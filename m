Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C043BA5C7
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhGBWKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:10:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:15273 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhGBWJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:09:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168418"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168418"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:32 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814896"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:32 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v2 65/69] KVM: X86: Introduce initial_tsc_khz in struct kvm_arch
Date:   Fri,  2 Jul 2021 15:05:11 -0700
Message-Id: <5f87f0b888555b52041a0fe32280adee0d563e63.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce a per-vm variable initial_tsc_khz to hold the default tsc_khz
for kvm_arch_vcpu_create().

This field is going to be used by TDX since TSC frequency for TD guest
is configured at TD VM initialization phase.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a47e17892258..ae8b96e15e71 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1030,6 +1030,7 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
 	u32 last_tsc_khz;
+	u32 initial_tsc_khz;
 	u64 cur_tsc_nsec;
 	u64 cur_tsc_write;
 	u64 cur_tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a8299add443f..d3ebed784eac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10441,7 +10441,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
+	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.initial_tsc_khz);
 
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
@@ -10894,6 +10894,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	pvclock_update_vm_gtod_copy(kvm);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;
+	kvm->arch.initial_tsc_khz = max_tsc_khz;
 
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
-- 
2.25.1

