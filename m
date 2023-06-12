Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF62872CB37
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbjFLQOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 12:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjFLQOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 12:14:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25951BC7;
        Mon, 12 Jun 2023 09:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686586455; x=1718122455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nxVNBn+XWFWeEHcN8pf1WYBMgr4o1yAKNG8v2o0cHHw=;
  b=JLFnb+nCWWyfIXGAqAwkc/zTQh+tc5f1oIBfQloqo0/ec7KItbbMjJHw
   hdH3or2aAFoS89DfYEqzQT600buQVnIrjiWN5U82ICbVJFrf2n8clvg+P
   X6jEKSo/ozHR7logih0JF8xCjyMpdLcpe6koaoUUR4C7Kf/R6UKk4b0A2
   /x0+kks3uLJhKh+wrbYbdS4mRLPphQ42tODo/iIvkQ7Y0QEQkcMtjViZS
   zBpdM+Zwr9lCQ1bAqddLgVd1iYfPtxT9qw/OCsy5BGLeb5rXpYMH0OKzy
   A/ojQ/+AYHqLK6I7UaylDYadeJlLIXzTnnYEbs5rhJ9RwewvyFQq9CM6a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="356976308"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="356976308"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:12:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="705457138"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="705457138"
Received: from spmantha-mobl1.amr.corp.intel.com (HELO [10.209.43.2]) ([10.209.43.2])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:12:34 -0700
Message-ID: <15148682-e2fd-8176-563b-74acf9815b6d@intel.com>
Date:   Mon, 12 Jun 2023 09:12:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 10/51] x86/fault: Add helper for dumping RMP
 entries
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
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
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-11-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230612042559.375660-11-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/23 21:25, Michael Roth wrote:
> +	/*
> +	 * If the RMP entry at the faulting pfn was not assigned, then not sure
> +	 * what caused the RMP violation. To get some useful debug information,
> +	 * iterate through the entire 2MB region, and dump the RMP entries if
> +	 * one of the bit in the RMP entry is set.
> +	 */
> +	pfn = pfn & ~(PTRS_PER_PMD - 1);
> +	pfn_end = pfn + PTRS_PER_PMD;
> +
> +	while (pfn < pfn_end) {
> +		ret = __snp_lookup_rmpentry(pfn, &e, &level);
> +		if (ret) {
> +			pr_info("Failed to read RMP entry for PFN 0x%llx\n", pfn);
> +			pfn++;
> +			continue;
> +		}
> +
> +		if (e.low || e.high)
> +			pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +				pfn << PAGE_SHIFT, e.high, e.low);
> +		pfn++;
> +	}
> +}

Dumping 511 lines of (possible) junk into the dmesg buffer seems a _bit_
rude here.  I can see dumping out the 2M RMP entry, but not the other 510.

This also destroys the information about which pfn was being targeted
for the dump in the first place.  That seems unfortunate.
