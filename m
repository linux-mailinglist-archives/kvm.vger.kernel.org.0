Return-Path: <kvm+bounces-28058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97658992A04
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 13:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EEDF281F22
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 11:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7401D1319;
	Mon,  7 Oct 2024 11:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JgjcTg1s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2300415D5C1
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 11:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728299310; cv=none; b=uUlBUEQRUQUut3M4hLN1o8BrF/dWiXxYaICGSffbSIb6Cnvq9d1qhg9HkGiLuKJKF323BPMMjsZ3LENNpl1EuWeFaS7k5b09SWIvUPEHXT8g4Pdq80czr1dg+o1b/qos4xMjDazFJDmO/tBgz0eCgpHADxj/s+BPHpdTrf6ClIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728299310; c=relaxed/simple;
	bh=hpwrGxuedAeKuZjTNzgbaWYzvlowhimdFInbSjmkp9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f87ygdl9l0/yAAINujD0oq7QGROF1GWgQQ5vRZ1wWVhBNxnhBxd5wLKkEOPRHG6tvSgpeAKnIb4cT3s9Be0Dv+lHtWE5RdbL4KVg504eHWJsEFa3XuxldmEZQ9waowne7dQLwnL5W7/kLxUD41+mQUQHfhff/yt4a0c4D13F3u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JgjcTg1s; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728299308; x=1759835308;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hpwrGxuedAeKuZjTNzgbaWYzvlowhimdFInbSjmkp9g=;
  b=JgjcTg1sVCw0AVivJzD7JzN5lB2iqt04mj5Mi233qjldxn1cAtmQciMp
   QHnmZsQZ4XbUh2J/7bm/BXxlavvv0/GXRt8PWatvBMUD1fekRpJG02b7R
   wlczWflN9iON//RaP7VX7u3Spo+2TruL6PgPR9e6uD2Ph2hTVmgwOPpra
   1t/GNOtyKC7Ucu1w7AJ9nt+omlydVIbv577CK4fNpsQi/UwqW6P0nPJFK
   zO27/JKjwU4v1/PJqTP2SXanzuLQfAJX7kDPXPylXUORo+rCMjOSmqrlw
   X4hDkUn0mVX3K3vMqn8zODTqGxQkL1gsnOQeM89/K1UuntWlIgvaMDNsj
   Q==;
X-CSE-ConnectionGUID: cJ8xRz/1R7yySXbZjKGrkQ==
X-CSE-MsgGUID: tAtMkEiWTUqiY2Az1z0k0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="31233858"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="31233858"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 04:08:27 -0700
X-CSE-ConnectionGUID: AQYZDfABQIaxfDs9ei+I9g==
X-CSE-MsgGUID: h8O7y00TS2SmBdz6F04s3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="75875239"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 07 Oct 2024 04:08:22 -0700
Date: Mon, 7 Oct 2024 19:24:33 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v2 5/7] i386/cpu: Support thread and module level cache
 topology
Message-ID: <ZwPE8foi2qviMQSB@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20240908125920.1160236-6-zhao1.liu@intel.com>
 <20240917100508.00001907@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917100508.00001907@Huawei.com>

On Tue, Sep 17, 2024 at 10:05:08AM +0100, Jonathan Cameron wrote:
> Date: Tue, 17 Sep 2024 10:05:08 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [PATCH v2 5/7] i386/cpu: Support thread and module level cache
>  topology
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Sun,  8 Sep 2024 20:59:18 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Allow cache to be defined at the thread and module level. This
> > increases flexibility for x86 users to customize their cache topology.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>
> Will be interesting to see if anyone uses the thread level, but
> no harm in supporting it.

x86 CPU has a legacy property "x-l1-cache-per-thread". This is the old
QEMU cache topology behavior, kept for compatibility. Now add thread
level and I can refactor the code for this thread level.

> I guess this would be a case of RDT
> / MPAM etc as I'm not sure I've seen an SMT processor with
> private caches. Some old papers seems to suggest that it might
> make sense for smt 8 and above.

Thanks for the hint, I'll think about whether some of the RDT / MPAM
cases can be applied here.

> Anyhow, patch is fine
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks!

-Zhao


