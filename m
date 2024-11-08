Return-Path: <kvm+bounces-31206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C6179C13E2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6D091F22F16
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 02:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B0A1EB56;
	Fri,  8 Nov 2024 02:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XU+QXzRb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71071BD9EF
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 02:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731032066; cv=none; b=itYYaFxf74bWjegdsPEXuQf5/UnkILLq2Qe9KgmUVIBRqe5E7N/GEI6dg9TEVRxCKNSy5f5mBSVtSGxZauDPZ26jJpO3Yg5So3WijofTHidwJh53DNXtHppQ5pIEBv1AqMy7HZiKfKyWsuPGlUemG68t7QGHcWGLLICcvSOuqpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731032066; c=relaxed/simple;
	bh=wrPKQ+gKJ4UWg0JoASdk8oJV1qGe96BO6ocY9KOW9Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMI1NtOWNq02NB1zkBxaR5GdfKCn1KDuVUm7t0usqo9U18Q3pYJRdANd/oVe7JjNx6JbcKpumUbu157ZZLDaeFrsVSngH64jm/eIy8CcbewTvfQYJIMBOnwp3Fb5t29Os+7rIas0G8pExnTXQhGohzdhIl1Ef/lbi10M+7ATlZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XU+QXzRb; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731032065; x=1762568065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wrPKQ+gKJ4UWg0JoASdk8oJV1qGe96BO6ocY9KOW9Ew=;
  b=XU+QXzRbfak1G1ZGh4aHUDdcyeQxAuqu08PlJ9HtSP0afHIN1J+Ax2ad
   ze1qeqFT1YnNuPpxd+TQSob4KleJZ7aBfZubkAQUBJQWlmhYEVkO10AXW
   JkzKxZb/67Fk7EEpW0datFc1PPUWV6TNtfxOpC/nldh8Fhk7tm0fPyMIP
   PSU2S25FxrPrfklN+e5IUMg7/+UkSbbxAoXGYUB3bbx1PndVFSZxbM9ex
   f1298vVUFDL4Vf/WpvwSOwkI8dHr9RiRh7Yf6DD+X15Oawn1LV/MLQ01n
   PaJ9C9GDpAv5Dugcd2eo0OhmrNkckJcg/aTONnCNNC1yd9GQ1UHkRv/Bd
   g==;
X-CSE-ConnectionGUID: Kn6g4t6AQsePkB/z3WqJhA==
X-CSE-MsgGUID: qwr6lw3VTgqMPMZrxQ+F4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="18533094"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="18533094"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 18:14:24 -0800
X-CSE-ConnectionGUID: HMIoyGIBTOGnYXw5b6XWLQ==
X-CSE-MsgGUID: 6glL6PAMT46/P50Op3Uq+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="85324973"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 07 Nov 2024 18:14:19 -0800
Date: Fri, 8 Nov 2024 10:32:16 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: dongli.zhang@oracle.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, joe.jin@oracle.com, davydov-max@yandex-team.ru,
	dapeng1.mi@linux.intel.com, zide.chen@intel.com
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
Message-ID: <Zy14MDBuiFuyj0YS@intel.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-3-dongli.zhang@oracle.com>
 <ZyxxygVaufOntpZJ@intel.com>
 <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>

> I will wait for a day or maybe the weekend. I am going to switch to the previous
> solution in v2 if there isn't any further objection with a more valid reason.
> 
> Thank you very much for the feedback!
> 

Welcome. It's now v9.2 soft frozen. I'm also continuing to review your
remaining patches.

Regards,
Zhao


