Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98284443D13
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKCG3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCG3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:29:53 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AE5C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:27:17 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t62-20020a625f41000000b004807e0ed462so806677pfb.22
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eVXFsIu2A0jcHNwkwUYO+pTUIoPZ1YXwb8zzymW3agQ=;
        b=XD1dMhNRonxvZZ9i2UCcZCoIvIEj9v7vxdtIWeG0WTFpcrY4lN/dj+JeBCeRGtUs+b
         TKOC+JBs+wHF9sqEOE+NK+uX7MR7JGXuZ/97c2qmTC9prsj9gzFwFDUkQBwwEwaW3KMx
         /CPyyLPCvdbnsY8rtKtXzgvMrI6FOl0KEcIi7a+KusBwBBGfCdZrwuakzoKxbGaE1Hpe
         kEWU+ZfLgmoWcFVw+9lQjr5zGO6EGaJfXCH2ifB88gJk2oENMhuChuVILNxWj087Pa6l
         3gO5JSvtCAnNz2AFkvgeb9oDEv+Cg2swChDGNWLQMmmXx65F2wRetqzAntKGaBGB/5bM
         /G1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eVXFsIu2A0jcHNwkwUYO+pTUIoPZ1YXwb8zzymW3agQ=;
        b=16I9RClf9QaE2pLDJ7DNeCDWTIu2pkWNkatvTWv36IB35uu5OZd6RSQDsoZzcWUMnS
         IyL2/kD6tBAue1Fl9BeGt9DlpTaIUV1P0hFHSfWJIaV2RY4wF0BQhE3X0FfgUNk1mETD
         q8EG2k/9JGHGDwxQl3d+6QVjJI6mJSUF2dkQsz5F9h84cZrow4qxKciZUUKnbk6fcVL3
         XfRmgaJrh5jpQlY6ATUSmn4sysiHu9TQvZuD4+fMR0xzooSaheSx8zLVYwTupMYpz2wf
         L6O+16gKopF78ZRJle3xmj5W1vSgdPFpss405X2RI5VwGJfAWfQK2teb0THuBuFQ8s9W
         UB5Q==
X-Gm-Message-State: AOAM531kBQXb3+lkJ/olpQRq8FLbCj+jbA3iVVMspExoKZmlXIBT1YKc
        /QiExC+nDLCvlS9uMUVg4ZE74VR5iQU=
X-Google-Smtp-Source: ABdhPJwf4BoucPOZITph2SZD/P4CzLQM8u6ddsbijqFxfHoaATosOtV5geGGgyUp899HzSt2uQ0f+XQH+PU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:dacb:b0:141:e931:3aff with SMTP id
 q11-20020a170902dacb00b00141e9313affmr17384890plx.50.1635920837395; Tue, 02
 Nov 2021 23:27:17 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:24:53 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-2-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 01/28] KVM: arm64: Add has_reset_once flag for vcpu
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
if the vCPU reset has been done once, for later use.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/reset.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..9b5e7a3b6011 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+	bool has_reset_once;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
+#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ce36b0a3343..4d34e5c1586c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	if (!ret && !vcpu->arch.has_reset_once)
+		vcpu->arch.has_reset_once = true;
+
 	return ret;
 }
 
-- 
2.33.1.1089.g2158813163f-goog

