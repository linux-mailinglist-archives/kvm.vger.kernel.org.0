Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227AC346923
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCWTdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230327AbhCWTdH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 15:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616527987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVjweup2vzSyW273usfznQT8Yb0z+TVjjvRS2WCC93M=;
        b=TXU9XgGmwZdDhoQiuID9wkYOcBX5ikdBHIv6m0wfpF+ZJHip3NTqfhaPhjpyR1YZ63WTaq
        uEz2LB5zAdMCSRmNeaUvUKS7mMa4yHtIu26YlyYoO4etIwUSd21cR8lfYgRs1FekZA8bTi
        YBL2p1Nx0XlmXO2lSBatfny7m6YCnhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-wj7nmj1vMBGfozz-QwGMPw-1; Tue, 23 Mar 2021 15:32:58 -0400
X-MC-Unique: wj7nmj1vMBGfozz-QwGMPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B73B107BEFA;
        Tue, 23 Mar 2021 19:32:56 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E027D60BE5;
        Tue, 23 Mar 2021 19:32:55 +0000 (UTC)
Date:   Tue, 23 Mar 2021 13:32:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vfio/type1: Batch page pinning
Message-ID: <20210323133254.33ed9161@omen.home.shazbot.org>
In-Reply-To: <20210219161305.36522-4-daniel.m.jordan@oracle.com>
References: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
        <20210219161305.36522-4-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Daniel,

I've found a bug in this patch that we need to fix.  The diff is a
little difficult to follow, so I'll discuss it in the resulting
function below...

(1) Imagine the user has passed a vaddr range that alternates pfnmaps
and pinned memory per page.


static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
                                  long npage, unsigned long *pfn_base,
                                  unsigned long limit, struct vfio_batch *batch)
{
        unsigned long pfn;
        struct mm_struct *mm = current->mm;
        long ret, pinned = 0, lock_acct = 0;
        bool rsvd;
        dma_addr_t iova = vaddr - dma->vaddr + dma->iova;

        /* This code path is only user initiated */
        if (!mm)
                return -ENODEV;

        if (batch->size) {
                /* Leftover pages in batch from an earlier call. */
                *pfn_base = page_to_pfn(batch->pages[batch->offset]);
                pfn = *pfn_base;
                rsvd = is_invalid_reserved_pfn(*pfn_base);

(4) We're called again and fill our local variables from the batch.  The
    batch only has one page, so we'll complete the inner loop below and refill.

(6) We're called again, batch->size is 1, but it was for a pfnmap, the pages
    array still contains the last pinned page, so we end up incorrectly using
    this pfn again for the next entry.

        } else {
                *pfn_base = 0;
        }

        while (npage) {
                if (!batch->size) {
                        /* Empty batch, so refill it. */
                        long req_pages = min_t(long, npage, batch->capacity);

                        ret = vaddr_get_pfns(mm, vaddr, req_pages, dma->prot,
                                             &pfn, batch->pages);
                        if (ret < 0)
                                goto unpin_out;

(2) Assume the 1st page is pfnmap, the 2nd is pinned memory

                        batch->size = ret;
                        batch->offset = 0;

                        if (!*pfn_base) {
                                *pfn_base = pfn;
                                rsvd = is_invalid_reserved_pfn(*pfn_base);
                        }
                }

                /*
                 * pfn is preset for the first iteration of this inner loop and
                 * updated at the end to handle a VM_PFNMAP pfn.  In that case,
                 * batch->pages isn't valid (there's no struct page), so allow
                 * batch->pages to be touched only when there's more than one
                 * pfn to check, which guarantees the pfns are from a
                 * !VM_PFNMAP vma.
                 */
                while (true) {
                        if (pfn != *pfn_base + pinned ||
                            rsvd != is_invalid_reserved_pfn(pfn))
                                goto out;

(3) On the 2nd page, both tests are probably true here, so we take this goto,
    leaving the batch with the next page.

(5) Now we've refilled batch, but the next page is pfnmap, so likely both of the
    above tests are true... but this is a pfnmap'ing!

(7) Do we add something like if (batch->size == 1 && !batch->offset) {
    put_pfn(pfn, dma->prot); batch->size = 0; }?

                        /*
                         * Reserved pages aren't counted against the user,
                         * externally pinned pages are already counted against
                         * the user.
                         */
                        if (!rsvd && !vfio_find_vpfn(dma, iova)) {
                                if (!dma->lock_cap &&
                                    mm->locked_vm + lock_acct + 1 > limit) {
                                        pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
                                                __func__, limit << PAGE_SHIFT);
                                        ret = -ENOMEM;
                                        goto unpin_out;
                                }
                                lock_acct++;
                        }

                        pinned++;
                        npage--;
                        vaddr += PAGE_SIZE;
                        iova += PAGE_SIZE;
                        batch->offset++;
                        batch->size--;

                        if (!batch->size)
                                break;

                        pfn = page_to_pfn(batch->pages[batch->offset]);
                }

                if (unlikely(disable_hugepages))
                        break;
        }

out:
        ret = vfio_lock_acct(dma, lock_acct, false);

unpin_out:
        if (ret < 0) {
                if (pinned && !rsvd) {
                        for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
                                put_pfn(pfn, dma->prot);
                }
                vfio_batch_unpin(batch, dma);

(8) These calls to batch_unpin are rather precarious as well, any time batch->size is
    non-zero, we risk using the pages array for a pfnmap.  We might actually want the
    above change in (7) moved into this exit path so that we can never return a potential
    pfnmap batch.

                return ret;
        }

        return pinned;
}

This is a regression that not only causes incorrect mapping for the
user, but also allows the user to trigger bad page counts, so we need
a fix for v5.12.  Thanks,

Alex

