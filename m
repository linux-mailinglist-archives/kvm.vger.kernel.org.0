Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3039FB42
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 17:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhFHP4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 11:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhFHPz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 11:55:58 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020ECC061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 08:54:05 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c5so22091480wrq.9
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 08:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6VUTi6r0zGjvD+ox5LbEVdcu7SOJ3CxYqosX/6quRvc=;
        b=iZxQMnxOlNisd6FMWcutFJg9ihWBRrP18+4KoCR7isLbBgJRjV2h9bm7ro5tM0SuA5
         MKA963p2Fjmaerhs0VLNc3mXjmVJbt4LXKOds3/hhLBfPZTNhM4ALrICmh9wRHLm3mDj
         9X0bwod0yko2OzqVbHqT6E91S1tWi3hL1+YyfpA/AefIXhN0izWgnv2m4AsrQM4gTRFb
         XPGRIVmgyNb6TPkqf5zH5+OpFuMLdvJItw67EM2UPkwxqiE40pkNyBxiSgrBs7QNMC1Q
         UqgLxRznUGNuKj9K/rYCy6GTXUiiCElOBKA3oqupM1W8sLyaqix9NLGflqG3lQaM8Z05
         rHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VUTi6r0zGjvD+ox5LbEVdcu7SOJ3CxYqosX/6quRvc=;
        b=SC+WTTWtaZ4p6Rwqh5hd3Wfa6PVKU0VwCTWoYeMaaiRor8dxipDzv/w9b887ATuzuY
         QnPQg8Sd8lFaU21Sc36uDD+UDfEnObnxZU1JSqhPW6YGMAM1272oPqaqfj5OxdnraICr
         gGUGilNrLOtM0ePC1y37flMWaWJAyaFfTfE470p8495l3hNoe+fmDhwZMF03kY6kPyxc
         E6XOHmuUf5rU5PeSP9CSChfvM5oMZlPDutpfMgLjPv3Oh4qFTCHXTWYUkeKfqxjGbiVz
         jDUanNfLGAyJRFbs2cx0F4u5+Li2ukeQvma3R/VSrjgBQpABEaaYkbNb3Q3Yxm6Zg9A5
         /v6w==
X-Gm-Message-State: AOAM533YGuyAg0K4iexDt0GPc+2vZg2nkw7l11EpV0jLJHlwZ2famxkd
        YyJ8wzFZLPW04iAR877i20aDdw==
X-Google-Smtp-Source: ABdhPJy61JSG9YYU4eU/zql91JN1YArLPTW12IIWCRmtkz+g9RAUJUbtnqHF/W7eyUKs8LNMBHfbCw==
X-Received: by 2002:adf:e50b:: with SMTP id j11mr22681729wrm.377.1623167643627;
        Tue, 08 Jun 2021 08:54:03 -0700 (PDT)
Received: from localhost.localdomain (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
        by smtp.gmail.com with ESMTPSA id l31sm3314180wms.16.2021.06.08.08.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:54:03 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     maz@kernel.org
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        lorenzo.pieralisi@arm.com, salil.mehta@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 3/5] KVM: arm64: Allow userspace to request WFI
Date:   Tue,  8 Jun 2021 17:48:04 +0200
Message-Id: <20210608154805.216869-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help userspace implement PSCI CPU_SUSPEND, allow setting the "HALTED"
MP state to request a WFI before returning to the guest.

Userspace won't obtain a HALTED mp_state from a KVM_GET_MP_STATE call
unless they set it themselves. When set by KVM, to handle wfi or
CPU_SUSPEND, it is consumed before returning to userspace.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Documentation/virt/kvm/api.rst | 15 +++++++++------
 include/uapi/linux/kvm.h       |  1 +
 arch/arm64/kvm/arm.c           | 11 ++++++++++-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7fcb2fd38f42..e4fe7fb60d5d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1416,8 +1416,8 @@ Possible values are:
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
                                  now ready for a SIPI [x86]
-   KVM_MP_STATE_HALTED           the vcpu has executed a HLT instruction and
-                                 is waiting for an interrupt [x86]
+   KVM_MP_STATE_HALTED           the vcpu has executed a HLT/WFI instruction
+                                 and is waiting for an interrupt [x86,arm64]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
    KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
@@ -1435,8 +1435,9 @@ these architectures.
 For arm/arm64:
 ^^^^^^^^^^^^^^
 
-The only states that are valid are KVM_MP_STATE_STOPPED and
-KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
+Valid states are KVM_MP_STATE_STOPPED and KVM_MP_STATE_RUNNABLE which reflect
+if the vcpu is paused or not. If KVM_CAP_ARM_MP_HALTED is present, state
+KVM_MP_STATE_HALTED is also valid.
 
 4.39 KVM_SET_MP_STATE
 ---------------------
@@ -1457,8 +1458,10 @@ these architectures.
 For arm/arm64:
 ^^^^^^^^^^^^^^
 
-The only states that are valid are KVM_MP_STATE_STOPPED and
-KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
+Valid states are KVM_MP_STATE_STOPPED and KVM_MP_STATE_RUNNABLE which reflect
+if the vcpu should be paused or not. If KVM_CAP_ARM_MP_HALTED is present,
+KVM_MP_STATE_HALTED can be set, to wait for interrupts targeted at the vcpu
+before running it.
 
 4.40 KVM_SET_IDENTITY_MAP_ADDR
 ------------------------------
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 79d9c44d1ad7..06ba64c49737 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1083,6 +1083,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_ARM_MP_HALTED 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d8cbaa0373c7..d6ad977fea5f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_MP_HALTED:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -469,6 +470,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	case KVM_MP_STATE_RUNNABLE:
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		break;
+	case KVM_MP_STATE_HALTED:
+		kvm_arm_vcpu_suspend(vcpu);
+		break;
 	case KVM_MP_STATE_STOPPED:
 		kvm_arm_vcpu_power_off(vcpu);
 		break;
@@ -699,7 +703,12 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			preempt_enable();
 		}
 
-		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu)) {
+		/*
+		 * Check mp_state again in case userspace changed their mind
+		 * after requesting suspend.
+		 */
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu) &&
+		    vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
 			if (!irq_pending) {
 				kvm_vcpu_block(vcpu);
 				kvm_clear_request(KVM_REQ_UNHALT, vcpu);
-- 
2.31.1

