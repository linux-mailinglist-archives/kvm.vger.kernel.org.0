Return-Path: <kvm+bounces-47214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 386A3ABEA75
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 05:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCC0C179AA2
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 03:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B872722DA00;
	Wed, 21 May 2025 03:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KsnxplBA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDC428E7;
	Wed, 21 May 2025 03:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747798251; cv=none; b=syTfR54ePSke8ADiwxxBs4hAPJW+i2rGJmGwbgrdLP3qSK1A+f6h/3BHYA2kR32eClq9C3M1QZIJoeb2AFUK0aAujlB55NFp2cCl+C6L+mD0RiHRlBNhY9/qd3sDKjqME5292/CDC2GU4k7IlXvy0K3g9xWNxKdnObROEfjN0GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747798251; c=relaxed/simple;
	bh=6xcSYYrwRQcoLSrWNX+CBzb07UaJT/rmtXR/2L9OTJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ruBQbQN4ZcagoO955nkmtXn0wx+/do0FS+8VpoaPo/cHb+HcZ0HwCc5rrhHOM1VMc6p7ShZRx4g2S0mhWoq9EpjOb/9arhxlA0aRMFuPYbXXykwbXNBAyb3hRjnjej4IJdoXk7Xa71IkYoc9vZLc0F/J/fbyr8ZzkHm/Q5Sr1TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KsnxplBA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747798250; x=1779334250;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6xcSYYrwRQcoLSrWNX+CBzb07UaJT/rmtXR/2L9OTJc=;
  b=KsnxplBABR43sFyv4+ipBbbVeLI5i92iiK7qllTdR9ynsdJ59BnpUh1I
   hdz9SWGH/nUxZB0rQHzsBT5bz/cCBYLRz2pgCB/rNBIIGLXYioouQ92YZ
   TPdGTg0mhX59Tnx97B88zhtEdo74/CvkwvrxukNRorQiGHKojK5CpoSta
   p1LL979aF6DwowzHJS+GRTul0BDnfdA+oZG7/xWv+IUiOJdbuanFnJNVA
   lxDcsKYT+RGKxU7CqCxF3sIuJjHZrZQuyKCc48//wJR93IMkamhEEvSVy
   mFNtxKIZ5kuvauIsCWFqtlZWvTUHLUaEkd3pYYczTL+GFZo0nIIL5CgTy
   w==;
X-CSE-ConnectionGUID: 3KLFB+5QR7Wszf0ACdVT9Q==
X-CSE-MsgGUID: Ms1DhPKoQY+u8WNb66S/ag==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="53422797"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="53422797"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 20:30:49 -0700
X-CSE-ConnectionGUID: 8y0c0cNGTKSaccsUV6HyPw==
X-CSE-MsgGUID: bN+RWkfxTHy0RbTVidTswA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="145140186"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 20:30:44 -0700
Message-ID: <8e11fd2e-d77b-46cc-94c9-e542003c4080@linux.intel.com>
Date: Wed, 21 May 2025 11:30:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 20/21] KVM: x86: Force a prefetch fault's max mapping
 level to 4KB for TDX
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030913.535-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250424030913.535-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2025 11:09 AM, Yan Zhao wrote:
> Introduce a "prefetch" parameter to the private_max_mapping_level hook and
> enforce the max mapping level of a prefetch fault for private memory to be
> 4KB. This is a preparation to enable the ignoring huge page splitting in
> the fault path.
>
> If a prefetch fault results in a 2MB huge leaf in the mirror page table,
> there may not be a vCPU available to accept the corresponding 2MB huge leaf
> in the S-EPT if the TD is not configured to receive #VE for page
> acceptance. Consequently, if a vCPU accepts the page at 4KB level, it will
> trigger an EPT violation to split the 2MB huge leaf generated by the
> prefetch fault.
>
> Since handling the BUSY error from SEAMCALLs for huge page splitting is
> more comprehensive in the fault path, which is with kvm->mmu_lock held for
> reading, force the max mapping level of a prefetch fault of private memory
> to be 4KB to prevent potential splitting.
>
> Since prefetch faults for private memory are uncommon after the TD's build
> time, enforcing a 4KB mapping level is unlikely to cause any performance
> degradation.
I am wondering what are the use cases for KVM_PRE_FAULT_MEMORY.
Is there an API usage guide to limit that userspace shouldn't use it for a large
amount of memory pre-fault? If no, and userspace uses it to pre-fault a lot of
memory, this "unlikely to cause any performance degradation" might be not true.



