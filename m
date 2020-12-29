Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B09F2E6EB7
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 08:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgL2HTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 02:19:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:11855 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgL2HTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Dec 2020 02:19:10 -0500
IronPort-SDR: kJgi/DFXkXKTzu65gduZgNlOhGsHoRACROFXvp8dLh9jbqwt2sHuMZEmIiO69tPaiyK7UbjWAN
 Bob+yjabg4dQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9848"; a="173888152"
X-IronPort-AV: E=Sophos;i="5.78,457,1599548400"; 
   d="scan'208";a="173888152"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2020 23:17:25 -0800
IronPort-SDR: QKCKIStYkeNmfJgKwwFY1lbNsImWFJP+blXuQKbjL2cbTrl2SQEqqYBlWswOBNA1LnXwYwDFyL
 u5/2oMz8bZjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,457,1599548400"; 
   d="scan'208";a="347286495"
Received: from unknown (HELO clx-ap-likexu.sh.intel.com) ([10.239.48.105])
  by fmsmga008.fm.intel.com with ESMTP; 28 Dec 2020 23:17:23 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     syzkaller-bugs@googlegroups.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()
Date:   Tue, 29 Dec 2020 15:11:44 +0800
Message-Id: <20201229071144.85418-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we know vPMU will not work properly when the guest bit_width(s) of
the [gp|fixed] counters are greater than the host ones, so we can setup a
smaller left shift value and refresh the guest pmu cpuid entry, thus fixing
the following UBSAN shift-out-of-bounds warning:

shift exponent 197 is too large for 64-bit type 'long long unsigned int'

Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 intel_pmu_refresh.cold+0x75/0x99 arch/x86/kvm/vmx/pmu_intel.c:348
 kvm_vcpu_after_set_cpuid+0x65a/0xf80 arch/x86/kvm/cpuid.c:177
 kvm_vcpu_ioctl_set_cpuid2+0x160/0x440 arch/x86/kvm/cpuid.c:308
 kvm_arch_vcpu_ioctl+0x11b6/0x2d70 arch/x86/kvm/x86.c:4709
 kvm_vcpu_ioctl+0x7b9/0xdb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3386
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+ae488dc136a4cc6ba32b@syzkaller.appspotmail.com
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a886a47daebd..a86a1690e75c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -345,6 +345,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
+	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
@@ -355,6 +356,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_fixed_counters =
 			min_t(int, edx.split.num_counters_fixed,
 			      x86_pmu.num_counters_fixed);
+		edx.split.bit_width_fixed = min_t(int,
+			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
-- 
2.29.2

