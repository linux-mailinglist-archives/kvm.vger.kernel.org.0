Return-Path: <kvm+bounces-48485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7792EACEA02
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C1F73AC00F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304C721A435;
	Thu,  5 Jun 2025 06:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pVH7Zo3e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E6B219315
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104158; cv=none; b=j4lDX1s9kYfLc5S2LMJMc7RfmaxS0JvP/hwS1yR/wvqvw7RGqiQavggUgRxTwhPKdeiXPgbr839+2FNH1FihNPA8bvd+/Ix4EJQQchGhH5oVqesD6sG+QWG1+MvYcrsU1KMtYDJAspNC1am10tNOw1XCtK3I9AIhnWgBH+y2Uqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104158; c=relaxed/simple;
	bh=XN4nRLB9K0FlDxsE36UR8rEo5bM83tbmLM+G36akoCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruBWNuTcpz8fRGvi/o2jhjIl1JMnON2maBMsXQyljJOqExw2PCflnQouHKlfzrbALalKUVA37373p6OqSXVkqJAc+Y/hCgWghaFIqn/iMJIBixJ7oOnX5bivv/MkXnskVR7SMmL1fjHOKkRQo1z2crtFKRpb47oG28rhSyOScjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pVH7Zo3e; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3116db72bd7so680913a91.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104156; x=1749708956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJnA2ITAN8AbKW8vRXTI9OBsRCn2zeX47qUEnC92+48=;
        b=pVH7Zo3eJUjMdw6RIdUUnCCV5HAan3rxFMZx8slpwUIJIP9lH1nbdiE5EABMWts1Cm
         LJrWDkr6Ve9xN/hG6sOVyMiclAis5aMEPbTmsX2nJtPA/dUlkt8QWBuDF3C0AXH87Ybc
         ksYeggWHlRQs0x+RBCQU/ZfiHPas0EinP6mPrytWMnqGbE/BludRshEWJk7usfhZzfP3
         bfmJ8I/E124g/cEQcLswr6MX1a/8+yTULXHLj5i8zfrcMLLRqLqh5vvoY3R/5fg9yIcs
         rwJnyL0p8e5HqIac+a7A8Pz3vSH8aRIIFVMmXmPQfLqXM4q5Xe9nGEq4gipBHzQxNFEK
         J8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104156; x=1749708956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJnA2ITAN8AbKW8vRXTI9OBsRCn2zeX47qUEnC92+48=;
        b=WfhHlGG2OCWco5GDySoUgRqBJVyrklr+aksAwqVuPjzZPE2rj+Kei5WhOL0wFnkPCy
         InAcbJYHO72uK0/ZF+QHkUuxsvScSvEZEid/MVg7XEd89x35TMxmHJxp7teAYEXs0Jsc
         lqKwfdTjmjZt9Bd3pjYTmcUxU4U2KSFz+ZLpwL3Qvk/e+RwUo4KQbsX80kBZRe52q7E/
         vB28Aj9GpEg9cWxJYg+n70W1QVVrCTnqpYiSpETIE/qGuYd4iS/hNn8I+Pd/slZF900B
         YtyidGUtjcBCgjw/82c/50TfJt8ppDH7ZLYBDnvTvPZTI45HFKNd0b0ukaioxb0Kvp3f
         eFfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwnFvZnqhphrf5xemgqm3H6Fa9dD+Be1eTW++1LKy2HQTxWAZP2+9e2mqwh8+RmFwuF+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5J91V3eAbG1K0H7i6wvHfb/ZZsYcM+WOY6ztHzpri4E5FN1rv
	ScrZNiI8zU/MsV5ugAoDKJqSRQAGoOWsa0TDwnegvA2VrMv0vFCmaP+EZs2uvS1LmIgesdLcTIM
	dbW0P
X-Gm-Gg: ASbGncvf69Hmomakk6yB5q1PSTjsOTp+gvozjMaqQkwnWk9Xks7BOwW8Yn6ngce4UO7
	TllOMdmBBSRuy37NXO8dJXH1gi+2EfQimmH1LClmfWAtMIO/LYrXCfIAZYo60LyUh+4H/dCNXRw
	ys9lQbrcqzzLNke/UazR9vdD+MmWaI5Sz/gMTXkak2ixig254HkBV+S3UnwPsUcksXHH6FSE0ZJ
	Cu1BFpz1NI+++xlXuvELyxm71ZEH6Pr00MCVGpv4xEX96BTh+0Z9eLn5XNbhAtOWN/XzetbaJt5
	WHNTnN5mbU238d33rPK7vuqXNUOT/YYAfQl6b2HfBlV2SFwyE51Gtu2jHfGk9PDDlXL5uiTTpRe
	kbMKQwA==
X-Google-Smtp-Source: AGHT+IGidU5oO/NtKWVZfC9oWMHMT1bnyxO6WBsndaUc4qqkBjwaBRbjIPk9+Qztot5hQY4gLIxDWQ==
X-Received: by 2002:a17:90b:2e49:b0:311:a314:c2ca with SMTP id 98e67ed59e1d1-3130ccf6f95mr7911585a91.6.1749104155801;
        Wed, 04 Jun 2025 23:15:55 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:55 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 13/13] RISC-V: KVM: Pass VMID as parameter to kvm_riscv_hfence_xyz() APIs
Date: Thu,  5 Jun 2025 11:44:58 +0530
Message-ID: <20250605061458.196003-14-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, all kvm_riscv_hfence_xyz() APIs assume VMID to be the
host VMID of the Guest/VM which resticts use of these APIs only
for host TLB maintenance. Let's allow passing VMID as parameter
to all kvm_riscv_hfence_xyz() APIs so that they can be re-used
for nested virtualization related TLB maintenance.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_tlb.h  | 17 ++++++---
 arch/riscv/kvm/gstage.c           |  3 +-
 arch/riscv/kvm/tlb.c              | 61 ++++++++++++++++++++-----------
 arch/riscv/kvm/vcpu_sbi_replace.c | 17 +++++----
 arch/riscv/kvm/vcpu_sbi_v01.c     | 25 ++++++-------
 5 files changed, 73 insertions(+), 50 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_tlb.h b/arch/riscv/include/asm/kvm_tlb.h
index f67e03edeaec..38a2f933ad3a 100644
--- a/arch/riscv/include/asm/kvm_tlb.h
+++ b/arch/riscv/include/asm/kvm_tlb.h
@@ -11,9 +11,11 @@
 enum kvm_riscv_hfence_type {
 	KVM_RISCV_HFENCE_UNKNOWN = 0,
 	KVM_RISCV_HFENCE_GVMA_VMID_GPA,
+	KVM_RISCV_HFENCE_GVMA_VMID_ALL,
 	KVM_RISCV_HFENCE_VVMA_ASID_GVA,
 	KVM_RISCV_HFENCE_VVMA_ASID_ALL,
 	KVM_RISCV_HFENCE_VVMA_GVA,
+	KVM_RISCV_HFENCE_VVMA_ALL
 };
 
 struct kvm_riscv_hfence {
@@ -59,21 +61,24 @@ void kvm_riscv_fence_i(struct kvm *kvm,
 void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask,
 				    gpa_t gpa, gpa_t gpsz,
-				    unsigned long order);
+				    unsigned long order, unsigned long vmid);
 void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
-				    unsigned long hbase, unsigned long hmask);
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long vmid);
 void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask,
 				    unsigned long gva, unsigned long gvsz,
-				    unsigned long order, unsigned long asid);
+				    unsigned long order, unsigned long asid,
+				    unsigned long vmid);
 void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask,
-				    unsigned long asid);
+				    unsigned long asid, unsigned long vmid);
 void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
 			       unsigned long hbase, unsigned long hmask,
 			       unsigned long gva, unsigned long gvsz,
-			       unsigned long order);
+			       unsigned long order, unsigned long vmid);
 void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
-			       unsigned long hbase, unsigned long hmask);
+			       unsigned long hbase, unsigned long hmask,
+			       unsigned long vmid);
 
 #endif
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index c7d61f14f6be..c5dc47b156c4 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -117,7 +117,8 @@ static void gstage_tlb_flush(struct kvm_gstage *gstage, u32 level, gpa_t addr)
 	if (gstage->flags & KVM_GSTAGE_FLAGS_LOCAL)
 		kvm_riscv_local_hfence_gvma_vmid_gpa(gstage->vmid, addr, BIT(order), order);
 	else
-		kvm_riscv_hfence_gvma_vmid_gpa(gstage->kvm, -1UL, 0, addr, BIT(order), order);
+		kvm_riscv_hfence_gvma_vmid_gpa(gstage->kvm, -1UL, 0, addr, BIT(order), order,
+					       gstage->vmid);
 }
 
 int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 349fcfc93f54..3c5a70a2b927 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -251,6 +251,12 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 				kvm_riscv_local_hfence_gvma_vmid_gpa(d.vmid, d.addr,
 								     d.size, d.order);
 			break;
+		case KVM_RISCV_HFENCE_GVMA_VMID_ALL:
+			if (kvm_riscv_nacl_available())
+				nacl_hfence_gvma_vmid_all(nacl_shmem(), d.vmid);
+			else
+				kvm_riscv_local_hfence_gvma_vmid_all(d.vmid);
+			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
 			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
 			if (kvm_riscv_nacl_available())
@@ -276,6 +282,13 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 				kvm_riscv_local_hfence_vvma_gva(d.vmid, d.addr,
 								d.size, d.order);
 			break;
+		case KVM_RISCV_HFENCE_VVMA_ALL:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
+			if (kvm_riscv_nacl_available())
+				nacl_hfence_vvma_all(nacl_shmem(), d.vmid);
+			else
+				kvm_riscv_local_hfence_vvma_all(d.vmid);
+			break;
 		default:
 			break;
 		}
@@ -328,14 +341,13 @@ void kvm_riscv_fence_i(struct kvm *kvm,
 void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask,
 				    gpa_t gpa, gpa_t gpsz,
-				    unsigned long order)
+				    unsigned long order, unsigned long vmid)
 {
-	struct kvm_vmid *v = &kvm->arch.vmid;
 	struct kvm_riscv_hfence data;
 
 	data.type = KVM_RISCV_HFENCE_GVMA_VMID_GPA;
 	data.asid = 0;
-	data.vmid = READ_ONCE(v->vmid);
+	data.vmid = vmid;
 	data.addr = gpa;
 	data.size = gpsz;
 	data.order = order;
@@ -344,23 +356,28 @@ void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
 }
 
 void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
-				    unsigned long hbase, unsigned long hmask)
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long vmid)
 {
-	make_xfence_request(kvm, hbase, hmask, KVM_REQ_TLB_FLUSH,
-			    KVM_REQ_TLB_FLUSH, NULL);
+	struct kvm_riscv_hfence data = {0};
+
+	data.type = KVM_RISCV_HFENCE_GVMA_VMID_ALL;
+	data.vmid = vmid;
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
+			    KVM_REQ_TLB_FLUSH, &data);
 }
 
 void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask,
 				    unsigned long gva, unsigned long gvsz,
-				    unsigned long order, unsigned long asid)
+				    unsigned long order, unsigned long asid,
+				    unsigned long vmid)
 {
-	struct kvm_vmid *v = &kvm->arch.vmid;
 	struct kvm_riscv_hfence data;
 
 	data.type = KVM_RISCV_HFENCE_VVMA_ASID_GVA;
 	data.asid = asid;
-	data.vmid = READ_ONCE(v->vmid);
+	data.vmid = vmid;
 	data.addr = gva;
 	data.size = gvsz;
 	data.order = order;
@@ -370,15 +387,13 @@ void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
 
 void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask,
-				    unsigned long asid)
+				    unsigned long asid, unsigned long vmid)
 {
-	struct kvm_vmid *v = &kvm->arch.vmid;
-	struct kvm_riscv_hfence data;
+	struct kvm_riscv_hfence data = {0};
 
 	data.type = KVM_RISCV_HFENCE_VVMA_ASID_ALL;
 	data.asid = asid;
-	data.vmid = READ_ONCE(v->vmid);
-	data.addr = data.size = data.order = 0;
+	data.vmid = vmid;
 	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
 			    KVM_REQ_HFENCE_VVMA_ALL, &data);
 }
@@ -386,14 +401,13 @@ void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
 void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
 			       unsigned long hbase, unsigned long hmask,
 			       unsigned long gva, unsigned long gvsz,
-			       unsigned long order)
+			       unsigned long order, unsigned long vmid)
 {
-	struct kvm_vmid *v = &kvm->arch.vmid;
 	struct kvm_riscv_hfence data;
 
 	data.type = KVM_RISCV_HFENCE_VVMA_GVA;
 	data.asid = 0;
-	data.vmid = READ_ONCE(v->vmid);
+	data.vmid = vmid;
 	data.addr = gva;
 	data.size = gvsz;
 	data.order = order;
@@ -402,16 +416,21 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
 }
 
 void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
-			       unsigned long hbase, unsigned long hmask)
+			       unsigned long hbase, unsigned long hmask,
+			       unsigned long vmid)
 {
-	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
-			    KVM_REQ_HFENCE_VVMA_ALL, NULL);
+	struct kvm_riscv_hfence data = {0};
+
+	data.type = KVM_RISCV_HFENCE_VVMA_ALL;
+	data.vmid = vmid;
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
+			    KVM_REQ_HFENCE_VVMA_ALL, &data);
 }
 
 int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
 {
 	kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0,
 				       gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT,
-				       PAGE_SHIFT);
+				       PAGE_SHIFT, READ_ONCE(kvm->arch.vmid.vmid));
 	return 0;
 }
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index b17fad091bab..b490ed1428a6 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -96,6 +96,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	unsigned long hmask = cp->a0;
 	unsigned long hbase = cp->a1;
 	unsigned long funcid = cp->a6;
+	unsigned long vmid;
 
 	switch (funcid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
@@ -103,22 +104,22 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
+		vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
 		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
-			kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask);
+			kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask, vmid);
 		else
 			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
-						  cp->a2, cp->a3, PAGE_SHIFT);
+						  cp->a2, cp->a3, PAGE_SHIFT, vmid);
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
+		vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
 		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
-			kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
-						       hbase, hmask, cp->a4);
+			kvm_riscv_hfence_vvma_asid_all(vcpu->kvm, hbase, hmask,
+						       cp->a4, vmid);
 		else
-			kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm,
-						       hbase, hmask,
-						       cp->a2, cp->a3,
-						       PAGE_SHIFT, cp->a4);
+			kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm, hbase, hmask, cp->a2,
+						       cp->a3, PAGE_SHIFT, cp->a4, vmid);
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 8f4c4fa16227..368dfddd23d9 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -23,6 +23,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	struct kvm_cpu_trap *utrap = retdata->utrap;
+	unsigned long vmid;
 
 	switch (cp->a7) {
 	case SBI_EXT_0_1_CONSOLE_GETCHAR:
@@ -78,25 +79,21 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
 			kvm_riscv_fence_i(vcpu->kvm, 0, hmask);
 		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA) {
+			vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
 			if (cp->a1 == 0 && cp->a2 == 0)
-				kvm_riscv_hfence_vvma_all(vcpu->kvm,
-							  0, hmask);
+				kvm_riscv_hfence_vvma_all(vcpu->kvm, 0, hmask, vmid);
 			else
-				kvm_riscv_hfence_vvma_gva(vcpu->kvm,
-							  0, hmask,
-							  cp->a1, cp->a2,
-							  PAGE_SHIFT);
+				kvm_riscv_hfence_vvma_gva(vcpu->kvm, 0, hmask, cp->a1,
+							  cp->a2, PAGE_SHIFT, vmid);
 		} else {
+			vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
 			if (cp->a1 == 0 && cp->a2 == 0)
-				kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
-							       0, hmask,
-							       cp->a3);
+				kvm_riscv_hfence_vvma_asid_all(vcpu->kvm, 0, hmask,
+							       cp->a3, vmid);
 			else
-				kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm,
-							       0, hmask,
-							       cp->a1, cp->a2,
-							       PAGE_SHIFT,
-							       cp->a3);
+				kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm, 0, hmask,
+							       cp->a1, cp->a2, PAGE_SHIFT,
+							       cp->a3, vmid);
 		}
 		break;
 	default:
-- 
2.43.0


