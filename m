Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05933587B74
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 13:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiHBLSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 07:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBLR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 07:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65DB2E5;
        Tue,  2 Aug 2022 04:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6502F611C5;
        Tue,  2 Aug 2022 11:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439B6C433C1;
        Tue,  2 Aug 2022 11:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659439077;
        bh=ASrf9MNJD8iUzMx7bBsa2lIAPoGjHS6tgZcQycTLCjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n8K7XF4onnhIWwEv4NbAuDuNw0TNYzhxLXkMsjPNY2V81CZwDIJxbMFs4mc00m/kL
         jDLohMWWVyvYNbxvVSx/G4P5Lgok8cPkQBW7NQVAXHpUJDjTHonBZmUyKnNO+vrEYG
         h/li8tYo8MMbeqnUDPhfhEKyAhw6rMZeDwCJHyCOY4/rnzlz/lhHoZL4uvjuD6N9yC
         nYnIuNIqMH/knMO0Pg26P4RKJfoEYCtcQ2pXT2EZOrtcSDkOY9eLDpLjbcCwf6HjZY
         yhwzDpX5Zk0t4VgWj5AjJg7d3ULytRoEGsQHUb0W6TmPkyktSROmPbShpKtcqd97rG
         44dXdZReN4DzQ==
Date:   Tue, 2 Aug 2022 14:17:53 +0300
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
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <YukH4RkfeX2IVahD@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:05:01PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The behavior and requirement for the SEV-legacy command is altered when
> the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> for more details.
> 
> Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
> when SNP is enabled to satify new requirements for the SNP. Continue
> allocating a 1mb region for !SNP configuration.
> 
> While at it, provide API that can be used by others to allocate a page
> that can be used by the firmware. The immediate user for this API will
> be the KVM driver. The KVM driver to need to allocate a firmware context
> page during the guest creation. The context page need to be updated
> by the firmware. See the SEV-SNP specification for further details.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 173 +++++++++++++++++++++++++++++++++--
>  include/linux/psp-sev.h      |  11 +++
>  2 files changed, 178 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 35d76333e120..0dbd99f29b25 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -79,6 +79,14 @@ static void *sev_es_tmr;
>  #define NV_LENGTH (32 * 1024)
>  static void *sev_init_ex_buffer;
>  
> +/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
> +#define SEV_SNP_ES_TMR_SIZE	(2 * 1024 * 1024)
> +
> +static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
> +
> +static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
> +static int sev_do_cmd(int cmd, void *data, int *psp_ret);
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -177,11 +185,161 @@ static int sev_cmd_buffer_len(int cmd)
>  	return 0;
>  }
>  
> +static void snp_leak_pages(unsigned long pfn, unsigned int npages)
> +{
> +	WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
> +	while (npages--) {
> +		memory_failure(pfn, 0);
> +		dump_rmpentry(pfn);
> +		pfn++;
> +	}
> +}
> +
> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
> +{
> +	struct sev_data_snp_page_reclaim data;
> +	int ret, err, i, n = 0;
> +
> +	for (i = 0; i < npages; i++) {
> +		memset(&data, 0, sizeof(data));
> +		data.paddr = pfn << PAGE_SHIFT;
> +
> +		if (locked)
> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +		else
> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +		if (ret)
> +			goto cleanup;
> +
> +		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +		if (ret)
> +			goto cleanup;
> +
> +		pfn++;
> +		n++;
> +	}
> +
> +	return 0;
> +
> +cleanup:
> +	/*
> +	 * If failed to reclaim the page then page is no longer safe to
> +	 * be released, leak it.
> +	 */
> +	snp_leak_pages(pfn, npages - n);
> +	return ret;
> +}
> +
> +static inline int rmp_make_firmware(unsigned long pfn, int level)
> +{
> +	return rmp_make_private(pfn, 0, level, 0, true);
> +}
> +
> +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
> +			     bool need_reclaim)
> +{
> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */
> +	int rc, n = 0, i;
> +
> +	for (i = 0; i < npages; i++) {
> +		if (to_fw)
> +			rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
> +		else
> +			rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
> +					    rmp_make_shared(pfn, PG_LEVEL_4K);
> +		if (rc)
> +			goto cleanup;
> +
> +		pfn++;
> +		n++;
> +	}
> +
> +	return 0;
> +
> +cleanup:
> +	/* Try unrolling the firmware state changes */
> +	if (to_fw) {
> +		/*
> +		 * Reclaim the pages which were already changed to the
> +		 * firmware state.
> +		 */
> +		snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
> +
> +		return rc;
> +	}
> +
> +	/*
> +	 * If failed to change the page state to shared, then its not safe
> +	 * to release the page back to the system, leak it.
> +	 */
> +	snp_leak_pages(pfn, npages - n);
> +
> +	return rc;
> +}
> +
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
> +{
> +	unsigned long npages = 1ul << order, paddr;
> +	struct sev_device *sev;
> +	struct page *page;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return NULL;
> +
> +	page = alloc_pages(gfp_mask, order);
> +	if (!page)
> +		return NULL;
> +
> +	/* If SEV-SNP is initialized then add the page in RMP table. */
> +	sev = psp_master->sev_data;
> +	if (!sev->snp_inited)
> +		return page;
> +
> +	paddr = __pa((unsigned long)page_address(page));
> +	if (snp_set_rmp_state(paddr, npages, true, locked, false))
> +		return NULL;
> +
> +	return page;
> +}
> +
> +void *snp_alloc_firmware_page(gfp_t gfp_mask)
> +{
> +	struct page *page;
> +
> +	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);

Could be just

        struct page *page  == __snp_alloc_firmware_pages(gfp_mask, 0, false);

> +
> +	return page ? page_address(page) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);

Undocumented API

Why don't you just export __snp_alloc_firmware_pages() and declare these
trivial wrappers as "static inline" inside psp-sev.h?

> +
> +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
> +{
> +	unsigned long paddr, npages = 1ul << order;
> +
> +	if (!page)
> +		return;

Silently ignored NULL pointer.

> +
> +	paddr = __pa((unsigned long)page_address(page));
> +	if (snp_set_rmp_state(paddr, npages, false, locked, true))
> +		return;
> +
> +	__free_pages(page, order);
> +}
> +
> +void snp_free_firmware_page(void *addr)
> +{
> +	if (!addr)
> +		return;

Why silently ignore a NULL pointer? At minimum, pr_warn() would be
appropriate.

> +
> +	__snp_free_firmware_pages(virt_to_page(addr), 0, false);
> +}
> +EXPORT_SYMBOL(snp_free_firmware_page);

Ditto, same comments as for allocation part.

> +
>  static void *sev_fw_alloc(unsigned long len)
>  {
>  	struct page *page;
>  
> -	page = alloc_pages(GFP_KERNEL, get_order(len));
> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), false);
>  	if (!page)
>  		return NULL;
>  
> @@ -393,7 +551,7 @@ static int __sev_init_locked(int *error)
>  		data.tmr_address = __pa(sev_es_tmr);
>  
>  		data.flags |= SEV_INIT_FLAGS_SEV_ES;
> -		data.tmr_len = SEV_ES_TMR_SIZE;
> +		data.tmr_len = sev_es_tmr_size;
>  	}
>  
>  	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> @@ -421,7 +579,7 @@ static int __sev_init_ex_locked(int *error)
>  		data.tmr_address = __pa(sev_es_tmr);
>  
>  		data.flags |= SEV_INIT_FLAGS_SEV_ES;
> -		data.tmr_len = SEV_ES_TMR_SIZE;
> +		data.tmr_len = sev_es_tmr_size;
>  	}
>  
>  	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> @@ -818,6 +976,8 @@ static int __sev_snp_init_locked(int *error)
>  	sev->snp_inited = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>  
> +	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
> +
>  	return rc;
>  }
>  
> @@ -1341,8 +1501,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>  		/* The TMR area was encrypted, flush it from the cache */
>  		wbinvd_on_all_cpus();
>  
> -		free_pages((unsigned long)sev_es_tmr,
> -			   get_order(SEV_ES_TMR_SIZE));
> +		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +					  get_order(sev_es_tmr_size),
> +					  false);
>  		sev_es_tmr = NULL;
>  	}
>  
> @@ -1430,7 +1591,7 @@ void sev_pci_init(void)
>  	}
>  
>  	/* Obtain the TMR memory area for SEV-ES use */
> -	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
> +	sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
>  	if (!sev_es_tmr)
>  		dev_warn(sev->dev,
>  			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 9f921d221b75..a3bb792bb842 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -12,6 +12,8 @@
>  #ifndef __PSP_SEV_H__
>  #define __PSP_SEV_H__
>  
> +#include <linux/sev.h>
> +
>  #include <uapi/linux/psp-sev.h>
>  
>  #ifdef CONFIG_X86
> @@ -940,6 +942,8 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
>  int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
>  
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
> +void *snp_alloc_firmware_page(gfp_t mask);
> +void snp_free_firmware_page(void *addr);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -981,6 +985,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
>  	return -ENODEV;
>  }
>  
> +static inline void *snp_alloc_firmware_page(gfp_t mask)
> +{
> +	return NULL;
> +}
> +
> +static inline void snp_free_firmware_page(void *addr) { }
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */
> -- 
> 2.25.1
> 

BR, Jarkko









