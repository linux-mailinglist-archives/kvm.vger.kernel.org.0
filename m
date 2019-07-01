Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC7C4BD43
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfFSPuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 11:50:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46023 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFSPuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 11:50:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so3897778wre.12;
        Wed, 19 Jun 2019 08:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=zjf81C76HrVq+IReyDc6rr3+Eybofc2ke2b3vedZ5Rg=;
        b=ULctRkHDOigvuGlSvdwNv3rWYSF9l80UIsojktkG8wSVREp60zn7BBE0zSyH4N1C+c
         L3QO7i7auNozvzvjRDFGY92+L8FgL94ArECvsovHgh6SCv94okLREIFeVG+ncRncFQZo
         adh5deAk9NRmmpuRxNyk0YFZw8C2rcgt6tWYpPnidOI5d2mM1nHZ2YfaS0CYu7PHno1w
         6jLtVujb2t47X+hh0PgqPsb/FZL2bayp0ebjBm8K8squkHPdR+9JImYWaPIV/CtiL1Zu
         9gIh6TMh8OG2lXWeCuqJ4IPAw9MRzsrA+dSJoNx44vovu+Io3vUNkW4dyZTl1FwIaOEX
         EG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=zjf81C76HrVq+IReyDc6rr3+Eybofc2ke2b3vedZ5Rg=;
        b=ksB/GcdwDtRAduY3xrMOt0aEWwRAw8kKDrnF28PU/cfOrPlybD05XiZIAmGca1ELpQ
         TFOQPErPVjY/BMyURU5gCsb+INpav0I5QfkcdSNwnsD05uOrVWmznWOdWJY5O6gInq3o
         k66Q96KkoNBkb1zxgBpV4vGeTa2ZwKERjjU0rRDZdBTbuHiSTCtORj4N42uTflnAcaOP
         wpiTIPti5U8rxvsosXK22YJPDAOWv/yXKro+jtWpgEqx8h8sgsSw/xkqG5J034nGqqPr
         SvXXiqCnLtKOIRDA77OuKJfhXfrLgUOhQJQcj9FkS5EK5TpyWd8IeEsWVySB+mKGdKjL
         wn+Q==
X-Gm-Message-State: APjAAAXbPim8m2f7RqyxXJgPe7yyF6xvPLB/nf/fP8Igqeo/kgBsObxp
        3ni2vu3KfUGS7AJ4Er5QssPn2irl
X-Google-Smtp-Source: APXvYqwlCcWEflll908xJpAYKY+HQOFWGdzfS9lQKxxuzhnSmvwWppTU0LaGLOKY0gVoXg3rRewatA==
X-Received: by 2002:adf:dd03:: with SMTP id a3mr34099070wrm.87.1560959398652;
        Wed, 19 Jun 2019 08:49:58 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q21sm1977424wmq.13.2019.06.19.08.49.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 08:49:57 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: nVMX: reorganize initial steps of vmx_set_nested_state
Date:   Wed, 19 Jun 2019 17:49:56 +0200
Message-Id: <1560959396-13969-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 332d079735f5 ("KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS
state before setting new state", 2019-05-02) broke evmcs_test because the
eVMCS setup must be performed even if there is no VMXON region defined,
as long as the eVMCS bit is set in the assist page.

While the simplest possible fix would be to add a check on
kvm_state->flags & KVM_STATE_NESTED_EVMCS in the initial "if" that
covers kvm_state->hdr.vmx.vmxon_pa == -1ull, that is quite ugly.

Instead, this patch moves checks earlier in the function and
conditionalizes them on kvm_state->hdr.vmx.vmxon_pa, so that
vmx_set_nested_state always goes through vmx_leave_nested
and nested_enable_evmcs.

Fixes: 332d079735f5
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c                          | 26 ++++++++++--------
 .../kvm/x86_64/vmx_set_nested_state_test.c         | 32 ++++++++++++++--------
 2 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fb6d1f7b43f3..5f9c1a200201 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5343,9 +5343,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_VMX)
 		return -EINVAL;
 
-	if (!nested_vmx_allowed(vcpu))
-		return kvm_state->hdr.vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
-
 	if (kvm_state->hdr.vmx.vmxon_pa == -1ull) {
 		if (kvm_state->hdr.vmx.smm.flags)
 			return -EINVAL;
@@ -5353,12 +5350,15 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		if (kvm_state->hdr.vmx.vmcs12_pa != -1ull)
 			return -EINVAL;
 
-		vmx_leave_nested(vcpu);
-		return 0;
-	}
+		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
+			return -EINVAL;
+	} else {
+		if (!nested_vmx_allowed(vcpu))
+			return -EINVAL;
 
-	if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
-		return -EINVAL;
+		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
+			return -EINVAL;
+    	}
 
 	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
 	    (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
@@ -5381,11 +5381,15 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	vmx_leave_nested(vcpu);
-	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
-		return 0;
+	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
+		if (!nested_vmx_allowed(vcpu))
+			return -EINVAL;
 
-	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
 		nested_enable_evmcs(vcpu, NULL);
+	}
+
+	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
+		return 0;
 
 	vmx->nested.vmxon_ptr = kvm_state->hdr.vmx.vmxon_pa;
 	ret = enter_vmx_operation(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 0648fe6df5a8..e64ca20b315a 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -123,36 +123,44 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	/*
 	 * We cannot virtualize anything if the guest does not have VMX
 	 * enabled.  We expect KVM_SET_NESTED_STATE to return 0 if vmxon_pa
-	 * is set to -1ull.
+	 * is set to -1ull, but the flags must be zero.
 	 */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
+	test_nested_state_expect_einval(vm, state);
+
+	state->hdr.vmx.vmcs12_pa = -1ull;
+	state->flags = KVM_STATE_NESTED_EVMCS;
+	test_nested_state_expect_einval(vm, state);
+
+	state->flags = 0;
 	test_nested_state(vm, state);
 
 	/* Enable VMX in the guest CPUID. */
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
-	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
+	/*
+	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
+	 * setting the nested state but flags other than eVMCS must be clear.
+	 */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
+	state->hdr.vmx.vmcs12_pa = -1ull;
+	test_nested_state_expect_einval(vm, state);
+
+	state->flags = KVM_STATE_NESTED_EVMCS;
+	test_nested_state(vm, state);
+
+	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
 	state->hdr.vmx.smm.flags = 1;
 	test_nested_state_expect_einval(vm, state);
 
 	/* It is invalid to have vmxon_pa == -1ull and vmcs_pa != -1ull. */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
-	state->hdr.vmx.vmcs12_pa = 0;
+	state->flags = 0;
 	test_nested_state_expect_einval(vm, state);
 
-	/*
-	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
-	 * setting the nested state.
-	 */
-	set_default_vmx_state(state, state_sz);
-	state->hdr.vmx.vmxon_pa = -1ull;
-	state->hdr.vmx.vmcs12_pa = -1ull;
-	test_nested_state(vm, state);
-
 	/* It is invalid to have vmxon_pa set to a non-page aligned address. */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = 1;
-- 
1.8.3.1

