Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6539C41CBB0
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345890AbhI2SVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 14:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343727AbhI2SVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 14:21:11 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88869C06161C;
        Wed, 29 Sep 2021 11:19:30 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0bd10085b5178de8b08a0e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:d100:85b5:178d:e8b0:8a0e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 02A081EC085D;
        Wed, 29 Sep 2021 20:19:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632939569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=O7rqBdueKVcv868vxhmTrVj9530r51QyHCjtnH4N2yw=;
        b=YBeC8KzmokpHoM3sHCUpYrsqpmDKYWwohdWWv+BVMrKJKs6BhWST147oDSW/w60qa6JN1U
        JUGhev5lMmPcvTnwL6N9kHEfMyltYmf3PDBlrL8dilFyE85armnZzSII5dfOB06zZfrHHQ
        LuzApwYwXynEFO67+Ez4FgHu1lYHzKw=
Date:   Wed, 29 Sep 2021 20:19:29 +0200
From:   Borislav Petkov <bp@alien8.de>
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 08/45] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YVSuMUk7Aq0hIl1h@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-9-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-9-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:41AM -0500, Brijesh Singh wrote:
> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
> +				      unsigned long address)
> +{

#ifdef CONFIG_AMD_MEM_ENCRYPT

> +	int rmp_level, level;
> +	pte_t *pte;
> +	u64 pfn;
> +
> +	pte = lookup_address_in_mm(current->mm, address, &level);
> +
> +	/*
> +	 * It can happen if there was a race between an unmap event and
> +	 * the RMP fault delivery.
> +	 */
> +	if (!pte || !pte_present(*pte))
> +		return 1;
> +
> +	pfn = pte_pfn(*pte);
> +
> +	/* If its large page then calculte the fault pfn */
> +	if (level > PG_LEVEL_4K) {
> +		unsigned long mask;
> +
> +		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);

Just use two helper variables named properly instead of this oneliner:

		pages_level 	 = page_level_size(level) / PAGE_SIZE;
		pages_prev_level = page_level_size(level - 1) / PAGE_SIZE;

> +		pfn |= (address >> PAGE_SHIFT) & mask;
> +	}
> +
> +	/*
> +	 * If its a guest private page, then the fault cannot be resolved.
> +	 * Send a SIGBUS to terminate the process.
> +	 */
> +	if (snp_lookup_rmpentry(pfn, &rmp_level)) {
> +		do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
> +		return 1;
> +	}
> +
> +	/*
> +	 * The backing page level is higher than the RMP page level, request
> +	 * to split the page.
> +	 */
> +	if (level > rmp_level)
> +		return 0;
> +
> +	return 1;

#else
	WARN_ONONCE(1);
	return -1;
#endif

and also handle that -1 negative value at the call site.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
