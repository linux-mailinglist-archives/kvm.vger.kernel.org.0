Return-Path: <kvm+bounces-48421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92139ACE1C1
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6271D179E10
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CF11D63C6;
	Wed,  4 Jun 2025 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vb2N4Nwz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE7F199FAC
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749052165; cv=none; b=j2XBK+/a1+oI8tNaKL2mizMI+j+Nb3h50KIUxsM+a8i59l00lnDoc8LuHhoBek9jV7L5SqimoYuYAeMu7x6Wlxkkno1OQIKNJP4ZekekLfkMUgEC/wVoON3xylkRcw+wOY0HjpErTKTO9ai2hzTdtJULJj9lEBkGtwc+WwLNt9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749052165; c=relaxed/simple;
	bh=E355dxQOrr/PVcwroKhZnO7dWd/iZ1NHGiq889Ab9X0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fXKudo2p7HXhr2LP3pRHqR5BrYRobGqo8e3P2EZ3DFDUGg9Cp9zQiLAio86MqRwuaYv8rxmLZKIAV8ltQAKMfuXFebO5/cz2ArT26LRdNKRF4Xejca3OUUNvrj5Q9vZ4xmJJelR4TBLpNY3XuIz30CNbrwundvyWjkdiWHVZveM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vb2N4Nwz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311fa374c2fso9275350a91.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 08:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749052163; x=1749656963; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=APQsb45khTfPV4BXCtKSSbtPEml4hNZfBir9V5yfOUU=;
        b=vb2N4NwzMmDUdRJy9eacC+fhVRJa7mVGnOlspJTZ9O3Xss488uiMNaRIKJd40aD849
         Rm7SeSHbpi81siSGLq22lVAqEUKmgs8T4M1DQAbIvwycXvsG4iu1mtIKR652yA8VDA3v
         Ndywt+Zw9NfRQjGbH+BDghFF+insHeaksYyGfKaQiav18JgGA0diVfgG8oVnZBz60mtI
         tLPl4iYbrECgKPPDbPzQHKYX68SIEQjaB/RWrQA4gDd2paYFFM+9BkSI7E0qedC3svN/
         TbB32QhsCMcTAUmiExOyO+zRBVIocf5DLW0RiwC/CBUUpC2uRTk4JwcdDsDFvjHVm9bB
         jPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749052163; x=1749656963;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=APQsb45khTfPV4BXCtKSSbtPEml4hNZfBir9V5yfOUU=;
        b=qzNGj8660VsRf5hhL1f8ZtfaHOBU/IBpCWZ29gH4UMPGX2UdumuhV//187Qm2Kkeyz
         Qovi+O6CRIiGz23BzfqBfb8F8J9liynCtedwVGMUq5sq38seRmQ2cLkacIV+1qpPLEZ1
         wNEh7FsfIG90fAI8Mow7lMmpMgnhRcOtZ1CoYHB9FAxU/rhdvurHdvHfN0S1C4UZTmYc
         6xfD7YEbQSg42/aO3qbOhn8z0qAWakpdivD503Y8WbuuNoGiVHHeCaFfGQ6T9t3ZKMBV
         bO4UgSzKJFMYy0iSD8EWyB5amAYyP7w+S6HBJMhxwTRNpXqVhMrZ0ajkDBnOt/r9+gci
         bn2Q==
X-Gm-Message-State: AOJu0YzKtOqyaAqFyyz23oSWyRTfDbGY+MkNjUQ+M5JQce/zme7s95RT
	PsEKkkjBDNrZp87mEr7AsSiKriehBg8hPOPQQVKLFALrCFrLSVNy3HXx2rPd/SWXd0gNbEkHpMT
	vEkVXYw==
X-Google-Smtp-Source: AGHT+IEhBYHH0jG1lNTT5kDcZ2O2I2zO4DfrveKxEVf0tri6G7bWBC1AeFJUjRv/5iW3hgKOjhXeD0GyTU4=
X-Received: from pjboe5.prod.google.com ([2002:a17:90b:3945:b0:312:4274:c4ce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a:b0:311:bdea:dca0
 with SMTP id 98e67ed59e1d1-3130ce0458fmr6517554a91.33.1749052163390; Wed, 04
 Jun 2025 08:49:23 -0700 (PDT)
Date: Wed, 4 Jun 2025 08:49:21 -0700
In-Reply-To: <688ba3c4-bf8a-47f1-ad14-85a23399582c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com> <20250529234013.3826933-9-seanjc@google.com>
 <688ba3c4-bf8a-47f1-ad14-85a23399582c@redhat.com>
Message-ID: <aEBrAbhRFkou4Mvj@google.com>
Subject: Re: [PATCH 08/28] KVM: nSVM: Use dedicated array of MSRPM offsets to
 merge L0 and L1 bitmaps
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 04, 2025, Paolo Bonzini wrote:
> On 5/30/25 01:39, Sean Christopherson wrote:
> > Use a dedicated array of MSRPM offsets to merge L0 and L1 bitmaps, i.e. to
> > merge KVM's vmcb01 bitmap with L1's vmcb12 bitmap.  This will eventually
> > allow for the removal of direct_access_msrs, as the only path where
> > tracking the offsets is truly justified is the merge for nested SVM, where
> > merging in chunks is an easy way to batch uaccess reads/writes.
> > 
> > Opportunistically omit the x2APIC MSRs from the merge-specific array
> > instead of filtering them out at runtime.
> > 
> > Note, disabling interception of XSS, EFER, PAT, GHCB, and TSC_AUX is
> > mutually exclusive with nested virtualization, as KVM passes through the
> > MSRs only for SEV-ES guests, and KVM doesn't support nested virtualization
> > for SEV+ guests.  Defer removing those MSRs to a future cleanup in order
> > to make this refactoring as benign as possible.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/nested.c | 72 +++++++++++++++++++++++++++++++++------
> >   arch/x86/kvm/svm/svm.c    |  4 +++
> >   arch/x86/kvm/svm/svm.h    |  2 ++
> >   3 files changed, 67 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 89a77f0f1cc8..e53020939e60 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -184,6 +184,64 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >   	}
> >   }
> > +static int nested_svm_msrpm_merge_offsets[9] __ro_after_init;
> > +static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
> > +
> > +int __init nested_svm_init_msrpm_merge_offsets(void)
> > +{
> > +	const u32 merge_msrs[] = {
> 
> "static const", please.

Ugh, I was thinking the compiler would be magical enough to not generate code to
fill an on-stack array at runtime, but that's not the case.

AFAICT, tagging it __initdata works, so I'll do this to hopefully ensure the
memory is discarded after module load.

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb4808cf4711..af530f45bf64 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -205,7 +205,7 @@ static int svm_msrpm_offset(u32 msr)
 
 int __init nested_svm_init_msrpm_merge_offsets(void)
 {
-       const u32 merge_msrs[] = {
+       static const u32 __initdata merge_msrs[] = {
                MSR_STAR,
                MSR_IA32_SYSENTER_CS,
                MSR_IA32_SYSENTER_EIP,

