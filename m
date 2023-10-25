Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EE87D6416
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 09:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbjJYHw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 03:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbjJYHwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 03:52:55 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879CE99
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 00:52:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-32d9b507b00so3855473f8f.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 00:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1698220372; x=1698825172; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :content-language:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EvDbK3AJ3DIdy4tdTmUriG4VrugsDy7JcPbRZPmtYB4=;
        b=oFGKwZ8a4elkockZeAI0+Ny8+b1o+2iwfOrpH9GcTi0e/4wFY2OeAW6BC7qiwJRyeK
         xgsqADjqghiAPcGsjxYRWZpigLFT36XQZPMxlftWNtJCOThEYB2SaQU2SXp6c7EstvsJ
         DiObnfJ8Y+GMBQ6SqlUlIBRaBTHrOZi099mic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698220372; x=1698825172;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :content-language:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvDbK3AJ3DIdy4tdTmUriG4VrugsDy7JcPbRZPmtYB4=;
        b=mzotbgpEUeyGIsEZqxjX2ENlXTMX3sFpYMNTrP++ziOPKPfcCz8z268uwyuX/1NPdN
         a8hzItW46tBXW9bu8uhJKqT4/b6Y6+VhlZzfQ5YqfykOajz/cJnjVUVfkCIt2kfE+f9L
         OtnQD9sc9ySWljbL7CtieCuA1dq9k9k85n4Yb9wesNcayZBBZxD/FYtI1jv7bigKFPbH
         lQTg1EA7j8dWlzerEontJFk/AOWfkr3xIEO17gLZ64/pFi+9DGXRTs08/3b9qNWSt5kS
         j/ZwcCUL9L1mdLK/b+EKOIGQXrrtNhJyO9y2+AEkI2jEpSWNxy5QQ1y09FP7uToyNq4f
         hdNQ==
X-Gm-Message-State: AOJu0Yw/R9GeUhQmODbaDE7zNZpB/UMHuEhOouJuSnP4luicpti9uxj7
        PzrRVAEZYCTE72WGrvyc3fFpAA==
X-Google-Smtp-Source: AGHT+IHQ9MicPffqRdlPjnVY2P4UrG8OLUiDpChIRL+8PB7v6WFNlNtI6KSlLtziVC46aIw9hM3NPw==
X-Received: by 2002:a05:6000:10f:b0:32d:7efc:7e1f with SMTP id o15-20020a056000010f00b0032d7efc7e1fmr9028332wrx.71.1698220371961;
        Wed, 25 Oct 2023 00:52:51 -0700 (PDT)
Received: from [192.168.1.10] (host-92-26-107-252.as13285.net. [92.26.107.252])
        by smtp.gmail.com with ESMTPSA id o15-20020adfcf0f000000b00327de0173f6sm11432651wrj.115.2023.10.25.00.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 00:52:51 -0700 (PDT)
Message-ID: <654468cf-1563-4c1c-8c7c-076bc6dfbabf@citrix.com>
Date:   Wed, 25 Oct 2023 08:52:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [RESEND][PATCH 1/6] x86/bugs: Add asm helpers for executing VERW
Content-Language: en-GB
To:     Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-1-cff54096326d@linux.intel.com>
 <f620c7d4-6345-4ad0-8a45-c8089e3c34df@citrix.com>
 <20231025062818.7kaerqklaut7dg5r@desk>
 <20231025072255.GA37471@noisy.programming.kicks-ass.net>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20231025072255.GA37471@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 8:22 am, Peter Zijlstra wrote:
> On Tue, Oct 24, 2023 at 11:28:18PM -0700, Pawan Gupta wrote:
>
>> With .text.entry section I am getting getting below warnings and an
>> error:
>>
>> -----------------------------------------------------------------
>>     LD      vmlinux.o
>>   vmlinux.o: warning: objtool: .text.entry+0x0: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x40: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x80: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0xc0: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x100: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x140: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x180: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x1c0: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x200: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x240: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x280: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x2c0: unreachable instruction
>>   vmlinux.o: warning: objtool: .text.entry+0x300: unreachable instruction
>>   vmlinux.o: warning: objtool: .altinstr_replacement+0x2c: relocation to !ENDBR: .text.entry+0x0
>>   vmlinux.o: warning: objtool: .altinstr_replacement+0x1c4: relocation to !ENDBR: .text.entry+0x0
>>   vmlinux.o: warning: objtool: .altinstr_replacement+0x1d0: relocation to !ENDBR: .text.entry+0x0
>>   vmlinux.o: warning: objtool: .altinstr_replacement+0x2d2: relocation to !ENDBR: .text.entry+0x80
>>   vmlinux.o: warning: objtool: .altinstr_replacement+0x5d5: relocation to !ENDBR: .text.entry+0xc0
>>     OBJCOPY modules.builtin.modinfo
>>     GEN     modules.builtin
>>     MODPOST vmlinux.symvers
>>     UPD     include/generated/utsversion.h
>>     CC      init/version-timestamp.o
>>     LD      .tmp_vmlinux.kallsyms1
>>   ld: error: unplaced orphan section `.text.entry' from `vmlinux.o'
>>   make[2]: *** [scripts/Makefile.vmlinux:36: vmlinux] Error 1
>> -----------------------------------------------------------------
>>
>> ... because my config has CONFIG_LD_ORPHAN_WARN_LEVEL="error" and
>> objtool needs to be told about this entry.
>>
>> Do you think its worth fighting these warnings and error, or simply use
>> .rodata section for verw memory operand?
> I'm thinking you need to at the very least stay in a section that's
> actually still mapped with PTI :-)

Sorry.  Xen and Linux have this section named opposite ways around.

> diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
> index bfb7bcb362bc..9eb2b532c92a 100644
> --- a/arch/x86/entry/entry.S
> +++ b/arch/x86/entry/entry.S
> @@ -20,3 +22,16 @@ SYM_FUNC_END(entry_ibpb)
>  EXPORT_SYMBOL_GPL(entry_ibpb);
>  
>  .popsection
> +
> +.pushsection .entry.text, "ax"
> +
> +.align 64
> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> +	UNWIND_HINT_UNDEFINED
> +	ANNOTATE_NOENDBR
> +1:
> +	.word __KERNEL_DS
> +	.skip 64 - (. - 1b), 0xcc

The 1 label aliases mds_verw_sel and this must remain like this for the
construct to work.

So instead of .skip, why not simply .align 64, 0xcc and get rid of the
1: label?

Do we have a suitably named constant cacheline size, rather than
opencoding 64?

> +SYM_CODE_END(mds_verw_sel);

Given that KVM needs it, this probably needs an EXPORT_SYMBOL_GPL() on it.

~Andrew
