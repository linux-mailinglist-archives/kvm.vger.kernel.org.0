Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9F17CE79A
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjJRTU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjJRTU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:20:26 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48C6114
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:20:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9e994fd94so47220475ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697656824; x=1698261624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H7ppnBIIrbmfIJgnyx9B9RiTitNvmGmwskuXYW2Y3sk=;
        b=Eh+lgmU/yLFcI4f/ahRmW3zanjUCZG9OkK3vNWgq1j9GrPbUBhq09t376RbY1BBXDo
         JbspcSvDp2LYTk/d4EXp/e17UBoGy/w1vjEOGKf24/ZOQHfJ6++hoO1pVb2Fj5HAAJFG
         zzBNeEQqFXeitii8VRQ0+lQ6uP/aZd83yq24Fd0fWwARrYErbsgspqURWOaA1MQpMBR0
         aj5jhWZUBIX27A0ThvrEoq/onaw3UnjKlK1I9jdKhm9p90xZ/9L6JsBQ8MgPuF+pCakc
         XvKdftOY3ezawUHR1D1a03Y8+rOxPbSsN+lUJ70bfNId7wasXeEQ4vjWoT9EUafYnezx
         I6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697656824; x=1698261624;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7ppnBIIrbmfIJgnyx9B9RiTitNvmGmwskuXYW2Y3sk=;
        b=iIOKcO5Ry0RI2qWYVDTrMeZoCEkPGXn1zhbo8SfFCxbvks0hCx/t3DbnEhfO5jqZ2C
         v4Z+CKtBoegj3kmIPIGH4UGgE18OJOk3iD7zZbX/Qa9wILC3BeVtGMyZ0E3p5unpME3J
         CA4HoBg1/bIa1jH9aTDpuS4KWnKdHJkqo9Mmn7DBDwT9yJQbgsRC2tiKMR+jC9hlyrX/
         +L7rkRugYObC4oy/mf5bYYVhMeqn3QT0FaQqHGDswVVFItC0dFMkGD7/HIe82xur8l7Q
         Ab5f5z/+zeMKOiD2RUlVWwr+OsM9r35IkWF7xwCPxSe9c952va2mFTviYhFncFT9C8qq
         kqHQ==
X-Gm-Message-State: AOJu0YxvhJDVkOqJjj/1DHgmACfSQaHR61LkHyAaYcWe33x+lANbhQLh
        oaxnyOcGLn76HGHhirCg2JuD+eKg84I=
X-Google-Smtp-Source: AGHT+IF8fprxOwg9NLxhNoiGVvB0E6ikGR9g208TVUDNojr9nRxzSrwsgdHktxGZJqj/q79lONDYyGyPxWM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c9c4:b0:1ca:a382:7fc1 with SMTP id
 q4-20020a170902c9c400b001caa3827fc1mr6069pld.12.1697656824132; Wed, 18 Oct
 2023 12:20:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 12:20:21 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018192021.1893261-1-seanjc@google.com>
Subject: [PATCH v2] KVM: SVM: Don't intercept IRET when injecting NMI and vNMI
 is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
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

When vNMI is enabled, rely entirely on hardware to correctly handle NMI
blocking, i.e. don't intercept IRET to detect when NMIs are no longer
blocked.  KVM already correctly ignores svm->nmi_masked when vNMI is
enabled, so the effect of the bug is essentially an unnecessary VM-Exit.

KVM intercepts IRET for two reasons:
 - To track NMI masking to be able to know at any point of time if NMI
   is masked.
 - To track NMI windows (to inject another NMI after the guest executes
   IRET, i.e. unblocks NMIs)

When vNMI is enabled, both cases are handled by hardware:
- NMI masking state resides in int_ctl.V_NMI_BLOCKING and can be read by
  KVM at will.
- Hardware automatically "injects" pending virtual NMIs when virtual NMIs
  become unblocked.

However, even though pending a virtual NMI for hardware to handle is the
most common way to synthesize a guest NMI, KVM may still directly inject
an NMI via when KVM is handling two "simultaneous" NMIs (see comments in
process_nmi() for details on KVM's simultaneous NMI handling).  Per AMD's
APM, hardware sets the BLOCKING flag when software directly injects an NMI
as well, i.e. KVM doesn't need to manually mark vNMIs as blocked:

  If Event Injection is used to inject an NMI when NMI Virtualization is
  enabled, VMRUN sets V_NMI_MASK in the guest state.

Note, it's still possible that KVM could trigger a spurious IRET VM-Exit.
When running a nested guest, KVM disables vNMI for L2 and thus will enable
IRET interception (in both vmcb01 and vmcb02) while running L2 reason.  If
a nested VM-Exit happens before L2 executes IRET, KVM can end up running
L1 with vNMI enable and IRET intercepted.  This is also a benign bug, and
even less likely to happen, i.e. can be safely punted to a future fix.

Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
Link: https://lore.kernel.org/all/ZOdnuDZUd4mevCqe@google.como
Cc: Santosh Shukla <santosh.shukla@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Expand changelog to explain the various behaviors and combos. [Maxim]

v1: https://lore.kernel.org/all/20231009212919.221810-1-seanjc@google.com

 arch/x86/kvm/svm/svm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1785de7dc98b..517a12e0f1fd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3568,8 +3568,15 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	if (svm->nmi_l1_to_l2)
 		return;
 
-	svm->nmi_masked = true;
-	svm_set_iret_intercept(svm);
+	/*
+	 * No need to manually track NMI masking when vNMI is enabled, hardware
+	 * automatically sets V_NMI_BLOCKING_MASK as appropriate, including the
+	 * case where software directly injects an NMI.
+	 */
+	if (!is_vnmi_enabled(svm)) {
+		svm->nmi_masked = true;
+		svm_set_iret_intercept(svm);
+	}
 	++vcpu->stat.nmi_injections;
 }
 

base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

