Return-Path: <kvm+bounces-64232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 30EF0C7B683
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:58:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 351CB4EB1D3
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A922FB990;
	Fri, 21 Nov 2025 18:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iB1moKmH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61BE2FB621
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751389; cv=none; b=MRRzazmMTACNkfEuD65XFmJD4LgYOwZRRM7ubDQSAqBcyPCkjsv+NQm/aNBTLK3sJybJNCoIkDIXBBzljODlZaHkINntqbYIsz8UraJM/1wESht1vfVLu1DHTUznfr/mFZBZUR6X1a8Cs8o9IOGToflCiQhvePjateWFZL73yYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751389; c=relaxed/simple;
	bh=Mam3IaCSYNQIHQjQmaJhgMMCKOY2hqFTzjd1CT1BebM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mo4j+wOIsVtU/qAD5tcLgNnitN7zxs4WV2B4iVUFhWdgNM5MfiiKkPS2OUK4lGGLnGksGCW5MTurokYMgRWGhL/eKEEv7KIQaPNmSrFUJD9WrJsszu7qO0GbkqOoxTdYsI4sEdf4w6D74v094bkiqXQStgeniU037NeK4hY42KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iB1moKmH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438744f11bso6540074a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751387; x=1764356187; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=45zCnBoYmBhO4CIZaEyDRG4f8mKY5mBvoMM1LyIYOfU=;
        b=iB1moKmH4xqlv9OOJujoJVoacqBLLqEcH4zgijfkhaU+y36VzRRTyHGwCbdIvAAhgZ
         lNVeoFW0xhuzXV6ZXY0x7Slk/qOmxsKOKUHY6bvgCtD6UnyofHs4NVZFUPgZpRpwkHEI
         b4opaQZkB6oWBpISEjJmVznpYyoQjC79g/NtALZKj+UaTLI0DKehj/t0seBYC9pFuzZ4
         BLkPr5Ue3wj2mkCGkEZ7wVj2jdU/CnsDf1GFonpJaMqF+yBLA3nEPj/ZNU8jpKxzmGzl
         LaEi58sJwj02E6hhB4SxOgZsc5qgdbOdTpA5lZjfMPuUP3OMSjkYdEcyC4tjYoAI4l7Z
         Gd5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751387; x=1764356187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45zCnBoYmBhO4CIZaEyDRG4f8mKY5mBvoMM1LyIYOfU=;
        b=pSyZCTZXjDCN8GxjRloV6/CoKEzxcGcnaeHuJkTPFE1vcZIXdfge4vnUpN4AXla2DQ
         ijFKeEqKV3KwvVuax4ts3/XbEBFmFUwj2w3OYjBLfdzxZRFDYHENld69/yl3ejG2LQlU
         kHT2n89GXJgXMNj7KhA2Pq/Iz5SFkcweWLoIgYJ5gokyC5uziS6uZYWKy+8i85i+6YKQ
         jOR8Ab0gsw1+taGC+PYLeIQsySXwL3lwXbbcpAWvmb8/fhBjbRqz2VA2vv5Lk87nPCyx
         OYRMmFL1wg0ucCLqLJrt0Lsl2uk/NSALtYY8B52Jkem9owSxg0iy+0z26g/cWuAyPOfE
         zTkQ==
X-Gm-Message-State: AOJu0Yx4MN+B8JX1c+UYD4OH5/E0UHIKGXNuRQcsWl2i5SbbBYLAt6v7
	6WFnFIDq60RR/YZGJ4StsY0B7SVECfx+juNIegkHrp1CPyMGE4JR2/jJRbvxVvFbx/ZDAU0XA/v
	1T5tnbQ==
X-Google-Smtp-Source: AGHT+IGghlbuYkW4ZbMkRVWX5VL6OyPvP4JN4m5PFSB/ZDMZcOV7CESskQGd43ILfS4/p4Y08KJla/xXVeM=
X-Received: from pjtz18.prod.google.com ([2002:a17:90a:cb12:b0:343:387b:f2fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cc3:b0:32e:d600:4fdb
 with SMTP id 98e67ed59e1d1-34733ef71f2mr3983496a91.18.1763751386921; Fri, 21
 Nov 2025 10:56:26 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:33 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375130260.290408.7905795529465965518.b4-ty@google.com>
Subject: Re: [PATCH v5 0/9] x86/bugs: KVM: L1TF and MMIO Stale Data cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 15:37:37 -0800, Sean Christopherson wrote:
> Clean up KVM's handling of L1TF and MMIO Stale data, as the code has bit
> rotted a bit and is harder than it should be to understand, and has a few
> warts.
> 
> TL;DR:
> 
>  - Unify L1TF flushing under per-CPU variable
>  - Bury L1TF L1D flushing under CONFIG_CPU_MITIGATIONS=y
>  - Move MMIO Stale Data into asm, and do VERW at most once per VM-Enter
> 
> [...]

Applied to kvm-x86 misc, with fixups for Boris' feedback.

[1/9] KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
      https://github.com/kvm-x86/linux/commit/844afc1af3a9
[2/9] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
      https://github.com/kvm-x86/linux/commit/aba7de6088be
[3/9] x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
      https://github.com/kvm-x86/linux/commit/afb99ffbd582
[4/9] x86/bugs: Use an x86 feature to track the MMIO Stale Data mitigation
      https://github.com/kvm-x86/linux/commit/f6106d41ec84
[5/9] KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via ALTERNATIVES_2
      https://github.com/kvm-x86/linux/commit/e6ff1d61de51
[6/9] x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_BUFFERS
      https://github.com/kvm-x86/linux/commit/fc704b578976
[7/9] KVM: VMX: Bundle all L1 data cache flush mitigation code together
      https://github.com/kvm-x86/linux/commit/0abd9610d6c6
[8/9] KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
      https://github.com/kvm-x86/linux/commit/05bd63959a9d
[9/9] KVM: x86: Unify L1TF flushing under per-CPU variable
      https://github.com/kvm-x86/linux/commit/38ee66cb1845

--
https://github.com/kvm-x86/linux/tree/next

