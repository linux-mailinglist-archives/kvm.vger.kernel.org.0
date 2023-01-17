Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE9D66DB2F
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbjAQKcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbjAQKat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:30:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E6C30EA8
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:40 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r9so7286402wrw.4
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JxUuw76iqveF/sNoXADChUiwxEEgDMG8APtAC2nJI+s=;
        b=MuiU+uyxvhbFRPyGqQ9ezTOALzxDqQbJVIykevHF+Hn583+flrkUR2ssjmJ2VjwOUE
         YhBQ2oj9m13vCXGQT5vXg6Vxrr8xn4xnx3PfAFbA0ANwE2oeu5cAFCWwH8BL9UXQos4/
         AU6RdoTw+AFWR9xecEPm2R/LmoOFrKYW2cT+4s6MySiAXOFpykWTBrwp/PLQ0aoYWTGJ
         MV06LlbbOoCbDvGu7wD+uQcnmFVbsfChDxR3UKZinxcNWAiRElF4zofcz3mvAfBYBFQ0
         upKvDTsVDq7qIuc8/eAH2yHe4c0zt14RXmdLDvvrTeQzpCN0Psp/68cc0K/ReCC/TATW
         ADyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JxUuw76iqveF/sNoXADChUiwxEEgDMG8APtAC2nJI+s=;
        b=OKoKBhObQnJmRZRb8wpdN8nMoDW5ox0j5KiqK+zbMHg5MjpfaRA0h+4piZoA4bWpKu
         s7lwUJMHAkp41ZyKy0yZX2OXw7IilT1YNBkO1pbSsww4nm7vHmGT0pstZdIog9QlXADF
         h8PMYiif17Fw1b3J+xrCHUSp9JbRjUg9TsMRIwgTqCQGas+lGrc0jtDy+nVGPQGOQlpe
         3Ki3httgBTZYL/W3OtZa2dZXTETPq/QKZxxCpZ3oO7BV5OJarq6MF1/DCCaEIlz2riYK
         94G0wQL6P+uIKdCkgKupduM8Nf7U2/CuX8kCsj9s7IL8wrgZA9jr2pt9i0TTdSYsfdFD
         CpiA==
X-Gm-Message-State: AFqh2krae2c/sc7psVS3yVMHc9sZWpUa0L91QlFuYZAgJN1H2xt7ZlmD
        wTAT1YKMs8kMqUeTz+Hp2cVtHQ==
X-Google-Smtp-Source: AMrXdXvkb1hCXR2fjbTM0Oh/wBiSQPcWasDcV7oYwS4iMzciVdpsIBOXxNCutkedmesZw9Rv2Jg3qA==
X-Received: by 2002:adf:f501:0:b0:2ba:dce5:ee28 with SMTP id q1-20020adff501000000b002badce5ee28mr2139486wro.18.1673951379156;
        Tue, 17 Jan 2023 02:29:39 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:17d8:e5ec:f870:7b46])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d452f000000b0028f9132e9ddsm28389844wra.39.2023.01.17.02.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:29:38 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, pbonzini@redhat.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v3 4/6] KVM: arm64: Provide VCPU attributes for PV lock
Date:   Tue, 17 Jan 2023 10:29:28 +0000
Message-Id: <20230117102930.1053337-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230117102930.1053337-1-usama.arif@bytedance.com>
References: <20230117102930.1053337-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1d1acc5be8d7..5041b27dfcf2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -913,6 +913,13 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
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
index 34dd6df3f8eb..d67816f193a6 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -413,6 +413,8 @@ enum {
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
+#define KVM_ARM_VCPU_PVLOCK_CTRL	3
+#define   KVM_ARM_VCPU_PVLOCK_IPA	0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5626ddb540ce..a1b0f39f24ba 100644
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
index 228d24bfe281..cdd9749efd33 100644
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
+	if (vcpu->arch.pv_lock.base != GPA_INVALID)
+		return -EEXIST;
+
+	/* Check the address is in a valid memslot */
+	idx = srcu_read_lock(&kvm->srcu);
+	if (kvm_is_error_hva(gfn_to_hva(kvm, ipa >> PAGE_SHIFT)))
+		ret = -EINVAL;
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (!ret)
+		vcpu->arch.pv_lock.base = ipa;
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
+	ipa = vcpu->arch.pv_lock.base;
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
index 55155e262646..0d76b7034002 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1427,6 +1427,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_ARM_PV_LOCK,
+#define KVM_DEV_TYPE_ARM_PV_LOCK	KVM_DEV_TYPE_ARM_PV_LOCK
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.25.1

