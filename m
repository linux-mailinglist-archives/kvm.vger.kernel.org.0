Return-Path: <kvm+bounces-60070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0450CBDE0B4
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 12:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78B813B1A6A
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 10:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF6B31B831;
	Wed, 15 Oct 2025 10:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C6E4Ie4N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDFA31BC99;
	Wed, 15 Oct 2025 10:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760524608; cv=none; b=hTS2N/BTmrCLjMKOl0MOirFimxhdKsjItChLrR/ujwIoxeHBUWC3pLLTRnW5EauRtP/KO89dCV+OL+zyc5m//v+9Q8hs/uEN54LVAwQq2f3dmIswxh0q624drAozHMaTCaxgBBMJ4CCet1Q8XeiE+PNcmnPMV9Ja+RgazHJ6bys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760524608; c=relaxed/simple;
	bh=fUlSYicpE9MZa5y54+x5r10gV2XnjF5BdKi3VtpBJiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qx6JZnqyfEaCsHntCR/ZdwK2XTyvWfPF68/rw14HanYLSXe8e2/dPHw5Pgv0i/PAfQgJ2kKG15/t2Yfy3HnMue3UpuLVNWDmE+dxY0QnQTICFMENJf82jJD/2AgwU33uSlbYJkFqopNUOeuxH/MW8AvZYko/lYmU4glr+mjPSM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C6E4Ie4N; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760524606; x=1792060606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fUlSYicpE9MZa5y54+x5r10gV2XnjF5BdKi3VtpBJiU=;
  b=C6E4Ie4Nv87jnAXX/f2DYH5MrSfPtDrB+v+MvbSIxrn3VR4xS3/fSUP0
   AWZO/SalnwWSK1twwc94FnX5ehNuOsAIeqBR/vzp22zc0o5cQ5GHs13Mz
   Ix1uFxYp4kTj3qj1so4uW7RK1yPKz3pV8xr59ks8kmEm2bhelhUVOp/2O
   k4Nrgd7qoDZxlEKMZrtgSAbBExmlKw/oDcj9WC8M7tmGafS/kzS7sRjxE
   kbX19Xs0d8rNKTSTm9iniDMAVRd7ig2RnqiePsp2GMdR9TOppH71u9847
   dvXofHz16FLT4G36wd46lSrd9lSPJTHhTHALsYzeMnN9hPQGS71VV6uRX
   Q==;
X-CSE-ConnectionGUID: HP/EhljmTWGsqDQKP0ZFOQ==
X-CSE-MsgGUID: Q8OzLJvjRGyhHjxLshkSYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="66348956"
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="66348956"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 03:36:45 -0700
X-CSE-ConnectionGUID: n9Wl9IVaRV6cuJ1TJszFWA==
X-CSE-MsgGUID: RNSe2GrQQAucs//U4DLnOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="182132717"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 03:36:42 -0700
Message-ID: <b12f4ba6-bf52-4378-a107-f519eb575281@intel.com>
Date: Wed, 15 Oct 2025 18:36:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20251014231042.1399849-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251014231042.1399849-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/15/2025 7:10 AM, Sean Christopherson wrote:
> Add VMX exit handlers for SEAMCALL and TDCALL, and a SEAMCALL handler for
> TDX, to inject a #UD if a non-TD guest attempts to execute SEAMCALL or
> TDCALL, or if a TD guest attempst to execute SEAMCALL.  

> Neither SEAMCALL
> nor TDCALL is gated by any software enablement other than VMXON, and so
> will generate a VM-Exit instead of e.g. a native #UD when executed from
> the guest kernel.

It's true only on the hardware with SEAM support.

On older hardware without SEAM support, SEAMCALL/TDCALL gets native #UD.

> Note!  No unprivilege DoS of the L1 kernel is possible as TDCALL and
> SEAMCALL #GP at CPL > 0, and the CPL check is performed prior to the VMX
> non-root (VM-Exit) check, i.e. userspace can't crash the VM. And for a
> nested guest, KVM forwards unknown exits to L1, i.e. an L2 kernel can
> crash itself, but not L1.
> 
> Note #2!  The Intel® Trust Domain CPU Architectural Extensions spec's
> pseudocode shows the CPL > 0 check for SEAMCALL coming _after_ the VM-Exit,
> but that appears to be a documentation bug (likely because the CPL > 0
> check was incorrectly bundled with other lower-priority #GP checks).
> Testing on SPR and EMR shows that the CPL > 0 check is performed before
> the VMX non-root check, i.e. SEAMCALL #GPs when executed in usermode.
> 
> Note #3!  The aforementioned Trust Domain spec uses confusing pseudocde
> that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
> specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
> form description explicitly states that SEAMCALL generates an exit when
> executed in "SEAM VMX non-root operation".
> 
> Cc: stable@vger.kernel.org
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/uapi/asm/vmx.h | 1 +
>   arch/x86/kvm/vmx/nested.c       | 8 ++++++++
>   arch/x86/kvm/vmx/tdx.c          | 3 +++
>   arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
>   4 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index 9792e329343e..1baa86dfe029 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -93,6 +93,7 @@
>   #define EXIT_REASON_TPAUSE              68
>   #define EXIT_REASON_BUS_LOCK            74
>   #define EXIT_REASON_NOTIFY              75
> +#define EXIT_REASON_SEAMCALL            76
>   #define EXIT_REASON_TDCALL              77
>   #define EXIT_REASON_MSR_READ_IMM        84
>   #define EXIT_REASON_MSR_WRITE_IMM       85
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 76271962cb70..f64a1eb241b6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>   	case EXIT_REASON_NOTIFY:
>   		/* Notify VM exit is not exposed to L1 */
>   		return false;
> +	case EXIT_REASON_SEAMCALL:
> +	case EXIT_REASON_TDCALL:
> +		/*
> +		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
> +		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
> +		 * never want or expect such an exit.
> +		 */

The i.e. part is confusing? It is exactly forwarding the EXITs to L1, 
while it says L1 should never want or expect such an exit.

> +		return true;
>   	default:
>   		return true;
>   	}



