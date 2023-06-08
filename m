Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6309728BEE
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbjFHXns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjFHXnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:43:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC484A2;
        Thu,  8 Jun 2023 16:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686267825; x=1717803825;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cWSWqOALQFKrNwE8jAhiXlR36iGyYWGvMKM0DXTmNyU=;
  b=aV41ohrtNip8/9mVJjeEDoky9DCEpja2SIZOYhZKGta2Pd5beK4MUK9E
   NOhY0YFiASXKdrQOEzGQDs779zqaXW1azrTYm9f0Tw5lIunHD7v31Gt5V
   XsAhvAcBkFeVed9oE9WV0AptmlpNmGanOIK9LMm7KjUjWvhKppqgnr1+n
   J+Jt8L3Ne8gT5apMKYybsqAPepyLTU7nj6WBX4W/BFNOKvvQBkuWhuc98
   oJ1pcv/83Fi+EORb09zaLwELAFuoScssLBs0y77C8WlnuChzO5W+3SGWb
   hUF0ayC5iR6LaNcAtccLXm47hOhaLbF9el/+bDtssboT5N2UOZdNLwgVg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="347110914"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="347110914"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:43:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="704327805"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="704327805"
Received: from goels-mobl.ger.corp.intel.com (HELO [10.209.86.239]) ([10.209.86.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:43:44 -0700
Message-ID: <b456ea7c-18be-3397-0115-fa25007741bf@intel.com>
Date:   Thu, 8 Jun 2023 16:43:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 12/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     kirill.shutemov@linux.intel.com, Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, tony.luck@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <4e108968c3294189ad150f62df1f146168036342.1685887183.git.kai.huang@intel.com>
 <20230608232452.yrx2tekugkvral4z@box>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230608232452.yrx2tekugkvral4z@box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/23 16:24, kirill.shutemov@linux.intel.com wrote:
>>  	ret = -EINVAL;
>> +	if (ret)
>> +		tdmrs_free_pamt_all(&tdx_tdmr_list);
>> +	else
>> +		pr_info("%lu KBs allocated for PAMT.\n",
>> +				tdmrs_count_pamt_pages(&tdx_tdmr_list) * 4);
> "* 4"? This is very cryptic. procfs uses "<< (PAGE_SHIFT - 10)" which
> slightly less magic to me. And just make the helper that returns kilobytes
> to begin with, if it is the only caller.

Let's look at where this data comes from:

+static unsigned long tdmrs_count_pamt_pages(struct tdmr_info_list
*tdmr_list)
+{
+	unsigned long pamt_npages = 0;
+	int i;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		unsigned long pfn, npages;
+
+		tdmr_get_pamt(tdmr_entry(tdmr_list, i), &pfn, &npages);
+		pamt_npages += npages;
+	}

OK, so tdmr_get_pamt() is getting it in pages.  How is it *stored*?

+static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_pfn,
+			  unsigned long *pamt_npages)
+{
...
+	pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
++	*pamt_pfn = PHYS_PFN(pamt_base);
+	*pamt_npages = pamt_sz >> PAGE_SHIFT;
+}

Oh, it's actually stored in bytes.  So to print it out you actually
convert it from bytes->pages->kbytes.  Not the best.

If tdmr_get_pamt() just returned 'pamt_size_bytes', you could do one
conversion at:

	free_contig_range(pamt_pfn, pamt_size_bytes >> PAGE_SIZE);

and since tdmrs_count_pamt_pages() has only one caller you can just make
it:  tdmrs_count_pamt_kb().  The print becomes:

	pr_info("%lu KBs allocated for PAMT.\n",
		tdmrs_count_pamt_kb(&tdx_tdmr_list) * 4);

and tdmrs_count_pamt_kb() does something super fancy like:

	return pamt_size_bytes / 1024;

which makes total complete obvious sense and needs zero explanation.
