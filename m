Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB53C6A782A
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 01:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjCBAC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 19:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjCBAC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 19:02:56 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDAC1729;
        Wed,  1 Mar 2023 16:02:52 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id h9so15889862ljq.2;
        Wed, 01 Mar 2023 16:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677715371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+mEYUoqzkV4y6vsMO1Tnsa6bn7KUqmY0W5AVOdUCN8g=;
        b=dNvQTh8k3DnN0lwNU0AYKg+hLxSqZa0EsGqc8+Z5Bqudjprv9CWoBml91KkNT6PUbO
         ruojlGrNqFgiBQwuLiuvPhXCfCfpxZAiVR1+7DnrLVZV/SDJfBZsgTbM5t32cm2edvwK
         679Obb1Wh/fTJg/LeEdLZYOQSrCi23VyT6WfYbs5X7ZUq2JPNhQyQAwaxUGtjgI+nKkQ
         1lvbWOzxoBPj0ZhY4N7/3lpUEDQZnbeBgyCHXpJWf298ODDpVmMiVtH/KAkudDLV43Dr
         9McqHU09OPXl0PEvUWq08TBwk5na5mruZxmZTl8y3NQKTuPPx4J5ye6DwtjEgszg71fC
         vM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677715371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+mEYUoqzkV4y6vsMO1Tnsa6bn7KUqmY0W5AVOdUCN8g=;
        b=h5ojHgbp/OCZzSowRRw/oJfcXVvws6aBxnnTX3GXkdpJDVRk86EyJ7lkC7IUMqAL3E
         Y+oTSqGZs6rm1ncJ7uVlVDbFizQNcbI4D4xeAEb24r8nxX8Pc5vjAJ1m3v3u82V1+QGN
         WFmmSBsmTqkaRi3w5QUuUimHsu0LGknBUm39K3Ch0SkVovEBsKW/Yuzw0B5kTSEXTBk3
         PjkY99G+1kAny8LlQsYFqZ3DS73dHGUY7k75CeJKuxy+F7EbkohCUQrudnjDabUYGk51
         3Y3WO1Njpli8KLVHne29DAOrs0q92xLGjviMZJ7jtbvDu7D1GKpxI8Oy+XuULYbZKyPg
         AaZA==
X-Gm-Message-State: AO0yUKW7i4naKlxw1IOckQCx7vWzqnCX3BvzVs4tfp279Ghxp5eOGfGn
        XCgKjKHzNlwRzr9BEBNuW24=
X-Google-Smtp-Source: AK7set/1liEDyyq962/VgpuqfVI283EUk4PS3DgsvEElOZ+Q4nC8n4n5DK3006LuS6BXBNGSvSfclw==
X-Received: by 2002:a2e:960d:0:b0:295:9d09:680d with SMTP id v13-20020a2e960d000000b002959d09680dmr2143470ljh.0.1677715370579;
        Wed, 01 Mar 2023 16:02:50 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id p17-20020a2eb991000000b00295b1ad177csm1656830ljp.68.2023.03.01.16.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 16:02:48 -0800 (PST)
Date:   Thu, 2 Mar 2023 02:02:45 +0200
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
        Dionna Glaze <dionnaglaze@google.com>
Subject: Re: [PATCH RFC v8 54/56] x86/sev: Add KVM commands for instance
 certs
Message-ID: <20230302020245.00006f57@gmail.com>
In-Reply-To: <20230220183847.59159-55-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-55-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:45 -0600
Michael Roth <michael.roth@amd.com> wrote:

In the host-wide certificates installing/uninstalling, a lock is to
prevent the racing between cert upload/download path and the handling
of guest request path.

Guess we need a similar lock to prevent the racing between
snp_{set,get}_instance_certs() and snp_handle_ext_guest_request().

This patch and PATCH 27 are focusing on cert from different sources.
It would be better to abstract. With the functions and data structure
of cert, the cert installing/uninstalling, checks, expectation of the
output buffer can be unified. Then we don't need mostly duplicate
routines in two different paths.

> From: Dionna Glaze <dionnaglaze@google.com>
> 
> The /dev/sev device has the ability to store host-wide certificates for
> the key used by the AMD-SP for SEV-SNP attestation report signing,
> but for hosts that want to specify additional certificates that are
> specific to the image launched in a VM, a different way is needed to
> communicate those certificates.
> 
> Add two new KVM ioctl to handle this: KVM_SEV_SNP_{GET,SET}_CERTS
> 
> The certificates that are set with this command are expected to follow
> the same format as the host certificates, but that format is opaque
> to the kernel.
> 
> The new behavior for custom certificates is that the extended guest
> request command will now return the overridden certificates if they
> were installed for the instance. The error condition for a too small
> data buffer is changed to return the overridden certificate data size
> if there is an overridden certificate set installed.
> 
> Setting a 0 length certificate returns the system state to only return
> the host certificates on an extended guest request.
> 
> Also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow space
> for an extra certificate.
> 
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: remove used of "we" and "this patch" in commit log]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 111 ++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h   |   1 +
>  include/linux/psp-sev.h  |   2 +-
>  include/uapi/linux/kvm.h |  12 +++++
>  4 files changed, 123 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 70d5650d8d95..18b64b7005e7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2089,6 +2089,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free;
>  
>  	sev->snp_certs_data = certs_data;
> +	sev->snp_certs_len = 0;
>  
>  	return context;
>  

Better to move the fix to PATCH 45.

> @@ -2404,6 +2405,86 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int snp_get_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_snp_get_certs params;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			   sizeof(params)))
> +		return -EFAULT;
> +
> +	/* No instance certs set. */
> +	if (!sev->snp_certs_len)
> +		return -ENOENT;
> +
> +	if (params.certs_len < sev->snp_certs_len) {
> +		/* Output buffer too small. Return the required size. */
> +		params.certs_len = sev->snp_certs_len;
> +
> +		if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> +				 sizeof(params)))
> +			return -EFAULT;
> +
> +		return -EINVAL;
> +	}
> +
> +	if (copy_to_user((void __user *)(uintptr_t)params.certs_uaddr,
> +			 sev->snp_certs_data, sev->snp_certs_len))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	unsigned long length = SEV_FW_BLOB_MAX_SIZE;
> +	void *to_certs = sev->snp_certs_data;
> +	struct kvm_sev_snp_set_certs params;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			   sizeof(params)))
> +		return -EFAULT;
> +
> +	if (params.certs_len > SEV_FW_BLOB_MAX_SIZE)
> +		return -EINVAL;
> +
> +	/*
> +	 * Setting a length of 0 is the same as "uninstalling" instance-
> +	 * specific certificates.
> +	 */
> +	if (params.certs_len == 0) {
> +		sev->snp_certs_len = 0;
> +		return 0;
> +	}
> +
> +	/* Page-align the length */
> +	length = (params.certs_len + PAGE_SIZE - 1) & PAGE_MASK;
> +
> +	if (copy_from_user(to_certs,
> +			   (void __user *)(uintptr_t)params.certs_uaddr,
> +			   params.certs_len)) {
> +		return -EFAULT;
> +	}
> +
> +	sev->snp_certs_len = length;
> +
> +	return 0;
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -2503,6 +2584,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_FINISH:
>  		r = snp_launch_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_GET_CERTS:
> +		r = snp_get_instance_certs(kvm, &sev_cmd);
> +		break;
> +	case KVM_SEV_SNP_SET_CERTS:
> +		r = snp_set_instance_certs(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> @@ -3550,8 +3637,28 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>  	if (rc)
>  		goto unlock;
>  
> -	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
> -					 &data_npages, &err);
> +	/*
> +	 * If the VMM has overridden the certs, then change the error message
> +	 * if the size is inappropriate for the override. Otherwise, use a
> +	 * regular guest request and copy back the instance certs.
> +	 */
> +	if (sev->snp_certs_len) {
> +		if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
> +			rc = -EINVAL;
> +			err = SNP_GUEST_REQ_INVALID_LEN;
> +			goto datalen;
> +		}
> +		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
> +				   (int *)&err);
> +	} else {
> +		rc = snp_guest_ext_guest_request(&req,
> +						 (unsigned long)sev->snp_certs_data,
> +						 &data_npages, &err);
> +	}
> +datalen:
> +	if (sev->snp_certs_len)
> +		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
> +
>  	if (rc) {
>  		/*
>  		 * If buffer length is small then return the expected
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 221b38d3c845..dced46559508 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -94,6 +94,7 @@ struct kvm_sev_info {
>  	u64 snp_init_flags;
>  	void *snp_context;      /* SNP guest context page */
>  	void *snp_certs_data;
> +	unsigned int snp_certs_len; /* Size of instance override for certs */
>  	struct mutex guest_req_lock; /* Lock for guest request handling */
>  
>  	u64 sev_features;	/* Features set at VMSA creation */
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 92116e2b74fd..3b28b78938f6 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -22,7 +22,7 @@
>  #define __psp_pa(x)	__pa(x)
>  #endif
>  
> -#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
> +#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */
>  
>  /**
>   * SEV platform state
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6e684bf5f723..ad7e24e43547 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1928,6 +1928,8 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_START,
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_GET_CERTS,
> +	KVM_SEV_SNP_SET_CERTS,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -2075,6 +2077,16 @@ struct kvm_sev_snp_launch_finish {
>  	__u8 pad[6];
>  };
>  
> +struct kvm_sev_snp_get_certs {
> +	__u64 certs_uaddr;
> +	__u64 certs_len;
> +};
> +
> +struct kvm_sev_snp_set_certs {
> +	__u64 certs_uaddr;
> +	__u64 certs_len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)

