Return-Path: <kvm+bounces-15996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1E08B2D4D
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2FE91F226A3
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD121155A39;
	Thu, 25 Apr 2024 22:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t5vApXQj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8387B155A43
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714085793; cv=none; b=Yq3cBpdjGXkNjbEVHXQkE2UPup+ystUPUv4vNDZcpjkqQEMJrsxlvbQ2CVECDAzMXaWihS6U8EeHQsppaDAvynlsk4P4jF0GhY+onz8wZ6wVryHqP4m4YnScZ+0ruNo2kZpNWC76rWV2WDgN726tr7uv3Hf9SNr2/VXvXSj1rns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714085793; c=relaxed/simple;
	bh=KYtF1y9QVO5lRyrlFu3LypLQR8DFwKeNUbD5+t8eWAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IrDzwmo5MD6W9APfZDpA2cVXSWVXaY7Wr3Af03wLrxAvabSfoMUYNuQqMJRJkW5k5b9YfdkekWw56UdVGzabiScWUrONRYQIVD8nwVmqioAgeOrglTMzt/CiWgmbFIAYxCB/v/F/prIVvRqzGfo5L2TVncGg+bhBoThjF6YYxp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t5vApXQj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b2abd30fdso28507277b3.2
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 15:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714085790; x=1714690590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkB0Oe3ETNpX0Q3btEZQH9RDe4KISQYsNCkxgD0xRNI=;
        b=t5vApXQj+HlsAVwouSNLkjD55s92sAE0x9Hx/6jIOoG7BURTbLdTbFKkVUSm4X/Wr6
         7GcwrOVdagftITNEQO7s9IWVtBSc9pigDktf4TIay8KKPK9tkJLuWtiAeVsNXAqJ4KMd
         yz+QoLXGsELnta+HaJZ6DzvNkDMVENKFx9i4yBghUyToYUZQoN6KbI4IeN4hk5LstTHW
         f3pqZAep21f8Agz+Hr1rQ/jlwJ4KXcCZey9ZCNgmZL/61munn9Hx+BZokU0TxHqRqM6V
         /zL+Vgqn6aTRrQ7L6Lg0soQTvqVKxNBEt6TsUqbCv4aEFpB0TogbFp2l40uw0D59LIoc
         SIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714085790; x=1714690590;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kkB0Oe3ETNpX0Q3btEZQH9RDe4KISQYsNCkxgD0xRNI=;
        b=g0is8FL3wukAAO8c6ln0fApDiNldbvBqDC37qtht/ThtM9TMK6qsKwJ5EZbX4yiUp2
         7UMNTX6Y+oM/l497/fJPYCa0BoUyAY4i+jy2URtvByZeWg6B4CwLwjBhgXlp//6YxWdc
         ZFyTGi3iQ9t4+r9FE9i6x1DDVSimYmAUcwKdIg3xcJS1J7t4TxBRe3u1O2GsE272/4gf
         aJ7/taybuTSc9sFpx3olmVUb4Plchm1cQGJQWZOBrFCacqdOBSR9UrlipIyZXtAaMvD2
         O7VXEtvPo3UVIqERCFp/bNHKlfLJ7z9P/wCbuvYnNn+fJbsQpGY5XEvxkZyhib+x3f7B
         Tgrw==
X-Forwarded-Encrypted: i=1; AJvYcCVtjc+hFl7iWBhu+9zW0Il049bBt5xkh6KNsw+1SjqauXzJ3X9SBOAFL7RDu6lbblnQdoIf4/CWjVncVJ+ZO6kFleJ9
X-Gm-Message-State: AOJu0YwQGadGqzcj/qBtaLeaKa7CYeJgnRxA9aX87Y7JZL7cZesodtpA
	d4c4CiM559cGvENuYRG65EpQ/bWzwE1hjExjsh9GfjU0IsjRAcTFFOU6C7EZD5uWexTeYBSJ8Mn
	LTA==
X-Google-Smtp-Source: AGHT+IFK9QispM2ICO/aS/Bc4lsJTNQ0CRIQjWqhFAfzup1zpNtFb4vtBZLcBygyOTGdpJexadd4ZWJU6fQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:15:b0:61a:b2d4:a3fb with SMTP id
 bc21-20020a05690c001500b0061ab2d4a3fbmr220432ywb.8.1714085790530; Thu, 25 Apr
 2024 15:56:30 -0700 (PDT)
Date: Thu, 25 Apr 2024 15:56:28 -0700
In-Reply-To: <4195a811-7084-42fe-ad10-27d898fb3196@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com> <20240412084309.1733783-2-steven.price@arm.com>
 <CA+EHjTwDaP6qULmjEGH=Eye=vjFikr9iJHEyzzX+cr_sH57vcA@mail.gmail.com> <4195a811-7084-42fe-ad10-27d898fb3196@arm.com>
Message-ID: <ZirfnPFPo1cMwFQc@google.com>
Subject: Re: [PATCH v2 01/43] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
From: Sean Christopherson <seanjc@google.com>
To: Steven Price <steven.price@arm.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Steven Price wrote:
> On 25/04/2024 10:48, Fuad Tabba wrote:
> > On Fri, Apr 12, 2024 at 9:43=E2=80=AFAM Steven Price <steven.price@arm.=
com> wrote:
> >>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range=
);
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index fb49c2a60200..3486ceef6f4e 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -633,6 +633,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_=
hva_range(struct kvm *kvm,
> >>                          * the second or later invocation of the handl=
er).
> >>                          */
> >>                         gfn_range.arg =3D range->arg;
> >> +
> >> +                       /*
> >> +                        * HVA-based notifications aren't relevant to =
private
> >> +                        * mappings as they don't have a userspace map=
ping.
> >> +                        */
> >> +                       gfn_range.only_private =3D false;
> >> +                       gfn_range.only_shared =3D true;
> >>                         gfn_range.may_block =3D range->may_block;
> >=20
> > I'd discussed this with Sean when he posted this earlier. Having two
> > booleans to encode three valid states could be confusing. In response,
> > Sean suggested using an enum instead:
> > https://lore.kernel.org/all/ZUO1Giju0GkUdF0o@google.com/
>=20
> That would work fine too! Unless I've missed it Sean hasn't posted an
> updated patch. My assumption is that this will get merged (in whatever
> form) before the rest of the series as part of that other series. It
> shouldn't be too hard to adapt.

Yeah, there's no updated patch.

Fuad, if you have a strong preference, I recommend chiming in on the TDX se=
ries[*],
as that is the series that's likely going to be the first user, and I don't=
 have
a strong preference on bools versus an enum.

[*] https://lore.kernel.org/all/e324ff5e47e07505648c0092a5370ac9ddd72f0b.17=
08933498.git.isaku.yamahata@intel.com

