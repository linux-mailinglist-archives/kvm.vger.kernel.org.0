Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695633B3FCA
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 10:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhFYIyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 04:54:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:33039 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhFYIyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 04:54:32 -0400
IronPort-SDR: 9KRHTdVoXMk9r3mvm9mxh4dgwyMYN404Td2h6eFQK9TWCZoJgWtURoOP4KEe4fDMyr4wP5ZQPC
 RCtAFUI7IuBg==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="229229036"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="229229036"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 01:52:12 -0700
IronPort-SDR: rfsP4Hu6nWtWjiduoQQqpv25aIvPfSs3IUQO6/97fhWEKLfzTQJ4LpiMcD/DihyzKyJwa9rcWc
 H/qSmO9upAfA==
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="642575362"
Received: from junyuton-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.170.209])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 01:52:09 -0700
Date:   Fri, 25 Jun 2021 16:52:06 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 08/54] Revert "KVM: MMU: record maximum physical address
 width in kvm_mmu_extended_role"
Message-ID: <20210625085206.uycvsmpnsryv45y5@linux.intel.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622175739.3610207-9-seanjc@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 10:56:53AM -0700, Sean Christopherson wrote:
> Drop MAXPHYADDR from mmu_role now that all MMUs have their role
> invalidated after a CPUID update.  Invalidating the role forces all MMUs
> to re-evaluate the guest's MAXPHYADDR, and the guest's MAXPHYADDR can
> only be changed only through a CPUID update.
> 
> This reverts commit de3ccd26fafc707b09792d9b633c8b5b48865315.
> 
> Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/mmu/mmu.c          | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 19c88b445ee0..cdaff399ed94 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -321,7 +321,6 @@ union kvm_mmu_extended_role {
>  		unsigned int cr4_smap:1;
>  		unsigned int cr4_smep:1;
>  		unsigned int cr4_la57:1;
> -		unsigned int maxphyaddr:6;
>  	};
>  };
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8d97d21d5241..04cab330c445 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4538,7 +4538,6 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
>  	ext.cr4_pse = !!is_pse(vcpu);
>  	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
>  	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
> -	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
>  
>  	ext.valid = 1;
>  
> -- 
> 2.32.0.288.g62a8d224e6-goog
> 

Reviewed-by: Yu Zhang <yu.c.zhang@linux.intel.com>

Thanks
Yu
