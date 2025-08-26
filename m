Return-Path: <kvm+bounces-55788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDC6B3730F
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 21:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BF951BA5E4D
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 19:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA5E286D75;
	Tue, 26 Aug 2025 19:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NsHbp3Wr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EC1211C
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 19:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756236653; cv=none; b=GKHBDBdy2qX3bR3ZaIrXfg6UAxEPO9TINGW0823Wk80nIP3DgqkSoGbVDxfGl3tIoiTbHWAucvpIaBfPDtr6Bj0oSk5x1LT+D5w1RsTSrBBMStT6V2nf/hyQl84p5Kjbe/dhq3LZu4k2ZYE2c7Dv/6ObV+w89AERh+w2naFfE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756236653; c=relaxed/simple;
	bh=gdCFdbTmtmMgFzjF7Da0SpcgHMstt2sZb9ZzRqgRRbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FhecmkI4D2bG4C4HN9peiYM/3eZ1QRkiCz0QChIzUv207Fbww7UX3dZtEEyzO4LcuyfsobV2pQ8WiDwzHmYsLF4AZgdiagzb8mnBlG5Kf6uC4tt/QvEpFBHLlfP7urn4u2z90kB3MCr1gXMV1n4nIGcNVNYp5FIqEwDE0eO3jwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NsHbp3Wr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458274406so119257275ad.3
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 12:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756236651; x=1756841451; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1KbdTZMW1s+GECxcY2zADFFjepOtziTvDtiLGvd1fQ=;
        b=NsHbp3Wrr1TG7nI3xB0g4JaufhgMP+I0LH+DDzlRuOOPLIUqPKAhzvWo3Ho9K3RQqr
         +i3EZ2qTGUXDU51Hm8YK3hvb4AVE7hvaiveE3JKksvNb0xMmnMctjDc5ln9GDadr74jK
         jEIB/7o3lPy9BavwAjnxvHBSKgd4VpdaKz9feUcWOOldbEMvs1SjsTMfvWPxFnnbyNT+
         MTY7fyF6ro8qGuW7skvGA1lZwSQcDPc2QqpKnX8yxZYjKx0tTo1kIZucf+Z0Y3tKnndv
         6SWoqisHnGNLDHovDqv8Aq0LakWOKB+vZ94p/HZOazrI3tkuzqv2eIZ4L+WL+sPhReAS
         /pBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236651; x=1756841451;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i1KbdTZMW1s+GECxcY2zADFFjepOtziTvDtiLGvd1fQ=;
        b=o/bfJMi3dqT59VE7f/6YAowZZH76CP7vARxTD4+gyog+utdi2TjIqpQujlMSd7Qixs
         KVarF+MSVxCFBVJbqUHtMfowWNIUn1rAyF34bcydl5x6VIDmUVz1Il4zhL8v9fd475M3
         fIkmgznjNankI2GUvxzl81XYs1GRF34SMiX86lw4dE3hKx47jNKH1+CS8KbRsxMEkyCQ
         MxOdX70FBJJ4ITYkokx2uGxon/gymvfCIWI2DK+0aUgQO4AtfcpXVhMu4SstxLCVWQl9
         aZ4GBq1LU9TaT2e9ynReZPbKm0s+WlkNX81iGZH5KqdhhdG4YtSs2W/GZdy6NzRagVsI
         dakw==
X-Forwarded-Encrypted: i=1; AJvYcCUUFeNmALyarS5LI1Ti+EGd2xk0nF4bHEHb2TNPC1b6MdsKV/vpEBWy7PFiumonXq13VME=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp6tWz0ILR0f5g+C8OMO3oC37luBlh4kxXML71QRnLuJAnnmS1
	qaB+DsAjrAT8HoXemOU0dU0V0TB5zb4RX63NUeMzVGicYx5MWh2rGlVqyzF+b0BT43Y/KhFHJdH
	Cf4vb/g==
X-Google-Smtp-Source: AGHT+IG2CjAVhRLnSDiJEfExwS0xJ/acWWu8/qwWbBjMXgNyF+JkUGLkWae/Nvf1BEW0/PCLmCGfm1/gcH8=
X-Received: from ploh5.prod.google.com ([2002:a17:902:f705:b0:246:1edd:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:943:b0:240:5549:7094
 with SMTP id d9443c01a7336-2462ee53d7dmr209535455ad.18.1756236651462; Tue, 26
 Aug 2025 12:30:51 -0700 (PDT)
Date: Tue, 26 Aug 2025 12:30:50 -0700
In-Reply-To: <01000198cf7ec03e-dfc78632-42ee-480b-8b51-3446fbb555d1-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816101308.2594298-1-dwmw2@infradead.org> <aKdIvHOKCQ14JlbM@google.com>
 <933dc95ead067cf1b362f7b8c3ce9a72e31658d2.camel@infradead.org>
 <aKdzH2b8ShTVeWhx@google.com> <6783241f1bfadad8429f66c82a2f8810a74285a0.camel@infradead.org>
 <aKeGBkv6ZjwM6V9T@google.com> <fdcc635f13ddf5c6c2ce3d5376965c81ce4c1b70.camel@infradead.org>
 <01000198cf7ec03e-dfc78632-42ee-480b-8b51-3446fbb555d1-000000@email.amazonses.com>
Message-ID: <aK4LamiDBhKb-Nm_@google.com>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: Sean Christopherson <seanjc@google.com>
To: Colin Percival <cperciva@tarsnap.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, graf@amazon.de, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2025, Colin Percival wrote:
> On 8/21/25 14:10, David Woodhouse wrote:
> > On Thu, 2025-08-21 at 13:48 -0700, Sean Christopherson wrote:
> > > > I think I'm a lot happier with the explicit CPUID leaf exposed by t=
he
> > > > hypervisor.
> > >=20
> > > Why?=C2=A0 If the hypervisor is ultimately the one defining the state=
, why does it
> > > matter which CPUID leaf its in?
> > [...]
> >=20
> > If you tell me that 0x15 is *never* wrong when seen by a KVM guest, and
> > that it's OK to extend the hardware CPUID support up to 0x15 even on
> > older CPUs and there'll never be any adverse consequences from weird
> > assumptions in guest operating systems if we do the latter... well, for
> > a start, I won't believe you. And even if I do, I won't think it's
> > worth the risk. Just use a hypervisor leaf :)

But for CoCo VMs (TDX in particular), using a hypervisor leaf is objectivel=
y worse,
because the hypervisor leaf is emulated by the untrusted world, whereas CPU=
ID.0x15
is emulated by the trusted world (TDX-Module).

If the issue is one of trust, what if we carve out a KVM_FEATURE_xxx bit th=
at
userspace can set to pinky swear it isn't broken?

> FreeBSD developer here.  I'm with David on this, we'll consult the 0x15/0=
x16
> CPUID leaves if we don't have anything better, but I'm not going to trust
> those nearly as much as the 0x40000010 leaf.
>=20
> Also, the 0x40000010 leaf provides the lapic frequency, which AFAIK is no=
t
> exposed in any other way.

On Intel CPUs, CPUID.0x15 defines the APIC timer frequency:

  The APIC timer frequency will be the processor=E2=80=99s bus clock or cor=
e crystal clock
  frequency (when TSC/core crystal clock ratio is enumerated in CPUID leaf =
0x15)
  divided by the value specified in the divide configuration register.

Thanks to TDX (again), that is also now KVM's ABI.

