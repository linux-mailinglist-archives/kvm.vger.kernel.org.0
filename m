Return-Path: <kvm+bounces-8715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF141855833
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97A742838D5
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 00:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8C9A59;
	Thu, 15 Feb 2024 00:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E0q6o9GK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548F4389
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 00:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707955888; cv=none; b=BvEv6GyR/5ewXqROjuAeLb1CpFcUtKcTpFl1Z8AQimzEE602OhrikmD5rQc3n9EjNkZl1Ixp3d0bFcn/zfCmrm1S16RyiEC/jvxlysOIKSwg/UmBSXss2v4S7k08QgGO1j34AirTnNQCW4Z33iRffdgGeDNH3n41K2Emo/RDc34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707955888; c=relaxed/simple;
	bh=hRCP7gBFnl/HDed1cL/TYrjYSDbAQpiyFpJfDJmsQfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IAW86RI0ESWZazGvsKITbX55VhnWAn/9nOQdQ/j87XGWBqhBxdQSVTllA2aQ7OovvDNYnMkKcu3VpKRrE/7epIS8gONzL2JhIqmrO8+yRayXRjBmtAXGrMCK7B48R/HXJTfwhorlPAOXIJp2gOgUXfSSGPmM6Ik38n3/jtMXIeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E0q6o9GK; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d107900457so4162821fa.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 16:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707955884; x=1708560684; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KiWMSqa1rWu/QozNlk3ifbqgQzvZnPWJ/ZDgt8vzqpE=;
        b=E0q6o9GKZS31CAXfMcntajwTJeInpeJRfWDa69K2CmwPJls709NFSsIOPODUyR51rV
         2nZ7bv9Ak2xP0f59PpaGVk2B+d2gs5V9QanHmPF9JZ71PxrnIKcWS7rClWClURASi7wB
         lahSP2JN0E5+eYRVnpeIoegiFGY4DMdFra55k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707955884; x=1708560684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KiWMSqa1rWu/QozNlk3ifbqgQzvZnPWJ/ZDgt8vzqpE=;
        b=hpgduT/H9wUmlF+yFRj0vqfjYhzm4wF8ePkdOmZTz+OXh+DjZy2HuTXbZXUhyW1D6g
         kaw2P+7s1Imgt5LsRc1a+636P8xq2kyt4HYILKYFNlZE83kVMgSSIQu4xtIkaZuLB6NB
         JqTWjzbGzVA1HtZ3ezSzH6x8PQgV0Kl1huslfUr9vuHQGPvuCMzru7CN6P1usfezihWi
         0LtMStsHNamnSQKYpnLPe9Kck1KYEqvgOEeER++VWOPfZfp5KRLoy2QrFM7THfg1hPzR
         w7m2xucGk03Bjboe/Dfv5zRTv5g4gdSqclnIeHbcfGvvBcTqDSE4AYLeo3TG7JW2B6PT
         kFsA==
X-Forwarded-Encrypted: i=1; AJvYcCXyk0LulSpYZXO3RqaF+DUlAitr48m1Id2ai/OsCt1YRxSR6Gk71Knq7n335jQoUbB0Giykqj85AF56O+/yQzByHE8N
X-Gm-Message-State: AOJu0YxYItwN0PE/80v5ztd5R9gQJ8XQihZstJjFXaUBLZttXnmBXsto
	f4lwtogk9VwBf9rVH/LOfDC4yLHPDOel29c19BYLrGbiUDeiDBofd8thgh2eY5xF6mGF0XHYxHp
	IDQpNeA==
X-Google-Smtp-Source: AGHT+IF5nx2zc7cc6ywfJtjbJFEuj814+FIKuvIYKkPaG/thShYJ0JKy1H0bKODUQQzgR8X1qAELBA==
X-Received: by 2002:a05:6512:535:b0:511:45ec:a17f with SMTP id o21-20020a056512053500b0051145eca17fmr204973lfc.40.1707955884216;
        Wed, 14 Feb 2024 16:11:24 -0800 (PST)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id i4-20020ac25224000000b0051156fcce6esm14754lfl.238.2024.02.14.16.11.23
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 16:11:23 -0800 (PST)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d0c7e6b240so3850891fa.0
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 16:11:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXMaDSZYJC1mVjMff65dQg7iKba4IHAGRbu7EZnv1OhNrBPG6aentkPkmBH9FCZnQNHWGTPRN5ZO+RzhmfjkwvqdHQH
X-Received: by 2002:a05:651c:1545:b0:2d1:1e3c:5736 with SMTP id
 y5-20020a05651c154500b002d11e3c5736mr128925ljp.32.1707955882632; Wed, 14 Feb
 2024 16:11:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com> <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
In-Reply-To: <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Feb 2024 16:11:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh2LQtWKNpV-+0+saW0+6zvQdK6vd+5k1yOEp_H_HWxzQ@mail.gmail.com>
Message-ID: <CAHk-=wh2LQtWKNpV-+0+saW0+6zvQdK6vd+5k1yOEp_H_HWxzQ@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Jakub Jelinek <jakub@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Feb 2024 at 10:43, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Based on the current state of
>
>     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
>
> I would suggest this attached kernel patch [...]

Well, that "current state" didn't last long, and it looks like Jakub
found the real issue and posted a suggested fix.

Anyway, the end result is that the current kernel situation - that
adds the workaround for all gcc versions - is the best that we can do
for now.

             Linus

