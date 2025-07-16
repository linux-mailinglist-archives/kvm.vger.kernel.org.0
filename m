Return-Path: <kvm+bounces-52559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25463B06C6D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 631D1566DCB
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 03:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C320F277CA0;
	Wed, 16 Jul 2025 03:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iuRuL/ds"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D1727510F;
	Wed, 16 Jul 2025 03:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752637440; cv=none; b=uWkJ7+s+7rbcMvXRd8Jlfv/j1Udg7Qf6/GWhlMD9q0xaRZ+0YfOeKkQLLlfxt0VPAlSNC82dR40d1NSqkISmz6nV0LObimyDRNcYjDLGM8wWmgkazlheXbVAI7dZqvqGPoCp0XHT7OxgHhxD8k3Wq5UPGxf9myWPJptuNJnQoPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752637440; c=relaxed/simple;
	bh=Fqhk2qhtOgsF+9qR826JiSghvMdaiAaEm/A0pVeWl38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WtFMlgU/t+q4Ai0Dt+LWHAXc3N1H6UEf+IUO7s/Cr8EmxfFRbKG3R6x39/sVZyNxgzPJNbzBd7v9BKDMcJTU+/Bjwkuro905KhdOPNhW2s4/obxkFv6frscQ1dX5ndvc9R+jKQHEBklFGpc8BZoZZgqlbjeePg7G5plmwnCH8Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iuRuL/ds; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752637438; x=1784173438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fqhk2qhtOgsF+9qR826JiSghvMdaiAaEm/A0pVeWl38=;
  b=iuRuL/dsGHkrEXUs+kspDj1MEaWjq+SXIAvecMMi00KJTyEApF8JQjkG
   0+PmkASMxhsY+aM0GfupVq8eNW5crGzYxfuHB7FH9aSBJLQ04gx85c0Us
   AtQPgTyLWErVz7HzyAEhtxzB/X52bX0kfnGo8eF/ARz3DKSVmDGgclT5y
   901tefqMlcUmYYV7xJmbQSTxs01X0/2frIxomZ1pfLb3GZkE+HHs1xDQE
   RIs/l/8gIK6Z6vjUySxaW6rz+6JyAiL68R0nmNZti6q4tiuX+OjKKK2CJ
   7CEAO8B0FUERXkI6YrQgAdWM2Uygem6lE4KAhJcomOIAiTScZXwcwLBNL
   Q==;
X-CSE-ConnectionGUID: HnIS1QWiSBCl+Qvlz+B3LA==
X-CSE-MsgGUID: d1qGLgKiSQmgEpwjatYs8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="57477159"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="57477159"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 20:43:57 -0700
X-CSE-ConnectionGUID: aPoQlabCQ3qZylzFjWdX/A==
X-CSE-MsgGUID: Kqz36sLKTp2ZwCHMnpujrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="188397958"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 20:43:43 -0700
Message-ID: <8f8f15a2-ac5d-46ec-a790-8a2428ff6af2@intel.com>
Date: Wed, 16 Jul 2025 11:43:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 01/21] KVM: Rename CONFIG_KVM_PRIVATE_MEM to
 CONFIG_KVM_GMEM
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-2-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> Rename the Kconfig option CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM. The
> original name implied that the feature only supported "private" memory.
> However, CONFIG_KVM_PRIVATE_MEM enables guest_memfd in general, which is
> not exclusively for private memory. Subsequent patches in this series
> will add guest_memfd support for non-CoCo VMs, whose memory is not
> private.
> 
> Renaming the Kconfig option to CONFIG_KVM_GMEM more accurately reflects
> its broader scope as the main Kconfig option for all guest_memfd-backed
> memory. This provides clearer semantics for the option and avoids
> confusion as new features are introduced.
> 
> Reviewed-by: Ira Weiny<ira.weiny@intel.com>
> Reviewed-by: Gavin Shan<gshan@redhat.com>
> Reviewed-by: Shivank Garg<shivankg@amd.com>
> Reviewed-by: Vlastimil Babka<vbabka@suse.cz>
> Co-developed-by: David Hildenbrand<david@redhat.com>
> Signed-off-by: David Hildenbrand<david@redhat.com>
> Signed-off-by: Fuad Tabba<tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

