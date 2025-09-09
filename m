Return-Path: <kvm+bounces-57141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E343B50718
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:29:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2909A563B64
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B8B369325;
	Tue,  9 Sep 2025 20:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KcckoLpY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC86C3629A6
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 20:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449726; cv=none; b=spTv2qdUFbBNfNDoRMgzKIL7jAWy5fsPvkdyckfZvvByWPz+gPbbE6eX4pXn9hJGkKluPn9vYHhhPppIfZoAvyoQLqYY5HStKFEFnSsgs1MAXp2VyGdl+kV45shGtZz2UGwI5kKbrn0xnmREjyDOBUgS9mHgBqL3p4Fkq6yOixU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449726; c=relaxed/simple;
	bh=vtdJbK7wreG5s5RioxYrcTeNIZaeOWo9M19O9uJimxs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T4PVwZO692oArdMn1Fg5aY63zXAOus7yA2cIPoeNDyrbucx+FYvoef3IdyEAnxppFwjrHmGjg43bqJHNqDdidVAyFLxgmYCoS2rexSFWmDtz+FtnqKJ7KRk+sz/J1xuNHKjy0TCeWCbs0AJT02tE5vYN8690IDxZqokyIMKMtmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KcckoLpY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24c8264a137so72388075ad.3
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 13:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757449724; x=1758054524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CMiFM11/UgOTiqujCsfr58bBaclwwZCG3bf7Rw+V6nY=;
        b=KcckoLpYDUPBtj1YzWWlCH2w03HGbPWxrGwAWPZRQPaw/AYeEY6SwdzPC+VneTyAPF
         lp/QVrbHRNflioj3BsppEVwieBc6vL0DMXu0ebS2wp9HFf2CsnJiqVoKCoL7Uu+Qowu/
         I2wInPl8IFQux3XoyQN4S7bmgnIOgxb5Pc+epMIHKVyqP2DdMNyi+TNidvckf7eafXJ9
         /0KDc/oAMPJVaiLzrq/gfpT5GJA/YbE+yqPWAirr7NrnMlYVQAMfQefiWf2F6ykyJRc3
         UuhiVSEeD4HBDHDdnz5qMgBFh1ibDg/7IjwzkexVhkK4askRtGrAqiwXxTJMXVOn8/6y
         5WIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757449724; x=1758054524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CMiFM11/UgOTiqujCsfr58bBaclwwZCG3bf7Rw+V6nY=;
        b=riRZIuL/rGmuvi0fQeExy2c70dNuzz+6ZS5c0p1SOrVPQ9DaAiCC+pQpRuTuYubsNG
         60v9nJVz7BZL8jqKEmEO3n7rX1vphy6Y3nPpLhB9r5d1avQ3S2UMuS1fyv7v7n46sAj9
         r25Ikb5rcqm74NyjfmS8UkTnNKv3TT+VVUrBAd2q7tQhMptzWD7nwCCTpP8darPkDyWe
         88C1WzfGrcMypFxgjMksvamCWRRHWPKduG+wUISQ0m4eK1ik4Ebw8/n2iPrhfRanz0oc
         A0RRMa+IIDC1TvaoXOW/Ej1rG9pzPz5bsZrAjvHhUSKYDP9kfbCc7VBFZuNMptpcl/pQ
         JZSg==
X-Gm-Message-State: AOJu0YwppryicIJdzRTuJWMUu0oX/EJzomFlhLvf5nyfcMJnus1JNM+A
	YGYUUFeqjgTuxnhzRzUjHnNV5h+R2AfcU7cyji+vqFh0ke7m4pKI1kD7La/SvpJZeEGJQJnrQoA
	ShIsReA==
X-Google-Smtp-Source: AGHT+IGtmVKP/LwQkTqqYTi72JKKi44xEFgNIfHXbNe2MHRDjv1vB5/IxJ0ew/FNcnhQLmQE78maXbxcXAk=
X-Received: from pjx15.prod.google.com ([2002:a17:90b:568f:b0:329:7040:8862])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f78f:b0:240:3eb9:5363
 with SMTP id d9443c01a7336-2516e69aedamr155274045ad.27.1757449723965; Tue, 09
 Sep 2025 13:28:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Sep 2025 13:28:34 -0700
In-Reply-To: <20250909202835.333554-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909202835.333554-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909202835.333554-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: selftests: Dedup the gnarly constraints of the
 fastops tests (more macros!)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a fastop() macro along with macros to define its required constraints,
and use the macros to dedup the innermost guts of the fastop testcases.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86/fastops_test.c  | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/fastops_test.c b/tools/testing/selftests/kvm/x86/fastops_test.c
index 6c9a2dbf6365..26a381c8303a 100644
--- a/tools/testing/selftests/kvm/x86/fastops_test.c
+++ b/tools/testing/selftests/kvm/x86/fastops_test.c
@@ -8,14 +8,20 @@
  * to set RFLAGS.CF based on whether or not the input is even or odd, so that
  * instructions like ADC and SBB are deterministic.
  */
+#define fastop(__insn)									\
+	"bt $0, %[bt_val]\n\t"								\
+	__insn "\n\t"									\
+	"pushfq\n\t"									\
+	"pop %[flags]\n\t"
+
+#define flags_constraint(flags_val) [flags]"=r"(flags_val)
+#define bt_constraint(__bt_val) [bt_val]"rm"((uint32_t)__bt_val)
+
 #define guest_execute_fastop_1(FEP, insn, __val, __flags)				\
 ({											\
-	__asm__ __volatile__("bt $0, %[ro_val]\n\t"					\
-			     FEP insn " %[val]\n\t"					\
-			     "pushfq\n\t"						\
-			     "pop %[flags]\n\t"						\
-			     : [val]"+r"(__val), [flags]"=r"(__flags)			\
-			     : [ro_val]"rm"((uint32_t)__val)				\
+	__asm__ __volatile__(fastop(FEP insn " %[val]")					\
+			     : [val]"+r"(__val), flags_constraint(__flags)		\
+			     : bt_constraint(__val)					\
 			     : "cc", "memory");						\
 })
 
@@ -37,12 +43,9 @@
 
 #define guest_execute_fastop_2(FEP, insn, __input, __output, __flags)			\
 ({											\
-	__asm__ __volatile__("bt $0, %[ro_val]\n\t"					\
-			     FEP insn " %[input], %[output]\n\t"			\
-			     "pushfq\n\t"						\
-			     "pop %[flags]\n\t"						\
-			     : [output]"+r"(__output), [flags]"=r"(__flags)		\
-			     : [input]"r"(__input), [ro_val]"rm"((uint32_t)__output)	\
+	__asm__ __volatile__(fastop(FEP insn " %[input], %[output]")			\
+			     : [output]"+r"(__output), flags_constraint(__flags)	\
+			     : [input]"r"(__input), bt_constraint(__output)		\
 			     : "cc", "memory");						\
 })
 
@@ -65,12 +68,9 @@
 
 #define guest_execute_fastop_cl(FEP, insn, __shift, __output, __flags)			\
 ({											\
-	__asm__ __volatile__("bt $0, %[ro_val]\n\t"					\
-			     FEP insn " %%cl, %[output]\n\t"				\
-			     "pushfq\n\t"						\
-			     "pop %[flags]\n\t"						\
-			     : [output]"+r"(__output), [flags]"=r"(__flags)		\
-			     : "c"(__shift), [ro_val]"rm"((uint32_t)__output)		\
+	__asm__ __volatile__(fastop(FEP insn " %%cl, %[output]")			\
+			     : [output]"+r"(__output), flags_constraint(__flags)	\
+			     : "c"(__shift), bt_constraint(__output)			\
 			     : "cc", "memory");						\
 })
 
-- 
2.51.0.384.g4c02a37b29-goog


