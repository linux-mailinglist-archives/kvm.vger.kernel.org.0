Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC00A32B5B6
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382872AbhCCHTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1836009AbhCBTfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9StB3i8b9IliRyEXIIJoxOXTPoz7/CmQ0mrH5grEa9U=;
        b=XFAt1pNVvQYZcQznOyK8vG5vWqW7sG9zzzZWUwoL+1a6lRPOIfYG4Bv1ZE4ydeStyv08f3
        nC4ddSXXt7D/lENHHxCoyTLSYwXCMP5/LG1PzEN6eNgLFh2cBYOnPIGj2GOLKSVuCZoZR3
        AVymp54DZh+nySq7o94AbaV4SSp8a/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-6tS2MkGiNXu7x0m-QJ-kew-1; Tue, 02 Mar 2021 14:33:58 -0500
X-MC-Unique: 6tS2MkGiNXu7x0m-QJ-kew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F326918B6145;
        Tue,  2 Mar 2021 19:33:56 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67C2B18996;
        Tue,  2 Mar 2021 19:33:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 21/23] KVM: nSVM: always use vmcb01 to for vmsave/vmload of guest state
Date:   Tue,  2 Mar 2021 14:33:41 -0500
Message-Id: <20210302193343.313318-22-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

This allows to avoid copying of these fields between vmcb01
and vmcb02 on nested guest entry/exit.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  3 --
 arch/x86/kvm/svm/svm.c    | 70 ++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7ed49d8cef5e..cda0ed49d4cb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -536,7 +536,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
 
-	nested_svm_vmloadsave(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
@@ -721,8 +720,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.pause_filter_thresh =
 		svm->vmcb->control.pause_filter_thresh;
 
-	nested_svm_vmloadsave(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
-
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a0df44f6c239..b68f795db792 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1587,16 +1587,17 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 {
 	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
+	struct vmcb_save_area *save01 = &to_svm(vcpu)->vmcb01.ptr->save;
 
 	switch (seg) {
 	case VCPU_SREG_CS: return &save->cs;
 	case VCPU_SREG_DS: return &save->ds;
 	case VCPU_SREG_ES: return &save->es;
-	case VCPU_SREG_FS: return &save->fs;
-	case VCPU_SREG_GS: return &save->gs;
+	case VCPU_SREG_FS: return &save01->fs;
+	case VCPU_SREG_GS: return &save01->gs;
 	case VCPU_SREG_SS: return &save->ss;
-	case VCPU_SREG_TR: return &save->tr;
-	case VCPU_SREG_LDTR: return &save->ldtr;
+	case VCPU_SREG_TR: return &save01->tr;
+	case VCPU_SREG_LDTR: return &save01->ldtr;
 	}
 	BUG();
 	return NULL;
@@ -2650,24 +2651,24 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_info->index) {
 	case MSR_STAR:
-		msr_info->data = svm->vmcb->save.star;
+		msr_info->data = svm->vmcb01.ptr->save.star;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_LSTAR:
-		msr_info->data = svm->vmcb->save.lstar;
+		msr_info->data = svm->vmcb01.ptr->save.lstar;
 		break;
 	case MSR_CSTAR:
-		msr_info->data = svm->vmcb->save.cstar;
+		msr_info->data = svm->vmcb01.ptr->save.cstar;
 		break;
 	case MSR_KERNEL_GS_BASE:
-		msr_info->data = svm->vmcb->save.kernel_gs_base;
+		msr_info->data = svm->vmcb01.ptr->save.kernel_gs_base;
 		break;
 	case MSR_SYSCALL_MASK:
-		msr_info->data = svm->vmcb->save.sfmask;
+		msr_info->data = svm->vmcb01.ptr->save.sfmask;
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		msr_info->data = svm->vmcb->save.sysenter_cs;
+		msr_info->data = svm->vmcb01.ptr->save.sysenter_cs;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
 		msr_info->data = svm->sysenter_eip;
@@ -2852,32 +2853,32 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->virt_spec_ctrl = data;
 		break;
 	case MSR_STAR:
-		svm->vmcb->save.star = data;
+		svm->vmcb01.ptr->save.star = data;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_LSTAR:
-		svm->vmcb->save.lstar = data;
+		svm->vmcb01.ptr->save.lstar = data;
 		break;
 	case MSR_CSTAR:
-		svm->vmcb->save.cstar = data;
+		svm->vmcb01.ptr->save.cstar = data;
 		break;
 	case MSR_KERNEL_GS_BASE:
-		svm->vmcb->save.kernel_gs_base = data;
+		svm->vmcb01.ptr->save.kernel_gs_base = data;
 		break;
 	case MSR_SYSCALL_MASK:
-		svm->vmcb->save.sfmask = data;
+		svm->vmcb01.ptr->save.sfmask = data;
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		svm->vmcb->save.sysenter_cs = data;
+		svm->vmcb01.ptr->save.sysenter_cs = data;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
 		svm->sysenter_eip = data;
-		svm->vmcb->save.sysenter_eip = data;
+		svm->vmcb01.ptr->save.sysenter_eip = data;
 		break;
 	case MSR_IA32_SYSENTER_ESP:
 		svm->sysenter_esp = data;
-		svm->vmcb->save.sysenter_esp = data;
+		svm->vmcb01.ptr->save.sysenter_esp = data;
 		break;
 	case MSR_TSC_AUX:
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
@@ -3091,6 +3092,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct vmcb_save_area *save = &svm->vmcb->save;
+	struct vmcb_save_area *save01 = &svm->vmcb01.ptr->save;
 
 	if (!dump_invalid_vmcb) {
 		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
@@ -3153,28 +3155,28 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       save->ds.limit, save->ds.base);
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "fs:",
-	       save->fs.selector, save->fs.attrib,
-	       save->fs.limit, save->fs.base);
+	       save01->fs.selector, save01->fs.attrib,
+	       save01->fs.limit, save01->fs.base);
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "gs:",
-	       save->gs.selector, save->gs.attrib,
-	       save->gs.limit, save->gs.base);
+	       save01->gs.selector, save01->gs.attrib,
+	       save01->gs.limit, save01->gs.base);
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "gdtr:",
 	       save->gdtr.selector, save->gdtr.attrib,
 	       save->gdtr.limit, save->gdtr.base);
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "ldtr:",
-	       save->ldtr.selector, save->ldtr.attrib,
-	       save->ldtr.limit, save->ldtr.base);
+	       save01->ldtr.selector, save01->ldtr.attrib,
+	       save01->ldtr.limit, save01->ldtr.base);
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "idtr:",
 	       save->idtr.selector, save->idtr.attrib,
 	       save->idtr.limit, save->idtr.base);
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "tr:",
-	       save->tr.selector, save->tr.attrib,
-	       save->tr.limit, save->tr.base);
+	       save01->tr.selector, save01->tr.attrib,
+	       save01->tr.limit, save01->tr.base);
 	pr_err("cpl:            %d                efer:         %016llx\n",
 		save->cpl, save->efer);
 	pr_err("%-15s %016llx %-13s %016llx\n",
@@ -3188,15 +3190,15 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-	       "star:", save->star, "lstar:", save->lstar);
+	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-	       "cstar:", save->cstar, "sfmask:", save->sfmask);
+	       "cstar:", save01->cstar, "sfmask:", save01->sfmask);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-	       "kernel_gs_base:", save->kernel_gs_base,
-	       "sysenter_cs:", save->sysenter_cs);
+	       "kernel_gs_base:", save01->kernel_gs_base,
+	       "sysenter_cs:", save01->sysenter_cs);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-	       "sysenter_esp:", save->sysenter_esp,
-	       "sysenter_eip:", save->sysenter_eip);
+	       "sysenter_esp:", save01->sysenter_esp,
+	       "sysenter_eip:", save01->sysenter_eip);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "gpat:", save->g_pat, "dbgctl:", save->dbgctl);
 	pr_err("%-15s %016llx %-13s %016llx\n",
@@ -3719,9 +3721,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		vmload(svm->vmcb_pa);
+		vmload(svm->vmcb01.pa);
 		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&vcpu->arch.regs);
-		vmsave(svm->vmcb_pa);
+		vmsave(svm->vmcb01.pa);
 
 		vmload(__sme_page_pa(sd->save_area));
 	}
-- 
2.26.2


