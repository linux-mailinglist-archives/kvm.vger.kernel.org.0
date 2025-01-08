Return-Path: <kvm+bounces-34789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C41AEA05FCD
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19A883A1227
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA431FE457;
	Wed,  8 Jan 2025 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L3n43rRu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB5F1FAC53
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349482; cv=none; b=oxjHT8VTkHC7n8BgLeRdmN81GkqUmyIJjG9Ou0kXUVSd5EeP6Ra87iOvy18HFjnzn3uBEBo7y3fWbZv54glskXpd8S5fw0eWqGCqUpkOkDRYVQaeB9raJ5RE40xhieAi79poMjj1H84svLCB4034jYICwUDhVG+Pnx2Wt0AUTdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349482; c=relaxed/simple;
	bh=uFCerLUu2T4I661JjtdcuupWXppPvMcsX+lF2HSHy+Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NfVUtvO2b5LQvvlx/E6gfDA0mfNKjVeiVpwvkIdUR6RRK3HJNI73KPJIb7GcR634f8+7oUAnP8d7OIgZezjugS5KhKij8zcElnEddnXa+VjeZuLYo0ji+pTjmDBNF+zl3J5X/5T/NJmmr/JAkqOj/YEpdNBSv7rg8gEoF41eE/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L3n43rRu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163dc0f689so118617185ad.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 07:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736349480; x=1736954280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=svCTvF2tEKcLu+qPTwRtfvESTV0KIhI9s6mPVElDk6A=;
        b=L3n43rRu6hL6wjCUJwxH3TF8wwYlHDJ1OtIbj8j1aGYjOUv7Pb9z/3yB/wEY8Fd1/W
         NMm9o54tDjfBrgrKIrX5kx9ePwvh4wu0fkzeobMGH0WWCu1azrJePWwwZvioxRNO1x8f
         IZzqsEDFAW2jIjWDmxu0cdFD09XP6bfdr9RrxyHh7gVuRkzwz6ygMQVWGhukv2IwTeQh
         MHTG/Lq/P0R5cAYmVxR8TybP6FxKGYe+xyScsX0eORSEtDAmzKUb09bwP8ZsVYgF3n++
         2FicAWN5QaqRE+xV1faCpKv/gNcHtA0eVCMoAYszLuwBnL2eskLSAke5lY+BcA6ttuEx
         F74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736349480; x=1736954280;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=svCTvF2tEKcLu+qPTwRtfvESTV0KIhI9s6mPVElDk6A=;
        b=jcWMBikZYcUOq4RAUQQ5KYrUpyMgJdsWWQSciIviwxm5E5r6P7fKM0573Xkmmqfx2O
         uy+iQwPYC4BkHFqcX7knydzsLZ+meQfKzBfabvOcpB6OvrMOyTEsdWV2Sc5hcdGGm3fc
         ORxbV/4osEL2pl+0uIBt8NRM6jHOS8MvH7dYLdnsUi/DulJ7hkVNx73t4eFPqjOjZPD1
         AXWIj7btn4A7EUmZ8erg3x8fw5ykqBNJUOhOhWeaySs/NX7WWx8dq9lv/+WAXtIFYKS4
         T0QpbACFYYFKyiP5fEdCoYOCGL7yhop9Wb8bbxlK4U7F50D4+R9NR5qngO0F/+67MVsX
         AS0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXFZMxjTlTCzkZy9cKF2o4BIM4o1VIT8oZdHRixZ6CGadwZR3YrEMUc3V+JAUQ37YuxASg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnpXA5VdBfMIG4tPDYoplfSUS1EmRs5TnahzmMVGtu5+B305Il
	CwMo8mypgcG9ezC6ppNtoyrDL5GmSXTEcHhveLpoq4SzOfaGpqOIp9rFMdV+BJ3fzy88oh/9nQs
	z8Q==
X-Google-Smtp-Source: AGHT+IFYAiCogwDWTnPToi/jJEHLUboqAk8gG89TQ75qc0dKdOOeMNdVVTuuEmP2XX0QF1uwlCrcwpKzxi0=
X-Received: from pfbbt23.prod.google.com ([2002:a05:6a00:4397:b0:727:3c81:f42a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d83:b0:1e4:80a9:3fb8
 with SMTP id adf61e73a8af0-1e88cfa6e23mr4807863637.16.1736349480035; Wed, 08
 Jan 2025 07:18:00 -0800 (PST)
Date: Wed, 8 Jan 2025 07:17:58 -0800
In-Reply-To: <CABCjUKB-pzcY-XFzpBQ6mRi-LiPJ7exAwr+RQXR-pD+P0cxrYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-3-suleiman@google.com>
 <Z31KK-9Z_b-UleVT@google.com> <CABCjUKB-pzcY-XFzpBQ6mRi-LiPJ7exAwr+RQXR-pD+P0cxrYA@mail.gmail.com>
Message-ID: <Z36XJl1OAahVkxhl@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Include host suspended time in steal time.
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2025, Suleiman Souhlal wrote:
> On Wed, Jan 8, 2025 at 12:37=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> > > Note that the case of a suspend happening during a VM migration
> > > might not be accounted.
> >
> > And this isn't considered a bug because?  I asked for documentation, no=
t a
> > statement of fact.
>=20
> I guess I don't really understand what the difference between documentati=
on
> and statements of fact is.

It's the difference between "X may be buggy" and "X has this exact caveat b=
ecause
KVM doesn't support saving/restoring associated metadata".  For this case, =
I'm
pretty sure it's possible to document exactly when suspended time will be l=
ost,
what may happen if that accounted time is lost, what userspace could do to =
avoid
dropping suspend time, and finally for the changelog only, specifically why=
 KVM
support for accounting suspended time is *intentionally* not providing APIs=
 to
save/restore pending suspended time.

> It's not completely clear to me what the desired behavior would be when
> suspending during a VM migration.

That's fine, it's not your (or KVM's) responsibility to know the desired
behavior for every possible/theoretical use case.  But as above, it *is* KV=
M's
responsibility to properly document any caveats with functionality.

> If we wanted to inject the suspend duration that happened after the migra=
tion
> started, but before it ended, I suppose we would need to add a way for th=
e
> new VM instance to add to steal time, possibly through a new uAPI.

It's not just migration, and it's not just the case where the host is suspe=
nded
*after* vCPU state is saved.  Pending suspended time will also be lost if v=
CPU
state is saved after suspend+resume without entering the guest (because the
accounting is done late in KVM_RUN).

> It is also not clear to me why we would want that.

Which is fine as well.  If some crazy use case cares about accounting suspe=
nded
time across save+restore, then the onus is on that use case to implement an=
d
justify appropriate support.

