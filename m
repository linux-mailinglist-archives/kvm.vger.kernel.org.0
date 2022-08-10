Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFED58EF50
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiHJPVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiHJPUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:20:53 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E735D0EB
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:50 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o12-20020a170902d4cc00b0016e81c62cc8so9982130plg.13
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=+ciazqpjV1jQm50yVPOpkxQh2xkGg5GkO+tFYJaL3ck=;
        b=eGa+rGN5BunXwgiJcdHszFWc3mIjKJPcPHd54XRsgZdIHQn1FwkJ9ESAE2KPRmG1uY
         oXnYNL9aStWM+0NaKqCKLONS+q/QG9jzOQBWQSBf4p4wosSaSjYdZz0+BVO941ejtoYx
         FMbP3LDK1dsWpZqgDA5EiQoKJTV0xQMWnwIxlGnOwrAyAJtAW2Cgcpt/5LexKLRKE0/S
         C3RYsK4J/QY3zPa/lUaPspHylsGt2Cc/XQCpck70o+MXl/6iMnX8ieiblPx7jRXCVRuM
         GSws0brc4Q6/Tm5dq/MpQQeYGlWUIkmdtzJ7R+jemistHHj8KO0kPPPdy4b97EKpblqg
         f4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=+ciazqpjV1jQm50yVPOpkxQh2xkGg5GkO+tFYJaL3ck=;
        b=Wek8mreAWy031qoq6C1KtNu8wp581q4T1gyS23r3Ju5gnRKAfQfFKpkfVXoNkwP4Ml
         0Xfn906SRln8+ZPgilt6xh3tffv6LUffK5c0RVNZBSXd/3bS1o2SR5sF2n27Rhlyzs3l
         pvuVBpzV1zEmbONY7evYRjFhIkwo66fed4nVQZ/M81FB59DdFnHxUJepi3M/l0cz/NwI
         +BC3yA21COvbNcKeV/lCsoQ7tn6lZZiP0bPprab0eEmUQWv89PFsXJSEeJA3gBoLVALl
         10IEzTP6ZbegeiWMSXQML4/hlBDmFrZxmixEVw+PqywUIObFLwB38JxIaIzZnEEETpxg
         jaKA==
X-Gm-Message-State: ACgBeo22oYgCto9dPjIHcqTH3cDb9a13BcOofxH6wo64pwk+XfZMDu4R
        Hw77gSEu0aisl7jydd3ZgXwP4UJG395KsuEQMhjLTlEum2DNjnKM34T2veuV/t+ZpyNmi4RlPyi
        rFsvK6MzaBRA2ElGxz4bCnEmY3QV9BGMBYzXuxkMHxfRP70uXoLxOl7bG1Q==
X-Google-Smtp-Source: AA6agR6z5l0ixZb9nEJXga+3E/JUEYAWhkrC8r2SuglZB9uV73r1XZ6c12lFMU7w5M8cFFnBf1ewFT4mvvU=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:b8d:b0:52d:dead:5570 with SMTP id
 g13-20020a056a000b8d00b0052ddead5570mr27662260pfj.56.1660144849538; Wed, 10
 Aug 2022 08:20:49 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:29 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-8-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 07/11] KVM: selftests: Consolidate boilerplate code in get_ucall()
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com,
        Peter Gonda <pgonda@google.com>
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
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 14 +++-----------
 tools/testing/selftests/kvm/lib/riscv/ucall.c | 19 +++----------------
 tools/testing/selftests/kvm/lib/s390x/ucall.c | 16 +++-------------
 .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  | 16 +++-------------
 6 files changed, 33 insertions(+), 59 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 5a85f5318bbe..63bfc60be995 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -27,9 +27,10 @@ struct ucall {
 void ucall_arch_init(struct kvm_vm *vm, void *arg);
 void ucall_arch_uninit(struct kvm_vm *vm);
 void ucall_arch_do_ucall(vm_vaddr_t uc);
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
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
index 1c81a6a5c1f2..132c0e98bf49 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -75,13 +75,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
 }
 
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
@@ -90,12 +86,8 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
 			    "Unexpected ucall exit mmio address access");
 		memcpy(&gva, run->mmio.data, sizeof(gva));
-		memcpy(&ucall, addr_gva2hva(vcpu->vm, gva), sizeof(ucall));
-
-		vcpu_run_complete_io(vcpu);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
+		return addr_gva2hva(vcpu->vm, gva);
 	}
 
-	return ucall.cmd;
+	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index b1598f418c1f..37e091d4366e 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -51,27 +51,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 		  uc, 0, 0, 0, 0, 0);
 }
 
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
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
+			return addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]);
 		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
 			vcpu_dump(stderr, vcpu, 2);
 			TEST_ASSERT(0, "Unexpected trap taken by guest");
@@ -80,6 +68,5 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 			break;
 		}
 	}
-
-	return ucall.cmd;
+	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 114cb4af295f..0f695a031d35 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -20,13 +20,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
 }
 
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
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
+		return addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]);
 	}
-
-	return ucall.cmd;
+	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 2395c7f1d543..ced480860746 100644
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
+	addr = ucall_arch_get_ucall(vcpu);
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
index 9f532dba1003..ead9946399ab 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -22,25 +22,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
 }
 
-uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
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
+		return addr_gva2hva(vcpu->vm, regs.rdi);
 	}
-
-	return ucall.cmd;
+	return NULL;
 }
-- 
2.37.1.559.g78731f0fdb-goog

