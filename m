Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2554B775F8E
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 14:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjHIMqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 08:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjHIMqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 08:46:32 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83F2F19A1;
        Wed,  9 Aug 2023 05:46:31 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id D6FD120FC3FE; Wed,  9 Aug 2023 05:46:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D6FD120FC3FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1691585190;
        bh=G0gxRN5QnxTLEOIdIvEe864KwskWfmwxWJZYwvjDSlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JvqfUwlrN8SFoQZfvoGT5ol8Tmiz9HmGGUsXNPJy28y9tdBKDtRIpIkaO0RTgvnGy
         me82/2JlMkKOJ8nouwy+b6PR8sxGfLnSMkNPCxFctzUFbnJb3MMLT5naT+6xEjxA9q
         sQa3F9+OJGboaWVu/aYlKhbXeWKFEEG9axlkdoYo=
Date:   Wed, 9 Aug 2023 05:46:30 -0700
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
Subject: Re: [PATCH RFC v9 19/51] x86/sev: Introduce snp leaked pages list
Message-ID: <20230809124630.GA11150@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-20-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-20-michael.roth@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:27PM -0500, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Pages are unsafe to be released back to the page-allocator, if they
> have been transitioned to firmware/guest state and can't be reclaimed
> or transitioned back to hypervisor/shared state. In this case add
> them to an internal leaked pages list to ensure that they are not freed
> or touched/accessed to cause fatal page faults.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: relocate to arch/x86/coco/sev/host.c]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/coco/sev/host.c        | 28 ++++++++++++++++++++++++++++
>  arch/x86/include/asm/sev-host.h |  3 +++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/host.c b/arch/x86/coco/sev/host.c
> index cd3b4c6a25bc..373e91f5a337 100644
> --- a/arch/x86/coco/sev/host.c
> +++ b/arch/x86/coco/sev/host.c
> @@ -64,6 +64,12 @@ struct rmpentry {
>  static unsigned long rmptable_start __ro_after_init;
>  static unsigned long rmptable_end __ro_after_init;
>  
> +/* list of pages which are leaked and cannot be reclaimed */
> +static LIST_HEAD(snp_leaked_pages_list);
> +static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> +
> +static atomic_long_t snp_nr_leaked_pages = ATOMIC_LONG_INIT(0);
> +
>  #undef pr_fmt
>  #define pr_fmt(fmt)	"SEV-SNP: " fmt
>  
> @@ -494,3 +500,25 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
>  	return rmpupdate(pfn, &val);
>  }
>  EXPORT_SYMBOL_GPL(rmp_make_shared);
> +
> +void snp_leak_pages(unsigned long pfn, unsigned int npages)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	WARN(1, "psc failed, pfn 0x%lx pages %d (marked offline)\n", pfn, npages);
> +
> +	spin_lock(&snp_leaked_pages_list_lock);
> +	while (npages--) {
> +		/*
> +		 * Reuse the page's buddy list for chaining into the leaked
> +		 * pages list. This page should not be on a free list currently
> +		 * and is also unsafe to be added to a free list.
> +		 */
> +		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
> +		sev_dump_rmpentry(pfn);
> +		pfn++;
> +	}
> +	spin_unlock(&snp_leaked_pages_list_lock);
> +	atomic_long_inc(&snp_nr_leaked_pages);
> +}
> +EXPORT_SYMBOL_GPL(snp_leak_pages);
> diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
> index 753e80d16433..bab3b226777a 100644
> --- a/arch/x86/include/asm/sev-host.h
> +++ b/arch/x86/include/asm/sev-host.h
> @@ -19,6 +19,8 @@ void sev_dump_rmpentry(u64 pfn);
>  int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
> +void snp_leak_pages(unsigned long pfn, unsigned int npages);
> +
>  #else
>  static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
>  static inline void sev_dump_rmpentry(u64 pfn) {}
> @@ -29,6 +31,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
>  	return -ENODEV;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
> +void snp_leak_pages(unsigned long pfn, unsigned int npages) {}

This needs to be 'static inline' or the build fails with multiple definition errors.
I'm building a guest kernel with CONFIG_KVM_AMD_SEV disabled.

Jeremi

>  #endif
>  
>  #endif
> -- 
> 2.25.1
> 
