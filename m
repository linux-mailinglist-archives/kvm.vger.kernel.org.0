Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9896481F52
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 19:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241742AbhL3Sw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 13:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241744AbhL3Sw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 13:52:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC94C06173F
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 10:52:57 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id v11so22050189pfu.2
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 10:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7LN0LYaPJq+96WHHrtqpjEIWMUaO4vFF4rfqypL1bR0=;
        b=rpWu9btVqmQ0QTbmhhUK9Dz89dFgfjXlqrAlod7GAGD11uxF9ibLliA+w90bMIj+yu
         TIOjH72MZO8MQ7A8vUTAUp8oWRFg8/BipD06png87ugKRx0MKigkwcE4v6Ox7L1hPCRF
         LbBZaDMOePI/nMwaCJr14Wu2PvJLwtFiw+54GL+KkzIMdHM3FccaqN4+6O48BHw6xq/Q
         3+12yH+FzOyHGDuAJBoBoI7EUk7q5/X/DE5Ns7fdkWsox8rQ/8JYcof7evWLlW7OBNDI
         +3dLx/XSBDQ6s6BWy9kD/uLxfdiPVleJt9v5d8jg2rY0ZTdLC080XnqpHl95VAbCakt7
         +40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7LN0LYaPJq+96WHHrtqpjEIWMUaO4vFF4rfqypL1bR0=;
        b=R7kplLrZl5rZr8pEr9w7NTigb4gDJgynxASfxnoCGp69vdkely1dZxyBVQ4/D732Je
         /fJZJTsbBybfMArcbtK5LMYHO8UP2P5TOFPoAqRkYzwNluvY9X1nbNYZBhm3N9b2ZCiy
         jMl6vqJlNT7R22CcGQM9A21q1mbIGXXJwlUlOQsbnfdZep3Ar3qZYEfAFubNq+0LsKOH
         Xji7q+/4DSyVfn6XCtWPhKmL16O13NAv8GnEUk/B7ujn+I67hy7gDxIPC82su5eynXQ3
         7tQGgWE8ylH2jhHGXsW885BEododozr4RR/exnuCbVeTVZqUdyqOjuTA8kLLkcXrRzVP
         oBDA==
X-Gm-Message-State: AOAM531tmn18FLPH50+EI+eIRMuDPY7QghoUHI7DKCIInUpzIu7FnuKN
        KLtWTBOsZmNlDh1CO/KHPY9CNw==
X-Google-Smtp-Source: ABdhPJzjf15Pudr7gJPrk1rYboV0PPDYswWEE3HKGVacbEvnTAzwn3YOFqw0PNuZsiPShsWRZbt0GA==
X-Received: by 2002:a05:6a00:21cd:b0:4bc:35e8:eaea with SMTP id t13-20020a056a0021cd00b004bc35e8eaeamr10048326pfj.23.1640890376505;
        Thu, 30 Dec 2021 10:52:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r7sm20049373pgm.15.2021.12.30.10.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 10:52:55 -0800 (PST)
Date:   Thu, 30 Dec 2021 18:52:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH v8 22/40] x86/sev: move MSR-based VMGEXITs for CPUID to
 helper
Message-ID: <Yc4ABL2EbBlwjma5@google.com>
References: <20211210154332.11526-1-brijesh.singh@amd.com>
 <20211210154332.11526-23-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210154332.11526-23-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Brijesh Singh wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> This code will also be used later for SEV-SNP-validated CPUID code in
> some cases, so move it to a common helper.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kernel/sev-shared.c | 84 +++++++++++++++++++++++++-----------
>  1 file changed, 58 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 3aaef1a18ffe..d89481b31022 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -194,6 +194,58 @@ enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
>  	return verify_exception_info(ghcb, ctxt);
>  }
>  
> +static int sev_cpuid_hv(u32 func, u32 subfunc, u32 *eax, u32 *ebx,

Having @subfunc, a.k.a. index, in is weird/confusing/fragile because it's not consumed,
nor is it checked.  Peeking ahead, it looks like all future users pass '0'.  Taking the
index but dropping it on the floor is asking for future breakage.  Either drop it or
assert that it's zero.

> +			u32 *ecx, u32 *edx)
> +{
> +	u64 val;
> +
> +	if (eax) {
> +		sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(func, GHCB_CPUID_REQ_EAX));
> +		VMGEXIT();
> +		val = sev_es_rd_ghcb_msr();
> +
> +		if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
> +			return -EIO;
> +
> +		*eax = (val >> 32);
> +	}
> +
> +	if (ebx) {
> +		sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(func, GHCB_CPUID_REQ_EBX));
> +		VMGEXIT();
> +		val = sev_es_rd_ghcb_msr();
> +
> +		if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
> +			return -EIO;
> +
> +		*ebx = (val >> 32);
> +	}
> +
> +	if (ecx) {
> +		sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(func, GHCB_CPUID_REQ_ECX));
> +		VMGEXIT();
> +		val = sev_es_rd_ghcb_msr();
> +
> +		if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
> +			return -EIO;
> +
> +		*ecx = (val >> 32);
> +	}
> +
> +	if (edx) {
> +		sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(func, GHCB_CPUID_REQ_EDX));
> +		VMGEXIT();
> +		val = sev_es_rd_ghcb_msr();
> +
> +		if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
> +			return -EIO;
> +
> +		*edx = (val >> 32);
> +	}

That's a lot of pasta!  If you add

  static int __sev_cpuid_hv(u32 func, int reg_idx, u32 *reg)
  {
	u64 val;

	if (!reg)
		return 0;

	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(func, reg_idx));
	VMGEXIT();
	val = sev_es_rd_ghcb_msr();
	if (GHCB_RESP_CODE(val) != GHCB_MSR_CPUID_RESP)
		return -EIO;

	*reg = (val >> 32);
	return 0;
  }

then this helper can become something like:

  static int sev_cpuid_hv(u32 func, u32 *eax, u32 *ebx, u32 *ecx, u32 *edx)
  {
	int ret;

	ret = __sev_cpuid_hv(func, GHCB_CPUID_REQ_EAX, eax);
	ret = ret ? : __sev_cpuid_hv(func, GHCB_CPUID_REQ_EBX, ebx);
	ret = ret ? : __sev_cpuid_hv(func, GHCB_CPUID_REQ_ECX, ecx);
	ret = ret ? : __sev_cpuid_hv(func, GHCB_CPUID_REQ_EDX, edx);

	return ret;
  }

> +
> +	return 0;
> +}
> +
