Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D97948C8A9
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 17:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355308AbiALQns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 11:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355279AbiALQno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 11:43:44 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C53C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 08:43:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e19so4769997plc.10
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 08:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7HY/A3WF60nW71TdnAHYrS3juf7M65B+H87+XUw+C30=;
        b=QMCqfuAwStH9iKuO7cRVqTzfdew0zzoOhm+YfJcUFQ/Kj0/75HBkxGtPaMYmxJv510
         8B3OPmstSVJnHsnfjVQbqjCxy2FwX40bZxiijBJLAqJzzdRTiNW4mzRWF2S4Fv8EfVD8
         3HmeUhGdcCJd3v2JpfhihUOx9Et5wjCnyGmKrrGAfR5O2UJNd9lcEAPagRHrfcLkL1XM
         JRn1RF8Gkw0N0TiSbe5B3B/lrmQCdaRXuLYYDR02dj83wUjgXMRdHtEfYiXH7NY9CbB3
         J1pZx0jsBmobRWf0QSDHwJmI6WtRrh8kTFlMK2Ou5efqw5eJH7wjkPo9dfLZj17UzXHA
         mknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7HY/A3WF60nW71TdnAHYrS3juf7M65B+H87+XUw+C30=;
        b=IwN2zQ4sYW2rmVKcBPlnlyXDZM+dAFWa45CQ260gvKfII1Wnj5oE9RQB5DgAPj38K3
         FseURIm4MlTBtrDdnAh3ZsykIHuO2GpwYToh6HoAjXYm/1CVVhLvcIlRNqOGyDp3aLrs
         HSSdwIb8LECW4PhZluIxiZrxTuHgBmBfFRm7KGmby0TIAv3h1IkJe+Kl4v3yugvrFXna
         613pboKFogwrePpVZKKixmDIpHVtsoCPGY2KNTuZfIsKgMcylyzw3j010C/i4Hkmv3pA
         q8i8XRnwbG1M86VkimlVfMtrPrAG2V943YkW3zrP+3GXhJ133x9pswA5AgbJmvVn/utu
         p84A==
X-Gm-Message-State: AOAM530Jtf/zxSz9vOn2J76vI0zGPUmaaffvgZ6wHnp0ttm1sTsmOR2v
        sYOqC87L/cyo3VjQegjSVMLleA==
X-Google-Smtp-Source: ABdhPJzOMMwpcVznIlF0eRQrinhUp11uNTvK9xu2egQB6XQklVzzl2o20R1IPYhsLQzhfykwaK754w==
X-Received: by 2002:a17:902:e541:b0:14a:59cc:3095 with SMTP id n1-20020a170902e54100b0014a59cc3095mr435290plf.151.1642005823475;
        Wed, 12 Jan 2022 08:43:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x26sm141796pfh.192.2022.01.12.08.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 08:43:42 -0800 (PST)
Date:   Wed, 12 Jan 2022 16:43:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, rkrcmar@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH] KVM: x86: fix kvm_vcpu_is_preempted
Message-ID: <Yd8FO8O9AQa79sFc@google.com>
References: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Li RongQing wrote:
> After support paravirtualized TLB shootdowns, steal_time.preempted
> includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB
> 
> and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED
> 
> Fixes: 858a43aae2367 ("KVM: X86: use paravirtualized TLB Shootdown")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 59abbda..a9202d9 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1025,8 +1025,8 @@ asm(
>  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
>  "__raw_callee_save___kvm_vcpu_is_preempted:"
>  "movq	__per_cpu_offset(,%rdi,8), %rax;"
> -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> -"setne	%al;"
> +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> +"andb	$" __stringify(KVM_VCPU_PREEMPTED) ", %al;"

Eww, the existing code is sketchy.  It relies on the compiler to store _Bool/bool
in a single byte since %rax may be non-zero from the __per_cpu_offset(), and
modifying %al doesn't zero %rax[63:8].  I doubt gcc or clang use anything but a
single byte on x86-64, but "andl" is just as cheap so I don't see any harm in
being paranoid.

>  "ret;"
>  ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
>  ".popsection");
> -- 
> 2.9.4
> 
