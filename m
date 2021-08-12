Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742B13EA92A
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhHLRJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 13:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbhHLRJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 13:09:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3652C061756;
        Thu, 12 Aug 2021 10:08:54 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f8300207fa77f9285c0b6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:8300:207f:a77f:9285:c0b6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 56FA21EC04FB;
        Thu, 12 Aug 2021 19:08:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1628788129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=V/K6iCeE0MoLZTtP5W4vJ+sANgh83kvWLuTqE8TAOjY=;
        b=TxI0FczNkTrobUxyNi31De7NeNnHXcA/OxKDy4SzpvAUR4q6cJdbt4sqiueXMvti7Z3uDc
        e2fFGhelJhkznEs9cDg97rSkOeK4T3OxOGK7nO4g88MHMA7JRWYckpiS9mMF3CIK5elgEE
        8+G2AwFPfbXeQfE0TtLhgx+eO5tlUkY=
Date:   Thu, 12 Aug 2021 19:09:28 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v9 07/26] x86/fpu/xstate: Convert the struct fpu 'state'
 field to a pointer
Message-ID: <YRVVyI2RDVzFplnn@zn.tnic>
References: <20210730145957.7927-1-chang.seok.bae@intel.com>
 <20210730145957.7927-8-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210730145957.7927-8-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 07:59:38AM -0700, Chang S. Bae wrote:
> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> index f5a38a5f3ae1..c7826708f27f 100644
> --- a/arch/x86/include/asm/fpu/types.h
> +++ b/arch/x86/include/asm/fpu/types.h
> @@ -339,13 +339,30 @@ struct fpu {
>  	/*
>  	 * @state:
>  	 *
> -	 * In-memory copy of all FPU registers that we save/restore
> -	 * over context switches. If the task is using the FPU then
> -	 * the registers in the FPU are more recent than this state
> -	 * copy. If the task context-switches away then they get
> -	 * saved here and represent the FPU state.
> +	 * A pointer to indicate the in-memory copy of all FPU registers
> +	 * that are saved/restored over context switches.
> +	 *
> +	 * Initially @state points to @__default_state. When dynamic states
> +	 * get used, a memory is allocated for the larger state copy and
> +	 * @state is updated to point to it. Then, the state in ->state
> +	 * supersedes and invalidates the state in @__default_state.
> +	 *
> +	 * In general, if the task is using the FPU then the registers in
> +	 * the FPU are more recent than the state copy. If the task
> +	 * context-switches away then they get saved in ->state and
> +	 * represent the FPU state.
> +	 */
> +	union fpregs_state		*state;
> +
> +	/*
> +	 * @__default_state:
> +	 *
> +	 * Initial in-memory copy of all FPU registers that saved/restored
> +	 * over context switches. When the task is switched to dynamic
> +	 * states, this copy is replaced with the new in-memory copy in
> +	 * ->state.
>  	 */
> -	union fpregs_state		state;
> +	union fpregs_state		__default_state;
>  	/*
>  	 * WARNING: 'state' is dynamically-sized.  Do not put
		    ^^^^^^

that needs to be __default_state as it is which is dynamically-sized.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
