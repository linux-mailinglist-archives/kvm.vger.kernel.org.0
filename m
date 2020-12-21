Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7572DFF69
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgLUSMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgLUSMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 13:12:32 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8130C061285
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:11:51 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id g18so6800664pgk.1
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bOLplW+5pp4JzOv86AiZeqRbE94ulVTnl+pKmMDmJSY=;
        b=HFWrQ9mvEZW6tq7gtcoW2W6O1cpRXIGiH7jNwK3Ivwz/2zIGkq9l678qT9/RTsTR4+
         rItrhVmzPjQ2w0Yg+izh2swEM4bjuu8ijBXO45WGBF2ARYlueahJHDb4A/8AYANw6fvT
         Gre+GIq7Ivj8wjoeIrWS2uhywzjU2dL7uCatGwBOLNsRVtRMwr4i5CeMfRWWio1ohGYG
         f6P9Mb3+AJI2jgHOcmveCnMPmKz95m3SX6vcIxhXSwIxNDl2fi8Y3rQLho4y9vTBzvJT
         /cVTftNX5dEHmdWPo+Dg6PqABaa8slheL5lY7yXey9mUqeszVoUfSypa64MjKyjBCgmx
         kmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bOLplW+5pp4JzOv86AiZeqRbE94ulVTnl+pKmMDmJSY=;
        b=hMc48iPxg+Xh9dJ3KyQk48qr6hso0ni7NuogRo+i1Jy9sxYB66S57kw9LudwsZniXO
         D/3uUGv30jz+AWZFH4BUZRBwezQIKhBRWb6pUyeQXZA4EmYSiiXcXpYVwze0mRUCbOWg
         X1TQhhY3hxWP3jDexGrv2/uqFh2wiMftHsQBgpSCNC5WuGiDREkMjKTThV1C2cbhvUdx
         TYc4SzpuX0818IveXIAeGzL8d8prsxaG53oeLhfeyu6JZtlm5+LcTp5VRAl/aCWLrl37
         oHJg8z4DiPwNzc3ryRvAWAHgATrS5tDTnHEtPJ3YIHq71r4RFvzthZVxsvgFV7lm9dzH
         IkcA==
X-Gm-Message-State: AOAM531Ah8qeuYcr2DQf8MFX5ZwDicMg54RsuXPg/eR2uvL9ADKVonVn
        +OeBb9jey6jEgTkC78pLg4+QUClQ4wctsg==
X-Google-Smtp-Source: ABdhPJzoQsNIctzyZlXh2aS6dXgzLjXlPRuPIlOiMY/6q2NocJbmuerTxlGVGSP70Q2xmfv0qYogTw==
X-Received: by 2002:a63:2b42:: with SMTP id r63mr15934021pgr.316.1608572898493;
        Mon, 21 Dec 2020 09:48:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 82sm17865501pfv.117.2020.12.21.09.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 09:48:17 -0800 (PST)
Date:   Mon, 21 Dec 2020 09:48:10 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] KVM: SVM: Add register operand to vmsave call in
 sev_es_vcpu_load
Message-ID: <X+Df2oQczVBmwEzi@google.com>
References: <20201219063711.3526947-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219063711.3526947-1-natechancellor@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020, Nathan Chancellor wrote:
> When using LLVM's integrated assembler (LLVM_IAS=1) while building
> x86_64_defconfig + CONFIG_KVM=y + CONFIG_KVM_AMD=y, the following build
> error occurs:
> 
>  $ make LLVM=1 LLVM_IAS=1 arch/x86/kvm/svm/sev.o
>  arch/x86/kvm/svm/sev.c:2004:15: error: too few operands for instruction
>          asm volatile(__ex("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");
>                       ^
>  arch/x86/kvm/svm/sev.c:28:17: note: expanded from macro '__ex'
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>                  ^
>  ./arch/x86/include/asm/kvm_host.h:1646:10: note: expanded from macro '__kvm_handle_fault_on_reboot'
>          "666: \n\t"                                                     \
>                  ^
>  <inline asm>:2:2: note: instantiated into assembly here
>          vmsave
>          ^
>  1 error generated.
> 
> This happens because LLVM currently does not support calling vmsave
> without the fixed register operand (%rax for 64-bit and %eax for
> 32-bit). This will be fixed in LLVM 12 but the kernel currently supports
> LLVM 10.0.1 and newer so this needs to be handled.
> 
> Add the proper register using the _ASM_AX macro, which matches the
> vmsave call in vmenter.S.

There are also two instances in tools/testing/selftests/kvm/lib/x86_64/svm.c
that likely need to be fixed.
 
> Fixes: 861377730aa9 ("KVM: SVM: Provide support for SEV-ES vCPU loading")
> Link: https://reviews.llvm.org/D93524
> Link: https://github.com/ClangBuiltLinux/linux/issues/1216
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e57847ff8bd2..958370758ed0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2001,7 +2001,7 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
>  	 * of which one step is to perform a VMLOAD. Since hardware does not
>  	 * perform a VMSAVE on VMRUN, the host savearea must be updated.
>  	 */
> -	asm volatile(__ex("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");
> +	asm volatile(__ex("vmsave %%"_ASM_AX) : : "a" (__sme_page_pa(sd->save_area)) : "memory");

I vote to add a helper in svm.h to encode VMSAVE, even if there is only the one
user.  Between the rAX behavior (it _must_ be rAX) and taking the HPA of the
VMCB, the semantics of VMSAVE are just odd enough to cause a bit of head
scratching when reading the code for the first time.  E.g. something like:

void vmsave(struct page *vmcb)
{
	/*
	 * VMSAVE takes the HPA of a VMCB in rAX (hardcoded by VMSAVE itself).
	 * The _ASM_AX operand is required to specify the address size, which
	 * means VMSAVE cannot consume a 64-bit address outside of 64-bit mode.
	 */
	hpa_t vmcb_pa = __sme_page_pa(vmcb);

	BUG_ON(!IS_ENABLED(CONFIG_X86_64) && (vmcb_pa >> 32));

	asm volatile(__ex("vmsave %%"_ASM_AX) : : "a" (vmcb_pa) : "memory");
}

>  
>  	/*
>  	 * Certain MSRs are restored on VMEXIT, only save ones that aren't
> -- 
> 2.30.0.rc0
> 
