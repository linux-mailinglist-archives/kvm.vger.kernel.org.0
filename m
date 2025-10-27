Return-Path: <kvm+bounces-61232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B646C11EE9
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:06:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ACF46353ED8
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA94232AADC;
	Mon, 27 Oct 2025 23:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="s1rlMNAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E24230BEC
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 23:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761606392; cv=none; b=dXoc3u9VhL5tDjAiYUQktENqlhKM8pOlZGSyTMGV1JoY5Edn7tK0f5WGWwcVZKAfy4hT/hsClFNdvWqgr8sMNvE7cPaT6AG5aDWfvzDEhSWv26agn3CNTqxLIbWFbrjowUKMmyOPLMtUhkPP62YyUoARqtAirHEQECROrOeK/Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761606392; c=relaxed/simple;
	bh=5+cC9rUGp+Qhc2isTMc45JlQ4CdwvIYA47KTGZq28Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VWcYNyNfsT5Itfc2A7xLxHebIhb4Gm863pmgS8ZN7Vv1PsLxVS5jMUn41ohm95gpHuhYMheM7ZXZOVRpbl6Kh4B9OK0Q/fotiEorQJlvOPJJ/9B2C2KMP0lSIUhlXbXE2Q95HNxrgAeXc7kjrtXNOIof1fIXRwd1e6wFUbDV0Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=s1rlMNAs; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33fc9550f68so955178a91.2
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1761606390; x=1762211190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FujRXKxtyB3paNujZd/CaQKsqivexQIWIeYXymH5QZc=;
        b=s1rlMNAsgMpVJlRDn3zMrY4oX5/kCVHvDR+9+iFjtDfMeiW1C2Dtpdttj1O0y/7UbY
         0IoALiDBs5qnoNixkn+LNpndvqWyT0w+LnxQhPEvVKqpzTKifZTJk7Uh6wRPPiHyEBFb
         AIvw2UiX8xZvKsMvDPlrMNBgXRa7ot7pfwTR92tOf9uuwQGoUne7n0JVzWMZnsGYvGHT
         bwRcNZbaYRDzD+rKdgKCdyPvOX5Q7ZWJMi0FgTNlUF2qetTQp6bqviNQ8QebzY92smk5
         vKYEtsaDilOFHqZQheYypIGfOmWLhPIMOVvBBLz7OWA2NQsy1Lf4kIEiaVgFNBMY9EsZ
         zfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761606390; x=1762211190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FujRXKxtyB3paNujZd/CaQKsqivexQIWIeYXymH5QZc=;
        b=iwX+pehO9ypjcAqHNwfHZU/OWkpxqDFB6bX1IXWNX0rWArkG3KlDcgqNum7GARTwVW
         2o7l/fp7yozCoPmor0U5cBHg29eD4ytCD3KDKKQFWarRqBn8KHa6SWjyGBk4uboLODjE
         MEVsXksuYM/nONxUqE8v8YUQ24ocSIdFA0N3jFNBSrYV5BbnNyTVgc2rm6X1RVRwEUy5
         Fi74dj16PMa5q2GTKQH6v6uV+io3pUxGNnMboft5lxjR+a29IlCnLwSl67NfFG8NGZh4
         J4Y8ZpjFM5IDsq/xJ+/7D5JdWWMI0auvAUcIL9MaKAOsH3znKRtIDtUEZUzma4xUqDuy
         Uj1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUTLemdZdrNBtb2a+WQrm2fRCzBsbRkJYNTJO0LdxBwk/HY8NRXf9dCbXaRn1GS0ebXfU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8laLBwu7Hhg1Vx8b1kLhHmAG6ojZnZNEzj2CfMjagUl4eeADF
	Dw7dBHbVk1A9xtj4BznlIlgM+FLmHXFsZvlb8V8cLucD2Cq48iQZb+C9ZdH7CQSdnvk=
X-Gm-Gg: ASbGncvPgzGEGKaChda9s6YalF0zDmBKle+9HXKa/dOyanF0/RfxSv7Xkpv8q1+kcW3
	OGOlCZ4E70h6n7tYjyVTL/VZV1Y63BrqmiUQvh7i37V704p9657FDpa7h/j6MBo9OjnKFj8/ZJo
	tklA1e8h2TPyweot2RSIsZ+iSoGr5qf7yVvXoBvEpuFl4X8QgHRcaMq+OKMeSJHx72vFdxMfWlD
	IVPEm6HeClYJ/hLmr4emOlL1IIM4/vGY+xiinmIZmDpLrUMBbAD21i3dCOfxN1WHtBSmUW0zUZX
	vt34l27N+fIqHeaZuGQYjFFxKcc3NNHjG+pVGY4luO7WRDcLd+yISY5wdOdqy+kZAN3okZwIBY2
	2Tbmi0YNXINRmJaElgUrthhBcKSq6xeszKwWCYYuNJbuNaNw5+9JEjYS9Sj6ohjdJXp1JHrTBNa
	spvnh0vSEm064r
X-Google-Smtp-Source: AGHT+IHBmy/5J1pJb4D3bLqg0o9qFMfOGw69b9Acs08VWjqmeB97MwOKAbhCbKjcC/zmXUGkL4nAEg==
X-Received: by 2002:a17:902:ebc6:b0:290:ab25:29a7 with SMTP id d9443c01a7336-294cb3945f2mr9579945ad.5.1761606390229;
        Mon, 27 Oct 2025 16:06:30 -0700 (PDT)
Received: from telecaster.thefacebook.com ([2620:10d:c090:500::4:c4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0a60fsm93789725ad.39.2025.10.27.16.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 16:06:29 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Gregory Price <gourry@gourry.net>,
	kernel-team@fb.com
Subject: [PATCH] KVM: SVM: Don't skip unrelated instruction if INT3 is replaced
Date: Mon, 27 Oct 2025 16:06:21 -0700
Message-ID: <71043b76fc073af0fb27493a8e8d7f38c3c782c0.1761606191.git.osandov@fb.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Omar Sandoval <osandov@fb.com>

We've been seeing guest VM kernel panics with "Oops: int3" coming from
static branch checks. I found that the reported RIP is one instruction
after where it's supposed to be, and I determined that when this
happens, the RIP was injected by __svm_skip_emulated_instruction() on
the host when a nested page fault was hit while vectoring an int3.

Static branches use the smp_text_poke mechanism, which works by
temporarily inserting an int3, then overwriting it. In the meantime,
smp_text_poke_int3_handler() relies on getting an accurate RIP.

This temporary int3 from smp_text_poke is triggering the exact scenario
described in the fixes commit: "if the guest executes INTn (no KVM
injection), an exit occurs while vectoring the INTn, and the guest
modifies the code stream while the exit is being handled, KVM will
compute the incorrect next_rip due to "skipping" the wrong instruction."

I'm able to reproduce this almost instantly by patching the guest kernel
to hammer on a static branch [1] while a drgn script [2] on the host
constantly swaps out the memory containing the guest's Task State
Segment.

The fixes commit also suggests a workaround: "A future enhancement to
make this less awful would be for KVM to detect that the decoded
instruction is not the correct INTn and drop the to-be-injected soft
event." This implements that workaround.

[1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
[2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b

Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Based on Linus's current tree.

 arch/x86/kvm/svm/svm.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..4d72c308b50b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -271,8 +271,29 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
+static bool emulated_instruction_matches_vector(struct kvm_vcpu *vcpu,
+						unsigned int vector)
+{
+	switch (vector) {
+	case BP_VECTOR:
+		return vcpu->arch.emulate_ctxt->b == 0xcc ||
+		       (vcpu->arch.emulate_ctxt->b == 0xcd &&
+			vcpu->arch.emulate_ctxt->src.val == BP_VECTOR);
+	case OF_VECTOR:
+		return vcpu->arch.emulate_ctxt->b == 0xce;
+	default:
+		return false;
+	}
+}
+
+/*
+ * If vector != 0, then this skips the instruction only if the instruction could
+ * generate an interrupt with that vector. If not, then it fails, indicating
+ * that the instruction should be retried.
+ */
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
-					   bool commit_side_effects)
+					   bool commit_side_effects,
+					   unsigned int vector)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long old_rflags;
@@ -293,8 +314,18 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+		if (vector == 0) {
+			if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+				return 0;
+		} else if (x86_decode_emulated_instruction(vcpu, EMULTYPE_SKIP,
+							   NULL,
+							   0) != EMULATION_OK ||
+			   !emulated_instruction_matches_vector(vcpu, vector) ||
+			   !kvm_emulate_instruction(vcpu,
+						    EMULTYPE_SKIP |
+						    EMULTYPE_NO_DECODE)) {
 			return 0;
+		}
 
 		if (unlikely(!commit_side_effects))
 			svm->vmcb->save.rflags = old_rflags;
@@ -311,7 +342,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 
 static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	return __svm_skip_emulated_instruction(vcpu, true);
+	return __svm_skip_emulated_instruction(vcpu, true, 0);
 }
 
 static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
@@ -331,7 +362,8 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	 * in use, the skip must not commit any side effects such as clearing
 	 * the interrupt shadow or RFLAGS.RF.
 	 */
-	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+	if (!__svm_skip_emulated_instruction(vcpu, !nrips,
+					     vcpu->arch.exception.vector))
 		return -EIO;
 
 	rip = kvm_rip_read(vcpu);
-- 
2.51.0


