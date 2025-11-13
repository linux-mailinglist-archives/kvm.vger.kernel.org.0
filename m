Return-Path: <kvm+bounces-63055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 793CBC5A479
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CF213BA5D2
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880DE325730;
	Thu, 13 Nov 2025 22:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BrI0emK1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E4B30FC21
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763071289; cv=none; b=sDVzVyzrsKHwv/hFIY3DokGR01JGgS4Wnie5gloKKMwXO55aWqXthNl6VjUAKGKrICs3G+0pRYb/b30KcWtGumvltDgc6hMg8DGT+Eha4PI/E86z7t4K6ODv8ccGIs8DzTRffjXgvb2QL4HSp1PpAUAjTz1domXGj43FGbQMio0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763071289; c=relaxed/simple;
	bh=cFo/2FWZAefgnCwiQcYKQrwsDw+guU7l0RE0dn492Xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=saz1lkKPge3FPxoqGStsGByFVrYlpeoaUcQpylEclHjWOTUPDmxgDoW4Yd+X2bIHHCgoMR9Z9i7ItEYUyURAtduCpYg5s9UvlCWkFI/R7h8qjhF5F52O56mHUEXqt0hannSfMJ3QgJvcGvJ61570JQJpNq+rr2myh3+GfH8MB+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BrI0emK1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29846a9efa5so32304255ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763071287; x=1763676087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1BDlpkIBziB9BZysiW/dDWMpz8bsQ1z6Y1o8U9LGSA0=;
        b=BrI0emK18mvnDctzlLBLMxIjrcFCvQf7yWyTdgngMdTHD8qaBAEEr9/nRgcs4/p/Fz
         OaOQRgwqLlTU/T6T4qiCHHpGAnqaLwMdI9jEhr65zPmplSFwobiYOTksoccJ/dW0p/w4
         fbZ/YtT4+BTuUFXZk6rkNuJ7tYbYbsxVBirX+LBpIBnhsUATaDOdlTOYoJkC5dhI9Chb
         WJHziXrAGSS9/h6HWSJuOC6P3GTZm02GZ+spEV7cJYCJFMp7a/jmTsy6bPXE5/T5xciN
         KTKqjOVy3jt3XgZsUnZZHJh5LPesMXhJtT2kC/VIKSueHiurm9YfaPfR1oLrV8YEVRi9
         PmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763071287; x=1763676087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BDlpkIBziB9BZysiW/dDWMpz8bsQ1z6Y1o8U9LGSA0=;
        b=YMWCo0D79qKm43fHBq2+Ma7xhDqzKWksMNgNnBfj31sZM+dg/cM9ICdKk2VGvUI8qj
         RYatqtTuac239hlHxMkRFtCNmylsk/XSHNukudYIUOrbg+uODb8Tn+zEpMQxLNZQBq6P
         bKe4xOKFyRz4lF3A/Syxtce7Vel09SYglG3A4uxypztnrt24UUVugPk+W59zbQ7Qjp+Q
         hCyLQEOakltXEQgadVb4A0aH1TaazAmH/0wCul2vmrk3ViKtGCafHOblORin1PD/cJ/q
         8pCw9LEPza0sWUpZUKIOZAgpexiciwv2CR0nhYj8Y9ZpOUBwRrfyzVISWcHa3UuS2gWe
         57UA==
X-Forwarded-Encrypted: i=1; AJvYcCUKcQaPjbpXxLJtThxHFIRnMuMoSqsViSDVxjVOEZ4isZDY87W+DDDa8fQmt1loXCQoa6I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKFksVxnG2p1QTd801DQUB+kEyS1LPL+UuD06lAcMCdSCj7Duk
	Uc+cApYCXIJbQ2PzeyOx4DUfR/eHvRsoM2KfDNorVDjL5qR3f2NbwgxuWJ5y9Aaqw323+5gvS9R
	YM3Z5Lg==
X-Google-Smtp-Source: AGHT+IFASVlzdNPPzhpykWWag2D93vCUrtxksdAEQWFHLBzEFdqSOYWn6d17jOWheOtfse9Hw/kZF1RRSzY=
X-Received: from plhe11.prod.google.com ([2002:a17:903:1cb:b0:290:28e2:ce54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d60d:b0:297:f2f1:6711
 with SMTP id d9443c01a7336-2986a757cc7mr5814155ad.56.1763071287488; Thu, 13
 Nov 2025 14:01:27 -0800 (PST)
Date: Thu, 13 Nov 2025 14:01:25 -0800
In-Reply-To: <20251113142000.GAaRXpEKHh1oQgN65e@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-5-seanjc@google.com>
 <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local> <aRTAlEaq-bI5AMFA@google.com>
 <20251112183836.GBaRTULLaMWA5hkfT9@fat_crate.local> <aRTubGCENf2oypeL@google.com>
 <20251113142000.GAaRXpEKHh1oQgN65e@fat_crate.local>
Message-ID: <aRZVNWFBPAQAtlWL@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Borislav Petkov wrote:
> On Wed, Nov 12, 2025 at 12:30:36PM -0800, Sean Christopherson wrote:
> > They're set based on what memory is mapped into the KVM-controlled page tables,
> > e.g. into the EPT/NPT tables, that will be used by the vCPU for that VM-Enter.
> > root->has_mapped_host_mmio is per page table.  vcpu->kvm->arch.has_mapped_host_mmio
> > exists because of nastiness related to shadow paging; for all intents and purposes,
> > I would just mentally ignore that one.
> 
> And you say they're very dynamic because the page table will ofc very likely
> change before each VM-Enter. Or rather, as long as the fact that the guest has
> mapped host MMIO ranges changes. Oh well, I guess that's dynamic enough...

In practice, the flag will be quite static for a given vCPU.  The issue is that
it _could_ be extremely volatile depending on VMM and/or guest behavior, and so
I don't want to try and optimize for any particular behavior/pattern, because
KVM effectively doesn't have any control over whether or not the vCPU can access
MMIO.

> > Very lightly tested at this point, but I think this can all be simplified to
> > 
> > 	/*
> > 	 * Note, ALTERNATIVE_2 works in reverse order.  If CLEAR_CPU_BUF_VM is
> > 	 * enabled, do VERW unconditionally.  If CPU_BUF_VM_MMIO is enabled,
> > 	 * check @flags to see if the vCPU has access to host MMIO, and do VERW
> > 	 * if so.  Else, do nothing (no mitigations needed/enabled).
> > 	 */
> > 	ALTERNATIVE_2 "",									  \
> > 		      __stringify(testl $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, WORD_SIZE(%_ASM_SP); \
> > 				  jz .Lskip_clear_cpu_buffers;					  \
> > 				  VERW;								  \
> > 				  .Lskip_clear_cpu_buffers:),					  \
> 
> And juse because that label is local to this statement only, you can simply
> call it "1" and reduce clutter even more.

Eh, sort of.  In the past, this code used "simple" numeric labels, and it became
nearly impossible to maintain.  This is quite contained code and so isn't likely
to cause maintenance problems, but unless someone feels *really* strongly about
numeric labels, I'll keep a named label to match the rest of the code.

Though with it just being VERW, I can shorten it a wee bit and make it more
precise at the same time:

		      __stringify(testl $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, WORD_SIZE(%_ASM_SP); \
				  jz .Lskip_mmio_verw;						  \
				  VERW;								  \
				  .Lskip_mmio_verw:),					  	  \

