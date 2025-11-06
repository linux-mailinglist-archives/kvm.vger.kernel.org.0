Return-Path: <kvm+bounces-62227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FD3C3C9AC
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9935A3B7871
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFCE3321B9;
	Thu,  6 Nov 2025 16:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A3SYUcM3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FF627F4E7
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447488; cv=none; b=kk3ZJ3mRxfjQi0V0gJR69X6wu4+6rtVNSW4pdNFk4sgO1e6XoPor+OH9bsO9DzUaV9jshVpDuNjNlRfFJ5toNJLlQ4gXCGlyp8jDEceU7FKPc7/WYzwVqFeLBd4o6I3W0am5262O8WitwBgZlJDXTXSXVBxsCHzE/JTXOfPsGkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447488; c=relaxed/simple;
	bh=rEUjsRVYzdi3XI1LFM54/o+nJWhRShVbyXSOqbKmxsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=omJ54TY3Q7692J4Zi9pZFqHftZsJAu+xP1NstyOp7NoDDlXCtiPDiz63hfGj0oq8QuLEIi3llr8kQyjtBLS50h6QNsjTFBh0mKHlcBcrK6zC+PePB8u9BX4mdwUaTCnemTdBVDQTQZS++o23P5jl6l2psOff3Tw5Bpl59+Ah9rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A3SYUcM3; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ed67a143c5so397571cf.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447485; x=1763052285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rb0xQ7azPtb5R1c1dFfey4+Gdz93xWujtr+XNfeYFuM=;
        b=A3SYUcM3OADG2bHWnjroLM1+o0xLGbQDNBfwsHqoeNOIhVahSK2vQdh+J4oUaGwdBk
         k9Gs9YLL73EIl+IxcO/SXu/nYkVMEikBEMF8pUgV0mEaV3bjs3oRrpTLdhFy8qKBsSG7
         B0adkbWuCZuszKqHbAGNtx5PPgs9QU3EwFv2JezToAnq08fYVUqaCmEgWrlzysDeVCwi
         +eGY1ZCwmhkiKhtKaLbEhS/Ys1aJQJuGj1kICi8DwCxMPA8oFyyBCrpeVbUBqryTIMm7
         U8TWgvob3JG6QMgyALpFKSEEncuOxDkazNxuxzBss+NGssKZdLAtt5WAld1maX+5JDAC
         kLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447485; x=1763052285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rb0xQ7azPtb5R1c1dFfey4+Gdz93xWujtr+XNfeYFuM=;
        b=ZGNTI+Ale7AJcvtWEYPG9M9uJ9ALLfbmT/s/2u+993zxoQYqlVxiF27E2asjQhuwvh
         TT5hZpps7NmcggpHjrng5oxU9uBExvbtIPGc7gof3Rv94XUCPYjhHb8lKHYqL02o3Czm
         4unHT+CvMuHyzPwBnhlLDsDtWFAEEzcSUkWFOwD7TVndLGfMiLFYN/g4ometrXF7vcO1
         cr8QXW0ev0WoiorN+dP2Eb4jnVOWiBeQLj0le8Op5NVttxLhMLW7o2XfW0Zzp+eRjMPC
         RcFgdaj9DMcUDMAXiuQ/FsXCQnp+m5EcuKJew+WuY6yumKP23jUM/wM+0JhkScIoxtRZ
         JwgA==
X-Forwarded-Encrypted: i=1; AJvYcCUpnLOJ6o4QKWVQFXpR95oORfa/m9C7XTnagY0t6yKyfNYp9gieywZXaro4Kc9XZtWRdHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYtcpIFbzGTPGgL8CiC8HjGiizeYr0JDWpjjd57CI5uaHvfj/f
	D3nOr71DYzMTwQ+I7Zev4sLULkL/MNumTLDvn2VUv8su2JTjdDl/Yb7gKHeioZGpsaliSSEDMoI
	MHSW+MY3ypS1PSZR//Ma5T79CseIy9eX14loVUJ+a
X-Gm-Gg: ASbGncsyXlmK2AOSz6AnFiBUc84Ip35TogAdka8L5NGjawhas0G8KyMBLQpGgvn1HpD
	Y1PAf38gCRieQu1FO1bvnHhRyLQ9mT5f4odxB4tR33M6UYV3OXDln4SPWAHBv2mL6vKr7DqhEtl
	Qgx7PixmJ5+NpqM/ShvasnrRpowDjZgVMpl6h79AWPSwiQrih5th+jZqb44gWy3pmX7e4zp0W52
	5EGbxUDsL5CgUCV5fYILVX1Msi1ixR382e6l49acXUwJEGbfDAvO31l+BTVVApe4F8thZQ=
X-Google-Smtp-Source: AGHT+IEcLrlYbh4mCr4c1Dl3FMnHNJ8BGbv+8eVtdigWkONCN7ekj7UeCPoYuiSi/E3ZLOfRY4zNtnzunYFejtXPYzI=
X-Received: by 2002:a05:622a:1105:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4ed81475fd7mr8177711cf.8.1762447485338; Thu, 06 Nov 2025
 08:44:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com> <20251104003536.3601931-4-rananta@google.com>
 <aQvlVzljJhKQQ2ji@google.com>
In-Reply-To: <aQvlVzljJhKQQ2ji@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 6 Nov 2025 22:14:33 +0530
X-Gm-Features: AWmQ_bnqsBhfkU0Z8CSVpXkdXubHfrNkA7o_iAWY9Mzo7gnOb_3JOEiFi4oC96M
Message-ID: <CAJHc60yVkMUW4C7i5WAb37AixEd1xL+oK=NUnFbqA2PGgHN0Pw@mail.gmail.com>
Subject: Re: [PATCH 3/4] vfio: selftests: Add helper to set/override a vf_token
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 5:31=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> > Not only at init, but a vf_token can also be set via the
> > VFIO_DEVICE_FEATURE ioctl, by setting the
> > VFIO_DEVICE_FEATURE_PCI_VF_TOKEN flag. Add an API to utilize this
> > functionality from the test code.
>
> Say what the commit does first. Then add context (e.g.  compare/contrast
> to other ways of setting the VF token).
>
> Also please add a sentence about how this will be used in a subsequent
> commit, since there are no callers in this commit.
>
> > +void vfio_device_set_vf_token(int fd, const char *vf_token)
> > +{
> > +     uuid_t token_uuid =3D {0};
> > +
> > +     VFIO_ASSERT_NOT_NULL(vf_token, "vf_token is NULL");
>
> nit: The help message here is not needed. It will be very obvious that
> vf_token is NULL if this assert fires :)
I'll apply these suggestions in v2.

Thank you.
Raghavendra

