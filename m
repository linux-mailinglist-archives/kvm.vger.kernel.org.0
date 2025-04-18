Return-Path: <kvm+bounces-43669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2398FA93ACB
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 18:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25ABD18912A2
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 16:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7881221C19C;
	Fri, 18 Apr 2025 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dloq/+KF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF7021481E
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 16:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744993335; cv=none; b=Q6A/m8K9YrspTaqeoTVS6KFfMbV5PDrPklzq8v7PZGB/Fa6VTcWU+c65lrUwCbpANCgA4hMxvWbIIDQSwpguIvBFPHToFD6Db3HJgyfSfGBWyPlNxCswnYrNC1DvyhgpcgS+lTZN1QsPgud9r5ws6hpLOpK0yuDrSpLE8qQqjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744993335; c=relaxed/simple;
	bh=Xaqjq8y6sGmO1ZUk2didNrSa73aZGxUDMzs+j+Zi8/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CCKjNLnmCYTBMtUrWJdHqqYz7oTbJX+mPjwLSttjnUWK1gIn3Qls681E0By7aPEAh4c0Q2PDbZz2G1vZk+C2z3+arylLWdkjgRd5DCl+RPuHD1GBjY9f6wXy4O6IfGM4afIXR0w57QfiLmnNNQWWjdpHRPekBbdTs8xYUifdPkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dloq/+KF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af8d8e0689eso2002077a12.2
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 09:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744993333; x=1745598133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1pjtyBfSlLKyL/NS0nFvpCvZz0n/zUmSG0nruCRN+Q=;
        b=Dloq/+KFdEApVpqRrbhvgPKsQg9NjrQXeSav8hNK5eD3hOrlZxastwt84tbwGSL5RH
         d38YL+VqiM7yiuX6R3wC8mVm/YcohiM9CyGUn47pmfuZkBJtuwC+TLq/Fm2R8r/j9z37
         6plZGoy2c0P+L97tT9oIb9LIY3/hFrnZtK+S6EEhOON4UsDhxtfA/2CbtSWf07RkJJ8q
         UTmY2QEGy+NJ0JH/T36jYwG0BTjePOxQk5dN3vXBbTIShxq9X/QF/CtzrHz+wDlQtMpR
         jaU5kPz8CMWRouCGoBQU9Ou4rB1UirFDIHf4F/gMsbrbvSxY0GTi9gQhdKz+oOzePOR0
         8oLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744993333; x=1745598133;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D1pjtyBfSlLKyL/NS0nFvpCvZz0n/zUmSG0nruCRN+Q=;
        b=jQGbYJDa335iq9iZjMX0dxBL2IvJ0nLIJC4U+JGMUz6BQ5+9TW3LT9fHvJtITxReYf
         femc2vr4W7YdmSLi3lcP9njaGJJJbKzahs3GJEquK2pFGpw+QWDUbrB1xzgf85nZd5j6
         HaoyJVBHCD1Rzrlqow1yurl4CS99CdsqXXvftJDeHA8a1JLRQ4RUwBDI3o2M8ynWM9Q5
         TucfJniZLEDUd4wPt6vT4dJVB9xfhwclEGAgNWJ8/u+3dZupRvznVHG6rshNAsMKWepa
         qdBu7y8i5bbqE9R3wwRlSQK4VtbkyZxjY7zQ6wSGWNoxMcvlFaqz5r+1qTO8yLLBuQac
         1YKg==
X-Forwarded-Encrypted: i=1; AJvYcCW+gzai28JRBWiCox4sJN8UdHgj4tkmGQpBQKdjRGEw5ymVA8fl4mn6orJV97dE3hpOBBg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0JunHVaq9e/ex192QvkqPgLneVOvJU3eIXI2SFxNwHJzSbW4g
	jftz6+qyhimf0pWSFail77f37u8Z2jXFCXWiejxHAvDTmZJq6bcd4vLKp0rd6H6MOJea3613oHE
	e2Q==
X-Google-Smtp-Source: AGHT+IHqwNO/x37hOdGCk0YIJnSIGZEumqGvWSf5j1xktHt7N62gEkfdWFum/WCMhL+WKTL+rztUgYv0GjY=
X-Received: from pfx42.prod.google.com ([2002:a05:6a00:a46a:b0:73c:26bd:133c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3bad:b0:220:f59b:6e6
 with SMTP id d9443c01a7336-22c5356798amr39350385ad.8.1744993333345; Fri, 18
 Apr 2025 09:22:13 -0700 (PDT)
Date: Fri, 18 Apr 2025 09:22:11 -0700
In-Reply-To: <6f070686a44225d36bc1086dc1643841b3d43d19.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <6f070686a44225d36bc1086dc1643841b3d43d19.camel@infradead.org>
Message-ID: <aAJ8M0Mm9bv7xlVs@google.com>
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025, David Woodhouse wrote:
> On Fri, 2025-04-04 at 12:38 -0700, Sean Christopherson wrote:
> >=20
> > This series is well tested except for one notable gap: I was not able t=
o
> > fully test the AMD IOMMU changes.=C2=A0 Long story short, getting upstr=
eam
> > kernels into our full test environments is practically infeasible.=C2=
=A0 And
> > exposing a device or VF on systems that are available to developers is =
a
> > bit of a mess.
>=20
> If I can make AMD bare-metal "instances" available to you, would that hel=
p?

Probably not, my main limitation is time, not lack of hardware.

I'm confident I can get a functional AMD test setup internally, it'll just =
take
a bit more time/effort (there are other people working on the testing front=
; I'm
hoping if I wait a bit, someone will solve the hiccups for me).

I'd been holding this series since ~October of last year, precisely due to =
lack
of bandwidth to configure a working test environment.  I felt that I got fa=
r
enough in testing that the odds of something being _really_ broken are smal=
l,
and didn't want to delay posting for potentially multiple more months as I =
assume
other folks in the community already have readily available test setups.

And no matter what, I want to get more thorough testing on a broader range =
of
hardware, e.g. from Intel and AMD in particular, before this gets merged, s=
o in
the end I don't think me getting access to different hardware would move th=
e
needle much.

Though I appreciate the offer :-)

> Separately, I'd quite like to see the eventfd=E2=86=92MSI delivery linkag=
e not
> use the IRQ routing table at all, and not need a GSI# assigned. Doing
> it that way is just a scaling and performance issue.
>=20
> I recently looked through the irqfd code and came to the conclusion
> that it wouldn't be hard to add a new user API which allows us to
> simply configure the kvm_irq_routing_entry to be delivered when a given
> eventfd fires, without using the table.

Yeah, especially if we gated the functionality on a per-VM capability.  Tha=
t way
kvm_irq_routing_update() could completely skip processing irqfds.  At that =
point,
other than the new uAPI, I think it's just irqfd_inject() and the resample =
code
that needs to be modified.

> I haven't had a chance to look hard, hopefully your rework doesn't make
> that any less feasible...

Quite the opposite, it should make it much, much easier.  Currently, both
vmx_pi_update_irte() and avic_pi_update_irte() pull the GSI's routing entry=
 from
kvm->irq_routing.

After this rework, irqfd->irq_entry is explicitly passed into=20
kvm_arch_update_irqfd_routing(), i.e. it removes two of the gnarliest paths=
 that
expect irqfd to go through the standard routing table.

