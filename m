Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D90F5F6615
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 14:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbiJFM3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 08:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiJFM3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 08:29:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104A8A02CB;
        Thu,  6 Oct 2022 05:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665059334; x=1696595334;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b3fj+AXXVhZdP+pSKHgDk/oArZKzYOpIAbb+AURPCqE=;
  b=cf+6krWXb5WRoLZjizDK5NcJgDHruFSYn0LRD6FRtI/+oUQ8oGqouDAk
   9sx+vkkKjy8Y2sWDbzGEEvvSQ3Egmv2nzv/XaTp6pEfuGMYDeGnUobJ/y
   4tkuTqw9BJ7aLQdwTlGIam9JDGavDsliLBPW/+PhzQg/VLe7S5WPuJ8s2
   4ck7i6jdmgAQKU9vK0u2NSJpMvam211YgFmQlW2adrkYGDbURIHUFliFG
   /t4MFI6gLDMR3TPEntQIDv5H2f9Mdt9XFI+umpjsoQpb9HyGMFQl/LtKc
   NrGVYKbtrQ6jtQvcnLHgQEY0OS/bD1O2fbr2YsxnGiF8YQ8R+q6IOO7bz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="290686709"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="290686709"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 05:28:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="750131358"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="750131358"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.132])
  by orsmga004.jf.intel.com with ESMTP; 06 Oct 2022 05:28:49 -0700
Date:   Thu, 6 Oct 2022 20:34:18 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v2] KVM: SVM: Replace kmap_atomic() with kmap_local_page()
Message-ID: <Yz7LSgq04//ovlkR@liuzhao-OptiPlex-7080>
References: <20220928092748.463631-1-zhao1.liu@linux.intel.com>
 <Yz4d2cXYi91UQT0Y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz4d2cXYi91UQT0Y@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022 at 12:14:17AM +0000, Sean Christopherson wrote:
> Date: Thu, 6 Oct 2022 00:14:17 +0000
> From: Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH v2] KVM: SVM: Replace kmap_atomic() with
>  kmap_local_page()
> 
> On Wed, Sep 28, 2022, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > The use of kmap_atomic() is being deprecated in favor of
> > kmap_local_page()[1].
> > 
> > The main difference between kmap_atomic() and kmap_local_page() is the
> > latter allows pagefaults and preemption.
> 
> Uber nit, I would phrase this as saying that local mappings don't disable
> page faults and preemption, which is slightly different than stating that they
> allow pagefaults/preemption.  E.g. if preemption is already disabled.
> 
> > There're 2 reasons we can use kmap_local_page() here:
> > 1. SEV is 64-bit only and kmap_locla_page() doesn't disable migration in
> 
> Nit, s/kmap_locla_page/kmap_local_page
> 
> For future reference, even better would be to use human language after "introducing"
> the functions, e.g.
> 
>   The main difference between atomic and local mappings is that local
>   mappings don't disable page faults or preemption.
> 
> Obviously that doesn't magically prevent typos, but it does make the changelog
> easier to read (IMO).
> 
> > this case, but here the function clflush_cache_range() uses CLFLUSHOPT
> > instruction to flush, and on x86 CLFLUSHOPT is not CPU-local and flushes
> > the page out of the entire cache hierarchy on all CPUs (APM volume 3,
> > chapter 3, CLFLUSHOPT). So there's no need to disable preemption to ensure
> > CPU-local.
> > 2. clflush_cache_range() doesn't need to disable pagefault and the mapping
> > is still valid even if sleeps. This is also true for sched out/in when
> > preempted.
> > 
> > In addition, though kmap_local_page() is a thin wrapper around
> > page_address() on 64-bit, kmap_local_page() should still be used here in
> > preference to page_address() since page_address() isn't suitable to be used
> > in a generic function (like sev_clflush_pages()) where the page passed in
> > is not easy to determine the source of allocation. Keeping the kmap* API in
> > place means it can be used for things other than highmem mappings[2].
> > 
> > Therefore, sev_clflush_pages() is a function that should use
> > kmap_local_page() in place of kmap_atomic().
> > 
> > Convert the calls of kmap_atomic() / kunmap_atomic() to kmap_local_page() /
> > kunmap_local().
> > 
> > [1]: https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com
> > [2]: https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/
> > 
> > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > Suggested-by: Ira Weiny <ira.weiny@intel.com>
> > Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > ---
> 
> No need to send a v3, the above are all the nittiest of nits.
Thanks Sean! I'll pay more attention to these next time.

Zhao
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
