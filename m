Return-Path: <kvm+bounces-48802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87069AD319D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 11:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CD893A51A4
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 09:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04E528C004;
	Tue, 10 Jun 2025 09:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IovoCQVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F21328BA9F;
	Tue, 10 Jun 2025 09:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749547025; cv=none; b=aehsKOuMETsbQbA94Nnr6Z6eCY4Qgfjulh6TPO/K5V3bVTpcRurRhWyeH04lKxjc9hjcuTcJOj+ZPpKaJj8eHAQI+X4T73vZMiTOoayKvjE9cd9zniND9d413LnPisBx6JyUroAr5VcWPEBp+Mlj8u95F4SQD+G7ZCrc46D0QNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749547025; c=relaxed/simple;
	bh=249R4dJADIaUMyPZ3qKvhEDG6b1yvOvVFSz48IQOzks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TBmMjovCYR+RPe8W8JJHIOlpziOkdOGWCz02SMxGlqCd/cVnrhEPLML8SHTvbJsqPJUjAcf7vD42KU9fBtBfBj6If5e5+Bg8iDi7rnbPwpD/SiwPCu797+gelQ9ZM8oFg76U8O+5BfAJHhAJ2nPlUeA3IvYeMxmWinQl6RQBzyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IovoCQVQ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749547022; x=1781083022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=249R4dJADIaUMyPZ3qKvhEDG6b1yvOvVFSz48IQOzks=;
  b=IovoCQVQgUy+ujJFk7uAYFXvxQho/8vICRknpJwPAOZ3yH7Iej47iy4X
   xxr432E3jDWg32LxC9tOyu7MHRD2pPVGEBgz+P4apbHt9qCi185QHelLu
   2bCjhPZmahXmeYVpDW6qlfAwsTFz0GYzJdURdI1DcZLjF8BhEfablyEC5
   PwOGGp/Ln6J81Jz5cJ1oc1Svnq2IJrs7vvurXrMNYVU4wNQB/zPtUv/AE
   +ktkX6xnZgNhNvrTeWld4A3r9qMiA0xm8JUi54z1Lfopn2Y8ux2wsZuna
   3UTvJw2jQ/k6HiySLuhZixHEy5z7sY+SH6bGEmHdOjoTsOgfvHvaT6HUf
   A==;
X-CSE-ConnectionGUID: dGANX6tFSoyqhp6ngKJe6A==
X-CSE-MsgGUID: p1ayBTWVT3i+AIzElfQ/Ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="77049058"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="77049058"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:17:00 -0700
X-CSE-ConnectionGUID: o331yDGbQVKFkpaXpOoFog==
X-CSE-MsgGUID: SKV6ptgcT6OMnG3O8o8JHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="151926606"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:16:56 -0700
Message-ID: <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
Date: Tue, 10 Jun 2025 17:16:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, linux-kernel@vger.kernel.org,
 kirill.shutemov@intel.com, jiewen.yao@intel.com
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250610021422.1214715-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/2025 10:14 AM, Binbin Wu wrote:
> Exit to userspace for TDG.VP.VMCALL<GetTdVmCallInfo> via a new KVM exit
> reason to allow userspace to provide information about the support of
> TDVMCALLs when r12 is 1 for the TDVMCALLs beyond the GHCI base API.
> 
> GHCI spec defines the GHCI base TDVMCALLs: <GetTdVmCallInfo>, <MapGPA>,
> <ReportFatalError>, <Instruction.CPUID>, <#VE.RequestMMIO>,
> <Instruction.HLT>, <Instruction.IO>, <Instruction.RDMSR> and
> <Instruction.WRMSR>. They must be supported by VMM to support TDX guests.
> 
> For GetTdVmCallInfo
> - When leaf (r12) to enumerate TDVMCALL functionality is set to 0,
>    successful execution indicates all GHCI base TDVMCALLs listed above are
>    supported.
> 
>    Update the KVM TDX document with the set of the GHCI base APIs.
> 
> - When leaf (r12) to enumerate TDVMCALL functionality is set to 1, it
>    indicates the TDX guest is querying the supported TDVMCALLs beyond
>    the GHCI base TDVMCALLs.
>    Exit to userspace to let userspace set the TDVMCALL sub-function bit(s)
>    accordingly to the leaf outputs.  KVM could set the TDVMCALL bit(s)
>    supported by itself when the TDVMCALLs don't need support from userspace
>    after returning from userspace and before entering guest. Currently, no
>    such TDVMCALLs implemented, KVM just sets the values returned from
>    userspace.
> 
>    A new KVM exit reason KVM_EXIT_TDX_GET_TDVMCALL_INFO and its structure
>    are added. Userspace is required to handle the exit reason as the initial
>    support for TDX.

It doesn't look like a good and correct design.

Consider the case that userspace supports SetupEventNotifyInterrupt and 
returns bit 1 of leaf_output[0] as 1 to KVM, and KVM returns it to TD 
guest for TDVMCALL_GET_TD_VM_CALL_INFO. So TD guest treats it as 
SetupEventNotifyInterrupt is support. But when TD guest issues this 
TDVMCALL, KVM doesn't support the exit to userspace for this specific 
leaf and userspace doesn't have chance to handle it.

I have a proposal:

Implement KVM_CAP_TDX_USER_EXIT_TDVMCALL

- on check of this cap, KVM returns the bitmap of TDVMCALL leafs that
   allows userspace to opt-in the user exit; e.g.,

#define TDX_USER_EXIT_TDVMCALL_GETQUOTE 		 BIT_ULL(0)
#define TDX_USER_EXIT_TDVMCALL_SetupEventNotifyInterrupt BIT_ULL(1)
...

- on enable of this cap, KVM allows userspace to opt-in which leaf will
   exit to usersapce for handling;

- KVM returns the result for leaf(r12)==1 of <GetTdVmCallInfo> based on
   the KVM_CAP_TDX_USER_EXIT_TDVMCALL enabled by userspace and its own
   capability;

If a non-base GHCI TDVMCALL is supported by KVM itself and no need exit 
to userspace, it's not reported in KVM_CAP_TDX_USER_EXIT_TDVMCALL so 
that usersapce cannot enable the user exit of this leaf. But KVM will 
still return the corresponding bit of this leaf as 1 for leaf(r12)==1 of 
<GetTdVmCallInfo> since it's supported by KVM itself.

If a non-base GHCI TDVMCALL is not supported by KVM itself but KVM 
allows/supports userspace to opt-in the user exit. e.g., <Getquote>. 
check of KVM_CAP_TDX_USER_EXIT_TDVMCALL will have the bit of this leaf set.

  - only when usersapce enable the corresponding bit by calling
    enable_cap(KVM_CAP_TDX_USER_EXIT_TDVMCALL), will KVM return the
    corresponding bit of this leaf as 1 for leaf(r12)==1 of
    <GetTdVmCallInfo> and exit to userspace for such leaf.

  - if userspace doesn't enable the corresponding bit with
    enable_cap(KVM_CAP_TDX_USER_EXIT_TDVMCALL). KVM will return 0 for
    the corresponding bit of this leaf for leaf(r12)==1 of
    <GetTdVmCallInfo> and return TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED when
    TDX guest issues such leaf;

If a non-base GHCI TDVMCALL is not supported by KVM and KVM doesn't 
allow/support userspace to opt-in the user exit. e.g., 
<SetupEventNotifyInterrupt>. check of KVM_CAP_TDX_USER_EXIT_TDVMCALL 
will not have the bit of this leaf set, so that userspace cannot opt-in 
the user exit of such leaf. leaf(r12)==1 of <GetTdVmCallInfo> return the 
bit of such leaf as 0 and TDX guest request of such leaf gets 
TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED.

