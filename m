Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE7744814
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404598AbfFMREG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:06 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41116 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404533AbfFMREF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so21577714wrm.8;
        Thu, 13 Jun 2019 10:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hD5mni7J0vxl5xZ/LUmZqJKthpmnqcOFIkPb351hUIk=;
        b=NHDa5B56vPplCy+DoYRe9/QcCWkcCBS4gnKUmPT8sChQ7929ZP+uB7VqLJBRb67kCs
         MbfS7pxzmRyteaC/+v0wN2cmKkqOCc9RL9CeNojllAm08vx2B0D/+G54VSduUG0dI/9i
         egg+YsCqPLUOPn3VXMcSnNv1BZFYW8ZhI7ZL4NSwAtF81gmZ5OgoO4krrZNby69Wy0qc
         sXTQBGp4c9Tm8xABRcu51zJ0STI0M93+sITjNucWedBSc84uSAW9h3PSvT8u+4zqqhCe
         tpoa7y+EWIljgRRMVFv+OCqB57tmTUYK10xSY/CZk84xoHNg6unh+0n0179LGBvbSPLZ
         6L4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=hD5mni7J0vxl5xZ/LUmZqJKthpmnqcOFIkPb351hUIk=;
        b=PPMw6lyPvVLJPzouk2jbpJIVnjiORXIBFyHlOP36YO5Z8akuRsEQXdWwZ3xeEnLTts
         Z3vPsjcpy80s6wogsbXTrkPsarbcwfmJIWMCD4nfT9cnf6bAJIrSDvCjBZ6Khra9ShCn
         6jQuOefAuzccUI8L6wPoBGdAEZQFP60E84dqtwCXimaqiKvvHmVALbFiZFM+PRcMur31
         QKDZvzZVM5OlkZiUoV3bjFQO+WRLzMpyc3tGFwC9Xk5YXQBB1gYp/EVt13U8iYlhgrhX
         YnuJlj02XGNb84SrGlCowoRBo2+08uF5UFi6TMb/9v3mp8JBM3kSVp+KDG251CkCUliU
         c1Gw==
X-Gm-Message-State: APjAAAWADPnGa+yLN3vWHQQd45tubnIL8wxmRTYrR84tQ8PKjSiujPkm
        nVHI0Y9WHQWQG/EZktzTn3XEahXi
X-Google-Smtp-Source: APXvYqyFayvUdDneA1mcw0RsrHJ8auPEqK/pppjAEByxjWHF4J17ewaQo09vNlZUVl3aCjGePOEtVQ==
X-Received: by 2002:a5d:430c:: with SMTP id h12mr4989630wrq.163.1560445442949;
        Thu, 13 Jun 2019 10:04:02 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:02 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 30/43] KVM: nVMX: Copy PDPTRs to/from vmcs12 only when necessary
Date:   Thu, 13 Jun 2019 19:03:16 +0200
Message-Id: <1560445409-17363-31-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Per Intel's SDM:

  ... the logical processor uses PAE paging if CR0.PG=1, CR4.PAE=1 and
  IA32_EFER.LME=0.  A VM entry to a guest that uses PAE paging loads the
  PDPTEs into internal, non-architectural registers based on the setting
  of the "enable EPT" VM-execution control.

and:

  [GUEST_PDPTR] values are saved into the four PDPTE fields as follows:

    - If the "enable EPT" VM-execution control is 0 or the logical
      processor was not using PAE paging at the time of the VM exit,
      the values saved are undefined.

In other words, if EPT is disabled or the guest isn't using PAE paging,
then the PDPTRS aren't consumed by hardware on VM-Entry and are loaded
with junk on VM-Exit.  From a nesting perspective, all of the above hold
true, i.e. KVM can effectively ignore the VMCS PDPTRs.  E.g. KVM already
loads the PDPTRs from memory when nested EPT is disabled (see
nested_vmx_load_cr3()).

Because KVM intercepts setting CR4.PAE, there is no danger of consuming
a stale value or crushing L1's VMWRITEs regardless of whether L1
intercepts CR4.PAE. The vmcs12's values are unchanged up until the
VM-Exit where L2 sets CR4.PAE, i.e. L0 will see the new PAE state on the
subsequent VM-Entry and propagate the PDPTRs from vmcs12 to vmcs02.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0948071905a4..1b42bd0bf354 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2252,10 +2252,16 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			  u32 *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
+	bool load_guest_pdptrs_vmcs12 = false;
 
-	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
+	if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
 		prepare_vmcs02_rare(vmx, vmcs12);
 		vmx->nested.dirty_vmcs12 = false;
+
+		load_guest_pdptrs_vmcs12 = !hv_evmcs ||
+			!(hv_evmcs->hv_clean_fields &
+			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
 	if (vmx->nested.nested_run_pending &&
@@ -2358,6 +2364,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 				entry_failure_code))
 		return -EINVAL;
 
+	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
+	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
+	    is_pae_paging(vcpu)) {
+		vmcs_write64(GUEST_PDPTR0, vmcs12->guest_pdptr0);
+		vmcs_write64(GUEST_PDPTR1, vmcs12->guest_pdptr1);
+		vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
+		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
+	}
+
 	if (!enable_ept)
 		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
 
@@ -3547,10 +3562,12 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	 */
 	if (enable_ept) {
 		vmcs12->guest_cr3 = vmcs_readl(GUEST_CR3);
-		vmcs12->guest_pdptr0 = vmcs_read64(GUEST_PDPTR0);
-		vmcs12->guest_pdptr1 = vmcs_read64(GUEST_PDPTR1);
-		vmcs12->guest_pdptr2 = vmcs_read64(GUEST_PDPTR2);
-		vmcs12->guest_pdptr3 = vmcs_read64(GUEST_PDPTR3);
+		if (nested_cpu_has_ept(vmcs12) && is_pae_paging(vcpu)) {
+			vmcs12->guest_pdptr0 = vmcs_read64(GUEST_PDPTR0);
+			vmcs12->guest_pdptr1 = vmcs_read64(GUEST_PDPTR1);
+			vmcs12->guest_pdptr2 = vmcs_read64(GUEST_PDPTR2);
+			vmcs12->guest_pdptr3 = vmcs_read64(GUEST_PDPTR3);
+		}
 	}
 
 	vmcs12->guest_linear_address = vmcs_readl(GUEST_LINEAR_ADDRESS);
-- 
1.8.3.1


