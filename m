Return-Path: <kvm+bounces-41642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFB1AA6B345
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 04:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15B357A9A26
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 03:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6A91E5B6A;
	Fri, 21 Mar 2025 03:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WtMFZysn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362CB78F5B
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 03:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742527389; cv=none; b=VX6k//IL+Ny6jzhtUvzkfHTy/C1oTBq6g3Y3OqjoMrAM3oLWdWLjJ6LHrP0Yk9yGkgXqKfYuKpT5sxN1K5e8R4cNxHQ2NdRBded35wGFqLN7z2ElUwedFkXaOLrKXZjarquIGewPKURjZp5ycUCnZVCvQ+tjnhdZ4wjgeORTRhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742527389; c=relaxed/simple;
	bh=VW905S5AtEa+aqLunlCnNTDg/VfBoD1PewmutLdb2ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdVeV0TVSlWCQRxQyS4RGMyHQKWfEtIHoshgMmg5RieZ69HWu3gdlYgz9GeSv1HG/hUaQa34cYOvfPD6pD6USsowY+VU6LlcFWvKF9S/RE7uIDuY1vhaRi9gFZVSeDzvNl2coZ/pbGo1lEogVEK4GOUgeOmxkL1bZ8X7U3C7vkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WtMFZysn; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742527387; x=1774063387;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VW905S5AtEa+aqLunlCnNTDg/VfBoD1PewmutLdb2ys=;
  b=WtMFZysnVtx6Be5zYcIXWLZENYqrIPncXEjmHFzoNF7SMjMj1Qm+ovuK
   mVJSduKkqVehA1fha78kaLVYt2BWD7WJH0MMArJJuFCr+NvExg2xfx65T
   z3Ud8XycbRF2ZtmaejD9uutfMmyqK+tx+PJrSMEDPE3zJW/qzfJP7TPY3
   zgxGJexjBGIEOita/8qSGSbOrSUSHiQhLeGrCM2InCYC5G6BaLZjVIYS6
   wgbRS4Hx/qifpADB9OmJvU+jer2PSq6L34051oNyNUJ7CpLRXnOvDvBY8
   tiFg1dsX8YKwC8N8dPSXQqCiWzVxFHhb9n5NITY+Ylmc/57Zi9dS4hroh
   A==;
X-CSE-ConnectionGUID: FrO9T6ylRqOb5MhJd2TP1w==
X-CSE-MsgGUID: spjkfp6OSv2kY2tkh9Eusg==
X-IronPort-AV: E=McAfee;i="6700,10204,11379"; a="43973087"
X-IronPort-AV: E=Sophos;i="6.14,263,1736841600"; 
   d="scan'208";a="43973087"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2025 20:23:06 -0700
X-CSE-ConnectionGUID: zOxVwuLWQFi4cQC1qFTZ9g==
X-CSE-MsgGUID: PRbIxo2HQ6KErz7zyEbsEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,263,1736841600"; 
   d="scan'208";a="128114389"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 20 Mar 2025 20:23:03 -0700
Date: Fri, 21 Mar 2025 11:43:16 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 0/5] accel/kvm: Support KVM PMU filter
Message-ID: <Z9zgVKtZyEx3MKuf@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <2fe2a98d-f70f-4996-b04e-d81f66d5863f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fe2a98d-f70f-4996-b04e-d81f66d5863f@redhat.com>

Hi Shaoqin,

Thank you very much for testing!

> I tried your series on ARM64, but it reports error at compile time, here is
> the error output:
> 
> qapi/kvm.json:59:Unexpected indentation.

I guess this is caused by my invalid format and sphinx complains that,
as Markus figured out :-(

What about the following change?

diff --git a/qapi/kvm.json b/qapi/kvm.json
index 31447dfeffb0..b383dfd9a788 100644
--- a/qapi/kvm.json
+++ b/qapi/kvm.json
@@ -54,11 +54,6 @@
 ##
 # @KVMPMUX86DefalutEvent:
 #
-# x86 PMU event encoding with select and umask.
-# raw_event = ((select & 0xf00UL) << 24) | \
-#              (select) & 0xff) | \
-#              ((umask) & 0xff) << 8)
-#
 # @select: x86 PMU event select field, which is a 12-bit unsigned
 #     number.
 #

> While I compiled it on x86, everything is ok. Could you please check why it
> failed on ARM64?

Maybe your Arm64 environment doesn't have sphinx_rtd_theme?

You can check it by:

python3 -m pip show sphinx_rtd_theme

> By the mean time, I will review and test this series.

Thank you again! I also plan to refresh v3, in maybe 1 or 2 weeks.

Best Regards,
Zhao



