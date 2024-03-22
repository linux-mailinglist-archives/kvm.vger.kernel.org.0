Return-Path: <kvm+bounces-12534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BFA48875A7
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 00:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A83041F24071
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759CC8289D;
	Fri, 22 Mar 2024 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bhblLiS8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0347EF05;
	Fri, 22 Mar 2024 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711149441; cv=none; b=HjFcf1f0NDwo1p712XPowFYNaahMIc4CNh+lJR9CZqZKGZ9V106VjnNh0x4/F99DvzHSSyVjdWdcb+HvZOFHC8Y3KXbavExLewxpr51o8W+NXzLqe4lJPsweXoAhf2hRRnVL28uGey9DiwgBAdrb9cR8f/aGJoVdyC716Dgxq3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711149441; c=relaxed/simple;
	bh=mwi63PZvRXJE5Atl2NAfpEPXg2Vt4KK6GsWoh7D5XNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCiEWa8y90kGMKPGTMsfDCvQrENmMlChuCOwukgMMXcPH2erAM1+oB0ZgXM5pR/plsgct0s9hIGmAP9g87dbs/sh3Qd207mwA9xflE1i/l3V8VTVigXE8dZycXhgXNuNGAWKVFJxmiP1mM8JLJy9i0wXyl1aov8GrOWIFZgCe1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bhblLiS8; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711149440; x=1742685440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mwi63PZvRXJE5Atl2NAfpEPXg2Vt4KK6GsWoh7D5XNE=;
  b=bhblLiS8XCh4XtmTH4I7eWpOKEVN4ptifo2B4yXCbU7wRLFUpiQyDT7D
   TGKpZKhFb1C/a/lKb0Y3SG2wUtHufboVI/29An/NnyPQ8GRjoM7RszOLB
   Kv56uxTuTY/sVy3t0IkWiPkXCWH6P5XiCYYFZ5/iJc5AGmoXP+sKW3Rnt
   s8SL5k6wpQjMJfqtMwtLPyq5N3x4PDSkHe40ExBnTPzJVc+G8jryinlkQ
   WxbR/9H3d7gWUKM7xCKVb126ac4+nYK9YpmuDSoC7XndENuQ7keqZbZzJ
   WWRFpWA8bCS5VpiWTUL/Aq4u2YiVXMt9J4SoRfz9SiVplPjKcHaNczUa0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="9990094"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="9990094"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:17:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15065240"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:17:19 -0700
Date: Fri, 22 Mar 2024 16:17:18 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <20240322231718.GE1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <20240322070635.jwqlqzo2x2ddf5c3@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240322070635.jwqlqzo2x2ddf5c3@yy-desk-7060>

On Fri, Mar 22, 2024 at 03:06:35PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:25:29AM -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Define architectural definitions for KVM to issue the TDX SEAMCALLs.
> >
> > Structures and values that are architecturally defined in the TDX module
> > specifications the chapter of ABI Reference.
> >
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > ---
> > v19:
> > - drop tdvmcall constants by Xiaoyao
> >
> > v18:
> > - Add metadata field id
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx_arch.h | 265 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 265 insertions(+)
> >  create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
> >
> > diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> > new file mode 100644
> > index 000000000000..e2c1a6f429d7
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx_arch.h
> > @@ -0,0 +1,265 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* architectural constants/data definitions for TDX SEAMCALLs */
> > +
> > +#ifndef __KVM_X86_TDX_ARCH_H
> > +#define __KVM_X86_TDX_ARCH_H
> > +
> > +#include <linux/types.h>
> > +
> > +/*
> > + * TDX SEAMCALL API function leaves
> > + */
> > +#define TDH_VP_ENTER			0
> > +#define TDH_MNG_ADDCX			1
> > +#define TDH_MEM_PAGE_ADD		2
> > +#define TDH_MEM_SEPT_ADD		3
> > +#define TDH_VP_ADDCX			4
> > +#define TDH_MEM_PAGE_RELOCATE		5
> > +#define TDH_MEM_PAGE_AUG		6
> > +#define TDH_MEM_RANGE_BLOCK		7
> > +#define TDH_MNG_KEY_CONFIG		8
> > +#define TDH_MNG_CREATE			9
> > +#define TDH_VP_CREATE			10
> > +#define TDH_MNG_RD			11
> > +#define TDH_MR_EXTEND			16
> > +#define TDH_MR_FINALIZE			17
> > +#define TDH_VP_FLUSH			18
> > +#define TDH_MNG_VPFLUSHDONE		19
> > +#define TDH_MNG_KEY_FREEID		20
> > +#define TDH_MNG_INIT			21
> > +#define TDH_VP_INIT			22
> > +#define TDH_MEM_SEPT_RD			25
> > +#define TDH_VP_RD			26
> > +#define TDH_MNG_KEY_RECLAIMID		27
> > +#define TDH_PHYMEM_PAGE_RECLAIM		28
> > +#define TDH_MEM_PAGE_REMOVE		29
> > +#define TDH_MEM_SEPT_REMOVE		30
> > +#define TDH_SYS_RD			34
> > +#define TDH_MEM_TRACK			38
> > +#define TDH_MEM_RANGE_UNBLOCK		39
> > +#define TDH_PHYMEM_CACHE_WB		40
> > +#define TDH_PHYMEM_PAGE_WBINVD		41
> > +#define TDH_VP_WR			43
> > +#define TDH_SYS_LP_SHUTDOWN		44
> > +
> > +/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
> > +#define TDX_NON_ARCH			BIT_ULL(63)
> > +#define TDX_CLASS_SHIFT			56
> > +#define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
> > +
> > +#define __BUILD_TDX_FIELD(non_arch, class, field)	\
> > +	(((non_arch) ? TDX_NON_ARCH : 0) |		\
> > +	 ((u64)(class) << TDX_CLASS_SHIFT) |		\
> > +	 ((u64)(field) & TDX_FIELD_MASK))
> > +
> > +#define BUILD_TDX_FIELD(class, field)			\
> > +	__BUILD_TDX_FIELD(false, (class), (field))
> > +
> > +#define BUILD_TDX_FIELD_NON_ARCH(class, field)		\
> > +	__BUILD_TDX_FIELD(true, (class), (field))
> > +
> > +
> > +/* Class code for TD */
> > +#define TD_CLASS_EXECUTION_CONTROLS	17ULL
> > +
> > +/* Class code for TDVPS */
> > +#define TDVPS_CLASS_VMCS		0ULL
> > +#define TDVPS_CLASS_GUEST_GPR		16ULL
> > +#define TDVPS_CLASS_OTHER_GUEST		17ULL
> > +#define TDVPS_CLASS_MANAGEMENT		32ULL
> > +
> > +enum tdx_tdcs_execution_control {
> > +	TD_TDCS_EXEC_TSC_OFFSET = 10,
> > +};
> > +
> > +/* @field is any of enum tdx_tdcs_execution_control */
> > +#define TDCS_EXEC(field)		BUILD_TDX_FIELD(TD_CLASS_EXECUTION_CONTROLS, (field))
> > +
> > +/* @field is the VMCS field encoding */
> > +#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(TDVPS_CLASS_VMCS, (field))
> > +
> > +enum tdx_vcpu_guest_other_state {
> > +	TD_VCPU_STATE_DETAILS_NON_ARCH = 0x100,
> > +};
> > +
> > +union tdx_vcpu_state_details {
> > +	struct {
> > +		u64 vmxip	: 1;
> > +		u64 reserved	: 63;
> > +	};
> > +	u64 full;
> > +};
> > +
> > +/* @field is any of enum tdx_guest_other_state */
> > +#define TDVPS_STATE(field)		BUILD_TDX_FIELD(TDVPS_CLASS_OTHER_GUEST, (field))
> > +#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(TDVPS_CLASS_OTHER_GUEST, (field))
> > +
> > +/* Management class fields */
> > +enum tdx_vcpu_guest_management {
> > +	TD_VCPU_PEND_NMI = 11,
> > +};
> > +
> > +/* @field is any of enum tdx_vcpu_guest_management */
> > +#define TDVPS_MANAGEMENT(field)		BUILD_TDX_FIELD(TDVPS_CLASS_MANAGEMENT, (field))
> > +
> > +#define TDX_EXTENDMR_CHUNKSIZE		256
> > +
> > +struct tdx_cpuid_value {
> > +	u32 eax;
> > +	u32 ebx;
> > +	u32 ecx;
> > +	u32 edx;
> > +} __packed;
> > +
> > +#define TDX_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
> 
> This series doesn't really touch off-TD things, so you can remove this.

Yes. I'll clean up to delete unused ones including this.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

