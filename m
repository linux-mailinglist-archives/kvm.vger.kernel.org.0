Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C102B692E
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgKQP6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:58:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgKQP6K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605628688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+MNEbtxb1mBnxWzPd8NLCF+8mtv5J2PVYOZ6pmIeLJo=;
        b=hXI6hFOaLN1y2PIlRvlpHKh3ELjvU2b4g9Nw/SQRGQ+6k2iu8Q1YytIAZL6WZif8MLomnQ
        Y+/AfknqQnQAhPliWP6yIJOgVvpEcZMMMy2Gsovv6N32rySyw9RPs2IAntJSNXKfmh+Xue
        yfZu1+vSxr80GEtAZB0j8EVG+hKKjKc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-J_MVi4wOPO-ff3zY4vx9KQ-1; Tue, 17 Nov 2020 10:58:00 -0500
X-MC-Unique: J_MVi4wOPO-ff3zY4vx9KQ-1
Received: by mail-qv1-f70.google.com with SMTP id 60so6751480qvb.15
        for <kvm@vger.kernel.org>; Tue, 17 Nov 2020 07:58:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+MNEbtxb1mBnxWzPd8NLCF+8mtv5J2PVYOZ6pmIeLJo=;
        b=inZNMpaPvX4z+z//lGlc9qN2ib9js+Z1Q7Qrmsp0czRM93uw5ysJVP2iIBuZ+bMuMx
         QO1CPykGc1cw0HRmDDh3TYix9VkftoBR+YKbBSwRWG5INKofnP2KXMqqCtCXko5B1zcH
         K1NcYBFujnKHJpCM4+BXxCHzAdG4iMXSAtgA3f6jV4mvGzH2X/2zGbNkrsLkYC+8sxcU
         gSkfKxLn+QmJQNUBV9oFsLV+y6E62VoItstVA78ubbW3mu+O8OogXGja1GzSO6I/6T6m
         Fm1QFlYFOH+UmI2QpRO9bxf3SdxzwcWeuemFr7UIbPFyeprKxG+78r+mkS1TM1orJ1cS
         PtLQ==
X-Gm-Message-State: AOAM530zXczgnrjBAhC90cZLFgn7vP2m4j8rlIFxricq6nDol+Z0Whu2
        9eDF3tbJDx4460qEycuLju5WkhQJnj2NWngia1HQM8AgcqFJ7BrcGAD8WKO5Jtss30qdtm7D7cR
        Ez/kvtdheiKpM
X-Received: by 2002:a0c:ab8f:: with SMTP id j15mr19488663qvb.54.1605628680125;
        Tue, 17 Nov 2020 07:58:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxa/gAj/nmWfkvRTdCq6/6b5MY5+CthY8O+RdjdQdq0JMIfNuiPa7O0IJlGGz0rsfz5LiWw2g==
X-Received: by 2002:a0c:ab8f:: with SMTP id j15mr19488638qvb.54.1605628679911;
        Tue, 17 Nov 2020 07:57:59 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id c9sm4783214qkm.116.2020.11.17.07.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 07:57:59 -0800 (PST)
Date:   Tue, 17 Nov 2020 10:57:57 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201117155757.GA13873@xz-x1>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1>
 <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 17, 2020 at 09:33:17AM -0600, Tom Lendacky wrote:
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

Thanks for the explanations.

It seems fine if two dimentional page table is used in kvm, as long as the 1st
level guest page table is handled the same way as in the host.

I'm thinking what if shadow page table is used - IIUC here the vfio mmio region
will be the same as normal guest RAM from kvm memslot pov, however if the mmio
region is not encrypted, does it also mean that the whole guest RAM is not
encrypted too?  It's a pure question because I feel like these are two layers
of security (host as the 1st, guest as the 2nd), maybe here we're only talking
about host security rather than the guests, then it looks fine too.

-- 
Peter Xu

