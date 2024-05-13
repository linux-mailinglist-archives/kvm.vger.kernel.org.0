Return-Path: <kvm+bounces-17295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 282BC8C3B48
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53E681C20EE0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585081465A7;
	Mon, 13 May 2024 06:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kdFYWCCL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91B1146591;
	Mon, 13 May 2024 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715581659; cv=none; b=OR7p4D76HcZAPksDK92YMCwYtZ/uFu7ZBEgW7GJHp7yu2IRAgpHQFyiBQEFBcyWEd7HK4jPL0VSWyTUZet0S9DR5IJUfDjsavHkGaY0NcrGeLf86mxz06Sp8bC8eOmx5/aFNGGFsp7s4pCEEKj0o3U2NQIfkW+J0vs8u2bLFY9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715581659; c=relaxed/simple;
	bh=EB+QZYJ8ce7OsnEMRF/rmR4y9VScVkSrEIVGEYRx3HQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dbw63GPkA6tifGRe5av31do+xqc/ag/rSyEdPX9qZ80oMXjnxDTauqNlM9UkhtRhTnO5J4x0rFPuF9uFH+QQsEQmvddQKqB2yZLi/XXE6lDySqs8sHlcrxWBm2crhLAi5b927LjTHs66IeMSCg/rnNbBpxqRpsPNXdBHM5NRwyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kdFYWCCL; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715581658; x=1747117658;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EB+QZYJ8ce7OsnEMRF/rmR4y9VScVkSrEIVGEYRx3HQ=;
  b=kdFYWCCLUNXX/nVcs796hp/XYQZwCeqGTTaGaKK97Iyg282UhSffqqqt
   t1iRD3/z4dKz88CUnE0lZCbAFmNC/lRL65bBjQ6MrZzsSvPvHX80tftNG
   SCj2nqu0ZDVwSBYfj9DpvluTRu0C6sDNZ5c4aGdK5jtNO/cuRn+Vg6S3/
   UnhoMY/xzhiShqFfjKnWa6uLDPrlxTLFRdo6etqdt7Oh/P4qGoHtf7VIi
   Mqay0dvtwp6j675fuswbmXzJ6xMu/hSVQp9HQ2/Fa1cDAPaI3+V045p6e
   EO7xH8QRf4lQBBTGL7mIcKKP04jl6bGOp/BCzC5JMQD7hcfeXB7q8zDeO
   A==;
X-CSE-ConnectionGUID: McWEQ9MdRUew6taTn+C6wg==
X-CSE-MsgGUID: zgrVSnkUTKuN1vUeRjsfNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="34010126"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="34010126"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:27:38 -0700
X-CSE-ConnectionGUID: cFuKuJL8TJSPmNTXgIVlGQ==
X-CSE-MsgGUID: MPlPNm8GTgOtuBK2X0VSfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30797945"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:27:34 -0700
Message-ID: <349716b1-a577-48a8-87a8-ac6f6f377e0e@intel.com>
Date: Mon, 13 May 2024 14:27:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/17] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-14-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-14-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Move the checks related to the validity of an access to a memslot from the
> inner __kvm_faultin_pfn() to its sole caller, kvm_faultin_pfn().  This
> allows emulating accesses to the APIC access page, which don't need to
> resolve a pfn, even if there is a relevant in-progress mmu_notifier
> invalidation.  Ditto for accesses to KVM internal memslots from L2, which
> KVM also treats as emulated MMIO.
> 
> More importantly, this will allow for future cleanup by having the
> "no memslot" case bail from kvm_faultin_pfn() very early on.
> 
> Go to rather extreme and gross lengths to make the change a glorified
> nop, e.g. call into __kvm_faultin_pfn() even when there is no slot, as the
> related code is very subtle.  E.g. fault->slot can be nullified if it
> points at the APIC access page, some flows in KVM x86 expect fault->pfn
> to be KVM_PFN_NOSLOT, while others check only fault->slot, etc.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Message-ID: <20240228024147.41573-13-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


