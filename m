Return-Path: <kvm+bounces-14164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3522D8A02E6
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8A551F22A19
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D5E1A0AF8;
	Wed, 10 Apr 2024 22:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AxjLXnsR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D149B194C90;
	Wed, 10 Apr 2024 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786881; cv=none; b=NRY6yA2F0ELMBNPJyqDyErwyGux3MH5Fmg6JkvsAHdO9MKqWUB89WXBGgeC2pUz/BBF6byqyXcVGFFfo/L6EOKEbK+i7QjUhsmmvDVh005idVTM4XTpi8rc3gm5IRJJb8j0/2ShvdOYJfPt/iBNsntd/zB0+r6vshULdF9g4/os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786881; c=relaxed/simple;
	bh=ETl8+5bXAMNCbp6iq0APgR1yrZku3CsPb2HTapGc37k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTGFDguRK4agX6bNfPuz2XCOLPGyXX2QVgmcQ9ELl52IQFwiM9d5UTihRHxPPopUbj4nVPGrI85al4kO9AYMIZmMejd9R/DPgKNupeEiXxG9n7lM1BGJLvZvnv1CFEYCSdatiyi0JaEuX7pibhkozZB/jzMfvOHq3nBUIHZfsAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AxjLXnsR; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786880; x=1744322880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ETl8+5bXAMNCbp6iq0APgR1yrZku3CsPb2HTapGc37k=;
  b=AxjLXnsRzgJvK3p6bV+atyo9KW9rQm0abU8hgP6WOGFZJbuNqZvMT+D3
   1cLLn860RorEcdz27ed25jPlSR/6wYUin3iY94QGjsP960NjAKRk82wyV
   Z6JKZCPWIMlWtDrko45EiV5wNEqYdRa3xJ/tdtVRot+DTlYPspUq44u+y
   iSM4oscE1uICsM3k4341vlHJ1oYkeV2tBCU8nH+ZB8V6ECin2ThdTBqnO
   vBMQuNr/mw5/R3z4norW+xVl94I3hfxzDqB/2n8CylhMLu4zadQlguIYH
   CXQ0v+Jab6mvvLXkPzifAO1SzFlK8LE5mSddWbnlGgWOZV9CLa0RNYgzy
   g==;
X-CSE-ConnectionGUID: Jf5yLRruSPOtkjCBBMqBkA==
X-CSE-MsgGUID: 9yXba4t+SjiNZGmoSkr2BQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041148"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041148"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:58 -0700
X-CSE-ConnectionGUID: dWoIIdVpTc+cUhlWEUNQkQ==
X-CSE-MsgGUID: fI8/2sUKQRKuXOH0I/dyrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476323"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:57 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 08/10] KVM: x86: Add a hook in kvm_arch_vcpu_map_memory()
Date: Wed, 10 Apr 2024 15:07:34 -0700
Message-ID: <7194bb75ac25fa98875b7891d7929655ab245205.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a hook in kvm_arch_vcpu_map_memory() for KVM_MAP_MEMORY before calling
kvm_mmu_map_page() to adjust the error code for a page fault.  The hook can
hold vendor-specific logic to make those adjustments and enforce the
restrictions.  SEV and TDX KVM will use the hook.

In the case of SEV and TDX, they need to adjust the KVM page fault error
code or refuse the operation due to their restriction.  TDX requires that
the guest memory population must be before finalizing the VM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Make pre_mmu_map_page() to take error_code.
- Drop post_mmu_map_page().
- Drop struct kvm_memory_map.source check.
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/x86.c                 | 28 ++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5187fcf4b610..a5d4f4d5265d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -139,6 +139,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
+KVM_X86_OP_OPTIONAL(pre_mmu_map_page);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ce244ad44e5..2bf7f97f889b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1812,6 +1812,9 @@ struct kvm_x86_ops {
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	int (*pre_mmu_map_page)(struct kvm_vcpu *vcpu,
+				struct kvm_memory_mapping *mapping,
+				u64 *error_code);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ba9c1720ac9..b76d854701d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5868,6 +5868,26 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+static int kvm_pre_mmu_map_page(struct kvm_vcpu *vcpu,
+				struct kvm_memory_mapping *mapping,
+				u64 *error_code)
+{
+	int r = 0;
+
+	if (vcpu->kvm->arch.vm_type == KVM_X86_DEFAULT_VM) {
+		/* nothing */
+	} else if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM) {
+		if (kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(mapping->base_address)))
+			*error_code |= PFERR_PRIVATE_ACCESS;
+	} else if (kvm_x86_ops.pre_mmu_map_page)
+		r = static_call(kvm_x86_pre_mmu_map_page)(vcpu, mapping,
+							  error_code);
+	else
+		r = -EOPNOTSUPP;
+
+	return r;
+}
+
 int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 			     struct kvm_memory_mapping *mapping)
 {
@@ -5900,6 +5920,14 @@ int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 	/* reload is optimized for repeated call. */
 	kvm_mmu_reload(vcpu);
 
+	/*
+	 * Adjust error_code for VM-type. max_level is adjusted by
+	 * gmem_max_level() callback.
+	 */
+	r = kvm_pre_mmu_map_page(vcpu, mapping, &error_code);
+	if (r)
+		goto out;
+
 	r = kvm_tdp_map_page(vcpu, mapping->base_address, error_code, &level);
 	if (r)
 		goto out;
-- 
2.43.2


