Return-Path: <kvm+bounces-54669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A541B264F0
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 14:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19DBEA047E0
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 12:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CAA2FD1B1;
	Thu, 14 Aug 2025 12:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y9MbNak6"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3B12EBBAC;
	Thu, 14 Aug 2025 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172994; cv=none; b=OpDfXyCCk8CFoDRKK+QhjbMvlZzbzpQFSa5FhsSmZ1+0IkbyArcUPncEXbwZNbmshnM3sgqjkLoKkIwxEeq/cjpYGFmNIjTJXGCj4atp5tFiZjVcto+NLEJ3yg4vChmUBY/Y0Qo/J/8WegHPj7HquLVZXZ8j/j4hi55dbZ//k6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172994; c=relaxed/simple;
	bh=Uk0cXH8F2Qchs59LmWckrLh9k+2D2InGvd+K6U+WQ5U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=no7VveQwtYs+5wgUxGslgurbcGJSgEo2WaiF5Ur2Wl6khB7y/GA4ffG3WZ0TIQMdKlRUiqpkGosQoRUogsaiTV8seJcGujdy3xiA3GihU1zJCJEge31/46OkA3u9Wz/Es2m7T9VDIaERFNWG4uWl7dENPvgyo6uAU1tRust7uns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y9MbNak6; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=IP9zfjZjBpKjNLU5g3/LbX3rTsuu30U8uTB+FpB+6ug=; b=Y9MbNak6vMIQ2x0NWfyt0TLZTu
	+N1fI/uCk5lvS9oV5WhpRWbdacic58afgKvnxwzZs1w1Q6kmMPVgZnnZNxsm4uPDYqK3GnuyW4tTF
	5ldLEoBs7w/hMbCQCwd8Wc3MaY/0i4cFuvpi+ZC5Rig+ZUh/ojVXX3GdRzQEA4xid7Mt1y/oc3r5q
	euQDSfVrNMW/HCDJndAnpErWCZMXx3ejVcFQO28VtAAG14rTuKnkKyxvxmxd3+/tCIlr8FpbLYMWC
	77IAobTCqAMfcF1isLVq2bPPpqnjFRU73Z71uQgVmXbj+IMRufzHWcrVxPIZ3at3iKaf+7MOpuOgS
	IRA66CpQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umWfd-00000000IZv-1LUu;
	Thu, 14 Aug 2025 12:03:02 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1umWfd-0000000AMTj-1ITv;
	Thu, 14 Aug 2025 13:03:01 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	graf@amazon.de,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Alok N Kataria <akataria@vmware.com>
Subject: [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
Date: Thu, 14 Aug 2025 12:56:03 +0100
Message-ID: <20250814120237.2469583-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250814120237.2469583-1-dwmw2@infradead.org>
References: <20250814120237.2469583-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

This mostly reverts commit a5b32718081e ("KVM: x86: Remove unnecessary
caching of KVM's PV CPUID base").

Sure, caching state which might change has certain risks, but KVM
already does cache the CPUID contents, and the whole point of calling
kvm_apply_cpuid_pv_features_quirk() from kvm_vcpu_after_set_cpuid() is
to cache the contents of that leaf too, so that guest_pv_has() can
access them quickly.

An upcoming commit is going to want to use vcpu->arch.kvm_cpuid from
kvm_cpuid() at runtime too, so put it back.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..50febd333f5f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -897,6 +897,7 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
+	struct kvm_hypervisor_cpuid kvm_cpuid;
 	bool cpuid_dynamic_bits_dirty;
 	bool is_amd_compatible;
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..bcce3a75c3f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -178,7 +178,12 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 
 	/*
 	 * Apply runtime CPUID updates to the incoming CPUID entries to avoid
-	 * false positives due mismatches on KVM-owned feature flags.
+	 * false positives due mismatches on KVM-owned feature flags.  Note,
+	 * runtime CPUID updates may consume other CPUID-driven vCPU state,
+	 * e.g. KVM or Xen CPUID bases.  Updating runtime state before full
+	 * CPUID processing is functionally correct only because any change in
+	 * CPUID is disallowed, i.e. using stale data is ok because the below
+	 * checks will reject the change.
 	 *
 	 * Note!  @e2 and @nent track the _old_ CPUID entries!
 	 */
@@ -231,14 +236,14 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
 
 static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
 {
-	struct kvm_hypervisor_cpuid kvm_cpuid;
 	struct kvm_cpuid_entry2 *best;
+	u32 features_leaf = vcpu->arch.kvm_cpuid.base | KVM_CPUID_FEATURES;
 
-	kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
-	if (!kvm_cpuid.base)
+	if (!vcpu->arch.kvm_cpuid.base ||
+	    vcpu->arch.kvm_cpuid.limit < features_leaf)
 		return 0;
 
-	best = kvm_find_cpuid_entry(vcpu, kvm_cpuid.base | KVM_CPUID_FEATURES);
+	best = kvm_find_cpuid_entry(vcpu, features_leaf);
 	if (!best)
 		return 0;
 
@@ -541,6 +546,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	if (r)
 		goto err;
 
+	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
 #ifdef CONFIG_KVM_XEN
 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
 #endif
-- 
2.49.0


