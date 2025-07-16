Return-Path: <kvm+bounces-52568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66473B06D1D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4CEA1AA7174
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0DE277CAD;
	Wed, 16 Jul 2025 05:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jF6mB9jG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820F31C9DE5;
	Wed, 16 Jul 2025 05:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752643270; cv=none; b=my8ZjJOBAj/55Zu9uSvRmIV3brKCsFWaY4M8cL7uGcjPrp6nivGWNUJWnrq/y6fUflNl4BS/GbyZD1Lf8P43R9AOcLxDOx80H5psUrlqIagA9uqNfCuoFyWVw1weXvR8PY414Som5U+HK+kv8R0v5Q+b8S4DTnWyzkGz5WeQrWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752643270; c=relaxed/simple;
	bh=Apgo83F8MuVmzXAF0LEpW/4FYIKirQ4fPrx9SMVQndM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQ7iyZqyn9/QDzFEdhAYZLZWqJcAXCAfdgrZzNENzyo7EjIA/QYG6v5CRj26vqsP2ORLnOguIOo2frpWGuPOhLGJIYbkoymdQIUPo/h75WJ4SK8H8dLr1x+oWDGPyHpp60V2csxHVCn553Ql5rGqA3tDgBL9yYnfb7gXE6Yt0Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jF6mB9jG; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752643268; x=1784179268;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Apgo83F8MuVmzXAF0LEpW/4FYIKirQ4fPrx9SMVQndM=;
  b=jF6mB9jGTuCLWccG228CC+m5KpMWT3ya06z7xeWNZ70bjSE1vD5Z0yPp
   yZrCD1WUKrBllrRl8Rh9+ZzTug7ZHZKQsafhAwdKcGEYUkUVYzjdLNQyC
   DSKIfy4yiIv2IrGFTawiI98HoiiLpGuiZwndyFYzJXO8DxokTEwrxQ7BF
   HEa76Y+IEtSqidexsIChZc6d0COnDW0GdelennKZy2fu2GohZPn+yaT5/
   myZvK65HyQJcwvhipOiMxWYK0Y/MCG6EyiCOehYpeZWE1Jf0ai3EsW5en
   LawZcUe/x3Z6lNkIe5vYDvEYEBLWmIImU+nuxG7yFfelr/nJ8/Iay6JeC
   Q==;
X-CSE-ConnectionGUID: SIin9SRLShaUCegqHjG9Xg==
X-CSE-MsgGUID: BVsj3A/6SdC42KoIXTn8Mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="66231115"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="66231115"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:21:08 -0700
X-CSE-ConnectionGUID: JrehOHLgSSSyzMf3ngGZWg==
X-CSE-MsgGUID: 0tdzYC4vSRiiC/1Tr1aoiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="194544482"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:20:54 -0700
Message-ID: <b3a76a74-3d7d-46ef-8636-fb06d4feb684@intel.com>
Date: Wed, 16 Jul 2025 13:20:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/21] KVM: Fix comments that refer to slots_lock
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
 <20250715093350.2584932-7-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-7-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> Fix comments so that they refer to slots_lock instead of slots_locks
> (remove trailing s).
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

