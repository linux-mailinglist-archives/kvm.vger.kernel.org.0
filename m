Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041585B3512
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIIKYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiIIKYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:24:13 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Sep 2022 03:24:09 PDT
Received: from hoyer.xyz (hoyer.xyz [85.25.100.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90DE114A69;
        Fri,  9 Sep 2022 03:24:08 -0700 (PDT)
Received: from [192.168.178.157] (p5b0acefd.dip0.t-ipconnect.de [91.10.206.253])
        (authenticated bits=0)
        by hoyer.xyz (8.16.1/8.15.2) with ESMTPSA id 28984EOS3014416
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 9 Sep 2022 10:04:14 +0200
Message-ID: <a6a01e3f-da3e-84a0-ba0d-fd00cd5e6a2a@hoyer.xyz>
Date:   Fri, 9 Sep 2022 10:04:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
To:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
From:   Harald Hoyer <harald@hoyer.xyz>
In-Reply-To: <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,FROM_SUSPICIOUS_NTLD,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replying inline to the patch (and not with a in-reply-to patch, as nitted by Sean Christopherson).

Am 21.06.22 um 01:08 schrieb Ashish Kalra:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
> it as the measurement of the guest at launch.
> 
> While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
> to encrypt the VMSA pages.
> 
> If its an SNP guest, then VMSA was added in the RMP entry as
> a guest owned page and also removed from the kernel direct map
> so flush it later after it is transitioned back to hypervisor
> state and restored in the direct map.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   .../virt/kvm/x86/amd-memory-encryption.rst    |  22 ++++
>   arch/x86/kvm/svm/sev.c                        | 119 ++++++++++++++++++
>   include/uapi/linux/kvm.h                      |  14 +++
>   3 files changed, 155 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 62abd5c1f72b..750162cff87b 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -514,6 +514,28 @@ Returns: 0 on success, -negative on error
>   See the SEV-SNP spec for further details on how to build the VMPL permission
>   mask and page type.
>   
> +21. KVM_SNP_LAUNCH_FINISH
> +-------------------------
> +
> +After completion of the SNP guest launch flow, the KVM_SNP_LAUNCH_FINISH command can be
> +issued to make the guest ready for the execution.
> +
> +Parameters (in): struct kvm_sev_snp_launch_finish
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_finish {
> +                __u64 id_block_uaddr;
> +                __u64 id_auth_uaddr;
> +                __u8 id_block_en;
> +                __u8 auth_key_en;
> +                __u8 host_data[32];
> +        };
> +
> +
> +See SEV-SNP specification for further details on launch finish input parameters.
>   
>   References
>   ==========
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a9461d352eda..a5b90469683f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2095,6 +2095,106 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_launch_update data = {};
> +	int i, ret;
> +
> +	data.gctx_paddr = __psp_pa(sev->snp_context);
> +	data.page_type = SNP_PAGE_TYPE_VMSA;
> +
> +	for (i = 0; i < kvm->created_vcpus; i++) {
> +		struct vcpu_svm *svm = to_svm(xa_load(&kvm->vcpu_array, i));
> +		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
> +
> +		/* Perform some pre-encryption checks against the VMSA */
> +		ret = sev_es_sync_vmsa(svm);
> +		if (ret)
> +			return ret;
> +
> +		/* Transition the VMSA page to a firmware state. */
> +		ret = rmp_make_private(pfn, -1, PG_LEVEL_4K, sev->asid, true);
> +		if (ret)
> +			return ret;
> +
> +		/* Issue the SNP command to encrypt the VMSA */
> +		data.address = __sme_pa(svm->sev_es.vmsa);
> +		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> +				      &data, &argp->error);
> +		if (ret) {
> +			snp_page_reclaim(pfn);
> +			return ret;
> +		}
> +
> +		svm->vcpu.arch.guest_state_protected = true;
> +	}
> +
> +	return 0;
> +}
> +
> +static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_launch_finish *data;
> +	void *id_block = NULL, *id_auth = NULL;
> +	struct kvm_sev_snp_launch_finish params;
> +	int ret;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	/* Measure all vCPUs using LAUNCH_UPDATE before we finalize the launch flow. */
> +	ret = snp_launch_update_vmsa(kvm, argp);

This poses a real problem for those, who want to precalculate the digest beforehand and sign their TEE without loading the TEE:
1. We don't know the contents of the VMSA, nor the hash of it.
2. Who guarantees, that future kernels have the same VMSA contents?

I would propose at least one additional ioctl parameter specifying the final VMSA for the SNP_PAGE_TYPE_VMSA snp_launch_update_vmsa.
This parameter could specify to use:
- the current VMSA
- or a VMSA resembling the CPU state on reset, where the contents is guaranteed to never change and have a defined digest
- or a user provided VMSA

> +	if (ret)
> +		return ret;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	if (params.id_block_en) {
> +		id_block = psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BLOCK_SIZE);
> +		if (IS_ERR(id_block)) {
> +			ret = PTR_ERR(id_block);
> +			goto e_free;
> +		}
> +
> +		data->id_block_en = 1;
> +		data->id_block_paddr = __sme_pa(id_block);
> +	}
> +
> +	if (params.auth_key_en) {

The `params.auth_key_en` indicator does _not_ specify, whether an ID_AUTH struct should be sent or not,
but wheter the ID_AUTH struct contains an author key or not. The firmware always expects an ID_AUTH block.

So, please move the upper `if` to enclose only `data->auth_key_en = 1;`, or use my patch sent in-reply to this mail yesterday.

> +		id_auth = psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH_SIZE);
> +		if (IS_ERR(id_auth)) {
> +			ret = PTR_ERR(id_auth);
> +			goto e_free_id_block;
> +		}
> +
> +		data->auth_key_en = 1;
> +		data->id_auth_paddr = __sme_pa(id_auth);
> +	}
> +
> +	data->gctx_paddr = __psp_pa(sev->snp_context);
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
> +
> +	kfree(id_auth);
> +
> +e_free_id_block:
> +	kfree(id_block);
> +
> +e_free:
> +	kfree(data);
> +
> +	return ret;
> +}
> +
>   int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -2191,6 +2291,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_SNP_LAUNCH_UPDATE:
>   		r = snp_launch_update(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_SNP_LAUNCH_FINISH:
> +		r = snp_launch_finish(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> @@ -2696,11 +2799,27 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>   
>   	svm = to_svm(vcpu);
>   
> +	/*
> +	 * If its an SNP guest, then VMSA was added in the RMP entry as
> +	 * a guest owned page. Transition the page to hypervisor state
> +	 * before releasing it back to the system.
> +	 * Also the page is removed from the kernel direct map, so flush it
> +	 * later after it is transitioned back to hypervisor state and
> +	 * restored in the direct map.
> +	 */
> +	if (sev_snp_guest(vcpu->kvm)) {
> +		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
> +
> +		if (host_rmp_make_shared(pfn, PG_LEVEL_4K, false))
> +			goto skip_vmsa_free;
> +	}
> +
>   	if (vcpu->arch.guest_state_protected)
>   		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
>   
>   	__free_page(virt_to_page(svm->sev_es.vmsa));
>   
> +skip_vmsa_free:
>   	if (svm->sev_es.ghcb_sa_free)
>   		kvfree(svm->sev_es.ghcb_sa);
>   }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9b36b07414ea..5a4662716b6a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1814,6 +1814,7 @@ enum sev_cmd_id {
>   	KVM_SEV_SNP_INIT,
>   	KVM_SEV_SNP_LAUNCH_START,
>   	KVM_SEV_SNP_LAUNCH_UPDATE,
> +	KVM_SEV_SNP_LAUNCH_FINISH,
>   
>   	KVM_SEV_NR_MAX,
>   };
> @@ -1948,6 +1949,19 @@ struct kvm_sev_snp_launch_update {
>   	__u8 vmpl1_perms;
>   };
>   
> +#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
> +#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
> +#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
> +
> +struct kvm_sev_snp_launch_finish {
> +	__u64 id_block_uaddr;
> +	__u64 id_auth_uaddr;
> +	__u8 id_block_en;
> +	__u8 auth_key_en;
> +	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
> +	__u8 pad[6];
> +};
> +
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)

