Return-Path: <kvm+bounces-73203-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKbEGdZ8q2lUdgEAu9opvQ
	(envelope-from <kvm+bounces-73203-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:18:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C90ED2294FF
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECA1630C597D
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A672DAFBD;
	Sat,  7 Mar 2026 01:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMOvNERC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0062D7DD2;
	Sat,  7 Mar 2026 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772846189; cv=none; b=ghXtl3mx2Sb9S9IXXxXO3Wt01LuxlmIj6f0/3JrhuM/SxYPGhp8ap88gpyuRg8iAF7M5Qyf911VZDMADIC3/T6v8D+62PbKM3ozzXxq6EK/l8gtY2rOFdkX8mv2h4qTiulzXxn7BsMLmYLhy1TLJMAzGHEHnduAk8EnFR2cnHzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772846189; c=relaxed/simple;
	bh=m8zySj9DBqQy/fDY4oXr5d3p6i7ivV2qeHI61VTnFQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/JpiPPZFMNgNwpI2/fEUZplxumsTuzxc1bdKrHrZtpy/A5lGNCILEk1nqUf0Cv5Y6TBsrASUH4hJPXjsi7OV6N0pDwdsv/ST7CZ/+l7BJ/DaZ2nEXZFDoFfNVLkctYH37mc1/kErbT6KZtctX4BCLhz4hovuWSuyYH04TLOAq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMOvNERC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7BAC19422;
	Sat,  7 Mar 2026 01:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772846189;
	bh=m8zySj9DBqQy/fDY4oXr5d3p6i7ivV2qeHI61VTnFQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMOvNERCh2jK0vh5JSSovVD6XkDSJ21dsnEotI4WjahX0QmaFMrLHl5GeHVyoRC1y
	 bpye2nIKvfIdTUZjPE0uhmnd98f2furc4C2acnk5qJjGjlekWGowTb2W9wsjAga6L3
	 cJODMlVahrEDcIdfj+4QoBWGs70uI2iiU0EGcH/IMYf2zw/bFfwbXA48LwV2yS/ycW
	 VYIvkmhaEdZSf+tMH1dMZWzJrau1u25Sd1B0WTQGSt4aZG6vgBUp2Ys9BD9a8Vg7f/
	 MD+lR05hJoLoxc42uZj3X+bA5JxZvQSxoo1TfavJvwM/70kr7YzsEaJoXJkVy6oJu0
	 fYyeGkdUJPsyA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Venkatesh Srinivas <venkateshs@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 3/3] KVM: SVM: Advertise Translation Cache Extensions to userspace
Date: Sat,  7 Mar 2026 01:16:19 +0000
Message-ID: <20260307011619.2324234-4-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260307011619.2324234-1-yosry@kernel.org>
References: <20260307011619.2324234-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C90ED2294FF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73203-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.982];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[chromium.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
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
advertise it and allow setting EFER.TCE. If a TLB invalidating
instruction is not intercepted, it will behave according to the guest's
setting of EFER.TCE as the value will be loaded on VM-Enter. Otherwise,
KVM's emulation may invalidate more TLB entries, which is perfectly fine
as the CPU is allowed to invalidate more TLB entries that it strictly
needs to.

Advertise X86_FEATURE_TCE to userspace, and allow the guest to set
EFER.TCE if available.

Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/cpuid.c | 1 +
 arch/x86/kvm/x86.c   | 6 ++++++
 2 files changed, 7 insertions(+)

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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b5d48e75b657..f12da9e92475e 100644
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
@@ -10035,6 +10038,9 @@ static void kvm_setup_efer_caps(void)
 
 	if (kvm_cpu_cap_has(X86_FEATURE_AUTOIBRS))
 		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_TCE))
+		kvm_enable_efer_bits(EFER_TCE);
 }
 
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
-- 
2.53.0.473.g4a7958ca14-goog


