Return-Path: <kvm+bounces-32672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E51779DB0F0
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA5A8282361
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9717819CC14;
	Thu, 28 Nov 2024 01:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+fbWs1v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C3199EAF
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757710; cv=none; b=H7YWfWwv1u/EMpdFZw2F6Dl5O1K//yqWA0vcj9zzCEdRQNuNmaRPmo6qLxp/lM0w241d06L1dFhQI74ijq7eX1jAwJYg4kej5H2PLr7GJwOJzMkyperkAmgXZul1vUGVRSJVNe3d7flgvIXxCLNvakU3vYMTBSvOnijgmVc8sg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757710; c=relaxed/simple;
	bh=IjugnqL6ZQNQ/DIuDn2cFOEAl0DXrDDZbsV125OySxY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tj7VD6mbAtfDzjgt4wLPPVtD+xw9g/JHcZjCe8NISTwq/3VW6JeHxLM2shcglfAPeO1rtQLewXuBPUJ7mvLVHIEi74rWbhxzOFS8jtYL0UvjKCNmEd8H2AZVzx1BIRARbv9H6jv40WpWWBAnLFJZAAnQaOrpbac38wZdnkCKXAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+fbWs1v; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7251c893b4cso454465b3a.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757709; x=1733362509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w37cfii7duZUi8WZ7tHrDI2rMh9nkiFXWTR2nGRtjs8=;
        b=I+fbWs1vSyUqBdBUhs66v3Xk9thObT6JGQmLrWYWTgeey6NghSzr/AgJesSswdqRpD
         tpMI5uqqxwdP7ViYgNSJQA3Wn8bgUJto7HuGjn8gNp607xziZihGK3ZLoJNdJzc/N53f
         TrrLqiA6mFs0HNHRQfw3HHipp0/mKJBfsMX7/Jqb+3LooWOUKOuIbDeyl8dp9kHAN1b3
         c4KwUH8OuJxHqSeJwOueNdeI9L6kfjfw/c6BGLkIKC46WVzdXLCbgSQEWWXQbtUplMs0
         ha0WCU/MOz0ssWEopPLegbXOOZDEY18oLRUshsPu61HcwlMMTg25JMnFHs3/4EE3Y+sk
         8eEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757709; x=1733362509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w37cfii7duZUi8WZ7tHrDI2rMh9nkiFXWTR2nGRtjs8=;
        b=Tzcrqz23eHL2MuIUS4ylC2s3GepYyM6Pqk3IybpNY/IJpL1DYtwT8xJrJeChuNvuqy
         vPpC0DH89yNGWfTW/zjTsS459LRllmplZCzTbg1uE3uqfsr0RQzxzB9bVmxIvY98kM9h
         voYTwTddW6TjcKXD+qi1x+9bkOXpVYQX345PJ978eKJ7NUMbDwo6JSwweJGE60+CGXZ7
         zyNCqMGf/xXJalpNJNe7LpcK/0/scbEqlEy1n3hZuNC/rSROJPj6sDStjsnlElsjG0vT
         4Vir9/yErkfrLipZ3ctkH1xMUmrXFHC2bPzGzIflNRvrM26EmTiI73SCiEfjD6uzeGfn
         meGA==
X-Gm-Message-State: AOJu0Yxbec2S1NcJwCe4fm51a9ox1Kz9wNSjzucwStTRuBPe8ZAX4HM7
	6d7LcsJKsHs4OL0k1ZMg0QJvflues5ZRjNkeOcD6lh16oz4lR0ZnFVm9Eo+gP3s97kcBev8Btfd
	G2Q==
X-Google-Smtp-Source: AGHT+IHGl1QQks3ar40WLUC+4/XZWej3Jj3cFtuTNS++ehK7wneav6FD4jzw8EYh26NVQsl0JaOaOMUeNXs=
X-Received: from pjboh6.prod.google.com ([2002:a17:90b:3a46:b0:2ea:af4a:4c40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:548f:b0:2ea:b564:4b31
 with SMTP id 98e67ed59e1d1-2ee08eb7ca7mr6568390a91.19.1732757708647; Wed, 27
 Nov 2024 17:35:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:48 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-22-seanjc@google.com>
Subject: [PATCH v3 21/57] KVM: x86: Account for max supported CPUID leaf when
 getting raw host CPUID
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly zero out the feature word in kvm_cpu_caps if the word's
associated CPUID function is greater than the max leaf supported by the
CPU.  For such unsupported functions, Intel CPUs return the output from
the last supported leaf, not all zeros.

Practically speaking, this is likely a benign bug, as KVM uses the raw
host CPUID to mask the kernel's computed capabilities, and the kernel does
perform max leaf checks when populating boot_cpu_data.  The only way KVM's
goof could be problematic is if the kernel force-set a feature in a leaf
that is completely unsupported, _and_ the max supported leaf happened to
return a value with '1' the same bit position.  Which is theoretically
possible, but extremely unlikely.  And even if that did happen, it's
entirely possible that KVM would still provide the correct functionality;
the kernel did set the capability after all.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index bfb81e417bef..c7fb6b764075 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -579,18 +579,37 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
+{
+	struct kvm_cpuid_entry2 entry;
+	u32 base;
+
+	/*
+	 * KVM only supports features defined by Intel (0x0), AMD (0x80000000),
+	 * and Centaur (0xc0000000).  WARN if a feature for new vendor base is
+	 * defined, as this and other code would need to be updated.
+	 */
+	base = cpuid.function & 0xffff0000;
+	if (WARN_ON_ONCE(base && base != 0x80000000 && base != 0xc0000000))
+		return 0;
+
+	if (cpuid_eax(base) < cpuid.function)
+		return 0;
+
+	cpuid_count(cpuid.function, cpuid.index,
+		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
+
+	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
+}
+
 /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
 static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
-	struct kvm_cpuid_entry2 entry;
 
 	reverse_cpuid_check(leaf);
 
-	cpuid_count(cpuid.function, cpuid.index,
-		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
-
-	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
+	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
 }
 
 static __always_inline
-- 
2.47.0.338.g60cca15819-goog


