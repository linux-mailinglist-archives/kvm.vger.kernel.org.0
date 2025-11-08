Return-Path: <kvm+bounces-62381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7B3C423F5
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 02:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9A2344E170F
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 01:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77B229B777;
	Sat,  8 Nov 2025 01:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKIdMaaM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9FD27E054
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 01:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762565835; cv=none; b=RquuciznQu8dfrsXXLp3L4BcNHsEIg31kkTxk/kXrVuUnqA8/NUdJfuilOQY1B/wVG5Z6NdJv2JSftCouBLTtlXjgwQ4ixNCzkdL7UlThA9NSQfhpBJlR2DV4BMbp/Hn2e91bl/lLF7gg5iu7uzfvJ+aPyJugGtI7y6+QvdL/sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762565835; c=relaxed/simple;
	bh=SJSMeQUFpCo/kA2WHCwtApgStS9KZ0/zaRiqLaMztIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fkSDQ3tKcAV2iudDoWAz17ipYOGgzKNLoU9susc8TNXBnB5X/VaOrtjmAqzYBHzbh1jIkAgO71ONU3IZLN06d7qKp2e6vOV3ybfN4uN6eYoQZWJXKj+iYCzeQxrQMYIwGylj7AB5EIhfbUYKTQtujYrNYYFj5DZ7ta+zQTwupx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKIdMaaM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3416dc5752aso3236129a91.1
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 17:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762565833; x=1763170633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xRnY5SJkO9h64mX0v92qoTuQodID73X2Y9ZfRGvcdjo=;
        b=sKIdMaaM+j+Za3yHUdm+TM6dj2nx9qcBQPYVcbxb8o/NnRuPmNz7vzMiNU+jQgJUEs
         0syIC3pEaHBehpZEDgMBuPhLBUscvPKIUOypy8iy3zLx4aL2EnvH9HL3VHRgfMoR0uPw
         AIhrL0KPjDhpRTOuuuhr+U9CzWbjIZWtO8tRnWmBZ8bbMWdwcNtcp6J9jUsHjgWeXzia
         XUmdXNVym8a6vcSFjwPYQIX5akAoc/DLgNLaClrp9Mk/9V0fl6gioIVWceIFLTiUhZY/
         aBZGo9Hr/utCZXI1AJyvtxusqu3F+2k9ennNHMzSTZGvoDb0pZa3FweDhv8+Y32cc/7W
         wR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762565833; x=1763170633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xRnY5SJkO9h64mX0v92qoTuQodID73X2Y9ZfRGvcdjo=;
        b=cQbv36TiO/z1a77HiUI64nTz6RS2fyizM9Kmo5+Q/T+EYnAYTjKeXsvToe6ZVUiWZt
         8AjH0DO1u85R+c7SQmxJI4c5stPHfTL4eVuJlIQlrtU4HTYj+FR9Z7N+6L00NvpYhLpz
         GJHLWwWl0GfJm7VE1Z1SST16gIEt8PoNV4ODw0HZFEW/WxqWBL+fET53ET1lpE94ghze
         YVt7vps3UEpzMhuIOVdlkKktzhLFT8yjMFXFfsdkGSLqatkxSquGd9822HRlCnEKcfiZ
         KWmmrle15vKu3CSQ6dabIcp/+a66iRUpaZ40LJ6PSJg8eAdSiG2kSNMk8wUrE4xveNoM
         sggg==
X-Forwarded-Encrypted: i=1; AJvYcCW33JZmumREpiRspa+XJ9rNOiCROCzZ8PHIceLBphImMPtcmKj+KhfUHDJpMNNriXpMuZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBOKKs9lDa2ZJwE5n3QFlnuYoXcDwHq0prMoHA95O9ryS/+47
	IkQRuIBusNN3SoNKeJCCBme01uehR9TBXlvKbSqX/mRl0nHByTaVFdXHp+ngUMFCrIzw/paZvAy
	dZF+glw==
X-Google-Smtp-Source: AGHT+IEbCnwUgr/Z7lukguR8IbmbSGbo7BssGdcfDCd1/WphprWEu5jq8gZggwd2EpYcWtXIDi96CNhVrVc=
X-Received: from pjaf2.prod.google.com ([2002:a17:90a:1202:b0:33b:51fe:1a89])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28cd:b0:340:c179:3657
 with SMTP id 98e67ed59e1d1-3436cbd88e1mr1283355a91.33.1762565832980; Fri, 07
 Nov 2025 17:37:12 -0800 (PST)
Date: Fri, 7 Nov 2025 17:37:11 -0800
In-Reply-To: <aQ2rTgWwqWvoqnIL@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030191528.3380553-1-seanjc@google.com> <20251030191528.3380553-4-seanjc@google.com>
 <aQ2rTgWwqWvoqnIL@intel.com>
Message-ID: <aQ6ex5rKZU-bEDiX@google.com>
Subject: Re: [PATCH v5 3/4] KVM: x86: Leave user-return notifier registered on reboot/shutdown
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 07, 2025, Chao Gao wrote:
> On Thu, Oct 30, 2025 at 12:15:27PM -0700, Sean Christopherson wrote:
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index bb7a7515f280..c927326344b1 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -13086,7 +13086,21 @@ int kvm_arch_enable_virtualization_cpu(void)
> > void kvm_arch_disable_virtualization_cpu(void)
> > {
> > 	kvm_x86_call(disable_virtualization_cpu)();
> >-	drop_user_return_notifiers();
> >+
> >+	/*
> >+	 * Leave the user-return notifiers as-is when disabling virtualization
> >+	 * for reboot, i.e. when disabling via IPI function call, and instead
> >+	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
> >+	 * the *very* unlikely scenario module unload is racing with reboot).
> >+	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
> >+	 * could be actively modifying user-return MSR state when the IPI to
> >+	 * disable virtualization arrives.  Handle the extreme edge case here
> >+	 * instead of trying to account for it in the normal flows.
> >+	 */
> >+	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
> >+		drop_user_return_notifiers();
> >+	else
> >+		__module_get(THIS_MODULE);
> 
> This doesn't pin kvm-{intel,amd}.ko, right? if so, there is still a potential
> user-after-free if the CPU returns to userspace after the per-CPU
> user_return_msrs is freed on kvm-{intel,amd}.ko unloading.
> 
> I think we need to either move __module_get() into
> kvm_x86_call(disable_virtualization_cpu)() or allocate/free the per-CPU
> user_return_msrs when loading/unloading kvm.ko. e.g.,

Gah, you're right.  I considered the complications with vendor modules, but missed
the kvm_x86_vendor_exit() angle.

> >From 0269f0ee839528e8a9616738d615a096901d6185 Mon Sep 17 00:00:00 2001
> From: Chao Gao <chao.gao@intel.com>
> Date: Fri, 7 Nov 2025 00:10:28 -0800
> Subject: [PATCH] KVM: x86: Allocate/free user_return_msrs at kvm.ko
>  (un)loading time
> 
> Move user_return_msrs allocation/free from vendor modules (kvm-intel.ko and
> kvm-amd.ko) (un)loading time to kvm.ko's to make it less risky to access
> user_return_msrs in kvm.ko. Tying the lifetime of user_return_msrs to
> vendor modules makes every access to user_return_msrs prone to
> use-after-free issues as vendor modules may be unloaded at any time.
> 
> kvm_nr_uret_msrs is still reset to 0 when vendor modules are loaded to
> clear out the user return MSR list configured by the previous vendor
> module.

Hmm, the other idea would to stash the owner in kvm_x86_ops, and then do:

		__module_get(kvm_x86_ops.owner);

LOL, but that's even more flawed from a certain perspective, because
kvm_x86_ops.owner could be completely stale, especially if this races with
kvm_x86_vendor_exit().

> +static void __exit kvm_free_user_return_msrs(void)
>  {
> 	int cpu;
>  
> @@ -10044,13 +10043,11 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops
> *ops)
> 		return -ENOMEM;
> 	}
>  
> -	r = kvm_init_user_return_msrs();
> -	if (r)
> -		goto out_free_x86_emulator_cache;
> +	kvm_nr_uret_msrs = 0;

For maximum paranoia, we should zero at exit() and WARN at init().

> 	r = kvm_mmu_vendor_module_init();
> 	if (r)
> -		goto out_free_percpu;
> +		goto out_free_x86_emulator_cache;
>  
> 	kvm_caps.supported_vm_types = BIT(KVM_X86_DEFAULT_VM);
> 	kvm_caps.supported_mce_cap = MCG_CTL_P | MCG_SER_P;
> @@ -10148,8 +10145,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops
> *ops)
> 	kvm_x86_call(hardware_unsetup)();
>  out_mmu_exit:
> 	kvm_mmu_vendor_module_exit();
> -out_free_percpu:
> -	kvm_free_user_return_msrs();
>  out_free_x86_emulator_cache:
> 	kmem_cache_destroy(x86_emulator_cache);
> 	return r;
> @@ -10178,7 +10173,6 @@ void kvm_x86_vendor_exit(void)
>  #endif
> 	kvm_x86_call(hardware_unsetup)();
> 	kvm_mmu_vendor_module_exit();
> -	kvm_free_user_return_msrs();
> 	kmem_cache_destroy(x86_emulator_cache);
>  #ifdef CONFIG_KVM_XEN
> 	static_key_deferred_flush(&kvm_xen_enabled);
> @@ -14361,8 +14355,14 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
>  
>  static int __init kvm_x86_init(void)
>  {
> +	int r;
> +
> 	kvm_init_xstate_sizes();
>  
> +	r = kvm_init_user_return_msrs();
> +	if (r)

Rather than dynamically allocate the array of structures, we can "statically"
allocate it when the module is loaded.

I'll post this as a proper patch (with my massages) once I've tested.

Thanks much!

(and I forgot to hit "send", so this is going to show up after the patch, sorry)

