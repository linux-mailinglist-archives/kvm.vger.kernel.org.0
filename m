Return-Path: <kvm+bounces-59921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 085E7BD50FB
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AAFF18A50EB
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 16:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72762798F0;
	Mon, 13 Oct 2025 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JE5e9baQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256C24A06A
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760373123; cv=none; b=UMM8DIKS0TEc6GdjM6HiJD2jSOswat8RZSlFipiFi2Q6bqEpBHNxUyY2+GTyZVcvMgKTw3wF5JZz1jPE0O9dwTyYLRfeN5TKSZ8ZY8AFG8xPUbCrO4VpOj81D1BEu8UXFa74vowez7KNKPMqOfvc9FMcADIhNp6ICe08Tg2Rirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760373123; c=relaxed/simple;
	bh=upittZMdgZGjKq3YijKfi9Xo2kafJXuuaI54gdgXicc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=suQt9nbGC0TDR/ptOO6OTcD0kPQjn9q2sjizSdD/VWUL8JxMK8mvKrhXg2DJxttkfhjMMaT75xwCZ+KWXd1yFYgokV7q78wZBY5gYY1iJ4V8Wadx91um2YPN6s2WQoVyQ+rIdnjiXYQj+kob5c6kdZ3GUUjtjFXhyYQDGHpjpsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JE5e9baQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-268149e1c28so114883765ad.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 09:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760373121; x=1760977921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hWHQvDLvbtnNuJ5ZPW5ZERwCgThDfKad1c4XeVbuOAk=;
        b=JE5e9baQNxELsqVxDA2IX4Ml+m9t8q3dDTSbVK2sVsa6q+2yaGJHJiCsgcNPfPZM/E
         6evnvK2o1ftePuqojHaEraiX9b011chhCnEVNXwcFhM5EXHswft0ryss0SOMd7KYFtg6
         RPBIUvndek4GkNCdeZ6T+zByw307D7XyPysE86ztpx0ixXGB++H4PpHvR+5X/La9Y0/y
         lWRBroEPNSmQmz8udkoAR0B0Mym55AMbrmPOpiNeyqkrX3rr/EmDWYG/o0LIckERYzFv
         YUcGRKcf1YWAafFmih5lSMVF68M1oUNAKjmLB76bjX1AEpwbCFzS4z06rjKb0Fzhk0YK
         7Faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760373121; x=1760977921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWHQvDLvbtnNuJ5ZPW5ZERwCgThDfKad1c4XeVbuOAk=;
        b=fNOqPFoSRooMXjRFYCf0uj7qWSswDvnMumJMrxpUs2+8o9JvrpYHiP6ZVtux9zaWlG
         He8b393fy8grdN7MgKnnCus99psjCwlqXGHAz/9ttuxLvi2roaCy7PWatQ+pNqBQ4lgh
         bFFm0BYROe92nkL2w9ZVi74xIegbbi2NCaRPy+IcjpS0FlDvFHgkfwP9yFkdHZlpF7o+
         j5VOGzXqAN2z6w423QsFFJLpqacHQf/HSxrbKEH3pPee2vJTrnrLsCAYj8t6F9ha50O9
         XiYAv3Vzq3piTERMlG9mR6UFG34lFnjdqqizQg9bm3g0m4IfMZyfV1OdyN8wKxUmuxks
         nZ0A==
X-Forwarded-Encrypted: i=1; AJvYcCW+Pf5INOgXNUMCQ4bcIN87yzS0jDxmBSwC4pD9g+/n+il9/0BsSwEFT5S1Vo20GEkajSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFGfFgsdcfSvd6OQekdnXVkHjiVYkCX0fY6GwcBYaFeDM1cOLx
	27Y9JbiUcD72XNfw4SsfUKXGIsGD7WC/tuziC2UBS+Y9FZdMSSEqrmVoXbKfeebj3Uefmf6otDC
	GYdxs7A==
X-Google-Smtp-Source: AGHT+IFGIoervvDCIFQ9baCk/TDNl+kDH2WM3OfJCpawPPFU8GQwMwV0dTeJ1XWLoXX14O/Jb5+a0MvNnnw=
X-Received: from plsk7.prod.google.com ([2002:a17:902:ba87:b0:268:505:ab8a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc4f:b0:280:fe18:8479
 with SMTP id d9443c01a7336-290272e0ac5mr240287225ad.51.1760373120827; Mon, 13
 Oct 2025 09:32:00 -0700 (PDT)
Date: Mon, 13 Oct 2025 09:31:59 -0700
In-Reply-To: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>
Message-ID: <aO0pf8h8k0NddyvX@google.com>
Subject: Re: [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 13, 2025, Brendan Jackman wrote:
> Currently the tracking of the need to flush L1D for L1TF is tracked by
> two bits: one per-CPU and one per-vCPU.
> 
> The per-vCPU bit is always set when the vCPU shows up on a core, so
> there is no interesting state that's truly per-vCPU. Indeed, this is a
> requirement, since L1D is a part of the physical CPU.
> 
> So simplify this by combining the two bits.
> 
> Since this requires a DECLARE_PER_CPU() which belongs in kvm_host.h,

No, it doesn't belong in kvm_host.h.

One of my biggest gripes with Google's prodkernel is that we only build with one
.config, and that breeds bad habits and some truly awful misconceptions about
kernel programming because engineers tend to treat that one .config as gospel.

Information *never* flows from a module to code that can _only_ be built-in, i.e.
to the so called "core kernel".  KVM x86 can be, and _usually_ is, built as a module,
kvm.ko.  Thus, KVM should *never* declare/provide symbols that are used by the
core kernel, because it simply can't work (without some abusrdly stupid logic)
when kvm.ko is built as a module:

  ld: vmlinux.o: in function `common_interrupt':
  arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2b56): undefined reference to `l1tf_flush_l1d'
  ld: vmlinux.o: in function `sysvec_x86_platform_ipi':
  arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2bf1): undefined reference to `l1tf_flush_l1d'
  ld: vmlinux.o: in function `sysvec_kvm_posted_intr_ipi':
  arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2c81): undefined reference to `l1tf_flush_l1d'
  ld: vmlinux.o: in function `sysvec_kvm_posted_intr_wakeup_ipi':
  arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2cd1): undefined reference to `l1tf_flush_l1d'
  ld: vmlinux.o: in function `sysvec_kvm_posted_intr_nested_ipi':
  arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2d61): undefined reference to `l1tf_flush_l1d'
  ld: vmlinux.o:arch/x86/include/asm/kvm_host.h:2486: more undefined references to `l1tf_flush_l1d' follow

Because prodkernel's .config forces CONFIG_KVM=y (for equally awful reasons),
Google engineers completely forget/miss that having information flow from kvm.ko
to vmlinux is broken (though I am convinced that a large percentage of engineers
that work (almost) exclusively on prodkernel simply have no clue about how kernel
modules work in the first place).

I am 100% in favor of dropping kvm_vcpu_arch.l1tf_flush_l1d, but the per-CPU flag
needs to stay in IRQ stats.  The alternative would be to have KVM (un)register a
pointer at module (un)load, but I don't see any point in doing so.  And _if_ we
wanted to go that route, it should be done in a separate patch.

