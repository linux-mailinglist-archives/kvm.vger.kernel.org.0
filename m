Return-Path: <kvm+bounces-39028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3FCA429D0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 360813B4B59
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66376264A94;
	Mon, 24 Feb 2025 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LTKIQkxY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E745264607
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740418157; cv=none; b=kLZo6ILfmLNn9KyhRZL72o2G4lG/b4qddecpPx/6P+hKv0q5reg13psQWUQwMGA+2lZtc/vSant2Y9Cbw5b/iKXbgWyvoiYHCo4FAp5UuQ/ibcop1xEuUWGagm6SR638sWY3loyuk+H/2zNmqFsI7zdhbYGQbSadhC04nmman6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740418157; c=relaxed/simple;
	bh=xx1QeYum9F0g4R1uQ44LWKRmPki5YkeJN99+/cp6RXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r79mrAYbhbh7UlddeieuOuDlC3qC8AA1hK2mrTNCi1huXoeKQdTQs0eauiGuyix6JM5wWacEchfDesaUUYnHTndv/N1Gz2Qsh85RmtuC2sZVrLdLarmgOrNw68x50TjSh0o9ZGruJG+PAkvpAYlhh1G/zR6QdshJlN3+eiOXpf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LTKIQkxY; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5dbfc122b82so37a12.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740418154; x=1741022954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xx1QeYum9F0g4R1uQ44LWKRmPki5YkeJN99+/cp6RXo=;
        b=LTKIQkxYv3j/YmeuLJ+fmpEFgx3BZPQNTW8VGvac+6zuUmS1OwUa7VU0NJbI9XuREE
         RKEWJavITT9A4stZ3bstUDCwAPe6wln1Wa9GLil6nxQk9E6msk0gXAKXYA/L34B738W2
         8K6MWVNoud3khBH2/faXqeZJa6Ys+XrLRX28r+WvBy0l3BLKzvEmZ06m9qFfHsa3+lJS
         Z22xe2ZXCt7xmolLjawqh4zRkdQzxjcwVmQm7pHXCt56z53Tk1Z7+ZmIsHFtD7+MA2MG
         XWR3dacp5FSrJNCof3bmX6obzkDq7LKOD5qw5IqgbC4H7C2xKZs/+U+AciXmUmGr7AMS
         0NZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740418154; x=1741022954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xx1QeYum9F0g4R1uQ44LWKRmPki5YkeJN99+/cp6RXo=;
        b=B621HJ9Gv5SlCYHCU1g6NABcIAZN/TD1xCGgjjTHw+s3S8SjWT0z0tX/JfGl8ufZor
         2GkmutytkjTzOnd5uxX2qFplam/hqu1X8RwTe/73Dnq0pTj1lTUrPQ6QmgZ0RNL64AT5
         LnIqEn4BIwIhSkS/AhlrtroIfclSwOBBcCQolnj2qSEuhdq0fh8R3CK9pw9xX6YSdiZS
         PepBfln6ix9aWaIUttbyca/1lhVsg4oxF7zoMjY3McOkJgqRkFGiUMr85CGUeo/7whMt
         4p20198eSpN6DCg1lwouVVEmFOwF54lTBK8L9w6Vw22mQXvznKaTUO670EmR85Yz2BrY
         5Y3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVomcW41VxN6W6M77ogZkYNZjlzZzcLdJ4AzDSpeERpVgMH81lov92VvzzkeaY4/nv9ZSA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaYcWFn36K/sYrPbDdRD2KbB4CBkw/PtBLxQxvJtdtOZIJnvX3
	S2KbCMtP4E510gv3iZKGlBPIa7HNwdHPxoBfoWAq1JI2YapRUwviTAx+ywS3oPZXJjsRI6h6Dk8
	mNREN/HTwvUrYFxDmmZaTmatI8L1Oq18o9EFN
X-Gm-Gg: ASbGncs/3rdkJxRtM2RuuRkzLrLGq3mTV42eDP1kfEgdvoNnEUh1tx1cnl2LfQiAu+8
	cmYz9GnP86KHD5KhT6DYKr8FaLyJaAiKI1lQFawKXxDmp1juIUiJWynkGoxDXKwcae9cFCu4uhq
	ma+zFQbs0=
X-Google-Smtp-Source: AGHT+IF33Bz0K5wTdY9n2hwU2nzRuWmxmxvKbeT5PUpV0suDtFxp2gRSePT6D7x7AVWBorWFCnCBILpKjJQOBzBvGy0=
X-Received: by 2002:a05:6402:2062:b0:5e0:ed25:d28 with SMTP id
 4fb4d7f45d1cf-5e400125716mr2002a12.1.1740418153635; Mon, 24 Feb 2025 09:29:13
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224165442.2338294-1-seanjc@google.com> <20250224165442.2338294-3-seanjc@google.com>
In-Reply-To: <20250224165442.2338294-3-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 24 Feb 2025 09:29:00 -0800
X-Gm-Features: AWEUYZkxSRz7bozwI6B1PTS5d-j--Hld6kcW4FN3FHQP5MxWfJFlCRft8xOA5s8
Message-ID: <CALMp9eRrZ3vMbiJRLU3wrpGaVbBOuYh8QkxazZKxXvDrnxVkUQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Assert that STI blocking isn't set
 after event injection
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 8:56=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Add an L1 (guest) assert to the nested exceptions test to verify that KVM
> doesn't put VMRUN in an STI shadow (AMD CPUs bleed the shadow into the
> guest's int_state if a #VMEXIT occurs before VMRUN fully completes).
>
> Add a similar assert to the VMX side as well, because why not.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Jim Mattson <jmattson@google.com>

