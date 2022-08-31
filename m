Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2265A72B9
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiHaAhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiHaAhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51136AB188
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:04 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k62-20020a638441000000b0042b66a99b6aso6234262pgd.18
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=jKorNpXhvwAGsXROivEBSj6hwWRnB+Rxe5sOrtAqphg=;
        b=tIU13tu3TrRZIwVjv3NBqNY45MhfLObBL6gThmPiOhUD6+etBUdAZjTHH2Bd9lYATB
         mm3B0SIcYf9WsoH4X+DNkzgG0ymiFjKf1dhwKuhKL7+DbEf1731yMvENCFd8Y2rOCqLX
         0NfwwTsjoiy6K40RaNI/f3p/JN1vVV9LgEN7ez756T3aQvTU/ln2o4jBeW8T/dteao5w
         lELNQ1P6djW8X4RFC1e/w1a+VZ6BI1RA6yX2YixQqGUyYIpXwRgH9G27UQNl2EFMPGRB
         MQ4noN2nDGKNGasEYXlxnYPZh7xlR/0dImt5IH7XdJWUg4VEgZMYS9sXuO5nMQYQIzan
         nD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=jKorNpXhvwAGsXROivEBSj6hwWRnB+Rxe5sOrtAqphg=;
        b=yLgfMj7JqSqaWcxy5RNHpradm3XYAOSmObqf3NimPJ3A5+qM4t57oepkjPMhYP3qIn
         d5AYmy8FiIQsYJYHlwvWNKo4OaW76GCzQQFDCmnYJPEJXK3HhmOntTHGwTjD1Nsxz0az
         ts5S7Hx7vkfv+WIFB0neawyHyGfB8qq+dv5XjH+FpsQYIlroNDravAhwK7TnoHVEOyOm
         YGPVWdDBiMW77+LT2s49Z7q3xgvisE2gOsM6nLqCemODauPAhCMD8tsDIhW41B8TVuYK
         VOTcYCbwV6QpLWkPPzcJvKs3PbmMN3hEKgYRk/k4RN+JRinYKx86BfkfaDzqEhJLZn83
         oq7g==
X-Gm-Message-State: ACgBeo0kGH7WN0Jzb+fdaQPqRdse8bwOicawdScVImITn5EVeEkjGHCX
        l5zbjuVjDLwO/5zbtGVF+fX1bEs8heM=
X-Google-Smtp-Source: AA6agR7yN+Sp/Y+nZ4AuoglDHrI+LXd3f1PmIguhTRo3PXqVoSa11JZpxTjMBfll0T0+/fbcDbejWHARNus=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b0c:b0:1f4:ffac:699a with SMTP id
 lx12-20020a17090b4b0c00b001f4ffac699amr600872pjb.145.1661906131231; Tue, 30
 Aug 2022 17:35:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:35:00 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-14-seanjc@google.com>
Subject: [PATCH 13/19] KVM: x86: Disable APIC logical map if vCPUs are aliased
 in logical mode
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
---
 arch/x86/kvm/lapic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 82278acae95b..d537b51295d6 100644
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
2.37.2.672.g94769d06f0-goog

