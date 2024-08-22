Return-Path: <kvm+bounces-24818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7452995B332
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 12:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BAAB1F23637
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 10:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA20183CB6;
	Thu, 22 Aug 2024 10:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hck3XNUs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8676317CA16;
	Thu, 22 Aug 2024 10:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724323745; cv=none; b=An//fE5zmScyXYaqf90qYvat1q8ZsXvzXdYRL8YGqnxc8FRJvKFYpw8cIEdtPGJN+gsRyowc5nigfvK453w+Ciz0288bPvElZwBjZVcTdT5kq0f37mo0RlUR5C5OGWeSRIyPaLXZOogkI+19XkzauLouO1XehNTq5piL25FP5NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724323745; c=relaxed/simple;
	bh=pcJbZbqHKck86vA7euPkLTW0Qpjz3e4EM8AdEqVYB54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLvaQRvATc/eOAy4OtpprkNurEuAdsULUzsT8s6QT+Ze7W6RvhZaxdBNZAiezKDRabvTCjwC9gRSIjdi/VLzCTRwltjPJy6Ov9CMHjdoyqSan4wxVR1Y1cpXOPwdBtNZiv6z9UArZA47sH5+DWsWDmxvYTx+AhrfAjzd+7UhPeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hck3XNUs; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724323744; x=1755859744;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pcJbZbqHKck86vA7euPkLTW0Qpjz3e4EM8AdEqVYB54=;
  b=hck3XNUsgE03t3tSwE5tHyEhGG1GExxH5hcQgbSBFncj8ATqRILX4Dvm
   A1dqb3QW+1NTAsRBKDMm8wkGxqW4hjru/G+N/wofDfsskJp2iDJOBrdag
   fEBPP9cej0jjwg0d82GmbXUpEsk1lcOzWkJtc/udcRSVqwPtaYv2hQ2rA
   Eaox/7/7gjA2MSb7BjkhBl9DC5Keyz7A7q/4I59ZbRWgaj4J2Mu27R+qi
   J+VD2EngpyM9bObwVIhutOcvQttMhUyX38pbsele9178ZMrYYchZv58xa
   3BjbM+hdIbaEfKptNQC1N/QosnpwOVSeZ4LBxmg0W5gLUjGMAaiVOekHX
   w==;
X-CSE-ConnectionGUID: iizzxVfzSfSxXkgCphoIbw==
X-CSE-MsgGUID: uW+/zczrTBKxIvkYMEWypA==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="26595941"
X-IronPort-AV: E=Sophos;i="6.10,166,1719903600"; 
   d="scan'208";a="26595941"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 03:49:03 -0700
X-CSE-ConnectionGUID: U1qYWecDT1+euIBUjlvmdA==
X-CSE-MsgGUID: zB+4lPy8QGegn0qmUqp0zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,166,1719903600"; 
   d="scan'208";a="84575188"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 22 Aug 2024 03:49:02 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sh5ND-000CgG-2c;
	Thu, 22 Aug 2024 10:48:59 +0000
Date: Thu, 22 Aug 2024 18:48:55 +0800
From: kernel test robot <lkp@intel.com>
To: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 1/1] KVM: selftestsi: Create KVM selftests runnner to run
 interesting tests
Message-ID: <202408221838.XU8LHJDm-lkp@intel.com>
References: <20240821223012.3757828-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821223012.3757828-2-vipinsh@google.com>

Hi Vipin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed]

url:    https://github.com/intel-lab-lkp/linux/commits/Vipin-Sharma/KVM-selftestsi-Create-KVM-selftests-runnner-to-run-interesting-tests/20240822-063157
base:   de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
patch link:    https://lore.kernel.org/r/20240821223012.3757828-2-vipinsh%40google.com
patch subject: [PATCH 1/1] KVM: selftestsi: Create KVM selftests runnner to run interesting tests
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20240822/202408221838.XU8LHJDm-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240822/202408221838.XU8LHJDm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408221838.XU8LHJDm-lkp@intel.com/

All warnings (new ones prefixed by >>):

   tools/testing/selftests/arm64/tags/.gitignore: warning: ignored by one of the .gitignore files
   tools/testing/selftests/arm64/tags/Makefile: warning: ignored by one of the .gitignore files
   tools/testing/selftests/arm64/tags/tags_test.c: warning: ignored by one of the .gitignore files
   tools/testing/selftests/kvm/.gitignore: warning: ignored by one of the .gitignore files
   tools/testing/selftests/kvm/Makefile: warning: ignored by one of the .gitignore files
   tools/testing/selftests/kvm/config: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/kvm/runner.py: warning: ignored by one of the .gitignore files
   tools/testing/selftests/kvm/settings: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/kvm/tests.json: warning: ignored by one of the .gitignore files

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

