Return-Path: <kvm+bounces-34063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C86C29F6ACB
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1A8F1896B63
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCE51C5CD5;
	Wed, 18 Dec 2024 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OuC44nx+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA9A149E16
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734538330; cv=none; b=qwBIQfMpvQUihIZdZ8c9FP/fXDoKpD/v2rOhKuD0r/cQj7uPsc7Uk7lNHW94l9LW+m3SOIHapDnRR+Gb9LuqLSBzpiz2688McBj6D5cc7fKLqcfe192MN0yXE0DDijRyL6T+EFb/9TN//7TIAxriRLlbnMMb19ZNORhiCJr15hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734538330; c=relaxed/simple;
	bh=ucG6hpTV+IReE+lOfCzMaRfXRUtudEvIopsU4oH+NGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YSsHdjZlCjX1oYAGUsvceRXMDpTZzwIbYe5S3Iim+R9bvx9lm3Y3CCxTGOSyHB7P6bVrC4WO9AorLO7hbuAR8GTZ7TroEx3KcFuY4PSMmZqhNmSBq8arI/6Mj5ZRv2y11d79oYG81CaGwIW4+698mMXY8AWr80KhKsK/Fzn2nWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OuC44nx+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734538328; x=1766074328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ucG6hpTV+IReE+lOfCzMaRfXRUtudEvIopsU4oH+NGE=;
  b=OuC44nx+E55fTdMxoIIib4El/Uz+DB1une806QE27kD7EKG/zHg7DNrj
   Zp6UYHR3uFC84+MBdgVs/yoCc3nRnS0KtwWkLL42QfnXPXAWe8nl/u3Kh
   ZYPZ5RfLeSvi5Duh53em+4zdV7ik/J7b+1dmNwBTSSYtSJWEQ+N0THCvX
   pPzVt1Hjt7UV6Mr0N1JLL8jD3uFPOJppxG25oT5oqAKCUoXCvqrFuSyAr
   IZ93Umy/+mRFibDY8ThA9HGyM1jQumEcfE4b9JKyUDmmZ35wi9kYVlvL0
   0PF2rTpD+gpd0M/gZ3QB8L3fflY5mfhVqGNd8HKaoQK+bA2CYfK8IScc0
   A==;
X-CSE-ConnectionGUID: r7YM3V41T/qM+BM+q18Eyg==
X-CSE-MsgGUID: 60qIU2wiQUmct/xJfW2gZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="46029667"
X-IronPort-AV: E=Sophos;i="6.12,245,1728975600"; 
   d="scan'208";a="46029667"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 08:12:06 -0800
X-CSE-ConnectionGUID: tmGK/hGKRq60K++Lad7knw==
X-CSE-MsgGUID: fWJY/bGUTrOKqmE5Tbi2rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="98724460"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 18 Dec 2024 08:12:02 -0800
Date: Thu, 19 Dec 2024 00:30:41 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Eric Farman <farman@linux.ibm.com>,
	kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
	Yanan Wang <wangyanan55@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/2] system: Move 'exec/confidential-guest-support.h' to
 system/
Message-ID: <Z2L4seQo7Z7LPpTh@intel.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241218155913.72288-2-philmd@linaro.org>

On Wed, Dec 18, 2024 at 04:59:12PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Wed, 18 Dec 2024 16:59:12 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH 1/2] system: Move 'exec/confidential-guest-support.h' to
>  system/
> X-Mailer: git-send-email 2.45.2
> 
> "exec/confidential-guest-support.h" is specific to system
> emulation, so move it under the system/ namespace.
> Mechanical change doing:
> 
>   $ sed -i \
>     -e 's,exec/confidential-guest-support.h,sysemu/confidential-guest-support.h,' \
>         $(git grep -l exec/confidential-guest-support.h)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/{exec => system}/confidential-guest-support.h | 6 +++---
>  target/i386/confidential-guest.h                      | 2 +-
>  target/i386/sev.h                                     | 2 +-
>  backends/confidential-guest-support.c                 | 2 +-
>  hw/core/machine.c                                     | 2 +-
>  hw/ppc/pef.c                                          | 2 +-
>  hw/ppc/spapr.c                                        | 2 +-
>  hw/s390x/s390-virtio-ccw.c                            | 2 +-
>  system/vl.c                                           | 2 +-
>  target/s390x/kvm/pv.c                                 | 2 +-
>  10 files changed, 12 insertions(+), 12 deletions(-)
>  rename include/{exec => system}/confidential-guest-support.h (96%)
> 

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

(MAINTAINERS is missed to change? :-))


