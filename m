Return-Path: <kvm+bounces-7532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B77B68437D7
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:28:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 737D4284308
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DB35813B;
	Wed, 31 Jan 2024 07:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RK7HR50b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24014F608;
	Wed, 31 Jan 2024 07:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706685766; cv=none; b=aRBGSLBg7kPDhw7VbmsnjJgDWwUHSOcwt9S2s1J+xSOV1wRJgo/6joDcvUBh7JfvZWTHtRAEtPb38ZWfQvtgCTfujRADwCY1aM+gs2pdnhjUP/fBEp/deHY54NJQtMxDBJyZOM8TnwJ1mFNfliN2QHG+fd5XT7yKLbOPC68IeR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706685766; c=relaxed/simple;
	bh=UUE+/VJXlKc4HQKfxBesRIPvkbX3DupU4onjGeqAeHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+fv9/W3Msj41GYDaANDgU7XmuE2MWlMqClcHi+Bk3n4k9EPsx6jptzOSRWktdGBRoEjS5tlsPFZ/O+mkgTxRnJj7QpXx323fYGsaDSDSl58Qs+fmx/uf31b7CGHPbk5s36/QEZ3QDpluhxmmuyh2JZLKHNJOWILFB2Xo6vWy3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RK7HR50b; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706685765; x=1738221765;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UUE+/VJXlKc4HQKfxBesRIPvkbX3DupU4onjGeqAeHI=;
  b=RK7HR50bOjXsY4ogRtK6+RkHNMoHs36zAC+hV9zeuM4p9a7NkXccwvZ1
   X/KpSXKiVvAOcCxDoSiGdzeCUPIZp3biDYJynfxAbLPqUhho0Sipt1Pup
   0+vMXL97L4L/RpsfuZS9KLPumiRhqu1gA9hKDL6JkCGTLVBxe75GJC5a1
   sv2c6mLn4xD81Opngm9n+gnh01NqgNhkHiA/5ph0M8Y7+2MPI6ZyZIMFF
   DAiYwHO3PLXGd58Ca7m882XvjOrqOB2KdPOCBkYtOge6APKusDGWFhBBV
   mWfLupZIclrEVt8PSrMh4z2/vhuc1b7LhqLilgkU8NEubaWEAPjRUCu4+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3359615"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="3359615"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 23:22:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="788484430"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="788484430"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 30 Jan 2024 23:22:39 -0800
Date: Wed, 31 Jan 2024 15:22:39 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v18 013/121] KVM: TDX: Add TDX "architectural" error codes
Message-ID: <20240131072239.wirjxijv7kumy3g4@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <212f22ed28e43c016607e3c420d7d98910878007.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <212f22ed28e43c016607e3c420d7d98910878007.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:49PM -0800, isaku.yamahata@intel.com wrote:
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
>  arch/x86/kvm/vmx/tdx_errno.h | 43 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
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

Looks these 2 TDX_EPT_xx are not used, so can remove them.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> +#define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
> +
> +/*
> + * TDG.VP.VMCALL Status Codes (returned in R10)
> + */
> +#define TDG_VP_VMCALL_SUCCESS			0x0000000000000000ULL
> +#define TDG_VP_VMCALL_RETRY			0x0000000000000001ULL
> +#define TDG_VP_VMCALL_INVALID_OPERAND		0x8000000000000000ULL
> +#define TDG_VP_VMCALL_TDREPORT_FAILED		0x8000000000000001ULL
> +
> +/*
> + * TDX module operand ID, appears in 31:0 part of error code as
> + * detail information
> + */
> +#define TDX_OPERAND_ID_RCX			0x01
> +#define TDX_OPERAND_ID_SEPT			0x92
> +#define TDX_OPERAND_ID_TD_EPOCH			0xa9
> +
> +#endif /* __KVM_X86_TDX_ERRNO_H */
> --
> 2.25.1
>
>

