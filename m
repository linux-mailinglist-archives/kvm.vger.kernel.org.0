Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4566509308
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379234AbiDTWmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382966AbiDTWm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:42:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FB443384;
        Wed, 20 Apr 2022 15:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650494358; x=1682030358;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=90feSWrZ1goRaiK9b3nAN11GuylFb6fRBN0S0ksIIFg=;
  b=Sq+H9M7fdUly7+ZEw9pMk7A56zmfStFIKAxyfsPnFa4YMNI8TwBI1PFW
   IpUu9jsmjrvSkVi4FtoxPsiFpeWOX/QhCviq3q1jaCLM2phfoxXoAmpFJ
   0N7NVjQGrTlAtU84tFiGMeEP7fm4/SuCHJpXg5T/FWDYsbuZV7g/lzXKS
   rD9m5l7CMw9WKXxNGKcVSxhVhfZCSEktyQ8Dj6UERccN1ykZbMagokbjq
   1vQOUAlbr2Smvc/b43u1LrN5xcFXO7rCui68NqWFvh6/8R6MoUdFGitTg
   bbkvdmXKF8XbWIIa7I9nUBz7aRI5F1IL/P0kHJa1aGASqgPWyeU2gn1AM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289279971"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="289279971"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:39:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="555427233"
Received: from ssharm9-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.30.148])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:39:13 -0700
Message-ID: <c19af3aeb431057922b3dc06be457435f0293f2e.camel@intel.com>
Subject: Re: [PATCH v3 11/21] x86/virt/tdx: Choose to use all system RAM as
 TDX memory
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 21 Apr 2022 10:39:10 +1200
In-Reply-To: <20220420205530.GB2789321@ls.amr.corp.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <dee8fb1cc2ab79cf80d4718405069715b0d51235.1649219184.git.kai.huang@intel.com>
         <20220420205530.GB2789321@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-20 at 13:55 -0700, Isaku Yamahata wrote:
> > +/* Check whether first range is the subrange of the second */
> > +static bool is_subrange(u64 r1_start, u64 r1_end, u64 r2_start, u64 r2_end)
> > +{
> > +	return (r1_start >= r2_start && r1_end <= r2_end) ? true : false;
> 
> nitpick:
> Just "return (r1_start >= r2_start && r1_end <= r2_end)"
> Maybe this is a matter of preference, though.

Will use yours.  Thanks!


-- 
Thanks,
-Kai


