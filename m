Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E48D356BA6
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351951AbhDGMAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:00:11 -0400
Received: from mail.skyhub.de ([5.9.137.197]:41706 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231315AbhDGMAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 08:00:10 -0400
Received: from zn.tnic (p200300ec2f08fb002f59ec04e5c6bba4.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:2f59:ec04:e5c6:bba4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 447251EC0288;
        Wed,  7 Apr 2021 14:00:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617796800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LeY+07bR0TuE9HnIC7Rc6eSIf93JZvl4Djq7JYVyZyc=;
        b=PLidQaeAxuv79aYrMgbPzrVB3WSAViBnd8/m+qvTo2tJbpWIMgbjBmboTUqzMoym4OMpUW
        NvYFxkfpTw5oqhWfjZh7PTTRxLH5I/Oi/Mi/ErdP0yMAJQcsXpQFzYY+3NTQ76SsU6Vjeq
        Oe/zXUiF10xFNp0bD6Zed+TJ3zmWrx0=
Date:   Wed, 7 Apr 2021 13:59:59 +0200
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
Subject: Re: [RFC Part1 PATCH 07/13] x86/compressed: register GHCB memory
 when SNP is active
Message-ID: <20210407115959.GC25319@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-8-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-8-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:18AM -0500, Brijesh Singh wrote:
> The SEV-SNP guest is required to perform GHCB GPA registration. This is

Why does it need to do that? Some additional security so as to not allow
changing the GHCB once it is established?

I'm guessing that's enforced by the SNP fw and we cannot do that
retroactively for SEV...? Because it sounds like a nice little thing we
could do additionally.

> because the hypervisor may prefer that a guest use a consistent and/or
> specific GPA for the GHCB associated with a vCPU. For more information,
> see the GHCB specification section 2.5.2.

I think you mean

"2.3.2 GHCB GPA Registration"

Please use the section name too because that doc changes from time to
time.

Also, you probably should update it here:

https://bugzilla.kernel.org/show_bug.cgi?id=206537

> diff --git a/arch/x86/boot/compressed/sev-snp.c b/arch/x86/boot/compressed/sev-snp.c
> index 5c25103b0df1..a4c5e85699a7 100644
> --- a/arch/x86/boot/compressed/sev-snp.c
> +++ b/arch/x86/boot/compressed/sev-snp.c
> @@ -113,3 +113,29 @@ void sev_snp_set_page_shared(unsigned long paddr)
>  {
>  	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_SHARED);
>  }
> +
> +void sev_snp_register_ghcb(unsigned long paddr)

Right and let's prefix SNP-specific functions with "snp_" only so that
it is clear which is wcich when looking at the code.

> +{
> +	u64 pfn = paddr >> PAGE_SHIFT;
> +	u64 old, val;
> +
> +	if (!sev_snp_enabled())
> +		return;
> +
> +	/* save the old GHCB MSR */
> +	old = sev_es_rd_ghcb_msr();
> +
> +	/* Issue VMGEXIT */

No need for that comment.

> +	sev_es_wr_ghcb_msr(GHCB_REGISTER_GPA_REQ_VAL(pfn));
> +	VMGEXIT();
> +
> +	val = sev_es_rd_ghcb_msr();
> +
> +	/* If the response GPA is not ours then abort the guest */
> +	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_REGISTER_GPA_RESP) ||
> +	    (GHCB_REGISTER_GPA_RESP_VAL(val) != pfn))
> +		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);

Yet another example where using a specific termination reason could help
with debugging guests. Looking at the GHCB spec, I hope GHCBData[23:16]
is big enough for all reasons. I'm sure it can be extended ofc ...

:-)

> +	/* Restore the GHCB MSR value */
> +	sev_es_wr_ghcb_msr(old);
> +}
> diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
> index f514dad276f2..0523eb21abd7 100644
> --- a/arch/x86/include/asm/sev-snp.h
> +++ b/arch/x86/include/asm/sev-snp.h
> @@ -56,6 +56,13 @@ struct __packed snp_page_state_change {
>  	struct snp_page_state_entry entry[SNP_PAGE_STATE_CHANGE_MAX_ENTRY];
>  };
>  
> +/* GHCB GPA register */
> +#define GHCB_REGISTER_GPA_REQ	0x012UL
> +#define		GHCB_REGISTER_GPA_REQ_VAL(v)		(GHCB_REGISTER_GPA_REQ | ((v) << 12))
> +
> +#define GHCB_REGISTER_GPA_RESP	0x013UL

Let's append "UL" to the other request numbers for consistency.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
