Return-Path: <kvm+bounces-6727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E41838A3D
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 10:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4263528458B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 09:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3542559B5B;
	Tue, 23 Jan 2024 09:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PzIa2Ovf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7C458ABB;
	Tue, 23 Jan 2024 09:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706001972; cv=none; b=fV3iSjmUw15cYlFFj0dViPutoBC68BQ3/Ugm4+4/fmtqdBYeGpY2WOKtnp4o3JXLlhgsuQWPC8lr5nE93+ZCjynmfkr5W7qnuuKn6MmGGl9tsIkT1zc7RDiUYwsM/AjVAGRR6CsQUbGBX9vO+GXKeyUee8JSmSrzONfYjZiahkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706001972; c=relaxed/simple;
	bh=FuJ3TFWqkwrEJ3h5NAnbltorQCrpxIgD0hjhe8TN+ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EKvs2z14XBwanSu3BYBXRhU/KuW8YGNnQ7ycvQlBSpatTggjUCXvJxb+32V7eCvrbIqb9AjUBqNJOx5gZ1BPEEElW+X8EXPC2IocGc0bvs48mAyO/pdB27f0qPoZnyfJzmRAAAT/J8J6nJB1qPzzGkP1+8or3ouaMNI8TDriTWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PzIa2Ovf; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706001970; x=1737537970;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FuJ3TFWqkwrEJ3h5NAnbltorQCrpxIgD0hjhe8TN+ys=;
  b=PzIa2Ovf9Je3R2zUDF3qsMPmLN2oQKqu8Vik2z2k90oESdMO94Y70+JN
   BsYfenpL9B9oUV8jX1KGyA+01kjBuuvc39HnRkWhlmyz/Txy3z+KQSK03
   GUqcpKnpXgbNige1nGTZAeZr8PW9vKxdkxDYQE/O3Djd78pfA7CHt1ztN
   DkFZ9TqbSXKXJ8B+YOPKZX5XtiwKmtXP0C6paIxDSI+2goG/NgnzVyBJX
   F24YeeDqJHYyyT/8zM/u8zjjgx3g759i996ENwM8zuViuCIz2ngNARhEE
   YcFrWae3AzR5FOXs0SClQ5YuClt+QE7PXrqEzQeW+R/f7tv83J7zqm3LJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="14981139"
X-IronPort-AV: E=Sophos;i="6.05,214,1701158400"; 
   d="scan'208";a="14981139"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 01:26:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,214,1701158400"; 
   d="scan'208";a="1482521"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 01:26:05 -0800
Message-ID: <09439dc1-1d07-4412-a0b5-1cded40ee40a@linux.intel.com>
Date: Tue, 23 Jan 2024 17:26:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 018/121] KVM: TDX: Add helper functions to
 allocate/free TDX private host key id
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <16ebf3b34cf1a2346ac6a58f4dc720abf74daab4.1705965634.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <16ebf3b34cf1a2346ac6a58f4dc720abf74daab4.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add helper functions to allocate/free TDX private host key id (HKID).
>
> The memory controller encrypts TDX memory with the assigned TDX HKIDs.  The
> global TDX HKID is to encrypt the TDX module, its memory, and some dynamic
> data (TDR).  The private TDX HKID is assigned to guest TD to encrypt guest
> memory and the related data.  When VMM releases an encrypted page for
> reuse, the page needs a cache flush with the used HKID.  VMM needs the
> global TDX HKID and the private TDX HKIDs to flush encrypted pages.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - Moved the functions to kvm tdx from arch/x86/virt/vmx/tdx/
> - Drop exporting symbols as the host tdx does.
> ---
>   arch/x86/kvm/vmx/tdx.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9d3f593eacb8..ee9d6a687d93 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -11,6 +11,35 @@
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> +/*
> + * Key id globally used by TDX module: TDX module maps TDR with this TDX global
> + * key id.  TDR includes key id assigned to the TD.  Then TDX module maps other
> + * TD-related pages with the assigned key id.  TDR requires this TDX global key
> + * id for cache flush unlike other TD-related pages.
> + */
> +/* TDX KeyID pool */
> +static DEFINE_IDA(tdx_guest_keyid_pool);
> +
> +static int __used tdx_guest_keyid_alloc(void)
> +{
> +	if (WARN_ON_ONCE(!tdx_guest_keyid_start || !tdx_nr_guest_keyids))
> +		return -EINVAL;
> +
> +	/* The first keyID is reserved for the global key. */
Seems no need to add the comment here any more.

> +	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
> +			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
> +			       GFP_KERNEL);
> +}
> +
> +static void __used tdx_guest_keyid_free(int keyid)
> +{
> +	/* keyid = 0 is reserved. */
> +	if (WARN_ON_ONCE(keyid <= 0))


Why not use tdx_guest_keyid_start and its range directly for the check?


> +		return;
> +
> +	ida_free(&tdx_guest_keyid_pool, keyid);
> +}
> +
>   static int __init tdx_module_setup(void)
>   {
>   	int ret;


