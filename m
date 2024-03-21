Return-Path: <kvm+bounces-12420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6AD9885CBD
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FF4F285BCE
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D02612BEB0;
	Thu, 21 Mar 2024 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m7gz1US+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7632212BE9A;
	Thu, 21 Mar 2024 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036516; cv=none; b=g0p/a8i/RBaB0yt0PoyKqkFM0XOGtVcoua4kRYM6h71L35BGyX06EmRJap/e9gEkXbvXwwBYTyCblyczfcX4U4ckw5ySQsqbFEeaIyXdJjFenR64sUMt27C9dMFp/kWCrtNFzWauvM02JM1Yrd+iJQ1PJ4jvcIfCkXnUhO3a/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036516; c=relaxed/simple;
	bh=SBcxsISLDAO5KohQkV0aO0//ioqYfv25xAdOSLw8DL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhZIVxuuPhaXVm7lU7KRSwZdFNCQfXr+rD5VcvdY9FvdMMv3fbNEBU7vIol1N5BzKmJbptPyP5+m7+aWfhHjHj2wdtXqRQFkYj52Y3a17V/kqhf/ftuz47M2P3mfkwN+o2EQiwnKtmZLS7aACV4ooL9zs5sSl/3WTKOv27iCogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m7gz1US+; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711036514; x=1742572514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SBcxsISLDAO5KohQkV0aO0//ioqYfv25xAdOSLw8DL4=;
  b=m7gz1US++bdAbVGxCLm8NXX+FspmxEAN/vfjv113LaT8mVrKfQI4rSPs
   ivM4h/L3YvBd7uGXVXpN1mM3mZWOf5H3MhNS6KpRMDRLgnJ9r3CBwQBCs
   MqJLiZVoc1umgXiCevUqmB9cgPwRwDC4Al1eS/V9iNZauQyEt0y02K+v6
   gjXTi57AXOcS8gUdEA2t+qJv83DJzscqLQn4+UErQvrCPmuUaVOr2peGb
   5oyb/Nk/Ye9sVZXdzONSqrtX8k8341gIFwUtUESWQPNgNyqu2o41ILun4
   cN4t5gcAN9D5lBWvMvDPL9Pcte6K/W1hGO+VMJDh5Y60tyP5QHpEFrsxp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9839619"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9839619"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 08:55:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="45664344"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 08:55:12 -0700
Date: Thu, 21 Mar 2024 08:55:13 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240321155513.GL1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <Zfp+YWzHV0DxVf1+@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zfp+YWzHV0DxVf1+@chao-email>

On Wed, Mar 20, 2024 at 02:12:49PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+static void setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
> >+				  struct td_params *td_params)
> >+{
> >+	int i;
> >+
> >+	/*
> >+	 * td_params.cpuid_values: The number and the order of cpuid_value must
> >+	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
> >+	 * It's assumed that td_params was zeroed.
> >+	 */
> >+	for (i = 0; i < tdx_info->num_cpuid_config; i++) {
> >+		const struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
> >+		/* KVM_TDX_CPUID_NO_SUBLEAF means index = 0. */
> >+		u32 index = c->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF ? 0 : c->sub_leaf;
> >+		const struct kvm_cpuid_entry2 *entry =
> >+			kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
> >+					      c->leaf, index);
> >+		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
> >+
> >+		if (!entry)
> >+			continue;
> >+
> >+		/*
> >+		 * tdsysinfo.cpuid_configs[].{eax, ebx, ecx, edx}
> >+		 * bit 1 means it can be configured to zero or one.
> >+		 * bit 0 means it must be zero.
> >+		 * Mask out non-configurable bits.
> >+		 */
> >+		value->eax = entry->eax & c->eax;
> >+		value->ebx = entry->ebx & c->ebx;
> >+		value->ecx = entry->ecx & c->ecx;
> >+		value->edx = entry->edx & c->edx;
> 
> Any reason to mask off non-configurable bits rather than return an error? this
> is misleading to userspace because guest sees the values emulated by TDX module
> instead of the values passed from userspace (i.e., the request from userspace
> isn't done but there is no indication of that to userspace).

Ok, I'll eliminate them.  If user space passes wrong cpuids, TDX module will
return error. I'll leave the error check to the TDX module.


> >+	}
> >+}
> >+
> >+static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
> >+{
> >+	const struct kvm_cpuid_entry2 *entry;
> >+	u64 guest_supported_xcr0;
> >+	u64 guest_supported_xss;
> >+
> >+	/* Setup td_params.xfam */
> >+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
> >+	if (entry)
> >+		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> >+	else
> >+		guest_supported_xcr0 = 0;
> >+	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> >+
> >+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
> >+	if (entry)
> >+		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> >+	else
> >+		guest_supported_xss = 0;
> >+
> >+	/*
> >+	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
> >+	 * and, CET support.
> >+	 */
> >+	guest_supported_xss &=
> >+		(kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
> >+
> >+	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> >+	if (td_params->xfam & XFEATURE_MASK_LBR) {
> >+		/*
> >+		 * TODO: once KVM supports LBR(save/restore LBR related
> >+		 * registers around TDENTER), remove this guard.
> >+		 */
> >+#define MSG_LBR	"TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH properly.\n"
> >+		pr_warn(MSG_LBR);
> 
> Drop the pr_warn() because userspace can trigger it at will.
> 
> I don't think KVM needs to relay TDX module capabilities to userspace as-is.
> KVM should advertise a feature only if both TDX module's and KVM's support
> are in place. if KVM masked out LBR and PERFMON, it should be a problem of
> userspace and we don't need to warn here.

Makes sense. Drop those message and don't advertise those features to user
space.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

