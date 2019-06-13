Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7913544843
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393343AbfFMRGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:06:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34866 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393300AbfFMRD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so10920533wml.0;
        Thu, 13 Jun 2019 10:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1xszuqo4jzQZnosE9CJxZHoV5wm53oaDFI2DV1TesBo=;
        b=rOHyuLkOK6v3UzpN3AA29V7Kfl/OJSWuNYA4ARIOa7bDsgIZqCvZMHMqof75DDEPl+
         PdffCnOtMcHt3URvKW5pgaGwD4D6cZG0YZFeGnHipps6kyc9qSt5h6qavRtMeYn+yK3I
         EgAe3FZyDCF1S5g2HzIU1JHbc2iuEjQiNNlkl2FKUnR5aQcFJKplNyPoxX5y2DDMyMr/
         IC/2yfbc6Y5w7PNqSt7HtFXamiCP/Pq+PIF89lKxCA+GXudhn75eMnxg+/amTsLiFShZ
         7kj4xxTMj3IDCraXFN0kF61G+9R+Ac2uIkgKeUTzjlvBzseq/+MKUfMTdo4TH2wo+HiM
         Fx7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=1xszuqo4jzQZnosE9CJxZHoV5wm53oaDFI2DV1TesBo=;
        b=LDoQay4C+NVD/kbfaZhEI+5Cl/gezqeAHFx03+VxQRXg3pCJy5fIsoh2h3HhJAqb1V
         YRCMnhHa8eNFyBIJyV5PVQ+gN1zkEgIGIHym/zB+HuQChjY4/mWmcuv/lt4q+ex41jfI
         A/mPV8ndWL+O1gSvqkhsCeZ9y1tPTB/wocLS06wL1kLR+D/EuCLmS3HK7EzjORm1TzPX
         YBatRNwQ+IZaUJAjgpyrnh8Vv+y+l/OxFfRbxVRMdnalXTdtteeHXq0qBwXZj/WmrwNN
         fjbyho3Z92R+z75p8RNEKpcXNKR5M4+nMZAIph+K4XO2niqPULp85/o1TJXv8hPE7u9P
         f6zQ==
X-Gm-Message-State: APjAAAVvzNeSYst0TN6G7LgZq2ca/1DSOIcuidcgi1fsktI1rGfc8PJN
        MEJklzhgZnJAB1GRCuBOIKspoaLq
X-Google-Smtp-Source: APXvYqwl36GFEvwlwotdqp0CKotuFjzLk3OdGhjgV6j1CjwJ9zMJ3XB09480XrrTPKzrc3/f4DjW8A==
X-Received: by 2002:a1c:6242:: with SMTP id w63mr4867248wmb.161.1560445436772;
        Thu, 13 Jun 2019 10:03:56 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:56 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 23/43] KVM: nVMX: Don't speculatively write virtual-APIC page address
Date:   Thu, 13 Jun 2019 19:03:09 +0200
Message-Id: <1560445409-17363-24-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The VIRTUAL_APIC_PAGE_ADDR in vmcs02 is guaranteed to be updated before
it is consumed by hardware, either in nested_vmx_enter_non_root_mode()
or via the KVM_REQ_GET_VMCS12_PAGES callback.  Avoid an extra VMWRITE
and only stuff a bad value into vmcs02 when mapping vmcs12's address
fails.  This also eliminates the need for extra comments to connect the
dots between prepare_vmcs02_early() and nested_get_vmcs12_pages().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0f4cb473bd36..d055bbc5cbde 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2039,20 +2039,13 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	exec_control &= ~CPU_BASED_TPR_SHADOW;
 	exec_control |= vmcs12->cpu_based_vm_exec_control;
 
-	/*
-	 * Write an illegal value to VIRTUAL_APIC_PAGE_ADDR. Later, if
-	 * nested_get_vmcs12_pages can't fix it up, the illegal value
-	 * will result in a VM entry failure.
-	 */
-	if (exec_control & CPU_BASED_TPR_SHADOW) {
-		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, -1ull);
+	if (exec_control & CPU_BASED_TPR_SHADOW)
 		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
-	} else {
 #ifdef CONFIG_X86_64
+	else
 		exec_control |= CPU_BASED_CR8_LOAD_EXITING |
 				CPU_BASED_CR8_STORE_EXITING;
 #endif
-	}
 
 	/*
 	 * A vmexit (to either L1 hypervisor or L0 userspace) is always needed
@@ -2861,10 +2854,6 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
 		map = &vmx->nested.virtual_apic_map;
 
-		/*
-		 * If translation failed, VM entry will fail because
-		 * prepare_vmcs02 set VIRTUAL_APIC_PAGE_ADDR to -1ull.
-		 */
 		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->virtual_apic_page_addr), map)) {
 			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, pfn_to_hpa(map->pfn));
 		} else if (nested_cpu_has(vmcs12, CPU_BASED_CR8_LOAD_EXITING) &&
@@ -2880,6 +2869,12 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			 */
 			vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
 					CPU_BASED_TPR_SHADOW);
+		} else {
+			/*
+			 * Write an illegal value to VIRTUAL_APIC_PAGE_ADDR to
+			 * force VM-Entry to fail.
+			 */
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, -1ull);
 		}
 	}
 
-- 
1.8.3.1


