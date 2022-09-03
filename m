Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A495ABBBF
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiICAXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiICAXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CB4F63FF
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k126-20020a253d84000000b0068bb342010dso2790920yba.1
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=sRJGbJUfwvTmIt7TCeDCGPl4C7G33IdwBZhsjLxh4VE=;
        b=Lrtf7dftYWdQobVdgIYPY6rFbIW/t3fpvvyqbmyM3pcHzZa84O+5S96zD5KZw3DiEJ
         vuPjMZQlr2ppg9GuBQEI9CH5Ih8F7Jm6P3e8qC2UoXHEDYk9jAClPlYuAOtWDlVxSpJJ
         EPdEItdldlbw0Ap4kJzxKdBMkwm8rZJv6mj44abpH1vu88KMUqD/B3DRHBnaT0H4Z3MD
         VL4+VWw/fxVq2p3ZDZ3iHnkzulp4D4CfOVq74bGwJintlSIzuIdnlMjR4g5wbCuo8oEa
         NPCHC5ZpSHWUGf+aqxBNOyVCdHWJwD2nbKyLepN/mRL4AXLiWmuL0AIDdX8QA1XBGhz9
         uX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=sRJGbJUfwvTmIt7TCeDCGPl4C7G33IdwBZhsjLxh4VE=;
        b=AJNsBO2S+zjfwLwDLIauR9NCiZVDfyY02w5QSRRHmXvoqpl16D25QzPpSMARtnzLmS
         4Wmk/D5hUPOMUGN5VA5Ns70lSsma6cAmrn80AbQlrdYbcM/jLI0yVH9DxnYkOC5CIlOL
         n8BSHE2scT6qwfkEgs22y4QqWMIZBQPWeDNJVRRq7iw06Egyl2HL6m33V48Qpd3sGrAJ
         /Iie0TFBVqtOZbLBbWTQp64vra1VEWUCEvfL6aJdfyKtSN7V3/1IfCc/9oq/OwCR28UJ
         kqe4tfaAeVmclZTL4+LLbmhKEfrWTwC223B4fV0e8kHAvTq/DuKL3/xSqpAmNoLwVj20
         MICw==
X-Gm-Message-State: ACgBeo2Ty4hO/qKKNWZdEb6Ry7pG0BmEnOweMITApmLLkjfdUu98n7jE
        DLYKT+Rds3R99duw241vybkAQZZKgas=
X-Google-Smtp-Source: AA6agR6Lvf/iV4NjK3NatuY3tfKZ66unw+gXhNRGQwD51QtjJbXvqUr/zDzU5BLJgHKQONRPn6jy3xdkQ9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9986:0:b0:6a7:29ef:133c with SMTP id
 p6-20020a259986000000b006a729ef133cmr1686245ybo.479.1662164601696; Fri, 02
 Sep 2022 17:23:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:44 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-14-seanjc@google.com>
Subject: [PATCH v2 13/23] KVM: x86: Disable APIC logical map if vCPUs are
 aliased in logical mode
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable the optimized APIC logical map if multiple vCPUs are aliased to
the same logical ID.  Architecturally, all CPUs whose logical ID matches
the MDA are supposed to receive the interrupt; overwriting existing map
entries can result in missed IPIs.

Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6b2f538b8fd0..75748c380ceb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -303,12 +303,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		if (!mask)
 			continue;
 
-		if (!is_power_of_2(mask)) {
+		ldr = ffs(mask) - 1;
+		if (!is_power_of_2(mask) || cluster[ldr]) {
 			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
 				    KVM_APIC_MODE_XAPIC_CLUSTER;
 			continue;
 		}
-		cluster[ffs(mask) - 1] = apic;
+		cluster[ldr] = apic;
 	}
 out:
 	old = rcu_dereference_protected(kvm->arch.apic_map,
-- 
2.37.2.789.g6183377224-goog

