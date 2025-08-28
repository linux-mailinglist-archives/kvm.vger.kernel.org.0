Return-Path: <kvm+bounces-56007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB2EB39102
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 03:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C2E93A3BAA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 01:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073641FA15E;
	Thu, 28 Aug 2025 01:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hFHzfVNq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40B1F3BA2
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 01:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756343945; cv=none; b=rwSAGw8XPPxdKO85ic1207t29ERqBn27rSUfnf3+moV+dxDuo+xXeEuFqJGqLc5Ot9iYAYSo/kmqAR0FaSoV8fyaPoBi0+RGdaVGrgY8Ioe6WIr083t/N55XxFvkxqOwXwh4c+IonEg9BiyLkT2gtlhzQdxfzZUJzQYkBePvqyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756343945; c=relaxed/simple;
	bh=scaFG6iPgc8hbuefno0IYF8MM9iYgaFa9NwpAUJXlQI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pOaOY28bAKm1d8gTmBAIMkmXpC59T8r4/6ddKAX7Nesmyzj9Hun71gmWpYdEJ7AwZkt5dNUo2cjS8ARptu0LnRIptFJFzsvsQzswqqGj7EEybCm1pJBi2QXWMsESDXRYXg2XUkPgL9QwM+b+nB9WpoQaDWSa7jOzYiYet4ifXhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hFHzfVNq; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756343943; x=1787879943;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=scaFG6iPgc8hbuefno0IYF8MM9iYgaFa9NwpAUJXlQI=;
  b=hFHzfVNqNIYIeLjrxETm4rYWdoyMCY2GXhL8+Ib9GzaDK4Ekgomsnips
   sQXrYkRwBEUF7wGxr72VQ5aL0qHHZtHHrv279qTvV/GHEGgDBYNyYFR+D
   VSPsmtSkfTl5bhnxhyW/0ffkqQ3uKdknBncu9Po0j2+vCVaCOUzoxWAMn
   O7xcrVsT9rJabeP/4mLSHaUWwGlsHizyyQQsXhmRiNWP4qABgo+8R7JLb
   F65G/+TBHmWduwY65dXNMD/+CkG4O/pLZYiKQ4Jmw6W5083m82wVa88Xb
   RMn6gz8es3amEr6VMyJFSS8DGhJmwJsbr+ViYvdx8mzNa/HFQirCybod6
   g==;
X-CSE-ConnectionGUID: iqjAXis7TieC/cbrKAqQgw==
X-CSE-MsgGUID: ZhF57m4zQ/KBSO8stsriyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="57631882"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="57631882"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 18:19:03 -0700
X-CSE-ConnectionGUID: IZUmbVXeQuuD0Ir6+mCpDA==
X-CSE-MsgGUID: PTcioG5IQ7GwRA5P+cQjVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174316638"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 27 Aug 2025 18:19:02 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1urRI2-000TL5-06;
	Thu, 28 Aug 2025 01:18:58 +0000
Date: Thu, 28 Aug 2025 09:18:23 +0800
From: kernel test robot <lkp@intel.com>
To: David Matlack <dmatlack@google.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [awilliam-vfio:next 5/37] tools/testing/selftests/vfio/.gitignore:
 warning: ignored by one of the .gitignore files
Message-ID: <202508280918.rFRyiLEU-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/awilliam/linux-vfio.git next
head:   9f3acb3d9a1872e2fa36af068ca2e93a8a864089
commit: 292e9ee22b0adad49c9a6f63708988e32c007da6 [5/37] selftests: Create tools/testing/selftests/vfio
config: i386-buildonly-randconfig-001-20250828 (https://download.01.org/0day-ci/archive/20250828/202508280918.rFRyiLEU-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250828/202508280918.rFRyiLEU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508280918.rFRyiLEU-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> tools/testing/selftests/vfio/.gitignore: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/vfio/Makefile: warning: ignored by one of the .gitignore files

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

