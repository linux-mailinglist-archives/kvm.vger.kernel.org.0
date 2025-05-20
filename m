Return-Path: <kvm+bounces-47070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43162ABCF13
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CD441B662B8
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 06:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9732A25C81C;
	Tue, 20 May 2025 06:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="asgtZigA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741E0257458;
	Tue, 20 May 2025 06:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747721905; cv=none; b=Wp3FjgOPXJ+2dvaiQjJL7jrwi1ulcI8H5cwMZ3Mk3k4zJSCmE3Rpi4zv0pm65zFuvpFZFRFC4Uixlw6qvIwltT6bCS64lX2KCQZ1oQAPztFWDxfVBTTZl+JSPi7TnDvSfKvw8jdATY+BMGxnABPPZ1bSZfWZDOVvwn1mLIolnHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747721905; c=relaxed/simple;
	bh=o1xCpNEMbDjTTk66YgQEoyS1BZUjioXOf8Ik7VxKouU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQeiOZoE4owckICI9ZAejncVDsKLPGh2MSzNNmMHyUtnA3guaHHSLIDqCXdOrz4AAGxagR8hGVLAWkGs6tPmG50+QYvPY8lTadkIsX6gh0DnYhBk69fC3tgTpLy0NnkXdl1JxmNvc2p7USYkM2Kv+vcEPdg0ovoNvNFX7W7Lt1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=asgtZigA; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747721904; x=1779257904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o1xCpNEMbDjTTk66YgQEoyS1BZUjioXOf8Ik7VxKouU=;
  b=asgtZigAFCbYV7Bhi5pTAd5uv6g+l9E10eMnvGuhrDa+DBFlLVf5oJ53
   OjAJEUzaXzW/dmyjbtK7E/9dsXm1cJWBmcwTjZ3LyxXYQqiGCVNANSMrZ
   6fYPaUjaY13lNC5vQza5/uQzeCW9nFf+GTwFa2PLpx8jkVV6JuMqflPPl
   6xVnQqctzN9tRoGDlJnTkfMhev16wytGF7Z4tjYuGA0w8KIz3/BgN4WTy
   bLIwTubkRftwGk4wZR9sbrqdQnz7E0fFEENrLSPxF59w1QQhzG6FpnEtp
   PdX5d4U0XIv/HXVWGJ6C8YcqAvzBCSNhoYcq4sZylixHe1ANa7lGY4IU6
   A==;
X-CSE-ConnectionGUID: 4aDnMDaVTmiCjFtpIBov3Q==
X-CSE-MsgGUID: 0fXGjlGRT1i4IjaC+TpAfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="52272222"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="52272222"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:18:21 -0700
X-CSE-ConnectionGUID: 3QdZmpM0TGeqCnxZ+6/uGQ==
X-CSE-MsgGUID: dfWHR48IRLS0cUiQWUxxfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="170608317"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:18:14 -0700
Message-ID: <22502c16-2733-4d48-892c-3e09dee1aa28@linux.intel.com>
Date: Tue, 20 May 2025 14:18:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 15/21] KVM: TDX: Support huge page splitting with
 exclusive kvm->mmu_lock
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
 <20250424030800.452-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250424030800.452-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2025 11:08 AM, Yan Zhao wrote:
[...]
> +
> +int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +			       void *private_spt)
> +{
> +	struct page *page = virt_to_page(private_spt);
> +	int ret;
> +
> +	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE || level != PG_LEVEL_2M, kvm))
> +		return -EINVAL;
> +
> +	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
> +	if (ret <= 0)
> +		return ret;
> +
> +	tdx_track(kvm);

It may worth a helper for the zap and track code.
It's the some code as what in tdx_sept_remove_private_spte().
So that they can share the code, including the bug check for HKID and the
comments.


> +
> +	return tdx_spte_demote_private_spte(kvm, gfn, level, page);
> +}
> +
>
[...]

