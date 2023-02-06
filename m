Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C62C68CACC
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjBFXss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBFXso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:48:44 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ABF2A9BE;
        Mon,  6 Feb 2023 15:48:43 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675727321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uvl4OAj0p18J/mYPwGL5MZpYwwAfj/gpr2FPGu6RDzk=;
        b=XTU7lAo5kPnd2/18ri7tAkasjYW7v1VgohXwezhwR1Rj7DrOQ/fGjiO2TA9e0kWTa1en8Z
        4zDD78FOPHRT4gaABrv2rwlhZIuhfRsrMdRh6C6nHfx7ObIINfb55+u778+OA5dBeouXNA
        dvom0z16NNWCoTto6wcxUPbdJQvuPABTt3pDHGgiSMrRtSrj4Qo1Dvk8U+CxSY6OVP6v0i
        smy93d/fm56EhvVXwVZWo9dtSJueq+8buyzyrea3hMWruraZ66dKzYozrmI1y5mIFfJ/+Q
        Z98hRENRc6xOTQAUCNcV09Hmc74CNuPPuoR4TjKnfcdhM7bn/f70P/ja9i/bFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675727321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uvl4OAj0p18J/mYPwGL5MZpYwwAfj/gpr2FPGu6RDzk=;
        b=i5hh+xOdX1d/kqrbbIQBR2NkHoW791gaA1MWS0mXQwYjcaUijlndxhcZbPsutt1S3u+4X3
        1COcFb/AsJOvMHCg==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v6 04/11] x86/smpboot: Reference count on
 smpboot_setup_warm_reset_vector()
In-Reply-To: <20230202215625.3248306-5-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-5-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 00:48:40 +0100
Message-ID: <871qn2xsmf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> If we want to do parallel CPU bringup, we're going to need to set this up
> and leave it until all CPUs are done. Might as well use the RTC spinlock
> to protect the refcount, as we need to take it anyway.

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#changelog

Aside of the 'We' this does not explain anything at all.

> [Usama Arif: fixed rebase conflict]
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

This SOB chain is even more broken...

> ---
>  arch/x86/kernel/smpboot.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 55cad72715d9..a19eddcdccc2 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -121,17 +121,22 @@ int arch_update_cpu_topology(void)
>  	return retval;
>  }
>  
> +
> +static unsigned int smpboot_warm_reset_vector_count;
> +
>  static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
>  {
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&rtc_lock, flags);
> -	CMOS_WRITE(0xa, 0xf);
> +	if (!smpboot_warm_reset_vector_count++) {
> +		CMOS_WRITE(0xa, 0xf);
> +		*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
> +			start_eip >> 4;
> +		*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
> +			start_eip & 0xf;

Again: 80 characters are history. Please fix that all over the series.

Thanks,

        tglx
