Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6A4A5D64
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 14:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbiBANZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 08:25:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:49552 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238435AbiBANZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 08:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643721946; x=1675257946;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yKGBWShsl1X257518ca8gg6z6D9kxMNiO15gjp8quVo=;
  b=RgvzTzGjJs8CN02io9R1LTGFlg/9iOUo9azFWe43AyqJVSfiQX9E1Lkw
   iP3NROgqfOQ87MYciUbYWEWvsofyF/p5yUdS+Xvx6IQ2TchKUs854czMe
   TnKKAXB9AbQOon+hDE9IeK2Rk+eezlPmAQeAzxuMw9qekpeq5OP3svHUe
   9wAg+WyMPXPkh/0yh8ka5dEwIcGuwolFnugNs3c6wxa+yjD3Nh/nPgWqm
   0gzc7rwu00I58bbNqvcJGF3l5MxTf7obxZrgjyiV/3Uox6CcpeeiQAd2L
   ftfaF5LSOmF432KMmZ9oAp7mhlC05px024P9isoUeE3kvJY5lacvgivfG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="235081757"
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="235081757"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 05:25:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="626730664"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 01 Feb 2022 05:25:42 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nEtAD-000TJ9-H6; Tue, 01 Feb 2022 13:25:41 +0000
Date:   Tue, 1 Feb 2022 21:25:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH 3/5] KVM: x86: Use __try_cmpxchg_user() to update guest
 PTE A/D bits
Message-ID: <202202012104.eSvVUhWh-lkp@intel.com>
References: <20220201010838.1494405-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201010838.1494405-4-seanjc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on 26291c54e111ff6ba87a164d85d4a4e134b7315c]

url:    https://github.com/0day-ci/linux/commits/Sean-Christopherson/x86-uaccess-CMPXCHG-KVM-bug-fixes/20220201-091001
base:   26291c54e111ff6ba87a164d85d4a4e134b7315c
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220201/202202012104.eSvVUhWh-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/c880d7a9df876f20dc3acdd893c5c71f3cda5029
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sean-Christopherson/x86-uaccess-CMPXCHG-KVM-bug-fixes/20220201-091001
        git checkout c880d7a9df876f20dc3acdd893c5c71f3cda5029
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   arch/x86/kvm/mmu/mmu.c:695:9: sparse: sparse: context imbalance in 'walk_shadow_page_lockless_begin' - different lock contexts for basic block
   arch/x86/kvm/mmu/mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, arch/x86/kvm/irq.h):
   include/linux/rcupdate.h:725:9: sparse: sparse: context imbalance in 'walk_shadow_page_lockless_end' - unexpected unlock
   arch/x86/kvm/mmu/mmu.c:2595:9: sparse: sparse: context imbalance in 'mmu_try_to_unsync_pages' - different lock contexts for basic block
   arch/x86/kvm/mmu/mmu.c: note: in included file:
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/mmu/mmu.c: note: in included file:
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/mmu/mmu.c: note: in included file:
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/paging_tmpl.h:244:23: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/mmu/mmu.c:4549:57: sparse: sparse: cast truncates bits from constant value (ffffff33 becomes 33)
   arch/x86/kvm/mmu/mmu.c:4551:56: sparse: sparse: cast truncates bits from constant value (ffffff0f becomes f)
   arch/x86/kvm/mmu/mmu.c:4553:57: sparse: sparse: cast truncates bits from constant value (ffffff55 becomes 55)

vim +244 arch/x86/kvm/mmu/paging_tmpl.h

   191	
   192	static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
   193						     struct kvm_mmu *mmu,
   194						     struct guest_walker *walker,
   195						     gpa_t addr, int write_fault)
   196	{
   197		unsigned level, index;
   198		pt_element_t pte, orig_pte;
   199		pt_element_t __user *ptep_user;
   200		gfn_t table_gfn;
   201		int ret;
   202	
   203		/* dirty/accessed bits are not supported, so no need to update them */
   204		if (!PT_HAVE_ACCESSED_DIRTY(mmu))
   205			return 0;
   206	
   207		for (level = walker->max_level; level >= walker->level; --level) {
   208			pte = orig_pte = walker->ptes[level - 1];
   209			table_gfn = walker->table_gfn[level - 1];
   210			ptep_user = walker->ptep_user[level - 1];
   211			index = offset_in_page(ptep_user) / sizeof(pt_element_t);
   212			if (!(pte & PT_GUEST_ACCESSED_MASK)) {
   213				trace_kvm_mmu_set_accessed_bit(table_gfn, index, sizeof(pte));
   214				pte |= PT_GUEST_ACCESSED_MASK;
   215			}
   216			if (level == walker->level && write_fault &&
   217					!(pte & PT_GUEST_DIRTY_MASK)) {
   218				trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
   219	#if PTTYPE == PTTYPE_EPT
   220				if (kvm_x86_ops.nested_ops->write_log_dirty(vcpu, addr))
   221					return -EINVAL;
   222	#endif
   223				pte |= PT_GUEST_DIRTY_MASK;
   224			}
   225			if (pte == orig_pte)
   226				continue;
   227	
   228			/*
   229			 * If the slot is read-only, simply do not process the accessed
   230			 * and dirty bits.  This is the correct thing to do if the slot
   231			 * is ROM, and page tables in read-as-ROM/write-as-MMIO slots
   232			 * are only supported if the accessed and dirty bits are already
   233			 * set in the ROM (so that MMIO writes are never needed).
   234			 *
   235			 * Note that NPT does not allow this at all and faults, since
   236			 * it always wants nested page table entries for the guest
   237			 * page tables to be writable.  And EPT works but will simply
   238			 * overwrite the read-only memory to set the accessed and dirty
   239			 * bits.
   240			 */
   241			if (unlikely(!walker->pte_writable[level - 1]))
   242				continue;
   243	
 > 244			ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
   245			if (ret)
   246				return ret;
   247	
   248			kvm_vcpu_mark_page_dirty(vcpu, table_gfn);
   249			walker->ptes[level - 1] = pte;
   250		}
   251		return 0;
   252	}
   253	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
