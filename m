Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EC72873A5
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 13:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgJHLy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 07:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJHLy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 07:54:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56508C061755;
        Thu,  8 Oct 2020 04:54:57 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602158095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q/qmSpb3CP/RpH2tkpGs6zDGpUn7/uJNauETOHjsGLE=;
        b=tM/7k60h1NSREO08lwvHHl1D63D5hCLpDNMiDgny87FAQ5JoEPlj1y35ARdCTvCwWUOjHo
        WD0SP/w4vC3WUnnyZTea3h4bgVc8m8hAnE91KdF6RxrIcCoywYxhFUJmWXKkYBNJ3W6ArE
        gZDEdyBiKRGkinMvLe5Rh13UlfJEjPJipJFYYvaVbMEh/Arr0x+9Ojv11QWUC0pcwnJOsR
        CZALYQctEhozOJ5/zTPftceoal65CfNLUj+fJ883yPYsf1qn04NP87UOknAD4sqP0oMHa7
        qKBTfYF0j7lXavXxMbsyClRaxZZZy/thvcZIQuXwrMYRGy2k2S3Rt78QFF88gw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602158095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q/qmSpb3CP/RpH2tkpGs6zDGpUn7/uJNauETOHjsGLE=;
        b=o/ra7z3MVh/xaHnM6qFqAGA9BvKL6JyqBKDpxC3OsoWYCB6jKR+4OvEXe0q0aT3ftoNZRc
        u+3WVBgtr7dsBoBA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86/apic: Support 15 bits of APIC ID in IOAPIC/MSI where available
In-Reply-To: <20201007122046.1113577-4-dwmw2@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-4-dwmw2@infradead.org>
Date:   Thu, 08 Oct 2020 13:54:55 +0200
Message-ID: <87h7r5vsog.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 13:20, David Woodhouse wrote:
>  
> +	/*
> +	 * If the hypervisor supports extended destination ID in IOAPIC
> +	 * and MSI, that increases the maximum APIC ID that can be used
> +	 * for non-remapped IRQ domains.
> +	 */
> +	if (x86_init.hyper.msi_ext_dest_id()) {
> +		msi_ext_dest_id = 1;
> +		apic_limit = 32767;
> +	}

This needs to be outside of the remap mode check because?

> +
>  	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
>  		/*
>  		 * Using X2APIC without IR is not architecturally supported
> @@ -1856,9 +1868,10 @@ static __init void try_to_enable_x2apic(int remap_mode)
>  		 * in physical mode, and CPUs with an APIC ID that cannnot
>  		 * be addressed must not be brought online.
>  		 */
> -		x2apic_set_max_apicid(255);
> +		x2apic_set_max_apicid(apic_limit);
>  		x2apic_phys = 1;
>  	}
> +
>  	x2apic_enable();
>  }
>  
> diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
> index 2825e003259c..85206f971284 100644
> --- a/arch/x86/kernel/apic/msi.c
> +++ b/arch/x86/kernel/apic/msi.c
> @@ -23,8 +23,11 @@
>  
>  struct irq_domain *x86_pci_msi_default_domain __ro_after_init;
>  
> +int msi_ext_dest_id __ro_after_init;

bool please.

Aside of that this breaks the build for a kernel with CONFIG_PCI_MSI=n

Thanks,

        tglx
