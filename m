Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66AFD6D1274
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 00:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjC3WpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 18:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjC3Wod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 18:44:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54196E381
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:44:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g187-20020a2520c4000000b00b74680a7904so20139060ybg.15
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680216255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWrmux7hI3Vkehq4mVAPcOxXo9VZdrd7e2opoA1ab28=;
        b=i0OxGwAlYv/8fg/xl8vCs3bv85Ct5kGC4I40aiP6zlxrZNla0vcd+Dt/3ziZ5Z64R2
         wwp0Kbij3HOATOhSkDXKKfOwlOYFxGiB/hDggLJkv/04GPSI/57NXaFnJDj78tlbjbfH
         zHFU86siWEoZyPUZgnPxbdTYoIqqHSKeqWKBcgWSOpw+XgqPbgWADD37A8W3toAbs1MC
         dcbVAQ8sl2OQzJt8IRgKDF9IS1AH/mRcNJT2VSC6zxmHCHPlb2t6r5bf+IqTbNLbJCvs
         AKYlZU4JbVRQXfpRwnjWx/H9f5H7hruDbA3ZWfT7nOqwawvT9S9fX+9ZMwDadcKocd2n
         Mp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680216255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VWrmux7hI3Vkehq4mVAPcOxXo9VZdrd7e2opoA1ab28=;
        b=EljVHpacoby7khWQTNhWz8NkeQAqUBH2y1NVENSYZm1b7xygU/Qto+9mmNJSiZL/vZ
         2k1f8QMCwJOLav3sCMjZiVjTyFDcyCCid44YzAyBqwc+039fSECZgY9pjQw4bgrD1D71
         xMqHeH8ZCwG1HsL0NRxY1jQ/0B8LFNKYbNvbkohmdBx/PINBsnGFLo8ZOfr8w/rvr51V
         v1f0Jcgify252cWvgJum6L+cpp5XkAyTZ6uH0sivpgmKkI3R6GvIp+dkMjxGeYJFTH0g
         qZ90EqgVAtiw0btQcdMkCf0JwNSJCk1QOrMKHQ2ykNbaeRrXYGqwN9HAU7HlTGk0bQI4
         grDw==
X-Gm-Message-State: AAQBX9d+I+OkXISQ51vp932HcJnxPslxTe6D+G4eoTBTp/ZHFClidy2I
        C3xdckm2YsVktwtQzprya7AUahzzPGJ+
X-Google-Smtp-Source: AKy350bcwJ9FD9dZGNvGTPVwMDF1LwhIoUS2S5HjV59ByCSD7PADcxzbUOioxj2xH08uJn1CEJhYNkbKLaF/
X-Received: from davidai2.mtv.corp.google.com ([2620:15c:211:201:c162:24e8:ec5e:d520])
 (user=davidai job=sendgmr) by 2002:a25:680e:0:b0:b78:3a15:e6fe with SMTP id
 d14-20020a25680e000000b00b783a15e6femr12135986ybc.2.1680216255549; Thu, 30
 Mar 2023 15:44:15 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:43:37 -0700
In-Reply-To: <20230330224348.1006691-1-davidai@google.com>
Mime-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330224348.1006691-3-davidai@google.com>
Subject: [RFC PATCH 2/6] kvm: arm64: Add support for get_cur_cpufreq service
From:   David Dai <davidai@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Cc:     David Dai <davidai@google.com>,
        Saravana Kannan <saravanak@google.com>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This service allows guests to query the host for frequency of the CPU
that the vCPU is currently running on.

Co-developed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: David Dai <davidai@google.com>
---
 Documentation/virt/kvm/api.rst                |  8 +++++++
 .../virt/kvm/arm/get_cur_cpufreq.rst          | 21 +++++++++++++++++++
 Documentation/virt/kvm/arm/index.rst          |  1 +
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/arm.c                          |  1 +
 arch/arm64/kvm/hypercalls.c                   | 18 ++++++++++++++++
 include/linux/arm-smccc.h                     |  7 +++++++
 include/uapi/linux/kvm.h                      |  1 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
 9 files changed, 59 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/get_cur_cpufreq.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62de0768d6aa..b0ff0ad700bf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8380,6 +8380,14 @@ structure.
 When getting the Modified Change Topology Report value, the attr->addr
 must point to a byte where the value will be stored or retrieved from.
 
+8.40 KVM_CAP_GET_CUR_CPUFREQ
+------------------------
+
+:Architectures: arm64
+
+This capability indicates that KVM supports getting the
+frequency of the current CPU that the vCPU thread is running on.
+
 9. Known KVM API problems
 =========================
 
diff --git a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
new file mode 100644
index 000000000000..06e0ed5b3868
--- /dev/null
+++ b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
@@ -0,0 +1,21 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+get_cur_cpufreq support for arm/arm64
+=============================
+
+Get_cur_cpufreq support is used to get current frequency(in KHz) of the
+current CPU that the vCPU thread is running on.
+
+* ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID: 0x86000040
+
+This hypercall uses the SMC32/HVC32 calling convention:
+
+ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID
+    ==============    ========    =====================================
+    Function ID:      (uint32)    0x86000040
+    Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
+                      (uint32)    Frequency in KHz of current CPU that the
+                                  vCPU thread is running on.
+    Endianness:                   Must be the same endianness
+                                  as the host.
+    ==============    ========    =====================================
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index e84848432158..47afc5c1f24a 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -11,3 +11,4 @@ ARM
    hypercalls
    pvtime
    ptp_kvm
+   get_cur_cpufreq
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f8129c624b07..ed8b63e91bdc 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -367,6 +367,7 @@ enum {
 enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
+	KVM_REG_ARM_VENDOR_HYP_BIT_GET_CUR_CPUFREQ	= 2,
 #ifdef __KERNEL__
 	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..f960b136c611 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_GET_CUR_CPUFREQ:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5da884e11337..b3f4b90c024b 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -3,6 +3,9 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
+#include <linux/cpufreq.h>
+#include <linux/sched.h>
+#include <uapi/linux/sched/types.h>
 
 #include <asm/kvm_emulate.h>
 
@@ -16,6 +19,15 @@
 #define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES			\
 	GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT - 1, 0)
 
+static void kvm_sched_get_cur_cpufreq(struct kvm_vcpu *vcpu, u64 *val)
+{
+	unsigned long ret_freq;
+
+	ret_freq = cpufreq_get(task_cpu(current));
+
+	val[0] = ret_freq;
+}
+
 static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 {
 	struct system_time_snapshot systime_snapshot;
@@ -116,6 +128,9 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PTP,
 				&smccc_feat->vendor_hyp_bmap);
+	case ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID:
+		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_GET_CUR_CPUFREQ,
+				&smccc_feat->vendor_hyp_bmap);
 	default:
 		return kvm_hvc_call_default_allowed(func_id);
 	}
@@ -213,6 +228,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID:
+		kvm_sched_get_cur_cpufreq(vcpu, val);
+		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 220c8c60e021..e15f1bdcf3f1 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -112,6 +112,7 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_GET_CUR_CPUFREQ	64
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -138,6 +139,12 @@
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_GET_CUR_CPUFREQ)
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d77aef872a0a..0a1a260243bf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1184,6 +1184,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_GET_CUR_CPUFREQ 512
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index f8129c624b07..ed8b63e91bdc 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -367,6 +367,7 @@ enum {
 enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
+	KVM_REG_ARM_VENDOR_HYP_BIT_GET_CUR_CPUFREQ	= 2,
 #ifdef __KERNEL__
 	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
 #endif
-- 
2.40.0.348.gf938b09366-goog

