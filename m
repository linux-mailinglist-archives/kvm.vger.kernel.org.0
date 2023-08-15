Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24C77D534
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbjHOVgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240293AbjHOVfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:35:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D071BF3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589cd098d24so56957127b3.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135340; x=1692740140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bCGvdYVO9EKbpa2jmZF0w8IsHUC4STqQLwNPEWIlFrg=;
        b=4seg8jbUuzcf+Jrd/1/VCZUZyBFVOg1OI+RgVOOd17/vtRlmnaSGCfGp+yaEQXkaUV
         T93drzsN5+fFePzUoNFE5SkAYPYATw3WDE7OlPsPwxwzAMhJUK4DDKasrG347gUl0E0m
         bjiWWESP9bDXOkIXBXe5d/i1vj2ID5gyS8VmBT98ZfA0J7RSycx3pK9aDweUnUg1pEpZ
         OMJRY5agn0k5JzWysk/6LYC5fkHk1aZcSyGv+bny6dm9yLROA7+zldsiELd3m9avnZ+y
         AOqsx3XjHgeRNK9pgBLcqe3SoweWvFnkgZGQmTVd+2LdyxnWwa93d1buUfX/MTMzuYaq
         imaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135340; x=1692740140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bCGvdYVO9EKbpa2jmZF0w8IsHUC4STqQLwNPEWIlFrg=;
        b=dJe2n2JeL1f57gSyNGUPVE9IkzNnq5+rhGan9PSU+gMaYRxkORDYrD1VMi/tmvvMmP
         PvakedOVZjHWcTsY9mMqiAoxFT307athRbvxOmqLpGOnux/CT+l9pizj3eREQpcuS0qA
         8HgAcjdaNhYU7NJKD72wKNsB897p3feZKM0NgLjOKn23s/odGxonoZ1xB3h/u6YWI+vR
         G+JcDXkrBgq39OzkSKQ+H/PufRVJpvq/vp1zcPU128v5v5fFJDBXboUk0vWOh7oV1BXI
         9P81+tE3g05wLj689/oqMIbg0YQONBP1hlDIdo1eY6PEmKs4iwhhdKYXPBUO1mloBMnz
         h0WQ==
X-Gm-Message-State: AOJu0YxIozCz9ax+LKKK+Lf9WijVWiL79OOmG3WDrvLBR5jZoTYPNouQ
        P7UXG1Gzbdw3I9AdbiK9Nl3T9izDuBQ=
X-Google-Smtp-Source: AGHT+IGRuzrjE+vpyIzdyF/OQOo1U5zpH5XKrPubx9S5xZyoHO/CMSeIvVbf4AW+/aR8z9iCg8Y6aE7RL/Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af27:0:b0:579:f832:74b with SMTP id
 n39-20020a81af27000000b00579f832074bmr200736ywh.10.1692135340576; Tue, 15 Aug
 2023 14:35:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:24 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-2-seanjc@google.com>
Subject: [PATCH 01/10] KVM: SVM: Drop pointless masking of default APIC base
 when setting V_APIC_BAR
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop VMCB_AVIC_APIC_BAR_MASK, it's just a regurgitation of the maximum
theoretical 4KiB-aligned physical address, i.e. is not novel in any way,
and its only usage is to mask the default APIC base, which is 4KiB aligned
and (obviously) a legal physical address.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h | 2 --
 arch/x86/kvm/svm/avic.c    | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 72ebd5e4e975..1e70600e84f7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -257,8 +257,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define AVIC_DOORBELL_PHYSICAL_ID_MASK			GENMASK_ULL(11, 0)
 
-#define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL
-
 #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
 #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
 #define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cfc8ab773025..7062164e4041 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -251,7 +251,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
+	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
 		avic_activate_vmcb(svm);
-- 
2.41.0.694.ge786442a9b-goog

