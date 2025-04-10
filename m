Return-Path: <kvm+bounces-43044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B50EA8366B
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 04:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 467551B64697
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 02:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93351DB366;
	Thu, 10 Apr 2025 02:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eib1r9BR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D71C878E
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 02:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744251650; cv=none; b=GmuF8WPcdJmtpaowTfX0RQQ4DUOII5lvXILM2yDkUnW8jAdEWsUuXJIXZirVOq5xyGuv0VEJuOE07eZMCBsK5sxbltIUZh+BsO7Mn9lY9Ewx0xxm1apgvzcmXCggwMiyAL1F8RjaEtGX4c0nK9IWOkJXXnELv1asZWaKu8hl8vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744251650; c=relaxed/simple;
	bh=N/CZ9fUsPlUSKuyUXcdSU3b8XXzkRmBDT3dSqkO2yL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EjSfWeWmvVNufRNarJ9zTNhRqoCsvXwJVEqA1Jfs7AXWA136WfxzcJzmzo4fvSnwis2DxLxceAYEpd3u9lsor9xtJipxCk4P0BJSQKi/64mY298Gg5JaLcPNVNMp6aAR/cx2uMadj+9r6YY6n+fwPzwwi1GWHI1sk9gbivDW+sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eib1r9BR; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744251649; x=1775787649;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N/CZ9fUsPlUSKuyUXcdSU3b8XXzkRmBDT3dSqkO2yL0=;
  b=eib1r9BRKQ4CNHxqn3QD8FwTRVdy2u6UzBXEeZ3YnffgP6QZ6VG6+mOp
   TeiBly4BW5LLLQQfuAYQgOuGVQi0yktDVFXelHI5US1m3FJQOsT5HNwQt
   JJkEn2kje5q6NX7+VFW5HZHGMuK1KKrKztCx7nxOQjcsV7fl09ggk31jx
   mmBh0l9VtztEUlN+vwHBH8mgCt7wGNP9kItAm7tOLEUjU+J0uduJrLz1A
   1wIga6nnNlImHxUQ7fZyu8Nige6ja0q7wzrGGEmQqoDlgDMv535XluolT
   f/FYAa4iuV9DHKX2Kw07O2Zkt4B+BiFbAozPD5sEdf1N1sA077piGWnTa
   Q==;
X-CSE-ConnectionGUID: 7WV4nFXtRKmI59EkKEMxtg==
X-CSE-MsgGUID: kk1PwlXORYSxhL8GHNapCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56418568"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="56418568"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 19:20:47 -0700
X-CSE-ConnectionGUID: bKFIMmGZTHaJskCfi9AWxQ==
X-CSE-MsgGUID: 2Y5avAX7QIGpzHaRBG2jdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="151936000"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 09 Apr 2025 19:20:38 -0700
Date: Thu, 10 Apr 2025 10:41:27 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
	babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
	groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	peter.maydell@linaro.org, gaosong@loongson.cn,
	chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
	jiaxun.yang@flygoat.com, arikalo@gmail.com, npiggin@gmail.com,
	danielhb413@gmail.com, palmer@dabbelt.com, alistair.francis@wdc.com,
	liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
Subject: Re: [PATCH v3 05/10] target/i386/kvm: extract unrelated code out of
 kvm_x86_build_cpuid()
Message-ID: <Z/cv155eTgVSW0rm@intel.com>
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
 <20250331013307.11937-6-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331013307.11937-6-dongli.zhang@oracle.com>

On Sun, Mar 30, 2025 at 06:32:24PM -0700, Dongli Zhang wrote:
> Date: Sun, 30 Mar 2025 18:32:24 -0700
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v3 05/10] target/i386/kvm: extract unrelated code out of
>  kvm_x86_build_cpuid()
> X-Mailer: git-send-email 2.43.5
> 
> The initialization of 'has_architectural_pmu_version',
> 'num_architectural_pmu_gp_counters', and
> 'num_architectural_pmu_fixed_counters' is unrelated to the process of
> building the CPUID.
> 
> Extract them out of kvm_x86_build_cpuid().
> 
> In addition, use cpuid_find_entry() instead of cpu_x86_cpuid(), because
> CPUID has already been filled at this stage.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Still extract the code, but call them for all CPUs.
> Changed since v2:
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Didn't add Reviewed-by from Dapeng as the change isn't minor.
> 
>  target/i386/kvm/kvm.c | 62 ++++++++++++++++++++++++-------------------
>  1 file changed, 35 insertions(+), 27 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


