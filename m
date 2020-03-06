Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C97017C8B1
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 00:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCFXHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 18:07:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:42162 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgCFXHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 18:07:48 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 15:07:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,523,1574150400"; 
   d="scan'208";a="288099074"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Mar 2020 15:07:47 -0800
Date:   Fri, 6 Mar 2020 15:07:47 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: VMX: untangle VMXON revision_id setting when
 using eVMCS
Message-ID: <20200306230747.GA27868@linux.intel.com>
References: <20200306130215.150686-1-vkuznets@redhat.com>
 <20200306130215.150686-3-vkuznets@redhat.com>
 <908345f1-9bfd-004f-3ba6-0d6dce67d11e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <908345f1-9bfd-004f-3ba6-0d6dce67d11e@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 06, 2020 at 02:20:13PM -0800, Krish Sadhukhan wrote:
> >@@ -2599,7 +2607,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
> >  int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
> >  {
> >-	loaded_vmcs->vmcs = alloc_vmcs(false);
> >+	loaded_vmcs->vmcs = alloc_vmcs(VMCS_REGION);
> >  	if (!loaded_vmcs->vmcs)
> >  		return -ENOMEM;
> >@@ -2652,25 +2660,13 @@ static __init int alloc_vmxon_regions(void)
> >  	for_each_possible_cpu(cpu) {
> >  		struct vmcs *vmcs;
> >-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
> >+		/* The VMXON region is really just a special type of VMCS. */
> 
> 
> Not sure if this is the right way to correlate the two.
> 
> AFAIU, the SDM calls VMXON region as a memory area that holds the VMCS data
> structure and it calls VMCS the data structure that is used by software to
> switch between VMX root-mode and not-root-mode. So VMXON is a memory area
> whereas VMCS is the structure of the data that resides in that memory area.
> 
> So if we follow this interpretation, your enum should rather look like,
> 
> enum vmcs_type {
> +    VMCS,
> +    EVMCS,
> +    SHADOW_VMCS

No (to the EVMCS suggestion), because this allocation needs to happen for
!eVMCS.  The SDM never explictly calls the VMXON region a VMCS, but it's
just being coy.  E.g. VMCLEAR doesn't fail if you point it at random
memory, but point it at the VMXON region and it yells.

We could call it VMXON_VMCS if that helps.  The SDM does call the memory
allocation for regular VMCSes a "VMCS region":

  A logical processor associates a region in memory with each VMCS. This
  region is called the VMCS region.

I don't think I've ever heard anyone differentiate that two though, i.e.
VMCS is used colloquially to mean both the data structure itself and the
memory region containing the data structure.

> >+		vmcs = alloc_vmcs_cpu(VMXON_REGION, cpu, GFP_KERNEL);
> >  		if (!vmcs) {
> >  			free_vmxon_regions();
> >  			return -ENOMEM;
> >  		}
> >-		/*
> >-		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
> >-		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
> >-		 * revision_id reported by MSR_IA32_VMX_BASIC.
> >-		 *
> >-		 * However, even though not explicitly documented by
> >-		 * TLFS, VMXArea passed as VMXON argument should
> >-		 * still be marked with revision_id reported by
> >-		 * physical CPU.
> >-		 */
> >-		if (static_branch_unlikely(&enable_evmcs))
> >-			vmcs->hdr.revision_id = vmcs_config.revision_id;
> >-
> >  		per_cpu(vmxarea, cpu) = vmcs;
> >  	}
> >  	return 0;
> >diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> >index e64da06c7009..a5eb92638ac2 100644
> >--- a/arch/x86/kvm/vmx/vmx.h
> >+++ b/arch/x86/kvm/vmx/vmx.h
> >@@ -489,16 +489,22 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
> >  	return &(to_vmx(vcpu)->pi_desc);
> >  }
> >-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
> >+enum vmcs_type {
> >+	VMXON_REGION,
> >+	VMCS_REGION,
> >+	SHADOW_VMCS_REGION,
> >+};
> >+
> >+struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags);
> >  void free_vmcs(struct vmcs *vmcs);
> >  int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
> >  void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
> >  void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
> >  void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
> >-static inline struct vmcs *alloc_vmcs(bool shadow)
> >+static inline struct vmcs *alloc_vmcs(enum vmcs_type type)
> >  {
> >-	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
> >+	return alloc_vmcs_cpu(type, raw_smp_processor_id(),
> >  			      GFP_KERNEL_ACCOUNT);
> >  }
