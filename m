Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B176558D23
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 04:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiFXCMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 22:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiFXCMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 22:12:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E6250B14;
        Thu, 23 Jun 2022 19:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656036744; x=1687572744;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ZHx+jG00ZO8ZCYzEWOrH0StMRMC4BjW65hod6Xx3uk=;
  b=e1qwFutLUE4pDSWo1WFxd7nndMy3znsTF60cOXA+qfMKVNxv9cem2k4R
   cIju9k/sy4wQt0zwHDAh0bG4ifIsfwvdDqwj4Jf/7xPjPmkHEVGj2wlwk
   TvudVzYC0aVth+JKEO0iKU9/EYbmYhXkRo8OT0kRKiFEzfSGGcztnN0kH
   JPIKDxvYRAid1rINHW59TxDmpYE8liEH4aMwiF48A29trqS9YiTvgTb4o
   YRrIMsbpPaHYOhtf+FQOcueKai/xstfmsANEyn8ry43ChcQsNT+9EnZDG
   VIM1lVl+HuIhilj29jkdm8SXSPrC0qIol1cLkma2JVxcjygjj6a1yOVrO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="263934549"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="263934549"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 19:12:24 -0700
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="645051512"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 19:12:20 -0700
Date:   Fri, 24 Jun 2022 10:12:05 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v5 05/22] x86/virt/tdx: Prevent hot-add driver managed
 memory
Message-ID: <20220624021200.GB15566@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
 <173e1f9b2348f29e5f7d939855b8dd98625bcb35.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173e1f9b2348f29e5f7d939855b8dd98625bcb35.1655894131.git.kai.huang@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 11:16:19PM +1200, Kai Huang wrote:
>@@ -55,6 +55,7 @@
> #include <asm/uv/uv.h>
> #include <asm/setup.h>
> #include <asm/ftrace.h>
>+#include <asm/tdx.h>
> 
> #include "mm_internal.h"
> 
>@@ -972,6 +973,26 @@ int arch_add_memory(int nid, u64 start, u64 size,
> 	return add_pages(nid, start_pfn, nr_pages, params);
> }
> 
>+int arch_memory_add_precheck(int nid, u64 start, u64 size, mhp_t mhp_flags)
>+{
>+	if (!platform_tdx_enabled())
>+		return 0;

add a new cc attribute (if existing ones don't fit) for TDX host platform and
check the attribute here. So that the code here can be reused by other cc
platforms if they have the same requirement.
