Return-Path: <kvm+bounces-14451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9591A8A29D8
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2831F2841C4
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B95824BB;
	Fri, 12 Apr 2024 08:44:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5034182495;
	Fri, 12 Apr 2024 08:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911444; cv=none; b=i0jjbyInNgDjhoaHFSGvPCbDVg0TCa8ZPqgEeA7pqIL1B5AUnD5nSvKYbXmSqDwE4R/bBESc5XHbEZX3dbLH4QX0KfX5Bpmbh11OqARdQ+beuIvOvdqv7s3NkGs+E20LbYXrTIFTeez9vb0ox18VQpFt3trFFfUoCd0eNwI+P5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911444; c=relaxed/simple;
	bh=YDaxlVTrZ+eLBz0rVk2gkbjJr9fpNkurmKQbjTD9toY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RjtkNY+cXFTwA12r8tLZ6ou/Bn66n/qH1vvrj9+2JQVatlc+2PXUUkDAi5w0/rxEVAZ30cNuHGrAC8S8Hm/OYOXYBcz1RuKdJl4dGORaB7MN6CCbU0tk5FJ3zQX0fkSvMLEyJnNHZl+xE7Mi89GMZsHScPA4GlhrAOOVj5kyQ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 419901576;
	Fri, 12 Apr 2024 01:44:32 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9A4B3F6C4;
	Fri, 12 Apr 2024 01:44:00 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 19/43] KVM: arm64: Handle realm MMIO emulation
Date: Fri, 12 Apr 2024 09:42:45 +0100
Message-Id: <20240412084309.1733783-20-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
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
 arch/arm64/kvm/mmio.c     | 10 +++++++++-
 arch/arm64/kvm/rme-exit.c |  6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 200c8019a82a..589a1a7601ad 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/rmi_smc.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -90,6 +91,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 	vcpu->mmio_needed = 0;
 
+	if (vcpu_is_rec(vcpu))
+		vcpu->arch.rec.run->entry.flags |= RMI_EMULATED_MMIO;
+
 	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
 		struct kvm_run *run = vcpu->run;
 
@@ -108,7 +112,11 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       &data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
-		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
+
+		if (vcpu_is_rec(vcpu))
+			vcpu->arch.rec.run->entry.gprs[0] = data;
+		else
+			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
 	}
 
 	/*
diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
index 5bf58c9b42b7..2ddaec09cc98 100644
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
2.34.1


