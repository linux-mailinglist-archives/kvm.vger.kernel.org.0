Return-Path: <kvm+bounces-51562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA075AF8C7C
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70C2680344C
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB152857E2;
	Fri,  4 Jul 2025 08:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AO4qkgzL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6E2868AC
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751618481; cv=none; b=uFMnYXJpqn9OhLLam2MdmnYVs/gcVWgUk0upmPOfEbcqDQd1Iu/vQt303IwTfnkg2rRM04cOJT2ZhIly4hvCO9RLBxMm9W7iYLG8YCMdGL7yGqWeSheF31cE0okYIZI3iNCKydLYPB/G8HvyRyvuT7+ojFEORi3tzfl1kYbziLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751618481; c=relaxed/simple;
	bh=1QuT+XRSxAhtUr7hKsZ7yJkGE89o5ONGpKD2gpcV/QU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcOEWPeLnloM8mf2kOyJTpND/qOL4vO21RHjqJKXwEI4sCbB1A7s4w/wJpZBh5n4CeGBRip0QK1w8dqgFaaavUu6z9EiUQbel1ykVrvdCiGgvphMajUX2eiWIFJG1d+k+rpgW76vgM6vM1LLq0+2RgizYY/MQYiQMPOp0kHyg6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AO4qkgzL; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751618480; x=1783154480;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1QuT+XRSxAhtUr7hKsZ7yJkGE89o5ONGpKD2gpcV/QU=;
  b=AO4qkgzLNIuDYLiyXT272hIEEyEVQ7mcYxDEIT3AqYHymhvRLtemTrSg
   mu66HjPSMGh6q6/CGsIoxDL3nEs1wGSdbl/f0xpC0j52kJihi1TnmGIW5
   GxzSe/P4tA304fC1sOBJkv9JRltIsqsZTMaRovNtDOR5o4maZh91T/4sK
   znBa0m9pNHyt3BHunh96s/88U6MSh7MOcfu10h3H8fs46N/L5why6FkM6
   qsdCtBpFrAfg646ZzwDCGVm3LQsgzpSpbHxrFXT8WDik3NacoFdIbibZd
   Kb30MUlJV/wZS2geakeIig1nY+5g+7ixJ3xYUpx2gJ+5BDnyRHZNfo4Xv
   w==;
X-CSE-ConnectionGUID: qP1MHS4oQ7W1YAY/R6MsoQ==
X-CSE-MsgGUID: KMsHJHs2Ru21v1HAlQyV/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79390522"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79390522"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:41:18 -0700
X-CSE-ConnectionGUID: Rmee1NI+T9S45FFL65lxYA==
X-CSE-MsgGUID: YJNNdulXQM+t6scSwQBLJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="155086915"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 04 Jul 2025 01:41:12 -0700
Date: Fri, 4 Jul 2025 17:02:38 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>, Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 38/39] accel: Extract AccelClass definition to
 'accel/accel-ops.h'
Message-ID: <aGeYrngC+7RX8kEa@intel.com>
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-39-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250703173248.44995-39-philmd@linaro.org>

On Thu, Jul 03, 2025 at 07:32:44PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  3 Jul 2025 19:32:44 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v6 38/39] accel: Extract AccelClass definition to
>  'accel/accel-ops.h'
> X-Mailer: git-send-email 2.49.0
> 
> Only accelerator implementations (and the common accelator
> code) need to know about AccelClass internals. Move the
> definition out but forward declare AccelState and AccelClass.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  MAINTAINERS                 |  2 +-
>  include/accel/accel-ops.h   | 50 +++++++++++++++++++++++++++++++++++++
>  include/qemu/accel.h        | 40 ++---------------------------
>  include/system/hvf_int.h    |  3 ++-
>  include/system/kvm_int.h    |  1 +
>  accel/accel-common.c        |  1 +
>  accel/accel-system.c        |  1 +
>  accel/hvf/hvf-all.c         |  1 +
>  accel/kvm/kvm-all.c         |  1 +
>  accel/qtest/qtest.c         |  1 +
>  accel/tcg/tcg-accel-ops.c   |  1 +
>  accel/tcg/tcg-all.c         |  1 +
>  accel/xen/xen-all.c         |  1 +
>  bsd-user/main.c             |  1 +
>  gdbstub/system.c            |  1 +
>  linux-user/main.c           |  1 +
>  system/memory.c             |  1 +
>  target/i386/nvmm/nvmm-all.c |  1 +
>  target/i386/whpx/whpx-all.c |  1 +
>  19 files changed, 70 insertions(+), 40 deletions(-)
>  create mode 100644 include/accel/accel-ops.h

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


