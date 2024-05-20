Return-Path: <kvm+bounces-17766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 712AF8C9EC0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E0BF1C20E6B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF901369A3;
	Mon, 20 May 2024 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZN0sa3k+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7855513665A
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 14:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716215284; cv=none; b=T6fdoh+XfpmhLaQ9sz6wy1pdnISe3Kcln+1V0O3kY5jCydnXHAdIt2+ForGhZC9fKz+cRL15EYUROi3Agz5TML7Ki9cB7PxZTOOA3iPbNQvrniqYCkjYBKPPUOGPqDgb/SgFLdvbRYY8oOYx9LzpkX1HYqDEfyVuTzETquapV7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716215284; c=relaxed/simple;
	bh=aIFaVZwViDuED/MpngbT68T3Hn2XrzGWILZhL0y6hC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sU3oUEX+opwPg4F4tuwjuQbcNrpR8T6LfGOW9Omf3FfqJAoUCiZJBqWMTYYLYK+XzdbtX8D/iemYJwBwyaYqXup0MJn7IzgiVHJx9nqL26W6tNNU6QsTAe9KVIGlboYBH/hLKwg+ucCK8/xvIdrIveRITwX7QCq3fv16/IPz8iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZN0sa3k+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-62a379a7c80so6458231a12.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 07:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716215283; x=1716820083; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXGyeFmV049bG/rdKD3bxiWZYyztqsFy6So8LtgL0Ko=;
        b=ZN0sa3k+x1UI8/wmulU2ql1pdhtG2w2fH8I3Y9tWqor66WfB3rOFwsqAa8I8OawQQD
         UlHvCLbKzSRXTtUb93yxPAXrqPmUQXg/7e13QMLeiz55oKPo5k+I8si+W1JbjoktkzMR
         XOxexX/Lkj+cwxM5DeZnImhleEkjfwMLzHqQ5hP9iF3sfq2sAuENOcajObjkJgBNs8R9
         4yWiv2fB3VVBc/MiHjO8QmV/9gTuYTDOtEnN4hht+n1tMGo9Bqfp5z4/yWJfMCyizwTB
         G3oRklTBMpwDzh7zgrCAW8yTre5xPYgZvXp2QvfZq8NTnNqDCmHSUxf7BllVdcDKrzin
         1jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716215283; x=1716820083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nXGyeFmV049bG/rdKD3bxiWZYyztqsFy6So8LtgL0Ko=;
        b=o/D2eW6/jqHXRg/8eZM+OOhXI3hIxzwdOVK0sgiVswfoKAziXgDkUdb7CDPVbvOMzF
         7KqcArcyT6VYy+YR4LlXcRr2xk2s4dvaKK6C9eAHWJAEzI8j7J3KMppc9LSSX5SYjkgw
         HGUrWHC096B9TCQr3Y0vjhIj7AmN7Wb30SxdEVe107MJLS+3K1DNVs2CZ1DNDlCqWGFG
         tMAglCYEpThK2K+xq9vX18qGac15c413hXPIOjfJkOdp4rD7EtztQEGSb4UZTG1XPJvQ
         tzUOvGHGXN6GpiOI6iuVD3spL9OO4R/Bf3knjEFn+bW4ta+wyZ+aRZl2W8Z0AX+bnfTv
         5oAA==
X-Forwarded-Encrypted: i=1; AJvYcCXyOi5cH8Nn1Jw6B6fryV6mop4lO74CLYwLDKjqr9hoYyTcKPSPbRjTDY5Ui7JY8dwzHnnvZk193fhoWHwzMrL5JTNp
X-Gm-Message-State: AOJu0YwNBCA0JJufB8TbkLVJWdgPAF3tsUm/Q5YbC9NgXghGErdyOPHq
	M05METf0FQ2wcE8/4lquucgO8pGrLGV6LEapZmsAKu/ErDwFG4Vzw49gfSHNfcrPLNJJohRZOUg
	B+w==
X-Google-Smtp-Source: AGHT+IEHUOdZt/IA0ae+qGmsAEodytRjzciCDWPhMs+k8WT2lUcpXmtWRif+sobSE6v7S2HItabPEMEFEBo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:450:b0:654:ef81:bd9a with SMTP id
 41be03b00d2f7-66467e67fe1mr23345a12.2.1716215282682; Mon, 20 May 2024
 07:28:02 -0700 (PDT)
Date: Mon, 20 May 2024 07:28:01 -0700
In-Reply-To: <20240520115334.852510-1-zhoushuling@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520115334.852510-1-zhoushuling@huawei.com>
Message-ID: <Zktd8QHU84_EdaNb@google.com>
Subject: Re: [PATCH] KVM: LAPIC: Fix an inversion error when a negative value
 assigned to lapic_timer.timer_advance_ns
From: Sean Christopherson <seanjc@google.com>
To: zhoushuling@huawei.com
Cc: pbonzini@redhat.com, weiqi4@huawei.com, wanpengli@tencent.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, May 20, 2024, zhoushuling@huawei.com wrote:
> From: Shuling Zhou <zhoushuling@huawei.com>
> 
> After 'commit 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns
> parameter overflow")',a negative value can be assigned to
> lapic_timer_advance_ns, when it is '-1', the kvm_create_lapic()
> will judge it and turns on adaptive tuning of timer advancement.
> However, when lapic_timer_advance_ns=-2, it will be assigned to
> an uint variable apic->lapic_timer.timer_advance_ns, the
> apic->lapic_timer.timer_advance_ns of each vCPU will become a huge
> value. When a VM is started, the VM is stuck in the
> "
> [    2.669717] ACPI: Core revision 20130517
> [    2.672378] ACPI: All ACPI Tables successfully acquired
> [    2.673309] ftrace: allocating 29651 entries in 116 pages
> [    2.698797] Enabling x2apic
> [    2.699431] Enabled x2apic
> [    2.700160] Switched APIC routing to physical x2apic.
> [    2.701644] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    2.702575] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8378A CPU @ 3.00GHz (fam: 06, model: 6a, stepping: 06)
> ..........
> "
> 
> 'Fixes: 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns
> parameter overflow")'

 Fixes: 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow")

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Signed-off-by: Shuling Zhou<zhoushuling@huawei.com>

There should be whitespace between your name and email.

> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ebf41023be38..5feeb889ddb6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2848,7 +2848,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	if (timer_advance_ns == -1) {
>  		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
>  		lapic_timer_advance_dynamic = true;
> -	} else {
> +	} else if (timer_advance_ns >= 0) {
>  		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  		lapic_timer_advance_dynamic = false;
>  	}

Wouldn't it be more appropriate to treat any negative value as "dynamic"?  The
comment above the module param also needs to be updated.

Oof, and lapic_timer_advance_dynamic is a global, which yields behavior that is
nearly impossible to document.  So I think we want this, over two patches?

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ebf41023be38..3a1bcfbe3e93 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -59,7 +59,6 @@
 #define MAX_APIC_VECTOR                        256
 #define APIC_VECTORS_PER_REG           32
 
-static bool lapic_timer_advance_dynamic __read_mostly;
 #define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100     /* clock cycles */
 #define LAPIC_TIMER_ADVANCE_ADJUST_MAX 10000   /* clock cycles */
 #define LAPIC_TIMER_ADVANCE_NS_INIT    1000
@@ -1854,7 +1853,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
        guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
        trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
 
-       if (lapic_timer_advance_dynamic) {
+       if (apic->lapic_timer.timer_advance_dynamic) {
                adjust_lapic_timer_advance(vcpu, guest_tsc - tsc_deadline);
                /*
                 * If the timer fired early, reread the TSC to account for the
@@ -2845,12 +2844,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
        hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
                     HRTIMER_MODE_ABS_HARD);
        apic->lapic_timer.timer.function = apic_timer_fn;
-       if (timer_advance_ns == -1) {
+       if (timer_advance_ns < 0) {
                apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
-               lapic_timer_advance_dynamic = true;
+               apic->lapic_timer.timer_advance_dynamic = true;
        } else {
                apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-               lapic_timer_advance_dynamic = false;
+               apic->lapic_timer.timer_advance_dynamic = false;
        }
 
        /*
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..6fb3b16a2754 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -54,6 +54,7 @@ struct kvm_timer {
        u32 timer_advance_ns;
        atomic_t pending;                       /* accumulated triggered timers */
        bool hv_timer_in_use;
+       bool timer_advance_dynamic;
 };
 
 struct kvm_lapic {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2b62169e09a..60e86607056e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -165,10 +165,11 @@ static u32 __read_mostly tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, 0644);
 
 /*
- * lapic timer advance (tscdeadline mode only) in nanoseconds.  '-1' enables
- * adaptive tuning starting from default advancement of 1000ns.  '0' disables
- * advancement entirely.  Any other value is used as-is and disables adaptive
- * tuning, i.e. allows privileged userspace to set an exact advancement time.
+ * lapic timer advance (tscdeadline mode only) in nanoseconds.  Any negative
+ * value enable adaptive tuning starting from default advancement of 1000ns.
+ * '0' disables advancement entirely.  Any postive value is used as-is and
+ * disables adaptive tuning, i.e. allows privileged userspace to set an exact
+ * advancement time.
  */
 static int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, 0644);


