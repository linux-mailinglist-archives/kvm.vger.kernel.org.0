Return-Path: <kvm+bounces-6888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F6083B64A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 01:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5D71C22FC6
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 00:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F6317EF;
	Thu, 25 Jan 2024 00:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ewNVnbA7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E28C193;
	Thu, 25 Jan 2024 00:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706144276; cv=none; b=Ho0t1c0EaxGO/RllcGkLLWpixkCcncDepr5St4Y3VB0kcd5PZxiGR+CP3q+5BNzYuW8tFLEawGpme4kKMBXAa6XqOumL526n9xrQUBot+kkpP/ErTBFZC29nOnvB45+xQlmUMUDZFSQHq759dghAP6deYoJDEyKhgZnRUgyf2sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706144276; c=relaxed/simple;
	bh=ooW4EEQBVQlYOcJ+TWB/kkVLUo0DXaIhjEWAqx4cpto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FceyXJKsI1HsuDE+8NcG2NRQXnk2LGEKQHYHqE7EsUudw3ORDbj5b6ZJmEeZ5KESJvTjQnbPdcqSeqWV/HWjQpo/omNBPdP0rv9kwoLIJnH6buSOrRtWZOM3nv0BFK0BGvGuQFJPPP75g5qFE9EruiA4XKmAEWCVwrLs8Qi2frY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ewNVnbA7; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706144274; x=1737680274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ooW4EEQBVQlYOcJ+TWB/kkVLUo0DXaIhjEWAqx4cpto=;
  b=ewNVnbA7cPfVN8B2XZ9oaySGE9LCYAih1SxjbtCLfslylYyqOP1xxqxc
   HM1u4V7Y3kYzdFYRU8ubx0MJSbBzK41myWwyxRtOwBfmlk0DVaFKdxrdB
   kQ6N3i7gDND3lPYiFbK2TIi2bxVK5HpEXHDfzEOJlyOyf+S6Ao6oqM3tX
   nBxl8huIocG8rIaDsHQLkRH7x5MlNrmIRxpklxvBaW9jRmKPI8vsGJ/ic
   X7Vq/qa9BjgIs+2Qp0oIUEvuaxQ8iAUZUKuap4aPBPMwo5igAAy9Ztsar
   FCqm0v+tmg1/zwHYokyl6Uom1mwQuYy1tf+qGxKFRk2ZK184GnNp9IjR5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9128064"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9128064"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 16:57:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="905800230"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="905800230"
Received: from yjiang5-mobl.amr.corp.intel.com (HELO localhost) ([10.212.118.106])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 16:57:51 -0800
Date: Wed, 24 Jan 2024 16:57:50 -0800
From: Yunhong Jiang <yunhong.jiang@linux.intel.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, mlevitsk@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	dedekind1@gmail.com, yuan.yao@intel.com,
	Zheyu Ma <zheyuma97@gmail.com>
Subject: Re: [PATCH v2] KVM: x86: nSVM/nVMX: Fix handling triple fault on RSM
 instruction
Message-ID: <20240125005710.GA8443@yjiang5-mobl.amr.corp.intel.com>
References: <20240123001555.4168188-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123001555.4168188-1-michal.wilczynski@intel.com>

On Tue, Jan 23, 2024 at 02:15:55AM +0200, Michal Wilczynski wrote:
> Syzkaller found a warning triggered in nested_vmx_vmexit().
> vmx->nested.nested_run_pending is non-zero, even though we're in
> nested_vmx_vmexit(). Generally, trying  to cancel a pending entry is
> considered a bug. However in this particular scenario, the kernel
> behavior seems correct.
> 
> Syzkaller scenario:
> 1) Set up VCPU's
> 2) Run some code with KVM_RUN in L2 as a nested guest
> 3) Return from KVM_RUN
> 4) Inject KVM_SMI into the VCPU
> 5) Change the EFER register with KVM_SET_SREGS to value 0x2501
> 6) Run some code on the VCPU using KVM_RUN
> 7) Observe following behavior:
> 
> kvm_smm_transition: vcpu 0: entering SMM, smbase 0x30000
> kvm_entry: vcpu 0, rip 0x8000
> kvm_entry: vcpu 0, rip 0x8000
> kvm_entry: vcpu 0, rip 0x8002
> kvm_smm_transition: vcpu 0: leaving SMM, smbase 0x30000
> kvm_nested_vmenter: rip: 0x0000000000008002 vmcs: 0x0000000000007000
>                     nested_rip: 0x0000000000000000 int_ctl: 0x00000000
> 		    event_inj: 0x00000000 nested_ept=n guest
> 		    cr3: 0x0000000000002000
> kvm_nested_vmexit_inject: reason: TRIPLE_FAULT ext_inf1: 0x0000000000000000
>                           ext_inf2: 0x0000000000000000 ext_int: 0x00000000
> 			  ext_int_err: 0x00000000
> 
> What happened here is an SMI was injected immediately and the handler was
> called at address 0x8000; all is good. Later, an RSM instruction is
> executed in an emulator to return to the nested VM. em_rsm() is called,
> which leads to emulator_leave_smm(). A part of this function calls VMX/SVM
> callback, in this case vmx_leave_smm(). It attempts to set up a pending
> reentry to guest VM by calling nested_vmx_enter_non_root_mode() and sets
> vmx->nested.nested_run_pending to one. Unfortunately, later in
> emulator_leave_smm(), rsm_load_state_64() fails to write invalid EFER to
> the MSR. This results in em_rsm() calling triple_fault callback. At this
> point it's clear that the KVM should call the vmexit, but
> vmx->nested.nested_run_pending is left set to 1.
> 
> Similar flow goes for SVM, as the bug also reproduces on AMD platforms.
> 
> To address this issue, reset the nested_run_pending flag in the
> triple_fault handler. However, it's crucial to note that
> nested_pending_run cannot be cleared in all cases. It should only be
> cleared for the specific instruction requiring hardware VM-Enter to
> complete the emulation, such as RSM. Previously, there were instances
> where KVM prematurely synthesized a triple fault on nested VM-Enter. In
> these cases, it is not appropriate to zero the nested_pending_run.
> 
> To resolve this, introduce a new emulator flag indicating the need for
> HW VM-Enter to complete emulating RSM. Based on this flag, a decision can
> be made in vendor-specific triple fault handlers about whether
> nested_pending_run needs to be cleared.
Would it be ok to move the followed emulator_leave_smm() code into
vmx_leave_smm, before setting nested_run_pending bit? It avoids changing
the generic emulator code.

#ifdef CONFIG_X86_64
        if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
                return rsm_load_state_64(ctxt, &smram.smram64);
        else
#endif
                return rsm_load_state_32(ctxt, &smram.smram32);

--jyh


