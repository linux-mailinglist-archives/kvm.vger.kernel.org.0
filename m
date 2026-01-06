Return-Path: <kvm+bounces-67088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB6ACF6420
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 02:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 176C130D184F
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 01:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F4F328B75;
	Tue,  6 Jan 2026 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="srukJ5bz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAD328B55
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 01:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767662247; cv=none; b=l0gsnc9Nxzn2fFCLOmQ8va+GefGSOD8hxV9WH8nLYaNzbKi5UHxmPgF2uxnoAzMW6MuwddzrEz23qcgvMKoq0aZm5stBhvZS/i2OrbfS+kwvtGQhqNuaih8Hv/9GmLYZX5kFIxWMOMQ3mtVQbAlb7yN7eSLSrFWjYTeu4OsGUJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767662247; c=relaxed/simple;
	bh=Vkn6d+IzHDTnJtRWg0esRaoSELl3xH6rHxdNRh7E4kQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QO1rPSZRl8LygSYaLS86ybBRh4vF7vYjBq+xO4lPXe3P+erXNAp8en3GD8OCwpcDTw/bVLVjDPExwTGianH+JejxaT1cjp4n5OO7AQlLrg3Tgl/n/hWZvhG2GVN3cZUlTrLpjy3l79VBTlU0z5zzpC1J6tq6I/+85e3mWWGQXdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=srukJ5bz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7c240728e2aso1427141b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 17:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767662245; x=1768267045; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHeIv2XQKWavHCM7YPXAh7Bmr80lyuwrW8phEkPDzPc=;
        b=srukJ5bzvW9Ojh7G3bI0aqEPyws40pOFcZzoyMjcW59bJogNbwN+OOginc2psgwcfl
         0FG/mhPx9UrlvRgQjhDZ24j1frLhm1ovJoxemadn0k3Q/X56x+lFUk3h3hvCv4FS71Y3
         Zgt6RIy6jThs1B+OJoZJ1tecn8QitiJaESLUKzhIcXSKcgMdMUzRInnv3lojXw2dKY5b
         yp8LTAVi9vGc0WNLQ99LUxu0ht+UMBSNqjdtDcJU0AxombQW1bvBEbdbeOU6wEbLnTKd
         tOg2fmO0OsNbXwHnm0FiOunSctCvDvCQzpJwQOcbk08BLv+a5gZlYbcgTKClgsDSWEE3
         otqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767662245; x=1768267045;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LHeIv2XQKWavHCM7YPXAh7Bmr80lyuwrW8phEkPDzPc=;
        b=jdmQ97Q93JVs35kK0Y11H3Nk6xUyvCR+TatqjhBn8tJ6zfd9Gfn6V6xt//LBOcp9P5
         tUIln7jaec0fRqdlhF/qj1JWJ5LJAVPwRxjONvq74sQg2RxlmbWCW7MuQaOYNsfZIBaV
         8pTOSpas/zlHhAVVzKT6UMLXLBTEgpGmppITVm8AXrzMIg+/LpHk0vXAoLaM8GI/4RFb
         H2R9k87r6OAP1aEDSNTqIop5jY9jiItiA/3dDfqXBTq7pLD/y9A3KXE83ZMw+9eX1k9r
         B3LMMU6Q6cuQIo3oL5lztfgkFpvr/YwyWZly8yUfRciLXS8Eqm93/+78I8s2mx9cjeEx
         /88Q==
X-Forwarded-Encrypted: i=1; AJvYcCWK70pm/0452TztpBytlymuTRZZGYuuNZjlhge3e0OjiwO/xNN8tQDXk4qxVxmaM2eFgp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLUWhUddk+/BmQ+2UsySs7FHP0kbHBDPqmUmTGsQfpmvxkGXCG
	T97mv2CBLzv9yO89o1BhlrXDi6vngzkYndzVfzoAU+iGgfEIBgYFwBTgCCFKyBrW++Kt+WJmc4L
	tH2DMLw==
X-Google-Smtp-Source: AGHT+IH/IIcpsomoZZuFOHAD7u0wqzN+TzokWJVvCMAPsUDjfqeJDbBC1q7HMCbobbBwmcXf/oHu2fSRIbE=
X-Received: from pffy8.prod.google.com ([2002:aa7:93c8:0:b0:802:f63a:105d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:428a:b0:7e8:4398:b36e
 with SMTP id d2e1a72fcca58-8188008db4dmr961948b3a.65.1767662245227; Mon, 05
 Jan 2026 17:17:25 -0800 (PST)
Date: Mon, 5 Jan 2026 17:17:23 -0800
In-Reply-To: <CALMp9eSWwjZ83VQXRSD3ciwHmtaK5_i-941KdiAv9V9eU20B8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-2-pbonzini@redhat.com>
 <CALMp9eSWwjZ83VQXRSD3ciwHmtaK5_i-941KdiAv9V9eU20B8g@mail.gmail.com>
Message-ID: <aVxiowGbWNgY2cWD@google.com>
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2026, Jim Mattson wrote:
> On Thu, Jan 1, 2026 at 1:13=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> >
> > From: Sean Christopherson <seanjc@google.com>
> > ...
> > +       /*
> > +        * KVM's guest ABI is that setting XFD[i]=3D1 *can* immediately=
 revert
> > +        * the save state to initialized.
>=20
> This comment suggests that an entry should be added to
> Documentation/virt/kvm/x86/errata.rst.

Hmm, I don't think it's necessary, the SDM (in a style more suited for the =
APM,
*sigh*), "recommends" that software not rely on state being maintained when=
 disabled
via XFD.

  Before doing so, system software should first initialize AMX state (e.g.,=
 by
  executing TILERELEASE); maintaining AMX state in a non-initialized state =
may
  have negative power and performance implications and will prevent the exe=
cution
  of In-Field Scan tests. In addition, software should not rely on the stat=
e of
  the tile data after setting IA32_XFD[17] or IA32_XFD[18]; software should=
 always
  reload or reinitialize the tile data after clearing IA32_XFD[17] and IA32=
_XFD[18].

  System software should not use XFD to implement a =E2=80=9Clazy restore=
=E2=80=9D approach to
  management of the TILEDATA state component. This approach will not operat=
e correctly
  for a variety of reasons. One is that the LDTILECFG and TILERELEASE instr=
uctions
  initialize TILEDATA and do not cause an #NM exception. Another is that an=
 execution
  of XSAVE, XSAVEC, XSAVEOPT, or XSAVES by a user thread will save TILEDATA=
 as
  initialized instead of the data expected by the user thread.

I suppose that doesn't _quite_ say that the CPU is allowed to clobber state=
, but
it's darn close.

I'm definitely not opposed to officially documenting KVM's virtual CPU impl=
ementation,
but IMO calling it an erratum is a bit unfair.

