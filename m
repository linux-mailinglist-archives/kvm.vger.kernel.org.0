Return-Path: <kvm+bounces-33999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2099F58EE
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 22:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA9F2188276A
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 21:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289EE1FA149;
	Tue, 17 Dec 2024 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BILBghsH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F411F9A98
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 21:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734471464; cv=none; b=h4ASAnmarDudNMhZN053Lk1T0aqhw2wdVFBBM/mQbdROgUENKwz7tMO8I/gwtShPezpyubglXC6uTHXObUtMzH/W/TVTaNS8rA6tBOVj4G9qLdnIhBDaNplEmNGg0DoE+UeBgfcT27DXzVbkDjwCsnhLitXolDJC0ZpGoAohKPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734471464; c=relaxed/simple;
	bh=FR0P8x7/9ngEgKiXbPcjZ9SkDVlLITONVwCAUmfHs9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AFSB5d8//sbOBmsV9zI0eGaJGZDix6YqSgEw9X7rY96OqlxPfrzvdNwWAAdg7V1D8l8WXtaqVvAw43/f+NCvl6QeXL2lIBu6DOTepchXi0MO5xmFKUrEyEdNLbcsKOKEQ2+QtTxMgDAG0wMqyiWAAcin6+FRnEi6wcHsopAUKOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BILBghsH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2165433e229so47787625ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 13:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734471462; x=1735076262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rw3V5l3zgEdyqeowifhhV2t/72Ab4n6g+8l5OuuzZOM=;
        b=BILBghsHVK5s1gsbkhi8u1FS2+AP5vCtWCg5wg3FDrFbHCoeVfR9BTnSy/J4di64Iz
         YABBGQxPspvWx4jdXUH62oPeCynQxXW6K5fdMV12ZzzBqq+z6pwT8+yPV1ASA5C7C5Nq
         y8wbGT0bf3hRxDBIowG45mknIiIkk0rN05jZH6S5NvjwUjMrte0UMZ7RbsX9yWiemtDo
         Q7vOMZ1YYn2m7dlSOrYHJPf1Yec8sVc5u9RiBVCpe4ECCoCekf/zwrUlKfmOKQ5jpzC7
         yjAFHmUaW7u3yJE11jONM3JNOpgCPTRkcbQVFBUcaWoLg1BxmrJj+DVwmVRYoQbNsAu3
         r3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734471462; x=1735076262;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rw3V5l3zgEdyqeowifhhV2t/72Ab4n6g+8l5OuuzZOM=;
        b=nm9nE63+EVmOA5F10Fzjdru9/p58/B5snt8hvxXmsgKJB2nN+6oFW/cjZ6EjX26jSz
         DiMYvb0/6J1jPu1q5KPWF72gyC3P02ROUM5GhX2qhhslCeRbWaBz+4MeHSZ0W+OhxyS7
         id22rt9B+9i/klWqZjBOr13oHQJZwHcGEEyD7ldc8o6nLi5YLuNBFMpcCo0n4lSiQ+7L
         J02TaQhGoc+UiZsCFv2MlChQYUr4yZPRS/zqS6M7RoD6xIDtasi8bhtGe+dE8La2BaTL
         VCNsIRtd3W+XEdHYP49knhNFYsgRgl46RMMOsp1FqjCZ9XeLJkXez5jJhd7U/LMgARyZ
         wAaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgdez7mPhG9FnRLzcxwtwgl3eu/EtZO9oi0kgv0s3S+TcvvHvre8i9RdW3J2dtXvVxy3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvOo5amOVA99AVWJ77D+pTefe+S6pfd7jPVuNdqQDJ58e3hV/n
	4Q4qrZsDqcDIoqMh45ZhBpOax5nPb4b6r5XFld0cWzfGEKELfvRWokR7LXoZ45bagKLFMzoObst
	VYw==
X-Google-Smtp-Source: AGHT+IHkBuqTQ7UlVlQLJaGwJ+fr7nw0ge3h4GeiLflYNngZHZg+PnIluUNLdsY9fVUJdSpCtTapg9gTOXQ=
X-Received: from pjbpd5.prod.google.com ([2002:a17:90b:1dc5:b0:2ef:6d06:31e4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d88c:b0:2ee:b6c5:1def
 with SMTP id 98e67ed59e1d1-2f2e91a9f37mr670257a91.8.1734471462252; Tue, 17
 Dec 2024 13:37:42 -0800 (PST)
Date: Tue, 17 Dec 2024 13:37:40 -0800
In-Reply-To: <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com> <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com>
Message-ID: <Z2HvJESqpc7Gd-dG@google.com>
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024, Ashish Kalra wrote:
>=20
>=20
> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
> > On Mon, Dec 16, 2024 at 3:57=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.=
com> wrote:
> >>
> >> From: Ashish Kalra <ashish.kalra@amd.com>
> >=20
> >> The on-demand SEV initialization support requires a fix in QEMU to
> >> remove check for SEV initialization to be done prior to launching
> >> SEV/SEV-ES VMs.
> >> NOTE: With the above fix for QEMU, older QEMU versions will be broken
> >> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
> >> older QEMU versions require SEV initialization to be done before
> >> launching SEV/SEV-ES VMs.
> >>
> >=20
> > I don't think this is okay. I think you need to introduce a KVM
> > capability to switch over to the new way of initializing SEV VMs and
> > deprecate the old way so it doesn't need to be supported for any new
> > additions to the interface.
> >=20
>=20
> But that means KVM will need to support both mechanisms of doing SEV
> initialization - during KVM module load time and the deferred/lazy
> (on-demand) SEV INIT during VM launch.

What's the QEMU change?  Dionna is right, we can't break userspace, but may=
be
there's an alternative to supporting both models.

