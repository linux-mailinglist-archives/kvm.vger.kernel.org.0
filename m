Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A543571CB
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 18:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhDGQJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 12:09:54 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57512 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354320AbhDGQJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 12:09:40 -0400
Received: from zn.tnic (p200300ec2f08fb00aad493ab6ea3c721.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:aad4:93ab:6ea3:c721])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3D4571EC0246;
        Wed,  7 Apr 2021 18:09:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617811769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sxVXkcApyvWgRpvz11rKwU3ny4asbFyeyFcDJmEYY4Y=;
        b=Jti5HoimSVXTmsMwJCv2kI1KP+LX5MCLeIhCghkd+qTJfK6oP6MWmTijWFbADr1GjW+28H
        axA+m1b0eTCX47GNLKGOpxI+iNKoNXudwQB350WlEEUfcziZXhyp388N+7voUeP62ijsS9
        GW0RyxaI6h6HNHeX1PqQNTufuzpL4XQ=
Date:   Wed, 7 Apr 2021 18:09:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 1/7] hyperv: Detect Nested virtualization support for SVM
Message-ID: <20210407160933.GI25319@zn.tnic>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 02:41:22PM +0000, Vineeth Pillai wrote:
> Detect nested features exposed by Hyper-V if SVM is enabled.
> 
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 3546d3e21787..4d364acfe95d 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -325,9 +325,17 @@ static void __init ms_hyperv_init_platform(void)
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
>  	}
>  
> -	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> +	/*
> +	 * AMD does not need enlightened VMCS as VMCB is already a
> +	 * datastructure in memory. We need to get the nested
> +	 * features if SVM is enabled.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_SVM) ||

Pls use:

	    cpu_feature_enabled

here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
