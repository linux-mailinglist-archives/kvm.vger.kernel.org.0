Return-Path: <kvm+bounces-35701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C04EBA144C8
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B4E33AA6A9
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A1A242244;
	Thu, 16 Jan 2025 22:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NXTaXS+r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FE122CBDA
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737067910; cv=none; b=o2cEY3h3R33i768izJKbtTZavs+bGmqCzCkt0ewZT4KQtpqTBA1vhR1d5Z3CMBbHbdibu66Y3iKuqKg+HNTezMRL+VAv+GXHmFBDh77WOaQYF8GL5bXeaJ9w3+FD9Z4HkbYW2wHC41aAeop0BBbCzryYhHlbptCbhfRIUgksvN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737067910; c=relaxed/simple;
	bh=8vzofeRWcsorue9hM39qV72+nCmIg6eJE6V/BKMgF4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ivmIHe90L+R4y+SCuz+3Yzy2Rdbfl/48mnDO9U40Yf3pzNfablj8/gY0MwN0uVoY+VqoyGO/5RuzlfbC/8yckucIEzehkx1XzUDb9SS57m4pSrRoyRFvLvcqQdAIIoQxP8L40Un37ZOHZXkIfcVFZznKKCF1FNTR1lZehZIlJoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NXTaXS+r; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e53aa843a24so2829826276.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 14:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737067908; x=1737672708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mo8wWiVSieP36PQBtcad/p/Y6sOL31Xn/K7FaizLB00=;
        b=NXTaXS+rknMZbxNfyNaPT+zT6acEJv6t8DdDnsJ5D49rbqzganfw9Cr/KqLj6pii9f
         pKhnf2CGS4R3IKomwn9Br3i0ZSRhjdY7B4dtbKABvaH0evqe8jIISRY+h+gMFB+B39x3
         pxdLJMNSxSVL6ivbqnXDrPQ+6p8RDA97LAuNQ8/kJKr2cxq+po6h0JNrioX49SrXzwtw
         t8BX5dbSonQrgkr3FeEUnNdf22eGCIIQYY7ecmBat4RKz/P9I4lj7W+TnAmpeVCGNQV9
         7A/HvkCYCEkH1r0B9F99nr47xkgjHiurlnyHYPNpwNvZHKeBb67537VWkbaEaQ6uq6Zl
         Lylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737067908; x=1737672708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mo8wWiVSieP36PQBtcad/p/Y6sOL31Xn/K7FaizLB00=;
        b=OJ2x4VT1BlnOokgoqanSMGr+yZbSxL0iirBxVa79gbqBZflmWE7lHaEVhtxovsNXHr
         L8KL9oJi/DxY56aXG2XjcpZKxxjMhYorOu6sl3pJ+I0RbQVyLaDSdAkf60Y0WKERHJZV
         i7F5NDZND4dFZ9uimKinVO8hv8cU4V58HEe+XcIUdUgzyLyjaeA8oLMat489dbpci9FK
         0AUVXG4ZYLsbbUv+p+4BUSBGjuPToLGZwD4VxK0xOPAJIn2ohmw/SRAtoNJgY9NE8qZy
         v4ERyRnLtlSAGzddiFGajgh879ehu04QOz+ZPA+lBlK24DOL5nlBuLzMZKkRObMie+K6
         zE9A==
X-Forwarded-Encrypted: i=1; AJvYcCWpie9E5xl6QZRnxbhcvIGiSghs6cQo34ZwEwwFRVi4s/kpzixn5MH+8xbRhg13Jj1h3lQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/Rsj2a8d9Hb5OLw8ojaUg/ewaXcvpfe4Xmz2Hay/XV5S65eNr
	ia+91hO//v8BipGPJ+XeWjMlAcIE2wRTN9wsn4/GOWD/hWe4QMCktSvr6MS23PDESxJwYP/dYR/
	uioXKEXfBDJRjooBm8HqtgQl/oq8z2VBx4Up0
X-Gm-Gg: ASbGncs6JSsTNd6ARyh9jx2PzqVy7CK9HehaJYKqaNHAQmSg6YakZkNweNmXjYJ2wSK
	DKuVtw0n7ikn6pGyT3ZogrPUv8iFK/rgDjFvAncxzVcIQSVHlsxz9OhnYd+rfH7unknVr
X-Google-Smtp-Source: AGHT+IHDVU+IJsNlLjF83+Ds9RyEMFn3PvbsQABSjjSiGmmyVwS/zqJzA12leRcKXime5YwyEjpU/j8pOjxtozPQTYw=
X-Received: by 2002:a05:6902:1447:b0:e54:9a7a:bce1 with SMTP id
 3f1490d57ef6-e57b0c833demr376797276.20.1737067907684; Thu, 16 Jan 2025
 14:51:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n> <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n> <Z4lsxgFSdiqpNtdG@x1n>
In-Reply-To: <Z4lsxgFSdiqpNtdG@x1n>
From: James Houghton <jthoughton@google.com>
Date: Thu, 16 Jan 2025 14:51:11 -0800
X-Gm-Features: AbW1kvYOIA-rxNht25vJwL_NVGMkqbp_NoziG0prE60wf6DVUh2TfK28c0IaFFg
Message-ID: <CADrL8HWRavCoZ_NtXJvcLOvjOiGDCor6ucWeEqkecA3VDY-adg@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
To: Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 12:32=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote=
:
>
> On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> > James,
> >
> > Sorry for a late reply.
> >
> > I still do have one or two pure questions, but nothing directly relevan=
t to
> > your series.
> >
> > On Thu, Jan 02, 2025 at 12:53:11PM -0500, James Houghton wrote:
> > > So I'm not pushing for KVM Userfault to replace userfaultfd; it's not
> > > worth the extra/duplicated complexity. And at LPC, Paolo and Sean
> > > indicated that this direction was indeed wrong. I have another way to
> > > make this work in mind. :)
> >
> > Do you still want to share it, more or less? :)

I think I'm referring to how to make 4K demand fetches for 1G-backed
guest memory work, and I kind of said what I was thinking a little
further down:

On Thu, Jan 2, 2025 at 9:53=E2=80=AFAM James Houghton <jthoughton@google.co=
m> wrote:
>
> FWIW, I think userspace mapping of gmem + userfaultfd support for
> userspace-mapped gmem + 1G page support for gmem =3D good 1G post-copy
> for QEMU (i.e., use gmem instead of hugetlbfs after gmem supports 1G
> pages).
>
> Remember the feedback I got from LSFMM a while ago? "don't use
> hugetlbfs." gmem seems like the natural replacement.

I guess this might not work if QEMU *needs* to use HugeTLB for
whatever reason, but Google's hypervisor just needs 1G pages; it
doesn't matter where they come from really.

> > > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> > > replacing it. And as of right now anyway, KVM Userfault *does* provid=
e
> > > a complete post-copy system for gmem.
> > >
> > > When gmem pages can be mapped into userspace, for post-copy to remain
> > > functional, userspace-mapped gmem will need userfaultfd integration.
> > > Keep in mind that even after this integration happens, userfaultfd
> > > alone will *not* be a complete post-copy solution, as vCPU faults
> > > won't be resolved via the userspace page tables.
> >
> > Do you know in context of CoCo, whether a private page can be accessed =
at
> > all outside of KVM?
> >
> > I think I'm pretty sure now a private page can never be mapped to
> > userspace.  However, can another module like vhost-kernel access it dur=
ing
> > postcopy?  My impression of that is still a yes, but then how about
> > vhost-user?
> >
> > Here, the "vhost-kernel" part represents a question on whether private
> > pages can be accessed at all outside KVM.  While "vhost-user" part
> > represents a question on whether, if the previous vhost-kernel question
> > answers as "yes it can", such access attempt can happen in another
> > process/task (hence, not only does it lack KVM context, but also not
> > sharing the same task context).
>
> Right after I sent it, I just recalled whenever a device needs to access
> the page, it needs to be converted to shared pages first..

Yep! This is my understanding anyway. Devices will need to GUP or use
the userspace page tables to access guest memory; both of which will
go to userfaultfd. And userspace hasn't told KVM to make some pages
shared, then these GUPs/faults will fail.

Maybe Trusted I/O changes some things here... let me reply to Sean. :)

> So I suppose the questions were not valid at all!  It is not about the
> context but that the pages will be shared always whenever a device in
> whatever form will access it..
>
> Fundamentally I'm thinking about whether userfaultfd must support (fd,
> offset) tuple.  Now I suppose it's not, because vCPUs accessing
> private/shared will all exit to userspace, while all non-vCPU / devices c=
an
> access shared pages only.
>
> In that case, looks like userfaultfd can support CoCo on device emulation=
s
> by sticking with virtual-address traps like before, at least from that
> specific POV.

Yeah, I don't think the userfaultfd API needs to change to support
gmem, because it's going to be using the VMAs / user mappings of gmem.

