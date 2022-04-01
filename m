Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E1A4EE991
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344282AbiDAINZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344267AbiDAIM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:12:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26A0208C28;
        Fri,  1 Apr 2022 01:11:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bx5so1756142pjb.3;
        Fri, 01 Apr 2022 01:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xXAykXWGOXNzJAmKUrp7qCF5qytKrFOAH5hU4PrPxCQ=;
        b=E1TKy9D48OqmNmtCAsTugXIkq+8IN9/KmgRiHcEJpR2EmPaU3gDUdUEMeVN4UqBMgf
         h36MjkSZIy9+23T+kyb0fKYteamHz/BmDmKJQ+jTaNHzjFhzPYBko6tuoWXCpYDObvo+
         qK2fehbUqvOGBCrM6mQYGl6wxcZnJQz9/DCpoijFbtpcrrt8FFycmm3flFwhCNUViEOa
         9pIgH4AKdBPDunkno4P0jUK1rnZezquKmzM/lbS7yVYekCSrNz1CVF49LOrC9jL6UEq+
         +FoubqMOEhfyhnWq7PluMHfhk8CyA5xw5CgOTSYsh/BxUJAR3H+pu0h2dQd0VhklVdx+
         vOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xXAykXWGOXNzJAmKUrp7qCF5qytKrFOAH5hU4PrPxCQ=;
        b=rrLYeC339VaCE6EkOeeKAzoKDFMb2sRUXMht8dvFDll9+I2iSDRpnyG4psyEqZit1X
         ZqFz0EEvHDgMTA0NLMqafkEmVsi3MgeKrRaqqXkH+SLHVAkzBBqs5iKPpdzGtEDFB0im
         22LCppA6J748odVbsnqVLjyvyg1H60cq1fafJtX+2HCy58Sj42mBgTZ7ML/n/5Yogo6Y
         vLZko03TJrD3whHpmWBl9iV4Oioyqm/z9kfeswp2dMAiYBAtjg4ugzjUJ2RX+bknwSbv
         VZw8n0ZmrBiZ/ILn8+qN08smItOL7VlQATYz05YmGNwZpI3FatptEl3n/x1P4QY4VeeH
         H04Q==
X-Gm-Message-State: AOAM532vDEGQXzxSJw1+X7vsZXY/u1mF9JATTomqVq9QfngsOTWova86
        2d01D5TegTX68HGa88K/zJffboiDR0I=
X-Google-Smtp-Source: ABdhPJx6ja5dY70puxnLAuFUzqo0LPQQ5fNT6wN3QIVajy/vSs0Dd/4mS4eZe4xj7zTbFYQqGBAgwA==
X-Received: by 2002:a17:902:f544:b0:154:5ecb:eb24 with SMTP id h4-20020a170902f54400b001545ecbeb24mr9456306plf.11.1648800667985;
        Fri, 01 Apr 2022 01:11:07 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id hg5-20020a17090b300500b001c795eedcffsm11634790pjb.13.2022.04.01.01.11.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Apr 2022 01:11:07 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 3/5] KVM: X86: Boost vCPU which is in critical section
Date:   Fri,  1 Apr 2022 01:10:03 -0700
Message-Id: <1648800605-18074-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
References: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
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
index 9aa05f79b743..b613cd2b822a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10377,6 +10377,28 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static bool kvm_vcpu_is_preemptible(struct kvm_vcpu *vcpu)
+{
+	int count;
+
+	if (!vcpu->arch.pv_pc.preempt_count_enabled)
+		return false;
+
+	if (!kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_pc.preempt_count_cache,
+	    &count, sizeof(int)))
+		return !(count & ~PREEMPT_NEED_RESCHED);
+
+	return false;
+}
+
+bool kvm_arch_boost_candidate(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.last_guest_irq_disabled || !kvm_vcpu_is_preemptible(vcpu))
+		return true;
+
+	return false;
+}
+
 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
 	int r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9536ffa0473b..28d9e99284f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1420,6 +1420,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_boost_candidate(struct kvm_vcpu *vcpu);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69c318fdff61..018a87af01a1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3544,6 +3544,11 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
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
@@ -3579,6 +3584,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
 			    !kvm_arch_vcpu_in_kernel(vcpu))
 				continue;
+			if (!kvm_arch_boost_candidate(vcpu))
+				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
 
-- 
2.25.1

