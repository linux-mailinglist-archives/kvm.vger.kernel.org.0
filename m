Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65816534912
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 04:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbiEZC4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 22:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiEZC4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 22:56:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD348DDED;
        Wed, 25 May 2022 19:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653533809; x=1685069809;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H4VPSZEeKPmBv/O5IDlM/5793JNMWKRyijOqYuPro88=;
  b=RJQD/RTs/TWbV0E8hco9h3kxVqvzunWcsgzUchWJyBesyRD91I7I61lx
   sdGbsqgp9VId/E7ehC3vyTpJXa7CTT2dSTTOicDRGvlpWHTefqgWnziY3
   7ZVr0EmCF8HjA9n4XYSwUDaE4SxEKbsEW8YGfNMOpH10eiDJWiykqykr9
   ws9iWFoR+YCXycDc3uKSqvLGSvJi9CVXt2kWMIqwI38SK7me5QsSwV2G9
   f1BsZXtb1HsqaXMxuYWXInRB5IBvnAnx3YXH6GiVYEM7eHUH1rzPLuACA
   oHsTCTtI18e2KvTWSBxG/L9LkYn0IQyrRLUnwN1RQ8jh9GATVSy6kRjkI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="261622006"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="261622006"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 19:56:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="630672054"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 25 May 2022 19:56:45 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nu3g5-0003XD-8x;
        Thu, 26 May 2022 02:56:45 +0000
Date:   Thu, 26 May 2022 10:55:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] KVM: x86: Omit VCPU_REGS_RIP from emulator's _regs
 array
Message-ID: <202205261040.m1luL6IW-lkp@intel.com>
References: <20220525222604.2810054-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525222604.2810054-4-seanjc@google.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on 90bde5bea810d766e7046bf5884f2ccf76dd78e9]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Christopherson/KVM-x86-Emulator-_regs-fixes-and-cleanups/20220526-062734
base:   90bde5bea810d766e7046bf5884f2ccf76dd78e9
config: i386-debian-10.3-kselftests (https://download.01.org/0day-ci/archive/20220526/202205261040.m1luL6IW-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/a2e1bffa1b7c8179bed0c28ade24b1a73d7220de
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Christopherson/KVM-x86-Emulator-_regs-fixes-and-cleanups/20220526-062734
        git checkout a2e1bffa1b7c8179bed0c28ade24b1a73d7220de
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/x86/kvm/x86.h:9,
                    from arch/x86/kvm/cpuid.h:5,
                    from arch/x86/kvm/mmu.h:7,
                    from arch/x86/kvm/x86.c:22:
>> arch/x86/kvm/kvm_emulate.h:310:34: error: 'VCPU_REGS_R15' undeclared here (not in a function); did you mean 'VCPU_REGS_RIP'?
     310 | #define NR_EMULATOR_GPRS        (VCPU_REGS_R15 + 1)
         |                                  ^~~~~~~~~~~~~
   arch/x86/kvm/kvm_emulate.h:374:29: note: in expansion of macro 'NR_EMULATOR_GPRS'
     374 |         unsigned long _regs[NR_EMULATOR_GPRS];
         |                             ^~~~~~~~~~~~~~~~
--
   In file included from arch/x86/kvm/emulate.c:23:
>> arch/x86/kvm/kvm_emulate.h:310:34: error: 'VCPU_REGS_R15' undeclared here (not in a function); did you mean 'VCPU_REGS_RIP'?
     310 | #define NR_EMULATOR_GPRS        (VCPU_REGS_R15 + 1)
         |                                  ^~~~~~~~~~~~~
   arch/x86/kvm/kvm_emulate.h:374:29: note: in expansion of macro 'NR_EMULATOR_GPRS'
     374 |         unsigned long _regs[NR_EMULATOR_GPRS];
         |                             ^~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c: In function 'reg_write':
   arch/x86/kvm/emulate.c:268:1: error: control reaches end of non-void function [-Werror=return-type]
     268 | }
         | ^
   arch/x86/kvm/emulate.c: In function 'reg_read':
   arch/x86/kvm/emulate.c:258:1: error: control reaches end of non-void function [-Werror=return-type]
     258 | }
         | ^
   cc1: some warnings being treated as errors
--
   In file included from arch/x86/kvm/vmx/../x86.h:9,
                    from arch/x86/kvm/vmx/../cpuid.h:5,
                    from arch/x86/kvm/vmx/evmcs.c:7:
>> arch/x86/kvm/vmx/../kvm_emulate.h:310:34: error: 'VCPU_REGS_R15' undeclared here (not in a function); did you mean 'VCPU_REGS_RIP'?
     310 | #define NR_EMULATOR_GPRS        (VCPU_REGS_R15 + 1)
         |                                  ^~~~~~~~~~~~~
   arch/x86/kvm/vmx/../kvm_emulate.h:374:29: note: in expansion of macro 'NR_EMULATOR_GPRS'
     374 |         unsigned long _regs[NR_EMULATOR_GPRS];
         |                             ^~~~~~~~~~~~~~~~


vim +310 arch/x86/kvm/kvm_emulate.h

   303	
   304	/*
   305	 * The emulator's _regs array tracks only the GPRs, i.e. excludes RIP.  RIP is
   306	 * tracked/accessed via _eip, and except for RIP relative addressing, which
   307	 * also uses _eip, RIP cannot be a register operand nor can it be an operand in
   308	 * a ModRM or SIB byte.
   309	 */
 > 310	#define NR_EMULATOR_GPRS	(VCPU_REGS_R15 + 1)
   311	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
