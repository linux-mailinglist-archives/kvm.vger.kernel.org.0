Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32497D89DC
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 22:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjJZUx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 16:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjJZUxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 16:53:25 -0400
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [IPv6:2001:41d0:203:375::ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8399B1A5
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 13:53:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698353599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KVx4O9OZMqaRRaGgDLRaRC+ta8o/rMb4o0crz9Vpp/s=;
        b=vGeqsZgVNvSyJjQKNn3S6L3IHilamh2dzf+wO4W8jF9U6SC6P9Ic4Sepl6A8YVMAinZmNy
        WJ+aq1rXsmf28ctckQzM3TTW+0j3vMUyCEGchHNt3grEvrBo5ZSs3tFp1FjxJo79lNNftM
        p+nbMyZ1YJu7RRK8d0puj79oztVXpiQ=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2] KVM: arm64: Add tracepoint for MMIO accesses where ISV==0
Date:   Thu, 26 Oct 2023 20:53:06 +0000
Message-ID: <20231026205306.3045075-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is a pretty well known fact that KVM does not support MMIO emulation
without valid instruction syndrome information (ESR_EL2.ISV == 0). The
current kvm_pr_unimpl() is pretty useless, as it contains zero context
to relate the event to a vCPU.

Replace it with a precise tracepoint that dumps the relevant context
so the user can make sense of what the guest is doing.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
v1: https://lore.kernel.org/kvmarm/ZToh7pNhz1zzQw6C@linux.dev/
v1 -> v2:
 - Add a tracepoint to improve debuggability (Marc)

Tested with the page_fault_test selftest, which does pre-indexed
accesses outside of a memslot.

 arch/arm64/kvm/mmio.c      |  4 +++-
 arch/arm64/kvm/trace_arm.h | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a..200c8019a82a 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -135,6 +135,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * volunteered to do so, and bail out otherwise.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
+		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
+				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
@@ -143,7 +146,6 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 			return 0;
 		}
 
-		kvm_pr_unimpl("Data abort outside memslots with no valid syndrome info\n");
 		return -ENOSYS;
 	}
 
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 8ad53104934d..c18c1a95831e 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -136,6 +136,31 @@ TRACE_EVENT(kvm_mmio_emulate,
 		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
 );
 
+TRACE_EVENT(kvm_mmio_nisv,
+	TP_PROTO(unsigned long vcpu_pc, unsigned long esr,
+		 unsigned long far, unsigned long ipa),
+	TP_ARGS(vcpu_pc, esr, far, ipa),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_pc		)
+		__field(	unsigned long,	esr		)
+		__field(	unsigned long,	far		)
+		__field(	unsigned long,	ipa		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc		= vcpu_pc;
+		__entry->esr			= esr;
+		__entry->far			= far;
+		__entry->ipa			= ipa;
+	),
+
+	TP_printk("ipa %#016lx, esr %#016lx, far %#016lx, pc %#016lx",
+		  __entry->ipa, __entry->esr,
+		  __entry->far, __entry->vcpu_pc)
+);
+
+
 TRACE_EVENT(kvm_set_way_flush,
 	    TP_PROTO(unsigned long vcpu_pc, bool cache),
 	    TP_ARGS(vcpu_pc, cache),

base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.820.g83a721a137-goog

