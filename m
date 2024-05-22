Return-Path: <kvm+bounces-17906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DBB8CB8E7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 04:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 712301F2676F
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FCEE5812B;
	Wed, 22 May 2024 02:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lYTrk8eK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7D15476B;
	Wed, 22 May 2024 02:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716344868; cv=none; b=bYdkfiS5G7OduCpbUwGtE8H3E+1SjYVcJsMtAyDdtlf1eUq4AagY/d5dhHxZsVkiVWruKFTIEHOkLtCniTLXDyXHGw0zvlmNzVoP9slrUDOY+OS1eZGYlxVDposE0rjXA2V/fwZ16Pd/H30ivFTsKkg7YPxH/wPV1Hf5bgUmuNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716344868; c=relaxed/simple;
	bh=zv1bDCgDyK66NAyyXA3qwyVKDI4Dj0TjLmGIr7Tt64o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8eB1s0blcskvCTktTQx3Z504Nva/MEoEnVopR9X3z6FbofXYwPg9lp1CWQQsW71NcjOKF6nRPQUC9bIPaAi6E+PgdHf1FZBW6ngwTZ89PA4Z0XSm1pTAcYmRqtjBuAPbPju8tC8ZwZou6inL9JHCxOcgcRHZRRERNnLWsmx5oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lYTrk8eK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716344867; x=1747880867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zv1bDCgDyK66NAyyXA3qwyVKDI4Dj0TjLmGIr7Tt64o=;
  b=lYTrk8eKeLtf80E21RKOHmaD7A+opYgD5RwJD4Rwv+WjGta5kdprMAIR
   H3JWtIE+G0k7PQnjWeGFlwXeOtG5dKJ6MW93NXW2YPz8KhbQ5Pcc+v2RG
   ao3PnlfC4j0DdgD/9hSr4fxlRXoq5pAEfbSHYnH7FkItK1JcuVzmEgH0y
   6f7HMrgEJWapWBelsqoTmndLMRXyt1RISDMS6tg6u4jbEwoQqCZvC2MG7
   xG5q5ReFDrkmhUBuCTbsSQ6LrMLB2zbNdepqZhsC5ZKh+qAUsZeykcYPC
   dC8E4bXpy3iDO0QswD5ynhIkHzqlpqkCBakobQK5nK2Tq7Q/UhugshGAS
   A==;
X-CSE-ConnectionGUID: wSHoqzD3Sqq3CoZbtfifyg==
X-CSE-MsgGUID: xWOZrB55RCqMFECgOXuKhA==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="16401381"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="16401381"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 19:27:46 -0700
X-CSE-ConnectionGUID: U4Z1vXzYTO6PdadMS/6+jQ==
X-CSE-MsgGUID: KPgYSKr4TyeyHIP7REqcFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33107201"
Received: from unknown (HELO 0610945e7d16) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 21 May 2024 19:27:43 -0700
Received: from kbuild by 0610945e7d16 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s9bhb-0000xN-2q;
	Wed, 22 May 2024 02:27:40 +0000
Date: Wed, 22 May 2024 10:26:54 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Paul Gazzillo <paul@pgazz.com>,
	Necip Fazil Yildiran <fazilyildiran@gmail.com>,
	oe-kbuild-all@lists.linux.dev, Juergen Gross <jgross@suse.com>,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH v3 2/2] LoongArch: Add steal time support in guest side
Message-ID: <202405221028.QrCEdMNQ-lkp@intel.com>
References: <20240521024556.419436-3-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521024556.419436-3-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 3c999d1ae3c75991902a1a7dad0cb62c2a3008b4]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-steal-time-support-in-kvm-side/20240521-104902
base:   3c999d1ae3c75991902a1a7dad0cb62c2a3008b4
patch link:    https://lore.kernel.org/r/20240521024556.419436-3-maobibo%40loongson.cn
patch subject: [PATCH v3 2/2] LoongArch: Add steal time support in guest side
config: loongarch-kismet-CONFIG_PARAVIRT-CONFIG_PARAVIRT_TIME_ACCOUNTING-0-0 (https://download.01.org/0day-ci/archive/20240522/202405221028.QrCEdMNQ-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20240522/202405221028.QrCEdMNQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405221028.QrCEdMNQ-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for PARAVIRT when selected by PARAVIRT_TIME_ACCOUNTING
   

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

