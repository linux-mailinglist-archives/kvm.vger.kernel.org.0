Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BFD6A7611
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCAVUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCAVUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:20:53 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDE341B4F;
        Wed,  1 Mar 2023 13:20:51 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id t11so19527375lfr.1;
        Wed, 01 Mar 2023 13:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677705650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nu3x+PS5kBI5WP9BR112ZTU4z9UIuyI7KKIlTlTHeoQ=;
        b=SzVg/5zL41KXogvGm5lKOvxW1C3rCcPhuShpSJvvVahiKNg7LGudNS2LH6j8JQwW/h
         D7MVwCtdUPl1j1jE9kJclFZdtn9iRW5LyNd7aKbtMz4/5rZzFvDi5rXeG5HFWz5+Omcp
         xnF9tJ808zJ2sE4A4CYZBFuMW6qLFAI6RwOlITc7gwR09jtWmUW2C28lCvd04uLEA+Ww
         JzEOdxPGeuRgAoJYtWx1cqh5gno1NHnIO0hzKo2GMiMEH5h05dmHv8BFYmTGM9DFzenf
         y9DL9YXcb4j0+9bESYzwkhtMwJjcZw44B47m5Ol4/WVYSVn1DaBtJgUPF/n+S0t4NE16
         QpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677705650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nu3x+PS5kBI5WP9BR112ZTU4z9UIuyI7KKIlTlTHeoQ=;
        b=FbBpYoRxs436xbU+Z9bmqDoGtaybTy60w915gkEGIeFcxaFmZhyE9dmIbRM8Fm2NM7
         H2aeKBUMSV2lg8aZYsH7Bid7b9ZseUxFCNyrznPQwGucMvAju1hoW1fInRnqCKWVa+LL
         dUSxaxSe+U2ZwGy/IGn4SgOXITshckB2cV1xS6PB7TrnWkShVkTVtaLGhbz/CEhfc7Qn
         7v2VL/8HnnIUBDY0vRh7GAy291zqA+D6xDDWu4mU3yggv2o5rnk7pVnrliVCKKwg89IP
         fzOb5QCpsh95v4y48wB9Hz/QxNM+tTg7Vg/I6cTF9UxEjFDcbN3B+CuzX2/5GhogSNGj
         6BhQ==
X-Gm-Message-State: AO0yUKVEs+GKTaZzZ1pXp4e0y3eOdAodY/EkZLoUJOkR6QfPEFzR+EPk
        eIZIzjmJ8Lk9l8meMbvjxkk=
X-Google-Smtp-Source: AK7set8yk+qcKeH8xZqt1MHJtbzkX+ZnH5n15zWSZb9IPULga8cN+Cba34unxob+c60jagUQ1AfbYw==
X-Received: by 2002:ac2:4c2a:0:b0:4db:3890:cb59 with SMTP id u10-20020ac24c2a000000b004db3890cb59mr1713252lfq.1.1677705649622;
        Wed, 01 Mar 2023 13:20:49 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id j8-20020a19f508000000b004d093d60f50sm1861420lfb.215.2023.03.01.13.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 13:20:49 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 23:20:45 +0200
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
Subject: Re: [PATCH RFC v8 52/56] ccp: Add support to decrypt the page
Message-ID: <20230301232045.0000502e@intel.com>
In-Reply-To: <20230220183847.59159-53-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-53-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:43 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add support to decrypt guest encrypted memory. These API interfaces can
> be used for example to dump VMCBs on SNP guest exit.
> 

What kinds of check will be applied from firmware when VMM decrypts this
page? I suppose there has to be kinda mechanism to prevent VMM to decrypt
any page in the guest. It would be nice to have some introduction about
it in the comments.

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: minor commit fixups]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 32 ++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 22 ++++++++++++++++++++--
>  2 files changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e65563bc8298..bf5167b2acfc 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2017,6 +2017,38 @@ int sev_guest_df_flush(int *error)
>  }
>  EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>  
> +int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
> +{
> +	struct sev_data_snp_dbg data = {0};
> +	struct sev_device *sev;
> +	int ret;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp_master->sev_data;
> +
> +	if (!sev->snp_initialized)
> +		return -EINVAL;
> +
> +	data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
> +	data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
> +	data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);
> +
> +	/* The destination page must be in the firmware state. */
> +	if (rmp_mark_pages_firmware(data.dst_addr, 1, false))
> +		return -EIO;
> +
> +	ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);
> +
> +	/* Restore the page state */
> +	if (snp_reclaim_pages(data.dst_addr, 1, false))
> +		ret = -EIO;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
> +
>  int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>  				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
>  {
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 81bafc049eca..92116e2b74fd 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -710,7 +710,6 @@ struct sev_data_snp_dbg {
>  	u64 gctx_paddr;				/* In */
>  	u64 src_addr;				/* In */
>  	u64 dst_addr;				/* In */
> -	u32 len;				/* In */
>  } __packed;
>  
>  /**
> @@ -913,13 +912,27 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>   * @error: SEV command return code
>   *
>   * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int sev_do_cmd(int cmd, void *data, int *psp_ret);
> +
> +/**
> + * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
> + *
> + * @sev_ret: sev command return code
> + *
> + * Returns:
>   * 0 if the SEV successfully processed the command
>   * -%ENODEV    if the SEV device is not available
>   * -%ENOTSUPP  if the SEV does not support SEV
>   * -%ETIMEDOUT if the SEV command timed out
>   * -%EIO       if the SEV returned a non-zero return code
>   */
> -int sev_do_cmd(int cmd, void *data, int *psp_ret);
> +int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
>  
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
> @@ -987,6 +1000,11 @@ static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_P
>  
>  void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
>  
> +static inline int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
> +{
> +	return -ENODEV;
> +}
> +
>  static inline void *snp_alloc_firmware_page(gfp_t mask)
>  {
>  	return NULL;

