Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48ADC76299F
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 05:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjGZD6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 23:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjGZD6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 23:58:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5461E270D;
        Tue, 25 Jul 2023 20:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690343860; x=1721879860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+B/VHnIVb0f3N6lyH6cvmBP+ZFp05AmQVmmVnXRka3o=;
  b=QX6nJ4BufM4yHRerVWJ2UsZoaiGl52ZpRj1aQFRhupOy1T9b0Nv2qPJE
   F0eJ0AsNNlJKHLnNyRPY+NxlDsWpZ2cyK5Kh/2bxF7rQ65TXB9d1volY9
   Ppb6mCtq9ggXl+i23zu9++aEQN5ufYWSeFf1AuDHHWJfn6s6C93P4w0OC
   lMXwdUJkCuWvoNBVI0avBm9IKIe+d01713CvmLrljmyZj2HNUpVvt0Nai
   I2raEin7Ok5CDgJUxQCWXD7PpciebwjIJy6I0yOHWNS/jsRqfOcQszyp3
   bCHrrIPvLDCLcVK+3BZUKdZY+BhiwIKKmijSV/wB4tuApdGn90O+C4cwP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="431709468"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="431709468"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 20:55:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972934968"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972934968"
Received: from pdeng6-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.174.155])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 20:55:14 -0700
Date:   Wed, 26 Jul 2023 11:55:11 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Subject: Re: [PATCH 3/5] KVM: x86/mmu: Harden TDP MMU iteration against root
 w/o shadow page
Message-ID: <20230726035511.denul3w4cxl4runk@linux.intel.com>
References: <20230722012350.2371049-1-seanjc@google.com>
 <20230722012350.2371049-4-seanjc@google.com>
 <20230725103945.wfa5zdupen3oo6xl@linux.intel.com>
 <ZL/wsIVpcpKs/9Nq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZL/wsIVpcpKs/9Nq@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 08:56:32AM -0700, Sean Christopherson wrote:
> On Tue, Jul 25, 2023, Yu Zhang wrote:
> > On Fri, Jul 21, 2023 at 06:23:48PM -0700, Sean Christopherson wrote:
> > > Explicitly check that tdp_iter_start() is handed a valid shadow page
> > > to harden KVM against bugs where
> > 
> > Sorry, where? 
> 
> Gah, I must have seen something shiny when writing the changelog.
> 
> > It's not about guest using an invisible GFN, it's about a KVM bug, right?
> 
> Yes, the intent is to guard against a KVM bug, e.g. if KVM managed to get into
> the TDP MMU with an invalid root, or a root belonging to a shadow MMU.  I'll fix
> the changelog in v2.
> 
> > > Opportunistically stop the TDP MMU iteration instead of continuing on
> > > with garbage if the incoming root is bogus.  Attempting to walk a garbage
> > > root is more likely to caused major problems than doing nothing.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/tdp_iter.c | 11 ++++++-----
> > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> > > index d2eb0d4f8710..bd30ebfb2f2c 100644
> > > --- a/arch/x86/kvm/mmu/tdp_iter.c
> > > +++ b/arch/x86/kvm/mmu/tdp_iter.c
> > > @@ -39,13 +39,14 @@ void tdp_iter_restart(struct tdp_iter *iter)
> > >  void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
> > >  		    int min_level, gfn_t next_last_level_gfn)
> > >  {
> > > -	int root_level = root->role.level;
> > > -
> > > -	WARN_ON(root_level < 1);
> > > -	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
> > > +	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
> > > +			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
> > > +		iter->valid = false;
> > > +		return;
> > > +	}
> > >  
> > 
> > I saw many usages of WARN_ON_ONCE() and WARN_ON() in KVM. And just wonder,
> > is there any criteria for KVM when to use which?
> 
> Heh, already a step ahead of you :-)
> 
> https://lore.kernel.org/all/20230721230006.2337941-5-seanjc@google.com

Haha! That patch lies just above this series, and the explanation is very
convincing. :) Thanks! 

B.R.
Yu
