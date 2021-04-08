Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A57B357E43
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 10:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhDHIib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 04:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhDHIib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 04:38:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A871C061760;
        Thu,  8 Apr 2021 01:38:20 -0700 (PDT)
Received: from zn.tnic (p200300ec2f095000c11580856fe05acf.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5000:c115:8085:6fe0:5acf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E1B411EC03CE;
        Thu,  8 Apr 2021 10:38:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617871095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Kxh8yxt419FOMUzcjS1sp7cQfN4dfxrZXCO9G9/LPLs=;
        b=o0qqxJ1JzVVmPhtCc06e0Zs3ccsPt4yTLpjUArkfRalbVy1cLaYahJ87Afn48n8rubLeph
        6DXjUkomsf0u3V3kHLdcQPFJx0eaPFcwq0rTRMh0IUByxsQ8zg+VUpyhVF+TsCtZ1OH1sw
        qc4lR7F8T9uFhD1ppYMAOhnAsZM81+w=
Date:   Thu, 8 Apr 2021 10:38:14 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 08/13] x86/sev-es: register GHCB memory when
 SEV-SNP is active
Message-ID: <20210408083814.GB10192@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-9-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-9-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:19AM -0500, Brijesh Singh wrote:
> @@ -88,6 +89,13 @@ struct sev_es_runtime_data {
>  	 * is currently unsupported in SEV-ES guests.
>  	 */
>  	unsigned long dr7;
> +
> +	/*
> +	 * SEV-SNP requires that the GHCB must be registered before using it.
> +	 * The flag below will indicate whether the GHCB is registered, if its
> +	 * not registered then sev_es_get_ghcb() will perform the registration.
> +	 */
> +	bool ghcb_registered;

snp_ghcb_registered

because it is SNP-specific.

>  };
>  
>  struct ghcb_state {
> @@ -196,6 +204,12 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
>  		data->ghcb_active = true;
>  	}
>  
> +	/* SEV-SNP guest requires that GHCB must be registered before using it. */
> +	if (sev_snp_active() && !data->ghcb_registered) {
> +		sev_snp_register_ghcb(__pa(ghcb));
> +		data->ghcb_registered = true;

This needs to be set to true in the function itself, in the success
case.

> +static inline u64 sev_es_rd_ghcb_msr(void)
> +{
> +	return __rdmsr(MSR_AMD64_SEV_ES_GHCB);
> +}
> +
> +static inline void sev_es_wr_ghcb_msr(u64 val)
> +{
> +	u32 low, high;
> +
> +	low  = (u32)(val);
> +	high = (u32)(val >> 32);
> +
> +	native_wrmsr(MSR_AMD64_SEV_ES_GHCB, low, high);
> +}

Those copies will go away once you create the common sev.c

> +
> +/* Provides sev_es_terminate() */
> +#include "sev-common-shared.c"
> +
> +void sev_snp_register_ghcb(unsigned long paddr)
> +{
> +	u64 pfn = paddr >> PAGE_SHIFT;
> +	u64 old, val;
> +
> +	/* save the old GHCB MSR */
> +	old = sev_es_rd_ghcb_msr();
> +
> +	/* Issue VMGEXIT */
> +	sev_es_wr_ghcb_msr(GHCB_REGISTER_GPA_REQ_VAL(pfn));
> +	VMGEXIT();
> +
> +	val = sev_es_rd_ghcb_msr();
> +
> +	/* If the response GPA is not ours then abort the guest */
> +	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_REGISTER_GPA_RESP) ||
> +	    (GHCB_REGISTER_GPA_RESP_VAL(val) != pfn))
> +		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
> +
> +	/* Restore the GHCB MSR value */
> +	sev_es_wr_ghcb_msr(old);
> +}

This is an almost identical copy of the version in compressed/. Move to
the shared file?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
