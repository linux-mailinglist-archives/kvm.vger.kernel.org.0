Return-Path: <kvm+bounces-47750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F02CAC47A6
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EF433B5A31
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 05:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A731BC07A;
	Tue, 27 May 2025 05:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rp31qdJU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2042F29;
	Tue, 27 May 2025 05:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748323881; cv=none; b=maCO93Y8eEbcU8+t4ohYpEN7m59ajpJAgjMw0ttsYjCQJeUbDHzKSU4Sy5ymgqnFEXHpBsuprDYhnCymy5xe5R/FB6Q9uHgSPk1VdcEA9WlxV9wHs62r4FwkzrY0WydIdrQO2aSZK6m/NbX0h334Kpto5rNTpLwnDjFObDuMFOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748323881; c=relaxed/simple;
	bh=5Now6IaadWLsxbSUmrNOd36MeABQBTNVzr7aeuW41gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CoafkTdvBn91lPZd8yDomxtibkBqtxGMqn9yGwmFUxYxNWsXdmbgCdc+Cd324tKQNy0TP4n2NY5xJ10AmVQjE359JOUlWDGapw5QVjveYT2cG9eGOQOFMGBDPgrT9YQx/p+L5denl7Egz6Edz8NRs7h6D2drjJlrOinFtkAx6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rp31qdJU; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748323879; x=1779859879;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5Now6IaadWLsxbSUmrNOd36MeABQBTNVzr7aeuW41gk=;
  b=Rp31qdJUYa/gy75NxWIl7JcdfWncpyI7vineNTrRDdaTsMxAWLW/IhP3
   2GFOhFdnFar8uN8F8vL/tJdVx7jStcXD6ACx4oozt+i06Hlhl/ymEjHnq
   3Zz0z/JwZhp5lPZsnJi/hsd3N1oXAVgV4iKd/6F19tj9oTvvmDAKY9jf3
   kqv6gMEo0UiqchNj9gVWv3EHsGrkpI1EJhtMJeF7oYPmnKY1OUQv/xd9G
   470qcOAW6ndmN93fR/DfXSO1yRH091NXCgGLFnsnJf726YRc36O0zIxs4
   q9f2Gl8/HvnuKFCrZKM/i58hMZqzdjnIHGismXHdgUbCqi8nHxpz09pcz
   A==;
X-CSE-ConnectionGUID: 8S+KDsAnTCevXxsrpbMwDQ==
X-CSE-MsgGUID: 00lxM4cbRXyDQsTxif1Skg==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50221079"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="50221079"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 22:31:18 -0700
X-CSE-ConnectionGUID: NV8NkFIJSPKBvHazeySFjA==
X-CSE-MsgGUID: TtvnsP17QA+HmpSJgbuR0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="142629388"
Received: from unknown (HELO [10.238.11.3]) ([10.238.11.3])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 22:31:16 -0700
Message-ID: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
Date: Tue, 27 May 2025 13:31:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] KVM: VMX: add noinstr for is_td_vcpu and is_td
To: Edward Adam Davis <eadavis@qq.com>, seanjc@google.com
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_27A451976AF76E66DF1379C3604976A3A505@qq.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <tencent_27A451976AF76E66DF1379C3604976A3A505@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/27/2025 11:45 AM, Edward Adam Davis wrote:
> is_td() and is_td_vcpu() run in no instrumentation, so they are need
> noinstr.
>
> [1]
> vmlinux.o: error: objtool: vmx_handle_nmi+0x47:
>          call to is_td_vcpu.isra.0() leaves .noinstr.text section
>
> Fixes: 7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>   arch/x86/kvm/vmx/common.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 8f46a06e2c44..70e0879c58f6 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -59,20 +59,20 @@ struct vcpu_vt {
>   
>   #ifdef CONFIG_KVM_INTEL_TDX
>   
> -static __always_inline bool is_td(struct kvm *kvm)
> +static noinstr __always_inline bool is_td(struct kvm *kvm)
>   {
>   	return kvm->arch.vm_type == KVM_X86_TDX_VM;
>   }
>   
> -static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> +static noinstr __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
>   {
>   	return is_td(vcpu->kvm);
>   }

noinstr is not needed when the functions are __always_inline.

>   
>   #else
>   
> -static inline bool is_td(struct kvm *kvm) { return false; }
> -static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> +static noinstr bool is_td(struct kvm *kvm) { return false; }
> +static noinstr bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }

Oops, overlooked the !CONFIG_KVM_INTEL_TDX case.

How about:

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 8f46a06e2c44..a0c5e8781c33 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -71,8 +71,8 @@ static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)

  #else

-static inline bool is_td(struct kvm *kvm) { return false; }
-static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+static __always_inline bool is_td(struct kvm *kvm) { return false; }
+static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }


>   
>   #endif
>   


