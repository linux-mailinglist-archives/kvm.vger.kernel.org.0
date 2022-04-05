Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485544F49B4
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444347AbiDEWVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450796AbiDEPwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:52:10 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE456262;
        Tue,  5 Apr 2022 07:43:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p26-20020a05600c1d9a00b0038ccbff1951so1399892wms.1;
        Tue, 05 Apr 2022 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1mH+YSU50fajcvK1QNZ8qQyJ60qjkNCXhuT3a6pQSAs=;
        b=dltkjXVB9Tl6/EfD0+STBcgxcVKiIwbPMdp6xBZ1L7eR30tp6KCooqhhNUqCzubXXL
         jOn35Yz8NwUy5wRAjj3u174P0gayVAu/KowJOr1sVrtp2RH67Lj8sU/aqWsQ67PzTqV5
         OzK6ODu2jV/DY97GmbBnnTBYEIx7xbyEbvUKt5YDYmBqnjuh4DY6y65j7roSZGZCD5tT
         nRK4JJfAqAIeFGfeMAnibNrbaZY2A4ecnXZ4RyjlChCXHfRZM2vT3Ax2fZZ+w9KsztA+
         pyr81udTeSjugi9UqC6jyGVq3XyULYSsxu8q7i4UcDhOjILBCk/4+gVgR2fEIncR402O
         yypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1mH+YSU50fajcvK1QNZ8qQyJ60qjkNCXhuT3a6pQSAs=;
        b=vRhGnJQqLihIfiJY3r2Sl06D7uNXqTXT88KKsNBmXZRs21Q8Y14y7Yv/XwalW8QHAH
         EjLZK/c0UZKSwe9dqSNXQeiT4r9v7aZmNX1bdshwpy/LEHRPayvltad/IZQ6CSRXQy3n
         LChIJdjGMrWuEc1TGbMGu4AwtNPStj+d3QRY0T+hHO8kSGVtXUihr7EYvptDkvTVeq5B
         eV5SmhYHfARbQiu2TV1FQGqXV8oAKnu6iRV8kMpC4HUaw1JUUTsy6I7+7vXzOhNcuX34
         OGw8uC5iJAe6wzrGCw7HiFddqmMz6kg35pZn4NlLqgdo3Zajk64c0GK3B/sTkaRITmPs
         mqjQ==
X-Gm-Message-State: AOAM532FinHgaNW6AfhOKQsPstSowkvX84wJmISOX/VBpv9BsJznaTzq
        CVluwyrGZDQsgXxp9Qer+qw=
X-Google-Smtp-Source: ABdhPJz5SRm0qxdvpeISG/S9S14QGfwdgdB9fmKtitopVWQqz5GnXYublw/ecA1THWklDgvL1x48ag==
X-Received: by 2002:a7b:ce0a:0:b0:38e:761a:1c76 with SMTP id m10-20020a7bce0a000000b0038e761a1c76mr3472870wmc.198.1649169824612;
        Tue, 05 Apr 2022 07:43:44 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id 3-20020a05600c248300b0038e7e94bbc2sm2399857wms.3.2022.04.05.07.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:43:44 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <71005293-95cd-ec52-83f4-d93947d16af0@redhat.com>
Date:   Tue, 5 Apr 2022 16:43:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 040/104] KVM: VMX: Split out guts of EPT violation
 to common/exposed function
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d7ea79b7fbebf723540672bd027d48158fcde0ff.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d7ea79b7fbebf723540672bd027d48158fcde0ff.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The difference of TDX EPT violation is how to retrieve information, GPA,
> and exit qualification.  To share the code to handle EPT violation, split
> out the guts of EPT violation handler so that VMX/TDX exit handler can call
> it after retrieving GPA and exit qualification.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/common.h | 35 +++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c    | 34 ++++++----------------------------
>   2 files changed, 41 insertions(+), 28 deletions(-)
>   create mode 100644 arch/x86/kvm/vmx/common.h
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> new file mode 100644
> index 000000000000..1052b3c93eb8
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_X86_VMX_COMMON_H
> +#define __KVM_X86_VMX_COMMON_H
> +
> +#include <linux/kvm_host.h>
> +
> +#include "mmu.h"
> +
> +static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					     unsigned long exit_qualification)
> +{
> +	u64 error_code;
> +
> +	/* Is it a read fault? */
> +	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> +		     ? PFERR_USER_MASK : 0;
> +	/* Is it a write fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> +		      ? PFERR_WRITE_MASK : 0;
> +	/* Is it a fetch fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> +		      ? PFERR_FETCH_MASK : 0;
> +	/* ept page table entry is present? */
> +	error_code |= (exit_qualification &
> +		       (EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |
> +			EPT_VIOLATION_EXECUTABLE))
> +		      ? PFERR_PRESENT_MASK : 0;
> +
> +	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> +	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> +
> +	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +}
> +
> +#endif /* __KVM_X86_VMX_COMMON_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7838cd177f0e..0edeeed0b4c8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -50,6 +50,7 @@
>   #include <asm/vmx.h>
>   
>   #include "capabilities.h"
> +#include "common.h"
>   #include "cpuid.h"
>   #include "evmcs.h"
>   #include "hyperv.h"
> @@ -5381,11 +5382,10 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
>   
>   static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   {
> -	unsigned long exit_qualification;
> -	gpa_t gpa;
> -	u64 error_code;
> +	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
> +	gpa_t gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>   
> -	exit_qualification = vmx_get_exit_qual(vcpu);
> +	trace_kvm_page_fault(gpa, exit_qualification);
>   
>   	/*
>   	 * EPT violation happened while executing iret from NMI,
> @@ -5394,31 +5394,9 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   	 * AAK134, BY25.
>   	 */
>   	if (!(to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
> -			enable_vnmi &&
> -			(exit_qualification & INTR_INFO_UNBLOCK_NMI))
> +	    enable_vnmi && (exit_qualification & INTR_INFO_UNBLOCK_NMI))
>   		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO, GUEST_INTR_STATE_NMI);
>   
> -	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> -	trace_kvm_page_fault(gpa, exit_qualification);
> -
> -	/* Is it a read fault? */
> -	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> -		     ? PFERR_USER_MASK : 0;
> -	/* Is it a write fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> -		      ? PFERR_WRITE_MASK : 0;
> -	/* Is it a fetch fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> -		      ? PFERR_FETCH_MASK : 0;
> -	/* ept page table entry is present? */
> -	error_code |= (exit_qualification &
> -		       (EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |
> -			EPT_VIOLATION_EXECUTABLE))
> -		      ? PFERR_PRESENT_MASK : 0;
> -
> -	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> -	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> -
>   	vcpu->arch.exit_qualification = exit_qualification;
>   
>   	/*
> @@ -5432,7 +5410,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
>   		return kvm_emulate_instruction(vcpu, 0);
>   
> -	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
>   }
>   
>   static int handle_ept_misconfig(struct kvm_vcpu *vcpu)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
