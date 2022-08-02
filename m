Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B261F587CF4
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 15:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiHBNT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 09:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiHBNT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 09:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A70813E3D;
        Tue,  2 Aug 2022 06:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64946134F;
        Tue,  2 Aug 2022 13:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4184C433D7;
        Tue,  2 Aug 2022 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659446393;
        bh=QpcAUsewd/+KMI+EaDJ9tjM4TNeoV2RTu8Kl+bvpWxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IW6a0pBIbsC5aevWoSvnCQw/mnUVKyYeXk22PgTJrLMOVjWuVKvxYHoJNu+XaOHGT
         KX/BQQ3WevV4ImfzdxOhGW2VvY68hI7gVN/iEIHt4jCIbkg9PPG8z1MmmB0XAkbvIx
         KQj5HmrDrwJWCvn8lpneqdu+BnUuBHv4yyh2zAWwr6x4k3iPI0CUjrfehS0MDbVOHZ
         qWdDrluYFRNt0jpoza17eCzqQ5KF410Es93UkKJfyJ02SOiyeUoYdtuG6ixRfnaTeU
         yxaUdedITpu2h5PZVWrj3BGH71at0ojTMovVf9bB5drUTA7vDAfZRPzmjToDJTzB6R
         kGakJmiL3h0Dw==
Date:   Tue, 2 Aug 2022 16:19:49 +0300
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
Subject: Re: [PATCH Part2 v6 24/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START
 command
Message-ID: <YukkdQJS4K+V2Nkn@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <6d5c899030b113755e6c093e8bb9ad123280edc6.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d5c899030b113755e6c093e8bb9ad123280edc6.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:07:35PM +0000, Ashish Kalra wrote:
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
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  24 ++++
>  arch/x86/kvm/svm/sev.c                        | 115 +++++++++++++++++-
>  arch/x86/kvm/svm/svm.h                        |   1 +
>  include/uapi/linux/kvm.h                      |  10 ++
>  4 files changed, 147 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 903023f524af..878711f2dca6 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -462,6 +462,30 @@ The flags bitmap is defined as::
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
> +                __u8 ma_en;             /* 1 if the migtation agent is enabled */
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
> index 813bda7f7b55..9e6fc7a94ed7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -21,6 +21,7 @@
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
>  #include <asm/fpu/xcr.h>
> +#include <asm/sev.h>
>  
>  #include "x86.h"
>  #include "svm.h"
> @@ -73,6 +74,8 @@ static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  
> +static int snp_decommission_context(struct kvm *kvm);
> +
>  struct enc_region {
>  	struct list_head list;
>  	unsigned long npages;
> @@ -98,12 +101,17 @@ static int sev_flush_asids(int min_asid, int max_asid)
>  	down_write(&sev_deactivate_lock);
>  
>  	wbinvd_on_all_cpus();
> -	ret = sev_guest_df_flush(&error);
> +
> +	if (sev_snp_enabled)
> +		ret = snp_guest_df_flush(&error);
> +	else
> +		ret = sev_guest_df_flush(&error);
>  
>  	up_write(&sev_deactivate_lock);
>  
>  	if (ret)
> -		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
> +		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
> +			sev_snp_enabled ? "-SNP" : "", ret, error);
>  
>  	return ret;
>  }
> @@ -1825,6 +1833,74 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> +static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct sev_data_snp_gctx_create data = {};
> +	void *context;
> +	int rc;
> +
> +	/* Allocate memory for context page */

Nit: this comment has very little value, if any. It's just stating
the obvious.

Instead, I'd add a description for the function:

/*
 * Allocate and initialize a digest for the guest measurement.
 */
static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)

This would be much more helpful to get a grasp on "what I'm looking at".

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
> @@ -1915,6 +1991,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_RECEIVE_FINISH:
>  		r = sev_receive_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_LAUNCH_START:
> +		r = snp_launch_start(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> @@ -2106,6 +2185,28 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> +static int snp_decommission_context(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_decommission data = {};
> +	int ret;
> +
> +	/* If context is not created then do nothing */
> +	if (!sev->snp_context)
> +		return 0;
> +
> +	data.gctx_paddr = __sme_pa(sev->snp_context);
> +	ret = snp_guest_decommission(&data, NULL);
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
> @@ -2147,7 +2248,15 @@ void sev_vm_destroy(struct kvm *kvm)
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
> index 2f45589ee596..71c011af098e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -91,6 +91,7 @@ struct kvm_sev_info {
>  	struct misc_cg *misc_cg; /* For misc cgroup accounting */
>  	atomic_t migration_in_progress;
>  	u64 snp_init_flags;
> +	void *snp_context;      /* SNP guest context page */
>  };
>  
>  struct kvm_svm {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0f912cefc544..0cb119d66ae5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1812,6 +1812,7 @@ enum sev_cmd_id {
>  
>  	/* SNP specific commands */
>  	KVM_SEV_SNP_INIT,
> +	KVM_SEV_SNP_LAUNCH_START,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -1919,6 +1920,15 @@ struct kvm_snp_init {
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
> -- 
> 2.25.1
> 

BR, Jarkko
