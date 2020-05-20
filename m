Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13EA1DAAA7
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 08:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgETGcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 02:32:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:50846 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgETGcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 02:32:02 -0400
IronPort-SDR: ngqDIfaiPPT/MqWJMon2i8doPM/I9KWptgMwjRxn5VU9yjkePbdRINVxThK22AHybePMnUllOl
 JNvQW6FlXjJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 23:32:02 -0700
IronPort-SDR: mW5f0SKYuUsLZSLzn563ghbJkf94Dian/7xrwSzP2PWLuA1iCfPIMgfSv6bXJ0eHZ5Wohpy5ix
 VnnkMl3319hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="264574336"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 19 May 2020 23:32:02 -0700
Date:   Tue, 19 May 2020 23:32:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 51/75] x86/sev-es: Handle MMIO events
Message-ID: <20200520063202.GB17090@linux.intel.com>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-52-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-52-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:01PM +0200, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Add handler for VC exceptions caused by MMIO intercepts. These
> intercepts come along as nested page faults on pages with reserved
> bits set.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: Adapt to VC handling framework ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---

...

> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index f4ce3b475464..e3662723ed76 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -294,6 +294,25 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>  	return ES_EXCEPTION;
>  }
>  
> +static phys_addr_t vc_slow_virt_to_phys(struct ghcb *ghcb, unsigned long vaddr)
> +{
> +	unsigned long va = (unsigned long)vaddr;
> +	unsigned int level;
> +	phys_addr_t pa;
> +	pgd_t *pgd;
> +	pte_t *pte;
> +
> +	pgd = pgd_offset(current->active_mm, va);
> +	pte = lookup_address_in_pgd(pgd, va, &level);
> +	if (!pte)
> +		return 0;

'0' is a valid physical address.  It happens to be reserved in the kernel
thanks to L1TF, but using '0' as an error code is ugly.  Not to mention
none of the callers actually check the result.

> +
> +	pa = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
> +	pa |= va & ~page_level_mask(level);
> +
> +	return pa;
> +}
