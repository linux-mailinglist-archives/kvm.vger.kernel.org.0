Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE477D539
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240320AbjHOVgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240330AbjHOVf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:35:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392921FCB
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d664f9c5b92so5467245276.3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135351; x=1692740151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CxcghMO4oqjMEN7NjAyYvu8EEPu+7dtIkj0PyyVU1PY=;
        b=UGhD9P3fwdCHLmsPnxBCw3IYw9fOU6RCS+CQwGE8IF1AWIgaPQgWFwxsPo3orqd5WN
         JKwbQYGkn5xQAiaPPerJL/k0tWOtPbnEpwCSUoHp9lwxKvsIwjPAs/TrAdaVgz7YrDpr
         YBDkuDs/nY2xT9YLhf/G+X3WmSckYw83Xm1NGjnqC2R7PR63CKD3kVBBKudi7KlMxjQM
         26OLmeO573eo+M6qYuUbUdYVv4VpupZ+xghORV2sVTR0bKsK6cjerz7uRPSvM3wPOX+t
         RjUhmUrYBYjQvHe4K4LTOkEC+rlHBm2zWYYyeMJBOwUVfwBP7Vi2jkgDroKaTHQJGGj0
         NsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135351; x=1692740151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CxcghMO4oqjMEN7NjAyYvu8EEPu+7dtIkj0PyyVU1PY=;
        b=HVU8iRcrwcVXiiESfA/DV9K4T7XFEaZOzpfbqa7BHrm7QejEe41F2lvRjcH2K0eJee
         e/KvSRQFMzPzy1HiwtNAeHbJufQsviiQmyJl7ROiUxK0Al+cbuvWiHN1T3E3frkfybdm
         TCMsONoFF882ls/pG5TAvpWwncuOTHkqUt3DLLNW+WE+4xYxDDYZF/Gb5Mm52YYvQZqm
         6dprWlh6HJoupRCjqLND8++kCiq5PaeJjG4nIVEOkcql7pvL5HLOURbtSgWdnfc+U8dd
         zKEOmE+jJeekDXSZRL8+bkIS6Xu14HAWxeUIZIJ4MdlDp8s9rN0RpX5Fh7moovi2KwwU
         aibQ==
X-Gm-Message-State: AOJu0Yw/SL/gIJhnxUBv1cFvFeRZvEvTAe/XLCSMrPxpFUlerQq/SDT3
        qWOtQmtnk+PBhoc7VeKogBWlHjZkbVE=
X-Google-Smtp-Source: AGHT+IH/wuwBL/LCXf2KX0BggSJOFAhvk+tGLuKVrUxDAKbe8bS9qAslf27WVZxhdW5q8B/OCgwFoC140tI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cf8c:0:b0:d10:5b67:843c with SMTP id
 f134-20020a25cf8c000000b00d105b67843cmr56ybg.4.1692135351506; Tue, 15 Aug
 2023 14:35:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:30 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-8-seanjc@google.com>
Subject: [PATCH 07/10] KVM: SVM: Inhibit AVIC if ID is too big instead of
 rejecting vCPU creation
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inhibit AVIC with a new "ID too big" flag if userspace creates a vCPU with
an ID that is too big, but otherwise allow vCPU creation to succeed.
Rejecting KVM_CREATE_VCPU with EINVAL violates KVM's ABI as KVM advertises
that the max vCPU ID is 4095, but disallows creating vCPUs with IDs bigger
than 254 (AVIC) or 511 (x2AVIC).

Alternatively, KVM could advertise an accurate value depending on which
AVIC mode is in use, but that wouldn't really solve the underlying problem,
e.g. would be a breaking change if KVM were to ever try and enable AVIC or
x2AVIC by default.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/svm/avic.c         | 16 ++++++++++++++--
 arch/x86/kvm/svm/svm.h          |  3 ++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 60d430b4650f..4c2d659a1269 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1243,6 +1243,12 @@ enum kvm_apicv_inhibit {
 	 * mapping between logical ID and vCPU.
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
+
+	/*
+	 * AVIC is disabled because the vCPU's APIC ID is beyond the max
+	 * supported by AVIC/x2AVIC, i.e. the vCPU is unaddressable.
+	 */
+	APICV_INHIBIT_REASON_ID_TOO_BIG,
 };
 
 struct kvm_arch {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bd81e3517838..522feaa711b4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -284,9 +284,21 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
+	 * hardware.  Do so immediately, i.e. don't defer the update via a
+	 * request, as avic_vcpu_load() expects to be called if and only if the
+	 * vCPU has fully initialized AVIC.  Bypass all of the helpers and just
+	 * clear apicv_active directly, the vCPU isn't reachable and the VMCB
+	 * isn't even initialized at this point, i.e. there is no possibility
+	 * of needing to deal with the n
+	 */
 	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (id > X2AVIC_MAX_PHYSICAL_ID))
-		return -EINVAL;
+	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
+		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_ID_TOO_BIG);
+		vcpu->arch.apic->apicv_active = false;
+		return 0;
+	}
 
 	if (!vcpu->arch.apic->regs)
 		return -EINVAL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a9fde1bb85ee..8b798982e5d0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -632,7 +632,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
+	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_ID_TOO_BIG)		\
 )
 
 bool avic_hardware_setup(void);
-- 
2.41.0.694.ge786442a9b-goog

