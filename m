Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC127679AE
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbjG2AhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbjG2Agx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:36:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7231430FB
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c04f5827eso1882186a12.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591012; x=1691195812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jjZUurEgx8+1WTff2yy2mIJojJc3waWamxg7HHxYGIg=;
        b=noxRP7DyXhyaM98FK0Vfbiwdsje2k4Fme8Ej+Lzw3561F5KC+8wOpq147aZ9YkCJA4
         yEvYhRIL0tZYxlGfadJ3T/3jLoEbUzrRLhc+Tpjjx3RoDw70wdOdllOhL6e3s9wXinRE
         stWTzC1jd5xpvinZznJG2aox3Q/eCKj8CKm8HHcFpRAqbyrWnYRMbc+qOK3bW954IHkN
         khHcPSsUb+qRbsTCBupFaUGuJ2ouREB28Jz6YQlS/pAikuObTfZ9xuQkb79Ykk1rItdc
         /QIdsA7sAOkNbdhQEtraNqyeGeOjcd1g1go1jvyob4nqQ1d1fjXGQ7+U7YBmsRRKafg/
         r2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591012; x=1691195812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjZUurEgx8+1WTff2yy2mIJojJc3waWamxg7HHxYGIg=;
        b=TakbQ+TOILS49LyaXF/6cFBF5lBrZSr5B+XSmro4ZgGZnkss+NCSgBKxCZXk6qx0/K
         6GEjcs71bQvRMrzN6Yf/MHoU8j6KqRAYckjafUyfhpk5zkG9R/DdyQ7JJFL/qbSulrUa
         LagWGwALk1ms6h+PzXhKZhpiUP39AVLfb7wlP/xi3nD8c0qc8Wv3yZUfDVzfkTv/O0Pr
         TUsM6auN/r8iEVEBYQjvrCjs4pEYUUfb4yAL0iErlcyOCDymNFDQfnA2u7poUNL9H081
         yPb3WxUK6GWn4XOEb8r6LtW1cK+2NNFubWJpP3XxIGNRGcR+l1xyfKUSfo8/nw0NcOxi
         HkPw==
X-Gm-Message-State: ABy/qLZzrkPLfjuAo0wFcUfY28hRh1KSPDpKr5zeQmt4cHs05xzI8L3a
        mFBGC4wum8ku7ueUgWvEjksDK8rD/Wk=
X-Google-Smtp-Source: APBJJlGOQzm3R4lKKE8dcYLKl/QqgICXHzOASeCmeTU7bt0Nk1iWBuRrxrxWvMsBrvIEj9CQ6afqhQgcvVk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f990:b0:1b8:80c9:a98e with SMTP id
 ky16-20020a170902f99000b001b880c9a98emr10492plb.13.1690591012012; Fri, 28 Jul
 2023 17:36:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:12 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-4-seanjc@google.com>
Subject: [PATCH v4 03/34] KVM: selftests: Add a shameful hack to
 preserve/clobber GPRs across ucall
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
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

Preserve or clobber all GPRs (except RIP and RSP, as they're saved and
restored via the VMCS) when performing a ucall on x86 to fudge around a
horrific long-standing bug in selftests' nested VMX support where L2's
GPRs are not preserved across a nested VM-Exit.  I.e. if a test triggers a
nested VM-Exit to L1 in response to a ucall, e.g. GUEST_SYNC(), then L2's
GPR state can be corrupted.

The issues manifests as an unexpected #GP in clear_bit() when running the
hyperv_evmcs test due to RBX being used to track the ucall object, and RBX
being clobbered by the nested VM-Exit.  The problematic hyperv_evmcs
testcase is where L0 (test's host userspace) injects an NMI in response to
GUEST_SYNC(8) from L2, but the bug could "randomly" manifest in any test
that induces a nested VM-Exit from L0.  The bug hasn't caused failures in
the past due to sheer dumb luck.

The obvious fix is to rework the nVMX helpers to save/restore L2 GPRs
across VM-Exit and VM-Enter, but that is a much bigger task and carries
its own risks, e.g. nSVM does save/restore GPRs, but not in a thread-safe
manner, and there is a _lot_ of cleanup that can be done to unify code
for doing VM-Enter on nVMX, nSVM, and eVMCS.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/lib/x86_64/ucall.c  | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index 4d41dc63cc9e..a53df3ece2f8 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -14,8 +14,36 @@ void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
-	asm volatile("in %[port], %%al"
-		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
+	/*
+	 * FIXME: Revert this hack (the entire commit that added it) once nVMX
+	 * preserves L2 GPRs across a nested VM-Exit.  If a ucall from L2, e.g.
+	 * to do a GUEST_SYNC(), lands the vCPU in L1, any and all GPRs can be
+	 * clobbered by L1.  Save and restore non-volatile GPRs (clobbering RBP
+	 * in particular is problematic) along with RDX and RDI (which are
+	 * inputs), and clobber volatile GPRs. *sigh*
+	 */
+#define HORRIFIC_L2_UCALL_CLOBBER_HACK	\
+	"rcx", "rsi", "r8", "r9", "r10", "r11"
+
+	asm volatile("push %%rbp\n\t"
+		     "push %%r15\n\t"
+		     "push %%r14\n\t"
+		     "push %%r13\n\t"
+		     "push %%r12\n\t"
+		     "push %%rbx\n\t"
+		     "push %%rdx\n\t"
+		     "push %%rdi\n\t"
+		     "in %[port], %%al\n\t"
+		     "pop %%rdi\n\t"
+		     "pop %%rdx\n\t"
+		     "pop %%rbx\n\t"
+		     "pop %%r12\n\t"
+		     "pop %%r13\n\t"
+		     "pop %%r14\n\t"
+		     "pop %%r15\n\t"
+		     "pop %%rbp\n\t"
+		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory",
+		     HORRIFIC_L2_UCALL_CLOBBER_HACK);
 }
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
-- 
2.41.0.487.g6d72f3e995-goog

