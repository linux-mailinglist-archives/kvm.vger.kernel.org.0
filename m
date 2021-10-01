Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A667341F164
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 17:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhJAPna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 11:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhJAPn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 11:43:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FF4C061775;
        Fri,  1 Oct 2021 08:41:45 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633102903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=byc2IlkIYSWPNIeqNzT2D0FAqUb7gNOtQCa+3uZyf44=;
        b=P2GSwiTe6hzVafYT7FlPYUlv9flFyPlWScvvxJl6lREbi/i7EtOh3mUmljYg0UVKgw0Iqa
        mrx++FH+fowkN898y9GkRyG51eZ80fz3EkHczGOeOgrxtcHAJoKNymjrhK1J3ZGU/OGLSl
        xf3etpSZAeFKvSBlYXpiV0iw32BiDRnS9EOPGrl/mHCdmgvW3iSSdeov0I6Ll688pWcfRw
        XMljQuDynKXWJlLkU6y6nhBOq+R1VXgWurU69odB7AS3FCZh2n7AFX4LWtcT0w6zTOCw2J
        eVB3JaniKQjU99WfIAeyi2LZF+D7PphjLyMd3nLb68cabA+o4dzwVb2Y3bx9Jg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633102903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=byc2IlkIYSWPNIeqNzT2D0FAqUb7gNOtQCa+3uZyf44=;
        b=NOn6f3p/uTC2tC2R8lNu9nR+TShS8dt0Q8gCtFBYs88FYMrXUviQIx3izHHZzbuyBvQSuQ
        eS3GL6xaLPfw3zAg==
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        luto@kernel.org, mingo@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v10 10/28] x86/fpu/xstate: Update the XSTATE save
 function to support dynamic states
In-Reply-To: <20210825155413.19673-11-chang.seok.bae@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-11-chang.seok.bae@intel.com>
Date:   Fri, 01 Oct 2021 17:41:42 +0200
Message-ID: <87tui04urt.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25 2021 at 08:53, Chang S. Bae wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 74dde635df40..7c46747f6865 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9899,11 +9899,16 @@ static void kvm_save_current_fpu(struct fpu *fpu)
>  	 * KVM does not support dynamic user states yet. Assume the buffer
>  	 * always has the minimum size.
>  	 */
> -	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
>  		memcpy(fpu->state, current->thread.fpu.state,
>  		       fpu_buf_cfg.min_size);

What happens with the rest of the state?

> -	else
> +	} else {
> +		struct fpu *src_fpu = &current->thread.fpu;
> +
> +		if (fpu->state_mask != src_fpu->state_mask)
> +			fpu->state_mask = src_fpu->state_mask;

What guarantees that the state size of @fpu is big enough when src_fpu
has dynamic features included?

>  		save_fpregs_to_fpstate(fpu);

Thanks,

        tglx
