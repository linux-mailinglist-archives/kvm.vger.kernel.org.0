Return-Path: <kvm+bounces-42452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C74B2A78796
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 07:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3B263B0E97
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AA1230BF5;
	Wed,  2 Apr 2025 05:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="itALuBC7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9A20C46D
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 05:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743571635; cv=none; b=LX4bNn8JG0CC5Zg0Jafc9IBekFIKqqugf/vW6D3CPbpiPQDwVHlIeiVDv0VpSY/OyfAwZ1j9Ags1T3rFUuNrhxggCfnqRZT20QK97gd/g4WjYbtvG+c1pRPtZE2G4CgH8EZmbHnjBLvVaXJnycuGyCiw31nee/UfDViKeUHCRWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743571635; c=relaxed/simple;
	bh=1sF68SZxLqUaeGEEZqKvOxgO+19Pom0IW9NQxYY2fJA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=k+4Gq0mdOd5kwmmhRTptyOtEq+fAlSmqpZu6bUL+t4SKeIxAuJHkhHRPQp5FlM316Kcxgsa1dB7+dmyRBMTvwkL80cQ90uL1CKgHqMDp3ftg5MU14klavxDg3aL4IslqsX4aXHJ/arMCKDzizDzW5o3kvwC4P9UTnbSos0ExN9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=itALuBC7; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743571632; x=1775107632;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1sF68SZxLqUaeGEEZqKvOxgO+19Pom0IW9NQxYY2fJA=;
  b=itALuBC74BR4xUMfiCL1dBjIiUqNdGys1tdaTkwwxrr2ncy3FKbyM/ko
   7GLzs/ad3GUn+fD/lgoSZNv0XpQb91uP/OiqDgsZC53e4/BC+njYoXHe1
   x/fzfx0R5boyYI6nQtHytFg/OUl+wbrQY9bXxurS7iu3ZrUKwvHrOwkuL
   kEmhbWMXLJY9n0U1kXEcATfL5mGxXk43x43Tz9/iMht80D9YVAg3pvjY9
   dilyUr8Kk07CR6QQl6NjJhktRdP9Ykj2zmrWWTTivDhyj6wTkIPpsxScY
   vlMLC6j7H773kCVhmiN3ePBgENCAevFxu5ybzeH0pwboejvgbedHRoemU
   g==;
X-CSE-ConnectionGUID: PLL72gBdQYWPkX8HdRXMnw==
X-CSE-MsgGUID: ba6lrYxTSFiwvlLkI9sdyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="55911435"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="55911435"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 22:27:11 -0700
X-CSE-ConnectionGUID: MSduumEET1Wh0yJ9azRckA==
X-CSE-MsgGUID: eBbekMp6TZ28VV82bdJ7aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="149769091"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 01 Apr 2025 22:27:10 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tzqce-000AUo-2o;
	Wed, 02 Apr 2025 05:26:58 +0000
Date: Wed, 2 Apr 2025 13:25:57 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>
Subject: [kvm:planes-20250401 40/62] arch/arm64/kvm/vgic/vgic-init.c:470:5:
 warning: suggest explicit braces to avoid ambiguous 'else'
Message-ID: <202504021310.0o5EZlcD-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git planes-20250401
head:   73685d9c23b7122b44f07d59244416f8b56ed48e
commit: ce9e60bf5379a9d8696fb730b1e72a629171c8ba [40/62] KVM: do not use online_vcpus to test vCPU validity
config: arm64-randconfig-003-20250402 (https://download.01.org/0day-ci/archive/20250402/202504021310.0o5EZlcD-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250402/202504021310.0o5EZlcD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504021310.0o5EZlcD-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/arm64/kvm/vgic/vgic-init.c: In function 'kvm_vgic_destroy':
>> arch/arm64/kvm/vgic/vgic-init.c:470:5: warning: suggest explicit braces to avoid ambiguous 'else' [-Wdangling-else]
     470 |  if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
         |     ^


vim +/else +470 arch/arm64/kvm/vgic/vgic-init.c

d26b9cb33c2d1b arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2023-12-07  452  
01ad29d224ff73 arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2023-12-07  453  void kvm_vgic_destroy(struct kvm *kvm)
ad275b8bb1e659 virt/kvm/arm/vgic/vgic-init.c   Eric Auger       2015-12-21  454  {
ad275b8bb1e659 virt/kvm/arm/vgic/vgic-init.c   Eric Auger       2015-12-21  455  	struct kvm_vcpu *vcpu;
46808a4cb89708 arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2021-11-16  456  	unsigned long i;
ad275b8bb1e659 virt/kvm/arm/vgic/vgic-init.c   Eric Auger       2015-12-21  457  
01ad29d224ff73 arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2023-12-07  458  	mutex_lock(&kvm->slots_lock);
9eb18136af9fe4 arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2024-08-08  459  	mutex_lock(&kvm->arch.config_lock);
f00327731131d1 arch/arm64/kvm/vgic/vgic-init.c Oliver Upton     2023-03-27  460  
10f92c4c537794 virt/kvm/arm/vgic/vgic-init.c   Christoffer Dall 2017-01-17  461  	vgic_debug_destroy(kvm);
10f92c4c537794 virt/kvm/arm/vgic/vgic-init.c   Christoffer Dall 2017-01-17  462  
ad275b8bb1e659 virt/kvm/arm/vgic/vgic-init.c   Eric Auger       2015-12-21  463  	kvm_for_each_vcpu(i, vcpu, kvm)
d26b9cb33c2d1b arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2023-12-07  464  		__kvm_vgic_vcpu_destroy(vcpu);
969ce8b5260d8e virt/kvm/arm/vgic/vgic-init.c   Zenghui Yu       2020-04-14  465  
969ce8b5260d8e virt/kvm/arm/vgic/vgic-init.c   Zenghui Yu       2020-04-14  466  	kvm_vgic_dist_destroy(kvm);
ad275b8bb1e659 virt/kvm/arm/vgic/vgic-init.c   Eric Auger       2015-12-21  467  
f00327731131d1 arch/arm64/kvm/vgic/vgic-init.c Oliver Upton     2023-03-27  468  	mutex_unlock(&kvm->arch.config_lock);
f616506754d34b arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2024-08-19  469  
f616506754d34b arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2024-08-19 @470  	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
f616506754d34b arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2024-08-19  471  		kvm_for_each_vcpu(i, vcpu, kvm)
f616506754d34b arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2024-08-19  472  			vgic_unregister_redist_iodev(vcpu);
f616506754d34b arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2024-08-19  473  
01ad29d224ff73 arch/arm64/kvm/vgic/vgic-init.c Marc Zyngier     2023-12-07  474  	mutex_unlock(&kvm->slots_lock);
1193e6aeecb36c virt/kvm/arm/vgic/vgic-init.c   Marc Zyngier     2017-01-12  475  }
1193e6aeecb36c virt/kvm/arm/vgic/vgic-init.c   Marc Zyngier     2017-01-12  476  

:::::: The code at line 470 was first introduced by commit
:::::: f616506754d34bcfdbfbc7508b562e5c98461e9a KVM: arm64: vgic: Don't hold config_lock while unregistering redistributors

:::::: TO: Marc Zyngier <maz@kernel.org>
:::::: CC: Oliver Upton <oliver.upton@linux.dev>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

