Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF6451B2DE
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379274AbiEDXAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379635AbiEDW6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:58:38 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92D056227
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f4dee8688cso23882567b3.16
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4WR9zEIsQRadY2XTHddV28lHjmHH8m3YJ1sYfLLT9gM=;
        b=qSAy0cRzHsHnqdPi0eCNQGd9LRbz8YACWFD8AO1m+Y4niOBi4QVk2H9ztTeFWBmLHw
         J6m2uUL+q7J3hSKDQcEzyXlLxG31pHPQ3O6/7OocAbEX6G0WO9fnEyWQ1slXolQ75XEV
         jPqkUu0bHOwNlW6XblQUUUertFnJWESHo5X9DR7rDz3CFcDF00R5czogOxCM1tTtam1f
         isxlkLSpyYSWW1gikpt4dkLA9dxnWaaIJ3b+1zV9ahge/AWV54QFmJqOb7F3uSH/7CY5
         btnMwAfabpWTTZp9p4ty2NHFCBSmB86uIp2to2Nqwn9Bm0DHT/h99yJy1hLXHKTuYfOT
         n2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4WR9zEIsQRadY2XTHddV28lHjmHH8m3YJ1sYfLLT9gM=;
        b=c6em2nEqYSyKSEEVyp7J6UA8ua28yKM446JHGrrF6kEPagSPLjR5zgicSXYU6BLJD8
         dsKEOnEv3F0NULG0pat8ucbfkxxMnrKoYbFXa6JO+cG6IzEKnaUPTADDo6jn2CKhqP17
         Kx0oQP7a4ITamZkpfdwbTv8O5yX1fLdgi8iE21ApZmUfK0da1Cgis+aMAqMqQIci1nsl
         DtXpQgRor1rI/aEG8KpzI5HlI4so5uOI5DyUriO82JR9sRY7Q37lMDEI2LFt8UtIxtnl
         fctN0C6dmkjDmEN7SCf4Gw4M5ADFwp95Q7Rk9wesA0Hgzrxa/UaZ+g2nbPeJrvmJ0e6c
         4sWA==
X-Gm-Message-State: AOAM532h193R4MW01L2HVvt0Uuo7xusdCv9hPOhlsP8dy0it1QWIog/z
        72QBJDxSg8C5+IkV0DUqlG60uYZhNmA=
X-Google-Smtp-Source: ABdhPJy/kebFBTcGppdJ4XEHVkmgD1x0nty7ACYkuebnm5m45K8Uq/6ziBxEaWwMsVL2Nymh5pjqdvZSInw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:215:0:b0:64a:c05:7082 with SMTP id
 21-20020a250215000000b0064a0c057082mr4218285ybc.188.1651704727455; Wed, 04
 May 2022 15:52:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:37 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-92-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 091/128] KVM: selftests: Move vm_is_unrestricted_guest() to x86-64
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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
index f621f7ffc150..570eb05005ea 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -666,8 +666,6 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
  */
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
 
-bool vm_is_unrestricted_guest(struct kvm_vm *vm);
-
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index cf6c9738302f..94888d3a13f5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -452,6 +452,7 @@ static inline void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid,
 uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
+bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 struct ex_regs {
 	uint64_t rax, rcx, rdx, rbx;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bcdc47289df3..89612535df22 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1941,39 +1941,6 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
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
index 91b326cd43a2..31a0fd79110d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1396,3 +1396,24 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
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
2.36.0.464.gb9c8b46e94-goog

