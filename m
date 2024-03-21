Return-Path: <kvm+bounces-12428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6806388602E
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 18:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99F5D1C21CC1
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 17:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6721332AA;
	Thu, 21 Mar 2024 17:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c9eSV7qR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6A510782;
	Thu, 21 Mar 2024 17:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711043977; cv=none; b=Y3oipLcYJNiN4r3UXVIdFQK+ilZWHm7yrBn4ENMMJbgexIAcXvRiLPbwvfflv+47/elUBqtEAL9VHB60mtK1pa+4/5v1qCgRS6vHjiR5oxTJDon8QL77gwbdCOjOIQ6YhMM4cXpF9TkviJj0yqhZ13VDCFxLDGaNkJJShi+EQ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711043977; c=relaxed/simple;
	bh=5p1vu+H+Qi9PzEOaI6stcVG4CjMDc4QRwynUOBT6pZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RauAJgIA/JJsw2WCgtz1NxwiBOh0aclepa2ufQRGSzu/4Oo0jCoEcrxS8TAzd8onsS6Jx8lJFWyGWm5WjL/a4K9yEgf15hefxXEoUXxLAqNc+X6L8CLxJeFxLhYJKSV0N6knN1q875F5+NhlUTpM0i5Oa1X4Yjcv+HZciIEvvhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c9eSV7qR; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711043976; x=1742579976;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5p1vu+H+Qi9PzEOaI6stcVG4CjMDc4QRwynUOBT6pZU=;
  b=c9eSV7qRS+14cTIE6GELWtQoqqKZord42RIPc3SfkHtFThn4zTzEA7Wy
   VRFaMhZAg41ugZUB1haXpAXxxVqyJofT35PoSt5K4rfeHM5IHii0VGurZ
   R4OY23/zjvLd2x+/DxRmI32akQG2SeyFA/h8gozYZLxwkRFhx/nDdW1A0
   XnFSzdz+s7J9H7fmbs7Smpy9+QffjXIV6ZwAX8hk8qOIzQbVPeTAc7Vxp
   jGqryq1gSWuYX9jjfENRDXACIxc4ncdelRZ0un+LeYq/9Ga8AOfzAmYvE
   Gsaz0MKlZfo1QOkQRjjUcE/M68+LVQlE89Y5ttfczvlygwc0IEs2M7zzi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="31492966"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="31492966"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 10:59:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="19167559"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 10:59:35 -0700
Date: Thu, 21 Mar 2024 10:59:34 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 041/130] KVM: TDX: Refuse to unplug the last cpu on
 the package
Message-ID: <20240321175934.GO1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <15d4d08cf1fe16777f8f8d84ee940e41afbad406.1708933498.git.isaku.yamahata@intel.com>
 <ZfuIJpHzp4sEjCi/@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfuIJpHzp4sEjCi/@chao-email>

On Thu, Mar 21, 2024 at 09:06:46AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> >index 437c6d5e802e..d69dd474775b 100644
> >--- a/arch/x86/kvm/vmx/main.c
> >+++ b/arch/x86/kvm/vmx/main.c
> >@@ -110,6 +110,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> > 	.check_processor_compatibility = vmx_check_processor_compat,
> > 
> > 	.hardware_unsetup = vt_hardware_unsetup,
> >+	.offline_cpu = tdx_offline_cpu,
> > 
> > 	/* TDX cpu enablement is done by tdx_hardware_setup(). */
> > 	.hardware_enable = vmx_hardware_enable,
> >diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >index b11f105db3cd..f2ee5abac14e 100644
> >--- a/arch/x86/kvm/vmx/tdx.c
> >+++ b/arch/x86/kvm/vmx/tdx.c
> >@@ -97,6 +97,7 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> >  */
> > static DEFINE_MUTEX(tdx_lock);
> > static struct mutex *tdx_mng_key_config_lock;
> >+static atomic_t nr_configured_hkid;
> > 
> > static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> > {
> >@@ -112,6 +113,7 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> > {
> > 	tdx_guest_keyid_free(kvm_tdx->hkid);
> > 	kvm_tdx->hkid = -1;
> >+	atomic_dec(&nr_configured_hkid);
> 
> I may think it is better to extend IDA infrastructure e.g., add an API to check if
> any ID is allocated for a given range. No strong opinion on this.

Will use ida_is_empyt().



> > }
> > 
> > static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> >@@ -586,6 +588,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
> > 	if (ret < 0)
> > 		return ret;
> > 	kvm_tdx->hkid = ret;
> >+	atomic_inc(&nr_configured_hkid);
> > 
> > 	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > 	if (!va)
> >@@ -1071,3 +1074,41 @@ void tdx_hardware_unsetup(void)
> > 	kfree(tdx_info);
> > 	kfree(tdx_mng_key_config_lock);
> > }
> >+
> >+int tdx_offline_cpu(void)
> >+{
> >+	int curr_cpu = smp_processor_id();
> >+	cpumask_var_t packages;
> >+	int ret = 0;
> >+	int i;
> >+
> >+	/* No TD is running.  Allow any cpu to be offline. */
> >+	if (!atomic_read(&nr_configured_hkid))
> >+		return 0;
> >+
> >+	/*
> >+	 * In order to reclaim TDX HKID, (i.e. when deleting guest TD), need to
> >+	 * call TDH.PHYMEM.PAGE.WBINVD on all packages to program all memory
> >+	 * controller with pconfig.  If we have active TDX HKID, refuse to
> >+	 * offline the last online cpu.
> >+	 */
> >+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
> >+		return -ENOMEM;
> >+	for_each_online_cpu(i) {
> >+		if (i != curr_cpu)
> >+			cpumask_set_cpu(topology_physical_package_id(i), packages);
> >+	}
> 
> Just check if any other CPU is in the same package of the one about to go
> offline. This would obviate the need for the cpumask and allow us to break once
> one cpu in the same package is found.

Good idea. Will rewrite it so.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

