Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851A4465C4D
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 03:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355003AbhLBCwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 21:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhLBCwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 21:52:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE33C061574;
        Wed,  1 Dec 2021 18:48:44 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638413322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g4d6LurEJQ3MhA4qJ7KFNVaMy6FBpSBp+mLvIbarqTw=;
        b=fZjdc0DMllkN72PBeX8cSYDwKvyoN8JH1duMC3ZUgDDJQWJJELJwGt5fDxTS9d7twYumbq
        XJMbc6MywWL2ReGIFakxrQRjURcEnD5iA29wWHE2fVsiRETaV3hDHnGU2yYjqclpm1Wbfk
        FSZpzjuWugOHjGIaVP16q7vtA1kxOb3BXo+n2usmwxfHBHXLcG/K8dnH/iY/nSez8n/v3e
        4F7yd9aMr+bRAb26BP4hoP+W59UPo8s70KTsoSUQlbPv1Nk9WmfsNDRaZZOoV8OIuApA8S
        SSBrOy7mD2Fzqr0SJH/ic+zQxkjQNgXNhXLK6SaJuCcLCfbDeb/5Dzvk56yHwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638413322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g4d6LurEJQ3MhA4qJ7KFNVaMy6FBpSBp+mLvIbarqTw=;
        b=z+OqXDRjVcQlZCarqrTpINn6PAIHJbaXiDNWvfppsqape4f22NYcrwr/MuSY75Zg5/VM3N
        AozKXxXxHuCwtkBg==
To:     zhenwei pi <pizhenwei@bytedance.com>, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: use x86_get_freq to get freq for kvmclock
In-Reply-To: <20211201024650.88254-3-pizhenwei@bytedance.com>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
 <20211201024650.88254-3-pizhenwei@bytedance.com>
Date:   Thu, 02 Dec 2021 03:48:41 +0100
Message-ID: <877dcn7md2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01 2021 at 10:46, zhenwei pi wrote:
> If the host side supports APERF&MPERF feature, the guest side may get
> mismatched frequency.
>
> KVM uses x86_get_cpufreq_khz() to get the same frequency for guest side.
>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  arch/x86/kvm/x86.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5a403d92833f..125ed3c8b21a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8305,10 +8305,8 @@ static void tsc_khz_changed(void *data)
>  
>  	if (data)
>  		khz = freq->new;
> -	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> -		khz = cpufreq_quick_get(raw_smp_processor_id());
>  	if (!khz)
> -		khz = tsc_khz;
> +		khz = x86_get_cpufreq_khz(raw_smp_processor_id());

my brain compiler tells me that this is broken.
