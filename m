Return-Path: <kvm+bounces-61446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D250AC1DE89
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 01:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EC131882524
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 00:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502E01E5B78;
	Thu, 30 Oct 2025 00:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gSIybInV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A811A9FB5
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 00:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761784152; cv=none; b=D9Bh0wWlHnOVDYkYrWpRry+/ckttqGh/3FVy2SM0wyILLFp6dSJ1zPyyKMssUxv/EFbrX5XdRquJ76DyrLkgGulJHL43Lgf2ErqRQtmwxe0xpPLWED9CSuoGWWsPL/hdD34XinYzX/aC9nhnZvfLrBFpacERWIeVXGbMVvWTjY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761784152; c=relaxed/simple;
	bh=IkJ6WMBTGrVBxgIBRaidIdM4Yc61NPhgAuDkcelvNGo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ENN/rln64I92+nNUZ1SFW3RRfPR//6fXni7Sal8YFkpzRTD0pKqv0O86UAJRWvFkWk6TKs+giMOBlCj8MMpDrnnyAU9njL+U8LD8F/2Zo1DkUiLcfsgYUoMkwNqEAikwd7+A5vdXqzTG1l7tkAKV0jATBP8hRgTotG3pJ67MzYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gSIybInV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3304def7909so420563a91.3
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 17:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761784150; x=1762388950; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h8trZMp6xkPXOE6vxOAKGI3QwsIAYM3Kj5aUZgfH7Q4=;
        b=gSIybInVXsO5yVuG5e3SOBaIEmlZxmTFDbGBgd8eMk9UHY0J10I0+XE/9IXPHWmDgs
         MBxWus9X+CnOTD3o7UgnD0pgr7lMEG0tq99nf9cZpCPEmM2iuzOUPPtVWMpE/Tc9ZtMX
         vsSKUO3UfCUsmBXCRKRvvFtCJn3eKYjNzHaPjLrW7S8RqDSzBYkeD4KZNXgzc4/A1L6E
         LbbtftQMvN3aJhzIUj+biqoYTL8n6r88KqqETIgGaf7hFjOd1jgg/68wPdPPMFUqnJAK
         rYb8zj3u9z8Z0NA8B70h58yswKvISo/nVe3/Dkn4zE8lInOhhZi3jgvrbmThO8Exo/fL
         QAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761784150; x=1762388950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h8trZMp6xkPXOE6vxOAKGI3QwsIAYM3Kj5aUZgfH7Q4=;
        b=hbZxjtp8JOU2BD3tp5B9/lZH3R7Q6gBv7ay7mV3Wnzp/2yS2wbJ8wGMfwhLKV4OseQ
         Mkp24kDkfMBMJdP/1n7wvdiaSmKSBjKEQFrvFa5uG+L2e4VRWZJehCcyabI4beYbX6Bm
         abjUiAZSe7quDTP4SAdG+m11UPhaBsEr6Q3Sjjroz0z35slroKykURRlRL6068Wdoo1a
         EsCJk+brjKOKbktw3YD2CQapqAxBpcqq6YcWelPHO1q9FxPnB3BWw6R7MK2PCnWCPRg8
         iptDWSdVIiovZdUj9kdnwy638BtYq+qINKFDUvbBUE25X4Pz5O+KaJWFPwTh9g/AyM6V
         7E1g==
X-Forwarded-Encrypted: i=1; AJvYcCXkQCnoHSJSaNpCzZm8GvnpGqZTVgu/dZ3IrZyy8rpu5ecPO/yL8vEb5POLbSaWsESm+40=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9XuzoBtAfPplRrTwvwAM6W3DhN03ysp5XmqhhJw6y2LuNy28C
	CX9ZAiqc59f2E+dAhQjHUFi+OAbnk3cwSpwFJVn7aCe9yrPRdrirnm+CQ7O78E1vBw75uwr7DFO
	AP2eciQ==
X-Google-Smtp-Source: AGHT+IEzRzzR2WXgH/sykv+W6W4Cap4yoCVR7DOB6Kie+N47XHeh5QxUDLeuGLOlEZd4Wopinxa9w7abyZQ=
X-Received: from pjug14.prod.google.com ([2002:a17:90a:ce8e:b0:334:1843:ee45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ccb:b0:340:299d:f746
 with SMTP id 98e67ed59e1d1-3404c3d7690mr1559614a91.8.1761784150386; Wed, 29
 Oct 2025 17:29:10 -0700 (PDT)
Date: Wed, 29 Oct 2025 17:29:08 -0700
In-Reply-To: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
Message-ID: <aQKxVLoS2MzBiSIm@google.com>
Subject: Re: [PATCH 0/3] Unify VERW mitigation for guests
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Pawan Gupta wrote:
> ---
> Pawan Gupta (3):
>       x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
>       x86/mmio: Rename cpu_buf_vm_clear to cpu_buf_vm_clear_mmio_only
>       x86/mmio: Unify VERW mitigation for guests
> 
>  arch/x86/include/asm/nospec-branch.h |  2 +-
>  arch/x86/kernel/cpu/bugs.c           | 17 +++++++++++------
>  arch/x86/kvm/mmu/spte.c              |  2 +-
>  arch/x86/kvm/vmx/run_flags.h         | 12 ++++++------
>  arch/x86/kvm/vmx/vmenter.S           |  8 +++++++-
>  arch/x86/kvm/vmx/vmx.c               | 26 ++++++++++----------------
>  6 files changed, 36 insertions(+), 31 deletions(-)
> ---

Any objection to taking these through the KVM tree when they're ready?  There
will be a conflict in vmx.c with an L1TF related cleanup, and that conflict is
actually helpful in that the two series feed off each other a little bit.

