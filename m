Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A8E63E4F5
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiK3XOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiK3XNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:13:15 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23049C625
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:43 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3cb1a789dabso125387b3.3
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ajf/v6plBmBpvMRb25eu7yZbuYHVVa1MLg3BBW1ApnM=;
        b=Q7q/5TXzNDPohOMoxUDiD0nnqEk1FoSW4RF/EEt8HMYjM52gPxj46PgYF/68/eUC70
         R52IpECaCvp222vr9xTL7j44GbL8VsDvPS5HArvcL4xJanWkN6UNBVlmOIcOzEnjqYoe
         h8mvG1+Ri644iv9eVrF8AA62rM3of5sqQn2h8l1NJ4Hp9LBXQlFjVGfCJ0M8iuidAG/g
         r3QoWBzS8+6cQpNc7qHKOescERK5wH+DxZ5oURQjRLgPy9Nq0G8eKIEZQN5DdxTswpJO
         dO7YdMWEfCe6tuDQ8/4qvPOOW5vLDHcu9lY8BtQx5KXbThVrpdnPftQhmMi0Ij7DKBRT
         iKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ajf/v6plBmBpvMRb25eu7yZbuYHVVa1MLg3BBW1ApnM=;
        b=3tX8XdKKr8yh717E328DPNUGCWSeshEGWue3m8V9n0Hx0C1IdfZm9BEKOe+S58Uk7E
         GN4ynR9p9+S6vzJMGauSAoNyKV73WduerWtK49VTZqGDhKI5STNHzerpSqGfDtGdVe5e
         0F9Z/rqQkrgkVVN6sIsBXsjygeLTo7x+h2sNWAw7i8e2thJu68nsycV+z9H20c4Utpxa
         7T/0e94a0khfLKhRFaeUt3GJniCsh08qT0+GKZRZw/Bncy6Bnz2eguy48YlG2r3o22vy
         ryzbNGdQtawuHqBxXc0JAM+XmwsSwemq+hWk3VcVhl340mnzn1TAhWcFiE+qOOUnkVB+
         AFtg==
X-Gm-Message-State: ANoB5pnahZi5zZdPkc/KJsMCR+eB4FTwx/q0tSAMbzBOIMUNY4ZXCQZ1
        oL37CmjGYgW/p1jiLB4fpmAkwGIjGTg=
X-Google-Smtp-Source: AA0mqf6Y4D7Qf+J2WKP5H4v6O2gU4VSt61bmL1SListQ4TvwmtEqTFXL/Zt8AS/4xR6esIpeSKRCzrkbQ9o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8401:0:b0:6f1:4590:92b9 with SMTP id
 u1-20020a258401000000b006f1459092b9mr33613349ybk.430.1669849822483; Wed, 30
 Nov 2022 15:10:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:10 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-27-seanjc@google.com>
Subject: [PATCH v2 26/50] KVM: PPC: Move processor compatibility check to
 module init
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move KVM PPC's compatibility checks to their respective module_init()
hooks, there's no need to wait until KVM's common compat check, nor is
there a need to perform the check on every CPU (provided by common KVM's
hook), as the compatibility checks operate on global data.

  arch/powerpc/include/asm/cputable.h: extern struct cpu_spec *cur_cpu_spec;
  arch/powerpc/kvm/book3s.c: return 0
  arch/powerpc/kvm/e500.c: strcmp(cur_cpu_spec->cpu_name, "e500v2")
  arch/powerpc/kvm/e500mc.c: strcmp(cur_cpu_spec->cpu_name, "e500mc")
                             strcmp(cur_cpu_spec->cpu_name, "e5500")
                             strcmp(cur_cpu_spec->cpu_name, "e6500")

Cc: Fabiano Rosas <farosas@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  1 -
 arch/powerpc/kvm/book3s.c          | 10 ----------
 arch/powerpc/kvm/e500.c            |  4 ++--
 arch/powerpc/kvm/e500mc.c          |  4 ++++
 arch/powerpc/kvm/powerpc.c         |  2 +-
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index bfacf12784dd..51a1824b0a16 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -118,7 +118,6 @@ extern int kvmppc_xlate(struct kvm_vcpu *vcpu, ulong eaddr,
 extern int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu);
-extern int kvmppc_core_check_processor_compat(void);
 extern int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
                                       struct kvm_translation *tr);
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 6d525285dbe8..87283a0e33d8 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -999,16 +999,6 @@ int kvmppc_h_logical_ci_store(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvmppc_h_logical_ci_store);
 
-int kvmppc_core_check_processor_compat(void)
-{
-	/*
-	 * We always return 0 for book3s. We check
-	 * for compatibility while loading the HV
-	 * or PR module
-	 */
-	return 0;
-}
-
 int kvmppc_book3s_hcall_implemented(struct kvm *kvm, unsigned long hcall)
 {
 	return kvm->arch.kvm_ops->hcall_implemented(hcall);
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index c8b2b4478545..0ea61190ec04 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -314,7 +314,7 @@ static void kvmppc_core_vcpu_put_e500(struct kvm_vcpu *vcpu)
 	kvmppc_booke_vcpu_put(vcpu);
 }
 
-int kvmppc_core_check_processor_compat(void)
+static int kvmppc_e500_check_processor_compat(void)
 {
 	int r;
 
@@ -507,7 +507,7 @@ static int __init kvmppc_e500_init(void)
 	unsigned long handler_len;
 	unsigned long max_ivor = 0;
 
-	r = kvmppc_core_check_processor_compat();
+	r = kvmppc_e500_check_processor_compat();
 	if (r)
 		goto err_out;
 
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index 57e0ad6a2ca3..795667f7ebf0 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -388,6 +388,10 @@ static int __init kvmppc_e500mc_init(void)
 {
 	int r;
 
+	r = kvmppc_e500mc_check_processor_compat();
+	if (r)
+		return kvmppc_e500mc;
+
 	r = kvmppc_booke_init();
 	if (r)
 		goto err_out;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 5faf69421f13..d44b85ba8cef 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -442,7 +442,7 @@ int kvm_arch_hardware_enable(void)
 
 int kvm_arch_check_processor_compat(void *opaque)
 {
-	return kvmppc_core_check_processor_compat();
+	return 0;
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
-- 
2.38.1.584.g0f3c55d4c2-goog

