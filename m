Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDBA652204
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiLTOIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiLTOHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:07:53 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6EADF95
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671545272; x=1703081272;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KjrQjt7pmaGuGIehXm8zk3RUdTaTQ5zmj0bg615tc+k=;
  b=kAuiOdWlvL4PxyNEgS1GjEZkZ8aAcsFw5h+bTZmyDEzrgrs0jzRKMXVq
   1KOJccmGjbU7grcw3f8EngS6xmHRnsgOOiHiaSesXHq1l9Zp3u0R/P5Lc
   2QqLmIzF7DLVwvxoI4c12+yT045ZvxnSkP7MM6dhyJu+6pF2cAKdL4PDL
   YAcpV36qywVmlLJNvGJ8ljUB+jjafoXaErZO+VfFOyNYd1Cm/SDM3yEch
   SSlWZugysZ8nripGrnH9RO8wBL15jAlMePxuBWK7ALjDnsgwffAezWI10
   umunopW6uSCj/X7S7W0BkQH9NBP8v/7oETO8sfSSLdgJ2A2xAHj2MMO0B
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="319669980"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="319669980"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:07:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="719565171"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="719565171"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 20 Dec 2022 06:07:34 -0800
Message-ID: <49fd8ecc10bef5a4c6393aa8f313858c69a03ea3.camel@linux.intel.com>
Subject: Re: [PATCH v3 5/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Tue, 20 Dec 2022 22:07:33 +0800
In-Reply-To: <20221219065347.oojvunwaszvqxhu5@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-6-robert.hu@linux.intel.com>
         <20221219065347.oojvunwaszvqxhu5@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-12-19 at 14:53 +0800, Yuan Yao wrote:
> On Fri, Dec 09, 2022 at 12:45:53PM +0800, Robert Hoo wrote:
> > When calc the new CR3 value, take LAM bits in.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> > ---
> >  arch/x86/kvm/mmu.h     | 5 +++++
> >  arch/x86/kvm/vmx/vmx.c | 3 ++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 6bdaacb6faa0..866f2b7cb509 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -142,6 +142,11 @@ static inline unsigned long
> > kvm_get_active_pcid(struct kvm_vcpu *vcpu)
> >  	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
> >  }
> > 
> > +static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
> > +{
> 
> Unlike the PCIDs, LAM bits in CR3 are  not sharing with other
> features,
> (e.g. PCID vs non-PCIN on bit 0:11) so not check CR4[28] here should
> be fine, otherwise follows kvm_get_pcid() looks better.
> 
No. CR4.LAM_SUP isn't an enablement switch over CR3.LAM_U{48,57},
they're parallel relationship, CR4.LAM_SUP controls supervisor mode
addresses has LAM or not while CR3.LAM_U controls user mode address's
LAM enablement.

> > +	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 |
> > X86_CR3_LAM_U57);


