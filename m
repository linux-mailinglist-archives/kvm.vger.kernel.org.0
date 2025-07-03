Return-Path: <kvm+bounces-51390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B06AF6CCB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B00441C20739
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B032D0275;
	Thu,  3 Jul 2025 08:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nzktpvFv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048DC142E73
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751531202; cv=none; b=jg9d7zIcjnJDUlFd7yHk9b+FZZ28/y37b9OUgmM5v07HiXzvL9m9rSjdhuVTNw1WBvptB+QSIt5fRy8qx9/8gsrhp8czVZH2kTRJRevJrGAddOWamVSx0rdp7TsI0wJttSTbC1sjRrXmg+G45cVmfKDU3fgv62eFpQ6x4WytjhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751531202; c=relaxed/simple;
	bh=ZmG4X3Jhxv8Gv5+e4UWaPy0CAvjKsc9isQvzNVKdnmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GouEKFgstB3RwEvUCo7oLibg4wNaZXt/gxcu7aFH6iOEl3iMCVCX/Lktqc34zDbXFL4BWQImGLQskn4coU7u9rlz5xHhGbUhd+EroxSfitzqYYP+K4SOEnJy8h3C8C19w/72hHMdwdhrIDf9cwli7aKSfZU17ZcfUe6DYh57EpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nzktpvFv; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751531201; x=1783067201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZmG4X3Jhxv8Gv5+e4UWaPy0CAvjKsc9isQvzNVKdnmE=;
  b=nzktpvFv952BL65jmtcdrzkJoQqmhpFH/eygzmZUKwzWKCMbaKOtomY2
   EgsVy8W5we2IrpBRK8TbhNPmKcRDHcyOoMMgb4M0O62/8EnjKjaC7HKK5
   9ifesQFPpVgMgSVFcXyvCK8dbZs6k1VUxTxNampDGqUrOyxZvlqgCSppH
   1fKoKm+IfNGnZBybq1RzOVHjGrYzUHf7/qH1wxkvG08ehhK1S8k8pyo7Y
   2+rcl7M46xr4Ny3jZL0/A7BKtHKnrNrF8xP/P/koD/UrYnGvK8yX+xjP4
   RIfP0TFOsOx1+yi1WckX4meKjEzsSX8c0mhwyAD/QfLDfAanS12V9pnxl
   A==;
X-CSE-ConnectionGUID: VfPs0tMqRTuFwpyXs/P1Rw==
X-CSE-MsgGUID: sXiBQmYYSEyQSccqdkBRDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="79280742"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="79280742"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:26:40 -0700
X-CSE-ConnectionGUID: z/7Ky3ApTN2kD35uOXuQkQ==
X-CSE-MsgGUID: ag0q8rMPT1GDBYZQiY2pWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="185245908"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 03 Jul 2025 01:26:35 -0700
Date: Thu, 3 Jul 2025 16:48:01 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>, Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 58/65] accel: Always register
 AccelOpsClass::get_elapsed_ticks() handler
Message-ID: <aGZDwZaXu1TAfsJY@intel.com>
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-59-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250702185332.43650-59-philmd@linaro.org>

On Wed, Jul 02, 2025 at 08:53:20PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Wed,  2 Jul 2025 20:53:20 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 58/65] accel: Always register
>  AccelOpsClass::get_elapsed_ticks() handler
> X-Mailer: git-send-email 2.49.0
> 
> In order to dispatch over AccelOpsClass::get_elapsed_ticks(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::get_elapsed_ticks() mandatory.
> Register the default cpus_kick_thread() for each accelerator.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/system/accel-ops.h        | 1 +
>  accel/hvf/hvf-accel-ops.c         | 2 ++
>  accel/kvm/kvm-accel-ops.c         | 3 +++
>  accel/qtest/qtest.c               | 2 ++
>  accel/tcg/tcg-accel-ops.c         | 3 +++
>  accel/xen/xen-all.c               | 2 ++
>  system/cpus.c                     | 6 ++----
>  target/i386/nvmm/nvmm-accel-ops.c | 3 +++
>  target/i386/whpx/whpx-accel-ops.c | 3 +++
>  9 files changed, 21 insertions(+), 4 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


