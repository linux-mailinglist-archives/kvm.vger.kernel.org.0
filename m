Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050452C008
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfE1HYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:24:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:57853 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfE1HYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:24:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 00:24:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,521,1549958400"; 
   d="scan'208";a="179114371"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2019 00:24:29 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hVWTE-0003sH-LM; Tue, 28 May 2019 15:24:28 +0800
Date:   Tue, 28 May 2019 15:23:29 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     kbuild-all@01.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH RESEND v2] KVM: X86: Implement PV sched yield hypercall
Message-ID: <201905281519.27MAOvb9%lkp@intel.com>
References: <1559009752-8536-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559009752-8536-1-git-send-email-wanpengli@tencent.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Wanpeng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on v5.2-rc2 next-20190524]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Wanpeng-Li/KVM-X86-Implement-PV-sched-yield-hypercall/20190528-132021
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   arch/x86/kvm/x86.c:2379:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const [noderef] <asn:1> * @@    got  const [noderef] <asn:1> * @@
   arch/x86/kvm/x86.c:2379:38: sparse:    expected void const [noderef] <asn:1> *
   arch/x86/kvm/x86.c:2379:38: sparse:    got unsigned char [usertype] *
   arch/x86/kvm/x86.c:7181:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/x86.c:7181:15: sparse:    struct kvm_apic_map [noderef] <asn:4> *
   arch/x86/kvm/x86.c:7181:15: sparse:    struct kvm_apic_map *
   arch/x86/kvm/x86.c:7243:14: sparse: sparse: undefined identifier 'KVM_HC_SCHED_YIELD'
>> arch/x86/kvm/x86.c:7243:14: sparse: sparse: incompatible types for 'case' statement
   arch/x86/kvm/x86.c:9408:16: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/x86.c:9408:16: sparse:    struct kvm_apic_map [noderef] <asn:4> *
   arch/x86/kvm/x86.c:9408:16: sparse:    struct kvm_apic_map *
>> arch/x86/kvm/x86.c:7193:9: sparse: sparse: context imbalance in 'kvm_sched_yield' - wrong count at exit
   arch/x86/kvm/x86.c:7243:14: sparse: sparse: Expected constant expression in case statement

vim +/case +7243 arch/x86/kvm/x86.c

  7174	
  7175	void kvm_sched_yield(struct kvm *kvm, u64 dest_id)
  7176	{
  7177		struct kvm_vcpu *target;
  7178		struct kvm_apic_map *map;
  7179	
  7180		rcu_read_lock();
  7181		map = rcu_dereference(kvm->arch.apic_map);
  7182	
  7183		if (unlikely(!map))
  7184			goto out;
  7185	
  7186		if (map->phys_map[dest_id]->vcpu) {
  7187			target = map->phys_map[dest_id]->vcpu;
  7188			rcu_read_unlock();
  7189			kvm_vcpu_yield_to(target);
  7190		}
  7191	
  7192	out:
> 7193		if (!target)
  7194			rcu_read_unlock();
  7195	}
  7196	
  7197	int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
  7198	{
  7199		unsigned long nr, a0, a1, a2, a3, ret;
  7200		int op_64_bit;
  7201	
  7202		if (kvm_hv_hypercall_enabled(vcpu->kvm))
  7203			return kvm_hv_hypercall(vcpu);
  7204	
  7205		nr = kvm_rax_read(vcpu);
  7206		a0 = kvm_rbx_read(vcpu);
  7207		a1 = kvm_rcx_read(vcpu);
  7208		a2 = kvm_rdx_read(vcpu);
  7209		a3 = kvm_rsi_read(vcpu);
  7210	
  7211		trace_kvm_hypercall(nr, a0, a1, a2, a3);
  7212	
  7213		op_64_bit = is_64_bit_mode(vcpu);
  7214		if (!op_64_bit) {
  7215			nr &= 0xFFFFFFFF;
  7216			a0 &= 0xFFFFFFFF;
  7217			a1 &= 0xFFFFFFFF;
  7218			a2 &= 0xFFFFFFFF;
  7219			a3 &= 0xFFFFFFFF;
  7220		}
  7221	
  7222		if (kvm_x86_ops->get_cpl(vcpu) != 0) {
  7223			ret = -KVM_EPERM;
  7224			goto out;
  7225		}
  7226	
  7227		switch (nr) {
  7228		case KVM_HC_VAPIC_POLL_IRQ:
  7229			ret = 0;
  7230			break;
  7231		case KVM_HC_KICK_CPU:
  7232			kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
  7233			ret = 0;
  7234			break;
  7235	#ifdef CONFIG_X86_64
  7236		case KVM_HC_CLOCK_PAIRING:
  7237			ret = kvm_pv_clock_pairing(vcpu, a0, a1);
  7238			break;
  7239	#endif
  7240		case KVM_HC_SEND_IPI:
  7241			ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
  7242			break;
> 7243		case KVM_HC_SCHED_YIELD:
  7244			kvm_sched_yield(vcpu->kvm, a0);
  7245			ret = 0;
  7246			break;
  7247		default:
  7248			ret = -KVM_ENOSYS;
  7249			break;
  7250		}
  7251	out:
  7252		if (!op_64_bit)
  7253			ret = (u32)ret;
  7254		kvm_rax_write(vcpu, ret);
  7255	
  7256		++vcpu->stat.hypercalls;
  7257		return kvm_skip_emulated_instruction(vcpu);
  7258	}
  7259	EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
  7260	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
