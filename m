Return-Path: <kvm+bounces-12632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F37E88B50A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 00:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB7CE1F3DD11
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8302582D67;
	Mon, 25 Mar 2024 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="crm2MU/b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A1C5D724;
	Mon, 25 Mar 2024 23:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711408261; cv=none; b=lY4s6wDggVFwqWYblQzEe73Ls+HOevf6fBvsHkNC3X4f37/WcgDW0qLV9Iaj0KmJiG1omyNHV7qxXUuScAUEgz2mf/FpDf7mKb8PkHwd2++0BPCG3azVe4pCLfWtOcGI85OBupji/VcrcCgSPWlDZ8y43tvNt7lsctyfyMHVzx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711408261; c=relaxed/simple;
	bh=5YbssXuI5sizABD/TiI1n66N2UT1fqlvepprQiYSV2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXhACy58kk/xwYvq7dSe6grJso+dMC0zans57mcdE2LehlnZwU8MYtHM7WbgR2jIZUN2QBjIriul2D3CofQj8W+v7TuGS6R88jvcXXzfkT2BqGGefOy0rHPLBwImdgAQT3GCH2eQqR3+mVOPeRg4CSBck/RwqVqC3dP7L0TEYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=crm2MU/b; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711408259; x=1742944259;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5YbssXuI5sizABD/TiI1n66N2UT1fqlvepprQiYSV2E=;
  b=crm2MU/bMOsKg4iJ0NJIEvVPWNC6uDKlFEXrU09QSG7U7rlgQGp/miKd
   XtUtaEdiL+SyVLHgoSVqix6llY1RMr5cTZadc0O7sd7voISwHpW/Tf4dR
   W62+s75ppyYQSoOcoYkbaL7ymIXR4GnMnxrinE+X3E5r9FdU8TzlTSZrY
   wyucZaxxEBXZ+mzK0B0dhyb6Gs6lJZu+lA4elyXfgOxS10JvXQnD2kT9n
   wPsWGIHRxOsTGSHUHn+CSDhAvx0Kk06lst/nDfZyQx82EuLSfz8ii0Ycp
   eoBhMNfXerGAi6ddUHfEunaFGPtzXRJd4rEO5y8WN+RCJck7PtrSCB6D2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6551758"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6551758"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:10:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20453313"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:10:59 -0700
Date: Mon, 25 Mar 2024 16:10:58 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240325231058.GP2357401@ls.amr.corp.intel.com>
References: <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
 <20240319235654.GC1994522@ls.amr.corp.intel.com>
 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
 <20240321225910.GU1994522@ls.amr.corp.intel.com>
 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240325221836.GO2357401@ls.amr.corp.intel.com>

On Mon, Mar 25, 2024 at 03:18:36PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> On Mon, Mar 25, 2024 at 07:55:04PM +0000,
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> 
> > On Mon, 2024-03-25 at 12:05 -0700, Isaku Yamahata wrote:
> > > Right, the guest has to accept it on VE.  If the unmap was intentional by guest,
> > > that's fine.  The unmap is unintentional (with vMTRR), the guest doesn't expect
> > > VE with the GPA.
> > > 
> > > 
> > > > But, I guess we should punt to userspace is the guest tries to use
> > > > MTRRs, not that userspace can handle it happening in a TD...  But it
> > > > seems cleaner and safer then skipping zapping some pages inside the
> > > > zapping code.
> > > > 
> > > > I'm still not sure if I understand the intention and constraints fully.
> > > > So please correct. This (the skipping the zapping for some operations)
> > > > is a theoretical correctness issue right? It doesn't resolve a TD
> > > > crash?
> > > 
> > > For lapic, it's safe guard. Because TDX KVM disables APICv with
> > > APICV_INHIBIT_REASON_TDX, apicv won't call kvm_zap_gfn_range().
> > Ah, I see it:
> > https://lore.kernel.org/lkml/38e2f8a77e89301534d82325946eb74db3e47815.1708933498.git.isaku.yamahata@intel.com/
> > 
> > Then it seems a warning would be more appropriate if we are worried there might be a way to still
> > call it. If we are confident it can't, then we can just ignore this case.
> > 
> > > 
> > > For MTRR, the purpose is to make the guest boot (without the guest kernel
> > > command line like clearcpuid=mtrr) .
> > > If we can assume the guest won't touch MTRR registers somehow, KVM can return an
> > > error to TDG.VP.VMCALL<RDMSR, WRMSR>(MTRR registers). So it doesn't call
> > > kvm_zap_gfn_range(). Or we can use KVM_EXIT_X86_{RDMSR, WRMSR} as you suggested.
> > 
> > My understanding is that Sean prefers to exit to userspace when KVM can't handle something, versus
> > making up behavior that keeps known guests alive. So I would think we should change this patch to
> > only be about not using the zapping roots optimization. Then a separate patch should exit to
> > userspace on attempt to use MTRRs. And we ignore the APIC one.
> > 
> > This is trying to guess what maintainers would want here. I'm less sure what Paolo prefers.
> 
> When we hit KVM_MSR_FILTER, the current implementation ignores it and makes it
> error to guest.  Surely we should make it KVM_EXIT_X86_{RDMSR, WRMSR}, instead.
> It's aligns with the existing implementation(default VM and SW-protected) and
> more flexible.

Something like this for "112/130 KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall"
Compile only tested at this point.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f891de30a2dd..4d9ae5743e24 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1388,31 +1388,67 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_rdmsr(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->run->msr.error)
+		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
+	else {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
+		tdvmcall_set_return_val(vcpu, vcpu->run->msr.data);
+	}
+	return 1;
+}
+
 static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 index = tdvmcall_a0_read(vcpu);
 	u64 data;
 
-	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ) ||
-	    kvm_get_msr(vcpu, index, &data)) {
+	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ)) {
+		trace_kvm_msr_read_ex(index);
+		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
+		return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_RDMSR, 0,
+					  tdx_complete_rdmsr,
+					  KVM_MSR_RET_FILTERED);
+	}
+
+	if (kvm_get_msr(vcpu, index, &data)) {
 		trace_kvm_msr_read_ex(index);
 		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
 		return 1;
 	}
-	trace_kvm_msr_read(index, data);
 
+	trace_kvm_msr_read(index, data);
 	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
 	tdvmcall_set_return_val(vcpu, data);
 	return 1;
 }
 
+static int tdx_complete_wrmsr(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->run->msr.error)
+		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
+	else
+		tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
+	return 1;
+}
+
 static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
 	u32 index = tdvmcall_a0_read(vcpu);
 	u64 data = tdvmcall_a1_read(vcpu);
 
-	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE) ||
-	    kvm_set_msr(vcpu, index, data)) {
+	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE)) {
+		trace_kvm_msr_write_ex(index, data);
+		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
+		if (kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_WRMSR, data,
+				       tdx_complete_wrmsr,
+				       KVM_MSR_RET_FILTERED))
+			return 1;
+		return 0;
+	}
+
+	if (kvm_set_msr(vcpu, index, data)) {
 		trace_kvm_msr_write_ex(index, data);
 		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
 		return 1;


-- 
Isaku Yamahata <isaku.yamahata@intel.com>

