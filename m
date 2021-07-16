Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1C93CB30B
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 09:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhGPHQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 03:16:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:40483 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhGPHQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 03:16:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="274512951"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="274512951"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 00:13:20 -0700
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="506374942"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.1])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 00:13:15 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH 0/5] IPI virtualization support for VM
Date:   Fri, 16 Jul 2021 14:48:02 +0800
Message-Id: <20210716064808.14757-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current IPI process in guest VM will virtualize the writing to interrupt
command register(ICR) of the local APIC which will cause VM-exit anyway
on source vCPU. Frequent VM-exit could induce much overhead accumulated
if running IPI intensive task.

IPI virtualization as a new VT-x feature targets to eliminate VM-exits
when issuing IPI on source vCPU. It introduces a new VM-execution
control - "IPI virtualization"(bit4) in the tertiary processor-based
VM-exection controls and a new data structure - "PID-pointer table
address" and "Last PID-pointer index" referenced by the VMCS. When "IPI
virtualization" is enabled, processor emulateds following kind of writes
to APIC registers that would send IPIs, moreover without causing VM-exits.
- Memory-mapped ICR writes
- MSR-mapped ICR writes
- SENDUIPI execution

This patch series implement IPI virtualization support in KVM.

Patches 1-3 add tertiary processor-based VM-execution support
framework. 

Patch 4 implement interrupt dispatch support in x2APIC mode with
APIC-write VM exit. In previous platform, no CPU would produce
APIC-write VM exit with exit qulification 300H when the "virtual x2APIC
mode" VM-execution control was 1.

Patch 5 implement IPI virtualization related function including
feature enabling through tertiary processor-based VM-execution in
various scenario of VMCS configuration, PID table setup in vCPU creation
and vCPU block consideration.     

Document for IPI virtualization is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

We did experiment to measure average time sending IPI from source vCPU
to the target vCPU completing the IPI handling by kvm unittest w/ and
w/o IPI virtualization. When IPI virtualizatin enabled, it will reduce
22.21% and 15.98% cycles comsuming in xAPIC mode and x2APIC mode
respectly.

KMV unittest:vmexit/ipi, 2 vCPU, AP runs without halt to ensure no VM
exit impact on target vCPU. 
 
		Cycles of IPI 				
		xAPIC mode		x2APIC mode	
	test	w/o IPIv  w/ IPIv	w/o IPIv  w/ IPIv
	1	6106	  4816		4265	  3768
	2	6244	  4656		4404	  3546
	3	6165	  4658		4233	  3474
	4	5992	  4710		4363	  3430
	5	6083	  4741		4215	  3551
	6	6238	  4904		4304	  3547
	7	6164	  4617		4263	  3709
	8	5984	  4763		4518	  3779
	9	5931	  4712		4645	  3667
	10	5955	  4530		4332	  3724
	11	5897	  4673		4283	  3569
	12	6140	  4794		4178	  3598
	13	6183	  4728		4363	  3628
	14	5991	  4994		4509	  3842
	15	5866	  4665		4520	  3739
	16	6032	  4654		4229	  3701
	17	6050	  4653		4185	  3726
	18	6004	  4792		4319	  3746
	19	5961	  4626		4196	  3392
	20	6194	  4576		4433	  3760
					
Average cycles	6059	  4713.1	4337.85	  3644.8
%Reduction		  -22.21%		  -15.98%

Gao Chao (1):
  KVM: VMX: enable IPI virtualization

Robert Hoo (4):
  x86/feat_ctl: Add new VMX feature, Tertiary VM-Execution control
  KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit
    variation
  KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
  KVM: VMX: dump_vmcs() reports tertiary_exec_control field as well

Zeng Guang (1):
  KVM: x86: Support interrupt dispatch in x2APIC mode with APIC-write VM
    exit

 arch/x86/include/asm/msr-index.h   |   1 +
 arch/x86/include/asm/vmx.h         |  11 +++
 arch/x86/include/asm/vmxfeatures.h |   5 +-
 arch/x86/kernel/cpu/feat_ctl.c     |   9 +++
 arch/x86/kvm/lapic.c               |   9 ++-
 arch/x86/kvm/vmx/capabilities.h    |   8 ++
 arch/x86/kvm/vmx/evmcs.c           |   2 +
 arch/x86/kvm/vmx/evmcs.h           |   1 +
 arch/x86/kvm/vmx/posted_intr.c     |  22 ++++--
 arch/x86/kvm/vmx/vmcs.h            |   1 +
 arch/x86/kvm/vmx/vmx.c             | 123 +++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  30 ++++---
 12 files changed, 198 insertions(+), 24 deletions(-)

-- 
2.17.1

