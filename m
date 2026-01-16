Return-Path: <kvm+bounces-68352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 407EAD37A5C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E32B316B719
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6961239526A;
	Fri, 16 Jan 2026 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TQaE6naS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9D5338594
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768584853; cv=none; b=dVLCm3W/NuqTKKXYJlyGStnfjFwyhJ4gTes4qkAQmGyBm3/cYR7HjFm5hAx/csRXOhIqCSohjyukXvoGn+ZHUwdjzcpvTUQB0gz4NnHNIsY1+empJtFIcVL0IJbilirxxavp0CSs16fMttM7VJCKSoIhVl/VSEWQhaBhuROjTr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768584853; c=relaxed/simple;
	bh=T6pKLN6msWa1JnbQayIcKy8zPrqf9eQVLDpB22ad/cc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UnGfwOxDRFW+uneGqT/O08dvOMrTIoi+FxtvqXfP+MbRJxyBlQN7z8NF82Ec45yjMoAwbFxHL4SuixlGnR7uOfcKOqc4DYcQK1FoJGS0YD6IvS8e9JwizE/q7oZELamrBA95Y1qZ7WdlXXVrTg9Vx6V0HGdLdF/74Jj42RZ99AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TQaE6naS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ea5074935so2200014a91.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 09:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768584852; x=1769189652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omt6t6gyNg/ahyDrqUD50qnP4xqrNa6EN8yZPVDHAws=;
        b=TQaE6naScmt3EPwR80rxV5NpMbFHsHsFsmIM9n7uy/EVjFEr6C31DkyEEpQ+ahZvXS
         phdqMb3XhYozS8N65kUjw0LXv93+8auqGgPhJ2+1ROdhtxovUNdKgboyA71+TX4w2zvU
         1WndneNCLKOL6a9A4VtuiIqzvmv30pkvuXmMp/AR9XStwzRbaZxi0myGIXBzPqqLk8cy
         /wqW26ruR7UZioy0HnSeyvnWhL7ZzY5VI6gupl0UeS10hw0q5QU32ofb87/fIJzP+mRy
         /QcJglkPbfLXPc4BPzaCf66IMFnuH9/k5/PCoyiaoCffKtbpuLLKt1DH2GI5t2+rnsyA
         gT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584852; x=1769189652;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=omt6t6gyNg/ahyDrqUD50qnP4xqrNa6EN8yZPVDHAws=;
        b=GEC6m/gYbFcLlXCL4WlYEx/mYn2hoSSo/lbRy3+lFpMgTSlgXLhv9NDq92xqKwuOPX
         3MArVImkm6BdbpUdjCTYf8XB/mS3nGSO0EY/PFMeo7Mzhf7aiDwsPS1pXV59SOOm063F
         FNS7EyGQcXjJJwBSwAQiBh8MRRktmjsY3hzTzoPImj9x/gDoI3E5XNYDHSeqSrE7cTMj
         arUzecaeNa3czc/FrD3ZC/A8a8SpE/lNOXSdUSQ3TBWqN9L6RZYy9keM9OqEHRJyKFeF
         R0uFOztnCzx3pObPoBwRYJOQW9afckTN2zGvg2rHWucEif3fhNdLf7nXRP50tJkDPJyD
         SG/A==
X-Forwarded-Encrypted: i=1; AJvYcCXF2zdpRFr767BN1KeqsR4JNA03UE68BfzYzXxnSOzA4XOmKEU02ABRsuPRJyj3E7Fm/6M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya9NANmsvUAzK8H1N7MVdzo0D82wfmhXJsmy1f9IY0cSw8654K
	LvmdMZfPnmS3QC5i6mxtIk9wCntr0xhiRJ08kkNsxo6My2w8ZZqHYQ01ZAXV1AJiCMQ832CwZTI
	yegGURA==
X-Received: from pjug18.prod.google.com ([2002:a17:90a:ce92:b0:34a:bd9b:7bb7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:f945:b0:349:8116:a2e1
 with SMTP id 98e67ed59e1d1-35273255e65mr2763724a91.20.1768584851389; Fri, 16
 Jan 2026 09:34:11 -0800 (PST)
Date: Fri, 16 Jan 2026 09:34:10 -0800
In-Reply-To: <E19BAC02-F4E4-4F66-A85D-A0D12D355E23@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-2-khushit.shah@nutanix.com> <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org>
 <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com> <aWbe8Iut90J0tI1Q@google.com>
 <cda9df77baa12272da735e739e132b2ac272cf9d.camel@infradead.org> <E19BAC02-F4E4-4F66-A85D-A0D12D355E23@nutanix.com>
Message-ID: <aWp2kjvTFAw1wPt6@google.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
From: Sean Christopherson <seanjc@google.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kai.huang@intel.com" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Jon Kohler <jon@nutanix.com>, Shaju Abraham <shaju.abraham@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026, Khushit Shah wrote:
> > On 16 Jan 2026, at 2:31=E2=80=AFPM, David Woodhouse <dwmw2@infradead.or=
g> wrote:
> >=20
> > But KVM *will* notify listeners, surely? When the guest issues the EOI
> > via the I/O APIC EOIR register.
> >=20
> > For that commit to have made any difference, Xen *has* to have been
> > buggy, enabling directed EOI in the local APIC despite the I/O APIC not
> > having the required support. Thus interrupts never got EOI'd at all,
> > and sure, the notifiers didn't get called.

Oh, I 100% agree there were bugs aplenty on both sides, but that's exactly =
why I
don't want to add support for the in-kernel I/O APIC without a strong reaso=
n for
doing so.

> You are describing=20
> 0bcc3fb95b97 ("KVM: lapic: stop advertising DIRECTED_EOI when in-kernel I=
OAPIC is in use=E2=80=9D)
> Since then I guess this issue should have been fixed?!  As
> c806a6ad35bf ("KVM: x86: call irq notifiers with directed EOI=E2=80=9D)  =
was much earlier.
>=20
> > On 16 Jan 2026, at 2:31=E2=80=AFPM, David Woodhouse <dwmw2@infradead.or=
g> wrote:
> >=20
> > If you're concerned about what to backport to stable, then arguably
> > it's *only* KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST which should be
> > backported, as that's the bug, and _ENABLE_ is a new feature?
>=20
> I think neither DISABLE or ENABLE is a new feature at least for split
> IRQCHIP.  It=E2=80=99s just giving a way to user-space to fix a bug in a =
way they
> like, because that=E2=80=99s how it should have been from the beginning.

Ya.  I don't see ENABLE (for split IRQCHIP) as a new feature, because it's =
the
only way for userspace to fix its setups without changing the virtual CPU m=
odel
exposed to the guest.

For better or worse, the aforementioned commit 0bcc3fb95b97 ("KVM: lapic: s=
top
advertising DIRECTED_EOI when in-kernel IOAPIC is in use=E2=80=9D) already =
clobbered the
virtual model when using an in-kernel I/O APIC.  Even though KVM (AFAIK) go=
t away
with the switcheroo then, I am strongly opposed to _KVM_ changing the virtu=
al CPU
model.  I.e. I want to give userspace the ability to choose how to address =
the
issue, because only userspace (or rather, the platform owner) knows whether=
 or
not its I/O APIC implementation plays nice with ENABLE, whether it's risker=
 to
continue with QUIRK vs. DISABLE, etc.

