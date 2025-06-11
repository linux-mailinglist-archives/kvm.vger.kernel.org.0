Return-Path: <kvm+bounces-48937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A16AD47D0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19E2817C857
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392A6139566;
	Wed, 11 Jun 2025 01:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iy8c1dJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB312A1CA;
	Wed, 11 Jun 2025 01:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749604946; cv=none; b=FV5ZTqaiSnOwIP7C1Pa2DrtdUXKpZwhmOuFG8KHnnCghVdmGwh08gf7B4Kh0uKkscS1XKJI8lcJnYrumVuMAb7PegYONt4rSP/QcuLrW3nyD3Zlyd7llhka6GoqKSniz7ws0gHdAgqTx4p2x8NyD2vbu5yeNW0eQuJPzsN/mvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749604946; c=relaxed/simple;
	bh=lhADqqBHXy3DGGCkuUwmCo4xqJKb3G0Yaq/McG/zUnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=roa6obA7ZuflNSMZb/MkDM2J3ANjgTQA7MM3SoVN0T5P7ySSHCseJ3WBMRbCt+lOPGaiI8XiS63HBTAaWKZalT8uh7lgany7MJqCBw4McPE5/yt2NMbwdr2u3GsTrB5OFVoRTXr3rwi1a3U/kDtGKKPc4Zkz57wff6e+E5jwjkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iy8c1dJJ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749604945; x=1781140945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lhADqqBHXy3DGGCkuUwmCo4xqJKb3G0Yaq/McG/zUnM=;
  b=Iy8c1dJJQrPIxGKLYJ6L1UrOC2A9HOd56dlcGCmVkc/W6+AEmewD7Ciq
   zb46E+OVJOoSfx43aV3o+fAA/BTMSMDM/82i7tYgjK2cZIfZdDUcZ+7yv
   9K4QxPhl0PwDzEt3tCWwYliyfqsiO8z5agE73PQGsuh4DYRIa76bYQcxN
   /HgCQSSLGLdL9sN+v2QVKeqMvnUlrWD+QsVVJyDEa9z+D+/nc4cjJGEXe
   SEBKpnG5NAllUNHoidTUr9N4aJ/HA7x7aUJONrsunbcBy0Y1DeJt8m19o
   zhgHLrIIuksfobmQ7BJZGzjL3ojRXTNfhek423Ok9wvVuGfJevJeqx5Ay
   Q==;
X-CSE-ConnectionGUID: Q20mTebHQ5Gar11e34mVaw==
X-CSE-MsgGUID: NgoVL/NaQ6Kx1DWzPE1wHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51820874"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51820874"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:22:24 -0700
X-CSE-ConnectionGUID: 6DTzPMGwRzq2zNiQmoqPQw==
X-CSE-MsgGUID: Th2PClIjS06SMunniyWObQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="147581950"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:22:21 -0700
Message-ID: <31c4ab96-55bf-4f80-a6fd-3478cc1d1117@linux.intel.com>
Date: Wed, 11 Jun 2025 09:22:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Jiewen Yao <jiewen.yao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Tony Lindgren <tony.lindgren@intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yan Y Zhao <yan.y.zhao@intel.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, Kirill Shutemov <kirill.shutemov@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-5-binbin.wu@linux.intel.com>
 <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
 <aEh0oGeh96n9OvCT@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aEh0oGeh96n9OvCT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 3:58 AM, Sean Christopherson wrote:
> On Tue, Jun 10, 2025, Rick P Edgecombe wrote:
>> On Tue, 2025-06-10 at 10:14 +0800, Binbin Wu wrote:
>>> Check userspace has enabled KVM exit on KVM_HC_MAP_GPA_RANGE during
>>> KVM_TDX_FINALIZE_VM.
>>>
>>> TDVMCALL_MAP_GPA is one of the GHCI base TDVMCALLs, so it must be
>>> implemented by VMM to support TDX guests. KVM converts TDVMCALL_MAP_GPA
>>> to KVM_HC_MAP_GPA_RANGE, which requires userspace to enable
>>> KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE bit set. Check it when
>>> userspace requests KVM_TDX_FINALIZE_VM, so that there is no need to check
>>> it during TDX guests running.
>>>
>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Do we need this change? It seems reasonable, but I don't think we need KVM to
>> ensure that userspace creates a TD that meets the GHCI spec.
> +1.  We do need to be careful about unintentionally creating ABI, but generally
> speaking KVM shouldn't police userspace.

OK.

>> So I'm not sure about the justification.
>>
>> It seems like the reasoning could be just to shrink the possible configurations
>> KVM has to think about, and that we only have the option to do this now before
>> the ABI becomes harder to change.
>>
>> Did you need any QEMU changes as a result of this patch?
>>
>> Wait, actually I think the patch is wrong, because KVM_CAP_EXIT_HYPERCALL could
>> be called again after KVM_TDX_FINALIZE_VM. In which case userspace could get an
>> exit unexpectedly. So should we drop this patch?
> Yes, drop it.
>
So, when the TDX guest calls MapGPA and KVM finds userspace doesn't opt-in
KVM_HC_MAP_GPA_RANGE, just return error to userspace?

