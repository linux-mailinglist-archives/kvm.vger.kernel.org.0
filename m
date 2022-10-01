Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247455F1E6B
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 19:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJARdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Oct 2022 13:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiJARdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Oct 2022 13:33:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B2624B;
        Sat,  1 Oct 2022 10:33:38 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e707329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e707:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4ADFF1EC0528;
        Sat,  1 Oct 2022 19:33:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1664645613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RIAHQvcTp1IhnuHkExqToXgHdcRkReCkndMAHTNwQEI=;
        b=lACJkGYm0mYkI2Vxsy72UegxjesbPKSc9LFwT2R0w05XLTwT/bGMh5s5BOOWOxnCUjFkrX
        ktOdrsiZrU1yVrH3PpnRfljEqRfsoKEvgR9iGpCGGqX88ZbLkrn35OFr8Ea2BdD1qqLhxV
        j7Nbn+Ns5+T0040/2lbKUrPSILpReUk=
Date:   Sat, 1 Oct 2022 19:33:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize
 the AMD-SP for SEV-SNP
Message-ID: <Yzh558vy+rJfsBBq@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:04:29PM +0000, Ashish Kalra wrote:
> +static int __sev_snp_init_locked(int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +	int rc = 0;
> +
> +	if (!psp || !psp->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp->sev_data;
> +
> +	if (sev->snp_inited)

snp_inited? That's silly.

	snp_initialized

pls.

> +		return 0;
> +
> +	/*
> +	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h

	/* Clear MSR_VM_HSAVE_PA on all cores before SNP_INIT */

> +	 * across all cores.
> +	 */
> +	on_each_cpu(snp_set_hsave_pa, NULL, 1);
> +
> +	/* Issue the SNP_INIT firmware command. */

Useless comment.

> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
> +	if (rc)
> +		return rc;
> +
> +	/* Prepare for first SNP guest launch after INIT */
> +	wbinvd_on_all_cpus();

Can you put a wbinvd() in snp_set_hsave_pa() instead and save yourself
the second IPI?

Or is that order of the commands:

	1. clear MSR IPI
	2. SNP_INIT
	3. WBINVD IPI
	4. ...

mandatory?

...

> +static int __sev_snp_shutdown_locked(int *error)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	int ret;
> +
> +	if (!sev->snp_inited)
> +		return 0;
> +
> +	/* SHUTDOWN requires the DF_FLUSH */
> +	wbinvd_on_all_cpus();
> +	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);

Why isn't this retval checked?

> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
> +	if (ret) {
> +		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
> +		return ret;
> +	}
> +
> +	sev->snp_inited = false;
> +	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
> +
> +	return ret;
> +}

...

>  void sev_dev_destroy(struct psp_device *psp)
> @@ -1287,6 +1385,26 @@ void sev_pci_init(void)
>  		}
>  	}
>  
> +	/*
> +	 * If boot CPU supports the SNP, then first attempt to initialize

s/the SNP/SNP/g

> +	 * the SNP firmware.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
> +		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
> +			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
> +				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> +		} else {
> +			rc = sev_snp_init(&error);
> +			if (rc) {
> +				/*
> +				 * If we failed to INIT SNP then don't abort the probe.

Who's "we"?

> +				 * Continue to initialize the legacy SEV firmware.
> +				 */
> +				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
> +			}
> +		}
> +	}
> +
>  	/* Obtain the TMR memory area for SEV-ES use */
>  	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
>  	if (!sev_es_tmr)

...

> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 01ba9dc46ca3..ef4d42e8c96e 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -769,6 +769,20 @@ struct sev_data_snp_init_ex {
>   */
>  int sev_platform_init(int *error);
>  
> +/**
> + * sev_snp_init - perform SEV SNP_INIT command
> + *
> + * @error: SEV command return code
> + *
> + * Returns:
> + * 0 if the SEV successfully processed the command
> + * -%ENODEV    if the SEV device is not available
> + * -%ENOTSUPP  if the SEV does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if the SEV returned a non-zero return code

Something's weird with those args. I think it should be

	%-ENODEV

and so on...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
