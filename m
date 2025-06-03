Return-Path: <kvm+bounces-48334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 390D8ACCD6D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 21:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0998F162394
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 19:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F263202C43;
	Tue,  3 Jun 2025 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WRY23oDe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C68620B81E
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 19:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748977216; cv=none; b=uwYU65xAwEdfpWHB059CADMQGXRycD1Df9l69/3+1DAn8SnMG0IVjubnt0BiENuQpDUzzg9K1QQYI24caelZjVQVWbvhjuEXoYgBjYdg+N59R8v23TPdKJOGhAymTJR6HSFqSKxrk4jWcsjD95tonnTiHCf1nVYYvQzt+0RzycA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748977216; c=relaxed/simple;
	bh=m5TJF0jIIbgCGQuk4aBQNxWcU+kLuEmnNdEOoqpXnrQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vjq1uv8Ea8QOJMJnrJ8tNrJprFlXz5/uAwKg5vkNyT/PoAfHft6uMpLCPerSIYCRhOPnpHvUO6idpZ/L0vlxCRaahxIOq0lptaJPHqUbgZvnNW1rNRY6UCUqwf+P0mABBGfqpuNnJ6SN3gr2ioJP9Qm7TCo1oUXpGXgSD1NV/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WRY23oDe; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25278so6369567a91.3
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 12:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748977214; x=1749582014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LRI+kvPhnbWyNuALR5/UlU1wn44Og69LXb9THAFowqQ=;
        b=WRY23oDecMff6YNj6gN/NDeipVqbx5edVn6J0LA4PggtMeku73nQlull2jJ+yTfPLT
         vvrNc1IVgTnorA8I/vPtfrMwmamxNz6yqlL8mQKMXBoZ8QKLREUkqZMUaQkFrWu7uHW8
         Rclk0ZIrxtVo4nzFvtMg8jnbch5LG7C21H1aG60ksAAaHstakDQfGNxtPleJUJq/3ED9
         tS8vH3xpyNGRMDd8Ee16Ops4kOfF9z0wSteRhhAb2k0EzJqnGlUFbF/Gwo/YKb5AQ4n8
         FBl+ypc8rw5yLR6qr+RQvVDuOlZ0gJg3glAxgu6FZk9AZWHcPmFnKbFcDVhj2rmqIGVk
         7vCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748977214; x=1749582014;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LRI+kvPhnbWyNuALR5/UlU1wn44Og69LXb9THAFowqQ=;
        b=c4wyt8ekMzVfeQ4O7Sp3N3l4XZL7qZrXKVDVLQSu7L5y5TpI3J9fr3nQJ2ivArn7iJ
         N3rhLsEqCPLQJ6T3HqyUTcE85m3lmUYYdV4vMoJmi6Zil5TtovyYuBOTmQunpuI3jGs5
         9aTnHodHITpgYnUdgsZMICpTKMcLeYa/BjmKM1Dz9LVCyIkVe0S0RvpDO2A9GjKcdBhh
         +ue216ip7VQF2P8cNS4pm9HWdkk6wKZOJPhzpnjf5bPf7lDtBhGPerxTxMc2diDrJC4S
         wZp04JKidgRigrRFETD2JLL//RRAv5jDtx4CdITGcxAalKcSVtk/wLy/wRQkE4vX6+YV
         Qv/w==
X-Forwarded-Encrypted: i=1; AJvYcCUQl1pa5ywNcX08AD2AAoQcYDdqmSqT5/yDWJgEbRziy0u5HpawuWEDD3c3s3ia9iU6iIk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhRbeqQz7zbi/guWuc9ktnUHWdRqCHlw94Ly5VtC+uVRNKDe88
	S7uAcmDxl+PxuU2SsMsdr2NNtoVvXpACNTLkyzHTnvLADmkYtlQOi8NWyRYDKpnKFRZqCaPdNK6
	B4Rp+gw==
X-Google-Smtp-Source: AGHT+IFxfWW/66Xi/qsd8HDqTJ/6I2NynwNI53ATDTHnfVAav9b9q4IUuy06fJqORMG8yPjMT9M/PLVLHaw=
X-Received: from pjbsy7.prod.google.com ([2002:a17:90b:2d07:b0:310:f76d:7b8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2804:b0:311:e4ff:1810
 with SMTP id 98e67ed59e1d1-3130ccf511cmr257256a91.3.1748977214333; Tue, 03
 Jun 2025 12:00:14 -0700 (PDT)
Date: Tue, 3 Jun 2025 12:00:12 -0700
In-Reply-To: <CADrL8HWvYwxTvRQFzk33aaDLgnSzgBvCaTW_1vP-fBuaC_K4Sw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250602224459.41505-1-seanjc@google.com> <20250602224459.41505-2-seanjc@google.com>
 <CADrL8HWvYwxTvRQFzk33aaDLgnSzgBvCaTW_1vP-fBuaC_K4Sw@mail.gmail.com>
Message-ID: <aD9GPPz9U5JU89b-@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Reject SEV{-ES} intra host migration if
 vCPU creation is in-flight
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Peter Gonda <pgonda@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2025, James Houghton wrote:
> On Mon, Jun 2, 2025 at 3:45=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > ---
> >  arch/x86/kvm/svm/sev.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index a7a7dc507336..93d899454535 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2032,6 +2032,10 @@ static int sev_check_source_vcpus(struct kvm *ds=
t, struct kvm *src)
> >         struct kvm_vcpu *src_vcpu;
> >         unsigned long i;
> >
> > +       if (src->created_vcpus !=3D atomic_read(&src->online_vcpus) ||
> > +           dst->created_vcpus !=3D atomic_read(&dst->online_vcpus))
> > +               return -EINVAL;
>=20
> I think -EBUSY (or perhaps -EAGAIN) might be a more proper return code.

Yeah, I was 50/50 on EBUSY vs EINVAL.  I think I went with EINVAL mostly ou=
t of
spite :-)

I'll change it to EBUSY.

