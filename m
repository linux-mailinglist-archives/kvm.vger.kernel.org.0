Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77D13CCFE5
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 11:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbhGSIWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 04:22:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235073AbhGSIWt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 04:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626685409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hEOQcTnDPmOyh7Lvu4AtIr/eiP9Wa6mbvXp76RMLz4=;
        b=epuGP5UDuiPhLEtizEn7KgZ5JPaSHATxFBm0hdTLgSj8H2Fd9lMbGYNhmS1SiAfzBRMA/e
        nJnRBgp35oAuee9f8EAI7bppyLiRNsJYBqZ67uNC+EnN0eMfbReI4Plo47MGoSERWyF2tH
        +9cm9K9ndKHtijhoJihMaksD+HFAkg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-Aa3bRiUdN4GqQ-MSt-3Ruw-1; Mon, 19 Jul 2021 05:03:27 -0400
X-MC-Unique: Aa3bRiUdN4GqQ-MSt-3Ruw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90E06804300;
        Mon, 19 Jul 2021 09:03:26 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8C285DA2D;
        Mon, 19 Jul 2021 09:03:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/1] KVM: nSVM: Swap the parameter order for svm_copy_vmrun_state()/svm_copy_vmloadsave_state()
Date:   Mon, 19 Jul 2021 11:03:22 +0200
Message-Id: <20210719090322.625277-1-vkuznets@redhat.com>
In-Reply-To: <20210716144104.465269-1-vkuznets@redhat.com>
References: <20210716144104.465269-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make svm_copy_vmrun_state()/svm_copy_vmloadsave_state() interface match
'memcpy(dest, src)' to avoid any confusion.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  8 ++++----
 arch/x86/kvm/svm/svm.c    | 12 ++++++------
 arch/x86/kvm/svm/svm.h    |  6 +++---
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8493592b63b4..1c2a0414a88d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -702,8 +702,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 }
 
 /* Copy state save area fields which are handled by VMRUN */
-void svm_copy_vmrun_state(struct vmcb_save_area *from_save,
-			  struct vmcb_save_area *to_save)
+void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
+			  struct vmcb_save_area *from_save)
 {
 	to_save->es = from_save->es;
 	to_save->cs = from_save->cs;
@@ -722,7 +722,7 @@ void svm_copy_vmrun_state(struct vmcb_save_area *from_save,
 	to_save->cpl = 0;
 }
 
-void svm_copy_vmloadsave_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 {
 	to_vmcb->save.fs = from_vmcb->save.fs;
 	to_vmcb->save.gs = from_vmcb->save.gs;
@@ -1385,7 +1385,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 
-	svm_copy_vmrun_state(save, &svm->vmcb01.ptr->save);
+	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
 	nested_load_control_from_vmcb12(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cfe165d74093..9a6987549e1b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2147,11 +2147,11 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 	ret = kvm_skip_emulated_instruction(vcpu);
 
 	if (vmload) {
-		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
+		svm_copy_vmloadsave_state(svm->vmcb, vmcb12);
 		svm->sysenter_eip_hi = 0;
 		svm->sysenter_esp_hi = 0;
 	} else {
-		svm_copy_vmloadsave_state(svm->vmcb, vmcb12);
+		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
 	}
 
 	kvm_vcpu_unmap(vcpu, &map, true);
@@ -4345,8 +4345,8 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 
 		BUILD_BUG_ON(offsetof(struct vmcb, save) != 0x400);
 
-		svm_copy_vmrun_state(&svm->vmcb01.ptr->save,
-				     map_save.hva + 0x400);
+		svm_copy_vmrun_state(map_save.hva + 0x400,
+				     &svm->vmcb01.ptr->save);
 
 		kvm_vcpu_unmap(vcpu, &map_save, true);
 	}
@@ -4394,8 +4394,8 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 					 &map_save) == -EINVAL)
 				return 1;
 
-			svm_copy_vmrun_state(map_save.hva + 0x400,
-					     &svm->vmcb01.ptr->save);
+			svm_copy_vmrun_state(&svm->vmcb01.ptr->save,
+					     map_save.hva + 0x400);
 
 			kvm_vcpu_unmap(vcpu, &map_save, true);
 		}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1b65ee3a9569..bd0fe94c2920 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -464,9 +464,9 @@ void svm_leave_nested(struct vcpu_svm *svm);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct kvm_vcpu *vcpu);
-void svm_copy_vmrun_state(struct vmcb_save_area *from_save,
-			  struct vmcb_save_area *to_save);
-void svm_copy_vmloadsave_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
+void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
+			  struct vmcb_save_area *from_save);
+void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
 
 static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
-- 
2.31.1

