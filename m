Return-Path: <kvm+bounces-69021-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKRrB1Xzc2ny0AAAu9opvQ
	(envelope-from <kvm+bounces-69021-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:16:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9296A7B132
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67DFC30504C9
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0333A2DCC1C;
	Fri, 23 Jan 2026 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zbHL5iZd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C623826A1B5
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206550; cv=none; b=F+oLcVL8FFVR4qWE7f46mmjePzjDYQ8G/Pu1ip+6V7CQny7Wt4wgtJbmLmmqiHPuUT4l2jYNvEHqMsxCRq3kg8mOjj3yT8J08vA4RXYc/kuMhDqEptmBFMmEHtehLLsj3upbLhLmbB3AsggyA+9/NYNRErJCjpPkNVweToEciFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206550; c=relaxed/simple;
	bh=GcPhUtbSFZCZfML8EMxJfn4YTnBjv127XlcIPdiHxu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qucy5WaV/4vNItbwlMBP1xZ0J1HnEpdFzeYzh2Cl21l6c+YOG7GglhrNafSGVQk6NiA95VGuK0nG3i5swztv2Ltw+aJA4cQz1/KVXmN5R1KOqLt0NcQseGCtWYPisUlFl9tsCIAeA1q75qUnmNC9lJqj4iXoPATuramvmXSrhIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zbHL5iZd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c337cde7e40so1329277a12.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769206548; x=1769811348; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CGdd8BKfTwRMHvUG+hG2z6R5W0TDHrveqU9uM1M3OZY=;
        b=zbHL5iZd3fqHidAh0+LZIy8gpa97f2PNQ/7EluMjVNwPnII6LLn17VDwA2i+Czd5oi
         HFRHBFVK/P1HKQTm5FP1xcZ8ozSLOd4YRgJLwIquqdgzW057XPBFpgTTLbI51/OT3Umb
         EIPuIrAGgLyq9TYBgFvdqcxcA3uTUX+5sGo+WRo7cnQmbWsuMIRMJOQ4gxxp/gs3WV+Y
         xbSMbQdPTUTfFuKXHTWKgnR6HsA6QhMgg0kpbbXUfsriotOfJtZ83bPQt6YC7nZG1yJ7
         Ioq9OPAPKHRWwOYWXP5kKyRMLGsS5NmcykGLycuDuwUve/hpgL9XFDC4FMwAYAehvwWl
         11xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769206548; x=1769811348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CGdd8BKfTwRMHvUG+hG2z6R5W0TDHrveqU9uM1M3OZY=;
        b=SGymnZf79UeuwqpnFTviBesnjqQ5f5qhghsiX40l9eL1M+mlp55LFA3lCq9PdKM0hw
         Wh2ggm1+7f4vJYPm75DOShs/GYKmwhdE04rreBd+WBJA+28lgHb2rmiGL1Kg9o4zzcOg
         7vmchEF6Dl9XQZN9V48JpavCB5uWcCPgd/1SLhAvAJypIK1Dqg2uaJLSsGs0DknGZAA1
         WMMssmax/AsPuVqC69DcSZA2ar0PJPL80UXMwlXJHTySCxVoFD0sDCVLyEVWZeBJGUIv
         3wd09l97VjQVmGZR2fBW3qw1lFVQ0MSR8Sdyk2dWJUUHiyQYNsW4+f6MzOxKuvdWzRQH
         eWug==
X-Gm-Message-State: AOJu0YzAeitsrBQUIt8aGCkg/IJfDZBbF2XV69IZwQgdz8dJf667SCPU
	1UnFLDrWqTUUOGikLNMw7v1fwt7Q0lxKhMXj914EQJ2yZRqIdTK9YvWXxC1m2ODI6PjCR1NyoRJ
	6Yrfzlg==
X-Received: from pgct22.prod.google.com ([2002:a05:6a02:5296:b0:c63:3c6b:9ab6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7284:b0:38d:f80d:1bc0
 with SMTP id adf61e73a8af0-38e6f7f1025mr4952983637.55.1769206548098; Fri, 23
 Jan 2026 14:15:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:15:41 -0800
In-Reply-To: <20260123221542.2498217-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123221542.2498217-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123221542.2498217-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69021-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9296A7B132
X-Rspamd-Action: no action

Add a flag to track when KVM is actively configuring its CPU caps, and
WARN if a cap is set or cleared if KVM isn't in its configuration stage.
Modifying CPU caps after {svm,vmx}_set_cpu_caps() can be fatal to KVM, as
vendor setup code expects the CPU caps to be frozen at that point, e.g.
will do additional configuration based on the caps.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 ++++++++
 arch/x86/kvm/cpuid.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 267e59b405c1..2f01511135c2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -36,6 +36,9 @@
 u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_cpu_caps);
 
+bool kvm_is_configuring_cpu_caps __read_mostly;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_is_configuring_cpu_caps);
+
 struct cpuid_xstate_sizes {
 	u32 eax;
 	u32 ebx;
@@ -830,6 +833,9 @@ void kvm_initialize_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
 
+	WARN_ON_ONCE(kvm_is_configuring_cpu_caps);
+	kvm_is_configuring_cpu_caps = true;
+
 	BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
 		     sizeof(boot_cpu_data.x86_capability));
 
@@ -1305,6 +1311,8 @@ void kvm_finalize_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_IBT);
 		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
 	}
+
+	kvm_is_configuring_cpu_caps = false;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_finalize_cpu_caps);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3b0b4b1adb97..07175dff24d6 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -8,6 +8,8 @@
 #include <uapi/asm/kvm_para.h>
 
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
+extern bool kvm_is_configuring_cpu_caps __read_mostly;
+
 void kvm_initialize_cpu_caps(void);
 void kvm_finalize_cpu_caps(void);
 
@@ -189,6 +191,7 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
+	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
 }
 
@@ -196,6 +199,7 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
+	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
-- 
2.52.0.457.g6b5491de43-goog


