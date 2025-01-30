Return-Path: <kvm+bounces-36930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 561B1A231C6
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AB8E1888E2D
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9B01EE035;
	Thu, 30 Jan 2025 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HyW7NDVp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856D31EE001
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254500; cv=none; b=vD3alxCDBQLIzi1HF0uXfaha5TGsBzblWvyDEFDwLOmSO2t6ygd0BNkJSuME+MurR2DPO5lxRalwu5TqWcNrd3+46v8z6pBHBo0+czO2IP8b5dPnnjA7ES9mFV7GopEqEm/mpiC0EZkqOXNiktd6kNCdMouYtxXPUYiPb4470KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254500; c=relaxed/simple;
	bh=CMkdp8I5zM7mqQK9ydQYKacWg9fXAUWhlQfZVru31TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUwCYpFKZJnTdpjOBtde6I+lZUOzAJIUpsoLDUZ82zyTVVIn/Uv9XsuvrBj4sL+XmO3V7D21SJaqJeyIBI2q43sJHIBUQ9CoOtSZTaJPwhjeUZcmxqAW5w4n7yVPrQz+MABqs2d62xk1vYf3SSW44lEAgCmWKTBPRoLolLD1YSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HyW7NDVp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738254497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vXhPYxXivfpAUmoL63eWbkQQipXOPxccSSUSI/QcRPA=;
	b=HyW7NDVpqDarYZH84tfMPWjpqvVW0ni4ClpeN8koJ69jFxdMWpKs1kZmlrsYZjfOxPrpgH
	sO2GRkpGSlWZnbgwrIlMQqLCmIYh4Z4FjPylI0UslLv4qCcYvjr8zzr+BC8ubsNOqouDWQ
	htB729E2x98U7GpVg0sZCgKwfnFScbw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-E5cEq116Nkav2vx93Odz6Q-1; Thu, 30 Jan 2025 11:28:16 -0500
X-MC-Unique: E5cEq116Nkav2vx93Odz6Q-1
X-Mimecast-MFC-AGG-ID: E5cEq116Nkav2vx93Odz6Q
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e2378169a4so21864896d6.2
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 08:28:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738254495; x=1738859295;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXhPYxXivfpAUmoL63eWbkQQipXOPxccSSUSI/QcRPA=;
        b=YD9Cm4Ou9OgHmuYju+FNEjpoYC9OA9P/UxgrHFLmvq6xXTWCS+XRwEwuu4LBK2te2r
         rXavjxvo/z3qXU1LhPS4/Qdhtx660GiECr92uP8i1rjX5wuhT7/E/iGoLjUmqEHbEojL
         hSHBH0MNsGckAll3XxdIc0rmAQqAnPOeUT7A7Cl//pLSFu7dtgNaFGRgYULItnouWOAU
         9aRj/ZNQxM9uniSprBfhp2dp6O9S4gGQtt9CBUBsC9hXj1KQO/3GZJd6HuALmK2Cv8XQ
         3X7eEVsrRTnDNhtC2DXvzEqYyRVWPmh+0UClBkHQGlCwxc9tF0ibz9lcmROPJ/UkzC8y
         HSNw==
X-Forwarded-Encrypted: i=1; AJvYcCXRyXV66WGJRmGp3OGlelh1mN8QWB4lIennL9MbdKnDwnPo5ZUNEZDMExmwSBSHDLGyESc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+wm8vcAwAM4c9KhJqa4SlD/hlxyakur3fQbLqv5hICEkaA3PL
	0tzNe2rzZiQkDPR0jiMoXdEw53/qSoicEPmxGHFWUavlIl6/qT+csyIeN0FIEWHnqhuole5fT9q
	J1tNXBLM/g/+ILr/iuxgQx/oeQDEyUuIERl1v4o5C86sGOBSzVA==
X-Gm-Gg: ASbGnculc16TT/2x9MRe5/NJb2PidHGJrIQAEZnUX77w7nIFhrEpg3NhzntOTEVwijL
	Q+X1aPEE5soih8KdhmfQZ81PEGhu87euXvOJKYzLHjbzzJPVaYX4IXmzwQx97emP71DyAr2DhRN
	+dlM864T/KeI4gtl9pN/2BE5weefVQ6Kt+G7iG5KG/j2dzIVVfdh1/Ku/D7RUiNbY9ysVGTxukt
	Npe2Dn5R4u3ZO6PzY/7zPOavBZj6n6IQrWWarpxIy56xDjCtrRd2z48w53JxXsSx9jQisl0pxYq
	wXQ/iWooyda95UiI5BicEqotE3jMNj9vHFfNtkKEgdBb1+t/
X-Received: by 2002:a05:6214:428f:b0:6e2:4940:400b with SMTP id 6a1803df08f44-6e249404305mr100836236d6.16.1738254495440;
        Thu, 30 Jan 2025 08:28:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHezdPdrcB465gv5HhXBH/dzV/lCJAFc7ts3XsdTfdwi+8v24sDD4NLRKI5jZWu3JiarcHE6Q==
X-Received: by 2002:a05:6214:428f:b0:6e2:4940:400b with SMTP id 6a1803df08f44-6e249404305mr100835876d6.16.1738254495132;
        Thu, 30 Jan 2025 08:28:15 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e2547f43f7sm7724526d6.9.2025.01.30.08.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2025 08:28:14 -0800 (PST)
Date: Thu, 30 Jan 2025 11:28:11 -0500
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
Message-ID: <Z5uom-NTtekV9Crd@x1.local>
References: <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
 <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>
 <Z5Jylb73kDJ6HTEZ@x1n>
 <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050>
 <Z5O4BSCjlhhu4rrw@x1n>
 <Z5WtRYSf7cjqITXH@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5WtRYSf7cjqITXH@yilunxu-OptiPlex-7050>

On Sun, Jan 26, 2025 at 11:34:29AM +0800, Xu Yilun wrote:
> > Definitely not suggesting to install an invalid pointer anywhere.  The
> > mapped pointer will still be valid for gmem for example, but the fault
> > isn't.  We need to differenciate two things (1) virtual address mapping,
> > then (2) permission and accesses on the folios / pages of the mapping.
> > Here I think it's okay if the host pointer is correctly mapped.
> > 
> > For your private MMIO use case, my question is if there's no host pointer
> > to be mapped anyway, then what's the benefit to make the MR to be ram=on?
> > Can we simply make it a normal IO memory region?  The only benefit of a
> 
> The guest access to normal IO memory region would be emulated by QEMU,
> while private assigned MMIO requires guest direct access via Secure EPT.
> 
> Seems the existing code doesn't support guest direct access if
> mr->ram == false:

Ah it's about this, ok.

I am not sure what's the best approach, but IMHO it's still better we stick
with host pointer always available when ram=on.  OTOH, VFIO private regions
may be able to provide a special mark somewhere, just like when romd_mode
was done previously as below (qemu 235e8982ad39), so that KVM should still
apply these MRs even if they're not RAM.

> 
> static void kvm_set_phys_mem(KVMMemoryListener *kml,
>                              MemoryRegionSection *section, bool add)
> {
>     [...]
> 
>     if (!memory_region_is_ram(mr)) {
>         if (writable || !kvm_readonly_mem_allowed) {
>             return;
>         } else if (!mr->romd_mode) {
>             /* If the memory device is not in romd_mode, then we actually want
>              * to remove the kvm memory slot so all accesses will trap. */
>             add = false;
>         }
>     }
> 
>     [...]
> 
>     /* register the new slot */
>     do {
> 
>         [...]
> 
>         err = kvm_set_user_memory_region(kml, mem, true);
>     }
> }
> 
> > ram=on MR is, IMHO, being able to be accessed as RAM-like.  If there's no
> > host pointer at all, I don't yet understand how that helps private MMIO
> > from working.
> 
> I expect private MMIO not accessible from host, but accessible from
> guest so has kvm_userspace_memory_region2 set. That means the resolving
> of its PFN during EPT fault cannot depends on host pointer.
> 
> https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.com/

I'll leave this to KVM experts, but I actually didn't follow exactly on why
mmu notifier is an issue to make , as I thought that was per-mm anyway, and KVM
should logically be able to skip all VFIO private MMIO regions if affected.
This is a comment to this part of your commit message:

        Rely on userspace mapping also means private MMIO mapping should
        follow userspace mapping change via mmu_notifier. This conflicts
        with the current design that mmu_notifier never impacts private
        mapping. It also makes no sense to support mmu_notifier just for
        private MMIO, private MMIO mapping should be fixed when CoCo-VM
        accepts the private MMIO, any following mapping change without
        guest permission should be invalid.

So I don't yet see a hard-no of reusing userspace mapping even if they're
not faultable as of now - what if they can be faultable in the future?  I
am not sure..

OTOH, I also don't think we need KVM_SET_USER_MEMORY_REGION3 anyway.. The
_REGION2 API is already smart enough to leave some reserved fields:

/* for KVM_SET_USER_MEMORY_REGION2 */
struct kvm_userspace_memory_region2 {
	__u32 slot;
	__u32 flags;
	__u64 guest_phys_addr;
	__u64 memory_size;
	__u64 userspace_addr;
	__u64 guest_memfd_offset;
	__u32 guest_memfd;
	__u32 pad1;
	__u64 pad2[14];
};

I think we _could_ reuse some pad*?  Reusing guest_memfd field sounds error
prone to me.

Not sure it could be easier if it's not guest_memfd* but fd + fd_offset
since the start.  But I guess when introducing _REGION2 we didn't expect
MMIO private regions come so soon..

Thanks,

-- 
Peter Xu


