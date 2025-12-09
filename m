Return-Path: <kvm+bounces-65577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 84883CB0C14
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76A7B30EFE99
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A322832D0CC;
	Tue,  9 Dec 2025 17:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ny3bS05R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638BA2C235D
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 17:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765301836; cv=none; b=BVSzP4VVS9a0y0ZrWoUaCXQ/LVccIT7T5ndGG8j/8TaVkSvYMfUr6u6VC/hLjZEBft1gd+V1K+kfH6yxEVVZ51rbqFRIL68zImB31UQrwHxDAlYv0m1U2n39fkKKSZJ5mdSk5v1BgoDPg64fMdd3DObvMQXtITh+Y6rltGlmQ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765301836; c=relaxed/simple;
	bh=HizTlmZQbI6tmGG3q1gw6CHs59oQallkQuLPYHyLpHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PK4s2jcXsenyQQnSn/WYHInekIoadVMPOwou07EdGRoHzKPIhbxO81nNRI+69lqo1Cj8T+9Pm8edowtpQgKVCBGrdLYwQQeQN8mnCOTdxO4E5GZ+R6vNC7JrTStXAiKR+mbAAe8d07XVLNRGlI2l3rUAwd0TreQggTUGprV/MOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ny3bS05R; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34a43e96860so2484069a91.3
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 09:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765301835; x=1765906635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSI8Pxf1Wt9ews+8G0JZ3VLNAwMte4kHmIud1VFkk60=;
        b=Ny3bS05Rx9IPO7IiQAlFWygqJDqU/KBJUkllITfQpS45+n5voCrD973pltyWkhLD+l
         EgGKOCKqaR+BfPaPhJFUuUg1ROVdBY7qphwC9cGynLgj4Ef3p32IL7689AN+qnguQ2X2
         mCyReCHzUm47/u2XwjlybNGJVvmW1Kfugsn86k/yLdt/VKjUEQi4sgMxWDxLLAP1Uubt
         vF1Fy8SPECt5v9QZmcZi3dTB+Hk0XxmnkCcygx1SWzOtJkdyIvErDZGIbpviqSJnOWiZ
         Zwez+PHnTTlCgXqdh7LJR0kesdv5qLZkqmihAY626EvqcKTmfQHNcxGI1jF3bYc2Jsaa
         iJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765301835; x=1765906635;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RSI8Pxf1Wt9ews+8G0JZ3VLNAwMte4kHmIud1VFkk60=;
        b=s1u8hbzIKu7BxkTXy7He/tw1eeyTu+VfnSRJOPOsVnlP8SBrEi94GZjQXpw9kakRQD
         Cc+6B8fpbn6b9HOllfxxeB8unJmEPXJhEQxW2lKektr2CZMvcTB8flslWATqn4aosnCM
         T97gFQECPQz/GrduvP8Uh6wUeDH+2onU3cPtKT0cJtamlTeVM47P16WpUpwloBaNNJ+A
         Lc+p/dH+GcoTAZkagQTRwh7nfUQpPSzB9uu/KR66AmVwu0u+O+qYCOOu7aFBRva0+Qao
         wJwMQz05lY4BTcZ4/NVD7xWE4q9FNQypCjx35UoRv+0UPtNC8DCBBR1hLN5Hpn257KK9
         46Lw==
X-Forwarded-Encrypted: i=1; AJvYcCV4B1qIxNJiD6fxNsfKes6mZwx11Y2r1JcATjsvWTk+eVAEZVPjzLaSJ792nqMq+LuN7vs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfmhYfVIJfYkR2nT2gi1AHaN8UIrtdkY2AvBJzyohp07IGf+WD
	9k98dFPdNAnVNbWnmD+FFPSY8DnXNWGM8SXjQVuR31Lglx6YFBFa/pCDahsuB9XZZifa7kGIDI2
	9dMzpTg==
X-Google-Smtp-Source: AGHT+IFtEkvOBWBmPhAZp6fiQBmIeByIj1WwkTuM0S6f9ba1kbmIBgBTopqxljhwYNgNIix+N66SAv3Sd14=
X-Received: from pjbnh9.prod.google.com ([2002:a17:90b:3649:b0:343:6cb7:a68e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8b:b0:343:f509:aa4a
 with SMTP id 98e67ed59e1d1-349a260a9d0mr9559247a91.36.1765301834531; Tue, 09
 Dec 2025 09:37:14 -0800 (PST)
Date: Tue, 9 Dec 2025 09:37:13 -0800
In-Reply-To: <2440b9bf-a2a1-4f66-94b2-71f47d62f3db@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-38-seanjc@google.com>
 <2440b9bf-a2a1-4f66-94b2-71f47d62f3db@linux.intel.com>
Message-ID: <aTheSQb9fhXmZKw6@google.com>
Subject: Re: [PATCH v6 37/44] KVM: VMX: Dedup code for removing MSR from
 VMCS's auto-load list
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2025, Dapeng Mi wrote:
>=20
> On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> > Add a helper to remove an MSR from an auto-{load,store} list to dedup t=
he
> > msr_autoload code, and in anticipation of adding similar functionality =
for
> > msr_autostore.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 31 ++++++++++++++++---------------
> >  1 file changed, 16 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 52bcb817cc15..a51f66d1b201 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1040,9 +1040,22 @@ static int vmx_find_loadstore_msr_slot(struct vm=
x_msrs *m, u32 msr)
> >  	return -ENOENT;
> >  }
> > =20
> > +static void vmx_remove_auto_msr(struct vmx_msrs *m, u32 msr,
> > +				unsigned long vmcs_count_field)
> > +{
> > +	int i;
> > +
> > +	i =3D vmx_find_loadstore_msr_slot(m, msr);
> > +	if (i < 0)
> > +		return;
> > +
> > +	--m->nr;
> > +	m->val[i] =3D m->val[m->nr];
>=20
> Sometimes the order of MSR writing does matter, e.g., PERF_GLOBAL_CTRL MS=
R
> should be written at last after all PMU MSR writing.

Hmm, no.  _If_ KVM were writing event selectors using the auto-load lists, =
then
KVM would need to bookend the event selector MSRs with PERF_GLOBAL_CTRL=3D0=
 and
PERF_GLOBAL_CTRL=3D<new context (guest vs. host)>.  E.g. so that guest PMC =
counts
aren't polluted with host events, and vice versa.

As things stand today, the only other MSRs are PEBS and the DS area configu=
ration
stuff, and kinda to my earlier point, KVM pre-zeroes MSR_IA32_PEBS_ENABLE a=
s part
of add_atomic_switch_msr() to ensure a quiescent period before VM-Enter.

Heh, and writing PERF_GLOBAL_CTRL last for that sequence might actually be
problematic.  E.g. load host PEBS with guest PERF_GLOBAL_CTRL active.

Anyways, I agree that this might be brittle, but this is all pre-existing b=
ehavior
so I don't want to tackle that here unless it's absolutely necessary.

Or wait, by "writing" do you mean "writing MSRs to memory", as opposed to "=
writing
values to MSRs"?  Regardless, I think my answer is the same: this isn't a p=
roblem
today, so I'd prefer to not shuffle the ordering unless it's absolutely nec=
essary.

> So directly moving the last MSR entry into cleared one could break the MS=
R
> writing sequence and may cause issue in theory.
>=20
> I know this won't really cause issue since currently vPMU won't use the M=
SR
> auto-load feature to save any PMU MSR, but it's still unsafe for future u=
ses.=C2=A0
>=20
> I'm not sure if it's worthy to do the strict MSR entry shift right now.
>
> Perhaps we could add a message to warn users at least.

Hmm, yeah, but I'm not entirely sure where/how best to document this.  Beca=
use
it's not just that vmx_remove_auto_msr() arbitrarily maniuplates the order,=
 e.g.
multiple calls to vmx_add_auto_msr() aren't guaranteed to provide ordering =
because
one or more MSRs may already be in the list.  And the "special" MSRs that c=
an be
switched via dedicated VMCS fields further muddy the waters.

So I'm tempted to not add a comment to the helpers, or even the struct fiel=
ds,
because unfortunately it's largely a "Here be dragons!" type warning. :-/

