Return-Path: <kvm+bounces-12152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69FA3880076
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:23:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 918B71C21E8D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CA0657B6;
	Tue, 19 Mar 2024 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nVOQqzWa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE628651AD
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710861814; cv=none; b=fAUGU5/d5Ib+/MgLdRa9RLWnv/TaRK5SsJxdLoTvqpFa0Vlnjtd1FywrcbCztnLJbyuRYnJZnPw7cs8ptm5K8g9C20EXdRbk9VdZCQTaf+POsSF9INjMBpoJ6p2/n6qjOfUVTDyfxAlWBea9Rn93YEp8W6c2rPKq6fLGfm3b/78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710861814; c=relaxed/simple;
	bh=fvMLAskbQvRvJxiELmO0vp9cYMo1W34F96QOg/1mTn8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jzbgvFtxROzpUV27LS7qBevCLXfcTF30adxc2gL90KZ1YciOnfDkjyBxUMChjkSk6bVqz2XM5KtBdTTQWlD/TIT9FSXbZYjORF/VW6iOFGD6DiLuzEklPaJeUN81rmbGyaDLBb5qmRRn20rnJRjX1pd7SYhO1XuQCeIOe/80fW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nVOQqzWa; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6b15967daso5746824b3a.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710861812; x=1711466612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3wqp23e+wwkLFeuG+pD7/YLX8aUj3W8gcgvpzMpJIA=;
        b=nVOQqzWaX3vAqXf4rnc4cVieRgaOkyeRDp6Y+RlufRaVzyIjqDbRDINEYYUlmOCmEe
         gqShrBLLg6t8ZdkJTtDDIp0Vi+BEVaiEngcj3GtyGQE+rMB99G8/xJT4OVaEXcT9vcV1
         CrqaRGUmc7AEZLF5cbvIgZ4cV5Z+pb5jNutqcQL2N+n9Gzdgedb2O0S/KaNMVQ36okTH
         VsZkfJs69XaKzGnJGR+YBqTsVSPx1WJ6hGwKAI/4PZomuZcJ93k7ryy8rwcHJknyvrfC
         3SC019P0lK7TFr0dn6/NXsbTKLjXFSXntv2RqVbw+Er2lwa6wuxIMl1cm67HO0ufLSFf
         GA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710861812; x=1711466612;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m3wqp23e+wwkLFeuG+pD7/YLX8aUj3W8gcgvpzMpJIA=;
        b=Sgb5u9WPf/eDDD1obnmPEF9Q/jyLim39HL8yezNW9lMLL9qAfzw/74QAswTOoq6OMw
         gtjqhj6vELzwOK+I9V86DJ81Z5lfpiwsMgABsM81tiDutQuOIoEDLNwfyLRRJ8gQ9OZW
         KtWmr/qL3JigAOog6/0SB7n3ieRsDBeKY3ozbypGoz4p11UIgygxaqmKUh7vJQ9Gmv8d
         3HZoSO6TfuJ/+uMfyyt18fO5GTZRvLZojYydYVv8YwAnQN3it7GjPkfEPSLfNzCD86b2
         4sSbsZ1Ig5Un9UOqc+wSEOM38Zmf/cgrFHv2xjksNU3qvvlRN8w2nZ8wpPSOs6C47Nke
         cUmg==
X-Forwarded-Encrypted: i=1; AJvYcCVgOCsHFZW4t5m3jGZKwN84Utn3VkEb/l0tTkLmZXnbQhBjEy6sCFrXV4TGIsaiBKGT27OMjucNJ7hRpglodneen8Bb
X-Gm-Message-State: AOJu0YydwKxuNTn4iPRV7VeD5VuF8/JJbl+wqsjLWZO4PbHrGFgHl3Em
	bXKlbEOCKktvubicHWbJbJvwtnIjGT5w+CiI9vxdtSMlH19eMyoM1VVPYP5X3PjXr/Y5OY65IU5
	Fgg==
X-Google-Smtp-Source: AGHT+IFhVAacehQIbFlkqUpsol9aRBbBhHsbv/C+HD5gV+HlsxvKUAzKRzn1stE6Bda0vRdAnqXCgU+OJwI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:93a2:b0:6e7:4921:6acd with SMTP id
 ka34-20020a056a0093a200b006e749216acdmr5230pfb.1.1710861812130; Tue, 19 Mar
 2024 08:23:32 -0700 (PDT)
Date: Tue, 19 Mar 2024 08:23:30 -0700
In-Reply-To: <33bcc5778e39780c6895ffa9f52f4b12cf83ad89.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000005fa5cc0613f1cebd@google.com> <b7561e6d6d357fcd8ec1a1257aaf2f97d971061c.camel@infradead.org>
 <ZfizYzC9-9Qo47tE@google.com> <33bcc5778e39780c6895ffa9f52f4b12cf83ad89.camel@infradead.org>
Message-ID: <Zfmt8rxlF1ag1iA_@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in __kvm_gpc_refresh
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: syzbot <syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, paul <paul@xen.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024, David Woodhouse wrote:
> On Mon, 2024-03-18 at 14:34 -0700, Sean Christopherson wrote:
> > On Mon, Mar 18, 2024, David Woodhouse wrote:
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Either gpa or uhva must=
 be valid, but not both */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(kvm_is_er=
ror_gpa(gpa) =3D=3D kvm_is_error_hva(uhva)))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> > >=20
> > > Hm, that comment doesn't match the code. It says "not both", but the
> > > code also catches the "neither" case. I think the gpa is in %rbx and
> > > uhva is in %r12, so this is indeed the 'neither' case.
> > >=20
> > > Is it expected that we can end up with a cache marked active, but wit=
h
> > > the address not valid? Maybe through a race condition with deactive? =
or
> > > more likely than that?
> >=20
> > It's the darn PV system time MSR, which allows the guest to triggering =
activation
> > with any GPA value.=C2=A0 That results in the cache being marked active=
 without KVM
> > ever setting the GPA (or any other fields).=C2=A0 The fix I'm testing i=
s to move the
> > offset+len check up into activate() and refresh().
>=20
> Not sure I even want a gpc of length 1 to work at INVALID_GPA; I don't
> think it's the offset+length check we want to be looking at?
>=20
> If we've activated the gpc with gpa=3D=3DINVALID_GPA, surely the right

This particular issue isn't due to activating with gpa=3D=3DINVALID_GPA, it=
's due to
marking the gpc as active without actually activating it.  The offset+lengt=
h
check is simply what causes KVM to prematurely bail from activation.

> thing to do is just let it fail (perhaps with an explicit check or just
> letting the memslot lookup fail). After fixing that WARN_ON be
>=20
>    if (WARN_ON_ONCE(!kvm_is_error_gpa(gpa) && !kvm_is_error_hva(uhva)))

I really don't want to relax the sanity check, as I feel strongly that KVM =
needs
an invariant that an active cache is either GPA-based or HVA-based, i.e. th=
at at
least one of GPA or HVA is "valid".  In quotes because the GPA doesn't need=
 to
be fully validated, just something that doesn't trip kvm_is_error_gpa().

