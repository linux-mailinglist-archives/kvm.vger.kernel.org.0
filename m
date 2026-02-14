Return-Path: <kvm+bounces-71090-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGf4NvrPj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71090-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 859EF13AAB9
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4076D30C7764
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8113929B22F;
	Sat, 14 Feb 2026 01:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ODe2sKw8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702E629DB99
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032448; cv=none; b=csEEcwSncOclIhQHGmCCDEjzwabqj6Y8X5IoDfpAi7DPCrIvikq25fuazMKu4ByfNLilTFOGVOjrQYbTDLHIHnZbF1L1MMfMd479uJxoNheaRd8h/AEe9nBeIwSrCqjX2EmdGp1HuZkEUnfEZ1g8oDWI7beUBl0cIf0bl2u4FaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032448; c=relaxed/simple;
	bh=hftPp1cgH316yfhw8k/dPrCnpI6uxskVDDg5/T2D/XQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X4HEX9ZXugZaOKosNv1GCnwXg+OqDP7sp7O6fIBiktu9Yu+inKJo+kpqL6PK+4Q7z6nqLi7WkrZUi2p5wBmrJFqjcMVUvyLx5vM2W21vNSCkkOvYDOwdV9WwfF1NQKDmESLaHE1r2Chg8DborvsnaVaubJy0q1DTf9MswS5P+RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ODe2sKw8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3562370038dso1400517a91.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032444; x=1771637244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=H80q9SD+282s080Ud0tbsBB2WQnuDfalKG9TFAGQvtU=;
        b=ODe2sKw8XoEK7CQYt+oCiLu5mLNoyuVj1bq+LvEAPbVmd7QLJjArvXZ9OHfsTmlrbn
         m7Se4Odc9ibeOBJ6ztQ6uNQXaPXElwac8G4qk/2g1vFwmdd67izJuA0opxTy+94nssVV
         CLNwOsDyI29nKRzGm1kVry8CmORq5gGhQLfXL92CJgKkNry4PSPbVNDDWu2pkh+EzKv/
         cL03Q+MVhTVSH7PymNRyqlR2q/e8EIjhi7uR8TxNQtOyX0Cj03IYxNzjoSJOAxtqIB0f
         9uyqsF+3OT1utCHsc/Kt4RCT7DSJvvMKb/1zcsBtPO89Yo26Z7MXAMfav0bgkNabM/yR
         zCKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032444; x=1771637244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H80q9SD+282s080Ud0tbsBB2WQnuDfalKG9TFAGQvtU=;
        b=WO5HjvGX5QwALDjRb5b3YrJ4yq4wyiDmDYzurMUDpWP22RrKNwZcOOfy8Rm1k6ZEDe
         2+C5d/wZsc5a+b+f9sHv4TyV/McIFqOgtWdNIZmoS5kDDRmhxenxkqI4U4UY2OMO9Wdr
         6t7Px8z6eOs425HN1sTWg7h2IiKdRgtpyY9kscOv0hr4Gy62i6anIqxh39m6/AkrXVvz
         2v1aH2xJCsqnh8Eeu+HAdys+J+55y81kArINzxxuo4PhPP40TSWicIHmJAM6KPEuYiql
         lisa3mPm9NmLWbN3M5V1xJnP2PFZ3etOiP3SyTsbdZq3QZtbc9JDNq4SjZ9EmUHDTPam
         CKQw==
X-Forwarded-Encrypted: i=1; AJvYcCWFM9QMxvJia5Gvl2BPAzfi+8VWPk8mCA88eDNThxpQ37KTJ98vA1V8giFNjMr50z6oNSA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8FD+X7w+YngbI4B2ZjRk16dCPgzUDGIfuif1tmbzaNhUTi0FX
	r2XLiC+mCPe8j1YL2TxUaWv60MRfv7L8z6LalML6P3i6Hwp7ISxxicEMxf2a9MTeas8BDwUQ5SJ
	vv9EJAg==
X-Received: from pgvt5.prod.google.com ([2002:a65:64c5:0:b0:c65:e24e:cef1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:43a5:b0:38e:9cc5:218c
 with SMTP id adf61e73a8af0-3946c8be39amr3465099637.54.1771032443485; Fri, 13
 Feb 2026 17:27:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:56 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-11-seanjc@google.com>
Subject: [PATCH v3 10/16] x86/virt/tdx: Drop the outdated requirement that TDX
 be enabled in IRQ context
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71090-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 859EF13AAB9
X-Rspamd-Action: no action

Remove TDX's outdated requirement that per-CPU enabling be done via IPI
function call, which was a stale artifact leftover from early versions of
the TDX enablement series.  The requirement that IRQs be disabled should
have been dropped as part of the revamped series that relied on a the KVM
rework to enable VMX at module load.

In other words, the kernel's "requirement" was never a requirement at all,
but instead a reflection of how KVM enabled VMX (via IPI callback) when
the TDX subsystem code was merged.

Note, accessing per-CPU information is safe even without disabling IRQs,
as tdx_online_cpu() is invoked via a cpuhp callback, i.e. from a per-CPU
thread.

Link: https://lore.kernel.org/all/ZyJOiPQnBz31qLZ7@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c      | 9 +--------
 arch/x86/virt/vmx/tdx/tdx.c | 4 ----
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0c790eb0bfa6..582469118b79 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3294,17 +3294,10 @@ int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 
 static int tdx_online_cpu(unsigned int cpu)
 {
-	unsigned long flags;
-	int r;
-
 	/* Sanity check CPU is already in post-VMXON */
 	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
 
-	local_irq_save(flags);
-	r = tdx_cpu_enable();
-	local_irq_restore(flags);
-
-	return r;
+	return tdx_cpu_enable();
 }
 
 static int tdx_offline_cpu(unsigned int cpu)
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5ce4ebe99774..dfd82fac0498 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -148,8 +148,6 @@ static int try_init_module_global(void)
  * global initialization SEAMCALL if not done) on local cpu to make this
  * cpu be ready to run any other SEAMCALLs.
  *
- * Always call this function via IPI function calls.
- *
  * Return 0 on success, otherwise errors.
  */
 int tdx_cpu_enable(void)
@@ -160,8 +158,6 @@ int tdx_cpu_enable(void)
 	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
 		return -ENODEV;
 
-	lockdep_assert_irqs_disabled();
-
 	if (__this_cpu_read(tdx_lp_initialized))
 		return 0;
 
-- 
2.53.0.310.g728cabbaf7-goog


