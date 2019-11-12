Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5FFF9945
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 20:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKLTCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 14:02:40 -0500
Received: from mga04.intel.com ([192.55.52.120]:7548 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfKLTCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 14:02:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 11:02:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="202788210"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 12 Nov 2019 11:02:38 -0800
Date:   Tue, 12 Nov 2019 11:02:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, vkuznets@redhat.com,
        Bhavesh Davda <bhavesh.davda@oracle.com>
Subject: Re: [PATCH] KVM: x86: Optimization: Requst TLB flush in
 fast_cr3_switch() instead of do it directly
Message-ID: <20191112190238.GC18089@linux.intel.com>
References: <20191112183300.6959-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112183300.6959-1-liran.alon@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 08:33:00PM +0200, Liran Alon wrote:
> When KVM emulates a nested VMEntry (L1->L2 VMEntry), it switches mmu root
> page. If nEPT is used, this will happen from
> kvm_init_shadow_ept_mmu()->__kvm_mmu_new_cr3() and otherwise it will
> happpen from nested_vmx_load_cr3()->kvm_mmu_new_cr3(). Either case,
> __kvm_mmu_new_cr3() will use fast_cr3_switch() in attempt to switch to a
> previously cached root page.
> 
> In case fast_cr3_switch() finds a matching cached root page, it will
> set it in mmu->root_hpa and request KVM_REQ_LOAD_CR3 such that on
> next entry to guest, KVM will set root HPA in appropriate hardware
> fields (e.g. vmcs->eptp). In addition, fast_cr3_switch() calls
> kvm_x86_ops->tlb_flush() in order to flush TLB as MMU root page
> was replaced.
> 
> This works as mmu->root_hpa, which vmx_flush_tlb() use, was
> already replaced in cached_root_available(). However, this may
> result in unnecessary INVEPT execution because a KVM_REQ_TLB_FLUSH
> may have already been requested. For example, by prepare_vmcs02()
> in case L1 don't use VPID.
> 
> Therefore, change fast_cr3_switch() to just request TLB flush on
> next entry to guest.
> 
> Reviewed-by: Bhavesh Davda <bhavesh.davda@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24c23c66b226..150d982ec1d2 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4295,7 +4295,7 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
>  			kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
>  			if (!skip_tlb_flush) {
>  				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> -				kvm_x86_ops->tlb_flush(vcpu, true);
> +				kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);

Ha, I brought this up in the original review[*].  Junaid was concerned with
maintaining the existing behavior for vcpu->stat.tlb_flush, so we kept the
direct call to ->tlb_flush().  Incrementing tlb_flush seems a-ok, so:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

[*] https://patchwork.kernel.org/patch/10461319/#21985483

>  			}
>  
>  			/*
> -- 
> 2.20.1
> 
