Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573A6729692
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 12:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjFIKPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 06:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238770AbjFIKOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 06:14:25 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8299F46B7;
        Fri,  9 Jun 2023 03:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686305051; x=1717841051;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1RKRKUCNJ3tof7WGhe5Q8dWpADSieMLQT+y0st2q+DQ=;
  b=SwhsDyYxQjBBBC0AVtpbkkTwNTiCmnvCywD4e4hJ8TBNGNWB3zhuG5of
   si42nDks/XSyw7NANZRO6BSed4Jw5a+i/pGh3GnZcdaZTxH+bDcPlMPc6
   PDOsgEw7g7RqC/rls0kmrTyeXeLftVi8bvI6QS9N+xQj+fKt2UEYwDseG
   LkwoaGrSvvrB29lbtLZUmF4puWEANGz7lm4lfTrgd4we8ol+JNJ5P2DNb
   UGrOQ8/4SjUOi9SAN7fhRHwHpadSMtoW1XVxyX9F7qDACL1yuIoIboS+K
   L8a+J0/6xAoxkI7Qbxw5PuAffvYlkgPph2i39G9xuDrujo9/6Yfg6jcA0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385922158"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="385922158"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 03:04:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="823013867"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="823013867"
Received: from mbahx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.216])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 03:03:54 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 30D58104C0F; Fri,  9 Jun 2023 13:03:52 +0300 (+03)
Date:   Fri, 9 Jun 2023 13:03:52 +0300
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
Subject: Re: [PATCH v11 16/20] x86/virt/tdx: Initialize all TDMRs
Message-ID: <20230609100352.6gnn5foahnppibmm@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <7bd7d0c6196deb58b54d6e629603775844b1307d.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd7d0c6196deb58b54d6e629603775844b1307d.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:29AM +1200, Kai Huang wrote:
> After the global KeyID has been configured on all packages, initialize
> all TDMRs to make all TDX-usable memory regions that are passed to the
> TDX module become usable.
> 
> This is the last step of initializing the TDX module.
> 
> Initializing TDMRs can be time consuming on large memory systems as it
> involves initializing all metadata entries for all pages that can be
> used by TDX guests.  Initializing different TDMRs can be parallelized.
> For now to keep it simple, just initialize all TDMRs one by one.  It can
> be enhanced in the future.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
