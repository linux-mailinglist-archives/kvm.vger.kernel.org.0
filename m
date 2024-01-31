Return-Path: <kvm+bounces-7589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C67F8441F1
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 15:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBF131F25F2A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 14:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA2883CC0;
	Wed, 31 Jan 2024 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WPkGeq5v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF5741AAB;
	Wed, 31 Jan 2024 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706711670; cv=none; b=K6/doZ8htLXp8Mo+s0U5fmwi1e6Hy6z+kVZORJSXJf3ZVNaMRBE+uxj3yo6nsMxlCAzO3HX+x2tLOZMXx3RRJ5/VEjESFLmOZBMDAnuaoLDYYd0Tfg5dOw2CphAYtrpRrG8UlRQfmsl4OO5jv6ShyYgyQl+ypaivH+1Z4CFYgo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706711670; c=relaxed/simple;
	bh=CYvz0qJVVOJjGjyVyIx0kkVnNE9jPzphOdhUwRpNJ7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mE9x507y6oFdjOy6+9t4zBQzYmIjwYJPTsmGwsobU5I0s/fPgCcqhEbI0snyD34NaNI8jtNazrkaiCX/V9XUO72hmLJ+AzqPiangWTy/zXq1VFARmuLkZ8clw+qSx+X9/aIeltMI5BTbE4BvUIQUgcN9ZFUnZrNtoZ9mRC4SFuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WPkGeq5v; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706711668; x=1738247668;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CYvz0qJVVOJjGjyVyIx0kkVnNE9jPzphOdhUwRpNJ7Y=;
  b=WPkGeq5vAtbXl2XhX8InMnyzoshc+DqQUy8hYzVjaqKpixjhzwiLFbST
   nupmGoie7Bq3VI5aXrg2WFjB5Ngr8lPwveBrj+LdzhxxiRw3la2Uady5O
   JwR5su01Lvoa/xdW8LiBn1ZeYRp2gr+wTlUedVGkBsUOWUKXRbvCaEhao
   V3H0kD8FOcKTTI1Jk+HsfgM70JI1L6LfIQTs6OPXYXEtqCYWMtOvPA/CB
   fYo0+5VnSzeN+GN12waRZm/QnOIXb9RlVNzVcCc3S2rJnKLbsbbMRYfPO
   +AsXZACVQ62AqGv89z4cKRSFjjZI7Rme5bWzNNPIrgFbQ6PmGtc7SC5mN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3451927"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="3451927"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 06:34:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="4075207"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 06:34:23 -0800
Message-ID: <ea5426ca-d74c-415d-8a70-ef64fa54639e@intel.com>
Date: Wed, 31 Jan 2024 22:34:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 004/121] KVM: VMX: Move out vmx_x86_ops to 'main.c' to
 wrap VMX and TDX
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <e603c317587f933a9d1bee8728c84e4935849c16.1705965634.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e603c317587f933a9d1bee8728c84e4935849c16.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> KVM accesses Virtual Machine Control Structure (VMCS) with VMX instructions
> to operate on VM.  TDX doesn't allow VMM to operate VMCS directly.
> Instead, TDX has its own data structures, and TDX SEAMCALL APIs for VMM to
> indirectly operate those data structures.  This means we must have a TDX
> version of kvm_x86_ops.
> 
> The existing global struct kvm_x86_ops already defines an interface which
> fits with TDX.  But kvm_x86_ops is system-wide, not per-VM structure.  To
> allow VMX to coexist with TDs, the kvm_x86_ops callbacks will have wrappers
> "if (tdx) tdx_op() else vmx_op()" to switch VMX or TDX at run time.
> 
> To split the runtime switch, the VMX implementation, and the TDX
> implementation, add main.c, and move out the vmx_x86_ops hooks in
> preparation for adding TDX, which can coexist with VMX, i.e. KVM can run
> both VMs and TDs.  Use 'vt' for the naming scheme as a nod to VT-x and as a
> concatenation of VmxTdx.
> 
> The current code looks as follows.
> In vmx.c
>    static vmx_op() { ... }
>    static struct kvm_x86_ops vmx_x86_ops = {
>          .op = vmx_op,
>    initialization code
> 
> The eventually converted code will look like
> In vmx.c, keep the VMX operations.
>    vmx_op() { ... }
>    VMX initialization
> In tdx.c, define the TDX operations.
>    tdx_op() { ... }
>    TDX initialization
> In x86_ops.h, declare the VMX and TDX operations.
>    vmx_op();
>    tdx_op();
> In main.c, define common wrappers for VMX and TDX.
>    static vt_ops() { if (tdx) tdx_ops() else vmx_ops() }
>    static struct kvm_x86_ops vt_x86_ops = {
>          .op = vt_op,
>    initialization to call VMX and TDX initialization
> 
> Opportunistically, fix the name inconsistency from vmx_create_vcpu() and
> vmx_free_vcpu() to vmx_vcpu_create() and vmx_vcpu_free().
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


