Return-Path: <kvm+bounces-53730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4CD4B15F0D
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 13:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 582721882AC0
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 11:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8987C29993B;
	Wed, 30 Jul 2025 11:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bf/NApAP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3222B284B41;
	Wed, 30 Jul 2025 11:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753873481; cv=none; b=TwJkH9R48aI8kPo89o28uRg/To/wBufZte4WNUnPN1GkmD+lGQu08ZNQHWKHAMHJw7zl4FuCRlwonxc5E50ydR3cgy8APZVpZcv/ZY6NgvCUb/V22l5H7Lg/B1CF6Ve7YJjoXKu86Y5hk9z7AtI84Kw0v4ZHRiaSM+OzPKa/JPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753873481; c=relaxed/simple;
	bh=ztg7FRt5UKPNEA3tAFLtII2s8T5WXcv9COtdzco54FE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPOWdIBzSZmaQIG3/5YeAhzFXhGIldzwMTZV7AM7dngQlBoBVAwatyhiOyupkZTPtlXRk9h7AXZKqioJD1Ah1yf+4HQBZ0WuTXn2UocIMq2CHCXD39MRo1Vp3SsjEl36Dl4G21psLWpAoLe9o9lXe5HxZd7GcR4/WYUYjOt+Kf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bf/NApAP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753873480; x=1785409480;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ztg7FRt5UKPNEA3tAFLtII2s8T5WXcv9COtdzco54FE=;
  b=Bf/NApAP87TA09MvneuADSkEPalrND3k4AT6VNj2gE905XEjibgzamRJ
   ZawiIT55LkhsUmQH+WqEfw5DCdr4pYKat7ekpO5eDcXkczDJM+Q8i5Cz6
   U4aqvBDVL06yjC4pfImJo8xgeMvCk/fnFKjTYLUG/3ygbT2EhEGn+CqnZ
   4pY+8g18M1OJp+MqEC+S5ZhXj1Ohzmnu4IXdnZv+QvjhZwPM17U95proW
   DjLbKC/2ZOPydJ8QiEI/HM/lxcK2KlHsoNCEAAlR0dwEwNRuQD2AumySZ
   jAkFM0yCFRk6UK/FTFU5M/92C2IQPMEIRJv8mAswgl17lR3zlWE8V+irD
   A==;
X-CSE-ConnectionGUID: shT9MtguRjm7m9v3FXDELA==
X-CSE-MsgGUID: JdBKKXhuQ6KCogARrS0ETw==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56055959"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56055959"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 04:04:38 -0700
X-CSE-ConnectionGUID: fC9Y47YQSmqENkR33+2+jw==
X-CSE-MsgGUID: KMR8BEEmSC+9bp4GEfwV/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="193801210"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 04:04:32 -0700
Message-ID: <f0378019-01d7-48df-bebf-d2a59e9d8582@intel.com>
Date: Wed, 30 Jul 2025 19:04:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 22/24] KVM: selftests: Do not use hardcoded page sizes
 in guest_memfd test
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
 <20250729225455.670324-23-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250729225455.670324-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 6:54 AM, Sean Christopherson wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Update the guest_memfd_test selftest to use getpagesize() instead of
> hardcoded 4KB page size values.
> 
> Using hardcoded page sizes can cause test failures on architectures or
> systems configured with larger page sizes, such as arm64 with 64KB
> pages. By dynamically querying the system's page size, the test becomes
> more portable and robust across different environments.
> 
> Additionally, build the guest_memfd_test selftest for arm64.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   tools/testing/selftests/kvm/Makefile.kvm       |  1 +
>   tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 40920445bfbe..963687892bcb 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -174,6 +174,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
>   TEST_GEN_PROGS_arm64 += coalesced_io_test
>   TEST_GEN_PROGS_arm64 += dirty_log_perf_test
>   TEST_GEN_PROGS_arm64 += get-reg-list
> +TEST_GEN_PROGS_arm64 += guest_memfd_test
>   TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
>   TEST_GEN_PROGS_arm64 += memslot_perf_test
>   TEST_GEN_PROGS_arm64 += mmu_stress_test
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index ce687f8d248f..341ba616cf55 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -146,24 +146,25 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>   {
>   	int fd1, fd2, ret;
>   	struct stat st1, st2;
> +	size_t page_size = getpagesize();
>   
> -	fd1 = __vm_create_guest_memfd(vm, 4096, 0);
> +	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
>   	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
>   
>   	ret = fstat(fd1, &st1);
>   	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
> -	TEST_ASSERT(st1.st_size == 4096, "memfd st_size should match requested size");
> +	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
>   
> -	fd2 = __vm_create_guest_memfd(vm, 8192, 0);
> +	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
>   	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
>   
>   	ret = fstat(fd2, &st2);
>   	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
> -	TEST_ASSERT(st2.st_size == 8192, "second memfd st_size should match requested size");
> +	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
>   
>   	ret = fstat(fd1, &st1);
>   	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
> -	TEST_ASSERT(st1.st_size == 4096, "first memfd st_size should still match requested size");
> +	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
>   	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
>   
>   	close(fd2);


