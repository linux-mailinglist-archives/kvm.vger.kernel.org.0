Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DFE674B29
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 05:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjATEra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 23:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjATErJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 23:47:09 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09114C9243
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 20:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189688; x=1705725688;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4gIsbKZ3JYUD6t3R692OHxya9r29qeaqfRmV5CFAJeQ=;
  b=BuPi02J5LvDmR23HnWb4ErPZktunGuvu0GJ8pL7C2Pry7QlcZv4B15Lk
   xgsq5pSADeTBuMpEHqPQxsuNvB8qDu47fmTCAPaD3aalbZ00fN2E7jcie
   uJTgokudoc9zLSTQFFfGQaXt5QDKyqGF0UQJVlPcIH1+g31aElhfzdRis
   GQvrowBGlsNf6ztt0n0CwzG7v2/hrrkO2p0ojq+QTjET6iEWDunpSf2Tk
   YqEuXXc4CHKP65T+xxCZDHy1OfJV6HrazuiSA/Ymj9zgAFuMNf+neqBqv
   MmEyVsUAavd8QcQjXEoQAiwT4HOLZ36f9cxLqj/XpkdrhwrjFNpwwqA6A
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387564499"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="387564499"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 23:26:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="783960101"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="783960101"
Received: from yihuaxu1-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.171.116])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 23:25:58 -0800
Date:   Thu, 19 Jan 2023 15:25:56 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, paul@xen.org
Subject: Re: [PATCH v5] KVM: MMU: Make the definition of 'INVALID_GPA' common
Message-ID: <20230119072556.ebnddkr54vqbzmjk@linux.intel.com>
References: <20230105130127.866171-1-yu.c.zhang@linux.intel.com>
 <Y8iUkMbNM8jWE4RR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8iUkMbNM8jWE4RR@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 12:53:36AM +0000, Sean Christopherson wrote:
> On Thu, Jan 05, 2023, Yu Zhang wrote:
> > KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in kvm_types.h,
> > and it is used by ARM code. We do not need another definition of
> > 'INVALID_GPA' for X86 specifically.
> > 
> > Instead of using the common 'GPA_INVALID' for X86, replace it with
> > 'INVALID_GPA', and change the users of 'GPA_INVALID' so that the diff
> > can be smaller. Also because the name 'INVALID_GPA' tells the user we
> > are using an invalid GPA, while the name 'GPA_INVALID' is emphasizing
> > the GPA is an invalid one.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > Reviewed-by: Paul Durrant <paul@xen.org>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > ---
> 
> Marc and/or Oliver,
> 
> Do you want to grab this since most of the changes are to arm64?  I'll happily
> take it through x86, but generating a conflict in arm64 seems infinitely more likely.
> 
Thank you, Sean! 

This patch was based on KVM's next branch - fc471e831016c ("Merge branch 'kvm-late-6.1'
into HEAD"). Tested by cross-building arm64. 

Do you know if KVM arm use a seperate branch(or repo)? Thanks!

B.R.
Yu

