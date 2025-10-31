Return-Path: <kvm+bounces-61718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A18C26662
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2AFED35227D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B94A31618F;
	Fri, 31 Oct 2025 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qsMSgnyf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9DC3043DA
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 17:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932185; cv=none; b=aPSJRb5qlGtAfuLwzxLYmV340FhNDwUlcKpb4FV7QviZ0wMnsQ3zcqzi70ruuH1IWc2WZn8yOGZmGC4FJ5/O0JgwWbuTTXbvJOH6vcPBLuHWcX7Hp3/gaEEfibDucR1/8AinwmfyG6o9fZekgV6Qj7r1xazhL8/0FUJcSXrCqv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932185; c=relaxed/simple;
	bh=wUmtHEk1Kb8QxeKkuMpwMU+pOoW2GV8Wfxxk4HiDohA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NCBWtvXTDoodAG+snxuvgZ9rxeCo0xj5BCvF1oo+C87fG4aGTLVSmennKheSAj8U9sKOyBEZJ45cQTUKf94UobmR6FxRgp8WOZncvrsRYJiECWnwG7so7zoLD/rBBKnRB6Xmsp+IgUuDOtfp6UnWijS2gYKUbs4YZt4t2Hkdm1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qsMSgnyf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3409a1854cdso1728961a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761932183; x=1762536983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oS0ZpZF16YCRh48Rs9UtzBxLRJbtN+FTBVVUS4s8+a8=;
        b=qsMSgnyfRor2UE/nFoK1IhQ/pruLpfOVdRerunVFws8PttxqDYTcp4SDPCcKA6Grqi
         KTYABmb1172VlIj1cQis4lyyKHcuDUrm2P5suk4xYcVQJDkHE1sDFIduSOlqEtVcTrhY
         Dedw9M309cema+aK9fPmn0RSrM/at0j/W7eKXs+NzqywNBznl9Ou+vSJOq/39BuUMT2B
         vcUNY/GCkdKQFNAGzT/FFzyOTOPGdLdWARbPLr/9INFcsrj88AOzbHnr596jw7E+qvpZ
         a7iM5GuvhEptgidX8fgIIL0+OxjHktTTjYszAGwoSdwRR4I2YmfE62Xbde7SFU6oE7+q
         C0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761932183; x=1762536983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oS0ZpZF16YCRh48Rs9UtzBxLRJbtN+FTBVVUS4s8+a8=;
        b=maYJvnGsUZbYgxuVXoDrYGG+VWeJjkGgn44N8jED/DvMuciAdL+JewQrwn2fQNU61B
         1CkrdpUHrF/QDYj5qNty24Fsop/zfi+inU1oEqdvz6KlHaHAvUnlm/jOhRnLQlaIuI20
         sbusZVPKEVjeQevZx0trI2pTzH3j0crLqMHI0WtLyWJNnHBM8wjO6ITVjISBJqCxX3fW
         GRuGJyMTT1n3FkQIGbXX6Nj46jZOBRPaOjcupPYUOW9Sr1MGV5c1XwSDBz2YDHJ5MCPn
         HJkic0ZBp6jA39myqWs06NPmd6PClehDWHK7FvA89DPZDz87fh04ATktjATG4MLSckl7
         ogCw==
X-Forwarded-Encrypted: i=1; AJvYcCVs+HmFh/PnTjOLoem9r0FqP9SVTkPLCXNKftkZG9Yoy77KUpDm/5ekZLvpVkHlDefKhdI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/n9liIAfw34XVOR1nMOpbaKtU+bcsa8ZApoQsZ5X0rt0b+vL0
	sGgYFsuQTy6lxuNSJSBHT+XA9PiuMfLyBnx1OXyoZgSFQe80dBsql3Ppta30vD567Qu0oOv3miN
	ev9ZMKA==
X-Google-Smtp-Source: AGHT+IGwWg806+ynAXsdzVM9jfhS677Oh5vXzRS9qR3coFaO6PIQH8mB/qMPv1Z4pIKbcAcNDhRMXaUHW+Q=
X-Received: from pjhu60.prod.google.com ([2002:a17:90a:51c2:b0:340:7740:281c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fd0:b0:340:6b5e:7578
 with SMTP id 98e67ed59e1d1-34082fc645amr5860376a91.4.1761932183557; Fri, 31
 Oct 2025 10:36:23 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:36:22 -0700
In-Reply-To: <DDWGVW5SJQ4S.3KBFOQPJQWLLK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <DDWGVW5SJQ4S.3KBFOQPJQWLLK@google.com>
Message-ID: <aQTzlivZDrT_tZRL@google.com>
Subject: Re: [PATCH v4 0/8] x86/bugs: KVM: L1TF and MMIO Stale Data cleanups
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 31, 2025, Brendan Jackman wrote:
> On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> > This is a combination of Brendan's work to unify the L1TF L1D flushing
> > mitigation, and Pawan's work to bring some sanity to the mitigations that
> > clear CPU buffers, with a bunch of glue code and some polishing from me.
> >
> > The "v4" is relative to the L1TF series.  I smushed the two series together
> > as Pawan's idea to clear CPU buffers for MMIO in vmenter.S obviated the need
> > for a separate cleanup/fix to have vmx_l1d_flush() return true/false, and
> > handling the series separately would have been a lot of work+churn for no
> > real benefit.
> >
> > TL;DR:
> >
> >  - Unify L1TF flushing under per-CPU variable
> >  - Bury L1TF L1D flushing under CONFIG_CPU_MITIGATIONS=y
> >  - Move MMIO Stale Data into asm, and do VERW at most once per VM-Enter
> >
> > To allow VMX to use ALTERNATIVE_2 to select slightly different flows for doing
> > VERW, tweak the low lever macros in nospec-branch.h to define the instruction
> > sequence, and then wrap it with __stringify() as needed.
> >
> > The non-VMX code is lightly tested (but there's far less chance for breakage
> > there).  For the VMX code, I verified it does what I want (which may or may
> > not be correct :-D) by hacking the code to force/clear various mitigations, and
> > using ud2 to confirm the right path got selected.
> 
> FWIW [0] offers a way to check end-to-end that an L1TF exploit is broken
> by the mitigation. It's a bit of a long-winded way to achieve that and I
> guess L1TF is anyway the easy case here, but I couldn't resist promoting
> it.

Yeah, it's on my radar, but it'll be a while before I have the bandwidth to dig
through something that involved (though I _am_ excited to have a way to actually
test mitigations).

