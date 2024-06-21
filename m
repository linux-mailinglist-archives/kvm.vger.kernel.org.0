Return-Path: <kvm+bounces-20192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF84911716
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0D231C20E85
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 00:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED704C94;
	Fri, 21 Jun 2024 00:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nhkz3gpn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF0F10E6
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 00:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718928053; cv=none; b=sCCd+qRurHWDNvJ35mngB8fiQoB0O3mi53dZZKAVvha+5S9fQ6S2U8ydZXg2cV7qXOSJ1SJIkoVEEp9c/szsVZJmTq65/q5LI3RPAuBOwCctlB69PSVRJy0bblVQoNC8M+iRbo9OczIGE5DFaWCw/20lUnk+DjfK0ZzAVv2Djds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718928053; c=relaxed/simple;
	bh=mYJv4v7AARll0n7wtHjIBf2UaNEm1t4MgiiJxFJXUPw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WJC1W6HWnaoqek3AFnNIQ/Ul4QMSthlYGPNk03bZuBOL2ISzKr5KKJm5KbtIyVTBByAM/iiaEHXarAw1muFbFyQicOM26taN+C6Jhyso9xcaR8A+HBDeUSxDryg4+41COYUh1FgCW5J9FpF5OlkW7CGtCNOCtaLgvOYf0aq6ML0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nhkz3gpn; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f9bc7d4922so14447285ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 17:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718928052; x=1719532852; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dtz2C98q13AonhzTgySDvQSopYPyYg34Yval8t860Dg=;
        b=nhkz3gpnVnD0J1mNKWhq5d5q52GrmuFZFU6kf8gBp+bbE8Xx9cfAM220utIsvf4mZT
         aOH0bdB3KWzRKVI+L0+TA+co65El4m55EuMNmWhdcoCuv/iN/ODMRMV6Dz/K2D76YjBQ
         bMUVR5g92QWAf+vNrl6BeXT3N1NquhIM2nBbD9hatdrum+b77SjSw1aNvsiUnKRa4qR8
         FXnOFfhxnV/IiO7nd4fWkIGhKNSDOP2po2/4EZWOo8iGdP+38KL0vF/d8nrSigcmEJzE
         f+8TBg6idic0kbCInI/s9R7Fw9kxyvbM4matz+sQbObSs4wKqIb1ELScYTo98N287Wig
         ivag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718928052; x=1719532852;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Dtz2C98q13AonhzTgySDvQSopYPyYg34Yval8t860Dg=;
        b=C5K3/ukMtNO8fxHJdlE6oiWVV6nl2duE9maGrUy9bEkAxryu9LyZxGnW4hXZYmejIO
         hyfoomQ2s9SlfCsTH3FsdRegbKqE9GTRwYP42DZk0hCnQyAk2kkKhz588eJl+MB9PPra
         7dyMWsR4ZSbnA7j0mOcbzoDyZmpCYXRBpwUT1it7/J7r3B55WtmABA1WV8bQKGkenj7O
         YH2yttj3V+YFYZbhH8b4FesmIJLcsxAGU7ZC9bQepsVBLx3Sd25xX9zDuycIj4lMhhXH
         CYVGocTdxpmdTWvBe7+q39s2wa/Av0tihjA6ur+ZTgLPO41FRJffNAxDpB723n/FR93j
         E6Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXaFZI9Dw3TAFk+aY61Vx/psgyPoZb48+yZkFp29iqIQ3iSmbXJT56cqGRZWRREYHBppYofBw3IQYaVFJr2WvoC2L6I
X-Gm-Message-State: AOJu0YwjQ9iAgUXv64TtXT2AR6M/PhgdkVnGFFmRJ3wvouE9yAzpVCyX
	qBIa3joTZG6Kzzkq3flG04xOk6dw7n/YlPpmI6FA7K4PCe424jQf6sB4kO2tht1bZ0T9zRaVhsQ
	cRw==
X-Google-Smtp-Source: AGHT+IEmP+N487JyzasP21NmIfKyPNYpTsrIfbUHJjPSQXGunKvga8uby03Y/Zhs15Xs7hc2pqk+Pa2M/tE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d506:b0:1f9:e808:b775 with SMTP id
 d9443c01a7336-1f9e808b9fdmr305745ad.8.1718928051742; Thu, 20 Jun 2024
 17:00:51 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:00:50 -0700
In-Reply-To: <21b18171d36a8284987f8cf3f2d02f9d783d1c25.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240613060708.11761-1-yan.y.zhao@intel.com> <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
 <ZnAMsuQsR97mMb4a@yzhao56-desk.sh.intel.com> <ZnGa550k46ow2N3L@google.com> <21b18171d36a8284987f8cf3f2d02f9d783d1c25.camel@intel.com>
Message-ID: <ZnTCsuShrupzHpAm@google.com>
Subject: Re: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "dmatlack@google.com" <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-06-18 at 07:34 -0700, Sean Christopherson wrote:
> > There's also option:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c) I=
nit disabled_quirks based on VM type.
> >=20
> > I.e. let userspace enable the quirk.=C2=A0 If the VMM wants to shoot it=
s TDX VM
> > guests, then so be it.=C2=A0 That said, I don't like this option becaus=
e it
> > would create a very bizarre ABI.
>=20
> I think we actually need to force it on for TDX because kvm_mmu_zap_all_f=
ast()
> only zaps the direct (shared) root. If userspace decides to not enable th=
e
> quirk, mirror/private memory will not be zapped on memslot deletion. Then=
 later
> if there is a hole punch it will skip zapping that range because there is=
 no
> memslot. Then won't it let the pages get freed while they are still mappe=
d in
> the TD?
>=20
> If I got that right (not 100% sure on the gmem hole punch page freeing), =
I think
> KVM needs to force the behavior for TDs.

What I was suggesting is that we condition the skipping of the mirror/priva=
te
EPT pages tables on the quirk, i.e. zap *everything* for TDX VMs if the qui=
rk is
enabled.  Hence the very bizarre ABI.

