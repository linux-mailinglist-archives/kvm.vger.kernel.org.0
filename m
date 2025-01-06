Return-Path: <kvm+bounces-34622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B2AA02FC2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DC427A1C50
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 18:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3001DEFE8;
	Mon,  6 Jan 2025 18:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rtYFuW8N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E756CFBF6
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 18:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736188169; cv=none; b=eV4rlMb8ljn3dPj3BbOkssxbco+oItpFNlCARD2zXquhMBdxBVRhDMNMqNsNXSnpY/Qt/pHslZdSl3APNjWcl3U1mlN7KzNs539L0WGnxRTIAANwDN4QoG6+UVzayLdXaC+/C8fH0h3cV8IGHzTbm6lkdskW9TWWjBRZ1Q1GYvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736188169; c=relaxed/simple;
	bh=aC5pxjlHoVfpis0kfg0Ph6v/kLOiex21gcAR0w4n5V4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N77QQ9xYw9sZ4loCmcZvHaHq4FQ7eQuSPAZP6/4eHOHQYwDdOUXzJIriIrT4bmsRRcsPOJBCC0LNZYpIzihP/thlRmmiCEZGZ9defc0MqWUh10n3CwCtYAygiyScUkG2KwNHJOKwj9876GEvqyoGZWoWwKQtprE05bBA22wByQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rtYFuW8N; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso20404387a91.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 10:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736188167; x=1736792967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iqJahD05CoKM1P+9hzduA76fyhopabrf40U3rdXLaF4=;
        b=rtYFuW8NULBGVh/EDl/YVKbDzNUEhwuprZDejX5T4iWyDh9/DHtD1p7f7rGXmJzxpw
         AGGThn3ZuzDtu58rxpnPjYTn4xb2V44LT3JI1XsgzJ+eaFYPQK8ZyMfEM0QcKY4VMG2T
         KhDPPt9LZQDb+wM9TWUgy08Jx0yi5ACGlqKoK6LbBOpTKeh4fZvO2c3M6VZnnQy6IbLZ
         yWGYmJp5LmUAkkm2aOjmp8B+/bdev096/+CMAJtKrhA22xbV0P8gcoDKiYxRlF85UAJj
         OJ3QxenVXs3ptdaT4kFcAcSRKYa2yCAK9UOUmC2aM1keo6hTyaWYomkli+X7fRiAYNHC
         JKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736188167; x=1736792967;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iqJahD05CoKM1P+9hzduA76fyhopabrf40U3rdXLaF4=;
        b=sMxj/2Sq9fhXhZ2GUbgv2Zb17HIr+kbHA56yfVf5JzSQ2zrqons1uhHjIsoh/Cl+7+
         MH4E/3qzaUobk7WkuUMbFvCXdj83eHu0Ny8b5oZdd1QgEyNJLP99MHFvkyKkc8MfpmI1
         oS8HKazErFtjLdtrOovTH3Wc+a8JoTq7o5ho0wx1wme09wHVQUiCXsq7hNhUQKr66PAE
         wRJ6jFvuogc9xPcy1IS/jTJEcYdxEhxnzS8qmTKqwHeqLRDiSDo8eH4wmuXqgyAP3IYF
         nvO1Q28uN5NqkB5ITTxESnK4Gax9vFx6uNdA/61LGej48a4OEUIAzmybsFz6JH81xC8f
         pnug==
X-Forwarded-Encrypted: i=1; AJvYcCVKrSVtZjer8w00oMAUzDxWyySZPg0zVW4OCYCKmW1L5l3JHRs0V47fc1emnBC1EvoZPik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaVOjfFsoFW9ZEPEv/Wit8R/6blxA0fo3lMcRl7b+f9skX8GAm
	FphN7Ph1UPA8OxfJaUX6XhABrOuJX8Ffl2c/EXTqEmQgIPeqV48BJfrs0ZTFbp08A6gvFCTjpn3
	0hQ==
X-Google-Smtp-Source: AGHT+IG36Tj1MEd1do7PTJpeYtiE0FYql983/qkYoONMBWTQeV01lDzjCo5AiSoGdXiaTtk8/FahyMrvRfg=
X-Received: from pjbsd5.prod.google.com ([2002:a17:90b:5145:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cc6:b0:2ee:aa95:6de9
 with SMTP id 98e67ed59e1d1-2f452eed7e1mr90148916a91.33.1736188167401; Mon, 06
 Jan 2025 10:29:27 -0800 (PST)
Date: Mon, 6 Jan 2025 10:29:25 -0800
In-Reply-To: <CAG48ez3aLwOW+jpJbLB-vXGudLQnDLCYs=Ao3eNikv6QiTc1Fw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241230175550.4046587-1-riel@surriel.com> <20241230175550.4046587-12-riel@surriel.com>
 <CAG48ez1nW7a+cHa4FDrri4SEZOWby9HbW+81JW7sY=CLZt98Tw@mail.gmail.com>
 <287e8a60e302929588eaf095584838fa745d69ac.camel@surriel.com> <CAG48ez3aLwOW+jpJbLB-vXGudLQnDLCYs=Ao3eNikv6QiTc1Fw@mail.gmail.com>
Message-ID: <Z3whBeRiq7M-86M6@google.com>
Subject: Re: [PATCH 11/12] x86/mm: enable AMD translation cache extensions
From: Sean Christopherson <seanjc@google.com>
To: Jann Horn <jannh@google.com>
Cc: Rik van Riel <riel@surriel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	KVM list <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	akpm@linux-foundation.org, nadav.amit@gmail.com, zhengqi.arch@bytedance.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2025, Jann Horn wrote:
> +KVM/SVM folks in case they know more about how enabling CPU features
> interacts with virtualization; original patch is at
> https://lore.kernel.org/all/20241230175550.4046587-12-riel@surriel.com/
>=20
> On Sat, Jan 4, 2025 at 4:08=E2=80=AFAM Rik van Riel <riel@surriel.com> wr=
ote:
> > On Fri, 2025-01-03 at 18:49 +0100, Jann Horn wrote:
> > > On Mon, Dec 30, 2024 at 6:53=E2=80=AFPM Rik van Riel <riel@surriel.co=
m>
> > > > only those upper-level entries that lead to the target PTE in
> > > > the page table hierarchy, leaving unrelated upper-level entries
> > > > intact.
> > >
> > > How does this patch interact with KVM SVM guests?
> > > In particular, will this patch cause TLB flushes performed by guest
> > > kernels to behave differently?

No.  EFER is context switched by hardware on VMRUN and #VMEXIT, i.e. the gu=
est
runs with its own EFER, and thus will get the targeted flushes if and only =
if
the hypervisor virtualizes EFER.TCE *and* the guest explicitly enables EFER=
.TCE.

> > That is a good question.
> >
> > A Linux guest should be fine, since Linux already flushes the parts of =
the
> > TLB where page tables are being freed.
> >
> > I don't know whether this could potentially break some non-Linux guests=
,
> > though.

