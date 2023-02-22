Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C1869FCF7
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 21:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjBVUY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 15:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjBVUY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 15:24:27 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062172A99E;
        Wed, 22 Feb 2023 12:24:26 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id m6so11705868lfq.5;
        Wed, 22 Feb 2023 12:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677097464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+88bH++uusEhsdCC8mbBZL+IqsNGdL/GWZjkaswK2g=;
        b=TJefIB0qefiV0E0Eh1hvJ3Ok+jvjjbxXtGzunNbw3xbB0mLj8aZB6Xz6/dfJEWmZLV
         dIRe6mkVqEYCmWm5sjhsgpaI5Sir+3QpDea40ZLSjncBq3UgEsDDr14oiw2YB6vGI66C
         CQkmGMi/QtXDGjllQwOWjDCshZdYumOJCoFGCVxGD5jYNpf1df9b4o1NKn+jrtR+cZ4B
         L3v35eXWzc6k5T42Pjk9J3br4ElN/hd0mUS4uRDs2sTjuhnTYEJv2C63Of1b7m149Vfc
         Zpg6vGjONgTyHKz2nSnMiYpCmr34O1+LUNOC5YbxUmkNgEPvhMY1V6M923H2cVZ0WFFI
         R10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677097464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c+88bH++uusEhsdCC8mbBZL+IqsNGdL/GWZjkaswK2g=;
        b=XPZPyRj+3N26ZdrB9GnXFOTk8ufnLjclTg4T8oj55cCjV1YD0viaK4qwdElAvStcBE
         1yPzJAnTBEUkOEA+FNtJvVWzUFcfbMnm+lFaK4Eu3uIMArPkF55x6vhhEmlHBHtfkGM5
         3RVIsLQWsz0aREAE/TIF5df3RCwnNqJFAXhKa4FF5Opnobsvr5mu7OnQcDOekQzexTy4
         DJva1yKBNX91whK/p9f/guHmV+VxBK/QMe8PFHA9NCf3IrY1pnAQ6MS1AdXsyG2iwoJ/
         Ike5dMvSBqeLCXTzErPZQF9JTRSYk50JIkPp7qCb46oF9x9NGVZH0J/Lb1GH+/Nx6snG
         N9YQ==
X-Gm-Message-State: AO0yUKWk11TD0uIAQ8ouFD45JZh39FhKv2jXCnod0WqWWEmjVFqvaQqH
        YB7HBihvtdGLIWc0QoSDdaM=
X-Google-Smtp-Source: AK7set/Whf/6LlbBrRRKoUl5FBXbdlxpDW9V7S/fwraxQrmyav/hzmWIjYBVbXE8NNuUhPQcghsbwg==
X-Received: by 2002:ac2:5470:0:b0:4d2:a03b:2840 with SMTP id e16-20020ac25470000000b004d2a03b2840mr3520811lfn.4.1677097463919;
        Wed, 22 Feb 2023 12:24:23 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a8-20020a056512020800b004cb1de3f487sm1031840lfo.104.2023.02.22.12.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 12:24:23 -0800 (PST)
Date:   Wed, 22 Feb 2023 22:24:21 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 28/56] crypto: ccp: Provide APIs to query
 extended attestation report
Message-ID: <20230222222421.00001a62@gmail.com>
In-Reply-To: <20230220183847.59159-29-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-29-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:19 -0600
Michael Roth <michael.roth@amd.com> wrote:

It seems in the discussion:
https://lore.kernel.org/lkml/f18fae8b-a928-cd82-e0b3-eac62ad3e106@amd.com/,
this API is going to be removed. Will that fix land in this patch series or not?
If not, It would be better to mention it in the comment message of this one
or patch 45.
If yes, I guess this patch is not needed.

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Version 2 of the GHCB specification defines VMGEXIT that is used to get
> the extended attestation report. The extended attestation report includes
> the certificate blobs provided through the SNP_SET_EXT_CONFIG.
> 
> The snp_guest_ext_guest_request() will be used by the hypervisor to get
> the extended attestation report. See the GHCB specification for more
> details.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 33 +++++++++++++++++++++++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b56b00ca2cd4..e65563bc8298 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2017,6 +2017,53 @@ int sev_guest_df_flush(int *error)
>  }
>  EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>  
> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
> +{
> +	unsigned long expected_npages;
> +	struct sev_device *sev;
> +	int rc;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp_master->sev_data;
> +
> +	if (!sev->snp_initialized)
> +		return -EINVAL;
> +
> +	mutex_lock(&sev->snp_certs_lock);
> +	/*
> +	 * Check if there is enough space to copy the certificate chain. Otherwise
> +	 * return ERROR code defined in the GHCB specification.
> +	 */
> +	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
> +	if (*npages < expected_npages) {
> +		*npages = expected_npages;
> +		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
> +		mutex_unlock(&sev->snp_certs_lock);
> +		return -EINVAL;
> +	}
> +
> +	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);
> +	if (rc) {
> +		mutex_unlock(&sev->snp_certs_lock);
> +		return rc;
> +	}
> +
> +	/* Copy the certificate blob */
> +	if (sev->snp_certs_data) {
> +		*npages = expected_npages;
> +		memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
> +	} else {
> +		*npages = 0;
> +	}
> +
> +	mutex_unlock(&sev->snp_certs_lock);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
> +
>  static void sev_exit(struct kref *ref)
>  {
>  	misc_deregister(&misc_dev->misc);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index d19744807471..81bafc049eca 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -931,6 +931,32 @@ void snp_free_firmware_page(void *addr);
>   */
>  void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
>  
> +/**
> + * snp_guest_ext_guest_request - perform the SNP extended guest request command
> + *  defined in the GHCB specification.
> + *
> + * @data: the input guest request structure
> + * @vaddr: address where the certificate blob need to be copied.
> + * @npages: number of pages for the certificate blob.
> + *    If the specified page count is less than the certificate blob size, then the
> + *    required page count is returned with error code defined in the GHCB spec.
> + *    If the specified page count is more than the certificate blob size, then
> + *    page count is updated to reflect the amount of valid data copied in the
> + *    vaddr.
> + *
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +				unsigned long vaddr, unsigned long *npages,
> +				unsigned long *error);
> +
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  static inline int
> @@ -968,6 +994,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>  
>  static inline void snp_free_firmware_page(void *addr) { }
>  
> +static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +					      unsigned long vaddr, unsigned long *n,
> +					      unsigned long *error)
> +{
> +	return -ENODEV;
> +}
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

