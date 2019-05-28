Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9042C098
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfE1HvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:51:13 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42046 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfE1HvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:51:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id 33so7505479pgv.9;
        Tue, 28 May 2019 00:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vBM+WK9qA4pZcm6B2byvLBaRkxAGft4URtktgvLLdCc=;
        b=JYMnfUJt7zLg3ezXy4Owo9g/XRbj/3h6pZwp3pbyeruPNHBxepU8hJSvJLTRPPP9MI
         YbrhbE0s6cNAwIgtworpnncCuVEh6wISGRiylo7DxhMYesny7sfiSgeHkwhw5Oq0GhW8
         OboQNjHVxsmQyhCHoZQ0NBZyNwETtWueT6KKpZY0u92r5bJgb4YSWXeUjTSMNg9lW1xC
         L1U5fZDcJHH5PVa+fipIfMwamcpiHPIB2Ga/h6BUF3MXsI0V+jYKe6NovJCtFDB1s7l0
         otY3wBbM7VdvusV00AK+uGxaB9FECWZsTjiUoB4AsDEGW+wUEINfNAW3+jeR2PcIXb9g
         UsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vBM+WK9qA4pZcm6B2byvLBaRkxAGft4URtktgvLLdCc=;
        b=gSuZhHaXIIYqvzs8RXnH7OpH5N6HkqZqg6dSGLGfHXf589bsxdx+BeoWDyPqyv1l2d
         R3r2ZyDtkeLDwZOWhI2nvB5LFho8PSGnLww3k7nl1qfQeKL96kgM4QFWhezF/OHhvGnI
         3gNTgWdBjQC9COMiE3+CWzuR3c4kETE/kMEmLkW4pCIBt/7Vy9t5SgGhmh/6E2/ZTZH7
         il+p8WB+OUoAI19fIpk8TcR7+gqGp5HEgCLa2nPYAlwAO/kFPBHbNlR1t73/lkkICw3S
         nEjRvkPM+sARLU7TkXk+DCBgZUIM3MaeEclaS9xcP8QnTzW0yOIydvl9hJY+J4CBvYHy
         Ny4g==
X-Gm-Message-State: APjAAAWPktAilv513xD1cK88xvSH6ZlODF2o5DQA1Sifpe2HPMSy7ph5
        2tT7bl4UYWI5SyisRaWQ8U5vOOTQ
X-Google-Smtp-Source: APXvYqxwwYuzgIofu2fenFDryRZ9lvnIY7FmN2dDzrx/AP1VZbmoe2uqj4FlxrMhoveLjfIzQOJ//A==
X-Received: by 2002:aa7:90ca:: with SMTP id k10mr141072623pfk.20.1559029871574;
        Tue, 28 May 2019 00:51:11 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id q20sm18201400pgq.66.2019.05.28.00.51.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 00:51:11 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND v2 1/3] KVM: X86: Implement PV sched yield in linux guest
Date:   Tue, 28 May 2019 15:50:55 +0800
Message-Id: <1559029857-2750-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559029857-2750-1-git-send-email-wanpengli@tencent.com>
References: <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
 <1559029857-2750-1-git-send-email-wanpengli@tencent.com>
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

