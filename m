Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B7F5A1D19
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 01:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbiHYXZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 19:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244476AbiHYXZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 19:25:30 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7962543EE
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-334370e5ab9so368330127b3.22
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=4Z//RLyP1rehkHu+EvaRqQeA7gFSVFg1ryRIWG0VX5Y=;
        b=cVHOX92sbLmSy2g6YtgsMML5vcPqtHbHBidVtUFbsEmymJTDzJsaRcoIh6RXnAJeQG
         IuDzl2PZbtJ2zl2haGTEwDSy9yaRX97uWu4/ZRUUszl+0Brm1o+inP1zty75rodY+eHt
         hPwes2yaNbGCk+CBxyX4ilV6csqVz8uJLEXVzS2NMVp3AkUwhYz+zCuei9SlsgWdp2w9
         jQFNnh8CZCXP1H6wxvA+i+YSuIFxdDeKcpOOxj5uATqw9Tvc4oue8AQUqrGs5qvuvqY1
         KJnHAau3De93VLwXJqDm/2c8P74QxM30NWcQwfyr9bT3riLnU5YwQm1O+PqdNGlzSwgc
         Ph+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=4Z//RLyP1rehkHu+EvaRqQeA7gFSVFg1ryRIWG0VX5Y=;
        b=P49sD/F2uXS2bT6e/NuAq5buFHr6WMNCmzEKtmy87wNw3LesX6HQ8vxOOpgk1Aqt1T
         hk5wzPWYGKZyFFYj7v/iwNNcORZjDe+awPMHpExAz31loy8MUXY72LhaSPTjjOz33M2j
         gFstw375lP4kwgd9W6F/JMZJc8m9W5EthAn5A2src9UQldVvVQB+9jzHjYhXLJdlrdpm
         e5l4TKp9gwnRv0DDDOQJLhKPnAQeOZb8ouilGzRFEpw5jVMXVFq5BuVT5f02DiTcz8HK
         YYGzkXzknnkuBr3GvGm4wX7IFhZgh4yaPPY+S9q4/gouzBORPxwWobftuDBg60NQ+2xC
         mG3A==
X-Gm-Message-State: ACgBeo3x5xHrIg5wDZRgqcqu+pegCltsuWGUdWUxa05hJlM3jwt+qszS
        QKpCBNWm1allo2Mza9kL8qsrLCFC/II=
X-Google-Smtp-Source: AA6agR5SnckLSZpn3KybUgOT4V+32XfiY55JPpOmN81Bv4muHwBphBjBEWNuUIWloNXG0OXE6tVlLayo7YE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e401:0:b0:66e:280a:98cd with SMTP id
 b1-20020a25e401000000b0066e280a98cdmr5127394ybh.540.1661469928122; Thu, 25
 Aug 2022 16:25:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 23:25:17 +0000
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825232522.3997340-3-seanjc@google.com>
Subject: [PATCH v5 2/7] KVM: selftests: Consolidate boilerplate code in get_ucall()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Peter Gonda <pgonda@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>
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

Consolidate the actual copying of a ucall struct from guest=>host into
the common get_ucall().  Return a host virtual address instead of a guest
virtual address even though the addr_gva2hva() part could be moved to
get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
should return a host virtual address (and returning NULL for "nothing to
see here" is far superior to returning 0).

Use pointer shenanigans instead of an unnecessary bounce buffer when the
caller of get_ucall() provides a valid pointer.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
index 3630708c32d6..f214f5cc53d3 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -75,13 +75,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
 	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
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
2.37.2.672.g94769d06f0-goog

