Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB435ADD57
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 04:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbiIFCa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 22:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiIFCaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 22:30:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFB41EC4C;
        Mon,  5 Sep 2022 19:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662431423; x=1693967423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G15JBOOK8EI0eKdSgCyHHPZ83FHdpeAzR9JiZNu8Z80=;
  b=ctWO8hLyA7EwoykAyUfgcO7CLnzbn5WXDrrbhGZhd9Bh0ocUdSu4K02W
   RdufqUSzCKyzvj5vFYndAxxGBNqUj7qkKE8ZlgnKmQinBmU0E0roafWrq
   FQ6FpyVGD5HLAW1+rOxD4QWuX1sFfnJzwbqAiXyULtCYo2/cfSLxdGuxX
   yj7bkeRYJYxZLDN6/ol0+UkIlpoqyUrXRp2PBqCRs5WW6YqD0iDC4Uipo
   INMvloUCaGJX73bLh6EvRV2o+RHORxKwweoU9lAsQGog+SwlWVjKQqnqI
   JdoKywYJJtI4ZLESDFsaGN5qb/jMOJbG5HWA72Ln6/6YJSCaIfvXNQGjl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="283480856"
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="283480856"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 19:30:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="643983689"
Received: from chenchar-mobl1.amr.corp.intel.com (HELO [10.212.193.190]) ([10.212.193.190])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 19:30:22 -0700
Message-ID: <0ce441af-c825-3061-ad92-c360c339e924@intel.com>
Date:   Mon, 5 Sep 2022 19:30:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
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
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 16:03, Ashish Kalra wrote:
> 
> When SEV-SNP is enabled globally, a write from the host goes through the
> RMP check. When the host writes to pages, hardware checks the following
> conditions at the end of page walk:
> 
> 1. Assigned bit in the RMP table is zero (i.e page is shared).
> 2. If the page table entry that gives the sPA indicates that the target
>    page size is a large page, then all RMP entries for the 4KB
>    constituting pages of the target must have the assigned bit 0.
> 3. Immutable bit in the RMP table is not zero.
> 
> The hardware will raise page fault if one of the above conditions is not
> met. Try resolving the fault instead of taking fault again and again. If
> the host attempts to write to the guest private memory then send the
> SIGBUS signal to kill the process. If the page level between the host and
> RMP entry does not match, then split the address to keep the RMP and host
> page levels in sync.

When you're working on this changelog for Borislav, I'd like to make one
other suggestion:  Please write it more logically and _less_ about what
the hardware is doing.  We don't need about the internal details of what
hardware is doing in the changelog.  Mentioning whether an RMP bit is 0
or 1 is kinda silly unless it matters to the code.

For instance, what does the immutable bit have to do with all of this?
There's no specific handling for it.  There are really only faults that
you can handle and faults that you can't.

There's also some major missing context here about how it guarantees
that pages that can't be handled *CAN* be split.  I think it has to do
with disallowing hugetlbfs which implies that the only pages that might
need splitting are THP's.+	/*
> +	 * If its an RMP violation, try resolving it.
> +	 */
> +	if (error_code & X86_PF_RMP) {
> +		if (handle_user_rmp_page_fault(regs, error_code, address))
> +			return;
> +
> +		/* Ask to split the page */
> +		flags |= FAULT_FLAG_PAGE_SPLIT;
> +	}

This also needs some chatter about why any failure to handle the fault
automatically means splitting a page.
