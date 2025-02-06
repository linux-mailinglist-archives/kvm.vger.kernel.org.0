Return-Path: <kvm+bounces-37533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB4BA2B2D8
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 21:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B0953A6B00
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4C21C68BE;
	Thu,  6 Feb 2025 20:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bh+NPnXb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862C1A76AE
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872200; cv=none; b=J2wHzQTLf/iGdNh591LuncK3Kz4lW/0LlbxeMpe/w+Cx1+NqZ8jegSx5oL1M/wu2sS2vuUTu1ebdvpvGJV27g/Oqw0XKNoyUrqeJEdhK0WmK47/KNeDQbw37xhJL+Ob5m5XwU5xKQxYlK5AovSAoQKpfaiPN3YuMw4SxRfzjRtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872200; c=relaxed/simple;
	bh=J4B4YWZsJNU1bHTLTpeWud/Q3aV5XgCDbqu/kHeyO+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBwDD2G2jTpiLnAJwGJcq7C/eFn1/0467/PdlFfY5l3Iukh5vWkuMPj9n4TRHaYK3iMSYmwqTzSt+/iB4C1bZ67C3Sbr5M79ypbECTgoLDPpEREVLJc47K2sN3bFMe+mTTz1rHp6gKpt3t8EppPMLiM9iavnqyehong/BmmLsgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bh+NPnXb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738872196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DKqGPfhuKIGtj4Hghs+eXC5K6q9Go7OMpG2M9IoV/XY=;
	b=bh+NPnXbYNbF9aVZ0RAkyoxtq3W9YMcc38iqYKjlmbXHZweI0ui+rS7asBWMX93QC5kJE+
	4teG5gXLmIneJ9LPnDHfGKXnwHR8Jfzf+A6GisOQCHvpkJNx1wHvfGxeTTFmq/byrcv0q/
	GbcaoxI1QwV63oiHESnMrVieORFgro0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-N97_vtYwOfSWDlxEVHdSDQ-1; Thu, 06 Feb 2025 15:03:14 -0500
X-MC-Unique: N97_vtYwOfSWDlxEVHdSDQ-1
X-Mimecast-MFC-AGG-ID: N97_vtYwOfSWDlxEVHdSDQ
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-46fa764f79cso24611661cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 12:03:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738872194; x=1739476994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKqGPfhuKIGtj4Hghs+eXC5K6q9Go7OMpG2M9IoV/XY=;
        b=mdq8pPi1/9PjhgfOYgKwoCeS9d73WdcG66eVmR+T0pIc2TyHrm8ROnduF960LktPS+
         gCCPGRMWsNvJVSKCIzrqT95nsMHLeo7ZzdJOIB5XSwyBRQDMiCVInVfu8cDOw2wYchD6
         pBcveTm/SNi6uy1BHxo0XSGEMw4yfNLS1/0iFfNFfB6A3FMsVfXBqICTxvWfhPksosaG
         rZBQkcy6va34BahoCOOfJoI5ZDgdv/Gw40JSLknhY8NBnQvuZ5YuKUfi9WpzRAlGUqoU
         srj5+uXVdGe6O8raQ7JIBYby2dyFu/nrlgCwxhjUs+iSpi6v/AeNNdsTiQYqryGy6IL4
         qS3w==
X-Forwarded-Encrypted: i=1; AJvYcCVm0YOXY1qeZ6ZmcZyMDTemU8JfexmwSi8BADuIuvElpiio5ylBTTRHtQLeDaDfiCdg8AE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKA1yPSzDHSOJvbQv5LY744ATp3PHXt+HJds4bSNhREA9CijWF
	LOmiL1/KMNEAlfvoOH7CwzaCToGITnQ3tON+wPyMVv1lmmb/bkA/UaKeJLb1izqIVS4FFO/6Y++
	vcfLWnnNC50ZTqGRyCifrcw+qy6XgzSHg+H0ZTbK892ue2ljafQ==
X-Gm-Gg: ASbGncu8S1rvCFi6bh2PYIh7MD4o40Rv30r8x8Vq8SWQSdpRTkxGtCCHvZJL/O0elWS
	bgf+6+h0+r3qcQHCTIMlKDgr7MxDHP03c3pARLOZ7q0EpM1HNqoDLP6LBe4mycdIrkh+BegulYs
	PBCwl7DGFBePRFRtDv6DJOreCSrdsH09RQIaMM0yxRsCex0gUkfZ9WpnysKporzpOqV1bKRdAJk
	dcYSHF8WpIppgerNE2TSDgu199E39xGizdeiV+WNDtkoOE6kObnfBEUEs+7cv1Ly/PebIAFup9P
	SLYG6LEA6TmRcdNLT1c6cNYUZasLbipGYDHUGJDm7XTrleI8
X-Received: by 2002:a05:622a:256:b0:467:7109:c783 with SMTP id d75a77b69052e-4716798aeedmr9263621cf.3.1738872194002;
        Thu, 06 Feb 2025 12:03:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IENmMKXdalwsDefa/7t7DHwVYizdH9C6eqbzxx/dcYYf6qBnHuQPjPtuYUdoaY4dulor+h2mg==
X-Received: by 2002:a05:622a:256:b0:467:7109:c783 with SMTP id d75a77b69052e-4716798aeedmr9262931cf.3.1738872193467;
        Thu, 06 Feb 2025 12:03:13 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47153beaa5csm8459611cf.68.2025.02.06.12.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 12:03:12 -0800 (PST)
Date: Thu, 6 Feb 2025 15:03:10 -0500
From: Peter Xu <peterx@redhat.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z6UVfrllv-Ahex73@x1.local>
References: <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
 <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>
 <Z5Jylb73kDJ6HTEZ@x1n>
 <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050>
 <Z5O4BSCjlhhu4rrw@x1n>
 <Z5WtRYSf7cjqITXH@yilunxu-OptiPlex-7050>
 <Z5uom-NTtekV9Crd@x1.local>
 <Z6SRxV83I9/kamop@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z6SRxV83I9/kamop@yilunxu-OptiPlex-7050>

On Thu, Feb 06, 2025 at 06:41:09PM +0800, Xu Yilun wrote:
> On Thu, Jan 30, 2025 at 11:28:11AM -0500, Peter Xu wrote:
> > On Sun, Jan 26, 2025 at 11:34:29AM +0800, Xu Yilun wrote:
> > > > Definitely not suggesting to install an invalid pointer anywhere.  The
> > > > mapped pointer will still be valid for gmem for example, but the fault
> > > > isn't.  We need to differenciate two things (1) virtual address mapping,
> > > > then (2) permission and accesses on the folios / pages of the mapping.
> > > > Here I think it's okay if the host pointer is correctly mapped.
> > > > 
> > > > For your private MMIO use case, my question is if there's no host pointer
> > > > to be mapped anyway, then what's the benefit to make the MR to be ram=on?
> > > > Can we simply make it a normal IO memory region?  The only benefit of a
> > > 
> > > The guest access to normal IO memory region would be emulated by QEMU,
> > > while private assigned MMIO requires guest direct access via Secure EPT.
> > > 
> > > Seems the existing code doesn't support guest direct access if
> > > mr->ram == false:
> > 
> > Ah it's about this, ok.
> > 
> > I am not sure what's the best approach, but IMHO it's still better we stick
> > with host pointer always available when ram=on.  OTOH, VFIO private regions
> > may be able to provide a special mark somewhere, just like when romd_mode
> > was done previously as below (qemu 235e8982ad39), so that KVM should still
> > apply these MRs even if they're not RAM.
> 
> Also good to me.
> 
> > 
> > > 
> > > static void kvm_set_phys_mem(KVMMemoryListener *kml,
> > >                              MemoryRegionSection *section, bool add)
> > > {
> > >     [...]
> > > 
> > >     if (!memory_region_is_ram(mr)) {
> > >         if (writable || !kvm_readonly_mem_allowed) {
> > >             return;
> > >         } else if (!mr->romd_mode) {
> > >             /* If the memory device is not in romd_mode, then we actually want
> > >              * to remove the kvm memory slot so all accesses will trap. */
> > >             add = false;
> > >         }
> > >     }
> > > 
> > >     [...]
> > > 
> > >     /* register the new slot */
> > >     do {
> > > 
> > >         [...]
> > > 
> > >         err = kvm_set_user_memory_region(kml, mem, true);
> > >     }
> > > }
> > > 
> > > > ram=on MR is, IMHO, being able to be accessed as RAM-like.  If there's no
> > > > host pointer at all, I don't yet understand how that helps private MMIO
> > > > from working.
> > > 
> > > I expect private MMIO not accessible from host, but accessible from
> > > guest so has kvm_userspace_memory_region2 set. That means the resolving
> > > of its PFN during EPT fault cannot depends on host pointer.
> > > 
> > > https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.com/
> > 
> > I'll leave this to KVM experts, but I actually didn't follow exactly on why
> > mmu notifier is an issue to make , as I thought that was per-mm anyway, and KVM
> > should logically be able to skip all VFIO private MMIO regions if affected.
> 
> I think this creates logical inconsistency. You builds the private MMIO
> EPT mapping on fault based on the HVA<->HPA mapping, but doesn't follow
> the HVA<->HPA mapping change. Why KVM believes the mapping on fault time
> but doesn't on mmu notify time?

IMHO as long as kvm knows it's a private MMIO and there's no mapping under
it guaranteed, then KVM can safely skip those ranges to speedup the mmu
notifier.

Said that, I'm not suggesting to stick with hvas if there're better
alternatives.  It's only about the paragraph that confused me a bit.

> 
> > This is a comment to this part of your commit message:
> > 
> >         Rely on userspace mapping also means private MMIO mapping should
> >         follow userspace mapping change via mmu_notifier. This conflicts
> >         with the current design that mmu_notifier never impacts private
> >         mapping. It also makes no sense to support mmu_notifier just for
> >         private MMIO, private MMIO mapping should be fixed when CoCo-VM
> >         accepts the private MMIO, any following mapping change without
> >         guest permission should be invalid.
> > 
> > So I don't yet see a hard-no of reusing userspace mapping even if they're
> > not faultable as of now - what if they can be faultable in the future?  I
> 
> The first commit of guest_memfd emphasize a lot on the benifit of
> decoupling KVM mapping from host mapping. My understanding is even if
> guest memfd can be faultable later, KVM should still work in a way
> without userspace mapping.

I could have implied to suggest using hva, not my intention.  I agree
fd-based API is better too in this case at least as of now.

What I'm not sure is how the whole things evolve with either gmemfd or
device fd when they're used with shared and mappable pages.  We can leave
that for later discussion for sure.

> 
> > am not sure..
> > 
> > OTOH, I also don't think we need KVM_SET_USER_MEMORY_REGION3 anyway.. The
> > _REGION2 API is already smart enough to leave some reserved fields:
> > 
> > /* for KVM_SET_USER_MEMORY_REGION2 */
> > struct kvm_userspace_memory_region2 {
> > 	__u32 slot;
> > 	__u32 flags;
> > 	__u64 guest_phys_addr;
> > 	__u64 memory_size;
> > 	__u64 userspace_addr;
> > 	__u64 guest_memfd_offset;
> > 	__u32 guest_memfd;
> > 	__u32 pad1;
> > 	__u64 pad2[14];
> > };
> > 
> > I think we _could_ reuse some pad*?  Reusing guest_memfd field sounds error
> > prone to me.
> 
> It truly is. I'm expecting some suggestions here.

Maybe a generic fd+offset pair from pad*?  I'm not sure whether at some
point that could also support guest-memfd there too, after all it's easy
for kvm to check whatever file->f_op it's backing, so logically kvm should
allow backing a memslot with whatever file without HVA.  Just my 2 cents.

Thanks,

-- 
Peter Xu


