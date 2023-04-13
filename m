Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0D76E1839
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 01:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjDMXUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 19:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjDMXTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 19:19:42 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6512690
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 16:19:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id ki6-20020a170903068600b001a684425451so1643200plb.15
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 16:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681427958; x=1684019958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vZsykKViO8pH2Vq7w4jg9ismrGeS6Wz/K+CquJ5ZblQ=;
        b=ESH/2wT0E4cL62dYuCz17pQNunVUYZDw/KsjWrqxwsAn94TDzXGTRE9j+kJ+Mn0CUv
         O/IMqRLcvIjFn5dpck0j8OZh6BLMTqjo3dJMOp0bTBT1PaVMxar51A3Ajbu4nQt1NOWi
         zUIsiisrDFk7ngI7Da5sOfZsp6kA6kmv4wyEH2qDEnZw7MuCbyC/bDiYZCpK5vJwD3ih
         qQOXk515/V2RF8w/U7QtuIc5WHlSTPaye2+mZyG0JHPvyc20QSDUWZamZmVkkPJHS5FN
         pUu39gPXc5R3/OCVaPktyNxYGNFg0Fjv5MZ7sgMaVj39HBg2y3pP8BsBbDH8zjrYIbcm
         gsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681427958; x=1684019958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZsykKViO8pH2Vq7w4jg9ismrGeS6Wz/K+CquJ5ZblQ=;
        b=QhdKACkkUidEvIn4YTezkiZJJrbY6J4ApCNwTwNCz2Rd3alPxoEAR/TtdBI4qbDqbj
         Q7asXw9bq7zIuFg+Z57dRgdnsGwkGGJGouQbVAYnbajmcAIEWf/d5thd35SzSqHL4yqW
         mcAUHKyqjuVdWmciQDv0CZYzz8g/3GyKn11jdrZrQv64pFx6S2TiBdsA4C3LWJkhquXW
         FP9rexsJweKSTVMDX5de27j82BuVlNLJWMOZ1mBXMEzXCuGPaHSAgbmRgYaaWKh88W3C
         h1dfvp59d19sba6a0xudvxV9fyd6oONbfEU9sfcGx2GMw2LJiHG5d6jSWmHIcYSckFlx
         /8bw==
X-Gm-Message-State: AAQBX9fXPWqRMhX3qRBUi/H5crAHngcTSh9RrUysjNkSiyquoBAmvZ/j
        CJadPtCStyba4ihByiCj7i0EjqGYGOk=
X-Google-Smtp-Source: AKy350aw7RgjjqqoMSboOkpamQ1m/yQB+WM/UlBTFExfGxFdyHkEbTi9OW+hTp2Tg8bKyf/f+xFA3hkDpiQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5d20:0:b0:513:5ac2:8e59 with SMTP id
 r32-20020a635d20000000b005135ac28e59mr203058pgb.10.1681427958623; Thu, 13 Apr
 2023 16:19:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Apr 2023 16:19:13 -0700
In-Reply-To: <20230413231914.1482782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230413231914.1482782-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230413231914.1482782-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: VMX: Treat UMIP as emulated if and only if the host
 doesn't have UMIP
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@intel.com>
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

Advertise UMIP as emulated if and only if the host doesn't natively
support UMIP, otherwise vmx_umip_emulated() is misleading when the host
_does_ support UMIP.  Of the four users of vmx_umip_emulated(), two
already check for native support, and the logic in vmx_set_cpu_caps() is
relevant if and only if UMIP isn't natively supported as UMIP is set in
KVM's caps by kvm_set_cpu_caps() when UMIP is present in hardware.

That leaves KVM's stuffing of X86_CR4_UMIP into the default cr4_fixed1
value enumerated for nested VMX.  In that case, checking for (lack of)
host support is actually a bug fix of sorts, as enumerating UMIP support
based solely on descriptor table exiting works only because KVM doesn't
sanity check MSR_IA32_VMX_CR4_FIXED1.  E.g. if a (very theoretical) host
supported UMIP in hardware but didn't allow UMIP+VMX, KVM would advertise
UMIP but not actually emulate UMIP.  Of course, KVM would explode long
before it could run a nested VM on said theoretical CPU, as KVM doesn't
modify host CR4 when enabling VMX, i.e. would load an "illegal" value into
vmcs.HOST_CR4.

Reported-by: Robert Hoo <robert.hu@intel.com>
Link: https://lore.kernel.org/all/20230310125718.1442088-2-robert.hu@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 ++--
 arch/x86/kvm/vmx/nested.c       | 3 +--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..d0abee35d7ba 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -152,8 +152,8 @@ static inline bool cpu_has_vmx_ept(void)
 
 static inline bool vmx_umip_emulated(void)
 {
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_DESC;
+	return !boot_cpu_has(X86_FEATURE_UMIP) &&
+	       (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC);
 }
 
 static inline bool cpu_has_vmx_rdtscp(void)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 96ede74a6067..4fadf6c661d5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2328,8 +2328,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		 * Preset *DT exiting when emulating UMIP, so that vmx_set_cr4()
 		 * will not have to rewrite the controls just for this bit.
 		 */
-		if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated() &&
-		    (vmcs12->guest_cr4 & X86_CR4_UMIP))
+		if (vmx_umip_emulated() && (vmcs12->guest_cr4 & X86_CR4_UMIP))
 			exec_control |= SECONDARY_EXEC_DESC;
 
 		if (exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..57464c762c79 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3404,7 +3404,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	else
 		hw_cr4 |= KVM_PMODE_VM_CR4_ALWAYS_ON;
 
-	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
+	if (vmx_umip_emulated()) {
 		if (cr4 & X86_CR4_UMIP) {
 			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 			hw_cr4 &= ~X86_CR4_UMIP;
-- 
2.40.0.634.g4ca3ef3211-goog

