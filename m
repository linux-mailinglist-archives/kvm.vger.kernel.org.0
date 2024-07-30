Return-Path: <kvm+bounces-22652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED5B940D26
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59EAB285B3A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2F01946AD;
	Tue, 30 Jul 2024 09:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kc0aqtMz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3969219414D
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330796; cv=none; b=j3voK/2WAso94fa9f6deDgIZUNdBdTeCo83+L4zSZehXc6c2bH7spz8iGhVX0iECLjEjXi0kx6yhmRBmtc9aWXoUWGhzTARVxEMRbr3ZeOk7+RrHRE6vMfVxzX3gxzOO0vwjHJZxbD24ltKyEqOafKZ76UgKKkWcfoPYdPtKrg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330796; c=relaxed/simple;
	bh=OJN+ESOf3j7WgRm7tp+5EaN6VLIEhB0GeZBgm8RyWZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdqoS718nxRZ9sHFBB4YkxvszHM/SRzzBpcUtq9q1aL3F6+S81aS/CII1cX9unRBVrHC8X/zi5ytCXHe7BwAjP9kVhvoH8xrgsODMHk2KAzQz7wq3ccmq3VqrnBj2EmPChVOI1dfxuAFJozGZVl8sUvz1InXWTk9wmO+UaABqm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kc0aqtMz; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722330795; x=1753866795;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OJN+ESOf3j7WgRm7tp+5EaN6VLIEhB0GeZBgm8RyWZI=;
  b=Kc0aqtMzfgJrddQVQ6IZxWlNrnQ+aeGwm/rkjiPyvRpMs9NjZWiMS5MR
   Bl+y4OdJWy4rlM5EXasWXpDmJ8uiX4/KavgGQEmBSuoAMsDZ9qznasgQe
   uFzxU9hTatuSvrGdPIMUPYWX3NvAVKU+ZT+uewH3LoDURuADwRBbbfsna
   ZHfNdamFmQ4EJG1VSu5Loc05seHWfQ5taSWmYZxX69T4KM9kXwwWS0qjF
   KuWXtCREhhRzszkYNFRRgbCvLrNYuQuXXj+C4+AsX0hQ5dSYm+zGug7dY
   4D9Quh11GxM6e+yewVww5DMK2oj8emxqIM5BndXhvvdehR1JXT3lycJBs
   g==;
X-CSE-ConnectionGUID: q2PT25OPSGioo+yfBoBsOg==
X-CSE-MsgGUID: yLKzVBCLQbS7WWdFHZldHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11148"; a="31542660"
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="31542660"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 02:13:14 -0700
X-CSE-ConnectionGUID: gswTXqQTRYekTBKloxnqDw==
X-CSE-MsgGUID: gyJq+ddtRmOByRaoPYZs5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="77507899"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 30 Jul 2024 02:13:04 -0700
Date: Tue, 30 Jul 2024 17:28:50 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, alex.williamson@redhat.com,
	andrew@codeconstruct.com.au, andrew@daynix.com,
	arei.gonglei@huawei.com, berrange@redhat.com, berto@igalia.com,
	borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
	den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
	farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
	idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
	jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com,
	kwolf@redhat.com, leetroy@gmail.com, marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com, michael.roth@amd.com, mst@redhat.com,
	mtosatti@redhat.com, nsg@linux.ibm.com, pasic@linux.ibm.com,
	pbonzini@redhat.com, peter.maydell@linaro.org, peterx@redhat.com,
	philmd@linaro.org, pizhenwei@bytedance.com, pl@dlhnet.de,
	richard.henderson@linaro.org, stefanha@redhat.com,
	steven_lee@aspeedtech.com, thuth@redhat.com,
	vsementsov@yandex-team.ru, wangyanan55@huawei.com,
	yuri.benditovich@daynix.com, qemu-block@nongnu.org,
	qemu-arm@nongnu.org, qemu-s390x@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 07/18] qapi/machine: Drop temporary 'prefix'
Message-ID: <ZqiyUjihMSD0ce4b@intel.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-8-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730081032.1246748-8-armbru@redhat.com>

On Tue, Jul 30, 2024 at 10:10:21AM +0200, Markus Armbruster wrote:
> Date: Tue, 30 Jul 2024 10:10:21 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: [PATCH 07/18] qapi/machine: Drop temporary 'prefix'
> 
> Recent commit "qapi: Smarter camel_to_upper() to reduce need for
> 'prefix'" added a temporary 'prefix' to delay changing the generated
> code.
> 
> Revert it.  This improves HmatLBDataType's generated enumeration
> constant prefix from HMATLB_DATA_TYPE to HMAT_LB_DATA_TYPE.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/machine.json            | 1 -
>  hw/core/numa.c               | 4 ++--
>  hw/pci-bridge/cxl_upstream.c | 4 ++--
>  3 files changed, 4 insertions(+), 5 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


