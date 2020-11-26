Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3F02C528B
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 12:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgKZLCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 06:02:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729663AbgKZLCP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 06:02:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606388534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wRLRXSeehVYPVGuCA1d0o01Y+gIuPbLbz2602T4YeXA=;
        b=MJz8GNIycgMjs3uiRGTFuyENpaPTEYm600V7oDtz6TG9cL180qcERgTztvq5ND8fa0MXO2
        mEfK2Amj5lpm/p4zEyk8cQrOW7zD1S8ynHvNUqkpYsldtI9stVWduu9p981GGNkkF8nvrZ
        N+2R322Dk/xgm2GmdxXZ7v2wee47d+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-La-84-XrMvy6T0qdNSLkKw-1; Thu, 26 Nov 2020 06:02:11 -0500
X-MC-Unique: La-84-XrMvy6T0qdNSLkKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE509805C06;
        Thu, 26 Nov 2020 11:02:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1446260C05;
        Thu, 26 Nov 2020 11:02:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH] kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level PT
Date:   Thu, 26 Nov 2020 12:02:06 +0100
Message-Id: <20201126110206.2118959-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU") caused
the following WARNING on an Intel Ice Lake CPU:

 get_mmio_spte: detect reserved bits on spte, addr 0xb80a0, dump hierarchy:
 ------ spte 0xb80a0 level 5.
 ------ spte 0xfcd210107 level 4.
 ------ spte 0x1004c40107 level 3.
 ------ spte 0x1004c41107 level 2.
 ------ spte 0x1db00000000b83b6 level 1.
 WARNING: CPU: 109 PID: 10254 at arch/x86/kvm/mmu/mmu.c:3569 kvm_mmu_page_fault.cold.150+0x54/0x22f [kvm]
...
 Call Trace:
  ? kvm_io_bus_get_first_dev+0x55/0x110 [kvm]
  vcpu_enter_guest+0xaa1/0x16a0 [kvm]
  ? vmx_get_cs_db_l_bits+0x17/0x30 [kvm_intel]
  ? skip_emulated_instruction+0xaa/0x150 [kvm_intel]
  kvm_arch_vcpu_ioctl_run+0xca/0x520 [kvm]

The guest triggering this crashes. Note, this happens with the traditional
MMU and EPT enabled, not with the newly introduced TDP MMU. Turns out,
there was a subtle change in the above mentioned commit. Previously,
walk_shadow_page_get_mmio_spte() was setting 'root' to 'iterator.level'
which is returned by shadow_walk_init() and this equals to
'vcpu->arch.mmu->shadow_root_level'. Now, get_mmio_spte() sets it to
'int root = vcpu->arch.mmu->root_level'.

The difference between 'root_level' and 'shadow_root_level' on CPUs
supporting 5-level page tables is that in some case we don't want to
use 5-level, in particular when 'cpuid_maxphyaddr(vcpu) <= 48'
kvm_mmu_get_tdp_level() returns '4'. In case upper layer is not used,
the corresponding SPTE will fail '__is_rsvd_bits_set()' check.

Revert to using 'shadow_root_level'.

Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- The usual (for KVM MMU) caveat 'I may be missing everything' applies,
 please review)
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5bb1939b65d8..7a6ae9e90bd7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3517,7 +3517,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
 	u64 sptes[PT64_ROOT_MAX_LEVEL];
 	struct rsvd_bits_validate *rsvd_check;
-	int root = vcpu->arch.mmu->root_level;
+	int root = vcpu->arch.mmu->shadow_root_level;
 	int leaf;
 	int level;
 	bool reserved = false;
-- 
2.26.2

