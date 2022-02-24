Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75784C33B4
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiBXR0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiBXR0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:26:46 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD9D278C95
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:15 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 97-20020a17090a09ea00b001bc54996b62so3933463pjo.3
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OsZB1WQ6lcTDQc8TII8Z2w2H891AEk6o7uXrnU60Sz4=;
        b=n/F4ja1wwLJBW/ijXvomC0vFaa1Gbh0XTIQ72X/rtTtlaWrnWJVjVDVQnw0Chugj0j
         s8eGLxLruJTXlJ3udhRPkErT9dlaCCvq+4Pc/4AyP6fslw5wApjjMzXxR5JolWEo3Uhn
         /xF8xB+oMyZoF8zM+m9Y3UAvlg9Q5fezULZ3Z37nGxzJzBcGlg2zHbru5rcSqCNNtg96
         iSGxIhYOowJ4KOjg8isnidQLFfTqDemO76gaoctt3D7t2fR4oP7+MifAHi8KKPk6R9uU
         ke+J+3OxaxPspS1mFy6prNU6GZzF3ophbL5sU3A7T9zPgk19vFCo7IozP+KWOWWnuJ5v
         YFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OsZB1WQ6lcTDQc8TII8Z2w2H891AEk6o7uXrnU60Sz4=;
        b=VcwuiOWnhsHQ9BNj5XSHSrZVdq+pNpEBUKQsL6uTPntNzfqUsr1PIUOll56HYx1EHM
         spTOUJDuGrSGuLliEs4B464Ljxp5mdxK8icycdbLizgo+x2DcvD7xeGwSR9xKNaMVfWg
         EiAWrxDezjNLT9sxYApTDHfX/hIvmyNZbHPMSHon1YvWhYi8jDdSMr+HnbTOq9t/o4Zv
         ZnDBnYLQo5/vUkkooG/p+uUoIhsFZqHa+39giLO/SuqKtMfpkaQch+jaPY3KmHVErPQo
         OIUxV8t2f0u9Etni1HyoLQLE20EcOlVvxQ8+sPGuAQNPlFbuU2fjaogT1XKNbkg54ype
         uBLQ==
X-Gm-Message-State: AOAM5302WHpomuEVhIITXrxn0o4z8M/Jz8qHFwnJ4fvSH0xH6wndRnP4
        7A3LzeiThJtomgpUVMxWOD+YVUTo5706
X-Google-Smtp-Source: ABdhPJwNVZA2Yo1/QQAgM2dA9o//8LsSbVv/DS6uJksGu0XtYEWfniXtgFLtkwUsjMzINEE1xgsyTvGjlEWP
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:2c0c:b0:1b9:fa47:1caf with SMTP id
 m12-20020a17090a2c0c00b001b9fa471cafmr3880202pjd.34.1645723575490; Thu, 24
 Feb 2022 09:26:15 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:25:50 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-5-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 04/13] KVM: arm64: Capture VM's first run
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture the first run of the KVM VM, which is basically the
first KVM_RUN issued for any vCPU. This state of the VM is
helpful in the upcoming patches to prevent user-space from
configuring certain VM features, such as the feature bitmap
exposed by the psuedo-firmware registers, after the VM has
started running.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 9 +++++++++
 arch/arm64/kvm/arm.c              | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 657733554d98..e823571e50cc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -139,6 +139,9 @@ struct kvm_arch {
 
 	/* Register scoping enabled for KVM registers */
 	bool reg_scope_enabled;
+
+	/* Capture first run of the VM */
+	bool has_run_once;
 };
 
 struct kvm_vcpu_fault_info {
@@ -796,6 +799,12 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
 void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
+
+static inline bool kvm_arm_vm_has_run_once(struct kvm_arch *kvm_arch)
+{
+	return kvm_arch->has_run_once;
+}
+
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
 extern phys_addr_t hyp_mem_size;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 107977c82c6c..f61cd8d57eae 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -635,6 +635,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
+	kvm->arch.has_run_once = true;
+
 	return ret;
 }
 
-- 
2.35.1.473.g83b2b277ed-goog

