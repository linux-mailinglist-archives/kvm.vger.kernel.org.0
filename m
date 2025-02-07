Return-Path: <kvm+bounces-37617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9ACA2C9F9
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7A6D3A6B6F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B22197A92;
	Fri,  7 Feb 2025 17:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PFWGXhgc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A862A1D8
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738948714; cv=none; b=CcabKxdtYOblAC7xpmGwZ9hXZNqUAeoBAFNLt2xJ5cTyyrEQroo5w52gsLFGrdxnbFXJETQfw8HacAPlYcNlMjOXAIb7EGhhjNrcSnJB3MJgEaMRqSQyQZRaRlqm/MjDSfgxJxJvKbVANl/l822AQyYnW50iHOY3FifLNNfCnBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738948714; c=relaxed/simple;
	bh=Jj1eNDqFpZhRI+fdFmpIJJSPmlSkB+1ee36V8K05VyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VOo+V5Y+yZbIjlKnlpICMY7DAjG+j1ip0eScCe4qMizdeZDr3TiV9IHvUHolya9Q/yzpf8VhB+e1uW/0WKwrTcwzoTRUhPaWTp39c1yV88KkmwiToKAuvxt2Bmfp8+AAnjRsd0jAEojQN8D/TFLD1TF3rRCY92f1DJoirSIE7Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PFWGXhgc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f46b7851fcso6721392a91.1
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 09:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738948712; x=1739553512; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSuOpbzcTju6tkFfxzl4KaN2A0Hnpur6HDpACNjX4wo=;
        b=PFWGXhgcZPGDuCOJCTXAde/QfQEvYaSj1JUN0UHL1N/sszgbv1eaYg2J+QYd/DYM5K
         vQgWGlD2JFVGKyGegTqvK9czIXVkw553pxzRtVYjiWE1a4Hxw2dU26xoFd0/yyM2fCd7
         jVytFI9Ny10CAmFp/MBo9dFGFmsQj0PwlPm16wJSk77EMpjaKTg4Q3fEOOxMFVkle/0s
         28wnyxgNATtt0WLqlml8seLSg8MiUm6xuYXtGzm7YP2EJB8fWv6cgAkLmuYkAT7iDKq4
         yGQq5YjTDpYLHhChnZnUGA28jjn44xCGO2zeVj1h0zR2lxMyNaZcEVdeFXA2OcoWIL1v
         ydqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738948712; x=1739553512;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CSuOpbzcTju6tkFfxzl4KaN2A0Hnpur6HDpACNjX4wo=;
        b=esiT+PdIhRIje63J7a7hWwGLx3wxri7FlTTZw2sgBzaYfK020RNBHcUOBaPQGMPaBC
         CZkSyijdVQhHS0hAVMFCq8vlj13uy310ZJYRQVThwFFynWwNh6r2r+K+P1C9V8Qt9LGY
         VPNW0MuklzVS4ZLPmpp+jZoqGF1SLuGxxIxqW6HpMGuIASluRJj8l23bJCVn+NzRxKC7
         soNwPN+OuL0B9q04U3bjZfZNSCBTpRUheh2ihwzBEEMSKJLI7iIzg53/eC3C7Gh3f6tR
         8/162DRoG91sgdYElf+Qsk5GjFfyw0YTeVdhaiaaiylD6xkbRAyBKA6I5RbU/CgvojB9
         yF6g==
X-Forwarded-Encrypted: i=1; AJvYcCWbPYs538cYJV1N6huvEF0JKqlXkCQHoKAsPg6GCkzrUxpPqmSjdYzSPPK7U5CGJVz95EQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yydliqe035rM6iZZ1rVv1ArLExz+Yj+eyM3/2Z33f94NrHFz6ii
	sKQEJVSnn0tkRlDDx/YPT7odYUjrYYe1DZvGdoaTbcqDXNW63bguqWbZ3meamUQy1psG84AxQvD
	EMw==
X-Google-Smtp-Source: AGHT+IGrayEP+/fD2zZXo2PSrKnXUC+O+jff+DjKCRUzSnky46KAfPmw7R7/FHXa4l1bRE8ZgLc4lf1t8Hs=
X-Received: from pjbsn12.prod.google.com ([2002:a17:90b:2e8c:b0:2fa:e9b:33b7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec86:b0:2fa:13ce:bf16
 with SMTP id 98e67ed59e1d1-2fa24068f50mr6276946a91.11.1738948712214; Fri, 07
 Feb 2025 09:18:32 -0800 (PST)
Date: Fri, 7 Feb 2025 09:18:30 -0800
In-Reply-To: <4410f771de905b8df18f7fc87fe5a034d1a57a7b.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201011400.669483-1-seanjc@google.com> <20250201011400.669483-2-seanjc@google.com>
 <43f702b383fb99d435f2cdb8ef35cc1449fe6c23.camel@infradead.org>
 <Z6N-kn1-p6nIWHeP@google.com> <cd3fb8dd79d7766f383748ec472de3943021eb39.camel@infradead.org>
 <Z6OI5VMDlgLbqytM@google.com> <48FAD370-09F1-47AA-8892-8BE29DC8A949@infradead.org>
 <85f8aaea4cb5918cef92309c8c1c26fc7fd113b8.camel@infradead.org>
 <Z6O6Evrdl9pPM3hX@google.com> <4410f771de905b8df18f7fc87fe5a034d1a57a7b.camel@infradead.org>
Message-ID: <Z6ZAZjBj9jv-VKgS@google.com>
Subject: Re: [PATCH 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 06, 2025, David Woodhouse wrote:
> On Wed, 2025-02-05 at 11:20 -0800, Sean Christopherson wrote:
> > On Wed, Feb 05, 2025, David Woodhouse wrote:
> > > On Wed, 2025-02-05 at 16:18 +0000, David Woodhouse wrote:
> > > >=20
> > > > > Oh!=C2=A0 It doesn't help KVM avoid breaking userspace, but a way=
 for QEMU to avoid a
> > > > > future collision would be to have QEMU start at 0x40000200 when H=
yper-V is enabled,
> > > > > but then use KVM_GET_MSR_INDEX_LIST to detect a collision with KV=
M Hyper-V, e.g.
> > > > > increment the index until an available index is found (with sanit=
y checks and whatnot).
> > > >=20
> > > > Makes sense. I think that's a third separate patch, yes?
> > >=20
> > > To be clear, I think I mean a third patch which further restricts
> > > kvm_xen_hvm_config() to disallow indices for which
> > > kvm_is_advertised_msr() returns true?
> > >=20
> > > We could roll that into your original patch instead, if you prefer.
> >=20
> > Nah, I like the idea of separate patch.
>=20
> Helpfully, kvm_is_advertised_msr() doesn't actually return true for
> MSR_IA32_XSS. Is that a bug?

Technically, no.  KVM doesn't support a non-zero XSS, yet, and so there's n=
othing
for userspace to save/restore.  But the word "yet"...

> And kvm_vcpu_reset() attempts to set MSR_IA32_XSS even if the guest
> doesn't have X86_FEATURE_XSAVES. Is that a bug?

Ugh, sort of.  Functionally, it's fine.  Though it's quite the mess.  The w=
rite
can be straight up deleted, as the vCPU structure is zero-allocated and the=
 CPUID
side effects that using __kvm_set_msr() is intended to deal with are irrele=
vant
because the CPUID array can't yet exist.

The code came about due to an SDM bug and racing patches, and we missed tha=
t the
__kvm_set_msr() would be pointless.

The SDM had a bug that said XSS was cleared to '0' on INIT, and then KVM ha=
d a
bug in its emulation of the buggy INIT logic where KVM open coded clearing =
ia32_xss,
which led to stale CPUID information (XSTATE sizes weren't updated).

While the patch[1] that became commit 05a9e065059e ("KVM: x86: Sync the sta=
tes
size with the XCR0/IA32_XSS at, any time") was in flight, Xiayoao reported =
the
SDM bug and sent a fix[2].

I merged the two changes, but overlooked that at RESET, the CPUID array is
guaranteed to be null/empty, and so calling into kvm_update_cpuid_runtime()=
 is
technically pointless.  And because guest CPUID is empty, the vCPU can't
possibly have X86_FEATURE_XSAVES, so gating the write on XSAVES would be ev=
en
weirder and more confusing.

I'm not sure what the best answer is.  I'm leaning towards simply deleting =
the
write.  I'd love to have a better MSR framework in KVM, e.g. to document wh=
ich
MSRs are modified by INIT, but at this point I think writing '0' to an MSR =
during
RESET (a.k.a. vCPU creation) does more harm than good.

[1] https://lore.kernel.org/all/20220117082631.86143-1-likexu@tencent.com
[2] https://lore.kernel.org/all/20220126034750.2495371-1-xiaoyao.li@intel.c=
om

