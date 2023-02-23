Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D918B6A1232
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 22:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBWVlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 16:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWVlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 16:41:18 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F423218A9E;
        Thu, 23 Feb 2023 13:41:16 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id f41so15471499lfv.13;
        Thu, 23 Feb 2023 13:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qJoM4vXaENPXqnrETZsBVfs8/JYjXs2/pFDbVazfCI=;
        b=f0c2b3ELsp/c031R0kg+iSLzD0LVA6+fDyAotS8+QsQEyDgaokMu43dNRkg9cEAUr9
         yvQIKt4anc5575bqMD4JqnPvpJ8m0ITobP/94FC3ZFkRedzAu3dJ7hE0L65kMWHi7WVJ
         m/UttK05vmOWJ7F4+SBnaezcoEO6kQbc09/gBnTuECJueFXDxatVeCc34hqsvM3J3L7q
         1IsZNrROjDcIjKr1e1skVXxTNdwIynMVTJSHn1UKgrESeDrphkVVjJt9DBWkTx9g29w8
         uQVmRkxcZ0dQ4w2Ez78CnQ0lnJkNoF75/MTEZbRD+nP8Mjbu5hrgdLV4WB9n9OIjGhKu
         T8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3qJoM4vXaENPXqnrETZsBVfs8/JYjXs2/pFDbVazfCI=;
        b=vQFn6xnkBXxGQZelSABUPa0yoI2YpCB63keEMsWJZm5NLEXZB8TacP9Y+LYfCZTqpM
         KMv4kSipGFPlE9u11pPv2fd9kuv5/0tPuxrDTJQ7n6O9SNieYYPfBaXx++zrAtO1j7N5
         7h3O9iDb58z+L/KD72PRWEcqkwjFn5P+q8PDgiB3fPiWUZZdU3N/RIEuoQdG483WILcm
         jwA+z8Uzh0kkkulhKG5Mzv0TbDH4aEhyVSoLSahs5ZbI7OZSxZTPXjX7Hn/cjyrL9OdR
         acNQckmU9wElChUShDxQZMoNWM3p0Ls+wbxshhCLMKL2zMF/7HPCeu1mKw6YJtsXPI00
         ljlA==
X-Gm-Message-State: AO0yUKUWeVGQcAD5rNkR+gA3QCyQz432p+dRUb7+3XNK+1oC2wqiqIGl
        oZJgjLYVciSPxujr95XwdzU=
X-Google-Smtp-Source: AK7set8yK0DzArIbIqTuKw/72Q4C0axGvD9qC9p/0DSpcksqSIjNWFglrSiJJvsBLG6slbfPJDUHVA==
X-Received: by 2002:a19:f00c:0:b0:4db:1e4a:749c with SMTP id p12-20020a19f00c000000b004db1e4a749cmr4421782lfc.0.1677188474998;
        Thu, 23 Feb 2023 13:41:14 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id m22-20020ac24256000000b004b57bbaef87sm529496lfl.224.2023.02.23.13.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 13:41:14 -0800 (PST)
Date:   Thu, 23 Feb 2023 23:41:12 +0200
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
Subject: Re: [PATCH RFC v8 34/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START
 command
Message-ID: <20230223234112.000030ac@gmail.com>
In-Reply-To: <20230220183847.59159-35-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-35-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:25 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
> The command initializes a cryptographic digest context used to construct
> the measurement of the guest. If the guest is expected to be migrated,
> the command also binds a migration agent (MA) to the guest.
> 
> For more information see the SEV-SNP specification.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  24 ++++
>  arch/x86/kvm/svm/sev.c                        | 121 +++++++++++++++++-
>  arch/x86/kvm/svm/svm.h                        |   1 +
>  include/uapi/linux/kvm.h                      |  10 ++
>  4 files changed, 153 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 2432213bd0ea..58971fc02a15 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -461,6 +461,30 @@ The flags bitmap is defined as::
>  If the specified flags is not supported then return -EOPNOTSUPP, and the supported
>  flags are returned.
>  
> +19. KVM_SNP_LAUNCH_START
> +------------------------
> +
> +The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
> +context for the SEV-SNP guest. To create the encryption context, user must
> +provide a guest policy, migration agent (if any) and guest OS visible
> +workarounds value as defined SEV-SNP specification.
> +
> +Parameters (in): struct  kvm_snp_launch_start
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_start {
> +                __u64 policy;           /* Guest policy to use. */
> +                __u64 ma_uaddr;         /* userspace address of migration agent */
> +                __u8 ma_en;             /* 1 if the migration agent is enabled */
> +                __u8 imi_en;            /* set IMI to 1. */
> +                __u8 gosvw[16];         /* guest OS visible workarounds */
> +        };
> +
> +See the SEV-SNP specification for further detail on the launch input.
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a8efe1f6bf77..097bb2138360 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -22,6 +22,7 @@
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
>  #include <asm/fpu/xcr.h>
> +#include <asm/sev.h>
>  
>  #include "mmu.h"
>  #include "x86.h"
> @@ -75,6 +76,8 @@ static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  
> +static int snp_decommission_context(struct kvm *kvm);
> +
>  struct enc_region {
>  	struct list_head list;
>  	unsigned long npages;
> @@ -100,12 +103,17 @@ static int sev_flush_asids(int min_asid, int max_asid)
>  	down_write(&sev_deactivate_lock);
>  
>  	wbinvd_on_all_cpus();
> -	ret = sev_guest_df_flush(&error);
> +
> +	if (sev_snp_enabled)
> +		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
> +	else
> +		ret = sev_guest_df_flush(&error);
>  
>  	up_write(&sev_deactivate_lock);
>  
>  	if (ret)
> -		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
> +		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
> +		       sev_snp_enabled ? "-SNP" : "", ret, error);
>  
>  	return ret;
>  }
> @@ -2011,6 +2019,80 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> +/*
> + * The guest context contains all the information, keys and metadata
> + * associated with the guest that the firmware tracks to implement SEV
> + * and SNP features. The firmware stores the guest context in hypervisor
> + * provide page via the SNP_GCTX_CREATE command.
> + */
> +static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct sev_data_snp_addr data = {};
> +	void *context;
> +	int rc;
> +
> +	/* Allocate memory for context page */
> +	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> +	if (!context)
> +		return NULL;
> +
> +	data.gctx_paddr = __psp_pa(context);
> +	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
> +	if (rc) {
> +		snp_free_firmware_page(context);
> +		return NULL;
> +	}
> +
> +	return context;
> +}
> +
> +static int snp_bind_asid(struct kvm *kvm, int *error)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_activate data = {0};
> +
> +	data.gctx_paddr = __psp_pa(sev->snp_context);
> +	data.asid   = sev_get_asid(kvm);
> +	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);

According to the SNP ABI specification[1] 8.10 SNP_ACTIVATE:

"The firmware checks that a DF_FLUSH is not required. If a DF_FLUSH is
required, the firmware returns DFFLUSH_REQUIRED. Note that all ASIDs are
marked to require a DF_FLUSH at reset."

Do we need a SNP_DF_FLUSH here before calling SNP_ACTIVATE or handle the
situation if the PSP firmware returns DFFLUSH_REQUIRED?

[1] https://www.amd.com/system/files/TechDocs/56860.pdf

> +}
> +
> +static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_launch_start start = {0};
> +	struct kvm_sev_snp_launch_start params;
> +	int rc;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	sev->snp_context = snp_context_create(kvm, argp);
> +	if (!sev->snp_context)
> +		return -ENOTTY;
> +
> +	start.gctx_paddr = __psp_pa(sev->snp_context);
> +	start.policy = params.policy;
> +	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> +	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
> +	if (rc)
> +		goto e_free_context;
> +
> +	sev->fd = argp->sev_fd;
> +	rc = snp_bind_asid(kvm, &argp->error);
> +	if (rc)
> +		goto e_free_context;
> +
> +	return 0;
> +
> +e_free_context:
> +	snp_decommission_context(kvm);
> +
> +	return rc;
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -2101,6 +2183,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_RECEIVE_FINISH:
>  		r = sev_receive_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_LAUNCH_START:
> +		r = snp_launch_start(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> @@ -2292,6 +2377,28 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> +static int snp_decommission_context(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_addr data = {};
> +	int ret;
> +
> +	/* If context is not created then do nothing */
> +	if (!sev->snp_context)
> +		return 0;
> +
> +	data.gctx_paddr = __sme_pa(sev->snp_context);
> +	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
> +	if (WARN_ONCE(ret, "failed to release guest context"))
> +		return ret;
> +
> +	/* free the context page now */
> +	snp_free_firmware_page(sev->snp_context);
> +	sev->snp_context = NULL;
> +
> +	return 0;
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -2333,7 +2440,15 @@ void sev_vm_destroy(struct kvm *kvm)
>  		}
>  	}
>  
> -	sev_unbind_asid(kvm, sev->handle);
> +	if (sev_snp_guest(kvm)) {
> +		if (snp_decommission_context(kvm)) {
> +			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
> +			return;
> +		}
> +	} else {
> +		sev_unbind_asid(kvm, sev->handle);
> +	}
> +
>  	sev_asid_free(sev);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 56a5c96d8a36..740969b57425 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -92,6 +92,7 @@ struct kvm_sev_info {
>  	struct misc_cg *misc_cg; /* For misc cgroup accounting */
>  	atomic_t migration_in_progress;
>  	u64 snp_init_flags;
> +	void *snp_context;      /* SNP guest context page */
>  };
>  
>  struct kvm_svm {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 499cc323f793..cf19799ca5ce 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1919,6 +1919,7 @@ enum sev_cmd_id {
>  
>  	/* SNP specific commands */
>  	KVM_SEV_SNP_INIT,
> +	KVM_SEV_SNP_LAUNCH_START,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -2026,6 +2027,15 @@ struct kvm_snp_init {
>  	__u64 flags;
>  };
>  
> +struct kvm_sev_snp_launch_start {
> +	__u64 policy;
> +	__u64 ma_uaddr;
> +	__u8 ma_en;
> +	__u8 imi_en;
> +	__u8 gosvw[16];
> +	__u8 pad[6];
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)

