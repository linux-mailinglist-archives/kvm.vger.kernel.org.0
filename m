Return-Path: <kvm+bounces-29050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 875929A1BDF
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 09:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AACB01C2209A
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 07:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FFA1CFEA8;
	Thu, 17 Oct 2024 07:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IbOHHlT/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BA939FE5;
	Thu, 17 Oct 2024 07:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150992; cv=none; b=IHBRbfaqFldavPMpU4wmLNOx0Uj1YQOE4sbdq6r83mdNAo/3JaU8atzD33T4QxqETlD5Q33815P6ucAm518y5S6t6yJGwQ2wHkqqLViiN0wymIKXdQT+LckbnF0Au85pm/oi/J9hRqyW6LtH8P2wCu/59mkZyxmVwQCodfKm7EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150992; c=relaxed/simple;
	bh=zjXOnpVg3YO/v5WC1ZRoTmp2lFkP/tJ10tDZqUyYkdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1lm+KHZqTFygc1CangzogycfeaUleiwHq3kdmYQ/2FpznCVYbj8Yl8uZyFFAI50y0dqdsH8YS7i1kBoriGDkXIls/Pp16zGkjX30DuRSrxtpf7V1ugKx/3t9AE3riC1SAWKcNmWSxC5sxgUmqZJM9ejMYN7IDXjOKdSxc4t9Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IbOHHlT/; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729150989; x=1760686989;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zjXOnpVg3YO/v5WC1ZRoTmp2lFkP/tJ10tDZqUyYkdw=;
  b=IbOHHlT/29FqA5nwUvJCEeMEhFqHXTof5EUKVcbanzHcav98L9zUSg9U
   R/nRG89uImbpv41Fj2gIz7TYFhc2pTCw8Cg2kXDfD+peoGB5bDm9Nt8op
   1F0jz21h0MNi7W5FLxX99fboCrbAfRZ2fFbshYIDqm2bdSV605FUtZ/i9
   XZ4fMPFP1CEXagfWPaUdW7FxoegSVEoZ4WJ+4fu38jkKgC5vAk8WNj49n
   EKV4Pod6h75QTJWVUsSvYLOp5tWy8O07PV3Qq/gGl290RrLaCk4BjZYqg
   6uSd/BC3blZWNaorS4mmv4BABT6WaNGCqnuXOjmAscmpW19x03gT4HG63
   g==;
X-CSE-ConnectionGUID: CJgKQlxlR4WLW8GDjHqpOg==
X-CSE-MsgGUID: VuhoU10ES46aKNWqq848ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11227"; a="40022686"
X-IronPort-AV: E=Sophos;i="6.11,210,1725346800"; 
   d="scan'208";a="40022686"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 00:43:09 -0700
X-CSE-ConnectionGUID: acJPe0JVSauLn/nltG7qEA==
X-CSE-MsgGUID: 8N/QpAneSeedgmoZd+I7Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,210,1725346800"; 
   d="scan'208";a="109271908"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 17 Oct 2024 00:43:05 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t1L9y-000Ltf-1K;
	Thu, 17 Oct 2024 07:43:02 +0000
Date: Thu, 17 Oct 2024 15:42:30 +0800
From: kernel test robot <lkp@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org,
	kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, nikunj@amd.com
Subject: Re: [PATCH v12 07/19] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <202410171505.gZbmXuo2-lkp@intel.com>
References: <20241009092850.197575-8-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009092850.197575-8-nikunj@amd.com>

Hi Nikunj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b]

url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/virt-sev-guest-Use-AES-GCM-crypto-library/20241009-173734
base:   8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
patch link:    https://lore.kernel.org/r/20241009092850.197575-8-nikunj%40amd.com
patch subject: [PATCH v12 07/19] x86/sev: Carve out and export SNP guest messaging init routines
config: x86_64-randconfig-121-20241017 (https://download.01.org/0day-ci/archive/20241017/202410171505.gZbmXuo2-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241017/202410171505.gZbmXuo2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410171505.gZbmXuo2-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/coco/sev/core.c:2663:24: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct snp_secrets_page *secrets @@     got void [noderef] __iomem * @@
   arch/x86/coco/sev/core.c:2663:24: sparse:     expected struct snp_secrets_page *secrets
   arch/x86/coco/sev/core.c:2663:24: sparse:     got void [noderef] __iomem *
>> arch/x86/coco/sev/core.c:2694:22: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got struct snp_secrets_page *secrets @@
   arch/x86/coco/sev/core.c:2694:22: sparse:     expected void volatile [noderef] __iomem *addr
   arch/x86/coco/sev/core.c:2694:22: sparse:     got struct snp_secrets_page *secrets

vim +2663 arch/x86/coco/sev/core.c

  2649	
  2650	struct snp_msg_desc *snp_msg_alloc(void)
  2651	{
  2652		struct snp_msg_desc *mdesc;
  2653	
  2654		BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
  2655	
  2656		if (snp_mdesc)
  2657			return snp_mdesc;
  2658	
  2659		mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);
  2660		if (!mdesc)
  2661			return ERR_PTR(-ENOMEM);
  2662	
> 2663		mdesc->secrets = ioremap_encrypted(secrets_pa, PAGE_SIZE);
  2664		if (!mdesc->secrets)
  2665			return ERR_PTR(-ENODEV);
  2666	
  2667		/* Allocate the shared page used for the request and response message. */
  2668		mdesc->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
  2669		if (!mdesc->request)
  2670			goto e_unmap;
  2671	
  2672		mdesc->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
  2673		if (!mdesc->response)
  2674			goto e_free_request;
  2675	
  2676		mdesc->certs_data = alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
  2677		if (!mdesc->certs_data)
  2678			goto e_free_response;
  2679	
  2680		/* initial the input address for guest request */
  2681		mdesc->input.req_gpa = __pa(mdesc->request);
  2682		mdesc->input.resp_gpa = __pa(mdesc->response);
  2683		mdesc->input.data_gpa = __pa(mdesc->certs_data);
  2684	
  2685		snp_mdesc = mdesc;
  2686	
  2687		return mdesc;
  2688	
  2689	e_free_response:
  2690		free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
  2691	e_free_request:
  2692		free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
  2693	e_unmap:
> 2694		iounmap(mdesc->secrets);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

