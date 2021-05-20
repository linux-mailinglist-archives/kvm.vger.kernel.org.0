Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D9438B58C
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhETRyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:54:01 -0400
Received: from mail.skyhub.de ([5.9.137.197]:44986 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235791AbhETRyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:54:00 -0400
Received: from zn.tnic (p200300ec2f0eb6009f35b1f88a592069.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:b600:9f35:b1f8:8a59:2069])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D15011EC064C;
        Thu, 20 May 2021 19:52:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621533158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fqWT78r8absILqyZ0+NWjNXYlWzdX8hYWzydvSsw51g=;
        b=XlHOrw/WI7akbnhiyT8ZYKHdIbaI3O3Yds2i8qBfAT3wDosVPmpYUQbZbdzRn8czd8W3TP
        OBQ24YAw6tqAmQmFsJ+fFcq9cRyg36HZefJnTJL57moEg/FKHTNu1ipS3N8uhdDPsHxPFb
        n3zCbb991H1GdGH6QB90QLX+ahwXkjk=
Date:   Thu, 20 May 2021 19:52:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 11/20] x86/compressed: Add helper for
 validating pages in the decompression stage
Message-ID: <YKah5QInPK4+7xaC@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-12-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-12-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:07AM -0500, Brijesh Singh wrote:
> @@ -278,12 +279,28 @@ static int set_clr_page_flags(struct x86_mapping_info *info,
>  	if ((set | clr) & _PAGE_ENC)
>  		clflush_page(address);
>  
> +	/*
> +	 * If the encryption attribute is being cleared, then change the page state to
> +	 * shared in the RMP entry. Change of the page state must be done before the
> +	 * PTE updates.
> +	 */
> +	if (clr & _PAGE_ENC)
> +		snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);

From the last review:

The statement above already looks at clr - just merge the two together.

> @@ -136,6 +137,55 @@ static inline bool sev_snp_enabled(void)
>  	return sev_status_val & MSR_AMD64_SEV_SNP_ENABLED ? true : false;
>  }
>  
> +static void snp_page_state_change(unsigned long paddr, int op)

From the last review:

no need for too many prefixes on static functions - just call this one
__change_page_state() or so, so that the below one can be called...

> +{
> +	u64 val;
> +
> +	if (!sev_snp_enabled())
> +		return;
> +
> +	/*
> +	 * If the page is getting changed from private to shard then invalidate the page

							shared

And you can write this a lot shorter

	* If private -> shared, ...

> +	 * before requesting the state change in the RMP table.
> +	 */
> +	if ((op == SNP_PAGE_STATE_SHARED) && pvalidate(paddr, RMP_PG_SIZE_4K, 0))
> +		goto e_pvalidate;
> +
> +	/* Issue VMGEXIT to change the page state in RMP table. */
> +	sev_es_wr_ghcb_msr(GHCB_MSR_PSC_REQ_GFN(paddr >> PAGE_SHIFT, op));
> +	VMGEXIT();
> +
> +	/* Read the response of the VMGEXIT. */
> +	val = sev_es_rd_ghcb_msr();
> +	if ((GHCB_RESP_CODE(val) != GHCB_MSR_PSC_RESP) || GHCB_MSR_PSC_RESP_VAL(val))
> +		goto e_psc;

That label is used only once - just do the termination here directly and
remove it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
