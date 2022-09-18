Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E755BBDED
	for <lists+kvm@lfdr.de>; Sun, 18 Sep 2022 15:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiIRNLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Sep 2022 09:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIRNLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Sep 2022 09:11:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517781F2CD;
        Sun, 18 Sep 2022 06:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663506663; x=1695042663;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gxjMkXkrtlGL6/dieHu87TQsocsXooZYX/tz1fHL+6c=;
  b=aCg5QMyrKTVQGKD7uYgMgSKoficsaecZhfvY52fqR0UotvVot4cm+6da
   0kvA2gJArHOhpcz8skQi1Spj9e0Z+6dL8kagQIGvIfM225TV2ULh4k77t
   npAx3cySR5Gp+kfnookykoUyM7YKPeDvyFs7bNVeLE8/YNBBeJSE2A2bd
   JQ/7AxPrGwWzinYEBUZTP1OVj4KrX+SX8DgUvPeecdc6mtse5Bw6cjebC
   ijO/97FFbA5Sg7vepottiV0UV1k9Dk5seJq49JI9YZOPpj+TwXjbwmEMD
   GuIyaA1oOqANEiZT8dhH+vpucDUjHVE9RnEbzdc6cebUqoEdtZIxTxcab
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10474"; a="278963149"
X-IronPort-AV: E=Sophos;i="5.93,325,1654585200"; 
   d="scan'208";a="278963149"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2022 06:11:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,325,1654585200"; 
   d="scan'208";a="707278242"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Sep 2022 06:11:00 -0700
Message-ID: <f6fd8ccff13f9f48cbca06f0a5278654198d0d06.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb
 flushing in validate_direct_spte()
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Date:   Sun, 18 Sep 2022 21:11:00 +0800
In-Reply-To: <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
         <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-24 at 17:29 +0800, Hou Wenlong wrote:
> The spte pointing to the children SP is dropped, so the
> whole gfn range covered by the children SP should be flushed.
> Although, Hyper-V may treat a 1-page flush the same if the
> address points to a huge page, it still would be better
> to use the correct size of huge page. Also introduce
> a helper function to do range-based flushing when a direct
> SP is dropped, which would help prevent future buggy use
> of kvm_flush_remote_tlbs_with_address() in such case.
> 
> Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new
> one to flush a specified range.")
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e418ef3ecfcb..a3578abd8bbc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -260,6 +260,14 @@ void kvm_flush_remote_tlbs_with_address(struct
> kvm *kvm,
>  	kvm_flush_remote_tlbs_with_range(kvm, &range);
>  }
>  
> +/* Flush all memory mapped by the given direct SP. */
> +static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct
> kvm_mmu_page *sp)
> +{
> +	WARN_ON_ONCE(!sp->role.direct);

What if !sp->role.direct? Below flushing sp->gfn isn't expected? but
still to do it. Is this operation harmless? 

> +	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> +					   KVM_PAGES_PER_HPAGE(sp-
> >role.level + 1));
> +}
> +
>  static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64
> gfn,
>  			   unsigned int access)
>  {
> @@ -2341,7 +2349,7 @@ static void validate_direct_spte(struct
> kvm_vcpu *vcpu, u64 *sptep,
>  			return;
>  
>  		drop_parent_pte(child, sptep);
> -		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child-
> >gfn, 1);
> +		kvm_flush_remote_tlbs_direct_sp(vcpu->kvm, child);
>  	}
>  }
>  

