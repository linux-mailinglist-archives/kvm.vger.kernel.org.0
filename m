Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A650587C76
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 14:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiHBMb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 08:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbiHBMbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 08:31:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E00D33A32;
        Tue,  2 Aug 2022 05:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEEBDB8199C;
        Tue,  2 Aug 2022 12:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED13C433C1;
        Tue,  2 Aug 2022 12:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659443479;
        bh=sS/iKN5UFc8H3LDEaCSvT34g5YFAT/d8natDfT6GXfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=trMOiRRzFaSvVwYrwCrgPIltHYmaWdeqVn7I927p3txdwLdpcXaGkZcmdUjPdd2ZS
         sJX+MvVhXQqnAp302hJMvOEbgW+OKOGgfgV6c25yxa0YL+PbqmMbF8BWWT4IRalwJ+
         SJvQqh/bAggMvxoHx1pCR1jXHWyiZwsJClttsnOVCtGcVqeAjohIpP9GsiCaC4bLqk
         gl5zEJ9D1B+Bxo9glmlLqQOpVpTLECq2MWanuJn4BbyWoICq7oZBp0sm2hLgGPAZkY
         jTI+zHpiDfUQ3ghsqREfOEwggyzWgbHkOFDCj9L3RQmDZTa0hR8KoTGLfnxZOKINpx
         VxdlD96iR/zDA==
Date:   Tue, 2 Aug 2022 15:31:16 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
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
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 17/49] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Message-ID: <YukZFKpAO5o5MLA1@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:05:50PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
> system-wide configuration value for SNP guests. The information includes
> the TCB version string to be reported in guest attestation reports.
> 
> Version 2 of the GHCB specification adds an NAE (SNP extended guest
> request) that a guest can use to query the reports that include additional
> certificates.

Neither in the commit message nor in the documentation is GHCB open coded.

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
> ---
>  Documentation/virt/coco/sevguest.rst |  27 +++++++
>  drivers/crypto/ccp/sev-dev.c         | 115 +++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h         |   3 +
>  include/uapi/linux/psp-sev.h         |  17 ++++
>  4 files changed, 162 insertions(+)
> 
> diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
> index 11ea67c944df..3014de47e4ce 100644
> --- a/Documentation/virt/coco/sevguest.rst
> +++ b/Documentation/virt/coco/sevguest.rst
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
> +If the certs_address is zero, then previous certificate blob will deleted.
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
> +The SNP_SET_EXT_CONFIG is used to query the system-wide configuration set
> +through the SNP_SET_EXT_CONFIG.
> +
>  3. SEV-SNP CPUID Enforcement
>  ============================
>  
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b9b6fab31a82..97b479d5aa86 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1312,6 +1312,10 @@ static int __sev_snp_shutdown_locked(int *error)
>  	if (!sev->snp_inited)
>  		return 0;
>  
> +	/* Free the memory used for caching the certificate data */
> +	kfree(sev->snp_certs_data);
> +	sev->snp_certs_data = NULL;
> +
>  	/* SHUTDOWN requires the DF_FLUSH */
>  	wbinvd_on_all_cpus();
>  	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
> @@ -1616,6 +1620,111 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_user_data_ext_snp_config input;
> +	int ret;
> +
> +	if (!sev->snp_inited || !argp->data)
> +		return -EINVAL;
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
> +	if (!sev->snp_inited || !argp->data)
> +		return -EINVAL;
> +
> +	if (!writable)
> +		return -EPERM;
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
> +		if (copy_from_user(&config,
> +				   (void __user *)input.config_address, sizeof(config))) {

You can put this into a single line, and it's still less than 100
characters:

                if (copy_from_user(&config, (void __user *)input.config_address, sizeof(config))) {


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

        kfree(sev->snp_certs_data);

> +	if (certs) {
> +		kfree(sev->snp_certs_data);

Remove kfree().

> +		sev->snp_certs_data = certs;
> +		sev->snp_certs_len = input.certs_len;
> +	} else {
> +		kfree(sev->snp_certs_data);

Remove kfree().

> +		sev->snp_certs_data = NULL;
> +		sev->snp_certs_len = 0;
> +	}
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
> @@ -1670,6 +1779,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index fe5d7a3ebace..d2fe1706311a 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -66,6 +66,9 @@ struct sev_device {
>  
>  	bool snp_inited;
>  	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
> +	void *snp_certs_data;
> +	u32 snp_certs_len;
> +	struct sev_user_data_snp_config snp_config;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index ffd60e8b0a31..60e7a8d1a18e 100644
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
> @@ -190,6 +192,21 @@ struct sev_user_data_snp_config {
>  	__u8 rsvd[52];
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
> -- 
> 2.25.1
> 

BR, Jarkko
