Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E035957D6DF
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 00:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiGUW2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 18:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiGUW2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 18:28:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F8291CCA
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:28:11 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b9so2982338pfp.10
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ApRvMbNP8wlH0201Q41bRrAQW2m03BQY4rHdajqvdkA=;
        b=nPOnVezBV0bXhFaox43hzXbu3Bifc/QvQk9RqkmSi8nMIkiNVjOqSsy6U4VUUMdDJj
         XK26sJ7Wt6aQV8WfR325CNagpJoFPGb7e5gVdaVJcMRITlslH1IX8ax8JkKNqtvmYCao
         XlcG4F9eVetr5Ob+Z40qgF+VDoZVUzzvW5Tc+iT/5mWNxTrfx5uUd/Lvob+m7us40K25
         bOGEkOwcZ09BvJvr+MgLeGPph0mIJq45a6WJRo8cN6sqgyz1SqHoy9F1ZjlP+W+N7LUq
         Fwfq/wwAwXT8SWgUpv9fuiszgDlabZFZAZl8O7lbD4btcgmcDSiQ2YcJzBPFbWIyOC8A
         dOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ApRvMbNP8wlH0201Q41bRrAQW2m03BQY4rHdajqvdkA=;
        b=ufXtqWZFziZkOjQ3xUFUET8JQ77RdfkEKtXoTLVCnh7jdJPU53oglTzetWAGClH2Sl
         hOR0Cojtona60KXavVhp89/mjETC0PODsVS55PVEZ3hgPK/FyA1nIJcanaXZXAF5gB1x
         csaiWG3ZdDS+Ybr+0Bl1Itq97GGdz9Dg7/L/bWaBLOtB0FmSq+NkhtDuToCP9VmwwCnE
         dOKiWDdl6hLa4telhqhxagb7chzQSd38d74tijAcoQfSEutXtFBcshHqQTrDbQlqG30a
         HXUhq6s4zW2mzVe4MlPqTvA56BVjBS+xAxwq4iB2HiBpSB1PxZGeKattUBYcOk6xpCj4
         X9DA==
X-Gm-Message-State: AJIora+COvMeqkAKBbPJdoEXozRq1ALOPREvYKv9XydkG6g8s7TgUwJw
        Q5mkW+q/beVBG/fRuVtzRHzcmYJwyCNgTw==
X-Google-Smtp-Source: AGRyM1v5Pz6nKHagM8aOB3KM1yOX28Jy9qVz2RRwnuvwmhO3GJhKFRjvzLe3IW8ndLmwYlW2dRIE/Q==
X-Received: by 2002:a63:6984:0:b0:40d:9ebe:5733 with SMTP id e126-20020a636984000000b0040d9ebe5733mr497593pgc.170.1658442490499;
        Thu, 21 Jul 2022 15:28:10 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y190-20020a6232c7000000b0051bbe085f16sm2229842pfy.104.2022.07.21.15.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 15:28:09 -0700 (PDT)
Date:   Thu, 21 Jul 2022 22:28:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/25] KVM: VMX: Extend VMX controls macro shenanigans
Message-ID: <YtnS9fH4cFpADvzu@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-16-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-16-vkuznets@redhat.com>
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

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> @@ -2581,30 +2536,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
>  
>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {

Curly braces no longer necessary.

> -		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
> -
> -		_cpu_based_3rd_exec_control = adjust_vmx_controls64(opt3,
> -					      MSR_IA32_VMX_PROCBASED_CTLS3);
> +		_cpu_based_3rd_exec_control =
> +			adjust_vmx_controls64(KVM_OPT_VMX_TERTIARY_VM_EXEC_CONTROL,
> +			MSR_IA32_VMX_PROCBASED_CTLS3);

Please align indentation.


	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
		_cpu_based_3rd_exec_control =
			adjust_vmx_controls64(KVM_OPT_VMX_TERTIARY_VM_EXEC_CONTROL,
					      MSR_IA32_VMX_PROCBASED_CTLS3);


>  	}
>  
> -	min = VM_EXIT_SAVE_DEBUG_CONTROLS | VM_EXIT_ACK_INTR_ON_EXIT;
> -#ifdef CONFIG_X86_64
> -	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
> -#endif
> -	opt = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> -	      VM_EXIT_LOAD_IA32_PAT |
> -	      VM_EXIT_LOAD_IA32_EFER |
> -	      VM_EXIT_CLEAR_BNDCFGS |
> -	      VM_EXIT_PT_CONCEAL_PIP |
> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
> -	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
> +	if (adjust_vmx_controls(KVM_REQ_VMX_VM_EXIT_CONTROLS,

I think we should spell out REQUIRED and OPTIONAL, almost all of the usage puts
them on their own lines, i.e. longer names doesn't change much.  "OPT" is fine,
but "REQ" already means "REQUEST" in KVM, i.e. I mentally read this as
"KVM requested controls", which is quite different from "KVM required controls".

> +				KVM_OPT_VMX_VM_EXIT_CONTROLS,
> +				MSR_IA32_VMX_EXIT_CTLS,
>  				&_vmexit_control) < 0)
>  		return -EIO;
>  
> -	min = PIN_BASED_EXT_INTR_MASK | PIN_BASED_NMI_EXITING;
> -	opt = PIN_BASED_VIRTUAL_NMIS | PIN_BASED_POSTED_INTR |
> -		 PIN_BASED_VMX_PREEMPTION_TIMER;
> -	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PINBASED_CTLS,
> +	if (adjust_vmx_controls(KVM_REQ_VMX_PIN_BASED_VM_EXEC_CONTROL,
> +				KVM_OPT_VMX_PIN_BASED_VM_EXEC_CONTROL,
> +				MSR_IA32_VMX_PINBASED_CTLS,
>  				&_pin_based_exec_control) < 0)

I vote to opportunistically (or in a prep patch) drop the silly "< 0" check, it's
pointless and makes the code unnecessarily difficult to follow.

And at that point, I also think it makes sense to move the pointer passing to the
same line as the MSR definition, even if one or two lines run a bit long:

	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS,
				KVM_OPTIONAL_VMX_VM_ENTRY_CONTROLS,
				MSR_IA32_VMX_ENTRY_CTLS, &_vmentry_control))

> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 286c88e285ea..89eaab3495a6 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -467,6 +467,113 @@ static inline u8 vmx_get_rvi(void)
>  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
>  }
>  
> +#define __KVM_REQ_VMX_VM_ENTRY_CONTROLS				\
> +	(VM_ENTRY_LOAD_DEBUG_CONTROLS)
> +#ifdef CONFIG_X86_64
> +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> +		(__KVM_REQ_VMX_VM_ENTRY_CONTROLS |		\
> +		VM_ENTRY_IA32E_MODE)

Align indentation (more obvious below).

> +#else
> +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> +		__KVM_REQ_VMX_VM_ENTRY_CONTROLS
> +#endif
> +#define KVM_OPT_VMX_VM_ENTRY_CONTROLS				\
> +	(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |			\
> +	VM_ENTRY_LOAD_IA32_PAT |				\
> +	VM_ENTRY_LOAD_IA32_EFER |				\
> +	VM_ENTRY_LOAD_BNDCFGS |					\
> +	VM_ENTRY_PT_CONCEAL_PIP |				\
> +	VM_ENTRY_LOAD_IA32_RTIT_CTL)

Align inside the paranthesis so that the control names all line up (goes for
everything in this file).

#define KVM_OPT_VMX_VM_ENTRY_CONTROLS				\
	(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |			\
	 VM_ENTRY_LOAD_IA32_PAT |				\
	 VM_ENTRY_LOAD_IA32_EFER |				\
	 VM_ENTRY_LOAD_BNDCFGS |				\
	 VM_ENTRY_PT_CONCEAL_PIP |				\
	 VM_ENTRY_LOAD_IA32_RTIT_CTL)

> +#define KVM_REQ_VMX_TERTIARY_VM_EXEC_CONTROL 0
> +#define KVM_OPT_VMX_TERTIARY_VM_EXEC_CONTROL			\
> +	(TERTIARY_EXEC_IPI_VIRT)
> +
>  #define BUILD_CONTROLS_SHADOW(lname, uname, bits)				\
>  static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)	\
>  {										\
> @@ -485,10 +592,12 @@ static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
>  }										\
>  static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\

I suspect these need to be __always_inline, otherwise various sanitizers might
cause these to be out of line and break the build due to @val not being a
compile-time constant.

>  {										\
> +	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
>  	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
>  }										\
>  static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
>  {										\
> +	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname | KVM_OPT_VMX_##uname)));	\
>  	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
>  }
>  BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
> -- 
> 2.35.3
> 
