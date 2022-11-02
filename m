Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE5F61724B
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiKBXYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiKBXXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:23:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2192669
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i65-20020a25d144000000b006cfec5975d5so349913ybg.15
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+L2f375WnDKSQSrHAcatMrAfJYCgg/AkS64YUNDhysQ=;
        b=BFDMuesdcf+U8clFlnsdcKMjEl5mRxrD1n9OYPB//rQ3VCubJly/rCCXdf60izOQ91
         gfZZvi49gCFrX7m6YJ/L3w1exRMCJjCuSICe4eRMng8+wai+/D16fwsJO3oG2Y3R0FX9
         fdeZ05XsyRVj9dD8bnC/3GDU2X+txUX5pHb6PL20RI7N+YCsO7MLcF6r1LMuuK0Pg4nq
         eE6rPQbqAixH7lbH5M4EJKUgaFlKJVjkGeGOUWsceZR0ohG40mmen016UsHv1w9M69we
         XfA2eYS+cPWfEbsMnwoPEeVjdG1rAWn3/E5NNWh/oBhlSgRKP2yTVbQeeBXTj7yW7L6G
         n2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+L2f375WnDKSQSrHAcatMrAfJYCgg/AkS64YUNDhysQ=;
        b=m0PtCcTZ6Zs5voNFn9Og/LAQJoWkCOSRJ72qyb7VaIH+xTwPIcRyP9P3MhrdOiaBu5
         ZZx7WEwr3+mHUCSxncpA0IKietl9U6Rb+11I08kvy5QXB9Rpw0UsgQCCzBvDDhJWJxZN
         A3wCodCaJJy3ufjsQ1g+PLenZaaOg+G52C8RWeKYO3MDlx31P4cbZaa45YivueNVz67O
         WrLXIIjZI1youYGXT4BQkRczvBe2EU8Tanlo+6Yr8cMLjygKnKjGcNob+LWHqGpspKjF
         Fvx9Ho8XF8voiJM7ThMDlE2WTCZA8f2jQOF20PFQ/viqyCtULG+KIcGuH6quEpnCbaxS
         T6VQ==
X-Gm-Message-State: ACrzQf1aTd1OxFEzbPXjVQ8Vtd/+0+lUgRQfDjh6lZbrn6HE/2Jl7Aw4
        /UOKi8Zh01/zYe72xfB01dkEvmZz6eI=
X-Google-Smtp-Source: AMsMyM4PzbXrj68EN8oL/rsKX+M0E41FPJHAXl8jIfJjWzfdfyN3Z0LYOQj3COZgmfCbUolFuDEOGWUorR8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:83ca:0:b0:6ca:6c0c:9cb8 with SMTP id
 v10-20020a2583ca000000b006ca6c0c9cb8mr26416502ybm.7.1667431195114; Wed, 02
 Nov 2022 16:19:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:51 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-25-seanjc@google.com>
Subject: [PATCH 24/44] KVM: PPC: Move processor compatibility check to module init
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
        Vitaly Kuznetsov <vkuznets@redhat.com>
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
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
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
index 74ea5687ecbc..36c27381a769 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -443,7 +443,7 @@ int kvm_arch_hardware_enable(void)
 
 int kvm_arch_check_processor_compat(void *opaque)
 {
-	return kvmppc_core_check_processor_compat();
+	return 0;
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
-- 
2.38.1.431.g37b22c650d-goog

