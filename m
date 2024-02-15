Return-Path: <kvm+bounces-8831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77450857193
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:27:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2041C21D0B
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D75A14534F;
	Thu, 15 Feb 2024 23:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jAQUfxAo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB75F13B7A2
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708039648; cv=none; b=oMwZHIh80iDOIUgWIq5tG3VykHXQpBmW12VQj3mo/buLrOeoFzb3Iu0eQ9BAHg9aEsYtHHmMrlT/bAMkA4E5dhjHmyKFxvxZxzVOt805d866LSRxwH0rNUa7Mr/kN+bDZwiKGK1ya8QkO+kiOh1gqau7M6Svtili9dNp8JolsLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708039648; c=relaxed/simple;
	bh=dqRJllxHJk02vellC/FB414Kijah5BlIS+1zh/OGRh0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g5DIsU1j3ZUosQmE6inDbyhdf/xzi/4grMtExEdoKPR9vwoTEXXZZ8rix40GV5EtrNPOfUDCMZOORjpAm/+eX2XMXWVsiOrqNjg7TsB9iJqB7mOood+YkuAyFNjyYNcrp0M0cXZ3+s/ZfCWDi55eoZUlzLQIdOPxF76WhBLqZmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jAQUfxAo; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708039647; x=1739575647;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=dqRJllxHJk02vellC/FB414Kijah5BlIS+1zh/OGRh0=;
  b=jAQUfxAoEaGTtdjPMRtDXU8uRojBl2ztmn7L8M4MkG9OeBmjn0fIKASK
   Cg0TTf5gw98C2ur/dCZyCFWN/+rJUf8jxpXN+1maSjknqVjbgCyNXsrqO
   +xHmB83BwynL2cirhnoYdsMmbk6RqZ/chbOuUOBIQipEm9dWLaPEaSuum
   2vyRe16BS/MnTikMfrdmbfO0XfmyI5bflD+MbsmneMNX8OjF1cwkjkjIf
   VZVS3LqMgHz+pTR2BzakVqYEUsaD+xpq3shTVNY+KnAwBcXYRCp0qKfkF
   rGSpStQe2Xkur+eNDYoYTLMyMKVqTKHEb00/HG6lkssdyFLy+2H/4NjhY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="5991615"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="5991615"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 15:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="912251969"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="912251969"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 15 Feb 2024 15:27:24 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ral8U-0000qK-10;
	Thu, 15 Feb 2024 23:27:22 +0000
Date: Fri, 16 Feb 2024 07:26:51 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:kvm-coco-queue 33/42] include/linux/kvm_host.h:2404:1: warning:
 no return statement in function returning non-void
Message-ID: <202402160740.fAyQeAi2-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   3428d62d5effe9bed1b9084ea8f7722761441ec0
commit: 08d58c22e8f1aa52e0732113e4af634302af9f06 [33/42] KVM: guest_memfd: add API to undo kvm_gmem_get_uninit_pfn
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20240216/202402160740.fAyQeAi2-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240216/202402160740.fAyQeAi2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402160740.fAyQeAi2-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/events/intel/core.c:17:
   include/linux/kvm_host.h: In function 'kvm_gmem_undo_get_pfn':
>> include/linux/kvm_host.h:2404:1: warning: no return statement in function returning non-void [-Wreturn-type]
    2404 | {}
         | ^


vim +2404 include/linux/kvm_host.h

  2400	
  2401	static inline int kvm_gmem_undo_get_pfn(struct kvm *kvm,
  2402					        struct kvm_memory_slot *slot, gfn_t gfn,
  2403					        int order)
> 2404	{}
  2405	#endif /* CONFIG_KVM_PRIVATE_MEM */
  2406	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

