Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDB024F7AF
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgHXJTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:19:44 -0400
Received: from 8bytes.org ([81.169.241.247]:36882 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbgHXIzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:51 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id A722585;
        Mon, 24 Aug 2020 10:55:46 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v6 01/76] KVM: SVM: nested: Don't allocate VMCB structures on stack
Date:   Mon, 24 Aug 2020 10:53:56 +0200
Message-Id: <20200824085511.7553-2-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Do not allocate a vmcb_control_area and a vmcb_save_area on the stack,
as these structures will become larger with future extenstions of
SVM and thus the svm_set_nested_state() function will become a too large
stack frame.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/nested.c | 47 +++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb68467e6049..28036629abf8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1060,10 +1060,14 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb __user *user_vmcb = (struct vmcb __user *)
 		&user_kvm_nested_state->data.svm[0];
-	struct vmcb_control_area ctl;
-	struct vmcb_save_area save;
+	struct vmcb_control_area *ctl;
+	struct vmcb_save_area *save;
+	int ret;
 	u32 cr0;
 
+	BUILD_BUG_ON(sizeof(struct vmcb_control_area) + sizeof(struct vmcb_save_area) >
+		     KVM_STATE_NESTED_SVM_VMCB_SIZE);
+
 	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_SVM)
 		return -EINVAL;
 
@@ -1095,13 +1099,22 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	if (kvm_state->size < sizeof(*kvm_state) + KVM_STATE_NESTED_SVM_VMCB_SIZE)
 		return -EINVAL;
-	if (copy_from_user(&ctl, &user_vmcb->control, sizeof(ctl)))
-		return -EFAULT;
-	if (copy_from_user(&save, &user_vmcb->save, sizeof(save)))
-		return -EFAULT;
 
-	if (!nested_vmcb_check_controls(&ctl))
-		return -EINVAL;
+	ret  = -ENOMEM;
+	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
+	save = kzalloc(sizeof(*save), GFP_KERNEL);
+	if (!ctl || !save)
+		goto out_free;
+
+	ret = -EFAULT;
+	if (copy_from_user(ctl, &user_vmcb->control, sizeof(*ctl)))
+		goto out_free;
+	if (copy_from_user(save, &user_vmcb->save, sizeof(*save)))
+		goto out_free;
+
+	ret = -EINVAL;
+	if (!nested_vmcb_check_controls(ctl))
+		goto out_free;
 
 	/*
 	 * Processor state contains L2 state.  Check that it is
@@ -1109,15 +1122,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	cr0 = kvm_read_cr0(vcpu);
         if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
-                return -EINVAL;
+		goto out_free;
 
 	/*
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
 	 * TODO: validate reserved bits for all saved state.
 	 */
-	if (!(save.cr0 & X86_CR0_PG))
-		return -EINVAL;
+	if (!(save->cr0 & X86_CR0_PG))
+		goto out_free;
 
 	/*
 	 * All checks done, we can enter guest mode.  L1 control fields
@@ -1126,15 +1139,21 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * contains saved L1 state.
 	 */
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
-	hsave->save = save;
+	hsave->save = *save;
 
 	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
-	load_nested_vmcb_control(svm, &ctl);
+	load_nested_vmcb_control(svm, ctl);
 	nested_prepare_vmcb_control(svm);
 
 out_set_gif:
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
-	return 0;
+
+	ret = 0;
+out_free:
+	kfree(save);
+	kfree(ctl);
+
+	return ret;
 }
 
 struct kvm_x86_nested_ops svm_nested_ops = {
-- 
2.28.0

