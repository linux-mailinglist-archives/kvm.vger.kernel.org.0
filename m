Return-Path: <kvm+bounces-38664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5BD9A3D79E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B65C3BFAF7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 10:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110851F153E;
	Thu, 20 Feb 2025 10:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MMV4a0yT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB771EE032
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740049129; cv=none; b=pBZCR7EKmeiKqvjsIvkQmG/gwrRwyJaeS1008eNkywPtzHiRsMwDyebJH0amCTC9sjKAAvjantXpMPCAJWFM9jYorElAngeBEfMWUQxJpBiM6/odXh55+r9AXRJlFfTPoJ/MOEuuUrHRgN6bHbFK6QNl1eCwW9kdcRQRV+20t2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740049129; c=relaxed/simple;
	bh=peXBWKLlJoZ0te86jGaqhSVx6k4fQXBrx/kZt4Y3dFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/gHsgeKEyf9PU/rFQeluiBDPzlC29LGZqp9xZR6Ewyu30DlW623XwzLb84CQXRlEzrNKlVZ1AMWM+bo+xVP/MI6mr73X8T/D8EsQhypOMD38TOcN190jpAVDJJU5XiUdFSo2VZ/D13+Kh4JzHp2lqIwz3muv3l4Mu0ejeJTfW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MMV4a0yT; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740049127; x=1771585127;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=peXBWKLlJoZ0te86jGaqhSVx6k4fQXBrx/kZt4Y3dFo=;
  b=MMV4a0yTSLUTNzuTgrZV9xUXKIkI1PdT+rRtI2Zyk0Lotx/ytOLI37LB
   usc0QKCVxKVLzCK9E7qg4m0R0BSn78VBiGUmA7aS9dXw7Q/MT5QoX4c0M
   F8YhjVcIjqv67114Hq78BjWbfUgFW9w8ki4vcRY7TdpX/sdk05xlT44gk
   xbWvalGE+ag1SgVCPLYCz+zoMjGodjNfWkPF8ZEW+TehKPE6A+nKFDliT
   KwLR8F3vdRipWjgLxp5ITZYYk4RApYQ4U52zeSoC3rv/vNrqo+7rOQlSC
   VzpnEatL7nCzCEMVV20BUySFdZ90r/oWakjCz6A7Pl8KOQrCb7AZSwu18
   Q==;
X-CSE-ConnectionGUID: pZk5DOe7S32+TVuy8YSj+w==
X-CSE-MsgGUID: +z1qFi3CQ0+YQMyM3NosLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40959994"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="40959994"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:58:46 -0800
X-CSE-ConnectionGUID: X65XWnxYRJ6my0mf/THp2Q==
X-CSE-MsgGUID: XqCrPXq5T1uDp7bf4/7ASQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="114737261"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 20 Feb 2025 02:58:45 -0800
Date: Thu, 20 Feb 2025 19:18:19 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru
Subject: Re: [PATCH v5 2/6] target/i386: Update EPYC-Rome CPU model for Cache
 property, RAS, SVM feature bits
Message-ID: <Z7cPeyLAuNDL0Oc4@intel.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <8e40e18b433d2d152433724a15bddcacdecbf154.1738869208.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e40e18b433d2d152433724a15bddcacdecbf154.1738869208.git.babu.moger@amd.com>

On Thu, Feb 06, 2025 at 01:28:35PM -0600, Babu Moger wrote:
> Date: Thu, 6 Feb 2025 13:28:35 -0600
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH v5 2/6] target/i386: Update EPYC-Rome CPU model for Cache
>  property, RAS, SVM feature bits
> X-Mailer: git-send-email 2.34.1
> 
> Found that some of the cache properties are not set correctly for EPYC models.
> 
> l1d_cache.no_invd_sharing should not be true.
> l1i_cache.no_invd_sharing should not be true.
> 
> L2.self_init should be true.
> L2.inclusive should be true.
> 
> L3.inclusive should not be true.
> L3.no_invd_sharing should be true.
> 
> Fix these cache properties.
> 
> Also add the missing RAS and SVM features bits on AMD EPYC-Rome. The SVM
> feature bits are used in nested guests.
> 
> succor		: Software uncorrectable error containment and recovery capability.
> overflow-recov	: MCA overflow recovery support.
> lbrv		: LBR virtualization
> tsc-scale	: MSR based TSC rate control
> vmcb-clean	: VMCB clean bits
> flushbyasid	: Flush by ASID
> pause-filter	: Pause intercept filter
> pfthreshold	: PAUSE filter threshold
> v-vmsave-vmload	: Virtualized VMLOAD and VMSAVE
> vgif		: Virtualized GIF
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
> ---
>  target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 94292bfaa2..e2c3c797ed 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2342,6 +2342,60 @@ static const CPUCaches epyc_rome_v3_cache_info = {
>      },
>  };
>  
> +static const CPUCaches epyc_rome_v5_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,

This field could be true,

> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,

ditto,

Compared to the previous cache model version, the differences can be
checked. I feel that in the future, when we introduce a new cache model,
it's better to avoid omitting items that default to false. This way, the
cache model can correspond to the output of the cpuid tool, making it
easier to compare and check.

Overall, LGTM,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


