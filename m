Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55A82F79D3
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbhAOMl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:41:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:57706 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732140AbhAOMl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:41:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32570AC8F;
        Fri, 15 Jan 2021 12:40:44 +0000 (UTC)
Date:   Fri, 15 Jan 2021 13:40:38 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        jing2.liu@intel.com, ravi.v.shankar@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 01/21] x86/fpu/xstate: Modify initialization helper to
 handle both static and dynamic buffers
Message-ID: <20210115124038.GA11337@zn.tnic>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-2-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201223155717.19556-2-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 23, 2020 at 07:56:57AM -0800, Chang S. Bae wrote:
> In preparation for dynamic xstate buffer expansion, update the buffer
> initialization function parameters to equally handle static in-line xstate
> buffer, as well as dynamically allocated xstate buffer.
> 
> init_fpstate is a special case, which is indicated by a null pointer
> parameter to fpstate_init().
> 
> Also, fpstate_init_xstate() now accepts the state component bitmap to
> configure XCOMP_BV for the compacted format.
> 
> No functional change.

Much better, thanks!

> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index eb86a2b831b1..f23e5ffbb307 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -191,8 +191,16 @@ static inline void fpstate_init_fstate(struct fregs_state *fp)
>  	fp->fos = 0xffff0000u;
>  }
>  
> -void fpstate_init(union fpregs_state *state)
> +/* A null pointer parameter indicates init_fpstate. */

Use kernel-doc comment style instead:

/**
 * ..
 *
 * @fpu: If NULL, use init_fpstate
 */

> +void fpstate_init(struct fpu *fpu)
>  {

...

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
