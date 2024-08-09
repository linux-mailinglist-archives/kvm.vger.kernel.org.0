Return-Path: <kvm+bounces-23752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD7D94D6CB
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5FCBB22103
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AAB1607B7;
	Fri,  9 Aug 2024 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MRRt48XY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5116115ADB1
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230210; cv=none; b=d0BTnQle8x3j4RI/FfofYIzygyvBxz0HNOLD0dkDcQGyQalgx6FHb0nL7d9JNhWaFpZ1KTrwfhCOWT9V9j41YjThucx/pXvnkl2sVvFJXSEz9GMIjGDNR0/0KHFa1pLAgGqnfx5e/zpAPgk/0t2If9xSYkDKZkS8/6THsccOSeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230210; c=relaxed/simple;
	bh=+mKRLKzoADpOE20G4o9BQCTbkCSsOug+v9doDlmgPOw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B/GKmq+H+UZjq9xPfKRkiF7BvyJZLlhFeF4LcWBiBtDGXzAD+2AUx8aZrNzf2WL59T3r9lUBbT0wLC1vqZHrCRYzNGKLszlbjFx6szVlb4mL1U95zTnjNgot6AxGbwjjbJ2/QVrrBh2RbDHaDFfOce7CQeNhScXJRC5I0097pWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MRRt48XY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a2787eb33dso2255597a12.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230208; x=1723835008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GsIoGeUgslSIDQu3stBnO5MiBTFOAiP1ETUsvE40Zzk=;
        b=MRRt48XYz6NoJWHb17AFlSJga+T1iOTrY5u389ZIr9h/aiPb8vVqnFyX4Uk5kY5PL0
         khxdE7MjLkoTvBqEBVJu67yNn8atyJCSqrBLoQKO2nmI0dkbDvvq+rq+NCdI6bqZcZTT
         p1sKiWigmVuQvWvUtzID/9MLjxkSsuLe4yNbYOHKaUZYMe0xWXXPVQOnoQWkGdt1znJB
         D3jpPKPcRLgoVA9I6Ir3hdNkllZvlqBQKD3PLX+e/PA9cpYS4eCazzMdS2pGTvYV8Yts
         2K0ZMHlwYhfd0brWQWuQPnTl7ZdWZ8SR5jMjRBbT7dFfDi4WLxmZoHUtqIBdXYU+ZQdq
         2jWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230208; x=1723835008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GsIoGeUgslSIDQu3stBnO5MiBTFOAiP1ETUsvE40Zzk=;
        b=Vg0yJmx0I2iZBRWj4U/vWQ9l3SYhm+DupbJ5LMvZ6Bf5Deuk29HNiE0rLAxf5qtqtk
         xTBIby97RoQoutxqC1yg33d1OOlLDdJSI2tOEQ44U6JFtW6JDd6cTn6e0sWz3hS6by6P
         wmAvt49qWnLrjfhY9lK1568JrdHW5T3WRuxkEncHkndPbwzCONWRj/NyOJTJitxg2JzV
         XSlTBZZRjnE+uE76rX7ALRCHZ8zsYov6wqd4sKYgyzC7SoaXLm/399H1HalBhQKxtot+
         lbgNSE2sptAJyyUaJ2xVbrLHBhxTFPanC1T8SsVLMptsDtAePI/6y74Xo1kJAKOkn8Cz
         9yMQ==
X-Gm-Message-State: AOJu0Ywka96LjSvApPROiewM9SDmTD82RFomVHtgxSM9+R1CZsxtxHQB
	aRb50uQz7W7j/0+uOZtoD7/fXEeyOObrcnFU1Ba+FKSZ8wYWd+jrq9qXHYVeIFW1m9RKiBOMTGg
	9QQ==
X-Google-Smtp-Source: AGHT+IE3eXOVlwsDRuB2+lPmtn5qtlNh4cfa2iZm6g38l3Rqzh9FsNEd+cI5zpswhamioOgLLQz+IgMJaoM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8c52:0:b0:7c1:271a:c780 with SMTP id
 41be03b00d2f7-7c3d2acc41emr4853a12.0.1723230208428; Fri, 09 Aug 2024 12:03:28
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:02:58 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-2-seanjc@google.com>
Subject: [PATCH 01/22] KVM: x86: Disallow read-only memslots for SEV-ES and
 SEV-SNP (and TDX)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Disallow read-only memslots for SEV-{ES,SNP} VM types, as KVM can't
directly emulate instructions for ES/SNP, and instead the guest must
explicitly request emulation.  Unless the guest explicitly requests
emulation without accessing memory, ES/SNP relies on KVM creating an MMIO
SPTE, with the subsequent #NPF being reflected into the guest as a #VC.

But for read-only memslots, KVM deliberately doesn't create MMIO SPTEs,
because except for ES/SNP, doing so requires setting reserved bits in the
SPTE, i.e. the SPTE can't be readable while also generating a #VC on
writes.  Because KVM never creates MMIO SPTEs and jumps directly to
emulation, the guest never gets a #VC.  And since KVM simply resumes the
guest if ES/SNP guests trigger emulation, KVM effectively puts the vCPU
into an infinite #NPF loop if the vCPU attempts to write read-only memory.

Disallow read-only memory for all VMs with protected state, i.e. for
upcoming TDX VMs as well as ES/SNP VMs.  For TDX, it's actually possible
to support read-only memory, as TDX uses EPT Violation #VE to reflect the
fault into the guest, e.g. KVM could configure read-only SPTEs with RX
protections and SUPPRESS_VE=0.  But there is no strong use case for
supporting read-only memslots on TDX, e.g. the main historical usage is
to emulate option ROMs, but TDX disallows executing from shared memory.
And if someone comes along with a legitimate, strong use case, the
restriction can always be lifted for TDX.

Don't bother trying to retroactively apply the restriction to SEV-ES
VMs that are created as type KVM_X86_DEFAULT_VM.  Read-only memslots can't
possibly work for SEV-ES, i.e. disallowing such memslots is really just
means reporting an error to userspace instead of silently hanging vCPUs.
Trying to deal with the ordering between KVM_SEV_INIT and memslot creation
isn't worth the marginal benefit it would provide userspace.

Fixes: 26c44aa9e076 ("KVM: SEV: define VM types for SEV and SEV-ES")
Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")
Cc: Peter Gonda <pgonda@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 include/linux/kvm_host.h        | 7 +++++++
 virt/kvm/kvm_main.c             | 5 ++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..37c4a573e5fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2191,6 +2191,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 #define kvm_arch_has_private_mem(kvm) false
 #endif
 
+#define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
+
 static inline u16 kvm_read_ldt(void)
 {
 	u16 ldt;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 689e8be873a7..62a3d1c0cc07 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -715,6 +715,13 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+#ifndef kvm_arch_has_readonly_mem
+static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_HAVE_KVM_READONLY_MEM);
+}
+#endif
+
 struct kvm_memslots {
 	u64 generation;
 	atomic_long_t last_used_slot;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..fad2d5932844 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1578,15 +1578,14 @@ static int check_memory_region_flags(struct kvm *kvm,
 	if (mem->flags & KVM_MEM_GUEST_MEMFD)
 		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
-#ifdef CONFIG_HAVE_KVM_READONLY_MEM
 	/*
 	 * GUEST_MEMFD is incompatible with read-only memslots, as writes to
 	 * read-only memslots have emulated MMIO, not page fault, semantics,
 	 * and KVM doesn't allow emulated MMIO for private memory.
 	 */
-	if (!(mem->flags & KVM_MEM_GUEST_MEMFD))
+	if (kvm_arch_has_readonly_mem(kvm) &&
+	    !(mem->flags & KVM_MEM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_READONLY;
-#endif
 
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
-- 
2.46.0.76.ge559c4bf1a-goog


