Return-Path: <kvm+bounces-60869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 063B7BFEFCC
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 05:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A42E03523A2
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 03:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C8D2248B4;
	Thu, 23 Oct 2025 03:26:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from Atcsqr.andestech.com (60-248-80-70.hinet-ip.hinet.net [60.248.80.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2289E1E5B60
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 03:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.248.80.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761189983; cv=none; b=NG6siZ0zA52eD5sRu2JJVcOmdrc/gjJX0hJac/hNmW9KyYou7qr7S+6hPREbkkRN+fGHZz++3n3tWCcg2FaAQNoUixafSSraoIWA+H/bkJIXpM42n83urw9LxwSDNinZApvCGwLVpwl4/lo2xYugop6Ot9KUj6jSOdQZC8+3W7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761189983; c=relaxed/simple;
	bh=RCZSGh4PwVbnssGD0Ep99NURJjnoNcltfPOBel3L4UI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AHjgjAwm8jIxI/fpoUXv1bQEoFDofRET5kGFH1EyDiuNnzf4sAAk1WIOWl9G5gmh7fJgML0pi8/Uv2HnuFOJt8bglygIuMlTRtQnOhVEFFKptgzigoADIk+dnPqaEh62TpF4w9Ayj3ysy/MolEnQMXsKn781cWJCVALgFr1lvEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com; spf=pass smtp.mailfrom=andestech.com; arc=none smtp.client-ip=60.248.80.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andestech.com
Received: from mail.andestech.com (ATCPCS34.andestech.com [10.0.1.134])
	by Atcsqr.andestech.com with ESMTPS id 59N3Q4Bw097416
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
	Thu, 23 Oct 2025 11:26:04 +0800 (+08)
	(envelope-from minachou@andestech.com)
Received: from swlinux02.andestech.com (10.0.15.183) by ATCPCS34.andestech.com
 (10.0.1.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 23 Oct
 2025 11:26:04 +0800
From: Hui Min Mina Chou <minachou@andestech.com>
To: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
CC: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tim609@andestech.com>, <minachou@andestech.com>,
        <ben717@andestech.com>, <az70021@gmail.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=
	<rkrcmar@ventanamicro.com>
Subject: [PATCH v3] RISC-V: KVM: flush VS-stage TLB after VCPU migration to prevent stale entries
Date: Thu, 23 Oct 2025 11:25:17 +0800
Message-ID: <20251023032517.2527193-1-minachou@andestech.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ATCPCS33.andestech.com (10.0.1.100) To
 ATCPCS34.andestech.com (10.0.1.134)
X-DKIM-Results: atcpcs34.andestech.com; dkim=none;
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:Atcsqr.andestech.com 59N3Q4Bw097416

From: Hui Min Mina Chou <minachou@andestech.com>

If multiple VCPUs of the same Guest/VM run on the same Host CPU,
hfence.vvma only flushes that Host CPU’s VS-stage TLB. Other Host CPUs
may retain stale VS-stage entries. When a VCPU later migrates to a
different Host CPU, it can hit these stale GVA to GPA mappings, causing
unexpected faults in the Guest.

To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CPU.
This ensures that no stale VS-stage mappings remain after VCPU migration.

Fixes: 92e450507d56 ("RISC-V: KVM: Cleanup stale TLB entries when host CPU changes")
Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
Reviewed-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
v3:
- Resolved build warning; updated header declaration and call side to
  kvm_riscv_local_tlb_sanitize

v2:
- Updated Fixes commit to 92e450507d56
- Renamed function to kvm_riscv_local_tlb_sanitize

 arch/riscv/include/asm/kvm_vmid.h | 2 +-
 arch/riscv/kvm/vcpu.c             | 2 +-
 arch/riscv/kvm/vmid.c             | 8 +++++++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vmid.h b/arch/riscv/include/asm/kvm_vmid.h
index ab98e1434fb7..75fb6e872ccd 100644
--- a/arch/riscv/include/asm/kvm_vmid.h
+++ b/arch/riscv/include/asm/kvm_vmid.h
@@ -22,6 +22,6 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
 int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
 bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
 void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
-void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
+void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3ebcfffaa978..796218e4a462 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -968,7 +968,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * Note: This should be done after G-stage VMID has been
 		 * updated using kvm_riscv_gstage_vmid_ver_changed()
 		 */
-		kvm_riscv_gstage_vmid_sanitize(vcpu);
+		kvm_riscv_local_tlb_sanitize(vcpu);
 
 		trace_kvm_entry(vcpu);
 
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 3b426c800480..6323f5383d36 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
 }
 
-void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
+void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
 {
 	unsigned long vmid;
 
@@ -146,4 +146,10 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
 
 	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
 	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
+
+	/*
+	 * Flush VS-stage TLBs entry after VCPU migration to avoid using
+	 * stale entries.
+	 */
+	kvm_riscv_local_hfence_vvma_all(vmid);
 }
-- 
2.34.1


