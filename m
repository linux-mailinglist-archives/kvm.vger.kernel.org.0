Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBF9652203
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiLTOH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLTOHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:07:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DE995BC
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671545257; x=1703081257;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b2HtQdk3JwpEF3xmHMG8fZwLlxWgoxRfHaU7YZt+R+s=;
  b=LyRC/mjT47oKxNgEg4B7jlVwAgoCfMbM4YurlR3s5vRJRrAQcTKvi2kP
   Zi1sIH0vxeyXfpiQtINZ3W8sQGu4vtR67IJ7UcWDFxkIJ5mQORC9IC9+g
   nNlvzD8yreCaqkYkBzRUju2qdFVlWB1JEwbPM5uhQHglEmar/obDs8E+m
   nbZhNgveHTkSGkVEeFnZ8RfkN4M7EhKLYozU0qrOizUa+PipW3Qr4lmHa
   67LzBWNQro1dxsSa8vLkzZJKROt55P46v9EPzAGvYX/Pe6bd3sQhL90Si
   ouJev4b8h2kRWDeXZyydfJMJqjLwvQghqIQoLcQ6BHBlYOqHl7jT3gX6w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="319669853"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="319669853"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:07:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="719565113"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="719565113"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 20 Dec 2022 06:07:09 -0800
Message-ID: <12706214b73728f88e5899db28b89344962d7495.camel@linux.intel.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: MMU: Rename get_cr3() --> get_pgd()
 and clear high bits for pgd
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Tue, 20 Dec 2022 22:07:08 +0800
In-Reply-To: <20221219064456.gcefglh4mov7xbz6@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-4-robert.hu@linux.intel.com>
         <20221219064456.gcefglh4mov7xbz6@yy-desk-7060>
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

On Mon, 2022-12-19 at 14:44 +0800, Yuan Yao wrote:
> On Fri, Dec 09, 2022 at 12:45:51PM +0800, Robert Hoo wrote:
> > The get_cr3() is the implementation of kvm_mmu::get_guest_pgd(),
> > well, CR3
> > cannot be naturally equivalent to pgd, SDM says CR3 high bits are
> > reserved,
> > must be zero.
> > And now, with LAM feature's introduction, bit 61 ~ 62 are used.
> > So, rename get_cr3() --> get_pgd() to better indicate function
> > purpose and
> > in it, filtered out CR3 high bits.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> > ---
> >  arch/x86/include/asm/processor-flags.h |  1 +
> >  arch/x86/kvm/mmu/mmu.c                 | 12 ++++++++----
> >  2 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/processor-flags.h
> > b/arch/x86/include/asm/processor-flags.h
> > index d8cccadc83a6..bb0f8dd16956 100644
> > --- a/arch/x86/include/asm/processor-flags.h
> > +++ b/arch/x86/include/asm/processor-flags.h
> > @@ -38,6 +38,7 @@
> >  #ifdef CONFIG_X86_64
> >  /* Mask off the address space ID and SME encryption bits. */
> >  #define CR3_ADDR_MASK	__sme_clr(PHYSICAL_PAGE_MASK)
> > +#define CR3_HIGH_RSVD_MASK	GENMASK_ULL(63, 52)
> >  #define CR3_PCID_MASK	0xFFFull
> >  #define CR3_NOFLUSH	BIT_ULL(63)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b6f96d47e596..d433c8923b18 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4488,9 +4488,13 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu,
> > gpa_t new_pgd)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
> > 
> > -static unsigned long get_cr3(struct kvm_vcpu *vcpu)
> > +static unsigned long get_pgd(struct kvm_vcpu *vcpu)
> >  {
> > +#ifdef CONFIG_X86_64
> > +	return kvm_read_cr3(vcpu) & ~CR3_HIGH_RSVD_MASK;
> 
> CR3_HIGH_RSVD_MASK is used to extract the guest pgd, may
> need to use guest's MAXPHYADDR but not hard code to 52.
> Or easily, just mask out the LAM bits.
> 
I define this CR3_HIGH_RSVD_MASK for extracting possible feature
control bits in [63, 52], now we already have LAM bits (bit 61, 62) and
PCID_NO_FLUSHING (bit 63) for examples. These bits, along with possible
future new ones, won't cross bit 52, as it is the MAXPHYADDR maximum
defined by current SDM. As for [51, guest actual max_phy_addr], I think
it should be guaranteed by other modules to reserved-as-0 to conform to
SDM. Given this, I chose the conservative const for simplicity.

However, your words also make sense, since this function is get_pgd(),
literally return kvm_read_cr3(vcpu) & ~vcpu->arch.reserved_gpa_bits is
more right. I'll take this in next version. Thanks.

