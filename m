Return-Path: <kvm+bounces-44167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE02A9B09B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:22:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E57AC4A46B0
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9AA291167;
	Thu, 24 Apr 2025 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LGaJZa+G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C1928F924
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504060; cv=none; b=Ni2RO0lKyY4H5qKrXf5hl/d4kh8NY2G4wCI12vGbAp4XEi5Y2IOd2cENdq7tGbtKF/q2vYNKZg8q5xB8WrjXNnnyGjkIO7LbBjn4ynCuQ06nVMOYMz8BVdNH6NXdggi+/avtVOKrr5CsN1DvnvA3JbYogmP4NwUKEB8zMuSOgsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504060; c=relaxed/simple;
	bh=NPLvNPRTGZlQyPSKuchNVhThznQp0bCS99QwrEGsnQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VHfoDvkuSMr5Ap3Gv0byroUK4dgHH+o2Gx9clSSlDGcZpE0L9sy7G/RoixmbI5iIdLa8yhsdP4VYmRULYe+NO6D3WclxBXdpl5ru5PUQUzSlPsUdzi1+lzFujmzZcvXiaBjPUT4brS6Yx//oa6SIhB1yi09ONLZHJGMyi+ecZ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LGaJZa+G; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43ea40a6e98so10390015e9.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504056; x=1746108856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LhbI7ata+xuMo4MQ3LDVVCBYF7iuDckOVgkFelFFVk=;
        b=LGaJZa+Gqb1A6S6wHwdOIGAHjxh7A1/kh4PeILy9RALRqV113f7vzYy1odu2l7vDad
         EGO/7UIQ+8a/vpk9fqX4WLk9mgwDX8Iqcgh5Po46E6eTHRQqJi+ePdSBD97nvLHLh2lV
         +ayjuxpSwfFQuHTTzrZACtNRtbsOMvO7svd1tlUGmopAuMl7qbpMEZxhTvCGdqVdatIC
         ZumxSbQ7yTOs0+CipPSOO+VKWmdUw3/IaxRWuKiox9SJWFDazZyqw5SujqsRLLpGx54c
         5yS0QvcZM5+Ac8QSB3TW3YT/3YhvunOXPS3Php1i2WecpS6diPIMdBBEQPF2Oj71erem
         0cNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504056; x=1746108856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2LhbI7ata+xuMo4MQ3LDVVCBYF7iuDckOVgkFelFFVk=;
        b=gsUWua6sIjG+frSW53UXS2ZtFDejwKth+qL2td7ltnwuyIycFG+undI2bm9sb/GFJ6
         MjfhBbA9WByrz1VnGCH9mixJP0c/bQI24Htzvi1q7gautIv+i3J1fMQ0G5RHixAMu9/K
         Th9rX1l3vqrtr7gxiKELmfTLGd9f/YLNjyBUcjiuvCUTTM91VEC778eN5Hw6xuGK+at0
         ABbzGeCQHRHRRxbNl7pFXzKoax/JRd95mPuC8ChFMF92CHsZjLT0AAilW85e5+KKHW7w
         NfGE5gOGGkUxBq17ScmvwUtwDoZOaJxsCvBJaIFa0fDELNAJA0DoAhgM2ZMl/zwRkpCV
         A3ow==
X-Forwarded-Encrypted: i=1; AJvYcCWn2IcVYxqy7DWC9Kt80RFf3P/n8Xclh1h0bN1CFE1fmQw7kpOtHUZHiRxnRuARHoEYNoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjgcZ/tEa2azB+DQ9Sdbd3mSPulH8MuUHy4GFTll42qtkcyfvp
	56lnrseQR+Gv3p6P0dfi+rB5sSlDStUAHamnCSDNghPd/ewiUYtCOdE29DU7hK0=
X-Gm-Gg: ASbGncuYoHDIDvQPcTxY5q6ma2+hO1IBNmMO88F3kL8N6f+8IGE6tt3+2OtKy1hCMbI
	dgYOTgbUzo601QpksJAHP5C+y4fhzmgY10MpW6dU1QK7vgAWECaAru0hCQB5rnfyOerXJFY04lc
	N1nwJxGKoKSqbmvRxFgmtDgTaW306aDFD9v1yQ4DLpUzHQpXUiRLokzpoyc4l4jJ7lNnqTMzZvr
	VX757PrK7RqwaWV97W2cXj97j4vVSYCkn01uIPTYx7YVD++nAg8Kc5wjw6hb3dBo8hQnDWZXvWK
	0zLEF5C9a1048Vg9/GnnWaEndQGfvFyEaYxW8iehPXh2hjl15k4ahfDF1WW8L268be9vC4xQkR4
	ZbgYn4RjQp7TLrLQk
X-Google-Smtp-Source: AGHT+IHqcrFkop2AMczZB7InA+Ahpw3ClIzGk7Xop+jnijaBOC/Y4QzTBvOvzogG1ZcwEVc5x1XCjQ==
X-Received: by 2002:a05:600c:8106:b0:440:6852:5b31 with SMTP id 5b1f17b1804b1-4409bd0d902mr31333525e9.10.1745504055954;
        Thu, 24 Apr 2025 07:14:15 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:15 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 23/34] gunyah: Add interfaces to map memory into guest address space
Date: Thu, 24 Apr 2025 15:13:30 +0100
Message-Id: <20250424141341.841734-24-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

This patch is a subset of [1], without gunyah guest-memfd parts.
I added the original commit message below.

[1] https://lore.kernel.org/lkml/20240222-gunyah-v17-20-1e9da6763d38@quicinc.com/
---
 arch/arm64/kvm/gunyah.c | 212 +++++++++++++++++++++++++++++++++++++++-
 include/linux/gunyah.h  |   6 ++
 2 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index e066482c2e71..5d18d133df50 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -10,8 +10,8 @@
 #include <linux/cpumask.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm_irqfd.h>
-#include <asm/kvm_mmu.h>
 #include <linux/perf_event.h>
+#include <asm/kvm_mmu.h>
 
 #include <linux/gunyah_rsc_mgr.h>
 #include <linux/gunyah.h>
@@ -19,6 +19,15 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "gunyah: " fmt
 
+#define GUNYAH_VM_ADDRSPACE_LABEL			0
+#define GUNYAH_VM_MEM_EXTENT_GUEST_PRIVATE_LABEL	0
+#define GUNYAH_VM_MEM_EXTENT_HOST_SHARED_LABEL		1
+#define GUNYAH_VM_MEM_EXTENT_GUEST_SHARED_LABEL		3
+#define GUNYAH_VM_MEM_EXTENT_HOST_PRIVATE_LABEL		2
+
+#define WRITE_TAG (1 << 0)
+#define SHARE_TAG (1 << 1)
+
 static int gunyah_vm_start(struct gunyah_vm *ghvm);
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
@@ -332,6 +341,23 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	}
 }
 
+static bool gunyah_vm_resource_ticket_populate_noop(
+	struct gunyah_vm_resource_ticket *ticket, struct gunyah_resource *ghrsc)
+{
+	return true;
+}
+static void gunyah_vm_resource_ticket_unpopulate_noop(
+	struct gunyah_vm_resource_ticket *ticket, struct gunyah_resource *ghrsc)
+{
+}
+
+static inline struct gunyah_resource *
+__first_resource(struct gunyah_vm_resource_ticket *ticket)
+{
+	return list_first_entry_or_null(&ticket->resources,
+					struct gunyah_resource, list);
+}
+
 static int gunyah_vm_add_resource_ticket(struct gunyah_vm *ghvm,
 				  struct gunyah_vm_resource_ticket *ticket)
 {
@@ -430,6 +456,159 @@ static void gunyah_vm_clean_resources(struct gunyah_vm *ghvm)
 	mutex_unlock(&ghvm->resources_lock);
 }
 
+static inline u32 donate_flags(bool share)
+{
+	if (share)
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_TO_SIBLING);
+	else
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_TO_PROTECTED);
+}
+
+static inline u32 reclaim_flags(bool share)
+{
+	if (share)
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_TO_SIBLING);
+	else
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_FROM_PROTECTED);
+}
+
+static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
+		struct folio *folio, gfn_t gfn, bool share, bool write)
+{
+	struct gunyah_resource *guest_extent, *host_extent, *addrspace;
+	u32 map_flags = BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PARTIAL);
+	u64 extent_attrs;
+	gfn_t gpa = gfn_to_gpa(gfn);
+	phys_addr_t pa = PFN_PHYS(folio_pfn(folio));
+	enum gunyah_pagetable_access access;
+	size_t size = folio_size(folio);
+	enum gunyah_error gunyah_error;
+	unsigned long tag = 0;
+	int ret;
+
+	if (share) {
+		guest_extent = __first_resource(&ghvm->guest_shared_extent_ticket);
+		host_extent = __first_resource(&ghvm->host_shared_extent_ticket);
+	} else {
+		guest_extent = __first_resource(&ghvm->guest_private_extent_ticket);
+		host_extent = __first_resource(&ghvm->host_private_extent_ticket);
+	}
+	addrspace = __first_resource(&ghvm->addrspace_ticket);
+
+	if (!addrspace || !guest_extent || !host_extent)
+		return -ENODEV;
+
+	if (share) {
+		map_flags |= BIT(GUNYAH_ADDRSPACE_MAP_FLAG_VMMIO);
+		tag |= SHARE_TAG;
+	} else {
+		map_flags |= BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PRIVATE);
+	}
+
+	if (write)
+		tag |= WRITE_TAG;
+
+	if (share && write)
+		access = GUNYAH_PAGETABLE_ACCESS_RW;
+	else if (share && !write)
+		access = GUNYAH_PAGETABLE_ACCESS_R;
+	else if (!share && write)
+		access = GUNYAH_PAGETABLE_ACCESS_RWX;
+	else /* !share && !write */
+		access = GUNYAH_PAGETABLE_ACCESS_RX;
+
+	gunyah_error = gunyah_hypercall_memextent_donate(donate_flags(share),
+							 host_extent->capid,
+							 guest_extent->capid,
+							 pa, size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err("Failed to donate memory for guest address 0x%016llx: %d\n",
+		       gpa, gunyah_error);
+		return gunyah_error_remap(gunyah_error);
+	}
+
+	extent_attrs =
+		FIELD_PREP_CONST(GUNYAH_MEMEXTENT_MAPPING_TYPE,
+				 ARCH_GUNYAH_DEFAULT_MEMTYPE) |
+		FIELD_PREP(GUNYAH_MEMEXTENT_MAPPING_USER_ACCESS, access) |
+		FIELD_PREP(GUNYAH_MEMEXTENT_MAPPING_KERNEL_ACCESS, access);
+	gunyah_error = gunyah_hypercall_addrspace_map(addrspace->capid,
+						      guest_extent->capid, gpa,
+						      extent_attrs, map_flags,
+						      pa, size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err("Failed to map guest address 0x%016llx: %d\n", gpa,
+		       gunyah_error);
+		ret = gunyah_error_remap(gunyah_error);
+		goto memextent_reclaim;
+	}
+
+	return 0;
+memextent_reclaim:
+	gunyah_error = gunyah_hypercall_memextent_donate(reclaim_flags(share),
+							 guest_extent->capid,
+							 host_extent->capid, pa,
+							 size);
+	if (gunyah_error != GUNYAH_ERROR_OK)
+		pr_err("Failed to reclaim memory donation for guest address 0x%016llx: %d\n",
+		       gpa, gunyah_error);
+	return ret;
+}
+
+static int gunyah_memory_reclaim_folio(struct gunyah_vm *ghvm,
+		struct folio *folio, gfn_t gfn, bool share)
+{
+	u32 map_flags = BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PARTIAL);
+	struct gunyah_resource *guest_extent, *host_extent, *addrspace;
+	enum gunyah_error gunyah_error;
+	phys_addr_t pa;
+	size_t size;
+	int ret;
+
+	addrspace = __first_resource(&ghvm->addrspace_ticket);
+	if (!addrspace)
+		return -ENODEV;
+
+	guest_extent = __first_resource(&ghvm->guest_private_extent_ticket);
+	host_extent = __first_resource(&ghvm->host_private_extent_ticket);
+	map_flags |= BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PRIVATE);
+
+	pa = PFN_PHYS(folio_pfn(folio));
+	size = folio_size(folio);
+
+	gunyah_error = gunyah_hypercall_addrspace_unmap(addrspace->capid,
+							guest_extent->capid,
+							gfn_to_gpa(gfn),
+							map_flags, pa, size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err_ratelimited(
+			"Failed to unmap guest address 0x%016llx: %d\n",
+			gfn_to_gpa(gfn), gunyah_error);
+		ret = gunyah_error_remap(gunyah_error);
+		goto err;
+	}
+
+	gunyah_error = gunyah_hypercall_memextent_donate(reclaim_flags(share),
+							 guest_extent->capid,
+							 host_extent->capid, pa,
+							 size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err_ratelimited(
+			"Failed to reclaim memory donation for guest address 0x%016llx: %d\n",
+			gfn_to_gpa(gfn), gunyah_error);
+		ret = gunyah_error_remap(gunyah_error);
+		goto err;
+	}
+
+	return 0;
+err:
+	return ret;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -1357,6 +1536,17 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 	return ret;
 }
 
+static inline void setup_extent_ticket(struct gunyah_vm *ghvm,
+				       struct gunyah_vm_resource_ticket *ticket,
+				       u32 label)
+{
+	ticket->resource_type = GUNYAH_RESOURCE_TYPE_MEM_EXTENT;
+	ticket->label = label;
+	ticket->populate = gunyah_vm_resource_ticket_populate_noop;
+	ticket->unpopulate = gunyah_vm_resource_ticket_unpopulate_noop;
+	gunyah_vm_add_resource_ticket(ghvm, ticket);
+}
+
 static struct gunyah_vm *gunyah_vm_alloc(struct gunyah_rm *rm)
 {
 	struct gunyah_vm *ghvm;
@@ -1375,6 +1565,20 @@ static struct gunyah_vm *gunyah_vm_alloc(struct gunyah_rm *rm)
 	INIT_LIST_HEAD(&ghvm->resources);
 	INIT_LIST_HEAD(&ghvm->resource_tickets);
 
+	ghvm->addrspace_ticket.resource_type = GUNYAH_RESOURCE_TYPE_ADDR_SPACE;
+	ghvm->addrspace_ticket.label = GUNYAH_VM_ADDRSPACE_LABEL;
+	ghvm->addrspace_ticket.populate = gunyah_vm_resource_ticket_populate_noop;
+	ghvm->addrspace_ticket.unpopulate = gunyah_vm_resource_ticket_unpopulate_noop;
+	gunyah_vm_add_resource_ticket(ghvm, &ghvm->addrspace_ticket);
+
+	setup_extent_ticket(ghvm, &ghvm->host_private_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_HOST_PRIVATE_LABEL);
+	setup_extent_ticket(ghvm, &ghvm->host_shared_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_HOST_SHARED_LABEL);
+	setup_extent_ticket(ghvm, &ghvm->guest_private_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_GUEST_PRIVATE_LABEL);
+	setup_extent_ticket(ghvm, &ghvm->guest_shared_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_GUEST_SHARED_LABEL);
 	return ghvm;
 }
 
@@ -1389,6 +1593,12 @@ static void gunyah_destroy_vm(struct gunyah_vm *ghvm)
 	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_RUNNING)
 		gunyah_vm_stop(ghvm);
 
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->addrspace_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_shared_extent_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_private_extent_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->guest_shared_extent_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->guest_private_extent_ticket);
+
 	gunyah_vm_clean_resources(ghvm);
 
 	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_EXITED ||
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 2648d3a623de..d1048d0fc246 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 
+#include <asm/gunyah.h>
 #include <linux/gunyah_rsc_mgr.h>
 
 #define gunyah_vcpu(kvm_vcpu_ptr) \
@@ -107,6 +108,11 @@ struct gunyah_vm {
 	struct list_head resources;
 	struct list_head resource_tickets;
 	enum gunyah_rm_vm_auth_mechanism auth;
+	struct gunyah_vm_resource_ticket addrspace_ticket;
+	struct gunyah_vm_resource_ticket host_private_extent_ticket;
+	struct gunyah_vm_resource_ticket host_shared_extent_ticket;
+	struct gunyah_vm_resource_ticket guest_private_extent_ticket;
+	struct gunyah_vm_resource_ticket guest_shared_extent_ticket;
 };
 
 /**
-- 
2.39.5


