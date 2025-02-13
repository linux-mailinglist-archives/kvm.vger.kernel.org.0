Return-Path: <kvm+bounces-38049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7559DA34999
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27C0A1891F8F
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1920F27FE99;
	Thu, 13 Feb 2025 16:16:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E68A27FE89;
	Thu, 13 Feb 2025 16:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463364; cv=none; b=WB1ghibn57Mcyh1XHglGfpBEGX8bftYfy1Q5x3dW5eNLwKS0zulVZd391fzIlPlqQBC/yf7xNusn4j/B/Ltu4HHz21O4HBbaGxkLPa5EbO8uA7rfOZhkRT8r+WmaV9PbvTgveI3b5IbGyIa80mjJh61VdpbNmd83MIXmk7rtSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463364; c=relaxed/simple;
	bh=fm7dyGb5TdfiSHs4Jst3VSCGbNR2UpHjI8A8jPsBiIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbGb9pF+RspngEM9xlpjrHqexMQ4ByPEYWqpZg37fi3lshszi9Y2ScjE4VHWfAbCDL09+H6QyL7XnJlO7VBjxokyP8hKNbJEp0s369uRNjCL1ixKouyL+BToW1yQKGVCJJ4IBAysX+IMje2NqtqA9DI0vTxkqZ6U/4UxHUnIHFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1C7226BA;
	Thu, 13 Feb 2025 08:16:22 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E98453F6A8;
	Thu, 13 Feb 2025 08:15:57 -0800 (PST)
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
Subject: [PATCH v7 18/45] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
Date: Thu, 13 Feb 2025 16:13:58 +0000
Message-ID: <20250213161426.102987-19-steven.price@arm.com>
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

The guest can request that a region of it's protected address space is
switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
RSI_IPA_STATE_SET. This causes a guest exit with the
RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
protected region to unprotected (or back), exiting to the VMM to make
the necessary changes to the guest_memfd and memslot mappings. On the
next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
calls.

The VMM may wish to reject the RIPAS change requested by the guest. For
now it can only do with by no longer scheduling the VCPU as we don't
currently have a usecase for returning that rejection to the guest, but
by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
open for adding a new ioctl in the future for this purpose.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v7: The code was previously split awkwardly between two
other patches.
---
 arch/arm64/kvm/rme.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 507eb4b71bb7..f965869e9ef7 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -624,6 +624,64 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start, u64 size,
 		realm_unmap_private_range(kvm, start, end);
 }
 
+static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
+			       unsigned long start,
+			       unsigned long end,
+			       unsigned long ripas,
+			       unsigned long *top_ipa)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
+	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	unsigned long ipa = start;
+	int ret = 0;
+
+	while (ipa < end) {
+		unsigned long next;
+
+		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+			int walk_level = RMI_RETURN_INDEX(ret);
+			int level = find_map_level(realm, ipa, end);
+
+			/*
+			 * If the RMM walk ended early then more tables are
+			 * needed to reach the required depth to set the RIPAS.
+			 */
+			if (walk_level < level) {
+				ret = realm_create_rtt_levels(realm, ipa,
+							      walk_level,
+							      level,
+							      memcache);
+				/* Retry with RTTs created */
+				if (!ret)
+					continue;
+			} else {
+				ret = -EINVAL;
+			}
+
+			break;
+		} else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
+			WARN(1, "Unexpected error in %s: %#x\n", __func__,
+			     ret);
+			ret = -EINVAL;
+			break;
+		}
+		ipa = next;
+	}
+
+	*top_ipa = ipa;
+
+	if (ripas == RMI_EMPTY && ipa != start)
+		realm_unmap_private_range(kvm, start, ipa);
+
+	return ret;
+}
+
 static int realm_init_ipa_state(struct realm *realm,
 				unsigned long ipa,
 				unsigned long end)
@@ -863,6 +921,32 @@ void kvm_destroy_realm(struct kvm *kvm)
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
+static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long base = rec->run->exit.ripas_base;
+	unsigned long top = rec->run->exit.ripas_top;
+	unsigned long ripas = rec->run->exit.ripas_value;
+	unsigned long top_ipa;
+	int ret;
+
+	do {
+		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		write_lock(&kvm->mmu_lock);
+		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
+		write_unlock(&kvm->mmu_lock);
+
+		if (WARN_RATELIMIT(ret && ret != -ENOMEM,
+				   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
+				   base, top, ripas))
+			break;
+
+		base = top_ipa;
+	} while (top_ipa < top);
+}
+
 int kvm_rec_enter(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -873,6 +957,9 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu)
 		for (int i = 0; i < REC_RUN_GPRS; i++)
 			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
 		break;
+	case RMI_EXIT_RIPAS_CHANGE:
+		kvm_complete_ripas_change(vcpu);
+		break;
 	}
 
 	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
-- 
2.43.0


