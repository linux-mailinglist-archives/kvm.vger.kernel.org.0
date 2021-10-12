Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9142ABEA
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 20:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhJLS3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 14:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbhJLS3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 14:29:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67DEC061745;
        Tue, 12 Oct 2021 11:27:04 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634063217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+JPNiXBO034X+zkqqSL63pmvtyjJNOIJ0HYL93XQQ7A=;
        b=pvvaUZAwjhJ+46VazGKaBeY8C6s5xPP0UD9YmG6THvS6A8mSBOcEvk6M1Ef6ANI4MQY2Bl
        m117MA1p6FgPT7EAQhE+LuEPS8vSfvRFXGr5c3Jvl13enUYqAOeUE9HzvSoRoYeBNnhbtV
        0td1ZXCwvuMziDDXEkdmsw/6dkERrMhtLlSKfiB+vLPfUrAg01EBEnKOoXwFdNfWCWEhX/
        WP/iEEW8tgSJ2lbJb053pQWHVReaXcLzHx5HrutIbP8fB3aBoJKDV6aL33HPL7mqFhtesY
        CwbvFFqrFcqz1piUQsMuui4wkFsCRQPIQLhEyvYR0tzrlwHMkVh1bj8q35DY3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634063217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+JPNiXBO034X+zkqqSL63pmvtyjJNOIJ0HYL93XQQ7A=;
        b=DWT8JNaDcnyKx//6Ih2xZ3q05OGbU6zZWvwFQBH72QlQe8t2S9aB8vSW4/iKWoG7Po6H0G
        w09HlALxP1OinbAg==
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <87czoaaymr.ffs@tglx>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de> <YWW9ksxtp4hpT0GI@zn.tnic>
 <87czoaaymr.ffs@tglx>
Date:   Tue, 12 Oct 2021 20:26:56 +0200
Message-ID: <87a6jeaykv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12 2021 at 20:25, Thomas Gleixner wrote:

> On Tue, Oct 12 2021 at 18:53, Borislav Petkov wrote:
>> On Tue, Oct 12, 2021 at 02:00:17AM +0200, Thomas Gleixner wrote:
>>>  	/*
>>> -	 * Guests with protected state can't have it set by the hypervisor,
>>> -	 * so skip trying to set it.
>>> +	 * Guest with protected state have guest_fpu == NULL which makes
>>
>> "Guests ... "
>>
>>> +	 * the swap only safe the host state. Exclude PKRU from restore as
>>
>> "save"
>
> No I meant safe, but let me rephrase it, Swap does both save and
> restore. But it's not safe to dereference a NULL pointer :)
>
>  .... makes the swap only handle the host state. Exclude PKRU from restore as

Gah. I should have looked at the context first. "save" is correct
here. Oh well...
