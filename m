Return-Path: <kvm+bounces-60269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 61748BE6292
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 04:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 09F7D4E429E
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413232580F3;
	Fri, 17 Oct 2025 02:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e3a/Yplt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F4250BEC;
	Fri, 17 Oct 2025 02:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760669599; cv=none; b=Qm2XCLgbLcdRVbMnMRqh8238n7DmKiqvLoZfzt7SGqEB5SSUWAvZMyFRZgngwqsidrktp/MdmQv3r7KrbqvD2qMaeXRn/CU+s1jKTEKAtWgXo7eHy+cxzAShZYzZPvDnrGRcs4YwZLqinoLOj6lymq4ocLtOVoQaK3rYAz333eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760669599; c=relaxed/simple;
	bh=ZdEdt0spzcNWkaPUCAO/o/SMxFDm8mn1uhO4DlKyYuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BiEE8CAW8h9rQOTV6PxiO4kb8jn+lYj/0ieTlXvUVAliu7rHbKA18fQi38rWUXGS72AfjvlGucn+469wnPrb9M0HtW50pqph+XMTGs/hJbg0IKs1YclLz/Aw0utNWJ35B+9gsEH0E7LOWkLHFoEBSvuu9TfOCuTwyxsau9abGxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e3a/Yplt; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760669598; x=1792205598;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZdEdt0spzcNWkaPUCAO/o/SMxFDm8mn1uhO4DlKyYuM=;
  b=e3a/Yplt8duIzDBWHw/MdFkiscWueGgBaTypfR77uuFPUUdjs+Q6mf06
   bBI1TIN11MiOFM98x+5YP+7aQ0YN/mcGrEhkD1SgX3HIeTJ6BF8zmrlv7
   ifmeliND/Kw1Hh9xrtjN8J05PN/EJclATmJ1MUzNuuPubF5zh9V54iQYH
   WL/4aA+n+uAZP1CQdlUQLbsb5S5YToxaTBbOmsPvqi4kCJMls8U7fJKOz
   r/UuMvZ8BEjmTJpgDSuh5dN0GV+MDTZ4Lsl/7a5m1oPmB9KF0xwq7XO6O
   +angFMSPc71HKIn6LwUrmMPuQ7EjIQj1ffV12s9oFab97XW0AMiXgxbPX
   Q==;
X-CSE-ConnectionGUID: kl5T1FK4SxCVYVsfpiS95Q==
X-CSE-MsgGUID: GeTvgsH4T62F2eG7YgLb5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62910549"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62910549"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 19:53:17 -0700
X-CSE-ConnectionGUID: NclHgfIqTFaCu79SwIhfXA==
X-CSE-MsgGUID: eilQ7ZZtT363yO8pnBS2VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="187016503"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 19:53:15 -0700
Message-ID: <690f2f8d-8533-4b54-adbe-206c0e06da51@intel.com>
Date: Fri, 17 Oct 2025 10:53:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
 <20251016182148.69085-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251016182148.69085-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/17/2025 2:21 AM, Sean Christopherson wrote:
> Add VMX exit handlers for SEAMCALL and TDCALL to inject a #UD if a non-TD
> guest attempts to execute SEAMCALL or TDCALL.  Neither SEAMCALL nor TDCALL
> is gated by any software enablement other than VMXON, and so will generate
> a VM-Exit instead of e.g. a native #UD when executed from the guest kernel.
> 
> Note!  No unprivileged DoS of the L1 kernel is possible as TDCALL and
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
> Note #3!  The aforementioned Trust Domain spec uses confusing pseudocode
> that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
> specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
> form description explicitly states that SEAMCALL generates an exit when
> executed in "SEAM VMX non-root operation".  But that's a moot point as the
> TDX-Module injects #UD if the guest attempts to execute SEAMCALL, as
> documented in the "Unconditionally Blocked Instructions" section of the
> TDX-Module base specification.
> 
> Cc: stable@vger.kernel.org
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/uapi/asm/vmx.h | 1 +
>   arch/x86/kvm/vmx/nested.c       | 8 ++++++++
>   arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
>   3 files changed, 17 insertions(+)
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
> index 76271962cb70..bcea087b642f 100644
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
> +		return false;
>   	default:
>   		return true;
>   	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 546272a5d34d..d1b34b7ca4a3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6033,6 +6033,12 @@ static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int handle_tdx_instruction(struct kvm_vcpu *vcpu)
> +{
> +	kvm_queue_exception(vcpu, UD_VECTOR);
> +	return 1;
> +}
> +
>   #ifndef CONFIG_X86_SGX_KVM
>   static int handle_encls(struct kvm_vcpu *vcpu)
>   {
> @@ -6158,6 +6164,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>   	[EXIT_REASON_ENCLS]		      = handle_encls,
>   	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
>   	[EXIT_REASON_NOTIFY]		      = handle_notify,
> +	[EXIT_REASON_SEAMCALL]		      = handle_tdx_instruction,
> +	[EXIT_REASON_TDCALL]		      = handle_tdx_instruction,
>   	[EXIT_REASON_MSR_READ_IMM]            = handle_rdmsr_imm,
>   	[EXIT_REASON_MSR_WRITE_IMM]           = handle_wrmsr_imm,
>   };


