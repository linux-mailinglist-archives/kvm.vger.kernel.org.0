Return-Path: <kvm+bounces-50639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE95AE7B16
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 10:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0F3E3ADC36
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77D0292B32;
	Wed, 25 Jun 2025 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="et7ugwBt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74534289371
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750841875; cv=none; b=CzAU4QnM4+AiKyRkdJoeC24GBvjwi6dE0E4/dHoZvrHxdLxNwYAYm7AvJRRGVgSUSnoJ9pwyEjmLWHem9mZLckKXAbVBkLZY6D49dZdrJAxEFZdFsYeIFY7xNGshg9rsYIjdXkslyQLHnXM2yMnPwWz7+abm971tv0I22nMo0Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750841875; c=relaxed/simple;
	bh=cNUWp/su5E8gasVSvmBLENE8Yn54Ci8OpCjOk0fFPfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJMCZJ//acNdJzMs0/S5mZxkKpLlA3TsXTOrr+dYnJaFu/rz5huJKyxP3X9xgSo21KA8IAQMmgQHJuDPm2iPUZwUSzbT+xI0Da9WYT6DNGKahe8YjUDxe/f4BxBX2+fmylCbEgIUZIu0jiBw8g5Rw2m/Rrk1LbEAbE3i19MamK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=et7ugwBt; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750841873; x=1782377873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cNUWp/su5E8gasVSvmBLENE8Yn54Ci8OpCjOk0fFPfg=;
  b=et7ugwBtsZF5HDhkz8UU1qzu+cvQyNwFPvt2OfQ+HAlkwGWIKLuBNRvd
   8rOZ9ifZKy7arjX3te5k6PyPVvk6txmIbWm+5d1kuvl0EL6xb+DT36at7
   GJNf+ouITRpxvv4RTohqQ7u4iwN4Xh2KhWbd2v96/5zWomNkiumNPcrUy
   QNmV6d6obO+8F5z8aIYP14U222txfL6gjyWgQtlh9XnpSeFfgFCbFlM4z
   LNZrC3yocyN1KMko/cA+GuMdEhtokfSjWHJLhiZ3Obc8cBe1HFPh7SCpP
   k1UqkaTnkrC4P612PHOE6lXU/Ko/k6lKP7tuIERQIWNGDjO0DUumJ4eEl
   w==;
X-CSE-ConnectionGUID: wcDKwu2RRn2e2Ju/QBwHCg==
X-CSE-MsgGUID: zTawrJ4BRSmH5y/L3vO0vQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="53035121"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="53035121"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 01:57:52 -0700
X-CSE-ConnectionGUID: 3U+gfcE6QfKN+X/jTsoDLg==
X-CSE-MsgGUID: JnAz04dgSwStc0XJF9MjTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="151771934"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 25 Jun 2025 01:57:50 -0700
Date: Wed, 25 Jun 2025 17:19:12 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
Message-ID: <aFu/EED7BNJgIXqH@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-2-zhao1.liu@intel.com>
 <fa16f7a8-4917-4731-9d9f-7d4c10977168@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa16f7a8-4917-4731-9d9f-7d4c10977168@zhaoxin.com>

Just want to confirm with the "lines_per_tag" field, which is related
about how to handle current "assert(lines_per_tag > 0)":

> --- patch prototype start ---
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 7b223642ba..8a17e5ffe9 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2726,6 +2726,66 @@ static const CPUCaches xeon_srf_cache_info = {
>      },
>  };
> 
> +static const CPUCaches yongfeng_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,

This fits AMD APM, and is fine.

> +        .inclusive = false,
> +        .self_init = true,
> +        .no_invd_sharing = false,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 64 * KiB,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,

Fine, too.

> +        .inclusive = false,
> +        .self_init = true,
> +        .no_invd_sharing = false,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l2_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 2,
> +        .size = 256 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 512,
> +        .lines_per_tag = 1,

SDM reserves this field:

For 0x80000006 ECX:

Bits 11-08: Reserved.

So I think this field should be 0, to align with "Reserved".

In this patch:

https://lore.kernel.org/qemu-devel/20250620092734.1576677-9-zhao1.liu@intel.com/

I add an argument (lines_per_tag_supported) in encode_cache_cpuid80000006(),
and for the case that lines_per_tag_supported=false, I assert
"lines_per_tag == 0" to align with "Reserved".

> +        .inclusive = true,
> +        .self_init = true,
> +        .no_invd_sharing = false,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l3_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 3,
> +        .size = 8 * MiB,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .partitions = 1,
> +        .sets = 8192,
> +        .lines_per_tag = 1,

The 0x80000006 EDX is also reserved in SDM. So I think this field should
be 0, too.

Do you agree?

> +        .self_init = true,
> +        .inclusive = true,
> +        .no_invd_sharing = true,
> +        .complex_indexing = false,
> +        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
> +    },
> +};
> +

