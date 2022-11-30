Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE96E63E4A1
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiK3XLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiK3XK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:10:27 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C8299F47
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:58 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y6-20020a17090322c600b00189892baa53so12012497plg.6
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7yWYfpXTDQbZLx47MbNcDj0N66CBaR6qG+PnY/I15CM=;
        b=bT3dL2RNgcw1MpeUO77l7FsTfdHMpEPlJatekk/DzFXJMm693HavywTCaGv6OqR75P
         CEGSx4lH9Jtd0fa2semdatuM2+6/GtUmIUJQimOKEXQM8pMgCWT8njsrI/UOhbCPveML
         q4zrbtboaVnIfVEgvLRQEAam2V+r4+zAGV7lL18Zl2LduEOPaMTpPlFnw/B6EsrXnukj
         2pbaAxvJ9zg/7eNsW555x3IFXEMVva/FgAmoY74Di0SuLoDCFLXDc3bBoL6HnnnAq35N
         reo1l2pMb3FCDaYjA4+6K/LTtV98kIt8jz3I1oCTyDyB/5twL2Ezyrmfizfy7s3Xbw19
         DN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7yWYfpXTDQbZLx47MbNcDj0N66CBaR6qG+PnY/I15CM=;
        b=NDHsKZIzfogRj7kZKl21EL7dtPktaNauigoFrWRlOmfQT/1WmJzIfc5q3x7P/LoADV
         9MrXffPeO5sFFGarO+mNIMuHcElAewWzdygGJAGo4HJAB5S5EQPMHOGJLVVM5pDiD96e
         YOvqZDMcwx3+SkpdwH92ZkIivscr/n371lnO/vQ4bW44dCJZahZHeii4U2NPeDUkSdc5
         4KAWCx0QLgnKhMGXngDlLObgihq+ZaDoKPtHE8bBgRcndq7k1bUary3/9jkKL/izObpg
         tqr9CiPVLOay1HfDu/AGxTan8y7FhOwDt+aDU7czKgHDpNejGxgrtIUsdDZD7JDzEIhZ
         NebA==
X-Gm-Message-State: ANoB5pn35WG1c3rsY7mpTRxQzSo2xYMVh7NvXKvsKIHHBDM2mOQnhrAx
        OCrWGXIQrkKZjMTj5cu9wSDN3ASBDSk=
X-Google-Smtp-Source: AA0mqf63J5CYVyPrHNleGtfRjvZIjPjkTqLR79wPGUIq9AORVm0CVLKuvvqzhbFB0T9FDbVeahYix13Gv4o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ee55:b0:176:a16a:417d with SMTP id
 21-20020a170902ee5500b00176a16a417dmr47218439plo.46.1669849797761; Wed, 30
 Nov 2022 15:09:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:08:56 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-13-seanjc@google.com>
Subject: [PATCH v2 12/50] KVM: VMX: Move Hyper-V eVMCS initialization to helper
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

Move Hyper-V's eVMCS initialization to a dedicated helper to clean up
vmx_init(), and add a comment to call out that the Hyper-V init code
doesn't need to be unwound if vmx_init() ultimately fails.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 73 +++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c0de7160700b..b8bf95b9710d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -523,6 +523,8 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 static unsigned long host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
+static struct kvm_x86_ops vmx_x86_ops __initdata;
+
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
@@ -551,6 +553,43 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static __init void hv_init_evmcs(void)
+{
+	int cpu;
+
+	if (!enlightened_vmcs)
+		return;
+
+	/*
+	 * Enlightened VMCS usage should be recommended and the host needs
+	 * to support eVMCS v1 or above.
+	 */
+	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
+	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
+	     KVM_EVMCS_VERSION) {
+
+		/* Check that we have assist pages on all online CPUs */
+		for_each_online_cpu(cpu) {
+			if (!hv_get_vp_assist_page(cpu)) {
+				enlightened_vmcs = false;
+				break;
+			}
+		}
+
+		if (enlightened_vmcs) {
+			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
+			static_branch_enable(&enable_evmcs);
+		}
+
+		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
+			vmx_x86_ops.enable_l2_tlb_flush
+				= hv_enable_l2_tlb_flush;
+
+	} else {
+		enlightened_vmcs = false;
+	}
+}
+
 static void hv_reset_evmcs(void)
 {
 	struct hv_vp_assist_page *vp_ap;
@@ -577,6 +616,7 @@ static void hv_reset_evmcs(void)
 }
 
 #else /* IS_ENABLED(CONFIG_HYPERV) */
+static void hv_init_evmcs(void) {}
 static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
@@ -8500,38 +8540,11 @@ static int __init vmx_init(void)
 {
 	int r, cpu;
 
-#if IS_ENABLED(CONFIG_HYPERV)
 	/*
-	 * Enlightened VMCS usage should be recommended and the host needs
-	 * to support eVMCS v1 or above. We can also disable eVMCS support
-	 * with module parameter.
+	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
+	 * to unwind if a later step fails.
 	 */
-	if (enlightened_vmcs &&
-	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
-	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
-	    KVM_EVMCS_VERSION) {
-
-		/* Check that we have assist pages on all online CPUs */
-		for_each_online_cpu(cpu) {
-			if (!hv_get_vp_assist_page(cpu)) {
-				enlightened_vmcs = false;
-				break;
-			}
-		}
-
-		if (enlightened_vmcs) {
-			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
-			static_branch_enable(&enable_evmcs);
-		}
-
-		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vmx_x86_ops.enable_l2_tlb_flush
-				= hv_enable_l2_tlb_flush;
-
-	} else {
-		enlightened_vmcs = false;
-	}
-#endif
+	hv_init_evmcs();
 
 	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
-- 
2.38.1.584.g0f3c55d4c2-goog

