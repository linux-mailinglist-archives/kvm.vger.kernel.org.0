Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D621ED17D
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 15:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgFCNww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 09:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgFCNww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 09:52:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093A9C08C5C0;
        Wed,  3 Jun 2020 06:52:52 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0b2300fc641046fe5d6605.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:2300:fc64:1046:fe5d:6605])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 564F01EC0391;
        Wed,  3 Jun 2020 15:52:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591192370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=tupcOtxWYMxyJ3y62hq5YRNljYinVUxG6t+SPocYtUQ=;
        b=bVSWSttxu5jfvdmiza7JUElW6ZgnEDEy503L18klnvJDHBqAFLRKLFLorzo3l9JD3hE/AG
        JcBY5Xtx0hjaYuLe7GgEYnJBNH24lEGSm0BzmVbrGeL0PSW7+S9wgK6hN2JWEA0WFLJW+W
        eMhJ0O4gIFfAOJ9bu9emst5EStRHHLE=
Date:   Wed, 3 Jun 2020 15:52:44 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 75/75] x86/efi: Add GHCB mappings when SEV-ES is active
Message-ID: <20200603135244.GD19711@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-76-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-76-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:25PM +0200, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Calling down to EFI runtime services can result in the firmware performing
> VMGEXIT calls. The firmware is likely to use the GHCB of the OS (e.g., for
> setting EFI variables), so each GHCB in the system needs to be identity
> mapped in the EFI page tables, as unencrypted, to avoid page faults.

...

> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index eef6e2196ef4..3b62714723b5 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -422,6 +422,31 @@ int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
>  	return 0;
>  }
>  

Trusting the firmware is never a good decision but we've established on
IRC that *this* firmware is in OVMF and is going to be part of the guest
measurement so if there's trouble we can always fix it, as opposed to
the actual firmware in the chip.

Please add some blurb above this function about it so that it is clear
what kind of EFI firmware it is about here.

> +int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
> +{
> +	struct sev_es_runtime_data *data;
> +	unsigned long address, pflags;
> +	int cpu;
> +	u64 pfn;
> +
> +	if (!sev_es_active())
> +		return 0;
> +
> +	pflags = _PAGE_NX | _PAGE_RW;
> +
> +	for_each_possible_cpu(cpu) {
> +		data = per_cpu(runtime_data, cpu);
> +
> +		address = __pa(&data->ghcb_page);
> +		pfn = address >> PAGE_SHIFT;
> +
> +		if (kernel_map_pages_in_pgd(pgd, pfn, address, 1, pflags))
> +			return 1;
> +	}
> +
> +	return 0;
> +}

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
