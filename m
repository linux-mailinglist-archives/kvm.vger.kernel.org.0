Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C05E36A134
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 14:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhDXMoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Apr 2021 08:44:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:1905 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237214AbhDXMoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Apr 2021 08:44:02 -0400
IronPort-SDR: rlDR1USMaCgIwEaxQM37opbaExT+YdehpbLweosy1iyzW10aUMeb3tc67CoevGUkOAlmcBW/Wg
 7sR+8HiJc2KA==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="195731763"
X-IronPort-AV: E=Sophos;i="5.82,248,1613462400"; 
   d="scan'208";a="195731763"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2021 05:43:23 -0700
IronPort-SDR: CX+5ZFcQ5jCDQB7NAUrMClckwWnZRcoWMv5hZVOSfXZvE1d+YKg+RmfcAh2bW7j7y2CIUH2aBN
 FI60aXELobTw==
X-IronPort-AV: E=Sophos;i="5.82,248,1613462400"; 
   d="scan'208";a="428736836"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 24 Apr 2021 05:43:21 -0700
Date:   Sat, 24 Apr 2021 20:31:00 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 1/2] KVM: VMX: Keep registers read/write consistent with
 definition
Message-ID: <20210424123100.GA5838@yangzhon-Virtual>
References: <20210422093436.78683-1-yang.zhong@intel.com>
 <20210422093436.78683-2-yang.zhong@intel.com>
 <5b5c9467-6358-66fb-47dd-cd8721ebe2f0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b5c9467-6358-66fb-47dd-cd8721ebe2f0@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 12:38:19PM +0200, Paolo Bonzini wrote:
> On 22/04/21 11:34, Yang Zhong wrote:
> >The kvm_cache_regs.h file has defined inline functions for those general
> >purpose registers and pointer register read/write operations, we need keep
> >those related registers operations consistent with header file definition
> >in the VMX side.
> >
> >Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> >---
> >  arch/x86/kvm/vmx/vmx.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 29b40e092d13..d56505fc7a71 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -2266,10 +2266,10 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> >  	switch (reg) {
> >  	case VCPU_REGS_RSP:
> >-		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
> >+		kvm_rsp_write(vcpu, vmcs_readl(GUEST_RSP));
> >  		break;
> >  	case VCPU_REGS_RIP:
> >-		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
> >+		kvm_rip_write(vcpu, vmcs_readl(GUEST_RIP));
> >  		break;
> 
> This is on purpose, because you don't want to mark those register dirty.
> 
> Likewise, in the case below it's more confusing to go through the
> helper because it checks kvm_register_is_available and calls
> vmx_cache_reg if false.
> 
> Because these functions are the once that handle the caching, it
> makes sense for them not to use the helpers.
> 

  Paolo, thanks for pointing out this issue, i will drop those two patches, thanks!

  Yang
 
> Paolo
> 
> >  	case VCPU_EXREG_PDPTR:
> >  		if (enable_ept)
> >@@ -4432,7 +4432,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  	vmx->msr_ia32_umwait_control = 0;
> >-	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> >+	kvm_rdx_write(&vmx->vcpu, get_rdx_init_val());
> >  	vmx->hv_deadline_tsc = -1;
> >  	kvm_set_cr8(vcpu, 0);
> >@@ -6725,9 +6725,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	WARN_ON_ONCE(vmx->nested.need_vmcs12_to_shadow_sync);
> >  	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
> >-		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
> >+		vmcs_writel(GUEST_RSP, kvm_rsp_read(vcpu));
> >+
> >  	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
> >-		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
> >+		vmcs_writel(GUEST_RIP, kvm_rip_read(vcpu));
> >  	cr3 = __get_current_cr3_fast();
> >  	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
> >
