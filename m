Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF63B5F17D1
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiJABBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiJABAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E54C7962A
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b11-20020a170902d50b00b0017828988079so4257988plg.21
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=h+90iLbssT+2X1a302WPpFnb6f2TypfnLO84iY5RrGQ=;
        b=mfZNCXiGnI7p1ypGzL1ptYh32xDJBoAspoF6otY5o4Ynm+Uk57mzPT+wcqcPxQeXVf
         40To52bA44S5E2jpfqRz4OdbG9X+FL/OX2VRxFNrzeasSphJ9sf+FwTu2/mPCymNoKAr
         b1Y1lAaSD1OPqdpUQHync3ncJVBJYpohU1xQP0a/Z38It3zAafP47FvOpPMvYZ+/X5ir
         9O91TMuIq3K5mM2KpTzsDXDiXpsHpDH9kOwUbmPrzSPowY75geq4kuaP82LRqbWmZWl1
         oBFbWzEFLfOZv+VZ27KG7SjJQYhNDsfjOw4Xy8M6VhGjYw5uOC3JKJc6rLz61SnZ/M8U
         keZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=h+90iLbssT+2X1a302WPpFnb6f2TypfnLO84iY5RrGQ=;
        b=3yAcwWjrb3K0YZDXUhO1CjWaxKUAY+juDjY+hn9tcmaA/+4P9WH4UeyYvvtGaDGReC
         0Jql7wsFEirg1xR3tQLldP65d1hGue2QHK0coamH3TvnDf7cZ/C22sXtv5ub3DoNzeci
         x/CbS5TPm0Z/Zc1O1YCyxf3Bgnn5/sn2AXXBdlMstXIE0QdI9NaO1n0rOln4JOtosRnW
         KLnCieHCYJ2HFEqoQk75JLx8CmYzTu1BWMcOpmeEcakhjr19hvMq8Gpn5rNHA8maxqox
         BFVIqm+5ah0eiNs7OFM1DYvZO4ujX6HkIC8eveqMDKKUcOo0cORyulIo61Ll755FHcwo
         wn6Q==
X-Gm-Message-State: ACrzQf3vqA8n7MowGN7bQSAddVvre3FjVW7LSBMswfg92Qzkd6tAvhs+
        Po8g5fSfeG2zz4uyiXoyya18Inu65Ho=
X-Google-Smtp-Source: AMsMyM5UxvnMw/tmRE+RDi5H/pVH119fO6xKYnbBT71PyTQHZUb50MZJ6s5H9c1lBVwPg8WoW15XancnCxQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1705:b0:55a:b9c4:6e14 with SMTP id
 h5-20020a056a00170500b0055ab9c46e14mr11665821pfc.40.1664585985944; Fri, 30
 Sep 2022 17:59:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:59 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-17-seanjc@google.com>
Subject: [PATCH v4 16/32] KVM: SVM: Document that vCPU ID == APIC ID in AVIC
 kick fastpatch
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document that AVIC is inhibited if any vCPU's APIC ID diverges from its
vCPU ID, i.e. that there's no need to check for a destination match in
the AVIC kick fast path.

Opportunistically tweak comments to remove "guest bug", as that suggests
KVM is punting on error handling, which is not the case.  Targeting a
non-existent vCPU or no vCPUs _may_ be a guest software bug, but whether
or not it's a guest bug is irrelevant.  Such behavior is architecturally
legal and thus needs to faithfully emulated by KVM (and it is).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 605c36569ddf..40a1ea21074d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -368,8 +368,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			cluster = (dest >> 4) << 2;
 		}
 
+		/* Nothing to do if there are no destinations in the cluster. */
 		if (unlikely(!bitmap))
-			/* guest bug: nobody to send the logical interrupt to */
 			return 0;
 
 		if (!is_power_of_2(bitmap))
@@ -397,7 +397,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			if (WARN_ON_ONCE(index != logid_index))
 				return -EINVAL;
 
-			/* guest bug: non existing/reserved logical destination */
+			/* Nothing to do if the logical destination is invalid. */
 			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
 				return 0;
 
@@ -406,9 +406,13 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 		}
 	}
 
+	/*
+	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
+	 * i.e. APIC ID == vCPU ID.  Once again, nothing to do if the target
+	 * vCPU doesn't exist.
+	 */
 	target_vcpu = kvm_get_vcpu_by_id(kvm, l1_physical_id);
 	if (unlikely(!target_vcpu))
-		/* guest bug: non existing vCPU is a target of this IPI*/
 		return 0;
 
 	target_vcpu->arch.apic->irr_pending = true;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

