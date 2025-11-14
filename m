Return-Path: <kvm+bounces-63240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DDDBC5EAEC
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 39B674F87F6
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1199347BB5;
	Fri, 14 Nov 2025 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rb0DIDpw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683833446CF
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763142504; cv=none; b=SyxxxdyX1oDDJ+i5yK7g/zjsnJRyp2lGe49MBm1MPwZPjz1LE1d5VhTeExwIkVLeAT9FOg4xfNqmGm1FKp4QeLdUyz/48UtU0t2bg2IwlRg1a7OjtfqvBVjsu7JKnci/Mke4W3DiGf4Y73WvkU1YsEw8L5rDzvRU8DXMvdC/haw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763142504; c=relaxed/simple;
	bh=M3lRJLmEZ7JGwWTvf6UoV64DNFaFI5lqaxXQ8tgqiIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=onJ6H7MQurNz40wxb9ooOroRsKGAoN5/qLX3DjXxqA8sK4e2l6reKR25qKFHk+ikdDelIgbUklrmm9uPL3ECdEtRjGbljnFV6Tlfj2rW0+eMTsQL1SV0mVoLDe/pADhiG2BYBBRFUeWbgI5r+jt2BOvQWfkouMQgTj+E9F2qnYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rb0DIDpw; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so365062566b.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 09:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763142500; x=1763747300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zg7DjlCq7wS0LcCCJEhlzHEukmpZjrkwro9CVQtSZwo=;
        b=Rb0DIDpwklbLQYFDjYQo8wBKZ7R4t6Lt28tfOx7AlVJ3XcE+sUI/KwSG+XZLPbixiR
         U4TNgFO3Ec1fh5jsI6DSxYkAm3FcswDm4DtIYx/HTw5jiCihP4CR21ULKbhe25eIiBOI
         LVO8WzEVdPtEfyFB6FdIWhdEcCtzLPP6p7ITQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763142500; x=1763747300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zg7DjlCq7wS0LcCCJEhlzHEukmpZjrkwro9CVQtSZwo=;
        b=gKCnzG9YdwscG3zlKIfovVzSC5MNrCooDnXku6w/74GDdXlJMRQCmD6Oz5QTHDmhwk
         sB9+7Bkkpg/1pg7ObE5oK/4PfFy6VKvaDkmz0bZY2I5bcDKw0kSzT20e8hPckYMbeiUy
         kk2sdxxU3j+QM/8OUdZbm6Ie+fe8QT6B7yxK1rBzPynMT/Fo3xl2O0EFl0WK6ot4vRmQ
         LBHfAU3Si14AnYP2eeA9KnZBYuvDM+AQA9hKNkhULd0egDStymZlPNsHLMnbFU7x5r03
         r+lTZOdFg3M/TXp7rAGmWUpNIVLZ0B52e+O6+Kvq1bNLqVbdOyLpG6xLYAGHdcw/XrZk
         7gig==
X-Forwarded-Encrypted: i=1; AJvYcCUxq28xQniixv19qHbdHCqNK/0IMiAXTbIUiEzmGsNVRyiqBTjy6fw/ZAK/Y+1iuIVH49Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsM2uaVU1F2nXYS9Wdk0oehWorEM3dZtKruwPGUGXgLxD091eU
	Rdvf7bMrm+gv0Lsub4baESuMKWjaLkIFH01y8nfTwJh+Z5equ7SAcCoY8orc+DOjbe15C4OoU5g
	QmZWAsoM=
X-Gm-Gg: ASbGnct1ORS6Tfl+Gh6DI7QId1ImueULya712o1hKbv0k2SoyvbDjK/ghwUieUgaDb6
	lvJzQAhzvOH9mC/BifbEMpVwhyQTfcSoP4svkshtZqsV1pDCfJQcDmCS9S0qAECDpBPsFHEW7De
	zjmXIH6tiqey3BEV8NZBViO3LWMIdx0rLcf4SdYLVBhQtA34EaSkW4WNpQk//ZVGxSYRgzrfwDP
	mxjKm+BeGuqPypTQwJu/0ZvyWQtqwkq/psD0R+D89Mwrh8Mhy1SjsK9G4+qteAw/ITrGDHG3YWK
	guRnY7BNdOwFFq7lURCYAsTlYVmuVSSd16B0woc1MhkBzfWky6EUz9zdfxkUx+qzxgorV5OxmCe
	w/UxMmd141VkYKV6nfDhAubIA2CDbq1v4Z7YzguVanfwZBC/1+bxlEBhgm83W0FxVhGcMdx4atw
	zJ9jf1NEIBMsIVqbQpjVF4ZQMuaOViXIX2+AEcM4zSH2ykavpWwA==
X-Google-Smtp-Source: AGHT+IFpCU6uCCRFmIe2cBCsRyEr+H+eL+uGiUFlnpYC3Q3L261u5vtLHY2ln+U9/ZsgHWb3aG8kXA==
X-Received: by 2002:a17:907:3da5:b0:b40:5752:16b7 with SMTP id a640c23a62f3a-b7367bd14d2mr414732866b.51.1763142500300;
        Fri, 14 Nov 2025 09:48:20 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fed90c0sm431631266b.65.2025.11.14.09.48.18
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 09:48:18 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6406f3dcc66so3949984a12.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 09:48:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVaIN+k57nNRH8QScgnl8P5reY1+7/YWZHq86DClXDYNUAL3lp7zJOAqMPvzytkbO1FCKs=@vger.kernel.org
X-Received: by 2002:a17:907:a0b:b0:b72:5e2c:9e97 with SMTP id
 a640c23a62f3a-b7367b8b6bfmr305496966b.36.1763142498394; Fri, 14 Nov 2025
 09:48:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113005529.2494066-1-jon@nutanix.com> <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
In-Reply-To: <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Nov 2025 09:48:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=whkVPGpfNFLnBv7YG__P4uGYWtG6AXLS5xGpjXGn8=orA@mail.gmail.com>
X-Gm-Features: AWmQ_bk0jgyM9fIRt_Ee0fGAZtYocBkhM5AivJHg1mQmAcGyfeiZb7v3Ov-HW6k
Message-ID: <CAHk-=whkVPGpfNFLnBv7YG__P4uGYWtG6AXLS5xGpjXGn8=orA@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Nov 2025 at 06:53, Jon Kohler <jon@nutanix.com> wrote:
>
> > On Nov 12, 2025, at 8:09=E2=80=AFPM, Jason Wang <jasowang@redhat.com> w=
rote:
> >
> > It has been used even before this commit.
>
> Ah, thanks for the pointer. I=E2=80=99d have to go dig to find its genesi=
s, but
> its more to say, this existed prior to the LFENCE commit.

It might still be worth pointing out that the LFENCE is what made
__get_user() and friends much slower, but the *real* issue is that
__get_user() and friends became *pointless* before that due to SMAP.

Because the whole - and only - point of the __get_user() interface is
the historical issue of "it translates to a single load instruction
and gets inlined".

So back in the dark ages before SMAP, a regular "get_user()" was a
function call and maybe six instructions worth over code. But a
"__get_user()" was inlined to be a single instruction, and the
difference between the two was quite noticeable if you did things in a
loop.

End result: we have a number of old historic __get_user() calls
because people cared and it was noticeable.

But then SMAP happens, and user space accesses aren't just a simple
single load instruction, but a "enable user space access, do the
access, then disable user space accesses" for safety and robustness
reasons.

That's actually true on non-x86 architectures too: on arm64 you also
have TTBR0_PAN, and user space accesses can be quite the mess of
instructions.

And in that whole change, now __get_user() is not only no longer
inlined, the performance advantage isn't relevant any more. Sure, it
still avoided the user address space range check, but that check just
is no longer relevant. It's a couple of (very cheap) instructions, but
the big reason to use __get_user() has simply gone away. The real
costs of user space accesses are elsewhere, and __get_user() and
get_user() are basically the same performance in reality.

But the historical uses of __get_user() remain, even though now they
are pretty much pointless.

Then LFENCE comes around due to the whole speculation issue, and
initially __get_user() and get_user() *both* get it, and it only
reinforces the whole "the address check is not the most expensive part
of the operation" thing, but __get_user() is still technically a cycle
or two faster.

But then get_user() gets optimized to do the address space check using
a data dependency instead of the "access_ok()" control dependency, and
so get_user() doesn't need LFENCE at all, and now get_user() is
*faster* than __get_user().

End result: __get_user() has been a historical artifact for a long
time. It's been discouraged because it's pointless. But with the
LFENCE it's not only pointless, it's actively detrimental not just for
safety but even for performance.

So __get_user() should die. The LFENCE is not the primary reason it
should be retired, it's only the last nail in the coffin.

             Linus

