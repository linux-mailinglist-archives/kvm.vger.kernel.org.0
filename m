Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095A7332A74
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 16:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhCIPaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 10:30:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231901AbhCIPaD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 10:30:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615303803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jxpAuLrdI2KEsxNtc6yigl8rRFIzhCgLVMdHGZZ+fc=;
        b=MznqlhAtMuCwqnSh0Ny2LPlGZk21AwknMNrcnrELRXVZyboNxbPyRMYb7tY7lJm2Lohf1o
        zjdW3Yx6SEmDoD667u9HShgogaF0ScjCuLfnT94SVos72QUQvCqxYg7dIq27gfTeN+gzDS
        Z7WOJJErx0VjHJ/Dfzq/+q/gMkvCZaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-PMx_YHNmNgK-G03W2rIzkA-1; Tue, 09 Mar 2021 10:29:59 -0500
X-MC-Unique: PMx_YHNmNgK-G03W2rIzkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2509057;
        Tue,  9 Mar 2021 15:29:57 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 443A060CF0;
        Tue,  9 Mar 2021 15:29:52 +0000 (UTC)
Date:   Tue, 9 Mar 2021 08:29:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210309082951.75f0eb01@x1.home.shazbot.org>
In-Reply-To: <20210309124609.GG2356281@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
        <20210308132106.49da42e2@omen.home.shazbot.org>
        <20210308225626.GN397383@xz-x1>
        <6b98461600f74f2385b9096203fa3611@hisilicon.com>
        <20210309124609.GG2356281@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 08:46:09 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 09, 2021 at 03:49:09AM +0000, Zengtao (B) wrote:
> > Hi guys:
> > 
> > Thanks for the helpful comments, after rethinking the issue, I have proposed
> >  the following change: 
> > 1. follow_pte instead of follow_pfn.  
> 
> Still no on follow_pfn, you don't need it once you use vmf_insert_pfn

vmf_insert_pfn() only solves the BUG_ON, follow_pte() is being used
here to determine whether the translation is already present to avoid
both duplicate work in inserting the translation and allocating a
duplicate vma tracking structure.

> > 2. vmf_insert_pfn loops instead of io_remap_pfn_range
> > 3. proper undos when some call fails.
> > 4. keep the bigger lock range to avoid unessary pte install.   
> 
> Why do we need locks at all here?

For the vma tracking and testing whether the fault is already
populated.  Once we get rid of the vma list, maybe it makes sense to
only insert the faulting page rather than the entire vma, at which
point I think we'd have no reason to serialize.  Thanks,

Alex

