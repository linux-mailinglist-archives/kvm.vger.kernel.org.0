Return-Path: <kvm+bounces-70942-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GJK7MHWrjWkK5wAAu9opvQ
	(envelope-from <kvm+bounces-70942-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:29:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4232912C7EE
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 471C7303432D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D404A2E8DE5;
	Thu, 12 Feb 2026 10:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXShR+sm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D702DE71B
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770892146; cv=none; b=nm5T0jic962ZBFwU9CU8gQ4jnxS1v6Wpt87dOXcgAUQvuUfNbE3dqBpKoluMMiODeYGkUZ99C+a3I8LUToKovxjC1qw+7zyawYqEQ4IBUctVMvUXOc/Q1sEgXLhHuuCf9/owqpOuvcJzVaeVtecHZuWPjamgcuwaTrBXN3T150o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770892146; c=relaxed/simple;
	bh=OJmNjBofLJOddVm/FKRMh+3l2G7M2Vx8ilcqxiy8HAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XwWEj8uPd1OODN5FPcgtSh4t9woAaVZFDDpe6FPi5mfpY0quVD8LcpEwISQj4TB0faSl9NhbMMJD5oJLpKTF0WaygZ561Bp31T6XbSGP0eiVnYdDEAvrUznS7WVPxkVlx2OGSawJO/v9xFRH7KeH7Mz7Ja2l1TK2WqLd9nCnDrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXShR+sm; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4833115090dso27200105e9.3
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 02:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770892143; x=1771496943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ukC8L7aMMcFiC9OBGhE3kC51+n1YuHXGUHKK89uyTY=;
        b=PXShR+smA5bb5z6JWrNAca3rl2fF04eH/iN7kcVRZ74cfS3cXlbGjv0Glti6QlEXAb
         yGXWfq9aJcUcck1WWY/ZL4fX1sGCobXWLLq5p7jjvLFlroHNn4hD9DRuXbzeyKoszZ3B
         pAmYZv467dNV4L0e3JUxw6d5C9QxYWtW1KvNvY5k5Kxzb3mal02La/JmPoQkaS6otdVL
         yzMH/W2x4bJykTIdn2ds72TK/bndi0Q0F+YwoFpufdBK5QKutN7zZ3mKTPpOIEpbNF6h
         odhnF1ST6HqxlnFYIrBim/jVOgfwxmkikaubcuLqAM45HZNlmB8WARf8CT1ezt/Q3YGr
         2A/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770892143; x=1771496943;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ukC8L7aMMcFiC9OBGhE3kC51+n1YuHXGUHKK89uyTY=;
        b=qKeuK19jKNnYnK3svT93Po8AuuJSPkObig0u24378tpe3lYMmbRpeXz3046QszTH3A
         lmiIF+mS8hyuR1Bpub0/R3PgTosMSTieCHaZ0mb1rgxXC4SZxxxUZE6l9L9aocKNKwQA
         pIm94KPVlfQlClzf2uNOlIJZAarjViG5oThPQgNCLGnZNr2yJ6M5Ggaewv70CR91x1Mo
         mVcL+wAy7awy66ax/+v6H3M1bDy6jjFtCG8ZlMiRPCr9RYXe9ncorpNCVy4NiAXW1G0A
         OMZjWAu8UaKMDPzk9ZzMVWhY8eV2wczUYgNeaVXNYTeeVH2E+5dih+lRKZ50QsQbOqXl
         jaEw==
X-Gm-Message-State: AOJu0YyyxHQuCM1cTWj+nnfbeUrQMoa3xUzAAcNOLdgxbCyg2x7CGhtp
	RMR12gjnLoJ5V1JDjgY5f9wikkn/zl0zBaVcJPdaIafMjurqVMY720IVRSwmZUXC
X-Gm-Gg: AZuq6aLNo6/AVhLU2PRQ0VczopYsIG6NWgWw77Jjfvf6ID3wV4Hba2b+lOefz7K0jp/
	fD/oai25pbAUgRpDUgQJgK4upMYjrJ33AfQMXreB6w3pe+MAzW59KzgW9Mey/w1nt/dALvR8Z99
	Tv4L5PxK2eLj0yjSvumzzu7a3f0KL9+/C4maG+fc0cFunee+21Fk4tPjyETFSirPEJIybsU8Sep
	TzNhvw/SDUrpDxJsaYLd9U1LPuSx9j/rkhjY1hfGAdJZS6KO9IK76nUNrb6v6shr1Vi1ASQ05Wp
	1qWzr6D2oaxc2sMFPdpuUrWV+p9/qnPQ+vxOCQDn5H/TCQKLp1lATknYAvzOdvxzwBlpFvOq8+H
	ZzZ0E76Z4Q0ED615bWPwp8OEuRwMevhBR91lWVLd0MYZFyhWno5Fsy3rLSrbRMgv/oVsD4WBWJ3
	J6JOuTYfX67BASK/gXxs/BerZhougNy3kw1PfxQK9WH0axzperACK5a04=
X-Received: by 2002:a05:600c:64c9:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-48367113bfbmr27264285e9.16.1770892142588;
        Thu, 12 Feb 2026 02:29:02 -0800 (PST)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5d77f9sm200650115e9.3.2026.02.12.02.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 02:29:02 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: x86: Fix incorrect memory constraint for FXSAVE in emulator
Date: Thu, 12 Feb 2026 11:27:59 +0100
Message-ID: <20260212102854.15790-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,google.com,redhat.com,kernel.org,alien8.de,linux.intel.com,zytor.com];
	TAGGED_FROM(0.00)[bounces-70942-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ubizjak@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,alien8.de:email]
X-Rspamd-Queue-Id: 4232912C7EE
X-Rspamd-Action: no action

The inline asm used to invoke FXSAVE in em_fxsave() and fxregs_fixup()
incorrectly specifies the memory operand as read-write ("+m"). FXSAVE
does not read from the destination operand; it only writes the current
FPU state to memory.

Using a read-write constraint is incorrect and misleading, as it tells
the compiler that the previous contents of the buffer are consumed by
the instruction. In both cases, the buffer passed to FXSAVE is
uninitialized, and marking it as read-write can therefore create a
false dependency on uninitialized memory.

Fix the constraint to write-only ("=m") to accurately describe the
instruction’s behavior and avoid implying that the buffer is read.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..d60094080e3f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3717,7 +3717,7 @@ static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 
 	kvm_fpu_get();
 
-	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_state));
+	rc = asm_safe("fxsave %[fx]", , [fx] "=m"(fx_state));
 
 	kvm_fpu_put();
 
@@ -3741,7 +3741,7 @@ static noinline int fxregs_fixup(struct fxregs_state *fx_state,
 	struct fxregs_state fx_tmp;
 	int rc;
 
-	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_tmp));
+	rc = asm_safe("fxsave %[fx]", , [fx] "=m"(fx_tmp));
 	memcpy((void *)fx_state + used_size, (void *)&fx_tmp + used_size,
 	       __fxstate_size(16) - used_size);
 
-- 
2.53.0


