Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4492B6924
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgKQPyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:54:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbgKQPyv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:54:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605628490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqZSXKUY2P7ZrgpFgcIRmxwnMRpI7PgrQSmr9FjWruI=;
        b=POut5Bhgxju/BHDTUDYOpoxwWAVFXwabfT0irJPrR65MITjSyAJt70a0b/QB3mclLYRJVS
        W+a7tPY5mtzTocw/UcoPuCXZiFYTNiupWRzXtAojliPSjCT6TrgTZiQU7x8oCQ+XwQF3KL
        /IjlMYNVOQTXpRKRPCzbaz2q7MCZlX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-PZ-227UCP9uE27-bb_d4_Q-1; Tue, 17 Nov 2020 10:54:48 -0500
X-MC-Unique: PZ-227UCP9uE27-bb_d4_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC2A519080A2;
        Tue, 17 Nov 2020 15:54:47 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C03416EF49;
        Tue, 17 Nov 2020 15:54:43 +0000 (UTC)
Date:   Tue, 17 Nov 2020 08:54:43 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201117085443.2c183078@w520.home>
In-Reply-To: <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
        <20201105233949.GA138364@xz-x1>
        <20201116155341.GL917484@nvidia.com>
        <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
        <20201116232033.GR917484@nvidia.com>
        <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 09:33:17 -0600
Tom Lendacky <thomas.lendacky@amd.com> wrote:

> On 11/16/20 5:20 PM, Jason Gunthorpe wrote:
> > On Mon, Nov 16, 2020 at 03:43:53PM -0600, Tom Lendacky wrote:  
> >> On 11/16/20 9:53 AM, Jason Gunthorpe wrote:  
> >>> On Thu, Nov 05, 2020 at 06:39:49PM -0500, Peter Xu wrote:  
> >>>> On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:  
> >>>>> Tom says VFIO device assignment works OK with KVM, so I expect only things
> >>>>> like DPDK to be broken.  
> >>>>
> >>>> Is there more information on why the difference?  Thanks,  
> >>>
> >>> I have nothing, maybe Tom can explain how it works?  
> >>
> >> IIUC, the main differences would be along the lines of what is performing
> >> the mappings or who is performing the MMIO.
> >>
> >> For device passthrough using VFIO, the guest kernel is the one that ends
> >> up performing the MMIO in kernel space with the proper encryption mask
> >> (unencrypted).  
> > 
> > The question here is why does VF assignment work if the MMIO mapping
> > in the hypervisor is being marked encrypted.
> > 
> > It sounds like this means the page table in the hypervisor is ignored,
> > and it works because the VM's kernel marks the guest's page table as
> > non-encrypted?  
> 
> If I understand the VFIO code correctly, the MMIO area gets registered as
> a RAM memory region and added to the guest. This MMIO region is accessed
> in the guest through ioremap(), which creates an un-encrypted mapping,
> allowing the guest to read it properly. So I believe the mmap() call only
> provides the information used to register the memory region for guest
> access and is not directly accessed by Qemu (I don't believe the guest
> VMEXITs for the MMIO access, but I could be wrong).

Ideally it won't, but trapping through QEMU is a common debugging
technique and required if we implement virtualization quirks for a
device in QEMU.  So I believe what you're saying is that device
assignment on SEV probably works only when we're using direct mapping
of the mmap into the VM and tracing or quirks would currently see
encrypted data.  Has anyone had the opportunity to check that we don't
break device assignment to VMs with this patch?  Thanks,

Alex

