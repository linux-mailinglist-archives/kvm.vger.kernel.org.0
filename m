Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23E728C04
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbjFHXxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbjFHXxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:53:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCC12737;
        Thu,  8 Jun 2023 16:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686268430; x=1717804430;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iLSjboJdek0X7Qc1YWntBo1izZe2j1frjQXUOyLlElY=;
  b=HYZzsBHGV2KfOJXYAnLxmzl6UzxpcpAnDIGL8DR+onPPc2AtD2X9lOvZ
   ay48MN88vCYBBaBFVwVubhLNjv0ROfkFoOQHcTPPw2BuZdp+4YwWitHUz
   sYcU2XUK7DAGyKGQkEGdt0kVmSSDRnEibhGV3T61bi/uQQxRqTHGju4uc
   HSymS/Npdg8ZlX9nJJhkqcdIu+3uhRm3dWA4peM3asqrFmEI85bG3iNsl
   mPl8FSGPFlOkSk/GjxmglOF6p7mv/v/YF7EATtosXDmGUQqbFJWoQbxJ0
   4X4jbg6YvPc2I/3tu2R94bsseVcyTWvXDnrdMgicf0RLiS7HVbUMQzVfn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="357471052"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="357471052"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:53:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="834402245"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="834402245"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:53:44 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id B3B18104C0F; Fri,  9 Jun 2023 02:53:41 +0300 (+03)
Date:   Fri, 9 Jun 2023 02:53:41 +0300
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
Subject: Re: [PATCH v11 14/20] x86/virt/tdx: Configure TDX module with the
 TDMRs and global KeyID
Message-ID: <20230608235341.7zr2dazup7p7mjd7@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <4e6cd933edd2501147366df7a17e1087560a4320.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e6cd933edd2501147366df7a17e1087560a4320.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:27AM +1200, Kai Huang wrote:
> The TDX module uses a private KeyID as the "global KeyID" for mapping
> things like the PAMT and other TDX metadata.  This KeyID has already
> been reserved when detecting TDX during the kernel early boot.
> 
> After the list of "TD Memory Regions" (TDMRs) has been constructed to
> cover all TDX-usable memory regions, the next step is to pass them to
> the TDX module together with the global KeyID.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
