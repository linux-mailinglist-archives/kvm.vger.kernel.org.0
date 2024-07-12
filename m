Return-Path: <kvm+bounces-21477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E45792F664
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:42:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A175281D95
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E79213E88B;
	Fri, 12 Jul 2024 07:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYENz8we"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D419213D88C;
	Fri, 12 Jul 2024 07:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720770144; cv=none; b=Nr8AE/KDPPA/Qpms1ehy9QXFHBNQPXC1n/O26bSpWhN9dffzFR8A3Im/WoDwr0k2nk+mMNAvKd9bcMUlZjooDnc0AaZFE5bh+leimpjRLOsRrgMyhJlu7pChvu6rI20jP2Nca8ed4KH+/Us5nIumcsEmUSFmrWuxLHnvPJ6bh84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720770144; c=relaxed/simple;
	bh=FCAX/GE42Rvua7klft0SmFsSL4NRQvnD/6NEEsublq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buQVZ47QQHVwCst+9GQWviBZtlgduXIVwRRCN0KWAhKrwiCQUFzAQIh0HLcK5zuH/Sh/6l5g28av+Ku6sScmcdDzdh35ty6/uFtjnwSekUuaC2LwVzQBcijOgIRFl+8RFJjJHHhCFsGwPLR+uujPk5Ov6Ne6AxVOzN+CWCEGrpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYENz8we; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720770143; x=1752306143;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FCAX/GE42Rvua7klft0SmFsSL4NRQvnD/6NEEsublq4=;
  b=WYENz8weTEcIzaRzEUgofUZZtytA7ga+L5pEN6X3jRnsFq386wLhbmqM
   2aKCh4SARlDxiRpyuvphEa35NXCXuMxQBb/Nuq2ybsey3jSthmMWKTr/j
   x/L458Sfz87CtbqgBHw11p2Gn/Zjs9sR5c3RNlhT9WG9HkEjic1E0VPq8
   NpXc9LWINuy3JLFRaaoSB3w5aeVKEaEXjH7OgwePx0aRE1jfEtHREzESX
   z7jDPhCHk1evYnX0c8KejipBg9GPRq3/aTKcYdjqnzTsMSNRxEaB52072
   dXH1HBMdZ6rtoDMmqmXQrA0Vni/4wkLV1Ybi1nxUpcetNp4bGjr+Py5Wu
   w==;
X-CSE-ConnectionGUID: QzKTY4aIQEqaXJMOvdW57w==
X-CSE-MsgGUID: w82XvdDoS6uPHC/ub2pZPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="18339793"
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="18339793"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 00:42:23 -0700
X-CSE-ConnectionGUID: KknpuucMRbqILOczuzvZGw==
X-CSE-MsgGUID: eUm6PhvFQM+TcRyM9r5bYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="53760951"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 00:42:19 -0700
Message-ID: <2c2d1d76-ee30-45c8-99ec-09b9943c0a4f@intel.com>
Date: Fri, 12 Jul 2024 15:42:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/49] KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS
 after vCPU creation
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-12-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240517173926.965351-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/18/2024 1:38 AM, Sean Christopherson wrote:
> Reject KVM_CAP_X86_DISABLE_EXITS if vCPUs have been created, as disabling
> PAUSE/MWAIT/HLT exits after vCPUs have been created is broken and useless,
> e.g. except for PAUSE on SVM, the relevant intercepts aren't updated after
> vCPU creation.  vCPUs may also end up with an inconsistent configuration
> if exits are disabled between creation of multiple vCPUs.
> 
> Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Link: https://lore.kernel.org/all/9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com
> Link: https://lore.kernel.org/all/20230121020738.2973-2-kechenl@nvidia.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   Documentation/virt/kvm/api.rst | 1 +
>   arch/x86/kvm/x86.c             | 6 ++++++
>   2 files changed, 7 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6ab8b5b7c64e..884846282d06 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7645,6 +7645,7 @@ branch to guests' 0x200 interrupt vector.
>   :Architectures: x86
>   :Parameters: args[0] defines which exits are disabled
>   :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
> +          or if any vCPUs have already been created
>   
>   Valid bits in args[0] are::
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bb34891d2f0a..4cb0c150a2f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6568,6 +6568,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
>   			break;
>   
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus)
> +			goto disable_exits_unlock;
> +
>   		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
>   			kvm->arch.pause_in_guest = true;
>   
> @@ -6589,6 +6593,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   
>   		r = 0;
> +disable_exits_unlock:
> +		mutex_unlock(&kvm->lock);
>   		break;
>   	case KVM_CAP_MSR_PLATFORM_INFO:
>   		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];


