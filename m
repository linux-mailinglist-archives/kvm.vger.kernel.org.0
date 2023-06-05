Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEA7722C4F
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjFEQQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjFEQQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:16:14 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E26D94
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:16:13 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53feeb13906so4619097a12.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 09:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685981773; x=1688573773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xg4ldCIzAS7znnQSOqjozyjYBgnKY+lUkD/r4HzlJ6s=;
        b=v2WpGKx9Llrh95v1OiQH3vt7ChGwW9X7teVoVN3SshJaFydIggGmvG/xvk3bJsWYi4
         +xE/8SvjCkyqUORdpgGjA+56Dh5VNZtLOmexxDTMWygMRxKoSPQXnUEvBodchk2mu9mY
         /5laB3KIaKAtYlRvkl7/m6VP/1pGDDJWraeXOiV6ZsBbyg00fLHRrpb8id/69pR4iy0a
         eyKhqqUlguElAKxicIOPT4wwSTTp7lePH0oWMhXy8RZDqFVpu8OFUfJTxKZPaLy+7tzI
         jNlKma498Wx8d6HSXIZVbEmzn2IvKekR42a1n+HLA/j9BIA+BJODcME1aArdwL83sJuf
         S9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685981773; x=1688573773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xg4ldCIzAS7znnQSOqjozyjYBgnKY+lUkD/r4HzlJ6s=;
        b=U1C/c0Raxq6lPfaFfjWHjnFk2SMyIpAp2DT2aNG8jFgyS5GPPXaqf6gwtXgdK+Tskq
         i9Im4WVWZwvapsgvo4Hliqgs7D6+chwpEQ6+XbwUo/Qxt32wQhJ2Zi58KIW0TZqzBfaU
         f2lcMddS8sULmmsi+1TnSIAXTdhPD6QlYBzNJgF+Ema1+s/MIvhkZjuQC5efOkz5ZbaY
         sx2LnEuDIMEWzJY8SKeW7HjR1PmVvwzMhnoN3CWjhynUrfkXY+JOLUQpxNzxKiBCzJF+
         ST+trP3x76dQEYh8qZ/V/99pog9dVKoGKebrNAHfMXT+MJFPr2UMT1RgbaIWdIWm96g8
         1Ttg==
X-Gm-Message-State: AC+VfDwsaHHC4X6YVC2BsOvpEE4o7/7gbZiK5cbbxm2z9Zd5Js/wOMDu
        3A7ao0VD7KvLoxo3Eu/IuYOy2sn90uA=
X-Google-Smtp-Source: ACHHUZ5OT4Hc1cBoaas/qcCfaknicU1Z/AEnmhEFo8v6GjDelni7bKiHq/ErdU+3GL0WX52rLjOMbAsxw4I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e889:b0:1ad:f135:9cf6 with SMTP id
 w9-20020a170902e88900b001adf1359cf6mr2255577plg.12.1685981772910; Mon, 05 Jun
 2023 09:16:12 -0700 (PDT)
Date:   Mon, 5 Jun 2023 09:16:11 -0700
In-Reply-To: <585cb687-54e5-90f3-36f2-0c356183db89@rbox.co>
Mime-Version: 1.0
References: <20230605114852.288964-1-mhal@rbox.co> <20230605130333.gzhjx4gbw7nkqbm2@yy-desk-7060>
 <585cb687-54e5-90f3-36f2-0c356183db89@rbox.co>
Message-ID: <ZH4KS4H4eMRTd14K@google.com>
Subject: Re: [PATCH] KVM: Clean up kvm_vm_ioctl_create_vcpu()
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023, Michal Luczaj wrote:
> On 6/5/23 15:03, Yuan Yao wrote:
> > On Mon, Jun 05, 2023 at 01:44:19PM +0200, Michal Luczaj wrote:
> >> Since c9d601548603 ("KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond")
> >> 'cond' is internally converted to boolean, so caller's explicit conversion
> >> from void* is unnecessary.
> >>
> >> Remove the double bang.
> >> ...
> >> -	if (KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> >> +	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> > 
> > Looks the only one place for KVM_BUG_ON().
> > 
> > Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> > 
> > BTW: svm_get_lbr_msr() is using KVM_BUG(false, ...) and
> > handle_cr() is using KVM_BUG(1, ...), a chance to
> > change them to same style ?
> 
> Sure, but KVM_BUG(false, ...) is a no-op, right? Would you like me to fix it
> separately with KVM_BUG(1, ...) as a (hardly significant) functional change?

Heh, yeah, that's dead code and should be fixed separately.  I think that should
just be a WARN_ON_ONCE(1) though, there's no reason to bug and kill the VM.
Actually, there's really no reason for double switch, KVM can simply provide a
helper to get the correct VMCB.  That'd provide an excuse to clean up a few other
uglies in svm_update_lbrv() too.  Tentative patch at the bottom.

> Also, am I correct to assume that (1, ) is the preferred style?

I don't think there's a preferred style, though (1, ...) is more prevalent, and
has the advantage of saving three chars for the message :-)

> arch/powerpc/kvm/book3s_64_mmu_host.c:kvmppc_mmu_map_page() seems to be the only
> exception (within KVM) with a `WARN_ON(true)`.

Yeah, I wouldn't worry about that one.

---
 arch/x86/kvm/svm/svm.c | 56 ++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ff48cdea1fbf..406b318f2f0d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -960,50 +960,24 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
 }
 
-static int svm_get_lbr_msr(struct vcpu_svm *svm, u32 index)
+static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
 {
 	/*
-	 * If the LBR virtualization is disabled, the LBR msrs are always
-	 * kept in the vmcb01 to avoid copying them on nested guest entries.
-	 *
-	 * If nested, and the LBR virtualization is enabled/disabled, the msrs
-	 * are moved between the vmcb01 and vmcb02 as needed.
+	 * If LBR virtualization is disabled, the LBR MSRs are always kept in
+	 * vmcb01.  If LBR virtualization is enabled and L1 is running VMs of
+	 * its own, the MSRs are moved between vmcb01 and vmcb02 as needed.
 	 */
-	struct vmcb *vmcb =
-		(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) ?
-			svm->vmcb : svm->vmcb01.ptr;
-
-	switch (index) {
-	case MSR_IA32_DEBUGCTLMSR:
-		return vmcb->save.dbgctl;
-	case MSR_IA32_LASTBRANCHFROMIP:
-		return vmcb->save.br_from;
-	case MSR_IA32_LASTBRANCHTOIP:
-		return vmcb->save.br_to;
-	case MSR_IA32_LASTINTFROMIP:
-		return vmcb->save.last_excp_from;
-	case MSR_IA32_LASTINTTOIP:
-		return vmcb->save.last_excp_to;
-	default:
-		KVM_BUG(false, svm->vcpu.kvm,
-			"%s: Unknown MSR 0x%x", __func__, index);
-		return 0;
-	}
+	return svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK ? svm->vmcb :
+								   svm->vmcb01.ptr;
 }
 
 void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-
-	bool enable_lbrv = svm_get_lbr_msr(svm, MSR_IA32_DEBUGCTLMSR) &
-					   DEBUGCTLMSR_LBR;
-
-	bool current_enable_lbrv = !!(svm->vmcb->control.virt_ext &
-				      LBR_CTL_ENABLE_MASK);
-
-	if (unlikely(is_guest_mode(vcpu) && svm->lbrv_enabled))
-		if (unlikely(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))
-			enable_lbrv = true;
+	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
+	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
+			   (is_guest_mode(vcpu) && svm->lbrv_enabled &&
+			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
 	if (enable_lbrv == current_enable_lbrv)
 		return;
@@ -2808,11 +2782,19 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = svm->tsc_aux;
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = svm_get_lbr_vmcb(svm)->save.dbgctl;
+		break;
 	case MSR_IA32_LASTBRANCHFROMIP:
+		msr_info->data = svm_get_lbr_vmcb(svm)->save.br_from;
+		break;
 	case MSR_IA32_LASTBRANCHTOIP:
+		msr_info->data = svm_get_lbr_vmcb(svm)->save.br_to;
+		break;
 	case MSR_IA32_LASTINTFROMIP:
+		msr_info->data = svm_get_lbr_vmcb(svm)->save.last_excp_from;
+		break;
 	case MSR_IA32_LASTINTTOIP:
-		msr_info->data = svm_get_lbr_msr(svm, msr_info->index);
+		msr_info->data = svm_get_lbr_vmcb(svm)->save.last_excp_to;
 		break;
 	case MSR_VM_HSAVE_PA:
 		msr_info->data = svm->nested.hsave_msr;

base-commit: 76a17bf03a268bc342e08c05d8ddbe607d294eb4
-- 

