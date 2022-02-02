Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4242F4A7B6B
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 00:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347984AbiBBXEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 18:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347980AbiBBXEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 18:04:40 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD48C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 15:04:40 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id q7-20020a6bf207000000b006129589cb60so573939ioh.4
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 15:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rGYn7uEtwBYy7ZvOW1eRBHwrKTmwXrKO2ob2gCgyBgE=;
        b=mZgilgpdDlk2FaGVa80Afk+ekRfaD9Wg1bY/w2GjxKuLBD3QUaafhZ6IoNF7gSKfR6
         UejgBOUz3Zu9tGaYbd8RapBY9DAjOdmvjQcglXVuUWKsI/uxmRI80aS7DAnnSJlk+WO3
         TcUg3vmyOQBTUnGW8bTo8pu6k6yY9sUqbVEQx2a9Qrc5JoPvEhJLOlneXUaGPurlRJJP
         9y8Iw/bQBCU10kllktwwk1XDMmwG8uXWvbLzhVu0dQZjzJcoFSLQUhInG6SUJsaFEehH
         hGl1etcx8x9t/DuIXDIaAhG4e6u9BFpPNzuOmTim0zOFCqqoIgYDKowidwBHbmiip3rq
         vRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rGYn7uEtwBYy7ZvOW1eRBHwrKTmwXrKO2ob2gCgyBgE=;
        b=62fjYTW+rBRTp+XIRJ6NaEEgPYYuf4nCxnaJK/b/JnlRUofnDbDMVMlyu3l1rAoW8D
         lFLiVgXKw6FHmi5FjRM2Bn+Fa/gzyKMaEoKHCFFrJ4Kf9rKoQDyPM10s57Y8No1+zG4d
         yWw36RK7aLx2Xi1bYESNgMl3SBxg4aoeW01dMgQq6/jrUbSllxKE7SzIT+TSzMwEViKl
         ocLmihgqIYlfOqbz1sN/PJoBt3uAPy7aN2y57AKwI/I4gmxoOi3dYiP0TzvZuiEIMgv5
         YZV8oiDjW7XTq0V9GCiPPnJWgHds+VLJ2rIWFS92tqwOtZ32KhneLv5zMKOsNwkXqSbO
         KEfg==
X-Gm-Message-State: AOAM531M5CqJK949t3bcyhzPLCs9eet1AlcBZMAUFYfy45LUYx6SBvnw
        YTzvCSnKkQKErJtar3BMbP5Wcaox1txgLpx3jWEMlUl35qUusUxE1Ok9jaxNUi7bjCagq+hCnVE
        +J7u/EgBRE6Fs/gOcBC7/WJDBTM7cI4SSV6p+UcJa2G8y4TNxFUqUKNKAFw==
X-Google-Smtp-Source: ABdhPJxVEKzGn8bl3bOD9Nbe77e75RaG2Xct5XdPNw1TwoyLUWg8QCdxBPwRcB890uk1SiI8P21qfVK2Hqw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:89c9:: with SMTP id a9mr17193642iot.210.1643843079937;
 Wed, 02 Feb 2022 15:04:39 -0800 (PST)
Date:   Wed,  2 Feb 2022 23:04:31 +0000
In-Reply-To: <20220202230433.2468479-1-oupton@google.com>
Message-Id: <20220202230433.2468479-3-oupton@google.com>
Mime-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 2/4] KVM: nVMX: Don't change VM-{Entry,Exit} ctrl MSRs on MPX
 CPUID update
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM does not respect userspace's configuration of the "{load,clear}
IA32_BNDCFGS" bit in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs, depending
on the order in which it sets the MSR and configures the guest's CPUID.
When the guest's CPUID is set, KVM will expose the "load IA32_BNDCFGS"
bits if MPX is exposed in the guest CPUID. In order to clear the bit,
userspace would need to write the VMX capability MSRs after updating
CPUID.

There are no ordering requirements on these ioctls. Fix the issue by
simply not updating the "{load,clear} IA32_BNDCFGS" bits on CPUID
update. Note that these bits are already exposed by default in the
respective VMX capability MSRs, if supported by hardware.

Fixes: 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aca3ae2a02f3..8cf58ba60b01 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7227,23 +7227,6 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 #undef cr4_fixed1_update
 }
 
-static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (kvm_mpx_supported()) {
-		bool mpx_enabled = guest_cpuid_has(vcpu, X86_FEATURE_MPX);
-
-		if (mpx_enabled) {
-			vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_BNDCFGS;
-			vmx->nested.msrs.exit_ctls_high |= VM_EXIT_CLEAR_BNDCFGS;
-		} else {
-			vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_BNDCFGS;
-			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
-		}
-	}
-}
-
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7335,10 +7318,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
 
-	if (nested_vmx_allowed(vcpu)) {
+	if (nested_vmx_allowed(vcpu))
 		nested_vmx_cr_fixed1_bits_update(vcpu);
-		nested_vmx_entry_exit_ctls_update(vcpu);
-	}
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
-- 
2.35.0.rc2.247.g8bbb082509-goog

