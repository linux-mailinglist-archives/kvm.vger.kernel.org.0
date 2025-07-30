Return-Path: <kvm+bounces-53719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D98EB159AF
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 09:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B418A3BB873
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 07:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788B228F51D;
	Wed, 30 Jul 2025 07:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpg5HRUe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E4F1EEA3C;
	Wed, 30 Jul 2025 07:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753860995; cv=none; b=lKCUNOggeZhqFSfDWVFr5juAznDL4Wc2Jx6/ePHJwbeWYDgWHvQ1zUjRMWkk4IpRM8XzDZJpPYu0zFVOu0wtj8ep4CTlL1T8vGzr15ii1uKJuUHgyQhAfGAg9tv5t05XCFFlkyRq+CduR7LGGd2mpwZMgpwHam78QzuYJfrHFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753860995; c=relaxed/simple;
	bh=Lgxb6ChAZm+S1lYlYOHvTXOyDWJ1q94r2HzDlbS89X0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CfvHLqPxuey07vl+qrcQtBGsjeHhgX4EfISFv3XuIXIQn/qVHmgIOb4jw97ehgAYg8f94C+WD94YNNFuyNoCRaDqUNT/+6n/8670E3xBiBck1V82cfNwIKYCR/JE3phvK9oYDixyjbVutpwd3zXsmumvMR7bmzA3RzrCImw2pgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpg5HRUe; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753860995; x=1785396995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Lgxb6ChAZm+S1lYlYOHvTXOyDWJ1q94r2HzDlbS89X0=;
  b=bpg5HRUeEr6gvH0ceO+6fKNY4MwxOoyx3yzEA0/fdUIpfLIBL57hgZMT
   7BuecC8dXQFHspILxELWq5HsgJ5v6Zfn3pmakzjVhQ2Php3xk/RCSIGcZ
   ueRieLhQISvMeKMIBZoztbv1nU3wHXQVlJgOsePLUKiEg3rw2HTpuN+8S
   HpVOY7tz7quLo6hdyX2zwjmbFjzCLIgRfp9v49GWMSKSRLmebg9IZJTVY
   EyHciAxk0t1y6Er16UnemlpfSxTLn3NgJG3M2G2HYrMY0zTCsiYTE13no
   dvVjngF/6lN+6CYBVyjg1rJiwhHRhNVGaKtjcV8Cj556BBGdsvmrReLeS
   Q==;
X-CSE-ConnectionGUID: OEZ5wljfQ5qLlb3DjIkHAQ==
X-CSE-MsgGUID: FvGNJ7rnTfubnMmrpS2qgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56037645"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56037645"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:36:34 -0700
X-CSE-ConnectionGUID: OqQi3hkUReqqLpZr2iCwuA==
X-CSE-MsgGUID: DbgjJr6SStqDXDA73Xhbqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="167395533"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:36:27 -0700
Message-ID: <f61594a4-5823-453c-9f1f-8bd94d3ba4a2@intel.com>
Date: Wed, 30 Jul 2025 15:36:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 15/24] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-16-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250729225455.670324-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 6:54 AM, Sean Christopherson wrote:
> Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
> not just private mappings, so that hugepage support plays nice with the
> upcoming support for backing non-private memory with guest_memfd.
> 
> In addition to getting the max order from guest_memfd for gmem-only
> memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
> restrictions on page size only apply to Secure EPT mappings.  Do nothing
> for SNP, as RMP restrictions apply to both private and shared memory.
> 
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

