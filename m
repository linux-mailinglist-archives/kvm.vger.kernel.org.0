Return-Path: <kvm+bounces-34064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A85A29F6AD5
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F9741897659
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB391B423D;
	Wed, 18 Dec 2024 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PZDhD5Oc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FED148855
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734538554; cv=none; b=iC+cqopPTlnMWnSUyEQD2oY3pTHdrtotDXGzAgzObgo466Bw9x+OAFlM46TzzDor0SgUht76XjvCFuV7zJ/ek+48VSsCfP5I/BIBWTFWmkS+Jl3hWV85SSJdZObNEjxr25Lpz96InoYsjQrY4t0vbN07zfgsphxRTTNpHsJNz2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734538554; c=relaxed/simple;
	bh=ZDuCEKT0/oRRNImm1XMVi47v0lb6hMFRoy25AeCBJaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CSs1cSMc37IXMo3H5PWTw8I9KWaLqW9kO0N2DMsc0Rv5QSrO5r7py9Unocbn2QXfmd1H865CSK2hNRqaPVRod6U9w5EvrWv7pesHr+OR7T/s7ZMAP8unfWwrgmX5nNuAqyhyco1T9Afdk6y+6/hB1+XR6ZoU36OfKqoHXmyBwtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PZDhD5Oc; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734538552; x=1766074552;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZDuCEKT0/oRRNImm1XMVi47v0lb6hMFRoy25AeCBJaw=;
  b=PZDhD5OcgfnHy0dKw4522HNSBR03TJni6TB3H1jiq3n9TqxIvT4Dhrbf
   l5kPTCdfWQ8EvG8KSzCYutJFmonO73CjdxMWlZKCNhlK6/FWQcXuwh9i2
   5UeJdr8vYOoncBkmnQMWBLbQ0GZw0OUIHIyHMwQzAIgz+HUhY6tP18MrO
   9e9kwJ3QUs01mEO4F7JZmIQANYJZLqZTXaOlDTrVjnvGccCzHu7XdBspb
   6YMKxGoaJzLKtdfducojwkVKQA5gyqH7I1pB1Sd15U0CcwlB531Ts7tjR
   U+aOW8dGOppXVNyPrZTYyvR7WNT4nx0m9m7iXQZTH6fz5KwGIO1ZR0vxg
   g==;
X-CSE-ConnectionGUID: CVNLLejvSUSMAEMaogtpkg==
X-CSE-MsgGUID: XuGdV/aFQeG/J6xCeYuDBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="34911664"
X-IronPort-AV: E=Sophos;i="6.12,245,1728975600"; 
   d="scan'208";a="34911664"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 08:15:52 -0800
X-CSE-ConnectionGUID: aEJDl8zWTMqdq1zsFDQVMA==
X-CSE-MsgGUID: or0tceHkRTuUzrBj/QC8pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,245,1728975600"; 
   d="scan'208";a="98464566"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 18 Dec 2024 08:15:46 -0800
Date: Thu, 19 Dec 2024 00:34:26 +0800
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
Subject: Re: [PATCH 2/2] target/i386/sev: Reduce system specific declarations
Message-ID: <Z2L5kvVIr3JpvMzu@intel.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-3-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241218155913.72288-3-philmd@linaro.org>

On Wed, Dec 18, 2024 at 04:59:13PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Wed, 18 Dec 2024 16:59:13 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH 2/2] target/i386/sev: Reduce system specific declarations
> X-Mailer: git-send-email 2.45.2
> 
> "system/confidential-guest-support.h" is not needed,
> remove it. Reorder #ifdef'ry to reduce declarations
> exposed on user emulation.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/sev.h  | 29 ++++++++++++++++-------------
>  hw/i386/pc_sysfw.c |  2 +-
>  2 files changed, 17 insertions(+), 14 deletions(-)
> 

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


