Return-Path: <kvm+bounces-28675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0790599B1DE
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 09:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6DCA284C9B
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 07:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DD71487CE;
	Sat, 12 Oct 2024 07:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScQ4aNqo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B0B142900;
	Sat, 12 Oct 2024 07:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728719775; cv=none; b=NeJcv76jsdRY3nPrsZOPAZZRiUGM56aohfzwSczZ5ikvBTvl7QqZP2NX0QI7QMlA2BZxQq98h8wM2f/3pmkvmGWQoQD1fXZDw/HNZyeXwXbAnK5LPEeJNfgU74dUKbnBMIkCGpxJQH9iBPtLtGdsSD7SPK/xqwgYC7qarlsURDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728719775; c=relaxed/simple;
	bh=rRvsmBeBTUCzqKK3se1PbVcX4TxQnKcMtvBQ6wWmjms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbHBI4H+4mO06l0Nq4cs6ALhKB96U3oh5Heo3qUegDg63JCyqWJpL6pX9FSdNX1En9aaEBwN4TyRMcJcckirHSWaSKuNnYPV40I9vgQZKdeAAxKzfvBbDeNjojvYj17Mt94XfC90BCkI4+hvI8HnhimUkmqCIh5gyNLlroF5aYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScQ4aNqo; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728719773; x=1760255773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rRvsmBeBTUCzqKK3se1PbVcX4TxQnKcMtvBQ6wWmjms=;
  b=ScQ4aNqoBBdBYk3MQvVbUpJ8ZcsMdChPnrQMAFydvYFbiEkn0LJ6Vlpe
   mlyMJ5owtsrW0KbPoTxl3vKnAKxpBcbz99fKbgB+LSE8MmfEabeXp3AgO
   tDXsGxbjD4zC3/suXlOnk3XXLaX7KaP/sYKqNp3wwi+m5sd6Zzvmrz5V4
   KJs/xzVpWZ79kSebzeBpXeE3UDm2EJ1TLAaE6FP7hGfeUjyz+qX3doQWf
   tOAxumg0sryidLzQywBlXJXQME4yrYq7PtN1TVNE3DEE9/X0EddOrbNUc
   aoOpoM3HdJC2Pgbww8cf8vhHxOiRCFyx9OgYjw0V3FiwR82CW+YBl8G/O
   g==;
X-CSE-ConnectionGUID: Diol7w/lSC2s92XypXbR8Q==
X-CSE-MsgGUID: A8AKnSTjSrW1hntbP3h1NA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39510294"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="39510294"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:56:10 -0700
X-CSE-ConnectionGUID: gbdsctEqRnuENEGHq2f8sQ==
X-CSE-MsgGUID: BwaPHN5ET2qkteYlClU8uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="82116742"
Received: from ls.amr.corp.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:56:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: Sean Christopherson <seanjc@google.com>,
	chao.gao@intel.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	Nikunj A Dadhania <nikunj@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/2] KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio to change
Date: Sat, 12 Oct 2024 00:55:56 -0700
Message-ID: <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1728719037.git.isaku.yamahata@intel.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add guest_tsc_protected member to struct kvm_arch_vcpu and prohibit
changing TSC offset/multiplier when guest_tsc_protected is true.

Background
X86 confidential computing technology defines protected guest TSC so that
the VMM can't change the TSC offset/multiplier once vCPU is initialized.
The SEV-SNP defines Secure TSC as optional.  TDX mandates it.  The TDX
module determines the TSC offset/multiplier.  The VMM has to retrieve them.

On the other hand, the x86 KVM common logic tries to guess or adjust TSC
offset/multiplier for better guest TSC and TSC interrupt latency at KVM
vCPU creation (kvm_arch_vcpu_postcreate()), vCPU migration over pCPU
(kvm_arch_vcpu_load()), vCPU TSC device attributes
(kvm_arch_tsc_set_attr()) and guest/host writing to TSC or TSC adjust MSR
(kvm_set_msr_common()).

Problem
The current x86 KVM implementation conflicts with protected TSC because the
VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
logic to change/adjust the TSC offset/multiplier somehow.

Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
offset/multiplier, the TSC timer interrupts is injected to the guest at the
wrong time if the KVM TSC offset is different from what the TDX module
determined.

Originally this issue was found by cyclic test of rt-test [1] as the
latency in TDX case is worse than VMX value + TDX SEAMCALL overhead.  It
turned out that the KVM TSC offset is different from what the TDX module
determines.

Solution
The solution is to keep the KVM TSC offset/multiplier the same as the value
of the TDX module somehow.  Possible solutions are as follows.
- Skip the logic
  Ignore (or don't call related functions) the request to change the TSC
  offset/multiplier.
  Pros
  - Logically clean.  This is similar to the guest_protected case.
  Cons
  - Needs to identify the call sites.

- Revert the change at the hooks after TSC adjustment
  x86 KVM defines the vendor hooks when TSC offset/multiplier are
  changed.  The callback can revert the change.
  Pros
  - We don't need to care about the logic to change the TSC
    offset/multiplier.
  Cons:
  - Hacky to revert the KVM x86 common code logic.

Choose the first one.  With this patch series, SEV-SNP secure TSC can be
supported.

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 61b7e9fe5e57..112b8a4f1860 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1036,6 +1036,7 @@ struct kvm_vcpu_arch {
 
 	/* Protected Guests */
 	bool guest_state_protected;
+	bool guest_tsc_protected;
 
 	/*
 	 * Set when PDPTS were loaded directly by the userspace without
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 65d871bb5b35..a6cf4422df28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2587,6 +2587,9 @@ EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_multiplier);
 
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 {
+	if (vcpu->arch.guest_tsc_protected)
+		return;
+
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
 				   vcpu->arch.l1_tsc_offset,
 				   l1_offset);
@@ -2650,6 +2653,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 
 	lockdep_assert_held(&kvm->arch.tsc_write_lock);
 
+	if (vcpu->arch.guest_tsc_protected)
+		return;
+
 	if (user_set_tsc)
 		vcpu->kvm->arch.user_set_tsc = true;
 
@@ -5028,7 +5034,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);
-			vcpu->arch.tsc_catchup = 1;
+			if (!vcpu->arch.guest_tsc_protected)
+				vcpu->arch.tsc_catchup = 1;
 		}
 
 		if (kvm_lapic_hv_timer_in_use(vcpu))
-- 
2.45.2


