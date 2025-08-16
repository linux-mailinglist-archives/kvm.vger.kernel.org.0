Return-Path: <kvm+bounces-54831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A29CB28CBC
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 12:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0330AC37F0
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 10:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566FC290D8B;
	Sat, 16 Aug 2025 10:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gkjHH4fY"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D228D1E32CF;
	Sat, 16 Aug 2025 10:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755339208; cv=none; b=ZpXjh3k2vTqky0VCbHo8erDAlhl2MTWsIKxr8LiNtB1GJ79YXYC8y/7C0Xliar/HBxNt6FBM6bAiIOrClFsviI/QNA99ViIgLOZg5+sx501INeSwFHz10fGxT5ovrdRCIeEFd7o4n3jVF1nOvUastfCFoaEXh7yVJEDALmWKxtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755339208; c=relaxed/simple;
	bh=Uk0cXH8F2Qchs59LmWckrLh9k+2D2InGvd+K6U+WQ5U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIuGwvIYA5mabyVOJ3GQY+AiqvvH5kzqzu45WS7KWYKhttTzQq3yvYGFFCIej/9XnjqUVQDuQcw3hX8dlAQS/smE8cxJqJ4jCAwqyVv8JTg590vg/iXj4C9rKf35g/JgW3NJ0xu79L3cfyAnuHX4vFtSKAoSADAx6UAWnWqbelQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gkjHH4fY; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=IP9zfjZjBpKjNLU5g3/LbX3rTsuu30U8uTB+FpB+6ug=; b=gkjHH4fYvaWJNYnMQ7qBbRspuz
	PxjJdMMo8zATDZZn2isfswT4Yiw3KJVoU6P7oCJfgTgb16lz1ILoUIsriE8lknlcylNmmaqP5kih7
	Au6d42wVejjY5ci7o3NHd5TMKKdjzow5u6MyffpsCa+/pTOJmDGzMRgQbgsizhKJ+7mVkIwVD67DB
	+P70xX8Ase1Q/7pYKsTD6izUqUyie0/VSprsm5aZ/zjFkQUoTs+uKs93W5KLsvGZNXZEVTmert5Nx
	1lcQB0bH8s1j5HOPInlzAZTWZmT8us5+H4qCbQ34Z0bFhc1TNhl6LTA0+3R+SWgZHU4zwiYHVrvHJ
	yINNdFGw==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unDuT-0000000GxZr-1ptl;
	Sat, 16 Aug 2025 10:13:13 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1unDuQ-0000000Asu9-0z7A;
	Sat, 16 Aug 2025 11:13:10 +0100
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
	Colin Percival <cperciva@tarsnap.com>
Subject: [PATCH v2 1/3] KVM: x86: Restore caching of KVM CPUID base
Date: Sat, 16 Aug 2025 11:10:00 +0100
Message-ID: <20250816101308.2594298-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250816101308.2594298-1-dwmw2@infradead.org>
References: <20250816101308.2594298-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

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


