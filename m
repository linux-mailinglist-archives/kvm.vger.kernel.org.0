Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4769C4E749C
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358970AbiCYOBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 10:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358899AbiCYOBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 10:01:08 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B88606CA;
        Fri, 25 Mar 2022 06:59:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g9-20020a17090ace8900b001c7cce3c0aeso3597732pju.2;
        Fri, 25 Mar 2022 06:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zFHRAV31Ch1tp+2iNpA7ALNISwTJjRRUfUkhPuq13Zo=;
        b=Cu4xcWiyozPIH5KA4agN/rdwpv5i8VxFgBjItP6j8wz9TTGY2XuJfrGQw+GTMtCW9T
         /ORB7tR1sdl/Q2caWDHAQLD00WcfLj/Q606h4CIpEdO2KXSfZ9epi8QKsbG4RrC27HCW
         3bcl81VVQeIQU2umHw3Ml2DfmM9cksdbbAXFKXmAVCYkOjZUbl8WR/SoKc3xHU0i/42Z
         qNfFvvi8PJNXfrH9OZYWGhsUPsdWgKVzeXvo+qiDoC1NHkGRcUiMWqov+A8N+zmYPMvN
         pReCRc0a1pUtGV3hu6WFntKrJ/dt5aL5paVw+ZjZUcCKD5WEcyr7E4+H3R6phBGZCNmb
         NX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zFHRAV31Ch1tp+2iNpA7ALNISwTJjRRUfUkhPuq13Zo=;
        b=YWRaIob8XCMvb8TyPiyEwR/IQPB5SnxSoM/QJ9EgglA5mclhAL20D/hD3ab5iV4Mkt
         dM13p00ITYXkLmgoTM38h4wsfcwO4x+PzXLL1powV6P7mA+RjIQ5i+frQ/O5li1v9A+S
         XmA44ZLpILVgUhYGAmTzH7R3Zjkfpw6hWVdbaDNqss1L8JzgaGXXgTpmST2XKnG8BHuD
         bIYQepicZHtSq8o5uMkZC7K6/KDUPab1Xy4cg2uFR6GmTFjJII2S7Os/IC6O32OGG79q
         gugVlmciZnk2LHNvFXlAjYiWMCHSx0+O2H9Dx+8+4fYg+njkMuVltBe4VKElur3YlPjM
         wm+g==
X-Gm-Message-State: AOAM5305/nHeDuhksIINso8nrjFJjjEf2KPxHPu1H3IBnNKp98wjwfei
        CFE86V35fsucKpkrHwaWKYlWWFsVusM=
X-Google-Smtp-Source: ABdhPJwLEuM4gsxnbwwEPABdOHYRI14l6NbAdRqXSGJjqYX+3gfuV43mgriZl0bNGYiGc+e7x+iErg==
X-Received: by 2002:a17:90b:1809:b0:1c7:2032:4b34 with SMTP id lw9-20020a17090b180900b001c720324b34mr25034960pjb.4.1648216772580;
        Fri, 25 Mar 2022 06:59:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id lw4-20020a17090b180400b001c7327d09c3sm14470875pjb.53.2022.03.25.06.59.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:59:32 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 3/5] KVM: X86: Boost vCPU which is in critical section
Date:   Fri, 25 Mar 2022 06:58:27 -0700
Message-Id: <1648216709-44755-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The missing semantic gap that occurs when a guest OS is preempted 
when executing its own critical section, this leads to degradation 
of application scalability. We try to bridge this semantic gap in 
some ways, by passing guest preempt_count to the host and checking 
guest irq disable state, the hypervisor now knows whether guest 
OSes are running in the critical section, the hypervisor yield-on-spin 
heuristics can be more smart this time to boost the vCPU candidate 
who is in the critical section to mitigate this preemption problem, 
in addition, it is more likely to be a potential lock holder.

Testing on 96 HT 2 socket Xeon CLX server, with 96 vCPUs VM 100GB RAM,
one VM running benchmark, the other(none-2) VMs running cpu-bound 
workloads, There is no performance regression for other benchmarks 
like Unixbench etc.

1VM
            vanilla    optimized    improved

hackbench -l 50000
              28         21.45        30.5%
ebizzy -M
             12189       12354        1.4%
dbench
             712 MB/sec  722 MB/sec   1.4%

2VM:
            vanilla    optimized    improved

hackbench -l 10000
              29.4        26          13%
ebizzy -M
             3834        4033          5%
dbench
           42.3 MB/sec  44.1 MB/sec   4.3%

3VM:
            vanilla    optimized    improved

hackbench -l 10000
              47         35.46        33%
ebizzy -M
	     3828        4031         5%
dbench 
           30.5 MB/sec  31.16 MB/sec  2.3%

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c       | 22 ++++++++++++++++++++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  7 +++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 425fd7f38fa9..6b300496bbd0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10375,6 +10375,28 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int kvm_vcpu_non_preemptable(struct kvm_vcpu *vcpu)
+{
+	int count;
+
+	if (!vcpu->arch.pv_pc.preempt_count_enabled)
+		return 0;
+
+	if (!kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_pc.preempt_count_cache,
+	    &count, sizeof(int)))
+		return (count & ~PREEMPT_NEED_RESCHED);
+
+	return 0;
+}
+
+bool kvm_arch_boost_candidate(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.irq_disabled || kvm_vcpu_non_preemptable(vcpu))
+		return true;
+
+	return false;
+}
+
 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
 	int r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..9f1a7d9540de 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1428,6 +1428,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_boost_candidate(struct kvm_vcpu *vcpu);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9581a24c3d17..ee5a788892e0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3545,6 +3545,11 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool __weak kvm_arch_boost_candidate(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
@@ -3580,6 +3585,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
 			    !kvm_arch_vcpu_in_kernel(vcpu))
 				continue;
+			if (!kvm_arch_boost_candidate(vcpu))
+				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
 
-- 
2.25.1

