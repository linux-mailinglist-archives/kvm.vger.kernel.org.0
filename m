Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A9E38FF79
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 12:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhEYKp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 06:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhEYKp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 06:45:26 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28F3C061574;
        Tue, 25 May 2021 03:43:56 -0700 (PDT)
Received: from zn.tnic (p4fed31b3.dip0.t-ipconnect.de [79.237.49.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3FC2D1EC0249;
        Tue, 25 May 2021 12:43:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621939435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WWFHfF3RAY6a+oyQek8PAZ9HHRMqle11WO6ub4mR6o8=;
        b=bAsBYje036C8mLeaxhYCUHfNSjE+vHH7omRPVJSrjxHkut7G5i80HqIDVDgUg9pYqNeOK+
        MeHxcj8UpaDed8kWtQ10du0mGYrrG6zIJaOvNeQh/7y7pzO0CSMebLM778cUO/HAMVP2xu
        RnahFWFKiykSnrm43jlLL8a0gPgmkqc=
Date:   Tue, 25 May 2021 12:41:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 12/20] x86/compressed: Register GHCB memory
 when SEV-SNP is active
Message-ID: <YKzUYjecerjTeT+H@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-13-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-13-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:08AM -0500, Brijesh Singh wrote:
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 733fca403ae5..7487d4768ef0 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -88,6 +88,18 @@
>  #define GHCB_MSR_PSC_RSVD_MASK		0xfffffULL
>  #define GHCB_MSR_PSC_RESP_VAL(val)	((val) >> GHCB_MSR_PSC_ERROR_POS)
>  
> +/* GHCB GPA Register */
> +#define GHCB_MSR_GPA_REG_REQ		0x012
> +#define GHCB_MSR_GPA_REG_VALUE_POS	12
> +#define GHCB_MSR_GPA_REG_VALUE_MASK	0xfffffffffffffULL

GENMASK_ULL

> +#define GHCB_MSR_GPA_REQ_VAL(v)		\
> +		(((v) << GHCB_MSR_GPA_REG_VALUE_POS) | GHCB_MSR_GPA_REG_REQ)
> +
> +#define GHCB_MSR_GPA_REG_RESP		0x013
> +#define GHCB_MSR_GPA_REG_RESP_VAL(v)	((v) >> GHCB_MSR_GPA_REG_VALUE_POS)
> +#define GHCB_MSR_GPA_REG_ERROR		0xfffffffffffffULL
> +#define GHCB_MSR_GPA_INVALID		~0ULL

Ditto.

> +
>  /* SNP Page State Change NAE event */
>  #define VMGEXIT_PSC_MAX_ENTRY		253
>  #define VMGEXIT_PSC_INVALID_HEADER	0x100000001
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 085d3d724bc8..140c5bc07fc2 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -81,6 +81,22 @@ static bool ghcb_get_hv_features(void)
>  	return true;
>  }
>  
> +static void snp_register_ghcb(unsigned long paddr)
> +{
> +	unsigned long pfn = paddr >> PAGE_SHIFT;
> +	u64 val;
> +
> +	sev_es_wr_ghcb_msr(GHCB_MSR_GPA_REQ_VAL(pfn));
> +	VMGEXIT();
> +
> +	val = sev_es_rd_ghcb_msr();
> +
> +	/* If the response GPA is not ours then abort the guest */
> +	if ((GHCB_RESP_CODE(val) != GHCB_MSR_GPA_REG_RESP) ||
> +	    (GHCB_MSR_GPA_REG_RESP_VAL(val) != pfn))
> +		sev_es_terminate(1, GHCB_TERM_REGISTER);

Nice, special termination reasons which say why the guest terminates,
cool!

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
