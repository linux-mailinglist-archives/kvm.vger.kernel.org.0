Return-Path: <kvm+bounces-55856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E85B37DE2
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDC26683E58
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D11C33CE9F;
	Wed, 27 Aug 2025 08:30:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512DD2F28F4;
	Wed, 27 Aug 2025 08:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756283427; cv=none; b=VuZiU6GnS/sTUmv3jhnH3O6thdzMVy4uYOJhnVRwk/71MITCGY0zX58zYX6kW64WoT2Fn/vA3T9/vKxZrSE/nU0LcNpnWE7sdFi/jSqTgXZv8NXSo+xR4CjYaedV7QheOABYlnd6zyEFY+r0bUzfzBUnogfJTBwjVqQRrJEhQek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756283427; c=relaxed/simple;
	bh=Hk1XVBq87Wloo/8yCfniyVuXNqm9lv0mufttpAK51xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpuAkaZXloYtH7G9BwO2wzd6Cpcwf4zwD5GmddNF03SQmLevsER5LO2jxINpVLqqeyM2BApwTT0aWfJ+3GgbFF1yyma7t0wo+iNd4bwILue6BkFWXPoTP0jMGUi5pUfGn36RYW7u27PQA/uMIvq/SwpSsuAYLRlQgpw+pIuRtgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 228811691;
	Wed, 27 Aug 2025 01:30:16 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31FA33F694;
	Wed, 27 Aug 2025 01:30:15 -0700 (PDT)
Message-ID: <70f4c2ce-1dbd-4596-af78-bca1cdbbb581@arm.com>
Date: Wed, 27 Aug 2025 09:30:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/18] arm64: topology: Use __free(put_cpufreq_policy)
 for policy reference
To: Zihuan Zhang <zhangzihuan@kylinos.cn>,
 "Rafael J . wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Markus Mayer
 <mmayer@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Krzysztof Kozlowski
 <krzk@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Thierry Reding <thierry.reding@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 MyungJoo Ham <myungjoo.ham@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Chanwoo Choi <cw00.choi@samsung.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Daniel Lezcano <daniel.lezcano@kernel.org>,
 Sascha Hauer <s.hauer@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>,
 Eduardo Valentin <edubezval@gmail.com>, Keerthy <j-keerthy@ti.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: zhenglifeng <zhenglifeng1@huawei.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Lukasz Luba <lukasz.luba@arm.com>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Beata Michalska <beata.michalska@arm.com>, Fabio Estevam
 <festevam@gmail.com>, Pavel Machek <pavel@kernel.org>,
 Sumit Gupta <sumitg@nvidia.com>,
 Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 linux-pm@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-acpi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-tegra@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, imx@lists.linux.dev,
 linux-omap@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250827023202.10310-1-zhangzihuan@kylinos.cn>
 <20250827023202.10310-2-zhangzihuan@kylinos.cn>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20250827023202.10310-2-zhangzihuan@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Zihuan,

On 8/27/25 03:31, Zihuan Zhang wrote:
> Replace the manual cpufreq_cpu_put() with __free(put_cpufreq_policy)
> annotation for policy references. This reduces the risk of reference
> counting mistakes and aligns the code with the latest kernel style.
> 
> No functional change intended.
> 
> Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
> ---
>  arch/arm64/kernel/topology.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> index 5d07ee85bdae..e3cb6d54f35b 100644
> --- a/arch/arm64/kernel/topology.c
> +++ b/arch/arm64/kernel/topology.c
> @@ -307,17 +307,16 @@ int arch_freq_get_on_cpu(int cpu)
>  		 */
>  		if (!housekeeping_cpu(cpu, HK_TYPE_TICK) ||
>  		    time_is_before_jiffies(last_update + msecs_to_jiffies(AMU_SAMPLE_EXP_MS))) {
> -			struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> +			struct cpufreq_policy *policy __free(put_cpufreq_policy);
Based on the guidance, in include/linux/cleanup.h, I would expect the
assignment to be done on this line.

"...the recommendation is to always define and assign variables in one
 * statement and not group variable definitions at the top of the
 * function when __free() is used."
>  			int ref_cpu;
>  
> +			policy = cpufreq_cpu_get(cpu);
>  			if (!policy)
>  				return -EINVAL;
>  
>  			if (!cpumask_intersects(policy->related_cpus,
> -						housekeeping_cpumask(HK_TYPE_TICK))) {
> -				cpufreq_cpu_put(policy);
> +						housekeeping_cpumask(HK_TYPE_TICK)))
>  				return -EOPNOTSUPP;
> -			}
>  
>  			for_each_cpu_wrap(ref_cpu, policy->cpus, cpu + 1) {
>  				if (ref_cpu == start_cpu) {
> @@ -329,8 +328,6 @@ int arch_freq_get_on_cpu(int cpu)
>  					break;
>  			}
>  
> -			cpufreq_cpu_put(policy);
> -
>  			if (ref_cpu >= nr_cpu_ids)
>  				/* No alternative to pull info from */
>  				return -EAGAIN;

Thanks,

Ben


