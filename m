Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454AA53C2F9
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240727AbiFCAuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbiFCArS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9298D37BDF
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s2-20020a17090302c200b00158ea215fa2so3491444plk.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TzsVyQIK/O28EG5/tdwYmklCNq7nGiihsFz4GFTB50s=;
        b=cLt/uhXB96LpU36y2h1pirbmPq6hN1+4AyLY/fXuOFMZ8+dnUTZuQe8lsQFcee6DHr
         SfF3icgvJRo/hPhSS1oOxKJVzwBpLHJYHax6+FvrXytfEBdm9AiPTCFNU99R8L8PzRhY
         F3wg9wB50Pn+KvcKxxbvQXw7BrhqUPEKYmKpbQzgkp9Nk+nwdL6dBqM117vzfCtG6bjs
         WcJy1cxv3eak/fgEfIXS1D+ivx++ZCJ9l6vLhQDpWvylyCOS6xV1SGVQGYUKavMQchYl
         GtzjY76G8sKvA5v+tzaVjU/8ZfD9qzYpDmE4tGmkwRXs8EjqI3C+ud0ASzwznxCnvHj6
         cSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TzsVyQIK/O28EG5/tdwYmklCNq7nGiihsFz4GFTB50s=;
        b=xL6MXKr03blLf7asZfuS5CGKPYm6Oddj1oySK9Gf6f2Rae8f+RTFbgC5m3Nmx+zlnU
         PeUExGcgd4iXnOmoS+k2Bl9JOdSWs7GX0tw88+B/yonV0IM9osjIVLAXZBcXdOllhzqh
         l39Mn3xDfuD5ZE3YpC1cJ0PIZwEqa7hFpkh7kGK63WALIQAbCPvUP964dx+gDeGDOofU
         0TshR5F4VlgW7cWiGUSfr7HVAuW9ovuUBMUA4Jyk08l89R0VizGjGzpb7Y4r/nWSTSwF
         l9pbQRGnFQTs69ZEBoi6wOMtQ7fdgKcD1n0f6Pp2Qv2ga1QFM9Pes2ddeBSmoLfUnGa1
         Pn4A==
X-Gm-Message-State: AOAM531rA29lfuuz+Scpj6DkM+BiEIULYIAT81hFP7ZMFMESmggsU4fO
        TICaGriNUJb+rqxi5p5CCRg4mpXpvDs=
X-Google-Smtp-Source: ABdhPJxKA8IlkmPHgyiTRJyZ41ym7M8uaV1l6J9PmL26g+Me8IDHs1NRI2EFwhgbqL9wHJMeePZXkYasBAc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:868c:0:b0:51b:bd62:4c87 with SMTP id
 x134-20020a62868c000000b0051bbd624c87mr7619847pfd.83.1654217195407; Thu, 02
 Jun 2022 17:46:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:46 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-100-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 099/144] KVM: selftests: Move vm_is_unrestricted_guest() to x86-64
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

An "unrestricted guest" is an VMX-only concept, move the relevant helper
to x86-64 code.  Assume most readers can correctly convert underscores to
spaces and oppurtunistically trim the function comment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 --
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 33 -------------------
 .../selftests/kvm/lib/x86_64/processor.c      | 21 ++++++++++++
 4 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index d94b6083d678..5426de96e169 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -667,8 +667,6 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
  */
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
 
-bool vm_is_unrestricted_guest(struct kvm_vm *vm);
-
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 1d46d60bb480..895d6974f7f5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -526,6 +526,7 @@ static inline void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid,
 uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
+bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 struct ex_regs {
 	uint64_t rax, rcx, rdx, rbx;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8348fa19690a..5f0030257b05 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1948,39 +1948,6 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
 
-/*
- * Is Unrestricted Guest
- *
- * Input Args:
- *   vm - Virtual Machine
- *
- * Output Args: None
- *
- * Return: True if the unrestricted guest is set to 'Y', otherwise return false.
- *
- * Check if the unrestricted guest flag is enabled.
- */
-bool vm_is_unrestricted_guest(struct kvm_vm *vm)
-{
-	char val = 'N';
-	size_t count;
-	FILE *f;
-
-	if (vm == NULL) {
-		/* Ensure that the KVM vendor-specific module is loaded. */
-		close(open_kvm_dev_path_or_exit());
-	}
-
-	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
-	if (f) {
-		count = fread(&val, sizeof(char), 1, f);
-		TEST_ASSERT(count == 1, "Unable to read from param file.");
-		fclose(f);
-	}
-
-	return val == 'Y';
-}
-
 unsigned int vm_get_page_size(struct kvm_vm *vm)
 {
 	return vm->page_size;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5c92e96300c5..67b9fb604594 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1358,3 +1358,24 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 done:
 	return min(max_gfn, ht_gfn - 1);
 }
+
+/* Returns true if kvm_intel was loaded with unrestricted_guest=1. */
+bool vm_is_unrestricted_guest(struct kvm_vm *vm)
+{
+	char val = 'N';
+	size_t count;
+	FILE *f;
+
+	/* Ensure that a KVM vendor-specific module is loaded. */
+	if (vm == NULL)
+		close(open_kvm_dev_path_or_exit());
+
+	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
+	if (f) {
+		count = fread(&val, sizeof(char), 1, f);
+		TEST_ASSERT(count == 1, "Unable to read from param file.");
+		fclose(f);
+	}
+
+	return val == 'Y';
+}
-- 
2.36.1.255.ge46751e96f-goog

