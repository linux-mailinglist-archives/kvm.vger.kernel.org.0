Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F4172CB83
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbjFLQal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 12:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjFLQaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 12:30:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01251AC;
        Mon, 12 Jun 2023 09:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686587438; x=1718123438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QhNATEJQnWJ6d9I9Xkx5FpQ9VU6vwCfeDSbUV8NvC4c=;
  b=bNKbhC05ctOLEwTNofmdXN5UFPm6ndTaMDakTi9B7DMPl4YOZPyBf56O
   hx5ntinfYs8znEQvFCbFkbtKATQjG27DO83XMgwYwMPAQtUnAz7ZMwUUi
   tlxjYfHsbMC5XPdZIgyvBM84hQD74mVCIUuM5tqVHXrJ0XMGS2tFJUiSm
   Ot2YrmqW07SiIb1DoQPGX1wFUe7DZlK8GFl0HZRqrcqaneKgEiDVWXxv+
   OwjFbiWsg1p0Bde373DVsfMxE/i8uPlemowlXsdio34iNuHPvk0OhUp+U
   c9EsfuJ/bZ+CKLK4sCuwSbuO9Gkwv+pbZtOf8B8zyMgtJmjNKb5cl+Ysi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="337729024"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="337729024"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:30:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="1041415457"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="1041415457"
Received: from spmantha-mobl1.amr.corp.intel.com (HELO [10.209.43.2]) ([10.209.43.2])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:30:36 -0700
Message-ID: <93654914-c3d9-8927-8ab2-ee4597426924@intel.com>
Date:   Mon, 12 Jun 2023 09:30:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 12/51] x86/fault: Report RMP page faults for kernel
 addresses
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
        zhi.a.wang@intel.com
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-13-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230612042559.375660-13-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/23 21:25, Michael Roth wrote:
>  	dump_pagetable(address);
> +
> +	if (error_code & X86_PF_RMP) {
> +		unsigned int level;
> +		pgd_t *pgd;
> +		pte_t *pte;
> +
> +		pgd = __va(read_cr3_pa());
> +		pgd += pgd_index(address);
> +		pte = lookup_address_in_pgd(pgd, address, &level);
> +
> +		sev_dump_rmpentry(pte_pfn(*pte));
> +	}
>  }

It would be nice to trim this hunk down.  Can you make it:

	if (error_code & X86_PF_RMP)
		sev_dump_rmpentry(address);

and hide the rest of the logic in the helper?

Oh, and lookup_address_in_pgd() can return NULL.  It's not great to page
fault in the page fault handler.  Could you fix that up too, please?
