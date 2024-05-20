Return-Path: <kvm+bounces-17805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE608CA4DF
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35EA1B215D6
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD78D137C21;
	Mon, 20 May 2024 23:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lu/DKLuY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606937169
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 23:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716246575; cv=none; b=uQxJDGbHWztAeWySSy+0uttGirFDWRA8mM8+lcNKbZ31m+6wnzVdwTOkxzhiPz472Acj1VYnQtsuFTrhkWc81RK0nLJ5vJILnn5fhIZZYDDGDlLdcG16jdN0hO9zG8olw2lCzGbBzf+CbCXk39SuGC2lQkx2ROiRjSELDsrRzOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716246575; c=relaxed/simple;
	bh=oURIQ8GCHpqOqM5pA4QbJ6dnCOCQctIKVZEaL9xBDAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cDzX+yMMV6/0b7UyLeYBCacgoeV8KfzrAoHSUGJs/s0HsVfYNIEow7pBCtmDlB1sxXcvfYmWKmayeOqUvWJ8B6IOI36texBtToqY+G6WTiNOiMqiYpYPYPQaUifWMbgbEPgz8ChRL7vcZaIm0Afd6UtoqwqTut8iXF+aW+PvpNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lu/DKLuY; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-572c65cea55so13045212a12.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 16:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1716246571; x=1716851371; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EvM0FitcwUpr4p4+bW7JYL4NlfErVMc9GVAB1zbL7e0=;
        b=Lu/DKLuYjOPTR1jQf3YIaSgHxl5YhlQZd4RniEtAH4v/d5R/dChbb8j1f3XtOzlBWl
         LGVlJ/QrlUDrMNqmHvI4ptmj94HW1OjkvDigB47L/j5ZxtOwC5Ntro/eBXcd3HvPK2Jq
         p9jhw3cJE4p0M8im2KSNa+pQl1IxcK9ysMT1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716246571; x=1716851371;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvM0FitcwUpr4p4+bW7JYL4NlfErVMc9GVAB1zbL7e0=;
        b=HmogNJ72Osxh2Z5ZQ6VXpge58RUdmpBsPsh24E471YDj3OuyryVQ2hMiMfjy+80LDE
         RLQPQyMpdzNiZ0Wi5k71uSjPLnSqGQQbKVOCVte8zNt/YAJAb3tlQyEvPIG/xJ66rRef
         mBx6OdsBILwI4RvZI5GyMuk7VzUv1NdM03z0qS9gB4GfD9Agm08heVn4yIbLlidt+F6a
         VSNh5dyH5pM8M+wGbxh4WBZuUPf+GZ+F76lJ6KQRjryD8bOE8Iojx9GXIMfxgr5WKrgy
         F7Rs+dF4iXY3ZQGp3DbYocvgDhYq06j70h7cBZZ7lbU3KUXTvC+8v1yReAa9Y8p5LWCf
         vtQQ==
X-Gm-Message-State: AOJu0Yyj/YbXb/xexEPRRkM+57gZxTE0g7xE72w90b3+VKmteX+ejbh7
	P/kYjU3g2V6HfQr3gUnKoeokpyhyBzU1j52Ox0dP4b0v7AqKqWWhRLjxSBxWFIjMuQ1yn7H6+vM
	7tih1fw==
X-Google-Smtp-Source: AGHT+IEtuuzzPDEKgaSEfIAxbmmvFqno1kv7aX/r/Gnn1zai7G08ncfA3YeZYoB4rYpO5+d/zrSzTw==
X-Received: by 2002:a50:c092:0:b0:56e:7281:55eb with SMTP id 4fb4d7f45d1cf-5752b474748mr6024046a12.9.1716246571407;
        Mon, 20 May 2024 16:09:31 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733bed0035sm15596723a12.50.2024.05.20.16.09.30
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 May 2024 16:09:31 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a59cdd185b9so1199128366b.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 16:09:30 -0700 (PDT)
X-Received: by 2002:a17:907:110c:b0:a5a:24ab:f5e with SMTP id
 a640c23a62f3a-a5d5c824bedmr702435466b.25.1716246570519; Mon, 20 May 2024
 16:09:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240520121223.5be06e39.alex.williamson@redhat.com>
 <CAHk-=wiecagwwqGQerx35p+1e2jwjjEbXCphKjPO6Q97DrtYPQ@mail.gmail.com> <20240520170309.76b60123.alex.williamson@redhat.com>
In-Reply-To: <20240520170309.76b60123.alex.williamson@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 May 2024 16:09:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjGbNWK6aOcprocyO8qLySpzJ5-eZzC3if=gb-Fh8NsiA@mail.gmail.com>
Message-ID: <CAHk-=wjGbNWK6aOcprocyO8qLySpzJ5-eZzC3if=gb-Fh8NsiA@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.10-rc1
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 May 2024 at 16:03, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> Sorry.  In my case I've looked through logs and I've seen bare merges in
> the past and I guess I assumed the reasoning here would be more obvious.

Yeah, the bare merges in the past is why I'm so frustrated about this
all. I don't understand why this keeps happening so much.

Who do people keep doing this thing where they just think "I don't
need to explain this thing".

Yes, git made merges easy. It was one of the design goals, since (a) I
do a lot of them and (b) it's what EVERY OTHER SCM historically
absolutely sucked at.

But just because merging used to be hard, and git made it so easy,
doesn't mean that people should then not even explain them.

I complained to Andrew this merge window about one of his pull
requests that had _seven_ pointless and totally unexplained merges.
It's like people do this operation in their sleep or something, and
don't think about how big an operation a merge is.

            Linus

