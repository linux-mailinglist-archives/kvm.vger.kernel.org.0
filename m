Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DEE4C47EE
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiBYOxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbiBYOxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:53:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0834216BCF9;
        Fri, 25 Feb 2022 06:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ppR3G1TJMdrYnEqs138ZAhJnbyaBVIHQNFEmxoMFDFs=; b=f6SnRY3u3JlszVtA6NQz35UnZY
        NJsjUO/LUA2IEHspL5GOBmnJuujqNyQefbOS2h6sYDcw98GY1E+tGFOci3bYeD5yH7/cfEtTYwx4N
        fhqaNRAj6q5Z6SA7mytw/Hp1OJgSjnGymCuxYj2aAxvg+jwKNKdnIHIu0nwV6eBk5QN9fBy8J4JRV
        TweI1Futdw579lbS7w+S+z0VBPSuHkEX3zutkCZ62l8WxnFJSKTaQuyeZMTJvOnl9wdh7JOwMNd5P
        J4zA4QYwPGKBOzTe5ffaWmbpebecV25Kbffx85VHffViPGErJDyAPK20RpJ7XJIW+XmKnuGU9/vjY
        3IUTku8Q==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxy-005rrx-IX; Fri, 25 Feb 2022 14:53:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxx-0009Ph-Rp; Fri, 25 Feb 2022 14:53:05 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
Subject: [PATCH 2/3] KVM: x86: Don't snapshot "max" TSC if host TSC is constant
Date:   Fri, 25 Feb 2022 14:53:03 +0000
Message-Id: <20220225145304.36166-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220225145304.36166-1-dwmw2@infradead.org>
References: <20220225145304.36166-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Don't snapshot tsc_khz into max_tsc_khz during KVM initialization if the
host TSC is constant, in which case the actual TSC frequency will never
change and thus capturing the "max" TSC during initialization is
unnecessary, KVM can simply use tsc_khz during VM creation.

On CPUs with constant TSC, but not a hardware-specified TSC frequency,
snapshotting max_tsc_khz and using that to set a VM's default TSC
frequency can lead to KVM thinking it needs to manually scale the guest's
TSC if refining the TSC completes after KVM snapshots tsc_khz.  The
actual frequency never changes, only the kernel's calculation of what
that frequency is changes.  On systems without hardware TSC scaling, this
either puts KVM into "always catchup" mode (extremely inefficient), or
prevents creating VMs altogether.

Ideally, KVM would not be able to race with TSC refinement, or would have
a hook into tsc_refine_calibration_work() to get an alert when refinement
is complete.  Avoiding the race altogether isn't practical as refinement
takes a relative eternity; it's deliberately put on a work queue outside
of the normal boot sequence to avoid unnecessarily delaying boot.

Adding a hook is doable, but somewhat gross due to KVM's ability to be
built as a module.  And if the TSC is constant, which is likely the case
for every VMX/SVM-capable CPU produced in the last decade, the race can
be hit if and only if userspace is able to create a VM before TSC
refinement completes; refinement is slow, but not that slow.

For now, punt on a proper fix, as not taking a snapshot can help some
uses cases and not taking a snapshot is arguably correct irrespective of
the race with refinement.

[ dwmw2: Rebase on top of KVM-wide default_tsc_khz to ensure that all
         vCPUs get the same frequency even if we hit the race. ]

Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Anton Romanov <romanton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb3e9916229a..04f86cb94069 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8751,22 +8751,22 @@ static int kvmclock_cpu_online(unsigned int cpu)
 
 static void kvm_timer_init(void)
 {
-	max_tsc_khz = tsc_khz;
-
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
-#ifdef CONFIG_CPU_FREQ
-		struct cpufreq_policy *policy;
-		int cpu;
-
-		cpu = get_cpu();
-		policy = cpufreq_cpu_get(cpu);
-		if (policy) {
-			if (policy->cpuinfo.max_freq)
-				max_tsc_khz = policy->cpuinfo.max_freq;
-			cpufreq_cpu_put(policy);
+		max_tsc_khz = tsc_khz;
+
+		if (IS_ENABLED(CONFIG_CPU_FREQ)) {
+			struct cpufreq_policy *policy;
+			int cpu;
+
+			cpu = get_cpu();
+			policy = cpufreq_cpu_get(cpu);
+			if (policy) {
+				if (policy->cpuinfo.max_freq)
+					max_tsc_khz = policy->cpuinfo.max_freq;
+				cpufreq_cpu_put(policy);
+			}
+			put_cpu();
 		}
-		put_cpu();
-#endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 	}
@@ -11637,7 +11637,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	pvclock_update_vm_gtod_copy(kvm);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
-	kvm->arch.default_tsc_khz = max_tsc_khz;
+	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-- 
2.33.1

