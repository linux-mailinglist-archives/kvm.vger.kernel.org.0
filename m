Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A47698A65
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 03:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBPCOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 21:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPCOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 21:14:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A9A2007D
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 18:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676513659; x=1708049659;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ddzF8NlXFP5ombNOuHdqdx7n30DC5EC7des4giF8hGU=;
  b=MNVT6RvzaaOCU8QBhVkBgXctazsYrQnBQuq064e37Db44fdiVYgHF2+p
   KWoeLU3RSO6O/T4jvv0ek8gyppP07Vl+kQXwVJQRRUlXCRtO6UnGmeZEf
   7153kx9Zv2ueaC2BcIinMVs7ZKbYguI7WFs/j/kj9vhQvsaYy/BrKY9oV
   m0D52lK5+gZFTXv0YNJcgZUX+wPhlYJ+4175gHnxEHBp1h4CJ+znG4WdJ
   9277CF/l19I4eNnO5nRvRHEWQr0mB+eDULuRjuigx5zeEVMOnTE8wsxfi
   xTQ7ayzwP6/ZchDqLpAFjRtppA7e04RE6Rs8AtgKAC7Yh/GT9wZNfb4jt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359030536"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="359030536"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 18:14:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="647501327"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="647501327"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 15 Feb 2023 18:14:16 -0800
Message-ID: <9753ebdc19ecce8bc1ff61ad127d9cba12185960.camel@linux.intel.com>
Subject: Re: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate
 shadow root
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Thu, 16 Feb 2023 10:14:15 +0800
In-Reply-To: <4f848515-462b-163e-a6ad-5bb16cc99518@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-3-robert.hu@linux.intel.com>
         <Y+TDEsdjYljRzlPY@gao-cwp>
         <83692d6b284768b132b78dd6f21e226a028ba308.camel@linux.intel.com>
         <4f848515-462b-163e-a6ad-5bb16cc99518@linux.intel.com>
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

On Tue, 2023-02-14 at 10:55 +0800, Binbin Wu wrote:
> On 2/9/2023 9:02 PM, Robert Hoo wrote:
> > On Thu, 2023-02-09 at 17:55 +0800, Chao Gao wrote:
> > > On Thu, Feb 09, 2023 at 10:40:15AM +0800, Robert Hoo wrote:
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -3698,8 +3698,11 @@ static int mmu_alloc_shadow_roots(struct
> > > > kvm_vcpu *vcpu)
> > > > 	gfn_t root_gfn, root_pgd;
> > > > 	int quadrant, i, r;
> > > > 	hpa_t root;
> > > > -
> > > 
> > > The blank line should be kept.
> > 
> > OK
> > > > +#ifdef CONFIG_X86_64
> > > > +	root_pgd = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48
> > > > |
> > > > X86_CR3_LAM_U57);
> > > > +#else
> > > > 	root_pgd = mmu->get_guest_pgd(vcpu);
> > > > +#endif
> > > 
> > > Why are other call sites of mmu->get_guest_pgd() not changed?
> > 
> > Emm, the other 3 are
> > FNAME(walk_addr_generic)()
> > kvm_arch_setup_async_pf()
> > kvm_arch_async_page_ready
> > 
> > In former version, I clear CR3.LAM bits for guest_pgd inside mmu-
> > > get_guest_pgd(). I think this is generic. Perhaps I should still
> > > do it
> > 
> > in that way. Let's wait for other's comments on this.
> > Thanks for pointing out.
> 
> I also prefer to handle it inside get_guest_pdg,
> but in kvm_arch_setup_async_pf()/kvm_arch_async_page_ready(), the
> value 
> is assigned to
> cr3 of struct kvm_arch_async_pf, does it requires all fileds of cr3?
> 
Took a rough look at the code, looks like
kvm_arch_setup_sync_fp() preserves the temporal cr3
kvm_arch_async_page_ready() confirms the ready (resolved) PF does
correspond to current vcpu context.
To be conservative, I prefer keep
kvm_arch_setup_async_pf()/kvm_arch_async_page_ready() as is, i.e. LAM
bits is contained in the checking.

As for FNAME(walk_addr_generic)()
	pte           = mmu->get_guest_pgd(vcpu);
I think it's like mmu_alloc_shadow_roots(), i.e. LAM bits should be
cleared. 

If no objection, I'll update in next version.

