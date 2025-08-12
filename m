Return-Path: <kvm+bounces-54547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BCBCB238E3
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 21:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EAA4687E52
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A708F2DCF46;
	Tue, 12 Aug 2025 19:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkdL65jH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42674217F35
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026814; cv=none; b=sqQXhGiNwwYnahQ+8+1eInEDhJUiBoTP0gy4XQRSmTtGRmqMocctGWHaUW5LF7HgtT1KhWtLxsOn4pgciqWwCSB/Jyzh3BGamGBYFINw2NRP5xbkanMPyQlg1sOHBIm+M3V/4n4n3a8yubIJxTS0lG815Gt77bahgPXtixcgR1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026814; c=relaxed/simple;
	bh=3ejSlU3f5/VXH8fWmlEhacx2qPrFoTB/HewbgoGTbOM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QeIkiC566y0sUXuKenGcS/LmukqebsISQ2MeB+8u6v5J7RpajvyxCBcnIQtzTSCvglH12m58pPKwEGtUeNUVgr+Octn2JMF1jXQz25LTBaWKbuklyglaqMwBW7VQ4i4fxk6LQJLt/yuI5QhVkf/EM6wCDIhTUgoTP2gJ08yEpes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CkdL65jH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755026811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A7wSAXOflfxcfVTvNNIgGBJrfUWItDsVVCEicsr2v1A=;
	b=CkdL65jH15o3S/Hp2xexB+0vQL6IF2ermYOdF3pkjNqbRBZP+OOrB2YuiK4GW9nQJbOZCq
	xaQj9AhwHLozy4nQdLdRqUVhu49P/0SOdS+pf1NMyPb1YxIdjiIzY9SRHcSmjAhWyb34qP
	IX/RtXFbHx/0n5Q34lqZxwjMoPJb0tU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-Fp5yPjPDMqWBhA87QFTnsw-1; Tue, 12 Aug 2025 15:26:49 -0400
X-MC-Unique: Fp5yPjPDMqWBhA87QFTnsw-1
X-Mimecast-MFC-AGG-ID: Fp5yPjPDMqWBhA87QFTnsw_1755026809
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e51241f25eso9221135ab.3
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 12:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755026809; x=1755631609;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A7wSAXOflfxcfVTvNNIgGBJrfUWItDsVVCEicsr2v1A=;
        b=XREx9OrIkgEozmunY40YAzCe3oPRg34EoI/aDcmjZNHTwiojt8HVAzGxgPlXU+o85d
         fM0ND6rVECPFdjm+Yqf9gemI1YDyhUBfjiW21aiiX4U0fP7s8OQE23Sfgwha5MEjOyKA
         LbQQMcpJUFc9oUbh/uvzC1NJAgKKplGst4Fb/JgnURwgorFH5YLYi1mXctw5aQwa0pqv
         ORVf+HynwyAVfg+NuJz0vZ4NSWtHCaDj0FNSv7XS0yO4MOv6oDA+XVBQTUKO4Lar0tXi
         ZIKlgIipyTIFNmv6hoFb4cb3nU+9wVXP6ZSzPIrl0xGi6KOkYLeDtK0MJpWAAH9Xi6fV
         m1tQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEsyhoFT09lsSPomLrXQWjp9Ii78DwFQQ+/hRaDMX+q8X86fzFedjKC3XM/pw5nVW7NkU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRLY5atYrA0I/GxqQ3TFd8LjkoGG6W4eF3qV4KCZCyTjCDo2FE
	dAITJIfI3CEfXJsobKeDJNqMO/2QNN6rE3Qo+uXPBziUipQIIhTvFUDejnux/xgtTJlyjr+TrrA
	5oq9lm/gNWVG95QJzVhbppeAHjeXxAN0NdkhDGQsQX28g2urIrZBKiw==
X-Gm-Gg: ASbGncvwy0OMd9824am1xxny8ojisvw1FqXROOwBXFXCvIoFSMn2AGxItpAE/o4PpXB
	KadyVUflAlE1oxlSloMeCTuxIv5DMAmzaPHAC3e3aIS59lLRnjr4clyLkmInRL2ZAxntyW7oKvG
	kLKx4rZNBv7VnClVOGe7QU3mmhLPDgCvP3nQ10cSUv5UGSQbBIkYd9bFLZoJlDURiUXZJcqf9zx
	omNWxDt/TTkwc27JmBSnD7bS625TvVvfBGK2L5ldM4RTIZLpItbF0sdUZkeLqB7fNiRMkNzTmhW
	BB6ErNrpwxJDfIHWB2F6R8z2IxCYsHXx8IK+0WJdDFo=
X-Received: by 2002:a05:6e02:1947:b0:3e5:2c5e:e6ce with SMTP id e9e14a558f8ab-3e5672932cemr1975405ab.0.1755026808428;
        Tue, 12 Aug 2025 12:26:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOKAUnRuVSW9wz+JqrZQHNj/4wdqIYJWdnLcZKhTdAZQUdsQn+R43DfCzsiRIeoCiy4GGj0A==
X-Received: by 2002:a05:6e02:1947:b0:3e5:2c5e:e6ce with SMTP id e9e14a558f8ab-3e5672932cemr1975065ab.0.1755026807620;
        Tue, 12 Aug 2025 12:26:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae997b3acsm3320381173.13.2025.08.12.12.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 12:26:46 -0700 (PDT)
Date: Tue, 12 Aug 2025 13:26:42 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "Kumar, Praveen" <pravkmr@amazon.de>, "Adam,
 Mahmoud" <mngyadam@amazon.de>, "Woodhouse, David" <dwmw@amazon.co.uk>,
 "nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250812132642.634b542d.alex.williamson@redhat.com>
In-Reply-To: <20250812003053.GA599331@ziepe.ca>
References: <lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805130046.0527d0c7.alex.williamson@redhat.com>
	<80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	<20250806115224.GB377696@ziepe.ca>
	<cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
	<20250807130605.644ac9f6.alex.williamson@redhat.com>
	<20250811155558.GF377696@ziepe.ca>
	<20250811160710.174ca708.alex.williamson@redhat.com>
	<20250812003053.GA599331@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Aug 2025 21:30:53 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, Aug 11, 2025 at 04:07:10PM -0600, Alex Williamson wrote:
> > We do this today with device specific regions, see
> > vfio_pci_core_register_dev_region().  We use this to provide several
> > additional regions for IGD.  If we had an interface for users to
> > trigger new regions we'd need some protection for exceeding the index
> > space (-ENOSPC), but adding a small number of regions is not a problem.  
> 
> That is pretty incomplete..
> 
> If we go down the maple tree direction I expect to eliminate
> vfio_pci_core_register_dev_region() and replace it with core code
> handling the dispatch of mmap and rw through the struct vfio_mmap.

Do note the inconsistency of having a vfio_mmap object that's used for
read/write.

> What it is now isn't locked properly to be dynamic, and it's operation
> is different from the actual physical regions. 

Of course it's not locked to be used dynamically now, it's not used
dynamically now.

> > > > > Well, we want to be able to WC map. Introducing "more cookies"
> > > > > again is just one way to get there. How do you create those
> > > > > cookies ? Upon request or each region automatically gets multiple
> > > > > with different attributes ? Do they represent entire regions or
> > > > > subsets ? etc...     
> > > 
> > > It doesn't matter. Fixing how mmap works internally lets you use all
> > > of those options.  
> > 
> > What exactly is the "fix how mmap works internally" proposal?  
> 
> I explained it to Mahmoud previously:
> https://lore.kernel.org/kvm/20250716184028.GA2177603@ziepe.ca/

Ok, I think you're just referring to a mechanism by which we use the
pgoff to get an object that tracks the mmap attributes.

> > > I don't think we need sub-regions, it is too complicated in the kernel
> > > and pretty much useless.  
> > 
> > So we infer that mmap cookies are an alias to an entire region.  
> 
> Ideally
> 
> > We have an existing ABI that maps BARs, config space, and VGA spaces to
> > fixed region indexes.  That "region index" to "device space" mapping
> > cannot change, but the offset of a given region and the total number of
> > regions is not ABI.   
> 
> Yes.
> 
> > Therefore we can introduce an API where a user
> > says "give me a new region index that aliases region 0 with mmap
> > attribute FOO".    
> 
> I know, but I really dislike this as a uAPI. It becomes confusing for
> the user to get a list of, what should be, physical regions and now
> suddenly has to deal with non-physial alias regions it may have
> created.

This is subjective though.  Personally I find it confusing to have this
fixation that BAR0 is _only_ accessed through region index 0.

> Our uAPI has a simple input to describe the region:
> 
>  	__u32	region_index;
> 
> Which I think should always describe the physical uAPI region number
> and never something else. Drivers like igd have more "physical"
> regions, but they are still ultimately physical regions decided by the
> kernel, set in a fixed list.

This is not entirely true.  When we expanded to device specific regions
for IGD we changed the API.  We defined that there are no static region
numbers after VGA.  Device specific regions, such as those used by IGD,
provide introspection via a capability exposed in the REGION_INFO
return buffer.  Therefore there is no implicit meaning of a given
region number after VGA_REGION_INDEX.  It is only the implementation of
those IGD regions that present them in a fixed order, the ABI does not
require it.
 
> The region_index is effectively uAPI with things like 0 always being
> BAR 0 of a PCI function.
> 
> I don't think we should be changing that property..

The vfio-pci uAPI maps region numbers up through VGA_REGION_INDEX to
specific device resources.  It does not in any way suggest that those
regions numbers exclusively map those device resources nor do higher
region numbers have any implicit mapping to other device resources.

Also note that fixed region indexes are really only a convention
provided by the vfio device type, ie. the "bus driver", for
convenience.  vfio-platform for instance has no such standard device
resources, aiui the userspace driver needs to implicitly understand the
region number to resource mapping.  If implemented today, we'd probably
include a capability in the region info buffer that describes the
region via a fdt compatibility ID or something.

> > To a limited extent we can provide this within fixed index/pgoff
> > implementation (not ABI) we use now, but AIUI we could use a maple tree
> > to block out ranges and get more dense packing of regions across the
> > device fd.  
> 
> It is not regions, the maple tree packs mmap cookies - the pgoff.
>
> Today we algorithmically derive pgoff from region_index in the kernel
> but this is not ABI and is exactly what I want to divorce here. pgoff
> goes through the maple tree to obtain the region index, not the other
> way around.

But it doesn't matter.  There is no requirement that a given region
index uniquely maps a given device resource and there is no implicit
definition of region numbers beyond VGA_REGION_INDEX for vfio-pci.
Whether we use high order bits of pgoff to index into an array or
lookup the pgoff in a maple tree, the result is we get an object that
describes the access.  The region index is yet another cookie for
userspace that has no implicit meaning in the generic vfio sense, but
has limited conventions for specific vfio device types.

> > I don't understand how this introduces so much complication to drivers
> > that, for example, BAR0 might be accessible through region index 0 for
> > legacy mappings and index 10 for modified mmap attributes.    
> 
> Because all the drivers assume the pgoff encoding:
> 
> int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
> {
> 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> 
> And index == region_index which is uAPI that defines the physical BAR:
> 
> 	if (!vdev->bar_mmap_supported[index])
> 		return -EINVAL;
> 
> So this all needs remapping logic if you want to make index dynamic.
> Yes you can abuse the vfio_pci_core_register_dev_region() to make
> alias regions and somehow provide ops or special cases to handle the
> aliases and probably make it work for PCI.
> 
> But I'm saying to just have to core handle it:
> 
> int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma, struct vfio_mmap *mmap)
> {
>    index = mmap->index;
> 
> The code is simpler and cleaner, it generalizes outside of PCI. No
> more open coding vm_pgoff shifting. We get nice things like pgoff
> packing, better 32 bit compatability, and a huge number of mmap
> cookies for whatever we need.

We're in agreement that we need to derive an object from a pgoff and
that will universally replace embedding the region index in the high
order bits of the pgoff.  However everything else here is just the
implementation of that returned object.  The object could easily have a
region field that maps to the uAPI region and a device region field
that maps to the physical resource.  Some objects have the same value
for these fields, some objects don't.  It's not fundamentally important.

> > Can you describe the driver scenario where having two different
> > mmap cookies for region index 0 makes things significantly easier for
> > drivers?  
> 
> Above

Unconvinced.

> > It seems like Ben's suggestion below of a call that modifies the mmap
> > attributes of an existing region is the least overall change to
> > existing drivers, though I'm not sure if that's what we should be
> > optimizing for.  
> 
> I agreee it is the least overall code change, but it is a bad uAPI
> design since it violates the principle that what pgoff points should
> behave consistently.

I think we could enforce ordering such that it does behave
consistently, but if simultaneous mappings to the same pgoff with
different attributes is important, it can't do that.

> > > > > The biggest advantage of that approach is that it completely
> > > > > precludes multiple conflicting mappings for a given region (at
> > > > > least within a given process, though it might be possible to
> > > > > extend it globally if we    
> > > 
> > > It doesn't. It just makes a messy uapi. At the time of mmap the vma
> > > would stil have to capture the attributes (no fault by fault!) into
> > > the VMA so we will see real users doing things like:
> > > 
> > >  set to wc(cookie)
> > >  mmap(cookie + XXX)
> > >  set to !wc(cookie)
> > >  mmap(cookie + YY)
> > > 
> > > And then if you try to debug this all our file/vma debug tools will
> > > just show cookie everywhere with no distinction that some VMAs are WC
> > > and some VMAs are !WC.
> > > 
> > > Basically, it fundamentally breaks how pgoff is supposed to work here
> > > by making its meaning unstable.  
> > 
> > We could require the mmap attribute is set before mmap and not changed
> > after, but yes, we don't get simultaneous mmaps with different
> > attributes without different cookies.  
> 
> Not allowing WC and !WC is fatal to any proposal, IMHO.
> 
> So as above, it is messy and poor to make the pgoff unstable, and it
> will be abused by userspace as I showed if that is the uAPI.

Ok, we can kill that idea.

> > > Indeed, that is required for most HW. mlx5 for example has BARs that
> > > mix WC and non WC access modes. There are too few BARs for most HW to
> > > be able to dedicate an entire BAR to WC only.  
> > 
> > So do we want to revisit whether an mmap attribute applies to a whole
> > region or only part of a region?    
> 
> So long as mmap() can take a slice out of a cookie I don't know of a
> functional reason to do more..

If we're creating a new region, the uAPI is simpler if it's an alias of
the whole region rather than specifying an offset and length.

> > > It would not be another region index. That is the whole point. It is
> > > another pgoff for an existing index.  
> > 
> > I think this is turning a region index into something it was not meant
> > to be.  
> 
> What do you mean? Region index is the uAPI we have to refer to a fixed
> physical part of the device.
> 
> Reallly, what makes more sense as userspace operations:
> 
> 'give me a WC mapping for region index 0 which is BAR 0'
> 
> 'Make a new region index for region index 0 which is bar 0 and then give me a mapping for region X"
> 
> The first is very logical, the second is pretty obfuscated.

Current situation: We already have an API that says give me a mapping
for region X.

Therefore a new operation that says "give me a new region index for
mapping index 0 with attribute FOO" is much more congruent to our
current API.

> > > This is broadly what I've proposed consistently since the beginning,
> > > adjusted for the various remarks since:
> > > 
> > > struct vfio_region_get_mmap {
> > > 	__u32	argsz;
> > > 	__u32	region_index; // only one, no aliases
> > > 	__u32   mmap_flags; // Set WC here
> > > 
> > > 	__aligned_u64 region_size;
> > > 	__aligned_u64 fd_offset;
> > > };
> > > 
> > > struct vfio_region_get_caps {
> > > 	__u32	argsz;
> > > 	__u32	region_index;
> > > 
> > > 	__u32	region_flags; // READ/WRITE/etc
> > > 	__aligned_u64 region_size;
> > > 	__u32	cap_offset;	/* Offset within info struct
> > > of first cap */ };
> > > 
> > > Alex, you pointed out that the parsing of the existing
> > > VFIO_DEVICE_GET_REGION_INFO has made it non-extendable. So the above
> > > two are creating a new extendable version that are replacements.  
> > 
> > Can you be more specific on this claim?   
> 
> I don't remember exactly. I think you said something about argsz isn't
> parsed right by the kernel so we can't make struct vfio_region_info
> any bigger to add something like mmap_flags in a backwards compatible
> way because the old kernel wouldn't check for 0 in the expanded
> structure.

Oh!  This was the proposal to use flags as an input value when we call
REGION_INFO.  Yeah, that's not possible.  But the above two new APIs
don't logically then follow as our only path forward though.

> > We are no longer creating static region indexes after the
> > introduction of device specific regions, but I don't see why we're
> > not using the mechanisms of the device specific region to create new
> > region indexes with new offsets that have specified mmap attributes
> > here.  
> 
> Well, because that is not my proposal.
> 
> My proposal is the above, where region_index only takes on values that
> the current uAPI defines and nothing more.

The vfio-pci uAPI only has conventions for a specific subset of the
region index space and already provides indexes beyond that space using
device specific regions with types defined within a capability buffer.

> The driver continues to use region_index for all its internal
> operations, like when PCI does this:
> 
> 	if (!vdev->bar_mmap_supported[index])
> 
> And we don't mess with that stuff at all. This is what I'm proposing,
> concretely.

This is just a matter of having a pgoff to object helper and the fact
that that provided object might have a BAR index reference, which is not
implicitly the region index.
 
> > I imagine a DEVICE_FEATURE that creates a new region, returning at
> > least the region index, DEVICE_INFO and REGION_INFO are updated to
> > describe the new region, ie.  mmap-only, new offset/cookie, likely a
> > capability embedded in the REGION_INFO to provide introspection that
> > this regions is an alias of another.  
> 
> And this is what you've been suggesting for a while, and I still
> continue to dislike it for the reasons given. :)

Likewise, I dislike the REGION_INFO2 proposal ;)

> > > To avoid the naming confusion we have a specific ioctl to get
> > > mmap'able access, and another one for the cap list. I guess this also
> > > gives access to read/write so maybe the name needs more bikeshedding.  
> > 
> > Largely duplicating REGION_INFO.  
> 
> As I said, we can't extend REGION_INFO so to make changes to it we
> need new functions.
> 
> > > There is still one index per physical object (ie BAR) in the uAPI.  
> > 
> > This is a non-requirement.  
> 
> Disagree!

Clearly this feeling is strong, I still don't understand why.  I don't
buy that it's confusing and the remaining arguments seem to be trivial
implementation choices.

> > > We get one cookie that describes the VMA behavior exactly and
> > > immutably.  
> > 
> > So does the above.  
> 
> Yes
>  
> > > The existing VFIO_DEVICE_GET_REGION_INFO is expressed in terms of the
> > > above two operations with mmap_flags = 0.  
> > 
> > Still more complicated that new region index and existing ioctls.  
> 
> I think it would simplify the drivers. Inside the drivers we can split
> the cap and mmap return paths into seperate function ops. Currently
> this is all open coded inside switch statements and it is pretty
> duplicitive.
> 
> > I see the device fd as segmented into regions.  The base set of regions
> > happen to have fixed definitions relative to device objects.  
> 
> I don't - the device fd is segmented in to pgoff spaces which are
> managed by "mmap cookies". Physical device regions map into many mmap
> cookies within the pgoff number space.
> 
> > Introducing mmap cookies as a new mapping to a region where we can have
> > N:1 cookies to region really seems unnecessarily complicated vs a 1:1
> > cookie to region space.  
> 
> Your version is creating a 1:N:1 mapping, which I think is more
> complicated. One physical region, N virtual regions, one pgoff.

No, the region index to pgoff is 1:1, REGION_INFO returns 1 offset per
region.  Therefore I think it's 1:N:N in this denotation vs I think you
want 1:1:N, but here you've referred to it as a _virtual_ region, which
is exactly what it is, there is no 1:1 requirement for physical regions
to virtual regions.

> > > If we later decide we need to solve the ARM multi-device issue then we
> > > can cleanly extend an additional start/len to vfio_region_get_mmap
> > > which can ensure mmaps cookies are disjoint. This is not subregions,
> > > or new regions, this is just a cookie with a restriction.  
> > 
> > No different if REGION_INFO supplies disjoint offset/length.  
> 
> We can't extend REGION_INFO so you'd have to create a new region index
> which is a slice of a physical index, further complicating the
> implementation :(

You argued previously we don't need slices of physical indexes, now
you're arguing that if we do need it the implementation is more
complicated.  Pick one.

> > > In terms of implementation once you do the maple tree work that
> > > Mahmoud started we end up with vfio_region_get_mmap allocating a
> > > struct vfio_mmap for each unique region_index/mmap_flags and returning
> > > it to userspace.  
> > 
> > And we get an entirely disjoint API from legacy vfio.  
> 
> I don't see how you can say that. Arguably it is closer to legacy
> VIFIO because we don't create new region_index's that are not defined
> in the uAPI header! Instead we add a single new ioctl.

DEVICE_INFO.num_regions defines the region space, not the vfio-pci
convention of low order region indexes.  The uAPI makes no claims that
num_regions is immutable and I very much see a path in line with our
uAPI where a user could invoke a DEVICE_FEATURE (or pick your own
IOCTL, but DEVICE_FEATURE is very extensible) to dynamically generate a
new region with specified mmap attributes, DEVICE_INFO.num_regions is
updated, the offset/mmap_cookie is obtained via REGION_INFO, along with
a capability in the return buffer allowing introspection.  New ioctls:
potentially zero.

> > Currently we have a struct vfio_pci_region stored in an array that we
> > dynamically resize for device specific regions and the offset is
> > determined statically from the array index.  We could easily specify an
> > offset and alias field on that object if we wanted to make the address
> > space more compact (without a maple tree) and facilitate multiple
> > regions referencing the same device resource.    
> 
> vfio_pci_region isn't shared outside PCI, so it doesn't improve the
> core/driver API. It isn't locked so it can't be changed dynmically.
> It is based on region index so we still have the pgoff shifting and
> poor pgoff untilization.

Obviously it would be great to remove barriers at the core rather than
just vfio-pci, and also obviously the current implementation doesn't
directly support these new features.  That doesn't mean there's not an
incremental path by which we adapt vfio_pci_region to support this and
come back to extend it with a maple tree, and again to push it into
vfio-core.  I think this is where BenH and I are confused by the
insistence to start with the maple tree rather than focusing on the API.

> > There are a lot of new APIs being proposed here in the name of this
> > idea that we shouldn't create new regions/sub-regions/alias-regions,
> > which ultimately seems like a non-issue to me.  Thanks,  
> 
> Two APIs, and the CAPS one is more for illustration - like if we had a
> time machine how could we have desinged this from day 0 to be
> extensible.
> 
> So I see add vfio_region_get_mmap or vfio_feature_create_region - same
> number of APIs. <shrug>

One works within the API, one tries to extend the API and impose
requirements that are not compelling to me.  Thanks,

Alex


