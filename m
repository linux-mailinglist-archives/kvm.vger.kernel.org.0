Return-Path: <kvm+bounces-51536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA50AAF864A
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EAA83B7005
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 04:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991EB1E25ED;
	Fri,  4 Jul 2025 04:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jr9jc0pV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC2F8F5B
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 04:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751602435; cv=none; b=NSteON93HV0ZkYh3uirLXW21Ag/oAw3mfVFCuaHuSv/r0TgfBuZX0uawz9ffYMitHTkR8E/0qcQ0OPOucu/W50X+n0zxE1gUv9icbNDS4MTlg7wg9Zp2HH1nACv9bmBvI8sPns175AJdtdvciY7+dqWPI5OQrZ0u/s56K4VV8SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751602435; c=relaxed/simple;
	bh=WW4JhfCET1Sp90wLio3HHFQ+bDrMu9NujLYRN0qFqT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fk4f5vZi+FoK81MnZnhcsYZYJrWiKlbT2r2EjDFYkn2V4OnY9zO0tk64bCpmQuOr7UejTLIYIOtaliag1QobNq25u8IeVb0d1vkLKYljL6AuESQUv4cd6JmiwrgwO0NAo7vyEM4YX6X+cQFO/VxrQI0Pqw5Unrym3jkmr5rvIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jr9jc0pV; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751602434; x=1783138434;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WW4JhfCET1Sp90wLio3HHFQ+bDrMu9NujLYRN0qFqT0=;
  b=Jr9jc0pVfUOFWvhY9KmeB7SsuxkOoUnm/bVamsv0czJ2ypYRhJD4uVre
   p2X0zOjsHqMR8a7ulvSsIMpU19BAduvLgqOa2tVNPgUNT5UwT08CTQjc3
   ItCp00uvgPiUjAe0w3ecKNLd1iOG7xTds8FbS+VHjWpxlBH66jZR04xVY
   I72CqSgrHZGuJJB1RKanpp79eebKM4Aj1hR9sTm+VirKMNB9Mqp2MFfJg
   pq2YASrigSoBk51gN79OjYVo3M6uYzSkaN4e4bZc42r1auliX944fen0E
   ccqWGqancZvcsjdQBTuoK+besWQZOtyQmPh9RCCmLlxnlImr7W3EKwdEi
   Q==;
X-CSE-ConnectionGUID: SHq1YzmiRHyJYg+6/vYq+A==
X-CSE-MsgGUID: TyAVqczTS82Y++v5VLWJ5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="41564556"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="41564556"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:13:53 -0700
X-CSE-ConnectionGUID: 9+K3I0TFTUuTrejo80dy3A==
X-CSE-MsgGUID: z8wN8IV5RjGk5fy8aWpdtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="185564976"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:13:51 -0700
Message-ID: <9292a723-eb6f-4106-bbf4-e046146686e4@intel.com>
Date: Fri, 4 Jul 2025 12:13:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/39] accel/kvm: Remove kvm_init_cpu_signals() stub
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-6-philmd@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250703173248.44995-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
> Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
> to accel/kvm") the kvm_init_cpu_signals() stub is not necessary.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

BTW, it seems we can further move kvm_init_cpu_signals() into
kvm-accel-ops.c and make it internal static function?

> ---
>   accel/stubs/kvm-stub.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
> index ecfd7636f5f..b9b4427c919 100644
> --- a/accel/stubs/kvm-stub.c
> +++ b/accel/stubs/kvm-stub.c
> @@ -105,11 +105,6 @@ unsigned int kvm_get_free_memslots(void)
>       return 0;
>   }
>   
> -void kvm_init_cpu_signals(CPUState *cpu)
> -{
> -    abort();
> -}
> -
>   bool kvm_arm_supports_user_irq(void)
>   {
>       return false;


