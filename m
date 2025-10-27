Return-Path: <kvm+bounces-61150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 168FCC0CD3E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC6FA188D1D5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD4C2F362F;
	Mon, 27 Oct 2025 09:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AdArQXZP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E8F2FABE3
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761559064; cv=none; b=OCX46gNzHgMGtVPle9XYbjD0M2gd1J2295ooQEBNjSyIVL9RoDdoJF2koh/KsZtFOURQ3zHihPuH17J3HCdik4NbOSO3hhYm56KQtv+wO5JURXruD0kqhOIV/8KLzK2GqJ2GlbhlVvGtHlt8sJbb4h4pgXdvOdb+OhsQjVCTZck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761559064; c=relaxed/simple;
	bh=IYai5m1YVZem9EfY0nEuzzJKBLzA7AeCEofC0v8Vq4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXvqmunNRu/Amv369Q5O3hKUnEkyUm6OiRaHqIzSHwXoSE1C86q8GOg4OFOiee1nLIS5/r0jY/KOfPGTiZnqNtp8yVxwrIDVUnmdRKN0U7DWB44sEvDSRhEdfq64h6DOyPAVpScwOwGUtg3o4fFdwNi+Xmp1nHa6CmwcH391oJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AdArQXZP; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761559062; x=1793095062;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IYai5m1YVZem9EfY0nEuzzJKBLzA7AeCEofC0v8Vq4o=;
  b=AdArQXZP3AbTCamTVjxNxdlAjBehWBkSusXHWSdEgMzqB49J+wN8HXKc
   sUVV/kBATfzt64scfJbhFNlCz4Im2ZPSYWZXoGsdr0TePBs22BZYdnB8b
   DSOFcMi51iA3+rt6y4zL5pJqgkXPWQ5YWC9wQjLtU0Ly5ARocSvi+oHTs
   GpLwbWH5qYWLZxQ02HT1pNRaevY4tL6B/eoephJCWTt6cx9I0J99A7EvU
   MVXcLgyBTKtKIu0eImrZtbn80sXsRJmX/aGOKokUDUtdeH2fqyPWPxqi8
   AJSl229B+ypLOk1JWvVnlKjVabHbv9t2zLPeocnGIDyMVkMjhAyoMaNb2
   w==;
X-CSE-ConnectionGUID: ywCPndZJRFWj25ixEDD/bQ==
X-CSE-MsgGUID: f+gOUu8YQg2f2StgUyM6Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74309926"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="74309926"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:57:33 -0700
X-CSE-ConnectionGUID: 81XN1JpNSr2gwGhIinUWeg==
X-CSE-MsgGUID: /BRy8T5yT62AIzTWs7e5cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184229168"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 27 Oct 2025 02:57:31 -0700
Date: Mon, 27 Oct 2025 18:19:40 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
Message-ID: <aP9HPKwHPcOlBTwm@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-11-zhao1.liu@intel.com>
 <0dc79cc8-f932-4025-aff3-b1d5b56cb654@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dc79cc8-f932-4025-aff3-b1d5b56cb654@intel.com>

> Though the feature expansion in x86_cpu_expand_features() under
> 
> 	if (xcc->max_features) {
> 		...
> 	}
> 
> only enables migratable features when cpu->migratable is true,
> x86_cpu_enable_xsave_components() overwrite the value later.

I have not changed the related logic, and this was intentional...too,
which is planed to be cleaned up after CET.


