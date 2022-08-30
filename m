Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85535A6C81
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 20:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiH3SoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 14:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiH3SoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 14:44:15 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7715174BA8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:44:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m2so11978367pls.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=LaMQFRX0UeRPFbdW+nLRpQghiuZmlwDm+nxHKxvjpKY=;
        b=P1rCIF3dZwQAQywAd5XezzR+dcnrRrYYfWVQaK2/SItThyh1FNTOv40ThKrDkYmeGq
         lbuBt8YmnQX4uqrCGmgf/xQQc+FBssbaSi+YyAK2mObTVwO+KaEtmuO6ekzPOFoo3A2S
         Km/oUV9GIcLhz3h/Weh0eE/uIXtx6yWi1YuRIWrcgndbSjYrqPsWzDE8r976Vh3KBC37
         TsTph/fAcyqqIpYLQ36445xpK+6MyjZsEHHfEXXpuCOsMbWuQsEPHLAitVJf4lpI71gc
         mdF7+Hl3jj1dg3QeiKkXvYg5smOU8peCXZjeJvBdK5sWbv4GTHknSPGG+NKGEqxmw2hz
         ApkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=LaMQFRX0UeRPFbdW+nLRpQghiuZmlwDm+nxHKxvjpKY=;
        b=zHHQYT777xzjIqngwYST468J8ZREbBDqtPtNO+sPun3R+ffsjkrYevv+1+vlW4trpA
         Hbe3CV32QRxlYm03Nthi8BG5MT1pRt1aM3FrCk0N6GURvUzi8EJZGa4SuCLti/PCov0V
         PiBFRXIaFGNp5J67nRJNjmRIAbh0WL9VylYx7SuJ7zG2S7PohXmeO+yZAgZz4/jbI0hx
         0my6CMmMIptctuz0sDewtKUEaOW3rxOGk/v+7H1GvOPr7SaezAbrzVHNHEIEK2AmX9Lp
         E2PKqKz/3f+UAzZGWYuFg+4x3+qAAM2bUCh+Tc4JfU2YYP/oUBfEVe1a2CzMznF+bF2m
         54ZA==
X-Gm-Message-State: ACgBeo1+n/VD2kC3CASnfSXpV8eZ+ELp3JQ32yME74+PGOrnPqE0cluA
        jyIJUA9S8k7JbN9Lzt2XFd5gHw==
X-Google-Smtp-Source: AA6agR6UYArRhVdJRzK2hp/ujTBg3oQGUm0TIgZfDwN7OKJ/efZVIoz3IOViIM51Ok0EcKVOTjgwwA==
X-Received: by 2002:a17:902:c945:b0:16d:c318:4480 with SMTP id i5-20020a170902c94500b0016dc3184480mr22601569pla.147.1661885052862;
        Tue, 30 Aug 2022 11:44:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z5-20020a17090a66c500b001f334aa9170sm8829426pjl.48.2022.08.30.11.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 11:44:12 -0700 (PDT)
Date:   Tue, 30 Aug 2022 18:44:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
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
Message-ID: <Yw5aeFp9rTs4tkDb@google.com>
References: <cover.1658913543.git.houwenlong.hwl@antgroup.com>
 <a845c3e93b2e94b510abbc26ab4ffc0eb8a8b67a.1658913543.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a845c3e93b2e94b510abbc26ab4ffc0eb8a8b67a.1658913543.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022, Hou Wenlong wrote:
> The return value of emulator_{get|set}_mst_with_filter()
> is confused, since msr access error and emulator error
> are mixed. Although, KVM_MSR_RET_* doesn't conflict with
> X86EMUL_IO_NEEDED at present, it is better to convert
> msr access error to emulator error if error value is
> needed.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/x86.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5366f884e9a7..8df89b9c212f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7908,11 +7908,12 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
>  	int r;
>  
>  	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
> -
> -	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
> -				    complete_emulated_rdmsr, r)) {
> -		/* Bounce to user space */
> -		return X86EMUL_IO_NEEDED;
> +	if (r) {
> +		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
> +				       complete_emulated_rdmsr, r))
> +			r = X86EMUL_IO_NEEDED;
> +		else
> +			r = X86EMUL_UNHANDLEABLE;

This should be X86EMUL_PROPAGATE_FAULT, X86EMUL_UNHANDLEABLE is used to indicate
that KVM needs to bail all the way to userspace.

I definitely like the idea of converting to X86EMUL_* here instead of spreading
it across these helpers and the emulator, but in that case should convert _all_
types.

And I think it makes sense to opportunistically handle "r < 0" in the get helper.
KVM may not return -errno today, but assuming that will always hold true is
unnecessarily risking.

E.g. what about:


static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
					u32 msr_index, u64 *pdata)
{
	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
	int r;

	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
	if (r < 0)
		return X86EMUL_UNHANDLEABLE;

	if (r) {
		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
				       complete_emulated_rdmsr, r))
			return X86EMUL_IO_NEEDED;
		else
			return X86EMUL_PROPAGATE_FAULT;
	}

	return X86EMUL_CONTINUE;
}

static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
					u32 msr_index, u64 data)
{
	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
	int r;

	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
	if (r < 0)
		return X86EMUL_UNHANDLEABLE;

	if (r) {
		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
				       complete_emulated_msr_access, r))
			return X86EMUL_IO_NEEDED;
		else
			return X86EMUL_PROPAGATE_FAULT;
	}

	return X86EMUL_CONTINUE;
}


Or maybe even add a helper to do the translation?  Can't tell if this is a net
positive or not.  It's a bit gratuitous, but it does ensure consistent behavior
for RDMSR vs. WRMSR.

static int emulator_handle_msr_return(struct kvm_vcpu *vcpu *, int r,
				      u32 msr, u64 data, u32 exit_reason,
				      int (*comp)(struct kvm_vcpu *vcpu))
{
	if (r < 0)
		return X86EMUL_UNHANDLEABLE;

	if (r) {
		if (kvm_msr_user_space(vcpu, msr, exit_reason, data, comp, r))
			return X86EMUL_IO_NEEDED;
		else
			return X86EMUL_UNHANDLEABLE;
	}

	return X86EMUL_CONTINUE;
}

static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
					u32 msr_index, u64 *pdata)
{
	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
	int r;

	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
	return emulator_handle_msr_return(vcpu, r, msr_index, 0,
					  KVM_EXIT_X86_RDMSR,
					  complete_emulated_rdmsr);
}

static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
					u32 msr_index, u64 data)
{
	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
	int r;

	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
	return emulator_handle_msr_return(vcpu, r, msr_index, data,
					  KVM_EXIT_X86_WRMSR,
					  complete_emulated_msr_access);
}


And then the emulator side of things can be:

static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
{
	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
	u64 msr_data;
	int r;

	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
	r = ctxt->ops->set_msr_with_filter(ctxt, msr_index, msr_data);

	if (r == X86EMUL_PROPAGATE_FAULT)
		return emulate_gp(ctxt, 0);

	return r;
}

static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
{
	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
	u64 msr_data;
	int r;

	r = ctxt->ops->get_msr_with_filter(ctxt, msr_index, &msr_data);

	if (r == X86EMUL_PROPAGATE_FAULT)
		return emulate_gp(ctxt, 0);

	if (r == X86EMUL_CONTINUE) {
		*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
		*reg_write(ctxt, VCPU_REGS_RDX) = msr_data >> 32;
	}
	return r;
}
