Return-Path: <kvm+bounces-8814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 390FB856C86
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E798D28A9D7
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC8613DB83;
	Thu, 15 Feb 2024 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UvuFojgp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1E313B797
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 18:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708021562; cv=none; b=HkwdAJSuiNsbSsZ15gZBsXxTLr9fiHaHWIUmcTDp4bILkdEx7rvVZNQ1YwDQxGzqSkTA7vPtKSXaEhEdUC3O0DXTObbLV6BqEtNuzGc3l0E9/iDQ7+sfcRXOLn6QGtf2ZAaXNZq7EXrkQ1x/JLR+Ezgn9SncjFYNn/fQWo3agb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708021562; c=relaxed/simple;
	bh=dk7nldjBHf2OhhUJm5xdgR4jejE5bUggZf5m/L2de8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nu2S2VAatnEs+eO+LthNgaTRf8cno7JRxLvYx2ktDeRlemPh/HIzNCcCVtE1FK2xb1J5zOpuw/pIgBIT0GtCBTjIYyy/wX8Iwk9xuzyqfZKTXqOaLL0hH5utF0YNcV9yq6XTY8jfERIhLDlPzwEzwclCEDQqs6RwZGZMhyKMkW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UvuFojgp; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a29c4bbb2f4so157240066b.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 10:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1708021558; x=1708626358; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4sjjC6lYZHHWcZkiJkEdyU7XkS4SkECfb3ViIZBKdrI=;
        b=UvuFojgpGDzon1jaXXncRrR1K/inmN5F47fmMDj0OEahZ46CaEmLsWI4se1yMTbn/9
         8apXo1FPMHJ/tOMjh9Vn77DozeYpmJF5P9fyOWqwotWV9l+iI1T650k/rmfA5Uc5nlu1
         Q9ifO0JBQfu9dodEWuXDVJHd9OgBdau2fKP7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708021558; x=1708626358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sjjC6lYZHHWcZkiJkEdyU7XkS4SkECfb3ViIZBKdrI=;
        b=NePpJTTZju8qN0KPOcH1K92ko8UMFUbiyaCrX5lFM4LFQpXs51wm25L401M9zI/YcA
         Orf8y1AWt8rGMYMEunD4GY1CtZP84jefmFvReba7TDP+Q1s0oPOj3qG3wYlSQOpRPivd
         SAAj5fD2vb0jc828+YS2jRuxkvfZalYWkiw7c7bC8QcYk5gpL2q3Y6KDLCsA8sqQkdLv
         CyWUVloFnyy/+btXAr2sUVhLohFIIC6yccJeSFiCDJD1e6U1LJR6Vd78lIPRr6AkMdF1
         WcVtwk+TveMBYDFHCH19fw5SWFaIi6iMRsyHyR7fFwZVfCv2qPkSRgD8N+VcEJfOwDtY
         qgRw==
X-Forwarded-Encrypted: i=1; AJvYcCUDDYm6AfhE49hecsH18hIwvTyZEO02x8JuSqnsmt/TEQ5JrIqqtZEZ9aLakLxA+gPNJD4/IRxgxkV0YhyHCOxH/7zp
X-Gm-Message-State: AOJu0YyMYr3uHg9BZtIskvqjo9QcFTrFcq+vWvdbUQpWJABbK6ZPMk5g
	1Uy1tZu6ZRGPimaYPeBwMswOwDLjJMxiZcXJpqfKX6dAvTM1FuMOBAeSmxU5Fr8oTcrRCLStMz4
	T1Sg=
X-Google-Smtp-Source: AGHT+IHJ9I27hVM79a1MCjhuTuw4kkCxnlE94u7vefmzUoOCiDbR37pk5p1lQ/MYEAvJn7f8MIrSMQ==
X-Received: by 2002:a17:907:685:b0:a36:50fb:37ef with SMTP id wn5-20020a170907068500b00a3650fb37efmr1575930ejb.28.1708021557967;
        Thu, 15 Feb 2024 10:25:57 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id vb4-20020a170907d04400b00a3da3152c54sm623382ejc.78.2024.02.15.10.25.57
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 10:25:57 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-563c0f13cabso996698a12.3
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 10:25:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVYEdFg8UTuf5DmF6oMvwzxTmoXcqukvFG0y2URk6mNzroi9TFfHeEko8DzLKtU4drBnbNvv8vRvfuPL+L/Rp9/RpJ2
X-Received: by 2002:aa7:cf8d:0:b0:560:14c4:58fe with SMTP id
 z13-20020aa7cf8d000000b0056014c458femr1868778edx.29.1708021557034; Thu, 15
 Feb 2024 10:25:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
 <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
 <CAHk-=wh2LQtWKNpV-+0+saW0+6zvQdK6vd+5k1yOEp_H_HWxzQ@mail.gmail.com> <Zc3NvWhOK//UwyJe@tucnak>
In-Reply-To: <Zc3NvWhOK//UwyJe@tucnak>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Feb 2024 10:25:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiar+J2t6C5k6T8hZXGu0HDj3ZjH9bNGFBkkQOHj4Xkog@mail.gmail.com>
Message-ID: <CAHk-=wiar+J2t6C5k6T8hZXGu0HDj3ZjH9bNGFBkkQOHj4Xkog@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Jakub Jelinek <jakub@redhat.com>
Cc: Uros Bizjak <ubizjak@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Feb 2024 at 00:39, Jakub Jelinek <jakub@redhat.com> wrote:
>
> Can it be guarded with
> #if GCC_VERSION < 140100

Ack. I'll update the workaround to do that, and add the new and
improved bugzilla pointer.

Thanks for fixing this so quickly.

                Linus

