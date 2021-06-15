Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFFA3A80FC
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhFONnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhFONmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:55 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2503CC061147
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:21 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id r8-20020a0562140c88b0290242bf8596feso10142369qvr.8
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MzTuqOfSLXkQXPIBooH4fP63ZLmEi4w/w9F0qFeyLuI=;
        b=b7HMusMXDb/BxYrxekRaLBxg6+8Di6dNYMsHoZDx91Rw74oEQIqQpEq4tZYgXlM9Bq
         vBq9n+In91lMzAjJUtBV2Qu2CPHCKbd9illCEiWAlYwAgEaftP0NYm7BNePEToWqmCCn
         7pVSLwwRKSPKsT64YEkG5/LzzS+jWXFoy+P6Inh6ochfcO7ZoZuX0kLF/J7TNi9BHi96
         5VDUuCwqtxO3gINwdOreBNN5T2Yir3rmT17+JqIg3gxAsrmpqEyfo9AT2MUfC3dBApjL
         jYoPAG42lxBJXkEvBK8FjZwPr8Bf5LH/9q+VgPrdh0UubiS6CyOU9vemBBgXNldhL5zL
         mWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MzTuqOfSLXkQXPIBooH4fP63ZLmEi4w/w9F0qFeyLuI=;
        b=AXOqPsyaa9o0D9TSfyOsAXPArWRerWIY2i37AqeDmta2QEu1F5LBcDKEK0Sk8AXllR
         g8ZbO/E5Vkb4FL3ELsciNfYympfXtcjgOjJgpXFqP06CQE9ewKUFS0fTMe1UUlLlsLnZ
         O7gwS76yxzAamYHNdCDpQBcNpAdzBt+K9xf9iVdETMGu1gkidzQydH5LkmJ0rrvMlsSe
         ALdFoGHBuGcTcLIA+JzVaElZwdudAVXAQWYleX7Z3EajXH6qkIYC/h1f0X+C6FO3M1Wr
         UimGMM4N+eRtVONx7ohO7/kIfTvLBM0tvtPTatGnkMbtN5PfxwjvPc/BV6i8I6Kr2gFl
         uidw==
X-Gm-Message-State: AOAM533YmCOXr5xksGhg1xEloS3JVFBcMlXn2EMJKEsbSDOjROX1ExcU
        gmal7UPhKAQjJi/JmuNP1l6V3XD/FA==
X-Google-Smtp-Source: ABdhPJwvkJ1Cqi1cwhQ8+25SscFqILXhxSW+c+DE3yisa7Q5WIyh+leztx9V8c334RDLLSz46bw6zNHG1g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:5309:: with SMTP id y9mr5312176qvr.31.1623764420268;
 Tue, 15 Jun 2021 06:40:20 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:50 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-14-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 13/13] KVM: arm64: Check vcpu features at pVM creation
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that a protected VM enabled only supported features when
created.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf624350fb27..15a92f3fdd44 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -88,10 +88,53 @@ static void pkvm_teardown_firmware_slot(struct kvm *kvm)
 	kvm->arch.pkvm.firmware_slot = NULL;
 }
 
+/*
+ * Check that only supported features are enabled for the protected VM's vcpus.
+ *
+ * Return 0 if all features enabled for all vcpus are supported, or -EINVAL if
+ * one or more vcpus has one or more unsupported features.
+ */
+static int pkvm_check_features(struct kvm *kvm)
+{
+	int i;
+	const struct kvm_vcpu *vcpu;
+	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	/*
+	 * Support for:
+	 * - CPU starting in poweroff state
+	 * - PSCI v0.2
+	 * - Pointer authentication: address or generic
+	 *
+	 * No support for remaining features, i.e.,:
+	 * - AArch32 state
+	 * - Performance Monitoring
+	 * - Scalable Vectors
+	 */
+	set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
+	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
+	set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
+	set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!bitmap_subset(vcpu->arch.features, allowed_features,
+				   KVM_VCPU_MAX_FEATURES))
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
2.32.0.272.g935e593368-goog

