Return-Path: <kvm+bounces-62223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B68AEC3C91C
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 363873A85D1
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC9434D4FA;
	Thu,  6 Nov 2025 16:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XY/FDOaQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AEC34C820
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447020; cv=none; b=rtJ5nYEg1q/e/vi/jc/t1iocpKzeGJxe8v8v8ZVOcQgcPD9lUDMMR1AaXzAX82fhTbYE8etF7szeIGWoIwEUXYo4LqbJ7t/VEgGa+o5Ippa1fkwHVPp9IArEZ5pxGVhhZ92YAixI7gaCUXVZ+V6me8iO+m63GiOQREJ1TEuof8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447020; c=relaxed/simple;
	bh=/H4aKQiGoB+WRNMdPbS39s+XSOfaGMVBTg+VNXS/AO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tRAD2YoPPCUcZBPirCFBbTqaES9NlWT5A6rjn0QD21dJdFI63z8osCc/mPjoblTb7M+4MQPR/mAnYIwzz8YAeq6OTJpZM00X823jS5atfqR1Ew1rN8AkJEkUjv5GjOUl7i6vNVC6snhQlRr6fVlK+WtZnJ+m0SpkWV1Uwn0aVRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XY/FDOaQ; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ea12242d2eso336751cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447018; x=1763051818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=unfH04DSjfahtY/Ro5y5JWosPD9lmvBdHPZWteASQ2g=;
        b=XY/FDOaQoj+ZAR8PxvT+5Y2lv7KZxY5LGlkhb8xvsn1s7ZpZY4LqYia5rRHbEUpuXs
         aqae7ZK4Ji4maep+IVLR4olUuACbVMgUVPbMeHYIk6n7JePULk6YpHdC6v59dheNdfhw
         PzrOhLsyJvdR49Gl4TDuCVPlxObpz/aB0LWGnKCw2zj6RyJRrfWtwkxwVO+Fy4fFvHZj
         gw5V/QpL30/X6gqXhaK7eVLXfkNLY5JEf1bTUk92FUSL1a7RuK3+moTT9k9GPfRG9WhM
         fpxbcvw0QRwCUAro5A2zCH5Plut8s5Li8xiyh/6PhLjRlxRI1yfvPqZgXOWlE2j7X+cj
         /pSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447018; x=1763051818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=unfH04DSjfahtY/Ro5y5JWosPD9lmvBdHPZWteASQ2g=;
        b=GVAqSA9X/Bjl4HOh5ZcIKvZ9jvtHW8iEj2YxbkezODal3GmVsizld5Z4B4ZnMJJduG
         dWsDfaCConHcU7AwclixPKdOe2LOXzCv5SBVOq1OIlY4HjLR81907MdsboAdjEkKbqX8
         HxvU/odnvpprmj8R90yd3dvbX2wr6+aO4oQePaUSf5luzWDMA3JDJtdjIZH1Cw52oHUR
         z2EgDVQT10LRUmg7uAQAi0gJoXbX7DGVTIe3eBl8MlOQvYwaliRKkcha7PexEwawVVQe
         jyN+dJJ9+g/Iu0/EteF34JoJiFonNY9Kb+qIA5T1amuxU0FC29oCpR1bGDr1sm1e2ok2
         uvfw==
X-Forwarded-Encrypted: i=1; AJvYcCUpyq0bwfLIonkK1YqZwpcDYsKJzytdk5htYgjx4d+Dmuc387ETB8uf1LL2tLH+RNnZ9VE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOK6sPRY6aufX7764UQCTN3zp7JO4y1vkzfJ+N97BwvN+eVsu8
	40WzwBtL4ZJhbF+UGCfeKm9bOi8SbHXvGVT6q37gyClRtyuNYeAQ7fbMAFUX+JI0h9QTk3k7/Vx
	Mf7tE7vNgHkO9rdmn5kNI1U79Ohg2creZ2r5wfRZQ
X-Gm-Gg: ASbGncv4crQsAAmL6/GY98VJ8XyMmxvVx8YjYwXaK/izD7xj5W9AgkGjZSNqbtMgJye
	0/qzAfj7r7NQuvTgtGbBRPg6rUW0DhoMZQGknIW4cWIyLtObHYObN2CLDq2EKWfbhMARrszrPOD
	bAir+c6CgIdcvsnbo87DI+zD4XR5wjuLQ/23PeYI830DgF6M6M1oIv5n/39N9PM3Ab8eH8kKGw8
	GkoYJDdgFtqkX4LDcdZAQUTV66ak1e27HwSspulwM3jGjgK+YaiMpwdImv1
X-Google-Smtp-Source: AGHT+IH4D/IkZOkIcH6+QihJJUYRXkSroIwjVIneHKA2+S/ighH3/zauPQTD1YhucwuTFxNEEfdh6lM9UHFcearQHbo=
X-Received: by 2002:ac8:5792:0:b0:4b7:aa51:116a with SMTP id
 d75a77b69052e-4ed813f1d79mr8130581cf.4.1762447017683; Thu, 06 Nov 2025
 08:36:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com> <20251104003536.3601931-2-rananta@google.com>
 <aQvoYE7LPQp1uNEA@google.com>
In-Reply-To: <aQvoYE7LPQp1uNEA@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 6 Nov 2025 22:06:44 +0530
X-Gm-Features: AWmQ_bnOnZ7KqbhSC0MJ1bizQMExDCc20cQdxq8DyRf13e7QBXYi53UHkKLSdUk
Message-ID: <CAJHc60xjPktqw=RgxgpOSqJP0Ldq6skmxLQm4QhpiojPAMOA=A@mail.gmail.com>
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 5:44=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
>
> > diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testin=
g/selftests/vfio/lib/libvfio.mk
> > index 5d11c3a89a28e..2dc85c41ffb4b 100644
> > --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> > +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> > @@ -18,7 +18,9 @@ $(shell mkdir -p $(LIBVFIO_O_DIRS))
> >
> >  CFLAGS +=3D -I$(VFIO_DIR)/lib/include
> >
> > +LDLIBS +=3D -luuid
>
> I wonder if we really need this dependency. VFIO and IOMMUFD just expect
> a 16 byte character array. That is easy enough to represent. The other
> part we use is uuid_parse(), but I don't know if selftests need to do
> that validation. We can let VFIO and IOMMUFD validate the UUID as they
> see fit and return an error if they aren't happy with it. i.e. We do not
> need to duplicate validation in the test.

Unfortunately, VFIO interface accepts UUID in multiple formats. For
VFIO_DEVICE_FEATURE and VFIO_DEVICE_BIND_IOMMUFD it accepts a
'u8[16]', but for VFIO_GROUP_GET_DEVICE_FD, we must present it as a
string. Is there an issue with the inclusion of an external library (I
think I've seen others in tools/ use it).

Thank you.
Raghavendra

