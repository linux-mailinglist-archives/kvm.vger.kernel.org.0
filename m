Return-Path: <kvm+bounces-14118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0632189F328
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8509C1F2A29C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 12:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A9E15B136;
	Wed, 10 Apr 2024 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="en3LnY6d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AC615ADBE;
	Wed, 10 Apr 2024 12:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712753383; cv=none; b=OnSD86CLLyjebAvbAWtgHzM5crdj2WGG96uZ7+MKcVLHRv50U6DL++lOVn05l55IkMkv6jGcAv6uo1qzwExc3QUgRxU+4HgeF+tOdsze6/WLnfAXU7PKbPEOhM930K9zq05+WKz0cTT7hYwiGtP83IBAcgkeH4891Y/PQ1l4Hn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712753383; c=relaxed/simple;
	bh=+IicuqEEwox6mFHc+j1yjm5xJA/SNOjjhb7nYJ5m7Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bavt0mRvF5hikaKHpLQxljK9/2H0vrzPETCsNGzbMPNCCEtrv1TeqRP6eSVpf5z6k562OHOyxGLtFoGnji02muN+PqSvJYw8qpV7may6jLHDWwPP9xnFK/WkRVk3Zm5kO4DrfefCbVpMnsyd9oqjtFkGoHvz/Q7Wa0dQpDsTqM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=en3LnY6d; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712753381; x=1744289381;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+IicuqEEwox6mFHc+j1yjm5xJA/SNOjjhb7nYJ5m7Hc=;
  b=en3LnY6ds243IZNCiTmUUsTrqAB29Ktuuz5xX00WI8sgKFRPI4uSWp3F
   pFVNQuXrDF/HF9QE70wMOvOkjYkaVqk+jB0sA30GXhx6dfeRLNrzsW4r1
   z2JCjiexTgoA6UqIlwKCVyVk6PhqZsrWSUAmb0wEYDbOFQ6519Ah35Jen
   8PhHK6VNGufw693MGXkF6v08KN2rNz7Lgv26qEShB0l3cfwtz+yN3pNLL
   tzQH7wMS7B+0xwiMLRNLwPky8FYq4jxAf5qRE5BquQ5/DGtg93n+2dlD3
   cxfd/DFpjw9t65Dx/LFUIxRyI/Gh7YCzcMhxCKrYrlV7PvqmmTqmACGWZ
   A==;
X-CSE-ConnectionGUID: d7T0toU+TK+uVp7u5Ege1w==
X-CSE-MsgGUID: XnVSDNXkTJCP9jV+WxTRhw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18719872"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18719872"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 05:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="937094934"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="937094934"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 10 Apr 2024 05:49:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 92A6E161; Wed, 10 Apr 2024 15:49:36 +0300 (EEST)
Date: Wed, 10 Apr 2024 15:49:36 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	Erdem Aktas <erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Message-ID: <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
 <ZfR4UHsW_Y1xWFF-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfR4UHsW_Y1xWFF-@google.com>

On Fri, Mar 15, 2024 at 09:33:20AM -0700, Sean Christopherson wrote:
> So my feedback is to not worry about the exports, and instead focus on figuring
> out a way to make the generated code less bloated and easier to read/debug.

I think it was mistake trying to centralize TDCALL/SEAMCALL calls into
few megawrappers. I think we can get better results by shifting leaf
function wrappers into assembly.

We are going to have more assembly, but it should produce better result.
Adding macros can help to write such wrapper and minimizer boilerplate.

Below is an example of how it can look like. It's not complete. I only
converted TDCALLs, but TDVMCALLs or SEAMCALLs. TDVMCALLs are going to be
more complex.

Any opinions? Is it something worth investing more time?

.set offset_rcx,	TDX_MODULE_rcx
.set offset_rdx,	TDX_MODULE_rdx
.set offset_r8,		TDX_MODULE_r8
.set offset_r9,		TDX_MODULE_r9
.set offset_r10,	TDX_MODULE_r10
.set offset_r11,	TDX_MODULE_r11

.macro save_output struct_reg regs:vararg
.irp reg,\regs
	movq	%\reg, offset_\reg(%\struct_reg)
.endr
.endm

.macro tdcall leaf
	movq	\leaf, %rax
	.byte	0x66,0x0f,0x01,0xcc
.endm

.macro tdcall_or_panic leaf
	tdcall	\leaf
	testq	%rax, %rax
	jnz	.Lpanic
.endm

SYM_FUNC_START(tdg_vm_rd)
	FRAME_BEGIN

	xorl	%ecx, %ecx
	movq	%rdi, %rdx

	tdcall_or_panic $TDG_VM_RD

	movq	%r8, %rax

	RET
	FRAME_END
SYM_FUNC_END(tdg_vm_rd)

SYM_FUNC_START(tdg_vm_wr)
	FRAME_BEGIN

	xorl	%ecx, %ecx
	movq	%rsi, %r8
	movq	%rdx, %r9
	movq	%rdi, %rdx

	tdcall_or_panic $TDG_VM_WR

	/* Old value */
	movq	%r8, %rax

	RET
	FRAME_END
SYM_FUNC_END(tdg_vm_wr)

SYM_FUNC_START(tdcs_ctls_set)
	FRAME_BEGIN

	movq	$TDCS_TD_CTLS, %rdx
	xorl	%ecx, %ecx
	movq	%rdi, %r8
	movq	%rdi, %r9

	tdcall $TDG_VM_WR

	testq	%rax, %rax
	setz	%al

	RET
	FRAME_END
SYM_FUNC_END(tdcs_ctls_set)

SYM_FUNC_START(tdg_sys_rd)
	FRAME_BEGIN

	xorl	%ecx, %ecx
	movq	%rdi, %rdx

	tdcall_or_panic $TDG_SYS_RD

	movq	%r8, %rax

	RET
	FRAME_END
SYM_FUNC_END(tdg_sys_rd)

SYM_FUNC_START(tdg_vp_veinfo_get)
	FRAME_BEGIN

	tdcall_or_panic $TDG_VP_VEINFO_GET

	save_output struct_reg=rdi regs=rcx,rdx,r8,r9,r10

	FRAME_END
	RET
SYM_FUNC_END(tdg_vp_veinfo_get)

SYM_FUNC_START(tdg_vp_info)
	FRAME_BEGIN

	tdcall_or_panic $TDG_VP_INFO

	save_output struct_reg=rdi regs=rcx,rdx,r8,r9,r10,r11

	FRAME_END
	RET
SYM_FUNC_END(tdg_vp_info)

SYM_FUNC_START(tdg_mem_page_accept)
	FRAME_BEGIN

	movq	%rdi, %rcx

	tdcall $TDG_MEM_PAGE_ACCEPT

	FRAME_END
	RET
SYM_FUNC_END(tdg_mem_page_accept)

SYM_FUNC_START(tdg_mr_report)
	FRAME_BEGIN

	movq	%rdx, %r8
	movq	%rdi, %rcx
	movq	%rsi, %rdx

	tdcall $TDG_MR_REPORT

	FRAME_END
	RET
SYM_FUNC_END(tdg_mr_report)

.Lpanic:
	ud2
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

