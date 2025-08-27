Return-Path: <kvm+bounces-55866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 152A3B37E9F
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A97F1B66A67
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA9D34575E;
	Wed, 27 Aug 2025 09:17:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD21287252;
	Wed, 27 Aug 2025 09:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286278; cv=none; b=n2d+cg45hAZiFojIwdqlVHknhNW8NFKheAF1AJEmRuVT1zyCyfX/je+bN6z3QbFxgGYofuDCjErIk4Z44UUE4Cd0SHYae2DJy7eGPGqtuT2dxVWNgp2QuhF7DCsnqnPX8LSBEZu0rqyR5UQFwyQw1E6Xuh17TFPPS0pf0HASxhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286278; c=relaxed/simple;
	bh=D6tI8dFPhQO9vi/pFTz+Fl4xZHDFVpijJJzgtBdp4kY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhqTDRSFlSB5NtvohbFtanbo9B675qZNiNwpPajoRqQnS9inEjyMJHJeFIYFvrVL409DevK+w4aO2HnbPmH+VRqZGcIUZ1ETsBvzEppbPGmMh9UrwpHLtzxAsmd+G71IichAOxtNrv6OldgUVoJkHDYbJfULhL6IAlci9A5js2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7AA01655;
	Wed, 27 Aug 2025 02:17:46 -0700 (PDT)
Received: from bogus (unknown [10.57.57.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 588C63F738;
	Wed, 27 Aug 2025 02:17:41 -0700 (PDT)
Date: Wed, 27 Aug 2025 10:17:18 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: Zihuan Zhang <zhangzihuan@kylinos.cn>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J . wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Eduardo Valentin <edubezval@gmail.com>, Keerthy <j-keerthy@ti.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	zhenglifeng <zhenglifeng1@huawei.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
	Len Brown <lenb@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Beata Michalska <beata.michalska@arm.com>,
	Fabio Estevam <festevam@gmail.com>, Pavel Machek <pavel@kernel.org>,
	Sumit Gupta <sumitg@nvidia.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Yicong Yang <yangyicong@hisilicon.com>, linux-pm@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	imx@lists.linux.dev, linux-omap@vger.kernel.org,
	linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/18] arm64: topology: Use __free(put_cpufreq_policy)
 for policy reference
Message-ID: <20250827-vegan-blond-marmot-eabf13@sudeepholla>
References: <20250827023202.10310-1-zhangzihuan@kylinos.cn>
 <20250827023202.10310-2-zhangzihuan@kylinos.cn>
 <70f4c2ce-1dbd-4596-af78-bca1cdbbb581@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70f4c2ce-1dbd-4596-af78-bca1cdbbb581@arm.com>

On Wed, Aug 27, 2025 at 09:30:13AM +0100, Ben Horgan wrote:
> Hi Zihuan,
> 
> On 8/27/25 03:31, Zihuan Zhang wrote:
> > Replace the manual cpufreq_cpu_put() with __free(put_cpufreq_policy)
> > annotation for policy references. This reduces the risk of reference
> > counting mistakes and aligns the code with the latest kernel style.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
> > ---
> >  arch/arm64/kernel/topology.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> > index 5d07ee85bdae..e3cb6d54f35b 100644
> > --- a/arch/arm64/kernel/topology.c
> > +++ b/arch/arm64/kernel/topology.c
> > @@ -307,17 +307,16 @@ int arch_freq_get_on_cpu(int cpu)
> >  		 */
> >  		if (!housekeeping_cpu(cpu, HK_TYPE_TICK) ||
> >  		    time_is_before_jiffies(last_update + msecs_to_jiffies(AMU_SAMPLE_EXP_MS))) {
> > -			struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> > +			struct cpufreq_policy *policy __free(put_cpufreq_policy);
> Based on the guidance, in include/linux/cleanup.h, I would expect the
> assignment to be done on this line.
> 
> "...the recommendation is to always define and assign variables in one
>  * statement and not group variable definitions at the top of the
>  * function when __free() is used."
> 

Agreed. I did something similar recently and there was a code path where
variable wasn't initialised and ended up with freeing unassigned pointer.
So it is more than just a recommendation sometimes.

-- 
Regards,
Sudeep

