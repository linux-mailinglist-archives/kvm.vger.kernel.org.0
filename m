Return-Path: <kvm+bounces-44260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 712E1A9C136
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE26C924515
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1B323315A;
	Fri, 25 Apr 2025 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oqy03SyK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265B922D4DA
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 08:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570127; cv=none; b=jBVeI+qP0U2or4QU2ZqCuXkNPelxoXdSh3J/NHG3crYLDl/vd1QEAyO08WCTBNLgFB16Rqdym+M02RKWCtnyBDUMzc8K/6v1kEv5FqYoIM3bQtEdsRlJB1WKeIW20xDp7fFtnx514Juj/QbMW4xsVUhcVGpC5JlWM5UeiWyYITw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570127; c=relaxed/simple;
	bh=RwMNTg3WBWQ4a8WIx76dSHsYi7CDIjlLKh74S0G5rbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqxLFvUmSCLzwXClHSs3VLOf+3mmmFCIzayCb16ejhcoQn0ec4fbmWXXOaLCYle7c2aPcyF7MNFOTkAfPBjtUCV2b9OftChCmzmicG/vE9ZfvR4dNtE2eOrI/rsN0GTpryBqvgqyo2pPpTi8KMc+H1+V9OYgtHCU2ZMYb1+R5aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oqy03SyK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745570126; x=1777106126;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RwMNTg3WBWQ4a8WIx76dSHsYi7CDIjlLKh74S0G5rbQ=;
  b=Oqy03SyKaYY/L9erctggUDw/gSpVF2tTM9OW1JZr5V2J8SNgECGheZpP
   J9djEsz33jRystt0FALyO5TzzBWUP0AILOrUC4TWM6X5WeAU2qo4+kRjz
   Ddb8wBmFgUevbsCxd+3VCXistmdiHo322ogJImUqq34DhAKA303x8kfsy
   We4AkSLs89IEt16QqZUwjGFQJvSu23RIj8xUNSNYu1Gy5ehPCBrlp8WF/
   6LWzIMoKJN/ReH+MOpu6f8uFIICF8qeKN9HskriK4S4sAvsonsloucRct
   szlgDsXiuZdI4F5v1YXpW95b1fmSetLeH35AioqHu6vYQS83kCdjihu7z
   w==;
X-CSE-ConnectionGUID: DOmK38Y9TVS88hbU6Ozhdg==
X-CSE-MsgGUID: WcTGpnWLSVWiLRmFEDuw8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="64643795"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="64643795"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 01:35:26 -0700
X-CSE-ConnectionGUID: cqhfZVHdRK+lj3h0O7mKlQ==
X-CSE-MsgGUID: 419sEBXVT3GtDZNwsfRe7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="132730130"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 25 Apr 2025 01:35:12 -0700
Date: Fri, 25 Apr 2025 16:56:10 +0800
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
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
	kraxel@redhat.com, berrange@redhat.com
Subject: Re: [PATCH v4 08/11] target/i386/kvm: query kvm.enable_pmu parameter
Message-ID: <aAtOKvlY+X8ERZ/S@intel.com>
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
 <20250416215306.32426-9-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416215306.32426-9-dongli.zhang@oracle.com>

On Wed, Apr 16, 2025 at 02:52:33PM -0700, Dongli Zhang wrote:
> Date: Wed, 16 Apr 2025 14:52:33 -0700
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v4 08/11] target/i386/kvm: query kvm.enable_pmu parameter
> X-Mailer: git-send-email 2.43.5
> 
> When PMU is enabled in QEMU, there is a chance that PMU virtualization is
> completely disabled by the KVM module parameter kvm.enable_pmu=N.
> 
> The kvm.enable_pmu parameter is introduced since Linux v5.17.
> Its permission is 0444. It does not change until a reload of the KVM
> module.
> 
> Read the kvm.enable_pmu value from the module sysfs to give a chance to
> provide more information about vPMU enablement.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v2:
>   - Rework the code flow following Zhao's suggestion.
>   - Return error when:
>     (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu)
> Changed since v3:
>   - Re-split the cases into enable_pmu and !enable_pmu, following Zhao's
>     suggestion.
>   - Rework the commit messages.
>   - Bring back global static variable 'kvm_pmu_disabled' from v2.
> 
>  target/i386/kvm/kvm.c | 61 +++++++++++++++++++++++++++++++------------
>  1 file changed, 44 insertions(+), 17 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


