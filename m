Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73446AADC1
	for <lists+kvm@lfdr.de>; Sun,  5 Mar 2023 02:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjCEBb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 20:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCEBb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 20:31:56 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA52D168AD
        for <kvm@vger.kernel.org>; Sat,  4 Mar 2023 17:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677979914; x=1709515914;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wC35bTP1xKMibyony9om/7+WH37+iYVjZWkiqn8nCbU=;
  b=L91fITTa3d35TkqO/1Jwb5gQiJyC5F/Aik5yMynEoFqSt7CMpBF+sACV
   nN9bG4SMuxbibjXy+fdVqT+oOe66KjmjJlIiuvG3j4erh607t7J/vNbsU
   hRFxmniMFKgrmBZrP6BT1s01Q41c8aXSB/UooHsbTpPiS4QmvLAxeN0yb
   WVBrNma8rGYdYmAuyCUmSdoaGxwq57ZKsJL99l4aD2Oof78yNIU/ja2jJ
   Y1br36+ev8Sp2KWDpjxHv/nAI+nXAByfLISb9GCjbb8u+EcF/eIybHhL9
   JB+jTHtHC/MvN4TThw6AicLMtPyG33tQ+fdvbgv3XBJCg3GoCj71F4x+i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="335353750"
X-IronPort-AV: E=Sophos;i="5.98,234,1673942400"; 
   d="scan'208";a="335353750"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2023 17:31:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="739914059"
X-IronPort-AV: E=Sophos;i="5.98,234,1673942400"; 
   d="scan'208";a="739914059"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2023 17:31:53 -0800
Message-ID: <88dd1570086f4a553a8dffbde71770cb51163388.camel@linux.intel.com>
Subject: Re: [PATCH v5 3/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com,
        kvm@vger.kernel.org
Date:   Sun, 05 Mar 2023 09:31:52 +0800
In-Reply-To: <ZAIX7m177/rQEl22@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
         <20230227084547.404871-4-robert.hu@linux.intel.com>
         <ZAGR1qG2ehb8iXDL@gao-cwp>
         <580137f7c866c7caadb3ff92d50169cd9a12dae2.camel@linux.intel.com>
         <ZAIX7m177/rQEl22@gao-cwp>
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

On Fri, 2023-03-03 at 23:53 +0800, Chao Gao wrote:
> On Fri, Mar 03, 2023 at 10:23:50PM +0800, Robert Hoo wrote:
> > On Fri, 2023-03-03 at 14:21 +0800, Chao Gao wrote:
> > > On Mon, Feb 27, 2023 at 04:45:45PM +0800, Robert Hoo wrote:
> > > > LAM feature uses 2 high bits in CR3 (bit 62 for LAM_U48 and bit
> > > > 61
> > > > for
> > > > LAM_U57) to enable/config LAM feature for user mode addresses.
> > > > The
> > > > LAM
> > > > masking is done before legacy canonical checks.
> > > > 
> > > > To virtualize LAM CR3 bits usage, this patch:
> > > > 1. Don't reserve these 2 bits when LAM is enable on the vCPU.
> > > > Previously
> > > > when validate CR3, kvm uses kvm_vcpu_is_legal_gpa(), now define
> > > > kvm_vcpu_is_valid_cr3() which is actually
> > > > kvm_vcpu_is_legal_gpa()
> > > > + CR3.LAM bits validation. Substitutes
> > > > kvm_vcpu_is_legal/illegal_gpa()
> > > > with kvm_vcpu_is_valid_cr3() in call sites where is validating
> > > > CR3
> > > > rather
> > > > than pure GPA.
> > > > 2. mmu::get_guest_pgd(), its implementation is get_cr3() which
> > > > returns
> > > > whole guest CR3 value. Strip LAM bits in those call sites that
> > > > need
> > > > pure
> > > > PGD value, e.g. mmu_alloc_shadow_roots(),
> > > > FNAME(walk_addr_generic)().
> > > > 3. When form a new guest CR3 (vmx_load_mmu_pgd()), melt in LAM
> > > > bit
> > > > (kvm_get_active_lam()).
> > > > 4. When guest sets CR3, identify ONLY-LAM-bits-toggling cases,
> > > > where it is
> > > > unnecessary to make new pgd, but just make request of load pgd,
> > > > then new
> > > > CR3.LAM bits configuration will be melt in (above point 3). To
> > > > be
> > > > conservative, this case still do TLB flush.
> > > > 5. For nested VM entry, allow the 2 CR3 bits set in
> > > > corresponding
> > > > VMCS host/guest fields.
> > > 
> > > isn't this already covered by item #1 above?
> > 
> > Ah, it is to address your comments on last version. To
> > repeat/emphasize
> > again, doesn't harm, does it?;) 
> 
> It is confusing. Trying to merge #5 to #1:

Well this is kind of subjective. I don't have any bias on this.
> 
> If LAM is supported, bits 62:61 (LAM_U48 and LAM_U57) are not
> reserved
> in CR3. VM entry also allows the two bits to be set in CR3 field in
> guest-state and host-state area of the VMCS. Previously ...
> 
> > > 
> > 
> > (...)
> > > > 
> > > > +static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 |
> > > > X86_CR3_LAM_U57);
> > > > +}
> > > 
> > > I think it is better to define a mask (like reserved_gpa_bits):
> > > 
> > > kvm_vcpu_arch {
> > > 	...
> > > 
> > > 	/*
> > > 	 * Bits in CR3 used to enable certain features. These bits
> > > don't
> > > 	 * participate in page table walking. They should be masked to
> > > 	 * get the base address of page table. When shadow paging is
> > > 	 * used, these bits should be kept as is in the shadow CR3.
> > > 	 */
> > > 	u64 cr3_control_bits;
> > > 
> > 
> > I don't strongly object this. But per SDM, CR3.bit[63:MAXPHYADDR]
> > are
> > reserved; and MAXPHYADDR is at most 52 [1]. So can we assert and
> > simply
> > define the MASK bit[63:52]? (I did this in v3 and prior)
> 
> No. Setting any bit in 60:52 should be rejected. And setting bit 62
> or
> 61 should be allowed if LAM is supported by the vCPU. I don't see how
> your proposal can distinguish these two cases.

No you didn't get my point.
Perhaps you can take a look at v3 patch and prior
https://lore.kernel.org/kvm/20221209044557.1496580-4-robert.hu@linux.intel.com/

define CR3_HIGH_RSVD_MASK, given "MAXPHYADDR is at most 52" is stated
in SDM.

