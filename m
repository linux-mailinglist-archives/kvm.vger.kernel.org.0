Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214E072967A
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 12:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbjFIKNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 06:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237994AbjFIKNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 06:13:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503031FEC;
        Fri,  9 Jun 2023 03:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686304933; x=1717840933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=avToKfNhX/fgiI/oQOGFUtfsY4aVoDQH31ifweHQMe4=;
  b=RR8fXJQdrfuI0FnBkMqmag3YOJmJuIKOax5/5cKRdvRt802FowVbBgo9
   LIbPpYg2BOUmjNFuRLNswx0P9ydDBFDu480gast2n9+DhQ92P8afnt+xn
   FNicYruuBQNduYUDarZnHQeVuwBl+JSXz7X+ePZwi1Gv5PFbxUcD3MlK5
   gH4m0M9Si2m8/CTH9WJMgAdUO/5Su2cp6QeztWnWAXP9ADpr811dauTXB
   bPpOszZabsNHyWw1E9/XwVDBgYrJlzldN1zmuCGKsA1JgAJfqy8PG9WXW
   7h2P5jDn8cbkWLeo43e6kQiuBauSxCU1CzHiLSPPuI8D66JmMOasmC1mJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="423444418"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="423444418"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 03:02:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="687689092"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="687689092"
Received: from mbahx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.216])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 03:02:07 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 092F2104C0F; Fri,  9 Jun 2023 13:02:04 +0300 (+03)
Date:   Fri, 9 Jun 2023 13:02:03 +0300
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
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230609100203.uabyy5clg2l4wegi@box>
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -21,6 +23,76 @@
>   */
>  #define TDH_SYS_INIT		33
>  #define TDH_SYS_LP_INIT		35
> +#define TDH_SYS_INFO		32

Could you keep these defines ordered? Here and all following patches.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
