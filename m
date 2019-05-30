Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF962EA0B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 03:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfE3BFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 21:05:22 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45334 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfE3BFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 21:05:22 -0400
Received: by mail-pl1-f193.google.com with SMTP id x7so819517plr.12;
        Wed, 29 May 2019 18:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NLeouBxvUtFtJV7am8sp6M7SEvXrySNvZkPzWOWKABQ=;
        b=rUo60yynsbKsshLQJMouNQAziTzNmjRr0IrYQEN6uXQhuGzYx9rP8N4Y5MwRtDkISy
         MCWY1boqAGqiNRG67jAbXC/TX+Mfuu6NY/J9Tqjpw+KVYzThjQmaDeQ4CmJ4uueXhC1f
         bJVF6Q/GCVOoZdKjOmYsRnhLu3QrLpA2SIyr4dAeGhiYFsk/yBOBVLHBJvhA3wvY0BZs
         gtGWTjHTWbWTKOWFbYf5GMPFOOVGfKDpR5sQVJXMPNtuq0E/uYVXQLs2IzLvZ1GMB/tM
         7RhD9YZM7DSEeiAcy7A6yWOUo+iqDNCxwLvz9xLuc6Aa7bZ4ZCSexi+UQF3wegZDR2ye
         Ianw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NLeouBxvUtFtJV7am8sp6M7SEvXrySNvZkPzWOWKABQ=;
        b=QPesrVubccDQBzWcp+zrrKZnRgrWC9D2CkKLLA0q/RbFE1fY3uqP+MCtlhiocvLsDR
         1uGnSCLttbSbar3AWNgHx60O4gcatofipZIyIkLkIgpp9Fa4gFCrMBEm2FNhZK7siZ+q
         DylUyfa1IyxkUuWyvwwG+9StHO0tEhWNVXwq6/w0NuV98+iA/XsxxQ2UNtLxV6pY204I
         vHL6qYVc8wFZ0R5Aok2g8UKV6rsgDMP7vj87pN8wwQq/PlvWydm7s9sfZGoFXnTU8LCL
         PrEsUBGZ/mHW6iGvAsuxsvDVvrDWJ5nIvIq7LEKT5jmIV98ps8sCHDslu6Efa7z0tDnR
         vhCA==
X-Gm-Message-State: APjAAAXEH6nfmGgq2YVbwX8Gp1DbkQjRgQO8VJvimsZEjdoiNSDokUgJ
        V9BBm2ytzVc0j/kfNnv1rMYuUyA4
X-Google-Smtp-Source: APXvYqxLom5xJx688ah6RS1P7ouc7Bj45i+N4LrNo5xTkjJCzMiGyx3l40AVSQnOOkaxCVVWxgBGuA==
X-Received: by 2002:a17:902:7618:: with SMTP id k24mr1005552pll.78.1559178321005;
        Wed, 29 May 2019 18:05:21 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id c76sm861965pfc.43.2019.05.29.18.05.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 29 May 2019 18:05:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 1/3] KVM: X86: Yield to IPI target if necessary
Date:   Thu, 30 May 2019 09:05:05 +0800
Message-Id: <1559178307-6835-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

When sending a call-function IPI-many to vCPUs, yield if any of
the IPI target vCPUs was preempted, we just select the first
preempted target vCPU which we found since the state of target
vCPUs can change underneath and to avoid race conditions.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
 arch/x86/include/uapi/asm/kvm_para.h     |  1 +
 arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
 include/uapi/linux/kvm_para.h            |  1 +
 4 files changed, 34 insertions(+)

diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
index da24c13..da21065 100644
--- a/Documentation/virtual/kvm/hypercalls.txt
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -141,3 +141,14 @@ a0 corresponds to the APIC ID in the third argument (a2), bit 1
 corresponds to the APIC ID a2+1, and so on.
 
 Returns the number of CPUs to which the IPIs were delivered successfully.
+
+7. KVM_HC_SCHED_YIELD
+------------------------
+Architecture: x86
+Status: active
+Purpose: Hypercall used to yield if the IPI target vCPU is preempted
+
+a0: destination APIC ID
+
+Usage example: When sending a call-function IPI-many to vCPUs, yield if
+any of the IPI target vCPUs was preempted.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 19980ec..d0bf77c 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_FEATURE_PV_TLB_FLUSH	9
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
 #define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_PV_SCHED_YIELD	12
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3f0cc82..54400c2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -540,6 +540,21 @@ static void kvm_setup_pv_ipi(void)
 	pr_info("KVM setup pv IPIs\n");
 }
 
+static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
+{
+	int cpu;
+
+	native_send_call_func_ipi(mask);
+
+	/* Make sure other vCPUs get a chance to run if they need to. */
+	for_each_cpu(cpu, mask) {
+		if (vcpu_is_preempted(cpu)) {
+			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
+			break;
+		}
+	}
+}
+
 static void __init kvm_smp_prepare_cpus(unsigned int max_cpus)
 {
 	native_smp_prepare_cpus(max_cpus);
@@ -651,6 +666,12 @@ static void __init kvm_guest_init(void)
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
+	if (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
+	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
+	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
+		pr_info("KVM setup pv sched yield\n");
+	}
 	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/kvm:online",
 				      kvm_cpu_online, kvm_cpu_down_prepare) < 0)
 		pr_err("kvm_guest: Failed to install cpu hotplug callbacks\n");
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 6c0ce49..8b86609 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -28,6 +28,7 @@
 #define KVM_HC_MIPS_CONSOLE_OUTPUT	8
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
+#define KVM_HC_SCHED_YIELD		11
 
 /*
  * hypercalls use architecture specific
-- 
2.7.4

