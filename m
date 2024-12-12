Return-Path: <kvm+bounces-33538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 429A89EDCE5
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 02:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81F8F1888E6A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 01:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E905364AE;
	Thu, 12 Dec 2024 01:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YlKJYTxC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B22C1CAB8
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733965270; cv=none; b=KH+2D5LCuFtdlrB9fkOEo7cqVjWVOgIOuWqV1iVHxdFx2cDhY5LGjkQDZnxOCSwuFSZ2t/fFmSYoJ8PNdUJ5U2zqp8b9feiHyo9rHnys/wmutdtBJD+PvtLBwEYTncjfJC9n2bI5U5U4HwiX6ZU/ktjldbEe32K5YO/qgUiO8aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733965270; c=relaxed/simple;
	bh=MsWUkv0rRpydxtGAUs5cP9cm3RSN578+vWRHQI0XJbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NyQMc0INi0infvbsrHnXUwxGnhP925aRoSzipQB6YYqqg+PeHoF8jdXd7aRtGpX4ijjczlZzvCaAPgKhxrrMCbBqgmd3qNaB/pjWcxTcKnPoNtdU2c/lpkXuJZdAPBuXS9MCe5X0aEcUJHgdKuJAllRFJJwk7kJFvVFpoxOOhA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YlKJYTxC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-8019f05c629so147122a12.2
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 17:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733965269; x=1734570069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7cpfZyNODHfiskmCxH+bHRLp/oczpA9P3snJG2D86I=;
        b=YlKJYTxCf113SHA/13Av3q+2mfX9WZRqGAxZede/fHq1/VtKtfJeyMy7Tto/eF9V2z
         5cPD+OocgNHSVXRZ1rnkW6+1Cy+WW4n3uyYtPunzO0kpT1vaNBiManane2SNvfdfp3Pu
         XdShN7MMN4Klfeb+/DEKctzXup3nxCpWKWOZJXKUVDHelnFb9+Iv+CwxrBb5y+P26hob
         jfBa43WN434nP2OnKzIZEmne6BnfyjM0tCsweXecN2X8xFCYGWq8RQqe1oJFJWXWXkbS
         Nz6TfUNXBKKbINvMWgdWqMTW0KtrL9YB+b+0vaXGrinSOBq6+UQmSmc5wpBagIaMhsyY
         LI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733965269; x=1734570069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L7cpfZyNODHfiskmCxH+bHRLp/oczpA9P3snJG2D86I=;
        b=JI+7rXW3eoUEILfjv8KFICBR9pQ0UsDEmoXvRi0MXAkSEv3FQEaa9h5I79M4ugDYEh
         QwTOb1/P9tZnK6hwEJuO5bVIGKwbXzQFpCYwFB//QDa6/79gP451G9Q/Vaw9AtGw3Jht
         qGQynijMkzuoCjYX64IxhBUUTpq0CuztYMRGm+g+HIvnUFrts3osGg1ZOIFg/8SIThd3
         JQJDXX8r9NRbZMSIcxwWgERscJ7WdfdIYsycDaRKTd3VRr4v6MRx/LsjfnYPU4vOoEIv
         VSH/hFBuTOvxCBEUt8ll4eDmQVJzFCDXVsrxmrN3Mo6jF3kU5yagg2tzQFXiyDqJiVFm
         8vNg==
X-Forwarded-Encrypted: i=1; AJvYcCVnf2YvwrsX+kyaeqZ1hnj6oL1YtR7rj4nKaeuExh6Pyq1dO0GFhUHl5T2IPBgcioS9CcY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlsz8u48g6tzrS6xxiSlGejO+05w6xcgI6P6+ZWgJm+9Cc+noI
	ByI/MhsgkpfGnb7KDwPQQYIdrKrEKqiXFxtPRrWYug17mzxwOENZM7R4LVtVr4qPNRLUF5PoS2D
	K7w==
X-Google-Smtp-Source: AGHT+IGoACptyZ2sMkDPPNC8IEQ1JeBJZZlRK3M9NSG7oG6xCWK4QqffIe8975REaYQKJeQ/fFVy1B8fJig=
X-Received: from pjf3.prod.google.com ([2002:a17:90b:3f03:b0:2d3:d4ca:5fb0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:268e:b0:2ee:5edc:489
 with SMTP id 98e67ed59e1d1-2f13930c56bmr2863220a91.26.1733965268793; Wed, 11
 Dec 2024 17:01:08 -0800 (PST)
Date: Wed, 11 Dec 2024 17:01:07 -0800
In-Reply-To: <2b75550c-0dc7-4bcc-ac60-9ad4402c17f8@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111102749.82761-1-iorlov@amazon.com> <20241111102749.82761-4-iorlov@amazon.com>
 <Z1nWykQ3e4D5e2C-@google.com> <2b75550c-0dc7-4bcc-ac60-9ad4402c17f8@gmail.com>
Message-ID: <Z1o1013dUex8w9hK@google.com>
Subject: Re: [PATCH v2 3/6] KVM: VMX: Handle vectoring error in check_emulate_instruction
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Ivan Orlov <iorlov@amazon.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 11, 2024, Ivan Orlov wrote:
> On 12/11/24 18:15, Sean Christopherson wrote:
> > Hmm, this should probably be "pf_mmio", not just "mmio".  E.g. if KVM is emulating
> > large swaths of guest code because unrestricted guest is disabled, then can end up
> > emulating an MMIO access for "normal" emulation.
> > 
> > Hmm, actually, what if we go with this?
> > 
> >    static inline bool kvm_can_emulate_event_vectoring(int emul_type)
> >    {
> > 	return !(emul_type & EMULTYPE_PF) ||
> > 	       (emul_type & EMULTYPE_WRITE_PF_TO_SP);
> >    }
> > 
> 
> Hm, by the way, what is the desired behaviour if EMULTYPE_ALLOW_RETRY_PF is
> set? Is it correct that we return an internal error if it is set during
> vectoring? Or KVM may try to unprotect the page and re-execute?

Heh, it's sneaky, but EMULTYPE_ALLOW_RETRY_PF can be set if and only if
RET_PF_WRITE_PROTECTED is set.  Hmm, that makes me think we should do the below
(EMULTYPE_WRITE_PF_TO_SP was a recent addition).

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..de5f6985d123 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9077,7 +9077,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
        if ((emulation_type & EMULTYPE_ALLOW_RETRY_PF) &&
            (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
-            WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF))))
+            WARN_ON_ONCE(!(emulation_type & EMULTYPE_WRITE_PF_TO_SP))))
                emulation_type &= ~EMULTYPE_ALLOW_RETRY_PF;
 
        r = kvm_check_emulate_insn(vcpu, emulation_type, insn, insn_len);

That said, let me get back to you on this when my brain is less tired.  I'm not
sure emulating when an exit occurred during event delivery is _ever_ correct.

> If so, we may need something like
> 
> static inline bool kvm_can_emulate_event_vectoring(int emul_type)
> {
> 	return !(emul_type & EMULTYPE_PF) ||
> 	       (emul_type & ~(EMULTYPE_PF));
> }
> 
> So it returns true if EMULTYPE_PF is not set or if it's not the only set
> bit.



