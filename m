Return-Path: <kvm+bounces-51561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 344E0AF8C1D
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB4263B506D
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DBE2E4271;
	Fri,  4 Jul 2025 08:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LVVYL6G/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269482E267B
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617858; cv=none; b=fUQhZB0q1pecTOJforbBWEkMHhuyKVQFGtY4BrDqtTf9LN0KJAkagO3V/Z3KkcxRyTbr+JjTNNXDs2iOwGYfDm9qYhqYwn4LKlsZZqty+bGDcn01oM9s6HI9JjZnmW8OjBZff1EUM1oY0Phd2/RTJx7QxocbFT0buHhvCw+ETWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617858; c=relaxed/simple;
	bh=qSKFJqr0Qywi0iAlGlIkKfjQJIEPf0LTXkikDjrW5KU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5v3p8jaH2zkY3ZFsPX+NrTR1Vfmg+4xJa7C1B6NJDek4J/IOIHsUw9k7R4GAMGUx6GZeV5LkoPVxQkBqYACRq5Fb+0JTBnYIPePz4feVBiXWY4GJ4pyqMN7ywfhWt9kJryEeuQgTBUHnVi6AWfs0sEy+ncliN0sH2WpTiEi9YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LVVYL6G/; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751617857; x=1783153857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=qSKFJqr0Qywi0iAlGlIkKfjQJIEPf0LTXkikDjrW5KU=;
  b=LVVYL6G/8nFPnAMCsWhmMiS4ZX5MxFTrqGv90XwP8KStRlABGxxjxV6t
   06ueeZDeY0KyGReYaMQi5LsOkKE1s+wH1/Zy+S0Nig1TR0MlRP7IJ6mQb
   2genx4SLduZt+PcfjOkvjN5oXrS9XGqhTzOtLGVq5br85fIBlNIOP67Wk
   zilSFUOdKBhPkfSh8cBGGSNAFC/4/6CQBUnN9cd5oF2LIPrKqH1bY8LMy
   TkjOP2hAbiLRHKyCUIvEEpCACe99r90MckobU84+VxCCfavhF8/uRr1s4
   1xwSQpnJFpduhuCWDJ1P6kzoUh5SzQ2MNqkHC3QadcuWUFBCV0TvEGm+d
   w==;
X-CSE-ConnectionGUID: MgKUaZ7rRzSEUmI7RJI7BQ==
X-CSE-MsgGUID: J8KYOevURw2IlKp/2ZV2vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53671781"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53671781"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:30:57 -0700
X-CSE-ConnectionGUID: GBBpck5FRFWey8H+f0UU4g==
X-CSE-MsgGUID: 7U0brTSvSf+E4dFTzF06GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154233853"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 04 Jul 2025 01:30:52 -0700
Date: Fri, 4 Jul 2025 16:52:18 +0800
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
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 37/39] accel: Rename 'system/accel-ops.h' ->
 'accel/accel-cpu-ops.h'
Message-ID: <aGeWQu8iYlzuPYQ+@intel.com>
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-38-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250703173248.44995-38-philmd@linaro.org>

On Thu, Jul 03, 2025 at 07:32:43PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  3 Jul 2025 19:32:43 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v6 37/39] accel: Rename 'system/accel-ops.h' ->
>  'accel/accel-cpu-ops.h'
> X-Mailer: git-send-email 2.49.0
> 
> Unfortunately "system/accel-ops.h" handlers are not only
> system-specific. For example, the cpu_reset_hold() hook
> is part of the vCPU creation, after it is realized.
> 
> Mechanical rename to drop 'system' using:
> 
>   $ sed -i -e s_system/accel-ops.h_accel/accel-cpu-ops.h_g \
>               $(git grep -l system/accel-ops.h)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/{system/accel-ops.h => accel/accel-cpu-ops.h} | 8 ++++----
>  accel/accel-common.c                                  | 2 +-
>  accel/accel-system.c                                  | 2 +-
>  accel/hvf/hvf-accel-ops.c                             | 2 +-
>  accel/kvm/kvm-accel-ops.c                             | 2 +-
>  accel/qtest/qtest.c                                   | 2 +-
>  accel/tcg/tcg-accel-ops.c                             | 2 +-
>  accel/xen/xen-all.c                                   | 2 +-
>  cpu-target.c                                          | 2 +-
>  gdbstub/system.c                                      | 2 +-
>  system/cpus.c                                         | 2 +-
>  target/i386/nvmm/nvmm-accel-ops.c                     | 2 +-
>  target/i386/whpx/whpx-accel-ops.c                     | 2 +-
>  13 files changed, 16 insertions(+), 16 deletions(-)
>  rename include/{system/accel-ops.h => accel/accel-cpu-ops.h} (96%)

...

> -#ifndef ACCEL_OPS_H
> -#define ACCEL_OPS_H
> +#ifndef ACCEL_CPU_OPS_H
> +#define ACCEL_CPU_OPS_H

Daniel mentioned "QEMU_" prefix is "best practice":

https://lore.kernel.org/qemu-devel/aAdSMExEAy45NIeB@redhat.com/

But I also think there's no need to change anything here for now. If
you agree, we can move in this direction in the future. So

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


