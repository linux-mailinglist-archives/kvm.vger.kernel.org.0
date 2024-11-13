Return-Path: <kvm+bounces-31823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF5C9C7EFD
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:56:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 294BD2845F6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 23:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D17E18D634;
	Wed, 13 Nov 2024 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eLAY1U3X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A118BB82
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 23:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731542188; cv=none; b=Z9bh35EkCDjtIMNePZxWtx9qatPOqDpp1T9ujjFRQBP+XawhXcdfkIeX4C3ikI54eS+6F7/yDb7ehCvXY1+NOBepoT5dRD6RX3HxmBc4t6A3CE/jJy0s75MTs9wqY7/2pyImm1Ma+6e6zJTW0ngOki5Z/Mgt4Yits5q5B/gy24Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731542188; c=relaxed/simple;
	bh=NonNEb/p36N4aNw8pMOp1DVBkj1VagGzEXC4C3d0/os=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UytJBujGZ2tVSSRZP64aQfngPJuG0fJ3TAV+oV48KHq900R91v+FSGWOTT86mhhyFoDv41zgfHTj9j37q3QgFEWWqQbFuj3vI27zXvI8pmbA5pFZIQ1SNyi58jpAc9DwVQh/66OXOPM8k9OLhDLkOLrU1IpegBtjC0R8tDFrNaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eLAY1U3X; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2118b20e83aso35ad.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 15:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731542186; x=1732146986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vr5S5GUuRLNtWM92jKG2I81mlCSBw1utW8NJkCQ7Lb8=;
        b=eLAY1U3X2YSTNXQr/Kfk9eZFfUFj6DYoKTBx7PHrh3ybxcVbME2fSPrfEf4sG8MnZ0
         6fokLZyS6oNZ19exrkgU81JVSzf+tl+AyEPi3WWQ/AeXvLO20elNvh7a0SvDvmYc1sd7
         aH2SYqWEA7XNOv3EiyyhxNh6HQQd1F/A2mQOAEOZjvsgezqijKpxeEZMDjt93krpKiYv
         /8GD07vk19KQaZyvV5uUzfOZrpU0jWGDOmgllppDFd4l4XlAfNV4TOpKdg4/r3eSDWi2
         ZI6jEtRZomZ1MZr96bZNA7TG34JqPSI9dC8Id4fwMhhoY9uV1PxKsjg/mzf+BTe+k4Uv
         213A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731542186; x=1732146986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vr5S5GUuRLNtWM92jKG2I81mlCSBw1utW8NJkCQ7Lb8=;
        b=C6+h+xijoL3o+gZ8oyS5/s4A9oROzJVzuis1V9ZVT/HWAQh19Otjg1A8iJGyc0m33G
         YcBcXUvdxhd4IPTNNWm4oTa9XLUi8pvUtlljYJ7VsFdQgjQemzUmbLw2nqEaZGlZYGhx
         U1w/a5c7esag3yJo/wQiT1LnfKeJSh+2Sa642wqnyWJfTo036mqpnLHU3UA7gkP2Jm07
         1TGiS0qly8d9gbqceKy0nLuhzuxfuuJlkyYspF5KxH6mmBpx+ajmecZPXjStUFG2kSuc
         Pdqii7o/3gjqG1jQmvJ1ZUPhSF2nDWqOaa/5Bb02+6hkBAhF2OoYNLODmYhG4cQk5++M
         C1wg==
X-Forwarded-Encrypted: i=1; AJvYcCW8MK3kSdZJRhtRJU/JnAmOrc+u6teT6c6Ll5EPTeXXHwtBi90XzfA6m0JupAFQXG93mFE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4x6WNveJvvAuBFdK3eHka9BuCBV+FbnqqRFYT15pIWLv860lO
	2EAqtYQUF2y2oC6SJNxQA9AfvqKqdJQuGWWhXy5tErP45yiDllLzo0E9DnJk6DFB1vkIJTT0vl8
	Zeg==
X-Google-Smtp-Source: AGHT+IEn0Egc9e+jdjdcl5p3lcxUZPaJq7jsZW0myyVy6Dwg4xCLPAlzYX1BQwwv9eyILE9wT9IYH/2e6DA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:e20b:b0:20c:857b:5dcb with SMTP id
 d9443c01a7336-211835150d4mr863225ad.4.1731542186557; Wed, 13 Nov 2024
 15:56:26 -0800 (PST)
Date: Wed, 13 Nov 2024 15:56:25 -0800
In-Reply-To: <20241108130737.126567-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com>
Message-ID: <ZzU8qY92Q2QNtuyg@google.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 08, 2024, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8e853a5fc867..d5af4f8c5a6a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7281,7 +7281,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  			kvm_mmu_zap_all_fast(kvm);
>  			mutex_unlock(&kvm->slots_lock);
>  
> -			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
> +			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
>  		}
>  		mutex_unlock(&kvm_lock);
>  	}
> @@ -7427,7 +7427,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  		mutex_lock(&kvm_lock);
>  
>  		list_for_each_entry(kvm, &vm_list, vm_list)
> -			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
> +			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
>  
>  		mutex_unlock(&kvm_lock);
>  	}
> @@ -7530,62 +7530,65 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  	srcu_read_unlock(&kvm->srcu, rcu_idx);
>  }
>  
> -static long get_nx_huge_page_recovery_timeout(u64 start_time)
> +#define NX_HUGE_PAGE_DISABLED (-1)

I don't see any point in using -1.  That's more legal (though still impossible
and absurd) than an deadline of '0'.  And it's somewhat confusing because KVM
uses -1 for the default nx_huge_pages value to indicate "enable the NX huge page
mitigation if the CPU is vulnerable to L1TF", not "disable the mitigation".

> +static u64 get_nx_huge_page_recovery_next(void)
>  {
>  	bool enabled;
>  	uint period;
>  
>  	enabled = calc_nx_huge_pages_recovery_period(&period);
>  
> -	return enabled ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
> -		       : MAX_SCHEDULE_TIMEOUT;
> +	return enabled ? get_jiffies_64() + msecs_to_jiffies(period)
> +		: NX_HUGE_PAGE_DISABLED;

Please align the '?' and ':' to show that they are related paths of the ternary
operator.  Moot point if we go without a literal '0'.

>  }
>  
> -static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
> +static void kvm_nx_huge_page_recovery_worker_kill(void *data)
>  {
> -	u64 start_time;
> +}
> +
> +static bool kvm_nx_huge_page_recovery_worker(void *data)
> +{
> +	struct kvm *kvm = data;
>  	long remaining_time;
>  
> -	while (true) {
> -		start_time = get_jiffies_64();
> -		remaining_time = get_nx_huge_page_recovery_timeout(start_time);
> +	if (kvm->arch.nx_huge_page_next == NX_HUGE_PAGE_DISABLED)
> +		return false;

The "next" concept is broken.  Once KVM sees NX_HUGE_PAGE_DISABLED for a given VM,
KVM will never re-evaluate nx_huge_page_next.  Similarly, if the recovery period
and/or ratio changes, KVM won't recompute the "next" time until the current timeout
has expired.

I fiddled around with various ideas, but I don't see a better solution that something
along the lines of KVM's request system, e.g. set a bool to indicate the params
changed, and sprinkle smp_{r,w}mb() barriers to ensure the vhost task sees the
new params.

FWIW, I also found "next" to be confusing.  How about "deadline"? KVM uses that
terminology for the APIC timer, i.e. it's familiar, intuitive, and accurate(ish).

Something like this as fixup?  (comments would be nice)

---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/mmu/mmu.c          | 34 +++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 72f3bcfc54d7..e9fb8b9a9c2b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1444,7 +1444,8 @@ struct kvm_arch {
 
 	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
 	struct vhost_task *nx_huge_page_recovery_thread;
-	u64 nx_huge_page_next;
+	u64 nx_huge_page_deadline;
+	bool nx_huge_page_params_changed;
 
 #ifdef CONFIG_X86_64
 	/* The number of TDP MMU pages across all roots. */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d0c2d9d2588f..acfa14d4248b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7102,6 +7102,13 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static void mmu_wake_nx_huge_page_task(struct kvm *kvm)
+{
+	smp_wmb();
+	WRITE_ONCE(kvm->arch.nx_huge_page_deadline, true);
+	vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+}
+
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
 {
 	if (nx_hugepage_mitigation_hard_disabled)
@@ -7162,7 +7169,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			mmu_wake_nx_huge_page_task(kvm);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -7291,7 +7298,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			mmu_wake_nx_huge_page_task(kvm);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -7394,17 +7401,14 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-#define NX_HUGE_PAGE_DISABLED (-1)
-
-static u64 get_nx_huge_page_recovery_next(void)
+static u64 get_nx_huge_page_recovery_deadline(void)
 {
 	bool enabled;
 	uint period;
 
 	enabled = calc_nx_huge_pages_recovery_period(&period);
 
-	return enabled ? get_jiffies_64() + msecs_to_jiffies(period)
-		: NX_HUGE_PAGE_DISABLED;
+	return enabled ? get_jiffies_64() + msecs_to_jiffies(period) : 0;
 }
 
 static void kvm_nx_huge_page_recovery_worker_kill(void *data)
@@ -7416,10 +7420,16 @@ static bool kvm_nx_huge_page_recovery_worker(void *data)
 	struct kvm *kvm = data;
 	long remaining_time;
 
-	if (kvm->arch.nx_huge_page_next == NX_HUGE_PAGE_DISABLED)
+	if (READ_ONCE(kvm->arch.nx_huge_page_params_changed)) {
+		smp_rmb();
+		WRITE_ONCE(kvm->arch.nx_huge_page_params_changed, false);
+		kvm->arch.nx_huge_page_deadline = get_nx_huge_page_recovery_deadline();
+	}
+
+	if (!kvm->arch.nx_huge_page_deadline)
 		return false;
 
-	remaining_time = kvm->arch.nx_huge_page_next - get_jiffies_64();
+	remaining_time = kvm->arch.nx_huge_page_deadline - get_jiffies_64();
 	if (remaining_time > 0) {
 		schedule_timeout(remaining_time);
 		/* check for signals and come back */
@@ -7428,7 +7438,7 @@ static bool kvm_nx_huge_page_recovery_worker(void *data)
 
 	__set_current_state(TASK_RUNNING);
 	kvm_recover_nx_huge_pages(kvm);
-	kvm->arch.nx_huge_page_next = get_nx_huge_page_recovery_next();
+	kvm->arch.nx_huge_page_deadline = get_nx_huge_page_recovery_deadline();
 	return true;
 }
 
@@ -7437,11 +7447,11 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
 
-	kvm->arch.nx_huge_page_next = get_nx_huge_page_recovery_next();
+	WRITE_ONCE(kvm->arch.nx_huge_page_params_changed, true);
 	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
 		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
 		kvm, "kvm-nx-lpage-recovery");
-	
+
 	if (!kvm->arch.nx_huge_page_recovery_thread)
 		return -ENOMEM;
 

base-commit: 922a5630cd31e4414f964aa64f45a5884f40188c
--

