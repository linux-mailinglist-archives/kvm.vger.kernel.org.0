Return-Path: <kvm+bounces-19547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F14906419
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 191401C21597
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C10A137902;
	Thu, 13 Jun 2024 06:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a84GCHrp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A202B13774C
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 06:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718260428; cv=none; b=YxlpNp8Ip1YR7+JIb5RrBNGFnqMGx7UOGHEWq5Btrs4AmwhSDSoRXnsB6S05puIpWF+pX9NIdr1Yr65LVjGSH8uLe/3BN2xR5zIEjK+LrR42lptJzpQDArw/Z0kJTxBAZTehDmDT5ZH8h5mBYNIsADpxcWnufCLW0e/78n4VlQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718260428; c=relaxed/simple;
	bh=bv8zXqqzoxL1cfR9kD8+nJ2IEnCJ/inoLv/HgcT04Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzPZ1NcbIwKhFOzNB7vA9YqyywfuGLar/0LvJwN8K5Hxu9APkY9A2/aIluLr5fBpn3kTSJVbV2F/jvDJUnX7vyYfRoays8reBBMZGq0Vm8Wzl20oK61qi+QpJ0d/dGimksOVYbOeGD7JVxP6XDbsNnAxxMsi6tls1K4EJoBLvGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a84GCHrp; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718260427; x=1749796427;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bv8zXqqzoxL1cfR9kD8+nJ2IEnCJ/inoLv/HgcT04Q4=;
  b=a84GCHrpjsX07mQKjK29CuwBEn9U8YPOvgIaPBrGr3I5rO//ERIWKZSu
   3RheDhrk5/WdNugMEca3UzFvohtEtHBP9ZQgDJZrZKi4BAHfuooNJ00TZ
   3G+XfzMUkbAz9BPKZd7U3OfmKhL8Gx6Ah9EQPrbu0xYBY4/OeuW0uOwMw
   NEdGxJvSiMO7u5k9+1kHlBfjyuL8s+MCLKnGGMDkHC8+Pbie5nqT09Xqh
   +xEtxN6XW6pKgop8HfMEXFWRrAOKp75Km3qQmeQjGkm2EoJNParOVDuxh
   uVOP/JPvw/JoD3cSlMr/DVQLl4xaFA7oTPgVMCR4fpJYZla+PED0++zhL
   g==;
X-CSE-ConnectionGUID: Q0uYYqVyQHmLlp93c59KQQ==
X-CSE-MsgGUID: RYgnrwFkTcicK6+utmugxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="26480969"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="26480969"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:33:47 -0700
X-CSE-ConnectionGUID: KmH9BOYYToO1/cIKx9dJ8Q==
X-CSE-MsgGUID: wHMUvk+3QkWVjt+REjbq6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="44568066"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 12 Jun 2024 23:33:45 -0700
Date: Thu, 13 Jun 2024 14:49:14 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/4] i386/cpu: Add RAS feature bits on EPYC CPU models
Message-ID: <ZmqWatuwNiYdaG7S@intel.com>
References: <cover.1718218999.git.babu.moger@amd.com>
 <9bba9cbb783da2eaee4e385bf3d93b7cac2c8c77.1718218999.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bba9cbb783da2eaee4e385bf3d93b7cac2c8c77.1718218999.git.babu.moger@amd.com>

On Wed, Jun 12, 2024 at 02:12:17PM -0500, Babu Moger wrote:
> Date: Wed, 12 Jun 2024 14:12:17 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH 1/4] i386/cpu: Add RAS feature bits on EPYC CPU models
> X-Mailer: git-send-email 2.34.1
> 
> Add the support for following RAS features bits on AMD guests.
> 
> SUCCOR: Software uncorrectable error containment and recovery capability.
> 	The processor supports software containment of uncorrectable errors
> 	through context synchronizing data poisoning and deferred error
> 	interrupts.
> 
> McaOverflowRecov: MCA overflow recovery support.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  target/i386/cpu.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


