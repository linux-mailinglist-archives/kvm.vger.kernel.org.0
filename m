Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A303A2C60
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhFJNFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:05:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhFJNFu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 09:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623330234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w1yRG9vI4ont0xlQTDfWQBvjqAZg/7xjdkXXrg1Zl+M=;
        b=WjzeOjJFr2D4llpTZaYez/OMil270b+h7wDPMX/8SVktCogmt/PvUJ3HsHWoCKwicjaoB/
        0KoivJJFE4d1TzRx548V88z3w5jqsWpfIEBf9SUOjXY0UzxaTLQz0LkRSFO6SreFBRbmAL
        AEXdUhz3kvYKghhqQtGxtXUn9Pey790=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-2Zzpl9QmNe-i8YEvI8cx5A-1; Thu, 10 Jun 2021 09:03:51 -0400
X-MC-Unique: 2Zzpl9QmNe-i8YEvI8cx5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95914100C624;
        Thu, 10 Jun 2021 13:03:47 +0000 (UTC)
Received: from work-vm (ovpn-114-240.ams2.redhat.com [10.36.114.240])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 552845C1D1;
        Thu, 10 Jun 2021 13:03:30 +0000 (UTC)
Date:   Thu, 10 Jun 2021 14:03:27 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH Part2 RFC v3 06/37] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <YMINnxkDVzRZ8gCQ@work-vm>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
 <20210602141057.27107-7-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602141057.27107-7-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
> hypervisor will use the instruction to add pages to the RMP table. See
> APM3 for details on the instruction operations.
> 
> The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
> contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
> to adjust the RMP entry without invalidating the previous RMP entry.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kernel/sev.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sev.h   | 20 ++++++++++++++++++++
>  2 files changed, 62 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 51676ab1a321..9727df945fb1 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2226,3 +2226,45 @@ struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)
>  	return entry;
>  }
>  EXPORT_SYMBOL_GPL(snp_lookup_page_in_rmptable);
> +
> +int psmash(struct page *page)
> +{
> +	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;
> +
> +	/* Retry if another processor is modifying the RMP entry. */
> +	do {
> +		/* Binutils version 2.36 supports the PSMASH mnemonic. */
> +		asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +			      : "=a"(ret)
> +			      : "a"(spa)
> +			      : "memory", "cc");
> +	} while (ret == FAIL_INUSE);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(psmash);
> +
> +int rmpupdate(struct page *page, struct rmpupdate *val)
> +{
> +	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;
> +
> +	/* Retry if another processor is modifying the RMP entry. */
> +	do {
> +		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> +		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> +			     : "=a"(ret)
> +			     : "a"(spa), "c"((unsigned long)val)
> +			     : "memory", "cc");
> +	} while (ret == FAIL_INUSE);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmpupdate);
> diff --git a/include/linux/sev.h b/include/linux/sev.h
> index 83c89e999999..bcd4d75d87c8 100644
> --- a/include/linux/sev.h
> +++ b/include/linux/sev.h
> @@ -39,13 +39,33 @@ struct __packed rmpentry {
>  
>  #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
>  
> +struct rmpupdate {
> +	u64 gpa;
> +	u8 assigned;
> +	u8 pagesize;
> +	u8 immutable;
> +	u8 rsvd;
> +	u32 asid;
> +} __packed;
> +
> +
> +/*
> + * The psmash() and rmpupdate() returns FAIL_INUSE when another processor is
> + * modifying the RMP entry.
> + */
> +#define FAIL_INUSE              3

Perhaps SEV_FAIL_INUSE ?

(Given that there are a whole buunch of FAIL_* macros already in
general)

Dave

>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level);
> +int psmash(struct page *page);
> +int rmpupdate(struct page *page, struct rmpupdate *e);
>  #else
>  static inline struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)
>  {
>  	return NULL;
>  }
> +static inline int psmash(struct page *page) { return -ENXIO; }
> +static inline int rmpupdate(struct page *page, struct rmpupdate *e) { return -ENXIO; }
>  
>  #endif /* CONFIG_AMD_MEM_ENCRYPT */
>  #endif /* __LINUX_SEV_H */
> -- 
> 2.17.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

