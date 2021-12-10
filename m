Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CECB470E80
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 00:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345038AbhLJXYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 18:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239950AbhLJXYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 18:24:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78FEC061746;
        Fri, 10 Dec 2021 15:20:24 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639178422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m0vojIwzSpEf1MPwLMXE64NmDKMUcglA6n43GrBYVRk=;
        b=WxFPS2TM1yuVQmnWrviQssRI0IwVNLZ87EUYPaGKgZVZOVQN46mWW9zO1W+FfK4ap6RkaZ
        qzDxUOE6N3LPBf6Yr+JP/Z3JZ9+RAW16Dkaj5+FB+su85aEduZh9fIGZ/Ez4LsmrYdvSvD
        yngM79twcVnL1QsDq0wG3BOj3Lxq7Px3Ouc/iPNYc1hlNBG22XsXaz9TzqBo9UxN5c2QTi
        YhClgvzYmq6r4dYi3C0WFmPgnmW5tzOMlPkGhO+/3YKhvLLHNHvwIdqHg2zDZQEyP0XLVk
        LUzhTIqqqBaZoDtEAMBsDvXGTaAdK8fymWJUJYJKUKbp5hKnwacZLp5ZEaHs2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639178422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m0vojIwzSpEf1MPwLMXE64NmDKMUcglA6n43GrBYVRk=;
        b=wB3vvPDPrph8S/L4nsM2nk9JD3ORPD0NAzYhu9Io3nh1O5PLIq+sbkCUXHs6ScTw8qrKwV
        XHXmiUpPU3AD/lBA==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 14/19] x86/fpu: Prepare for KVM XFD_ERR handling
In-Reply-To: <20211208000359.2853257-15-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-15-yang.zhong@intel.com>
Date:   Sat, 11 Dec 2021 00:20:22 +0100
Message-ID: <87tufgvyh5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -322,6 +322,55 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
>  }
>  EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
>  
> +#ifdef CONFIG_X86_64
> +void fpu_save_guest_xfd_err(struct fpu_guest *guest_fpu)
> +{
> +	if (guest_fpu->xfd_err & XFD_ERR_GUEST_DISABLED)
> +		return;
> +
> +	/* A non-zero value indicates guest XFD_ERR already saved */
> +	if (guest_fpu->xfd_err)
> +		return;
> +
> +	/* Guest XFD_ERR must be saved before switching to host fpstate */
> +	WARN_ON_ONCE(!current->thread.fpu.fpstate->is_guest);

Warn and proceed?

> +	rdmsrl(MSR_IA32_XFD_ERR, guest_fpu->xfd_err);
> +
> +	/*
> +	 * Restore to the host value if guest xfd_err is non-zero.
> +	 * Except in #NM handler, all other places in the kernel
> +	 * should just see xfd_err=0. So just restore to 0.
> +	 */
> +	if (guest_fpu->xfd_err)
> +		wrmsrl(MSR_IA32_XFD_ERR, 0);
> +
> +	guest_fpu->xfd_err |= XFD_ERR_GUEST_SAVED;
> +}
> +EXPORT_SYMBOL_GPL(fpu_save_guest_xfd_err);
> +
> +void fpu_restore_guest_xfd_err(struct fpu_guest *guest_fpu)
> +{
> +	u64 xfd_err = guest_fpu->xfd_err;
> +
> +	if (xfd_err & XFD_ERR_GUEST_DISABLED)
> +		return;
> +
> +	xfd_err &= ~XFD_ERR_GUEST_SAVED;
> +
> +	/*
> +	 * No need to restore a zero value since XFD_ERR
> +	 * is always zero outside of #NM handler in the host.
> +	 */
> +	if (!xfd_err)
> +		return;
> +
> +	wrmsrl(MSR_IA32_XFD_ERR, xfd_err);
> +	guest_fpu->xfd_err = 0;
> +}

Why should any pf this be in the FPU core?

It's a pure guest issue as all of this is related to struct fpu_guest
and not struct fpu or any other core FPU state.

Thanks,

        tglx

