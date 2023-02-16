Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26729698C6F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 06:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBPFyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 00:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBPFyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 00:54:09 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C09B2F79C
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 21:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676526848; x=1708062848;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nt6y+JE79KiN03D7E49Rf69dosfVOwKAthVWbmewPSU=;
  b=AQ/xjJ4SbHqHYW71Ra/3sXZvRUP+sbLsdCTvayHPri/CbIagsEUw1cFs
   2YPME7YwT8NkP657H2xF49SCG69YUhomA6KuUI7h0+cstBnD77yYAH13G
   cTAhx3GUw3W5aJanY8QA6OayAF5yonM5DpOzkh80LhhE+weFbRPG8Mtge
   g2WpPim3R+FYw0pFdwFzCx2ewX64mdCden2XIqsBpTIz70vzAKvjhYjRd
   yy+j0MYWohst3zRt0I3O8G5+lCNRnZFqzkZ4RLgOCLIUklEoSn41tqcyZ
   LN/FFjEAV0+ELfhZdZFRCudJty4KeuLjCZ6EER12PnQckHE/ftvSvCQDS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359060941"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="359060941"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 21:54:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="663337894"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="663337894"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 15 Feb 2023 21:54:05 -0800
Message-ID: <8e0596cec817d820f32fc85f099cd6cf5de52367.camel@linux.intel.com>
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Thu, 16 Feb 2023 13:54:04 +0800
In-Reply-To: <264acaa2-ba77-685b-04c3-35e4c7db52f0@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-2-robert.hu@linux.intel.com>
         <814481b6-c316-22bd-2193-6aa700db47b5@linux.intel.com>
         <90d0f1ffec67e015e3f0f1ce9d8d719634469a82.camel@linux.intel.com>
         <1e8df25a-4c25-6738-dd92-a58c28282eb0@linux.intel.com>
         <d1d819b00a6dda7a58b25f7b0692ad53473497d8.camel@linux.intel.com>
         <264acaa2-ba77-685b-04c3-35e4c7db52f0@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-16 at 13:31 +0800, Binbin Wu wrote:
> On 2/14/2023 8:24 PM, Robert Hoo wrote:
> > On Tue, 2023-02-14 at 17:00 +0800, Binbin Wu wrote:
> > > According to the code of set_cr4_guest_host_mask,
> > > vcpu->arch.cr4_guest_owned_bits is a subset of
> > > KVM_POSSIBLE_CR4_GUEST_BITS,
> > > and X86_CR4_LAM_SUP is not included in
> > > KVM_POSSIBLE_CR4_GUEST_BITS.
> > > No matter change CR4_RESERVED_BITS or not, X86_CR4_LAM_SUP will
> > > always be set in CR4_GUEST_HOST_MASK.
> > > 
> > > 
> > 
> > set_cr4_guest_host_mask():
> > 	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
> > 			~vcpu->arch.cr4_guest_rsvd_bits;
> 
> My point is  when X86_CR4_LAM_SUP is not set in
> KVM_POSSIBLE_CR4_GUEST_BITS,
> CR4.LAM_SUP is definitely owned by host, regardless of the value of 
> cr4_guest_rsvd_bits.
> 
Yes, you can disregard that reply.
We were talking each's own points:) Neither is wrong.

Chao talked to me afterwards, that your points are: we can say by
default, without this patch, CR4.LAM_SUP were intercepted. so why
redundantly name this patch "Intercept CR4.LAM_SUP".
That's true, but intercepted as reserved bit.

I'm revising the subject in v5.
> 
> > 
> > kvm_vcpu_after_set_cpuid():
> > 	vcpu->arch.cr4_guest_rsvd_bits =
> > 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> > 

