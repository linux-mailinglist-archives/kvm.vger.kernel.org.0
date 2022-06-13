Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CCD549CBB
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346144AbiFMTEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346299AbiFMTDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:03:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A21F49F3D
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:41:32 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y6so577955pfr.13
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O+JocPgmO8WNM4BldK6U8fZVXY76qHP3I087zvG+y48=;
        b=g3dcbrCKJI/BbBGz+mo9iC7bdjomgr5vnnU7/831GTnPptxXpZ0Ar6CcTaN25QOvqd
         VAsdBYGvK4fj2dCR/GtP7gk5MDXJxUe9H4SKW30Uie5kQnGHxmL3tf6VBnpblKXgVDQb
         e6xxWX2ACphUbDcaxSA37nbHlUEGtayXluwu9FTQQro8Hx6X5DIUVMxKAfWtEY2fAwb/
         G82hC6TqXFVSb7gUr0NhO1UqgGPh3o+i5E7wTvwoiSEW3Nv9wILVE4/RHShrK9eTAEjF
         pPa1lyUGuk5yUtCPTyX78U8q4Naumo7gOYM2vdKv+OOMXnWgytloUMxEwimoZn+nlqwV
         AJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O+JocPgmO8WNM4BldK6U8fZVXY76qHP3I087zvG+y48=;
        b=u/Vow4muewBcidDnacWfPdJCOD9jLqmuezO5T8QiABxN+HH8rdB4V2uVY1MSGc8zy1
         r031J6HMx5M4SaFW8rIZo8OzylIdrJ2o3u6Fsc4MLzf0KbMmhtKRzVLZDyDEuuAnp1+P
         JYawM6me/TbqtOunzUNxwEz013Lw16QhelZdxyb70xW8xmnJXMd1Ejuy+DWCAGzl4IC5
         PZMHe1qiK2pKvIMSbPi+pAlBTZnLrxeWBPYiU4swROTeSrc/Y5Nlz3GTrGz0o0Bexn3m
         YCLdECIl02vo/lyWud17f62v3LTsmqHC/xUhs9K+fY2O/KFrT6XlwnW8wvmegLxVGYD8
         ea3g==
X-Gm-Message-State: AOAM533NHUb13p+eqfr40VNb27w4lAIFBUTSZJeh1DRobv0Kh4xu/+eh
        H0Pckbqgseg46keHIVHBuPA4FQ==
X-Google-Smtp-Source: ABdhPJyEHkALhnbB6gryb80ttr+wk7GpaS/12VCioSqOpKgG+WeNaPDgSVYurGGS6l1E6JVjQlE9FQ==
X-Received: by 2002:a63:1559:0:b0:3f5:fdf7:12e2 with SMTP id 25-20020a631559000000b003f5fdf712e2mr409373pgv.13.1655138491804;
        Mon, 13 Jun 2022 09:41:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u7-20020a63b547000000b003fc136f9a7dsm5649504pgo.38.2022.06.13.09.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 09:41:31 -0700 (PDT)
Date:   Mon, 13 Jun 2022 16:41:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <Yqdot/66J7RMRw2B@google.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022, Anirudh Rayabharam wrote:
> As per the comments in arch/x86/kvm/vmx/evmcs.h, TSC multiplier field is

It's not just the comments, it's also the code.  It would be helpful to call out
in the changelog that KVM clears unsupported controls via evmcs_sanitize_exec_ctrls()
when using eVMCS.  

> currently not supported in EVMCS. As a result, there is no TSC scaling
> support when KVM is running on Hyper-V i.e. kvm_has_tsc_control is
> false.
> 
> However, in nested_vmx_setup_ctls_msrs(), TSC scaling is exposed to L1.
> When L1 tries to launch an L2 guest, vmcs12 has TSC scaling enabled.
> This propagates to vmcs02. But KVM doesn't set the TSC multiplier value
> because kvm_has_tsc_control is false. Due to this, VM entry for L2 guest
> fails. (VM entry fails if "use TSC scaling" is 1 and TSC multiplier is 0.)
>
> To fix, expose TSC scaling to L1 only if kvm_has_tsc_control.
> 
> Fixes: d041b5ea93352 ("KVM: nVMX: Enable nested TSC scaling")
> Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f5cb18e00e78..d773ddc6422b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6656,6 +6656,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		      msrs->secondary_ctls_low,
>  		      msrs->secondary_ctls_high);
>  
> +	if (!kvm_has_tsc_control)
> +		msrs->secondary_ctls_high &= ~SECONDARY_EXEC_TSC_SCALING;

I would much rather we fix the root of the problem and not play whack-a-mole,
e.g. all of the other controls that aren't supported by eVMCS have the same bug,.

nested_vmx_setup_ctls_msrs() should use vmcs_config to get the base MSR values,
not read the MSRs from hardware.  And it's not just eVMCS, e.g. the manipulation
of VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL for a CPU errata isn't handled either.

>  	msrs->secondary_ctls_low = 0;
>  	msrs->secondary_ctls_high &=
>  		SECONDARY_EXEC_DESC |
> @@ -6667,8 +6670,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		SECONDARY_EXEC_RDRAND_EXITING |
>  		SECONDARY_EXEC_ENABLE_INVPCID |
>  		SECONDARY_EXEC_RDSEED_EXITING |
> -		SECONDARY_EXEC_XSAVES |
> -		SECONDARY_EXEC_TSC_SCALING;
> +		SECONDARY_EXEC_XSAVES;
>  
>  	/*
>  	 * We can emulate "VMCS shadowing," even if the hardware
> -- 
> 2.34.1
> 
