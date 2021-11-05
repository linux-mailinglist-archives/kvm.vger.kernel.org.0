Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735C64468D8
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 20:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhKETYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 15:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhKETYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 15:24:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C516125F;
        Fri,  5 Nov 2021 19:21:30 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mj4mG-003ig2-Jz; Fri, 05 Nov 2021 19:21:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 2/5] KVM: mips: Use kvm_get_vcpu() instead of open-coded access
Date:   Fri,  5 Nov 2021 19:20:58 +0000
Message-Id: <20211105192101.3862492-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211105192101.3862492-1-maz@kernel.org>
References: <20211105192101.3862492-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-mips@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup.patel@wdc.com, atish.patra@wdc.com, borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com, jgross@suse.com, npiggin@gmail.com, seanjc@google.com, paulus@samba.org, mpe@ellerman.id.au, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we are about to change the way vcpus are allocated, mandate
the use of kvm_get_vcpu() instead of open-coding the access.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/mips/kvm/loongson_ipi.c | 4 ++--
 arch/mips/kvm/mips.c         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/loongson_ipi.c b/arch/mips/kvm/loongson_ipi.c
index 3681fc8fba38..5d53f32d837c 100644
--- a/arch/mips/kvm/loongson_ipi.c
+++ b/arch/mips/kvm/loongson_ipi.c
@@ -120,7 +120,7 @@ static int loongson_vipi_write(struct loongson_kvm_ipi *ipi,
 		s->status |= data;
 		irq.cpu = id;
 		irq.irq = 6;
-		kvm_vcpu_ioctl_interrupt(kvm->vcpus[id], &irq);
+		kvm_vcpu_ioctl_interrupt(kvm_get_vcpu(kvm, id), &irq);
 		break;
 
 	case CORE0_CLEAR_OFF:
@@ -128,7 +128,7 @@ static int loongson_vipi_write(struct loongson_kvm_ipi *ipi,
 		if (!s->status) {
 			irq.cpu = id;
 			irq.irq = -6;
-			kvm_vcpu_ioctl_interrupt(kvm->vcpus[id], &irq);
+			kvm_vcpu_ioctl_interrupt(kvm_get_vcpu(kvm, id), &irq);
 		}
 		break;
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index ceacca74f808..6228bf396d63 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -479,7 +479,7 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	if (irq->cpu == -1)
 		dvcpu = vcpu;
 	else
-		dvcpu = vcpu->kvm->vcpus[irq->cpu];
+		dvcpu = kvm_get_vcpu(vcpu->kvm, irq->cpu);
 
 	if (intr == 2 || intr == 3 || intr == 4 || intr == 6) {
 		kvm_mips_callbacks->queue_io_int(dvcpu, irq);
-- 
2.30.2

