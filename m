Return-Path: <kvm+bounces-58375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DBA3B8FBDF
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9B9417F69C
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE2D2877F6;
	Mon, 22 Sep 2025 09:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cGuj6X8q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FF2287244;
	Mon, 22 Sep 2025 09:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758533016; cv=none; b=j3+GETnQMqqaqIkItPY8pv3IvXm5U8rTeMLPz51x+tUqTJIDxRlSk8es+fUkbxhSQSb6ZDL5qcfoVZNun6MsT29TsMfXrc+rIRoiTVpEyLjI97Z0fniJHnBCELu6qxPy0HNPLEX1O1OT6qplEz9/YSfCZ1JF0f2Ufx/jYBcDi6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758533016; c=relaxed/simple;
	bh=lZH1GR3SVwh/Vbb9I019CLouzGZxVHUPSKq2vlxMm3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E55+NYWR2tkCNXkBKI4JHC03X0nN7fy/iOGg6TpJu54rW39yP4wU6rx/4J99TJud6GWVdLIXhklVL56iKfqmgkrS63iMbm0nvhsn10dp2PmjsLmAdIskfRPSYUYjd1ZA7GkUwlYO/28m9v2x/7JcIta9luSsNeyR+Qj2q02tNlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cGuj6X8q; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758533015; x=1790069015;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lZH1GR3SVwh/Vbb9I019CLouzGZxVHUPSKq2vlxMm3s=;
  b=cGuj6X8qYYbtU4LDdqvMOzToypQLu74xw0sBA97TwHvievhMCos/+Irj
   +p75g930g8QMq5NA6u4jkYusrzM2xrqf0v+MDVlCkqXxc5aZdj626BHay
   WbDAk2Rs4rL9ld1248xhJ20GYacpAfa18SLIiw+QSi3mtlHAq/zbNOF6W
   1XUFbs03c82B1gqxvh5zfHDR4KDEz8LDe7VccsANX7Ilp7S5BPoWdUQge
   9SD7m3CviJ9wEROR1i5qqsoG/rNTMATP9yrycy73hgkR+EP1Cfq0CekOo
   cJmTcWLr4XoNWNO82VSLDY2j1Lz33DZZEmYcV/XqAuzlVBW2SQVe6h3rT
   w==;
X-CSE-ConnectionGUID: ndhlF0ENRr2b3KfObWBs7w==
X-CSE-MsgGUID: JeBPd2HNR5a923VK9qYJ6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64594712"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64594712"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 02:23:34 -0700
X-CSE-ConnectionGUID: BH/ghJKXTFGb4OfhA0JrQg==
X-CSE-MsgGUID: 8wx/DjSgQ4mmpW08CHHK8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175568862"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 02:23:31 -0700
Message-ID: <4f59ec69-15fd-4463-86c9-17491afd8eca@linux.intel.com>
Date: Mon, 22 Sep 2025 17:23:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 33/51] KVM: nVMX: Add consistency checks for CET
 states
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-34-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-34-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Chao Gao <chao.gao@intel.com>
>
> Introduce consistency checks for CET states during nested VM-entry.
>
> A VMCS contains both guest and host CET states, each comprising the
> IA32_S_CET MSR, SSP, and IA32_INTERRUPT_SSP_TABLE_ADDR MSR. Various
> checks are applied to CET states during VM-entry as documented in SDM
> Vol3 Chapter "VM ENTRIES". Implement all these checks during nested
> VM-entry to emulate the architectural behavior.
>
> In summary, there are three kinds of checks on guest/host CET states
> during VM-entry:
>
> A. Checks applied to both guest states and host states:
>
>   * The IA32_S_CET field must not set any reserved bits; bits 10 (SUPPRESS)
>     and 11 (TRACKER) cannot both be set.
>   * SSP should not have bits 1:0 set.
>   * The IA32_INTERRUPT_SSP_TABLE_ADDR field must be canonical.
>
> B. Checks applied to host states only
>
>   * IA32_S_CET MSR and SSP must be canonical if the CPU enters 64-bit mode
>     after VM-exit. Otherwise, IA32_S_CET and SSP must have their higher 32
>     bits cleared.
>
> C. Checks applied to guest states only:
>
>   * IA32_S_CET MSR and SSP are not required to be canonical (i.e., 63:N-1
>     are identical, where N is the CPU's maximum linear-address width). But,
>     bits 63:N of SSP must be identical.
>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

> ---
>   arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 51c50ce9e011..024bfb4d3a72 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3100,6 +3100,17 @@ static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)
>   	return !__is_canonical_address(la, l1_address_bits_on_exit);
>   }
>   
> +static bool is_valid_cet_state(struct kvm_vcpu *vcpu, u64 s_cet, u64 ssp, u64 ssp_tbl)
> +{
> +	if (!kvm_is_valid_u_s_cet(vcpu, s_cet) || !IS_ALIGNED(ssp, 4))
> +		return false;
> +
> +	if (is_noncanonical_msr_address(ssp_tbl, vcpu))
> +		return false;
> +
> +	return true;
> +}

Nit:

Is the following simpler?

index a8a421a8e766..17ba37c2bbfc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3102,13 +3102,8 @@ static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)

  static bool is_valid_cet_state(struct kvm_vcpu *vcpu, u64 s_cet, u64 ssp, u64 ssp_tbl)
  {
-       if (!kvm_is_valid_u_s_cet(vcpu, s_cet) || !IS_ALIGNED(ssp, 4))
-               return false;
-
-       if (is_noncanonical_msr_address(ssp_tbl, vcpu))
-               return false;
-
-       return true;
+       return (kvm_is_valid_u_s_cet(vcpu, s_cet) && IS_ALIGNED(ssp, 4) &&
+               !is_noncanonical_msr_address(ssp_tbl, vcpu));
  }

