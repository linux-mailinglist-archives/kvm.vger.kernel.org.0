Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9AA6D126B
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 00:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjC3Wow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 18:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjC3Woc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 18:44:32 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C30D10260
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:44:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5417f156cb9so203164177b3.8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680216260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2nOCpsUj368/jlH6/5xvHY1SZiMoDDhdnoWB6M9IhGk=;
        b=THVYyF8s290bORIWP3ABi5re4jfnJUNSfUN9waQEfuWO2DCGAMFNogh1dtxKos0ky7
         RXiMYsAOxoD9dh31FpQfAM4Y3AJViocg6mDhumiMoiM5DogAAWaq9zzKtThBTTQGwbhj
         4E/EII3+jyQhP/Qq7fJ6Kl1Ewz1qkrYavr6s9YBhW6Z4hTwzBrZLLKL8mxHs5Cs4lpdT
         TDTynATErlOMbxgxMmyx7Fi6Y+10JW2JMIpn0Jvqy6IhJwcJy+6Nky/yAIzx1+EbqrBX
         YqViQN6XeDFsLS+BcYlwXCXJ1z2qCxeexx873lv78Ezdp3VXqR30z7mFhZ89zkS4VQdR
         ofGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680216260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2nOCpsUj368/jlH6/5xvHY1SZiMoDDhdnoWB6M9IhGk=;
        b=2MmfYRvzRa5eJ3V5Qnye7zDxGy2mFQ5FLeqJL5/CVHe9BdJiYhYKKYk/PYmHH8SeJ9
         sFP5VIMPZOM7B4nz7JZ5o6ot4HMlhfHw4tTDTHkHIhn/GRV7wSSC+bPtDZLlFzpoo0iU
         hU6ragw7jOb04U5il0RwaEjSmfLiEvDUF4nW8ATieFe9hK/UM7XUJkFYed+u2WT3Ix+m
         nyLhdvFNgzHtNIUsGAqNVkuY97u7mRsvyMjLndm9602KojvJoQUv7LjgejR0lFACCeXc
         m4+pFSuztSIDbpFmwj4sKCeWxQylLCjrjBH0jgL+bxp3F0v7/9YNdvlHsJ++RvSqSFxT
         ZiDA==
X-Gm-Message-State: AAQBX9dJEzyK0hgTtQ6acvNHtGINHsQ75c2M11rmKGNFOHN2ioN40Ju/
        rx1bZtAP1uMlePPd+B2r/XCGLD76EfmT
X-Google-Smtp-Source: AKy350bzCEo/+0/51fGzFdSbJqoEEFx7hq0PNKn99Z+L93t5QuaWPTEqABt2N5tIMlx8Fqm3GFdtlD5RbP1d
X-Received: from davidai2.mtv.corp.google.com ([2620:15c:211:201:c162:24e8:ec5e:d520])
 (user=davidai job=sendgmr) by 2002:a25:7403:0:b0:b7e:6118:348 with SMTP id
 p3-20020a257403000000b00b7e61180348mr4575548ybc.0.1680216260677; Thu, 30 Mar
 2023 15:44:20 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:43:38 -0700
In-Reply-To: <20230330224348.1006691-1-davidai@google.com>
Mime-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330224348.1006691-4-davidai@google.com>
Subject: [RFC PATCH 3/6] kvm: arm64: Add support for util_hint service
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

This service allows guests to send the utilization of workoads on its vCPUs
to the host. Utilization is represented as an arbitrary value of 0-1024
where 1024 represents the highest performance point normalized for
frequency and architecture across all CPUs. This hint is used by
the host for scheduling vCPU threads and deciding CPU frequency.

Co-developed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: David Dai <davidai@google.com>
---
 Documentation/virt/kvm/api.rst           | 12 ++++++++++++
 Documentation/virt/kvm/arm/index.rst     |  1 +
 Documentation/virt/kvm/arm/util_hint.rst | 22 ++++++++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h        |  1 +
 arch/arm64/kvm/arm.c                     |  1 +
 arch/arm64/kvm/hypercalls.c              | 20 ++++++++++++++++++++
 include/linux/arm-smccc.h                |  7 +++++++
 include/uapi/linux/kvm.h                 |  1 +
 tools/arch/arm64/include/uapi/asm/kvm.h  |  1 +
 9 files changed, 66 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/util_hint.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b0ff0ad700bf..38ce33564efc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8388,6 +8388,18 @@ must point to a byte where the value will be stored or retrieved from.
 This capability indicates that KVM supports getting the
 frequency of the current CPU that the vCPU thread is running on.
 
+8.41 KVM_CAP_UTIL_HINT
+----------------------
+
+:Architectures: arm64
+
+This capability indicates that the KVM supports taking utilization
+hints from the guest. Utilization is represented as a value from 0-1024
+where 1024 represents the highest performance point across all physical CPUs
+after normalizing for architecture. This is useful when guests are tracking
+workload on its vCPUs. Util hints allow the host to make more accurate
+frequency selections and task placement for vCPU threads.
+
 9. Known KVM API problems
 =========================
 
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 47afc5c1f24a..f83877663813 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -12,3 +12,4 @@ ARM
    pvtime
    ptp_kvm
    get_cur_cpufreq
+   util_hint
diff --git a/Documentation/virt/kvm/arm/util_hint.rst b/Documentation/virt/kvm/arm/util_hint.rst
new file mode 100644
index 000000000000..262d142d62d9
--- /dev/null
+++ b/Documentation/virt/kvm/arm/util_hint.rst
@@ -0,0 +1,22 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Util_hint support for arm64
+============================
+
+Util_hint is used for sharing the utilization value from the guest
+to the host.
+
+* ARM_SMCCC_HYP_KVM_UTIL_HINT_FUNC_ID: 0x86000041
+
+This hypercall using the SMC32/HVC32 calling convention:
+
+ARM_SMCCC_HYP_KVM_UTIL_HINT_FUNC_ID
+    ==============    =========   ============================
+    Function ID:      (uint32)    0x86000041
+    Arguments:        (uint32)    util value(0-1024) where 1024 represents
+                                  the highest performance point normalized
+                                  across all CPUs
+    Return values:    (int32)     NOT_SUPPORTED(-1) on error.
+    Endianness:                   Must be the same endianness
+                                  as the host.
+    ==============    ========    ============================
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed8b63e91bdc..61309ecb7241 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -368,6 +368,7 @@ enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
 	KVM_REG_ARM_VENDOR_HYP_BIT_GET_CUR_CPUFREQ	= 2,
+	KVM_REG_ARM_VENDOR_HYP_BIT_UTIL_HINT		= 3,
 #ifdef __KERNEL__
 	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f960b136c611..bf3c4d4b9b67 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -221,6 +221,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_GET_CUR_CPUFREQ:
+	case KVM_CAP_UTIL_HINT:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b3f4b90c024b..01dba07b5183 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -28,6 +28,20 @@ static void kvm_sched_get_cur_cpufreq(struct kvm_vcpu *vcpu, u64 *val)
 	val[0] = ret_freq;
 }
 
+static void kvm_sched_set_util(struct kvm_vcpu *vcpu, u64 *val)
+{
+	struct sched_attr attr = {
+		.sched_flags = SCHED_FLAG_UTIL_GUEST,
+	};
+	int ret;
+
+	attr.sched_util_min = smccc_get_arg1(vcpu);
+
+	ret = sched_setattr_nocheck(current, &attr);
+
+	val[0] = (u64)ret;
+}
+
 static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 {
 	struct system_time_snapshot systime_snapshot;
@@ -131,6 +145,9 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID:
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_GET_CUR_CPUFREQ,
 				&smccc_feat->vendor_hyp_bmap);
+	case ARM_SMCCC_VENDOR_HYP_KVM_UTIL_HINT_FUNC_ID:
+		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_UTIL_HINT,
+				&smccc_feat->vendor_hyp_bmap);
 	default:
 		return kvm_hvc_call_default_allowed(func_id);
 	}
@@ -231,6 +248,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID:
 		kvm_sched_get_cur_cpufreq(vcpu, val);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_UTIL_HINT_FUNC_ID:
+		kvm_sched_set_util(vcpu, val);
+		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index e15f1bdcf3f1..9f747e5025b6 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -113,6 +113,7 @@
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
 #define ARM_SMCCC_KVM_FUNC_GET_CUR_CPUFREQ	64
+#define ARM_SMCCC_KVM_FUNC_UTIL_HINT			65
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -145,6 +146,12 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_GET_CUR_CPUFREQ)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_UTIL_HINT_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_UTIL_HINT)
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0a1a260243bf..7f667ab344ae 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1185,6 +1185,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_GET_CUR_CPUFREQ 512
+#define KVM_CAP_UTIL_HINT 513
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index ed8b63e91bdc..61309ecb7241 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -368,6 +368,7 @@ enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
 	KVM_REG_ARM_VENDOR_HYP_BIT_GET_CUR_CPUFREQ	= 2,
+	KVM_REG_ARM_VENDOR_HYP_BIT_UTIL_HINT		= 3,
 #ifdef __KERNEL__
 	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
 #endif
-- 
2.40.0.348.gf938b09366-goog

