Return-Path: <kvm+bounces-7945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F876848C3D
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 09:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB3881C229C6
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 08:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315B714AA5;
	Sun,  4 Feb 2024 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nL1W88nU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC5A14275;
	Sun,  4 Feb 2024 08:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707036403; cv=none; b=SA7pckbAKX0nS2fhvoyG7DcHpfNWT1uhEtwN/cjw8whykuonSxWzmj9WV2ZpFB5+BZaBPIq5LrusfPNNlD7DIU3sNiLpFeewbVPJZ1ku2naM0l1my+PP7lzVhYbL/JwDLa9RcbTZrf+02z2ncyjri0yrgEsgXL5iXhbxAY53i1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707036403; c=relaxed/simple;
	bh=Cpy3CKuYNywdrx8Zum44pEFdPYhqxi2fjTOZk38Zifk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JEwMtx8L+dSd2Nbkd5I8+ZuoUCUe6wSz0DFAHg/o1LQgwz47UZR3AeAkVomTVdCK0dqpvrjQR+aBWjOfWGAC/CVsTnDsA14wFSYMmBR58b68+bHion+jpxy8Hjvo2bAUpRqu2cPvio3Rsd2cYe8CHlCZ6oRCsLmaIlLjnV6Shq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nL1W88nU; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707036402; x=1738572402;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cpy3CKuYNywdrx8Zum44pEFdPYhqxi2fjTOZk38Zifk=;
  b=nL1W88nUfdRjOkUSjTPQy1lIvFGqsLTqVQG/bOzWLDP2yTXgl3FD1CpN
   aCcCR4qkRzXJE5Glmqmk8KE7TvM2FHn/ejLsMlyfdsUqFEbz3L8PjnPq5
   /Gsrd3RPAq6rNvugyIsL0yNQ6EBkSk8rT/g2QQAicX9bKvmnrlISHzzaL
   ebzXqUEFN2/OXxQordWS/eYEkXdshz8QyQM02KpxRM+PmOpEcGgz4XlLb
   53pH4Ok6bWdYoEORo/N03Ai/71q+CtVdrzywlNUMLz4PnwWT1GcWeyXhG
   3s4+yJzd+tE9SqSy/VrqHs99OSJJalMi1R+CH+h0pgb8vKuDAd0FWZTQ1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="528900"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="528900"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 00:46:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="515985"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 00:46:37 -0800
Message-ID: <4f35f658-bd0a-4461-b9db-992bef0e57a9@linux.intel.com>
Date: Sun, 4 Feb 2024 16:46:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 053/121] KVM: x86/mmu: TDX: Do not enable page track
 for TD guest
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Yan Zhao <yan.y.zhao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <ba65644eb8327600c393bc3a3dc71c49e872d29f.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ba65644eb8327600c393bc3a3dc71c49e872d29f.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
>
> TDX does not support write protection and hence page track.
> Though !tdp_enabled and kvm_shadow_root_allocated(kvm) are always false
> for TD guest, should also return false when external write tracking is
> enabled.

Nit:
The preferred shortlog prefix format is "KVM: <topic>:", remove "TDX" from
the shortlog?
"KVM: x86/mmu: Do not enable page track for TD guest" should be OK.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Cc: Yuan Yao <yuan.yao@linux.intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   arch/x86/kvm/mmu/page_track.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index c87da11f3a04..ce698ab213c1 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -22,6 +22,9 @@
>   
>   bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
>   {
> +	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
> +		return false;
> +
>   	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
>   	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
>   }


