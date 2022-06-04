Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E0353D499
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349516AbiFDBWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350126AbiFDBWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA5A56419
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u8-20020a170903124800b0015195a5826cso5052765plh.4
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+P9ebQR/o0N4C3OJ9m1Uv8l25raaSyZTreScin4zTKM=;
        b=LKIbb7OzdyJNTyYLfYa5SqAKhGy8qCh/O8ZXDuyyuUn2JQb/TaGQGYvnsoHpUZ82VQ
         SBwcQGkKi3WqixgHwvzhrqaIjm/LdWchr1nQ4XU4XHbXelGsfBjOZS2oxSbSEs2fAdvA
         suW06y+VZvHX6qayFRKROkAQOT2xUvw7iJg2N8YcIuJx//fHrwUkZ0nglvW3rjWAR5go
         eS/ewvyA3u4QKpc9FicF31a0IT87S31bCuPShM1rwISP2RUh/biOZXHOmEGkHYAefHvX
         IylApBv8j4D3iDwHWbG9jyyPtBvxFNnvm9qlIRjfwnRCsa9pR5f81q11D49hkB8Xrs4G
         KJEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+P9ebQR/o0N4C3OJ9m1Uv8l25raaSyZTreScin4zTKM=;
        b=i+G3AhOvKqtBrbWwUzEcDfFTSrKEO/aYyy9ySvDpWnyfx8DJlPK2YUqPaF2RS+ytcl
         veTyPeK/4unL0BNJymC1PmrwfLmrCZvBDViQVeGIiMxZLunf7H0xg2PoJsVlzgYiNu20
         F2laZwMSgBbDjLuDduYPk+J2eKYnImCSvCeMyRU9rjg62zUt3rS0twYPC9LhBFPoL84A
         K5Xu5euolt+pKCrZ9gZga1IMeJO6kvNuAhL3iZ0a5XLiiRFbTenvuoaPuDeRpZ2vnUQs
         EE8Fw5o1/SCVCNHVT+Pzeoc7GnKO9JTQFJojnWqdBftSHQXiy1B2H+J6EKIGI7i6A8Uz
         mcWQ==
X-Gm-Message-State: AOAM531CEP6s2pS8iyyTl8BQixprQWwE1a4Yv877X2DKxCtMPIHbkkae
        getVyu2G7fHR5BudBWMUpefxtavzm8k=
X-Google-Smtp-Source: ABdhPJxgvfD6FG8SsCElziqkiQTRREee4CpL7ZM72hJxwAc8WaSmO41wFuyeAtBhDVauiLb88jmLzQl5Kvk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:c84:b0:518:e0f6:f1af with SMTP id
 a4-20020a056a000c8400b00518e0f6f1afmr12773907pfv.47.1654305688234; Fri, 03
 Jun 2022 18:21:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:32 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 16/42] KVM: selftests: Verify that kvm_cpuid2.entries layout
 is unchanged by KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

In the CPUID test, verify that KVM doesn't modify the kvm_cpuid2.entries
layout, i.e. that the order of entries and their flags is identical
between what the test provides via KVM_SET_CPUID2 and what KVM returns
via KVM_GET_CPUID2.

Asserting that the layouts match simplifies the test as there's no need
to iterate over both arrays.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 53 ++++++++-----------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 4aa784932597..dac5b1ebb512 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -79,41 +79,34 @@ static bool is_cpuid_mangled(struct kvm_cpuid_entry2 *entrie)
 	return false;
 }
 
-static void check_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *entrie)
-{
-	int i;
-
-	for (i = 0; i < cpuid->nent; i++) {
-		if (cpuid->entries[i].function == entrie->function &&
-		    cpuid->entries[i].index == entrie->index) {
-			if (is_cpuid_mangled(entrie))
-				return;
-
-			TEST_ASSERT(cpuid->entries[i].eax == entrie->eax &&
-				    cpuid->entries[i].ebx == entrie->ebx &&
-				    cpuid->entries[i].ecx == entrie->ecx &&
-				    cpuid->entries[i].edx == entrie->edx,
-				    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
-				    entrie->function, entrie->index,
-				    cpuid->entries[i].eax, cpuid->entries[i].ebx,
-				    cpuid->entries[i].ecx, cpuid->entries[i].edx,
-				    entrie->eax, entrie->ebx, entrie->ecx, entrie->edx);
-			return;
-		}
-	}
-
-	TEST_ASSERT(false, "CPUID 0x%x.%x not found", entrie->function, entrie->index);
-}
-
 static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
 {
+	struct kvm_cpuid_entry2 *e1, *e2;
 	int i;
 
-	for (i = 0; i < cpuid1->nent; i++)
-		check_cpuid(cpuid2, &cpuid1->entries[i]);
+	TEST_ASSERT(cpuid1->nent == cpuid2->nent,
+		    "CPUID nent mismatch: %d vs. %d", cpuid1->nent, cpuid2->nent);
 
-	for (i = 0; i < cpuid2->nent; i++)
-		check_cpuid(cpuid1, &cpuid2->entries[i]);
+	for (i = 0; i < cpuid1->nent; i++) {
+		e1 = &cpuid1->entries[i];
+		e2 = &cpuid2->entries[i];
+
+		TEST_ASSERT(e1->function == e2->function &&
+			    e1->index == e2->index && e1->flags == e2->flags,
+			    "CPUID entries[%d] mismtach: 0x%x.%d.%x vs. 0x%x.%d.%x\n",
+			    i, e1->function, e1->index, e1->flags,
+			    e2->function, e2->index, e2->flags);
+
+		if (is_cpuid_mangled(e1))
+			continue;
+
+		TEST_ASSERT(e1->eax == e2->eax && e1->ebx == e2->ebx &&
+			    e1->ecx == e2->ecx && e1->edx == e2->edx,
+			    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
+			    e1->function, e1->index,
+			    e1->eax, e1->ebx, e1->ecx, e1->edx,
+			    e2->eax, e2->ebx, e2->ecx, e2->edx);
+	}
 }
 
 static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
-- 
2.36.1.255.ge46751e96f-goog

