Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1B154BC1B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358371AbiFNUtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358290AbiFNUsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C472B4F47A
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 78-20020a630051000000b003fe25580679so5494754pga.9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0hBUVDYa1V63NknO05YZpgVFJQbVlF6OGvqwo1CHEa8=;
        b=qO096xhzhbmoBbXvOug/Fwiz2wA7YD0H5/c+9kRUBfOC2Hlx1VOp+cxVtQLEw5+zKt
         Hs1N95XeROECeMdKDiWNnRC1yJsW+iq0JgaN2fvns2FKebq26CnCzam05LJv8nRaajmv
         J3GrqT6Lj6oUBUYkNUPibkotf41mXR/L5uhnteJJiTzk8e1UG/aGhXAtEadP+nZpHah7
         obv5nMga3+BvcWOjfFShmZjyaFOw80ZG+5eZllbCoXPT22aPQmLfdmFv5SZIsBOA/YAO
         uG1JAjuW7yKDGAcbm6aqvk/q7b87z3V9pAOcxPFqOMk04vC5Vc9WPJeoGTh17lvltbGi
         H14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0hBUVDYa1V63NknO05YZpgVFJQbVlF6OGvqwo1CHEa8=;
        b=TbzDHkkNxVD97oDCAXKPrK+i1t2NZadYKeQ+e1eMb/tEGDogTEGepsGBa8Pts0C665
         CyVHYz9jl4jAvaCBIWPHK6L8MFcIUqga7l0nSL0Ud2Ep8PWejzWWjrK/iX/4IcGcb1Cf
         BmUtE6opt8XsXWPmdBS4D9CNhx8ql2ddqzVZThuGhAg0GAdpD4nm86nFLJZsKvpRYOmj
         uyf64LAWmRynN7nvnqluOPznmfDlidCfmzPhc3ABjqv/TgYIUj5a8b45F1jJlJ+l9pkp
         Xrx/xQZLK5N7+4Cz2ArnrnA2PM4wVk+ZTgLb5Xt4Ximpe3lHKKpc54LKuvc4JD7z2Rwi
         exEQ==
X-Gm-Message-State: AJIora8caL93Zg5/6iEh+gDYbJ0GrUIYBHzNJdGlV58cQbS7mUjPpNij
        8xVOcuJU25acaEsbmDcjo9nNe/EJsVo=
X-Google-Smtp-Source: ABdhPJxUNhxNhuLUDcuLfIjlgQaeLj1jqxeYHrVLquCta8611mU2pbL0A7hHK9zF5w1lB0T8KzFZivfIweo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23ce:b0:50d:823f:981 with SMTP id
 g14-20020a056a0023ce00b0050d823f0981mr6614960pfc.10.1655239681604; Tue, 14
 Jun 2022 13:48:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:23 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 14/21] KVM: x86: Use kvm_queue_exception_e() to queue #DF
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Queue #DF by recursing on kvm_multiple_exception() by way of
kvm_queue_exception_e() instead of open coding the behavior.  This will
allow KVM to Just Work when a future commit moves exception interception
checks (for L2 => L1) into kvm_multiple_exception().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 511c0c8af80e..e45465075005 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -663,25 +663,22 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 	}
 	class1 = exception_class(prev_nr);
 	class2 = exception_class(nr);
-	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
-		|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
+	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY) ||
+	    (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
 		/*
-		 * Generate double fault per SDM Table 5-5.  Set
-		 * exception.pending = true so that the double fault
-		 * can trigger a nested vmexit.
+		 * Synthesize #DF.  Clear the previously injected or pending
+		 * exception so as not to incorrectly trigger shutdown.
 		 */
-		vcpu->arch.exception.pending = true;
 		vcpu->arch.exception.injected = false;
-		vcpu->arch.exception.has_error_code = true;
-		vcpu->arch.exception.vector = DF_VECTOR;
-		vcpu->arch.exception.error_code = 0;
-		vcpu->arch.exception.has_payload = false;
-		vcpu->arch.exception.payload = 0;
-	} else
+		vcpu->arch.exception.pending = false;
+
+		kvm_queue_exception_e(vcpu, DF_VECTOR, 0);
+	} else {
 		/* replace previous exception with a new one in a hope
 		   that instruction re-execution will regenerate lost
 		   exception */
 		goto queue;
+	}
 }
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
-- 
2.36.1.476.g0c4daa206d-goog

