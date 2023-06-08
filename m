Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B39A728B2E
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 00:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbjFHWlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 18:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjFHWlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 18:41:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E28A2D42;
        Thu,  8 Jun 2023 15:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686264064; x=1717800064;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HWH/BChFipfANutgTqAIw2nFszN1k9sN0DS13QIpLeQ=;
  b=akyy+RFim9+mtE5bfROSFyn6QK/j9BKBDmBRhRowT7dskFtoOeXsmuq9
   sA7ekxMXeiLarN4UyloXkI7O/jS9GSz98LdGHZbFT6Gc0GqL1VJuF9HzE
   mVg6Bk/6b2ZbegCKVAGTNL8M9S/Wt+dt6KUQOBfaHLuePxpC4XWYTJhwB
   5brOVs5XubiXoBkRvaBempLK8T9x7FbAq1fgrI1oihHqfBJmMumgl9ILO
   fiA/E2oTnkz3ctWB26gtwRsskzcCIsrOA21selV0fOby82/D5v4AWZzwV
   m3ZtpJZMk+cE6r043+26WFoVGxVjrcVUCtvhfsA0dWvXD5z3n0bceC9sF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="421040869"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="421040869"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 15:41:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="775264650"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="775264650"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 15:40:58 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 0BC00104C0F; Fri,  9 Jun 2023 01:40:56 +0300 (+03)
Date:   Fri, 9 Jun 2023 01:40:56 +0300
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
Subject: Re: [PATCH v11 09/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <20230608224056.2j524gnkrdjtirti@box>
References: <cover.1685887183.git.kai.huang@intel.com>
 <468533166590ff5ed11730350c4af8cdb0b99165.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468533166590ff5ed11730350c4af8cdb0b99165.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:22AM +1200, Kai Huang wrote:
> As a step of initializing the TDX module, the kernel needs to tell the
> TDX module which memory regions can be used by the TDX module as TDX
> guest memory.
> 
> TDX reports a list of "Convertible Memory Region" (CMR) to tell the
> kernel which memory is TDX compatible.  The kernel needs to build a list
> of memory regions (out of CMRs) as "TDX-usable" memory and pass them to
> the TDX module.  Once this is done, those "TDX-usable" memory regions
> are fixed during module's lifetime.
> 
> To keep things simple, assume that all TDX-protected memory will come
> from the page allocator.  Make sure all pages in the page allocator
> *are* TDX-usable memory.
> 
> As TDX-usable memory is a fixed configuration, take a snapshot of the
> memory configuration from memblocks at the time of module initialization
> (memblocks are modified on memory hotplug).  This snapshot is used to
> enable TDX support for *this* memory configuration only.  Use a memory
> hotplug notifier to ensure that no other RAM can be added outside of
> this configuration.
> 
> This approach requires all memblock memory regions at the time of module
> initialization to be TDX convertible memory to work, otherwise module
> initialization will fail in a later SEAMCALL when passing those regions
> to the module.  This approach works when all boot-time "system RAM" is
> TDX convertible memory, and no non-TDX-convertible memory is hot-added
> to the core-mm before module initialization.
> 
> For instance, on the first generation of TDX machines, both CXL memory
> and NVDIMM are not TDX convertible memory.  Using kmem driver to hot-add
> any CXL memory or NVDIMM to the core-mm before module initialization
> will result in failure to initialize the module.  The SEAMCALL error
> code will be available in the dmesg to help user to understand the
> failure.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
