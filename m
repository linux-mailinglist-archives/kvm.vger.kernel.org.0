Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227AF334280
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 17:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhCJQIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 11:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhCJQIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 11:08:47 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2521FC061761
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 08:08:47 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g4so11694867pgj.0
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 08:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n5SUJ6SxBX80zMdF1n9kHJvTdoHW9bhKWhAVahClOnw=;
        b=CWTtLzbpRE0V6DoYNY5ITdORUBJw8jR4RCevgqlelCN+8kUmrRzlTLdFdG4a/eMvz2
         ZrVuOTckkKqFhXKDwA1CP/ArmUcQpwL+VQlD499zZ1ZUR+pPtJZyT63QpFgeUNGjFEwr
         FQ7GRQDp/0r38umVI6oWVOHtPyGT+vGswax9+1eh97CaZ81ynX5x+JNdkTxsZLhKM50O
         1ShZYqKP38mYycHxl3jRlhy6hXAflEwBjO0IKlVRRc3eVO9hx7kemvMjmD7/PZoSDDIu
         IiefWTdhxFmCxahCznDHWM8FVVIbG0hzEUu4GGRXhBraxl2ygu6ILYeHWzuWAuqk1as3
         dvfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n5SUJ6SxBX80zMdF1n9kHJvTdoHW9bhKWhAVahClOnw=;
        b=nfhd8EoYcHHAf/bJm30enSyjB2ZPrBPtxH5Sjr+LCDNwlwro9UXRWrfonS3oQIuNIH
         VmRPd72sb5W/ODtXKKK3hxQjS5ydoWlfuq0yyVRfAw/0zijx2A/yOUWek0/kSq1yOsX/
         rHs8Kbcb01CQhiC5UskG79GsII3PQA7dqeQx5x7eM7mUHx8P+2ot9FV5u5z7HkWZ2n35
         qQnXyLq/snV/Po944nF0jabqowjCPxbLx3eIOUP9sNgqQQi+i+0sJ1b9VWXyLHf3TAM3
         r/seWWGmMwIhqX8UX8RjJOtXVGT2SRRfqdhgDK+6/hAx39e7O8YrRpDzAa7FAvz9U7sn
         WT/g==
X-Gm-Message-State: AOAM530HzXbhluPucZTUT+0zDDeH463kgXY8IHVeQmjyQQJPyTMKUDkq
        OOf4uJVGIm0DAh7eFLc6SpPIAA==
X-Google-Smtp-Source: ABdhPJy5E/rQt24yUFZtGlD2TgGJpQC3ID3/OnoSW5lGrPnU+CrQLObcNsCRohIldO+xCguGUhtUKg==
X-Received: by 2002:a63:ff53:: with SMTP id s19mr3403048pgk.347.1615392526495;
        Wed, 10 Mar 2021 08:08:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
        by smtp.gmail.com with ESMTPSA id x7sm5308pfp.23.2021.03.10.08.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 08:08:45 -0800 (PST)
Date:   Wed, 10 Mar 2021 08:08:37 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 5/7] x86/boot/compressed/64: Add CPUID sanity check to
 32-bit boot-path
Message-ID: <YEjvBfJg8P1SQt98@google.com>
References: <20210310084325.12966-1-joro@8bytes.org>
 <20210310084325.12966-6-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310084325.12966-6-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The 32-bit #VC handler has no GHCB and can only handle CPUID exit codes.
> It is needed by the early boot code to handle #VC exceptions raised in
> verify_cpu() and to get the position of the C bit.
> 
> But the CPUID information comes from the hypervisor, which is untrusted
> and might return results which trick the guest into the no-SEV boot path
> with no C bit set in the page-tables. All data written to memory would
> then be unencrypted and could leak sensitive data to the hypervisor.
> 
> Add sanity checks to the 32-bit boot #VC handler to make sure the
> hypervisor does not pretend that SEV is not enabled.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/mem_encrypt.S | 36 ++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
> index 2ca056a3707c..8941c3a8ff8a 100644
> --- a/arch/x86/boot/compressed/mem_encrypt.S
> +++ b/arch/x86/boot/compressed/mem_encrypt.S
> @@ -145,6 +145,34 @@ SYM_CODE_START(startup32_vc_handler)
>  	jnz	.Lfail
>  	movl	%edx, 0(%esp)		# Store result
>  
> +	/*
> +	 * Sanity check CPUID results from the Hypervisor. See comment in
> +	 * do_vc_no_ghcb() for more details on why this is necessary.
> +	 */
> +
> +	/* Fail if Hypervisor bit not set in CPUID[1].ECX[31] */

This check is flawed, as is the existing check in 64-bit boot.  Or I guess more
accurately, the check in get_sev_encryption_bit() is flawed.  AIUI, SEV-ES
doesn't require the hypervisor to intercept CPUID.  A malicious hypervisor can
temporarily pass-through CPUID to bypass the CPUID[1].ECX[31] check.  The
hypervisor likely has access to the guest firmware source, so it wouldn't be
difficult for the hypervisor to disable CPUID interception once it detects that
firmware is handing over control to the kernel.

> +	cmpl    $1, %ebx
> +	jne     .Lcheck_leaf
> +	btl     $31, 4(%esp)
> +	jnc     .Lfail
> +	jmp     .Ldone
> +
> +.Lcheck_leaf:
> +	/* Fail if SEV leaf not available in CPUID[0x80000000].EAX */
> +	cmpl    $0x80000000, %ebx
> +	jne     .Lcheck_sev
> +	cmpl    $0x8000001f, 12(%esp)
> +	jb      .Lfail
> +	jmp     .Ldone
> +
> +.Lcheck_sev:
> +	/* Fail if SEV bit not set in CPUID[0x8000001f].EAX[1] */
> +	cmpl    $0x8000001f, %ebx
> +	jne     .Ldone
> +	btl     $1, 12(%esp)
> +	jnc     .Lfail
> +
> +.Ldone:
>  	popl	%edx
>  	popl	%ecx
>  	popl	%ebx
> @@ -158,6 +186,14 @@ SYM_CODE_START(startup32_vc_handler)
>  
>  	iret
>  .Lfail:
> +	/* Send terminate request to Hypervisor */
> +	movl    $0x100, %eax
> +	xorl    %edx, %edx
> +	movl    $MSR_AMD64_SEV_ES_GHCB, %ecx
> +	wrmsr
> +	rep; vmmcall
> +
> +	/* If request fails, go to hlt loop */
>  	hlt
>  	jmp .Lfail
>  SYM_CODE_END(startup32_vc_handler)
> -- 
> 2.30.1
> 
