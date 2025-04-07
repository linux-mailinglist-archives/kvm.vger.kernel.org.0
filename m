Return-Path: <kvm+bounces-42817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FE8A7D7EF
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03858166CB4
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E52C228CB8;
	Mon,  7 Apr 2025 08:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="epyK+SrP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5AE226D1E
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 08:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014677; cv=none; b=tgoilCbQyOsG/tLrufz8hjRMnSLGxTNNIGVityxveNo7MG6UpmIQeTDR2/sM8m1xewNDBuk8flkzZgXRMqOUBxVLFJ65RgEmnJdjJrueIpJIz7aU9djca5L8PgsXAXsZG3Gd+B0exhBcQIUjAxeu3A+aVKX9N0ljvQG8+wvGWaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014677; c=relaxed/simple;
	bh=kZrG6A3qreL/i86/K2NTwOlUnRVT2U3MzsiWZCErg/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MK9ugwDbvR0f7mq3f1/QMVRDh0K0KVpeiYZKHc44/NRku2XmjRbQoHuXNYx3UmGKt7+2PpsNpltjH621ag4250pQ13XLYt3WgTKRPKFl2EPfhUMVpfREIQmk0a7drAimkV62ccL1cxUNBr4c+3YRt+IB7umYYRv2db2/oIyderc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=epyK+SrP; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744014676; x=1775550676;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kZrG6A3qreL/i86/K2NTwOlUnRVT2U3MzsiWZCErg/E=;
  b=epyK+SrPYZ/1gpUASMVmfUV496LA0B0RCo/2GMI0zuO1WN475rYyeiT/
   kcqY4raaJbMcZrd4tjPpjWzWg9xhT0GZqXcoUUwvAzgkHpJpOQ5jJDf8V
   BNOt7Lsw3CMAt/8te3xOkifM3eqhNNFbfMaAd/H8gOPKboM392n7+qcZq
   eiXU8WJMc3JYIIGn3+OLHroIEDsZ8c8CqS9x7KnFDJHooNmHk7pkDkTOK
   eLHy4BuoTyeqT+ut/EwYQvMfIRU15Ja7tDCYOoq2rmPkFB+Act1xV4rB3
   Sc/zdORenCqtuAwrwkhknGCCIBuc8E0J/6KlgNK8l5qb4/BNRO1+HkDQR
   w==;
X-CSE-ConnectionGUID: jGH6NG3QRfKz95rzGOG1Mw==
X-CSE-MsgGUID: 0Jx567W/QyuZok+MQ9rQaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="49179678"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="49179678"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 01:31:15 -0700
X-CSE-ConnectionGUID: 3UnJmUBtRACuOGFOxL2hig==
X-CSE-MsgGUID: /fy17LQ3TmGx2BKsh8y5Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="158851027"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 07 Apr 2025 01:31:09 -0700
Date: Mon, 7 Apr 2025 16:51:31 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, pbonzini@redhat.com, mtosatti@redhat.com,
	sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
	like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai@zhaoxin.com,
	cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
	frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
Message-ID: <Z/OSEw+yJkN89aDG@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
 <84653627-3a20-44fd-8955-a19264bd2348@oracle.com>
 <e3a64575-ab1f-4b6f-a91d-37a862715742@zhaoxin.com>
 <a94487ab-b06d-4df4-92d8-feceeeaf5ec3@oracle.com>
 <65a6e617-8dd8-46ee-b867-931148985e79@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65a6e617-8dd8-46ee-b867-931148985e79@zhaoxin.com>

On Tue, Apr 01, 2025 at 11:35:49AM +0800, Ewan Hai wrote:
> Date: Tue, 1 Apr 2025 11:35:49 +0800
> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
> Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers
>  during VM reset
> 
> > > [2] As mentioned in [1], QEMU always sets the vCPU's vendor to match the host's
> > > vendor
> > > when acceleration (KVM or HVF) is enabled. Therefore, if users want to emulate a
> > > Zhaoxin CPU on an Intel host, the vendor must be set manually.Furthermore,
> > > should we display a warning to users who enable both vPMU and KVM acceleration
> > > but do not manually set the guest vendor when it differs from the host vendor?
> > 
> > Maybe not? Sometimes I emulate AMD on Intel host, while vendor is still the
> > default :)
> 
> Okay, handling this situation can be rather complex, so let's keep it
> simple. I have added a dedicated function to capture the intended behavior
> for potential future reference.
> 
> Anyway, Thanks for taking Zhaoxin's situation into account, regardless.
> 

Thanks for your code example!!

Zhaoxin implements perfmon v2, so I think checking the vendor might be
overly complicated. If a check is needed, it seems more reasonable to
check the perfmon version rather than the vendor, similar to how avx10
version is checked in x86_cpu_filter_features().

I understand Ewan's concern is that if an Intel guest requires a higher
perfmon version that the Zhaoxin host doesn't support, there could be
issues (although I think this situation doesn't currently exist in KVM-QEMU,
one reason is QEMU uses the pmu_version in 0xa queried from KVM directly,
which means QEMU currently doesn't support custom pmu_version).

(I'll help go through Dongli's v3 soon.)

Thank you both,
Zhao


