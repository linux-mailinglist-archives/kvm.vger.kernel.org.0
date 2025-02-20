Return-Path: <kvm+bounces-38678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A411A3D91D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E06D7A867E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC771F3FF4;
	Thu, 20 Feb 2025 11:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cdjnj7iA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB741F1510
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051939; cv=none; b=U/2PA7oBwnCWngFmaixUEhcyBDzPkW/y0biLh8bxsAp+P3A7SGwF7ESyHpFcZY3veWMyg0D35CEnp5P1Eq4AizYh5/qDVpgEBZsOAAPotdOHHfyaEsNB45Mtg1rws+no1n1GY7XiqsaVWPg/PvBxRwwJE+m9Qhcc+I3z0u16LeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051939; c=relaxed/simple;
	bh=Yrzr6RlKTrfVfuylJCFKjN7TwC2IIN9gmHbRTx+OEfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfBJpmRDRegEvPkqoNdvNLlxVLEYVPTJ2QDFoJ9BPkoK859ifyEPFFn6o3KqVc5ElIwsbtqNO1N13R1NQbFzryp0uEXx2eDpxMljkvYcIQH9R0gj0hK49m3rH1phCRXqgwGxlWhP036OuGnXarIwSfP8FPKsAflynx9X2DT9GLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cdjnj7iA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740051938; x=1771587938;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yrzr6RlKTrfVfuylJCFKjN7TwC2IIN9gmHbRTx+OEfk=;
  b=Cdjnj7iA2cRmiJ+j9zPI40Ez6Cajped6Td4rHmlCKg5KMjNkn9K6vpkD
   7i/OlDa2Hq6iX6Aet0x3ju80taceiLG0UpmfHV/YyfiA5BpnJS5+bETH3
   e5cwIaeBJXDuZYYPXSMxhvoLVLHMM9sH2WIja/Y7OW+CtnFE4NoiKzkrD
   rAbmV+Wie6dUhe8749Gr/fx+OSBkk+NYM6ayg8li5dWtKJvUSrnZLp9um
   zLo+q3IxP/bV9jWh40QGz2tvX6wvlc/7l94EpqioBv25au+baSxWclIp9
   kyW8PuUnOTgmh34/qclC1tEmZ2RteQK8tDE1ShZdZMNuXkJY4JMKSStHm
   w==;
X-CSE-ConnectionGUID: 7dHBHinDTS+dEePF1NhSyw==
X-CSE-MsgGUID: eHvyQ1WfTzOEVKLQX6KpTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="44474594"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="44474594"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 03:45:37 -0800
X-CSE-ConnectionGUID: sQ5KWKyHSfm7Xasg2I/RmA==
X-CSE-MsgGUID: 4zLxPxTbTM2sIWbZgSx64w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119116496"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 20 Feb 2025 03:45:36 -0800
Date: Thu, 20 Feb 2025 20:05:11 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru
Subject: Re: [PATCH v5 5/6] target/i386: Update EPYC-Genoa for Cache
 property, perfmon-v2, RAS and SVM feature bits
Message-ID: <Z7cad1GabzGG1pAp@intel.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <ded4e65f9c9109f0863d1a00888b1ba48fab1549.1738869208.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ded4e65f9c9109f0863d1a00888b1ba48fab1549.1738869208.git.babu.moger@amd.com>

> +static const CPUCaches epyc_genoa_v2_cache_info = {
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


