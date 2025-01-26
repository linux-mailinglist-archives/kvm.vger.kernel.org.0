Return-Path: <kvm+bounces-36615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A291A1CD75
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 19:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78CF6166B62
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 18:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAC415A856;
	Sun, 26 Jan 2025 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YGnIQe76"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903ED282F1
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737916478; cv=none; b=e3279SkJAkSnj2O1R/+1dEpfKqEkN0HUltk2b3IV7S3LvdS97ZSY+rhkewtwTIfbqA2NtM2Mxos3KZ3M4H4MbKWZHE9rIW8o7i6r13MlhZv5bRosi3/A+M0MzVkXGr8hm5u2xkoib7h4DxwGTlu2TNYdnOmxnyS7IgNbfFyhaCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737916478; c=relaxed/simple;
	bh=7HyIi85BfwqnA0QFh40UxREJkDfzUJ/f4nbJc3BsON8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gGJp8pRMU6cAgUfnAmcULQ+kTo/mVcNe4B1EplRjzXoh755Mv/78JQHPZqEdqpJLzscnA+do91y0vPftrprhojM8UG9pG7Ma/pQRldbJD7uMmVr/ppcaOsACfTsJZY8iIek/AiJ71lKERAG+YJZrmUVRvJING2ovxsaB90elo/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YGnIQe76; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab2aea81cd8so695257966b.2
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 10:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737916474; x=1738521274; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7wzfV7iMGCy036Srv1zt2vwBLuCR6xNPDIO75MMr6k4=;
        b=YGnIQe76sCYuBBI+uei9jlRmd2FkLu5o8rONan7ouFO7MOGoIgEud51L/QoDllfKy5
         vDS/B4GOMX4nuRr3M2XTGbmy1ZCTzx0CdDNk/IS+Fux/+ef8d8jgNbYoX+o+35U1oAKs
         aSocKwps37+/zTDs/LSUllih+bryIGGn9RpYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737916474; x=1738521274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7wzfV7iMGCy036Srv1zt2vwBLuCR6xNPDIO75MMr6k4=;
        b=o4kH4GL4F/btYryU+A5GZFv/yFiCCpjv0+9wJv+uAsq/338IMlxNVrnPxnNDJ+xh0V
         06A0kP0ds+h56qsdFu/NukKicRei6fz3zYHDbZN+/mTqAP3CVtHEwkA9J0e+Us5ZnKqP
         gxGe+WkMUjmcMbkDYLyJ/SsM4cTeOO+PNxUIRAtre5kDsCHMoLy8FBtr4CtXuXc58LBD
         SsSzgFC+oOYweu4sbLyIwRMyaNzvoRQhhXg1U3NEiGk8Nxe5d+MXk3s4fBbX/Liji8lA
         tpjCZ11mPdEjfshVNfwH8wf1RzFMR/xyo2fDyIiuQZxKm5bF5pJxrtY0p4EdPcbSPVqo
         BqYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlkkh6/x0wf+4KWvgLCKl+jtN/CKDHDFeyAp4T7A6OXHv1+iLwrLMXAMt5BlNdIf8PhgM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7hdgTCYPrYtI8IeeFkpxn9hs0SBRSpIUtxvL6/u15CCaGq7NO
	sY3amX4L6o6AH8JKuOj3UvS1m02wzZgznLb3QROok1jeLRz5zK7bNkCn5ZfBV+sJAAiiIHOPlKM
	q+k4=
X-Gm-Gg: ASbGncul0gs4mEOWeEOeTbqYz8ej8eAb6ttZVEtSJfhkAdtSkq2NJOBbmbAbFoZn4/t
	CPaJ+Akf2kKxe2+vljX0TDBSlcrvJjIVk4I4h0cPP9SPsjT8lX8tmaRdW9zl4AOgDlGAa/JeJTf
	1CB7g/vgBYBDtZrUsTOiL+vPVq7fma+SxGUIIwcfC7g9Ic7N5h4XQVOpzNG5TlIrktH8TszQbPy
	tGR6umc023NcjPXlpLGWhuLOsUzRqH+4uea4k1qZ+6miu/iIw9B7R/s3A0XpZSg/pBgjNA5Ctgl
	uH5e3ZPp2SM983PvLIUTEw4u7TpDvTfY7Hd2c8zg7kI73GqPSpI3EO0=
X-Google-Smtp-Source: AGHT+IFdE30vGMsCH2qQJFy5M/Zc6PHTLAqUNG+ioUG4dzT85yRWdREA0WOQyJeq3Ono9wDXBqfQgQ==
X-Received: by 2002:a17:907:2da7:b0:ab6:5413:fb14 with SMTP id a640c23a62f3a-ab65413fbcemr1948719166b.38.1737916474628;
        Sun, 26 Jan 2025 10:34:34 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6760fc2ffsm463774366b.147.2025.01.26.10.34.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 10:34:34 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d9b6b034easo7414673a12.3
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 10:34:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUHLua7N7GcClAj9MjrIxBWneCdDZiSsO+mR7pd5x4k4ZiQ1m0z+oiUZ0PPVilDmQ4Ns8o=@vger.kernel.org
X-Received: by 2002:a50:a696:0:b0:5db:efcc:c19c with SMTP id
 4fb4d7f45d1cf-5dbefccc1b8mr14306181a12.19.1737916473113; Sun, 26 Jan 2025
 10:34:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com>
In-Reply-To: <20250126142034.GA28135@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Jan 2025 10:34:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
X-Gm-Features: AWEUYZn6jFvrGMOZr4bKfjogJYLhIC5e1Hm4tpc7Lw1vG6RONA_2YUhPDgNbqAA
Message-ID: <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Jan 2025 at 06:21, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Should we just add some flag to say "don't show this thread in this
> > context"?
>
> Not sure I understand... Looking at is_single_threaded() above I guess
> something like below should work (incomplete, in particular we need to
> chang first_tid() as well).

So yes, I was thinking something similar, but:

> But a PF_HIDDEN sub-thread will still be visible via /proc/$pid_of_PF_HIDDEN
>
> > We obviously still want to see it for management purposes,
> > so it's not like the thing should be entirely invisible,
>
> Can you explain?

I was literally thinking that instead of a "hidden" flag, it would be
a "self-hidden" flag.

So if somebody _else_ (notably the sysadmin) does "ps" they see the
kernel thread as a subthread.

But when you look at your own /proc/self/task/ listing, you only see
your own explicit threads. So that "is_singlethreaded()" logic works.

Maybe that's just too ugly for words, and the kvm workaround is better.

            Linus

