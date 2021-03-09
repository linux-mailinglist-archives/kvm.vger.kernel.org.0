Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3535533312E
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCIVn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:43:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232047AbhCIVnL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 16:43:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615326191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2htzCneNwn3ooAI3x79IJRPwnebgNq9nSCidB6cALU=;
        b=Ga0SbkKsJxwuEyYJBBrKGg4Q+1oP+JBbIISco1AF4Mr4RJU/gOa1SpqTG0juVtocCyE/1s
        ec642qgWHenpP0f4G4Xgm9FXfJT9v1aSbFhWv5wuVFWhGj60Uie8bVyDbHwBEQlBz6e60U
        yIE9hwzpR1EZ7+H3/SLmn43Q0/y2sfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-OwRs04BgN56lgP0jv_6V9g-1; Tue, 09 Mar 2021 16:43:09 -0500
X-MC-Unique: OwRs04BgN56lgP0jv_6V9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1075683DD24;
        Tue,  9 Mar 2021 21:43:07 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4B815D9DB;
        Tue,  9 Mar 2021 21:43:01 +0000 (UTC)
Date:   Tue, 9 Mar 2021 14:43:01 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
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
Message-ID: <20210309144301.3593af00@omen.home.shazbot.org>
In-Reply-To: <20210309210036.GJ763132@xz-x1>
References: <20210308132106.49da42e2@omen.home.shazbot.org>
        <20210308225626.GN397383@xz-x1>
        <6b98461600f74f2385b9096203fa3611@hisilicon.com>
        <20210309124609.GG2356281@nvidia.com>
        <20210309082951.75f0eb01@x1.home.shazbot.org>
        <20210309164004.GJ2356281@nvidia.com>
        <20210309184739.GD763132@xz-x1>
        <20210309122607.0b68fb9b@omen.home.shazbot.org>
        <20210309194824.GE763132@xz-x1>
        <20210309131104.1094b798@omen.home.shazbot.org>
        <20210309210036.GJ763132@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 16:00:36 -0500
Peter Xu <peterx@redhat.com> wrote:

> On Tue, Mar 09, 2021 at 01:11:04PM -0700, Alex Williamson wrote:
> > > It's just that the initial MMIO access delay would be spread to the 1st access
> > > of each mmio page access rather than using the previous pre-fault scheme.  I
> > > think an userspace cares the delay enough should pre-fault all pages anyway,
> > > but just raise this up.  Otherwise looks sane.  
> > 
> > Yep, this is a concern.  Is it safe to have loops concurrently and fully
> > populating the same vma with vmf_insert_pfn()?  
> 
> AFAIU it's safe, and probably the (so far) best way for an userspace to quickly
> populate a huge chunk of mmap()ed region for either MMIO or RAM.  Indeed from
> that pov vmf_insert_pfn() seems to be even more efficient on prefaulting since
> it can be threaded.

Ok, then we'll keep the loop and expect that a race might incur
duplicate work, but should be safe.

It also occurred to me that Jason was suggesting the _prot version of
vmf_insert_pfn(), which I think is necessary if we want to keep the
same semantics where the default io_remap_pfn_range() was applying
pgprot_decrypted() onto vma->vm_page_prot.  So if we don't want to
break SME use cases we better apply that ourselves.  Thanks,

Alex

