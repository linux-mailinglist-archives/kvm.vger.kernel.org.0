Return-Path: <kvm+bounces-24393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 029E4954C47
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 16:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFE1F28395D
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 14:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438D81BCA14;
	Fri, 16 Aug 2024 14:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XO3mpMPo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75901E520
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723818088; cv=none; b=uesDCaX8J/eWvaweHU/U5B+c2+TewSXx3FD3aO+eUN+iObOba0Whro0TRAHBF2cREjaQn3Tb5Rz3vHlQ3h/NMRxziZWQ5hcuhqL33LFEGkettk6Rf7UPYkQtdlzPPxoOFMwvHMzxrckh1ga8s8IOH3hxWz0i9jCLhRpNcd4F52I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723818088; c=relaxed/simple;
	bh=XViPu9Ga1CH+Foj+CO5agYgwIrSBF/sFOf+9+Bvx5Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxjRSmXqRbDYTus6lYrirqfcrKLpEujPc0HVuUcOnUTwVVW+IBDJ0/8b2kZNg5vnkKaGDs1TvvtnlemDgI0s4WK82akAOGE4M0O3jnBNjmQJJyHePcmPCbjOGXwkmrr+xez5D3DmMFKR7IqayJ8epD6jio+Noh/MUSaTyh1ExRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XO3mpMPo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723818085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DuswRPhqxZF2X8qLOLYIapi1ZWMauW2dTfqaGd5YdE0=;
	b=XO3mpMPodHbS6me2kUHr8r8AK/qccy6C/Se19ul/eJxAU8/KPuMGQ9dQihsKk1djNr8Fwc
	GmGMBh5Nw22/33fW1kEl/VFYY98SJAL3aldX/HE4jaiuQsRPUyWxjeJ83tAdIWaOtldx/5
	A487T71NbrU4C/Ga+PKmfYzCuADFR5c=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-qAoOfvBYMOeZihJnjK8mDA-1; Fri, 16 Aug 2024 10:21:22 -0400
X-MC-Unique: qAoOfvBYMOeZihJnjK8mDA-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3daf1458b58so304427b6e.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723818082; x=1724422882;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DuswRPhqxZF2X8qLOLYIapi1ZWMauW2dTfqaGd5YdE0=;
        b=OE2H8iBrVkRyuT8sHxXGJcb1JoNfamAPOgJAxPn3REVCJ2AgzAxH4oNl35EFsJKPH2
         amjcMtOtLQw2fJBfe7jlLveg+IlqBtwKMkGqf9WqMqtYW9G8/pkkJV/zD7uH11zChM2P
         nPQmmkMQokd8RiIMgick5MfQZAUNpn3u2T3DB5mUF28Kgx5Buz+0p3E4ca1D33dMyicz
         0eUQzNkK+cLTexG4+qy4PgRa1VyDLJF1FY6wz89fTctvYWw/UmqmMZ4DMhVdW4yWBWOn
         S3jYE86CHbUxa8UfvROlLJgLg//Qmr9tlXSPNOXPoA5zUmxGVVDEsv1Rq/k1PRGmk3q8
         XwIw==
X-Forwarded-Encrypted: i=1; AJvYcCWeVw5GxdxZD+8sOuO6wD/dR5ZRiU07/YirWqviG7pLObB7hXBqGRhOsOov83Fcb8ir1/ZcPW9CS7UjkDXBNvLaDl0V
X-Gm-Message-State: AOJu0Ywc+NDLUYseVXLUHu8NeJqvBkRzu0XbrR/iznjsZBQ0oXdG/CEe
	BLeQQ3SdKyFUbV+91GPU2hBxTCyysArDJrawCIVIRjUYJX1FoJWzsgqOdCLFT1RiWqLMOX6YicH
	JRfpSWn6pYMMdNRRa/IyI8pd4y3mSpGGr0Qb5JQmkToQr8byEfQ==
X-Received: by 2002:a05:6808:148a:b0:3d9:402e:4d17 with SMTP id 5614622812f47-3dd3acb5e6dmr1979650b6e.2.1723818081693;
        Fri, 16 Aug 2024 07:21:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDqekk9YZ0zc1gPPIevbw82K49KS4P67EowjlW1kTTHelWBjTXZ7lPyZqRU/oSZDp42I5DQA==
X-Received: by 2002:a05:6808:148a:b0:3d9:402e:4d17 with SMTP id 5614622812f47-3dd3acb5e6dmr1979620b6e.2.1723818081238;
        Fri, 16 Aug 2024 07:21:21 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff1073b4sm176155085a.104.2024.08.16.07.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 07:21:20 -0700 (PDT)
Date: Fri, 16 Aug 2024 10:21:17 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 06/19] mm/pagewalk: Check pfnmap early for
 folio_walk_start()
Message-ID: <Zr9gXek8ScalQs33@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com>
 <ZrZJqd8FBLU_GqFH@x1n>
 <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com>
 <20240814130525.GH2032816@nvidia.com>
 <81080764-7c94-463f-80d3-e3b2968ddf5f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <81080764-7c94-463f-80d3-e3b2968ddf5f@redhat.com>

On Fri, Aug 16, 2024 at 11:30:31AM +0200, David Hildenbrand wrote:
> On 14.08.24 15:05, Jason Gunthorpe wrote:
> > On Fri, Aug 09, 2024 at 07:25:36PM +0200, David Hildenbrand wrote:
> > 
> > > > > That is in general not what we want, and we still have some places that
> > > > > wrongly hard-code that behavior.
> > > > > 
> > > > > In a MAP_PRIVATE mapping you might have anon pages that we can happily walk.
> > > > > 
> > > > > vm_normal_page() / vm_normal_page_pmd() [and as commented as a TODO,
> > > > > vm_normal_page_pud()] should be able to identify PFN maps and reject them,
> > > > > no?
> > > > 
> > > > Yep, I think we can also rely on special bit.
> > 
> > It is more than just relying on the special bit..
> > 
> > VM_PFNMAP/VM_MIXEDMAP should really only be used inside
> > vm_normal_page() because thay are, effectively, support for a limited
> > emulation of the special bit on arches that don't have them. There are
> > a bunch of weird rules that are used to try and make that work
> > properly that have to be followed.
> > 
> > On arches with the sepcial bit they should possibly never be checked
> > since the special bit does everything you need.
> > 
> > Arguably any place reading those flags out side of vm_normal_page/etc
> > is suspect.
> 
> IIUC, your opinion matches mine: VM_PFNMAP/VM_MIXEDMAP and pte_special()/...
> usage should be limited to vm_normal_page/vm_normal_page_pmd/ ... of course,
> GUP-fast is special (one of the reason for "pte_special()" and friends after
> all).

The issue is at least GUP currently doesn't work with pfnmaps, while
there're potentially users who wants to be able to work on both page +
!page use cases.  Besides access_process_vm(), KVM also uses similar thing,
and maybe more; these all seem to be valid use case of reference the vma
flags for PFNMAP and such, so they can identify "it's pfnmap" or more
generic issues like "permission check error on pgtable".

The whole private mapping thing definitely made it complicated.

> 
> > 
> > > > Here I chose to follow gup-slow, and I suppose you meant that's also wrong?
> > > 
> > > I assume just nobody really noticed, just like nobody noticed that
> > > walk_page_test() skips VM_PFNMAP (but not VM_IO :) ).
> > 
> > Like here..
> > 
> > > > And, just curious: is there any use case you're aware of that can benefit
> > > > from caring PRIVATE pfnmaps yet so far, especially in this path?
> > > 
> > > In general MAP_PRIVATE pfnmaps is not really useful on things like MMIO.
> > > 
> > > There was a discussion (in VM_PAT) some time ago whether we could remove
> > > MAP_PRIVATE PFNMAPs completely [1]. At least some users still use COW
> > > mappings on /dev/mem, although not many (and they might not actually write
> > > to these areas).
> > 
> > I've squashed many bugs where kernel drivers don't demand userspace
> > use MAP_SHARED when asking for a PFNMAP, and of course userspace has
> > gained the wrong flags too. I don't know if anyone needs this, but it
> > has crept wrongly into the API.
> > 
> > Maybe an interesting place to start is a warning printk about using an
> > obsolete feature and see where things go from there??
> 
> Maybe we should start with some way to pr_warn_ONCE() whenever we get a
> COW/unshare-fault in such a MAP_PRIVATE mapping, and essentially populate
> the fresh anon folio.
> 
> Then we don't only know who mmaps() something like that, but who actually
> relies on getting anon folios in there.

Sounds useful to me, if nobody yet has solid understanding of those private
mappings while we'd want to collect some info.  My gut feeling is we'll see
some valid use of them, but I hope I'm wrong..  I hope we can still leave
that as a separate thing so we focus on large mappings in this series.  And
yes, I'll stick with special bits here to not add one more flag reference.

Thanks,

-- 
Peter Xu


