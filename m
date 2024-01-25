Return-Path: <kvm+bounces-7018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A76D83C64A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B04F1F2413A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 15:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B40745D5;
	Thu, 25 Jan 2024 15:16:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3366A6EB76;
	Thu, 25 Jan 2024 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706195805; cv=none; b=enX7TxHHWpH/r7bVhWyW8eDKJc//J2Nit2x0XTpYxH2GjHyfiSPhuBFwWyA4SnGb8uPFsQHuZNsoi4bIZ1fOIodRsR+HtPjX5juXff5r/Rpz1E36mfIn5pX6VoLk24hiHxAG9cMK6gaDCo1jV+aT2KGc7sWlHzfvhZzRtm/v4xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706195805; c=relaxed/simple;
	bh=ppQpkqkS5Pk9g2RveAtMZHsPA5svTY4M06OVIx8lVU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DpmuEZ8hRB1DU/i0Iw+wzROOuGgWhPGGVMJPZLiXm+lIT5Rj4NfRoSwI7A7Op9Xu2XCX4u2oVkDM7ucH07mW6QxUrN6P1Y5qCgHvGUDSWnnZEaiHVyWmwoBD2jQwJFZTpwms7u4Vypy82lFp522S3NoDbmcay2t9Zw3JG++pNIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-59584f41f1eso896319eaf.1;
        Thu, 25 Jan 2024 07:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706195803; x=1706800603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ppQpkqkS5Pk9g2RveAtMZHsPA5svTY4M06OVIx8lVU4=;
        b=XhclgRZeKJazbGk03RK1S+sOuxqRaIxNPpm/pfAUB2hm0KIxhRY5aMUceL+E7aeQwI
         wyJ2pTNfjtafBeRC92YQEb3t1UwT5mGAohiEpvadg5kRldU5oNxCm6zVG+MP/gj1wnR6
         VZi39SuJ/K9c3uyPHzba9VhkGUIzkWYPHN1bYd075r+KQaQszsOVqK1mvtr2pZg9mCv1
         00UV0JovdyvvBoYUaeLyrtkJF12Q6OD+ulyK6zQBq7eDE5RBqZWHXGdCXCi6YCpLyXVP
         Ezeqf4XC50swe6cRhrmJvsFMMbrZJEasXHpV8aau5OfJ7Z2bXWd2oEYI7MH8bEtuVxPT
         Al0A==
X-Gm-Message-State: AOJu0YwZjv6kc7C018jucQqJgQsxho0CIg9XO02gw+m+TjQcstBpl7+F
	vYZ4CILeQoQE2u+7AwAkGVHCv9+LJOgSBAbbbybh0wzr9dFgvYseU9jFxv9eKqNXjLsJyw+MowU
	e3E3mLqRjCCRhQY9kGxXO2YPwfa8=
X-Google-Smtp-Source: AGHT+IH8IUNVDZ3DGx4u1lJeFJmLJJs3jg2F+GuFGgcnqs9XT6iZ5JelvP0oePboWk5xd2R2jLiJYd7422hsG62DvZM=
X-Received: by 2002:a05:6820:26c9:b0:599:2b86:993 with SMTP id
 da9-20020a05682026c900b005992b860993mr1911512oob.0.1706195803136; Thu, 25 Jan
 2024 07:16:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com> <88356fdc-91f4-4f43-97a5-3da0ce455515@oracle.com>
In-Reply-To: <88356fdc-91f4-4f43-97a5-3da0ce455515@oracle.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 25 Jan 2024 16:16:31 +0100
Message-ID: <CAJZ5v0iPEuzwcko2gr+uprKvuGe48GgavB2Q2w3ZQ6E=Lg_g5A@mail.gmail.com>
Subject: Re: [PATCH v2] Enable haltpoll for arm64
To: Mihai Carabas <mihai.carabas@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, 
	Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, 
	hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
	vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
	akpm@linux-foundation.org, pmladek@suse.com, dianders@chromium.org, 
	npiggin@gmail.com, rick.p.edgecombe@intel.com, joao.m.martins@oracle.com, 
	juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de, 
	ankur.a.arora@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 25, 2024 at 3:40=E2=80=AFPM Mihai Carabas <mihai.carabas@oracle=
.com> wrote:
>
> Hello,
>
> How can we move this patchset forward?

There have been some comments and a tag has been given.

Update the series (to address the comments and add the tag where
applicable) and resend.

Thanks!

