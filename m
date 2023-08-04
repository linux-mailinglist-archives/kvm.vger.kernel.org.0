Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372F6770736
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjHDRev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjHDReu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28894C06
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691170438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HCex7OscvVPSb+aVsDqyfjlMqtwIJUHlLvy33ZAyJg=;
        b=GfMKOz6z9Es2567GtFRwsvq5HQhTuaD1PitBCOatTODf2g8FLc5NTwpcXuvVoiBMH3vHr3
        9nnfltV86OFwfoU0RY9ISORx7myUMx68lRrX/lYgmLaBpUlTd9KqR2JX4qKPLlod4i5f4B
        CrK8hbf/H4DkSMcKgxLGuhqAhyhJXgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-3gt5amElNl-qUyHzN-fuzA-1; Fri, 04 Aug 2023 13:33:57 -0400
X-MC-Unique: 3gt5amElNl-qUyHzN-fuzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 083F780027F;
        Fri,  4 Aug 2023 17:33:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7025C5796B;
        Fri,  4 Aug 2023 17:33:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org
Subject: [PATCH 2/3] KVM: SEV: only access GHCB fields once
Date:   Fri,  4 Aug 2023 13:33:54 -0400
Message-Id: <20230804173355.51753-3-pbonzini@redhat.com>
In-Reply-To: <20230804173355.51753-1-pbonzini@redhat.com>
References: <20230804173355.51753-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A KVM guest using SEV-ES or SEV-SNP with multiple vCPUs can trigger
a double fetch race condition vulnerability and invoke the VMGEXIT
handler recursively.

sev_handle_vmgexit() maps the GHCB page using kvm_vcpu_map() and then
fetches the exit code using ghcb_get_sw_exit_code().  Soon after,
sev_es_validate_vmgexit() fetches the exit code again. Since the GHCB
page is shared with the guest, the guest is able to quickly swap the
values with another vCPU and hence bypass the validation. One vmexit code
that can be rejected by sev_es_validate_vmgexit() is SVM_EXIT_VMGEXIT;
if sev_handle_vmgexit() observes it in the second fetch, the call
to svm_invoke_exit_handler() will invoke sev_handle_vmgexit() again
recursively.

To avoid the race, always fetch the GHCB data from the places where
sev_es_sync_from_ghcb stores it.

Exploiting recursions on linux kernel has been proven feasible
in the past, but the impact is mitigated by stack guard pages
(CONFIG_VMAP_STACK).  Still, if an attacker manages to call the handler
multiple times, they can theoretically trigger a stack overflow and
cause a denial-of-service, or potentially guest-to-host escape in kernel
configurations without stack guard pages.

Note that winning the race reliably in every iteration is very tricky
due to the very tight window of the fetches; depending on the compiler
settings, they are often consecutive because of optimization and inlining.

Tested by booting an SEV-ES RHEL9 guest.

Fixes: CVE-2023-4155
Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Cc: stable@vger.kernel.org
Reported-by: Andy Nguyen <theflow@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e898f0b2b0ba..ca4ba5fe9a01 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2445,9 +2445,15 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
+static u64 kvm_ghcb_get_sw_exit_code(struct vmcb_control_area *control)
+{
+	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
+}
+
 static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
-	struct kvm_vcpu *vcpu;
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct ghcb *ghcb;
 	u64 exit_code;
 	u64 reason;
@@ -2458,7 +2464,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	 * Retrieve the exit code now even though it may not be marked valid
 	 * as it could help with debugging.
 	 */
-	exit_code = ghcb_get_sw_exit_code(ghcb);
+	exit_code = kvm_ghcb_get_sw_exit_code(control);
 
 	/* Only GHCB Usage code 0 is supported */
 	if (ghcb->ghcb_usage) {
@@ -2473,7 +2479,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	    !kvm_ghcb_sw_exit_info_2_is_valid(svm))
 		goto vmgexit_err;
 
-	switch (ghcb_get_sw_exit_code(ghcb)) {
+	switch (exit_code) {
 	case SVM_EXIT_READ_DR7:
 		break;
 	case SVM_EXIT_WRITE_DR7:
@@ -2490,18 +2496,18 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!kvm_ghcb_rax_is_valid(svm) ||
 		    !kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
-		if (ghcb_get_rax(ghcb) == 0xd)
+		if (vcpu->arch.regs[VCPU_REGS_RAX] == 0xd)
 			if (!kvm_ghcb_xcr0_is_valid(svm))
 				goto vmgexit_err;
 		break;
 	case SVM_EXIT_INVD:
 		break;
 	case SVM_EXIT_IOIO:
-		if (ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_STR_MASK) {
+		if (control->exit_info_1 & SVM_IOIO_STR_MASK) {
 			if (!kvm_ghcb_sw_scratch_is_valid(svm))
 				goto vmgexit_err;
 		} else {
-			if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
+			if (!(control->exit_info_1 & SVM_IOIO_TYPE_MASK))
 				if (!kvm_ghcb_rax_is_valid(svm))
 					goto vmgexit_err;
 		}
@@ -2509,7 +2515,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_EXIT_MSR:
 		if (!kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
-		if (ghcb_get_sw_exit_info_1(ghcb)) {
+		if (control->exit_info_1) {
 			if (!kvm_ghcb_rax_is_valid(svm) ||
 			    !kvm_ghcb_rdx_is_valid(svm))
 				goto vmgexit_err;
@@ -2553,8 +2559,6 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	return 0;
 
 vmgexit_err:
-	vcpu = &svm->vcpu;
-
 	if (reason == GHCB_ERR_INVALID_USAGE) {
 		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
 			    ghcb->ghcb_usage);
@@ -2852,8 +2856,6 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
 
-	exit_code = ghcb_get_sw_exit_code(ghcb);
-
 	sev_es_sync_from_ghcb(svm);
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
@@ -2862,6 +2864,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
+	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
 		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
-- 
2.39.0


