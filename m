Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88814D5007
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 18:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244366AbiCJRQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 12:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244347AbiCJRQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 12:16:01 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D8C182DA7
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:15:00 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e2so5433886pls.10
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TPBQdtbwOmlVYwAm75BFwhcIX+dQ//6h0EnbuKsG+sU=;
        b=Ur6lep8Ry6UQr79uHPM2mS0Y8zxWlv9paJGLd5Pz5xCuu3h3wbaj0DUdtxwLG01M3+
         p5kGGkTH9GfXo11W9gNqUrUcTRtZmYbKGFrvyjaDIxCwgS0sGg4ZwS2QDd9xkcA+cK3k
         2rXFZZHPmQy/rZ2fc3C/1A/v+f7kwVm67+8236LNjp1S79ig5HAdAfSsyZ/ZqO4URUUZ
         2kg2/FZitlv+ObTsRkfpECA7d9/habQnCKgubwJIuHNNuHT8jxXNgrl53qzpSN3fncBu
         4LBkRRdr7uYEs0wsz/X4C1H2NY9RrlEVixp5tmE0IVNImhcU7iqzxp6jhDRrlsDjSSbJ
         vc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TPBQdtbwOmlVYwAm75BFwhcIX+dQ//6h0EnbuKsG+sU=;
        b=0TUjX75PCeYwn+H39x66ccWRRoBGK9FuIrHqNxZAxGsEUbQjAktjck+wtuIhU55EAe
         ACWBPdzoV69nYPb0oC+8r8etVYmoxXvo24D54ywpdyyY3SWnrG9rRojp1PNHITwIdYIs
         3pduQb+dviDZYNooEg8YxScdsHHqXT7tDhk1BHoxsRNZBqu0cUc/sMYG47O7w3xDGtu9
         TUk2H4RBLKIfvgD4vMio8+f87J0Gtt9uUQ9iHPKMl5+2ZNU4vEJXScb8FptxkydVe4jm
         F8WZZP9qiuXOgFQ6UvLu+Ljf1zwKZsDd282e6wnoSg7XEsHVUcoyr/SRkoQZnkb42NeS
         jX1w==
X-Gm-Message-State: AOAM531SsyNKhMoix8bvC6ZxeIFVriin15fdWXASJCqo6+tISILzaAg1
        PKi7jh6uKjm+9NqnnPunGMoZK7IGUhFQ+A==
X-Google-Smtp-Source: ABdhPJybOygWPx/LvPXMP9Xv/cIRttLOmJATcGvThhrinrYKNGRgYMqwH0Y07fNfO7GsJowtYBJIPA==
X-Received: by 2002:a17:902:d888:b0:151:6fe8:6e68 with SMTP id b8-20020a170902d88800b001516fe86e68mr5897412plz.158.1646932499643;
        Thu, 10 Mar 2022 09:14:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e18-20020a63d952000000b00372a1295210sm5907148pgj.51.2022.03.10.09.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 09:14:58 -0800 (PST)
Date:   Thu, 10 Mar 2022 17:14:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: x86: Remove redundant vm_entry_controls_clearbit()
 call
Message-ID: <YioyDu+9VoGmTWlD@google.com>
References: <20220310111354.504565-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310111354.504565-1-zhenzhong.duan@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022, Zhenzhong Duan wrote:
> When emulating exit from long mode, EFER_LMA is cleared which lead to
> efer writing emulation, which will unset VM_ENTRY_IA32E_MODE control
> bit as requested by SDM. So no need to unset VM_ENTRY_IA32E_MODE again
> in exit_lmode() explicitly.
> 
> In fact benefited from shadow controls mechanism, this change doesn't
> eliminate vmread or vmwrite.
> 
> Opportunistically remove unnecessory assignment to uret MSR data field
> as vmx_setup_uret_msrs() will do the same thing.

This needs to be a separate patch, it's much more subtle than "xyz will do the
same thing".  update_transition_efer() doesn't unconditionally set uret->data,
which on the surface makes this look suspect, but it's safe because uret->data
is consumed if and only if uret->load_into_hardware is true, and it's (a) set to
false if uret->data isn't updated and (b) uret->data is guaranteed to be updated
before it's set to true.

> In case EFER isn't supported by hardware, long mode isn't supported,
> so this will no break.
>
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b730d799c26e..b04588dc7faa 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2878,14 +2878,11 @@ int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  		return 0;
>  
>  	vcpu->arch.efer = efer;
> -	if (efer & EFER_LMA) {
> +	if (efer & EFER_LMA)
>  		vm_entry_controls_setbit(to_vmx(vcpu), VM_ENTRY_IA32E_MODE);
> -		msr->data = efer;
> -	} else {
> +	else
>  		vm_entry_controls_clearbit(to_vmx(vcpu), VM_ENTRY_IA32E_MODE);
>  
> -		msr->data = efer & ~EFER_LME;
> -	}

While you're doing opportunistic cleanups, drop the local "msr" and use "vmx"
directly instead of redoing to_vmx(), i.e. this

int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	/* Nothing to do if hardware doesn't support EFER. */
	if (!vmx_find_uret_msr(vmx, MSR_EFER))
		return 0;

	vcpu->arch.efer = efer;
	if (efer & EFER_LMA)
		vm_entry_controls_setbit(vmx, VM_ENTRY_IA32E_MODE);
	else
		vm_entry_controls_clearbit(vmx, VM_ENTRY_IA32E_MODE);

	vmx_setup_uret_msrs(vmx);
	return 0;
}
