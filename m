Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741D9149574
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 13:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAYMPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 07:15:20 -0500
Received: from mga12.intel.com ([192.55.52.136]:31406 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbgAYMPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jan 2020 07:15:20 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 04:15:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,361,1574150400"; 
   d="gz'50?scan'50,208,50";a="222849864"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 25 Jan 2020 04:15:17 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ivKLN-0008GQ-46; Sat, 25 Jan 2020 20:15:17 +0800
Date:   Sat, 25 Jan 2020 20:14:30 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm:queue 100/190] arch/s390/kvm/kvm-s390.c:3031:32: error: 'id'
 undeclared; did you mean 'ida'?
Message-ID: <202001252020.ZO704BHr%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bqtvlxkq5olq24yx"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bqtvlxkq5olq24yx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   e81c4f4b2dcf427c4fffe0f5772f06f1ef9d15aa
commit: fc2f83337b7996e4a34c0eed3fbadddf2b67b9f5 [100/190] KVM: Move vcpu alloc and init invocation to common code
config: s390-alldefconfig (attached as .config)
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
>> arch/s390/kvm/kvm-s390.c:3031:32: error: 'id' undeclared (first use in this function); did you mean 'ida'?
     vcpu->arch.sie_block->icpua = id;
                                   ^~
                                   ida
   arch/s390/kvm/kvm-s390.c:3031:32: note: each undeclared identifier is reported only once for each function it appears in
>> arch/s390/kvm/kvm-s390.c:3033:39: error: 'kvm' undeclared (first use in this function)
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
982cff42595990 Michael Mueller       2019-01-31 @3033  	vcpu->arch.sie_block->gd = (u32)(u64)kvm->arch.gisa_int.origin;
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

--bqtvlxkq5olq24yx
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--bqtvlxkq5olq24yx--
