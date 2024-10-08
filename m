Return-Path: <kvm+bounces-28153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A5B9957A2
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 21:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 686B51F26879
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBEE213EED;
	Tue,  8 Oct 2024 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UIwU5yFg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F67212D16
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 19:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728415817; cv=none; b=imR6pGX96+nMM2BaMc1sR36wd+xFf5OACdywEla4Dol6cGriLYmSAMaitC00bpOyzndB/w/kVKBXM0ka4r6iiWW2LdjJW62XLw9ythn0iIvz5HudkNlZ8grlqeWsFGk4N4wtcFCW5ul89koQBRaYqhnB/FnWKK/5sNuiRSNM4og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728415817; c=relaxed/simple;
	bh=i02dTDaEPMSaL7Z/bKJlJnWAWdq0QL8dv8eDCHe+D5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SDgADTThiFqD7AdXpE3vRhh5qmqzJ2TpFCJdKw5+s1Vo9IX7WzWvgG8ufvGzVstQC90VwPgQD1lc1F5QH6hx78ricb4RH7tv1QoYCQU5Eqke3syU508bkg6yQZJcfsx4M24w7l/7oUWT9ayrbh/EFU/QRbDbmXpl+GzqM+e20kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UIwU5yFg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1159159528so394971276.1
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2024 12:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728415815; x=1729020615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FPlkG7ZoRlkbHr9vPUwi8+LWYYFCuq+IrymeH+44AKA=;
        b=UIwU5yFgsMUQJwNCpx1R7rpIhIAgxbFTTJu+vxcmwAsY7ZKqgzmrqB8xgiBkOsFCE2
         /3jjw5rh7I/62TbNuL1ABPkFYNxS/nr2Afmh6DShg337D8GrWrBcEabum9Aqd2KlZXLW
         07qphvO8jb2GqLRYFtZXJJ9Z+ECC/ATMhU6wsEHtLWAKvufuauReEqxjqFXtzzEoy8Ra
         mvkdIocZU6pP3a1dXP2e1XMluxLMxvD7Y4nmBia/y/q8fO3bJCdjCHidaB4daVy/HIPt
         hA2106BR4knvJ+sgeXOJ8qGI1mTEPRMhCdpLYcJKBIwLdHOgU0zjKltm7Myr/k7D6KGz
         ELlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728415815; x=1729020615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FPlkG7ZoRlkbHr9vPUwi8+LWYYFCuq+IrymeH+44AKA=;
        b=sXFk9/sO+CzWaJcR9EdITzrvReXJwCQIBT3tsCjmCmHPJ7OL04gIfKpNtaKgg0DXBK
         kbkIaCrV3VKfMumL5VFwfh8guyQ2OtAT8WFqyi57rjnPgXsGlt7c9jHOWwVMPyN0ojkh
         YOP+twqdOV347LdbwFn8ir39d2hPI20b9kG4LLY/A133gxlM/UQ+tgZ+toYaJm8Z+qrN
         15ycDOCGZgHvb5ATDq8835wjIJK2UTYiGi4VtXmwlooyGg+5+6TvUgIPy7S0HIkQJoAI
         j1bvJc5rH+sEMtCebwz2EHr89YGbzZik3Hk9AH32ur5y7YB2BYf+hfta5K6uF8r4garo
         KC6g==
X-Forwarded-Encrypted: i=1; AJvYcCU/82PNDXK5yPlvzK8HK8YI7kRkR6KIapPgi/5FYVLyLSB0nFCAmomIBm/fZSYSvxgkTUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5lfOBDTjgwwAtdjeZBcbsWif80on6GrcwutBtLlmgcpM6Tcs9
	zTAgM8UPT153pUdJ48WithQNG/XgZqxpmeTjfkWKG0xM/5MF3fAfbuRC4o755sl4NTcfpgPfg3T
	zeQ==
X-Google-Smtp-Source: AGHT+IFES2vX7FGCe5EWWJU/+OHopxi8E9cAc1VIHr9YudNnvp5Ss8FEVKKEmYVcxwyacMvNG/vZGf7wOOo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:2d1a:0:b0:e28:e97f:5397 with SMTP id
 3f1490d57ef6-e28fe4604a9mr320276.3.1728415814755; Tue, 08 Oct 2024 12:30:14
 -0700 (PDT)
Date: Tue, 8 Oct 2024 12:30:13 -0700
In-Reply-To: <diqzwmiosqfs.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzzfnkswiv.fsf@ackerleytng-ctop.c.googlers.com> <diqzwmiosqfs.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <ZwWIRW7zoX2PBsnF@google.com>
Subject: Re: [RFC PATCH 30/39] KVM: guest_memfd: Handle folio preparation for
 guest_memfd mmap
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: quic_eberman@quicinc.com, tabba@google.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, pbonzini@redhat.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	isaku.yamahata@intel.com, muchun.song@linux.dev, mike.kravetz@oracle.com, 
	erdemaktas@google.com, vannapurve@google.com, qperret@google.com, 
	jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org, 
	brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev, 
	pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com, 
	anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com, 
	vkuznets@redhat.com, maciej.wieczor-retman@intel.com, pgonda@google.com, 
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 03, 2024, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > Elliot Berman <quic_eberman@quicinc.com> writes:
> >> From x86 CoCo perspective, I think it also makes sense to not zero
> >> the folio when changing faultiblity from private to shared:
> >>  - If guest is sharing some data with host, you've wiped the data and
> >>    guest has to copy again.
> >>  - Or, if SEV/TDX enforces that page is zero'd between transitions,
> >>    Linux has duplicated the work that trusted entity has already done.
> >>
> >> Fuad and I can help add some details for the conversion. Hopefully we
> >> can figure out some of the plan at plumbers this week.
> >
> > Zeroing the page prevents leaking host data (see function docstring for
> > kvm_gmem_prepare_folio() introduced in [1]), so we definitely don't want
> > to introduce a kernel data leak bug here.
> 
> Actually it seems like filemap_grab_folio() already gets a zeroed page.
> 
> filemap_grab_folio() eventually calls __alloc_pages_noprof()
> -> get_page_from_freelist()
>    -> prep_new_page()
>       -> post_alloc_hook()
> 
> and post_alloc_hook() calls kernel_init_pages(), which zeroes the page,
> depending on kernel config.
> 
> Paolo, was calling clear_highpage() in kvm_gmem_prepare_folio() zeroing an
> already empty page returned from filemap_grab_folio()?

Yes and no.  CONFIG_INIT_ON_ALLOC_DEFAULT_ON and init_on_alloc are very much
hardening features, not functional behavior that other code _needs_ to be aware
of.  E.g. enabling init-on-alloc comes with a measurable performance cost.

Ignoring hardening, the guest_memfd mapping specifically sets the gfp_mask to
GFP_HIGHUSER, i.e. doesn't set __GFP_ZERO.

That said, I wouldn't be opposed to skipping the clear_highpage() call when
want_init_on_alloc() is true.

Also, the intended behavior (or at least, what  intended) of kvm_gmem_prepare_folio()
was it would do clear_highpage() if and only if a trusted entity does NOT zero
the page.  Factoring that in is a bit harder, as it probably requires another
arch hook (or providing an out-param from kvm_arch_gmem_prepare()).  I.e. the
want_init_on_alloc() case isn't the only time KVM could shave cycles by not
redundantly zeroing memory.

