Return-Path: <kvm+bounces-49714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 857C7ADD01A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C23AE1887CE1
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2A9202961;
	Tue, 17 Jun 2025 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sp6cQCew"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9CF1FAC42
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750170986; cv=none; b=By3KfHSw3cagaPScmF2/Bp1za/WLx6uCS6gZwO4gsSrjUg0sf/LleMqRny0Mifi6vLcWY69plvgY/w88f+AFCJXfg8luX1/yx6M1w6MrMR+cflj2BTSPpGtRl8Ni+QLXARDiimoUe8VJkvtITBun//vJifyCdN3BS9s8kMEcv4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750170986; c=relaxed/simple;
	bh=XascYBoc9NckCIIv+PQoeUxYqjNPXzZSnGc/V/kEwjs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q3eMZYZKXKpa52ztfET87GhWeRIj9aesaUDBjeJkXg+2/CWMk0fcHvIrMOYuLKmhwQpiwQhjFte3w+1gWU7knbAE6Ej8/7W668fvOrmpjfc3pcFTecuvJPbEVQwHbPGPkQkiHLOyJa4cT4fd+JQsuouvzdt9W2y81ehIzDxDI80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sp6cQCew; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7391d68617cso5369870b3a.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 07:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750170984; x=1750775784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uMwlSkCNIqJfHOH66+3JA30LqpAbnp8KrvmDSuhH/Ag=;
        b=sp6cQCewnH92bNA3UZI8X8hP07fmWYuMOsZFn/8O65BPTv+z6ZCvPu/ojtyUV9SXvX
         mBCG2EjVcEoFmAZCBOuDLT33Vd44Vh7RAEfY5L8JEhdB7+lCH4nlES0WGb7lKDB3hM9j
         Yiskl6ZyWJsFjhGboi7+YTS22KwCkUwqKNBe3PZkQykFY/Dk8Azlp2Ey1oOdJydzLh4c
         8ilxDWLLMRpUiug3LF64R1HDJUDQZaJaHd8Rv9TGhb2Z9MypVYwa6GIiFUwEeZA7Nuq9
         6sKUgt/Km5ayiEjNHf5U3B36Uy42B0IQ9WmXSoZyPeb3iXT4kV4UHv39vqQ651MOr+u2
         fTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750170984; x=1750775784;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uMwlSkCNIqJfHOH66+3JA30LqpAbnp8KrvmDSuhH/Ag=;
        b=PO+V5+07VJj6LyzZw5jehWUxgJgP9nVRf7nb6Nsbw1jkOjm7MEjd0tK9wklQooviOU
         oNyntEnvzFQa9SE9TBi73ifT1F765CAUe1/qkSxhxvzHuBJ+lIsQQoZ3fUNuDJWBWzYW
         OwkhDFkSn0hxq865sWSLmTbFATCUQgI4YRYdKDPvKPaCV4BeGojdgknSoJ3e6GgwhMu5
         68j7qfnkyjUQoW84Q2PIkgSM9PmmomUCCJHjs1nmN1TFEVp067Fx/l0n6MOVsXX9baOx
         UfRl9pkY1bDBmOTgA+1uZ0b3zj7TX+VeNLUun+1ixdm8TvJK3dhqupZ53i4adtNCZyBK
         bIDw==
X-Forwarded-Encrypted: i=1; AJvYcCU1DYwRP7k9oRBa7REWfiobE62WQ8UrTQ226kl4Wi4evZAFDH5jfwjEcKNK7tts8/Jk1WA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9vDZYkVAeaOYtGx+wORqCTGA0Pj+kehzJ0Ismd5GmqCMitMx1
	HlppdR2u56VKeoslLICnCr4embZmSbi395uauviBZ+AFx1RO+6lfgiOR8gCfnp8+WjhUn5E9ZQF
	FNGsSyA==
X-Google-Smtp-Source: AGHT+IFdJLXMZEEu8DdlQZ+U+oQwIvzvdGgAICIJ+geqiAScmpG1InwG5WTe3wRE1wV8wV8tzAaYKmdEpJA=
X-Received: from pfnw6.prod.google.com ([2002:aa7:8586:0:b0:747:a8e8:603e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9181:b0:748:a0b9:f873
 with SMTP id d2e1a72fcca58-748a0b9f8d2mr16220059b3a.9.1750170984466; Tue, 17
 Jun 2025 07:36:24 -0700 (PDT)
Date: Tue, 17 Jun 2025 07:36:22 -0700
In-Reply-To: <CAK9=C2WFA+SDt4MCLj0reQnkkA2kxUmfWhT8HZxjT_DdW8W_rQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
 <20250611-352bef23df9a4ec55fe5cb68@orel> <aEmsIOuz3bLwjBW_@google.com>
 <20250612-70c2e573983d05c4fbc41102@orel> <aEymPwNM59fafP04@google.com> <CAK9=C2WFA+SDt4MCLj0reQnkkA2kxUmfWhT8HZxjT_DdW8W_rQ@mail.gmail.com>
Message-ID: <aFF9ZqbvZZtbUnGt@google.com>
Subject: Re: [PATCH] RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
From: Sean Christopherson <seanjc@google.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Andrew Jones <ajones@ventanamicro.com>, zhouquan@iscas.ac.cn, anup@brainfault.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 15, 2025, Anup Patel wrote:
> On Sat, Jun 14, 2025 at 3:59=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Jun 12, 2025, Andrew Jones wrote:
> > > On Wed, Jun 11, 2025 at 09:17:36AM -0700, Sean Christopherson wrote:
> > > > Looks like y'all also have a bug where an -EEXIST will be returned =
to userspace,
> > > > and will generate what's probably a spurious kvm_err() message.
> > >
> > > On 32-bit riscv, due to losing the upper bits of the physical address=
? Or
> > > is there yet another thing to fix?
> >
> > Another bug, I think.  gstage_set_pte() returns -EEXIST if a PTE exists=
, and I
> > _assume_ that's supposed to be benign?  But this code returns it blindl=
y:
>=20
> gstage_set_pte() returns -EEXIST only when it was expecting a non-leaf
> PTE at a particular level but got a leaf PTE=20

Right, but isn't returning -EEXIST all the way to userspace undesirable beh=
avior?

E.g. in this sequence, KVM will return -EEXIST and incorrectly terminate th=
e VM
(assuming the VMM doesn't miraculously recover somehow):

 1. Back the VM with HugeTLBFS
 2. Fault-in memory, i.e. create hugepage mappings
 3. Enable KVM_MEM_LOG_DIRTY_PAGES
 4. Write-protection fault, kvm_riscv_gstage_map() tries to create a writab=
le
    non-huge mapping.
 5. gstage_set_pte() encounters the huge leaf PTE before reaching the targe=
t
    level, and returns -EEXIST.

AFAICT, gstage_wp_memory_region() doesn't split/shatter/demote hugepages, i=
t
simply clears _PAGE_WRITE.

It's entirely possible I'm missing something that makes the above scenario
impossible in practice, but at this point I'm genuinely curious :-)

