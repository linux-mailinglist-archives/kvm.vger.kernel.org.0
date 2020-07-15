Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71F220338
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgGOEGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:16670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgGOEGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:02 -0400
IronPort-SDR: xXg0snEgwNOooD3gl0He6k3kv+5MTJ5k+0ZRgeEFwiAaCOyj3H80BS2AabZ2toRv4Sp+J1wiDy
 0szdY/OWY4qA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167479"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167479"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:01 -0700
IronPort-SDR: srxr9mmabrRkjfdIblyup+KNXo+ebb9ZuNfJP5MUwZb2yIPc2yFT256FCsO2zP0guShTbjdZJ3
 ioCZC3tIv9kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587005"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 21:06:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 1/7] KVM: nVMX: Reset the segment cache when stuffing guest segs
Date:   Tue, 14 Jul 2020 21:05:51 -0700
Message-Id: <20200715040557.5889-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715040557.5889-1-sean.j.christopherson@intel.com>
References: <20200715040557.5889-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 4d561edf6f9ca..3b23901b90809 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2407,6 +2407,8 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_TR_BASE, vmcs12->guest_tr_base);
 		vmcs_writel(GUEST_GDTR_BASE, vmcs12->guest_gdtr_base);
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
+
+		vmx->segment_cache.bitmask = 0;
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
-- 
2.26.0

