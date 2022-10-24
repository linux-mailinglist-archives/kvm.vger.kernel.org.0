Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1268C60B530
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiJXSOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiJXSNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:13:55 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0290F100BC2
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 09:55:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso7020662pjc.0
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 09:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m9QJ1WIMSrjBnka7vLbpchRih8LDKA+qYd06ktxI7R4=;
        b=Kv6xPyP0h9SeVsnJBl+P8WKONUFDVsWJBpRGiHKjwQ828Ww+/f0UTSnBn+GM7yirvc
         0dKFBbi2fTJGqi5Y4XabZSjqn8G3GiEEaOFpOpTtWkcIq/hvUwSVPTaoNliIzDQI5s76
         akDlTHOmNpPVUCCSouSBfSLPZ4CrD3GSut1twtpMCXbM/RDcTVsGznc4ZYO3XgimElZ6
         8nGfkNhtwPre9l9lfXUTiCubk3XL/RmrwCLfFOdSVpq+oLVCVZM74BThykJw/ZOEioYY
         nv5rLUhO0eaaSAzdOPWzGY8p0LTQ1N0Slys7AOTpmsrBOdtA+A0Ce9ygfpMY/WznTugZ
         +CZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9QJ1WIMSrjBnka7vLbpchRih8LDKA+qYd06ktxI7R4=;
        b=NznOAYxHLddqpiLQCOMaGSrnRnuMz1A4vSNCdphY5/cm3+X2Td5PYzgDFPbpiD7Gpu
         OVLMX6lYTGwnKkk2QgGbc3Iu+NSkCcBmxQuWMr6PPOLG17UEi4dvg2b+G9wjioeme49B
         SRVNhByWgnXSzlvB57jyLP2q/xljh72lUMop49XK7uNF4K6GumM7YKTXMslIHWQRhuqX
         ip0xobgiCUwDK9USyCthI8Y8RtsYtxQFbv+Tr1K/4e/ZDsbxOpFoo0tMA18hsnaSk51w
         HwVju1YGF1WdZtRf7Nv49t96S32pP+xxp8XqpCRyMuzu2w/lfWYF8rsyPBqcdr4fI4Xf
         RPyg==
X-Gm-Message-State: ACrzQf0tvm5anZmh8VnOv5Q+wIwEmvTbRfk1J23mTdWhXoBxechWc31W
        cQURSh1Htm9Wm2qBQXo9qxiGgQ==
X-Google-Smtp-Source: AMsMyM7dcxQSPW0FUdto1JW2+l8fTlyFVF9CIgDL8SlZ8Funn0x84eM66/S0fZozNwsB+9cRYW1wAA==
X-Received: by 2002:a17:902:8698:b0:181:f060:7133 with SMTP id g24-20020a170902869800b00181f0607133mr34526960plo.1.1666630343161;
        Mon, 24 Oct 2022 09:52:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a928100b00200b12f2bf3sm114852pjo.51.2022.10.24.09.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 09:52:22 -0700 (PDT)
Date:   Mon, 24 Oct 2022 16:52:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: vmx/nested: avoid blindly setting
 SECONDARY_EXEC_ENCLS_EXITING when sgx is enabled
Message-ID: <Y1bCwpU4a+TZhRE1@google.com>
References: <20221024124845.1927035-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024124845.1927035-1-eesposit@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"nVMX" instead of "vmx/nested"

On Mon, Oct 24, 2022, Emanuele Giuseppe Esposito wrote:
> Currently vmx enables SECONDARY_EXEC_ENCLS_EXITING even when sgx
> is not set in the host MSR.
> This was probably introduced when sgx was not yet fully supported, and
> we wanted to trap guests trying to use the feature.

Nah, it's just a boneheaded bug.

> When booting a guest, KVM checks that the cpuid bit is actually set
> in vmx.c, and if not, it does not enable the feature.

The CPUID thing is a red herring.  That's an _additional_ restriction, KVM honors
MSR_IA32_VMX_PROCBASED_CTLS2 when configuring vmcs01.  See adjust_vmx_controls()
for secondary controls in setup_vmcs_config().

> However, in nesting this control bit is blindly copied, and will be

It's not "copied", KVM sets the bit in the nVMX MSR irrespective of host support,
which is the problem.

> propagated to VMCS12 and VMCS02. Therefore, when L1 tries to boot
> the guest, the host will try to execute VMLOAD with VMCS02 containing
> a feature that the hardware does not support, making it fail with
> hardware error 0x7.
> 
> According with section A.3.3 of Intel System Programming Guide,
> we should *always* check the value in the actual

s/we/software

> MSR_IA32_VMX_PROCBASED_CTLS2 before enabling this bit.
> 
> RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2127128
> 

Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
Cc: stable@vger.kernel.org

> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8f67a9c4a287..f651084010cc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6678,6 +6678,25 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
>  	return (u64)max_idx << VMCS_FIELD_INDEX_SHIFT;
>  }
>  
> +/*
> + * According with section A.3.3 of

Avoid referencing sections/tables by "number" in comments (and changelogs), as the
comment is all but guaranteed to become stale because future versions of the SDM
will shift things around.

The slightly more robust way to reference a specific SDM/APM section is to use the
title, e.g. According to section "Secondary Processor-Based VM-Execution Controls"
in Intel's SDM ...", as hardware vendors are less likely to arbitrarily rename
sections and tables.  It's a bit more work for readers, but any decent PDF viewer
can search these days.

> Intel System Programming Guide

KVM typically uses "Intel's SDM" (and "AMD's APM").  Like "VMX" or "SVM", it's ok
to use the SDM acronym without introducing since "SDM" is 

> + * we *can* set the guest MSR control X (in our case

Avoid pronouns in comments.  "we" and "us" are ambiguous, e.g. "we" can mean KVM,
the developer, the user, etc...

> + * SECONDARY_EXEC_ENCLS_EXITING) *iff* bit 32+X of
> + * MSR_IA32_VMX_PROCBASED_CTLS2 is set to 1.
> + * Otherwise it must remain zero.

As a general rule, if you find yourself writing a comment and a helper for
something that KVM absolutely needs to get right (honoring VMX MSRs), then odds
are very good that there's a simpler/easier fix, i.e. that you're effectively
re-inventing part of the weel.

> + */
> +static void nested_vmx_setup_encls_exiting(struct nested_vmx_msrs *msrs)
> +{
> +	u32 vmx_msr_procb_low, vmx_msr_procb_high;
> +
> +	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2, vmx_msr_procb_low, vmx_msr_procb_high);
> +
> +	WARN_ON(vmx_msr_procb_low & SECONDARY_EXEC_ENCLS_EXITING);
> +
> +	if (enable_sgx && (vmx_msr_procb_high & SECONDARY_EXEC_ENCLS_EXITING))
> +		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
> +}
> +
>  /*
>   * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
>   * returned for the various VMX controls MSRs when nested VMX is enabled.
> @@ -6874,8 +6893,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>  		msrs->secondary_ctls_high |=
>  			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
>  
> -	if (enable_sgx)
> -		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;

The issue here is that I, who wrote this code long, long ago, copied the pattern
used for enable_unrestricted_guest, flexpriority_enabled, etc... without fully
appreciating the logic.  Unlike those module params, enable_sgx doesn't track
hardware support, i.e. enable_sgx isn't cleared when SGX can't be enabled due to
lack of hardware support.  As a result, KVM effectively enumerates to L1 that the
control is always available, i.e. that KVM emulates ENCLS-exiting for L1, but KVM
obviously doesn't actually emulating the behavior.

Not updating enable_sgx is responsible for a second bug: vmx_set_cpu_caps() doesn't
clear the SGX bits when hardware support is unavailable.  This is a much less
problematic bug as as it only pops up if SGX is soft-disabled (the case being
handled by cpu_has_sgx()) or if SGX is supported for bare metal but not in the
VMCS (will never happen when running on bare metal, but can theoertically happen
when running in a VM).

Last but not least, KVM should ideally have module params reflect KVM's actual
configuration.

Killing all birds with one stone, simply clear enable_sgx when ENCLS-exiting isn't
supported.  The #ifdef is a little gross, but I think it's marginally less ugly
than having vmx.c define a dummy boolean.

Compile tested only...

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..65f092e4a81b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8263,6 +8263,11 @@ static __init int hardware_setup(void)
        if (!cpu_has_virtual_nmis())
                enable_vnmi = 0;
 
+#ifdef CONFIG_X86_SGX_KVM
+       if (!cpu_has_vmx_encls_vmexit())
+               enable_sgx = false;
+#endif
+
        /*
         * set_apic_access_page_addr() is used to reload apic access
         * page upon invalidation.  No need to do anything if not
