Return-Path: <kvm+bounces-38680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1187A3D934
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:52:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 513F9188E10E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D021F460E;
	Thu, 20 Feb 2025 11:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eDRIzRpC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBDD1F3BBE
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740052343; cv=none; b=s6OyUKX5khYMbMINliZO1Vh/lkoobp6YCUqbL7C3dZIkHFa8PWTFyvhjOLSIkv7DcdhTNM6ZdGSJnrpxPVx2safsF/RLZXAkHfWQeaISNkE5ksHGNRSn98NdaeoKIGOhIsygY0L2VgYW8934pAqKh9nNuI/+3kGl7PsfCh/Cdo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740052343; c=relaxed/simple;
	bh=fla4TsChoauH/FZHbft2/awrwcbSsmH9YvqhF93NDck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIiAceQpTZHpQ+Zl8nRBqnwSdLgvPmbrhtSYOlQcm/6/0cyJ62OqhubiOz0ckUQqGP7AmSgo4bXx2XFIADen2HErq9JM6+GQp8PNd/0QOEdqhtRmt686Vmp4JblbFfVi1Fe3FVDCg8LS1fYJt7KfnFi8nGpGxTsIgGLDg78wOhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eDRIzRpC; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740052341; x=1771588341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fla4TsChoauH/FZHbft2/awrwcbSsmH9YvqhF93NDck=;
  b=eDRIzRpCRTIj5ES8ueVXHQMfTlhMVmdtn4jhH3t0Wwigz9MnF0GOI0An
   Zagy2Tv1ALVt/0LpRy8VRFj2Gkp6QsbfpBNvOcWYwHb5qNHYijogXhenG
   38aBZLKAUEv4oI7Ao1rZzfSL3kY8maHbeMYuDrJEg7ruF+V6sFjOsvMQT
   weSLUqTCSXjz7+rqQqDtisIdyDc55lRzLshl4CEsCbc/M+K5E3azfVD8M
   zoGqDAh+EkV0tpW96y85DcYMBWHmIETLGKB4oP+Mc7MZFk5AfxW1JIzGl
   on+6MqKdfebCi91Yq2UQG9y7va/3shG1+9pEPr0zURuIHSLRlqeqfv5+B
   A==;
X-CSE-ConnectionGUID: bWkfYMlKR9GGh/EsvJcq7g==
X-CSE-MsgGUID: 9iqLIPo0SJm1yDoOQgZj8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="66184856"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="66184856"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 03:52:21 -0800
X-CSE-ConnectionGUID: A0Leyr2BTzuvfTBz+ciupQ==
X-CSE-MsgGUID: gwEu5mGZQcSCfMOZta6ZEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114872142"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 20 Feb 2025 03:52:20 -0800
Date: Thu, 20 Feb 2025 20:11:54 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru
Subject: Re: [PATCH v5 6/6] target/i386: Add support for EPYC-Turin model
Message-ID: <Z7ccCtbPPuRRdGUN@intel.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <3d918a6327885d867f89aa2ae4b4a19f0d5fb074.1738869208.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d918a6327885d867f89aa2ae4b4a19f0d5fb074.1738869208.git.babu.moger@amd.com>

> +static const CPUCaches epyc_turin_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 48 * KiB,
> +        .line_size = 64,
> +        .associativity = 12,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,

true.

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

true.

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

(And it would be better to add a Turin entry in docs/system/cpu-models-x86.rst.inc
later :-).)

Thanks,
Zhao



