Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34983F6B05
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 23:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhHXVfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 17:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhHXVfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 17:35:43 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C584C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 14:34:58 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id x10-20020a05622a000ab02902982df43057so11434561qtw.9
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 14:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MZN4oBbWEOsHzWZgslUKdaHZb21enktCWRWj8WQuJHw=;
        b=f2uwJrvQWxth4bwI4AeJ2nEFSXk8vdexb8C4dfzbWv1QjmknE206l3cu7Yym6g6ehh
         OrKeug2E5MAt6rpGESa3/Aw/NAYrPEi1nNxFkoek8aFyTCpxO3wf0Kk6jMShgrppb4D9
         rFxHxEtXe1fK8pIzhNY29yfg7Owk3W9yCHBMoUOOgPMPCdIUv4CSQ+0F1eYyM/PuLTyu
         +q1+0rqToAq+FG/YBiwbBVyT7fCObJ7QzNMMINMVfm9gmVgcQ9E6Y/ONXiKcJWGgj1K+
         0tAiy9/VaCS7nz10iq4io3ErFLdMmJ8yk2LHsiLiYpXKG6if4gVN5XAeG30k5BHNcpQu
         EJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MZN4oBbWEOsHzWZgslUKdaHZb21enktCWRWj8WQuJHw=;
        b=iqOdxDmkOeYgRRgXWKV0AD3fVYhHmLFZe8aoskHFVz09TGoc5KR3ktXVKtyQ6hzdLU
         o/+tFQlGUOyg4n2Vux4RRPFsjdTQKOnuDSDmpRWj0CB73kX2JpfbV1EjoGYT1W1vZM9C
         Ux+yV+LUAyHuqMPnZq6G0Dd5WteU0ERagLHl13FFG/levb8m2sqGfrJ3GxQkbJLxYkc2
         Ggerw34TrZz+Eqz/z1D5vTsqFCX99iLMLjTqclXpgvtCD/KIoOqfxcjwXfU4nF/BJDeh
         uKLg8XUiJZZcR5trAVZ7Kmr8MlAolwvwm5aCk0dzVHBHQf11rDiFcjP+q3lY1SPoSUwV
         G1IQ==
X-Gm-Message-State: AOAM531qWWubuKQEUB1KTf3nK7n5uRLf52V1i2Zy2+LjuYggtEvf49Ll
        3jIoP4TwMDtRFCovtAadeZwWWtjBXGi6Tgscobp9Y/nI7jIJsmu97Vcu6lX3R7st5ogGWqSWYF9
        T42QzrMkBbDW/10btZdgeNlkGlRCB0An/UoHKgsh/N7BW/mdQUJMYClKvBw==
X-Google-Smtp-Source: ABdhPJwCtCRX/g2KsfsgDGe6kvtcxkVWKYRCPIOoJZwjgcnAZvePmD3HugahbZO9uzjgcarnlKhXOCFKrbI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:312:: with SMTP id
 i18mr8427019qvu.48.1629840896664; Tue, 24 Aug 2021 14:34:56 -0700 (PDT)
Date:   Tue, 24 Aug 2021 21:34:50 +0000
In-Reply-To: <YSVhV+UIMY12u2PW@google.com>
Message-Id: <20210824213450.1206228-1-oupton@google.com>
Mime-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [RFC PATCH] KVM: arm64: Allow VMMs to opt-out of KVM_CAP_PTP_KVM
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>, rejiw@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 3bf725699bf6 ("KVM: arm64: Add support for the KVM PTP service")
introduced support for a hypercall-based interface through which a KVM
guest may query the host's walltime relative to its physical or virtual
counter. Unfortunately, KVM does not require opt-in for the feature, and
unconditionally provides it to guests when available.

This is extremely problematic for operators who want to ensure guest
migrations are rollback safe. If an operator were to live migrate guests
to a kernel with KVM_CAP_PTP_KVM and subsequently need to roll back the
kernel, guests that discovered the hypercall will get fussy *very*
quickly.

Plug the hazard by introducing a new capability,
KVM_CAP_DISABLE_PTP_KVM. To maintain ABI compatibility with the
aforementioned change, this cap is off by default. When enabled, hide
the KVM PTP hypercall from the guest.

Fixes: 3bf725699bf6 ("KVM: arm64: Add support for the KVM PTP service")
Signed-off-by: Oliver Upton <oupton@google.com>
---
Patch cleanly applies on v5.14-rc7. Delightfully untested beyond
building it :)

 Documentation/virt/kvm/api.rst    | 13 +++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arm.c              |  5 +++++
 arch/arm64/kvm/hypercalls.c       |  7 +++++--
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index dae68e68ca23..4866418a2bb6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7241,3 +7241,16 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_DISABLE_PTP_KVM
+----------------------------
+
+:Architectures: arm64
+
+This capability indicates that a VMM may disable the KVM virtual PTP
+service for a guest. KVM_CAP_PTP_KVM introduced support for this
+hypercall interface, but it is unconditionally enabled without any
+opt-out.
+
+When this capability is enabled, KVM will hide the KVM virtual PTP
+service from the guest.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..8795228aa08e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -136,6 +136,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* PTP KVM hypercall disabled for this guest */
+	bool ptp_kvm_disabled;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0ca72f5cda41..b8f3b2eafd45 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -103,6 +103,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_DISABLE_PTP_KVM:
+		kvm->arch.ptp_kvm_disabled = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -217,6 +221,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_DISABLE_PTP_KVM:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 30da78f72b3b..8e9f2e1329e7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -62,6 +62,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
+	struct kvm *kvm = vcpu->kvm;
 	u32 feature;
 	gpa_t gpa;
 
@@ -128,10 +129,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
-		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		if (!kvm->arch.ptp_kvm_disabled)
+			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
-		kvm_ptp_get_time(vcpu, val);
+		if (!kvm->arch.ptp_kvm_disabled)
+			kvm_ptp_get_time(vcpu, val);
 		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..d8419c336ec8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_DISABLE_PTP_KVM 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

