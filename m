Return-Path: <kvm+bounces-13628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F17C899288
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 02:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9C171F226AD
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 00:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AFF4405;
	Fri,  5 Apr 2024 00:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i48pVJd6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349D5393
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 00:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712276181; cv=none; b=HkoQXTRmbmA5m7biheQgHvhYwg+5dhCLhvAYv1ceh/lrU94FEAntPDSckqhKEYHVIzvamWyhM08Qr9guCQ4NNT9pi7+/FDr/a3RwTGDTK0thgOcHdyM7Ne11q3OoAhl0AuXTGWX9nGyzUDXoYSs3a6sZOdiVQVjWgv80O9I/dZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712276181; c=relaxed/simple;
	bh=aM1o8V3WrHwhFLYeSqPkvHH3Xl1NKFUP8KIumzBOTnY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lxgRIIDBr+QlBC1oK8hbajeGdlstWmQSx7C365c3xuqRpWoRwthy41BxUydNNMhBJjB9gTA+0Nna7BLFaXHVMDmSZl9Z0JhALjgi8wZWnJ8NsQyIDwezuI69MRJ6TjpfjvIU3cQTMQdulV5OqI6SgydXthjb83dqKvDQXaPwObQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i48pVJd6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e0f311af88so11514315ad.3
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 17:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712276178; x=1712880978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79L5pbtJWSgta3i9osQOSsFXBxbQE23Z+3gWm67hRDo=;
        b=i48pVJd6ICfJT67T4bAWD3V9OtsKBf/q7HWEuSxPasLFPuj2l31FT/Ch/S1AGcHdGE
         zk8oHPpYw4g5uUCA/2BnHSI7W786yzpQpt3W0/Hixqzud9LaZ1V7Y0B8VY59XZ4Kn1mz
         C0AhdDXi+dCU7kdl2d2R2bI9dNT24UHqUoMjcBe6MXtrdleQnkDHOWeKAUA7IkcAsFjt
         ockyYbHon6TvdRl2LymAk1QysiC6toVC/uLRot3Y9EI09F1bl1T13xgCZvSIvQTpD0gE
         saVbhAuU7eVo3+de3cfKKVbRW4ug1G2G2+gLyfyEGKgsC2TxpdGu0JUvP6H317eCoh6N
         DHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712276178; x=1712880978;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=79L5pbtJWSgta3i9osQOSsFXBxbQE23Z+3gWm67hRDo=;
        b=DpcUGznsDKFigzs6ib1hKjUX1OoRoR6NyEqcL9seUpuJL3TBP1G8giLX59bzxdlGeS
         UF/rkfD74lZNhHFxeVJ+V26mMYM9ubTYfaOsw+sH2jv7z6s2qpUsvP9dIjrgf00RNOt5
         1KKw5xuQiRrUQ3fuoPdEdlyTLVCf1NcvUF28c1IMqh5aOhK/uF/mvJgDTROFpMXCkqJ0
         s2VlalZcrKA4FpmdEY9tx9O+UoZJQBRYt7dbf5NVsKJ13ZvNhQ8EeZhxjynLtOa6Dbhi
         rCFg0AuJwdvq4eJqpqYKxIbg8Le8yy404gVWsWAVtXZzJ3+cmMfSvIQzPeBfolIOiY8X
         6Dqw==
X-Forwarded-Encrypted: i=1; AJvYcCWEEUqpUIj9wMTH82ZcVi9qhCw/s/MTndcq4tAXK5ZrYvovNBF/dq9ZNDy6KMGQOfPmvu5vEDCvGd9Bt4hg28LUANYC
X-Gm-Message-State: AOJu0YxUw5hM491La1yn3jzovCQrgRgh2DGCH6CWHxSEIXUI6BrhA0jw
	TCr1buNZw/SewX13wYorBkRYS8lMeLmChQnZ9AITudIV0JmEOwS4otnLscTsRAN3cSItVwKpVdf
	6kA==
X-Google-Smtp-Source: AGHT+IHWXsPOnscb4CEpKuycd8/61hU/RKy2B+DMAKLhC7DgRElrsml3mZA4kp0OH4StC/VpkQ8EtOjhAXY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cec3:b0:1e0:b5ef:3993 with SMTP id
 d3-20020a170902cec300b001e0b5ef3993mr44009plg.5.1712276178486; Thu, 04 Apr
 2024 17:16:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Apr 2024 17:16:14 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405001614.924824-1-seanjc@google.com>
Subject: [PATCH] x86/cpufeatures: Add CPUID_LNX_5 to track recently added
 Linux-defined word
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add CPUID_LNX_5 to track cpufeatures' word 21, and add the appropriate
compile-time assert in KVM to prevent direct lookups on the features in
CPUID_LNX_5.  KVM uses X86_FEATURE_* flags to manage guest CPUID, and so
must translate features that are scattered by Linux from the Linux-defined
bit to the hardware-defined bit, i.e. should never try to directly access
scattered features in guest CPUID.

Opportunistically add NR_CPUID_WORDS to enum cpuid_leafs, along with a
compile-time assert in KVM's CPUID infrastructure to ensure that future
additions update cpuid_leafs along with NCAPINTS.

No functional change intended.

Fixes: 7f274e609f3d ("x86/cpufeatures: Add new word for scattered features")
Cc: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeature.h | 2 ++
 arch/x86/kvm/reverse_cpuid.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 42157ddcc09d..686e92d2663e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -33,6 +33,8 @@ enum cpuid_leafs
 	CPUID_7_EDX,
 	CPUID_8000_001F_EAX,
 	CPUID_8000_0021_EAX,
+	CPUID_LNX_5,
+	NR_CPUID_WORDS,
 };
 
 #define X86_CAP_FMT_NUM "%d:%d"
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index aadefcaa9561..58ac8d69c94b 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -102,10 +102,12 @@ static const struct cpuid_reg reverse_cpuid[] = {
  */
 static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
 {
+	BUILD_BUG_ON(NR_CPUID_WORDS != NCAPINTS);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_5);
 	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
 	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
 }

base-commit: c85af715cac0a951eea97393378e84bb49384734
-- 
2.44.0.478.gd926399ef9-goog


