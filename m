Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D124727604F
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgIWSp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:45:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:14506 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgIWSoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:44:54 -0400
IronPort-SDR: lYVYORvuiGnQpiGL6gJCW2XHjrIHWetwCYE2C9FnSzkKniUtGOUtF0UaFQlug2CS7H5WY6+VEA
 QoieX+LXRayA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225124471"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="225124471"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:44:53 -0700
IronPort-SDR: raRX+UdgFpVe0RwVtA3YHBB4KtQmsIqt3dXRq+oX7WgMMhcnsZK0vmJbUXMCzfcheJY3kDUVsD
 MjTCj77I07qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="347457646"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2020 11:44:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH v2 1/7] KVM: nVMX: Reset the segment cache when stuffing guest segs
Date:   Wed, 23 Sep 2020 11:44:46 -0700
Message-Id: <20200923184452.980-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923184452.980-1-sean.j.christopherson@intel.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly reset the segment cache after stuffing guest segment regs in
prepare_vmcs02_rare().  Although the cache is reset when switching to
vmcs02, there is nothing that prevents KVM from re-populating the cache
prior to writing vmcs02 with vmcs12's values.  E.g. if the vCPU is
preempted after switching to vmcs02 but before prepare_vmcs02_rare(),
kvm_arch_vcpu_put() will dereference GUEST_SS_AR_BYTES via .get_cpl()
and cache the stale vmcs02 value.  While the current code base only
caches stale data in the preemption case, it's theoretically possible
future code could read a segment register during the nested flow itself,
i.e. this isn't technically illegal behavior in kvm_arch_vcpu_put(),
although it did introduce the bug.

This manifests as an unexpected nested VM-Enter failure when running
with unrestricted guest disabled if the above preemption case coincides
with L1 switching L2's CPL, e.g. when switching from a L2 vCPU at CPL3
to to a L2 vCPU at CPL0.  stack_segment_valid() will see the new SS_SEL
but the old SS_AR_BYTES and incorrectly mark the guest state as invalid
due to SS.dpl != SS.rpl.

Don't bother updating the cache even though prepare_vmcs02_rare() writes
every segment.  With unrestricted guest, guest segments are almost never
read, let alone L2 guest segments.  On the other hand, populating the
cache requires a large number of memory writes, i.e. it's unlikely to be
a net win.  Updating the cache would be a win when unrestricted guest is
not supported, as guest_state_valid() will immediately cache all segment
registers.  But, nested virtualization without unrestricted guest is
dirt slow, saving some VMREADs won't change that, and every CPU
manufactured in the last decade supports unrestricted guest.  In other
words, the extra (minor) complexity isn't worth the trouble.

Note, kvm_arch_vcpu_put() may see stale data when querying guest CPL
depending on when preemption occurs.  This is "ok" in that the usage is
imperfect by nature, i.e. it's used heuristically to improve performance
but doesn't affect functionality.  kvm_arch_vcpu_put() could be "fixed"
by also disabling preemption while loading segments, but that's
pointless and misleading as reading state from kvm_sched_{in,out}() is
guaranteed to see stale data in one form or another.  E.g. even if all
the usage of regs_avail is fixed to call kvm_register_mark_available()
after the associated state is set, the individual state might still be
stale with respect to the overall vCPU state.  I.e. making functional
decisions in an asynchronous hook is doomed from the get go.  Thankfully
KVM doesn't do that.

Fixes: de63ad4cf4973 ("KVM: X86: implement the logic for spinlock optimization")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6ce9ce91029..04441663a631 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2408,6 +2408,8 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_TR_BASE, vmcs12->guest_tr_base);
 		vmcs_writel(GUEST_GDTR_BASE, vmcs12->guest_gdtr_base);
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
+
+		vmx->segment_cache.bitmask = 0;
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
-- 
2.28.0

