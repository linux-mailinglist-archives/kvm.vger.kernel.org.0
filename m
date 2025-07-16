Return-Path: <kvm+bounces-52577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC2DB06DEA
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9344C5650AB
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72BE2877D9;
	Wed, 16 Jul 2025 06:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnB2HHdo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1EC2874FF
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752647260; cv=none; b=JtCsfowcIe8SLZtaHl4clmqZNHoY27s6kQ9d/ER6BSSG/1ddxQ8JYVxyR4M9h9QV9ZeRmWjBgcZsQlxRzL+GkCrBkcN8lPvpoRF40Phhm0bf09aySlh5mt1oQbDSNm/6F+kKfqhkVcY4XEQa3iR3shQyeMEctgmwyFPE8Z08hQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752647260; c=relaxed/simple;
	bh=Nm6wYWpaUTxUQrksbS/WulWRPA20L3tmmXTPB37k/8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MMsZBWs57d3DochfxGse/bUvvDQUv/RO9REgtvvFAi3ql+peuuwiq0b5PwYveFQXVYA68195fB5nq3HKppERY10ZiqrSZm0ufSu4ilzbsPpKoEiYecZi6PwfNu7Q8ecLhCuYEA6jk7ODsSS5VgUmGWRtKWny9f62ygKHwMBXSmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnB2HHdo; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752647258; x=1784183258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Nm6wYWpaUTxUQrksbS/WulWRPA20L3tmmXTPB37k/8A=;
  b=BnB2HHdoklSgjiDPuTUbYQhPmfUCh5xJ8Y7zuh8lGkyorFFeWbLVawES
   yd8Pkp4VNlj51hOxHpyUXdnIeBOLCcyQoNiutNHLRUGwipSKpJch3DyoZ
   t4Ot2ynJd2a3Z3U7rwhmjro9mV/qu5HtMkmNRJkyIMa87afeg1qJ7B0tQ
   I8lol3t9zAY7ORkMKFdJgx8UoFQHH4JEh4VHQRNR4AybI+/yppmcXCTx6
   Yx1zDckQ4hseuiwFsK07/RSKE7+RfzM3I3U6ClllSmQFBvSGNjLo5cD/V
   bwVfGhDWbBLG5OZHWqAqyUs8Yn6Yan/f/mLCV3iyIYILYUEjVE0N/NKjB
   A==;
X-CSE-ConnectionGUID: DVE1nbp5SsWWUhb6MHffQA==
X-CSE-MsgGUID: 5A/zYoquQSSZLQqVX0hBzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54819074"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="54819074"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 23:27:37 -0700
X-CSE-ConnectionGUID: cHc9Z1nyT8Gr5uQWj6iK0Q==
X-CSE-MsgGUID: 35RxXw/uRlak7L5rmo3dsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="158145049"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 23:27:35 -0700
Message-ID: <59ec573d-c489-4008-ac87-6d8c207b7e4c@intel.com>
Date: Wed, 16 Jul 2025 14:27:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] target/i386: Add TSA attack variants TSA-SQ and
 TSA-L1
To: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
 zhao1.liu@intel.com, bp@alien8.de
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/2025 3:46 AM, Babu Moger wrote:
> Transient Scheduler Attacks (TSA) are new speculative side channel attacks
> related to the execution timing of instructions under specific
> microarchitectural conditions. In some cases, an attacker may be able to
> use this timing information to infer data from other contexts, resulting in
> information leakage.
> 
> AMD has identified two sub-variants two variants of TSA.
> CPUID Fn8000_0021 ECX[1] (TSA_SQ_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-SQ.
> 
> CPUID Fn8000_0021 ECX[2] (TSA_L1_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-L1.
> 
> Add the new feature word FEAT_8000_0021_ECX and corresponding bits to
> detect TSA variants.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
> Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Babu Moger <babu.moger@amd.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

