Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C9F6958BE
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBNF7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBNF7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:59:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BE061BC
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 21:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676354298;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QroTo7XZf3wgJm7/KonBsO/MCtU86JyA/gXwdq8Y+4o=;
        b=hCTPYY+Dpt0oEZxqDuvOGQCaYMCdyVeL5jq/MDtfU4jeGZksdgZ8+UbqJMGHKDLSO1ekMf
        jZCOfLa+8sxgNXNhxyM3/PXdA2Zj6+VWCPHZOyoik5vk/lk2e/Mt+81avHoW9bCEzqWUDz
        H75IBpCzyWfDIJSFOia9SL8t7OTSNqU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-fhLi7w2lPhSIOujo1IV_iQ-1; Tue, 14 Feb 2023 00:58:12 -0500
X-MC-Unique: fhLi7w2lPhSIOujo1IV_iQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD016101AA5F;
        Tue, 14 Feb 2023 05:58:10 +0000 (UTC)
Received: from [10.64.54.114] (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80A6551E5;
        Tue, 14 Feb 2023 05:58:02 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 00/12] Implement Eager Page Splitting for ARM.
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
References: <20230206165851.3106338-1-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <1a3afa6d-3478-31dd-6f34-52075875c2fa@redhat.com>
Date:   Tue, 14 Feb 2023 16:57:59 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 2/7/23 3:58 AM, Ricardo Koller wrote:
> Eager Page Splitting improves the performance of dirty-logging (used
> in live migrations) when guest memory is backed by huge-pages.  It's
> an optimization used in Google Cloud since 2016 on x86, and for the
> last couple of months on ARM.
> 
> Background and motivation
> =========================
> Dirty logging is typically used for live-migration iterative copying.
> KVM implements dirty-logging at the PAGE_SIZE granularity (will refer
> to 4K pages from now on).  It does it by faulting on write-protected
> 4K pages.  Therefore, enabling dirty-logging on a huge-page requires
> breaking it into 4K pages in the first place.  KVM does this breaking
> on fault, and because it's in the critical path it only maps the 4K
> page that faulted; every other 4K page is left unmapped.  This is not
> great for performance on ARM for a couple of reasons:
> 
> - Splitting on fault can halt vcpus for milliseconds in some
>    implementations. Splitting a block PTE requires using a broadcasted
>    TLB invalidation (TLBI) for every huge-page (due to the
>    break-before-make requirement). Note that x86 doesn't need this. We
>    observed some implementations that take millliseconds to complete
>    broadcasted TLBIs when done in parallel from multiple vcpus.  And
>    that's exactly what happens when doing it on fault: multiple vcpus
>    fault at the same time triggering TLBIs in parallel.
> 
> - Read intensive guest workloads end up paying for dirty-logging.
>    Only mapping the faulting 4K page means that all the other pages
>    that were part of the huge-page will now be unmapped. The effect is
>    that any access, including reads, now has to fault.
> 
> Eager Page Splitting (on ARM)
> =============================
> Eager Page Splitting fixes the above two issues by eagerly splitting
> huge-pages when enabling dirty logging. The goal is to avoid doing it
> while faulting on write-protected pages. This is what the TDP MMU does
> for x86 [0], except that x86 does it for different reasons: to avoid
> grabbing the MMU lock on fault. Note that taking care of
> write-protection faults still requires grabbing the MMU lock on ARM,
> but not on x86 (with the fast_page_fault path).
> 
> An additional benefit of eagerly splitting huge-pages is that it can
> be done in a controlled way (e.g., via an IOCTL). This series provides
> two knobs for doing it, just like its x86 counterpart: when enabling
> dirty logging, and when using the KVM_CLEAR_DIRTY_LOG ioctl. The
> benefit of doing it on KVM_CLEAR_DIRTY_LOG is that this ioctl takes
> ranges, and not complete memslots like when enabling dirty logging.
> This means that the cost of splitting (mainly broadcasted TLBIs) can
> be throttled: split a range, wait for a bit, split another range, etc.
> The benefits of this approach were presented by Oliver Upton at KVM
> Forum 2022 [1].
> 

[...]

Sorry for raising questions about the design lately. There are two operations
regarding the existing huge page mapping. Here, lets take PMD and PTE mapping
as an example for discussion: (a) The existing PMD mapping is split to contiguous
512 PTE mappings when all sub-pages are written in sequence and dirty logging has
been enabled (b) The contiguous 512 PTE mappings are combined to one PMD mapping
when dirty logging is disabled.

Before this series is applied, both (a) and (b) are handled by the page fault handler.
After this series is applied, (a) is handled in the ioctl handler while (b) is still
handled in the page fault handler. I'm not sure why we can't eagerly split the PMD
mapping into 512 PTE mapping in the page fault handler? In this way, the implementation
may be simplified by extending kvm_pgtable_stage2_map(). In the implementation, the
newly introduced API kvm_pgtable_stage2_split() calls to kvm_pgtable_stage2_create_unlinked()
and then stage2_map_walker(), which is part of kvm_pgtable_stage2_map(), to create the
unlinked page tables. It's why I have the question.

Thanks,
Gavin


