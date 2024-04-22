Return-Path: <kvm+bounces-15538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FC28AD2C6
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 18:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5422B1F2194F
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 16:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B73915383D;
	Mon, 22 Apr 2024 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPxXxXTK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04C92EB11
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804854; cv=none; b=pWVDU0llahpaKXHlucK2NjpN1CyvvY8db0oRGLUyjQ38OZ3ZoQeg/eMQztcBZCSLnWPfpp6Hbv4MwLdlaCczwFwwXmB5xZJrZ3aS0exkph8Ar/tiPXmutq/AXvREIyeZQcbQqJ0Q8ELTkrWp5hH3lkv1wv3pBi5/MDu87CkKGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804854; c=relaxed/simple;
	bh=+wae0B+ys0gandOVgPZT8Q21ke+dPfFe3CB/aXABw5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NUjUhYVylUnNbF7n4TlAVWyAqr/vjdcTtV8bn1MrqxN+aZQh8bM92dIasl99dTotx4YBYb1Wy6veq0ADW+8tRVY0oPCMmKAlFHD5aud4DGDCUgoDEEnmd6dZ9jU72gtfCV+QzKqfdVS1/vcI4m1XLmFWAasUYJVMtO4PACJmCVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPxXxXTK; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6150dcdf83fso102278427b3.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 09:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713804852; x=1714409652; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OwAeYXHSMbPHhbeWG+3FQJ1s/K4L2nXyUDCV89cjg2I=;
        b=HPxXxXTKTYlWWdyM42J9V/fiPm5b3iQoiKHnKf+UBf++7lFa5l/aYZSaugj0McrAtA
         6ICigSeS00pnIjBS6tJ4Hu+gy7+g+/9t/Ahmtf6JoxOFQxzU1pMiq6VI2PZ3XBb9fGCc
         o8zfGlMFRD0iXFHuuSF1nNTAOF2PrjDxBxj8GcHqF1FQj5KwZVZ6YyWTq8YVB8V+jDYP
         gxStYsK++F2YxpbpJHli3qxUbp9yFKzSIX2BK75soqEhQU/6BOeTDdM/0g7lgLowUri+
         vCTUG8Zg+a2wt6ah3MP5xszPxvnACYa9N/ZZflH5EXgkHy7udtl4SvRILJP9S0+fKFeq
         3B2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713804852; x=1714409652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OwAeYXHSMbPHhbeWG+3FQJ1s/K4L2nXyUDCV89cjg2I=;
        b=jkjf55zZ2NlKV2ps3GhehKVpCcFokuJH5VOvWUeLu+7/8ejK1g8qyRi4lFC4IXRP4M
         +aCyuwasr78INyVDzawoJP17XRRv5CA3H1GUeRrHeW5OUTpojgQJB4K4lrEZXmFlXnIr
         s1swZ3FSORQ7iqTZW7V0A1OnMAT/EOHcuRAFt9AHRd7ujNQt1j4QCtcjH1wq8Mj0CmYO
         MRORECQUK10+1KjtvscDDgeKAMfpN9uEy9j31DNT/zXTcmrYT90UNInGJxaj/SES+0Pf
         RremWWsCzmu9dEp3LGACeLcVmANm7csMGXMzuwzPBKozxXzKWDfI3n+ZOMbls48WgQRZ
         T1AQ==
X-Forwarded-Encrypted: i=1; AJvYcCWooYLwR8aLO1P63yKG5CJlnlclWwBw9OTTvrhLgsYCLasCY9f6At9oskAm3RG0HFPufdTzuCfH/5e/Hdh248CqwUnF
X-Gm-Message-State: AOJu0Yyr4h32bsV+n/aGwVvrZEDW0gmdnRxLdo0qaHLxg9LnMvXlc1jT
	bxb/0OV5coXbCnIX9kK9H/Su7LauPDQiVqkTzRkETd6MVmuqiowKEqwrSFHHKlwLfK9H9ZWjeAK
	fJw==
X-Google-Smtp-Source: AGHT+IEBDEaXggQrL4Fp1AGzElxvevEhIM99Si/OADkeWqxXUAbrr396/RbJ3/JbHR2k88R5bWFo0Y+BPo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cb85:0:b0:615:33de:61d5 with SMTP id
 n127-20020a0dcb85000000b0061533de61d5mr2601239ywd.1.1713804851996; Mon, 22
 Apr 2024 09:54:11 -0700 (PDT)
Date: Mon, 22 Apr 2024 09:54:10 -0700
In-Reply-To: <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zh7KrSwJXu-odQpN@google.com> <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com> <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
 <ZiBc13qU6P3OBn7w@google.com> <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
 <ZiEulnEr4TiYQxsB@google.com> <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
 <ZiKoqMk-wZKdiar9@google.com> <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
Message-ID: <ZiaWMpNm30DD1A-0@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 22, 2024, Kai Huang wrote:
> On Fri, 2024-04-19 at 10:23 -0700, Sean Christopherson wrote:
> > On Fri, Apr 19, 2024, Kai Huang wrote:
> > And tdx_enable() should also do its best to verify that the caller is post-VMXON:
> > 
> > 	if (WARN_ON_ONCE(!(__read_cr4() & X86_CR4_VMXE)))
> > 		return -EINVAL;
> 
> This won't be helpful, or at least isn't sufficient.
> 
> tdx_enable() can SEAMCALLs on all online CPUs, so checking "the caller is
> post-VMXON" isn't enough.  It needs "checking all online CPUs are in post-
> VMXON with tdx_cpu_enable() having been done".

I'm suggesting adding it in the responding code that does that actual SEAMCALL.

And the intent isn't to catch every possible problem.  As with many sanity checks,
the intent is to detect the most likely failure mode to make triaging and debugging
issues a bit easier.

> I didn't add such check because it's not mandatory, i.e., the later
> SEAMCALL will catch such violation.

Yeah, a sanity check definitely isn't manadatory, but I do think it would be
useful and worthwhile.  The code in question is relatively unique (enables VMX
at module load) and a rare operation, i.e. the cost of sanity checking CR4.VMXE
is meaningless.  If we do end up with a bug where a CPU fails to do VMXON, this
sanity check would give a decent chance of a precise report, whereas #UD on a
SEAMCALL will be less clearcut.

> Btw, I noticed there's another problem, that is currently tdx_cpu_enable()
> actually requires IRQ being disabled.  Again it was implemented based on
> it would be invoked via both on_each_cpu() and kvm_online_cpu().
> 
> It also also implemented with consideration that it could be called by
> multiple in-kernel TDX users in parallel via both SMP call and in normal
> context, so it was implemented to simply request the caller to make sure
> it is called with IRQ disabled so it can be IRQ safe  (it uses a percpu
> variable to track whether TDH.SYS.LP.INIT has been done for local cpu
> similar to the hardware_enabled percpu variable).

Is this is an actual problem, or is it just something that would need to be
updated in the TDX code to handle the change in direction?

> > Actually, duh.  There's absolutely no reason to force other architectures to
> > choose when to enable virtualization.  As evidenced by the massaging to have x86
> > keep enabling virtualization on-demand for !TDX, the cleanups don't come from
> > enabling virtualization during module load, they come from registering cpuup and
> > syscore ops when virtualization is enabled.
> > 
> > I.e. we can keep kvm_usage_count in common code, and just do exactly what I
> > proposed for kvm_x86_enable_virtualization().
> 
> If so, then looks this is basically changing "cpuhp_setup_state_nocalls()
> + on_each_cpu()" to "cpuhp_setup_state()", and moving it along with
> register_syscore_ops() to hardware_enable_all()"?

Yep.

