Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD063396D
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 11:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiKVKLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 05:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiKVKLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 05:11:11 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A4153EE8;
        Tue, 22 Nov 2022 02:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2kluR8XS/5l2vEzd270Z9ykwF5m8DT9IrYcaeynxfAY=; b=d6+qGB5BG/okyjo+T6PgxWuj8F
        NiFipH0849DEGMlf5aUr7bJHGWYBrgu0/Ge7R6qXNkY3IGC8R2UzcvbH9B4Y7s/IUzdzSSt1J34re
        w/ptngkZSYG/iTiBptnCDbEnHiJY/9YAsp3c9Mb9/So0DzVoImDGM9KcUbLVXZiQaig8Rb27KHize
        X9G4UbIITIeQKHqOxFO+ciMp6bORDsUNhKLBnzWI4irR7rteseajYbJ6SahLvAhs63rhgBUYeEo07
        xs9dx9aTWKxrYoUw4FCqqXM91+Hnt00h1cY3uokF/3aQwH3NZUeWhlwR8xhpQI9bM4Vrg6mKmtz/N
        tmQc6P1w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxQEs-003P1G-RT; Tue, 22 Nov 2022 10:10:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 80540300244;
        Tue, 22 Nov 2022 11:10:48 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5BA3E2D66D658; Tue, 22 Nov 2022 11:10:48 +0100 (CET)
Date:   Tue, 22 Nov 2022 11:10:48 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <Y3ygKH0/rdhKwv4m@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 01:26:32PM +1300, Kai Huang wrote:

> +static int build_tdx_memory(void)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	int i, nid, ret;
> +
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> +		/*
> +		 * The first 1MB may not be reported as TDX convertible
> +		 * memory.  Manually exclude them as TDX memory.
> +		 *
> +		 * This is fine as the first 1MB is already reserved in
> +		 * reserve_real_mode() and won't end up to ZONE_DMA as
> +		 * free page anyway.
> +		 */
> +		start_pfn = max(start_pfn, (unsigned long)SZ_1M >> PAGE_SHIFT);
> +		if (start_pfn >= end_pfn)
> +			continue;
> +
> +		/* Verify memory is truly TDX convertible memory */
> +		if (!pfn_range_covered_by_cmr(start_pfn, end_pfn)) {
> +			pr_info("Memory region [0x%lx, 0x%lx) is not TDX convertible memorry.\n",
> +					start_pfn << PAGE_SHIFT,
> +					end_pfn << PAGE_SHIFT);
> +			return -EINVAL;

Given how tdx_cc_memory_compatible() below relies on tdx_memlist being
empty; this error patch is wrong and should goto err.

> +		}
> +
> +		/*
> +		 * Add the memory regions as TDX memory.  The regions in
> +		 * memblock has already guaranteed they are in address
> +		 * ascending order and don't overlap.
> +		 */
> +		ret = add_tdx_memblock(start_pfn, end_pfn, nid);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	free_tdx_memory();
> +	return ret;
> +}

> +bool tdx_cc_memory_compatible(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	struct tdx_memblock *tmb;
> +
> +	/* Empty list means TDX isn't enabled successfully */
> +	if (list_empty(&tdx_memlist))
> +		return true;
> +
> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		/*
> +		 * The new range is TDX memory if it is fully covered
> +		 * by any TDX memory block.
> +		 */
> +		if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
> +			return true;
> +	}
> +	return false;
> +}
