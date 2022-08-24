Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F84359F1BB
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbiHXDEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiHXDDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE35B81B38
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:11 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 201-20020a6300d2000000b0042a89089736so4032802pga.9
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=+SIhYTBUYTFAvpLW0Up8qzMwlBeVs3qNEniJXYGsmJ4=;
        b=TFX+J/2SpUqaDOI4whujTsMB6JVeMbPd+LA/pH53Jrc9ZqmZDkwOacMhRIX2Z7ebhl
         kYLlj/eubz0nYDI2JiXKFUQId/kJmjm8eX4lPjTg972bGN5kpgQeU/YI3O02HJ+QaaEZ
         Xafn+rPAtVZ8Tro82nrTWhBAjmbxzzEcRXYswfQV2OKrJHRroIkFo6Debom2cZr96FS8
         C3pxwCuu2eSfthEcfjKlL8uD2feVJeS79NKyJNhfv4nTyeekE8sHTPh9bdCEAm5F0k/H
         ltlqgZfIEF0/A9pMXpApPqaGuiqhzKb03J3GkVAGuaETu8kHewDmcTFopu1Lq9Xuc1fJ
         YlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=+SIhYTBUYTFAvpLW0Up8qzMwlBeVs3qNEniJXYGsmJ4=;
        b=Q95+LEc41bB2MoJCgdopQdb2y/7n5ZN2xeQgt9KhUtdDRLngOWYlT8YmT6B+5HBQLn
         D4dzeGg5WGPz49rU/myycY9HIc4/bE4KpQHwEENzoHLaW2xhxnnlEZaOmZBBWzmDnGoo
         8wMWGBMdmQ0S7d63fZSmHc/cnhXBUgQsnXCu3b5PKbbZow/OgAaGLtKHTv/gYKP+/BBx
         Q4dtySAjWklU7lWYNYo7ItBMqk5EtutOrPa7yksPuJ1fc3kqKuCGISPYxtONIR26tE6E
         +wK5zLXlgPW32V9x6Yn9KDqHNOz9Ygek3nxBialTEODIzzpTw668p9Np9BgZMZ/0h7iD
         ICdQ==
X-Gm-Message-State: ACgBeo1dhQkLRP4CKTUBTycoW9ZLmH3qgqKSmK+GqNw52V6rJSNjKpdX
        hrEe9RM6t/N/r318OQUQYiipLg4Ndmo=
X-Google-Smtp-Source: AA6agR6+w843iTwZa71KnypAwmGm026ypbyC/fQGxkvO86tdoUEpnh7s0norch8SieartxtTYzWKCPogeoY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:b50a:0:b0:536:3a64:3492 with SMTP id
 y10-20020a62b50a000000b005363a643492mr20177206pfe.52.1661310131554; Tue, 23
 Aug 2022 20:02:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:20 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 18/36] KVM: selftests: Enable TSC scaling in evmcs selftest
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

The updated Enlightened VMCS v1 definition enables TSC scaling, test
that SECONDARY_EXEC_TSC_SCALING can now be enabled.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 31 +++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 99bc202243d2..21a7a792a010 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -18,6 +18,9 @@
 
 #include "vmx.h"
 
+/* Test flags */
+#define HOST_HAS_TSC_SCALING BIT(0)
+
 static int ud_count;
 
 static void guest_ud_handler(struct ex_regs *regs)
@@ -64,11 +67,14 @@ void l2_guest_code(void)
 	vmcall();
 	rdmsr_gs_base(); /* intercepted */
 
+	/* TSC scaling */
+	vmcall();
+
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
 
-void guest_code(struct vmx_pages *vmx_pages)
+void guest_code(struct vmx_pages *vmx_pages, u64 test_flags)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
@@ -150,6 +156,18 @@ void guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 	GUEST_SYNC(11);
 
+	if (test_flags & HOST_HAS_TSC_SCALING) {
+		GUEST_ASSERT((rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32) &
+			     SECONDARY_EXEC_TSC_SCALING);
+		/* Try enabling TSC scaling */
+		vmwrite(SECONDARY_VM_EXEC_CONTROL, vmreadz(SECONDARY_VM_EXEC_CONTROL) |
+			SECONDARY_EXEC_TSC_SCALING);
+		vmwrite(TSC_MULTIPLIER, 1);
+	}
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_SYNC(12);
+
 	/* Try enlightened vmptrld with an incorrect GPA */
 	evmcs_vmptrld(0xdeadbeef, vmx_pages->enlightened_vmcs);
 	GUEST_ASSERT(vmlaunch());
@@ -204,6 +222,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct ucall uc;
+	u64 test_flags = 0;
 	int stage;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
@@ -212,11 +231,19 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
 
+	if ((kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32) &
+	    SECONDARY_EXEC_TSC_SCALING) {
+		test_flags |= HOST_HAS_TSC_SCALING;
+		pr_info("TSC scaling is supported, adding to test\n");
+	} else {
+		pr_info("TSC scaling is not supported\n");
+	}
+
 	vcpu_set_hv_cpuid(vcpu);
 	vcpu_enable_evmcs(vcpu);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	vcpu_args_set(vcpu, 2, vmx_pages_gva, test_flags);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
-- 
2.37.1.595.g718a3a8f04-goog

