Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13296EC2B
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 23:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfGSVlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 17:41:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50950 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbfGSVlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 17:41:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so30037395wml.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 14:41:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JPnD2on9MPes546wI5hB8iJA16OLHGs/RSJMTP+xE/g=;
        b=QuiW6Iaq2CkFORbhqt9xeDkzIeLW3XlDFmUb/rlotRxd3nsovfnXs1UMzYzjyx4uTD
         RDAVNqfXmOd6/VkqlLW1h/xk7ZQ5zHGoVOj3qdcDPQhtpRI7yqqY/21g9jpoftkrL/kL
         Nw9WOUXRJeHzOJIj5Ncf1Wh0Jk6maANi1XEkYLiH9mBKQP1mq3KoeONsRuQBqI16MKc8
         1rf20MUDTRPn1s40bVYr5xMj4lON8/6EFXBWxefwkf30BTFPaMn3uADhcIqEvvFYfuIX
         4pA/5FMdd7XUx51e7OhY4R1bN5ZG7iYsn0SsZOyqpFTX3PyFyMRIqJCYA+bHbOLwxjzk
         66EQ==
X-Gm-Message-State: APjAAAU2fM/Y0UCP1uYFttweNsx8AA/xMTJgReubmC2RWKU4VodY2ZWu
        VcDiGrkM9ytSTeL7had0jqh2vLBssx8=
X-Google-Smtp-Source: APXvYqzWFOG1apvfJTpaD1HUhIGFOxEDFz5ZgU6gLi4SlZV7MzTBwfbH9+P+iHt7d6Pk/Val0bHt2g==
X-Received: by 2002:a7b:c251:: with SMTP id b17mr51176977wmj.143.1563572481866;
        Fri, 19 Jul 2019 14:41:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id j10sm50967571wrd.26.2019.07.19.14.41.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 14:41:21 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] KVM: x86: Don't check kvm_rebooting in
 __kvm_handle_fault_on_reboot()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190719204110.18306-1-sean.j.christopherson@intel.com>
 <20190719204110.18306-6-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2fe374ae-9611-1f29-32f0-e8fce126cd41@redhat.com>
Date:   Fri, 19 Jul 2019 23:41:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719204110.18306-6-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/19 22:41, Sean Christopherson wrote:
> Remove the kvm_rebooting check from VMX/SVM instruction exception fixup
> now that kvm_spurious_fault() conditions its BUG() on !kvm_rebooting.
> Because the 'cleanup_insn' functionally is also gone, deferring to
> kvm_spurious_fault() means __kvm_handle_fault_on_reboot() can eliminate
> its .fixup code entirely and have its exception table entry branch
> directly to the call to kvm_spurious_fault().
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 92c59cd923b6..a5ae5562ce0a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1511,13 +1511,7 @@ asmlinkage void kvm_spurious_fault(void);
>  	"667: \n\t"							\
>  	"call	kvm_spurious_fault \n\t"				\
>  	"668: \n\t"							\
> -	".pushsection .fixup, \"ax\" \n\t"				\
> -	"700: \n\t"							\
> -	"cmpb	$0, kvm_rebooting\n\t"					\
> -	"je	667b \n\t"						\
> -	"jmp	668b \n\t"						\
> -	".popsection \n\t"						\
> -	_ASM_EXTABLE(666b, 700b)
> +	_ASM_EXTABLE(666b, 667b)
>  
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
