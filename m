Return-Path: <kvm+bounces-53857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA84B188CE
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 23:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA4FB7A40D6
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 21:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2464A28F524;
	Fri,  1 Aug 2025 21:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZJk/CQkN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672EC1A0712
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 21:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754084078; cv=none; b=en+0265tTuGOb0lil0LPrliwdaO0zniOpzF0ytkXbXb9CVSGUuHXL2ztjYYsuP4v/zqr5Z+Jg4ewpw3u5JLvcHEO4wnto1KaL0Z/mIM0SfbHKKk5QwUh+7bhWk4UwhqPWXWUC/mnpzqH+x9/MwPZQWROtSdZoDExK3f+r75h2vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754084078; c=relaxed/simple;
	bh=IZkwXQkh8YxYF6KhegHig00grekwiuruDFNARhibles=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T1Nq8AJvu1iqTLTT5YtD7B55+pG5Rjg6Bzt2JY6awfgkvmRIwtFdOlKhZpMg6PPRNB4kz5zLIoSDL0MZQI/zhhjNV6cbbvakHGMPYa66VJLQa392KP3dnAbENpXAFFzFlqRdpPdZbI5rraMkzVkqB0JtaspIakMF0yP1W/xmqHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZJk/CQkN; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-af93381a1d2so188483366b.3
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 14:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754084074; x=1754688874; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WLFHL6fOZFPNrc7teT5UWCBGBPE4FkQnF2Ru0J7QGa4=;
        b=ZJk/CQkNn759zW48a2JZ+wnGAeFYF/65D4MSSLPZwRDZrb4H2z29VBipHbl/UpS9qM
         zM/NJ2LyQta0RPM94ipgCU7SJ6pKOHzTcl10VrKjt9Tua628qDUKWg7ZiVjYmaEZeSD6
         +MdGPgCmO1YSZCIMlC9v6WH/bJ3tyyR2voquc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754084074; x=1754688874;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLFHL6fOZFPNrc7teT5UWCBGBPE4FkQnF2Ru0J7QGa4=;
        b=fJMZH6uKL3BfxuT/CwTdSLf67ron4UG4rRNIwnztf/oUV7ynUtXt9BwEXe+4XK1W/F
         Y1YwGX0FjK2Vi6QRwrPgfbyf5liikr09j99R0sQEAP2DpjaSnYnDEZBajBbQTfJVQtBO
         qVTjPXoCAyGzmcU1Wf77jbWYWhltTp/DtIX0oBe/1R7AyqgT02NXN+WvyV7MeZ6Tz+ri
         WixPmfWHQsM+TkD1wMnn7Hl4CSILSZcwyQg7kn/hjwNOJycBUy6LPsnT2nSjqnZhLliR
         9ny7stFX/pn1tfcXKc064UXylptUOiAGLyMVcBpHIs11sPGlFq5XKZsMD0LhNDn4Z6PB
         x6aw==
X-Forwarded-Encrypted: i=1; AJvYcCWElH+s9XvB2IPURJoL0+c2JCRs2mInNEOPUFOSv9uVm5Z6QRdtqIxAQ61U52PttFS7Mq8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQp5cRrauK57kRR4itK7UsxOBUXAI/kpifCKrqOoXkP3OCkKi1
	gjAPQhQihoGvUqblvu6t3JNup3aQH/BzlC4GwwEIl8mYmaSJ/ZaaOMjibQSEuPEGLPLzWPle6hP
	nrMXaeRw=
X-Gm-Gg: ASbGncthpMTVjfE8dYjbHVl5neg3mW+VxifqmVJ773SLxiNxZ6J3nAvZf87rovZrnLh
	mds8tSIuvM2OfdzX/Uh0FEHlWzgFQNQq4vdEmiJSJnUOHwH7IfiQZNBmUC5+d0ng+2FedLIP/mt
	v/AACobfMb/EXJsshFMNyRbhEZgXem3Fif39Gq+/mWnPWwnyZSDksJqtqfSq8bAtPjsfWtOm799
	XUtOejMzaGGIYH0GqWGOJWawrweWDQs1H7nkE24bvB1h6Sc+QKUP9m8+FftxkmfxK1vPU2e2C3K
	sGaPZbrA33aLnrZx7H9W0OZKx9FgkKi1eGT4O2P93E0vtNXtxne0VUXNpWyMWHLow55wi9XpH6Z
	HDe0RGBw1whiK5Ywrvkke45KbDmYnqCH5ksEiXHLbtS2YiqVEcT3/2bmFzAZcCy7F83hkkhJf
X-Google-Smtp-Source: AGHT+IFBlFPQslrQULcVVih42VvNVh3bIhDsPLVRRaer64M936z21wqtjoXbNG2TdDlYSS7mPHGMuQ==
X-Received: by 2002:a17:906:6a11:b0:ae0:b3be:f214 with SMTP id a640c23a62f3a-af940032f88mr135558866b.9.1754084074584;
        Fri, 01 Aug 2025 14:34:34 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a243644sm341608866b.139.2025.08.01.14.34.32
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 14:34:32 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-615622ed677so3640160a12.1
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 14:34:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWvwp1cTilCNaVKcXG+wVA9GC/EDA0YHA/FZ9cJdG2eqV+MoLt1LEcuQLCbJk5g2hnE7O4=@vger.kernel.org
X-Received: by 2002:a05:6402:2790:b0:615:cc03:e6a2 with SMTP id
 4fb4d7f45d1cf-615e6ebec77mr689309a12.1.1754084072420; Fri, 01 Aug 2025
 14:34:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801091318-mutt-send-email-mst@kernel.org>
 <CAHk-=whgYijnRXoAxbYLsceWFWC8B8in17WOws5-ojsAkdrqTg@mail.gmail.com>
 <aI0rDljG8XYyiSvv@gallifrey> <CAHk-=wi1sKCKxzrrCKii9zjQiTAcChWpOCrBCASwRRi3KKXH3g@mail.gmail.com>
In-Reply-To: <CAHk-=wi1sKCKxzrrCKii9zjQiTAcChWpOCrBCASwRRi3KKXH3g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Aug 2025 14:34:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgRtKY+tk0mhnHzrC0YMXef0GtVUFQ6cGW0-4XS30mQ5A@mail.gmail.com>
X-Gm-Features: Ac12FXyaANs0webz-gagQ0r78-lvtho7QphOSO_s_LZu61Rm94DR5P3bHuE7Emw
Message-ID: <CAHk-=wgRtKY+tk0mhnHzrC0YMXef0GtVUFQ6cGW0-4XS30mQ5A@mail.gmail.com>
Subject: Re: [GIT PULL v2] virtio, vhost: features, fixes
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alok.a.tiwari@oracle.com, 
	anders.roxell@linaro.org, dtatulea@nvidia.com, eperezma@redhat.com, 
	eric.auger@redhat.com, jasowang@redhat.com, jonah.palmer@oracle.com, 
	kraxel@redhat.com, leiyang@redhat.com, lulu@redhat.com, 
	michael.christie@oracle.com, parav@nvidia.com, si-wei.liu@oracle.com, 
	stable@vger.kernel.org, viresh.kumar@linaro.org, wangyuli@uniontech.com, 
	will@kernel.org, wquan@redhat.com, xiaopei01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

On Fri, 1 Aug 2025 at 14:15, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> My apologies - they are indeed there, and I was simply looking at stale state.
>
> So while it's recently rebased, the commits have been in linux-next
> and I was just wrong.

Pulled and pushed out. Sorry again for blaming Michael for my own incompetence.

            Linus

