Return-Path: <kvm+bounces-44174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 62268A9B0B8
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB3547A9599
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5EA2957AA;
	Thu, 24 Apr 2025 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c+Nx3rUg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1901B423E
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504068; cv=none; b=D3MY9SfF+RInlqEWqjCmkOBJXsHtW7LmxpOEKk9vS/HWGAYzqUbxXYeZKpJL7nj0ZQJpCcR9ztoDVPHrG6sUWLGBWOtQRHYhefZeELH/nskGHQGpo27ciySMxBLhnkavFGROIl2mBFnj/OnlatlMNaDo6o0kSwtqDpvJEvDAXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504068; c=relaxed/simple;
	bh=4ABx24IRjfvVXtvRhqG0T6gWoZOLeg1qYCJYADA24es=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=shJBScNBVVVy+tE3GjC7P54mciai8j+Hz6ZPB/BIVK3eNFXdJEt+bC7b4cQmVI+EO8OK28pFQgLpd9JCH2zKzYZ3z8Ze9SdJ35Y2mPNyvfXTxvlMGisJmazobZCVOGvDozr6G+ucWT6eFRn7cQIuzQVZLNULihEc3ccFfm9ty3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c+Nx3rUg; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39bf44be22fso820752f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504064; x=1746108864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC4sArz2tKH+wjPmCs+Bj3DeYtgEPbRq63zRADPtWtk=;
        b=c+Nx3rUg6FC30JCuD2Slbwo5+E/SGjmyOKEVkH02gOU9x0Hi+Z9SokAYrM0TCEBD94
         /E8LdTFmJt47WiNqPE9Oo5ak510zj8YatEwCUGn1J39+r9X5CdwHRXD65/AmPorFjMsk
         KllBv+H0VgPpePwNqe8IC76HHXo9/M8QZ1Uatk2bGgwQX7X97snbbuyrkC0YxcAHkPMD
         FE6DAGYZSWu1B1Zn88kvQXvWxfU39uZDxxvq2CL8WDYMU07HBaznbPo1TP2KhyGY4uFg
         1HzllzIWEJAJj3aP8e4tUFZ10cnNsI5v+yd0+BErIupk0hGOT/s2P6OsfIzIg5EFOID4
         /HiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504064; x=1746108864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WC4sArz2tKH+wjPmCs+Bj3DeYtgEPbRq63zRADPtWtk=;
        b=bbz4dGtp7JH13nUIk5s1SRdheBHgLtu6hvBgwc5QWuW0FlcoqeMtsHyFQa8EtrBwba
         R08SVq5GTHjNNH2vr2TA9yS3RP62jkpoZHprqGZjCuGLGoqKa8ZVNQ4Ao5LIH1McAkMs
         FulT7rgpFnyi4N+w7pykrJ/wlIEwlb7GnnlB499DiFAJLYG9KzP9SmWs7/D2kXgxwD1u
         Bxhvpok4AgDe67O+V5tMxr817Wj44N50zwCCsWYRntwe3kISbgsE6AtPgpLTT0TMtSj1
         4NaRR49yUgvBg5XD9dTlMbncrdUk63GsKyjtBwxWDx8UtacHXcBK1k7SJSHCHcrg+e1+
         /BQg==
X-Forwarded-Encrypted: i=1; AJvYcCU6EfvB/Jr4R5KvJ2iESGxBsNeo8Xm0VVpGh7ia+LOl5gpU57lhKQ2dfYami/N8e1hQfqY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPDJ27+d5AjJD2W87rweGJxhyIp4biPOuMRgEwk/ZlBsrdQ9Lz
	FUKhtsV1TCMzyvVTppKP+F7lRibTY/SPKotGeG15CQXyRJ9aAoOxVPZF58cW2JU=
X-Gm-Gg: ASbGnctK/Qw2Zm6JgRzmfU/UWpMkxiisAh2B91XnZjBYl3qz24C72Co/mRR8qH2E+gP
	JViav/h7V+x0ryGqz2CdWLIraaCIQs4J4dnSkvMECyPBp+1wz6tLIRA2gGMS34Qb5Gv2R8FeepG
	DMsYhHzkUA1FvuUai5znntm1IywZTLDdZMDrlYJMU4ymgokzdAGUe6Vq+YXmiXCYaods9zi6XAx
	zJt2tcgbRaPsh3sBVQqs/2ZonHoaIZAhv+KN8SzGx4DxJYuGGMYAc3w4rIZhEt0cZ5+bKVUdoOm
	YaOg8JHrQh/lhF5fbdZ+gFE35e6z8sbMIYR5afNtLS5b710LJH87c4eHyyXmtKWd6iPKnlzymUb
	bnh372YQMNZXyDDcU
X-Google-Smtp-Source: AGHT+IGeGIUXl8vOV0aXlznupMFAAmbzGK8/bha/61z42fQMkuhHsWrpW3uTjHsZlOeGVmwfVkNdPQ==
X-Received: by 2002:a05:6000:18ad:b0:39a:c9ac:cd58 with SMTP id ffacd0b85a97d-3a06cf63742mr2096999f8f.29.1745504063860;
        Thu, 24 Apr 2025 07:14:23 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:23 -0700 (PDT)
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
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 29/34] gunyah: Enable demand paging
Date: Thu, 24 Apr 2025 15:13:36 +0100
Message-Id: <20250424141341.841734-30-karim.manaouil@linaro.org>
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

Tell resource manager to enable demand paging and wire vCPU faults to
provide the backing folio.

When a folio is donated to the guest, PG_private is set on the folio so
that we can recognize it later when taking it back (e.g. to reclaim the
folio when the VM exists).

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 182 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 179 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 687f2beea4e7..e8037d636e8f 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/cpumask.h>
+#include <linux/pagemap.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/perf_event.h>
@@ -476,7 +477,7 @@ static inline u32 reclaim_flags(bool share)
 					GUNYAH_MEMEXTENT_DONATE_FROM_PROTECTED);
 }
 
-static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
+static int __gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
 		struct folio *folio, gfn_t gfn, bool share, bool write)
 {
 	struct gunyah_resource *guest_extent, *host_extent, *addrspace;
@@ -573,7 +574,7 @@ static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
 	return ret;
 }
 
-static int gunyah_memory_reclaim_folio(struct gunyah_vm *ghvm,
+static int gunyah_memory_reclaim_folio_locked(struct gunyah_vm *ghvm,
 		struct folio *folio, gfn_t gfn, bool share)
 {
 	u32 map_flags = BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PARTIAL);
@@ -713,6 +714,144 @@ static int gunyah_reclaim_memory_parcel(struct gunyah_vm *ghvm,
 	return 0;
 }
 
+static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm, gfn_t gfn, bool write)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *memslot;
+	struct page *page;
+	struct folio *folio;
+	int ret;
+
+	/* Gunyah always starts guest address space at 1G */
+	if (gfn < gpa_to_gfn(SZ_1G))
+		return -EINVAL;
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (!memslot)
+		return -ENOENT;
+
+	page = memslot->arch.pages[gfn - memslot->base_gfn];
+	folio = page_folio(page);
+
+	folio_lock(folio);
+	/* Did we race with another vCPU? */
+	if (folio_test_private(folio)) {
+		folio_unlock(folio);
+		return 0;
+	}
+
+	ret = __gunyah_memory_provide_folio(ghvm, folio, gfn, false, true);
+	if (ret) {
+		folio_unlock(folio);
+		return ret;
+	}
+	folio_set_private(folio);
+	folio_unlock(folio);
+
+	return 0;
+}
+
+static int gunyah_reclaim_memory_range(struct gunyah_vm *ghvm, gfn_t start, gfn_t nr)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	gfn_t end = start + nr;
+	int i, ret;
+
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		slots = __kvm_memslots(kvm, i);
+
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
+			struct page **pages, *page;
+			struct folio *folio;
+			unsigned long offset;
+			unsigned long reclaimed = 0;
+
+			slot = iter.slot;
+			pages = slot->arch.pages;
+			for (offset = 0; offset < slot->npages;) {
+				page = pages[offset];
+				folio = page_folio(page);
+				folio_lock(folio);
+				if (folio_test_private(folio)) {
+					ret = gunyah_memory_reclaim_folio_locked(ghvm, folio,
+							slot->base_gfn + offset, false);
+					if (ret) {
+						WARN_ON_ONCE(1);
+						return ret;
+					}
+					folio_clear_private(folio);
+					reclaimed++;
+				}
+				folio_unlock(folio);
+				offset += folio_nr_pages(folio);
+			}
+		}
+	}
+	return 0;
+}
+
+static int gunyah_memory_parcel_to_paged(struct gunyah_vm *ghvm, gfn_t start, gfn_t nr)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *memslot;
+	struct page **pages, *page;
+	struct folio *folio;
+	int i;
+
+	memslot = gfn_to_memslot(kvm, start);
+	if (!memslot)
+		return -ENOENT;
+
+	if (start - memslot->base_gfn < nr)
+		return -EINVAL;
+
+	pages = &memslot->arch.pages[start - memslot->base_gfn];
+
+	for (i = 0; i < nr;) {
+		page = pages[i];
+		folio = page_folio(page);
+		VM_BUG_ON(folio_test_private(folio));
+		folio_set_private(folio);
+		i += folio_nr_pages(folio);
+	}
+
+	return 0;
+}
+
+static int gunyah_start_paging(struct gunyah_vm *ghvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	struct gunyah_rm_mem_entry *entries, *entry;
+	int count = 0;
+	int bkt, ret;
+
+	slots = kvm_memslots(&ghvm->kvm);
+	kvm_for_each_memslot(slot, bkt, slots) {
+		if (slot->base_gfn >= PFN_DOWN(SZ_1G))
+			count++;
+	}
+
+	entries = entry = kcalloc(count, sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	kvm_for_each_memslot(slot, bkt, slots) {
+		if (slot->base_gfn < PFN_DOWN(SZ_1G))
+			continue;
+		entry->phys_addr = cpu_to_le64(gfn_to_gpa(slot->base_gfn));
+		entry->size = cpu_to_le64(gfn_to_gpa(slot->npages));
+		entry++;
+	}
+
+	ret = gunyah_rm_vm_set_demand_paging(ghvm->rm, ghvm->vmid, count, entries);
+	kfree(entries);
+	return ret;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -772,7 +911,14 @@ static int gunyah_handle_page_fault(
 	struct gunyah_vcpu *vcpu,
 	const struct gunyah_hypercall_vcpu_run_resp *vcpu_run_resp)
 {
-	return -EINVAL;
+	u64 addr = vcpu_run_resp->state_data[0];
+	bool write = !!vcpu_run_resp->state_data[1];
+	int ret = 0;
+
+	ret = gunyah_memory_provide_folio(vcpu->ghvm, gpa_to_gfn(addr), write);
+	if (!ret || ret == -EAGAIN)
+		return 0;
+	return ret;
 }
 
 static bool gunyah_kvm_handle_mmio(struct gunyah_vcpu *vcpu,
@@ -1614,6 +1760,28 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 		goto err;
 	}
 
+	ret = gunyah_start_paging(ghvm);
+	if (ret) {
+		pr_warn("Failed to set up demand paging: %d\n", ret);
+		goto err;
+	}
+
+	ret = gunyah_memory_parcel_to_paged(ghvm, ghvm->dtb.parcel_start,
+			ghvm->dtb.parcel_pages);
+	if (ret) {
+		pr_warn("Failed to set up paging for memparcel: %d\n", ret);
+		goto err;
+	}
+
+	ret = gunyah_rm_vm_set_address_layout(
+		ghvm->rm, ghvm->vmid, GUNYAH_RM_RANGE_ID_IMAGE,
+		ghvm->dtb.parcel_start << PAGE_SHIFT,
+		ghvm->dtb.parcel_pages << PAGE_SHIFT);
+	if (ret) {
+		pr_warn("Failed to set location of DTB mem parcel: %d\n", ret);
+		goto err;
+	}
+
 	ret = gunyah_rm_vm_init(ghvm->rm, ghvm->vmid);
 	if (ret) {
 		ghvm->vm_status = GUNYAH_RM_VM_STATUS_INIT_FAILED;
@@ -1719,6 +1887,14 @@ static void gunyah_destroy_vm(struct gunyah_vm *ghvm)
 			pr_err("Failed to reclaim DTB parcel: %d\n", ret);
 	}
 
+	/**
+	 * If this fails, we're going to lose the memory for good and is
+	 * BUG_ON-worthy, but not unrecoverable (we just lose memory).
+	 * This call should always succeed though because the VM is in not
+	 * running and RM will let us reclaim all the memory.
+	 */
+	WARN_ON(gunyah_reclaim_memory_range(ghvm, gpa_to_gfn(SZ_1G), gpa_to_gfn(U64_MAX)));
+
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->addrspace_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_shared_extent_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_private_extent_ticket);
-- 
2.39.5


