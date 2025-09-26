Return-Path: <kvm+bounces-58848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C175BA2881
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 08:32:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CADCC6260A0
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 06:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AAF27B32C;
	Fri, 26 Sep 2025 06:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXbBEaAj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00DA1DC1AB;
	Fri, 26 Sep 2025 06:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758868366; cv=none; b=PEdCvwzfSXmjRuvGlJ/O/sNyI8v25GL6jVTtS2Ip7l+RBdhyZ7D9ExmgOxOiIwJJF00wAeNGEdHozfFG1Upkhg5e7mqqnX6nsrbutaHPfXe620v1WtdFNtI0HpJVXi6J7eLZtIquAAyFar7Iwg67lZXJl6lhwtq4gZto6cibr10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758868366; c=relaxed/simple;
	bh=bppMdRX/qwB4QSiw0NafKt4DSxAl2uc1f9uyxKzpRzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qHKsn9Q/iWp4dMyvHa6KlWH0uyU/X1jry519R735juEHo0HI+q6kYLVY+iLC3S+T+6zsZxnopMKGMnsvcjUAZaKz+BoIVa0pQewHvuXQ7P7xp36HwQAil2Nin5qroB0c66uIB0So7y45/K07We3IOC0DH11uZuNo7uEHmFDaS9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXbBEaAj; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758868365; x=1790404365;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bppMdRX/qwB4QSiw0NafKt4DSxAl2uc1f9uyxKzpRzs=;
  b=nXbBEaAjzndaLMNSlvdmfoKAG4jcd/LMM4YJ8Ich9ZeL4gw1S/NOkwtB
   xy6MrfcT3JiFn63bsqe+qT2M2Q9IaCs0vk0AXDx2ZtOp0/W68usQ4rTL4
   J8R6FZJRgOlUKGb0lKo+cbLvikGX/aRS2LVaq1haQNZIh2wvAgIuFlFsc
   pr2w0pYECx02M99/CFgh+Uo8XW/rwKDSETv9OLvwbjQdSxnjSJUOGJVgq
   8f9FSOrtfrDhQHLQ5Qah1aFPo4chp3DkX2W2roXqprP4jV9lipoBvyp/I
   nIJGCrINU3M8nMYA9cQODmDvVzlaSAo+TCJhIgbE6AOqHHVMnYzw8Q3t2
   w==;
X-CSE-ConnectionGUID: MxgyLBxbRouERaNzRHOVBQ==
X-CSE-MsgGUID: ibNdvuYmTBKssBEhtrGt5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="61248047"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="61248047"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 23:32:44 -0700
X-CSE-ConnectionGUID: bJ4mVfvGT16mScjR8vzWoA==
X-CSE-MsgGUID: V65c4wW9RJCihs4iuPxGTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214666273"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 23:32:38 -0700
Message-ID: <24d2f165-f854-4996-89cf-28d644c592a3@intel.com>
Date: Fri, 26 Sep 2025 14:32:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, kas@kernel.org,
 bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 yan.y.zhao@intel.com, vannapurve@google.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> The TDX error code has a complex structure. The upper 32 bits encode the
> status code (higher level information), while the lower 32 bits provide
> clues about the error, such as operand ID, CPUID leaf, MSR index, etc.
> 
> In practice, the kernel logic cares mostly about the status code. Whereas
> the error details are more often dumped to warnings to be used as
> debugging breadcrumbs. This results in a lot of code that masks the status
> code and then checks the resulting value. Future code to support Dynamic
> PAMT will add yet mode SEAMCALL error code checking. To prepare for this,
> do some cleanup to reduce the boiler plate error code parsing.
> 
> Since the lower bits that contain details are needed for both error
> printing and a few cases where the logical code flow does depend on them,
> don’t reduce the boiler plate by masking the detail bits inside the
> SEAMCALL wrappers, returning only the status code. Instead, create some
> helpers to perform the needed masking and comparisons.
> 
> For the status code based checks, create a macro for generating the
> helpers based on the name. Name the helpers IS_TDX_FOO(), based on the
> discussion in the Link.
> 
> Many of the checks that consult the error details are only done in a
> single place. It could be argued that there is not any code savings by
> adding helpers for these checks. Add helpers for them anyway so that the
> checks look consistent when uses with checks that are used in multiple
> places (i.e. sc_retry_prerr()).
> 
> Finally, update the code that previously open coded the bit math to use
> the helpers.
> 
> Link: https://lore.kernel.org/kvm/aJNycTvk1GEWgK_Q@google.com/
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Enhance log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> v3:
>   - Split from "x86/tdx: Consolidate TDX error handling" (Dave, Kai)
>   - Change name from IS_TDX_ERR_FOO() to IS_TDX_FOO() after the
>     conclusion to one of those naming debates. (Sean, Dave)
> ---
>   arch/x86/coco/tdx/tdx.c                 |  6 +--
>   arch/x86/include/asm/shared/tdx_errno.h | 54 ++++++++++++++++++++++++-
>   arch/x86/include/asm/tdx.h              |  2 +-
>   arch/x86/kvm/vmx/tdx.c                  | 44 +++++++++-----------
>   arch/x86/virt/vmx/tdx/tdx.c             |  8 ++--
>   5 files changed, 80 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 7b2833705d47..96554748adaa 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -129,9 +129,9 @@ int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
>   
>   	ret = __tdcall(TDG_MR_REPORT, &args);
>   	if (ret) {
> -		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
> +		if (IS_TDX_OPERAND_INVALID(ret))
>   			return -ENXIO;
> -		else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
> +		else if (IS_TDX_OPERAND_BUSY(ret))
>   			return -EBUSY;
>   		return -EIO;
>   	}

There are TDCALL_RETURN_CODE() usages left in tdx_mcall_extend_rtmr().
Please clean them up as well, and the definitions of TDCALL_RETURN_CODE 
macro and friends can be removed totally:


   /* TDX Module call error codes */
   #define TDCALL_RETURN_CODE(a)	((a) >> 32)
   #define TDCALL_INVALID_OPERAND	0xc0000100
   #define TDCALL_OPERAND_BUSY	0x80000200

> @@ -316,7 +316,7 @@ static void reduce_unnecessary_ve(void)
>   {
>   	u64 err = tdg_vm_wr(TDCS_TD_CTLS, TD_CTLS_REDUCE_VE, TD_CTLS_REDUCE_VE);
>   
> -	if (err == TDX_SUCCESS)
> +	if (IS_TDX_SUCCESS(err))

I would expect a separate patch to change it first to

	if ((err & TDX_STATUS_MASK) == TDX_SUCCESS)

because it certainly changes the semantic of the check.

And this applies to some other places below, e.g.,

 > -	if (err == TDX_FLUSHVP_NOT_DONE)
 > +	if (IS_TDX_FLUSHVP_NOT_DONE(err))

 > -	if (err == TDX_RND_NO_ENTROPY) {
 > +	if (IS_TDX_RND_NO_ENTROPY(err)) {


>   		return;
>   
>   	/*
> diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
> index f98924fe5198..49ab7ecc7d54 100644
> --- a/arch/x86/include/asm/shared/tdx_errno.h
> +++ b/arch/x86/include/asm/shared/tdx_errno.h
> @@ -2,8 +2,10 @@
>   #ifndef _X86_SHARED_TDX_ERRNO_H
>   #define _X86_SHARED_TDX_ERRNO_H
>   
> +#include <asm/trapnr.h>
> +

This belongs to the previous patch, I think.

And in that patch, the <asm/trapnr.h> can be removed from
arch/x86/include/asm/tdx.h?

>   /* Upper 32 bit of the TDX error code encodes the status */
> -#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
> +#define TDX_STATUS_MASK				0xFFFFFFFF00000000ULL
>   
>   /*
>    * TDX SEAMCALL Status Codes
> @@ -52,4 +54,54 @@
>   #define TDX_OPERAND_ID_SEPT			0x92
>   #define TDX_OPERAND_ID_TD_EPOCH			0xa9
>   
> +#ifndef __ASSEMBLER__
> +#include <linux/bits.h>
> +#include <linux/types.h>
> +
> +static inline u64 TDX_STATUS(u64 err)
> +{
> +	return err & TDX_STATUS_MASK;
> +}
> +
> +static inline bool IS_TDX_NON_RECOVERABLE(u64 err)
> +{
> +	return (err & TDX_NON_RECOVERABLE) == TDX_NON_RECOVERABLE;
> +}
> +
> +static inline bool IS_TDX_SW_ERROR(u64 err)
> +{
> +	return (err & TDX_SW_ERROR) == TDX_SW_ERROR;
> +}

Kai already catched that it can be defined with DEFINE_TDX_ERRNO_HELPER()

The background is that we wanted to use SEAMCALL return code to cover 
the #GP/#UD/VMFAILINVALID cases generally so that we asked TDX 
architecuts to reserve Class ID (0XFF) for software usage.

SW_ERROR is just a Linux defined status code (in the upper 32 bits), and 
details in the lower 32 bits to identify among #GP/#UD/VMFAILINVALID.

So ...

> +static inline bool IS_TDX_SEAMCALL_VMFAILINVALID(u64 err)
> +{
> +	return (err & TDX_SEAMCALL_VMFAILINVALID) ==
> +		TDX_SEAMCALL_VMFAILINVALID;
> +}
> +
> +static inline bool IS_TDX_SEAMCALL_GP(u64 err)
> +{
> +	return (err & TDX_SEAMCALL_GP) == TDX_SEAMCALL_GP;
> +}
> +
> +static inline bool IS_TDX_SEAMCALL_UD(u64 err)
> +{
> +	return (err & TDX_SEAMCALL_UD) == TDX_SEAMCALL_UD;
> +}

... TDX_SEAMCALL_{VMFAILINVALID,GP,UD} are full 64-bit return codes, not 
some masks. The check of

	(err & TDX_SEAMCALL_*) == TDX_SEAMCALL_*

isn't correct here and we need to check

	err == TDX_SEAMCALL_*;

e.g., The #UD is of number 6, which is 110b. If SEAMCALL could cause 
exception of vector 111b, 1110b, 1111b, they can pass the check of 
IS_TDX_SEAMCALL_UD()

