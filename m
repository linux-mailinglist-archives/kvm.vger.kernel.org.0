Return-Path: <kvm+bounces-55340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C08B302E2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F4657AB7C4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 19:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC8534AB15;
	Thu, 21 Aug 2025 19:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dmwy8ech"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016661F948
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 19:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755804451; cv=none; b=o8azHdus+/6Ek0iQuhoSaFieL3CGCZyGFG/HnvrYzMBXqFyqwuJIhjqgCvQxtXONEzgu0+n4wFOc/bQQF1Oz4CYbdYlgiaJJ9lgO1KYxSFOZXtrsHrT53vX3JemEsJOEXpogWgDxmeqa4Tg5T4Ijni+RZEMRqixh65iZ08gfevE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755804451; c=relaxed/simple;
	bh=lOUKtSAZ4iupwypocHdXzytWd18DxAtEEIyeYib0aBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBDpNmD2pllQ5enoMMMfLfZdPVGLlfSLabIzGUyxgB4ZK9q4V4EjBH7pVVNYFgo81EqauXJHe1e3eDmdGuM6r9mDNbxGbyQobeaHZvFptWGAdJg7u7Dhhisc8vs4XdUl0HKB5nWnvTKLqx9zib4HeTeAkKr55XoNbmPlKgdFIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dmwy8ech; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323267915ebso2802248a91.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 12:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755804449; x=1756409249; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1WG539BFfyXprn2bVLibkaFh6lh376RBX3TpUomP+A=;
        b=Dmwy8echBkqWaNXCkW5352ACjVLCZ2amwEnldzZnZQO5GK6gKuQGbCXmMIB89nXq8t
         UFWzbesaJhro8P2vnYND8ZpUieg3zJ5s3OcuYj0jWL6zzpn6NVUd03SJWvq3q+EkU6T1
         hdMAspsQUc/NCaGw6ndwPvtZaTkINtsaQJTXwms8LGl+j/bemB3Hh5FCNQmnhj1etoae
         vzXkfOgQhwKhyhLa2BNAmMzen7kdiy1R8vSET1GB9bZ8AzHcyorRB3WKn7fv6dPD6hKG
         aPvThv0LI9VYCzOmkOdPFDb8GPxewfKg5e+OjOhqw+CcnPm/foLxCv4+eAQVtPnvhXoc
         bGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755804449; x=1756409249;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F1WG539BFfyXprn2bVLibkaFh6lh376RBX3TpUomP+A=;
        b=cUFey5lmyhUe9hUrKECoZ2axxyJaHl+KMKJxPNBq20prPXhuLHhpr9qO1VqvXLXVHb
         YG/X9M3MGOrtrQPBp50SaKtFpiG//W//HDoKW5tCEilhMStS76WJU4awEGwKxElCvbOZ
         IpoV4J7kS/2peABXNzjj/HiCNy+U29Tfup0iadPDESlF7TQcRO2nRnV2QcdRq0xAP9/G
         8m+mweQRbAEbZ3uqtdPxV+Y4r5+Y7KjepH0aURGkLQqEvBXeixmFhoSywZ7j5KVYM3/E
         3qJ9bBz4hFRrsIr5RDp3ozL31nmlBngTmcq4zXQU1YG0ptrQJvLZoyh94dNAFVO4+0Q2
         ePnA==
X-Forwarded-Encrypted: i=1; AJvYcCXc8jO8JZ1mx3m0XwFQKsaBOWVLDzAyzHjgXd+sevUy4EOg5KO/Zonm2HgvvMTBhy5ojSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLYMBNSLGEqyoAzOSD3slFRkCqiaKOegwcdgEsCzIRQ1gLq1Dq
	PQNJWIbuQt7NiSDaN3Uhwl4H1R9uZ6JL66GM+tYqis6gcBr5yYmCn3S0Tu7plu9EKsXSVhTXo0M
	F9nH8fg==
X-Google-Smtp-Source: AGHT+IFjjOVdCzUMSrPQOTtvzRTU30p+KCG2TZ40l1JyMAUGmGOpdOZaL41+Jz4ysVNohi6+GLl248r7Afk=
X-Received: from pjae15.prod.google.com ([2002:a17:90a:118f:b0:324:eb0d:70e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c3:b0:311:e8cc:4253
 with SMTP id 98e67ed59e1d1-32515e221c4mr804326a91.2.1755804449299; Thu, 21
 Aug 2025 12:27:29 -0700 (PDT)
Date: Thu, 21 Aug 2025 12:27:27 -0700
In-Reply-To: <933dc95ead067cf1b362f7b8c3ce9a72e31658d2.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816101308.2594298-1-dwmw2@infradead.org> <aKdIvHOKCQ14JlbM@google.com>
 <933dc95ead067cf1b362f7b8c3ce9a72e31658d2.camel@infradead.org>
Message-ID: <aKdzH2b8ShTVeWhx@google.com>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, graf@amazon.de, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Colin Percival <cperciva@tarsnap.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025, David Woodhouse wrote:
> On Thu, 2025-08-21 at 09:26 -0700, Sean Christopherson wrote:
> > On Sat, Aug 16, 2025, David Woodhouse wrote:
> > > In https://lkml.org/lkml/2008/10/1/246=C2=A0VMware proposed a generic=
 standard
> > > for harmonising CPUID between hypervisors. It was mostly shot down in
> > > flames, but the generic timing leaf at 0x4000_0010 didn't quite die.
> > >=20
> > > Mostly the hypervisor leaves at 0x4000_0xxx are very hypervisor-speci=
fic,
> > > but XNU and FreeBSD as guests will look for 0x4000_0010 unconditional=
ly,
> > > under any hypervisor. The EC2 Nitro hypervisor has also exposed TSC
> > > frequency information in this leaf, since 2020.
> > >=20
> > > As things stand, KVM guests have to reverse-calculate the TSC frequen=
cy
> > > from the mul/shift information given to them in the KVM clock to conv=
ert
> > > ticks into nanoseconds, with a corresponding loss of precision.
> >=20
> > I would rather have the VMM use the Intel-define CPUID.0x15 to enumerat=
e the
> > TSC frequency.=C2=A0
>=20
> The problem with that is that it's been quite unreliable. The kernel
> doesn't trust it even on chips as recent (hah) as Skylake. I'd be
> happier to trust what the hypervisor explicitly gives us. But yes, it
> should be *one* of the sources of information before we reverse-
> calculate it from the pvclock.=20

Sorry, by "the VMM use" I mean have the host, e.g. QEMU, explicitly define =
TSC
frequency in CPUID.0x15 and CPU frequency in CPUID.0x16.  And then on the
KVM-as-a-guest side of things, trust those leaves when they're available.

So same idea as having the VMM fill 0x4000_0010, but piggyback the Intel-de=
fined
leaves instead of the VMware-defined leaf.  One of the reasons I'd like to =
go
that route is to avoid having to choose one or the other when running under=
 TDX,
where CPUID.{0x15,0x16} are provided by the "trusted" TDX-Module, but any P=
V
leaf is not.

Dunno how feasible it is to get non-Linux guests on board though...

