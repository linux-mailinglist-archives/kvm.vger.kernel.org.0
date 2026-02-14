Return-Path: <kvm+bounces-71085-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AKbGA/Qj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71085-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C13A513AAC7
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1AEA304138F
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3959829AB02;
	Sat, 14 Feb 2026 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XJ/dSDIR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56624285C98
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032436; cv=none; b=O+ogHh7Nv/geABfRQxiQ8ZR7FEEzOFJ9mhhr5IQ7AxkL/vzP4+PcwWhtbTfzZTxv+gXJN+PO63sCllhPAop9JhhVnxN58BTr41dvLAX5fuLYoActyRYDwFUjuR/mPF4VyP+suujCEc9FiLBcAiFFjIjEupdLf+FVnTyhYgM5SN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032436; c=relaxed/simple;
	bh=KxQaeOFTUwNddWWAwysEkVI+6gLN8UxXhcnpjxklb+A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hi6O+cqwXE8uPqVBZymTUfcRrUEIbg5P+n8MZx0RSRUcZyDGqi/H+RdMiUDh4SFeihLMRkxshzA/emTt5XlvdUaffFza9uoV4QECb8Lb/W9mzH6Mcsi6NwIZ+DJaBHkY6xvaOtKNQv8A7Hxf+ZcgD/opVr4XyGEbYnnqHUAoZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XJ/dSDIR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354be486779so4828368a91.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032435; x=1771637235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ncRTKT34NsAmZ158dpqAeNu/HepDjS+oL5Xbl/IP/0E=;
        b=XJ/dSDIRMgLOoGcIeQSSlYDnhpgjRACXRnBQt7SUi8al2r6NZ1t/zPFQRmMPO0VZ5I
         1729pOs24HGlcDrvT820muwdBAXj+ia9yAcXg85xR97KCNYzHpLhtSVFK8+BTS/Q0ocZ
         g+NSpKHhjD7LDS7OU4GXmBgBRW10KxWhRS8N/KHmI2Y77fzD9EyFbM/J4y1K/NuI4usq
         GZg0rurbbY4e8D7D01WrbQNXrqGwyzDEyeuGocOPxQ9KtycIDptP/927gCwE1FfRDKk0
         gtA4f3PNFx37kMmSq9IZ3kUfR373ObgH9U9nRKSGomq6G8KO48PZjq4/eY5d2ybBddm5
         tuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032435; x=1771637235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ncRTKT34NsAmZ158dpqAeNu/HepDjS+oL5Xbl/IP/0E=;
        b=BK8SIMQIh0Ge8xI68SIVZy3zMYgOBmQhFmCbR4/IgDojVlwwveYz1SpQc4mZDLKXRX
         cMwGoWfdgFtxsLeVNdJdz7WAsbCOCXURf8YRv0qj9jCZmfzJYEA6U8JTcRqoZyVu6ado
         72ddt2B/duKNRTWQM2FprghTF/FdpvGYJkYTGGCN7W0ffhgSoZtEOfCkFRRUR5P0OUB0
         B6t/7rHOeLsfxd69Kr04qnGjUhFt5UKHawH9a74O/eVuAsP6Qh6XCSJCKALg14/MTwmY
         Xbhd2h3hhZiaNgfXFAQJ8WnpUYB1KkfLKu/TVuSwxiwI9gDH3n2or7kBWwOV1eZs2V1+
         O6rg==
X-Forwarded-Encrypted: i=1; AJvYcCUqr91ZGPszB8DhlkOp64ihh/lVyYGaP2x9nyo62Rbpvh8WAF5fhJDalRAAbN1fIh3ht3w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6JTUhjaF4CcCbVPl9GYWhCcP1u/bTCv8b0N3tO2aqYGnGFDAG
	IylttoEfUtiggb4kARWWw4uANjpVPzPx5JQT8gqaVKVgb245pvaY5FRq1npqlqzKwi7OJoTiH4I
	mYEj8ew==
X-Received: from pjl16.prod.google.com ([2002:a17:90b:2f90:b0:353:28:3531])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5105:b0:33b:be31:8194
 with SMTP id 98e67ed59e1d1-356aad80906mr3557884a91.34.1771032434676; Fri, 13
 Feb 2026 17:27:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:51 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-6-seanjc@google.com>
Subject: [PATCH v3 05/16] x86/virt: Force-clear X86_FEATURE_VMX if configuring
 root VMCS fails
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71085-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C13A513AAC7
X-Rspamd-Action: no action

If allocating and configuring a root VMCS fails, clear X86_FEATURE_VMX in
all CPUs so that KVM doesn't need to manually check root_vmcs.  As added
bonuses, clearing VMX will reflect that VMX is unusable in /proc/cpuinfo,
and will avoid a futile auto-probe of kvm-intel.ko.

WARN if allocating a root VMCS page fails, e.g. to help users figure out
why VMX is broken in the unlikely scenario something goes sideways during
boot (and because the allocation should succeed unless there's a kernel
bug).  Tweak KVM's error message to suggest checking kernel logs if VMX is
unsupported (in addition to checking BIOS).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  7 ++++---
 arch/x86/virt/hw.c     | 14 ++++++++++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index abd4830f71d8..e767835a4f3a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2927,14 +2927,15 @@ static bool __kvm_is_vmx_supported(void)
 		return false;
 	}
 
-	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
-	    !this_cpu_has(X86_FEATURE_VMX)) {
+	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL)) {
 		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL on CPU %d\n", cpu);
 		return false;
 	}
 
-	if (!per_cpu(root_vmcs, cpu))
+	if (!this_cpu_has(X86_FEATURE_VMX)) {
+		pr_err("VMX not fully enabled on CPU %d.  Check kernel logs and/or BIOS\n", cpu);
 		return false;
+	}
 
 	return true;
 }
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index 56972f594d90..40495872fdfb 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -28,7 +28,7 @@ static __init void x86_vmx_exit(void)
 	}
 }
 
-static __init int x86_vmx_init(void)
+static __init int __x86_vmx_init(void)
 {
 	u64 basic_msr;
 	u32 rev_id;
@@ -56,7 +56,7 @@ static __init int x86_vmx_init(void)
 		struct vmcs *vmcs;
 
 		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-		if (!page) {
+		if (WARN_ON_ONCE(!page)) {
 			x86_vmx_exit();
 			return -ENOMEM;
 		}
@@ -68,6 +68,16 @@ static __init int x86_vmx_init(void)
 
 	return 0;
 }
+
+static __init int x86_vmx_init(void)
+{
+	int r;
+
+	r = __x86_vmx_init();
+	if (r)
+		setup_clear_cpu_cap(X86_FEATURE_VMX);
+	return r;
+}
 #else
 static __init int x86_vmx_init(void) { return -EOPNOTSUPP; }
 #endif
-- 
2.53.0.310.g728cabbaf7-goog


