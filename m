Return-Path: <kvm+bounces-18523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E67228D6030
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A25AD283D8A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE57156F3B;
	Fri, 31 May 2024 11:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvmIh18H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738C5156672
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717153457; cv=none; b=L/1AGXee0iv0XP1segsNKkx2K/nIiqg/JoCanR2Qj+ALC/Un2Q/4Ox6rPyNihFw1bLE1J7u2azp+A0j6UDbp6AZtEZ5gKbt+LFRDJWFfS2wz53/pZA0xmki+ffJFCyY2MMX7bYr3Xy9Q1BB+gTGz3RheXF92q1c33uFnQ7ejeIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717153457; c=relaxed/simple;
	bh=JUerc8nwjl9Obv7KsVz6/WdXAIZmdpNnbZ1ImmKyWq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BVBN6G8RJ80QtksbtoHd/L6mAlnAXRS75zv9fqGPHEOsECCydRWHg/5HK2seitnbcEitURozBpzFbda0TREDqf68Sk6m0IKDCwROg/Wv3Kao6qL0ZPTDNfytM266K2UzLPm/J+5xrsAZNxlXCXWsdx+S7rlQO4RKH4E8J7U6VO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HvmIh18H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717153454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QrXf169kVCaHYgglOjYI5Ct9T/6NmM5FFA9dSl+lPlw=;
	b=HvmIh18HtFN63U7pSXG7AYBPEYsXtLLtoDPWdTOCdXZpZEPrdcC9T2KSQ2c9c+QqIlGHwb
	Bnz7dwmW4GLF5Q7uwsCRjq6N6kNM60afrFNClDkaLbqDYbt4Z0EdC6cewkVni+G4601sYz
	lJUTQUoRr/q37yGQ1OfL4twBBilq+jU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-HioThgDuPNWnXI6OL9M7bg-1; Fri, 31 May 2024 07:04:13 -0400
X-MC-Unique: HioThgDuPNWnXI6OL9M7bg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35e0f445846so349093f8f.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717153452; x=1717758252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrXf169kVCaHYgglOjYI5Ct9T/6NmM5FFA9dSl+lPlw=;
        b=vnGNwGH4RLox1TRITfgZe+DWMyzB7Vn4aB0obz1uEcWvLxo0OEq5Ih4RHjPdmRw1wp
         OiKyfXjgGBT4d/fi03jcmkgxkO88xh9P/6vNEU6kdRLDKLAT3b8bZcT3oZIJDmr3OHVW
         Mq4xRL6Ii951NOZRFyyzjgbaF0KU7Ymb8pvV+vnJdGQvvTdtfIWeo4gpACTqgff1rssT
         3+gI3q3BP2zA3UkyASOwo0Fy+yCz8W3urKGA6mIT36gUL8LWMk+EZU/22gUNmeRsN9R+
         g7WNJnjPg19CGc4/VLOYyglDW/P5LONpTL0M+A/5pVYiRY3K59251nZvkRZd48ziWy/Y
         CpYA==
X-Forwarded-Encrypted: i=1; AJvYcCWja7lV7IJ1JD/gtVapwdNTTKwTnlLUTE69MM9xcuXQzm7sfzGrbKrXW1GdlDNO51CJheDB1aABgG0pwD8NVoC39W0I
X-Gm-Message-State: AOJu0YwvQFCjD175Qk9j57BmNOmGmYMHdUyBHn/AxGvuaGvOWR+pNt9U
	F+tmIb5EBivroKnoMjKsYBDLwt7cz0P8tr+xgFZDqUsAN8vkmBe2jd4S+KHNUJsFtXQ6TayBD97
	ldDc8Jj2xHdVAKk42cgtwxdKUyxVjgkgDMEqTwyBBy1SBvnawamprxuJgCDA6kVZS46kP+CTjRZ
	4CZO08INp403N+HwMfOGA52M3N
X-Received: by 2002:a5d:4003:0:b0:354:e4df:472f with SMTP id ffacd0b85a97d-35e0f272b5dmr1066909f8f.25.1717153450612;
        Fri, 31 May 2024 04:04:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmFehOMMI/KFabXe/43YV9+whbMFVa9m+G9FPU/c0uHafhWnH55lclge4cujXx8/UJCfqXLi5mPsl+m5OkQGw=
X-Received: by 2002:a5d:4003:0:b0:354:e4df:472f with SMTP id
 ffacd0b85a97d-35e0f272b5dmr1066885f8f.25.1717153450215; Fri, 31 May 2024
 04:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-5-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-5-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:03:58 +0200
Message-ID: <CABgObfZb2oZ5R90pw7mkJEfNjwrcTwxT3AqKgUfguyKih7CXJw@mail.gmail.com>
Subject: Re: [PATCH v4 04/31] i386/sev: Introduce "sev-common" type to
 encapsulate common SEV state
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>
> -#define TYPE_SEV_GUEST "sev-guest"
> -OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
>
> +OBJECT_DECLARE_TYPE(SevCommonState, SevCommonStateClass, SEV_COMMON)
> +OBJECT_DECLARE_TYPE(SevGuestState, SevGuestStateClass, SEV_GUEST)

A separate SevGuestStateClass is not necessary.

> -    .interfaces =3D (InterfaceInfo[]) {
> -        { TYPE_USER_CREATABLE },
> -        { }
> -    }
> +    .class_size =3D sizeof(SevGuestStateClass),

Declaring .class_size is not needed either because it's the same as
the superclass.

Paolo


