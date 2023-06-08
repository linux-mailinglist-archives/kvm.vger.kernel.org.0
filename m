Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294EC728B7C
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjFHXCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjFHXCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:02:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDB21BEB;
        Thu,  8 Jun 2023 16:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686265340; x=1717801340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pTxSE3g/pkUW9O1/rWpP1ww2HeBy2R2YFKbn6r4RIdo=;
  b=n+ZmULfIufgFM84JxcGwHfeFUdeFx2vdWYvc8vLKL9A5aM9cjLC/p7cL
   50be1Os5AEOw/mVYNQnmToSuq+5yz4JeawSMsNxTsB0Pu5mwOC950ryA5
   +6A4slnimlLqJocT++kbwnCaSNUuFgxyctHTEgqLaHxLr+ttToaLT2Mx+
   QH2Nlw3+WDZMy/JtJbbZ4/YZO6VDp4APg6KhQyehN6YGrJ0zv2EyUI0A7
   pLzmxFeXqc6gj9AOzdmjmsVYSRbjbFav1GyXa40NTWpsL/+VNtiiZiKqM
   tfdybYOFNpqavlyMdcxrl1s0j8XvApI93JggvbRnOBoMCKuBUuTTW0eER
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="359941373"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="359941373"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:02:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="713282835"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="713282835"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:02:14 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id CEE67104C0F; Fri,  9 Jun 2023 02:02:11 +0300 (+03)
Date:   Fri, 9 Jun 2023 02:02:11 +0300
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
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Message-ID: <20230608230211.byot2fbo7skkfqxe@box>
References: <cover.1685887183.git.kai.huang@intel.com>
 <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:24AM +1200, Kai Huang wrote:
> +#define TDMR_ALIGNMENT		BIT_ULL(30)

Nit: SZ_1G can be a little bit more readable here.

Anyway:

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>


-- 
  Kiryl Shutsemau / Kirill A. Shutemov
