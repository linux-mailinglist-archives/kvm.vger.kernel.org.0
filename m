Return-Path: <kvm+bounces-60695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 345FABF7C80
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F10504E1F46
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACF83446C1;
	Tue, 21 Oct 2025 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MyajYB+A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D273346E79
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761065313; cv=none; b=RDdxGKobW20rgi9nKKnhQQuLYfRiDR1B0JKL4AwgADCwnQzapDQP7+W8MAbvyDqoW+ube8k32WiIiF5nqgvXlRfOidz8bzJRHZA/k0J+cvqS+nO38QVFm3AEJpyKtRPrmemGLco6v7sOh6oWX6Sh+7eQIns6THYEYkB8c3OKkn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761065313; c=relaxed/simple;
	bh=qNuz2BhbrPuJtjUlueV/PTGi0i61jZnzkjuzIcaTMSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TO1tQYG408P0VySlSVVGQ06Aon90Z1Qo0l6B0BIrc2dEwn4vgxEqRwdvwBG23bt/LiaePGoUcX0zgKt0TwuKwF5jDVv0A0JwmiAfMtVKSyMiHS3yh0ZQNHuLPafgsCMJDUkal6OGW6jMuUEckwJr/FH1qgMKNf2B8QQUF3R3oIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MyajYB+A; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33da1f30fdfso5916841a91.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761065312; x=1761670112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5pwugCQDX5Fa9uMyMSiPompvEUK7ReL7M9ApQQ2FgUQ=;
        b=MyajYB+AkuPM5jrLzxAgUXpp9jAuZetrHKAoSiJHcwfdwPpekTPOe3Vsa5ZSRgcO0y
         49CNGGkk8fyg8mvqi5s7lk2ns7WB5Bc23Bvo78+t775gt1keRJAuC/fHN6PwW7sizOZb
         X0cc2QgViv0GoVqLQ8gSzDCNTYSb17y/L/u+TVBhdfq1U+5vQfPT+5iw6WaLpkxZrSUy
         CA2xlDYRJz78UGYpXd+ttt5809GE1dcm2i4r8VyMF6n+ZJ8rqgCU9rnahGQmQP26Hj7n
         YaKGpXV0OhFzSrgOXry4S5W961mi5hm5FbhMWQ9RMh4zLBlQRxLyo/g6CTb1H+rjtX08
         iMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761065312; x=1761670112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pwugCQDX5Fa9uMyMSiPompvEUK7ReL7M9ApQQ2FgUQ=;
        b=WEOKsvGsBj2Rb0j6bdDuG13zv4BLAxb8MME0IGTCPhenhDMHxMJEwhIfEFVZcq6qmw
         zdNSHqp6PePNMWDKI2CNy1OJnX8FAbhAUhNRQlXb9jwz6uuRfUTwpUCnEwF9jkJJPzsy
         /06uGN+zby0h3AEHuTrhrutf8vaXzMYxXOSeoGMWaA+xCPaD8bCvfkSAiYCzV3tUL3mI
         /k2/n0e3LgAjspSWrkeV27WMReK4cFTktySLTUkvVz9QQ+J2L0JgrRZTv6hMRJ8smJmw
         fRHhcqbaD/ag7SWE48jSManlTRdbNaFdClkF/tNcwdvHakRls+S8jQ9/ftDWdvxdMIMu
         eGxg==
X-Forwarded-Encrypted: i=1; AJvYcCX0o7PdGnkfHWV3FPUxUURJr9aTeZYTYmxIf2u6lQB8/3EDpbU934BvU7DZAsvTsghxMVM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya7ZsoqK35Jh3cTHvux3qSZth5A9aQ9JWVF3UnZdduslP/2F8i
	zUBly9JZ/EiizO9nClTo6+cxZ4p/eWvcma6/76wMMr9KLjdttmBZT2i7zTFs1nWQ8KFXo0j7alw
	s2k+m3A==
X-Google-Smtp-Source: AGHT+IFTe4URBA8XHN2+Qq9s8GixG6Z7wvrTVQCbQJYOjxumGBtb8NxaGtW3DTPqFM4psX9kQ4XK36VDvmU=
X-Received: from pjvp12.prod.google.com ([2002:a17:90a:df8c:b0:334:1843:ee45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec6:b0:33b:be31:8194
 with SMTP id 98e67ed59e1d1-33bcf90ca94mr21952921a91.34.1761065311784; Tue, 21
 Oct 2025 09:48:31 -0700 (PDT)
Date: Tue, 21 Oct 2025 09:48:30 -0700
In-Reply-To: <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com> <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
Message-ID: <aPe5XpjqItip9KbP@google.com>
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache
 flush is skipped
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Brendan Jackman wrote:
> On Thu Oct 16, 2025 at 8:04 PM UTC, Sean Christopherson wrote:
> > If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
> > mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
> > because none of the "heavy" paths that trigger an L1D flush were tripped
> > since the last VM-Enter.
> 
> Presumably the assumption here was that the L1TF conditionality is good
> enough for the MMIO stale data vuln too? I'm not qualified to assess if
> that assumption is true, but also even if it's a good one it's
> definitely not obvious to users that the mitigation you pick for L1TF
> has this side-effect. So I think I'm on board with calling this a bug.

Yeah, that's where I'm at as well.

> If anyone turns out to be depending on the current behaviour for
> performance I think they should probably add it back as a separate flag.

...

> > @@ -6722,6 +6722,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
> >  		:: [flush_pages] "r" (vmx_l1d_flush_pages),
> >  		    [size] "r" (size)
> >  		: "eax", "ebx", "ecx", "edx");
> > +	return true;
> 
> The comment in the caller says the L1D flush "includes CPU buffer clear
> to mitigate MDS" - do we actually know that this software sequence
> mitigates the MMIO stale data vuln like the verw does? (Do we even know if
> it mitigates MDS?)
> 
> Anyway, if this is an issue, it's orthogonal to this patch.

Pawan, any idea?

