Return-Path: <kvm+bounces-50204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C37AE2600
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7F3F3BF264
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6170242D90;
	Fri, 20 Jun 2025 23:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jh0NsVmU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D71323F43C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 23:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750461505; cv=none; b=R8vnaBRQH2lOJfs5XOQpNgo50x/GbFmSn45ek2EYbMbhvjdCBX4LZVh2BwkJASJr0ipX/Eca0OX6S9ZJykJudj/oLpbIJLMJaY8tmNZtYWB4WY3t8eg9DrdkQerMo9TgCgllREtV7uEUCVdB8VWRvBs1BvxgbMasSlxqz02dML0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750461505; c=relaxed/simple;
	bh=cJ5hZsPH7NDmBvT6ASMgxpAnAccRQKVdWnl0tO0A/YQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YW3YyykeYBbnJ1Lhtix3h4WRCjUVOWc9dZv9PEbL72Ix1BumU4xj2dT7OGav8mGunGLnVmP9IZxc5EdSOEUoy41XYdCHNCjb1AaNpMqi2P4sP1xvHn32vnBwNfFg01wRcE0vpSi1T2IEl0/FxCGOxOTgPlcnoJFryw5Ih6wFCYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jh0NsVmU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d670ad35so2056065a91.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750461503; x=1751066303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bSZq6ddE7mNucAzAya10S33mWQ/Wp8htlhyW4f0AToQ=;
        b=jh0NsVmUCKPkJN/5NcLIgPyrdcHrdOZjBQ1dbZ8lIqXIgCuwY1UOmLhkkr6Duk68gz
         tGBvRziXWNTXYIWjlgj/cuciQ1ykw+18J13j2itp8ohS9kW7jIZJw7ZgCfAJkj+POgsz
         YfFvVRk+S0PYSMaXlE3hBvE5w5gQgr+yduyktiZcWEmwBVP8yNlqie5+G2EoEUufHZD7
         zp4dcyShxqLZmhqSfzl2RnpsCfXpbHvuqJUJIG3l+Vr4zwCI4HbC0YvlSDUTfWc0FLbt
         FyvScPerRgx3lP6IFWiIkkR14Ow2GelvzAbIPLQDCcmxwB54on5YaRfel4a8OwCYgf7q
         uy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750461503; x=1751066303;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bSZq6ddE7mNucAzAya10S33mWQ/Wp8htlhyW4f0AToQ=;
        b=EtOceLScvKDCRxhe9/UK9VQ2O0KFcaClrW4Kq3CVX7kO5x+BCN7iYkU3ndEMsrZ8c8
         bcaFwjeCLBw5d571e5XUpoQrWgZAvi3TjlexY49AIvQRu8G/lKQRA7ZA1GwyFkH25XJs
         m1GlFGJ8ulDkRo+eu4W7Vkr916JThq8RxBJXbvysWpdf8o2W/X5m0CPXUh7djRIZf3aW
         uqBqWmMU/YCHl9TErdsnc1/x3K/FHhsYPCObAlVOnuvP5ypBJAYBvUkWL5Ismcuqo1X4
         Z9iJQh3DfZoEojDD1TG/nxNOALeEREP+fDXdoFc7wCqIKa77tglVL0Ol4ndiVopjTvrw
         PXQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu1C+CtApLiWJw9KPgIGckUN4sDANcSnAhGMG0KfwTCERSelu8naHq3BJakKX8ilmAcCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgit+BV8q3DYPp+wlByCqcMUju2mZo/tCgCrqzfSiJZOlZwKt/
	lEseBqG3mkWfR0rQ9qCXK8fjOSGR1cWo0/qnqlYU2W1bkqmJkL4esedHezUJ15dhrFq6ls6xKe3
	D2pCwFQ==
X-Google-Smtp-Source: AGHT+IHKltIi0JMRBvpdhKHOFBvjdjaZcxVKi/npJ75GZzdSdCdBTLTS5ifTyl+QncNm67zNvNizSCphOrA=
X-Received: from pjbsc5.prod.google.com ([2002:a17:90b:5105:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4f:b0:313:1e9d:404b
 with SMTP id 98e67ed59e1d1-3159d62ac81mr7486543a91.2.1750461502772; Fri, 20
 Jun 2025 16:18:22 -0700 (PDT)
Date: Fri, 20 Jun 2025 16:18:21 -0700
In-Reply-To: <7acedeba-9c90-403c-8985-0247981bf2b5@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com> <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
 <3281866f-2593-464d-a77e-5893b5e7014f@intel.com> <36374100-0587-47f1-9319-6333f6dfe4db@zytor.com>
 <39987c98-1f63-4a47-b15e-8c78f632da4e@intel.com> <7acedeba-9c90-403c-8985-0247981bf2b5@zytor.com>
Message-ID: <aFXsPVIKi6wFUB6x@google.com>
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
From: Sean Christopherson <seanjc@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>, Xin Li <xin@zytor.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, 
	Tony Luck <tony.luck@intel.com>, Zhang Rui <rui.zhang@intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org, 
	linux-edac@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025, H. Peter Anvin wrote:
> On 2025-06-19 15:57, Sohil Mehta wrote:
> > On 6/19/2025 3:45 PM, Xin Li wrote:
> > > On 6/19/2025 3:15 PM, Sohil Mehta wrote:
> > > >=20
> > > > I want to say that the event data for IRQ has to be zero until the
> > > > architecture changes =E2=80=94 Similar to the /* Reserved, must be =
0 */ comment
> > > > in asm_fred_entry_from_kvm().
> > > >=20
> > >=20
> > > FRED spec says:
> > >=20
> > > For any other event, the event data are not currently defined and wil=
l
> > > be zero until they are.
> > >=20
> > > So "Event data not defined for IRQ thus 0."
> >=20
> > I am fine with this. Not *defined* removes the ambiguity.
> >=20
>=20
> So I was thinking about this, and wonder: how expensive is it to get the
> event data exit information out of VMX? If it is not very expensive, it
> would arguably be a good thing to future-proof by fetching that informati=
on,
> even if it is currently always zero.

It's trivially easy to do in KVM, and the cost of the VMREAD should be less=
 than
20 cycles.  So quite cheap in the grand scheme.  If VMREAD is more costly t=
han
that, then we have bigger problems :-)

