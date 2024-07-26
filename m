Return-Path: <kvm+bounces-22372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E89D93DB57
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 468F328439C
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407E7153BF7;
	Fri, 26 Jul 2024 23:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZoCQUIfK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE46C15AAD3
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037978; cv=none; b=ZJkkzGpoJ22xd0T9tlRZxH/SKasPPMbV/8JBG5xIZ7AmRo21hV9O6EUq8MWQ2kTWWt4rrvaiB5vIB4OGcic2OizIQOaKmaaQZrMKIDptAojIWG15/Kd5L4+S/3LlnqpWaZzUnns7i2GeYyMAjcpiDNO4oN8KfnRWApa17Sc0Vq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037978; c=relaxed/simple;
	bh=P7WAicOgvpnFP/OgYcMHNilB3cYbvZdOfqdCkUi/Hw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l1OrTyNippORgr8+C/NHkIQvF61XYk3FXKMJGV/kYPnAppLiHQSeGt/1oYYqg6PnA/18tp3YU0TRvNe43ILtjpBrRsAzWsfCOhzHHWW0qjmY3PBFMyfFEj1ayi+iTqFcOzF22qpll3OhEp/IIGj+7eXgxU2E7ED9vshlGtH3Ysg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZoCQUIfK; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66619cb2d3eso5952037b3.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037976; x=1722642776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fmU/HR7p0h2R7XRsIfqUXhH6E22vlxrvSMQX4VgE/mU=;
        b=ZoCQUIfKoT5CuQK+9e2sZZYfCl+zAGIhLpWtYo0VRAfH3J3+yp/9TvzFqTSR15kTYL
         bjEJZsnNxVoB8J2D8dPbhQPNeiYbnBJNzr7eoHuTSyp/lrVg5jRBZmPlttDbVa48B4PJ
         W7NBRkNGcYHMxszPj1n5EZ+Jggmu+VPGjPd7Ttp/3pSJrpXJI0+mbJYIo9DA9igvKs/w
         A++fMhrDKhRlWqiU7uv+yxjhugmcpHWv1DxwkjTkFV8rTa9J52UCIWmP4ZNFsR+z+XGa
         rntZmjontxSN9+i5vGnBVOpYU/JvPWdjs8KVWoC6Hr8ukP8uFZy87wokVAI7RtIVs7mU
         MBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037976; x=1722642776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmU/HR7p0h2R7XRsIfqUXhH6E22vlxrvSMQX4VgE/mU=;
        b=i2I5mqMyMOC4Xxqp854qlKMonr06srMOzQgS1rvRGIGVzYALVzTjpKJAJPvss3hBVW
         eNWhILVGRHAWippcXVBZoOHsVAkfm3AGEiijS20YAWIo6PRV4sUTtqKQ9PbtPmuXjvmT
         Yn3hUPklxtIHmfHeIzb6R+N4HeEztTwciEW0zeRvsEnYWRFKJNFHnWIp4Vqo/kXqftm5
         DW0XU4hgs5OLm05Em7IMfT9MuOWLY/y52PIA/PPIUzLGv96tVXNsqupxDiQgwqxbfLee
         08W4JUw/uhK3TCuw8PPep9W0BtXGObDx1kFA9Tb0OwRgvvKPQIDE7Gx2LaONPHan/rN5
         lycQ==
X-Gm-Message-State: AOJu0YzSFzd5ZLALzRerQ/XVm3NWnQzGeqOCnXgJ7HMc5GV6HXZsJ9Nt
	xHHyjd0vUkjlE3eCkM+RC4woK6SW7lxhFaVFNUQ7NTS5lyL2qTUNNtqQ7JOP9gdlbfb3raWZWmQ
	rGw==
X-Google-Smtp-Source: AGHT+IEZeCODu/YeM5d/iOhxGxPVHISuly+z8I6+5BlUeuWOyJE5t2wqwhMJ9ApQGl0yAUOujG/KjtPFVv0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad14:0:b0:62f:f535:f41 with SMTP id
 00721157ae682-67a0abd4d1fmr288247b3.9.1722037976008; Fri, 26 Jul 2024
 16:52:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:18 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-10-seanjc@google.com>
Subject: [PATCH v12 09/84] KVM: x86/mmu: Don't force flush if SPTE update
 clears Accessed bit
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Don't force a TLB flush if mmu_spte_update() clears Accessed bit, as
access tracking tolerates false negatives, as evidenced by the
mmu_notifier hooks that explicit test and age SPTEs without doing a TLB
flush.

In practice, this is very nearly a nop.  spte_write_protect() and
spte_clear_dirty() never clear the Accessed bit.  make_spte() always
sets the Accessed bit for !prefetch scenarios.  FNAME(sync_spte) only sets
SPTE if the protection bits are changing, i.e. if a flush will be needed
regardless of the Accessed bits.  And FNAME(pte_prefetch) sets SPTE if and
only if the old SPTE is !PRESENT.

That leaves kvm_arch_async_page_ready() as the one path that will generate
a !ACCESSED SPTE *and* overwrite a PRESENT SPTE.  And that's very arguably
a bug, as clobbering a valid SPTE in that case is nonsensical.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 58b70328b20c..b7642f1f993f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -518,37 +518,24 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
  * TLBs must be flushed. Otherwise rmap_write_protect will find a read-only
  * spte, even though the writable spte might be cached on a CPU's TLB.
  *
+ * Remote TLBs also need to be flushed if the Dirty bit is cleared, as false
+ * negatives are not acceptable, e.g. if KVM is using D-bit based PML on VMX.
+ *
+ * Don't flush if the Accessed bit is cleared, as access tracking tolerates
+ * false negatives, and the one path that does care about TLB flushes,
+ * kvm_mmu_notifier_clear_flush_young(), uses mmu_spte_update_no_track().
+ *
  * Returns true if the TLB needs to be flushed
  */
 static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 {
-	bool flush = false;
 	u64 old_spte = mmu_spte_update_no_track(sptep, new_spte);
 
 	if (!is_shadow_present_pte(old_spte))
 		return false;
 
-	/*
-	 * For the spte updated out of mmu-lock is safe, since
-	 * we always atomically update it, see the comments in
-	 * spte_has_volatile_bits().
-	 */
-	if (is_mmu_writable_spte(old_spte) &&
-	      !is_writable_pte(new_spte))
-		flush = true;
-
-	/*
-	 * Flush TLB when accessed/dirty states are changed in the page tables,
-	 * to guarantee consistency between TLB and page tables.
-	 */
-
-	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte))
-		flush = true;
-
-	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))
-		flush = true;
-
-	return flush;
+	return (is_mmu_writable_spte(old_spte) && !is_writable_pte(new_spte)) ||
+	       (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte));
 }
 
 /*
-- 
2.46.0.rc1.232.g9752f9e123-goog


