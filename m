Return-Path: <kvm+bounces-17925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE218CBB0E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE08DB2100D
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E712C78C66;
	Wed, 22 May 2024 06:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DM52PygH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB10C156;
	Wed, 22 May 2024 06:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716358567; cv=none; b=J5ReG5Nn07TcLyihmMUr/xm8ZRDcw3FsbbPbLympXjxLQhhVolLK5LjB4uEDzXW2Nb/UJB4NI3Yl5vsRODENk+Z1+M/rbRcVjZarB1IRxxbqoI/TO6PSVwalfW1hl2GiC7jwRhQy4gVmb2U/zT8stSu+on6fqKpfYzUWvw1BIeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716358567; c=relaxed/simple;
	bh=bAI2wltaiLvKpldNLmwJZda6OtxNcsGjBpSXqrdzk40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQ4dzbqNzimM2ZP2s5qAythBDkC8bKdlA4vhjzyZ/eaepYfb0nb3LGnK0gWICNM2fG2J0RKOadURGj87t9oiDLl1dNqemRvpbFG6UmZ0Oc0S4nHo/V1lNTn2zilMjFmrBNGqxDzKv7L8uxRffzUIDrOXGDe/7EYfK3mWvpQH+L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DM52PygH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716358564; x=1747894564;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bAI2wltaiLvKpldNLmwJZda6OtxNcsGjBpSXqrdzk40=;
  b=DM52PygH/ovZmX4RUphdmwtmNEKnEVi2rKQ7H65hEYxzInWjzG1P7OCT
   yGFfViSxAUtvd57iOomTxihBBtL51asP5hRqEoFUfN2ORFUH/GsPeTJt6
   UDSj50pRi0hq7KGqZl6pT/7i3l0LYouSMD+Dm5RiFzoLkams5L2UPrlSP
   ZSNgGlgSKeag14TSMkGSeLtzCRovj8HSbuyIFvbnqXCBp9h33dNQCIGSE
   OHplC97T5RrezWXa+noS9ut5rIeNsZvKDunWYIgAvWE1w0bpibb3oZVIp
   CX9phi5T5uc2TgEvaRV7Roeq0eoNPf+DKOZaZuY149P3Ha3b2mqLfwzDf
   Q==;
X-CSE-ConnectionGUID: J2jG1mVjSDiTOhJKqob5rg==
X-CSE-MsgGUID: QrmQSAoZS/ykGX0+Efz14w==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12529464"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12529464"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:16:03 -0700
X-CSE-ConnectionGUID: kx/bK4ONSrGeWpdf16IfMg==
X-CSE-MsgGUID: +ABB6sSGRnaJeR7aC5AHIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33291027"
Received: from unknown (HELO 0610945e7d16) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 21 May 2024 23:16:00 -0700
Received: from kbuild by 0610945e7d16 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s9fGY-00016P-0A;
	Wed, 22 May 2024 06:15:58 +0000
Date: Wed, 22 May 2024 14:15:26 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Juergen Gross <jgross@suse.com>,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH v3 1/2] LoongArch: KVM: Add steal time support in kvm side
Message-ID: <202405221317.LCtBJH1F-lkp@intel.com>
References: <20240521024556.419436-2-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521024556.419436-2-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build errors:

[auto build test ERROR on 3c999d1ae3c75991902a1a7dad0cb62c2a3008b4]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-steal-time-support-in-kvm-side/20240521-104902
base:   3c999d1ae3c75991902a1a7dad0cb62c2a3008b4
patch link:    https://lore.kernel.org/r/20240521024556.419436-2-maobibo%40loongson.cn
patch subject: [PATCH v3 1/2] LoongArch: KVM: Add steal time support in kvm side
config: loongarch-randconfig-r051-20240522 (https://download.01.org/0day-ci/archive/20240522/202405221317.LCtBJH1F-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240522/202405221317.LCtBJH1F-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405221317.LCtBJH1F-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/loongarch/kvm/exit.c: In function 'kvm_save_notify':
>> arch/loongarch/kvm/exit.c:711:63: error: 'struct sched_info' has no member named 'run_delay'
     711 |                 vcpu->arch.st.last_steal = current->sched_info.run_delay;
         |                                                               ^
--
   arch/loongarch/kvm/vcpu.c: In function 'kvm_update_stolen_time':
>> arch/loongarch/kvm/vcpu.c:67:37: error: 'struct sched_info' has no member named 'run_delay'
      67 |         steal += current->sched_info.run_delay -
         |                                     ^
   arch/loongarch/kvm/vcpu.c:69:55: error: 'struct sched_info' has no member named 'run_delay'
      69 |         vcpu->arch.st.last_steal = current->sched_info.run_delay;
         |                                                       ^
   arch/loongarch/kvm/vcpu.c: In function 'kvm_loongarch_pvtime_set_attr':
   arch/loongarch/kvm/vcpu.c:138:63: error: 'struct sched_info' has no member named 'run_delay'
     138 |                 vcpu->arch.st.last_steal = current->sched_info.run_delay;
         |                                                               ^


vim +711 arch/loongarch/kvm/exit.c

   692	
   693	static long kvm_save_notify(struct kvm_vcpu *vcpu)
   694	{
   695		unsigned long id, data;
   696	
   697		id   = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
   698		data = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
   699		switch (id) {
   700		case KVM_FEATURE_STEAL_TIME:
   701			if (!kvm_pvtime_supported())
   702				return KVM_HCALL_INVALID_CODE;
   703	
   704			if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
   705				return KVM_HCALL_INVALID_PARAMETER;
   706	
   707			vcpu->arch.st.guest_addr = data;
   708			if (!(data & KVM_STEAL_PHYS_VALID))
   709				break;
   710	
 > 711			vcpu->arch.st.last_steal = current->sched_info.run_delay;
   712			kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
   713			break;
   714		default:
   715			break;
   716		};
   717	
   718		return 0;
   719	};
   720	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

