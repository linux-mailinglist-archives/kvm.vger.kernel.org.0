Return-Path: <kvm+bounces-12432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF848861D7
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F74D1F231B1
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 20:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF86135414;
	Thu, 21 Mar 2024 20:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="REzcuhgs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7857D12CD89;
	Thu, 21 Mar 2024 20:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053828; cv=none; b=S4qpzLEsJ1+XsraLPLzVUPgT6g36SYZHZktXWT3omEwLS/aUtNjsJvTa9ml05LDDb/lwEBoiX+LquJx0QAdcokGuH3gWdUcbefMYGTUR8k3S/GRXAEXe09x8rMVEWoCK1Yx1faT7k1N0nYiKe+g6wSEMQQp2zZMWFUEKEqzdG68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053828; c=relaxed/simple;
	bh=FDLJrtlyM9+tF+ndIBWA6li6OsU/NkF+XdC3UObSUQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBvkVN+eCAx42Vg1MWuBqZrwwD/r24XSAMYa8ehU/V8ew+hMtc5YiZWxFerSO+2u+4bn5vFmQLZoIJPC57Yk7ho/3/olC0T0KF34ZWis8qnuESt1s600Wn6mdFaYk7EZEsuTKeNA6rI8fnGE37BB0ytC5szfGUPmHth0ApdYnHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=REzcuhgs; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711053827; x=1742589827;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FDLJrtlyM9+tF+ndIBWA6li6OsU/NkF+XdC3UObSUQE=;
  b=REzcuhgs4ppgq5guUewn1Nmmll6wtJL8Cfk6Eyq+ZeBefXxtnkgYY7gl
   aQgXFFXXC6AwgTWOi83ygd6gaggMxcH6gVtCv8o4UDLLadham3KEaenbi
   OudfEYjPcDS+9tFUW7KRAP7h05BDJLttWND9EKIzbRtMey2pu1XNFneWV
   GNZsOXdSEyN4z2Xv8DD0jDvr9eufxtBYtwUE0vqsnrBaufm8SNoX7Fvdn
   BmSzKLAvHLLSGkzgUkXNCDVkAgKRJvu2CjE3pFym2Rr4xukMEsjmQRPf3
   c7ZN3tsuUMO7HR5tscK8lFbcey4sHQrK5RxXsoznDjRVYKY6CiV0e4tgJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6203257"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="6203257"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 13:43:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14619224"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 13:43:45 -0700
Date: Thu, 21 Mar 2024 13:43:45 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 044/130] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20240321204345.GQ1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6a21fe6ea9eb53c24b6527ef8e5a07f0c2e8806.1708933498.git.isaku.yamahata@intel.com>
 <ZfvI8t7SlfIsxbmT@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfvI8t7SlfIsxbmT@chao-email>

On Thu, Mar 21, 2024 at 01:43:14PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
> >+static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> >+{
> >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> >+	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >+	unsigned long *tdvpx_pa = NULL;
> >+	unsigned long tdvpr_pa;
> >+	unsigned long va;
> >+	int ret, i;
> >+	u64 err;
> >+
> >+	if (is_td_vcpu_created(tdx))
> >+		return -EINVAL;
> >+
> >+	/*
> >+	 * vcpu_free method frees allocated pages.  Avoid partial setup so
> >+	 * that the method can't handle it.
> >+	 */
> >+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> >+	if (!va)
> >+		return -ENOMEM;
> >+	tdvpr_pa = __pa(va);
> >+
> >+	tdvpx_pa = kcalloc(tdx_info->nr_tdvpx_pages, sizeof(*tdx->tdvpx_pa),
> >+			   GFP_KERNEL_ACCOUNT);
> >+	if (!tdvpx_pa) {
> >+		ret = -ENOMEM;
> >+		goto free_tdvpr;
> >+	}
> >+	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> >+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> >+		if (!va) {
> >+			ret = -ENOMEM;
> >+			goto free_tdvpx;
> >+		}
> >+		tdvpx_pa[i] = __pa(va);
> >+	}
> >+
> >+	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> >+	if (KVM_BUG_ON(err, vcpu->kvm)) {
> >+		ret = -EIO;
> >+		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> >+		goto free_tdvpx;
> >+	}
> >+	tdx->tdvpr_pa = tdvpr_pa;
> >+
> >+	tdx->tdvpx_pa = tdvpx_pa;
> >+	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> 
> Can you merge the for-loop above into this one? then ...
> 
> >+		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> >+		if (KVM_BUG_ON(err, vcpu->kvm)) {
> >+			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> 
> >+			for (; i < tdx_info->nr_tdvpx_pages; i++) {
> >+				free_page((unsigned long)__va(tdvpx_pa[i]));
> >+				tdvpx_pa[i] = 0;
> >+			}
> 
> ... no need to free remaining pages.

Makes sense. Let me clean up this.


> >+			/* vcpu_free method frees TDVPX and TDR donated to TDX */
> >+			return -EIO;
> >+		}
> >+	}
> >+
> >+	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
> >+	if (KVM_BUG_ON(err, vcpu->kvm)) {
> >+		pr_tdx_error(TDH_VP_INIT, err, NULL);
> >+		return -EIO;
> >+	}
> >+
> >+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> >+	tdx->td_vcpu_created = true;
> >+	return 0;
> >+
> >+free_tdvpx:
> >+	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> >+		if (tdvpx_pa[i])
> >+			free_page((unsigned long)__va(tdvpx_pa[i]));
> >+		tdvpx_pa[i] = 0;
> >+	}
> >+	kfree(tdvpx_pa);
> >+	tdx->tdvpx_pa = NULL;
> >+free_tdvpr:
> >+	if (tdvpr_pa)
> >+		free_page((unsigned long)__va(tdvpr_pa));
> >+	tdx->tdvpr_pa = 0;
> >+
> >+	return ret;
> >+}
> >+
> >+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> >+{
> >+	struct msr_data apic_base_msr;
> >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> >+	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >+	struct kvm_tdx_cmd cmd;
> >+	int ret;
> >+
> >+	if (tdx->initialized)
> >+		return -EINVAL;
> >+
> >+	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> 
> These checks look random e.g., I am not sure why is_td_created() isn't check here.
> 
> A few helper functions and boolean variables are added to track which stage the
> TD or TD vCPU is in. e.g.,
> 
> is_hkid_assigned()
> is_td_finalized()
> is_td_created()
> tdx->initialized
> td_vcpu_created
> 
> Insteading of doing this, I am wondering if adding two state machines for
> TD and TD vCPU would make the implementation clear and easy to extend.

Let me look into the state machine. Originally I hoped we don't need it, but
it seems to deserve the state machine..


> >+		return -EINVAL;
> >+
> >+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> >+		return -EFAULT;
> >+
> >+	if (cmd.error)
> >+		return -EINVAL;
> >+
> >+	/* Currently only KVM_TDX_INTI_VCPU is defined for vcpu operation. */
> >+	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
> >+		return -EINVAL;
> 
> Even though KVM_TD_INIT_VCPU is the only supported command, it is worthwhile to
> use a switch-case statement. New commands can be added easily without the need
> to refactor this function first.

Yes. For KVM_MAP_MEMORY, I will make KVM_TDX_INIT_MEM_REGION vcpu ioctl instead
of vm ioctl because it is consistent and scalable.  We'll have switch statement
in the next respin.

> >+
> >+	/*
> >+	 * As TDX requires X2APIC, set local apic mode to X2APIC.  User space
> >+	 * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=1 by
> >+	 * KVM_SET_CPUID2.  Otherwise kvm_set_apic_base() will fail.
> >+	 */
> >+	apic_base_msr = (struct msr_data) {
> >+		.host_initiated = true,
> >+		.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
> >+		(kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0),
> >+	};
> >+	if (kvm_set_apic_base(vcpu, &apic_base_msr))
> >+		return -EINVAL;
> 
> Exporting kvm_vcpu_is_reset_bsp() and kvm_set_apic_base() should be done
> here (rather than in a previous patch).

Sure.


> >+
> >+	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
> >+	if (ret)
> >+		return ret;
> >+
> >+	tdx->initialized = true;
> >+	return 0;
> >+}
> >+
> 
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index c002761bb662..2bd4b7c8fa51 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -6274,6 +6274,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> > 	case KVM_SET_DEVICE_ATTR:
> > 		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
> > 		break;
> >+	case KVM_MEMORY_ENCRYPT_OP:
> >+		r = -ENOTTY;
> 
> Maybe -EINVAL is better. Because previously trying to call this on vCPU fd
> failed with -EINVAL given ...

Oh, ok. Will change it.  I followed VM ioctl case as default value. But vcpu
ioctl seems to have -EINVAL as default value.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

