Return-Path: <kvm+bounces-26048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A196C96FEBB
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F33D2842B8
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAF3A94F;
	Sat,  7 Sep 2024 00:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L/ibXGMj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C265256D
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670113; cv=none; b=Lqvs71ejwzK/MuPLd6DCMEeR0dTKPq0ehuAifAsWetqlx5NXrSbcSXRVYH6gCpxwfgqXuxXMNrzNt04R5JU8Cbh86tHi9jy1vrP8mT7Me0o7AEcrr9pI1k9z0IQn883NQirHp0N6v6SO4OpWSmz2AeoJdiBMxRmPXNBQlslYfz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670113; c=relaxed/simple;
	bh=UFUaOWELgtMfFEsfIQ6vW+7mTZedBrO6HDqKObAmwFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=faw378equNpvSk9rLIqd1P6OM3v+oog1Oj5TgeVTbjtf44Mgqjs49FOZNJRi4yjYM3TRcr8teENjl1lJ3AhuyzqS9Iiu/ZSeVcLNxuVuka+aDNifmktjMFeFjq8zj20H/Ia03mpF+sj0A3WK2pvxovZy6/ysWUKrQ6QfvZJPudw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L/ibXGMj; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f75c0b78fbso1117421fa.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 17:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1725670108; x=1726274908; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8jlGegiEN/nXhAMG4ddyYE+bSxApyov+rlpPE1WvsoM=;
        b=L/ibXGMjdDwDdA01RpX6GtS1Hb0i+7/MCvv7kpDnJ9yHMg1pQM8wxE3LnT8ALPZtJr
         KIApI3x33cobz6HqaUWRkr3trILZ/TOfrogZYvp4IjBX/gXpg4s08gldifiz/UcFmtFr
         bwYctQth/DajBns6X2XPqNxufmUpUJFowWj8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725670108; x=1726274908;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8jlGegiEN/nXhAMG4ddyYE+bSxApyov+rlpPE1WvsoM=;
        b=AdY2CrfU3XB0utYD18GecNIl8V5NGN3VC/hR5uUMp0i6DzH+DNaGB7GdLy5UDRvVo8
         2BKrdwR3FsQI6nOWHM27GjA7QhuBLxAlwDvC8TkHYUQwZBW7zHj+IUe2h4WqQLo17evl
         nx9F2xpqWwAji7aLnCf7FOANaROkZrYHU0PKJKk+GzC8ESkENDrOOjrYW0dk/H6DwfJ2
         tZh19YqThMuCwy37FWONY/cIvqq4YOTkaHlClM/ia7f6ZIRtKq/iLTnY/QQrmH4nGT/Q
         gV65FI1VvhngWEqBIuqUi3r2HXe+uDv1DRAzU03yBjzEpch5HgN8LrJhtk8DFEDOLjcL
         3bpg==
X-Forwarded-Encrypted: i=1; AJvYcCVEj0qvpiEYrf2LE7AlkOPdvCEMaZFPb8L9LFG4dReu0Kv1CAcOTQvFIWEn0poG3WPIqGg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa5qqd/1lmblSxxm8YSkIOct9Dd1NcGS97l3QDPtxkefypPPVF
	WmSC+affyx23UYayCbK2c+6w5KFmOk6O7+XP0n6FiDwjCv8VW8r1IJnjY5yzu1s94K8teA4NQX5
	WCIg=
X-Google-Smtp-Source: AGHT+IHnIP5cj7VGqpip1wGjO9eSfHEkN2HnDSMk662IDrvMFbu4FsH/3W/HYDEmLJSE6M/Gdrw4CA==
X-Received: by 2002:a05:6512:1116:b0:52e:9b68:d2da with SMTP id 2adb3069b0e04-536587a35d2mr2563614e87.9.1725670107838;
        Fri, 06 Sep 2024 17:48:27 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5365f8cb76fsm9605e87.177.2024.09.06.17.48.26
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 17:48:27 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f502086419so32295181fa.3
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 17:48:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXKEHH72QTBExyCF653N6rqX7MiU1tF2kR9er+PN4SpopofCzE6chuaMDsq+W0RzL6k7s8=@vger.kernel.org
X-Received: by 2002:a2e:6111:0:b0:2f3:e2fd:7dcd with SMTP id
 38308e7fff4ca-2f751ea7abdmr23935841fa.6.1725670106422; Fri, 06 Sep 2024
 17:48:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240906154517.191976-1-pbonzini@redhat.com> <CAHk-=wjK7HF3dQT8q_6fr3eLGvKS+c46PdYNVAsHRyQRgcgiyw@mail.gmail.com>
 <20240906233958.GA1968981@thelio-3990X>
In-Reply-To: <20240906233958.GA1968981@thelio-3990X>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Sep 2024 17:48:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi0ePNgwLfk8yddABjnZh+gcL9dV2E8mxLKfb=8LHFQ-g@mail.gmail.com>
Message-ID: <CAHk-=wi0ePNgwLfk8yddABjnZh+gcL9dV2E8mxLKfb=8LHFQ-g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for Linux 6.11-rc7
To: Nathan Chancellor <nathan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Sept 2024 at 16:40, Nathan Chancellor <nathan@kernel.org> wrote:
>
> This was brought up to GCC at one point and they considered its current
> behavior as working as intended from my understanding:
>
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91432

Their argument seems to be "the missing fallthrough has no effect".

Which is true.

But they seem to be missing that it has no effect *NOW*.

One major problem case is that people tend to add new cases to the end
of a switch() statement, not counting that final "default: break".

So the "it doesn't have any effect NOW" is true, but the next time
somebody edits that and doesn't check warnings, it *will* have very
strange behavior, and it won't be affecting the newly added case, but
some entirely unrelated previous case.

So I really think the lack of warnings is a gcc mis-feature. It leaves
code in a bad situation going forward.

Oh well.  Many times I have had to disable warnings entirely because
they have too many false positives, so I guess the occasional "doesn't
warn enough" is still a better problem to have.

And at least we have (a) clang warning about it and (b) require the
warnings going forward and use -Werror, so at least for the kernel the
"when somebody edits that code, you get surprising behavior" case
_will_ get noticed.

                 Linus

