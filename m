Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5FF53D459
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345496AbiFDBWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350010AbiFDBWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A002F018
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e75-20020a25e74e000000b0066128644d3dso2933432ybh.1
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DVDxR3/rPjapwoi40YmntTXgVr1EnJ/TXdlqXCtH5/M=;
        b=BL0gCNo37HVBu0UtgooziHLtHMQuT+ewg2OxZ2qfBDPI0Hfbxx8rW4MMtzA6RP2+8o
         U7swNEqPtyIYm99MOZKVYUPR4NeyFzPue8Pct4Zt719jQnzNoPtS1Hyuajvp9/jSKTJh
         lweoB476a0cKkod23VSI5mG+gQrJrCb2/IS7t8FiI6VlWAiY1CGv0e27XX5nou4xhOtT
         jIXjthpku/M6rKq56i1wDGYGEKLAMYg+ZfpQBJFjhYuu5uC/L5bnG/5NnAW+Nznsap+g
         7YRHl68qM10ZQILCoEhVkiivMMioxe1dMJQMAQYqHbJZ+gyBmTJWc4XTkqMHkXkLEoRL
         ET3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DVDxR3/rPjapwoi40YmntTXgVr1EnJ/TXdlqXCtH5/M=;
        b=JAVyU0HYAUmu6co7Sdl1LeurWixFlWLkkDvR4wCA1HT8fChxryyM7XzhFfHT7YmeWV
         pCN8WWaPomzSEjpM9JliE44ckc8HO7I0o+G7IlGgUtJa+8r+55dE+My3CFdgmLfM/6BE
         BlNGDEcpOL2/xmty4R2ulLMTtMQgfR4ZUMME/YepJU2dlVovVM02l9w/FN4dt8I6xbT5
         hveQrLoi+tQ1pozIvXSP1Y6zyaTiwEakn8alS18BTOW9tdab+uEMh7MnO8YgyJZ+wxty
         ZQq3lDA+8BFuQzGsO58r2Nw3Di2z5j81xP8D5WyI6dvwzUA5m1nzuWMZ2MPDYmnaQRf2
         CKkA==
X-Gm-Message-State: AOAM53029155wg8ZidJontzbfNr6kjyJfOWKJ2M5rzEqYK8XHGeLrNck
        ii3r1D0FcRkebbEeKSFJ+hIXp2NC5WM=
X-Google-Smtp-Source: ABdhPJy8aASDE5qPtj1QbthWSAtJneWEpm7sYMdxhfMXqhchEofuIi9Ww7pudDor9Z1AQ1oRMFg0pmjBd4U=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:260a:0:b0:300:1729:7654 with SMTP id
 m10-20020a81260a000000b0030017297654mr14142103ywm.125.1654305695249; Fri, 03
 Jun 2022 18:21:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:36 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 20/42] KVM: selftests: Rename and tweak get_cpuid() to get_cpuid_entry()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Rename get_cpuid() to get_cpuid_entry() to better reflect its behavior.
Leave set_cpuid() as is to avoid unnecessary churn, that helper will soon
be removed entirely.

Oppurtunistically tweak the implementation to avoid using a temporary
variable in anticipation of taggin the input @cpuid with "const".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h  |  4 ++--
 tools/testing/selftests/kvm/lib/x86_64/processor.c    | 11 +++++------
 tools/testing/selftests/kvm/x86_64/cpuid_test.c       |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index f170fd5f8726..fcfeac1590a2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -692,8 +692,8 @@ void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 /*
  * get_cpuid() - find matching CPUID entry and return pointer to it.
  */
-struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
-				   uint32_t index);
+struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
+					 uint32_t function, uint32_t index);
 /*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index ae40ff426ad8..b481ad131ec6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1191,16 +1191,15 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 	}
 }
 
-struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
-				   uint32_t index)
+struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
+					 uint32_t function, uint32_t index)
 {
 	int i;
 
 	for (i = 0; i < cpuid->nent; i++) {
-		struct kvm_cpuid_entry2 *cur = &cpuid->entries[i];
-
-		if (cur->function == function && cur->index == index)
-			return cur;
+		if (cpuid->entries[i].function == function &&
+		    cpuid->entries[i].index == index)
+			return &cpuid->entries[i];
 	}
 
 	TEST_FAIL("CPUID function 0x%x index 0x%x not found ", function, index);
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index ca36557646b0..8723d73dcdbd 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -157,7 +157,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
 	/* Changing CPU features is forbidden */
-	ent = get_cpuid(cpuid, 0x7, 0);
+	ent = get_cpuid_entry(cpuid, 0x7, 0);
 	ebx = ent->ebx;
 	ent->ebx--;
 	rc = __vcpu_set_cpuid(vcpu);
@@ -165,7 +165,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	ent->ebx = ebx;
 
 	/* Changing MAXPHYADDR is forbidden */
-	ent = get_cpuid(cpuid, 0x80000008, 0);
+	ent = get_cpuid_entry(cpuid, 0x80000008, 0);
 	eax = ent->eax;
 	x = eax & 0xff;
 	ent->eax = (eax & ~0xffu) | (x - 1);
-- 
2.36.1.255.ge46751e96f-goog

