Return-Path: <kvm+bounces-24269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AE29535D7
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:43:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEF111F25342
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2A31AB51B;
	Thu, 15 Aug 2024 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YhjXKMVy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9160F1A3BD0
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732908; cv=none; b=hsjYpJdgNM6YCWaNEaikP/hTcLsE3fqA/gnWbJz29GWqQ9QFXQd8imSV7d09pUouLTf+Dcek4ZjnAfXuBeTqXp58uAyVsbUG6QcU/RH99FUrDxWyYheh0skMyskvuDtndPgZo+qg8Tq4WHqfDjRKV9nmhA9MyPklx0Uz7A02hTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732908; c=relaxed/simple;
	bh=V8QdjGFb8F+F+uBmy8H9NtHYvs5qGYjs+alfqKY+Mes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fs0m5BRarF7yZlCiQLgMUGbv+yknHuUX9WNEL/OyKZC4kPuhi+OA4T+cuIg/fCzlafwwr/ZGekif2Xsnc8VpVYifGVmdNk6aQhsXV8qs7LeveWY7L4u597DeGcllsQKAUW0bDeF+HAD5PpxYmxpYyU2jo8XtvvZ4Q8cgwxoW8cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YhjXKMVy; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6adcb88da08so20691757b3.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723732905; x=1724337705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V8QdjGFb8F+F+uBmy8H9NtHYvs5qGYjs+alfqKY+Mes=;
        b=YhjXKMVy3wL4n/6wI9utVm7rRSlM+4+a2pwbZkfplXGRZEFOtkAkjj854VfCrFJwjl
         Hold8vOKYyeFUnxE/VpUFqqvCa0lzSnlpo5PTj9Cp6chpL/qsFxmrcJlG4/FVOxy6Rv0
         bs7RBZOpC0vNtzgrcm8AwiN9n5vqVbQQa1Ku3v/WTCtGmGPY66otH083I95ZMZsxPCDH
         7R3QSo+UVbKH/OVit1NikJNS7AZPCuicWA7NY3shBpNzi8u95OD/QVw8HRi07vyV88Ax
         y6xieO84SetyFfeaZojUBgHUAJGR8sKrZo6WK6WF7E4n+GDSuy0q+pcadE/Xf4RFh30p
         h6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723732905; x=1724337705;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V8QdjGFb8F+F+uBmy8H9NtHYvs5qGYjs+alfqKY+Mes=;
        b=Ni4I58N6SLqeZ6doTMV4VFupLZkg1WCToqt9t6cdUzCvDJhGzZX3rgb0+t7Arky5uC
         OhVmL2fj6XVLQ4OfyFgb0twCWHuI3pCBwHKV4lbnsTHo6TEUrElDYPtXjnoswkHgE1kQ
         fhergz6AI9HpKqlYQUNX8LgCjLAe8e25+s2efk3YFAwXzqpr5+Yoss04GHcWB+kuLsEo
         1WEZks+6yYOHRYacvXxslpRZT3196GrHn0sbOkXp6vw0q+Z/DvOcGfyiG5D76YV8DDTr
         BpqlgLWUcGRpvZs6yIdYB+AyAddRwMHms46hSghkTgQcd3Pl9k5uMb6FCCYmQsgb6Pto
         yj5g==
X-Forwarded-Encrypted: i=1; AJvYcCUsqeYHc2rwjxcfpX7l+s2H/l+RI6v7gucK77lU3yFhaSEl65gIknFTroiOyuRLhcLnNqMc5ji/PuT2DgFh0lGX5SGg
X-Gm-Message-State: AOJu0YxdMSjXTEVaKKOFo4DpGJdE+iabff+CDKhffJN5GGJ+eXvf2soP
	IjAexAQO+9M+0b7yFwcmwCr9nWL0YJ+TVkpSSKY2lqnCSpl6iTmofAociNKtAencziM+j9/CY/8
	nYg==
X-Google-Smtp-Source: AGHT+IFSiCB9jnN8MHCdZgXQSjJCqbcr/Subh+gxUDVsexDTlSRc3K/rXclSfcwq3ddq5WwRJAk3mZhT5yM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:5cd4:0:b0:64a:d1b0:4f24 with SMTP id
 00721157ae682-6ac9b002b3dmr1171957b3.7.1723732905559; Thu, 15 Aug 2024
 07:41:45 -0700 (PDT)
Date: Thu, 15 Aug 2024 07:41:44 -0700
In-Reply-To: <cc44c0da-4f9f-456f-84e5-87bd4fa47af6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com> <e8db3e58-38de-47d4-ac6c-08408f9aaa10@redhat.com>
 <cc44c0da-4f9f-456f-84e5-87bd4fa47af6@intel.com>
Message-ID: <Zr4TqH9dYk0BbGkd@google.com>
Subject: Re: [PATCH v3 0/8] KVM: Register cpuhp/syscore callbacks when
 enabling virt
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Marc Zyngier <Marc.Zyngier@arm.com>, 
	Anup Patel <Anup.Patel@wdc.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024, Kai Huang wrote:
>=20
> > Also placed in kvm/queue, mostly as a reminder to myself, and added
> > other maintainers for testing on ARM, RISC-V and LoongArch.=C2=A0 The c=
hanges
> > from v3 to v4 should be mostly nits, documentation and organization of
> > the series.
> >=20
>=20
> Also another reminder:
>=20
> Could you also remove the WARN_ON() in kvm_uninit_virtualization() so tha=
t
> we can allow additional kvm_disable_virtualization() after that for TDX?

Yeah, I'll take care of that in v4 (as above, Paolo put this in kvm/queue a=
s a
placeholder of sorts).

