Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FADF587CA2
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiHBMug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 08:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiHBMuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 08:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3550CCC;
        Tue,  2 Aug 2022 05:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 937F7B819A1;
        Tue,  2 Aug 2022 12:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1E1C433D6;
        Tue,  2 Aug 2022 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659444631;
        bh=fKvVypfFH+JdjXExshpBu+/wwf6r289/dR4kaa6y89Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oh/y9mS8nTihVUTuHoEk8BDmxcPGiO/d5C2TG66DpBrwOAVnzorFJUs308bSWbSwA
         9I54AvkKySbc53ZxUkr/vioMZLaqCMfxDgxSfdNOAYMe0IOW3jvLth1i94Vipn4wYl
         6skR1UbzEcl7Ebj8zmjkM4isySpAsiBt7flXgSSqK+6weRNwGGJHWwTSJfu6TXr8Ss
         XtbsBzF6CN9AaqCTr2gHS8s49ex9rnpHAqjLYPRRPUc7DrHbSNf8I2n00FMaC+tYlT
         VQnGAlz/xzRMhpYMAnM5++znp/m3Da4AdUfWay7+eaGrPuc+l4HOwyVGnVlSyUO/wM
         3liCWBTOkWLCQ==
Date:   Tue, 2 Aug 2022 15:50:28 +0300
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
Subject: Re: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command
Message-ID: <YukdgY/XThzrClah@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:08:05PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into the
> guest's memory. The data is encrypted with the cryptographic context
> created with the KVM_SEV_SNP_LAUNCH_START.
> 
> In addition to the inserting data, it can insert a two special pages
> into the guests memory: the secrets page and the CPUID page.
> 
> While terminating the guest, reclaim the guest pages added in the RMP
> table. If the reclaim fails, then the page is no longer safe to be
> released back to the system and leak them.

From this paragraph I get a picture that reclaimer is failing "all the
time", and that is totally normal and legit behaviour. Is this the case?

Stimuli/conditions/something is mandatory if failure is mentioned in any
context.

> 
> For more information see the SEV-SNP specification.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  29 +++
>  arch/x86/kvm/svm/sev.c                        | 187 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  19 ++
>  3 files changed, 235 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 878711f2dca6..62abd5c1f72b 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -486,6 +486,35 @@ Returns: 0 on success, -negative on error
>  
>  See the SEV-SNP specification for further detail on the launch input.
>  
> +20. KVM_SNP_LAUNCH_UPDATE
> +-------------------------
> +
> +The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It also
> +calculates a measurement of the memory contents. The measurement is a signature
> +of the memory contents that can be sent to the guest owner as an attestation
> +that the memory was encrypted correctly by the firmware.
> +
> +Parameters (in): struct  kvm_snp_launch_update
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_update {
> +                __u64 start_gfn;        /* Guest page number to start from. */
> +                __u64 uaddr;            /* userspace address need to be encrypted */
> +                __u32 len;              /* length of memory region */
> +                __u8 imi_page;          /* 1 if memory is part of the IMI */
> +                __u8 page_type;         /* page type */
> +                __u8 vmpl3_perms;       /* VMPL3 permission mask */
> +                __u8 vmpl2_perms;       /* VMPL2 permission mask */
> +                __u8 vmpl1_perms;       /* VMPL1 permission mask */
> +        };
> +
> +See the SEV-SNP spec for further details on how to build the VMPL permission
> +mask and page type.
> +
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 41b83aa6b5f4..b5f0707d7ed6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -18,6 +18,7 @@
>  #include <linux/processor.h>
>  #include <linux/trace_events.h>
>  #include <linux/hugetlb.h>
> +#include <linux/sev.h>
>  
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
> @@ -233,6 +234,49 @@ static void sev_decommission(unsigned int handle)
>  	sev_guest_decommission(&decommission, NULL);
>  }
>  
> +static inline void snp_leak_pages(u64 pfn, enum pg_level level)
> +{
> +	unsigned int npages = page_level_size(level) >> PAGE_SHIFT;
> +
> +	WARN(1, "psc failed pfn 0x%llx pages %d (leaking)\n", pfn, npages);
> +
> +	while (npages) {
> +		memory_failure(pfn, 0);
> +		dump_rmpentry(pfn);
> +		npages--;
> +		pfn++;
> +	}
> +}
> +
> +static int snp_page_reclaim(u64 pfn)
> +{
> +	struct sev_data_snp_page_reclaim data = {0};
> +	int err, rc;
> +
> +	data.paddr = __sme_set(pfn << PAGE_SHIFT);
> +	rc = snp_guest_page_reclaim(&data, &err);
> +	if (rc) {
> +		/*
> +		 * If the reclaim failed, then page is no longer safe
> +		 * to use.
> +		 */
> +		snp_leak_pages(pfn, PG_LEVEL_4K);
> +	}
> +
> +	return rc;
> +}
> +
> +static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
> +{
> +	int rc;
> +
> +	rc = rmp_make_shared(pfn, level);
> +	if (rc && leak)
> +		snp_leak_pages(pfn, level);
> +
> +	return rc;
> +}
> +
>  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  {
>  	struct sev_data_deactivate deactivate;
> @@ -1902,6 +1946,123 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct list_head *head = &sev->regions_list;
> +	struct enc_region *i;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	list_for_each_entry(i, head, list) {
> +		u64 start = i->uaddr;
> +		u64 end = start + i->size;
> +
> +		if (start <= hva && end >= (hva + len))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_launch_update data = {0};
> +	struct kvm_sev_snp_launch_update params;
> +	unsigned long npages, pfn, n = 0;
> +	int *error = &argp->error;
> +	struct page **inpages;
> +	int ret, i, level;
> +	u64 gfn;
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
> +	/* Verify that the specified address range is registered. */
> +	if (!is_hva_registered(kvm, params.uaddr, params.len))
> +		return -EINVAL;
> +
> +	/*
> +	 * The userspace memory is already locked so technically we don't
> +	 * need to lock it again. Later part of the function needs to know
> +	 * pfn so call the sev_pin_memory() so that we can get the list of
> +	 * pages to iterate through.
> +	 */
> +	inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
> +	if (!inpages)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Verify that all the pages are marked shared in the RMP table before
> +	 * going further. This is avoid the cases where the userspace may try
> +	 * updating the same page twice.
> +	 */
> +	for (i = 0; i < npages; i++) {
> +		if (snp_lookup_rmpentry(page_to_pfn(inpages[i]), &level) != 0) {
> +			sev_unpin_memory(kvm, inpages, npages);
> +			return -EFAULT;
> +		}
> +	}
> +
> +	gfn = params.start_gfn;
> +	level = PG_LEVEL_4K;
> +	data.gctx_paddr = __psp_pa(sev->snp_context);
> +
> +	for (i = 0; i < npages; i++) {
> +		pfn = page_to_pfn(inpages[i]);
> +
> +		ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, level, sev_get_asid(kvm), true);
> +		if (ret) {
> +			ret = -EFAULT;
> +			goto e_unpin;
> +		}
> +
> +		n++;
> +		data.address = __sme_page_pa(inpages[i]);
> +		data.page_size = X86_TO_RMP_PG_LEVEL(level);
> +		data.page_type = params.page_type;
> +		data.vmpl3_perms = params.vmpl3_perms;
> +		data.vmpl2_perms = params.vmpl2_perms;
> +		data.vmpl1_perms = params.vmpl1_perms;
> +		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
> +		if (ret) {
> +			/*
> +			 * If the command failed then need to reclaim the page.
> +			 */
> +			snp_page_reclaim(pfn);
> +			goto e_unpin;
> +		}
> +
> +		gfn++;
> +	}
> +
> +e_unpin:
> +	/* Content of memory is updated, mark pages dirty */
> +	for (i = 0; i < n; i++) {
> +		set_page_dirty_lock(inpages[i]);
> +		mark_page_accessed(inpages[i]);
> +
> +		/*
> +		 * If its an error, then update RMP entry to change page ownership
> +		 * to the hypervisor.
> +		 */
> +		if (ret)
> +			host_rmp_make_shared(pfn, level, true);
> +	}
> +
> +	/* Unlock the user pages */
> +	sev_unpin_memory(kvm, inpages, npages);
> +
> +	return ret;
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -1995,6 +2156,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_START:
>  		r = snp_launch_start(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_LAUNCH_UPDATE:
> +		r = snp_launch_update(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> @@ -2113,6 +2277,29 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>  static void __unregister_enc_region_locked(struct kvm *kvm,
>  					   struct enc_region *region)
>  {
> +	unsigned long i, pfn;
> +	int level;
> +
> +	/*
> +	 * The guest memory pages are assigned in the RMP table. Unassign it
> +	 * before releasing the memory.
> +	 */
> +	if (sev_snp_guest(kvm)) {
> +		for (i = 0; i < region->npages; i++) {
> +			pfn = page_to_pfn(region->pages[i]);
> +
> +			if (!snp_lookup_rmpentry(pfn, &level))
> +				continue;
> +
> +			cond_resched();
> +
> +			if (level > PG_LEVEL_4K)
> +				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> +
> +			host_rmp_make_shared(pfn, level, true);
> +		}
> +	}
> +
>  	sev_unpin_memory(kvm, region->pages, region->npages);
>  	list_del(&region->list);
>  	kfree(region);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0cb119d66ae5..9b36b07414ea 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1813,6 +1813,7 @@ enum sev_cmd_id {
>  	/* SNP specific commands */
>  	KVM_SEV_SNP_INIT,
>  	KVM_SEV_SNP_LAUNCH_START,
> +	KVM_SEV_SNP_LAUNCH_UPDATE,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -1929,6 +1930,24 @@ struct kvm_sev_snp_launch_start {
>  	__u8 pad[6];
>  };
>  
> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
> +#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
> +
> +struct kvm_sev_snp_launch_update {
> +	__u64 start_gfn;
> +	__u64 uaddr;
> +	__u32 len;
> +	__u8 imi_page;
> +	__u8 page_type;
> +	__u8 vmpl3_perms;
> +	__u8 vmpl2_perms;
> +	__u8 vmpl1_perms;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> -- 
> 2.25.1
> 

BR, Jarkko
