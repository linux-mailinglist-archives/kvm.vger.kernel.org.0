Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD027296D1
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 12:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241300AbjFIK1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 06:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbjFIK1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 06:27:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1F15FF0;
        Fri,  9 Jun 2023 03:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686305840; x=1717841840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SVayVWVqa392N8MIrWO6VixuwsosPLRpQlzN6/QEniU=;
  b=nFUn0Yu8nxpBTWpl7414R1IAffyo6ucZL3R2n/84JY4JzGMN7ytbnfhD
   AygSxLcIJxauSSLhGLqthWpucgCXCHYyIGuP9Yb1rsmtGCTJizec2z3rf
   PYL6tucD8ggPR0F1zkghwHCYbeZWfd/NnB9fwh6DGBA9rb/NPPglIvhXY
   VBxIH07nXVRpnqt8C9pPv+PksWYNsvi40KmZ90GxOramLvZ/n5ejonO9t
   Gc7GaxH/jaBegMlEaf5WU2MepPb/+Lf/+o5mHR8oOYGr5B1k+yMWwm7Gj
   YQ3qHp9kqOW8kTr2Neu6AcwILv8e/+qoR6GiLu1DJfaMNIMT2p4Q5P2lo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="421158875"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="421158875"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 03:14:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="704501041"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="704501041"
Received: from mbahx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.216])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 03:14:38 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 9938C104C0F; Fri,  9 Jun 2023 13:14:35 +0300 (+03)
Date:   Fri, 9 Jun 2023 13:14:35 +0300
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
Subject: Re: [PATCH v11 17/20] x86/kexec: Flush cache of TDX private memory
Message-ID: <20230609101435.xmz3kgydseddrty7@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <17bcbe3e154415ee7a4c77489809a3db0c5ddf3f.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17bcbe3e154415ee7a4c77489809a3db0c5ddf3f.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:30AM +1200, Kai Huang wrote:
> There are two problems in terms of using kexec() to boot to a new kernel
> when the old kernel has enabled TDX: 1) Part of the memory pages are
> still TDX private pages; 2) There might be dirty cachelines associated
> with TDX private pages.
> 
> The first problem doesn't matter on the platforms w/o the "partial write
> machine check" erratum.  KeyID 0 doesn't have integrity check.  If the
> new kernel wants to use any non-zero KeyID, it needs to convert the
> memory to that KeyID and such conversion would work from any KeyID.
> 
> However the old kernel needs to guarantee there's no dirty cacheline
> left behind before booting to the new kernel to avoid silent corruption
> from later cacheline writeback (Intel hardware doesn't guarantee cache
> coherency across different KeyIDs).
> 
> There are two things that the old kernel needs to do to achieve that:
> 
> 1) Stop accessing TDX private memory mappings:
>    a. Stop making TDX module SEAMCALLs (TDX global KeyID);
>    b. Stop TDX guests from running (per-guest TDX KeyID).
> 2) Flush any cachelines from previous TDX private KeyID writes.
> 
> For 2), use wbinvd() to flush cache in stop_this_cpu(), following SME
> support.  And in this way 1) happens for free as there's no TDX activity
> between wbinvd() and the native_halt().
> 
> Flushing cache in stop_this_cpu() only flushes cache on remote cpus.  On
> the cpu which does kexec(), unlike SME which does the cache flush in
> relocate_kernel(), do the cache flush right after stopping remote cpus
> in machine_shutdown().  This is because on the platforms with above
> erratum, the kernel needs to convert all TDX private pages back to
> normal before a fast warm reset reboot or booting to the new kernel in
> kexec().  Flushing cache in relocate_kernel() only covers the kexec()
> but not the fast warm reset reboot.
> 
> Theoretically, cache flush is only needed when the TDX module has been
> initialized.  However initializing the TDX module is done on demand at
> runtime, and it takes a mutex to read the module status.  Just check
> whether TDX is enabled by the BIOS instead to flush cache.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
