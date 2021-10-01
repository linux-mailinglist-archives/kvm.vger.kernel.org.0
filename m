Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1019341EEA3
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 15:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353421AbhJANeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 09:34:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57408 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352901AbhJANeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 09:34:19 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633095149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HXoyc4jRDQBnUGo2gIo6eI8vmDogfCVzmxMMg8jeyVk=;
        b=UTGTL+XZwMStbn79e3Ovx+epJ7xoXD0wVPPamqHwJLXO+jS5kUR1wD87+HrAilMGElEuNQ
        PAwRgHs8i/DvKbeYr/LUVE9zuhwSgsnHCo8OEmLyLxUyr2cIIdl5ipwHyKg/VA31l1y3Pa
        d2GipeRnDLt73TdTpKYzjqIKWENPVvYxKdkoqhTWWwqrJyYnPma7tbtQ9nrOzxGReJyCgL
        BTX48mEDAdEeYYRCa+RgFP7xbLZvhrv+0ZMC9BD6ENNDDcuAOy83P5/n71HnPFE2eA3JGs
        0LtsdTQGmm/+ZSbpPRGqE5lpEdYMMn8SlqDH/03Ffyhs7nUR5gEgg4KPJuC2CQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633095149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HXoyc4jRDQBnUGo2gIo6eI8vmDogfCVzmxMMg8jeyVk=;
        b=StyaMW5j05uqR4WdXO07lpqqZoxUXbSXsGSEdErMUygddj6Td9VGxXzTnjsUHsz4vOvGEa
        qlkq9HeZ4h3qV5Dw==
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        luto@kernel.org, mingo@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v10 06/28] x86/fpu/xstate: Add new variables to indicate
 dynamic XSTATE buffer size
In-Reply-To: <20210825155413.19673-7-chang.seok.bae@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-7-chang.seok.bae@intel.com>
Date:   Fri, 01 Oct 2021 15:32:23 +0200
Message-ID: <878rzc6fbs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25 2021 at 08:53, Chang S. Bae wrote:
> +/**
> + * struct fpu_xstate_buffer_config - xstate buffer configuration
> + * @max_size:			The CPUID-enumerated all-feature "maximum" size
> + *				for xstate per-task buffer.
> + * @min_size:			The size to fit into the statically-allocated
> + *				buffer. With dynamic states, this buffer no longer
> + *				contains all the enabled state components.
> + * @user_size:			The size of user-space buffer for signal and
> + *				ptrace frames, in the non-compacted format.
> + */

>  void fpstate_init(struct fpu *fpu)
>  {
>  	union fpregs_state *state;
> +	unsigned int size;
> +	u64 mask;
>  
> -	if (likely(fpu))
> +	if (likely(fpu)) {
>  		state = &fpu->state;
> -	else
> +		/* The dynamic user states are not prepared yet. */
> +		mask = xfeatures_mask_all & ~xfeatures_mask_user_dynamic;

The patch ordering is really odd. Why aren't you adding

     fpu->state_mask
and
     fpu->state_size

first and initialize state_mask and state_size to the fixed mode and
then add the dynamic sizing on top?

>  	/*
>  	 * If the target FPU state is not resident in the CPU registers, just
>  	 * memcpy() from current, else save CPU state directly to the target.
> +	 *
> +	 * KVM does not support dynamic user states yet. Assume the buffer
> +	 * always has the minimum size.
>  	 */
>  	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>  		memcpy(&fpu->state, &current->thread.fpu.state,
> -		       fpu_kernel_xstate_size);
> +		       fpu_buf_cfg.min_size);

Which completely avoids the export of fpu_buf_cfg for KVM because the
information is just available via struc fpu. As a bonus the export of
fpu_kernel_xstate_size can be removed as well.

Hmm?

Thanks,

        tglx
