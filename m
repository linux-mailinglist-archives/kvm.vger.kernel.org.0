Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADDC652205
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiLTOIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbiLTOIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:08:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B791B782
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671545279; x=1703081279;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iCSWYG7IyH2eBTtkCLLZcSYT3zCEH3CANK1ToQt1Sno=;
  b=C2AvJV81lRuUmWxxax34y7cwuUtoZ+qTIm5DdR2MzEq68vBX6XvVqFmr
   VMGdTGNTRWy00cCGhhNwTznKqqCveqo/aNKowS0FxWYuU16HKm2xl1tZs
   VpcZBUq4NKfs7hpEycV1EQPTCrHzVTv9T/nk7UNEkX+1N+Zi2qYan2s65
   uTglz9GJEydAZclD18Z5vbp2u6N8Jbf2X33gyokM4LjeiLwkprkRvrLZD
   hYRznoJ6SRTGOf9kWj37w9y50lxD+gp2MYiSyZnvczSgd8Bvkx5Pkyugk
   dLeiOTGNCqc/gPRWDAGNU4nJ6pO1glMTY7pavj21eiC9nzwKgjVj8HLG7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299961715"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="299961715"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:07:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="714447304"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="714447304"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2022 06:07:47 -0800
Message-ID: <77f09b4762da2a534554aa521b24f96a79f07f5e.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Tue, 20 Dec 2022 22:07:46 +0800
In-Reply-To: <20221219073212.ypilyj4dnbgg3mwo@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-7-robert.hu@linux.intel.com>
         <20221219073212.ypilyj4dnbgg3mwo@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-12-19 at 15:32 +0800, Yuan Yao wrote:
> On Fri, Dec 09, 2022 at 12:45:54PM +0800, Robert Hoo wrote:
> > Define kvm_untagged_addr() per LAM feature spec: Address high bits
> > are sign
> > extended, from highest effective address bit.
> > Note that LAM_U48 and LA57 has some effective bits overlap. This
> > patch
> > gives a WARN() on that case.
> > 
> > Now the only applicable possible case that addresses passed down
> > from VM
> > with LAM bits is those for MPX MSRs.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c |  3 +++
> >  arch/x86/kvm/x86.c     |  5 +++++
> >  arch/x86/kvm/x86.h     | 37 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 45 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9985dbb63e7b..16ddd3fcd3cb 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2134,6 +2134,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu,
> > struct msr_data *msr_info)
> >  		    (!msr_info->host_initiated &&
> >  		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
> >  			return 1;
> > +
> > +		data = kvm_untagged_addr(data, vcpu);
> > +
> >  		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
> >  		    (data & MSR_IA32_BNDCFGS_RSVD))
> >  			return 1;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index eb1f2c20e19e..0a446b45e3d6 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1812,6 +1812,11 @@ static int __kvm_set_msr(struct kvm_vcpu
> > *vcpu, u32 index, u64 data,
> >  	case MSR_KERNEL_GS_BASE:
> >  	case MSR_CSTAR:
> >  	case MSR_LSTAR:
> > +		/*
> > +		 * LAM applies only addresses used for data accesses.
> 
> Confused due to the MSR_KERNEL_GS_BASE also used for data accessing,
> how about add below:
> The strict canonical checking is sitll appplied to MSR writing even
> LAM is enabled.

OK

...
> > +#ifdef CONFIG_X86_64
> > +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> > +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu
> > *vcpu)
> > +{
> > +	if (addr >> 63 == 0) {
> > +		/* User pointers */
> > +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> > +			addr = get_canonical(addr, 57);
> > +		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
> > +			/*
> > +			 * If guest enabled 5-level paging and LAM_U48,
> > +			 * bit 47 should be 0, bit 48:56 contains meta
> > data
> > +			 * although bit 47:56 are valid 5-level address
> 
> Still 48:56.

OK

