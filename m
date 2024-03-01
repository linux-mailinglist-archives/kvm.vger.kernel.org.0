Return-Path: <kvm+bounces-10692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B45FD86EA86
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 21:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5977728E724
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456B33D997;
	Fri,  1 Mar 2024 20:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J7sdiITJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271C7E1;
	Fri,  1 Mar 2024 20:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709325833; cv=none; b=Rbeof/Mu+72jo/slQ8qrLYjzimE8XJKaeMvLncdGI+50WG6fKvg2NnOpBBf4IYeWYhHdOeIygI3v2bto2zE8FU9QFuEoDPmK6lSOu+IPMt8naa6y0+5EIcnCFdICDWJb7xxULjYxL1aoK7uGbhhKK8Fka+WF7eFgoy11iJwxC+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709325833; c=relaxed/simple;
	bh=kUyMdHkVkpeJxiyTY9gwfrRpGuWeFO/2yLcwV4ze4PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJRpnTlhHr0/POhRK6S128M0PD4l1vnUCVb3a+jkjufx2wCkOfYTLlwqQarJr5piEUVN36gskxrH1KLtR6aS1WKOqFOrId2J1zRiW0JBnv2zMkF+k96aHS43hYOkELuuPiI+KzirBdcTk2TbtfrQx6u16W7I0pC9v2PO4Io01CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J7sdiITJ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709325832; x=1740861832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kUyMdHkVkpeJxiyTY9gwfrRpGuWeFO/2yLcwV4ze4PY=;
  b=J7sdiITJ1kAZr8sgz50mVhoWucZdfvkoFsu+OXac+ZYGYPkQFX5OPufN
   GYcmyMdCwuJePDNkldKBwQ6Phco2fJwTUK2a/EYPGiSOa6dTn5qX5w9/w
   CROt2hwL/xvur3IU3TOkt5EJb7dPdWtOr06eQ3UiXhTGSTMmZ6lUzvNpT
   D+4P4zIm2il4OlYlml1+oBehYmh+3/dx5FXGBN/UfMgwIx+r9AaOG4YTA
   jSKPPtaCV5JYuqmCgCIxKjCPVLwsnronNpJzofoZ/sbagtThIMm4oXZ+O
   JCuLQ7HKbUTVjG3yx+nnYsf8kbPkClwW+teTUG1nqvpO7nCvbuGsZxFXc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="3808094"
X-IronPort-AV: E=Sophos;i="6.06,197,1705392000"; 
   d="scan'208";a="3808094"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 12:43:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,197,1705392000"; 
   d="scan'208";a="8374083"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 01 Mar 2024 12:43:42 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rg9j3-000E5D-2e;
	Fri, 01 Mar 2024 20:43:32 +0000
Date: Sat, 2 Mar 2024 04:42:59 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>, Kees Cook <keescook@chromium.org>,
	Rae Moar <rmoar@google.com>, Shuah Khan <skhan@linuxfoundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v1 8/8] kunit: Add tests for faults
Message-ID: <202403020418.NnNnFElm-lkp@intel.com>
References: <20240229170409.365386-9-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-9-mic@digikod.net>

Hi Mickaël,

kernel test robot noticed the following build warnings:

[auto build test WARNING on d206a76d7d2726f3b096037f2079ce0bd3ba329b]

url:    https://github.com/intel-lab-lkp/linux/commits/Micka-l-Sala-n/kunit-Run-tests-when-the-kernel-is-fully-setup/20240301-011020
base:   d206a76d7d2726f3b096037f2079ce0bd3ba329b
patch link:    https://lore.kernel.org/r/20240229170409.365386-9-mic%40digikod.net
patch subject: [PATCH v1 8/8] kunit: Add tests for faults
config: x86_64-randconfig-122-20240301 (https://download.01.org/0day-ci/archive/20240302/202403020418.NnNnFElm-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240302/202403020418.NnNnFElm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403020418.NnNnFElm-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/kunit/kunit-test.c:142:11: sparse: sparse: symbol 'test_const' was not declared. Should it be static?

vim +/test_const +142 lib/kunit/kunit-test.c

   141	
 > 142	const int test_const = 1;
   143	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

