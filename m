Return-Path: <kvm+bounces-72968-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WN6DBLUeqmmSLgEAu9opvQ
	(envelope-from <kvm+bounces-72968-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:24:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC4A219C4F
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0EA13082679
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 00:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257B12BE65B;
	Fri,  6 Mar 2026 00:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQSPSU6H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568292BD022;
	Fri,  6 Mar 2026 00:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772756617; cv=none; b=sD2qk+VgEiOR7YjwfbIZG99n4eOoYyxVUwnE/K3N34qkErazNSfVwxX00ESdrQ6/SGIGZKNLLAGwlOu1m7eR0W5P7ENq/3OUUP86SGpLfyGQB/4dZ5ZqlfQgE2hIzobfKbveDtpZLSU8ZK5Gndimj9otN5R7zCLk6TyizrTbXVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772756617; c=relaxed/simple;
	bh=cRHkBp+CT5efR5ErcV7pt0gmyEBfde9vl4OGQ1V/Pxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X3OVwKA8lO8e15uu0+BmsPGESD6jPjITACD3tlH2vmLd3etDlClrd9vR4rWgwj/p0GXi8ZpRP8Jy35DJrtPbvBAAg9jNcAyD5hU++d5Zt1sJm2TMhmY0V1j9zsXPllctyX+TNV9BIWv5ygIyaGJihbNC5HmEouQvgU4A0r3MiGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQSPSU6H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5617C19423;
	Fri,  6 Mar 2026 00:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772756617;
	bh=cRHkBp+CT5efR5ErcV7pt0gmyEBfde9vl4OGQ1V/Pxw=;
	h=From:To:Cc:Subject:Date:From;
	b=kQSPSU6HTrGODJ8T1pI85EqdM0je2GdWx7ZWZLKKCKbqtZh+d/Lnbg2gecRfURCkc
	 aLIjlGBsfycjfpDFueWGsyqvU4iKKL8mMDi4LDmmpH9OjZxdHJNq65NSNO+T3DflCi
	 v6NiDpuX56KakNivUufO9BNlR+IRgW/AizzPYnR26TDh00bhO3nF9ahL5BvcfXScjY
	 smMXSsoh+RPCQXxarMXj77Rfjd6aYmPXStDNxuJr0/jWpGj0lZHNmw+uDYqyVh4LB7
	 SzU3b+FgGC7pjeyW2B5uitsNt96WNNO0LMIzKyfLEpr+rgge76CUYCHS5K8lzWEuyK
	 Z6V1de+M36rUg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Venkatesh Srinivas <venkateshs@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH] KVM: SVM: Propagate Translation Cache Extensions to the guest
Date: Fri,  6 Mar 2026 00:23:27 +0000
Message-ID: <20260306002327.1225504-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5BC4A219C4F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72968-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,chromium.org:email]
X-Rspamd-Action: no action

From: Venkatesh Srinivas <venkateshs@chromium.org>

TCE augments the behavior of TLB invalidating instructions (INVLPG,
INVLPGB, and INVPCID) to only invalidate translations for relevant
intermediate mappings to the address range, rather than ALL intermdiate
translations.

The Linux kernel has been setting EFER.TCE if supported by the CPU since
commit 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions"),
as it may improve performance.

KVM does not need to do anything to virtualize the feature, only
advertise it and allow setting EFER.TCE.  Passthrough X86_FEATURE_TCE to
the guest, and allow the guest to set EFER.TCE if available.

Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 arch/x86/kvm/cpuid.c   | 1 +
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/x86.c     | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fffbf087937d4..4f810f23b1d9b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1112,6 +1112,7 @@ void kvm_initialize_cpu_caps(void)
 		F(XOP),
 		/* SKINIT, WDT, LWP */
 		F(FMA4),
+		F(TCE),
 		F(TBM),
 		F(TOPOEXT),
 		VENDOR_F(PERFCTR_CORE),
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3407deac90bd6..fee1c8cd45973 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5580,6 +5580,9 @@ static __init int svm_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
 		kvm_enable_efer_bits(EFER_AUTOIBRS);
 
+	if (boot_cpu_has(X86_FEATURE_TCE))
+		kvm_enable_efer_bits(EFER_TCE);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 879cdeb6adde2..7336ce1df3f7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1743,6 +1743,9 @@ static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if (efer & EFER_NX && !guest_cpu_cap_has(vcpu, X86_FEATURE_NX))
 		return false;
 
+	if (efer & EFER_TCE && !guest_cpu_cap_has(vcpu, X86_FEATURE_TCE))
+		return false;
+
 	return true;
 
 }

base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
-- 
2.53.0.473.g4a7958ca14-goog


