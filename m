Return-Path: <kvm+bounces-34989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5062FA088B6
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DB0B3A8BE5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 07:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C167206F09;
	Fri, 10 Jan 2025 07:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HOyYo91N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CBF2066C7
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 07:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736492797; cv=none; b=GwfhnvfSjm2ok4yHFb7le1DGrqvIER0l3CBdqNYFTnxJh6doI/fr/tWl2Sct8+DxZzbcWHpCNIHc/LDgCWl1uYbTgYd8QkNF2586ZG2OCesv/k4OBA/PaimbwgsNFozQVF5l/S8W+VWxIg5YeF5s60ZUcuf5q+CwfekLD//elKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736492797; c=relaxed/simple;
	bh=Icfp8ADMH22lY9/TECTYujLjL4kAtLZFXlPwp+iKNWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZrXGDNVCdZY4gmLzBqdP7Pd0cNhObkAVIDRyFOTRuqGE7LsdYhwoXdzMFQ8WJ6iSMwzSM/gVXY//prlsYF4C7d9yKCvsTvk+I+BV50H8wvfapl/Tlu2T+8oslvH+DK3lqYekYsI6s78ItiGWWCb0wIrzT21aHGAkZacTJHdbFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HOyYo91N; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736492796; x=1768028796;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Icfp8ADMH22lY9/TECTYujLjL4kAtLZFXlPwp+iKNWM=;
  b=HOyYo91NzFR5We2qgkd7SxbIxeNeXronXo1fNUTshwbXqy5KOnKY5Tia
   c3E8Bmq81IwFzoho54oTYoc2n+MbnYz8sTFbOfrBXBb5xJcdv0GOgVhEf
   GR+I7hvDsHplC4jOcRyhFyxXgJwxeaUlYbJHvMxZ0hIXFVaJR7SCb9J1d
   wdVAWklR222FnmCVsY4FCITXAj2JnG95eo8Ly7Sz8DdHAiT6sqKt514AB
   9ewQPrzXH2JztML97ZRwK+jFWofLVbPWZTNlTZaH2hBob2XYyZefJZyD4
   F9uxOaQlug+lY8mwZCBcaWqcwLTwCoCRU3/E+MD3vv5+PCUQyXLMD4Owg
   g==;
X-CSE-ConnectionGUID: ouzd2qJ/RA+6JuxqSH866g==
X-CSE-MsgGUID: ul6GsxnZQ4SPIYwDuCfXiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="36939429"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="36939429"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 23:06:36 -0800
X-CSE-ConnectionGUID: e+pImn6jSuK83VHtw1pMoA==
X-CSE-MsgGUID: I+za7lgbSUii4CBnw7HmIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="104200387"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 09 Jan 2025 23:06:33 -0800
Date: Fri, 10 Jan 2025 15:25:21 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 1/5] hw/core/machine: Reject thread level cache
Message-ID: <Z4DLYf6kfWptN5IK@intel.com>
References: <20250108150150.1258529-1-zhao1.liu@intel.com>
 <20250108150150.1258529-2-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108150150.1258529-2-zhao1.liu@intel.com>

Hi Jonathon,

Thanks for more explaination!

Based on your clarification, I think the commit message for Patch 1
needs to be updated since I used the same wrods as the cover letter...

What about the following change?

On Wed, Jan 08, 2025 at 11:01:46PM +0800, Zhao Liu wrote:
> Date: Wed, 8 Jan 2025 23:01:46 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: [PATCH v7 1/5] hw/core/machine: Reject thread level cache
> X-Mailer: git-send-email 2.34.1
> 
> Currently, neither i386 nor ARM have real hardware support for per-
> thread cache, and there is no clear demand for this specific cache
> topology.
> 
> Additionally, since supporting this special cache topology on ARM
> requires extra effort [1], it is unnecessary to support it at this
> moment, even though per-thread cache might have potential scheduling
> benefits for VMs without CPU affinity.

Additionally, since ARM even can't support this special cache topology
in device tree, it is unnecessary to support it at this moment, even
though per-thread cache might have potential scheduling benefits for
VMs without CPU affinity.

If it's fine for u, I'll resend this series quickly.

Thanks,
Zhao

> Therefore, disable thread-level cache topology in the general machine
> part. At present, i386 has not enabled SMP cache, so disabling the
> thread parameter does not pose compatibility issues.
> 
> In the future, if there is a clear demand for this feature, the correct
> approach would be to add a new control field in MachineClass.smp_props
> and enable it only for the machines that require it.
> 
> [1]: https://lore.kernel.org/qemu-devel/Z3efFsigJ6SxhqMf@intel.com/#t
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>


