Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7321B64E618
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 04:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiLPDDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 22:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiLPDDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 22:03:33 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79735EDE1
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 19:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671159812; x=1702695812;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p1PyXhAeFC/b205GMTflzdNbyDd9hinQs009fNK6On4=;
  b=PKnfjAbT8bn5vfJJEeG16IFMLfBIKst3KOBoxkoOSAYkhUI6z/a98xSA
   4Ff9ByxsHaP1NpCvxaBHnt4LBzt0oq4/6G5IhkCwzqy37aKNE4jgI/XIW
   5EwyPmW7h3Da84vB+nXEXXkdg/kPjOM4sivQNE+hapdjoPzbC5Yj2ZusJ
   gUavhPxbQHSQ/mFjDjkmT6IVirlCqGx82SIszZcelReNmu0WC90DB8lg9
   6+6LachjoTg8GNaUODXwKCSrqFbbNxKZX0acSS8+xymxtnOwm1CX/2+lr
   LRAPfoDHqZFarefiU9IQ6ft9JX4uXvFs8xOZHH5NllEfyhU+g+IqsuY/j
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="381089775"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="381089775"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 19:03:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="756594057"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="756594057"
Received: from xintongc-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.168.175])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 19:03:28 -0800
Date:   Fri, 16 Dec 2022 11:03:25 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: Re: [PATCH v3] KVM: MMU: Make the definition of 'INVALID_GPA' common.
Message-ID: <20221216030325.7ebp6on5ch7p343y@linux.intel.com>
References: <20221215095736.1202008-1-yu.c.zhang@linux.intel.com>
 <Y5tjdeMk2jJCX8Co@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5tjdeMk2jJCX8Co@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 06:12:05PM +0000, Sean Christopherson wrote:
> Nit, terminating punction (the period) isn't usually included in the shortlog.
> 
> On Thu, Dec 15, 2022, Yu Zhang wrote:
> > KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in
> > kvm_types.h, and it is used by ARM and X86 xen code. We do
> > not need a specific definition of 'INVALID_GPA' for X86.
> > 
> > Instead of using the common 'GPA_INVALID' for X86, replace
> > the definition of 'GPA_INVALID' with 'INVALID_GPA', and
> > change the users of 'GPA_INVALID', so that the diff can be
> > smaller. Also because the name 'INVALID_GPA' tells the user
> > we are using an invalid GPA, while the name 'GPA_INVALID'
> > is emphasizing the GPA is an invalid one.
> > 
> > Also, add definition of 'INVALID_GFN' because it is more
> > proper than 'INVALID_GPA' for GFN variables.
> 
> This should be a separate commit.  Yes, it's trivial and a nop, but there's no
> reason to surprise readers/blamers that assumed the shortlog tells the whole
> story.  E.g. add and use INVALID_GFN where appropriate in patch 1, then switch
> to INVALID_GPA in patch 2.  Then you can also add a "Suggested-by: David ..." for
> patch 1.

Good point! Thanks! :)

B.R.
Yu
