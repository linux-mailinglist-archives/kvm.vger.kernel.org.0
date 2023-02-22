Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B66569F499
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 13:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjBVMcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 07:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBVMcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 07:32:23 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04A33A849;
        Wed, 22 Feb 2023 04:32:11 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id f16so7556852ljq.10;
        Wed, 22 Feb 2023 04:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677069130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyVpU31pGYL3hxPsk3WstIM/y2F79bUZeHHwWlTuPok=;
        b=i5CokvbD5k4JtMJKI1HL6SznirWdNw7nvi/OtYQ8HTQkDyzsBgVTh4acYuHYa31Mgi
         wuBrIaD8Hn1B96mrxbhRx+4n4JwiZjGhLbBO0wakqEVxXej7zJ2qZ922FKBjpUm+7xkL
         LouG0oUfsVvYE5z8GhK1ueJMdwOb7WSdSVIlp/dSRSTFvz1h+kyegE5EPbqCSiBgskSD
         +c55wkbx9xRC1gRjs7QPJJ+rDpV1MZR3Z7XO4lSDpc8HaoY0pfRbPxhqpxjrcBn651G0
         5FQGGa7XSelN3Xz4Ki3RkWdXEHHvY2/oBgxs+l2bYz+ozGBog8pWXha7mT377fO5ZOsn
         nOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677069130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyVpU31pGYL3hxPsk3WstIM/y2F79bUZeHHwWlTuPok=;
        b=DGpVx1AqATQGvW1u3uOCL5xPCDhwkyFh0sLmMgd5TBFE/rF7KrmDce4kYXcGjn4Vbe
         V0acSuEA+CGrCWNaLFrIaf7gzpFMNc/5ezh7VImao7GfWEqiG80tvbz3zJKj9QIC5buv
         Mf0li8fkSGEoWdF0qOHP5KlMGq7RWLM3QzE2Og91umthssmElWNframOxTrA1ehzug67
         Ow3bpyVLGX6c6mlUrGxo8p6WzgKNG8GlHdpi83TIRm2YxnOlzu/p3h25TNMxLdoUQDPe
         sY3eCSsm6LhDhBVA5waHPlAGmCSTgIi0ZcbKqXtxu9sMMA3jBvOvzTjmylW+Qudop+lp
         60AQ==
X-Gm-Message-State: AO0yUKW03yJ9i1SEPbt+08d/qEu8llft76lzpngHYmpy2jDh1j5Qf/U3
        N+1QliaGCClRofK9cv1SEss=
X-Google-Smtp-Source: AK7set8L/s7Y4MyMogprcSJqyYvW/jhg8Y2UPbMYOLxDa0cCPc6SZjWzN8Q3ARFPBYMui0KZq/hvVQ==
X-Received: by 2002:a05:651c:220e:b0:295:9c3f:e30c with SMTP id y14-20020a05651c220e00b002959c3fe30cmr201590ljq.1.1677069129921;
        Wed, 22 Feb 2023 04:32:09 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id f4-20020a19ae04000000b004cb43c9bf9asm1127438lfc.208.2023.02.22.04.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 04:32:09 -0800 (PST)
Date:   Wed, 22 Feb 2023 14:32:05 +0200
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
Subject: Re: [PATCH RFC v8 27/56] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Message-ID: <20230222143205.00007635@gmail.com>
In-Reply-To: <20230220183847.59159-28-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-28-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:18 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
> system-wide configuration value for SNP guests. The information includes
> the TCB version string to be reported in guest attestation reports.
> 
> Version 2 of the GHCB specification adds an NAE (SNP extended guest
> request) that a guest can use to query the reports that include additional
> certificates.
> 
> In both cases, userspace provided additional data is included in the
> attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
> command to give the certificate blob and the reported TCB version string
> at once. Note that the specification defines certificate blob with a
> specific GUID format; the userspace is responsible for building the
> proper certificate blob. The ioctl treats it an opaque blob.
> 
> While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
> command that can be used to obtain the data programmed through the
> SNP_SET_EXT_CONFIG.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  Documentation/virt/coco/sev-guest.rst |  27 ++++++
>  drivers/crypto/ccp/sev-dev.c          | 123 ++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h          |   4 +
>  include/uapi/linux/psp-sev.h          |  17 ++++
>  4 files changed, 171 insertions(+)
> 
> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
> index 11ea67c944df..6cad4226c348 100644
> --- a/Documentation/virt/coco/sev-guest.rst
> +++ b/Documentation/virt/coco/sev-guest.rst
> @@ -145,6 +145,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>  status includes API major, minor version and more. See the SEV-SNP
>  specification for further details.
>  
> +2.5 SNP_SET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
> +reported TCB version in the attestation report. The command is similar to
> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
> +command also accepts an additional certificate blob defined in the GHCB
> +specification.
> +
> +If the certs_address is zero, then the previous certificate blob will deleted.
> +For more information on the certificate blob layout, see the GHCB spec
> +(extended guest request message).
> +
> +2.6 SNP_GET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_GET_EXT_CONFIG is used to query the system-wide configuration set
> +through the SNP_SET_EXT_CONFIG.
> +
>  3. SEV-SNP CPUID Enforcement
>  ============================
>  
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 65e13a562f3b..b56b00ca2cd4 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1481,6 +1481,10 @@ static int __sev_snp_shutdown_locked(int *error)
>  	data.length = sizeof(data);
>  	data.iommu_snp_shutdown = 1;
>  
> +	/* Free the memory used for caching the certificate data */
> +	kfree(sev->snp_certs_data);
> +	sev->snp_certs_data = NULL;
> +
>  	wbinvd_on_all_cpus();
>  
>  retry:
> @@ -1793,6 +1797,118 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_user_data_ext_snp_config input;
> +	int ret;
> +
> +	if (!sev->snp_initialized || !argp->data)
> +		return -EINVAL;
> +
> +	memset(&input, 0, sizeof(input));
> +
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +		return -EFAULT;
> +
> +	/* Copy the TCB version programmed through the SET_CONFIG to userspace */
> +	if (input.config_address) {
> +		if (copy_to_user((void * __user)input.config_address,
> +				 &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy the extended certs programmed through the SNP_SET_CONFIG */
> +	if (input.certs_address && sev->snp_certs_data) {
> +		if (input.certs_len < sev->snp_certs_len) {
> +			/* Return the certs length to userspace */
> +			input.certs_len = sev->snp_certs_len;
> +
> +			ret = -ENOSR;
> +			goto e_done;
> +		}
> +

What about if input.certs_len > sev->snp_certs_len? Is it possbile for the
userspace to know the length of data in the buffer? (I guess it might be able
to know the certs len through the blob data, but a comment here would be nice)

> +		if (copy_to_user((void * __user)input.certs_address,
> +				 sev->snp_certs_data, sev->snp_certs_len))
> +			return -EFAULT;
> +	}
> +
> +	ret = 0;
> +
> +e_done:
> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
> +		ret = -EFAULT;
> +
> +	return ret;
> +}
> +
> +static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_user_data_ext_snp_config input;
> +	struct sev_user_data_snp_config config;
> +	void *certs = NULL;
> +	int ret = 0;
> +
> +	if (!sev->snp_initialized || !argp->data)
> +		return -EINVAL;
> +
> +	if (!writable)
> +		return -EPERM;
> +
> +	memset(&input, 0, sizeof(input));
> +
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +		return -EFAULT;
> +
> +	/* Copy the certs from userspace */
> +	if (input.certs_address) {
> +		if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
> +			return -EINVAL;
> +
> +		certs = psp_copy_user_blob(input.certs_address, input.certs_len);
> +		if (IS_ERR(certs))
> +			return PTR_ERR(certs);
> +	}
> +
> +	/* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
> +	if (input.config_address) {
> +		memset(&config, 0, sizeof(config));
> +		if (copy_from_user(&config,
> +				   (void __user *)input.config_address, sizeof(config))) {
> +			ret = -EFAULT;
> +			goto e_free;
> +		}
> +
> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +		if (ret)
> +			goto e_free;
> +
> +		memcpy(&sev->snp_config, &config, sizeof(config));
> +	}
> +
> +	/*
> +	 * If the new certs are passed then cache it else free the old certs.
> +	 */
> +	mutex_lock(&sev->snp_certs_lock);
> +	if (certs) {
> +		kfree(sev->snp_certs_data);
> +		sev->snp_certs_data = certs;
> +		sev->snp_certs_len = input.certs_len;
> +	} else {
> +		kfree(sev->snp_certs_data);
> +		sev->snp_certs_data = NULL;
> +		sev->snp_certs_len = 0;
> +	}
> +	mutex_unlock(&sev->snp_certs_lock);
> +
> +	return 0;
> +
> +e_free:
> +	kfree(certs);
> +	return ret;
> +}
> +
>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
>  	void __user *argp = (void __user *)arg;
> @@ -1847,6 +1963,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  	case SNP_PLATFORM_STATUS:
>  		ret = sev_ioctl_snp_platform_status(&input);
>  		break;
> +	case SNP_SET_EXT_CONFIG:
> +		ret = sev_ioctl_snp_set_config(&input, writable);
> +		break;
> +	case SNP_GET_EXT_CONFIG:
> +		ret = sev_ioctl_snp_get_config(&input);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		goto out;
> @@ -1962,6 +2084,7 @@ int sev_dev_init(struct psp_device *psp)
>  		goto e_sev;
>  
>  	sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
> +	mutex_init(&sev->snp_certs_lock);
>  
>  	psp->sev_data = sev;
>  
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 19d79f9d4212..41d5353d5bab 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -66,6 +66,10 @@ struct sev_device {
>  
>  	bool snp_initialized;
>  	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
> +	void *snp_certs_data;
> +	u32 snp_certs_len;
> +	struct mutex snp_certs_lock;
> +	struct sev_user_data_snp_config snp_config;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 5adfaea7df97..c20d37586d21 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -29,6 +29,8 @@ enum {
>  	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
>  	SEV_GET_ID2,
>  	SNP_PLATFORM_STATUS,
> +	SNP_SET_EXT_CONFIG,
> +	SNP_GET_EXT_CONFIG,
>  
>  	SEV_MAX,
>  };
> @@ -192,6 +194,21 @@ struct sev_user_data_snp_config {
>  	__u8 rsvd1[52];
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_ext_config - system wide configuration value for SNP.
> + *
> + * @config_address: address of the struct sev_user_data_snp_config or 0 when
> + *		reported_tcb does not need to be updated.
> + * @certs_address: address of extended guest request certificate chain or
> + *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
> + * @certs_len: length of the certs
> + */
> +struct sev_user_data_ext_snp_config {
> +	__u64 config_address;		/* In */
> +	__u64 certs_address;		/* In */
> +	__u32 certs_len;		/* In */
> +};
> +
>  /**
>   * struct sev_issue_cmd - SEV ioctl parameters
>   *

