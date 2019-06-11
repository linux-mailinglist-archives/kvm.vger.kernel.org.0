Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB293CB1A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388904AbfFKMX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:23:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41852 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387819AbfFKMX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:23:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id s24so5046407plr.8;
        Tue, 11 Jun 2019 05:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AKeqxqK2gKEF050JzqbZCibb9Lq7XU7zk3Rd1JiS3Ag=;
        b=LuvR0HuWMAXhFxd9h2DOrYAjzX6po79YvL9sIiqZU6LQBCETX5syodrVB1XOFmvFts
         2SCrpn1mexFdYIjKAm0Mf8BHsA9Zqyr9N4JcCcmsSqVAZdek8o+wOS6dp01FlxmFyq+J
         4QUBF/Vezmsftdd2gs0p5zH03De1diPnJzMrtp22nop38YpjjC/i9p0Y4VOMxglmv2On
         WoEkIjBKnH1dbHqo7UziA8VZ8zNiEPpW1qzvKInBTyqdwDwYybnmMFGWcE9x4zn6G3y0
         Wej/TrEWFdrWlnrW1uWDlS4upwTSryLuuKjNIGByBxMJHFBU+ilQoxRva0VHzvLqzB23
         vehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AKeqxqK2gKEF050JzqbZCibb9Lq7XU7zk3Rd1JiS3Ag=;
        b=bCU9UotBiJA4JQuelU+xoi+w6mtC5TQJG4rUUF+k7fr29PHgpf0ytBHGDz59caluAN
         v0ZEksL7elw9khQEAiLQXV/n0A54qj2j6mDWTSChKx6x0+q1GuzQGME/8WKvqrQDBiiJ
         Y/OuxXgNTt0FAmMBdWTRC8ncLoikrhJl5H0zsARPNUj2TTvH8bjEGnUe2802iRI9+NV9
         Io+iuR+z56Ve3Jvz8VK3F//KKGOaYkTAtS+DATfInKpcSgEq2pAWxMKj45P9noqjoC2H
         Rh48OeGRoItWDe7BHO0YxpKHXAUETzsRpU6GD+YDB0tIEjGOOUQTh7+5Q3i3c8V6I9zM
         IuMQ==
X-Gm-Message-State: APjAAAVUiPV46SB7fbxd/aBi1NHAvaYQH3awMVyyIDcwkeY+W5FlGYcu
        fXhVd4GbwuGNtmVm79fFsELGYblP
X-Google-Smtp-Source: APXvYqwTT7hkV+XG3d00/uesyvZjWtaFvmevdoatEUYwpbTe3Q5M1lUlhxg2AdT/iyx1JzLMF9TUHw==
X-Received: by 2002:a17:902:ba82:: with SMTP id k2mr67900016pls.323.1560255836922;
        Tue, 11 Jun 2019 05:23:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 127sm14832271pfc.159.2019.06.11.05.23.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:23:56 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 1/3] KVM: X86: Yield to IPI target if necessary
Date:   Tue, 11 Jun 2019 20:23:48 +0800
Message-Id: <1560255830-8656-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
References: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
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
index 5169b8c..82caf01 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -527,6 +527,21 @@ static void kvm_setup_pv_ipi(void)
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
@@ -638,6 +653,12 @@ static void __init kvm_guest_init(void)
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

