Return-Path: <kvm+bounces-58279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01EEEB8B8D2
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93BBC16EF80
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1235E32951B;
	Fri, 19 Sep 2025 22:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ERmfosvB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D88F328960
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321278; cv=none; b=WfiIpm7t/HrYO4+Ajk44czh7ZJXHC8lHoijfN8Ck052Sk0JI7YWw2gAWJw2BF4NZyElfls7w9QNVUufaKiLsXsPJjBwBxzdUj0siPBGg5O4kuIsEHgOldmlvmh/eDapVFvVoIBFIk1Ij+V2cflODiXXGMDWUvFBwSQMUSmPRv3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321278; c=relaxed/simple;
	bh=1fL7wRWEPZHd8pnmUHNV19lmd4QIuene6PbtmX/XRSM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nwghkbyui1WuEtWbIVmYe/5eMvJ+OivdNqlCqTQUKR5MI2k7vhGbHWl8Z0IrSqGBteSgvuxyrb7hAyZtktZN0+Qun6rd2zAX+WvUW6VmA6sqPwtDjvzCjAG+sntdlWVopQ6KbSdkFxlrOV9ZG69gW/FT/bxdADTWSlaYIFTdev8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ERmfosvB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f86568434so1936518a12.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321275; x=1758926075; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JQSH/c/8VdNhmUGrSGxQbnKeu17eb9RfSKjkJ+x4hXo=;
        b=ERmfosvB4+YICvzg8ydLp4lV6iuwkzrTOrJ+9klHoW1bPTuepGEVpzdxXqIYKMrEX0
         r4pXiCcTLYjuEQux16EaAcYTEJdrWcMbsSB0VvEfVlhmUsWdFuOQKIEJAL+8iJMAwns3
         sYSubhV0V1jm8/IldSNTygm26XD7KFENyB+v2QwoCV2M58tK6wKsLf/a46WNh+ujw6a0
         9kP8D1Sn+InQRMxlWeEXVs4/6xFDRe9mvnAVGvccTCBpOLiZAe/jUClgPxty7E8Ogs14
         IguGc1Rw5cdeFeGiEjQRNKPdaLQCZ7lGgLWXUB4lJrIWWOl8XfOXXe+px1SJ8ryToIZv
         jACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321275; x=1758926075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JQSH/c/8VdNhmUGrSGxQbnKeu17eb9RfSKjkJ+x4hXo=;
        b=wpERVt4UB0zPeN82E0UVJDX+8c+11wWkiEaoDG78/cXcgjOcki+w8cTIkWD/b5biYD
         OxnBwzTziMf8t7SlimjGEhvC+/uzrmuLQrT/SXqXkzhr5//wBJVzTO8BEYselOutK/6q
         rsSrnZlTZXz3l2qKkmIaygPbTDrxfvIlY0CCejRGuz6to4Zkph1UOUuB9bhl7XseWL5r
         fVSYdN7n7Ke2jbP6gqSHG6K45z/nywZFebaWcBqCOh4mhs9KglMfA6mePtg3OZY5MYOH
         H3Lxg8kdNI4o2RrzbnUSAm3U7nLRoaEWg+mMnHMOumcxwhTPhvEkiJzofk/r3accwNM9
         hvCA==
X-Gm-Message-State: AOJu0YxJkJACI89iNE/WJH593iUZ8SRN9H6LPW6DNgVlwrjKBcxm/AV8
	mx3Gqq5XLYMRpwt3J16ZkYwkHoHdhdYwWpBoV+wpyuXpNLxiEyX+I2GK9/P3X46WScPNt0kFfxc
	9pEesrg==
X-Google-Smtp-Source: AGHT+IGoYT2HZpEdAlhZx5r/ucYzX6YQNn5sfl4TsQNztPyoD3+rQERQ2+y8rcMk9gZnGPsyJg3CNYiaXsU=
X-Received: from pjbpd9.prod.google.com ([2002:a17:90b:1dc9:b0:31f:b2f:aeed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a127:b0:262:d265:a3c
 with SMTP id adf61e73a8af0-29270bb8175mr7218066637.32.1758321275014; Fri, 19
 Sep 2025 15:34:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:58 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-52-seanjc@google.com>
Subject: [PATCH v16 51/51] KVM: VMX: Make CR4.CET a guest owned bit
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

Make CR4.CET a guest-owned bit under VMX by extending
KVM_POSSIBLE_CR4_GUEST_BITS accordingly.

There's no need to intercept changes to CR4.CET, as it's neither
included in KVM's MMU role bits, nor does KVM specifically care about
the actual value of a (nested) guest's CR4.CET value, beside for
enforcing architectural constraints, i.e. make sure that CR0.WP=1 if
CR4.CET=1.

Intercepting writes to CR4.CET is particularly bad for grsecurity
kernels with KERNEXEC or, even worse, KERNSEAL enabled. These features
heavily make use of read-only kernel objects and use a cpu-local CR0.WP
toggle to override it, when needed. Under a CET-enabled kernel, this
also requires toggling CR4.CET, hence the motivation to make it
guest-owned.

Using the old test from [1] gives the following runtime numbers (perf
stat -r 5 ssdd 10 50000):

* grsec guest on linux-6.16-rc5 + cet patches:
  2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )

* grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
  1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )

Not only does not intercepting CR4.CET make the test run ~35% faster,
it's also more stable with less fluctuation due to fewer VMEXITs.

Therefore, make CR4.CET a guest-owned bit where possible.

This change is VMX-specific, as SVM has no such fine-grained control
register intercept control.

If KVM's assumptions regarding MMU role handling wrt. a guest's CR4.CET
value ever change, the BUILD_BUG_ON()s related to KVM_MMU_CR4_ROLE_BITS
and KVM_POSSIBLE_CR4_GUEST_BITS will catch that early.

Link: https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/ [1]
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 36a8786db291..8ddb01191d6f 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,8 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE \
+	 | X86_CR4_CET)
 
 #define X86_CR0_PDPTR_BITS    (X86_CR0_CD | X86_CR0_NW | X86_CR0_PG)
 #define X86_CR4_TLBFLUSH_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
-- 
2.51.0.470.ga7dc726c21-goog


