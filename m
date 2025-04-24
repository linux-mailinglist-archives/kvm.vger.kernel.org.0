Return-Path: <kvm+bounces-44224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAC5A9B6B7
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 20:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D6D47B5C60
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 18:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1E4290BCF;
	Thu, 24 Apr 2025 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylzR3I28"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2AF1F4CAC
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 18:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745520572; cv=none; b=uItJmz8p39KnIpbO4UAdLQ70TfEjoqGpHkxpQ8Knid3JAF09WEW175sh9R14j+XCA/D/xURNaKXSJjVMmrY7NLFwqYY1gIbmkU114VZ/a7NLTJn8+h7zSL4sdWp21UedFyHX2A4SRix2FLRvrCU3O1zGkUlvsynGOMSCDRQOc68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745520572; c=relaxed/simple;
	bh=YJThV8OU+yLTh48RfiUdm+OTToDHsoL5U/oCrdFEqDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tXmFutPtvODYt7eTJtcEsuJU0BPgB5tqD9U8CdU0hZQIqyI+h05rClVFOcpSdY67Zuf3vx8oYy613w8TVCdZLMMZTA6UkR++NeFkCPpF0jjeM7QzGWK6NhUG+JSvWLEorOrXqCYF2vWBJNpcY3ONYM7xxxWpog+oZPZYo7NPB1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ylzR3I28; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2240aad70f2so22985ad.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 11:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745520569; x=1746125369; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJThV8OU+yLTh48RfiUdm+OTToDHsoL5U/oCrdFEqDQ=;
        b=ylzR3I28/yHFuETRVx8TQjGviT85wGYNO9xhZfMuqph6DIlhaSNwaWlvkbtPK+qs6B
         ElMVBnjACjOFiHTrBVLwYd0Ca2Bvc55SIR11MRMKQdqC8pWDQ02LcBDNfeiyTRnZ5NNU
         VMrctS6S7a6mrVAt0zxIvDmckXP/ME542w8bOGeXP/yi/f+pdH6jDv3F/FZqfds1HJIy
         CmMS680r1gfHpGVYwT3Dpz2TINkurECqb7m/VPrDGvlHQ8N/F80q96LKwbu+ATbjBkLf
         pAIcJXHi1I9IhYCmVJiTMIOvpxgVkg4KgEzzvZCM1nspYuccVgdk/hS2G9SO+thvSb9j
         Wi/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745520569; x=1746125369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJThV8OU+yLTh48RfiUdm+OTToDHsoL5U/oCrdFEqDQ=;
        b=H8RRIzMFKMbQXWf+Bi6b44JsmE8ynV6fef4b7Q8ZfT6y7VKny+Faq23F1Zpub5ArUb
         eGds0ILQeT0fQ7NMe75QEM7l+Hqdi6Zi4NDXo1dqhbevvi4k6Mb8vfoAqYs47F9emBOC
         m8u7KpbmZ/JTVzGaNJBsauznlmRQtmeM763tzxcenZuFzTfdQoxAbx3psxRhy24031Du
         qWjpVGgV2QmJo3NLxnZ9BmyeGpXq8qQ0IKA79mHYu2pSS2HTN3ZPlYp2s8lZQM6FweLh
         WWcdrHEBTL7G4n9FLLHVuNVDNgO+ltr90YjaEJvwXv0NSA7wtaakIFZoIw3tLXIZ6jj7
         qPEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWK01BEs+PVdVSInsH+zJf08HwDjDkYT+KWBXlvqoC7PCAtzMVBAJD0WwH0tU9C7l3gQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2ji3y6qyeRX0x5m6PWkjQn1sD0xC69WVyFv82LdGdTsXSBnI5
	UC3kwcIQpkiwlL25uqfiUjQQur6Dvnw/OTW1yOto5wJ14d0xZKhOu0XlIdnO/wxeBy2Oy3EgheQ
	oqb751bFauZzsabeT3By+iXnrPW/e95hLR2IH
X-Gm-Gg: ASbGncueZbbbb0MNUScB+beDnmatsgPo2ZcUOBJYlh8x2AFH6dvLawIVv5mViGkXvEs
	x2SOFiVtg8lZdQD5Sc8OJRAowZS5M34inGwX5vRLwGwtol6Jl1OTG7hUbqOOtTqnz6Bwwhul8Bd
	joZVSa1Oiw+LhOMJdnmhoB7uectfBYE+e8tmxxopEjOCIgfGIZX9U1
X-Google-Smtp-Source: AGHT+IG7TvFiypkSdm6cFL8QXv7Geze56CiuyUqiMCDjIy5B3tjxrLsMvkElYIkhtHnXIN1qIRY0zGBcPAIono1A5h0=
X-Received: by 2002:a17:903:2053:b0:220:ce33:6385 with SMTP id
 d9443c01a7336-22dbdb49fd4mr181535ad.9.1745520568724; Thu, 24 Apr 2025
 11:49:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424040301.2480876-1-almasrymina@google.com>
In-Reply-To: <20250424040301.2480876-1-almasrymina@google.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 24 Apr 2025 11:49:16 -0700
X-Gm-Features: ATxdqUGSuXy2A5TP0CkyPakNQ5S2ontOlQJJboyrRu9J3Ao5kJdPZ2OrP3y4P5Q
Message-ID: <CAHS8izOT38_nGbPnvxaqxV-y-dUcUkqEEjfSAutd0oqsYrB4RQ@mail.gmail.com>
Subject: Re: [PATCH net-next v11 0/8] Device memory TCP TX
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 9:03=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> v11: https://lore.kernel.org/netdev/20250423031117.907681-1-almasrymina@g=
oogle.com/
>
> Addressed a couple of nits and collected Acked-by from Harshitha
> (thanks!)
>

Hello,

I made a slight mistake sending this iteration and accidentally
dropped patch 9, which contains the selftest. There is nothing wrong
with the selftest in this iteration, I just accidentally cropped the
series 1 patch too early.

I'll repost after the cooldown, and if this happens to get merged I'll
just send the selftest as a follow up patch, it's an independent
change anyway.

--=20
Thanks,
Mina

