Return-Path: <kvm+bounces-46287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 937D0AB4A0D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 05:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB77A3BE8DE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 03:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DF51A315D;
	Tue, 13 May 2025 03:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHuOlI66"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4931C45C14
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747106293; cv=none; b=Ma/UT3v94AZR8KLElpWtVlouJjjIzxALxqi2NuqnDExsYl/CTGShtlzGSgxV234B+6MvjzLdavtAB/3piN2+DBSsuY+1MqL/OWIE70ppa+foPlwUfTZImR0e73elqCUTbeMdzhTp82cW6E5mzuezm+XZXe9808o68MjIHCSmuQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747106293; c=relaxed/simple;
	bh=v7EzudV4/Ya+6M4YGvaIUylCgp31lJUmDL5kclRL7KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYokP0aReRZd7+SsRfqnQSQu9Dx101zgNx3VkM0jDqnkFLh5SdHD2ktnDfRWMxIRgFBdtyFMWq+c9gRaqGFrkHYYINQnNubOxGUTuIM/zA2nx2SP0iwUaxiNGEdO0ZJJ+RnKDPbFo4t8oBFWczUTMeaeJ9lCH/noig0Nzwi2rGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHuOlI66; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747106291; x=1778642291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=v7EzudV4/Ya+6M4YGvaIUylCgp31lJUmDL5kclRL7KA=;
  b=FHuOlI66SSEfvgWsJ1TDPiuYgaIbOlxgzIllmka269O2Iy5Yc+w8h04I
   zlDmJZ8nmPvFifmcuu8yx7iSV+bNC1Kxt9fSKOAtJ2vcxjnpdQOXc7eGr
   eH5wLp8HClxq98jWwd3di4kXR2sm8hRffp00btg1TdNlBbX/Wkuemq5ip
   VGCCscRcbsaBYoikfns73qQYpGnST4Vajh+HAgoVI/v6v6vJIWKYH7XBS
   hg2ZbIqkULP0FprUN+aOOxiBTZNxgBFBXxmv/KfUQzQKj6KriwM6UZUfa
   9+93LSgVFjWB6un/ir6PCr8ANL9jwNQwWEq4logA9mc5rp8OvzITm/57R
   A==;
X-CSE-ConnectionGUID: psklj1yPRYGu3NXovH9eHg==
X-CSE-MsgGUID: YNjczhPnQVWc22lc8a8qFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="36556447"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="36556447"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 20:18:10 -0700
X-CSE-ConnectionGUID: jHtMsGTiSlWYZmP7vHDbNA==
X-CSE-MsgGUID: vBQXI3WTT0eBic3bqHfFUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="138498133"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 12 May 2025 20:18:07 -0700
Date: Tue, 13 May 2025 11:39:10 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-stable@nongnu.org
Subject: Re: [PATCH v5 01/11 for v9.2?] i386/cpu: Mark avx10_version filtered
 when prefix is NULL
Message-ID: <aCK+3m7jv+qPWYZ4@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-2-zhao1.liu@intel.com>
 <c62b0d60-2815-41e1-9e56-7bec83640208@tls.msk.ru>
 <baafd30e-db22-4950-ad44-2b2b51cc8f6c@tls.msk.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <baafd30e-db22-4950-ad44-2b2b51cc8f6c@tls.msk.ru>

On Mon, May 12, 2025 at 12:35:35PM +0300, Michael Tokarev wrote:
> Date: Mon, 12 May 2025 12:35:35 +0300
> From: Michael Tokarev <mjt@tls.msk.ru>
> Subject: Re: [PATCH v5 01/11 for v9.2?] i386/cpu: Mark avx10_version
>  filtered when prefix is NULL
> 
> On 21.12.2024 00:04, Michael Tokarev wrote:
> > 06.11.2024 06:07, Zhao Liu wrote:
> > > In x86_cpu_filter_features(), if host doesn't support AVX10, the
> > > configured avx10_version should be marked as filtered regardless of
> > > whether prefix is NULL or not.
> > > 
> > > Check prefix before warn_report() instead of checking for
> > > have_filtered_features.
> > > 
> > > Cc: qemu-stable@nongnu.org
> > > Fixes: commit bccfb846fd52 ("target/i386: add AVX10 feature and
> > > AVX10 version property")
> > > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > 
> > Hi!
> > 
> > Has this patch been forgotten?  9.2 is out already and I'm collecting
> > fixes for it...
> 
> Ping #2?  It's a 10.0.1 time already.. :)
>

Hi Michael,

I'm sorry, but now I think it is not necessary, since it doesn't
affect the normal use of avx10. And I don't think anyone is actively
setting the wrong avx10 version in a normal production environment (
even KVM only supports v1).

Hope this helps and saves you the effort!

Thanks,
Zhao


