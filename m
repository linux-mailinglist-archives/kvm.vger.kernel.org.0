Return-Path: <kvm+bounces-36132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCAEA1816B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43D61887F1D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6160F1F471D;
	Tue, 21 Jan 2025 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MVZ+M1k0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276551F2C57
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737474916; cv=none; b=ZXvWUxmWuj7pwkZDiy+EVKl6l1w19asebeeOwvMOd3aBN0DJqnQN28IC142Amq3NZ7jLwYCX5XZlGi1ea8b3dRn74HM6IuCQEM+CtBT/D/2H4n1Ny6asz78Qw6iGPRJXe9wIeWJFv+6d40Ivfz0/xSQGs0R+pFZqTaFwTvitm3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737474916; c=relaxed/simple;
	bh=7XZXwF5wdlElwvcZPmyQUeHz6RNJPSi3z8M5J77LL5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QQZRkX5b4TNgjsGb6H4TerPN8MXTMrpIlioVUbJshYuC74Oe6bIpspPC8W/IclIN+6AAeh3zL9swDrvWQbVvV01Poo5+iW8SeRHWpoOYYh4S9cFiibvHqV24/AXoNd838axQa/EmDdJxar6KmnlGgQDUh5YagcC21+LK4oY3DXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MVZ+M1k0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso10742735a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 07:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737474914; x=1738079714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e6+Apqyoldz7GJ9ISR71ryeAIIRuwHBMgh+a+9AIAM8=;
        b=MVZ+M1k0/B76YG2eIdls7pkV+v0S8N6D5IGWzPlLpmaP+lIs2hSqj6MyEkB29g1Aqs
         TONd9Qo8kPCTVamBiJO4tIHmnOGdQmaEF3HBrdqWivcLBVKsh/hkAMofXpDoP0L8tQus
         DFw10sx/uCMnAL+cYAf6fRwKejzdgkfIayIxgFvHA3S4/CCZRiCWdPLf5ajzVNwsn57O
         6L9z2t4yRWSGjSvntfZFsdjswzSfiWrd4mecha2zEUKOdezIjiA2dI1wMbmb1Sj5fdFR
         b2IbBy8IuSCBu9SdM/BptVbdIaKx71492mhWBVTzjdZKehpE+6xa4F18LGRNUpeXPlYx
         oFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737474914; x=1738079714;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e6+Apqyoldz7GJ9ISR71ryeAIIRuwHBMgh+a+9AIAM8=;
        b=sDEZaxgr1IvHaro0M5UfGuNImb2hOnklio5GuB2GaDtEr4SRrF2rKk2f5ODIhKBR47
         Io5XsXs9ZLWpH8M7W+ACcmAXOCloWOL3Ijhz6eiaU+XVP512qoWgBEOTadoh8xJ0ClxP
         Jh5zFFMVnyoEt+TkTJx8FEZP2/jcClR/36ukobHZ/X5WrTdtQI0OdvtDujqGCpelnibK
         /Z4t1GA7BYh3i5KMpGr9Zp/hJzSMZur8m9PdvTkYcBewoNju7WsSGGnu3xxZHsjsXlGN
         upgy8lJdqOX2PWYEQ/ZqphciI8l/qnOLXvTYGq6Cyp1lq/xGxsW2Hvr3YoH8DAAWdBg8
         nwcA==
X-Forwarded-Encrypted: i=1; AJvYcCVVfuB1jBQ3TI1Vjfl9xxqxRnZoZKj59KEio9nn1mTiAHfXkHN2PKw8ejsOU58a2AJcs2k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpkj/cJ1PJOzmU/PWQdY39aijoCoc6weeBArv0dZhdU5Lwft/s
	ByqWxAIccVP4vXUo037eS9EvfH+cAzV0x5GVOLMV2YnCPzp0RDDyM1OQRiIGyOlkkBgil/EKEGE
	KpA==
X-Google-Smtp-Source: AGHT+IGh29y2t1Ejp1CgkeenXGZZ++olVnu2uIXJAQWnhFxMiW+EJMMlUGjS1gR0STV1P0L/xv7sb9wVQrc=
X-Received: from pfblu23.prod.google.com ([2002:a05:6a00:7497:b0:725:3321:1f0c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2382:b0:725:ef4b:de28
 with SMTP id d2e1a72fcca58-72dafb365b8mr23518496b3a.17.1737474914409; Tue, 21
 Jan 2025 07:55:14 -0800 (PST)
Date: Tue, 21 Jan 2025 07:55:13 -0800
In-Reply-To: <Z42Q-sbPMA9zZMIC@archie.me>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <03a04e86-c629-44df-9022-05c42b4c736f@gmx.de> <Z42Q-sbPMA9zZMIC@archie.me>
Message-ID: <Z4_DYfJKl3jqzU_Y@google.com>
Subject: Re: kconfig does not accept a lower value for KVM_MAX_NR_VCPUS
From: Sean Christopherson <seanjc@google.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: "Toralf =?utf-8?Q?F=C3=B6rster?=" <toralf.foerster@gmx.de>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux KVM <kvm@vger.kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025, Bagas Sanjaya wrote:
> On Sun, Jan 19, 2025 at 12:04:04PM +0100, Toralf F=C3=B6rster wrote:
> > I was wondering why I cannot put a lower value here during make oldconf=
ig:

The lower limit of 1024 in the Kconfig exists to ensure backwards compatibi=
lity.
CONFIG_KVM_MAX_NR_VCPUS is effectively exposed to userspace via KVM_CAP_MAX=
_VCPUS,
and prior to the Kconfig KVM hardcoded KVM_CAP_MAX_VCPUS to 1024.

I did float the idea of setting the range to 1 - 4096, but we opted to go w=
ith
the conservative approach because the benefits are relatively minor, and we=
 didn't
want to risk indirectly breaking userspace.

> >   Maximum number of vCPUs per KVM guest (KVM_MAX_NR_VCPUS) [1024] (NEW)=
 16
> >   Maximum number of vCPUs per KVM guest (KVM_MAX_NR_VCPUS) [1024] (NEW)=
 8
> >   Maximum number of vCPUs per KVM guest (KVM_MAX_NR_VCPUS) [1024] (NEW)
> >=20
>=20
> Hi Toralf,
>=20
> From arch/x86/kvm/Kconfig:
>=20
> >config KVM_MAX_NR_VCPUS
> >	int "Maximum number of vCPUs per KVM guest"
> >	depends on KVM
> >	range 1024 4096
> >	default 4096 if MAXSMP
> >	default 1024
> >	help
> >	  Set the maximum number of vCPUs per KVM guest. Larger values will inc=
rease
> >	  the memory footprint of each KVM guest, regardless of how many vCPUs =
are
> >	  created for a given VM.
>=20
> I don't know your use case, but you can safely choose the default (1024).
>=20
> Thanks.
>=20
> --=20
> An old man doll... just what I always wanted! - Clara

