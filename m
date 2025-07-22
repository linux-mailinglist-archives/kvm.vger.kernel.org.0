Return-Path: <kvm+bounces-53172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FAAB0E563
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 23:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F9511C8748E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 21:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E762868AC;
	Tue, 22 Jul 2025 21:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="pLjUK27L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A63C27FD56
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 21:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753219522; cv=none; b=ZajeZFC+CbThs+sPubK1God20FRThttgtIhsoF2ynVrreGIF6MbUjkriu0VkyHhvtLkUd+VOwEzDG4lKuOjxu9oU+CsUriez4o7suPCiTiH6djm3RJGPA1THPqv5z+s4ZWOcQpNLagsaAvqFYB9SORRymJjaQDdO3+Dju+GnOBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753219522; c=relaxed/simple;
	bh=0WCbJNzWvZcN2WJWPtUngCYwWsVie2W+id+j1gBWhC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH7bzsbEnsWnLJd0W+v9IdfEmJQq12gOILfi5YXneFwH71v0VGv+xxiC3HV/rmy3ISnFC43ffn/CKuQ5fFzXZsPdyZUtLJgPo0K0NzcrgDuNjG6tOyf7bg7ur73c+t2NX0EEEl1R19Tyxm5V6K9QJiAr5PfDLO3uqfOwIDLaSvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=pLjUK27L; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-235e1d710d8so64959895ad.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753219518; x=1753824318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sYfC0z0fmbhRyOvnlOriFc7D0YQFEXxIRam4ow7EpHs=;
        b=pLjUK27Lf4rNoIXq8GlUibHnWApy38Q27az0vl+I7QOe6wwqzMJd4yFgqUV9OAsjnT
         ANjy/MOhJzcAe0X4tiT0FxqMmxY6ktRH4YV2NuK4Sr3Okw/0YZ2c9h/y0/4pDoQ6oxbs
         2+SZiGPI/EIeJv+U+Pkp426IMr0FqG5z3i1tSvZ0aMEmyBYJcVoC6OzNILZPgk5PZnB1
         qRIFVrqossWzCYtqjzszygPnRkxcD1NH5k1b0FPZPLu7T1E4MFsrpwEMtIKzES3mjLth
         z0Rlsbq/gTAe0HXIvY31eSddkimZ94tBPrB+wnN89TAqVhk7AD8naVtnzxk/uXylgo8w
         AMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753219518; x=1753824318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sYfC0z0fmbhRyOvnlOriFc7D0YQFEXxIRam4ow7EpHs=;
        b=wj/zwi3liCtXoZILE/TxVztiyAyL9CRUomOy8dLWHooiSVRUyU8QYCqwzqt4iHDIFV
         EDgVvmyjNWJRDGfZRce3EXCLxMiEK0G1Bfd6nkQJOuA0IQP406QtzV5R4kYRnsjtW56U
         ZvB7bYShM/zWred79uOtfS0AN3Ex49e2jDoOOYVSbRmbkwiBNrQno+uxa1yUBkjm0n7e
         lg2k+X2+FxLczcLmeO2/NMaVVAF2zA/TE6Qp8tDWNOUVOv5tGmfXsaqn1tcT0EcLs0l2
         PG1Wm+Dl6l+XocV2qrKcS0bh1kwgYWlK/6MWn0SkFz9mctFm8p5HFG1Eq5yKH5gkPiFY
         Iv+A==
X-Forwarded-Encrypted: i=1; AJvYcCWgnwtYbnSLcKC+fSwmVeRpUTPVv1SALOzIaFxOu+tvlNR/8BiW/ZzS8NuOwKke/jJoNLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOPF9C+v2RdOwAlA+q5y39eoLqKvgCAbMRwOHqDJjlQHp/xbcX
	EvfW2rrcNaNXROCrpbojgfP2Hu/h4WguGKgV3dPC/AaA1dKCqaZ+nJCtYbPOKNTqoLQ=
X-Gm-Gg: ASbGncsQGHiSPNd+Lt9uMs/5lNLvcX9bW4RkorPOh97x0yVA9gqoUm3f5xvOrwQhUBB
	QzSb54PYjx5jCRtHww/r4vyisCxp8S9U6F0uYEdMTSdqm0Inmc14IqR+BLl6Zs+CDXU9c3Jwueg
	H+/ZQsL/3QzNAplwrY2zzZ/FdwcANuFqDAEG1br1a5wcob8Qt62f9l6ZgjL/+wLjBElHOcMu46E
	rZZ+fGXpYuX8EMcZhqZnYAGqAzQQAN/YR4II0/8qxIJGE7eypsUHpIvNw9oKRLnxq5+Uc3XWxX7
	PNUPEPlaNXW/cKBR8MdlFIRGzfhbTjeEV8ca51YJmqonUWYgc+tIUTjlzYLfXFk4Of2bIDjcrUr
	Q6Ey8u1oEA62egjMV6hQBj9TISNuAPBY2s1v9ezHNPznkrDQFVXFCXDV5dCciSO7appNLOgSy7o
	R7O7zXzUzucIxmeNEf
X-Google-Smtp-Source: AGHT+IH+6AQpc3T2i1ajEk8KawR/GSP/8xLtxRy1rm7L7m2TNl7t1NGVFzXJpKC4l7fzaYsi4+JFpg==
X-Received: by 2002:a17:903:2bcc:b0:23c:7c59:c74e with SMTP id d9443c01a7336-23f980775d4mr7202735ad.0.1753219518387;
        Tue, 22 Jul 2025 14:25:18 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6b4c76sm82394935ad.116.2025.07.22.14.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 14:25:17 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: Mathias Krause <minipli@grsecurity.net>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2] KVM: VMX: Make CR4.CET a guest owned bit
Date: Tue, 22 Jul 2025 23:25:03 +0200
Message-ID: <20250722212505.15315-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <96a0a8b2-3ebd-466c-9c6e-8ba63cd4e2e3@grsecurity.net>
References: <20250704085027.182163-1-chao.gao@intel.com> <20250704085027.182163-20-chao.gao@intel.com> <4114d399-8649-41de-97bf-3b63f29ec7e8@grsecurity.net> <aH58w_wHx3Crklp4@google.com> <96a0a8b2-3ebd-466c-9c6e-8ba63cd4e2e3@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Not only makes not intercepting CR4.CET the test run ~35% faster, it's
also more stable, less fluctuation due to less VMEXITs, I believe.

Therefore, make CR4.CET a guest-owned bit where possible.

This change is VMX-specific, as SVM has no such fine-grained control
register intercept control.

If KVM's assumptions regarding MMU role handling wrt. a guest's CR4.CET
value ever change, the BUILD_BUG_ON()s related to KVM_MMU_CR4_ROLE_BITS
and KVM_POSSIBLE_CR4_GUEST_BITS will catch that early.

Link: https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/ [1]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2:
- provide motivation and performance numbers

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
2.47.2


