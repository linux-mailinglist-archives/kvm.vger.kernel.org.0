Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4135C1FA823
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 07:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgFPFWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 01:22:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:32103 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgFPFWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 01:22:32 -0400
IronPort-SDR: SzG/bMS3Sne1lNE2uhEqqMMPB1ui6q8JT0dhYyWsQByxAfjE8fkTW8cqGUOLXAWMFOv1tVQlGc
 RmosoHO5/fyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 22:22:31 -0700
IronPort-SDR: butAZOv0zFAFZgppKHYoCFHLQnFeIKas1AdMjVWvR7PRx3NBb+8f1ewJZNBc9LEsjo6xc+yDIA
 g48RpFrKvD1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,517,1583222400"; 
   d="scan'208";a="317115995"
Received: from lkp-server02.sh.intel.com (HELO ec7aa6149bd9) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jun 2020 22:22:29 -0700
Received: from kbuild by ec7aa6149bd9 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jl43I-0000TL-J6; Tue, 16 Jun 2020 05:22:28 +0000
Date:   Tue, 16 Jun 2020 13:21:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-async-pf-int-5.8 3/6] arch/x86/kernel/kvm.c:330:6: warning:
 Variable 'pa' is reassigned a value before the old one has been used.
Message-ID: <202006161327.d4RqWvaG%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-async-pf-int-5.8
head:   62a9576cc07b7dcba951aaa00d6a55933c49367e
commit: b1d405751cd5792856b1b8333aafaca6bf09ccbb [3/6] KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery
compiler: gcc-9 (Debian 9.3.0-13) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cppcheck warnings: (new ones prefixed by >>)

>> arch/x86/kernel/kvm.c:330:6: warning: Variable 'pa' is reassigned a value before the old one has been used. [redundantAssignment]
     pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
        ^
   arch/x86/kernel/kvm.c:326:0: note: Variable 'pa' is reassigned a value before the old one has been used.
     u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
   ^
   arch/x86/kernel/kvm.c:330:6: note: Variable 'pa' is reassigned a value before the old one has been used.
     pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
        ^

vim +/pa +330 arch/x86/kernel/kvm.c

ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  322  
ed3cf15271fa15 Nicholas Krause    2015-05-20  323  static void kvm_guest_cpu_init(void)
fd10cde9294f73 Gleb Natapov       2010-10-14  324  {
b1d405751cd579 Vitaly Kuznetsov   2020-05-25  325  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
b1d405751cd579 Vitaly Kuznetsov   2020-05-25  326  		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
ef68017eb5704e Andy Lutomirski    2020-02-28  327  
ef68017eb5704e Andy Lutomirski    2020-02-28  328  		WARN_ON_ONCE(!static_branch_likely(&kvm_async_pf_enabled));
ef68017eb5704e Andy Lutomirski    2020-02-28  329  
ef68017eb5704e Andy Lutomirski    2020-02-28 @330  		pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
b1d405751cd579 Vitaly Kuznetsov   2020-05-25  331  		pa |= KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
52a5c155cf79f1 Wanpeng Li         2017-07-13  332  
fe2a3027e74e40 Radim Krčmář       2018-02-01  333  		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
fe2a3027e74e40 Radim Krčmář       2018-02-01  334  			pa |= KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
fe2a3027e74e40 Radim Krčmář       2018-02-01  335  
b1d405751cd579 Vitaly Kuznetsov   2020-05-25  336  		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
b1d405751cd579 Vitaly Kuznetsov   2020-05-25  337  
52a5c155cf79f1 Wanpeng Li         2017-07-13  338  		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
89cbc76768c2fa Christoph Lameter  2014-08-17  339  		__this_cpu_write(apf_reason.enabled, 1);
6bca69ada4bc20 Thomas Gleixner    2020-03-07  340  		pr_info("KVM setup async PF for cpu %d\n", smp_processor_id());
fd10cde9294f73 Gleb Natapov       2010-10-14  341  	}
d910f5c1064d7f Glauber Costa      2011-07-11  342  
ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  343  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  344  		unsigned long pa;
6bca69ada4bc20 Thomas Gleixner    2020-03-07  345  
ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  346  		/* Size alignment is implied but just to make it explicit. */
ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  347  		BUILD_BUG_ON(__alignof__(kvm_apic_eoi) < 4);
89cbc76768c2fa Christoph Lameter  2014-08-17  348  		__this_cpu_write(kvm_apic_eoi, 0);
89cbc76768c2fa Christoph Lameter  2014-08-17  349  		pa = slow_virt_to_phys(this_cpu_ptr(&kvm_apic_eoi))
5dfd486c4750c9 Dave Hansen        2013-01-22  350  			| KVM_MSR_ENABLED;
ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  351  		wrmsrl(MSR_KVM_PV_EOI_EN, pa);
ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  352  	}
ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  353  
d910f5c1064d7f Glauber Costa      2011-07-11  354  	if (has_steal_clock)
d910f5c1064d7f Glauber Costa      2011-07-11  355  		kvm_register_steal_time();
fd10cde9294f73 Gleb Natapov       2010-10-14  356  }
fd10cde9294f73 Gleb Natapov       2010-10-14  357  

:::::: The code at line 330 was first introduced by commit
:::::: ef68017eb5704eb2b0577c3aa6619e13caf2b59f x86/kvm: Handle async page faults directly through do_page_fault()

:::::: TO: Andy Lutomirski <luto@kernel.org>
:::::: CC: Thomas Gleixner <tglx@linutronix.de>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
