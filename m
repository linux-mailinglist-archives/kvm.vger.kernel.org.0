Return-Path: <kvm+bounces-57682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82245B58ED8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90D7A18923CB
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE69E2E5404;
	Tue, 16 Sep 2025 07:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PmGD89DH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D702BAF9;
	Tue, 16 Sep 2025 07:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758006629; cv=none; b=EjpEk8MHnMsplzGweJVk0pZEH7Ghb+5p8/G4kr5qLqWk1Q+eLI6lnEbxPN7csKUM9SYatL39ABcwQkHGY/0PnfHIZOED8GpVYI6LzXCXm57a7t8hQhAYyziaTODwuZATMZlUNioWiImdJrNeNpCpv/oTDwbfzIpYvHcuppRvJa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758006629; c=relaxed/simple;
	bh=t0ogTC/JUAL5SrNtFmzKazdF3tZ0foxtSqDAIAX5u1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFYB+UwyBWyMzEAeS0GbENSeMU10zIUQrDQrPVer79baUnlczwG+IhxzFPBkEGkpq/2pDIPM8noIxzWEw6AMRZ4dlgh1TMvYP0Hdv+KXjM/zT7PDB3oOLTrU97OwMrhRRUmZIvIXTA5AK6sKI1l3D4zBsrKddez57IYtD0Bgxk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PmGD89DH; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758006628; x=1789542628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t0ogTC/JUAL5SrNtFmzKazdF3tZ0foxtSqDAIAX5u1k=;
  b=PmGD89DHQPYrd9bHEQVjJbbvMU0Sq5EaFYxjEADW0lAgrrywQtlyfGvn
   T2XnXD/OmLX2nALuYdrmSLhry210YYJf/GG4+DtTC7BZXkPUZqDDZ8u8U
   y9dFm4Kv7rzGuJT8HuvHGCnqqVE3g7oCGRGw0H26pjXoFO2eyi/oj2fU6
   25I3NxmlDpsWBTcwE9wi3sXP5+rKQeMrCn1orxl9AzsvndgIGXZbTTq21
   agXxcKWsz/VOcAtFlGuclbVTzsenwlhs08JNH/Zx0lYzuraMYQzNMmQVc
   4iWPD2o+aI34BP3vfxqgkuVjc5CtQljB82n2ymjIiir4ae1mKcbSWTU6p
   Q==;
X-CSE-ConnectionGUID: V2jaW3Z/S3mVG2WgpSczYg==
X-CSE-MsgGUID: 3/AZoOIPR+qLrxucqAed5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="70898961"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="70898961"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:10:27 -0700
X-CSE-ConnectionGUID: 01L6Fw3BTCq9ibVHQ/qLkQ==
X-CSE-MsgGUID: POnf6OzLT8Sad3ZuBmfd7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="173981684"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:10:24 -0700
Message-ID: <b3fae3e0-1337-430c-beeb-290dc185b8bf@linux.intel.com>
Date: Tue, 16 Sep 2025 15:10:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 04/41] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-5-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access MSRs and
> other non-MSR registers through them, along with support for
> KVM_GET_REG_LIST to enumerate support for KVM-defined registers.
>
> This is in preparation for allowing userspace to read/write the guest SSP
> register, which is needed for the upcoming CET virtualization support.
>
> Currently, two types of registers are supported: KVM_X86_REG_TYPE_MSR and
> KVM_X86_REG_TYPE_KVM. All MSRs are in the former type; the latter type is
> added for registers that lack existing KVM uAPIs to access them. The "KVM"
> in the name is intended to be vague to give KVM flexibility to include
> other potential registers.  More precise names like "SYNTHETIC" and
> "SYNTHETIC_MSR" were considered, but were deemed too confusing (e.g. can
> be conflated with synthetic guest-visible MSRs) and may put KVM into a
> corner (e.g. if KVM wants to change how a KVM-defined register is modeled
> internally).
>
> Enumerate only KVM-defined registers in KVM_GET_REG_LIST to avoid
> duplicating KVM_GET_MSR_INDEX_LIST, and so that KVM can return _only_
> registers that are fully supported (KVM_GET_REG_LIST is vCPU-scoped, i.e.
> can be precise, whereas KVM_GET_MSR_INDEX_LIST is system-scoped).
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com [1]
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

> ---
>   Documentation/virt/kvm/api.rst  |   6 +-
>   arch/x86/include/uapi/asm/kvm.h |  26 +++++++++
>   arch/x86/kvm/x86.c              | 100 ++++++++++++++++++++++++++++++++
>   3 files changed, 131 insertions(+), 1 deletion(-)
[...]
> +
> +#define KVM_X86_REG_ENCODE(type, index)				\
Nit:
Is it better to use KVM_X86_REG_ID so that when searching with the string
non-case sensitively, the encoding and its structure can be related to each
other?


> +	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
> +
[...]
>   
> +struct kvm_x86_reg_id {
> +	__u32 index;
> +	__u8  type;
> +	__u8  rsvd1;
> +	__u8  rsvd2:4;
> +	__u8  size:4;
> +	__u8  x86;
> +};
> +
>

