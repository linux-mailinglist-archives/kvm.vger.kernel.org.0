Return-Path: <kvm+bounces-72415-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFCeLQkGpmlVJAAAu9opvQ
	(envelope-from <kvm+bounces-72415-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:50:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 205D41E4200
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9112C3674A88
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D41372ED0;
	Mon,  2 Mar 2026 21:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h+CKCzHA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74227372EC1
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772486783; cv=none; b=qLHdtW7BNsNNOwBBHMVnU2UyiGY5QwF/wcC6cKaHa1hglbLGm1yE+nSeblGMXtyP4hqf2FK90ymn8VhT9ai5y42kDZi8E5UQJC5Ql5L0FWOUTHU3uqvuhXMaqKr9eWbNaSKIFflz1hQLfYsBEAf6N2QLYeuX3ItOevRgmRGD1LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772486783; c=relaxed/simple;
	bh=pFUPbp80vEwcgpNceRaPXqwEX3X3g1P/RAB57XGPFBo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RUvJ+r4ftctXJPfor45ASod21uqzIaIxTcMdmqQnZFGgXjDIPQLuB4JvfnEkz3dMy6v3lLf/JzFrHmYhMQbrLIaSnYrPtYbu4inBq+VZh9oEFp1co2ZBkNPk/bcO5gJAr1tznQi2OnKy2awM7cwhF16rgVeNSfURKzBSIqEFaHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h+CKCzHA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae59e057f1so10789435ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 13:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772486782; x=1773091582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6Vn47yZY8dJtLejZL9u/YV0jGur9tGGJ3eXMFAT82o=;
        b=h+CKCzHA8ObibXhHsg9oQC4ZRF3n+IcJQprLDtcf4BRKkoCM4c8ee5w1TPZH+h82Go
         CpMO4GTF30jjc0MpsTN7HuDs96YySdbUdDpO7L3eOAOzHIHwUeZ+wmTAgSLt2VM/JaZo
         3rHcb9NK9v/WS1X9YC5S3zscRrapkuRk+Y2RIZMWi7Ze5RYQeW6fKp4EmMrvhyt3mjF2
         iOjM0Y4PPlFFIwlxxtDi2WAhiN6VvgBEgAP8OGwKQ+osM3JS14InkaOFGPpCclVqBxYC
         l6S9RXloQ68PGQEyE6Ohxq3TytS9J/jr/cstITOy/QWy/7sxkVIDv4LnPGjoYIrmC6Kd
         LcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772486782; x=1773091582;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b6Vn47yZY8dJtLejZL9u/YV0jGur9tGGJ3eXMFAT82o=;
        b=lFwzbNqpgVT3JutGm6dk0lAuI9GUggINN5mMi3EQ7IXQCxGA9ULruPC/4eDVGsK3hX
         r1YFtkauSqzp9q714jof59WIfNgOLNFtGgJAKdhoc+Gmn87MkSiP9GJw8v8yqHg6FiEF
         FAJLCb9KHR4cYgGRTNSkY5yMv7SoD3tpV8xuRnkHsQIhPeWAZrd1QAvrYgDoLMfSkP3j
         +JSZ8bXsawmHQwLeSqr+wiABIwoD4dquXbsOarvoUO9owftcx5CXVnv6ysk1wVylNsP4
         b1MIgtKzhUYiPdDEH3nwHXb+aG5e8xHVcLt96kx2Wt8vokB6AMaExJzOGquAxmvrfLXI
         AWpg==
X-Gm-Message-State: AOJu0Yw2lSuAWOQdaFhZJj6hhL6EEg9aJyILVb53+7xR9WQHYsIyUVNZ
	fBQJNY8y1kLovNjmnzp+1QM3TwVCr9pdGMdOauCD+hw5yfnCbLNPta2AqGYEHu2XR3nbdt9TQWs
	PvK+Vzg==
X-Received: from plfp3.prod.google.com ([2002:a17:902:e743:b0:2a7:6cb8:a982])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:144b:b0:2aa:d671:e613
 with SMTP id d9443c01a7336-2ae2e4b54efmr143178755ad.38.1772486781549; Mon, 02
 Mar 2026 13:26:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  2 Mar 2026 13:26:19 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260302212619.710873-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Immediately fail the build when possible if
 required #define is missing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 205D41E4200
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72415-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Guard usage of the must-be-defined macros in KVM's multi-include headers
with the existing #ifdefs that attempt to alert the developer to a missing
macro, and spit out an explicit #error message if a macro is missing, as
referencing the missing macro completely defeats the purpose of the #ifdef
(the compiler spews a ton of error messages and buries the targeted error
message).

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h     | 10 ++++++----
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  8 +++++---
 arch/x86/kvm/vmx/vmcs_shadow_fields.h  |  5 +++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..3776cf5382a2 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -1,8 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_OPTIONAL)
-BUILD_BUG_ON(1)
-#endif
-
+#if !defined(KVM_X86_OP) || \
+    !defined(KVM_X86_OP_OPTIONAL) || \
+    !defined(KVM_X86_OP_OPTIONAL_RET0)
+#error Missing one or more KVM_X86_OP #defines
+#else
 /*
  * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
  * both DECLARE/DEFINE_STATIC_CALL() invocations and
@@ -148,6 +149,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+#endif
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index f0aa6996811f..d5452b3433b7 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_OPTIONAL)
-BUILD_BUG_ON(1)
-#endif
+#if !defined(KVM_X86_PMU_OP) || \
+    !defined(KVM_X86_PMU_OP_OPTIONAL)
+#error Missing one or more KVM_X86_PMU_OP #defines
+#else
 
 /*
  * KVM_X86_PMU_OP() and KVM_X86_PMU_OP_OPTIONAL() are used to help generate
@@ -26,6 +27,7 @@ KVM_X86_PMU_OP_OPTIONAL(cleanup)
 KVM_X86_PMU_OP_OPTIONAL(write_global_ctrl)
 KVM_X86_PMU_OP(mediated_load)
 KVM_X86_PMU_OP(mediated_put)
+#endif
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index cad128d1657b..67e821c2be6d 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -1,6 +1,6 @@
 #if !defined(SHADOW_FIELD_RO) && !defined(SHADOW_FIELD_RW)
-BUILD_BUG_ON(1)
-#endif
+#error Must #define at least one of SHADOW_FIELD_RO or SHADOW_FIELD_RW
+#else
 
 #ifndef SHADOW_FIELD_RO
 #define SHADOW_FIELD_RO(x, y)
@@ -74,6 +74,7 @@ SHADOW_FIELD_RW(HOST_GS_BASE, host_gs_base)
 /* 64-bit */
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
+#endif
 
 #undef SHADOW_FIELD_RO
 #undef SHADOW_FIELD_RW

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.473.g4a7958ca14-goog


