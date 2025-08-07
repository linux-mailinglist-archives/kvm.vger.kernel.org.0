Return-Path: <kvm+bounces-54268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC45B1DD3D
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B39C9627245
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 18:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A126226CFF;
	Thu,  7 Aug 2025 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ISOlgKj5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9821FF55
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754593096; cv=none; b=Gj4cqkFwTcnqS5qqJaazdloHBEkI6/cI/dtNRv5EjBN6vYqEAqOirAf7xKpEE1CLIMvqtbGHfgm/4rEMPCo+jWlpDvowu65do1Uk7+uRsjY6x1xpilh8N6F41tGz4jdk4rJApjqZr2cJARVEybEcJiwxH/cWeBhDInEv53spivQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754593096; c=relaxed/simple;
	bh=MuhIPyi2F5+ipcNc957b0wI7HllbWh/lbIIst2ORD2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TneHuQ0CBq42Ffs+sBaCWasb2aE+m7LXWroWIPxi7ybP2XK6wLU69VCKGsUmJNmCsHYh6vzmVK/i2EJCcHEOR1N3+W5HXo/uP//oLFDM8lfCEjdIarX/OssBEeLhg67Bx7QY71mgXZUCcsLasGWPKDN1RfSUL/kHu6YodcOcvjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ISOlgKj5; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b099118fedso59761cf.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 11:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754593094; x=1755197894; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=96362UVupe8COf1P6wW/mjtmbdG3wWxnQMi7BMOUIUE=;
        b=ISOlgKj5UPRwKsKRT0fvJs/VjevZ5F51s67VmcltqSE7U/yxGfriq2M79TbfX5nXPL
         sIhbMGHdBEo9QLD0dUFmdd6/PoI2BnTxbG3aI9tEHsRKfRFeOp//4yNWYRRs9mtmWWEy
         3d05ltVM9q0bi6kxh+HDAXVc4FF5xOl1GRozjkWV/vUHn/rdU1FDXQgBskJbIKZO6A4r
         7HMPcan11p92JOJpm8EGerNHUfpBw8+DT0RnJ8ahNIki7csClzFYxopx50rV9nR3VeIC
         Yic+1jlLMXOfVzGPh/j/savlM0vKk5JoNXPUPyX70liV54btLr1uMab7zKTo1WSofi6/
         fYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754593094; x=1755197894;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96362UVupe8COf1P6wW/mjtmbdG3wWxnQMi7BMOUIUE=;
        b=GucLBuAba+naZMKbqoWca7QO3QkjBlQ76OxPaSMZstY2jq2vGvwRk0oOp/kgUuGeSi
         tgQh+pvUcoBhiqpymiV5QoBqTNwRtQHhxQprzkX0j8raE54E+Sy0EWLqVY1/wl/9qCOZ
         Hc0Hc2mMvJboG7qKGUP6VDU+tq3ZCa/2BKQaSBy8aN6vUGK9e1j1FX6EwbL/HjwAiOq7
         55bYLn/DUYghuEoRBEvsBzrL0wVx/gzYdJ/+in65GrsVYIqTYXhS1sk+qZLKyfshcM1e
         p/VMTX/fnFqTGsSj6FvVHppPIiBvLO8KviCW0+cGtS9rAB3PgVM1iZXDU38AuVVyckie
         irEw==
X-Forwarded-Encrypted: i=1; AJvYcCXZ/o2e3uTB3v0/YbJlFbzD/Yp9jJYNgMV/DldHrwtF08nKp14SM6aMh+JHcN2yuSLAApk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBNIgxwXYISCPUhnGLn7D24OXdaCA95iJwFYR92hxWwNVuEJl4
	TpaKfeill/B7NkX8RoXwXuzY300/bPAXDj1SUm6TJDOxvFVW5X29bFgyceYpqfpZJs1CzaYqe5P
	p5pduYVBTFM0iLRZGJYmv+pwVKZtwy5pWIXOF/n4ZKRGnDba0RJ/XOG7T
X-Gm-Gg: ASbGncuZ6TlNWCinSWZrTc28Oc4aCzM7qbEOK/6veehtz/xCJi902MAS+OOPWGXMlcl
	+u93suXAX26t+Skhzduwg96ePKMp/f7fFMWwlfwUsH8MRDxPHrrIkN3jC5yGAVY/WW559VRmcO4
	aaApxDYzcBGV2U2Za94rjYy6Avw+hVksqShbdQ6TbmGxeNZPo0lBpigy66yIRvWCrS+QGgLhvqy
	AmJY2nHn7v07zfbp0mzWt8xSfE5rCvwo+Nd
X-Google-Smtp-Source: AGHT+IGQv3PJBbuZ1uXQcTT0alJEv27zQP6RUhp/GXkD21PwsG9r1YtfOqnK9qoS+hDRmSRDSNYUz0kE+B4S+clok58=
X-Received: by 2002:a05:622a:a648:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4b0af27a4c2mr270701cf.11.1754593093620; Thu, 07 Aug 2025
 11:58:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com> <20250724235144.2428795-3-rananta@google.com>
 <aIjwalITY6CAj7TO@linux.dev>
In-Reply-To: <aIjwalITY6CAj7TO@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 7 Aug 2025 11:58:01 -0700
X-Gm-Features: Ac12FXylmxDAHRXg2gQCPPXuwIGOmW7c0vzzAhp62yyDvoK-TIuMbTJEHyOdR6k
Message-ID: <CAJHc60wBNTP9SSt_skEXXv9N+tF_1RoV6vcQQx4hWphJF6EmkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table periodically
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

>
> Protected mode is affected by the same problem, potentially even worse
> due to the overheads of calling into EL2. Both protected and
> non-protected flows should use stage2_destroy_range().
>
I experimented with this (see diff below), and it looks like it takes
significantly longer to finish the destruction even for a very small
VM. For instance, it takes ~140 seconds on an Ampere Altra machine.
This is probably because we run cond_resched() for every breakup in
the entire sweep of the possible address range, 0 to  ~(0ULL), even
though there are no actual mappings there, and we context switch out
more often.

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c

+ static void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+ {
+       u64 end = is_protected_kvm_enabled() ? ~(0ULL) : BIT(pgt->ia_bits);
+       u64 next, addr = 0;
+
+       do {
+               next = stage2_range_addr_end(addr, end);
+               KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
+                                                            next - addr);
+
+               if (next != end)
+                       cond_resched();
+       } while (addr = next, addr != end);
+
+
+       KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
+ }

--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -316,9 +316,13 @@ static int __pkvm_pgtable_stage2_unmap(struct
kvm_pgtable *pgt, u64 start, u64 e
        return 0;
 }

-void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt, u64
addr, u64 size)
+{
+       __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+}
+
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
+{
+}

Without cond_resched() in place, it takes about half the time.

I also tried moving cond_resched() to __pkvm_pgtable_stage2_unmap(),
as per the below diff, and calling pkvm_pgtable_stage2_destroy_range()
for the entire 0 to ~(1ULL) range (instead of breaking it up). Even
for a fully 4K mapped 128G VM, I see it taking ~65 seconds, which is
close to the baseline (no cond_resched()).

--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -311,8 +311,11 @@ static int __pkvm_pgtable_stage2_unmap(struct
kvm_pgtable *pgt, u64 start, u64 e
                        return ret;
                pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
                kfree(mapping);
+               cond_resched();
        }

Does it make sense to call cond_resched() only when we actually unmap pages?

Thank you.
Raghavendra

