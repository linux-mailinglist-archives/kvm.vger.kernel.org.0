Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421C3652B65
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 03:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLUCMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 21:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLUCMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 21:12:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38188167D2
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 18:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671588754; x=1703124754;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JgZFQl4OA7MduMBHBZc3HUbw1byNAY+/vPS6ASXhvzo=;
  b=JhQbm2Gi5K74e19TtAQaQ71PozeSYaIr86Cxlt+igtiJDkUyUzH+CROZ
   KtAoS2lQWANyGgOBL44V4Dzln2573l9rami8Wwja3A4EUQL3I+zJXSazk
   TB+92BacWql0p9XdvmpJLYDV+k0PCnYEdSocKAY6MqCC2aZgkup0xYbFA
   f+RrnVsRO1s140vqq5+HR3VXRc5OTS75BoVQFCf3us8Hkth7FZi5kCJDr
   Iz4OSX2J+mZyuYRo5JeqVEw0Cnf7b8IsaLdpOJ7a/zW9LHVWalFxrcOpO
   pzlf1kbwSynliKbicVLZatT6EEj8e8mgiGpEDTrGWfi/E5qVFdaOATRYa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="319823459"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="319823459"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 18:12:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="980023489"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="980023489"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga005.fm.intel.com with ESMTP; 20 Dec 2022 18:12:32 -0800
Date:   Wed, 21 Dec 2022 10:12:31 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 5/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
Message-ID: <20221221021231.dtcxzva34rjocv2j@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-6-robert.hu@linux.intel.com>
 <20221219065347.oojvunwaszvqxhu5@yy-desk-7060>
 <49fd8ecc10bef5a4c6393aa8f313858c69a03ea3.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49fd8ecc10bef5a4c6393aa8f313858c69a03ea3.camel@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 10:07:33PM +0800, Robert Hoo wrote:
> On Mon, 2022-12-19 at 14:53 +0800, Yuan Yao wrote:
> > On Fri, Dec 09, 2022 at 12:45:53PM +0800, Robert Hoo wrote:
> > > When calc the new CR3 value, take LAM bits in.
> > >
> > > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu.h     | 5 +++++
> > >  arch/x86/kvm/vmx/vmx.c | 3 ++-
> > >  2 files changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index 6bdaacb6faa0..866f2b7cb509 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -142,6 +142,11 @@ static inline unsigned long
> > > kvm_get_active_pcid(struct kvm_vcpu *vcpu)
> > >  	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
> > >  }
> > >
> > > +static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
> > > +{
> >
> > Unlike the PCIDs, LAM bits in CR3 are  not sharing with other
> > features,
> > (e.g. PCID vs non-PCIN on bit 0:11) so not check CR4[28] here should
> > be fine, otherwise follows kvm_get_pcid() looks better.
> >
> No. CR4.LAM_SUP isn't an enablement switch over CR3.LAM_U{48,57},
> they're parallel relationship, CR4.LAM_SUP controls supervisor mode
> addresses has LAM or not while CR3.LAM_U controls user mode address's
> LAM enablement.

That's right, I didn't realize this at that time, thanks. : -)

>
> > > +	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 |
> > > X86_CR3_LAM_U57);
>
>
