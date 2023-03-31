Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD26F6D240B
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjCaPcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 11:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjCaPcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 11:32:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0AB1CBBB
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:32:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e23-20020a25e717000000b00b66ab374ba1so22452822ybh.22
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680276737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b4x8HXV1Ty8f+QbD1cIYl7EFoffqOl19yzTsY05x5g0=;
        b=RpQKSqzfM66CEr49DRl6c33cu/r90RL+52Q2nA/itFx+B8Dy1tUE/CIGtGN+1nAnci
         QH2d0P/0A3uUcfabuGUniUxhSg++n1n/0zhJbXjdVYS2oCWGp+E79n21PBkoU2KbdZzT
         SvTOuEBeYWy3l3MBOWUxUQQ3G4AMCBr1Na85FQCS/9kdWxtB59ckMTVrDFlCLsE3F+3N
         9H21IIDswb/lAvorKG4ksQUg4FpCesg1HOO/ViCBVDc9kJn5t6nfB/r+nFBvISCdWmHy
         1UL6sLdnR6fAXfFnAjRNyzksx7RLbRpM2mBykKLBv4MRAmBxCNJeVf6c3JzLAkK2lbn+
         jnkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680276737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4x8HXV1Ty8f+QbD1cIYl7EFoffqOl19yzTsY05x5g0=;
        b=wGxyLWLbHRNuCm+b7DpBTuDnp0uRtpOODJRRUJOwr0YD9X/Znjo4r42cLEQJtUrgmx
         JCb37CRzWRM6cuYODOi45Vpm0L7uRCofZzCP9cD2lYu5ZRPQRwDRz/i1UbH4jcgZCGbs
         81x7dc7U/E4VSg5e2BAJjy2WwmaVkRA+3Cj7fT7baBeSys0hgxCYgHB0mw3Mp7DF+WwS
         2uZ57L3/jOo+cURnjTe8v5whbCAyW4Ps/0fQliRnzLFD2gr9oK2gAR+vDx5QIGvo0dwT
         r1a3QlPA0NXS9oy9EMyJvz+vmqiR5MyW351ejQ92bsXa4/AHHkXVk6aeMP9Sy82150uP
         NRdg==
X-Gm-Message-State: AAQBX9dVyS3lkJh4JBNin7/e+1BeJA4xWXiNo6rLYvEHq2bte55Ovc0m
        9qrrYnnTKhP26yL+oUqWc4HwAVmjshI=
X-Google-Smtp-Source: AKy350Y1zNtBu7i8KLk9w+z7acvdr6P9P8vy6hT4uJaRtUDBhM+lGVvEQBzQ3v9GVVpLzpfTgAQULfhO/OA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1205:b0:b69:fab9:de60 with SMTP id
 s5-20020a056902120500b00b69fab9de60mr17995381ybu.0.1680276737147; Fri, 31 Mar
 2023 08:32:17 -0700 (PDT)
Date:   Fri, 31 Mar 2023 08:32:15 -0700
In-Reply-To: <20230331071929.102070-1-haiwenyao@uniontech.com>
Mime-Version: 1.0
References: <20230331071929.102070-1-haiwenyao@uniontech.com>
Message-ID: <ZCb8/5/anTD24FSp@google.com>
Subject: Re: [PATCH] KVM: VMX: Reduce redundant call and simplify code
From:   Sean Christopherson <seanjc@google.com>
To:     Wenyao Hai <haiwenyao@uniontech.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, the call into common code is unnecessary/superfluous, not redundant.

On Fri, Mar 31, 2023, Wenyao Hai wrote:
> Use vcpu->arch.pat = data instead of kvm_set_msr_common() to
> simplify code, avoid redundant judgements.
> 
> Signed-off-by: Wenyao Hai <haiwenyao@uniontech.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d2d6e1b6c788..abeeea21c8ef 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2320,12 +2320,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
>  			get_vmcs12(vcpu)->guest_ia32_pat = data;
>  
> -		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
> +		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
>  			vmcs_write64(GUEST_IA32_PAT, data);
> -			vcpu->arch.pat = data;
> -			break;
> -		}
> -		ret = kvm_set_msr_common(vcpu, msr_info);
> +
> +		vcpu->arch.pat = data;

After this, I'm pretty sure the PAT path in kvm_set_msr_common() is no longer used.
And good riddance, because it's not an MTRR, and then only reason to lump it in
with MTRRs would be to zap SPTEs when the memtype changes, but KVM doesn't even
do that because update_mtrr() bails early for PAT.

I'll send a small series next week to clean up handling of PAT and the related
code in kvm_set_msr_common().  I'll include this patch and the patch from Ke Guo[*]
as the first two patches in the series.

[*] https://lore.kernel.org/all/20230329081859.2571698-1-guoke@uniontech.com
