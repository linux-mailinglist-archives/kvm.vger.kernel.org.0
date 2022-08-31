Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FDA5A7459
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 05:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiHaDSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 23:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiHaDSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 23:18:04 -0400
Received: from out0-148.mail.aliyun.com (out0-148.mail.aliyun.com [140.205.0.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4EA4D245;
        Tue, 30 Aug 2022 20:18:02 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047204;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.P3zI0Md_1661915879;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.P3zI0Md_1661915879)
          by smtp.aliyun-inc.com;
          Wed, 31 Aug 2022 11:17:59 +0800
Date:   Wed, 31 Aug 2022 11:17:59 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: Return emulator error if RDMSR/WRMSR
 emulation failed
Message-ID: <20220831031759.GA130753@k08j02272.eu95sqa>
References: <cover.1658913543.git.houwenlong.hwl@antgroup.com>
 <a845c3e93b2e94b510abbc26ab4ffc0eb8a8b67a.1658913543.git.houwenlong.hwl@antgroup.com>
 <Yw5aeFp9rTs4tkDb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw5aeFp9rTs4tkDb@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 02:44:08AM +0800, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Hou Wenlong wrote:
> > The return value of emulator_{get|set}_mst_with_filter()
> > is confused, since msr access error and emulator error
> > are mixed. Although, KVM_MSR_RET_* doesn't conflict with
> > X86EMUL_IO_NEEDED at present, it is better to convert
> > msr access error to emulator error if error value is
> > needed.
> > 
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/x86.c | 22 ++++++++++++----------
> >  1 file changed, 12 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5366f884e9a7..8df89b9c212f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7908,11 +7908,12 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
> >  	int r;
> >  
> >  	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
> > -
> > -	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
> > -				    complete_emulated_rdmsr, r)) {
> > -		/* Bounce to user space */
> > -		return X86EMUL_IO_NEEDED;
> > +	if (r) {
> > +		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
> > +				       complete_emulated_rdmsr, r))
> > +			r = X86EMUL_IO_NEEDED;
> > +		else
> > +			r = X86EMUL_UNHANDLEABLE;
> 
> This should be X86EMUL_PROPAGATE_FAULT, X86EMUL_UNHANDLEABLE is used to indicate
> that KVM needs to bail all the way to userspace.
> 
> I definitely like the idea of converting to X86EMUL_* here instead of spreading
> it across these helpers and the emulator, but in that case should convert _all_
> types.
> 
> And I think it makes sense to opportunistically handle "r < 0" in the get helper.
> KVM may not return -errno today, but assuming that will always hold true is
> unnecessarily risking.
I agree. The original commit 7dffecaf4eab wanted to report negative values to
userspace, but the emulator actually didn't propagate -errno to the caller.
So handling "r < 0" in the set helper is better, then only X86EMUL_* is returned. 

> 
> E.g. what about:
> 
> 
> static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
> 					u32 msr_index, u64 *pdata)
> {
> 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> 	int r;
> 
> 	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
> 	if (r < 0)
> 		return X86EMUL_UNHANDLEABLE;
> 
> 	if (r) {
> 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
> 				       complete_emulated_rdmsr, r))
> 			return X86EMUL_IO_NEEDED;
> 		else
> 			return X86EMUL_PROPAGATE_FAULT;
> 	}
> 
> 	return X86EMUL_CONTINUE;
> }
> 
> static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
> 					u32 msr_index, u64 data)
> {
> 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> 	int r;
> 
> 	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
> 	if (r < 0)
> 		return X86EMUL_UNHANDLEABLE;
> 
> 	if (r) {
> 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
> 				       complete_emulated_msr_access, r))
> 			return X86EMUL_IO_NEEDED;
> 		else
> 			return X86EMUL_PROPAGATE_FAULT;
> 	}
> 
> 	return X86EMUL_CONTINUE;
> }
>
I'll take this in the v2. Thanks.

> 
> Or maybe even add a helper to do the translation?  Can't tell if this is a net
> positive or not.  It's a bit gratuitous, but it does ensure consistent behavior
> for RDMSR vs. WRMSR.
> 
> static int emulator_handle_msr_return(struct kvm_vcpu *vcpu *, int r,
> 				      u32 msr, u64 data, u32 exit_reason,
> 				      int (*comp)(struct kvm_vcpu *vcpu))
> {
> 	if (r < 0)
> 		return X86EMUL_UNHANDLEABLE;
> 
> 	if (r) {
> 		if (kvm_msr_user_space(vcpu, msr, exit_reason, data, comp, r))
> 			return X86EMUL_IO_NEEDED;
> 		else
> 			return X86EMUL_UNHANDLEABLE;
> 	}
> 
> 	return X86EMUL_CONTINUE;
> }
> 
> static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
> 					u32 msr_index, u64 *pdata)
> {
> 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> 	int r;
> 
> 	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
> 	return emulator_handle_msr_return(vcpu, r, msr_index, 0,
> 					  KVM_EXIT_X86_RDMSR,
> 					  complete_emulated_rdmsr);
> }
> 
> static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
> 					u32 msr_index, u64 data)
> {
> 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> 	int r;
> 
> 	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
> 	return emulator_handle_msr_return(vcpu, r, msr_index, data,
> 					  KVM_EXIT_X86_WRMSR,
> 					  complete_emulated_msr_access);
> }
> 
> 
> And then the emulator side of things can be:
> 
> static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
> {
> 	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
> 	u64 msr_data;
> 	int r;
> 
> 	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
> 		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
> 	r = ctxt->ops->set_msr_with_filter(ctxt, msr_index, msr_data);
> 
> 	if (r == X86EMUL_PROPAGATE_FAULT)
> 		return emulate_gp(ctxt, 0);
> 
> 	return r;
> }
> 
> static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
> {
> 	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
> 	u64 msr_data;
> 	int r;
> 
> 	r = ctxt->ops->get_msr_with_filter(ctxt, msr_index, &msr_data);
> 
> 	if (r == X86EMUL_PROPAGATE_FAULT)
> 		return emulate_gp(ctxt, 0);
> 
> 	if (r == X86EMUL_CONTINUE) {
> 		*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
> 		*reg_write(ctxt, VCPU_REGS_RDX) = msr_data >> 32;
> 	}
> 	return r;
> }
