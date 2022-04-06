Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54B54F6E8B
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiDFXca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiDFXc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:32:27 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB21C337B;
        Wed,  6 Apr 2022 16:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649287827; x=1680823827;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dN6tJX4kfZRcYxEG7jPgJawAk+mr6Z5aozdvN/WcmgM=;
  b=ZhAAWgana9gbl3SgOhyB0sbqlLdJyg2lISOgdbhXtGXI/o0iwgUsMunF
   XSacqIF8FQr7n9HTX9G/Z94GHhnnU491FENnE5LwGfJiaxjhcYoo1lAJG
   UGWXwbBhhuliqdfAb+P9VAnH5RvxCT4m8/QKiRv805aCX9NFb+qxkdonU
   pHsoTLm+L1NM8/2dZq4FEZ0tJfsl7BlH9w6Ctq3FScfL25T5SWs0O1kn6
   6mO9BqtEaiCZR2jf4QYusLohGeBa8Dx2ZXYFJ7mk+yyHDO//OwrdJltQk
   vmumHClQYnVr9zY80ve2Q+pVg2Ue1gqtU1O16VDx0dHr+wyO8Fx8qIT+K
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="321878694"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="321878694"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 16:30:25 -0700
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="524689613"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 16:30:22 -0700
Message-ID: <3ac99ee504d6230f747a0f0c6ab91e6acd375536.camel@intel.com>
Subject: Re: [RFC PATCH v5 045/104] KVM: x86/tdp_mmu: make REMOVED_SPTE
 include shadow_initial value
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 11:30:20 +1200
In-Reply-To: <6614d2a2bc34441ed598830392b425fdf8e5ca52.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <6614d2a2bc34441ed598830392b425fdf8e5ca52.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDP MMU uses REMOVED_SPTE = 0x5a0ULL as special constant to indicate the
> intermediate value to indicate one thread is operating on it and the value
> should be semi-arbitrary value.  For TDX (more correctly to use #VE), the
> value should include suppress #VE value which is shadow_init_value.
> 
> Define SHADOW_REMOVED_SPTE as shadow_init_value | REMOVED_SPTE, and replace
> REMOVED_SPTE with SHADOW_REMOVED_SPTE to use suppress #VE bit properly for
> TDX.

Like we discussed, this patch should be merged with patch "KVM: x86/mmu: Allow
non-zero init value for shadow PTE".


-- 
Thanks,
-Kai


