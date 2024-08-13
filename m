Return-Path: <kvm+bounces-23942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD31F94FDCA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFAC81C20F4B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085C53BBCF;
	Tue, 13 Aug 2024 06:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJeLcwGG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEC51C68C;
	Tue, 13 Aug 2024 06:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723530357; cv=none; b=C5CnogSXnmwz9twVVjTmOoSO2uPwtwkuCl9s/Skat6EjzpyrbNdYHcCKQELQGqPRfQyqS68UOvnP2r+A01IPQfxpBYhNma9YR5YScDAQZNIOTZnufg53Pgb+Tkln4InPURwctEum7dU5mtiDy/IxwYUv+51FoOofv9tUMXFExUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723530357; c=relaxed/simple;
	bh=4ph18impfwnuKJQRFnczRQosU8MAKr3namoLIzlx+dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JKtSOLbntPUXs8OoRw0QihuIG9cVAaKCh1tvUXIQXvmDDaE6QQ37RHiwEbifNU2UYxMYB+1PzTNI/rgmVspkP/dwDzua4fKmPr+zlxjoGpAtfNcB8AhiiOIJUL1guAzY09nCyUS9DCKRSqTiMuHKq8eZrHqlwfqTu8WxSwAOl1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJeLcwGG; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723530355; x=1755066355;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4ph18impfwnuKJQRFnczRQosU8MAKr3namoLIzlx+dM=;
  b=iJeLcwGGpfbgxhDQD/aHvc5JIrUeLqNmFbAOxsIE/1EoYOFAX1qt6qUZ
   doiFRTsWZr5YpkFPPB3LuBRk4TWnrF42HdQAjZ4QosgdOJiTK6bOYMSB0
   rbLFzUgG4VrWgr62n9ssaEwXUsMM77enIeTcxD4cO5MTDo+gD4CuUib5E
   1f963NbMsMY3TaL+dDbFY406EmHXwVHZsO9hpgMnMDIcA7uknha0DZ+bk
   J36QdtUQo3SHeOy9WdYMA37eqoo6o+zWZmwSdkvHb5DPS36FvzFTc7hXq
   nCwDLHrFv/g9UQpglFWcl387KqabaqWs8BuAcRXuXGmy8qN935SM26r42
   A==;
X-CSE-ConnectionGUID: K0OZ24rMQCifJWeDwObPxQ==
X-CSE-MsgGUID: Gcn7BZR8SEa2K59QAOhsZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="32818841"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="32818841"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:25:54 -0700
X-CSE-ConnectionGUID: SzLsM7PlTeqDySK3ltogtQ==
X-CSE-MsgGUID: mXvJyyd+TyiuCO77u5XOMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58630966"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:25:52 -0700
Message-ID: <0efc9ac6-7cb3-4d94-97ef-0d2d6c11f63a@linux.intel.com>
Date: Tue, 13 Aug 2024 14:25:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/25] KVM: TDX: Add place holder for TDX VM specific
 mem_enc_op ioctl
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-9-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240812224820.34826-9-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
> guest state-protected VM.  It defined subcommands for technology-specific
> operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
> are not limited to memory encryption, but various technology-specific
> operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
> for TDX specific operations and define subcommands.
>
> Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
> TDX specific sub-commands will be added to retrieve/pass TDX specific
> parameters.  Make mem_enc_ioctl non-optional as it's always filled.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - rename error->hw_error (Kai)
>   - Include "x86_ops.h" to tdx.c as the patch to initialize TDX module
>     doesn't include it anymore.
>   - Introduce tdx_vm_ioctl() as the first tdx func in x86_ops.h
>   - Drop middle paragraph in the commit log (Tony)
>
> v15:
>    - change struct kvm_tdx_cmd to drop unused member.
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>   arch/x86/include/uapi/asm/kvm.h    | 26 ++++++++++++++++++++++++
>   arch/x86/kvm/vmx/main.c            | 10 ++++++++++
>   arch/x86/kvm/vmx/tdx.c             | 32 ++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h         |  6 ++++++
>   arch/x86/kvm/x86.c                 |  4 ----
>   6 files changed, 75 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index af58cabcf82f..538f50eee86d 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -123,7 +123,7 @@ KVM_X86_OP(leave_smm)
>   KVM_X86_OP(enable_smi_window)
>   #endif
>   KVM_X86_OP_OPTIONAL(dev_get_attr)
> -KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> +KVM_X86_OP(mem_enc_ioctl)
>   KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>   KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>   KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index cba4351b3091..d91f1bad800e 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -926,4 +926,30 @@ struct kvm_hyperv_eventfd {
>   #define KVM_X86_SNP_VM		4
>   #define KVM_X86_TDX_VM		5
>   
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
It's not used yet.
This cmd id can be introduced in the next patch.

> +
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
>
[...]

