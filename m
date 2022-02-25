Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67324C3B14
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 02:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiBYBkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 20:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiBYBkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 20:40:02 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2807F28B61D
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:39:32 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id d9-20020a630e09000000b00374105253b2so1884725pgl.0
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=lsIVxLdUn9+kqKlthczBNmMV4Jfo8iVsWw07MsiBzFo=;
        b=S1KhSS0YRiaedP0dpkuo9CSOauVYjzsqSwrDB7U8+wO9GIVphEwKYGjbx4XBYymstD
         e0Q9KgXKyhZyhkAyN6VqAFzFD7Mb34VbZAF+GDrvLpwpvXzyr5d9KyrvU6bIIwkUriHN
         s/5HWFK1Ui8qJr/+eTC8OfLBVChIHwmRQAB5S8JAdfzAeC0rMhAXkBMRTVKgmCPq/pYm
         nxys78/POUfQ9ThDbgsaMyjINh4xQu62bSuPcsl8elaL0CG1EAfNiazDHAaE2UBp2nnM
         nr8HywrRNUmOm0lYa021CQd6WBjeGL3sDpnIPSVp+PjnZ85vBm/8IEoUgKDiQXsb4jbG
         luxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=lsIVxLdUn9+kqKlthczBNmMV4Jfo8iVsWw07MsiBzFo=;
        b=0563i0di+eeEOAQxe38Wkhou/OIpTBr6XW209ghUGMyy0vIKS6CTiWVLgMLft0mnAC
         LASj5o8HVke0wV7RVNkXfpoc9w8WTJdfupwl0DV+pj5uq2trjCaUkzKhXn4DscgfPIaX
         8uMNVmlRIwlSG25blRfitU4ptykfCF9c7uHVvx1JJ7/lJCx5x/ck9ntBSSpSG5fRg8WQ
         oaUO2ORVMvR8Hcgr0IfzN/rk75EkEg5D97pQMb7Q4tsAYGKdsb0Zi5AKNhSuOVBANYnU
         1agw7sitd32OVc9vKP0BZk/5oNlUAeZowSG0mzwaMPMsamwbzHsTWTgPcRRMJqvxGW/r
         NqFQ==
X-Gm-Message-State: AOAM531vcqqhzzV/A4IQ6u/+vcnR/k8Jf3JhbGpMYM9qh5K4+Am9d3PV
        l/S0unyfzUqjjiFXXAhqE0eiUkCQuGg=
X-Google-Smtp-Source: ABdhPJxthNBm8xeMjBejGNjZhtAPusW151AX+qp4ccNqPhw0xRMdnSW1ZqJrQRd4Lv/wPI98qL9BTJjlf0M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f505:b0:1bc:d47e:8b19 with SMTP id
 cs5-20020a17090af50500b001bcd47e8b19mr856714pjb.102.1645753171649; Thu, 24
 Feb 2022 17:39:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 01:39:29 +0000
Message-Id: <20220225013929.3577699-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH] KVM: x86: Don't snapshot "max" TSC if host TSC is constant
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Anton Romanov <romanton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6552360d8888..81d9d84dc59f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8727,13 +8727,15 @@ static int kvmclock_cpu_online(unsigned int cpu)
 
 static void kvm_timer_init(void)
 {
-	max_tsc_khz = tsc_khz;
-
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 #ifdef CONFIG_CPU_FREQ
 		struct cpufreq_policy *policy;
 		int cpu;
+#endif
 
+		max_tsc_khz = tsc_khz;
+
+#ifdef CONFIG_CPU_FREQ
 		cpu = get_cpu();
 		policy = cpufreq_cpu_get(cpu);
 		if (policy) {
@@ -11160,7 +11162,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
+	kvm_set_tsc_khz(vcpu, max_tsc_khz ? : tsc_khz);
 	kvm_vcpu_reset(vcpu, false);
 	kvm_init_mmu(vcpu);
 	vcpu_put(vcpu);

base-commit: f4bc051fc91ab9f1d5225d94e52d369ef58bec58
-- 
2.35.1.574.g5d30c73bfb-goog

