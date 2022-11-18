Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C643462FBE2
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 18:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiKRRom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 12:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiKRRok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 12:44:40 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83DA30F59
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:44:39 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b29so5514935pfp.13
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nArehU+M3JvjBQMdLR3MkhWwl9kcg6nFoz5gcIdq8kE=;
        b=AJca8AstvwdRRkP1srRFlRaPBpzypHw8skgW7f8bNMatvp8svOlFc5rCnpPMyeFAu+
         1/rvqCTFynexUfBUicBJcJOC6H1CZDeuWNiPY8kzV1WSlZFBRjcMErop2+JrLAtvg1DF
         aKG5zdmUfzjjLZbj0g18wlANBPod7aT5N/RF6f4FW98GrUzU7icRn5Sz/7yzmJ2raR27
         yrJsXHI+rDfM1Ry2minZqoQs85Is74E+PADC3+rx+tkkrtXIXjalfKx+fvKTsEdWtgbq
         4oV3qRJonSGXNPO+QrVxhnInnqt0BmuMec0nhqlL4F5qwORlQ9L/CaPiz/pU5tfk8xu9
         xdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nArehU+M3JvjBQMdLR3MkhWwl9kcg6nFoz5gcIdq8kE=;
        b=RorwNkGkuAKlUc0H6FzunXPR6MhPeIYrI5gnOciPAA7bZtJ+YaPHkeyJmbuuwmGy8E
         g7fAuR+xWQKM1/ZP7kMBDs8lLErUBT4tcyurl/3uLKkR/9SGgj6FGxVimM61ZFp2GK0H
         X8amYuSk1wvZZUamgLSZKrMQ5FiM0+kNn7zsXwXMagLLQhNEcAjeUpJPYKXE4855Bw9g
         X/VvntMjDXw1+h1qZd26IUVqZhKRH03fn9jBsVoHN5uuGGuWZ2jwtAmsbg2Lrypjc/R/
         lHk+B5hiRN0p6mYR12fS7c2+RyXCXTI7WYeTP2A2e9NRMpd2g48JKIH+5crAw6l53Aj7
         Y02g==
X-Gm-Message-State: ANoB5pkuiGt1wfH6tWpSrdjgs+OCY8gHG3dveclpQYLQr146lL/jYlGq
        hdFM02Sj1PlgNn7DC6czhV8zvg==
X-Google-Smtp-Source: AA0mqf7gyEVm/lIvuTjTM0XanOw0gnpUP2EsrJLFSLzMo9IOee6S/iHkyQ0EtRQ8Unb8HSLYW0d9kQ==
X-Received: by 2002:a63:4d0d:0:b0:477:14ea:cee6 with SMTP id a13-20020a634d0d000000b0047714eacee6mr6045535pgb.303.1668793479252;
        Fri, 18 Nov 2022 09:44:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g8-20020aa79f08000000b0056bc5ad4862sm3456021pfr.28.2022.11.18.09.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:44:38 -0800 (PST)
Date:   Fri, 18 Nov 2022 17:44:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm, vmx: don't use "unsigned long" in
 vmx_vcpu_enter_exit()
Message-ID: <Y3fEg/0PcgJi7mWd@google.com>
References: <Y3e7UW0WNV2AZmsZ@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3e7UW0WNV2AZmsZ@p183>
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

Nit (because I really suck at case-insensitive searches), please capitalize
"KVM: VMX:" in the shortlog.

On Fri, Nov 18, 2022, Alexey Dobriyan wrote:
> __vmx_vcpu_run_flags() returns "unsigned int" and uses only 2 bits of it
> so using "unsigned long" is very much pointless.

And __vmx_vcpu_run() and vmx_spec_ctrl_restore_host() take an "unsigned int" as
well, i.e. actually relying on an "unsigned long" value won't actually work.

On a related topic, this code in __vmx_vcpu_run() is unnecessarily fragile as it
relies on VMX_RUN_VMRESUME being in bits 0-7.

	/* Copy @flags to BL, _ASM_ARG3 is volatile. */
	mov %_ASM_ARG3, %bl

	...

	/* Check if vmlaunch or vmresume is needed */
	testb $VMX_RUN_VMRESUME, %bl

The "byte" logic is another holdover, from when "flags" was just "launched" and
was passed in as a boolean.  I'll send a proper patch to do:

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 0b5db4de4d09..5bd39f63497d 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -69,8 +69,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
         */
        push %_ASM_ARG2
 
-       /* Copy @flags to BL, _ASM_ARG3 is volatile. */
-       mov %_ASM_ARG3B, %bl
+       /* Copy @flags to EBX, _ASM_ARG3 is volatile. */
+       mov %_ASM_ARG3L, %ebx
 
        lea (%_ASM_SP), %_ASM_ARG2
        call vmx_update_host_rsp
@@ -106,7 +106,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
        mov (%_ASM_SP), %_ASM_AX
 
        /* Check if vmlaunch or vmresume is needed */
-       testb $VMX_RUN_VMRESUME, %bl
+       test $VMX_RUN_VMRESUME, %ebx
 
        /* Load guest registers.  Don't clobber flags. */
        mov VCPU_RCX(%_ASM_AX), %_ASM_CX
@@ -128,7 +128,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
        /* Load guest RAX.  This kills the @regs pointer! */
        mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
-       /* Check EFLAGS.ZF from 'testb' above */
+       /* Check EFLAGS.ZF from 'test VMX_RUN_VMRESUME' above */
        jz .Lvmlaunch
 
        /*


> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
