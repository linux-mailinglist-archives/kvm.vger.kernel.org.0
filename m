Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA83EA70B
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbhHLPDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:03:10 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50100 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238194AbhHLPDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 11:03:09 -0400
Received: from zn.tnic (p200300ec2f0f830099de965992d633fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:8300:99de:9659:92d6:33fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 294AA1EC01DF;
        Thu, 12 Aug 2021 17:02:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1628780558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2YLlWCBM2h1buYRLjyfrjQPBk1fNhhkd7J5SB+sqLHw=;
        b=gWT5tIHXbO5j+eyxCYEkIXJIRECIzEXs881TU9lM9OeZxaMuuIbZTby9xQPlv6dlqebt01
        FzpsbL+TNjnr6a7NrLSTdIPQ0tC8NGB/Juj5Zl0aX89dthadzA7rLQtdcd1DdziIaFytZq
        6NnMAmufxmIjSJP+EqsGLo4LHipXGFA=
Date:   Thu, 12 Aug 2021 17:03:15 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v9 05/26] x86/fpu/xstate: Add new variables to indicate
 dynamic XSTATE buffer size
Message-ID: <YRU4M6FO0OHc67Wx@zn.tnic>
References: <20210730145957.7927-1-chang.seok.bae@intel.com>
 <20210730145957.7927-6-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210730145957.7927-6-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 07:59:36AM -0700, Chang S. Bae wrote:
> @@ -167,8 +158,10 @@ static void __init fpu__init_task_struct_size(void)
>  	/*
>  	 * Add back the dynamically-calculated register state
>  	 * size.
> +	 *
> +	 * Use the minimum size as embedded to task_struct.

embedded in...

> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 74e608c6ad6c..12caf1a56ce0 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -77,12 +77,51 @@ static unsigned int xstate_comp_offsets[XFEATURE_MAX] __ro_after_init =
>  static unsigned int xstate_supervisor_only_offsets[XFEATURE_MAX] __ro_after_init =
>  	{ [ 0 ... XFEATURE_MAX - 1] = -1};
>  
> -/*
> - * The XSAVE area of kernel can be in standard or compacted format;
> - * it is always in standard format for user mode. This is the user
> - * mode standard format size used for signal and ptrace frames.
> +/**
> + * struct fpu_xstate_buffer_config - xstate buffer configuration
> + * @max_size:			The CPUID-enumerated all-feature "maximum" size
> + *				for xstate per-task buffer.
> + * @min_size:			The size to fit into the statically-allocated
> + *				buffer. With dynamic states, this buffer no longer
> + *				contains all the enabled state components.
> + * @user_size:			The size of user-space buffer for signal and
> + *				ptrace frames, in the non-compacted format.
>   */
> -unsigned int fpu_user_xstate_size __ro_after_init;
> +struct fpu_xstate_buffer_config {
> +	unsigned int min_size, max_size;
> +	unsigned int user_size;
> +};
> +
> +static struct fpu_xstate_buffer_config buffer_config __ro_after_init;

I know I had asked for the accessors below but if this is going to be
read-only after init and is not going to change for duration of the
system lifetime, then you don't really need those accessors.

I.e., you can do

struct fpu_xstate_buffer_config {
	unsigned int min_size, max_size;
	unsigned int user_size;
};

static struct fpu_xstate_buffer_config fpu_buf_cfg __ro_after_init;

and then access those values through fpu_buf_cfg.<value>

Thx.

> +
> +unsigned int get_xstate_config(enum xstate_config cfg)
> +{
> +	switch (cfg) {
> +	case XSTATE_MIN_SIZE:
> +		return buffer_config.min_size;
> +	case XSTATE_MAX_SIZE:
> +		return buffer_config.max_size;
> +	case XSTATE_USER_SIZE:
> +		return buffer_config.user_size;
> +	default:
> +		return 0;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(get_xstate_config);
> +
> +void set_xstate_config(enum xstate_config cfg, unsigned int value)
> +{
> +	switch (cfg) {
> +	case XSTATE_MIN_SIZE:
> +		buffer_config.min_size = value;
> +		break;
> +	case XSTATE_MAX_SIZE:
> +		buffer_config.max_size = value;
> +		break;
> +	case XSTATE_USER_SIZE:
> +		buffer_config.user_size = value;
> +	}
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
