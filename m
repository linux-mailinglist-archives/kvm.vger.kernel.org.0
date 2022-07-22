Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC42E57E028
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 12:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbiGVKnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 06:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGVKnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 06:43:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A218BB23E
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 03:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658486612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HKNyVutADCTmas4cu3E/IQbKfET/TUWRp+T+RALUVVk=;
        b=X78U7ewhAvn2ktabZyazYsWrg+FLRKYuEOFBMRZG7/xGI/EH2uKYz0NmGN5wgmP+4eJ+Hk
        nGC6In/urRTDTvyRzcG7prtCGs4re3Gy35Vrfxvq/QZsi6f/+p99yT5nnrjMkuXGYaZHD6
        nYHUGlVfEqG1CXX4f3aQDcOdItjKiA4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-wghmIIzxPSyaDsXZP3JxgQ-1; Fri, 22 Jul 2022 06:43:30 -0400
X-MC-Unique: wghmIIzxPSyaDsXZP3JxgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A2343810D2C;
        Fri, 22 Jul 2022 10:43:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18B6F90A04;
        Fri, 22 Jul 2022 10:43:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, oliver.upton@linux.dev
Subject: [PATCH] Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"
Date:   Fri, 22 Jul 2022 06:43:29 -0400
Message-Id: <20220722104329.3265411-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
when guest MPX disabled"), KVM has taken ownership of the "load
IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls,
trying to set these bits in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
MSRs if the guest's CPUID supports MPX, and clear otherwise.

The intent of the patch was to apply it to L0 in order to work around
L1 kernels that lack the fix in commit 691bd4340bef ("kvm: vmx: allow
host to access guest MSR_IA32_BNDCFGS", 2017-07-04): by hiding the
control bits from L0, L1 hides BNDCFGS from KVM_GET_MSR_INDEX_LIST,
and the L1 bug is neutralized even in the lack of commit 691bd4340bef.

This was perhaps a sensible kludge at the time, but a horrible
idea in the long term and in fact it has not been extended to
other CPUID bits like these:

  X86_FEATURE_LM => VM_EXIT_HOST_ADDR_SPACE_SIZE, VM_ENTRY_IA32E_MODE,
                    VMX_MISC_SAVE_EFER_LMA

  X86_FEATURE_TSC => CPU_BASED_RDTSC_EXITING, CPU_BASED_USE_TSC_OFFSETTING,
                     SECONDARY_EXEC_TSC_SCALING

  X86_FEATURE_INVPCID_SINGLE => SECONDARY_EXEC_ENABLE_INVPCID

  X86_FEATURE_MWAIT => CPU_BASED_MONITOR_EXITING, CPU_BASED_MWAIT_EXITING

  X86_FEATURE_INTEL_PT => SECONDARY_EXEC_PT_CONCEAL_VMX, SECONDARY_EXEC_PT_USE_GPA,
                          VM_EXIT_CLEAR_IA32_RTIT_CTL, VM_ENTRY_LOAD_IA32_RTIT_CTL

  X86_FEATURE_XSAVES => SECONDARY_EXEC_XSAVES

These days it's sort of common knowledge that any MSR in
KVM_GET_MSR_INDEX_LIST must allow *at least* setting it with KVM_SET_MSR
to a default value, so it is unlikely that something like commit
5f76f6f5ff96 will be needed again.  So revert it, at the potential cost
of breaking L1s with a 6 year old kernel.  While in principle the L0 owner
doesn't control what runs on L1, such an old hypervisor would probably
have many other bugs.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75ee509f0b7b..4fd25e1d6ec9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7457,23 +7457,6 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
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
@@ -7565,10 +7548,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
2.31.1

