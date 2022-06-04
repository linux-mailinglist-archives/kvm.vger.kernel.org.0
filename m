Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3045453D48B
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350185AbiFDBWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350161AbiFDBWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C775A0A4
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c11-20020a17090a4d0b00b001e4e081d525so5582758pjg.7
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MAb0VYGO01rN81APErjc83aRSpAeSVLJ6uKCqsMFyZY=;
        b=qpsSsrn3cRRFyGX9dQ2g3eQ7U+TOhp8sVQa+70aRvKIYEROHKd+hXl+qcCooaei1Hd
         Lde3KjSwHSkX8XXcrbC1ETlGPZ85wBictpfieWNWvVdzeAhy9/bTwrzWBUZq3JIGLB88
         FWUF08J+ujHY6TjX0Rymq5vS0ftpEihSBKMV7b9t/+d9xwu9WRf0THSdEzg4Yccxvund
         HYYrBJ6JUT9IZ5fHlOspAYD5na7T/ZQ0LrSHJ/XPpaoHwlqI9KEuaNdlLouMxDDZyLje
         noZRLt/v2MMym4kJQOdriSsjYnpBsnkyRnASyRhqOfzFmKofr7xsbrlhUJ04CgwMQe8h
         Y1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MAb0VYGO01rN81APErjc83aRSpAeSVLJ6uKCqsMFyZY=;
        b=1m1vaTxyTY7q4J+rj2e/1KqRnBLNKGtP+T0aq+atjYpKeyFC2hTAI+2vmB7W/PGaWp
         7xWM78CkahWumaqxrJhCmY0QfBjVaYnS2EEQvuQRx0GAw0QElF+Xf3Hn3RpUwqLLljcR
         u8bx8s+QTSDOrH5JfCluo/Hw+zrw6AzGtLblZDHr4OZfFMgzmzmDXp5XVfdb2aSmYplq
         Ym2K+qzjvX6r9PQxk/jIjnF8gU5Lb76RkZIal0lRmeNLwsC2TGX+7Q4VjXixbsDDZ05/
         4Jo9XSbn6jban5mJvOHtSqIEp9YZ7QaiYhu0PVbenCPhQ5El9ltp7WMxkMx/oH2h+WNi
         daBw==
X-Gm-Message-State: AOAM533PD+3FtigOdVgRL6hqIe/rjI/oKrgxkOUmcZonpxJ6tlpXB4OU
        KHUtfcee3rOXdwBY6TQ9U6zlWhMeCtg=
X-Google-Smtp-Source: ABdhPJwKqHsT6cTlMWKkXMg8RInDXfL66prXk3gNx7J5qEL3rOLKVQ9GiTgjGXA1ctgIMLxxMrfrKTX6cNs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b88:b0:1e6:7aa2:4301 with SMTP id
 pc8-20020a17090b3b8800b001e67aa24301mr13726686pjb.118.1654305696863; Fri, 03
 Jun 2022 18:21:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:37 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 21/42] KVM: selftests: Use get_cpuid_entry() in kvm_get_supported_cpuid_index()
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

Use get_cpuid_entry() in kvm_get_supported_cpuid_index() to replace
functionally identical code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 14 ++++----
 .../selftests/kvm/lib/x86_64/processor.c      | 32 -------------------
 2 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index fcfeac1590a2..e43a1d2fd112 100644
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
index b481ad131ec6..a835a63a6924 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -767,38 +767,6 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
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
2.36.1.255.ge46751e96f-goog

