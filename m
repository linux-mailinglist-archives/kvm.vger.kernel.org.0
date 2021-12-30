Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051D2481F47
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 19:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbhL3Skw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 13:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbhL3Skv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 13:40:51 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83345C061574
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 10:40:51 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so7063493pjd.1
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 10:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0dlCui6ef10a63W49l8BeTD6AlMqaA5DizmBUz4pmE0=;
        b=cCnkXzILDcBP2M9InOSjHJwJ1jEfD62+xKs/RcNbUQDWf2HXUt/AUIkduZcK9yoXHc
         JXYXD/C5t3+K2RQd8Q/ly6PI4PF/AUWQPatd3JV9p4GWme7hNZibf8u5O3w6IVy4txQD
         Z4rGuFHiD96cwkgkFkBGR26VYM0vVE04pt6GaYUOTHPQ27cMbF/c0TRPu26gBQ/FJRLO
         dsF3ZHkTsq/Hk9Vz3AArXDwy+dKYts0n/3gKE0cxyzdFDfomQenAH4kbMtiGTKuty86e
         3XKpxjsLDcHI0jPh/SFeR+K+SFBYoB/q2DG4hKMQBRbkegn8mJrPNXB6s3hD8Q+aHxlh
         43dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0dlCui6ef10a63W49l8BeTD6AlMqaA5DizmBUz4pmE0=;
        b=M/JrQ/d9/ntrGJ9c7/9jWA2JGkHTMo5huCdytlSBeeSJWMkz/bq+kdUDmOF2zEQFoA
         n6XXl0YL++fy1nLZ5D91pOBbLmiYd88KUC52SRSP5uzwopPm5bIGgWl5YM+SV4tpDubW
         4G52dobOI3Roh6K2ClELwOrHSpaigdm5BcDkZrXl+j6KtsifMEhMfHexv998A3byRLwI
         IqlwKr49yXRaCDw8xC4UC+Zwfi0/Ov/fgcQiU8Vjk7YA5AXqMAuFbr8TLAxFd3hmkJEl
         PssJ37+yASS8YZljYQ+Sw9UmtQzlOpwVShRliyEYaR00KDRBX19jtMnnl67Df3bCWqty
         4u8Q==
X-Gm-Message-State: AOAM533+l/M/X0tiBqOjDX9QNniyDHvuGY8474BvrI1yyd/axdPBpkxc
        +DQQDw+TAu85Glnrc6W5CuUVdw==
X-Google-Smtp-Source: ABdhPJw1DGaUS0160SXEiorqCYdmWgjglHDjXF9V7C0SSxlxrcLzR+TYgYTAmK0J0pGgmghC5eafuw==
X-Received: by 2002:a17:90b:3b45:: with SMTP id ot5mr37244717pjb.147.1640889650869;
        Thu, 30 Dec 2021 10:40:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j7sm28410030pfu.164.2021.12.30.10.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 10:40:50 -0800 (PST)
Date:   Thu, 30 Dec 2021 18:40:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH] x86/kvm: Allow kvm_read_and_reset_apf_flags() to be
 instrumented
Message-ID: <Yc39L/2Ltx53bP/0@google.com>
References: <20211126123145.2772-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126123145.2772-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Both VMX and SVM made mistakes of calling kvm_read_and_reset_apf_flags()
> in instrumentable code:
> 	vmx_vcpu_enter_exit()
> 		ASYNC PF induced VMEXIT
> 		save cr2
> 	leave noinstr section
> 	-- kernel #PF can happen here due to instrumentation
> 	handle_exception_nmi_irqoff
> 		kvm_read_and_reset_apf_flags()
> 
> If kernel #PF happens before handle_exception_nmi_irqoff() after leaving
> noinstr section due to instrumentation, kernel #PF handler will consume
> the incorrect apf flags and panic.
> 
> The problem might be fixed by moving kvm_read_and_reset_apf_flags()
> into vmx_vcpu_enter_exit() to consume apf flags earlier before leaving
> noinstr section like the way it handles CR2.
> 
> But linux kernel only resigters ASYNC PF for userspace and guest, so

I'd omit the guest part.  While technically true, it's not relevant to the change
as the instrumentation safety comes purely from the user_mode() check.  Mentioning
the "guest" side of things gets confusing as the "host" may be an L1 kernel, in
which case it is also a guest and may have its own guests.

It'd also be helpful for future readers to call out that this is true only since
commit 3a7c8fafd1b4 ("x86/kvm: Restrict ASYNC_PF to user space").  Allowing async
#PF in kernel mode was presumably why this code was non-instrumentable in the
first place.

> ASYNC PF can't hit when it is in kernel, so apf flags can be changed to
> be consumed only when the #PF is from guest or userspace.

...

> @@ -1538,7 +1514,20 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
>  	state = irqentry_enter(regs);
>  
>  	instrumentation_begin();
> -	handle_page_fault(regs, error_code, address);
> +
> +	/*
> +	 * KVM uses #PF vector to deliver 'page not present' events to guests
> +	 * (asynchronous page fault mechanism). The event happens when a
> +	 * userspace task is trying to access some valid (from guest's point of
> +	 * view) memory which is not currently mapped by the host (e.g. the
> +	 * memory is swapped out). Note, the corresponding "page ready" event
> +	 * which is injected when the memory becomes available, is delivered via
> +	 * an interrupt mechanism and not a #PF exception
> +	 * (see arch/x86/kernel/kvm.c: sysvec_kvm_asyncpf_interrupt()).
> +	 */
> +	if (!user_mode(regs) || !kvm_handle_async_user_pf(regs, (u32)address))
> +		handle_page_fault(regs, error_code, address);

To preserve the panic() if an async #PF is injected for !user_mode, any reason
not to do?

	if (!kvm_handle_async_user_pf(regs, (u32)address))
		handle_page_fault(regs, error_code, address);

Then __kvm_handle_async_user_pf() can keep its panic() on !user_mode().  And it
also saves a conditional when kvm_async_pf_enabled is not true.
