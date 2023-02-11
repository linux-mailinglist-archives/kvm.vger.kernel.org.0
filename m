Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219BA692E97
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 07:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBKGYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Feb 2023 01:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBKGYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Feb 2023 01:24:05 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649822A6F1
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 22:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676096644; x=1707632644;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vMz0hwB0R661dXPRaR1tbwaiZWjw0xrB0xzdKaEhGaw=;
  b=oBlit3AxeBIeOmDuGb0hvFVd3QGGVlF0yy2LHXMByrSqbw6Ir1Q9bFg9
   62CQ2RyeySCyYZDccRxYJ/7ueKZ2PqgwuD1Z6dIOGijhamccKQ+Gh420K
   SNP1bTtowZDQHMbTIxBI4Ab6saIevHB34ZPNMoWJDh51EBWtTrmQCh8vX
   08W7IdTG3afsKNUcIyfg6gS6SlGd/PMrTNgF95CPolbO24eTUF9qnaP9y
   5vQcXX1TNlieLYdfm4hS94g99NrSly+ZMI7TcCnhQcCDQ1FH9SNzjdj4p
   Bix67kQ9H9RyeatryFbC+EUFcGyoH/r8jlYSXrCHuJX+1mC30mQvrUrcA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="310953303"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="310953303"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 22:24:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="698636358"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="698636358"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 10 Feb 2023 22:24:01 -0800
Message-ID: <9d144ccf640ca7a429df1e7f9e1fe42e8fd8c164.camel@linux.intel.com>
Subject: Re: [PATCH v4 4/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Sat, 11 Feb 2023 14:24:00 +0800
In-Reply-To: <Y+ZPBxFBJTsItzeE@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-5-robert.hu@linux.intel.com>
         <Y+ZPBxFBJTsItzeE@gao-cwp>
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

On Fri, 2023-02-10 at 22:04 +0800, Chao Gao wrote:
> On Thu, Feb 09, 2023 at 10:40:17AM +0800, Robert Hoo wrote:
> > When calc the new CR3 value, take LAM bits in.
> 
> I prefer to merge this one into patch 2 because both are related to
> CR3_LAM_U48/U57 handling. Merging them can give us the whole picture
> of
> how the new LAM bits are handled:
> * strip them from CR3 when allocating/finding a shadow root
> * stitch them with other fields to form a shadow CR3

OK
> 
> I have a couple questions:
> 1. in kvm_set_cr3(), 
> 
>         /* PDPTRs are always reloaded for PAE paging. */
>         if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
>                 goto handle_tlb_flush;
> 
> Shouldn't we strip off CR3_LAM_U48/U57 and do the comparison?

Here is the stringent check, i.e. including LAM bits.
Below we'll check if LAM bits is allowed to check.

	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
		return	1;

The only LAM bits toggling case will be handled in

	if (cr3 != old_cr3) {
		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
					X86_CR3_LAM_U57));
		} else {
			/*
			 * Though effective addr no change, mark the
			 * request so that LAM bits will take effect
			 * when enter guest.
			 */
			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
		}
	}

> It depends on whether toggling CR3_LAM_U48/U57 causes a TLB flush.

In v1, Kirill and I discussed about this. He lean toward being
conservative on TLB flush.
> 
> 2. also in kvm_set_cr3(),
> 
>         if (cr3 != kvm_read_cr3(vcpu))
>                 kvm_mmu_new_pgd(vcpu, cr3);
> 
> is it necessary to use a new pgd if only CR3_LAM_U48/U57 were
> changed?
> 
Hasn't applied my patch? It isn't like this. It's like below
	if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
			kvm_mmu
_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
				
	X86_CR3_LAM_U57));
			}

Only if effective pgd addr bits changes, kvm_mmu_new_pgd().

