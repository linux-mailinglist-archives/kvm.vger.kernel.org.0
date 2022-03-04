Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BB4CD03A
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 09:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbiCDIkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 03:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiCDIjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 03:39:49 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A619B19E09F;
        Fri,  4 Mar 2022 00:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646383106; x=1677919106;
  h=from:to:cc:subject:date:message-id;
  bh=OU/QJMxeH6hU5Fy/ptPoRcEsojqtbzEPaMTWKGbVk5U=;
  b=he2ytrBYhWqcaHWuE2nfpeEKljc8oho34kE2j5UA7WqWuLpiKaMI9kCp
   JzKoDsGkr6ylv+Gezp15v4HdlRkj92Ed/x6cr2cXIpdCpXJvanBL4mrrm
   +iylhn9I67hPVDT7Qgt9R8yIlvznhPXUNARhb5Cu30bOoD1lGyX5ZKJDt
   UqUU/9wv2YxUQkO21jpPNFUPTzYuSC+o1xnLyaCM+kO7qlR8ARiNRxKO0
   GZtPpFTOqb+nn7fISnxz4DBk/IfhWFOfab6YPx1VcSXoIe/tYl10Bk/hf
   WWl/Z+Cav9w3mELwhclQ0HjfwHFqfDcv3UzCq5OTgL/w8nknCA4XAr7uM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="252755880"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="252755880"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:06 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="552141392"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:00 -0800
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
Subject: [PATCH v7 0/8] IPI virtualization support for VM
Date:   Fri,  4 Mar 2022 16:07:17 +0800
Message-Id: <20220304080725.18135-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, issuing an IPI except self-ipi in guest on Intel CPU
always causes a VM-exit. It can lead to non-negligible overhead
to some workloads involving frequent IPIs when running in VMs.

IPI virtualization is a new VT-x feature, targeting to eliminate
VM-exits on source vCPUs when issuing unicast, physical-addressing
IPIs. Once it is enabled, the processor virtualizes following kinds
of operations that send IPIs without causing VM-exits:
- Memory-mapped ICR writes
- MSR-mapped ICR writes
- SENDUIPI execution

This patch series implements IPI virtualization support in KVM.

Patches 1-4 add tertiary processor-based VM-execution support
framework, which is used to enumerate IPI virtualization.

Patch 5 handles APIC-write VM exit due to writes to ICR MSR when
guest works in x2APIC mode. This is a new case introduced by
Intel VT-x.

Patch 6 disallow the APIC ID change unconditionally.

Patch 7 provide userspace capability to set maximum possible VCPU
ID for current VM. IPIv can refer to this value to allocate memory
for PID-pointer table. 

Patch 8 implements IPI virtualization related function including
feature enabling through tertiary processor-based VM-execution in
various scenarios of VMCS configuration, PID table setup in vCPU
creation and vCPU block consideration.

Document for IPI virtualization is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

We did experiment to measure average time sending IPI from source vCPU
to the target vCPU completing the IPI handling by kvm unittest w/ and
w/o IPI virtualization. When IPI virtualization enabled, it will reduce
22.21% and 15.98% cycles consuming in xAPIC mode and x2APIC mode
respectively.

--------------------------------------
KVM unittest:vmexit/ipi

2 vCPU, AP was modified to run in idle loop instead of halt to ensure
no VM exit impact on target vCPU.

                Cycles of IPI
                xAPIC mode              x2APIC mode
        test    w/o IPIv  w/ IPIv       w/o IPIv  w/ IPIv
        1       6106      4816          4265      3768
        2       6244      4656          4404      3546
        3       6165      4658          4233      3474
        4       5992      4710          4363      3430
        5       6083      4741          4215      3551
        6       6238      4904          4304      3547
        7       6164      4617          4263      3709
        8       5984      4763          4518      3779
        9       5931      4712          4645      3667
        10      5955      4530          4332      3724
        11      5897      4673          4283      3569
        12      6140      4794          4178      3598
        13      6183      4728          4363      3628
        14      5991      4994          4509      3842
        15      5866      4665          4520      3739
        16      6032      4654          4229      3701
        17      6050      4653          4185      3726
        18      6004      4792          4319      3746
        19      5961      4626          4196      3392
        20      6194      4576          4433      3760

Average cycles  6059      4713.1        4337.85   3644.8
%Reduction                -22.21%                 -15.98%

--------------------------------------
IPI microbenchmark:
(https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com)

2 vCPUs, 1:1 pin vCPU to pCPU, guest VM runs with idle=poll, x2APIC mode

Result with IPIv enabled:

Dry-run:                         0,             272798 ns
Self-IPI:                  5094123,           11114037 ns
Normal IPI:              131697087,          173321200 ns
Broadcast IPI:                   0,          155649075 ns
Broadcast lock:                  0,          161518031 ns

Result with IPIv disabled:

Dry-run:                         0,             272766 ns
Self-IPI:                  5091788,           11123699 ns
Normal IPI:              145215772,          174558920 ns
Broadcast IPI:                   0,          175785384 ns
Broadcast lock:                  0,          149076195 ns


As IPIv can benefit unicast IPI to other CPU, Normal IPI test case gain
about 9.73% time saving on average out of 15 test runs when IPIv is
enabled.

Normal IPI statistics (unit:ns):
        test    w/o IPIv        w/ IPIv
        1       153346049       140907046
        2       147218648       141660618
        3       145215772       117890672
        4       146621682       136430470
        5       144821472       136199421
        6       144704378       131676928
        7       141403224       131697087
        8       144775766       125476250
        9       140658192       137263330
        10      144768626       138593127
        11      145166679       131946752
        12      145020451       116852889
        13      148161353       131406280
        14      148378655       130174353
        15      148903652       127969674

Average time    145944306.6     131742993.1 ns
%Reduction                      -9.73%

--------------------------------------
hackbench:

8 vCPUs, guest VM free run, x2APIC mode
./hackbench -p -l 100000

                w/o IPIv        w/ IPIv
Time            91.887          74.605
%Reduction                      -18.808%

96 vCPUs, guest VM free run, x2APIC mode
./hackbench -p -l 1000000

                w/o IPIv        w/ IPIv
Time            287.504         235.185
%Reduction                      -18.198%

--------------------------------------
v6->v7:
1. Revise kvm_apic_write_nodecode() on dealing with
   vICR busy bit in x2apic mode
2. Merge PID-table memory allocation with max_vcpu_id
   into IPIv enabling patch
3. Change to allocate PID-table, setup vCPU's PID-table
   entry and IPIv related VMCS fields once IPIv can
   be enabled, which support runtime enabling IPIv.

v5->v6:
1. Adapt kvm_apic_write_nodecode() implementation based
   on Sean's fix of x2apic's ICR register process.
2. Drop the patch handling IPIv table entry setting in
   case APIC ID changed, instead applying Levitsky's patch
   to disallow setting APIC ID in any case.
3. Drop the patch resizing the PID-pointer table on demand.
   Allow userspace to set maximum vcpu id at runtime that
   IPIv can refer to the practical value to allocate memory
   for PID-pointer table.

v4 -> v5:
1. Deal with enable_ipiv parameter following current
   vmcs configuration rule.
2. Allocate memory for PID-pointer table dynamically
3. Support guest runtime modify APIC ID in xAPIC mode
4. Helper to judge possibility to take PI block in IPIv case

v3 -> v4:
1. Refine code style of patch 2
2. Move tertiary control shadow build into patch 3
3. Make vmx_tertiary_exec_control to be static function

v2 -> v3:
1. Misc change on tertiary execution control
   definition and capability setup
2. Alternative to get tertiary execution
   control configuration

v1 -> v2:
1. Refine the IPIv enabling logic for VM.
   Remove ipiv_active definition per vCPU.

--------------------------------------

Chao Gao (1):
  KVM: VMX: enable IPI virtualization

Maxim Levitsky (1):
  KVM: x86: lapic: don't allow to change APIC ID unconditionally

Robert Hoo (4):
  x86/cpu: Add new VMX feature, Tertiary VM-Execution control
  KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit
    variation
  KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
  KVM: VMX: dump_vmcs() reports tertiary_exec_control field as well

Zeng Guang (2):
  KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
  KVM: x86: Allow userspace set maximum VCPU id for VM

 arch/x86/include/asm/kvm_host.h    |   6 ++
 arch/x86/include/asm/msr-index.h   |   1 +
 arch/x86/include/asm/vmx.h         |  11 +++
 arch/x86/include/asm/vmxfeatures.h |   5 +-
 arch/x86/kernel/cpu/feat_ctl.c     |   9 +-
 arch/x86/kvm/lapic.c               |  47 ++++++++--
 arch/x86/kvm/vmx/capabilities.h    |  13 +++
 arch/x86/kvm/vmx/evmcs.c           |   2 +
 arch/x86/kvm/vmx/evmcs.h           |   1 +
 arch/x86/kvm/vmx/posted_intr.c     |  15 ++-
 arch/x86/kvm/vmx/vmcs.h            |   1 +
 arch/x86/kvm/vmx/vmx.c             | 141 +++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  65 +++++++------
 arch/x86/kvm/x86.c                 |  11 +++
 14 files changed, 280 insertions(+), 48 deletions(-)

-- 
2.27.0

