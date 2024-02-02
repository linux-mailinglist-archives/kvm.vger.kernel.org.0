Return-Path: <kvm+bounces-7826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8258846A1D
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C93F1F2AB88
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110EE17C67;
	Fri,  2 Feb 2024 08:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UBttLn8v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC9E17C64;
	Fri,  2 Feb 2024 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706861069; cv=none; b=YnJEciWZYtPlGXhe6B7MESYHMYb/NkKZuLS0jxOer/fAkNDt1dI3JXTqXeTKZsBKyAJ/AamT+Tt+W2epsMuJ6RlldHNM4gAngSR9SC778gs7IFFYnWK9OLmUrVpkA2pjwkmTVUxHzh7hHi2aEg0urx0ro2ni7eaeGjEWjweGZ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706861069; c=relaxed/simple;
	bh=vn1Uy7iLyuBoZC2jtSRfxjt5sl8GxyEeXddLMX+BM7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZ5nriDFjG67VlWjUede0ETq/wCXe2dpiWR16Fk1DGrcn1Q5YoIzOoCmBbyeOQMJcRQp5wkzfD4VzPIVRZDMljCRNRod8XQsEzu0D5pTCkKXyV+dbHF29ykiut18KioHoLwZtkdJ4eo9Hrn/Frgge1jz5VxQeVIDKMV8ENyY3kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UBttLn8v; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706861068; x=1738397068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vn1Uy7iLyuBoZC2jtSRfxjt5sl8GxyEeXddLMX+BM7s=;
  b=UBttLn8vRLNhj50s9wsLyFXzIlmT3nI0a4IuVsERvdkPluq4a9bED7T1
   YQMqaCrK/B1Wf+nYcZjI+qIeJFsAClqxmDBtjIl+TGW5sjOoQ5I+50wPI
   i6yNYAD5c65QeWbr1YrFWK/oCqbzec8F/HLS3shXdY7dYGwY36+keriCV
   Dh8khYnM+XUvXW2dm+VLVXeVqteKKarzkuxLTBvXCam2nAw+5mu5i9vUx
   DDbMVsysWaddeOdKuCUTZI1b67BSYMpvbzMiD+ADOo8sHPGZ2tybVK0TO
   2q+emsFgl7txjVOeGEVyX0xQyMlVSiJnU5VipTnztuoV+NWVKkIKwHx5e
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="3959696"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="3959696"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 00:04:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="962145227"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="962145227"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 00:04:22 -0800
Message-ID: <2e174040-933d-4f54-b5fb-380411b53355@intel.com>
Date: Fri, 2 Feb 2024 16:04:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 013/121] KVM: TDX: Add TDX "architectural" error codes
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <212f22ed28e43c016607e3c420d7d98910878007.1705965634.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <212f22ed28e43c016607e3c420d7d98910878007.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
> SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
> SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
> guest and may return an error.  So error code for the TDX guest is also
> needed.
> 
> TDX SEAMCALL uses bits 31:0 to return more information, so these error
> codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
> defined by TDX Guest-Host-Communication interface spec.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx_errno.h | 43 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
> 
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> new file mode 100644
> index 000000000000..7f96696b8e7c
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -0,0 +1,43 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* architectural status code for SEAMCALL */
> +
> +#ifndef __KVM_X86_TDX_ERRNO_H
> +#define __KVM_X86_TDX_ERRNO_H
> +
> +#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
> +
> +/*
> + * TDX SEAMCALL Status Codes (returned in RAX)
> + */
> +#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
> +#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
> +#define TDX_OPERAND_INVALID			0xC000010000000000ULL
> +#define TDX_OPERAND_BUSY			0x8000020000000000ULL
> +#define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
> +#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
> +#define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
> +#define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
> +#define TDX_KEY_CONFIGURED			0x0000081500000000ULL
> +#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
> +#define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
> +#define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
> +#define TDX_EPT_ENTRY_NOT_FREE			0xC0000B0200000000ULL
> +#define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
> +
> +/*
> + * TDG.VP.VMCALL Status Codes (returned in R10)
> + */
> +#define TDG_VP_VMCALL_SUCCESS			0x0000000000000000ULL
> +#define TDG_VP_VMCALL_RETRY			0x0000000000000001ULL
> +#define TDG_VP_VMCALL_INVALID_OPERAND		0x8000000000000000ULL
> +#define TDG_VP_VMCALL_TDREPORT_FAILED		0x8000000000000001ULL

Same to previous Patch:

These should be put in some shared header file, because they are shared 
with guest TD code.

Other than it,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> +/*
> + * TDX module operand ID, appears in 31:0 part of error code as
> + * detail information
> + */
> +#define TDX_OPERAND_ID_RCX			0x01
> +#define TDX_OPERAND_ID_SEPT			0x92
> +#define TDX_OPERAND_ID_TD_EPOCH			0xa9
> +
> +#endif /* __KVM_X86_TDX_ERRNO_H */


