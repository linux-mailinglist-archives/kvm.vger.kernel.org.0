Return-Path: <kvm+bounces-65772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EB19BCB6200
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A5D6C300249E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8552D12ED;
	Thu, 11 Dec 2025 14:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="qGo2PF8C"
X-Original-To: kvm@vger.kernel.org
Received: from out28-76.mail.aliyun.com (out28-76.mail.aliyun.com [115.124.28.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495A82C2353;
	Thu, 11 Dec 2025 14:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765461682; cv=none; b=Xd6DwlUNKrzjsdB2Ku2DWG0rENyNnDy7Ly+N7QGMtcOLaOg0N6CmG/0khwrBq+n+uBJjssvvObkojjJ75/SqanC0/hucmevx3o0X1A/KlvlnfPl3DpniT2OITlpX0pSXgVKhV/bHclG9R/lg+ZprGPWlkNi2vtLXTcczKgV+unA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765461682; c=relaxed/simple;
	bh=sig6NBUwsODolchWtc08N7f1YONEwgls5q0b89vTUPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spbVaXLDWJfrs1m2i/DTHKNJztlr17d8KrBUTZ2E7X4brNc7HKF8Wo3qOi2WPz6qiDaYKSiAcaem5+MB/oFUAjEQpadE3lPe86ysdJL0YH4fPeF4JM5KY8/6hvpabmrCPzAzdqMZs1P5v0yCSpQGYngyYKn3Bysy7pA2RwJx0Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=qGo2PF8C; arc=none smtp.client-ip=115.124.28.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1765461667; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=vuVLqfhB8Au6lyWCkydXHMNzWOrQGO98oZ5XCntqZoU=;
	b=qGo2PF8CdmaOk/Lt8oY/5x33lO8/R/hOPc2TXpvvXzV+JOXDSO6lvH6cDa497oWrmWPfI5DXW9etca+GdTuZvKuQAsUQ99qB93LiEPN2bvW/SECT1NpQBSBu555iP16vUx+QLFXtFrmrmkAJnAloQVAUpM7GmW4RfB8XAj3Cuxg=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fi4iSL9_1765461666 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 22:01:07 +0800
Date: Thu, 11 Dec 2025 22:01:06 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] KVM: VMX: Set 'BS' bit in pending debug exceptions
 during instruction emulation
Message-ID: <20251211140106.GB42509@k08j02272.eu95sqa>
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
 <b1a294bc9ed4dae532474a5dc6c8cb6e5962de7c.1757416809.git.houwenlong.hwl@antgroup.com>
 <aTMiVoOGS6gQm9aL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTMiVoOGS6gQm9aL@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Dec 05, 2025 at 10:20:06AM -0800, Sean Christopherson wrote:
> On Wed, Sep 10, 2025, Hou Wenlong wrote:
> > If 'STI' or 'MOV SS' with 'X86_EFLAGS_TF' set is emulated by the
> > emulator (e.g., using the 'force emulation' prefix), the check for
> > pending debug exceptions during VM entry would fail,
> 
> s/fail/VM-Fail, and please elaborate on what exactly fails.  I've had a lot (too
> much) of exposure to the consistency check, but I still have to look up the details
> every time.
>
Get it.
 
> > as #UD clears the pending debug exceptions. Therefore, set the 'BS' bit in
> > such situations to make instruction emulation more robust.
> > 
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >  arch/x86/include/asm/kvm_host.h    |  1 +
> >  arch/x86/kvm/vmx/main.c            |  9 +++++++++
> >  arch/x86/kvm/vmx/vmx.c             | 14 +++++++++-----
> >  arch/x86/kvm/vmx/x86_ops.h         |  1 +
> >  arch/x86/kvm/x86.c                 |  7 +++++--
> >  6 files changed, 26 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 18a5c3119e1a..3a0ab1683f17 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -50,6 +50,7 @@ KVM_X86_OP(get_gdt)
> >  KVM_X86_OP(set_gdt)
> >  KVM_X86_OP(sync_dirty_debug_regs)
> >  KVM_X86_OP(set_dr7)
> > +KVM_X86_OP_OPTIONAL(set_pending_dbg)
> >  KVM_X86_OP(cache_reg)
> >  KVM_X86_OP(get_rflags)
> >  KVM_X86_OP(set_rflags)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 0d3cc0fc27af..a36ca751ee2e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1765,6 +1765,7 @@ struct kvm_x86_ops {
> >  	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
> >  	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
> >  	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
> > +	void (*set_pending_dbg)(struct kvm_vcpu *vcpu);
> >  	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> >  	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
> >  	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index dbab1c15b0cd..23adff73f90b 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -465,6 +465,14 @@ static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
> >  	vmx_set_dr7(vcpu, val);
> >  }
> >  
> > +static void vt_set_pending_dbg(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> 
> WARN_ON_ONCE()?
> 
> > +		return;
> > +
> > +	vmx_set_pending_dbg(vcpu);
> > +}
> > +
> >  static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
> >  {
> >  	/*
> > @@ -906,6 +914,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.get_gdt = vt_op(get_gdt),
> >  	.set_gdt = vt_op(set_gdt),
> >  	.set_dr7 = vt_op(set_dr7),
> > +	.set_pending_dbg = vt_op(set_pending_dbg),
> >  	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
> >  	.cache_reg = vt_op(cache_reg),
> >  	.get_rflags = vt_op(get_rflags),
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 227b45430ad8..e861a0edb3f4 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5243,11 +5243,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  			 */
> >  			if (is_icebp(intr_info))
> >  				WARN_ON(!skip_emulated_instruction(vcpu));
> > -			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
> > -				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
> > -				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
> > -				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
> > -					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
> > +			vmx_set_pending_dbg(vcpu);
> 
> This looks wrong.  Per Table 19-2. Debug Exception Conditions, INT1 doesn't
> set DR6.BS.  Oooh, the helper is _conditionally_ setting DR6_BS.  But that still
> _looks_ wrong, and it makes the comment confusing.
> 
> >  
> >  			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
> >  			return 1;
> > @@ -5554,6 +5550,14 @@ void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
> >  	vmcs_writel(GUEST_DR7, val);
> >  }
> >  
> > +void vmx_set_pending_dbg(struct kvm_vcpu *vcpu)
> 
> Related to above, this is a confusing name.  In no small part because of the rather
> insane complexity related to pending debug exceptions being visible to software
> via the VMCS.  E.g. I initially read this as "set a pending #DB", not "set the
> VMCS field with the same name based on RFLAGS.TF and whether or not the vCPU is
> in an interrupt shadow".
> 
> Maybe refresh_pending_dbg_excpetions()?  And then the above case would be:
> 
> 			if (is_icebp(intr_info))
> 				WARN_ON(!skip_emulated_instruction(vcpu));
> 			else
> 				vmx_refresh_pending_dbg_exceptions(vcpu);
>
Agree, this makes the code clearly.

> > +{
> > +	if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
> > +	    vmx_get_interrupt_shadow(vcpu))
> > +		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
> > +			    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
> > +}
> > +
> >  static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
> >  {
> >  	kvm_apic_update_ppr(vcpu);
> > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > index 2b3424f638db..2913648cfe4f 100644
> > --- a/arch/x86/kvm/vmx/x86_ops.h
> > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > @@ -75,6 +75,7 @@ void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
> >  void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
> >  void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val);
> >  void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
> > +void vmx_set_pending_dbg(struct kvm_vcpu *vcpu);
> >  void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
> >  void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> >  unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 83960214d5d8..464e9649cb54 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9250,10 +9250,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  			if (ctxt->is_branch)
> >  				kvm_pmu_branch_retired(vcpu);
> >  			kvm_rip_write(vcpu, ctxt->eip);
> > -			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
> > +			__kvm_set_rflags(vcpu, ctxt->eflags);
> > +			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))) {
> >  				r = kvm_vcpu_do_singlestep(vcpu);
> > +				if (r)
> > +					kvm_x86_call(set_pending_dbg)(vcpu);
> 
> Why not handle this in kvm_vcpu_do_singlestep()?  Ah, because the call from
> kvm_skip_emulated_instruction() can never occur in an interrupt shadow.  But
> that's a _really_ subtle detail, and more imporantly the call is benign in that
> case.
>
Yes, my initial thought is that kvm_skip_emulated_instruction() clears
the interrupt shadow, so I didn't add one more function call for it.
However, I'll move it into kvm_vcpu_do_singlestep()

> So unless there's a good reason to do otherwise, I vote to move the call into
> kvm_vcpu_do_singlestep().
> 
> > +			}
> >  			kvm_x86_call(update_emulated_instruction)(vcpu);
> > -			__kvm_set_rflags(vcpu, ctxt->eflags);
> 
> Please move the relocation of the call to __kvm_set_rflags() to its own patch.
> I vaguely recall running into problems related to the state of RFLAGS in the
> emulator versus those in the vCPU.  I don't _think_ there's a problem here, but
> if there is, I want the change to be fully isolated.
> 
> >  		}

Get it. I moved it up to keep it after kvm_rip_write() so that matches that the singlestep
trap is generated after instruction execution.


> >  
> >  		/*
> > -- 
> > 2.31.1
> > 

