Return-Path: <kvm+bounces-34933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42774A07F1D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 18:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33C967A32F1
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 17:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7541F37D6;
	Thu,  9 Jan 2025 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxWUW9gU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C082192D7E;
	Thu,  9 Jan 2025 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736444568; cv=none; b=rmHNHkMROaOsnkx9/5fvS2yXBw9BKLhogSIv4FKpf6qmtpdq45QCov+QDRT89C3wgC7i+i66WBqgiqKTDo7g2nSOSmfBnyGNm/RKzwAhZLtIKGWafBkhyLhr59V4xWQZjXxd/9Ix7Gp4HUxir0JZ+g5NaPAIeLgeC8lm76uy5js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736444568; c=relaxed/simple;
	bh=dgToOXb8BvN4dra1Kh0zNZ6JczMXJPb/z/Obr2XcVuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGXWCRQhFM79APAq3FdX6/6fwSjRhrzi1IDLsDDwg2KTG8L8si/fr6Qra7lwtsPcPZZKwjnwolepPWJ480hrCwIQLwcIw0ELAX7GQJzEhXbAeGeHq6xp7AqLwCUAdzlP3D1KXB5jhXokCUJ5P/AYOJ+0wA1hJfdDBZDTMdwllPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bxWUW9gU; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736444567; x=1767980567;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dgToOXb8BvN4dra1Kh0zNZ6JczMXJPb/z/Obr2XcVuo=;
  b=bxWUW9gUn4Q3H3cNa7LGSfTsm6cZ6vesi4focjJ8Sl0f/W9TWKIFGPnS
   jTUcOO2eiaaj51LTI/kao4wSd7vj5O/6j4rtNnJKLSF8o6gFEIGTOErxy
   dKdYERlUvJ7pqW01ZjKCC3jxbuNsZP6D/k7Doa5JxsBhwuOTmuarNigUh
   ruYemTIBpoQ3Wh7p8ElNuHDSKi85v6YNWlVawAnT8r8H0/QLNcfVD/uXi
   WvdpX5UmXcWOlTI5H40Jpt4mS9oqPO67C3mEgj2CYY/6xqH7Ir6faqYV/
   SlOSCyZbN1CkrFruOepFdUi9/WP1C2gM8KBWL5KE60UvoL3sYHCu/s4mE
   Q==;
X-CSE-ConnectionGUID: oxHwX3eaQCOUii8uJcr+LA==
X-CSE-MsgGUID: AESLZacDQD2wJgMX8ijUnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="36602372"
X-IronPort-AV: E=Sophos;i="6.12,302,1728975600"; 
   d="scan'208";a="36602372"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 09:42:47 -0800
X-CSE-ConnectionGUID: k1Q/oHnYS2u8SlDT98Hsog==
X-CSE-MsgGUID: pQYon3DlSXaJlOBIOZEk9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="126759244"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Jan 2025 09:42:43 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tVwYL-000HwX-16;
	Thu, 09 Jan 2025 17:42:41 +0000
Date: Fri, 10 Jan 2025 01:42:02 +0800
From: kernel test robot <lkp@intel.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-s390@vger.kernel.org,
	frankja@linux.ibm.com, borntraeger@de.ibm.com,
	schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
	hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
	gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 04/13] KVM: s390: move pv gmap functions into kvm
Message-ID: <202501100045.U1NGK9qJ-lkp@intel.com>
References: <20250108181451.74383-5-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108181451.74383-5-imbrenda@linux.ibm.com>

Hi Claudio,

kernel test robot noticed the following build warnings:

[auto build test WARNING on s390/features]
[also build test WARNING on kvm/queue kvm/next mst-vhost/linux-next linus/master v6.13-rc6 next-20250109]
[cannot apply to kvms390/next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Claudio-Imbrenda/KVM-s390-wrapper-for-KVM_BUG/20250109-021808
base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
patch link:    https://lore.kernel.org/r/20250108181451.74383-5-imbrenda%40linux.ibm.com
patch subject: [PATCH v1 04/13] KVM: s390: move pv gmap functions into kvm
config: s390-randconfig-001-20250109 (https://download.01.org/0day-ci/archive/20250110/202501100045.U1NGK9qJ-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250110/202501100045.U1NGK9qJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501100045.U1NGK9qJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/s390/kvm/gmap.c:144: warning: Function parameter or struct member 'page' not described in '__gmap_destroy_page'
>> arch/s390/kvm/gmap.c:144: warning: expecting prototype for gmap_destroy_page(). Prototype was for __gmap_destroy_page() instead


vim +144 arch/s390/kvm/gmap.c

   133	
   134	/**
   135	 * gmap_destroy_page - Destroy a guest page.
   136	 * @gmap: the gmap of the guest
   137	 * @gaddr: the guest address to destroy
   138	 *
   139	 * An attempt will be made to destroy the given guest page. If the attempt
   140	 * fails, an attempt is made to export the page. If both attempts fail, an
   141	 * appropriate error is returned.
   142	 */
   143	static int __gmap_destroy_page(struct gmap *gmap, struct page *page)
 > 144	{
   145		struct folio *folio = page_folio(page);
   146		int rc;
   147	
   148		/*
   149		 * See gmap_make_secure(): large folios cannot be secure. Small
   150		 * folio implies FW_LEVEL_PTE.
   151		 */
   152		if (folio_test_large(folio))
   153			return -EFAULT;
   154	
   155		rc = uv_destroy_folio(folio);
   156		/*
   157		 * Fault handlers can race; it is possible that two CPUs will fault
   158		 * on the same secure page. One CPU can destroy the page, reboot,
   159		 * re-enter secure mode and import it, while the second CPU was
   160		 * stuck at the beginning of the handler. At some point the second
   161		 * CPU will be able to progress, and it will not be able to destroy
   162		 * the page. In that case we do not want to terminate the process,
   163		 * we instead try to export the page.
   164		 */
   165		if (rc)
   166			rc = uv_convert_from_secure_folio(folio);
   167	
   168		return rc;
   169	}
   170	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

