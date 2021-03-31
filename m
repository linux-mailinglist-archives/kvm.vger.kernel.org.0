Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444973505FE
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhCaSHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 14:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbhCaSHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 14:07:30 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31CC061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 11:07:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so1693747pjb.0
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 11:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fzUxfJHs4m96o0h93XY6hLbrWDklPfvA/cxbRjLDuiE=;
        b=AW9hN1Djcg4K3j6y1d6rLhacaldp5/qFhVVlaCM4Y4E4DJEIsgt2V+ZwiR2/a+Dazb
         1JRokka2xSlR+ur/y4YTI5lunennSWPSD6CCusxkJwPorqyEwKEiZHy3jxOSbXjsIztY
         CL2ZvlWfAFL4bxmN1KzcCzGxE72CVrjbkQA36b76+r7MAKX2GuYTIg4fHXGUizObFMGr
         qh2q7GOSLeDC8hiM1lbp5K+V3Pr6tbnPU6z460UOE0JuPs6kxAj1rLgbjpxzYV18kUlX
         62h2/pIh85HeBtJv5VaQXUJ3OYSnMML6O9vO1R/AkJUgrjd3zbEdDT4qVPfZstkbhIb0
         7nwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fzUxfJHs4m96o0h93XY6hLbrWDklPfvA/cxbRjLDuiE=;
        b=QUQypZCrfIsY0Ae/wiZokLokWlMW3XjVZ5ELGR2C/JapTpM/PGW9l9Z8A6fGcpYCb8
         t6/G8SN7acsSWRgqykHx+kYH7kLgU5RQ44ryhsWvvzmOFRXXJG5a1NVPlr43jIdgUocL
         JK4lgkQuNYgJBAumtFyMr6LchvEuIUDOaQCib7Twc2V2BuQ5UtnYOiQO8Tinmy+WHe29
         p0vLohCJvkLPhFC5g8bPxa2voJtmURIVxFacNTRUN73s3+dCVmoxOTOx33c0nth0Ac2t
         4/wrj7jdV8QyDL7EFO/1inDHfAlmkObBDEa969aP/g1tpPS8mYo/r/hSiNR2Y4HJS2QR
         cAkA==
X-Gm-Message-State: AOAM5330OW58PvRMquhusG0DFtf3uF412mywoseccDxSlQWmcYfjvr8z
        pUlP3TjEsWv6CcC7HPsG+0EI+A==
X-Google-Smtp-Source: ABdhPJwVLzSBQTNx4xs+d36/l5KaNndW79U3YjxOAWpxY+JuSKFrSViByfpBlr1uaqpRCR1PsNJC3A==
X-Received: by 2002:a17:90a:8b16:: with SMTP id y22mr4558382pjn.191.1617214049909;
        Wed, 31 Mar 2021 11:07:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e1sm2979522pfi.175.2021.03.31.11.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 11:07:29 -0700 (PDT)
Date:   Wed, 31 Mar 2021 18:07:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix potential memory access error
Message-ID: <YGS6XS87HYJdVPFQ@google.com>
References: <1617182122-112315-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617182122-112315-1-git-send-email-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Yang Li wrote:
> Using __set_bit() to set a bit in an integer is not a good idea, since
> the function expects an unsigned long as argument, which can be 64bit wide.
> Coverity reports this problem as
> 
> High:Out-of-bounds access(INCOMPATIBLE_CAST)
> CWE119: Out-of-bounds access to a scalar
> Pointer "&vcpu->arch.regs_avail" points to an object whose effective
> type is "unsigned int" (32 bits, unsigned) but is dereferenced as a
> wider "unsigned long" (64 bits, unsigned). This may lead to memory
> corruption.
> 
> /home/heyuan.shy/git-repo/linux/arch/x86/kvm/kvm_cache_regs.h:
> kvm_register_is_available
> 
> Just use BIT instead.

Meh, we're hosed either way.  Using BIT() will either result in undefined
behavior due to SHL shifting beyond the size of a u64, or setting random bits
if the truncated shift ends up being less than 63.

I suppose one could argue that undefined behavior is better than memory
corruption, but KVM is very broken if 'reg' is out-of-bounds so IMO it's not
worth changing.  There are only two call sites that don't use a hardcoded value,
and both are guarded by WARN.  kvm_register_write() bails without calling
kvm_register_mark_dirty(), so that's guaranteed safe.  vmx_cache_reg() WARNs
after kvm_register_mark_available(), but except for kvm_register_read(), all
calls to vmx_cache_reg() use a hardcoded value, and kvm_register_read() also
WARNs and bails.

Note, all of the above holds true for kvm_register_is_{available,dirty}(), too.

So in the current code, it's impossible for this to be a problem.  Theoretically
future code could introduce bugs, but IMO we should never accept code that uses
a non-hardcoded 'reg' and doesn't pre-validate.

The number of uops is basically a wash because "BTS <reg>, <mem>" is fairly
expensive; depending on the uarch, the difference is ~1-2 uops in favor of BIT().
On the flip side, __set_bit() shaves 8 bytes.  Of course, none these flows are
anywhere near that senstive.

TL;DR: I'm not opposed to using BIT(), I just don't see the point.


__set_bit():
   0x00000000000104e6 <+6>:	mov    %esi,%eax
   0x00000000000104e8 <+8>:	mov    %rdi,%rbp
   0x00000000000104eb <+11>:	sub    $0x8,%rsp
   0x00000000000104ef <+15>:	bts    %rax,0x2a0(%rdi)

|= BIT():
   0x0000000000010556 <+6>:	mov    %esi,%ecx
   0x0000000000010558 <+8>:	mov    $0x1,%eax
   0x000000000001055d <+13>:	mov    %rdi,%rbp
   0x0000000000010560 <+16>:	sub    $0x8,%rsp
   0x0000000000010564 <+20>:	shl    %cl,%rax
   0x0000000000010567 <+23>:	or     %eax,0x2a0(%rdi)

> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 2e11da2..cfa45d88 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -52,14 +52,14 @@ static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
>  static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
>  					       enum kvm_reg reg)
>  {
> -	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +	vcpu->arch.regs_avail |= BIT(reg);
>  }
>  
>  static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>  					   enum kvm_reg reg)
>  {
> -	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> -	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> +	vcpu->arch.regs_avail |= BIT(reg);
> +	vcpu->arch.regs_dirty |= BIT(reg);
>  }
>  
>  static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
> -- 
> 1.8.3.1
> 
