Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08206728C01
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbjFHXxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbjFHXxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:53:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95532726;
        Thu,  8 Jun 2023 16:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686268418; x=1717804418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7DV2YNv9v+YyLWdOtvU4aFLGouEH6kscRGQrlX+SwF4=;
  b=koLfhKlYsVvT77dOw06/kfOQ3JoMtj6w691RdpSG6swC1/aBsP+b6Fzl
   cDXx5GWxh8nXcJH2aWElQ6ly9Iceh7w+zUJCzpGggNifnYvX+yIu/CSeP
   /4XHqQlszx6K7tgK03+ZBwOebOtU3rSzGXKiA/mvUDt5O2ab8r9FUr0S3
   BJobOoAfE+sp40y1GqbbUvyoZPOQ3/W+GXHiJcQPbl/4im5QhLTUYG0KN
   0pPjtlpDzFRDNKNaRJ8Ue5Bwc/GCT60k6iuXWrXhR5zIuA3bXRradNQyR
   gFtbQFAMv1XIEP1MQj8dCpggN+CO4rXkJbqVK6wNBTxyVMABNS7srA+uC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="357471000"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="357471000"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:53:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="834402222"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="834402222"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:53:31 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 765B0104C0F; Fri,  9 Jun 2023 02:53:27 +0300 (+03)
Date:   Fri, 9 Jun 2023 02:53:27 +0300
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
Subject: Re: [PATCH v11 13/20] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Message-ID: <20230608235327.44jkdyw7pg46pyen@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <409448809f7c78191aa27d6d2970ba1384c2d464.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <409448809f7c78191aa27d6d2970ba1384c2d464.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:26AM +1200, Kai Huang wrote:
> As the last step of constructing TDMRs, populate reserved areas for all
> TDMRs.  For each TDMR, put all memory holes within this TDMR to the
> reserved areas.  And for all PAMTs which overlap with this TDMR, put
> all the overlapping parts to reserved areas too.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
