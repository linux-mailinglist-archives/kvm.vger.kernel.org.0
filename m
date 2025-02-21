Return-Path: <kvm+bounces-38834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A02FEA3ECC8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 07:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 822FA16A318
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 06:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EE61FC7D7;
	Fri, 21 Feb 2025 06:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zv6qivXU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDAC1E5B78
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 06:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740118817; cv=none; b=nZFMUhK/pBLRQPB2RP4Mqqh6M6PN1LAym+cSGO+jhM7nyU6Egq1nvsScFJVhrG/r9fbgDw8lXB+TOno54+ki9PgZf2oAIK2nBVvpeZAO9tW/Ltq2iVtciwFedTMd6iWlHSuQ5nk+YV3YZ8qBRpY4SWoqc0uWKXC3GHpAlpbmvio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740118817; c=relaxed/simple;
	bh=/TmnVBEIhOLYaI4vqlqV5Wg1fLgUkRzb1PPSGi6Cpn0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=R5dZrIghZh3JwNaj2EyJc0FWKf83dyDBBk7k1RpA/0L9aKPQ1aL9FMHCij3su3NlHcQAi7AEDvvT1KQHomeJv/rRYdTnvbI9QCgueXqzGcv4hWJkS9qbXXJWR1yPOrU2OZAGFGocGhUK8fymvV12GWsIJ8ZIAPZVtC8lzi8DhZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zv6qivXU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740118816; x=1771654816;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=/TmnVBEIhOLYaI4vqlqV5Wg1fLgUkRzb1PPSGi6Cpn0=;
  b=Zv6qivXUOn4SqxOiIrUMFHrvSDbiScpGIUtumNLVLClbaKRWvn4GyJmZ
   DVZSirdbfIL+qA9h5jgkmeqrwqKMlhW1SjP6MaMP5cuDNpvYCwk6ELq1k
   3gepdVlY/YfPSJrHnEBPeJcr9wxoSWl2sFT2LJgiVZ96JhGTe3iT0vgyv
   WrCC97ZCGDn3sUI2AZjIqKu3fyTusSPFj5i5OnL23t/ta6N4Rpn7/QR7w
   jOJqaum56hk3IfbrEN3I/8D7ExlXmE7yJT7zb58OpF2eTPF4DWVU5HVB/
   EwswrEUJHEy2/RYHmTLutB6eUqzWcZo4auDhYdvk9N1R7bjFU0I5hlZog
   A==;
X-CSE-ConnectionGUID: RyvCUSART96J4bG9SDb5xA==
X-CSE-MsgGUID: 7RLRTynDTM+aCo/p70t0LA==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="58333289"
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="scan'208";a="58333289"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 22:20:16 -0800
X-CSE-ConnectionGUID: QSoUjupuSyWODAJQ+lJ9uw==
X-CSE-MsgGUID: nkvV8U6zTbugezukpYjsaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="scan'208";a="114995433"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 20 Feb 2025 22:20:14 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tlMOR-0005Bd-1U;
	Fri, 21 Feb 2025 06:20:11 +0000
Date: Fri, 21 Feb 2025 14:19:33 +0800
From: kernel test robot <lkp@intel.com>
To: Zhiming Hu <zhiming.hu@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [kvm:kvm-coco-queue 30/121] arch/x86/include/asm/tdx.h:183:12:
 warning: 'tdx_get_nr_guest_keyids' defined but not used
Message-ID: <202502211420.jG76aLe3-lkp@intel.com>
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
config: i386-buildonly-randconfig-001-20250221 (https://download.01.org/0day-ci/archive/20250221/202502211420.jG76aLe3-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250221/202502211420.jG76aLe3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502211420.jG76aLe3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:22:
>> arch/x86/include/asm/tdx.h:183:12: warning: 'tdx_get_nr_guest_keyids' defined but not used [-Wunused-function]
     183 | static u32 tdx_get_nr_guest_keyids(void) { return 0; }
         |            ^~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from arch/x86/kernel/asm-offsets.c:22:
>> arch/x86/include/asm/tdx.h:183:12: warning: 'tdx_get_nr_guest_keyids' defined but not used [-Wunused-function]
     183 | static u32 tdx_get_nr_guest_keyids(void) { return 0; }
         |            ^~~~~~~~~~~~~~~~~~~~~~~


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

