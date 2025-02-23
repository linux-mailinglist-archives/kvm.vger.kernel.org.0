Return-Path: <kvm+bounces-38969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70751A41248
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 00:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 270EF7A7AC0
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2025 23:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F50204F8B;
	Sun, 23 Feb 2025 23:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jb5yWmsM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C25317588
	for <kvm@vger.kernel.org>; Sun, 23 Feb 2025 23:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740353995; cv=none; b=KfRT6/kQxn1xF42z4FLwNnc189zVaJM9ZTnOzqAoBdXjHJCFgjjKSrUOH08YNDHhWdMORlrkLioCw6vREx1aBQRde4NT1hRbm6ozHTuXSkS16ozZWD9J20aRrwZ7OuQkmgrJvthatVokiRXo7SiVv4XjLyzdQOLbn1OfCYzb4OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740353995; c=relaxed/simple;
	bh=hzCL0wIUvmBcBhuuc3gsWODoNAycfhMCTUXDCPb41Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=e7QpAJiIfb7znBACmhTqn75SFpNzswQe37UixDfCLFQtSmnlTSsAIDuSuO64ql9PJwttlksev6GwMToYoC3mzUKJc2QX39dvzeKSGR0hcRlA3JVwwkvUARqCXkuT4H+nKLZC5O9wZsgUlE2UrlMTQMmliP3fnTbignabr1fMQKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jb5yWmsM; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740353992; x=1771889992;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=hzCL0wIUvmBcBhuuc3gsWODoNAycfhMCTUXDCPb41Wo=;
  b=jb5yWmsMPdn8iYWxbLzaafI1N3HhfpCHimxexdlKBHKOK0cpSfUvq6xb
   EfGWGGQDX3MoVxSWdqlZWpwiry0YKhGmSeNiCuT8HEuyUi1UXdYERbOIp
   JR8/AAK54fSykYuwLPdfzrllqCIZ+qN0NqBP+9TvsjMA9dhgCkN4E87s1
   UjsKTBl5p+hOoAlEC5jvOBvNYHeRQmPU3xb0AGlWoVSsQdG0edRI1TLtv
   KwVzm38h+FhS26EbMtWDMP7u+vgL742JMpooaK4oDoC1M7lFzBjB0O8wM
   t2grjMhzCCD9Y8Atw5BE7O2DMl6lnQ/rpb0TFZjM1VZNG1KWwX3hVZa5r
   A==;
X-CSE-ConnectionGUID: +PcUy3WESkO6PNSgliEzsw==
X-CSE-MsgGUID: aKqRhXy3ToW1743Ta+fD/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="58517710"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="58517710"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 15:39:51 -0800
X-CSE-ConnectionGUID: BPnuqFCAQseOTp6NxUr3xQ==
X-CSE-MsgGUID: CpAuFQekSleKlr7kNt142A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="115876309"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 23 Feb 2025 15:39:49 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tmLZb-0007fV-0j;
	Sun, 23 Feb 2025 23:39:47 +0000
Date: Mon, 24 Feb 2025 07:39:35 +0800
From: kernel test robot <lkp@intel.com>
To: Zhiming Hu <zhiming.hu@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [kvm:kvm-coco-queue 30/121] arch/x86/include/asm/tdx.h:183:12:
 error: unused function 'tdx_get_nr_guest_keyids'
Message-ID: <202502240742.C79LoViU-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   ff2046f9bcd0883c72158404a1466eb96781ccca
commit: 5c017bb4d89f65807c56d652443b53e7765b8b35 [30/121] KVM: TDX: Register TDX host key IDs to cgroup misc controller
config: x86_64-randconfig-004-20250224 (https://download.01.org/0day-ci/archive/20250224/202502240742.C79LoViU-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250224/202502240742.C79LoViU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502240742.C79LoViU-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <built-in>:4:
   In file included from drivers/gpu/drm/xe/compat-i915-headers/i915_utils.h:6:
   In file included from drivers/gpu/drm/xe/compat-i915-headers/../../i915/i915_utils.h:37:
   In file included from arch/x86/include/asm/hypervisor.h:37:
   In file included from arch/x86/include/asm/kvm_para.h:10:
>> arch/x86/include/asm/tdx.h:183:12: error: unused function 'tdx_get_nr_guest_keyids' [-Werror,-Wunused-function]
     183 | static u32 tdx_get_nr_guest_keyids(void) { return 0; }
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for FB_IOMEM_HELPERS
   Depends on [n]: HAS_IOMEM [=y] && FB_CORE [=n]
   Selected by [m]:
   - DRM_XE_DISPLAY [=y] && HAS_IOMEM [=y] && DRM [=m] && DRM_XE [=m] && DRM_XE [=m]=m [=m] && HAS_IOPORT [=y]


vim +/tdx_get_nr_guest_keyids +183 arch/x86/include/asm/tdx.h

   162	
   163	u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
   164	u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
   165	u64 tdh_mng_key_config(struct tdx_td *td);
   166	u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
   167	u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
   168	u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
   169	u64 tdh_vp_flush(struct tdx_vp *vp);
   170	u64 tdh_mng_vpflushdone(struct tdx_td *td);
   171	u64 tdh_mng_key_freeid(struct tdx_td *td);
   172	u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
   173	u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
   174	u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
   175	u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
   176	u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
   177	u64 tdh_phymem_cache_wb(bool resume);
   178	u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
   179	#else
   180	static inline void tdx_init(void) { }
   181	static inline int tdx_cpu_enable(void) { return -ENODEV; }
   182	static inline int tdx_enable(void)  { return -ENODEV; }
 > 183	static u32 tdx_get_nr_guest_keyids(void) { return 0; }
   184	static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
   185	static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
   186	#endif	/* CONFIG_INTEL_TDX_HOST */
   187	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

