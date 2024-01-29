Return-Path: <kvm+bounces-7315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7378400B9
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 09:57:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CF571F2249E
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 08:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7647E54FAA;
	Mon, 29 Jan 2024 08:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cuacWkyd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C0254FA0;
	Mon, 29 Jan 2024 08:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706518655; cv=none; b=rFgCy6CqU8KYEPiYhcKIku/vAG7wuHSiPW9KzhZaakZGA77tKjRq+dGVHAAOXRSRofSyvCXy4rtxBfLBOkKkkk18GR9JPWnobcOtcjFM7J9sPfGuD74JEcvTDZfz/8wI/iqc5T9r2/oZ503lPLVmuVXPaYwR+uGlnmgcUFGZTRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706518655; c=relaxed/simple;
	bh=4OzwNHO6i2VIeS985v3IpxVekLKtJP3xM9OuIoQ30Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4VVjsORb8fhjzVdXwetFsG1a2hL+CefcFhc5gT+FE2JT3oNLydGbwyJph4oDsgTKIVQLG4nJEXT136mglxc4fXIQFP6dJRy43dB0UzVY0U/1X7SAq25kKwlVgfihiDkkV+Q+syWMOkVO4AxWEWV5rcvCVrrakbgWgc5qmi0y1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cuacWkyd; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706518654; x=1738054654;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4OzwNHO6i2VIeS985v3IpxVekLKtJP3xM9OuIoQ30Ec=;
  b=cuacWkydp/QcdjHQ4Odq7pT2OGcdonNgWFq5bq60uUdfbTlfGnD3aa11
   XbnU5kxHGmTcPBvIpWx4Y5hF6AI05C84VbY7GKPOZQkKb80U/lw75aSSf
   c+Ue5HM0hMUlkXDDuopNEZfQeUrOJVUZNb3gwg8MP/zn4Rnr6spQSr5/5
   /oc5dlgWApKMS61hn824QkZUW85kzvhunBqpmPGigaqHEeaPS0hcXViAA
   5Q0UpBu4AUFaslIKkfRo2f8NpSRYFnk2k6A+jq9ev+jawUK6TVwgm8LO/
   vqFXHkrFwgjoNmnuE2sLdhqvYSoFfe42OXe92u5LG3dumcsmH6Wvo6vdQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="16422514"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="16422514"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 00:56:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="29450977"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa002.jf.intel.com with ESMTP; 29 Jan 2024 00:56:48 -0800
Date: Mon, 29 Jan 2024 16:56:47 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v18 007/121] KVM: VMX: Reorder vmx initialization with
 kvm vendor initialization
Message-ID: <20240129085647.o3vm6mglo2htfy2n@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:43PM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> To match vmx_exit cleanup.  Now vmx_init() is before kvm_x86_vendor_init(),
> vmx_init() can initialize loaded_vmcss_on_cpu.  Oppertunistically move it
> back into vmx_init().
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - move the loaded_vmcss_on_cpu initialization to vmx_init().
> - fix error path of vt_init(). by Chao and Binbin
> ---
>  arch/x86/kvm/vmx/main.c    | 17 +++++++----------
>  arch/x86/kvm/vmx/vmx.c     |  6 ++++--
>  arch/x86/kvm/vmx/x86_ops.h |  2 --
>  3 files changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 18cecf12c7c8..443db8ec5cd5 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -171,7 +171,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
>  static int __init vt_init(void)
>  {
>  	unsigned int vcpu_size, vcpu_align;
> -	int cpu, r;
> +	int r;
>
>  	if (!kvm_is_vmx_supported())
>  		return -EOPNOTSUPP;
> @@ -182,18 +182,14 @@ static int __init vt_init(void)
>  	 */
>  	hv_init_evmcs();
>
> -	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> -	for_each_possible_cpu(cpu)
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> -	r = kvm_x86_vendor_init(&vt_init_ops);
> -	if (r)
> -		return r;
> -
>  	r = vmx_init();
>  	if (r)
>  		goto err_vmx_init;
>
> +	r = kvm_x86_vendor_init(&vt_init_ops);

Do kvm_x86_vendor_init() *after* vmx_init() leads to
"enable_ept" is used before set to 0 in some cases.

vmx_init() depends on "enable_ept" variable for below 2:
    vmx_setup_l1d_flush()
    allow_smaller_maxphyaddr = true;

And "enable_ept" can be set to 0 in:
kvm_x86_vendor_init()
    vmx_hardware_setup()

> +	if (r)
> +		goto err_vendor_init;
> +
>  	/*
>  	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>  	 * exposed to userspace!
> @@ -207,9 +203,10 @@ static int __init vt_init(void)
>  	return 0;
>
>  err_kvm_init:
> +	kvm_x86_vendor_exit();
> +err_vendor_init:
>  	vmx_exit();
>  err_vmx_init:
> -	kvm_x86_vendor_exit();
>  	return r;
>  }
>  module_init(vt_init);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8efb956591d5..3f4dad3acb13 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -477,7 +477,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
>   * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
>   * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
>   */
> -DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> +static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
>
>  static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
>  static DEFINE_SPINLOCK(vmx_vpid_lock);
> @@ -8528,8 +8528,10 @@ int __init vmx_init(void)
>  	if (r)
>  		return r;
>
> -	for_each_possible_cpu(cpu)
> +	for_each_possible_cpu(cpu) {
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
>  		pi_init_cpu(cpu);
> +	}
>
>  	cpu_emergency_register_virt_callback(vmx_emergency_disable);
>
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b936388853ab..bca2d27b3dfd 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -14,8 +14,6 @@ static inline __init void hv_init_evmcs(void) {}
>  static inline void hv_reset_evmcs(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>
> -DECLARE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> -
>  bool kvm_is_vmx_supported(void);
>  int __init vmx_init(void);
>  void vmx_exit(void);
> --
> 2.25.1
>
>

