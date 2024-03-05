Return-Path: <kvm+bounces-10884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B1A871823
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4CE81C214A3
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E957F495;
	Tue,  5 Mar 2024 08:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TrWWX/su"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBC67EEF8;
	Tue,  5 Mar 2024 08:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709626901; cv=none; b=JwF32iEWfFHqeJjy7CFAThMtrmKwsNzAcdmkG5noiSdwHs3XA04k8/Q4CGYqCoSVo5Ev8aoKsOlHb2PZNowzUW34Va4yHWMwyBh1mv74VpagP8UZkxz/JcPgPMggzl+68Ru9Tmpw7pMnnrhL4ohcT/bz2/AGERRrZ1YGwVUrGps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709626901; c=relaxed/simple;
	bh=P9041sYAq5zhZua0EsYLvjpC/5BMWtqdpSeSAlAUPts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdHLTPmzn4ojia8u6XHaruSjCRXMiXeBYzUNQgfCPOZC26PD54zKrJ4liTEUxhtMSBkGVAugGZDYpwkg0DuvwE3eavONSsaRuqANi8mKH8BBJt7K417nwi4VyQmwhoZ7DSpEfKFIhTpyrL8lbcn5IY6zo6YEfIvQ06a/rQnQAJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TrWWX/su; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709626900; x=1741162900;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P9041sYAq5zhZua0EsYLvjpC/5BMWtqdpSeSAlAUPts=;
  b=TrWWX/suMjiQhX37TEIRjygThtHrxv5TlrX58Ccb1dKRjgvkk3wtWLl8
   eA4KrDjAT9O4xM8G5rQcXUvdJltvRSnb8E3aPHfXZ7uTGMazTulDrZhwn
   My7ZBj7NwlMDfkx+826SuFimBegxwRLy6OTN9KrSHkGAlndgx3fDKjnAE
   Y/2wcFjnNf456AffsSO8MxebH+7ooUIRZJ8E8AiVQZC0NRAyDpbbj/F2E
   9s4OWkpKuPQnJzNo21op9dPhlnfAyLMLmDdGPgjI0AAfkJg3bPXioBEVT
   qAraCMTBiB+i9o9zmo9EcAdXi/04MgzlQE4D2Hi77DQNwyapGa/6fJJSY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4086582"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4086582"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:21:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="40183356"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:21:39 -0800
Date: Tue, 5 Mar 2024 00:21:38 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <20240305082138.GD10568@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <ZeGC64sAzg4EN3G5@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZeGC64sAzg4EN3G5@yzhao56-desk.sh.intel.com>

On Fri, Mar 01, 2024 at 03:25:31PM +0800,
Yan Zhao <yan.y.zhao@intel.com> wrote:

> > + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> > + */
> > +#define TDX_MAX_VCPUS	(~(u16)0)
> This value will be treated as -1 in tdx_vm_init(),
> 	"kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);"
> 
> This will lead to kvm->max_vcpus being -1 by default.
> Is this by design or just an error?
> If it's by design, why not set kvm->max_vcpus = -1 in tdx_vm_init() directly.
> If an unexpected error, may below is better?
> 
> #define TDX_MAX_VCPUS   (int)((u16)(~0UL))
> or
> #define TDX_MAX_VCPUS 65536

You're right. I'll use ((int)U16_MAX).
As TDX 1.5 introduced metadata MAX_VCPUS_PER_TD, I'll update to get the value
and trim it further. Something following.

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index f964d99f8701..31205f84d594 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -23,7 +23,6 @@ KVM_X86_OP(has_emulated_msr)
 /* TODO: Once all backend implemented this op, remove _OPTIONAL_RET0. */
 KVM_X86_OP_OPTIONAL_RET0(vcpu_check_cpuid)
 KVM_X86_OP(vcpu_after_set_cpuid)
-KVM_X86_OP_OPTIONAL(max_vcpus);
 KVM_X86_OP_OPTIONAL(vm_enable_cap)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6dd78230c9d4..deb59e94990f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -13,17 +13,6 @@
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
-static int vt_max_vcpus(struct kvm *kvm)
-{
-	if (!kvm)
-		return KVM_MAX_VCPUS;
-
-	if (is_td(kvm))
-		return min(kvm->max_vcpus, TDX_MAX_VCPUS);
-
-	return kvm->max_vcpus;
-}
-
 #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_INTEL_TDX_HOST)
 static int vt_flush_remote_tlbs(struct kvm *kvm);
 static int vt_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, gfn_t nr_pages);
@@ -1130,7 +1119,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_disable = vt_hardware_disable,
 	.has_emulated_msr = vt_has_emulated_msr,
 
-	.max_vcpus = vt_max_vcpus,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_enable_cap = vt_vm_enable_cap,
 	.vm_init = vt_vm_init,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7cca6a33ad97..a8cfb4f214a6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -63,6 +63,8 @@ struct tdx_info {
 	u8 nr_tdcs_pages;
 	u8 nr_tdvpx_pages;
 
+	u16 max_vcpus_per_td;
+
 	/*
 	 * The number of WBINVD domains. 0 means that wbinvd domain is cpu
 	 * package.
@@ -100,7 +102,8 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		if (cap->flags || cap->args[0] == 0)
 			return -EINVAL;
 		if (cap->args[0] > KVM_MAX_VCPUS ||
-		    cap->args[0] > TDX_MAX_VCPUS)
+		    cap->args[0] > TDX_MAX_VCPUS ||
+		    cap->args[0] > tdx_info->max_vcpus_per_td)
 			return -E2BIG;
 
 		mutex_lock(&kvm->lock);
@@ -729,7 +732,8 @@ int tdx_vm_init(struct kvm *kvm)
 	 * TDX has its own limit of the number of vcpus in addition to
 	 * KVM_MAX_VCPUS.
 	 */
-	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
+	kvm->max_vcpus = min3(kvm->max_vcpus, tdx_info->max_vcpus_per_td,
+			     TDX_MAX_VCPUS);
 
 	mutex_init(&to_kvm_tdx(kvm)->source_lock);
 	return 0;
@@ -4667,6 +4671,7 @@ static int __init tdx_module_setup(void)
 		TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
 		TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
 		TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
+		TDX_INFO_MAP(MAX_VCPUS_PER_TD, max_vcpus_per_td),
 	};
 
 	ret = tdx_enable();
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index b10dad8f46bb..711855be6c83 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -144,7 +144,7 @@ struct tdx_cpuid_value {
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-#define TDX_MAX_VCPUS	(~(u16)0)
+#define TDX_MAX_VCPUS	((int)U16_MAX)
 
 struct td_params {
 	u64 attributes;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d097024fd974..6822a50e1d5d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4733,8 +4733,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-		if (kvm_x86_ops.max_vcpus)
-			r = static_call(kvm_x86_max_vcpus)(kvm);
+		if (kvm)
+			r = kvm->max_vcpus;
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_MAX_VCPU_IDS;

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

