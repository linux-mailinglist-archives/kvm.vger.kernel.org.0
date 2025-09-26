Return-Path: <kvm+bounces-58864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A113BA36EC
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DA93561163
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0CA2F7443;
	Fri, 26 Sep 2025 11:03:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD0B2F617F;
	Fri, 26 Sep 2025 11:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758884602; cv=none; b=KfOJ/dTfPuo7VN5MO551cryw3J836G6lKLyze9bK/kam9CMiYuCXp9hnDJZR812ZHBbdgzJIADxW0OOREkv6L+qGjMuWWH0/Em4DYJ9RVu+9g+lJbLgAVxk6Rrz9V1GmEfN8ieEiRHrkbKmqdMLjQlW+mSZbfbXo2KsoDfZ1YP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758884602; c=relaxed/simple;
	bh=W5lM2Om5UZeLdIJDQW24L+lk68gNVW2qKZzpzg4jocM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnMGRFNYrKEZ0j1Y8VLrrA77bV+yapkrh3ccevGeExib41+Vzte7l/78WwWXI6qySpT+cZ2K5UEvpnkg7p2Cn4aQhqgngMy/7IQwZ5S3drz1fBdeFou/k8QsVVTN0YiXBuyMnVTxrQzHblYWl9rHCwVZc/WaGaLU2/M58dKHbbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48AC72BCC;
	Fri, 26 Sep 2025 04:03:12 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D58963F66E;
	Fri, 26 Sep 2025 04:03:16 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH 3/5] arm64: RME: Support RMI_EXIT_S2AP_CHANGE
Date: Fri, 26 Sep 2025 12:02:52 +0100
Message-ID: <20250926110254.55449-4-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250926110254.55449-1-steven.price@arm.com>
References: <20250926110254.55449-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the primary plane of a realm wishes to change the access permissions
of memory for the other planes then this causes an exit to the normal
world. KVM then must complete the request using RMI_RTT_SET_S2AP which
may fail if there are missing RTTs. In this case KVM must allocate the
missing RTTs and retry.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h |  3 +++
 arch/arm64/kvm/rme-exit.c        | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/rme.c             | 25 +++++++++++++++++++++----
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index e5c0c8274bf8..934b30a8e607 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -112,6 +112,9 @@ int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
 int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 
 int realm_aux_map(struct kvm_vcpu *vcpu, phys_addr_t ipa);
+int kvm_realm_set_s2ap(struct kvm_vcpu *vcpu,
+		       unsigned long start,
+		       unsigned long end);
 
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
index 04c8af8642af..b7e615f7b3a9 100644
--- a/arch/arm64/kvm/rme-exit.c
+++ b/arch/arm64/kvm/rme-exit.c
@@ -112,6 +112,31 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
 	return -EFAULT;
 }
 
+static int rec_exit_s2ap_change(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long base = rec->run->exit.s2ap_base;
+	unsigned long top = rec->run->exit.s2ap_top;
+	int ret = -EINVAL;
+
+	if (kvm_realm_is_private_address(realm, base) &&
+	    kvm_realm_is_private_address(realm, top)) {
+		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		write_lock(&kvm->mmu_lock);
+		ret = kvm_realm_set_s2ap(vcpu, base, top);
+		write_unlock(&kvm->mmu_lock);
+	}
+
+	WARN_RATELIMIT(ret && ret != -ENOMEM,
+		       "Unable to satisfy SET_S2AP for %#lx - %#lx\n",
+		       base, top);
+
+	return 1;
+}
+
 static int rec_exit_host_call(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -192,6 +217,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		return rec_exit_psci(vcpu);
 	case RMI_EXIT_RIPAS_CHANGE:
 		return rec_exit_ripas_change(vcpu);
+	case RMI_EXIT_S2AP_CHANGE:
+		return rec_exit_s2ap_change(vcpu);
 	case RMI_EXIT_HOST_CALL:
 		return rec_exit_host_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index c420546d26f3..fa39a8393d53 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -1329,6 +1329,7 @@ static int kvm_populate_realm(struct kvm *kvm,
 enum ripas_action {
 	RIPAS_INIT,
 	RIPAS_SET,
+	SET_S2AP,
 };
 
 static int ripas_change(struct kvm *kvm,
@@ -1348,12 +1349,13 @@ static int ripas_change(struct kvm *kvm,
 		rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
 		memcache = &vcpu->arch.mmu_page_cache;
 
-		WARN_ON(action != RIPAS_SET);
+		WARN_ON(action == RIPAS_INIT);
 	} else {
 		WARN_ON(action != RIPAS_INIT);
 	}
 
 	while (ipa < end) {
+		unsigned long rtt_tree_idx = 0;
 		unsigned long next;
 
 		switch (action) {
@@ -1364,21 +1366,27 @@ static int ripas_change(struct kvm *kvm,
 			ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
 						&next);
 			break;
+		case SET_S2AP:
+			ret = rmi_rtt_set_s2ap(rd_phys, rec_phys, ipa, end,
+					       &next, &rtt_tree_idx);
+			break;
 		}
 
 		switch (RMI_RETURN_STATUS(ret)) {
 		case RMI_SUCCESS:
 			ipa = next;
 			break;
-		case RMI_ERROR_RTT: {
+		case RMI_ERROR_RTT:
+		case RMI_ERROR_RTT_AUX: {
 			int err_level = RMI_RETURN_INDEX(ret);
 			int level = find_map_level(realm, ipa, end);
 
 			if (err_level >= level)
 				return -EINVAL;
 
-			ret = realm_create_rtt_levels(realm, ipa, err_level,
-						      level, memcache);
+			ret = realm_create_rtt_aux_levels(realm, ipa, err_level,
+							  level, rtt_tree_idx,
+							  memcache);
 			if (ret)
 				return ret;
 			/* Retry with the RTT levels in place */
@@ -1396,6 +1404,15 @@ static int ripas_change(struct kvm *kvm,
 	return 0;
 }
 
+int kvm_realm_set_s2ap(struct kvm_vcpu *vcpu,
+		       unsigned long start,
+		       unsigned long end)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	return ripas_change(kvm, vcpu, start, end, SET_S2AP, NULL);
+}
+
 static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
 			       unsigned long start,
 			       unsigned long end,
-- 
2.43.0


