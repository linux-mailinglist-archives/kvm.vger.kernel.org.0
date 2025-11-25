Return-Path: <kvm+bounces-64532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAB4C86414
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97D013B87DD
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B5E32AAC5;
	Tue, 25 Nov 2025 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DW7CYnxR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833CA32824A
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092344; cv=none; b=EqBxb9bbp/Nd5BtJTocnStb0Qjrznegtot8+d5v3Wfa7SACxm0qSfAlSG62l28k5aoNkdNBtP6PiRWzibpxSFJkL7WsiWwCYODeyk16R/HU8ozzkSAl/sYZhTsd0U88BF/1qS2HWqIpxbtQ37++FprRw12u0GUtKHblmkickuXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092344; c=relaxed/simple;
	bh=hYpKuwg+6qk4P1s0BVsJWxLzFkie37j9EJGGxbty2O4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=flT91Q/Pglufcu4BwX54Gralkt+i9y9qZbsoatYpbWRWhugndqjgqDxtpH4hwLDONcLy6IfzhEsb3e6O1K7kglyoy2tLdRMBW8xdu9xBi3CabpsF6fb4BHWww8XdhzIFSYD0l7A83oX2g+GZ1+VerFN06g4IDD0sBefXE9SpreM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DW7CYnxR; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-37cef3ccb82so22964701fa.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764092341; x=1764697141; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYpKuwg+6qk4P1s0BVsJWxLzFkie37j9EJGGxbty2O4=;
        b=DW7CYnxRNDbpyakHdtjoLBg1YOyAMn2KKBGzKdzTpfQz7B0e28llGf2GO2xej2ocTc
         tYd55PteEgoj6BeTV/vzzu8dMj/Z3nWaHbXB+CzNpk5XMdFwO60ndxNMsWrW68Ms+vD5
         lZzNusKARXfjGm+FfViVefDbCo6XAjlu3Ld1SvRSoHMcCOCYdRaveCoat8khQBByI2PQ
         uQgsRfMmFKeQugdokJTMVgOQmMTaB3D7LPeo2sYnHUUasUxlqCeFWrfL+HJjssrHZzIr
         ELj1HStCz5kAbBGRLeYSogq6TSKmukp6Zh2V7gaXl8cPEr/rBc94omH79fkPtSnXqhSr
         XWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764092341; x=1764697141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hYpKuwg+6qk4P1s0BVsJWxLzFkie37j9EJGGxbty2O4=;
        b=xOCHn/DyPzloiaqoFZBgchBEhA9Gn8ZmR0/eK7U1IeasmhM2oLfePHvrGY9Arsm/pc
         SzsjTodhabOKAVs0FjG+Damu90Z4s5P9haeZtobKEZTV3by9M3xc21UEs2ShXXiNZwv/
         smls1UZshsUb93N4lra4mH4tq+NnnDqBrR4pUVLYEWP6ZvW4NfUiM/QfaKrtr2ORNyZz
         LmPfx4n4thrk8txle9q1DPVsslgoVk8hvl6vLWQFzK/GAD+ExOa2SxLCLdQwyxkrRfCL
         O3gZotktYWLWiaLr5WEf3r5odGFmBCVnkHDiHPg6LnB07+tOX1yPvcJUwo6mESfvaDPl
         3s2w==
X-Forwarded-Encrypted: i=1; AJvYcCVZfxjBC56scdlKniilLkOET71wRYVoGiX0/MqCiO5FWe/D4SSUB/cskeBKPRpCYLgP93w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuY2fPhEQiIIt1ha2kXaCLvAvqLcpmldsZ6oQCgVKqZayT9YRu
	K9MQyCneKeEhpmBJAOCN4HUqWbQ2UqaFoJxrR+k6lPZ1tX0H9Eak0xFokJ3YUR8OgyYslEtNPu7
	b2nvcjk/MnB+zwTD1EYYjnmUDu2SR6yazn8B+D8r4
X-Gm-Gg: ASbGnctKMrHr0ipchZKFOAkBE76RzUL5vb+Y8Nk5v5YDAKp5uztbvPeKywiUZIGPoSw
	fvjMu8bRnHVZzdSy1javPKxrpIJg7rUT3gm0uOtvPMflFXzLtmt1MkA799XmrhLhmAsBXmvQBQx
	5BgOb8OLV/HA7dfmKhl9y4KzOMA5L7XmmhQx8KH2ctvczH9m0sutD1KCPkaK0FyYSmLDcA/3Jw9
	M+ZshxVdOQ7QZ2TFkCd33HrP13Ijdg7q+7yyifIFAz77DBccNd8aYqCWjzPztGM0PINQwhH7Wwk
	m13aOg==
X-Google-Smtp-Source: AGHT+IFq+pkA9wUXo6O1YuyXrs06FlYpW+bNX4EgX0RqVurgQxcjqXf5OCpjt4Cav6Vv/IGQxFOOMXQu/61PgqQPYgY=
X-Received: by 2002:a05:6512:2398:b0:594:2654:5e65 with SMTP id
 2adb3069b0e04-596a3edac23mr5617787e87.26.1764092340301; Tue, 25 Nov 2025
 09:39:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121181429.1421717-1-dmatlack@google.com> <CAJHc60zkNOrWtzEPr00a6=fHpcW1KmGRu7Txcohe=LHnS6OL_Q@mail.gmail.com>
In-Reply-To: <CAJHc60zkNOrWtzEPr00a6=fHpcW1KmGRu7Txcohe=LHnS6OL_Q@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 25 Nov 2025 09:38:33 -0800
X-Gm-Features: AWmQ_bk-F6GfHzkfFixwREJH6feckFCzraz_YXkqd1eUKsaSXAISX2Opcpq0vY0
Message-ID: <CALzav=dMsiA+a3ZKcQmrYhV+nZvFVUTKifEs2U7hsxVmVWrL3g@mail.gmail.com>
Subject: Re: [PATCH v3 00/18] vfio: selftests: Support for multi-device tests
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 3:20=E2=80=AFAM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Fri, Nov 21, 2025 at 11:44=E2=80=AFPM David Matlack <dmatlack@google.c=
om> wrote:
> >
> > This series adds support for tests that use multiple devices, and adds
> > one new test, vfio_pci_device_init_perf_test, which measures parallel
> > device initialization time to demonstrate the improvement from commit
> > e908f58b6beb ("vfio/pci: Separate SR-IOV VF dev_set").
> >
> Apart from a couple of minor nits in patch-6:
> Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>

Thanks Raghu!

I'll send a v4 addressing your comments and the kernel-test-robot
issues on riscv and i386. And then hopefully we can get this into
6.19.

