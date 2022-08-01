Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B294A58721C
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 22:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiHAUMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 16:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbiHAULa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 16:11:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374E43E74E
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 13:11:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w3-20020a258503000000b00676bd41edabso6215948ybk.5
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 13:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T2ovbVSsPrqZm8WKCfNJf5rzRjcU2cYuPrze4v5+pmc=;
        b=LvwmnBiPe2imIL09shURbYjP4GTHOk+mIvil4Cij2bxx96QPcL9nuZ1OGfbcSeaddf
         pKCaNJpsyqodRuV0qZdj3eL912Hxo2zvDD6ix2XwGIff3DjABCjWI9Ghd4YwscQwBDM3
         CC3y08tOUa8MqjFvDMHU98iHBd/y1Qj9EIUD0FX+L9aRDwlKEXQ91VjaejkSAUi/Q+Ow
         l7BmbhmUYydK0k9o4Ra8L/zQdNTAIEXjyvlNKoRK7a1uFmB4wbu7dZHyXVXoXhZKSbY+
         Z63cFJcauanfBc90xse/OCYUvwkKnnnD2jjoF7t3vYzg9ts2Jl03Cj2XTCs0DjM3tz2b
         oM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T2ovbVSsPrqZm8WKCfNJf5rzRjcU2cYuPrze4v5+pmc=;
        b=5rwpkTJiyRtTlxS8hvDHm08U6da2/RJPTzQNck8KyYmhES2HJvXLqify4v23sYQ7Am
         EbSvjwcgyPGHeuLJMi4n4rSf+Kq8oaqX2eGIo0I5lac9UBkaR7cQHWmww+MNVAoFmtyE
         WAqRjP7RoXojGi/xc3lTuWPplwKixTERMqosWd+e613EJ4bu5Rvyk6+0Ucd9HsSqHfXB
         g8pQbWilMzZUeflfp4A5MU1mOMiLBhf4j8u5FgLmt7QQRatMo0kewl7vd8NbSi2b34GN
         1KYxUlVGD0VYJbOei+Py/F3x7aHWq7GE7ZXolm6RVpp1+2bJU2OF8gYf4FpzATcbNi0e
         r5qA==
X-Gm-Message-State: ACgBeo0gL9NK7X79crg1hJbNP4If+Qg/BoNz+dB6lYy293IU2l9I5nPz
        oFO1EL/WjGy270NsC0uZ4DvOwasAIBZws4Nczb14wjeXoU7p0xgUfzN5IH8ZpmwVqMN+yOZ1leK
        DcXWJl2yRslvY8yhrh7duy4T6HWoYpJCia32ecId13pQ8Q8CJwZGN11DkNw==
X-Google-Smtp-Source: AA6agR7JCFahUrvCbt8quua1d2eTqX3nuOVPVlyDqoGu5qyYlnFncKpY7Ipm9CzyHDISuU6ywogGOstmY9Y=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:6be2:f99c:e23c:fa12])
 (user=pgonda job=sendgmr) by 2002:a0d:e252:0:b0:322:eca5:eaf3 with SMTP id
 l79-20020a0de252000000b00322eca5eaf3mr15238204ywe.219.1659384685484; Mon, 01
 Aug 2022 13:11:25 -0700 (PDT)
Date:   Mon,  1 Aug 2022 13:11:05 -0700
In-Reply-To: <20220801201109.825284-1-pgonda@google.com>
Message-Id: <20220801201109.825284-8-pgonda@google.com>
Mime-Version: 1.0
References: <20220801201109.825284-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [V2 07/11] KVM: selftests: Consolidate boilerplate code in get_ucall()
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Consolidate the actual copying of a ucall struct from guest=>host into
the common get_ucall().  Return a host virtual address instead of a guest
virtual address even though the addr_gva2hva() part could be moved to
get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
should return a host virtual address (and returning NULL for "nothing to
see here" is far superior to returning 0).

Use pointer shenanigans instead of an unnecessary bounce buffer when the
caller of get_ucall() provides a valid pointer.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/ucall_common.h      |  8 ++------
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 13 +++----------
 tools/testing/selftests/kvm/lib/riscv/ucall.c | 19 +++----------------
 tools/testing/selftests/kvm/lib/s390x/ucall.c | 16 +++-------------
 .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  | 16 +++-------------
 6 files changed, 33 insertions(+), 58 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 5a85f5318bbe..c1bc8e33ef3f 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -27,9 +27,10 @@ struct ucall {
 void ucall_arch_init(struct kvm_vm *vm, void *arg);
 void ucall_arch_uninit(struct kvm_vm *vm);
 void ucall_arch_do_ucall(vm_vaddr_t uc);
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
+uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
+uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 
 static inline void ucall_init(struct kvm_vm *vm, void *arg)
 {
@@ -41,11 +42,6 @@ static inline void ucall_uninit(struct kvm_vm *vm)
 	ucall_arch_uninit(vm);
 }
 
-static inline uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
-{
-	return ucall_arch_get_ucall(vcpu, uc);
-}
-
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 1c81a6a5c1f2..d2f099caa9ab 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -78,24 +78,17 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
-		vm_vaddr_t gva;
+		uint64_t ucall_addr;
 
 		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
 			    "Unexpected ucall exit mmio address access");
 		memcpy(&gva, run->mmio.data, sizeof(gva));
-		memcpy(&ucall, addr_gva2hva(vcpu->vm, gva), sizeof(ucall));
 
-		vcpu_run_complete_io(vcpu);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
+		return ucall_addr;
 	}
 
-	return ucall.cmd;
+	return 0;
 }
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index b1598f418c1f..3f000d0b705f 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -51,27 +51,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 		  uc, 0, 0, 0, 0, 0);
 }
 
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_RISCV_SBI &&
 	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
 		switch (run->riscv_sbi.function_id) {
 		case KVM_RISCV_SELFTESTS_SBI_UCALL:
-			memcpy(&ucall,
-			       addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]),
-			       sizeof(ucall));
-
-			vcpu_run_complete_io(vcpu);
-			if (uc)
-				memcpy(uc, &ucall, sizeof(ucall));
-
-			break;
+			return vcpu->vm, run->riscv_sbi.args[0];
 		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
 			vcpu_dump(stderr, vcpu, 2);
 			TEST_ASSERT(0, "Unexpected trap taken by guest");
@@ -80,6 +68,5 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 			break;
 		}
 	}
-
-	return ucall.cmd;
+	return 0;
 }
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 114cb4af295f..f7a5a7eb4aa8 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -20,13 +20,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
 }
 
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
 	    run->s390_sieic.icptcode == 4 &&
@@ -34,13 +30,7 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 	    (run->s390_sieic.ipb >> 16) == 0x501) {
 		int reg = run->s390_sieic.ipa & 0xf;
 
-		memcpy(&ucall, addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]),
-		       sizeof(ucall));
-
-		vcpu_run_complete_io(vcpu);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
+		return run->s.regs.gprs[reg];
 	}
-
-	return ucall.cmd;
+	return 0;
 }
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 749ffdf23855..a060252bab40 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -18,3 +18,22 @@ void ucall(uint64_t cmd, int nargs, ...)
 
 	ucall_arch_do_ucall((vm_vaddr_t)&uc);
 }
+
+uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	struct ucall ucall;
+	void *addr;
+
+	if (!uc)
+		uc = &ucall;
+
+	addr = addr_gva2hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
+	if (addr) {
+		memcpy(uc, addr, sizeof(*uc));
+		vcpu_run_complete_io(vcpu);
+	} else {
+		memset(uc, 0, sizeof(*uc));
+	}
+
+	return uc->cmd;
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index 9f532dba1003..24746120a593 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -22,25 +22,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
 }
 
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
 		struct kvm_regs regs;
 
 		vcpu_regs_get(vcpu, &regs);
-		memcpy(&ucall, addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi),
-		       sizeof(ucall));
-
-		vcpu_run_complete_io(vcpu);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
+		return regs.rdi;
 	}
-
-	return ucall.cmd;
+	return 0;
 }
-- 
2.37.1.455.g008518b4e5-goog

