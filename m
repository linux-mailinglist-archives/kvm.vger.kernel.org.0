Return-Path: <kvm+bounces-10582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3C586DB26
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 06:30:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60F851F236B4
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 05:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359CE524DC;
	Fri,  1 Mar 2024 05:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J9eA7fjU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F3C50A8F;
	Fri,  1 Mar 2024 05:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709271010; cv=none; b=mRPFpVpe4o4ikiEHX2eVlLGxFXAa02Mr8VdSxUL5l8fJYNugo15XZiIpxlhHXQJGLkDFDtORQhiB6d/DzrCxK2a6GYmLPpQqJxaNsI3PZINqhRpbcTm6gKbC2E1UIz5iWHPWun8C1gkmcPWwOE/0eNg5ulM1YMmiR3sySuJLBwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709271010; c=relaxed/simple;
	bh=yUOV0dq5JKRNnbJJINmDoCKpgeqYWZeaU6kZotwZpuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVAVOxXLtZuJ7cHB/8MIZLJQn5UEfgQXcBLkkrCGS3zDw6DT4DhvCs3TD4u1KMD5omJL1IPtnwB1Nzu6rtzIN24LQ2oHwpfK/1GIYn92/S3hnFv14rEbD0u7+4flkuftRF8gSA/b4hwUgHyPjJDqeH/fLJDYBIyX/Al8hzfKMNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J9eA7fjU; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709271008; x=1740807008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=yUOV0dq5JKRNnbJJINmDoCKpgeqYWZeaU6kZotwZpuI=;
  b=J9eA7fjUYA+c3ntZewCi1fqt6XP8GYwFvasrMeLOZQb7SczLHZ0bRlKe
   OkEon2YrujW8xG7BBwGRBlVzl0X5bSEFV5S3MPyMLpuMVriuLSI/YvSMA
   yuqI7lPimlJGI53WmIAgCpUZKMh4rxVmQ6tcEqmZ0X+vCbPRZ3uJIPjdW
   7/R0RMowK0T+7VMkhWwqaPAcVc3Rc7Bs0h7KpbjkgSVqZMFyC0wq0HSqg
   XaGiJDvtgX62D7PSmVi3WMnR70MdvZ6sbrIyUUJTKIT/kB+UXQyg9RaXS
   lAokeDbdVF53IC0q59BvpPB8Wp3PWU6Dookpuc4m9XEA0N+j2XL331rWG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="15226247"
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="15226247"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 21:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="12766605"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 29 Feb 2024 21:29:59 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rfvT2-000DZ8-2R;
	Fri, 01 Mar 2024 05:29:56 +0000
Date: Fri, 1 Mar 2024 13:29:40 +0800
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
Subject: Re: [PATCH v1 1/8] kunit: Run tests when the kernel is fully setup
Message-ID: <202403011330.telj6BqQ-lkp@intel.com>
References: <20240229170409.365386-2-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-2-mic@digikod.net>

Hi Mickaël,

kernel test robot noticed the following build warnings:

[auto build test WARNING on d206a76d7d2726f3b096037f2079ce0bd3ba329b]

url:    https://github.com/intel-lab-lkp/linux/commits/Micka-l-Sala-n/kunit-Run-tests-when-the-kernel-is-fully-setup/20240301-011020
base:   d206a76d7d2726f3b096037f2079ce0bd3ba329b
patch link:    https://lore.kernel.org/r/20240229170409.365386-2-mic%40digikod.net
patch subject: [PATCH v1 1/8] kunit: Run tests when the kernel is fully setup
config: arc-allmodconfig (https://download.01.org/0day-ci/archive/20240301/202403011330.telj6BqQ-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240301/202403011330.telj6BqQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403011330.telj6BqQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/kunit/executor.c:18:31: warning: 'final_suite_set' defined but not used [-Wunused-variable]
      18 | static struct kunit_suite_set final_suite_set = {};
         |                               ^~~~~~~~~~~~~~~


vim +/final_suite_set +18 lib/kunit/executor.c

    17	
  > 18	static struct kunit_suite_set final_suite_set = {};
    19	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

