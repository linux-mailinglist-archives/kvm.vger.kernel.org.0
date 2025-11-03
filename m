Return-Path: <kvm+bounces-61893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 592DFC2D50F
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 372D64EB041
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 17:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E00F631CA59;
	Mon,  3 Nov 2025 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oeUPv9lO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F91631C56A
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762189075; cv=none; b=BhpC3szrfgn6hAaMF5Psd0sbQB56hqZnyR8oVYESQP6e+e3NyOR5nTKmwVDFp4qiMe3KJzV4Fv7hU9ZsrTbIcv5aecucoQ2xIpCWoE46svB5bQBzuJGwc3lIwZdP1xK1Z9Xo5OI355BGixC914VDi+fY+gKmfDJ4LlgVkI0gmeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762189075; c=relaxed/simple;
	bh=8QZMELXENbunUYpr28WqprFjzAksKDqeP0VLh+0+HBE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B7KmLAKerYGPrR13gKjD4vwzHf9jOwqJ//zfij4TlPTvdSugZXCKzRa7XbBPGXAPGnzIxgE++i5+WvzblfXWUoolhcZFk9W2D48xtGeKmICACLuT53hKQ4tesl27C+j2BwAmv2WSHtkcvU3YmeQvTl0e/i2orjpJhLmbOaLYxPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oeUPv9lO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341616a6fb7so448523a91.0
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 08:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762189073; x=1762793873; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KgHCRB+iOhQXBR2DJ3UKt+ri7IzX08+hr1DQhDLbsGo=;
        b=oeUPv9lOtOFFcTCXXx73+qQHLeGQdoIKmtLtfdAco9WN6qOFn56grch2nwnNSVD9M9
         tavasGV0VNjLhrJpBaC5yTq7YVD6tv46LLzSIlFbZl2YoyvRcZTG23WioFeGFE/yibOv
         O2J0qhdeorK89aTivvkWtEzkCwGgoMYk9dPYnTfMeg7VxQTmOUx66DlfnYkWxTY1f3o3
         I+iSgAhsEim66RmAE7uSXkrFD4pfQS897HnVNBWT9gxE78QnAatBE6EaJfvEWjBje9+d
         z7WGLhbSKonl+JqWVODRjETfaZoyyNM5G8Nmz+ZKHW/ciLutNNNGOvEUVp7LKX7jbajW
         /1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762189073; x=1762793873;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KgHCRB+iOhQXBR2DJ3UKt+ri7IzX08+hr1DQhDLbsGo=;
        b=L1EqdU84jl9kKC06xugSq9UXxdx5e7a77ik1OjdGJDZPZd+926DFG0Ig3jNOiHcxRB
         v0NpIZ9BFJKmCm1c3LztQ+uP7jPFNZTjhNX2CtGtTseFzfbM1cipOk8czg22nWz6AuGr
         8Gu2zmVWeXKm+mL0xzKSw+USzJivG5BrpQ4o+JkTLzFMl+pMDghg1sf77k7DuqetovJe
         ggeGzWYaZQ5DzEfIt6V/8PsHahzudgWEIo1QVnXor8hmWP+AqeyoJa4Qp0nzKZNBF8t0
         0fHxmBrEILqYdZ186bBKDdUuB6d/Zwnzh1ZzA+wwMCTW/baIBsbIw1gJes2Dhm1WKRrP
         KtNg==
X-Forwarded-Encrypted: i=1; AJvYcCVadSMrLQSSl32T0KaM59c8nusYSubFClF9cEiYi69qiZWwlGlViEHkveu17u9xnf3SYEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAb92sL+lc6yPnGXbpa73m0r9iEBRxwkRVjsuxCU0f0xt8i8kV
	bhxbHBXkkE/kQVU0zSi9IX4R99/Y7bfERHW4EbeGUAYIVnD8uBnmWmTsm9aapCDruiEpF9xfdMh
	ZWMSeAA==
X-Google-Smtp-Source: AGHT+IFOpWte/V7QEZNwmFK3W3HK1rZFTmmKzEm/d2Hx1LQQlueXjMmVSeG9D67BxqXsCpRIlefh72yq0PE=
X-Received: from pjpe14.prod.google.com ([2002:a17:90a:9a8e:b0:340:92f6:5531])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e8e:b0:332:3515:3049
 with SMTP id 98e67ed59e1d1-34082fc930bmr15533204a91.4.1762189072869; Mon, 03
 Nov 2025 08:57:52 -0800 (PST)
Date: Mon, 3 Nov 2025 08:57:51 -0800
In-Reply-To: <80691865-7295-44C9-9967-5E5B744EB5D4@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918162529.640943-1-jon@nutanix.com> <aNHE0U3qxEOniXqO@google.com>
 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com> <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
 <aPvf5Y7qjewSVCom@google.com> <EFA9296F-14F7-4D78-9B7C-1D258FF0A97A@nutanix.com>
 <aQTxoX4lB_XtZM-w@google.com> <80691865-7295-44C9-9967-5E5B744EB5D4@nutanix.com>
Message-ID: <aQjd1q5jF5uSTfmu@google.com>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
From: Sean Christopherson <seanjc@google.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2025, Khushit Shah wrote:
> Hi Sean,=20
>=20
> > On 31 Oct 2025, at 10:58=E2=80=AFPM, Sean Christopherson <seanjc@google=
.com> wrote:
> >=20
> >> Hi Sean,
> >>=20
> >> Thanks for the reply.
> >>=20
> >>> On 25 Oct 2025, at 1:51=E2=80=AFAM, Sean Christopherson <seanjc@googl=
e.com> wrote:
> >>>=20
> >>> Make it a quirk instead of a capability.  This is definitely a KVM bu=
g, it's just
> >>> unfortunately one that we can't fix without breaking userspace :-/
> >>=20
> >> I don=E2=80=99t think this approach fully addresses the issue.
> >>=20
> >> For example, consider the same Windows guest running with a userspace
> >> I/O APIC that has no EOI registers. The guest will set the Suppress EO=
I
> >> Broadcast bit because KVM advertises support for it (see=20
> >> kvm_apic_set_version).
> >>=20
> >> If the quirk is enabled, an interrupt storm will occur.
> >> If the quirk is disabled, userspace will never receive the EOI
> >> notification.
> >=20
> > Uh, why not?
> >=20
> >> For context, Windows with CG the interrupt in the following order:
> >>  1. Interrupt for L2 arrives.
> >>  2. L1 APIC EOIs the interrupt.
> >>  3. L1 resumes L2 and injects the interrupt.
> >>  4. L2 EOIs after servicing.
> >>  5. L1 performs the I/O APIC EOI.
> >=20
> > And at #5, the MMIO access to the I/O APIC gets routed to userspace for=
 emulation.
>=20
> Yes, but the userspace does not have I/O APIC EOI register and so it will=
 just be a
> meaningless MMIO write, resulting in the the IRQ line being kept masked.

Why on earth would userspace disable the quirk without proper support?

> > On 31 Oct 2025, at 10:58=E2=80=AFPM, Sean Christopherson <seanjc@google=
.com> wrote:
> >=20
> > That's the whole point of the quirk; userspace should disable the quirk=
 if and
> > only if it supports the I/O APIC EOI extension.
>=20
>=20
> Sadly, so if the quirk is kept enabled (no I/O APIC EOI extension) and if=
 we do
> not want a guest reboot, the original windows interrupt storm bug will pe=
rsist?

Well, yeah, if you don't fix the bug it'll keep causing problems.

> Unless we also update the userspace to handle the EOI register write none=
theless,
> as damage has been done on the time of power on.
>=20
> > On 31 Oct 2025, at 10:58=E2=80=AFPM, Sean Christopherson <seanjc@google=
.com> wrote:
> >=20
> >> and updated userspace can opt in when it truly supports EOI broadcast
> >> suppression.
> >>=20
> >> Am I missing something?
> >=20
> > I think so?  It's also possible I'm missing something :-)
>=20
> I am just thinking that the original Windows bug is not solved for all th=
e cases,
> i.e A powered on Windows guest with userspace I/O APIC that does not have
> EOI register.=20

Userspace _must_ change one way or the other.  Either that or you livepatch=
 your
kernel to carry an out-of-tree hack-a-fix to avoid updating userspace.=20

> Also, in the patch instead of a knob to disable suppress EOI broadcast, I=
 think
> we should have a knob to enable, this way at least for unmodified userspa=
ce=20
> the buggy situation is never reached.

No.  Having a bug that prevents booting certain guests is bad.  Introducing=
 a
change that potentially breaks existing setups is worse.  Yes, it's unfortu=
nate
that userspace needs to be updated to fully remedy the issue.  But unless y=
ou're
livepatching the kernel, userspace should be updated anyways on a full rebo=
ot.

