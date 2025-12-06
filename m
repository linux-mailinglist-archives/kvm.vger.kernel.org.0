Return-Path: <kvm+bounces-65432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF33CA9B82
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31A5832344FA
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4E03090EA;
	Sat,  6 Dec 2025 00:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sj3VHSDj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891043064B2
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980328; cv=none; b=p1cLdcJOJScyANuu/ghAG3qrll7XlMIByFMRjDqivgAF+3xDtiMarZeNg8cb0O+bcO1jW2DR0pO4/U5OBeKcP19e0Vi/QU6TGyECyo3gcw/m5aaUrfdwxFHf8CUyvHfeAL7r6gOOJWslNxAiScPzYjn7er+D0vat+Hx6V7GHIH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980328; c=relaxed/simple;
	bh=l5LewAY0/XP6khVEVySmdxm/awcqBbBDupO1XKWMwzw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZycEWoOkqYxbokUgQqEYY68tDOLnIM5Uv2E/LWXPdQEgwbNWd0joRDBbWlmnCJ8z9J1glakDqcrZzXVsq16HqFa+0UD8bLQfcD5z9g0AFRzVRAvk/DeKxgUcTaR5nsEwxaYfisr2iRH7PLNDSPgoPRnwBJthQhXdG9S0m8LDgcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sj3VHSDj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso3052646a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980326; x=1765585126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OETTgwJdKjLOXcIOe9hfqxKY+IkrMGSVX3FLBG1neIA=;
        b=sj3VHSDjoVOqfHTm75gcjLiZ2g5ImZzrOY+bEHkeUX5GF1e/PnPa7Mag0CMbGlhqJN
         lbadaBXTOiucejd0oFmg1RbH47IDtn9slLfgCRmv+fl6PcRACsE6DWYqtx38nKBsfRnA
         pDLn2OcqfiVhfrNmPq6pu9NmxgSQkXlbeXjVJWag2bgkxjV58Lx+5SWSuXGNFlJiSw1X
         BYpumfnfnUdtwi/h6PwgVFrRbasqDtwYbSK7NbDyP/pQJzdVlPyzwtTsuxw0B5+QdO5E
         8Ia+cNEbkOiEpsrd3kudpJB7bh4LZNPOPlUMBSVYOiWzXhHOY8l4HyFd27HxLZzGpKeh
         kEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980326; x=1765585126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OETTgwJdKjLOXcIOe9hfqxKY+IkrMGSVX3FLBG1neIA=;
        b=A/sLsoA1DSwcC6JqGdQYwbj/xThBzYcNONuyQQfmpOPzj6Jgsesz3PxBe8vSbfo6hL
         dvHlRWqqj0lN0wNbhXAYNkYGNwEN+yrAFix/MyVi0etb3TQaVOtLTz9rq7MvHtm1Oh8E
         KASGpWETg22ipXxFolEG3Chlr9WJf5wFBAIVKvY7XPt/fixWco0DGfgp2UWNCQOf0eRw
         krzy7EyGi5KtBhcJ6Y1M1mzTLYwR4PiLVaaDVCfJKlshSvD7l2SC23nspZ5jhpUrKHJ/
         UqtONHSzlkcUxkaA1q5+inA1Fbxib4FrOL74DJcnD+AVWs+hFMSeq4u4I4nZFh7R1vv5
         d8Tw==
X-Forwarded-Encrypted: i=1; AJvYcCU+qEVY5yyNNP7UzM4+kwMfyArudyqFekXxZgb9i4WlyJKVmcSd93bwS7AuEpHUn/WoD7M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3Hm7OtK7TzfjblGXQVUclh+nixfwGALu7F74YDN3UcVfqpMPT
	5rx3L0fSaxtRy2tjoa+Y7zMCO7bmlFokrBr6UGV5pkn9jfdCDmlqS3tRaZfGt0bw08uUB8qDZGu
	2LWNaFQ==
X-Google-Smtp-Source: AGHT+IEhe1pZpq0MW23HxJ1d0U2ymT/Zcg6wxeHV4r8IvmytRP6tpgYpoHJSoQtNjxepJopTb3+TB9OPRJk=
X-Received: from pjis4.prod.google.com ([2002:a17:90a:5d04:b0:340:b1b5:eb5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ecd:b0:340:f05a:3ec2
 with SMTP id 98e67ed59e1d1-349a25fb8c0mr658162a91.17.1764980325670; Fri, 05
 Dec 2025 16:18:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:15 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-40-seanjc@google.com>
Subject: [PATCH v6 39/44] KVM: VMX: Bug the VM if either MSR auto-load list is full
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN and bug the VM if either MSR auto-load list is full when adding an
MSR to the lists, as the set of MSRs that KVM loads via the lists is
finite and entirely KVM controlled, i.e. overflowing the lists shouldn't
be possible in a fully released version of KVM.  Terminate the VM as the
core KVM infrastructure has no insight as to _why_ an MSR is being added
to the list, and failure to load an MSR on VM-Enter and/or VM-Exit could
be fatal to the host.  E.g. running the host with a guest-controlled PEBS
MSR could generate unexpected writes to the DS buffer and crash the host.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 38491962b2c1..2c50ebf4ff1b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1098,6 +1098,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 {
 	int i, j = 0;
 	struct msr_autoload *m = &vmx->msr_autoload;
+	struct kvm *kvm = vmx->vcpu.kvm;
 
 	switch (msr) {
 	case MSR_EFER:
@@ -1134,12 +1135,10 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
 	j = vmx_find_loadstore_msr_slot(&m->host, msr);
 
-	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
-	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
-		printk_once(KERN_WARNING "Not enough msr switch entries. "
-				"Can't add msr %x\n", msr);
+	if (KVM_BUG_ON(i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm) ||
+	    KVM_BUG_ON(j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
 		return;
-	}
+
 	if (i < 0) {
 		i = m->guest.nr++;
 		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
-- 
2.52.0.223.gf5cc29aaa4-goog


