Return-Path: <kvm+bounces-71705-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNidLBQpnmk7TwQAu9opvQ
	(envelope-from <kvm+bounces-71705-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:41:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5107218D8D3
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8838D30930EB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CBF3B52E9;
	Tue, 24 Feb 2026 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fp2duO4U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320A83AE70F;
	Tue, 24 Feb 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972473; cv=none; b=LH739MLVnC6HCYyCjM/GQXPEKaNhQMRKsfdd4VS3QyUzyGEjcPMUlNs2x86O1MAdKqCFaO0B2OUEjNfKbNhHT6d3ZmN7ARLW3B/6B0Bq1U2dz2HrTDGEjcWPOrMto1RNjXUeRuMURK1yHLbnz4HJ27VlS1905W7o2Aba5h/XqrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972473; c=relaxed/simple;
	bh=RrqiU/db4McrUKSt3VpYR/YqxtlOXYT7mo6zTzAkg7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNdhY6SqHOM//y7j1bHhKR+n0QHwp2qv5afHb+fcvEkK/+5GgB4lgAGAApU/BVbWyOoR/hx33BoD0IUwkmg6ntcxyHjiJGZ8TgM5lgC9/TjOm/gE2iceUczqj6GX0lwYsDr88zvMeGRAr6Y1BJuRA1oGLElAyntW0gIYSDi74Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fp2duO4U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7091C19424;
	Tue, 24 Feb 2026 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972472;
	bh=RrqiU/db4McrUKSt3VpYR/YqxtlOXYT7mo6zTzAkg7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fp2duO4Ukx+HxEjZxHeBSPdyP4r+bgkBknl8mKXsyNsnwEYsCcPbIYa6wkP769x5U
	 pn7R/IvFwVA9m/TKP6nIOmDCXklH225+MwxRyczA4c6dUUbkNDSNJOwr27bef1bwP9
	 c7EoTQnrBToYKrYv7h06w4drdA1f8KTH0hxIUvnuduW0qrseb1u7IPHg8ItDe+Hcr/
	 4yy6UvoybyvkgVSEzNRArShSsNOq8oZnYJY5E0f4Qb5cZv19TjxXtcRu74dbTxd1+y
	 2qdfeJ5FE0/CQBxuPcp08jf4Y/46cg6LUevYjKMg96qNR7x8h1LkH4UBhV+ZhUa2UK
	 UjFujrR+JCaEA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v6 29/31] KVM: nSVM: Sanitize INT/EVENTINJ fields when copying from vmcb12
Date: Tue, 24 Feb 2026 22:34:03 +0000
Message-ID: <20260224223405.3270433-30-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71705-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5107218D8D3
X-Rspamd-Action: no action

Make sure all fields used from vmcb12 in creating the vmcb02 are
sanitized, such that no unhandled or reserved bits end up in the vmcb02.

The following control fields are read from vmcb12 and have bits that are
either reserved or not handled/advertised by KVM: tlb_ctl, int_ctl,
int_state, int_vector, event_inj, misc_ctl, and misc_ctl2.

The following fields do not require any extra sanitizing:
- tlb_ctl: already being sanitized.
- int_ctl: bits from vmcb12 are copied bit-by-bit as needed.
- misc_ctl: only used in consistency checks (particularly NP_ENABLE).
- misc_ctl2: bits from vmcb12 are copied bit-by-bit as needed.

For the remaining fields (int_vector, int_state, and event_inj), make
sure only defined bits are copied from L1's vmcb12 into KVM'cache by
defining appropriate masks where needed.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/include/asm/svm.h | 5 +++++
 arch/x86/kvm/svm/nested.c  | 8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 16cf4f435aebd..bcfeb5e7c0edf 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -224,6 +224,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define X2APIC_MODE_SHIFT 30
 #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
 
+#define SVM_INT_VECTOR_MASK GENMASK(7, 0)
+
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -637,6 +639,9 @@ static inline void __unused_size_checks(void)
 #define SVM_EVTINJ_VALID (1 << 31)
 #define SVM_EVTINJ_VALID_ERR (1 << 11)
 
+#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
+				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)
+
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d7c353ac42d88..6dd31ed2bed5e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -505,18 +505,18 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->tlb_ctl             = from->tlb_ctl & TLB_CONTROL_MASK;
 	to->erap_ctl            = from->erap_ctl;
 	to->int_ctl             = from->int_ctl;
-	to->int_vector          = from->int_vector;
-	to->int_state           = from->int_state;
+	to->int_vector          = from->int_vector & SVM_INT_VECTOR_MASK;
+	to->int_state           = from->int_state & SVM_INTERRUPT_SHADOW_MASK;
 	to->exit_code           = from->exit_code;
 	to->exit_info_1         = from->exit_info_1;
 	to->exit_info_2         = from->exit_info_2;
 	to->exit_int_info       = from->exit_int_info;
 	to->exit_int_info_err   = from->exit_int_info_err;
-	to->event_inj           = from->event_inj;
+	to->event_inj           = from->event_inj & ~SVM_EVTINJ_RESERVED_BITS;
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
-	to->misc_ctl2            = from->misc_ctl2;
+	to->misc_ctl2		= from->misc_ctl2;
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-- 
2.53.0.414.gf7e9f6c205-goog


