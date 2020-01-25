Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864EA1495E6
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 14:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgAYNZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 08:25:22 -0500
Received: from mga06.intel.com ([134.134.136.31]:47413 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgAYNZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jan 2020 08:25:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 05:24:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,361,1574150400"; 
   d="gz'50?scan'50,208,50";a="400917624"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 25 Jan 2020 05:24:51 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ivLQh-0004Jn-5r; Sat, 25 Jan 2020 21:24:51 +0800
Date:   Sat, 25 Jan 2020 21:24:43 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm:queue 100/190] arch/s390/kvm/kvm-s390.c:3031:32: error: 'id'
 undeclared; did you mean 'fd'?
Message-ID: <202001252143.RK169mFJ%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6f3flkabp6phzgte"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6f3flkabp6phzgte
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   e81c4f4b2dcf427c4fffe0f5772f06f1ef9d15aa
commit: fc2f83337b7996e4a34c0eed3fbadddf2b67b9f5 [100/190] KVM: Move vcpu alloc and init invocation to common code
config: s390-debug_defconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout fc2f83337b7996e4a34c0eed3fbadddf2b67b9f5
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/s390/kvm/kvm-s390.c: In function 'kvm_arch_vcpu_create':
>> arch/s390/kvm/kvm-s390.c:3031:32: error: 'id' undeclared (first use in this function); did you mean 'fd'?
     vcpu->arch.sie_block->icpua = id;
                                   ^~
                                   fd
   arch/s390/kvm/kvm-s390.c:3031:32: note: each undeclared identifier is reported only once for each function it appears in
   arch/s390/kvm/kvm-s390.c:3033:39: error: 'kvm' undeclared (first use in this function)
     vcpu->arch.sie_block->gd = (u32)(u64)kvm->arch.gisa_int.origin;
                                          ^~~

vim +3031 arch/s390/kvm/kvm-s390.c

897cc38eaab96d Sean Christopherson   2019-12-18  3013  
fc2f83337b7996 Sean Christopherson   2019-12-18  3014  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
b0c632db637d68 Heiko Carstens        2008-03-25  3015  {
7feb6bb8e6dbd1 Michael Mueller       2013-06-28  3016  	struct sie_page *sie_page;
897cc38eaab96d Sean Christopherson   2019-12-18  3017  	int rc;
4d47555a804956 Carsten Otte          2011-10-18  3018  
da72ca4d4090a8 QingFeng Hao          2017-06-07  3019  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
7feb6bb8e6dbd1 Michael Mueller       2013-06-28  3020  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
7feb6bb8e6dbd1 Michael Mueller       2013-06-28  3021  	if (!sie_page)
fc2f83337b7996 Sean Christopherson   2019-12-18  3022  		return -ENOMEM;
b0c632db637d68 Heiko Carstens        2008-03-25  3023  
7feb6bb8e6dbd1 Michael Mueller       2013-06-28  3024  	vcpu->arch.sie_block = &sie_page->sie_block;
7feb6bb8e6dbd1 Michael Mueller       2013-06-28  3025  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
7feb6bb8e6dbd1 Michael Mueller       2013-06-28  3026  
efed110446226c David Hildenbrand     2015-04-16  3027  	/* the real guest size will always be smaller than msl */
efed110446226c David Hildenbrand     2015-04-16  3028  	vcpu->arch.sie_block->mso = 0;
efed110446226c David Hildenbrand     2015-04-16  3029  	vcpu->arch.sie_block->msl = sclp.hamax;
efed110446226c David Hildenbrand     2015-04-16  3030  
b0c632db637d68 Heiko Carstens        2008-03-25 @3031  	vcpu->arch.sie_block->icpua = id;
ba5c1e9b6ceebd Carsten Otte          2008-03-25  3032  	spin_lock_init(&vcpu->arch.local_int.lock);
982cff42595990 Michael Mueller       2019-01-31  3033  	vcpu->arch.sie_block->gd = (u32)(u64)kvm->arch.gisa_int.origin;
4b9f952577fb40 Michael Mueller       2017-06-23  3034  	if (vcpu->arch.sie_block->gd && sclp.has_gisaf)
4b9f952577fb40 Michael Mueller       2017-06-23  3035  		vcpu->arch.sie_block->gd |= GISA_FORMAT1;
9c23a1318eb12f David Hildenbrand     2016-02-17  3036  	seqcount_init(&vcpu->arch.cputm_seqcount);
ba5c1e9b6ceebd Carsten Otte          2008-03-25  3037  
321f8ee559d697 Sean Christopherson   2019-12-18  3038  	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
321f8ee559d697 Sean Christopherson   2019-12-18  3039  	kvm_clear_async_pf_completion_queue(vcpu);
321f8ee559d697 Sean Christopherson   2019-12-18  3040  	vcpu->run->kvm_valid_regs = KVM_SYNC_PREFIX |
321f8ee559d697 Sean Christopherson   2019-12-18  3041  				    KVM_SYNC_GPRS |
321f8ee559d697 Sean Christopherson   2019-12-18  3042  				    KVM_SYNC_ACRS |
321f8ee559d697 Sean Christopherson   2019-12-18  3043  				    KVM_SYNC_CRS |
321f8ee559d697 Sean Christopherson   2019-12-18  3044  				    KVM_SYNC_ARCH0 |
321f8ee559d697 Sean Christopherson   2019-12-18  3045  				    KVM_SYNC_PFAULT;
321f8ee559d697 Sean Christopherson   2019-12-18  3046  	kvm_s390_set_prefix(vcpu, 0);
321f8ee559d697 Sean Christopherson   2019-12-18  3047  	if (test_kvm_facility(vcpu->kvm, 64))
321f8ee559d697 Sean Christopherson   2019-12-18  3048  		vcpu->run->kvm_valid_regs |= KVM_SYNC_RICCB;
321f8ee559d697 Sean Christopherson   2019-12-18  3049  	if (test_kvm_facility(vcpu->kvm, 82))
321f8ee559d697 Sean Christopherson   2019-12-18  3050  		vcpu->run->kvm_valid_regs |= KVM_SYNC_BPBC;
321f8ee559d697 Sean Christopherson   2019-12-18  3051  	if (test_kvm_facility(vcpu->kvm, 133))
321f8ee559d697 Sean Christopherson   2019-12-18  3052  		vcpu->run->kvm_valid_regs |= KVM_SYNC_GSCB;
321f8ee559d697 Sean Christopherson   2019-12-18  3053  	if (test_kvm_facility(vcpu->kvm, 156))
321f8ee559d697 Sean Christopherson   2019-12-18  3054  		vcpu->run->kvm_valid_regs |= KVM_SYNC_ETOKEN;
321f8ee559d697 Sean Christopherson   2019-12-18  3055  	/* fprs can be synchronized via vrs, even if the guest has no vx. With
321f8ee559d697 Sean Christopherson   2019-12-18  3056  	 * MACHINE_HAS_VX, (load|store)_fpu_regs() will work with vrs format.
321f8ee559d697 Sean Christopherson   2019-12-18  3057  	 */
321f8ee559d697 Sean Christopherson   2019-12-18  3058  	if (MACHINE_HAS_VX)
321f8ee559d697 Sean Christopherson   2019-12-18  3059  		vcpu->run->kvm_valid_regs |= KVM_SYNC_VRS;
321f8ee559d697 Sean Christopherson   2019-12-18  3060  	else
321f8ee559d697 Sean Christopherson   2019-12-18  3061  		vcpu->run->kvm_valid_regs |= KVM_SYNC_FPRS;
321f8ee559d697 Sean Christopherson   2019-12-18  3062  
321f8ee559d697 Sean Christopherson   2019-12-18  3063  	if (kvm_is_ucontrol(vcpu->kvm)) {
321f8ee559d697 Sean Christopherson   2019-12-18  3064  		rc = __kvm_ucontrol_vcpu_init(vcpu);
321f8ee559d697 Sean Christopherson   2019-12-18  3065  		if (rc)
a2017f17fa175b Sean Christopherson   2019-12-18  3066  			goto out_free_sie_block;
321f8ee559d697 Sean Christopherson   2019-12-18  3067  	}
321f8ee559d697 Sean Christopherson   2019-12-18  3068  
8335713ad08caf Christian Borntraeger 2015-12-08  3069  	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
b0c632db637d68 Heiko Carstens        2008-03-25  3070  		 vcpu->arch.sie_block);
ade38c311a0ad8 Cornelia Huck         2012-07-23  3071  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
b0c632db637d68 Heiko Carstens        2008-03-25  3072  
fc2f83337b7996 Sean Christopherson   2019-12-18  3073  	return 0;
fc2f83337b7996 Sean Christopherson   2019-12-18  3074  
7b06bf2ffa15e1 Wei Yongjun           2010-03-09  3075  out_free_sie_block:
7b06bf2ffa15e1 Wei Yongjun           2010-03-09  3076  	free_page((unsigned long)(vcpu->arch.sie_block));
fc2f83337b7996 Sean Christopherson   2019-12-18  3077  	return rc;
b0c632db637d68 Heiko Carstens        2008-03-25  3078  }
b0c632db637d68 Heiko Carstens        2008-03-25  3079  

:::::: The code at line 3031 was first introduced by commit
:::::: b0c632db637d68ad39d9f97f452ce176253f5f4e KVM: s390: arch backend for the kvm kernel module

:::::: TO: Heiko Carstens <heiko.carstens@de.ibm.com>
:::::: CC: Avi Kivity <avi@qumranet.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--6f3flkabp6phzgte
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
5j0yAQA=

--6f3flkabp6phzgte--
