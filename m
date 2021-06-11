Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDAA3A43B5
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhFKOHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFKOHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 10:07:22 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3722C061574;
        Fri, 11 Jun 2021 07:05:24 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0aec00c954d2edeb094cfc.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:ec00:c954:d2ed:eb09:4cfc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 17BCC1EC053C;
        Fri, 11 Jun 2021 16:05:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1623420323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jjSbtHxfmAfGqMirhGR6ZtzrOk/6dDWM66vpfU14tVE=;
        b=H7E8yAP84yciTlUXqurgT+uzQ8Jh3nsdJ2rmPMVBRLA8UcEs3g67Rg3SeS7mW5IaAAYxuH
        Dzedmq7mXio6AZo7zjHw3oneDcZRubs3Q0xDV7FdVLYDDwwVVSHiUALCmvPluchMv2uh0N
        sqBFsV1ziNuq79mr3wsF1RgQRHNE3OA=
Date:   Fri, 11 Jun 2021 16:05:15 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 2/6] x86/sev-es: Disable IRQs while GHCB is active
Message-ID: <YMNtmz6W1apXL5q+@zn.tnic>
References: <20210610091141.30322-1-joro@8bytes.org>
 <20210610091141.30322-3-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210610091141.30322-3-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021 at 11:11:37AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The #VC handler only cares about IRQs being disabled while the GHCB is
> active, as it must not be interrupted by something which could cause
> another #VC while it holds the GHCB (NMI is the exception for which the
> backup GHCB is there).
> 
> Make sure nothing interrupts the code path while the GHCB is active by
> disabling IRQs in sev_es_get_ghcb() and restoring the previous irq state
> in sev_es_put_ghcb().

Why this unnecessarily complicated passing of flags back and forth?

Why not simply "sandwich" them:

	local_irq_save()
	sev_es_get_ghcb()

	...blablabla

	sev_es_put_ghcb()
	local_irq_restore();

in every call site?

What's the difference in passing *flags in and have the
get_ghcb/put_ghcb save/restore flags instead of the callers?

> -static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
> +static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state,
> +						    unsigned long *flags)
>  {
>  	struct sev_es_runtime_data *data;
>  	struct ghcb *ghcb;
>  
> +	/*
> +	 * Nothing shall interrupt this code path while holding the per-cpu
> +	 * GHCB. The backup GHCB is only for NMIs interrupting this path.

Hmm, so why aren't you accessing/setting data->ghcb_active and
data->backup_ghcb_active safely using cmpxchg() if this path can be
interrupted by an NMI?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
