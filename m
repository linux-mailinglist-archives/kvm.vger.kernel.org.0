Return-Path: <kvm+bounces-35523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48362A11E49
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 10:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 963DB3A8D7C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 09:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0DE1FC7C8;
	Wed, 15 Jan 2025 09:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="llbztw3U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12131EEA3D;
	Wed, 15 Jan 2025 09:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736934038; cv=none; b=KpLxC9eToFnCzvgCjT9w9OnRneMg9m0xKoGVCOLS7iF/rxMRs5nW50kk0g2GJ557pzRMfqy3M/0wjpqnX5RyCS0mM/6lH7ixdI1v6e0ILpMf/6F6oxAUhWEYC8ZZhc/4uW0/vHPVYRcq1eXLsSd1Vu07nSpjPk7WHPncwjRNNKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736934038; c=relaxed/simple;
	bh=82OrV5Ilm8OITGM6qaDm+HchWp6oYpILZKE7zDsl07k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sWvg1MRX86stLK6yxugNeMO1p9GwRYQBb3hHMKxsqaNoHYnQB5ycVj6WB3KpPCmnWzhumzMHwWOOC5idZEqjhn1+cV8KMRBU4UeC9OyuaKSPPRrnmwpx0KPPPk6Oib2G287VMZ9mrvPKKPeaoNsROuubEqIoKA8eYUOmzrxt7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=llbztw3U; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736934037; x=1768470037;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=82OrV5Ilm8OITGM6qaDm+HchWp6oYpILZKE7zDsl07k=;
  b=llbztw3UCQo5MiWaV5E5wmLm1lOJORfx7ahZgtCbu/9XF3xgtwOqiBTK
   n1+kuDmKW8wUUllqtfG+MMy2fPMNiHOH3jhe7TKtMuEA7NgzN0knHW5I9
   AO9Pk2IQ6ym1Jg/smZoV7JatInAKEtV7I++qHwj8cjQfaEEQemh7hAQ4R
   d8pQbD8blvbppf2JadnnDfKoOsLBh7qsWb1+daQfJJRfDcWjRDnLCSofu
   tgtkevM8Nsjw+SIKQKLWNN1jVm0+NRrNJYZyZMVPLaH/r+n/UXjEew0oY
   pdomJVL6axcPxkk7N9ujEDHnOW0MwQ0wc0n5u1dHf8vPrcpZvX0s2odIF
   A==;
X-CSE-ConnectionGUID: XvoCcSSKRd6PmiP2dHUCcw==
X-CSE-MsgGUID: 3KVtDgZTRca8XLCHY8esXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="41196458"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="41196458"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 01:40:36 -0800
X-CSE-ConnectionGUID: AFvWLxNCRqmZZaKJgAMkew==
X-CSE-MsgGUID: gr2GYsDeQ2qrDawvPhaIgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105564576"
Received: from dliang1-mobl.ccr.corp.intel.com (HELO [10.238.10.216]) ([10.238.10.216])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 01:40:34 -0800
Message-ID: <67f0292e-6eea-4788-977c-50af51910945@linux.intel.com>
Date: Wed, 15 Jan 2025 17:40:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] KVM: x86: Prep KVM hypercall handling for TDX
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, "Hunter, Adrian"
 <adrian.hunter@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <173457537849.3292936.8364596188659598507.b4-ty@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <173457537849.3292936.8364596188659598507.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/19/2024 10:40 AM, Sean Christopherson wrote:
> On Wed, 27 Nov 2024 16:43:38 -0800, Sean Christopherson wrote:
>> Effectively v4 of Binbin's series to handle hypercall exits to userspace in
>> a generic manner, so that TDX
>>
>> Binbin and Kai, this is fairly different that what we last discussed.  While
>> sorting through Binbin's latest patch, I stumbled on what I think/hope is an
>> approach that will make life easier for TDX.  Rather than have common code
>> set the return value, _and_ have TDX implement a callback to do the same for
>> user return MSRs, just use the callback for all paths.
>>
>> [...]
> Applied patch 1 to kvm-x86 fixes.  I'm going to hold off on the rest until the
> dust settles on the SEAMCALL interfaces, e.g. in case TDX ends up marshalling
> state into the "normal" GPRs.
Hi Sean, Based on your suggestions in the link https://lore.kernel.org/kvm/Z1suNzg2Or743a7e@google.com, the v2 of "KVM: TDX: TDX hypercalls may exit to userspace" is planned to morph the TDG.VP.VMCALL with KVM hypercall to EXIT_REASON_VMCALL and marshall r10~r14 from vp_enter_args in struct vcpu_tdx to the appropriate x86 registers for KVM hypercall handling.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ef66985ddc91..d5aaf66af835 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -935,6 +935,23 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
         return tdx_exit_handlers_fastpath(vcpu);
  }
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+       tdvmcall_set_return_code(vcpu, vcpu->run->hypercall.ret);
+       return 1;
+}
+
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+       kvm_rax_write(vcpu, to_tdx(vcpu)->vp_enter_args.r10);
+       kvm_rbx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r11);
+       kvm_rcx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r12);
+       kvm_rdx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r13);
+       kvm_rsi_write(vcpu, to_tdx(vcpu)->vp_enter_args.r14);
+
+       return __kvm_emulate_hypercall(vcpu, 0, complete_hypercall_exit);
+}
+
  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
  {
         switch (tdvmcall_leaf(vcpu)) {
@@ -1286,6 +1303,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
                 return 0;
         case EXIT_REASON_TDCALL:
                 return handle_tdvmcall(vcpu);
+       case EXIT_REASON_VMCALL:
+               return tdx_emulate_vmcall(vcpu);
         default:
                 break;
         }


To test TDX, I made some modifications to your patch
"KVM: x86: Refactor __kvm_emulate_hypercall() into a macro"
Are the following changes make sense to you?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2198807290b..2c5df57ad799 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10088,9 +10088,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
         if (kvm_hv_hypercall_enabled(vcpu))
                 return kvm_hv_hypercall(vcpu);
-       return __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
-                                      is_64_bit_hypercall(vcpu),
-                                      kvm_x86_call(get_cpl)(vcpu),
+       return __kvm_emulate_hypercall(vcpu, kvm_x86_call(get_cpl)(vcpu),
                                        complete_hypercall_exit);
  }
  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b00ecbfef000..989bed5b48b0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -623,19 +623,18 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
                               int op_64_bit, int cpl,
                               int (*complete_hypercall)(struct kvm_vcpu *));
-#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, complete_hypercall) \
-({                                                                                             \
-       int __ret;                                                                              \
-                                                                                               \
-       __ret = ____kvm_emulate_hypercall(_vcpu,                                                \
-                                         kvm_##nr##_read(_vcpu), kvm_##a0##_read(_vcpu),       \
-                                         kvm_##a1##_read(_vcpu), kvm_##a2##_read(_vcpu),       \
-                                         kvm_##a3##_read(_vcpu), op_64_bit, cpl,               \
-                                         complete_hypercall);                                  \
-                                                                                               \
-       if (__ret > 0)                                                                          \
-               __ret = complete_hypercall(_vcpu);                                              \
-       __ret;                                                                                  \
+#define __kvm_emulate_hypercall(_vcpu, cpl, complete_hypercall)                                \
+({                                                                                     \
+       int __ret;                                                                      \
+       __ret = ____kvm_emulate_hypercall(_vcpu, kvm_rax_read(_vcpu),                   \
+                                         kvm_rbx_read(_vcpu), kvm_rcx_read(_vcpu),     \
+                                         kvm_rdx_read(_vcpu), kvm_rsi_read(_vcpu),     \
+                                         is_64_bit_hypercall(_vcpu), cpl,              \
+                                         complete_hypercall);                          \
+                                                                                       \
+       if (__ret > 0)                                                                  \
+               __ret = complete_hypercall(_vcpu);                                      \
+       __ret;                                                                          \
  })
  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);



