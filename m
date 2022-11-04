Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF566190F4
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiKDGVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiKDGVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:21:20 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2883A2A72B
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 23:21:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5so2445244wmo.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 23:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NFek8SyKiRWYHjHtbk8OGDRsRGEQRPyliekwb3dBs0=;
        b=RpQOXNrO20ME0kIdNBKVxPKf0Z3AKFuxtXg7Kpowlf6wGtNyM1z81ylwdCFeriDUJc
         siE/bB07/fvJHdC7zDA5R65FrlXN/uEtFtMYUfetI9PpJFMmD8a51QQpxpAkv2pUKmTJ
         5GBwq9ilxXBUFckUoyIQf2axWInAGcyLaHI5p50yhdy6hYkdQhErNcZcPDf8MOYrh4IN
         8SUZLJQInHIoCzin7R5P3GsIhUS2H+s2CpmdACF2OdTGNTgJSN//kbzhs3Y3NxDfBziW
         f+pwo3nFiKizpA3oKXUEo6epZdyJ8PUwa6nCUW6+k0GnEVNmo5ysmY6Y7LuIu8paZerB
         H/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+NFek8SyKiRWYHjHtbk8OGDRsRGEQRPyliekwb3dBs0=;
        b=6jNaV36Aoc9b92O9oxWx2f4e6jdAa0/SESwsALEUSfgz8/MdYV+cwcl0SN6RQWnXQy
         ucnpmehF+Kl1F8Ss7i7IVh+3RZOVJKiBHVqnnbkob749gAI5GxqeT0k6PEvO6XuLsFMa
         In+YGFH1U3X9ZzLffeo826skrPu5l/bkKcDj7zg6zpkXq3BBjpd7Bf/zE1kwIcsjWrZR
         Zqs03cRQ3QVJ3e8+3Hz9/VgceXrlcQvVbcdBe8cDl9mcUewgGTKunSesjB67eeVw0FbA
         KTng+ee2D5k5i3JfavgFHcszZFN5hHMC1vyZRlXRfHVzWUYrPfvmqfy3Sfg3U5GVK3tu
         wv5g==
X-Gm-Message-State: ACrzQf3HgUSiqR02LQBuJ/t9VXk1ahelLFhPHAUjH24CpSv1flSSsTAL
        EeNbC48tKJtBdZF+aUuwyncv2v9ZZQaO2Q==
X-Google-Smtp-Source: AMsMyM6a2SECt/q6AUJgpLy6YsWcT70H6BaxmCMWqTGmcdrFaEEdP6mgJVsQmKaMvgdbkE/uNKxFOQ==
X-Received: by 2002:a05:600c:468f:b0:3c6:f85c:25a1 with SMTP id p15-20020a05600c468f00b003c6f85c25a1mr21947258wmo.60.1667542877688;
        Thu, 03 Nov 2022 23:21:17 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
        by smtp.gmail.com with ESMTPSA id w11-20020a5d608b000000b002366f9bd717sm3099924wrt.45.2022.11.03.23.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:21:17 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v2 4/6] KVM: arm64: Provide VCPU attributes for PV lock
Date:   Fri,  4 Nov 2022 06:21:03 +0000
Message-Id: <20221104062105.4119003-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow user space to inform the KVM host where in the physical memory
map the paravirtualized lock structures should be located.

User space can set an attribute on the VCPU providing the IPA base
address of the PV lock structure for that VCPU. This must be
repeated for every VCPU in the VM.

The address is given in terms of the physical address visible to
the guest and must be 64 byte aligned. The guest will discover the
address via a hypercall.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/kvm_host.h |  7 ++++
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/guest.c            |  9 +++++
 arch/arm64/kvm/pvlock.c           | 57 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 77 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 18303b30b7e9..86aeca8a4393 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -829,6 +829,13 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 
+int kvm_arm_pvlock_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pvlock_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pvlock_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+
 extern unsigned int kvm_arm_vmid_bits;
 int kvm_arm_vmid_alloc_init(void);
 void kvm_arm_vmid_alloc_free(void);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index bd05ece5c590..71010bacaaab 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -412,6 +412,8 @@ enum {
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
+#define KVM_ARM_VCPU_PVLOCK_CTRL	3
+#define   KVM_ARM_VCPU_PVLOCK_IPA	0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2ff13a3f8479..7e765e3256ef 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -959,6 +959,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_set_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -982,6 +985,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_get_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1005,6 +1011,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_has_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/arch/arm64/kvm/pvlock.c b/arch/arm64/kvm/pvlock.c
index 3eb35ab31481..b08a287a4811 100644
--- a/arch/arm64/kvm/pvlock.c
+++ b/arch/arm64/kvm/pvlock.c
@@ -41,3 +41,60 @@ void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
 	kvm_put_guest(kvm, base + offset, cpu_to_le64(preempted));
 	srcu_read_unlock(&kvm->srcu, idx);
 }
+
+int kvm_arm_pvlock_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	struct kvm *kvm = vcpu->kvm;
+	u64 ipa;
+	int ret = 0;
+	int idx;
+
+	if (attr->attr != KVM_ARM_VCPU_PVLOCK_IPA)
+		return -ENXIO;
+
+	if (get_user(ipa, user))
+		return -EFAULT;
+	if (!IS_ALIGNED(ipa, 64))
+		return -EINVAL;
+	if (vcpu->arch.pv.base != GPA_INVALID)
+		return -EEXIST;
+
+	/* Check the address is in a valid memslot */
+	idx = srcu_read_lock(&kvm->srcu);
+	if (kvm_is_error_hva(gfn_to_hva(kvm, ipa >> PAGE_SHIFT)))
+		ret = -EINVAL;
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (!ret)
+		vcpu->arch.pv.base = ipa;
+
+	return ret;
+}
+
+int kvm_arm_pvlock_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 ipa;
+
+	if (attr->attr != KVM_ARM_VCPU_PVLOCK_IPA)
+		return -ENXIO;
+
+	ipa = vcpu->arch.pv.base;
+
+	if (put_user(ipa, user))
+		return -EFAULT;
+	return 0;
+}
+
+int kvm_arm_pvlock_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PVLOCK_IPA:
+		return 0;
+	}
+	return -ENXIO;
+}
\ No newline at end of file
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..1fe3cce5c84a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1429,6 +1429,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_ARM_PV_LOCK,
+#define KVM_DEV_TYPE_ARM_PV_LOCK	KVM_DEV_TYPE_ARM_PV_LOCK
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.25.1

