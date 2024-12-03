Return-Path: <kvm+bounces-32892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6369E1450
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 08:34:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1388AB27BAB
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 07:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2716718BC1D;
	Tue,  3 Dec 2024 07:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5YS6m5w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9776F2500BD;
	Tue,  3 Dec 2024 07:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733211233; cv=none; b=YBl114BRrikImaCavxUKT11yAHaXhYMjijcrez4O/58W/knzv/yRUyh/t/qKWJOpb4HzsKTE1LzyPHAqR32qJtv8ARrbOix+PUHgsbr29Ujk/qgpef7nuHNy15BSV9cu6sNaCdSaPl7ek0TkAbM/cG+mqrkW69lcFyG6Wdjeb/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733211233; c=relaxed/simple;
	bh=69UyLA9eKNgduF7mwJmi9g57ARU2C/orBCmXM84SsPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=utPUWTkKoN01paPeyfwBBNm57wSiZd+l+vNlyulkBO5wkq14zFmyz6JPMiQyGUggJBxJidIQK2P4hgK9NQYOK0RvWLXpINPxoA7tkfcYTFCVAn4Wga6Mfpi1TQs+HDjJcrM5YeujNBepDdjVi5E7pVlExLBxdEpV6VIidfGT3zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5YS6m5w; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733211231; x=1764747231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=69UyLA9eKNgduF7mwJmi9g57ARU2C/orBCmXM84SsPg=;
  b=a5YS6m5wQZFfBLmMLYSgpiCtWORpL8F89qznAOiZuvWMsCoN4UehImR4
   bvEw0lcvOW5cTUpEGkrfdYiHNtmLBsU2Lma5lh/aoCZgB2QFsA5WpxKhX
   hpX9ONuu4j0s2zz9++RCBha8QsDXkmLm41W7eCAHFWOVWgaJGOA7VVo04
   kvsA8+YSoqnhjzIh9dHBefpcMe8bW2XGUDC9L/ceJLYL/I5nMkeN1NZsN
   /yPYBuXKTjNgcRWHlwYXmxDrpaTxSbhn151fpDeOKOdYYOVpxoz45ll3G
   hGPVbb9Ct4OjpRYj/CX6y5wUKNBps8SHvzyvmubksC2bRtAtGOyUhuKXX
   Q==;
X-CSE-ConnectionGUID: ct6UME8GQ9SbsCGR7upguQ==
X-CSE-MsgGUID: W8TXdyzZRyK+zVFBwwF7Xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="32765392"
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="32765392"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 23:33:50 -0800
X-CSE-ConnectionGUID: PcNy7wmIRp6ahGwZ0wA2Ug==
X-CSE-MsgGUID: VhiH70xXSTi1M8Dex6U4XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="130815581"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 23:33:49 -0800
Message-ID: <f8e59acf-1657-46aa-9811-da85adf1d9a9@linux.intel.com>
Date: Tue, 3 Dec 2024 15:33:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] KVM: x86: Move "emulate hypercall" function
 declarations to x86.h
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-4-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241128004344.4072099-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> Move the declarations for the hypercall emulation APIs to x86.h.  While
> the helpers are exported, they are intended to be consumed only KVM vendor
only -> only by

> modules, i.e. don't need to exposed to the kernel at-large.

to exposed -> to be exposed
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 6 ------
>   arch/x86/kvm/x86.h              | 6 ++++++
>   2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e159e44a6a1b..c1251b371421 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2181,12 +2181,6 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>   	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl);
> -int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
> -
>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>   		       void *insn, int insn_len);
>   void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 45dd53284dbd..6db13b696468 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -617,4 +617,10 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>   	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>   }
>   
> +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +				      unsigned long a0, unsigned long a1,
> +				      unsigned long a2, unsigned long a3,
> +				      int op_64_bit, int cpl);
> +int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
> +
>   #endif


