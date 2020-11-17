Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7EE2B6D11
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 19:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgKQSSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 13:18:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731253AbgKQSSH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 13:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605637079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y6q7ZcUkDpAwl9Mjvs8+shsquW4YH/qnPrBuABgSQqc=;
        b=EDH5p+ukZDWFbN6cfHz3ZuAgoBJf98rx1BLsvSm65cDpx1g/qbQWMixwViN2QcpBEozgDX
        A1ilQU3b9VWuPDSlmQbBe7AO0Ah/cyUVlBuI2iJpUldQdvndHIzGBIkNsbkpEXIBSGa7wA
        dT7w3DwJKeXA6HOEkyquqOvy3IYAVCA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-ElBa6VsmOxCKWIr9U9w_Ew-1; Tue, 17 Nov 2020 13:17:57 -0500
X-MC-Unique: ElBa6VsmOxCKWIr9U9w_Ew-1
Received: by mail-qt1-f197.google.com with SMTP id v9so12971688qtw.12
        for <kvm@vger.kernel.org>; Tue, 17 Nov 2020 10:17:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y6q7ZcUkDpAwl9Mjvs8+shsquW4YH/qnPrBuABgSQqc=;
        b=gKIKQafk9zLTZWRxWIHF0JV3QmkC51Ym8v3DmbLZu8ZFAVnQaok3frXzSV2G3WjOzk
         ev58oUTvGJlEaga1fd+GzgquPyTGvPYkr1YBpYZimLYn9q0JZeu6yhPWuDTEBcr2FfEE
         a9s2yUdOYIPfuIDY5U+0tR83GTecMMVDqisR5vuPe3G5SaHXYqFzhapgU87i6fyAjGLe
         3rIHWHplFnQZDOcfE61VLxjj90WmKvH/YFKaU5wcmHHEQhrRSy4TIKjKO565fzHZudxa
         x+Ud2K0Lm6tXahMD6KaxJkDKIWXJfT8E0Zer8ToZ6oKXu3ndrnRdIDclwajifFMHJ7TK
         p7pg==
X-Gm-Message-State: AOAM531uNHgvTwcdPjO/NgPnrJ8Zda0rgT1A31wSELnHVskYXrqfDWj7
        DP7Qv5b5LPqb/GyQo5ns2G32L75iOpOnmfuyPbOZL1br+FEf0eUN4lfdjOlvARyt/JsGvq3rrRF
        XgFfQhGzobckl
X-Received: by 2002:a37:6195:: with SMTP id v143mr812485qkb.71.1605637076969;
        Tue, 17 Nov 2020 10:17:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXfQ4S7zmbQ7XdFjkQc/tghtislLfC5uK1v4Bdgapd32qiaw84ySxd9kDRbWODecGm9z4ZLQ==
X-Received: by 2002:a37:6195:: with SMTP id v143mr812460qkb.71.1605637076619;
        Tue, 17 Nov 2020 10:17:56 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id j21sm14292613qtp.10.2020.11.17.10.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 10:17:55 -0800 (PST)
Date:   Tue, 17 Nov 2020 13:17:54 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201117181754.GC13873@xz-x1>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1>
 <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
 <20201117155757.GA13873@xz-x1>
 <57f51f08-1dec-e3d6-b636-71c8a00142fb@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <57f51f08-1dec-e3d6-b636-71c8a00142fb@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 17, 2020 at 10:34:37AM -0600, Tom Lendacky wrote:
> On 11/17/20 9:57 AM, Peter Xu wrote:
> > On Tue, Nov 17, 2020 at 09:33:17AM -0600, Tom Lendacky wrote:
> >> On 11/16/20 5:20 PM, Jason Gunthorpe wrote:
> >>> On Mon, Nov 16, 2020 at 03:43:53PM -0600, Tom Lendacky wrote:
> >>>> On 11/16/20 9:53 AM, Jason Gunthorpe wrote:
> >>>>> On Thu, Nov 05, 2020 at 06:39:49PM -0500, Peter Xu wrote:
> >>>>>> On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:
> >>>>>>> Tom says VFIO device assignment works OK with KVM, so I expect only things
> >>>>>>> like DPDK to be broken.
> >>>>>>
> >>>>>> Is there more information on why the difference?  Thanks,
> >>>>>
> >>>>> I have nothing, maybe Tom can explain how it works?
> >>>>
> >>>> IIUC, the main differences would be along the lines of what is performing
> >>>> the mappings or who is performing the MMIO.
> >>>>
> >>>> For device passthrough using VFIO, the guest kernel is the one that ends
> >>>> up performing the MMIO in kernel space with the proper encryption mask
> >>>> (unencrypted).
> >>>
> >>> The question here is why does VF assignment work if the MMIO mapping
> >>> in the hypervisor is being marked encrypted.
> >>>
> >>> It sounds like this means the page table in the hypervisor is ignored,
> >>> and it works because the VM's kernel marks the guest's page table as
> >>> non-encrypted?
> >>
> >> If I understand the VFIO code correctly, the MMIO area gets registered as
> >> a RAM memory region and added to the guest. This MMIO region is accessed
> >> in the guest through ioremap(), which creates an un-encrypted mapping,
> >> allowing the guest to read it properly. So I believe the mmap() call only
> >> provides the information used to register the memory region for guest
> >> access and is not directly accessed by Qemu (I don't believe the guest
> >> VMEXITs for the MMIO access, but I could be wrong).
> > 
> > Thanks for the explanations.
> > 
> > It seems fine if two dimentional page table is used in kvm, as long as the 1st
> > level guest page table is handled the same way as in the host.
> > 
> > I'm thinking what if shadow page table is used - IIUC here the vfio mmio region
> > will be the same as normal guest RAM from kvm memslot pov, however if the mmio
> > region is not encrypted, does it also mean that the whole guest RAM is not
> > encrypted too?  It's a pure question because I feel like these are two layers
> > of security (host as the 1st, guest as the 2nd), maybe here we're only talking
> > about host security rather than the guests, then it looks fine too.
> 
> SEV is only supported with NPT (TDP).

I see, thanks for answering (even if my question was kind of out-of-topic..).

Regarding this patch, my current understanding is that the VM case worked only
because the guests in the previous tests were always using kvm directly mapped
MMIO accesses.  However that should not be always guaranteed because qemu
should be in complete control of that (e.g., qemu can switch to user-exit for
all mmio accesses for a vfio-pci device anytime without guest's awareness).

Logically this patch should fix that, just like the dpdk scenario where mmio
regions were accessed from userspace (qemu).  From that pov, I think this patch
should help.

Acked-by: Peter Xu <peterx@redhat.com>

Though if my above understanding is correct, it would be nice to mention some
of above information in the commit messages too, though may not worth a repost.

Tests will always be welcomed as suggested by Alex, of course.

Thanks,

-- 
Peter Xu

