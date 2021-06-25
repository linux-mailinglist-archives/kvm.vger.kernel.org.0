Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBAD3B3FB4
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 10:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhFYIuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 04:50:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:56702 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhFYIuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 04:50:02 -0400
IronPort-SDR: hiWmSReGk0SA1O0BBSQNvcuBMuX0o4Mp/EYvu1Uers/bXko7qqa20zilmuA2y9N7mZE0DDJFeq
 YPy2djOUqrjQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="204625928"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="204625928"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 01:47:41 -0700
IronPort-SDR: 4x8bWtAhRzajnMb31YCDA9o2+hWWzAt5mwBRz6uvcgk8xiHeMPty+Qna7pDzV5x9UKegZ4+20z
 TyG5hWVZmU/w==
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="642574659"
Received: from junyuton-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.170.209])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 01:47:38 -0700
Date:   Fri, 25 Jun 2021 16:47:36 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 05/54] Revert "KVM: x86/mmu: Drop
 kvm_mmu_extended_role.cr4_la57 hack"
Message-ID: <20210625084644.ort4oojvd27oy4ca@linux.intel.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622175739.3610207-6-seanjc@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 10:56:50AM -0700, Sean Christopherson wrote:
> Restore CR4.LA57 to the mmu_role to fix an amusing edge case with nested
> virtualization.  When KVM (L0) is using TDP, CR4.LA57 is not reflected in
> mmu_role.base.level because that tracks the shadow root level, i.e. TDP
> level.  Normally, this is not an issue because LA57 can't be toggled
> while long mode is active, i.e. the guest has to first disable paging,
> then toggle LA57, then re-enable paging, thus ensuring an MMU
> reinitialization.
> 
> But if L1 is crafty, it can load a new CR4 on VM-Exit and toggle LA57
> without having to bounce through an unpaged section.  L1 can also load a

May I ask how this is done by the guest? Thanks!

> new CR3 on exit, i.e. it doesn't even need to play crazy paging games, a
> single entry PML5 is sufficient.  Such shenanigans are only problematic
> if L0 and L1 use TDP, otherwise L1 and L2 share an MMU that gets
> reinitialized on nested VM-Enter/VM-Exit due to mmu_role.base.guest_mode.
> 
> Note, in the L2 case with nested TDP, even though L1 can switch between
> L2s with different LA57 settings, thus bypassing the paging requirement,
> in that case KVM's nested_mmu will track LA57 in base.level.
> 
> This reverts commit 8053f924cad30bf9f9a24e02b6c8ddfabf5202ea.
> 
> Fixes: 8053f924cad3 ("KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e11d64aa0bcd..916e0f89fdfc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -320,6 +320,7 @@ union kvm_mmu_extended_role {
>  		unsigned int cr4_pke:1;
>  		unsigned int cr4_smap:1;
>  		unsigned int cr4_smep:1;
> +		unsigned int cr4_la57:1;
>  		unsigned int maxphyaddr:6;
>  	};
>  };
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0db12f461c9d..5024318dec45 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4537,6 +4537,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
>  	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
>  	ext.cr4_pse = !!is_pse(vcpu);
>  	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
> +	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
>  	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
>  
>  	ext.valid = 1;
> -- 
> 2.32.0.288.g62a8d224e6-goog
> 

B.R.
Yu
