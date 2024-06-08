Return-Path: <kvm+bounces-19104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E124C900EA8
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:07:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F1B6B23B0A
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FB679FD;
	Sat,  8 Jun 2024 00:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MGqZACxm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC992579
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805208; cv=none; b=cy1qNeZ4YGCIo7++E+oav5gtSMupqUfGQtEu7h2cP7aZLADCToqjxgpAXMoslGk4wWqWbRw/Bd7iYXVUCv1f2VjqZiAvtBTzbTzFSRyTpcsR0Hso3RoR4rC/bZuzO/1EQ1XscviDIP/ADYYurzYyyIPEa9uMrqOVyS/PAmAtKas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805208; c=relaxed/simple;
	bh=Z9cQiqCM7hbNpA06nsciQ9usUI929x4+2L/O+6mKe9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZW66VbMu0z6ZLWz/ROCz0uigzsySZaRWuMmL4wpNgaSMIsGVRAExsHpYOKyVS/l6/X5/5K8vknCqaFR0OZQh3LVrnmPlbF36LtV3XJNWlYwtu/3R9pYaUJ2LsF93t/iqAaNxrpLa3tbg8k9/5jeIWjs8dA4ddt0+dRcbTXp4sX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MGqZACxm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c1aa8d19bbso2401513a91.2
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805206; x=1718410006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7jRC7mrAmyRprGwM6jxI+f+KhszVr6gb5pmkxB7ZXA=;
        b=MGqZACxmOzh0Pjd17d6bvLahP7/oDnheITmyAsszZhDex11lRdsoRAAr6wVIjkkYT/
         vuZvEK2luMj47NGCW69HiFdMnlBJNbi+gDse+Uk/5OtUcV4ABqpWaEX6j0vJnHO3lFG6
         UVjsEYHsFnQCTdM+qXbbzpT6DFuFs5KRRWagrC5zTPWbHLVP1Wtcu1EAYGxoBuA7JZpz
         3a6nRVvWfXmIkvP+7HJtXbqiKL86y/F0Ax+SjOii8YC8Q6W/PzdQQBbEMx0JR42Zja5s
         lnG0dwa4+qHaEBkJ0sguM+fTsia1OaasdrBtxsVr+V6XZaOqBBZ9HFR//tE+KdtOwyFO
         xIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805206; x=1718410006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y7jRC7mrAmyRprGwM6jxI+f+KhszVr6gb5pmkxB7ZXA=;
        b=YbGL3D1uixmh0hwY5rn6dhkiPtPZrxiafAm7mULFM/9HeeSi5s8+lvnDVW1l+8f+NL
         T9bhTtd8HLZaNYzHD0ufdy2N+4atCIAIUShnuJ0pyF6O2z2l10YmKQ6UKqEWHiyriiQB
         Eq1Dw2rfDA/b2wZIy3cfQzqFrrNAvREqLkXnfq+ef3e/k/+67E5+GKvHvmE7BEYYfAuU
         plTihXibOwscTJclbi9gjFJaq4P9fYppKlZyu2WOXQQcAFD3x+LdAFlynaRbTRS4rkH/
         k+NsCKjPHrZSWcpCZ3dyiQSXbSEiPEKJqPiNdGhyDfo0nOrwQxLoCHgkfvlSled4mv3e
         k8fA==
X-Gm-Message-State: AOJu0Yyu5RC31ZY7FDynf8iDUQ0lh8wUhNOLHJ2ih4RoVOBhWw7E5jEj
	OayAv6it8qBFonLlpRHLSoYpGmqu9xPe7OhX/NBObr2IhT2aPXwQ4NyCdeslYbvCEXkON0gwPmw
	tyg==
X-Google-Smtp-Source: AGHT+IFf695AOM2a+ignEkEKz7vbC9tOTvuHErDOawu22pUXoiH1M2cUxhsxJpINQZK9PHGRZkrPmcj7XLA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ed03:b0:2bd:e2fd:a089 with SMTP id
 98e67ed59e1d1-2c2bc79dd1cmr9867a91.0.1717805205652; Fri, 07 Jun 2024 17:06:45
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:06:33 -0700
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000639.3295768-3-seanjc@google.com>
Subject: [PATCH v3 2/8] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Register KVM's cpuhp and syscore callback when enabling virtualization
in hardware instead of registering the callbacks during initialization,
and let the CPU up/down framework invoke the inner enable/disable
functions.  Registering the callbacks during initialization makes things
more complex than they need to be, as KVM needs to be very careful about
handling races between enabling CPUs being onlined/offlined and hardware
being enabled/disabled.

Intel TDX support will require KVM to enable virtualization during KVM
initialization, i.e. will add another wrinkle to things, at which point
sorting out the potential races with kvm_usage_count would become even
more complex.

Note, using the cpuhp framework has a subtle behavioral change: enabling
will be done serially across all CPUs, whereas KVM currently sends an IPI
to all CPUs in parallel.  While serializing virtualization enabling could
create undesirable latency, the issue is limited to creation of KVM's
first VM, and even that can be mitigated, e.g. by letting userspace force
virtualization to be enabled when KVM is initialized.

Cc: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 174 ++++++++++++++++----------------------------
 1 file changed, 61 insertions(+), 113 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9b0579d3eea..f6b114f42433 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5502,7 +5502,7 @@ static DEFINE_PER_CPU(bool, hardware_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
-static int __hardware_enable_nolock(void)
+static int hardware_enable_nolock(void)
 {
 	if (__this_cpu_read(hardware_enabled))
 		return 0;
@@ -5517,34 +5517,18 @@ static int __hardware_enable_nolock(void)
 	return 0;
 }
 
-static void hardware_enable_nolock(void *failed)
-{
-	if (__hardware_enable_nolock())
-		atomic_inc(failed);
-}
-
 static int kvm_online_cpu(unsigned int cpu)
 {
-	int ret = 0;
-
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	mutex_lock(&kvm_usage_lock);
-	if (kvm_usage_count)
-		ret = __hardware_enable_nolock();
-	mutex_unlock(&kvm_usage_lock);
-	return ret;
+	return hardware_enable_nolock();
 }
 
 static void hardware_disable_nolock(void *junk)
 {
-	/*
-	 * Note, hardware_disable_all_nolock() tells all online CPUs to disable
-	 * hardware, not just CPUs that successfully enabled hardware!
-	 */
 	if (!__this_cpu_read(hardware_enabled))
 		return;
 
@@ -5555,78 +5539,10 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	mutex_lock(&kvm_usage_lock);
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
-	mutex_unlock(&kvm_usage_lock);
+	hardware_disable_nolock(NULL);
 	return 0;
 }
 
-static void hardware_disable_all_nolock(void)
-{
-	BUG_ON(!kvm_usage_count);
-
-	kvm_usage_count--;
-	if (!kvm_usage_count)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
-}
-
-static void hardware_disable_all(void)
-{
-	cpus_read_lock();
-	mutex_lock(&kvm_usage_lock);
-	hardware_disable_all_nolock();
-	mutex_unlock(&kvm_usage_lock);
-	cpus_read_unlock();
-}
-
-static int hardware_enable_all(void)
-{
-	atomic_t failed = ATOMIC_INIT(0);
-	int r;
-
-	/*
-	 * Do not enable hardware virtualization if the system is going down.
-	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
-	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
-	 * after kvm_reboot() is called.  Note, this relies on system_state
-	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
-	 * hook instead of registering a dedicated reboot notifier (the latter
-	 * runs before system_state is updated).
-	 */
-	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
-	    system_state == SYSTEM_RESTART)
-		return -EBUSY;
-
-	/*
-	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
-	 * is called, and so on_each_cpu() between them includes the CPU that
-	 * is being onlined.  As a result, hardware_enable_nolock() may get
-	 * invoked before kvm_online_cpu(), which also enables hardware if the
-	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
-	 * enable hardware multiple times.
-	 */
-	cpus_read_lock();
-	mutex_lock(&kvm_usage_lock);
-
-	r = 0;
-
-	kvm_usage_count++;
-	if (kvm_usage_count == 1) {
-		on_each_cpu(hardware_enable_nolock, &failed, 1);
-
-		if (atomic_read(&failed)) {
-			hardware_disable_all_nolock();
-			r = -EBUSY;
-		}
-	}
-
-	mutex_unlock(&kvm_usage_lock);
-	cpus_read_unlock();
-
-	return r;
-}
-
 static void kvm_shutdown(void)
 {
 	/*
@@ -5658,8 +5574,7 @@ static int kvm_suspend(void)
 	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
+	hardware_disable_nolock(NULL);
 	return 0;
 }
 
@@ -5668,8 +5583,7 @@ static void kvm_resume(void)
 	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
-	if (kvm_usage_count)
-		WARN_ON_ONCE(__hardware_enable_nolock());
+	WARN_ON_ONCE(hardware_enable_nolock());
 }
 
 static struct syscore_ops kvm_syscore_ops = {
@@ -5677,6 +5591,60 @@ static struct syscore_ops kvm_syscore_ops = {
 	.resume = kvm_resume,
 	.shutdown = kvm_shutdown,
 };
+
+static int hardware_enable_all(void)
+{
+	int r;
+
+	guard(mutex)(&kvm_usage_lock);
+
+	if (kvm_usage_count++)
+		return 0;
+
+	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
+			      kvm_online_cpu, kvm_offline_cpu);
+	if (r)
+		goto err_cpuhp;
+
+	register_syscore_ops(&kvm_syscore_ops);
+
+	/*
+	 * Undo virtualization enabling and bail if the system is going down.
+	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
+	 * possible for an in-flight operation to enable virtualization after
+	 * syscore_shutdown() is called, i.e. without kvm_shutdown() being
+	 * invoked.  Note, this relies on system_state being set _before_
+	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
+	 * or this CPU observes the impending shutdown.  Which is why KVM uses
+	 * a syscore ops hook instead of registering a dedicated reboot
+	 * notifier (the latter runs before system_state is updated).
+	 */
+	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
+	    system_state == SYSTEM_RESTART) {
+		r = -EBUSY;
+		goto err_rebooting;
+	}
+
+	return 0;
+
+err_rebooting:
+	unregister_syscore_ops(&kvm_syscore_ops);
+	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
+err_cpuhp:
+	--kvm_usage_count;
+	return r;
+}
+
+static void hardware_disable_all(void)
+{
+	guard(mutex)(&kvm_usage_lock);
+
+	if (--kvm_usage_count)
+		return;
+
+	unregister_syscore_ops(&kvm_syscore_ops);
+	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
+}
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 static int hardware_enable_all(void)
 {
@@ -6382,15 +6350,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	int r;
 	int cpu;
 
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
-				      kvm_online_cpu, kvm_offline_cpu);
-	if (r)
-		return r;
-
-	register_syscore_ops(&kvm_syscore_ops);
-#endif
-
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);
@@ -6401,10 +6360,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 					   offsetofend(struct kvm_vcpu, stats_id)
 					   - offsetof(struct kvm_vcpu, arch),
 					   NULL);
-	if (!kvm_vcpu_cache) {
-		r = -ENOMEM;
-		goto err_vcpu_cache;
-	}
+	if (!kvm_vcpu_cache)
+		return -ENOMEM;
 
 	for_each_possible_cpu(cpu) {
 		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
@@ -6461,11 +6418,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
-err_vcpu_cache:
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-	unregister_syscore_ops(&kvm_syscore_ops);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-#endif
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
@@ -6487,10 +6439,6 @@ void kvm_exit(void)
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-	unregister_syscore_ops(&kvm_syscore_ops);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-#endif
 	kvm_irqfd_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-- 
2.45.2.505.gda0bf45e8d-goog


