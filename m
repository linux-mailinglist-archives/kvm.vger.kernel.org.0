Return-Path: <kvm+bounces-70698-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SBr4ImLIimldNwAAu9opvQ
	(envelope-from <kvm+bounces-70698-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:55:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7EA011734E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D00CD3009E3D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 05:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1077532D0F3;
	Tue, 10 Feb 2026 05:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNtOSgt1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1044926ED3E;
	Tue, 10 Feb 2026 05:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770702938; cv=none; b=Bm+oWhSgpftQLL+sYJ3HjAo549EshZH338bAfCnEpCtx9YfDpyRh1YYOitBu/HputJDHsXrXlFL9O9iqWIdIuOeuwlV6TREaMjU5dGvTMe1vZ0L4+FVRp/Z1iDOOeeSs3jOV7YZmyPJNvaYppqOODNUowBs6NwVWVajC1vgJmGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770702938; c=relaxed/simple;
	bh=9nnWMdj/22l/UeayrTX5T1lj3a2Zm8Tv6HcRko/maj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAPvyCXIdo0cph6KsBT0xAcBN8cHNQTSxc5Duf9lAokZNjJSPO2ArwB4VKkgbGvIjwS7uTe2u2LRYkyu4Hl2Z60vC0L7F8Q/sSZ7k7gwtENd3Ul23TOJw4X4JvgOQwHd5Jd7aQk3bre2YLsfBv1EQnbyMA5ewnHUgG7sX8ZmcqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aNtOSgt1; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770702937; x=1802238937;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9nnWMdj/22l/UeayrTX5T1lj3a2Zm8Tv6HcRko/maj4=;
  b=aNtOSgt17uYI0ZhRJCdfu0cwXuayJe6shmzrNQpPle7+SVkMUgTGn3gh
   xhTeIk/1M4eBwHydAx1D9IZaLyC9zQL3OyvgM13UuBVMTChzGvgfnh4KN
   OX26Pm8uLbzLQ4Ffpr69iIxMURuYrfpQrxFHFCEOxIl+7J3GUIiqlJgaR
   ql4rpi/jioag67EdVkWGK7Pc9EM1opVf47jofoiQ3qXMg8CoaBIYqGM/Z
   I3oX3Zh0HkC9dWXgX+GnfENrU/bZzcVHr07MlheBEDPn+HAKrunV6to/0
   SXWks6BMu+9opE8vSQdO+Ll7Vl6npXeQ7CIEqWKivTR4W/t2roTSQFF89
   g==;
X-CSE-ConnectionGUID: kbMsJ551QjixW4ymF8gCMQ==
X-CSE-MsgGUID: 7fR5unBxRxmMMvdDevSBDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82552879"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82552879"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 21:55:30 -0800
X-CSE-ConnectionGUID: arSyvb8yT9+dGXp6koLMDA==
X-CSE-MsgGUID: OiiH5N3LTQOp/Uz4oFV5Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211845844"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 09 Feb 2026 21:55:24 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpgiY-00000000ogW-0ClM;
	Tue, 10 Feb 2026 05:55:22 +0000
Date: Tue, 10 Feb 2026 13:55:00 +0800
From: kernel test robot <lkp@intel.com>
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v6 16/19] KVM: arm64: Add vCPU device attr to partition
 the PMU
Message-ID: <202602101354.lZex1CmW-lkp@intel.com>
References: <20260209221414.2169465-17-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209221414.2169465-17-coltonlewis@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70698-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[01.org:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email]
X-Rspamd-Queue-Id: A7EA011734E
X-Rspamd-Action: no action

Hi Colton,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 63804fed149a6750ffd28610c5c1c98cce6bd377]

url:    https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20260210-064939
base:   63804fed149a6750ffd28610c5c1c98cce6bd377
patch link:    https://lore.kernel.org/r/20260209221414.2169465-17-coltonlewis%40google.com
patch subject: [PATCH v6 16/19] KVM: arm64: Add vCPU device attr to partition the PMU
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20260210/202602101354.lZex1CmW-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101354.lZex1CmW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101354.lZex1CmW-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: arch/arm64/kvm/pmu-direct.c:55 function parameter 'vcpu' not described in 'kvm_vcpu_pmu_is_partitioned'
>> Warning: arch/arm64/kvm/pmu-direct.c:55 expecting prototype for kvm_pmu_is_partitioned(). Prototype was for kvm_vcpu_pmu_is_partitioned() instead

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

