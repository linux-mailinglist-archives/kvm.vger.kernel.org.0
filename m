Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6326A995A
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 15:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjCCOYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 09:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCCOYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 09:24:22 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8F912F18
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 06:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677853461; x=1709389461;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yz+jwlRPJfMxoehQU1Cx9fvgqYB69yc8GYOqMQgEZk0=;
  b=Duxy0WN6Uj2PRNXq9FEVcehEoU6Me4gIzdjs5yksqdPQSu3/qnrvShX7
   6GM6T+E2tmvhk4a8+w5UnoF2IzlzxdSz9jUlS19nFuDghTwePFqKUwxDh
   K5FPYLupW+wlK3SjILBJBs4m5+8bzu5ttcRARRoF0QFcG4uoGIJBxe7vk
   OKonn8y+aVYMukX/ceH65NZqJsZvUBQhCFueH3JKJU4dmvrCASxmODHWf
   qs6JkfFUN93n1YwkLU+HVXP+KE1zzpYWS8STIg+/cOpnlt6Wb4WzyonDi
   qQCpSvDlU/JfQF+Ws1rX91kt0Ee9RjZRwjGD4uTGiXIIOzJa5SjxQASbL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="315450009"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="315450009"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 06:23:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="668666972"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="668666972"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2023 06:23:51 -0800
Message-ID: <580137f7c866c7caadb3ff92d50169cd9a12dae2.camel@linux.intel.com>
Subject: Re: [PATCH v5 3/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com,
        kvm@vger.kernel.org
Date:   Fri, 03 Mar 2023 22:23:50 +0800
In-Reply-To: <ZAGR1qG2ehb8iXDL@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
         <20230227084547.404871-4-robert.hu@linux.intel.com>
         <ZAGR1qG2ehb8iXDL@gao-cwp>
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

On Fri, 2023-03-03 at 14:21 +0800, Chao Gao wrote:
> On Mon, Feb 27, 2023 at 04:45:45PM +0800, Robert Hoo wrote:
> > LAM feature uses 2 high bits in CR3 (bit 62 for LAM_U48 and bit 61
> > for
> > LAM_U57) to enable/config LAM feature for user mode addresses. The
> > LAM
> > masking is done before legacy canonical checks.
> > 
> > To virtualize LAM CR3 bits usage, this patch:
> > 1. Don't reserve these 2 bits when LAM is enable on the vCPU.
> > Previously
> > when validate CR3, kvm uses kvm_vcpu_is_legal_gpa(), now define
> > kvm_vcpu_is_valid_cr3() which is actually kvm_vcpu_is_legal_gpa()
> > + CR3.LAM bits validation. Substitutes
> > kvm_vcpu_is_legal/illegal_gpa()
> > with kvm_vcpu_is_valid_cr3() in call sites where is validating CR3
> > rather
> > than pure GPA.
> > 2. mmu::get_guest_pgd(), its implementation is get_cr3() which
> > returns
> > whole guest CR3 value. Strip LAM bits in those call sites that need
> > pure
> > PGD value, e.g. mmu_alloc_shadow_roots(),
> > FNAME(walk_addr_generic)().
> > 3. When form a new guest CR3 (vmx_load_mmu_pgd()), melt in LAM bit
> > (kvm_get_active_lam()).
> > 4. When guest sets CR3, identify ONLY-LAM-bits-toggling cases,
> > where it is
> > unnecessary to make new pgd, but just make request of load pgd,
> > then new
> > CR3.LAM bits configuration will be melt in (above point 3). To be
> > conservative, this case still do TLB flush.
> > 5. For nested VM entry, allow the 2 CR3 bits set in corresponding
> > VMCS host/guest fields.
> 
> isn't this already covered by item #1 above?

Ah, it is to address your comments on last version. To repeat/emphasize
again, doesn't harm, does it?;) 
> 
(...)
> > 
> > +static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
> > +{
> > +	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 |
> > X86_CR3_LAM_U57);
> > +}
> 
> I think it is better to define a mask (like reserved_gpa_bits):
> 
> kvm_vcpu_arch {
> 	...
> 
> 	/*
> 	 * Bits in CR3 used to enable certain features. These bits
> don't
> 	 * participate in page table walking. They should be masked to
> 	 * get the base address of page table. When shadow paging is
> 	 * used, these bits should be kept as is in the shadow CR3.
> 	 */
> 	u64 cr3_control_bits;
> 

I don't strongly object this. But per SDM, CR3.bit[63:MAXPHYADDR] are
reserved; and MAXPHYADDR is at most 52 [1]. So can we assert and simply
define the MASK bit[63:52]? (I did this in v3 and prior)

[1] CPUID.80000008H:EAX[7:0] reports the physical-address width
supported by the processor. (For processors
that do not support CPUID function 80000008H, the width is generally 36
if CPUID.01H:EDX.PAE [bit 6] = 1
and 32 otherwise.) This width is referred to as MAXPHYADDR. MAXPHYADDR
is at most 52. (SDM 4.1.4 Enumeration of Paging Features by CPUID)

> and initialize the mask in kvm_vcpu_after_set_cpuid():
> 
> 	if (guest_cpuid_has(X86_FEATURE_LAM))
> 		vcpu->arch.cr3_control_bits = X86_CR3_LAM_U48 |
> X86_CR3_LAM_U57;
> 
> then add helpers to extract/mask control bits.
> 
> It is cleaner and can avoid looking up guest CPUID at runtime.
>  And if
> AMD has a similar feature (e.g., some CR3 bits are used as control
> bits),
> it is easy to support that feature.

