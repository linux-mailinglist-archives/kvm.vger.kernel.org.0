Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B3A33C9FC
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhCOXhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhCOXhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:37:34 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E78BC06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:37:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u18so16055417plc.12
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m5DKET+zhD2D4Fd/Hccb3C70vrkwKJbqddmWptN5Rcg=;
        b=CcBIATws8iJMUNgDgLzeoUqd5qjalBXpH3OfRKHqPAmMCK2yg7SfBN4sTLiu5GNTA5
         pOZt2vwdaHNnRTMZvRoY6xhc036l2aOZoYx74+eHMoHlne0CYUQ35Rz8fN2nqz8C5qqk
         472Zdw6e9uPIq27nr4qLk8X4jRXw8L1lID86G8q32ZGVUlG7qKUS97quQn0Dhwg+Ympf
         pqt8biCTL8lGuq1qKYdc++NHG8743QNzLPCu/fplbhtvrh5kiL4pLfR//d2Xn8QeDU2h
         zhmNC7w+PtuvJk98I22AClyO/cqGn5Z4dryqbWUe2bHptxIefXYnQRtWTQ+L+87lS32V
         Wj7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m5DKET+zhD2D4Fd/Hccb3C70vrkwKJbqddmWptN5Rcg=;
        b=UFkXIQeyq6gjxfL46FQyhGsASO/hMLp5RvfK10azgcvyigj5+kmk4CWFg1EkkTsGaG
         d0lc7zuy6HMqq44XIil+pghtbGI8EwiOiE8FnRijd7zhu7cIPVOVx2pKTYj/QOYK8q8f
         e63xvyOnBb+IZ9xO/lkLLOJ+TV7q+8dASGr7HCWjd8PuLa1zAejp/5Twe5PqwcBswlGg
         kPt1SqPg/2aeAnb67DeuWW49kApmU1WoqhlJqQPfLhBCexG1HW5sFNy11+lGtqmAGgE7
         cpYBCEvDFi7E0kWwAvpg9gB+B0ZFU5Yskv8CG412J/JNyhtfkK0d5SijRF5RHfic+GtR
         SJ0A==
X-Gm-Message-State: AOAM530sTr4Ye2u7UcDj8RV17BC2kLouo1SkdzRoJGfrHwoiuZ4yHd5S
        k6FiTSfz6X2scXavqBH412toBlsfWma6aA==
X-Google-Smtp-Source: ABdhPJyeOCb//22JJMMlmKYoWfd71Qf5DD7ZghvVWV8EJaoAT8g47yxOwBOQkv7MaJieupA2dD4L1A==
X-Received: by 2002:a17:90b:1953:: with SMTP id nk19mr1648941pjb.28.1615851452764;
        Mon, 15 Mar 2021 16:37:32 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:3d60:4c70:d756:da57])
        by smtp.gmail.com with ESMTPSA id z11sm14734939pgj.22.2021.03.15.16.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 16:37:32 -0700 (PDT)
Date:   Mon, 15 Mar 2021 16:37:25 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts while
 single stepping
Message-ID: <YE/vtYYwMakERzTS@google.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315221020.661693-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021, Maxim Levitsky wrote:
> This change greatly helps with two issues:
> 
> * Resuming from a breakpoint is much more reliable.
> 
>   When resuming execution from a breakpoint, with interrupts enabled, more often
>   than not, KVM would inject an interrupt and make the CPU jump immediately to
>   the interrupt handler and eventually return to the breakpoint, to trigger it
>   again.
> 
>   From the user point of view it looks like the CPU never executed a
>   single instruction and in some cases that can even prevent forward progress,
>   for example, when the breakpoint is placed by an automated script
>   (e.g lx-symbols), which does something in response to the breakpoint and then
>   continues the guest automatically.
>   If the script execution takes enough time for another interrupt to arrive,
>   the guest will be stuck on the same breakpoint RIP forever.
> 
> * Normal single stepping is much more predictable, since it won't land the
>   debugger into an interrupt handler, so it is much more usable.
> 
>   (If entry to an interrupt handler is desired, the user can still place a
>   breakpoint at it and resume the guest, which won't activate this workaround
>   and let the gdb still stop at the interrupt handler)
> 
> Since this change is only active when guest is debugged, it won't affect
> KVM running normal 'production' VMs.
> 
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a9d95f90a0487..b75d990fcf12b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8458,6 +8458,12 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>  		can_inject = false;
>  	}
>  
> +	/*
> +	 * Don't inject interrupts while single stepping to make guest debug easier
> +	 */
> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
> +		return;

Is this something userspace can deal with?  E.g. disable IRQs and/or set NMI
blocking at the start of single-stepping, unwind at the end?  Deviating this far
from architectural behavior will end in tears at some point.

> +
>  	/*
>  	 * Finally, inject interrupt events.  If an event cannot be injected
>  	 * due to architectural conditions (e.g. IF=0) a window-open exit
> -- 
> 2.26.2
> 
