Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AEB5895E5
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 04:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbiHDCPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 22:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiHDCPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 22:15:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056A25F9A8
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 19:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659579298; x=1691115298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K39T1sRdxj08Qghma5YTykYkO5vNMLzecy63QnA545Y=;
  b=QpLMZDaNb/a9VBk4jmO5MFH1GH7U9wTjqXivEXal7VfoDSVMWa3fvBWP
   WS8v4Dc7f9qXzLOOgTtZoa98Ra0IA/GI5HY/4Kr/JS3cPXNKXsMZe51Du
   72TMxqtYx6j+ViC/2wRvma+4vs6ncwFX4hqpGMz1T2HUJS++11uYFDBT4
   kfgFy2b9YPAxTSFRcVzbqZ4sR/LDdiwtru8O/4CkHzugqGVexRe5ukevf
   LyUl0iikX4+FhI2nX2NlF7pYYIrZoZHrKoagqVK+qdAefahJD8QCo0qex
   5FvZXdq10nUHSDCEcculZew/T5EIzpUmwlu+5unjlj2HHZwPf0eVjFUMv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="315691922"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="315691922"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 19:14:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="662332968"
Received: from yxing1-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.169.130])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 19:14:56 -0700
Date:   Thu, 4 Aug 2022 10:14:53 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] X86: Set up EPT before running
 vmx_pf_exception_test
Message-ID: <20220804021453.j5nptlscrso47p5w@linux.intel.com>
References: <20220715113334.52491-1-yu.c.zhang@linux.intel.com>
 <YumMC1hAVpTWLmap@google.com>
 <20220803015742.v2kzo5edaqdmi456@linux.intel.com>
 <YuqFS9nNVfMl6NnI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuqFS9nNVfMl6NnI@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 02:25:15PM +0000, Sean Christopherson wrote:
> On Wed, Aug 03, 2022, Yu Zhang wrote:
> > On Tue, Aug 02, 2022 at 08:41:47PM +0000, Sean Christopherson wrote:
> > > On Fri, Jul 15, 2022, Yu Zhang wrote:
> > > > Although currently vmx_pf_exception_test can succeed, its
> > > > success is actually because we are using identical mappings
> > > > in the page tables and EB.PF is not set by L1. In practice,
> > > > the #PFs shall be expected by L1, if it is using shadowing
> > > > for L2.
> > > 
> > > I'm a bit lost.  Is there an actual failure somewhere?  AFAICT, this passes when
> > > run as L1 or L2, with or without EPT enabled.
> > 
> > Thanks for your reply, Sean.
> > 
> > There's no failure. But IMHO, there should have been(for the
> > vmx_pf_exception_test, not the access test) -  L1 shall expect
> > #PF induced VM exits, when it is using shadow for L2.
> 
> Note, I'm assuming L1 == KVM-Unit-Tests, let me know if we're not using the same
> terminology.
> 
> Not using EPT / TDP doesn't strictly imply page table shadowing.  E.g. if a hypervisor
> provides a paravirt interface to install mappings, and the contract is that the VM
> must use the paravirt API, then the hypervisor doesn't need to intercept page faults
> because there are effectively no guest PTEs to write-protect / shadow.  
> 
> That's more or less what's happening here, L1 and L2 are collaborating to create
> page tables for L2, and so L1 doesn't need to intercept #PF.

Oh... So it is intentionally designed to let L1 and L2 use the same address space.
Then we can just drop this patch. Thanks a lot for the explanation!

B.R.
Yu
