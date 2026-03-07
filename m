Return-Path: <kvm+bounces-73202-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAJBGr58q2lUdgEAu9opvQ
	(envelope-from <kvm+bounces-73202-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:17:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5A12294F8
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BFEF3091367
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6142D9EC4;
	Sat,  7 Mar 2026 01:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mniWdhCX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06F2D3A7C;
	Sat,  7 Mar 2026 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772846189; cv=none; b=MP7CJE6ZIKZkmgDC52Gi6FdP9kbgOJiOlCzrPa4IwLCV7+8uJfUqkH0wh4HTufV89WViAr8fQFu/PW3RO+UMxt5u52uLNMNL6lBP2LnF1+tf0meIgkhghfUtqXHFSRN4iG3H0B2zg0CBIDBwovPw8rVJFN3JRPddgzy9uUrEQeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772846189; c=relaxed/simple;
	bh=pbvDC5cATKYlFj6xqezHC6kl2o6p3pGv/bHyMa5pBz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKMKpDfWBZ9Mpa5B3dAVYGvapLslNOdAxF0WKwue5BGubMnQL9oTkneqPOTibSa53u3ujQENcpJQGPJdwBrI4KJMPIEwBQSMSkXLOrKymcBxGOqmjpNfQsPBHw3xI3QHDyB39UCaRXRKzeihYdnW+xeBXshVxwsyNhteWStrBIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mniWdhCX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B99C4CEF7;
	Sat,  7 Mar 2026 01:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772846189;
	bh=pbvDC5cATKYlFj6xqezHC6kl2o6p3pGv/bHyMa5pBz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mniWdhCXQkUgmTaEFFzoQ1XjD1VCkhplQdY7Tp3Hp3bWPci8WT/Ykg0gIFVUw4yfe
	 cqd+1hBnZ8q42ZhQu9oPtYaePn/JSxwPgPa3CJICfhManPZ2gkq6e6yRqPsApbWd7S
	 iLC5mVUobKMZk7ZbNoQjc7jBDgQfDhZTk0UcozMMauJDI08QA9j9uUlRcXYjAyXeLw
	 rWcWZtFY1nyjb8tgEV5EcYjnCYOSzz1Ytr/pc9aY0ik7PsWkvc3QnQtwMpMezJKFa1
	 dapsMEb4/vxuw+Bel6GyfFAv4ogbWZJuEGuf1xx1sVLIWaUNwk0N72iASF/DnDjTRi
	 gsKMijnNzJzkw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Venkatesh Srinivas <venkateshs@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 2/3] KVM: x86: Use kvm_cpu_cap_has() for EFER bits enablement checks
Date: Sat,  7 Mar 2026 01:16:18 +0000
Message-ID: <20260307011619.2324234-3-yosry@kernel.org>
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
X-Rspamd-Queue-Id: BD5A12294F8
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
	TAGGED_FROM(0.00)[bounces-73202-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.982];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Instead of checking that the hardware supports underlying features for
EFER bits, check if KVM supports them. It is practically the same, but
this removes a subtle dependency on kvm_set_cpu_caps() enabling the
relevant CPUID features.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1aae2bc380d1b..0b5d48e75b657 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10027,13 +10027,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
 
 static void kvm_setup_efer_caps(void)
 {
-	if (boot_cpu_has(X86_FEATURE_NX))
+	if (kvm_cpu_cap_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
-	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
+	if (kvm_cpu_cap_has(X86_FEATURE_FXSR_OPT))
 		kvm_enable_efer_bits(EFER_FFXSR);
 
-	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+	if (kvm_cpu_cap_has(X86_FEATURE_AUTOIBRS))
 		kvm_enable_efer_bits(EFER_AUTOIBRS);
 }
 
-- 
2.53.0.473.g4a7958ca14-goog


