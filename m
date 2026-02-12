Return-Path: <kvm+bounces-71008-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EId3KKcnjmngAAEAu9opvQ
	(envelope-from <kvm+bounces-71008-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 20:19:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 179CC130A65
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 20:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 39CE63042D48
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0B43246BB2;
	Thu, 12 Feb 2026 19:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tJaLyO44"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A73239567
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 19:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770923932; cv=none; b=dd/MkNI/26NPGimMLFPi2eXmjGmU4wmfZQELS9SelCQ4GERTGqj5X2a6yK19CQpcyz6afE4MZYGfA27o5ZQY/U/t2Qs4GLwGV9lXVs4gyo681K5XOWpuZOIgNpXrQ9f4uj0yurfX6d3jqHhdeBQxfuLoKp+rRi9CM5YNtckzaEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770923932; c=relaxed/simple;
	bh=Ai3bocC+Bif6h2FHLI9zdNJDBtoDK4uDB38CFcqONXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OFrtuxmasEInM08Ws9zyxRSaX9IavabYQCmmkGSccuYRlbQGx/HMziWSZynF9AV5lncLC9yvOA3hAmPRihCksXEhGe7Y7Iz0Y+WZNVKtEX9DN5DVXc3PxTDdiUUfRF9aO16Sc2CD9z94aMqZ6sOq5qpfPv+pDZFM/v2lxIhG7zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tJaLyO44; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so998225a12.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 11:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770923930; x=1771528730; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zlvdicwj6EnKhUuPuCcNZTyUNSxuDnHvnqeUNhDe2jY=;
        b=tJaLyO44yP45VntcK4hX2xlcdi1HOUA539dewNM0JKlBMWbDzV4inlsjupd9BKDIl1
         44x/Y1ZSMwQwrTNoVuNSasUtfEJK8JYN1NYI9g1FtjUU5n59eT4o/0ncnLul8LJ8sY6J
         tO7z/XPzHneQ8dsvMyQqEtzZtdwagEx32/wMx9lkc9J4aFu7YTIH4cyPwvb4/7FTAlBb
         PJOAlYdGEbeM5nR4ObMW4gtcWzx3PSHCoCdXoy7Uca76C82ZUzTk5Urt9wd/v8E0xy8E
         3yX+MJz7LF3k4+dausgmsXFW54sVSVLt1N00ujgsz08sYeGQQvfd4dwL5p6JqJAcCefc
         XKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770923930; x=1771528730;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zlvdicwj6EnKhUuPuCcNZTyUNSxuDnHvnqeUNhDe2jY=;
        b=RwqpUe8fR8tRbiWfYdBdjpWil3b7NcE0cYwy5LKZLBeKxX335Q5X2iz75Z2AsARFAA
         /2YFggrGVi75pyvtO1cQ20zR6q7VQxNxYWhuXS/QKR1lq/vhZ6Fn/BpJGkrNo8dQ5iHf
         SPxuoT3htScKOTNOcXH3Q8yMt19q4e+b3s8FYc79d0if3pa0yyEXaWgEsHsKanvuuXKf
         KIWaBYdOoZXnkB3lj2AzD7G/DdbhmDWav3TZs6ZuwsBZkg35VDgF5InC+ZqW3a4KyyWY
         h91mL3XnJ5pn7RXXBLCD8pMaB+XBzSVZpVPmESoYTX4ZM+pVCXMRb5IMWqyyZCVKXxjk
         RuSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpbcgG/PrTbn2YkAPZAMTKH5U0OK3+j01KCjHjx9puA5G2VpYUL743UuPt8Lr5lWs77u4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKtLLr/xtsEiKKcOqEzuKyqQDbsKGaWixkxsAty+JnP+izF1B2
	HSH0ugkeFcIRizoK0jr5n6HVVY5QnGe5XMvQJ3dEYHBWK4X88OAiF2hEs96eIn3ufj3S/OSKSFP
	3YCnYNQ==
X-Received: from pjbmr8.prod.google.com ([2002:a17:90b:2388:b0:354:c477:4601])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2687:b0:354:c3a4:3a6
 with SMTP id 98e67ed59e1d1-35692c1f165mr3367108a91.3.1770923930330; Thu, 12
 Feb 2026 11:18:50 -0800 (PST)
Date: Thu, 12 Feb 2026 11:18:49 -0800
In-Reply-To: <b8efb256-8db8-42ed-a4b1-891aa5824251@p183>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <b8efb256-8db8-42ed-a4b1-891aa5824251@p183>
Message-ID: <aY4nmdwiOMZf00DG@google.com>
Subject: Re: [PATCH] kvm: use #error instead of BUILD_BUG_ON
From: Sean Christopherson <seanjc@google.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71008-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 179CC130A65
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Alexey Dobriyan wrote:
> Force preprocessing error instead of expanding BUILD_BUG_ON macro and
> forcing compile error at later stage.

This doesn't actually help in practice though, because KVM still uses the missing
macro and so the output is spammed with a bunch of unhelpful errors.

I'm tempted to just delete the guards since they so rarely have meaning, but
vmcs_shadow_fields.h subtly _needs_ the guard since it will #define the missing
macro (unlikes the ops headers, it only requires one to be defined).

And having a guard for vmcs_shadow_fields.h but not the ops headers would be
weird and confusing, so this?

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 12 Feb 2026 10:48:34 -0800
Subject: [PATCH] KVM: x86: Immediately fail the build when possible if
 required #define is missing

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

