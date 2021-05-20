Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FC438B3FB
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 18:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhETQEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 12:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbhETQDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 12:03:45 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695AFC061760;
        Thu, 20 May 2021 09:02:23 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0eb60047444127d595167e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:b600:4744:4127:d595:167e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 274391EC0632;
        Thu, 20 May 2021 18:02:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621526541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GX2XQzvfPLgXrP1lIElAkbHpsf60KiOZXtIKg3YN+BI=;
        b=gWj7j52NqPF/YFJtdZ/1A706qZ/ee2C5fYgzIo6SUXPKCFU2HDB04OSq02opeZkNi1FWPU
        zA8LldKclQf3aHEV3chuqYOSMAeIAJe15+jkXsQ5JdsnopD1D0DnyfZ9ktkAdRvpZFlZb3
        S2Qf3Lfy8R9UdEuaUF1zBneCc7CEhyU=
Date:   Thu, 20 May 2021 18:02:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 09/20] x86/sev: check SEV-SNP features
 support
Message-ID: <YKaIDAHOz4+soLxi@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-10-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-10-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:05AM -0500, Brijesh Singh wrote:
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index 6d9055427f37..7badbeb6cb95 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -25,6 +25,8 @@
>  
>  struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
>  struct ghcb *boot_ghcb;
> +static u64 sev_status_val;

msr_sev_status should be more descriptive.

> +static bool sev_status_checked;

You don't need this one - you can simply do

	if (!msr_sev_status)
		read the MSR.

>  /*
>   * Copy a version of this function here - insn-eval.c can't be used in
> @@ -119,11 +121,30 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>  /* Include code for early handlers */
>  #include "../../kernel/sev-shared.c"
>  
> +static inline bool sev_snp_enabled(void)
> +{
> +	unsigned long low, high;
> +
> +	if (!sev_status_checked) {
> +		asm volatile("rdmsr\n"
> +			     : "=a" (low), "=d" (high)
> +			     : "c" (MSR_AMD64_SEV));
> +		sev_status_val = (high << 32) | low;
> +		sev_status_checked = true;
> +	}
> +
> +	return sev_status_val & MSR_AMD64_SEV_SNP_ENABLED ? true : false;

	return msr_sev_status & MSR_AMD64_SEV_SNP_ENABLED;

is enough.

> +}
> +
>  static bool early_setup_sev_es(void)
>  {
>  	if (!sev_es_negotiate_protocol())
>  		sev_es_terminate(0, GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
>  
> +	/* If SEV-SNP is enabled then check if the hypervisor supports the SEV-SNP features. */

80 cols like the rest of this file pls.

> +	if (sev_snp_enabled() && !sev_snp_check_hypervisor_features())
> +		sev_es_terminate(0, GHCB_SEV_ES_REASON_SNP_UNSUPPORTED);
> +
>  	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
>  		return false;

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
