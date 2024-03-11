Return-Path: <kvm+bounces-11498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F14877AE7
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 07:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50BAC281DE1
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 06:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B33F9E6;
	Mon, 11 Mar 2024 06:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nhp9Jqod"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5135BD516
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710138509; cv=none; b=cqJ7VhS5WLs9Fr/j4WtGz3wtNwPqWiOhKLKr6xUS48DLG5P2FbYRzrQgbms29lnJzuMdrMZzLGOw7nre1nFfsnxc70w4wCbU+ESqEFTz02y9RJvyl3vMBpuq30oCD2wZ+mlGCuUFzAUB7dNkxEKeiksyOENoMVfXTqRpRZWUIhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710138509; c=relaxed/simple;
	bh=IOKzj0IERhHPKMm55PuM9BoEsyEamUJqnVssTHpG1Tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6dcBtqdmYZIy8vSkjTYEzFr8VG8ZpAe5BKv6aYxy50Uf4AKeVO4KIMc/EjmrQhaPjzWtmULAnSqAf7SBRONydiDpjOuiD9N14XU7VlV7upljpJZNePhM9BgFfp4nowYT/TPc2ycSMt1wull6fZ3UfxZb07+MPYRNxXsv8l/LdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nhp9Jqod; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710138507; x=1741674507;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IOKzj0IERhHPKMm55PuM9BoEsyEamUJqnVssTHpG1Tw=;
  b=Nhp9JqodzZK3zPA/MvgrID+1TXSySiWxkqkVicmTzrhIt/uM9GHnjGWd
   CQcJ2aGEcN4UAVhp/eLnOGR05FZPSQOeH2lry0Zk3yQx4H9tfJPiAKWu+
   kaK0LEkjgJpeCV6yIAKqdkTust/7yQGztHiKCnt/eawx/CZ9pIydPM/h2
   nu2f66df9pjih0KCFabgyNzwYMoz847imWNVzWelbwUzGcyPWrJLfdOxz
   UiUKMGqG/d0KIqKIedfuJlLH2K/0s4iIl2uvZ9P8ZZirSo8+zZPmJ0CCM
   A+SFHgEgjE8hu4zCWB4nySvmcwPbWiODArBFhT9wkNRXzD3Y5uTvZB7jI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="30226726"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="30226726"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 23:28:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="15657580"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 23:28:20 -0700
Message-ID: <770fe9ab-c9cc-4062-b841-180036a3d050@intel.com>
Date: Mon, 11 Mar 2024 14:28:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/21] i386/cpu: Introduce bitmap to cache available
 CPU topology levels
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-10-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227103231.1556302-10-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/2024 6:32 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Currently, QEMU checks the specify number of topology domains to detect
> if there's extended topology levels (e.g., checking nr_dies).
> 
> With this bitmap, the extended CPU topology (the levels other than SMT,
> core and package) could be easier to detect without touching the
> topology details.
> 
> This is also in preparation for the follow-up to decouple CPUID[0x1F]
> subleaf with specific topology level.
> 
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>


Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

