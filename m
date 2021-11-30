Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198A7464053
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344210AbhK3VkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbhK3VkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:40:07 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1288C061574;
        Tue, 30 Nov 2021 13:36:47 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638308204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XB+2u5uEBJEn4Qm0c+1ERye9sFiy1dxB5m1DCsCRIdU=;
        b=lYKsjQggunBjL//xtzE/JaYSyEicoLfIP7C2ag+SfIKg5zJT3qSryEVhpm6FQhZJf+ZWFX
        04tDjFlnWaBo5DT60Gloq90FMqmyhV5nmMj7vlxoexKqrCF9yMFc7vzG2L9xEizsdepbk+
        My6/gRPMT2ahdUIASrk2Vsm9DxgaElpRwffWh4SNIJ3qiQ0UF2nHIF2HMWTr0dUiy4jSFg
        Vy8Ir48C56SdrMw/QLtQLlwNJCZRQFeCZIeq4rJQ9wGdlcZOsi1U4XbI+PlUI6/tPsWT2d
        XuqXU8fy/DX+ICv7l1uEaXHWVvGqt2EOYoV4+srchMwFgoCMmY8edqhCjA4wKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638308204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XB+2u5uEBJEn4Qm0c+1ERye9sFiy1dxB5m1DCsCRIdU=;
        b=EtGNw3/2HkClYokrjpc8z7ivJxVQb0a6HsEsOkaPJ8e55RcS5bFYLxZVpJRg2KuyTC48R5
        0mTpLkYGI80NZWCA==
To:     zhenwei pi <pizhenwei@bytedance.com>, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: Re: [PATCH 1/2] x86/cpu: introduce x86_get_freq
In-Reply-To: <20211129052038.43758-1-pizhenwei@bytedance.com>
References: <20211129052038.43758-1-pizhenwei@bytedance.com>
Date:   Tue, 30 Nov 2021 22:36:43 +0100
Message-ID: <87lf15ba1g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29 2021 at 13:20, zhenwei pi wrote:

> Wrapper function x86_get_freq to get freq on a x86 platform, hide
> detailed implementation for proc routine.

Please rename this to x86_get_cpufreq_khz() simply because
x86_get_freq() is way too unspecific.

Please mention function names with 'function()' which makes it obvious
what it is. Here and in the Subject.

Also spell out frequency all over the place in the change log. There is
no reason for using abbreviations in text.

> +
> +unsigned int x86_get_freq(unsigned int cpu)
> +{
> +	unsigned int freq = 0;
> +
> +	if (cpu_has(&cpu_data(cpu), X86_FEATURE_TSC)) {

Please use cpu_feature_enabled(X86....) and make this condition
negated:

     if (!cpu_feature_enabled(X86_FEATURE_TSC))
            return 0;

which spares an indentation level and the 0 initialization of the variable.

Thanks,

        tglx
