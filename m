Return-Path: <kvm+bounces-38050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7E5A349E4
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5154F3B2412
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7704280A22;
	Thu, 13 Feb 2025 16:16:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A126627FE89;
	Thu, 13 Feb 2025 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463369; cv=none; b=WQ0W3YbftsIpCaZByLlyzNHwwvt+pzXmqQw8nA/Aq/O7rC0JoWlJk9kpfNxW3Qd/aO1iy+DT/Nmv3X25deymzyR/iK8k+JtRIvJDQwcg4UM7K31CBtWtgH+MM2KHcOInJc2Dfh+oOok+NfKPaedfgij0VKvSkbyx5CS7YqpV+wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463369; c=relaxed/simple;
	bh=8+5AwkbXNAfRYqWVSXxGPd5voMjxPRw9TxrfWJGUYgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neK/c9IHVeae8G4eqnt8TjLiUaG/AxDYLCt+3Gl6rg3Eg10rUHPsntz4kElx7Iy5nNyiSmK+aelEofUpvC9doUbBYIob5I0W2ndaGN3zobIsiTPC4nbeIPu4I133R3OkqwtrDGCdXhYWF8trDROHoYd/9h4o8hLzPV7g5fT6ua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C33CA26B9;
	Thu, 13 Feb 2025 08:16:27 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A797D3F6A8;
	Thu, 13 Feb 2025 08:16:02 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 19/45] KVM: arm64: Handle realm MMIO emulation
Date: Thu, 13 Feb 2025 16:13:59 +0000
Message-ID: <20250213161426.102987-20-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
References: <20250213161426.102987-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MMIO emulation for a realm cannot be done directly with the VM's
registers as they are protected from the host. However, for emulatable
data aborts, the RMM uses GPRS[0] to provide the read/written value.
We can transfer this from/to the equivalent VCPU's register entry and
then depend on the generic MMIO handling code in KVM.

For a MMIO read, the value is placed in the shared RecExit structure
during kvm_handle_mmio_return() rather than in the VCPU's register
entry.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v5:
 * Inject SEA to the guest is an emulatable MMIO access triggers a data
   abort.
 * kvm_handle_mmio_return() - disable kvm_incr_pc() for a REC (as the PC
   isn't under the host's control) and move the REC_ENTER_EMULATED_MMIO
   flag setting to this location (as that tells the RMM to skip the
   instruction).
---
 arch/arm64/kvm/inject_fault.c |  4 +++-
 arch/arm64/kvm/mmio.c         | 16 ++++++++++++----
 arch/arm64/kvm/rme-exit.c     |  6 ++++++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e..2a9682b9834f 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -165,7 +165,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
  */
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 {
-	if (vcpu_el1_is_32bit(vcpu))
+	if (unlikely(vcpu_is_rec(vcpu)))
+		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
+	else if (vcpu_el1_is_32bit(vcpu))
 		inject_abt32(vcpu, false, addr);
 	else
 		inject_abt64(vcpu, false, addr);
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index ab365e839874..bff89d47a4d5 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/rmi_smc.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -136,14 +137,21 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       &data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
-		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
+
+		if (vcpu_is_rec(vcpu))
+			vcpu->arch.rec.run->enter.gprs[0] = data;
+		else
+			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
 	}
 
 	/*
 	 * The MMIO instruction is emulated and should not be re-executed
 	 * in the guest.
 	 */
-	kvm_incr_pc(vcpu);
+	if (vcpu_is_rec(vcpu))
+		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_EMULATED_MMIO;
+	else
+		kvm_incr_pc(vcpu);
 
 	return 1;
 }
@@ -162,14 +170,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * No valid syndrome? Ask userspace for help if it has
 	 * volunteered to do so, and bail out otherwise.
 	 *
-	 * In the protected VM case, there isn't much userspace can do
+	 * In the protected/realm VM case, there isn't much userspace can do
 	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
 		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
-		if (vcpu_is_protected(vcpu)) {
+		if (vcpu_is_protected(vcpu) || vcpu_is_rec(vcpu)) {
 			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 			return 1;
 		}
diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
index aae1adefe1a3..c785005f821f 100644
--- a/arch/arm64/kvm/rme-exit.c
+++ b/arch/arm64/kvm/rme-exit.c
@@ -25,6 +25,12 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
 
 static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
 {
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
+		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
+			     rec->run->exit.gprs[0]);
+
 	return kvm_handle_guest_abort(vcpu);
 }
 
-- 
2.43.0


