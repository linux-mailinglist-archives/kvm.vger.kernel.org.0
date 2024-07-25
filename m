Return-Path: <kvm+bounces-22236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C039093C372
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 15:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F24A12832ED
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 13:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8CE19B5A9;
	Thu, 25 Jul 2024 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5zrpRaM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7082199396;
	Thu, 25 Jul 2024 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721915774; cv=none; b=NRQA75epDGCmz+ut1a9uSAPYlhb9VvK/ohqWy93URmf46w+HIS/BhxY8p0AAzpEpMGZecbnJgP87LBKWR3AJADLn+zlCgjmMaxeT6XsNfyaMJPkJ9qsyjZhtFDrrzvZ/Nif34fh653PXvBpisOO9twGClS0ti4ZawptEgVY2V3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721915774; c=relaxed/simple;
	bh=oYgkU880g28EPPYXxQ9zPy/BMERQjQlBZHT0rb9xjBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGtELTkD5m+Xdyvu+tefgmtODbcgkvDtxZCS0z9D1xxt78cn0025IJ9RV5jZNIXDVvv3+KBEQh4gW8+4smRjK/bIKEsm2E+z/0ZhqQmjhCjkRsv+anjLq4KOhVZjrbkG9SCdVi2OtaHbAav9c/DfJ5ApPNrv9+0lrxY6YPTeQHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5zrpRaM; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721915772; x=1753451772;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oYgkU880g28EPPYXxQ9zPy/BMERQjQlBZHT0rb9xjBM=;
  b=E5zrpRaMph5AauuM+NC39JC1ESd6Z+3luCUDvGSeGBcRZBNG1kQzaGjA
   6l8ITXE8+6eV9A8r7it3aDJTtuMKyZ6xKCruT0uzbK69OO4ol46lrX0tJ
   7MiD5odHps2Z7TdFzHtM+DDg04otf9Hhm6FllzH3W55BhazJL2h3tvW2y
   sxUSo4dQETMjGJFmt6vAVtdxV7aga+/gtQHpYw3gXpADjMki6BtMnyaim
   fLAs2JKp/fEeh2uA1FRW7NpId0Y8pUL3IAcyHzKLuvV8gBSwEfUs0rL5r
   wqUaBUtB0ElGmbXAedvgqOqH+ZTdy9iwoPHh5mXw+p/aFfAQ+0fIU5Zhx
   Q==;
X-CSE-ConnectionGUID: x9yfe01wQh6LXobrdTFf7A==
X-CSE-MsgGUID: rvUG3dNiSWC9ciELd1LCQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="31041473"
X-IronPort-AV: E=Sophos;i="6.09,236,1716274800"; 
   d="scan'208";a="31041473"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 06:56:11 -0700
X-CSE-ConnectionGUID: iBHTsrRHTv2odeFj25zVOA==
X-CSE-MsgGUID: AAtSdriAR4+Fi5C14XiXgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,236,1716274800"; 
   d="scan'208";a="57733142"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 25 Jul 2024 06:56:08 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sWyww-000o9Y-0C;
	Thu, 25 Jul 2024 13:56:06 +0000
Date: Thu, 25 Jul 2024 21:55:08 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH v5 3/3] LoongArch: KVM: Add vm migration support for LBT
 registers
Message-ID: <202407252157.QONm81J6-lkp@intel.com>
References: <20240725033404.2675204-4-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725033404.2675204-4-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build errors:

[auto build test ERROR on c33ffdb70cc6df4105160f991288e7d2567d7ffa]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-HW-Binary-Translation-extension-support/20240725-113707
base:   c33ffdb70cc6df4105160f991288e7d2567d7ffa
patch link:    https://lore.kernel.org/r/20240725033404.2675204-4-maobibo%40loongson.cn
patch subject: [PATCH v5 3/3] LoongArch: KVM: Add vm migration support for LBT registers
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20240725/202407252157.QONm81J6-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240725/202407252157.QONm81J6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407252157.QONm81J6-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/loongarch/kvm/vcpu.c: In function 'kvm_get_one_reg':
>> arch/loongarch/kvm/vcpu.c:606:45: error: assignment to 'long unsigned int' from 'u64 *' {aka 'long long unsigned int *'} makes integer from pointer without a cast [-Wint-conversion]
     606 |                         vcpu->arch.lbt.scr0 = v;
         |                                             ^
   arch/loongarch/kvm/vcpu.c:609:45: error: assignment to 'long unsigned int' from 'u64 *' {aka 'long long unsigned int *'} makes integer from pointer without a cast [-Wint-conversion]
     609 |                         vcpu->arch.lbt.scr1 = v;
         |                                             ^
   arch/loongarch/kvm/vcpu.c:612:45: error: assignment to 'long unsigned int' from 'u64 *' {aka 'long long unsigned int *'} makes integer from pointer without a cast [-Wint-conversion]
     612 |                         vcpu->arch.lbt.scr2 = v;
         |                                             ^
   arch/loongarch/kvm/vcpu.c:615:45: error: assignment to 'long unsigned int' from 'u64 *' {aka 'long long unsigned int *'} makes integer from pointer without a cast [-Wint-conversion]
     615 |                         vcpu->arch.lbt.scr3 = v;
         |                                             ^
   arch/loongarch/kvm/vcpu.c:618:47: error: assignment to 'long unsigned int' from 'u64 *' {aka 'long long unsigned int *'} makes integer from pointer without a cast [-Wint-conversion]
     618 |                         vcpu->arch.lbt.eflags = v;
         |                                               ^
>> arch/loongarch/kvm/vcpu.c:621:45: error: assignment to 'uint32_t' {aka 'unsigned int'} from 'u64 *' {aka 'long long unsigned int *'} makes integer from pointer without a cast [-Wint-conversion]
     621 |                         vcpu->arch.fpu.ftop = v;
         |                                             ^
   arch/loongarch/kvm/vcpu.c: In function 'kvm_set_one_reg':
>> arch/loongarch/kvm/vcpu.c:700:25: error: invalid type argument of unary '*' (have 'u64' {aka 'long long unsigned int'})
     700 |                         *v = vcpu->arch.lbt.scr0;
         |                         ^~
   arch/loongarch/kvm/vcpu.c:703:25: error: invalid type argument of unary '*' (have 'u64' {aka 'long long unsigned int'})
     703 |                         *v = vcpu->arch.lbt.scr1;
         |                         ^~
   arch/loongarch/kvm/vcpu.c:706:25: error: invalid type argument of unary '*' (have 'u64' {aka 'long long unsigned int'})
     706 |                         *v = vcpu->arch.lbt.scr2;
         |                         ^~
   arch/loongarch/kvm/vcpu.c:709:25: error: invalid type argument of unary '*' (have 'u64' {aka 'long long unsigned int'})
     709 |                         *v = vcpu->arch.lbt.scr3;
         |                         ^~
   arch/loongarch/kvm/vcpu.c:712:25: error: invalid type argument of unary '*' (have 'u64' {aka 'long long unsigned int'})
     712 |                         *v = vcpu->arch.lbt.eflags;
         |                         ^~
   arch/loongarch/kvm/vcpu.c:715:25: error: invalid type argument of unary '*' (have 'u64' {aka 'long long unsigned int'})
     715 |                         *v = vcpu->arch.fpu.ftop;
         |                         ^~


vim +606 arch/loongarch/kvm/vcpu.c

   568	
   569	static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
   570			const struct kvm_one_reg *reg, u64 *v)
   571	{
   572		int id, ret = 0;
   573		u64 type = reg->id & KVM_REG_LOONGARCH_MASK;
   574	
   575		switch (type) {
   576		case KVM_REG_LOONGARCH_CSR:
   577			id = KVM_GET_IOC_CSR_IDX(reg->id);
   578			ret = _kvm_getcsr(vcpu, id, v);
   579			break;
   580		case KVM_REG_LOONGARCH_CPUCFG:
   581			id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
   582			if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
   583				*v = vcpu->arch.cpucfg[id];
   584			else
   585				ret = -EINVAL;
   586			break;
   587		case KVM_REG_LOONGARCH_KVM:
   588			switch (reg->id) {
   589			case KVM_REG_LOONGARCH_COUNTER:
   590				*v = drdtime() + vcpu->kvm->arch.time_offset;
   591				break;
   592			case KVM_REG_LOONGARCH_DEBUG_INST:
   593				*v = INSN_HVCL | KVM_HCALL_SWDBG;
   594				break;
   595			default:
   596				ret = -EINVAL;
   597				break;
   598			}
   599			break;
   600		case KVM_REG_LOONGARCH_LBT:
   601			if (!kvm_guest_has_lbt(&vcpu->arch))
   602				return -ENXIO;
   603	
   604			switch (reg->id) {
   605			case KVM_REG_LOONGARCH_LBT_SCR0:
 > 606				vcpu->arch.lbt.scr0 = v;
   607				break;
   608			case KVM_REG_LOONGARCH_LBT_SCR1:
   609				vcpu->arch.lbt.scr1 = v;
   610				break;
   611			case KVM_REG_LOONGARCH_LBT_SCR2:
   612				vcpu->arch.lbt.scr2 = v;
   613				break;
   614			case KVM_REG_LOONGARCH_LBT_SCR3:
   615				vcpu->arch.lbt.scr3 = v;
   616				break;
   617			case KVM_REG_LOONGARCH_LBT_EFLAGS:
   618				vcpu->arch.lbt.eflags = v;
   619				break;
   620			case KVM_REG_LOONGARCH_LBT_FTOP:
 > 621				vcpu->arch.fpu.ftop = v;
   622				break;
   623			default:
   624				ret = -EINVAL;
   625				break;
   626			}
   627			break;
   628		default:
   629			ret = -EINVAL;
   630			break;
   631		}
   632	
   633		return ret;
   634	}
   635	
   636	static int kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
   637	{
   638		int ret = 0;
   639		u64 v, size = reg->id & KVM_REG_SIZE_MASK;
   640	
   641		switch (size) {
   642		case KVM_REG_SIZE_U64:
   643			ret = kvm_get_one_reg(vcpu, reg, &v);
   644			if (ret)
   645				return ret;
   646			ret = put_user(v, (u64 __user *)(long)reg->addr);
   647			break;
   648		default:
   649			ret = -EINVAL;
   650			break;
   651		}
   652	
   653		return ret;
   654	}
   655	
   656	static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
   657				const struct kvm_one_reg *reg, u64 v)
   658	{
   659		int id, ret = 0;
   660		u64 type = reg->id & KVM_REG_LOONGARCH_MASK;
   661	
   662		switch (type) {
   663		case KVM_REG_LOONGARCH_CSR:
   664			id = KVM_GET_IOC_CSR_IDX(reg->id);
   665			ret = _kvm_setcsr(vcpu, id, v);
   666			break;
   667		case KVM_REG_LOONGARCH_CPUCFG:
   668			id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
   669			ret = kvm_check_cpucfg(id, v);
   670			if (ret)
   671				break;
   672			vcpu->arch.cpucfg[id] = (u32)v;
   673			break;
   674		case KVM_REG_LOONGARCH_KVM:
   675			switch (reg->id) {
   676			case KVM_REG_LOONGARCH_COUNTER:
   677				/*
   678				 * gftoffset is relative with board, not vcpu
   679				 * only set for the first time for smp system
   680				 */
   681				if (vcpu->vcpu_id == 0)
   682					vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
   683				break;
   684			case KVM_REG_LOONGARCH_VCPU_RESET:
   685				kvm_reset_timer(vcpu);
   686				memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
   687				memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
   688				break;
   689			default:
   690				ret = -EINVAL;
   691				break;
   692			}
   693			break;
   694		case KVM_REG_LOONGARCH_LBT:
   695			if (!kvm_guest_has_lbt(&vcpu->arch))
   696				return -ENXIO;
   697	
   698			switch (reg->id) {
   699			case KVM_REG_LOONGARCH_LBT_SCR0:
 > 700				*v = vcpu->arch.lbt.scr0;
   701				break;
   702			case KVM_REG_LOONGARCH_LBT_SCR1:
   703				*v = vcpu->arch.lbt.scr1;
   704				break;
   705			case KVM_REG_LOONGARCH_LBT_SCR2:
   706				*v = vcpu->arch.lbt.scr2;
   707				break;
   708			case KVM_REG_LOONGARCH_LBT_SCR3:
   709				*v = vcpu->arch.lbt.scr3;
   710				break;
   711			case KVM_REG_LOONGARCH_LBT_EFLAGS:
   712				*v = vcpu->arch.lbt.eflags;
   713				break;
   714			case KVM_REG_LOONGARCH_LBT_FTOP:
   715				*v = vcpu->arch.fpu.ftop;
   716				break;
   717			default:
   718				ret = -EINVAL;
   719				break;
   720			}
   721			break;
   722		default:
   723			ret = -EINVAL;
   724			break;
   725		}
   726	
   727		return ret;
   728	}
   729	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

