Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7B841EE4C
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 15:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhJANRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 09:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhJANRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 09:17:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE28CC061775;
        Fri,  1 Oct 2021 06:15:24 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633094123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RgNzazZZZU00oypcQsc+q9dNMqyuBTQu7dV4Uj4peo8=;
        b=kAghlOBmNBYKZ7yFt1D8HvA53eknujC2apli+DcHptTDUOwPX4Tvd+MgfLCl/5CcfqAH/u
        s18YxBZ3v0mPOW4VkF9X2jgeej1bO834QKg2bLJgz9v5qgZfiYOmIXqydUn6il9XpID6FE
        Ile+YsncSvMQU91GcEi3QIH2IKjywYQNCcJJMqOd2UTLlFFTCidmI3sS4eAVElDvfafqRY
        igBOMIPisUgOX4yqmOHf6Gvwe3D2H5OMikACS3JqkpSmiHxr1ZI/CHsTTtrnbnq/hk+coI
        nTDHWiRef+Zr5NnGBajgImcGIHqseFrFgU3xP7qneSPkK1erEvhz8/cVjPCXgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633094123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RgNzazZZZU00oypcQsc+q9dNMqyuBTQu7dV4Uj4peo8=;
        b=6SW5cTo2kSOzfHpxRq731VA9XPWyT8G0m2m5BdP2GhPdl/D/uMEeSsJ01pwdA9YrdH1eZb
        YjeoaI+4ANVn1uAg==
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        luto@kernel.org, mingo@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v10 04/28] x86/fpu/xstate: Modify address finders to
 handle both static and dynamic buffers
In-Reply-To: <20210825155413.19673-5-chang.seok.bae@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-5-chang.seok.bae@intel.com>
Date:   Fri, 01 Oct 2021 15:15:22 +0200
Message-ID: <87ee946g45.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Chang,

On Wed, Aug 25 2021 at 08:53, Chang S. Bae wrote:

> Have all the functions finding XSTATE address take a struct fpu * pointer
> in preparation for dynamic state buffer support.
>
> init_fpstate is a special case, which is indicated by a null pointer
> parameter to get_xsave_addr() and __raw_xsave_addr().

Same comment vs. subject. Prepare ...

> +	if (fpu)
> +		xsave = &fpu->state.xsave;
> +	else
> +		xsave = &init_fpstate.xsave;
> +
> +	return xsave + xstate_comp_offsets[xfeature_nr];

So you have the same conditionals and the same comments vs. that NULL
pointer oddity how many times now all over the place?

That can be completely avoided:

Patch 1:

-union fpregs_state init_fpstate __ro_after_init;
+static union fpregs_state init_fpstate __ro_after_init;
+struct fpu init_fpu = { .state = &init_fpstate } __ro_after_init;

and make all users of init_fpstate access it through init_fpu.

Patches 2..N which change arguments from fpregs_state to fpu:

-	fun(init_fpu->state);
+	fun(&init_fpu);

Patch M which adds state_mask:

@fpu__init_system_xstate()
+	init_fpu.state_mask = xfeatures_mask_all;

Hmm?

Thanks,

        tglx
