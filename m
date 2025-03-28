Return-Path: <kvm+bounces-42166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3401DA74231
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 03:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84A8E3BD9B4
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 02:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494821CAA60;
	Fri, 28 Mar 2025 02:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDrzyaAU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018C322094;
	Fri, 28 Mar 2025 02:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743127419; cv=none; b=RPc/s6JVdqOSLiGWhDHWt8AlmKErfLme+uazH+twFVjPfjYvenFXfDiFoROcfMjkz2RWGNugx0EJntGc0GrdCSal3e+8/EYrngkOiSSDijf6MEwfHTYCe9meTsnrbhZBABirflcIojj004+ICeLDBfG2uzD616vHkFEKU/i5B08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743127419; c=relaxed/simple;
	bh=v0xbqSPQQKaqZGLToyeLFsOvg4EAX8pOEEyfKlpu5EA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VRL6+IHixUHlP4UQbEvzE+di5wwGCAi2ubyEauQYHcKIZqd2J+H2gXARV65II4SLytJQgkEw+amRGCIsn8x3DS01CFaXLjhPzjmi+s0663tzYk6LgOTxG+jmX7eRtkqkrX4BtiJrBj6jJnEHVtFrnIjFhBSTVUgQ34LZgKYbD0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDrzyaAU; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e90b8d4686so14774386d6.2;
        Thu, 27 Mar 2025 19:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743127417; x=1743732217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0xbqSPQQKaqZGLToyeLFsOvg4EAX8pOEEyfKlpu5EA=;
        b=LDrzyaAUc0psw02B7YIfqdr1dsPTkA1z3atHaSSqLtQ6j4yFwcgpcasFPJmg5Eqbwz
         xFQ/1fjC/Fh5E3f63kmxyNv1dqUyWe4VLF0DdbsZ8xkL3W/dvehsZ6m3jkVdEtTsXCXi
         XebprXEHNnpuC9Q5M/IlQUN+5fFyW4H3oRZPZ0ITWcuookAle3Bawn3MraaYYMVXEaUq
         /LdGZ3jcdhzHFph1faGeVZGEqEbagXPN+ZvUUhhd+vEL24xjGEyB+pdecl63pg5h9n5+
         FOe51fZWY+bNeEXyTjSDYhQJUmQc1k2yLWOyBJK96GAgIhl5CiYXmmX4/cnjomak5B34
         9Vtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743127417; x=1743732217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0xbqSPQQKaqZGLToyeLFsOvg4EAX8pOEEyfKlpu5EA=;
        b=JQQ2XohQjKSNClHC5rKyYRxXcVDNVQFbdvpji3uvRHejBTm9GAb8z00bBDSVWYp5ms
         kRNlVLpLprcbN5V8Y1sMu1+//5r8F6Hmw9SxFB9wYGmBBXdNCOdHz2Pw60d+Wb2SdNVm
         x6Kjs2UYScccljwOW0tCMzS3SYKqFbZj1gIP8PptWjuxo3n0u5LLxXv3+cqBDlvTdyHf
         wu/g5tuKiYyFQOXj/fPHzy3SZcayTNNmM0wC3zhwmej0K/oABdPc7RYaz+qpMcmBvulR
         8H5DFpfRjBqjelkY1nuLFxzJ3KNvsdTIKk22sjqYx7yd+7YjEWl6F0tW2Ef5poJ+sKAl
         FjWg==
X-Forwarded-Encrypted: i=1; AJvYcCVmrRDFchcokE4Fvi+zblT+xQEVPajrsavxKLecB60slsRy3O6Eg56Io99UeBqp2MCRTXOaWWaY@vger.kernel.org, AJvYcCWwrL3HSJ3oOZl9eXjJ8RjKJ5huhLJ+uwtlx2+nF+QTFmnyCQc5i3nZMI6LFZHx/Ylisq+SrDT6U1ICCvA4@vger.kernel.org, AJvYcCX+hHSmxInev31HYaTYa1E5E/mtHmoBWP4vehDEkAwFPgHglbsid1f38Uc7J9Nulv72IMA9@vger.kernel.org
X-Gm-Message-State: AOJu0YwHhrfBL54xDcfyYrUd1JnZ7cHR1fXV+mCBOejZ/Kd0xtgSvM7l
	H5IH/yeIYFNRm2/27/rtSLIwhlV9p5ANvVqHe1TBIsbOVojagCKYHMK6Ye4RV4M3OYpFb7bmBeU
	DmIyYB/1eBr9zv5x9gtxgdp6ttbY=
X-Gm-Gg: ASbGnctnryGC9bSGNzHM8sx7C5h69JgS4Wipzt2NqPIXcTT8Rf/0uazNhvC/hRzaasa
	2m0oDVbDC5XTdtUGsmA3dBqQcioNFVFMthrFkwBvQcYcUFJXDy1DS09UbUYSw9tQeIlPtxW7N3j
	/hJDADZmwQS5/4XkxlXd0yABivk1Q=
X-Google-Smtp-Source: AGHT+IGzxGgAcBmkBhgOMEG8X4jJS/vZejCCvST2LV72DuHnUbw7QjxJT9lWLTlmVnO2ggUz5ByBPTpg1hW4cGhpEMw=
X-Received: by 2002:a05:6214:405:b0:6e8:f4e2:26e1 with SMTP id
 6a1803df08f44-6ed238bddc4mr84919466d6.20.1743127416723; Thu, 27 Mar 2025
 19:03:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250327012350.1135621-1-jthoughton@google.com>
 <20250327012350.1135621-4-jthoughton@google.com> <fg5owc6cvx7mkdq64ljc4byc5xmepddgthanynyvfsqhww7wx2@q5op3ltl2nip>
In-Reply-To: <fg5owc6cvx7mkdq64ljc4byc5xmepddgthanynyvfsqhww7wx2@q5op3ltl2nip>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 28 Mar 2025 10:03:00 +0800
X-Gm-Features: AQ5f1JoVOHztbYp2553_bmf4nlPgYHM1EgpaFVKxtX_C6dMD9jJHzJ1OMNJ7RsA
Message-ID: <CALOAHbD1iNJHB0XRK3GpHePpbX2Ti9vDT4aFDpay6PWUYg-Dcg@mail.gmail.com>
Subject: Re: [PATCH 3/5] cgroup: selftests: Move cgroup_util into its own library
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Yu Zhao <yuzhao@google.com>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2025 at 5:43=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> Hello James.
>
> On Thu, Mar 27, 2025 at 01:23:48AM +0000, James Houghton <jthoughton@goog=
le.com> wrote:
> > KVM selftests will soon need to use some of the cgroup creation and
> > deletion functionality from cgroup_util.
>
> Thanks, I think cross-selftest sharing is better than duplicating
> similar code.
>
> +Cc: Yafang as it may worth porting/unifying with
> tools/testing/selftests/bpf/cgroup_helpers.h too

Thanks for pointing that out=E2=80=94that=E2=80=99s a good suggestion. We s=
hould also
consider migrating the bpf cgroup helpers into the new libcgroup.


--
Regards
Yafang

