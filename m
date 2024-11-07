Return-Path: <kvm+bounces-31065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 793A19BFF3F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 08:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDAFE1F23D88
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 07:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C64198A31;
	Thu,  7 Nov 2024 07:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipV5OUhY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3A194C6F
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 07:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730965178; cv=none; b=X10yQ8vwx9kGRjGYjZnlIW0AbpyEoaciMLzi+EqrNNekqKBQqn+vREQ0dfOOXdSP/uVJgbIXCLYwrxO00yi+dS2QrHEv7XE9LLanTghPWzuH+m8v5Ola8USOw4jHeGlrql9lQG7lkylMVQwe78Zq8L2zpvH5CxVSKrxxSaiPEug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730965178; c=relaxed/simple;
	bh=o3PUuxafAuNLu0KCEN1nvG6vAa6h5dDNS9Y7mqKnbo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueI13EiZZogDz6wrFleL1WvdhiEeEYfpF9YklpA+1QpxqWpGQjnnMOM5OpddoSKMMiOaW1KPvEpcuT6Rb1Yb50c4jP6fRRHVw/yH+427fACy5PTSNPnx3pYb0S27A/4oxBEY1gFa2YwfO94EN00sCsR3K3GvEza0IZgtsVxJKy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ipV5OUhY; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730965177; x=1762501177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o3PUuxafAuNLu0KCEN1nvG6vAa6h5dDNS9Y7mqKnbo8=;
  b=ipV5OUhYC2DkKWJhQL1jxTp1rwi/7+TtK7dnK1hMCVNS6bdprymu3dNK
   sQI+kb5u93Z+VHKGUJFiZOQ+3+C0KbG5w1fW1j3eRVIfgtNig25faQ/+W
   91RXAGW6LAg5ajUnqMjE+s60y/qg1FVdhMt5Bey3/qeyGJ5Uswzw+g2MZ
   7qCl4ay+KxaE7xcZj2oQ8rvJ0hgz8T9u864V3Yn+TD+sch05w9lx2Kvba
   y2ZxDCgitrZYJhIh5cIRHqPAKS5XA7N7UlRQWCfChtsvoSIQGiYDui0Vg
   eUruXrGsovSTX5kXQIxv/CPx5wjmfDsep3zaXwaFGpHYboCTLsfmg51Km
   w==;
X-CSE-ConnectionGUID: 9ufxRz1jR+uks+6p3QWejg==
X-CSE-MsgGUID: Ed6zQbrQSAC33i8kFAFyqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="48312056"
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="48312056"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 23:39:36 -0800
X-CSE-ConnectionGUID: xnS3xB5oS92ZYXiVssGaAw==
X-CSE-MsgGUID: KgYwXGwqQXaz1JOmikcEDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85762334"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 06 Nov 2024 23:39:33 -0800
Date: Thu, 7 Nov 2024 15:57:28 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: dongli.zhang@oracle.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, joe.jin@oracle.com, davydov-max@yandex-team.ru
Subject: Re: [PATCH 1/7] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
Message-ID: <Zyxy6IL5oOP1NFrn@intel.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-2-dongli.zhang@oracle.com>
 <ZyroXEOsRPonKD7x@intel.com>
 <7497ade9-de05-49a9-9419-83e015646ebd@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7497ade9-de05-49a9-9419-83e015646ebd@oracle.com>

> Thank you very much for the suggestion.
> 
> Yes, this works. The PERFCORE is a prerequisite of PERFMON_V2 (according to
> Linux kernel source code).
> 
> 1403 static int __init amd_core_pmu_init(void)
> 1404 {
> 1405         union cpuid_0x80000022_ebx ebx;
> 1406         u64 even_ctr_mask = 0ULL;
> 1407         int i;
> 1408
> 1409         if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
> 1410                 return 0;
> 
> 
> If you don't mind, I will send the v2 with your Suggested-by.
> 
> Thank you very much!

Sure, welcome! :)

-Zhao

> Dongli Zhang

