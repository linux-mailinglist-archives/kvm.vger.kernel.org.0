Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A57589CCC
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbiHDNhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 09:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbiHDNhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 09:37:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911203D5B5;
        Thu,  4 Aug 2022 06:37:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2896921068;
        Thu,  4 Aug 2022 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659620238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4z4bB0wf9LcF9P6u2FPUyZHxaeD5A+EOAqqR1WSbcG4=;
        b=BXgO1RCi6DXmG5yZlxDlMsnurvSrUNO/6LU+fwYMGsA2KiyInuHZy5B+Z+0xmwLjX9vvTg
        TGwZgIzeXkTEwi9Wl7yuERuGSQRaLUK5aJj9VMY+ky1oVWsdMoEQrcCEWqAIGrWvhJXgS+
        b3PLvVILPAybITOU257Nx/Dfo6dDTws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659620238;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4z4bB0wf9LcF9P6u2FPUyZHxaeD5A+EOAqqR1WSbcG4=;
        b=z0C+PLAADumOtWMXMulg5tP5ulysMkSTVGsW6yee5rER0go9eeH1Ci+9u33zw6DI9k6HDD
        TmakTx0UQv3ICaDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A4FA113434;
        Thu,  4 Aug 2022 13:37:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Rje4J43L62K/YAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 04 Aug 2022 13:37:17 +0000
Message-ID: <5c806192-f62c-5ea3-820d-8d629e0b0eba@suse.cz>
Date:   Thu, 4 Aug 2022 15:37:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH Part2 v6 25/49] KVM: SVM: Disallow registering memory
 range from HugeTLB for SNP guest
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
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <b32e0daab8af130a1bda76eb06ecd2546e8478bb.1655761627.git.ashish.kalra@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <b32e0daab8af130a1bda76eb06ecd2546e8478bb.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/22 01:07, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> While creating the VM, userspace call the KVM_MEMORY_ENCRYPT_REG_REGION
> ioctl to register the memory regions for the guest. This registered
> memory region is typically used as a guest RAM. Later, the guest may
> issue the page state change (PSC) request that will require splitting
> the large page into smaller page. If the memory is allocated from the
> HugeTLB then hypervisor will not be able to split it.
> 
> Do not allow registering the memory range backed by the HugeTLB until
> the hypervisor support is added to handle the case.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9e6fc7a94ed7..41b83aa6b5f4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -17,6 +17,7 @@
>  #include <linux/misc_cgroup.h>
>  #include <linux/processor.h>
>  #include <linux/trace_events.h>
> +#include <linux/hugetlb.h>
>  
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
> @@ -2007,6 +2008,35 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	return r;
>  }
>  
> +static bool is_range_hugetlb(struct kvm *kvm, struct kvm_enc_region *range)
> +{
> +	struct vm_area_struct *vma;
> +	u64 start, end;
> +	bool ret = true;
> +
> +	start = range->addr;
> +	end = start + range->size;
> +
> +	mmap_read_lock(kvm->mm);
> +
> +	do {
> +		vma = find_vma_intersection(kvm->mm, start, end);
> +		if (!vma)
> +			goto unlock;
> +
> +		if (is_vm_hugetlb_page(vma))
> +			goto unlock;
> +
> +		start = vma->vm_end;
> +	} while (end > vma->vm_end);

Note it's more efficient to only find the first vma and then iterate using
vma->vm_next. But the details will change when maple tree is merged, and
likely this patch won't exist after rebasing to UPM anyway...

> +	ret = false;
> +
> +unlock:
> +	mmap_read_unlock(kvm->mm);
> +	return ret;
> +}
> +
>  int sev_mem_enc_register_region(struct kvm *kvm,
>  				struct kvm_enc_region *range)
>  {
> @@ -2024,6 +2054,13 @@ int sev_mem_enc_register_region(struct kvm *kvm,
>  	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>  		return -EINVAL;
>  
> +	/*
> +	 * SEV-SNP does not support the backing pages from the HugeTLB. Verify
> +	 * that the registered memory range is not from the HugeTLB.
> +	 */
> +	if (sev_snp_guest(kvm) && is_range_hugetlb(kvm, range))
> +		return -EINVAL;
> +
>  	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>  	if (!region)
>  		return -ENOMEM;

