Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397B054BB80
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357246AbiFNUIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357259AbiFNUIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5B826AE9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b6-20020a252e46000000b0065d5168f3f0so8390621ybn.21
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fiFiuxHIXgxAegJSj8gHfTJ9tT66KFy3T9yk9UrH1WA=;
        b=BqYhsM3ta9qAOvxT/8fB3pAXO46xUVrQnLHPqO3swLXf7Yx69UT8IeGNP9VcLfis1h
         PR+5/whVYPOCSJcKwGg2py7+MP0vudhhgwoc2Vf0vwUnnMnG2+uPdBfl907koadWZP50
         aA/yJv1nqFAejidU/mt9ZTJmK5/I3Hk3aT/bLrvVKLT6qoqNh8wDQqKc3aW8Z1ObYCRh
         cM0jjnHApfzUCbBzHEYNW8mcwrQyJoMP+uWFV9YenmMmU3AfX8Jv/dI+dyEBLhLn50ny
         Yqwyk/MiF6IxdBiCMPY+v/OX8KQ2Z163j+q8VDkTgutJVHnP/+akxXA/c3oN4JKMz+iR
         DlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fiFiuxHIXgxAegJSj8gHfTJ9tT66KFy3T9yk9UrH1WA=;
        b=tWa0lbTfPkcrX7vWQ/nbqSDIlCMCr78NmVudQ4+3IO8MI8IcopO3MxkB1sTU5kIrvJ
         9od2mqpdnDHhqOs8z43lbGn0CgXl2jZg3iEZm5g8BKHo31B+3KQirfidt4/LgV16ZZfa
         Us+x2Ljk7rMmQuz47/hPGDUULzWYC8/Uv612tqtosh9cZr61tLDxGPm6QBG1YdWWs5Cn
         DAGDFsVSZkA9Rtm9LjOQgG0OarZ7NyRj6xX2Y1Sfru1TV/UKlT4O99Nz6+y5cfYOD/h2
         eEhrcG1YHUQr4dN81lnyIdgb3kU/s1p3k2P1NHT5E0TizNHBiWDYD6tuZBfvQnJFR2tn
         su5Q==
X-Gm-Message-State: AJIora/jREV9wgxvPJeoVxS1bR05fxHN5K0hJs0CYgoD/tUFUsTjTaK5
        g5r7W1ieLyZmf18kaBihug2bn9vkna0=
X-Google-Smtp-Source: AGRyM1vp/gYIujKzWJ4tGvzmphkG9wplsr6yXQfpOs2tkEkB9kNjmhE0zNhf+X1rdBQS6MBSp0B8vQuY+rA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:5e87:0:b0:660:240c:784 with SMTP id
 s129-20020a255e87000000b00660240c0784mr6538456ybb.445.1655237270172; Tue, 14
 Jun 2022 13:07:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:46 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 21/42] KVM: selftests: Use get_cpuid_entry() in kvm_get_supported_cpuid_index()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use get_cpuid_entry() in kvm_get_supported_cpuid_index() to replace
functionally identical code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 14 ++++----
 .../selftests/kvm/lib/x86_64/processor.c      | 32 -------------------
 2 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 36c75acd4509..b62d93a15903 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -616,6 +616,8 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 	return cpuid;
 }
 
+struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
+					 uint32_t function, uint32_t index);
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid);
 
 static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu)
@@ -641,8 +643,11 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
-struct kvm_cpuid_entry2 *
-kvm_get_supported_cpuid_index(uint32_t function, uint32_t index);
+static inline struct kvm_cpuid_entry2 *kvm_get_supported_cpuid_index(uint32_t function,
+								     uint32_t index)
+{
+	return get_cpuid_entry(kvm_get_supported_cpuid(), function, index);
+}
 
 static inline struct kvm_cpuid_entry2 *
 kvm_get_supported_cpuid_entry(uint32_t function)
@@ -689,11 +694,6 @@ uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 			     uint64_t vaddr, uint64_t pte);
 
-/*
- * get_cpuid() - find matching CPUID entry and return pointer to it.
- */
-struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
-					 uint32_t function, uint32_t index);
 /*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d4ea5628746c..8226aa5274f3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -766,38 +766,6 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 	vcpu_set_cpuid(vcpu);
 }
 
-/*
- * Locate a cpuid entry.
- *
- * Input Args:
- *   function: The function of the cpuid entry to find.
- *   index: The index of the cpuid entry.
- *
- * Output Args: None
- *
- * Return: A pointer to the cpuid entry. Never returns NULL.
- */
-struct kvm_cpuid_entry2 *
-kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
-{
-	struct kvm_cpuid2 *cpuid;
-	struct kvm_cpuid_entry2 *entry = NULL;
-	int i;
-
-	cpuid = kvm_get_supported_cpuid();
-	for (i = 0; i < cpuid->nent; i++) {
-		if (cpuid->entries[i].function == function &&
-		    cpuid->entries[i].index == index) {
-			entry = &cpuid->entries[i];
-			break;
-		}
-	}
-
-	TEST_ASSERT(entry, "Guest CPUID entry not found: (EAX=%x, ECX=%x).",
-		    function, index);
-	return entry;
-}
-
 uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index)
 {
 	struct {
-- 
2.36.1.476.g0c4daa206d-goog

