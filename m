Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371F07453D1
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 04:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjGCCVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 22:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjGCCVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 22:21:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29481BB;
        Sun,  2 Jul 2023 19:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688350854; x=1719886854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PYorJh5Lg7ytNVcruB1M1czupjrGpI9bzxcEReugLww=;
  b=amaHtCpYXdA9nZ8908BI+wbWd56uBe6bSmv0ImYa33Vl5VhqPcTJUrVJ
   Zqy3WMF+gWqYjxXfa/GXB1JzHoPNS6+eQ66x0CMv9V0Z/KREgHaRscOHU
   F34B0Tn5FCjce9nqXi1DBowLC1gZxGRAsNMX/aQZ3bvD8S68UuoptcVZl
   3f0YKIuyX8AnWUvyazuzia8epu8lDyQ8uF8n8UhPWN2gWItuWq85q8es3
   kpFnrhH87j9f9dis02Qh+LVpYKMghAH7dCbLHu9WCvzRmCRFxo6Gu/X6w
   5XAT62/HWz4K79E8UC8fviCOHpnB/rN6Ide948iT33uDWpHj5/mk6O+Mg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="352595347"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="352595347"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2023 19:20:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="783728489"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="783728489"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jul 2023 19:20:49 -0700
Date:   Mon, 3 Jul 2023 10:20:49 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>,
        shina@ecc.u-tokyo.ac.jp, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuan.yao@intel.com
Subject: Re: [PATCH] KVM: nVMX: Prevent vmlaunch with EPTP pointing outside
 assigned memory area
Message-ID: <20230703022049.nixdqrq63zzbmrdm@yy-desk-7060>
References: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
 <ZJxTTZzZnfbyMVIH@google.com>
 <ZJ0w5pKk/41Zv26i@yzhao56-desk.sh.intel.com>
 <ZJ3FyLUYrlr6+HLw@google.com>
 <ZJ3p5wBwyQZ+aQOV@google.com>
 <20230630050157.kurgzdcpjngs6w4k@yy-desk-7060>
 <ZJ72omPGZcdjjWbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ72omPGZcdjjWbo@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 08:37:06AM -0700, Sean Christopherson wrote:
> On Fri, Jun 30, 2023, Yuan Yao wrote:
> > On Thu, Jun 29, 2023 at 01:30:31PM -0700, Sean Christopherson wrote:
> > > @@ -3834,8 +3822,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> > >  			if (!(pdptrs[i] & PT_PRESENT_MASK))
> > >  				continue;
> > >
> > > -			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
> > > -				return 1;
> > > +			if (kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT))
> > > +				pdptrs[i] = 0;
> >
> > Hi Sean,
> >
> > Should this be "!kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT)" and
>
> Yep, typo that inverted the check.  Thanks for saving me some debug time!
>
> > turn the pae_root[i] to dummy root yet ?
>
> No, zeroing the PDPTR is sufficient.  Unlike CR3, which is always "present", PDPTRs
> have a present bit and so KVM can communicate to hardware that the entry isn't
> valid simply by clearing the PDPTPR.

Got it, same as how KVM deal with other middle level entries,
thanks for the explanation!
