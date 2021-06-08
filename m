Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2539F8B1
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhFHOPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:15:21 -0400
Received: from mail-wm1-f74.google.com ([209.85.128.74]:59924 "EHLO
        mail-wm1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhFHOPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:15:20 -0400
Received: by mail-wm1-f74.google.com with SMTP id n8-20020a05600c3b88b02901b6e5bcd841so129949wms.9
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k1l2n59g13iNu83bUTxARpOhgMKflgQ04MOsDPUh0Ic=;
        b=HKMRwVfndsrVEdmwwjp+AJfDUAU/7SHKuQu+f50Ph5TxJeikrk3f1yLdxBBbNGalK4
         1OsQdR3D7asjd+1UcEgIGwjwfNFpdR4INjRegFwmCpjoHIFrG4VisTD9D+yw0wOrihMD
         u+jS5KLKNo5J22J7NPibJPCz8HM4C4uXx57pgOf5PT9cJ5hlU5DjgyMov1wcyirmTTfd
         DmnL7lIfo9JWERgn13Mn1FX+q3udhEE6m24+t2J5Y7wWHEcarMFKH81jyvkAkw1iirzX
         ujxnJb0sk3tt2uylf6jCDqe33eE8qI8MQtloA22FQDfL0qlJumIPI3wJ6LXAx0k2kXcR
         LVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k1l2n59g13iNu83bUTxARpOhgMKflgQ04MOsDPUh0Ic=;
        b=BXs0sxUFZHzjZGnX0oSWskddjzsMakT3JRAFtLCo4kjJXzQRxhfWl3uUihyDov9oTz
         lLYcIkuxMMhU2dBBCq+QkQbVboYBF5eRV9lkcaWKSjyqHmj944ExNOHAJxhMJ8VmSHzu
         +K56TX8s3tvpO8sD8F92TkqxcYnjw734F6XtXvawqsG01xRh9yDAEalyfoXlDFa37GGr
         rHGb8S+RNOS5rXpG2g69/HoDMDm8g8kS4G8EgctyJF3m521y59cM9QQk99CEzhB5kpJw
         ERaSTgktHoIKtxsznLfleivPxYX5R4ZLTmc6mYIMeHLIkrAOk48GDYBLjtsU8MhTNwxx
         9pgA==
X-Gm-Message-State: AOAM532IIgUqHgwtDslpZt1LgeIKIjc23Qki2gq+g0wK5CpJ8vPaT9mp
        alB9L6dwRfySMW3WPJ2COR4Bcg6J4A==
X-Google-Smtp-Source: ABdhPJzXIHfxt5tac7kqNaZAg4dHpDxMG83Oc7gi7GtbAhXwc3s7cpEqjJlIIcQ1S8LZ+Ld/XnKDm6HcjA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fd0:: with SMTP id
 o16mr4554612wmq.50.1623161530591; Tue, 08 Jun 2021 07:12:10 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:41 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-14-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 13/13] KVM: arm64: Check vcpu features at pVM creation
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that a protected VM is not setting any of the unsupported
features when it's created.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf624350fb27..5e58d604faec 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -88,10 +88,41 @@ static void pkvm_teardown_firmware_slot(struct kvm *kvm)
 	kvm->arch.pkvm.firmware_slot = NULL;
 }
 
+/*
+ * Check that no unsupported features are enabled for the protected VM's vcpus.
+ *
+ * Return 0 if all features enabled for all vcpus are supported, or -EINVAL if
+ * one or more vcpus has one or more unsupported features.
+ */
+static int pkvm_check_features(struct kvm *kvm)
+{
+	int i;
+	const struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/*
+		 * No support for:
+		 * - AArch32 state for protected VMs
+		 * - Performance Monitoring
+		 * - Scalable Vectors
+		 */
+		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features) ||
+		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
+		    test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int pkvm_enable(struct kvm *kvm, u64 slotid)
 {
 	int ret;
 
+	ret = pkvm_check_features(kvm);
+	if (ret)
+		return ret;
+
 	ret = pkvm_init_firmware_slot(kvm, slotid);
 	if (ret)
 		return ret;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

