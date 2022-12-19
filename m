Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0632A6507E6
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 07:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiLSGxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 01:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiLSGxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 01:53:50 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22032729
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 22:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671432829; x=1702968829;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wB3JU39L1PHuPdNAq7UqOfekTBCgMXSJBp9WsY4eWp8=;
  b=kepbxbUdgadd23JospyJEkgKDggxazXYkg+CymDftJjbsGef9cV769rS
   udW3zCSbsK7iC5yFTx6ZPequ7/gYOC/JOslEtikePXCb+DkEg+zXA4yWH
   l3pO72TnyeX6CcJM5KS3JalOHd/Y9ZKbReoT30N2g846bE5anwwP8dCCR
   Sq9Co3sddl6YRWiuL6xXRnxeQNGG2rFMzba/8lrq/MI7jl0eHuI7aPK0s
   /mE1tQH4QReGP20T14ujNw9hnlMckX9VeW6m9n4ibpPN0mMfihz3pZclx
   SHYIcnhsY0rf927ZWHWozY0vru54CFqHdBPYKRJvenxLGh45A99E5Ye71
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="346376019"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="346376019"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 22:53:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="739226206"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="739226206"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Dec 2022 22:53:48 -0800
Date:   Mon, 19 Dec 2022 14:53:47 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 5/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
Message-ID: <20221219065347.oojvunwaszvqxhu5@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-6-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-6-robert.hu@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 12:45:53PM +0800, Robert Hoo wrote:
> When calc the new CR3 value, take LAM bits in.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> ---
>  arch/x86/kvm/mmu.h     | 5 +++++
>  arch/x86/kvm/vmx/vmx.c | 3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 6bdaacb6faa0..866f2b7cb509 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>  	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
>  }
>
> +static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
> +{

Unlike the PCIDs, LAM bits in CR3 are  not sharing with other features,
(e.g. PCID vs non-PCIN on bit 0:11) so not check CR4[28] here should
be fine, otherwise follows kvm_get_pcid() looks better.

> +	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> +}
> +
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
>  	u64 root_hpa = vcpu->arch.mmu->root.hpa;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cfa06c7c062e..9985dbb63e7b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3261,7 +3261,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			update_guest_cr3 = false;
>  		vmx_ept_load_pdptrs(vcpu);
>  	} else {
> -		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
> +		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
> +			    kvm_get_active_lam(vcpu);
>  	}
>
>  	if (update_guest_cr3)
> --
> 2.31.1
>
