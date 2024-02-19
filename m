Return-Path: <kvm+bounces-9074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C8785A29E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 252321C23161
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 11:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A302E40E;
	Mon, 19 Feb 2024 11:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZyw+qnN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F85E2E3EF
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 11:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708343907; cv=none; b=tSN0khj/k2BzCo/FEkttWSyhPPSxRqE5KhvD+EVuBSH0YzI37DiIHZh5P3BoQMt+AYb+LKnIQLUim4TTr3/g/H/F8KcTdAd3rISru0hWZBnR38ibFOy/0YfHg4Gxo4kxqq1VXLJDFjifosW2ZOsCyBPVpc+ruFwCKJt01VKW53o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708343907; c=relaxed/simple;
	bh=nJstLW9esmyElWFns2CzFB95hhSHbzyVH5WsxNSFQ2U=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=XIv7KqGAU0TJlM3GN8wO1EPDpnATvwXGo6eE0bivSQXdtujH1ntodn/7+VPx0YlTAxyJivuP5DuvQDHFxwLm/SaNJHbZ/dE4lS60qoInciTGxHpjcD3kyG9KNRHhEokS/F2hE/6IAwCCVMeQdodWQg7My3MqD4HtwpE7whzplms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZyw+qnN; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dba6b9b060so18310045ad.1
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 03:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708343906; x=1708948706; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qtKD19qauwfMDNEwLgCb7I5KxV73UoCs2lBAo1NZd7g=;
        b=dZyw+qnNm6wzSFG009nvrPaI0IzNMez0J8mlvd61lVaa2452EQDp5YxDro+YZmNQpS
         BZQaXTilvuBdA8B8lkfO4sCZX7zEoicR/l/AdxJkDRJ+9UdQwqL9K4UB0HcGf8dW3szz
         ane459A5s/tLNLd7I8POVhqguUyQ68AGxEiRmIQbQ+DkD0OTrvhgChJlKgxeWBT18Fmd
         /lBGfFgA7ULI/YN3pY9S7T76RRuP2p9X/hr7nlPUy1NuhTfS1YPLgxYrbLfKpuvloN5V
         /EL/QuQFvI8RTMQo6abl82jEcr4QI6jy+RJowW7uiB0fitLPe0ofyBRg8NYqWmKrdSwu
         2bLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708343906; x=1708948706;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qtKD19qauwfMDNEwLgCb7I5KxV73UoCs2lBAo1NZd7g=;
        b=tA4Jq7RXKkGEorXH9acEuvksnnQgrmkCTzid2bk0NWbugH/Q2RDQmKaRrXzHlDpHkI
         rzefg42PLCD3XIplu8LO5jXTAIxZOuO8rWgnIzbxfXK0+6wnSQ5mMMtyMKAGBIrux/sC
         JifwTXqbir3sM9WLroMeXWJVIWV2foYp7D50BKZma2mF5+V8p5LxeC13gChI3GZn8nv9
         1LxfCygVfr5atKxbs0yXA/MMaJWspj1creah3dIeX/dz4eLhgFFWVCDw3VUsBHtbKSOv
         85auI3kVeqdxe4ri0fanrs/pOG/44RgYp01r6uFRRTIGFRwd3p3+H8LlVffOciHk+IVF
         k2Wg==
X-Forwarded-Encrypted: i=1; AJvYcCWTLfGUmFYkdcXoCrFl9Z7P+qIeD8Tsr0in58VzYRKuMlxTVQcVz0rMTMczbvahM/W3/SrQ39KC63oYh6miMrCF2EAf
X-Gm-Message-State: AOJu0Yxu4eOV6WK4cc6KbC7K7UcA0IaeeLqLGIAQcvdcfxe2lPyaVlmK
	XEjFXNRzFFjCiWKmb5p8s+eJaj3MPIwznKlwNvWEOQZDZbQBQXgV
X-Google-Smtp-Source: AGHT+IE9b6RC9oHbAhWZTL2lD+mu5223dNrNzrbJxmVB0cgYIkGUcQQPDPnjzMu1ezsyMOuXvHSLQg==
X-Received: by 2002:a17:902:e84a:b0:1db:e41f:bab with SMTP id t10-20020a170902e84a00b001dbe41f0babmr5023569plg.32.1708343905564;
        Mon, 19 Feb 2024 03:58:25 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709028c8c00b001d949393c50sm4178505plo.187.2024.02.19.03.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 03:58:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Feb 2024 21:58:20 +1000
Message-Id: <CZ91DDIGOAMM.3RLL24M34FXGK@wheely>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Alexandru Elisei" <alexandru.elisei@arm.com>,
 "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Cc: <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
 <CZ7AJ4JK5805.2N5QS85IP42QZ@wheely>
 <4986756f-6230-421b-9601-054c6c2969e8@redhat.com>
In-Reply-To: <4986756f-6230-421b-9601-054c6c2969e8@redhat.com>

On Mon Feb 19, 2024 at 4:59 PM AEST, Thomas Huth wrote:
> On 17/02/2024 11.43, Nicholas Piggin wrote:
> > On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> >> getchar() can currently only be called once on arm since the implement=
ation
> >> is a little bit too  na=C3=AFve: After the first character has arrived=
, the
> >> data register never gets set to zero again. To properly check whether =
a
> >> byte is available, we need to check the "RX fifo empty" on the pl011 U=
ART
> >> or the "RX data ready" bit on the ns16550a UART instead.
> >>
> >> With this proper check in place, we can finally also get rid of the
> >> ugly assert(count < 16) statement here.
> >>
> >> Signed-off-by: Thomas Huth <thuth@redhat.com>
> >=20
> > Nice, thanks for fixing this up.
> >=20
> > I see what you mean about multi-migration not waiting. It seems
> > to be an arm issue, ppc works properly.
>
> Yes, it's an arm issue. s390x also works fine.
>
> > This patch changed things
> > so it works a bit better (or at least differently) now, but
> > still has some bugs. Maybe buggy uart migration?
>
> I'm also seeing hangs when running the arm migration-test multiple times,=
=20
> but also without my UART patch here - so I assume the problem is not real=
ly=20
> related to the UART?

Yeah, I ended up figuring it out. A 11 year old TCG migration memory
corruption bug!

https://lists.gnu.org/archive/html/qemu-devel/2024-02/msg03486.html

All the weirdness was just symptoms of that. The hang that arm usually
got was target machine trying to lock the uart spinlock that is already
locked (because the unlock store got lost in migration).

powerpc and s390x were just luckier in avoiding the race, maybe the way
their translation blocks around getchar code were constructed made the
problem not show up easily or at all. I did end up causing problems
for them by rearranging the code (test case is linked in that msg).

Thanks,
Nick

