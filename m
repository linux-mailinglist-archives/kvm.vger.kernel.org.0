Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B830354BB8F
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243472AbiFNUIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357167AbiFNUH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83C22181B
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:41 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id x24-20020a17090ab01800b001ea7efd1e45so4073190pjq.5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3g6panSSHQgYqlim8rZBaxutX2L51x10az76OlO4Z68=;
        b=Hwtfi3PL4gwEMKgjA3xrlYKysxaKAG5YEmKWUQuhgrLXuy8eZfkhVuyxpj5O6s2O3V
         yE1wSQM8MCjSsZmXXJJu1dfGRs/7Bht6jO41ng1h5Gh1s5vtJLGIFNUAbmVXta0CyVXo
         oy9E3vlemkQGDw0aBDEdzrgx7IQt2uplgvGWXY6QzIxn0dkYi4BrphcgrG4gr24T74kB
         SAIqynypcgmCNce3qQ+IQzJrYbAB0tpW/oXgBPCzjz735FdYGkkLVu+Y/GBbuwz5HqPm
         hCvFyFgjTxHO+H4i/caB8sJdCV3C0zXSsnYj57rgdxWs4mw5rafmnv34FQvcXWxhfcLU
         JAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3g6panSSHQgYqlim8rZBaxutX2L51x10az76OlO4Z68=;
        b=CS62BvdazjDRqu84gyyVjCP4DJVqCVwM2B2c47/rkGArN+Danwcpu/bIVsjP5cryfl
         WoIqX4k2TtT6KW4tpRpiZdsnZEouUUPc33AUafd18Xoo0AZmxh4pPoE42eGAL5tet//q
         O4W78SoP+OegUQC3p3sNin9duBMDLFNkyajZqjFiLPHeZn+3ZlH2qJb5nkph78JVHo5/
         Wxfm2hNSML9GlPP9tp/AXvXIKXZbqIKyUqKON+z+Hp0glNd9DiCp3tdjbmisl0gto53u
         8ghO+LquRUcUgkxPcb+55AGjleyBkzvjlr7IwkxGhCtjD+gGPywhT3Itk6i2XpRy3BFL
         T4QA==
X-Gm-Message-State: AJIora+bgbMwW3LUtGZ48+F4zDdaGsXjyNqkIY9Y5zuo9b23kE9gLU0B
        fsm2ejy6+xAb9cxJ5R+UGYfuqake7nM=
X-Google-Smtp-Source: AGRyM1txikG7zi07OUVNaKZjWrjQVwZNbe4HY/7GZqCt/1ScgSF01+LuViWdVHACRUXRXLZkHG4lbrMgQ5k=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8bc2:b0:167:7645:e76a with SMTP id
 r2-20020a1709028bc200b001677645e76amr6147597plo.115.1655237261430; Tue, 14
 Jun 2022 13:07:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:41 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 16/42] KVM: selftests: Verify that kvm_cpuid2.entries
 layout is unchanged by KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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
2.36.1.476.g0c4daa206d-goog

