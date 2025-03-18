Return-Path: <kvm+bounces-41341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026CFA6652E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01B0E17AF1D
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF24414D2BB;
	Tue, 18 Mar 2025 01:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OvVBJbPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9201D3FC2;
	Tue, 18 Mar 2025 01:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261701; cv=none; b=su3voaj7lV/Tg757FBtgu831Sru5QzyuPy6xpu5Rfoz1cNUFHaCf9cyH8zsa3c4FhqYWhus5bNZbinNZtZnoDyq0yyNXoQYXtytDoNslfWbHXXxB+94RwERXJcyTvNtYDKxzUAy7L6q0rXhD3faU73q7TIkY7aw2thfm+0XibDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261701; c=relaxed/simple;
	bh=pLa7nmBIJgWzueqkPk4AGuMVC9d7jDDRLX/NlIBoDkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rR8dTBbhycszZCaw83CyIea1BYKJjq+5mOl0fANvEved1s9cKkgtbvCHyOkUi1izdy49LkE06M5g7tKdpZMWOx7S6FjlIXl6PQZPK0/Mz7uY0YtKtCTEL/TGwXvKT9ubM5ZuAE5PJb08tQkSmUlwRKVQs6GWOZc8vguu9zz7Br0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OvVBJbPJ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742261699; x=1773797699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pLa7nmBIJgWzueqkPk4AGuMVC9d7jDDRLX/NlIBoDkQ=;
  b=OvVBJbPJkR/m4ylhBtL2MKFUzIzvhfoN0fqjRwqvXSwb9pe9LIp5BmPE
   j+uCrXLtKGg4CZPpJ3veK8ytqshoXxZuwywv7o94awrvQr0vOfYIUoIaz
   z3BVt8SAwj+c0WHXZaH9fb4DT+Npn/jU47z9FQu853rmPsexCUgC1TCTo
   Zit8fAbZvlaNUFZynDHLH+4DEwdL0374LSLDYOYRkkA9wRTaSLOwme6ZP
   ywGSa7VbYTrv3yg+4tXfhsn+Hn8neBoajIWLqfh+eb/8NhqedKD/2zlSU
   E1vzjboSggSA+k2ijgu1Wu8Y7TV0XMW68chqLCG12SzN6Pm4nePz0cUiw
   A==;
X-CSE-ConnectionGUID: Opk93W7WQmq3+K/FC3CCBw==
X-CSE-MsgGUID: xRFtpcyeQla3gHhonYOaow==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="54009598"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="54009598"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:34:59 -0700
X-CSE-ConnectionGUID: P78im2mWSXK+g/BfK4CEXA==
X-CSE-MsgGUID: MOrFEG6sR8iuttfa+EO9kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="127284151"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:34:57 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 5/5] KVM: x86/mmu: Check and free obsolete roots in kvm_mmu_reload()
Date: Tue, 18 Mar 2025 09:33:33 +0800
Message-ID: <20250318013333.5817-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250318013038.5628-1-yan.y.zhao@intel.com>
References: <20250318013038.5628-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check request KVM_REQ_MMU_FREE_OBSOLETE_ROOTS to free obsolete roots in
kvm_mmu_reload() to prevent kvm_mmu_reload() from seeing a stale obsolete
root.

Since kvm_mmu_reload() can be called outside the
vcpu_enter_guest() path (e.g., kvm_arch_vcpu_pre_fault_memory()), it may be
invoked after a root has been marked obsolete and before vcpu_enter_guest()
is invoked to process KVM_REQ_MMU_FREE_OBSOLETE_ROOTS and set root.hpa to
invalid. This causes kvm_mmu_reload() to fail to load a new root, which
can lead to kvm_arch_vcpu_pre_fault_memory() being stuck in the while
loop in kvm_tdp_map_page() since RET_PF_RETRY is always returned due to
is_page_fault_stale().

Keep the existing check of KVM_REQ_MMU_FREE_OBSOLETE_ROOTS in
vcpu_enter_guest() since the cost of kvm_check_request() is negligible,
especially a check that's guarded by kvm_request_pending().

Export symbol of kvm_mmu_free_obsolete_roots() as kvm_mmu_reload() is
inline and may be called outside of kvm.ko.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu.h     | 3 +++
 arch/x86/kvm/mmu/mmu.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 050a0e229a4d..f2b36d32ef40 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -104,6 +104,9 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
+	if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
+		kvm_mmu_free_obsolete_roots(vcpu);
+
 	/*
 	 * Checking root.hpa is sufficient even when KVM has mirror root.
 	 * We can have either:
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 607cbb19ea96..15fd4838e4f2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5802,6 +5802,7 @@ void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
 	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.root_mmu);
 	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.guest_mmu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_free_obsolete_roots);
 
 static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
 				    int *bytes)
-- 
2.43.2


