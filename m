Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA584B7EBD
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344138AbiBPDQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:16:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344182AbiBPDQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:16:00 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78491DCE07;
        Tue, 15 Feb 2022 19:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644981349; x=1676517349;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QTNgfjCEcX1QhsvTX1L+Tjbtrc8LR7Y4aspA8SJiUsY=;
  b=JwBB0DbylUBY2K3e//TrI8m1LQawXcoZwceWmpubMWe0giVf7YIPEwUe
   duP7lcXCIOm9A0lnVIotI0XiHMTlbn6gEVIxnrVtFKk/xectxV0djtRuJ
   A9v0PfXFmDtJjm/wnwqqtuqALzL0+UDHdBddGebkPTGjzfF73sIS8quKw
   AkbSYG116omhG4VzRlqLH/PeafkFHaLC6heTiK2eDWkR9dJxKmx8F1RC8
   ELDfIQYflM0ZjCXATv/t14EbgA4je8RVIOwDaaPOThRrIFMr3YeAubZ2D
   ybISafQCEeBomQsPKrkd6a+MLiVq2W2/I5Dq2LeLIbBDSqNf8Wb3cRutc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250250392"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="250250392"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:15:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="773798119"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:15:36 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Heiko Carstens <hca@linux.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Jia He <justin.he@arm.com>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Garry <john.garry@huawei.com>,
        Juergen Gross <jgross@suse.com>, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Qi Liu <liuqi115@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>, x86@kernel.org
Subject: [PATCH v4 0/6] Improve KVM's interaction with CPU hotplug
Date:   Wed, 16 Feb 2022 11:15:15 +0800
Message-Id: <20220216031528.92558-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes from v3->v4:
 - rebased to the lastest kvm/next branch.
 - add Sean's reviewed-by tags
 - add Marc's patch to simplify ARM's cpu hotplug logic in KVM

Changes from v2->v3:
 - rebased to the latest kvm/next branch. 
 - patch 1: rename {svm,vmx}_check_processor_compat to follow the name
	    convention
 - patch 3: newly added to provide more information when hardware enabling
	    fails
 - patch 4: reset hardware_enable_failed if hardware enabling fails. And
	    remove redundent kernel log.
 - patch 5: add a pr_err() for setup_vmcs_config() path.

Changes from v1->v2: (all comments/suggestions on v1 are from Sean, thanks)
 - Merged v1's patch 2 into patch 1, and v1's patch 5 into patch 6.
 - Use static_call for check_processor_compatibility().
 - Generate patch 2 with "git revert" and do manual changes based on that.
 - Loosen the WARN_ON() in kvm_arch_check_processor_compat() instead of
   removing it.
 - KVM always prevent incompatible CPUs from being brought up regardless of
   running VMs.
 - Use pr_warn instead of pr_info to emit logs when KVM finds offending
   CPUs.

KVM registers its CPU hotplug callback to CPU starting section. And in the
callback, KVM enables hardware virtualization on hotplugged CPUs if any VM
is running on existing CPUs.

There are two problems in the process:
1. KVM doesn't do compatibility checks before enabling hardware
virtualization on hotplugged CPUs. This may cause #GP if VMX isn't
supported or vmentry failure if some in-use VMX features are missing on
hotplugged CPUs. Both break running VMs.
2. Callbacks in CPU STARTING section cannot fail. So, even if KVM finds
some incompatible CPUs, its callback cannot block CPU hotplug.

This series improves KVM's interaction with CPU hotplug to avoid
incompatible CPUs breaking running VMs. Following changes are made:

1. move KVM's CPU hotplug callback to ONLINE section (suggested by Thomas)
2. do compatibility checks on hotplugged CPUs.
3. abort onlining incompatible CPUs

This series is a follow-up to the discussion about KVM and CPU hotplug
https://lore.kernel.org/lkml/3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com/T/

Note: this series is tested only on Intel systems.

Chao Gao (4):
  KVM: x86: Move check_processor_compatibility from init ops to runtime
    ops
  Partially revert "KVM: Pass kvm_init()'s opaque param to additional
    arch funcs"
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
  KVM: Do compatibility checks on hotplugged CPUs

Marc Zyngier (1):
  KVM: arm64: Simplify the CPUHP logic

Sean Christopherson (1):
  KVM: Provide more information in kernel log if hardware enabling fails

 arch/arm64/kvm/arch_timer.c        | 27 ++++-------
 arch/arm64/kvm/arm.c               |  6 ++-
 arch/arm64/kvm/vgic/vgic-init.c    | 19 +-------
 arch/mips/kvm/mips.c               |  2 +-
 arch/powerpc/kvm/powerpc.c         |  2 +-
 arch/riscv/kvm/main.c              |  2 +-
 arch/s390/kvm/kvm-s390.c           |  2 +-
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             |  4 +-
 arch/x86/kvm/vmx/evmcs.c           |  2 +-
 arch/x86/kvm/vmx/evmcs.h           |  2 +-
 arch/x86/kvm/vmx/vmx.c             | 22 +++++----
 arch/x86/kvm/x86.c                 | 16 +++++--
 include/kvm/arm_arch_timer.h       |  4 ++
 include/kvm/arm_vgic.h             |  4 ++
 include/linux/cpuhotplug.h         |  5 +-
 include/linux/kvm_host.h           |  2 +-
 virt/kvm/kvm_main.c                | 73 +++++++++++++++++++-----------
 19 files changed, 107 insertions(+), 90 deletions(-)

-- 
2.25.1

