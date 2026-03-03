Return-Path: <kvm+bounces-72478-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AME8AokupmkrLwAAu9opvQ
	(envelope-from <kvm+bounces-72478-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:42:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C371E74DD
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D6A09316C67E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C5737187A;
	Tue,  3 Mar 2026 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfLrPqjp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8B736B05A;
	Tue,  3 Mar 2026 00:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498081; cv=none; b=SP90D3TYg6s+d9jn5V041LqfpYhndYc91WxTA/T7t90zMCZ5YIgPMuo+AEN5ootaYOpKNo8usbuh4MI7utoxEwzYtlLOV3Lj2Cp9QVBnYmx7pTKliQcajexnVO58plfPpG7ORgL5GIMCoQFgmm17CAEChm4ZxpW4Ta/pWWWX0vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498081; c=relaxed/simple;
	bh=95wwBjlq/N/L6+wVJriKShJaYwctfh7q+1J/sfqEdnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPi53/P8i2gP1O7x+RnWUxIT3Ifsg/UzWRHbsxshw3rXMhoJR7WF8Y+KpSxjmZ8yQ+nlkSQEQpN+k22TwUUFl/+mSs8MK236RaA98M+O2bk0MxbCxk6DrmotwSRJ/yeUclW+uHLigUrO6gRXkJQHlQWlrCwwL1kGBrAuwqlJrkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfLrPqjp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F155C2BCAF;
	Tue,  3 Mar 2026 00:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498080;
	bh=95wwBjlq/N/L6+wVJriKShJaYwctfh7q+1J/sfqEdnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfLrPqjpji/7NrxOFl3FYamBPJ03rHL4Rza14X+NkxnjeiXQnKy1e+YmcCGF15Dtu
	 gcFQOgVtvu20b4OSNmEfDL+UB7yBTiDXrzMp7Pd59kxqKlHOkK55AgCbhpXpOdu7S8
	 nK7dk+tEm4Mp7gZV2PfVoPEyTUTR3Ro0cVPHEDHBw1bMwEpkmhTZrGlCwZXr9gJaEr
	 nRjOxjVDEBXN9mROqiFH+bUgYeGcEioeefduEorVghSlt27AWi9OkYdsMdOYgo/kC4
	 3+lT2K9Lpje3pHBFzY0eOA3o+Ecnyl4zwaZ1Wv0FA3sgT3kFAEw5ostdMOvl2c4l2T
	 hlaQTKj90D8sA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v7 23/26] KVM: nSVM: Sanitize TLB_CONTROL field when copying from vmcb12
Date: Tue,  3 Mar 2026 00:34:17 +0000
Message-ID: <20260303003421.2185681-24-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57C371E74DD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72478-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

The APM defines possible values for TLB_CONTROL as 0, 1, 3, and 7 -- all
of which are always allowed for KVM guests as KVM always supports
X86_FEATURE_FLUSHBYASID. Only copy bits 0 to 2 from vmcb12's
TLB_CONTROL, such that no unhandled or reserved bits end up in vmcb02.

Note that TLB_CONTROL in vmcb12 is currently ignored by KVM, as it nukes
the TLB on nested transitions anyway (see
nested_svm_transition_tlb_flush()). However, such sanitization will be
needed once the TODOs there are addressed, and it's minimal churn to add
it now.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/include/asm/svm.h | 2 ++
 arch/x86/kvm/svm/nested.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index c169256c415fb..16cf4f435aebd 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -182,6 +182,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define TLB_CONTROL_FLUSH_ASID 3
 #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
 
+#define TLB_CONTROL_MASK GENMASK(2, 0)
+
 #define ERAP_CONTROL_ALLOW_LARGER_RAP BIT(0)
 #define ERAP_CONTROL_CLEAR_RAP BIT(1)
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2d0c39fad2724..97439d0f5c49c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -496,7 +496,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
 	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
 	to->tsc_offset          = from->tsc_offset;
-	to->tlb_ctl             = from->tlb_ctl;
+	to->tlb_ctl             = from->tlb_ctl & TLB_CONTROL_MASK;
 	to->erap_ctl            = from->erap_ctl;
 	to->int_ctl             = from->int_ctl;
 	to->int_vector          = from->int_vector;
-- 
2.53.0.473.g4a7958ca14-goog


