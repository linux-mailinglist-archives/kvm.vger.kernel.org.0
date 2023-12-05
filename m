Return-Path: <kvm+bounces-3451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D5A8049AD
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528D628160A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 06:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA2CD52F;
	Tue,  5 Dec 2023 06:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LqFVi2aI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25AB138;
	Mon,  4 Dec 2023 22:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701756164; x=1733292164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D+RilDnE5bQgzZwlQHyb0tF4Dk2ycFV+8VSSMzo7c90=;
  b=LqFVi2aIPnuZ0o75XmCpBUd0py9eLIf/fx09uTm61AKcRYjyDhTTERCT
   3Q/z44c6VIXXHFmZpCSKqJcDvaQmeX0QJk+E36M1tEZfLvb3qqyX4B+aT
   0+REhYOieCq/Joo0l6eUPyVJvXNN2MIsagp4bSTRKCgATVPGLvSs2YYBa
   xaNAGTAjQ38sV1jUmUZSBpmwDcXc/TathHh+zWMntGjaqE0wVyJbVQxZx
   VioCAwigmqeWDU2rXlOWgysz20uOmE7JlS+s8eZuLFbMxNCSKQ/UhTeaA
   8LJm6G+9rY9Xnc07zHXM5QLEWcXwX5rcbz0rVmowbCdrtQ9vXn1Ob81K/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="690760"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="690760"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 22:02:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="861640297"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="861640297"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 22:02:40 -0800
Message-ID: <11b3ce61-2f1c-436c-840f-b07de123b2f5@linux.intel.com>
Date: Tue, 5 Dec 2023 14:02:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 002/116] KVM: x86/vmx: initialize loaded_vmcss_on_cpu
 in vmx_hardware_setup()
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <2909211f19ff00fccbfeb9dee396a891384333f2.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2909211f19ff00fccbfeb9dee396a891384333f2.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> vmx_hardware_disable() accesses loaded_vmcss_on_cpu via
> hardware_disable_all().  To allow hardware_enable/disable_all() before
> kvm_init(), initialize it in vmx_hardware_setup() so that tdx module
> initialization, hardware_setup method, can reference the variable.

In patch 004/116, vmx_init() and kvm_x86_vendor_init()  are re-ordered,
tdx_hardware_setup() will be called after vmx_init(), the change of
this patch seems meaningless after patch 004/116.


>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0e081c964e7a..0f3769cc3741 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8263,8 +8263,12 @@ __init int vmx_hardware_setup(void)
>   {
>   	unsigned long host_bndcfgs;
>   	struct desc_ptr dt;
> +	int cpu;
>   	int r;
>   
> +	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> +	for_each_possible_cpu(cpu)
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
>   	store_idt(&dt);
>   	host_idt_base = dt.address;
>   
> @@ -8507,11 +8511,8 @@ static int __init vmx_init(void)
>   	if (r)
>   		goto err_l1d_flush;
>   
> -	for_each_possible_cpu(cpu) {
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> +	for_each_possible_cpu(cpu)
>   		pi_init_cpu(cpu);
> -	}
>   
>   	cpu_emergency_register_virt_callback(vmx_emergency_disable);
>   


