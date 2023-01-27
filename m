Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B2267DC6E
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjA0C4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjA0C43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 21:56:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE8C13D;
        Thu, 26 Jan 2023 18:56:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF563619F6;
        Fri, 27 Jan 2023 02:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB381C433EF;
        Fri, 27 Jan 2023 02:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674788187;
        bh=0eCg5dIYL7w+G5CITMsIeizICcSGo/snHPCDO6PDgKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BJbOckcgyZIq35jeA/6/AP3qbtJeH+JLHtgIVNquz/nyaaNBKpG4PcEyOFJxUfCK+
         +53r3+qv9hfghb7HrWhoUEWVpgl2doCQuxS8HplhYFNEdKXDt8KNYgLlBS9izqNJE8
         VzcWEwrSPcLdPjOYUWirxVQevkiRezp4CkvnzejVmEXfg5nYFLIOVDx7kCI+8SVdJY
         DKnAh5v4q4vclf+hmCp5wmFIRTutBx6TD3QjALeMzfKeUe4nbIFSFyklQMYC62h3Ny
         YzAlX0gTSQUBXt2LfitDvKzQRhjU2DdxyDQRPL0WsvKueWiRA8XMaEy8buDKLx3kLK
         aoTAkhF8U/bwg==
Date:   Fri, 27 Jan 2023 02:56:24 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@profian.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Harald Hoyer <harald@profian.com>,
        Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH RFC 8/8] crypto: ccp: Move __sev_snp_init_locked() call
 inside __sev_platform_init_locked()
Message-ID: <Y9M9WN80vtAaKxjD@kernel.org>
References: <20230127025237.269680-1-jarkko@profian.com>
 <20230127025237.269680-9-jarkko@profian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127025237.269680-9-jarkko@profian.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 02:52:37AM +0000, Jarkko Sakkinen wrote:
> The following functions end up calling sev_platform_init() or
> __sev_platform_init_locked():
> 
> * sev_guest_init()
> * sev_ioctl_do_pek_csr
> * sev_ioctl_do_pdh_export()
> * sev_ioctl_do_pek_import()
> * sev_ioctl_do_pek_pdh_gen()
> * sev_pci_init()
> 
> Only sev_guest_init() and sev_pci_init() also call sev_snp_init().
> Address this by calling __sev_snp_init_locked() inside
> __sev_platform_init_locked() before any other initialization.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> ---
>  arch/x86/kvm/svm/sev.c       |  4 +--
>  drivers/crypto/ccp/sev-dev.c | 51 +++++++++++++-----------------------
>  include/linux/psp-sev.h      | 15 -----------
>  3 files changed, 19 insertions(+), 51 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5e4666b79689..2dd56f59fc50 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -343,11 +343,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  			goto e_free;
>  
>  		mutex_init(&sev->guest_req_lock);
> -		ret = sev_snp_init(&argp->error, false);
> -	} else {
> -		ret = sev_platform_init(&argp->error);
>  	}
>  
> +	ret = sev_platform_init(&argp->error);
>  	if (ret)
>  		goto e_free;
>  
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 50e73df966ec..be040926f66a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -102,6 +102,7 @@ struct sev_data_range_list *snp_range_list;
>  static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
>  
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
> +static int __sev_snp_init_locked(int *error);
>  
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
> @@ -965,7 +966,8 @@ static int __sev_platform_init_locked(int *error)
>  {
>  	struct psp_device *psp = psp_master;
>  	struct sev_device *sev;
> -	int rc = 0, psp_ret = -1;
> +	int psp_ret = -1;
> +	int rc;
>  	int (*init_function)(int *error);
>  
>  	if (!psp || !psp->sev_data)
> @@ -976,6 +978,18 @@ static int __sev_platform_init_locked(int *error)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> +	rc = __sev_snp_init_locked(error);
> +	if (rc < 0 && rc != -ENODEV)
> +		return rc;
> +
> +	if (!sev_es_tmr) {
> +		/* Obtain the TMR memory area for SEV-ES use */
> +		sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
> +		if (!sev_es_tmr)
> +			dev_warn(sev->dev,
> +				 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> +	}
> +
>  	if (sev_init_ex_buffer) {
>  		init_function = __sev_init_ex_locked;
>  		rc = sev_read_init_ex_file();
> @@ -1373,6 +1387,9 @@ static int __sev_snp_init_locked(int *error)
>  	struct sev_device *sev;
>  	int rc = 0;
>  
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENODEV;
> +
>  	if (!psp || !psp->sev_data)
>  		return -ENODEV;
>  
> @@ -1457,24 +1474,6 @@ static int __sev_snp_init_locked(int *error)
>  	return rc;
>  }
>  
> -int sev_snp_init(int *error, bool init_on_probe)
> -{
> -	int rc;
> -
> -	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> -		return -ENODEV;
> -
> -	if (init_on_probe && !psp_init_on_probe)
> -		return 0;
> -
> -	mutex_lock(&sev_cmd_mutex);
> -	rc = __sev_snp_init_locked(error);
> -	mutex_unlock(&sev_cmd_mutex);
> -
> -	return rc;
> -}
> -EXPORT_SYMBOL_GPL(sev_snp_init);
> -
>  static int __sev_snp_shutdown_locked(int *error)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -2319,14 +2318,6 @@ void sev_pci_init(void)
>  		}
>  	}
>  
> -	rc = sev_snp_init(&error, true);
> -	if (rc)
> -		/*
> -		 * Don't abort the probe if SNP INIT failed,
> -		 * continue to initialize the legacy SEV firmware.
> -		 */
> -		dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
> -
>  	/*
>  	 * If boot CPU supports SNP, then first attempt to initialize
>  	 * the SNP firmware.
> @@ -2341,12 +2332,6 @@ void sev_pci_init(void)
>  		}
>  	}
>  
> -	/* Obtain the TMR memory area for SEV-ES use */
> -	sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
> -	if (!sev_es_tmr)
> -		dev_warn(sev->dev,
> -			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> -
>  	if (!psp_init_on_probe)
>  		return;
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 970a9de0ed20..ef0c6941a8f4 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -794,21 +794,6 @@ struct sev_data_snp_shutdown_ex {
>   */
>  int sev_platform_init(int *error);
>  
> -/**
> - * sev_snp_init - perform SEV SNP_INIT command
> - *
> - * @error: SEV command return code
> - * @init_on_probe: indicates if called during module probe/init
> - *
> - * Returns:
> - * 0 if the SEV successfully processed the command
> - * -%ENODEV    if the SEV device is not available
> - * -%ENOTSUPP  if the SEV does not support SEV
> - * -%ETIMEDOUT if the SEV command timed out
> - * -%EIO       if the SEV returned a non-zero return code
> - */
> -int sev_snp_init(int *error, bool init_on_probe);
> -
>  /**
>   * sev_platform_status - perform SEV PLATFORM_STATUS command
>   *
> -- 
> 2.38.1
> 

I tested this with both values for psp_init_on_probe.

BR, Jarkko
