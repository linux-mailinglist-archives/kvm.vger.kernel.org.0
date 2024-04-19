Return-Path: <kvm+bounces-15351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D05A88AB44E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 19:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 572F91F22416
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 17:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A319713A899;
	Fri, 19 Apr 2024 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I2wLMuhE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80277137C32
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 17:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713547435; cv=none; b=Jr8GvK46tbxQ7pRwYP/ZHzkOFGYdhBuFmX/0ZR2AtDobnrXP8YX/jKd4mSZJ/BJQ4Eypi+kh2DKbgPehqQAo/7o/L3gh2cZnkxLthcvc84W7+km+g46EYATzqzOnexKCIO1FfbF+L/tv58y/1tSeDi5aq10vcgOCor+FFHXHFD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713547435; c=relaxed/simple;
	bh=4zqi94Uc/R8iBsYBBImj/1Cm2SNGTxyyrkhMn0eenOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DVM3ILNav3buwuL/aRRUOTJv7zrxh2Re5XlHeSH2HXsP22vXTX6+TYyIfqMJsmYdpUocBNZJD6xCvyp4ifLR3j5+BCFYyNPvme4vmotSV6sH3/z39qw2pVW0MHck7PZTg3XmX6fH/tznWC+9htfdvV1qCgvp9JIkwixURVieWQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I2wLMuhE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a4a2cace80so2529627a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 10:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713547434; x=1714152234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WPGtsMCwemSIr+JDp0r8nt/aMHu/Jjken9XpaKI2j4=;
        b=I2wLMuhEPUQlJ/JAHQd9rpfMn/rWXxVBCSRNRSosBQRBgPfVNs4g1jYZbKF4IMMNJT
         3j/U0j+RL13ceVq5SYdZGRRImSTZYybS6SFvd0ZtEERCoXiQdo2S++wgCpt8BSv7w0Pr
         AZ9f/Y8l+J24Q00EL8nnxMVvrrQPKSb2dUU/TKIDc9Ynb/rJ6EirRpm8jDxJXihbs3zn
         cEps/grfphrNm8UsWINftQ3E8BAUDjJZqb2ASHf8yxDQr2Z9E+GAZw0earqMDm4Mh5ep
         CIxD5tl87957emeXdBO2WzLKh4hP19MZWAlX0Ssja9mbXchQuz2a6EZsC86DJTeDS36D
         099w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713547434; x=1714152234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WPGtsMCwemSIr+JDp0r8nt/aMHu/Jjken9XpaKI2j4=;
        b=ozczWVOPZhQ8A52GGoQNM+W1nnstQq0tpG/xNi7cQxrY2fvuqOfAkauncMhS22TBA4
         mDv9ST3u3fGHF3+2Vj81DHlsX6UVyny8vSwYDlHbzf0O1WKaRPnZ3tLlYUJRjOE6g43P
         DCGKG21FhzHc8CsWjO4lB+J5hDxqD/pcpTxbwmEblRiDU1sTlB2o2nFibKu5w27AfTk+
         Fy7Nq60FWoWY+UhralnV8Ynb59nngFD9ttg1wFGjMeY3XyLITM0ek1kCgEutM8PYPMev
         jHDtEzxqHHYqdHdLrwXL622Uk9+gNJI7QN0RDpt2/y8ptqKSomlr9tbp5gPHhsu4ufQ/
         WN0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXPEEoQRUKVscd7983LUge5bYledhTavqmcG/ylXOrsRfEQL1dzvb46F4My66u0eQCwx3oasyIxFXTqtL8bvnOtFs4D
X-Gm-Message-State: AOJu0YzOnq5xKJQlkvkLrKxwZwra2TW0kjmA+eNJr0YZF/GCI5Beyl3V
	8FN0l4Bg55OMKFCT/UjVV2myc5dh7918UgiHGM/UbmQDwbNiIQdLyqAWS/ypoDJ4Hm27C5DmJ+r
	lwQ==
X-Google-Smtp-Source: AGHT+IGGe/+C3TYWvB4s3TxxlXneQCY3I9SMxiecXVgkEzf3CZxByEf/KHHFm+qEb9Q+1OuEhyXw0yNn4Bg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f411:b0:2ac:3c42:57ea with SMTP id
 ch17-20020a17090af41100b002ac3c4257eamr8941pjb.5.1713547433583; Fri, 19 Apr
 2024 10:23:53 -0700 (PDT)
Date: Fri, 19 Apr 2024 10:23:52 -0700
In-Reply-To: <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zhftbqo-0lW-uGGg@google.com> <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
 <Zh7KrSwJXu-odQpN@google.com> <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com> <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
 <ZiBc13qU6P3OBn7w@google.com> <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
 <ZiEulnEr4TiYQxsB@google.com> <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
Message-ID: <ZiKoqMk-wZKdiar9@google.com>
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

On Fri, Apr 19, 2024, Kai Huang wrote:
> On 19/04/2024 2:30 am, Sean Christopherson wrote:
> > No, that will deadlock as cpuhp_setup_state() does cpus_read_lock().
> 
> Right, but it takes cpus_read_lock()/unlock() internally.  I was talking
> about:
> 
> 	if (enable_tdx) {
> 		kvm_x86_virtualization_enable();
> 
> 		/*
> 		 * Unfortunately currently tdx_enable() internally has
> 		 * lockdep_assert_cpus_held().
> 		 */
> 		cpus_read_lock();
> 		tdx_enable();
> 		cpus_read_unlock();
> 	}

Ah.  Just have tdx_enable() do cpus_read_lock(), I suspect/assume the current
implemention was purely done in anticipation of KVM "needing" to do tdx_enable()
while holding cpu_hotplug_lock.

And tdx_enable() should also do its best to verify that the caller is post-VMXON:

	if (WARN_ON_ONCE(!(__read_cr4() & X86_CR4_VMXE)))
		return -EINVAL;

> > > Btw, why couldn't we do the 'system_state' check at the very beginning of
> > > this function?
> > 
> > We could, but we'd still need to check after, and adding a small bit of extra
> > complexity just to try to catch a very rare situation isn't worth it.
> > 
> > To prevent races, system_state needs to be check after register_syscore_ops(),
> > because only once kvm_syscore_ops is registered is KVM guaranteed to get notified
> > of a shutdown. >
> > And because the kvm_syscore_ops hooks disable virtualization, they should be called
> > after cpuhp_setup_state().  That's not strictly required, as the per-CPU
> > hardware_enabled flag will prevent true problems if the system enter shutdown
> > state before KVM reaches cpuhp_setup_state().
> > 
> > Hmm, but the same edge cases exists in the above flow.  If the system enters
> > shutdown _just_ after register_syscore_ops(), KVM would see that in system_state
> > and do cpuhp_remove_state(), i.e. invoke kvm_offline_cpu() and thus do a double
> > disable (which again is benign because of hardware_enabled).
> > 
> > Ah, but registering syscore ops before doing cpuhp_setup_state() has another race,
> > and one that could be fatal.  If the system does suspend+resume before the cpuhup
> > hooks are registered, kvm_resume() would enable virtualization.  And then if
> > cpuhp_setup_state() failed, virtualization would be left enabled.
> > 
> > So cpuhp_setup_state() *must* come before register_syscore_ops(), and
> > register_syscore_ops() *must* come before the system_state check.
> 
> OK.  I guess I have to double check here to completely understand the races.
> :-)
> 
> So I think we have consensus to go with the approach that shows in your
> second diff -- that is to always enable virtualization during module loading
> for all other ARCHs other than x86, for which we only always enables
> virtualization during module loading for TDX.

Assuming the other arch maintainers are ok with that approach.  If waiting until
a VM is created is desirable for other architectures, then we'll need to figure
out a plan b.  E.g. KVM arm64 doesn't support being built as a module, so enabling
hardware during initialization would mean virtualization is enabled for any kernel
that is built with CONFIG_KVM=y.

Actually, duh.  There's absolutely no reason to force other architectures to
choose when to enable virtualization.  As evidenced by the massaging to have x86
keep enabling virtualization on-demand for !TDX, the cleanups don't come from
enabling virtualization during module load, they come from registering cpuup and
syscore ops when virtualization is enabled.

I.e. we can keep kvm_usage_count in common code, and just do exactly what I
proposed for kvm_x86_enable_virtualization().

I have patches to do this, and initial testing suggests they aren't wildly
broken.  I'll post them soon-ish, assuming nothing pops up in testing.  They are
clean enough that they can land in advance of TDX, e.g. in kvm-coco-queue even
before other architectures verify I didn't break them.

> Then how about "do kvm_x86_virtualization_enable()  within
> late_hardware_setup() in kvm_x86_vendor_init()"  vs "do
> kvm_x86_virtualization_enable() in TDX-specific code after
> kvm_x86_vendor_init()"?
> 
> Which do you prefer?

The latter, assuming it doesn't make the TDX code more complex than it needs to
be.  The fewer kvm_x86_ops hooks, the better.

