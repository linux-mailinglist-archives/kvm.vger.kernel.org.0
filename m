Return-Path: <kvm+bounces-10501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DB986CAAB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 656E21F218AA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED24512BE85;
	Thu, 29 Feb 2024 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fHXMSkSS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D6C128389;
	Thu, 29 Feb 2024 13:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709214629; cv=none; b=F6SEXKaKbuEcy/ZjISvCMDtjDQPPsdmOj9griaYiQ+xcLyPZ3kilhya1OFAul0iXhESNL93n7qb5z4QVJKJ6RDvDdJJOKexwmQXXHxyRtHu9NnOs8FTWbb7GtIU0yhfkJekwIDZVI9Jg8NzhaH5QSViMJXjnPZOWDwL97KLqLAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709214629; c=relaxed/simple;
	bh=r064jTRX5HKRWE4P9/PY9rqZIJZaYsbT+MBu6QNwZJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g0hnQXRV9c7YvpUVra7aTfFSoFQziJdek5r7rVv5aPES0FJODh/oEj/aOtDb4Yoy2Dvr5VK6oIypnBEELXwR0B8lkRV57DkcwL5YcYNuQyxBhdJnbjbzrAhmrsYnGtXCK0StQXb2O6smq7aV2qiOB/xDaNGAMZT8Im60/vdhAQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fHXMSkSS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709214628; x=1740750628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r064jTRX5HKRWE4P9/PY9rqZIJZaYsbT+MBu6QNwZJs=;
  b=fHXMSkSSTO5XH6q8A9dJFT5uP4KOCyir4simCBAgUigN4YXGFOdbk1Xa
   JFPEOEkkr/LOaiP1o7VHObxRqlVj/10CqNrmuO78iAYWV2sQHOa6DBlrX
   Bbn7JsqF9XAAxS/jO/MxfVD0JgSpKTh1YrBg9yaGMXqv2oN9Deqxlm/QP
   IZLFMKrLuoGQwAXnWh55XJ+UPRXOKnwnnz4/I4l3NNA5QRmxEwW7a/uS8
   2xbmhHL9IuyPP3WqqnBHyWOnGRClDbUT7aWCE6i3le/kKd7BpufwkabBQ
   9jDf8rIjFYkvnyyZgCHAsKjps3endAprDIjupY+7M7qROL9fKrBFvU9Cn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3848096"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3848096"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:50:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7939306"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:50:24 -0800
Message-ID: <83ddabf1-e8a4-4870-a9bf-79aa45793056@intel.com>
Date: Thu, 29 Feb 2024 21:50:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/21] KVM: x86/mmu: Replace hardcoded value 0 for the
 initial value for SPTE
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-4-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227232100.478238-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> The TDX support will need the "suppress #VE" bit (bit 63) set as the
> initial value for SPTE.  To reduce code change size, introduce a new macro
> SHADOW_NONPRESENT_VALUE for the initial value for the shadow page table
> entry (SPTE) and replace hard-coded value 0 for it.  Initialize shadow page
> tables with their value.
> 
> The plan is to unconditionally set the "suppress #VE" bit for both AMD and
> Intel as: 1) AMD hardware uses the bit 63 as NX for present SPTE and
> ignored for non-present SPTE; 2) for conventional VMX guests, KVM never
> enables the "EPT-violation #VE" in VMCS control and "suppress #VE" bit is
> ignored by hardware.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <acdf09bf60cad12c495005bf3495c54f6b3069c9.1705965635.git.isaku.yamahata@intel.com>
> [Remove unnecessary CONFIG_X86_64 check. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


