Return-Path: <kvm+bounces-27960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3B49907A1
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 17:35:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7703285BCB
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 15:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792A42216B6;
	Fri,  4 Oct 2024 15:30:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1FD62216A1;
	Fri,  4 Oct 2024 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728055799; cv=none; b=rrNII+QdW0eDZPYEyVlsve8wW91XuYH2Ih9FA0aDVZzjT8I3lvYthM8S6EOwSwdQb83U8CbplMDEiiX69fqf8sEXOG+azC6m+Hp+LCeywvYIuiwrZswcTl1Fwx6u8n2pTvFKemCi0aPvOMamn/ykRKKqiITkPDrFNEFXOghsCwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728055799; c=relaxed/simple;
	bh=udcL4EBBo9JwtJP2o66UEzg0N5WRt3ztfzTXBHqbI4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LIw4jSMpnPbk9u7YtI4B74HVPpcrTwVoHfThSgBtw/Ln/iypsYiuYWVcOURsrjnHdBmhE8PbwTWfZx3AGfpYMXBpjH8YnhxGAp3rAVHeShfoGExYMBtvQ0ntmlEwnMZUt5Dj+XNdA82gwi5fat0Kq97GkxMYJWTGmoCfh3KPHgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC48B1063;
	Fri,  4 Oct 2024 08:30:27 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 078A33F640;
	Fri,  4 Oct 2024 08:29:53 -0700 (PDT)
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
Subject: [PATCH v5 22/43] KVM: arm64: Handle realm VCPU load
Date: Fri,  4 Oct 2024 16:27:43 +0100
Message-Id: <20241004152804.72508-23-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241004152804.72508-1-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When loading a realm VCPU much of the work is handled by the RMM so only
some of the actions are required. Rearrange kvm_arch_vcpu_load()
slightly so we can bail out early for a realm guest.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 273c08bb4a05..00595fa0717d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -660,10 +660,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
-	if (has_vhe())
-		kvm_vcpu_load_vhe(vcpu);
-	kvm_arch_vcpu_load_fp(vcpu);
-	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
@@ -679,6 +675,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vcpu_set_pauth_traps(vcpu);
 
+	/* No additional state needs to be loaded on Realmed VMs */
+	if (vcpu_is_rec(vcpu))
+		return;
+
+	if (has_vhe())
+		kvm_vcpu_load_vhe(vcpu);
+	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_pmu_restore_guest(vcpu);
+
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
 
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
-- 
2.34.1


