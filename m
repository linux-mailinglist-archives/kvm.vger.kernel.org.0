Return-Path: <kvm+bounces-10774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 405E686FC82
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F01832813FC
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6BE1AAD8;
	Mon,  4 Mar 2024 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NXgqHGRV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE914A8C;
	Mon,  4 Mar 2024 08:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709542622; cv=none; b=UH3XfNTJ9RL2qPdFz9F02aBlkj8M17n38X9JwnD6+DY7qsI/cYLlU6Le1EMlrX0KRwc+bEfFDcyZgyqPFi7bGqWpxHI8uZp2j0CEf3XafPL8e2oB/fU14RHcdmijF+aJmDwPYSn7SxmUdKAElm7i93+4wmbGuZA2kwBBtLbq7+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709542622; c=relaxed/simple;
	bh=sr6gtABwiwykguXjTH272CA4oVkPXPYSSJvrXaGgQPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q7zt0pEPk17PGmBqiVl+KFchAobhBch+w8zFU/bRsWowKQnOc0dFSnGzZfqIsBUVcEjPwn6bqdUB6Z/4IjGjGM1OqihDSJqd55Y+C92XI8XH4PUxOiFzeOeN0fgNXAkuqNAolRhcPhMRB/ze8FnKwsl9L/OkJFJlhF0GhuVAf0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NXgqHGRV; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709542620; x=1741078620;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sr6gtABwiwykguXjTH272CA4oVkPXPYSSJvrXaGgQPE=;
  b=NXgqHGRV6DV/wGGLAwL0Oz9F7xB08lDYPfbcarU4Jp6OmFcHwotVFau/
   UHKY1NEQKny/+VjT1HE9uNq3IRsIQEpPS434A9U0ONCi78lDfmQ+nqr2h
   8rvD1T78u2KNdIsM8c9GrSNcErk8aU57pKIFIhTiCwEXh3Q30NsCa8aVE
   nQ9sP/Hu5seC7N+gE3MwDWlZb25erjHqoyjSZIH1HD48uJjTTHcZV1Nlp
   Niy+N977GRn/3w//xPehwtSXTSTVIPocF9LiU1pSwf4EwFsiUMXSH0p/H
   0TKTuOl+ltBiwdYI1ixi0muwtSTz/XhoNjFBznunfTPLRv5M85/tTW9rP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="6974452"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="6974452"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:56:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="9295607"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:56:48 -0800
Message-ID: <754f2fcf-fc00-4f89-a17c-a80bbec1e2ff@intel.com>
Date: Mon, 4 Mar 2024 16:56:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/21] KVM: x86/mmu: Pass around full 64-bit error code
 for KVM page faults
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-14-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227232100.478238-14-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
...
> The use of lower_32_bits() moves from kvm_mmu_page_fault() to
> FNAME(page_fault), since walking is independent of the data in the
> upper bits of the error code.

Is it a must? I don't see any issue if full u64 error_code is passed to 
FNAME(page_fault) as well.



