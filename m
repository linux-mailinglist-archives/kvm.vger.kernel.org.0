Return-Path: <kvm+bounces-48604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5DFACF85A
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B40D3AF9C5
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FB827EC73;
	Thu,  5 Jun 2025 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j9BiLlqV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D4727D760
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749153027; cv=none; b=TmLcTELmUqBGYxoFmoihzKQK8m67QN5/HnIfH12+AgamnpE+CqzM2jO3GpPYTKPY01lW2TAR1bw+VYQLWtPxKb8/xPQ44fjwsU3XCTA5inj6fbl9MG5+VoO2i3t+c1Gafl/e/ALFUW4OO8b5z6BVUyErCT7vq950+HqwrbArADY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749153027; c=relaxed/simple;
	bh=aZ890D4c2otV8dXfljJVZ3yZSCyWORqFvzJMd1T5OEQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X6wmCsdqODvnlplPuUf2FVf2zGqoxOnWX0kJ/MrpAXVYpWqegEqmF7OzLfvlhmKZOKuweX/9riRG1UOu0Cg5FL2ABxfCSzy/ddSvtYtYdP5K0LxuJo8TPXRZ8qB5eYf84QDgjdWY9niJi/aIbORyE5pSdXSMZUYr9KRIlamGsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j9BiLlqV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e7550f7bso13540645ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749153025; x=1749757825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Yh85KLZs5g2N1g/C3H1XUc3OdMT8vH9q0BF8iu8KMD8=;
        b=j9BiLlqVEkFfkPh0FCqJ7CkSbad+cJQOAl+kDwK5rjK/9T/gyYhHMSgcFwDshDbjAi
         dKZXyXX62R00y8VF3mO7vP0xAVFFrBxZvutE4MJy8ZD1M0VB1TDSJAShpYgQgb33XPJi
         cn+MWOyr+MOQWFL9OXrjt3mN9IsgKvI4Oau+9/txpvTyJ9C/MA+KCkxn4QxNchiaZxS/
         7axFobfU64Mi6roy+1vmmgQwgfiSYNqpN+YxIQ91B3CMx+JCHRW93iJTzMDQ+uyJtK3J
         sQXGRjj2wABwlKFd16lrJ3kF0TJHMrQ75XgMVLp05k5l9xmTEXrxyqpXHlykOG2IAN0g
         DXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749153025; x=1749757825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yh85KLZs5g2N1g/C3H1XUc3OdMT8vH9q0BF8iu8KMD8=;
        b=C+wWtigId9Vo64I7VOSN4fMHknXTPNokfPfzCKRGMdJPK5Te/PEjFtpkQp6ho5AyRX
         kGM+AJOwMfUM8uKBm9c8tXMGrUswbFTa0klBX8YCaxfAoqKB8XnigBQvG+qW3xl2Hbqc
         7VNsrAjHL2XBSMPsc7CwbCFb6uRi/ehMOVmCDySIpDFDTpEny5nK2fkjfPHQLIwhMoSu
         KGIDD/fO2Zg2+K0B0xWgsIDJaOAPw9IDzlHIxyuUaUNrKL4Tm8pNRymbdByK64U/2StT
         /V9ND2TiE7JI3nUfwTh21jaY3tloOVNIHYuhGTXitT66LkciJLstOFBzD0x+gadB04o5
         Bc2w==
X-Gm-Message-State: AOJu0Yw749I9WiYdXvdDMeYSAiL7tHLcJg8S2qCuKWaGl6DKKrH53z72
	F+2cZ6qntcbyPuxEMD3k+e8SzP3sihKtVhpKFcXV1fyC9TN229Q4yNwANj0LggFz0ttHZWWciaK
	6IEhOVg==
X-Google-Smtp-Source: AGHT+IHzvxbdDdfnfWZ9af+RjkmA2KEI4LuJiSUG1HjoMKppEofk4kNWIkNWtL/EBOlyMdx1LTeQgUXXx/M=
X-Received: from pjblr6.prod.google.com ([2002:a17:90b:4b86:b0:313:2412:ced6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2390:b0:235:7c6:eba2
 with SMTP id d9443c01a7336-23601dc42d7mr9522965ad.37.1749153025099; Thu, 05
 Jun 2025 12:50:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:50:15 -0700
In-Reply-To: <20250605195018.539901-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605195018.539901-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605195018.539901-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: x86: Drop pending_smi vs. INIT_RECEIVED check when
 setting MP_STATE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+c1cbaedc2613058d5194@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Allow userspace to set a vCPU's mp_state to INIT_RECEIVED in conjunction
with a pending SMI, as rejecting that combination could result in KVM
disallowing reflecting the output from KVM_GET_VCPU_EVENTS back into KVM
via KVM_SET_VCPU_EVENTS.

At the time the check was added, smi_pending could only be set in the
context of KVM_RUN, with the vCPU in the RUNNABLE state.  I.e. it was
impossible for KVM to save vCPU state such that userspace could see a
pending SMI for a vCPU in WFS.

That no longer holds true now that KVM processes requested SMIs during
KVM_GET_VCPU_EVENTS, e.g. if a vCPU receives an SMI while in WFS, and
then userspace saves vCPU state.

Note, this may partially re-open the user-triggerable WARN that was mostly
closed by commit 28bf28887976 ("KVM: x86: fix user triggerable warning in
kvm_apic_accept_events()"), but that WARN can already be triggered in
several other ways, e.g. if userspace stuffs VMXON=1 after putting the
vCPU into WFS.  That issue will be addressed in an upcoming commit, in a
more robust fashion (hopefully).

Fixes: 1f7becf1b7e2 ("KVM: x86: get smi pending status correctly")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd34a2ec854c..7e3ab297a1bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11895,10 +11895,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	/*
 	 * Pending INITs are reported using KVM_SET_VCPU_EVENTS, disallow
 	 * forcing the guest into INIT/SIPI if those events are supposed to be
-	 * blocked.  KVM prioritizes SMI over INIT, so reject INIT/SIPI state
-	 * if an SMI is pending as well.
+	 * blocked.
 	 */
-	if ((!kvm_apic_init_sipi_allowed(vcpu) || vcpu->arch.smi_pending) &&
+	if (!kvm_apic_init_sipi_allowed(vcpu) &&
 	    (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED ||
 	     mp_state->mp_state == KVM_MP_STATE_INIT_RECEIVED))
 		goto out;
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


