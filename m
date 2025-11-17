Return-Path: <kvm+bounces-63335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 03AE6C62F3A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 2ED9028B2C
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 08:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 546052877FE;
	Mon, 17 Nov 2025 08:46:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from Atcsqr.andestech.com (60-248-80-70.hinet-ip.hinet.net [60.248.80.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEC6265632
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 08:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.248.80.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763369208; cv=none; b=qzv4o1mSYlpsSIHzwwmT3t92QyD4TjOTFi5RPOz7V/8YC/J1hrLYasDI7JmbIPpY6JwBeqbzJK7BAvomkGzv1E1gqrufm6ZgyEj13T0SVD2Nr+6Q/uuvwcKV8TcRKE5+Qti/4Jqi3j3pTU5krN0n7lw56OOKhLP7GZCaCsHjYhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763369208; c=relaxed/simple;
	bh=5rq7hC+3whNZCqhr0ZHxQujF367+hptZaUKGj/4QSIE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DJszJ7ao95W2j6qHBC6GXR9F3DRDj338afjV6x+4mwJhvCVgQ/xvnYaW2YLxA47wao+51Xu3QwW6DDLAx+R+XGwEe5wkhR0r9jFiijz+K5VFUQ23WW/MJKVO1AHuEfQCIZzQlXu4ubvnhP6P5QK74k684RI1QX7U4K6kSSdErQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com; spf=pass smtp.mailfrom=andestech.com; arc=none smtp.client-ip=60.248.80.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andestech.com
Received: from mail.andestech.com (ATCPCS34.andestech.com [10.0.1.134])
	by Atcsqr.andestech.com with ESMTPS id 5AH8kHmt097165
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
	Mon, 17 Nov 2025 16:46:17 +0800 (+08)
	(envelope-from minachou@andestech.com)
Received: from swlinux02.andestech.com (10.0.15.183) by ATCPCS34.andestech.com
 (10.0.1.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Nov
 2025 16:46:17 +0800
From: Hui Min Mina Chou <minachou@andestech.com>
To: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
CC: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tim609@andestech.com>, <minachou@andestech.com>,
        <ben717@andestech.com>, <az70021@gmail.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=
	<rkrcmar@ventanamicro.com>
Subject: [PATCH v4] RISC-V: KVM: Flush VS-stage TLB after VCPU migration for split two-stage TLBs
Date: Mon, 17 Nov 2025 16:45:55 +0800
Message-ID: <20251117084555.157642-1-minachou@andestech.com>
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
X-MAIL:Atcsqr.andestech.com 5AH8kHmt097165

Most implementations cache the combined result of two-stage
translation, but some, like Andes cores, use split TLBs that
store VS-stage and G-stage entries separately.

On such systems, when a VCPU migrates to another CPU, an additional
HFENCE.VVMA is required to avoid using stale VS-stage entries, which
could otherwise cause guest faults.

Introduce a static key to identify CPUs with split two-stage TLBs.
When enabled, KVM issues an extra HFENCE.VVMA on VCPU migration to
prevent stale VS-stage mappings.

Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
Reviewed-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
Changelog:

v4:
 - Rename the patch subject
 - Remove the Fixes tag
 - Add a static key so that HFENCE.VVMA is issued only on CPUs with
   split two-stage TLBs
 - Add kvm_riscv_setup_vendor_features() to detect mvendorid/marchid
   and enable the key when required

v3:
 - Resolved build warning; updated header declaration and call side to
   kvm_riscv_local_tlb_sanitize
 - Add Radim Krčmář's Reviewed-by tag
 (https://lore.kernel.org/all/20251023032517.2527193-1-minachou@andestech.com/)

v2:
 - Updated Fixes commit to 92e450507d56
 - Renamed function to kvm_riscv_local_tlb_sanitize
 (https://lore.kernel.org/all/20251021083105.4029305-1-minachou@andestech.com/)
---
 arch/riscv/include/asm/kvm_host.h |  2 ++
 arch/riscv/include/asm/kvm_vmid.h |  2 +-
 arch/riscv/kvm/main.c             | 14 ++++++++++++++
 arch/riscv/kvm/vcpu.c             |  2 +-
 arch/riscv/kvm/vmid.c             |  6 +++++-
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index d71d3299a335..21abac2f804e 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -323,4 +323,6 @@ bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
 
 void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
 
+DECLARE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
+
 #endif /* __RISCV_KVM_HOST_H__ */
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
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 67c876de74ef..bf0e4f1abe0f 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -15,6 +15,18 @@
 #include <asm/kvm_nacl.h>
 #include <asm/sbi.h>
 
+DEFINE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
+
+static void kvm_riscv_setup_vendor_features(void)
+{
+	/* Andes AX66: split two-stage TLBs */
+	if (riscv_cached_mvendorid(0) == ANDES_VENDOR_ID &&
+	    (riscv_cached_marchid(0) & 0xFFFF) == 0x8A66) {
+		static_branch_enable(&kvm_riscv_tlb_split_mode);
+		kvm_info("using split two-stage TLBs requiring extra HFENCE.VVMA\n");
+	}
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
@@ -159,6 +171,8 @@ static int __init riscv_kvm_init(void)
 		kvm_info("AIA available with %d guest external interrupts\n",
 			 kvm_riscv_aia_nr_hgei);
 
+	kvm_riscv_setup_vendor_features();
+
 	kvm_register_perf_callbacks(NULL);
 
 	rc = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
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
index 3b426c800480..1dbd50c67a88 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
 }
 
-void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
+void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
 {
 	unsigned long vmid;
 
@@ -146,4 +146,8 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
 
 	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
 	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
+
+	/* For split TLB designs, flush VS-stage entries also */
+	if (static_branch_unlikely(&kvm_riscv_tlb_split_mode))
+		kvm_riscv_local_hfence_vvma_all(vmid);
 }
-- 
2.34.1


