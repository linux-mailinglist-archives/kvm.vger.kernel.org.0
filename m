Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405F3729B57
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240122AbjFINSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 09:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjFINSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 09:18:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263DBA3;
        Fri,  9 Jun 2023 06:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686316684; x=1717852684;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8UyLEibmXUqgyndyzdA99iRsyIpRFb+3EGRyOqrRvVk=;
  b=Uc+/Oe1GCQnw/2KeIfC97kekGce7fN7vhFydgGKkaExiVb/LRIl+RLFr
   VbDxG+/APYz/IiuioR++3ILVSbMabdZEVUVtBoPrzPJUNzJLugqCswNwW
   BkKjU09FHiidCmSB9k7yhFGSmHCmM1rysyKSI++eYmiL4G9NpUvmZOu64
   10sYxEv6ORyO9q7E4Z2Bfsz7m1UO4XYAYjPTMm/ziz7NHGZOqb076x9qT
   LlMo647KCYPG6rOOk0hJpnlpnb1EcovOxciZACvKlokCge3kdXxi1fhm/
   Ly0C3+6rzzzuQPz678WNJZqMe1RPHeRaCuLeP1wkXAEWnGVK1PQCWhC4R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="421186418"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="421186418"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 06:18:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="743484861"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="743484861"
Received: from mbahx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.216])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 06:17:57 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id A7B32109B7B; Fri,  9 Jun 2023 16:17:54 +0300 (+03)
Date:   Fri, 9 Jun 2023 16:17:54 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <20230609131754.dhii5ctfwtzx667o@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:32AM +1200, Kai Huang wrote:
> The first few generations of TDX hardware have an erratum.  Triggering
> it in Linux requires some kind of kernel bug involving relatively exotic
> memory writes to TDX private memory and will manifest via
> spurious-looking machine checks when reading the affected memory.
> 
> == Background ==
> 
> Virtually all kernel memory accesses operations happen in full
> cachelines.  In practice, writing a "byte" of memory usually reads a 64
> byte cacheline of memory, modifies it, then writes the whole line back.
> Those operations do not trigger this problem.
> 
> This problem is triggered by "partial" writes where a write transaction
> of less than cacheline lands at the memory controller.  The CPU does
> these via non-temporal write instructions (like MOVNTI), or through
> UC/WC memory mappings.  The issue can also be triggered away from the
> CPU by devices doing partial writes via DMA.
> 
> == Problem ==
> 
> A partial write to a TDX private memory cacheline will silently "poison"
> the line.  Subsequent reads will consume the poison and generate a
> machine check.  According to the TDX hardware spec, neither of these
> things should have happened.
> 
> To add insult to injury, the Linux machine code will present these as a
> literal "Hardware error" when they were, in fact, a software-triggered
> issue.
> 
> == Solution ==
> 
> In the end, this issue is hard to trigger.  Rather than do something
> rash (and incomplete) like unmap TDX private memory from the direct map,
> improve the machine check handler.
> 
> Currently, the #MC handler doesn't distinguish whether the memory is
> TDX private memory or not but just dump, for instance, below message:
> 
>  [...] mce: [Hardware Error]: CPU 147: Machine Check Exception: f Bank 1: bd80000000100134
>  [...] mce: [Hardware Error]: RIP 10:<ffffffffadb69870> {__tlb_remove_page_size+0x10/0xa0}
>  	...
>  [...] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>  [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>  [...] Kernel panic - not syncing: Fatal local machine check
> 
> Which says "Hardware Error" and "Data load in unrecoverable area of
> kernel".
> 
> Ideally, it's better for the log to say "software bug around TDX private
> memory" instead of "Hardware Error".  But in reality the real hardware
> memory error can happen, and sadly such software-triggered #MC cannot be
> distinguished from the real hardware error.  Also, the error message is
> used by userspace tool 'mcelog' to parse, so changing the output may
> break userspace.
> 
> So keep the "Hardware Error".  The "Data load in unrecoverable area of
> kernel" is also helpful, so keep it too.
> 
> Instead of modifying above error log, improve the error log by printing
> additional TDX related message to make the log like:
> 
>   ...
>  [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>  [...] mce: [Hardware Error]: Machine Check: Memory error from TDX private memory. May be result of CPU erratum.

The message mentions one part of issue -- CPU erratum -- but misses the
other required part -- kernel bug that makes kernel access the memory it
not suppose to.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
