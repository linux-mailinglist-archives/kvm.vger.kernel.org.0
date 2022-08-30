Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1D05A6CC0
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiH3TFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiH3TFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:05:32 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5247046DA8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:05:31 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id f12so11850732plb.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=L0ixBWfvGN8dkOYu3QU6PxspWgA+D5YI3mWGgu9LL/M=;
        b=lTPUSyCJXHj0en9G0RNRW/fDz5tKnCiyrfdZ52/ViUnO+0L9ARdg3OwmxZ/FYh7/q7
         V7VDiiTQa/gErmbnofCSNu0vc1vsa7B1qfi2btqFOq0Bt4HlOLKpU0wgeYim3vgO13ca
         OzthEBGNvg3W+YrYdDJIZhfnMhfbHrmFzICw0z5W3cWFcL+nypp2IXts+RMz6PpNs1e4
         eImFMrrtiu98DZBOG2zCIyeWuH0Az80Tk/nhSDmW/HYGZbhoPUKsB/LQOsGcJ+PqU/PY
         GOK/s/7KJtY9MVGjhn6hCUKXoppe2v5ycKrq+l3TFgYg+ja4VKYqGOEVU8l5lUiXhOv9
         w67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=L0ixBWfvGN8dkOYu3QU6PxspWgA+D5YI3mWGgu9LL/M=;
        b=XSU5vOB3bm5ukZow0oYr8MBIf2IO7X7g7ETnTGYzWA3VMAEz6glGgoefU8fXsB9w4u
         QriilzP/Ba1s4lOD+TZCHsPxOSAg7Ul9kYEQF8WcIHAOm7BO7TL23czuFmy2kDmGBDyQ
         W15XeynYF1YnReEXriii2CsbZ34wPWt/Tcoq/ucbnnk/KS+Z66UX6pm5h9p8AWhxD2KV
         utJCwxSBlzzoLdBwBIyKNcapoku94JwXe4OkQ4pSQPjsFhDwgPT7TD3laI1uZU4tI4Tz
         erHS4v3C2rGvkR7r7a6eQOvChINeiAClvAacURkU+PW6l4Oa4w6rGevtYqgOkndA6ajv
         qVCA==
X-Gm-Message-State: ACgBeo2KrFZX+URkNs5hNsKRT9GYP1Chau07XIQs4lI2tioeOIhdDcPx
        z652e7bqsrJOn3LTQOa7YEnEY7oyyvYZMg==
X-Google-Smtp-Source: AA6agR76jiz7NZrcL4vj/E7jcS3k1UtQoIBYOXP+UhSMZHhnA7mcoHuTuRyZd8c4T3C/OFk6qjoTfw==
X-Received: by 2002:a17:90a:8b82:b0:1fa:973c:1d34 with SMTP id z2-20020a17090a8b8200b001fa973c1d34mr25204294pjn.31.1661886330687;
        Tue, 30 Aug 2022 12:05:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s66-20020a625e45000000b005350ea966c7sm9722288pfb.154.2022.08.30.12.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 12:05:30 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:05:26 +0000
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
Subject: Re: [PATCH 2/2] KVM: x86: Add missing trace points for RDMSR/WRMSR
 in emulator path
Message-ID: <Yw5fdi4eqUnCLQaX@google.com>
References: <cover.1658913543.git.houwenlong.hwl@antgroup.com>
 <f7d395b60eb7e6dcc149ba39d86f9296bd81b0ac.1658913543.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7d395b60eb7e6dcc149ba39d86f9296bd81b0ac.1658913543.git.houwenlong.hwl@antgroup.com>
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
> Since the RDMSR/WRMSR emulation uses a sepearte emualtor interface,
> the trace points for RDMSR/WRMSR can be added in emulator path like
> normal path.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/x86.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8df89b9c212f..6e45b20ce9a4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7908,12 +7908,16 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
>  	int r;
>  
>  	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
> -	if (r) {
> +	if (!r) {
> +		trace_kvm_msr_read(msr_index, *pdata);
> +	} else {
>  		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
> -				       complete_emulated_rdmsr, r))
> +				       complete_emulated_rdmsr, r)) {
>  			r = X86EMUL_IO_NEEDED;
> -		else
> +		} else {
> +			trace_kvm_msr_read_ex(msr_index);

Drat, I suspected this patch would make adding a helper a mess.  We could use
trace_kvm_msr() directly, using @exit_reason to select between "rdmsr" and "wrmsr",
but I think the end result is less readable and not worth the small amount
of deduplication.  E.g. this is rather hard to read.

	if (r < 0)
		return X86EMUL_UNHANDLEABLE;

	if (r) {
		if (kvm_msr_user_space(vcpu, msr, exit_reason, data, comp, r))
			return X86EMUL_IO_NEEDED;

		trace_kvm_msr(exit_reason == KVM_EXIT_X86_WRMSR,
			      msr, data, true);
		return X86EMUL_PROPAGATE_FAULT;
	}

	trace_kvm_msr(exit_reason == KVM_EXIT_X86_WRMSR, msr, data, false);
	return X86EMUL_CONTINUE;

Aha!  If there "error" paths return directly, then the "else" paths go away and
this is all (IMO) a bit cleaner.  And the diff for this patch should be much
smaller since there won't be any curly brace changes.

How about this for a final product?

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

		trace_kvm_msr_read_ex(msr_index);
		return X86EMUL_PROPAGATE_FAULT;
	}

	trace_kvm_msr_read(msr_index, *pdata);
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

		trace_kvm_msr_write_ex(msr_index, data);
		return X86EMUL_PROPAGATE_FAULT;
	}

	trace_kvm_msr_write(msr_index, data);
	return X86EMUL_CONTINUE;
}

