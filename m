Return-Path: <kvm+bounces-60989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E70EC04C32
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 09:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1288C4F89C7
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 07:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599F12E9ED1;
	Fri, 24 Oct 2025 07:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g9m4xaHZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD402E7F20;
	Fri, 24 Oct 2025 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761291538; cv=none; b=oYR5FwHuiXBOHX/U60FsawRGxTC6z4WJg56dqs1sZOBynRuJO0XPMfaI/bxlRPXOBmYiXUGyiY4XU1iBvhmz6EJBdVZhXB3/TCV42CyknJJ+lMudDQddVhvS86mW1+c9Z8sJLhyDjY623sjGswLi6BorhbyC7OstIGBKMBaVFts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761291538; c=relaxed/simple;
	bh=mqrmnotooRW9zCLkNbwsBqACdnSVp7ozY0nJzWJwIdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DKb3ky07s3vqmtGYVAKlfFZjVxE+DmJO29NRjp0ls9ggxzwYfYtIunniU5zeulRHYbLVhqTCTq08wBCh8n7zw5z/xTNcWPUDE8XqgTpzNeqCFbyvzx/2AhamajAfuJrilZ8iwVyTB2oZRB6QoG1QgDmRWrq6fdMcaJyLTlGgIIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g9m4xaHZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761291536; x=1792827536;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mqrmnotooRW9zCLkNbwsBqACdnSVp7ozY0nJzWJwIdI=;
  b=g9m4xaHZtgFSSKDog/5LAykfm5/SE0sochHhx0j9i0xw9RawwykFwP0K
   V6+Z20SalskrBvSMt/01crt9R4cvk26NMJK2g1hU6Ibu/UBxtj3+q9Zoy
   eGW60wAWIUU2jljDG4fLA8FPwprMq0+fmNIXvY4fvp7+Ek+uRNZ4Uuss6
   QJZ1nqSdNiZpKsVN9vZeE6QSyWBseOMvX2Pb5ciCYF9w9MAw1xE43EqC4
   viy0hHfONNXdgj/dUg1Qn1Ksg19aHhMfjYIXd9y/U2xEv+wMXzACeoTd7
   qbfe2PVGxiYuNp5PgqCgC70I0PS5Ua6hxAUXa1W20CUw8Ueq7ycTzZj4H
   w==;
X-CSE-ConnectionGUID: qhk/yOFJTIORfyKmVjC/KQ==
X-CSE-MsgGUID: 1Tw6iZNCQEaTuL1rRL/nlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81097445"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="81097445"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 00:38:55 -0700
X-CSE-ConnectionGUID: UxV1qHb2TCSYa+TzbX0Eow==
X-CSE-MsgGUID: EwmjUoGZTCaYHb6B07GYSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="188424583"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.235.70]) ([10.124.235.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 00:38:46 -0700
Message-ID: <5dea4a3d-c7b7-48f0-b2d5-7597e0cd5f00@linux.intel.com>
Date: Fri, 24 Oct 2025 15:38:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/25] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-14-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251017003244.186495-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spte() as
> providing a one-off helper for effectively three lines of code is at best a
> wash, and splitting the code makes the comment for smp_rmb()  _extremely_
> confusing as the comment talks about reading kvm->arch.pre_fault_allowed
> before kvm_tdx->state, but the immediately visible code does the exact
> opposite.
>
> Opportunistically rewrite the comments to more explicitly explain who is
> checking what, as well as _why_ the ordering matters.
>
> No functional change intended.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

[...]
> +	/*
> +	 * If the TD isn't finalized/runnable, then userspace is initializing
> +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> +	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.ADD.
> +	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all mapped pages
                                                                    ^
                                                 Nit: Is pre-mapped better?
> +	 * have been added to the image, to prevent running the TD with a
> +	 * valid mapping in the mirror EPT, but not in the S-EPT.
> +	 */
> +	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
> +		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> +			return -EIO;
> +
> +		atomic64_inc(&kvm_tdx->nr_premapped);
> +		return 0;
> +	}
> +
> +	return tdx_mem_page_aug(kvm, gfn, level, pfn);
>   }
>   
>   static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,


