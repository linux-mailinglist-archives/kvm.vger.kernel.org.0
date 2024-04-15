Return-Path: <kvm+bounces-14696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E61808A5CC5
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 23:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 160271C21BCC
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 21:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC12156F26;
	Mon, 15 Apr 2024 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YvYZyhF2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5BB156987
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 21:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713215825; cv=none; b=lZGcm8kb+a5m0JWKFQrdO1TGFf6cHaPFMfjizjcXvRyZFBrN1kEhRD11XMg6/a4Da3Hxvvn6ds2NbdgYKuB/ttl8x010gkWwd/VTYfSFz9Cko0/V6Q7Y7ZH2emY2zBZR0C4Cpa9tZCvB15BNqpFK8JCGpDVmKtf3wtoO0LsIQIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713215825; c=relaxed/simple;
	bh=yfn6aJnruIJIdeEpg1IYTe1hjYARVnJM9I6RBU6GCHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V5B7WO+4UxkrQyrMwjkg9/NjgHHlPNGWeaHbPdT/0WXbk8nEJYxgUZL2In/L0zo24Ra20iqaViMRR1XpMCamOFKg5Tn112rNH6tEu6mPKMhGM4dDs5Qc4gf6yNAXlXgTVcaMcyYLJsf07+SrGDebIdKuj/fAUD0h13dJIJy1kck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YvYZyhF2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e5e5fa31dbso23679075ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 14:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713215824; x=1713820624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBGOoxkS/mJcI9EGCPz3dzyAa3bwIeBtfweaCEU7c+g=;
        b=YvYZyhF2zuhdKd8PW1Q6UCpbcmp0xTKmng364IJUAnLbcj7ei2AaO3QrQIkPimA+X3
         16RchrXgeOzxlSZMwKUPL0VkMEuqkZbpgLDfjW4XmaR+FMpCXsDWAdG9crdZzlIBzB8S
         MS8DlT6Xjv3QqED8Kld6QgNIf68hke9MMzDfg8ankKGvyMqSo0pRMkSREmXvXqvN/c/s
         Wmb7iYIuPq7kpN6yfusdObx1d2dbMBiu3fdCv+BCODiP43PAPe8cVu4XzsWS+TSXCiRE
         3lpnVCkSjD3VIIECnnspwQKHc0qrUnslRpnqCOUzxqanjkp6IA/DqyVdM2fgQkWN9oHx
         cJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713215824; x=1713820624;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aBGOoxkS/mJcI9EGCPz3dzyAa3bwIeBtfweaCEU7c+g=;
        b=KCalsYmjZT2DDcptBMnj/Z5LgaF44hM+UubcdlGUIBwQPid+SEWwERiCK3VGDU6/bP
         FUbDxn3JtXC/CxV16uuYe2At62CIhaJzihcZaXSHzhXAecwFKP+4xeB2szHVcCXpjXkJ
         iYEhBiCo+dqRj5gTmfYOEK5yvWGDx89aWP6EtUyZmhWXCNSHsT9dJH7rhVwFX66t7RKj
         BNXGK8k5xzc2tM+1KRRrlnvnUf33KmIwPi7n19MrX74SZLyNN7hQGFAQZA2hL7VwRWTD
         6+47+/ODWGk5we0yo1vLlnGs/ecgmakPdQBVIquxchlv2RMl7Q7ah9+o9I8kE5rXZ5Qs
         BOSg==
X-Gm-Message-State: AOJu0YzEqvyGH5k8p3ejrkoXXMrouGvNyl3J81uN5ToLzfl0P2KyPOng
	CL5gPnW1H6LjHY67vCZ/afY3p0pXciQUfnyVTh/ZgE3hqLdKoOA6ZYzCecboVAfKSErXQhmlsBZ
	kzQ==
X-Google-Smtp-Source: AGHT+IEKXRUjLWsJdJPk1rSQzftmy/0qVa+yD6hHbsIi+0DoB3x4NIfe8OTr+b/8zXdTMu8B9jazXCLbJxo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22ca:b0:1e7:b7ca:2d96 with SMTP id
 y10-20020a17090322ca00b001e7b7ca2d96mr40604plg.1.1713215823680; Mon, 15 Apr
 2024 14:17:03 -0700 (PDT)
Date: Mon, 15 Apr 2024 14:17:02 -0700
In-Reply-To: <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
 <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
Message-ID: <Zh2ZTt4tXXg0f0d9@google.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for KVM_MAP_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024, Rick P Edgecombe wrote:
> I wouldn't call myself much of an expert on nested, but...
>=20
> On Wed, 2024-04-10 at 15:07 -0700, isaku.yamahata@intel.com wrote:
> > There are several options to populate L1 GPA irrelevant to vCPU mode.
> > - Switch vCPU MMU only: This patch.
> > =C2=A0 Pros: Concise implementation.
> > =C2=A0 Cons: Heavily dependent on the KVM MMU implementation.

Con: Makes it impossible to support other MMUs/modes without extending the =
uAPI.

> Is switching just the MMU enough here? Won't the MTRRs and other vcpu bit=
s be
> wrong?
>=20
> > - Use kvm_x86_nested_ops.get/set_state() to switch to/from guest mode.
> > =C2=A0 Use __get/set_sregs2() to switch to/from SMM mode.
> > =C2=A0 Pros: straightforward.
> > =C2=A0 Cons: This may cause unintended side effects.
>=20
> Cons make sense.
>=20
> > - Refactor KVM page fault handler not to pass vCPU. Pass around necessa=
ry
> > =C2=A0 parameters and struct kvm.
> > =C2=A0 Pros: The end result will have clearly no side effects.
> > =C2=A0 Cons: This will require big refactoring.
>=20
> But doesn't the fault handler need the vCPU state?

Ignoring guest MTRRs, which will hopefully soon be a non-issue, no.  There =
are
only six possible roots if TDP is enabled:

      1. 4-level !SMM !guest_mode
      2. 4-level  SMM !guest_mode
      3. 5-level !SMM !guest_mode
      4. 5-level  SMM !guest_mode
      5. 4-level !SMM guest_mode
      6. 5-level !SMM guest_mode

4-level vs. 5-level is a guest MAXPHYADDR thing, and swapping the MMU elimi=
nates
the SMM and guest_mode issues.  If there is per-vCPU state that makes its w=
ay into
the TDP page tables, then we have problems, because it means that there is =
per-vCPU
state in per-VM structures that isn't accounted for.

There are a few edge cases where KVM treads carefully, e.g. if the fault is=
 to
the vCPU's APIC-access page, but KVM manually handles those to avoid consum=
ing
per-vCPU state.

That said, I think this option is effectively 1b, because dropping the SMM =
vs.
guest_mode state has the same uAPI problems as forcibly swapping the MMU, i=
t's
just a different way of doing so.

The first question to answer is, do we want to return an error or "silently=
"
install mappings for !SMM, !guest_mode.  And so this option becomes relevan=
t only
_if_ we want to unconditionally install mappings for the 'base" mode.

> > - Return error on guest mode or SMM mode:=C2=A0 Without this patch.
> > =C2=A0 Pros: No additional patch.
> > =C2=A0 Cons: Difficult to use.
>=20
> Hmm... For the non-TDX use cases this is just an optimization, right? For=
 TDX
> there shouldn't be an issue. If so, maybe this last one is not so horribl=
e.

And the fact there are so variables to control (MAXPHADDR, SMM, and guest_m=
ode)
basically invalidates the argument that returning an error makes the ioctl(=
) hard
to use.  I can imagine it might be hard to squeeze this ioctl() into QEMU's
existing code, but I don't buy that the ioctl() itself is hard to use.

Literally the only thing userspace needs to do is set CPUID to implicitly s=
elect
between 4-level and 5-level paging.  If userspace wants to pre-map memory d=
uring
live migration, or when jump-starting the guest with pre-defined state, sim=
ply
pre-map memory before stuffing guest state.  In and of itself, that doesn't=
 seem
difficult, e.g. at a quick glance, QEMU could add a hook somewhere in
kvm_vcpu_thread_fn() without too much trouble (though that comes with a hug=
e
disclaimer that I only know enough about how QEMU manages vCPUs to be dange=
rous).

I would describe the overall cons for this patch versus returning an error
differently.  Switching MMU state puts the complexity in the kernel.  Retur=
ning
an error punts any complexity to userspace.  Specifically, anything that KV=
M can
do regarding vCPU state to get the right MMU, userspace can do too.
=20
Add on that silently doing things that effectively ignore guest state usual=
ly
ends badly, and I don't see a good argument for this patch (or any variant
thereof).

