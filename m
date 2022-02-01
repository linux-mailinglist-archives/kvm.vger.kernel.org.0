Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9484A5927
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 10:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbiBAJZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 04:25:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:65221 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235822AbiBAJZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 04:25:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643707533; x=1675243533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gUWEXzJ4CQlIUlnkVKFBZZcmOw+scAStpajAHmMMh6s=;
  b=axE5odOo1C9ZSq5WsMMgMZaQxHoTdQeJEZITtUT/M86NH8++lJU9LK6L
   PB4U4aO/fyzpJjSSRB57qV9KobLCy3th49945nzHgtKtqZyjn1ht1mULB
   lsswtiaki4QWFzluZB4zKhHw46YMzUnPMPB3BlT+8GU54+014eaYvHc3b
   eBgnJAdK8Y0Avls7FpWlPLg8TjXzJ2k3oTruaUaAe2J2EVF4IJzqhkTPH
   nq8Fo3bm+cses5S5RZ7p/vwdcLSaOVylMdpHkd80OVTWax14E3/bQmpIx
   Y3rM1fykAyFh5PqeBrb2+/crincnH4zZTjMlqQh3Qsse48suXUrq4xSUO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="334007657"
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="334007657"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 01:25:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="537730962"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 01 Feb 2022 01:25:29 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nEpPk-000T3l-JD; Tue, 01 Feb 2022 09:25:28 +0000
Date:   Tue, 1 Feb 2022 17:25:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: Use __try_cmpxchg_user() to emulate atomic
 accesses
Message-ID: <202202011753.zksthphR-lkp@intel.com>
References: <20220201010838.1494405-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201010838.1494405-5-seanjc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on 26291c54e111ff6ba87a164d85d4a4e134b7315c]

url:    https://github.com/0day-ci/linux/commits/Sean-Christopherson/x86-uaccess-CMPXCHG-KVM-bug-fixes/20220201-091001
base:   26291c54e111ff6ba87a164d85d4a4e134b7315c
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220201/202202011753.zksthphR-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 6b1e844b69f15bb7dffaf9365cd2b355d2eb7579)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/5387711f4b49675e162ca30b05a3b2435326e5f9
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sean-Christopherson/x86-uaccess-CMPXCHG-KVM-bug-fixes/20220201-091001
        git checkout 5387711f4b49675e162ca30b05a3b2435326e5f9
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:7213:7: error: invalid output size for constraint '+a'
                   r = emulator_try_cmpxchg_user(u64, hva, old, new);
                       ^
   arch/x86/kvm/x86.c:7159:3: note: expanded from macro 'emulator_try_cmpxchg_user'
           (__try_cmpxchg_user((t *)(ptr), (t *)(old), *(t *)(new), efault ## t))
            ^
   arch/x86/include/asm/uaccess.h:629:11: note: expanded from macro '__try_cmpxchg_user'
           __ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);   \
                    ^
   arch/x86/include/asm/uaccess.h:606:18: note: expanded from macro 'unsafe_try_cmpxchg_user'
           case 1: __ret = __try_cmpxchg_user_asm("b", "q",                \
                           ^
   arch/x86/include/asm/uaccess.h:467:22: note: expanded from macro '__try_cmpxchg_user_asm'
                          [old] "+a" (__old)                               \
                                      ^
>> arch/x86/kvm/x86.c:7213:7: error: invalid output size for constraint '+a'
   arch/x86/kvm/x86.c:7159:3: note: expanded from macro 'emulator_try_cmpxchg_user'
           (__try_cmpxchg_user((t *)(ptr), (t *)(old), *(t *)(new), efault ## t))
            ^
   arch/x86/include/asm/uaccess.h:629:11: note: expanded from macro '__try_cmpxchg_user'
           __ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);   \
                    ^
   arch/x86/include/asm/uaccess.h:610:18: note: expanded from macro 'unsafe_try_cmpxchg_user'
           case 2: __ret = __try_cmpxchg_user_asm("w", "r",                \
                           ^
   arch/x86/include/asm/uaccess.h:467:22: note: expanded from macro '__try_cmpxchg_user_asm'
                          [old] "+a" (__old)                               \
                                      ^
>> arch/x86/kvm/x86.c:7213:7: error: invalid output size for constraint '+a'
   arch/x86/kvm/x86.c:7159:3: note: expanded from macro 'emulator_try_cmpxchg_user'
           (__try_cmpxchg_user((t *)(ptr), (t *)(old), *(t *)(new), efault ## t))
            ^
   arch/x86/include/asm/uaccess.h:629:11: note: expanded from macro '__try_cmpxchg_user'
           __ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);   \
                    ^
   arch/x86/include/asm/uaccess.h:614:18: note: expanded from macro 'unsafe_try_cmpxchg_user'
           case 4: __ret = __try_cmpxchg_user_asm("l", "r",                \
                           ^
   arch/x86/include/asm/uaccess.h:467:22: note: expanded from macro '__try_cmpxchg_user_asm'
                          [old] "+a" (__old)                               \
                                      ^
   3 errors generated.


vim +7213 arch/x86/kvm/x86.c

  7157	
  7158	#define emulator_try_cmpxchg_user(t, ptr, old, new) \
  7159		(__try_cmpxchg_user((t *)(ptr), (t *)(old), *(t *)(new), efault ## t))
  7160	
  7161	static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
  7162					     unsigned long addr,
  7163					     const void *old,
  7164					     const void *new,
  7165					     unsigned int bytes,
  7166					     struct x86_exception *exception)
  7167	{
  7168		struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
  7169		u64 page_line_mask;
  7170		unsigned long hva;
  7171		gpa_t gpa;
  7172		int r;
  7173	
  7174		/* guests cmpxchg8b have to be emulated atomically */
  7175		if (bytes > 8 || (bytes & (bytes - 1)))
  7176			goto emul_write;
  7177	
  7178		gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, NULL);
  7179	
  7180		if (gpa == UNMAPPED_GVA ||
  7181		    (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
  7182			goto emul_write;
  7183	
  7184		/*
  7185		 * Emulate the atomic as a straight write to avoid #AC if SLD is
  7186		 * enabled in the host and the access splits a cache line.
  7187		 */
  7188		if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
  7189			page_line_mask = ~(cache_line_size() - 1);
  7190		else
  7191			page_line_mask = PAGE_MASK;
  7192	
  7193		if (((gpa + bytes - 1) & page_line_mask) != (gpa & page_line_mask))
  7194			goto emul_write;
  7195	
  7196		hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
  7197		if (kvm_is_error_hva(addr))
  7198			goto emul_write;
  7199	
  7200		hva += offset_in_page(gpa);
  7201	
  7202		switch (bytes) {
  7203		case 1:
  7204			r = emulator_try_cmpxchg_user(u8, hva, old, new);
  7205			break;
  7206		case 2:
  7207			r = emulator_try_cmpxchg_user(u16, hva, old, new);
  7208			break;
  7209		case 4:
  7210			r = emulator_try_cmpxchg_user(u32, hva, old, new);
  7211			break;
  7212		case 8:
> 7213			r = emulator_try_cmpxchg_user(u64, hva, old, new);
  7214			break;
  7215		default:
  7216			BUG();
  7217		}
  7218	
  7219		if (r < 0)
  7220			goto emul_write;
  7221		if (r)
  7222			return X86EMUL_CMPXCHG_FAILED;
  7223	
  7224		kvm_page_track_write(vcpu, gpa, new, bytes);
  7225	
  7226		return X86EMUL_CONTINUE;
  7227	
  7228	emul_write:
  7229		printk_once(KERN_WARNING "kvm: emulating exchange as write\n");
  7230	
  7231		return emulator_write_emulated(ctxt, addr, new, bytes, exception);
  7232	}
  7233	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
