Return-Path: <kvm+bounces-32786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE759DF3C6
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 00:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E87FF1630A5
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 23:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA301AC420;
	Sat, 30 Nov 2024 23:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ApAgDkAH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AADC1AA78A
	for <kvm@vger.kernel.org>; Sat, 30 Nov 2024 23:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733008298; cv=none; b=aFXabyHMb/sAKLJWfifjMCVDEN2x9QHhKvvfmf/0ikP5rN5Es09Cg/GMi4Ngnyo8enTNZD8pL/Fzv854C/EU42l6VDNAef2h49Xb/L9ZE7Pxyp/NjZv/TimNCJ3Wi+LRLbWOiGGLwUcaanHTGg0etlDHeo6fkRBFhJJ3ZKtJI9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733008298; c=relaxed/simple;
	bh=igWI8mrhgsOvImsfULhcXfwMtkGJFUnIjBAYjDygDVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OJ+kLqTXpdp4jpjMeC3YgWo4JZ0VaZvYwJnZoMOr9w1fZUWNOpbYFFnw0Uz9UirdcRt6F/o78o5lTEOR26QzUMy1SyCKvwwpOilfx+7snbZ08arTzjXNrCI3gWYVmKcYkmAUpzGZGGoHy3TzGeSTPTqg2Lzl4T4hycnbriVhia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ApAgDkAH; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa549f2fa32so455836766b.0
        for <kvm@vger.kernel.org>; Sat, 30 Nov 2024 15:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1733008295; x=1733613095; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GSLp2FeQX6v0+DpLPCnxxi3sSbb+vr+koAirOocK+fM=;
        b=ApAgDkAHmF0l90AW21clbWq1Hora23ZCfcd0uA7h2je6FkdpipubI0sqz0JrQhx1+N
         wNqp/Jg2JrmVr8zSDSQqwayRcwPIHLqVIbVF59TVzzn3IanguYNiWnFYDqO5E4XgYx7d
         XcRKLhDaGoQnA23dnpoIwFrv8R57JArwEuGYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733008295; x=1733613095;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GSLp2FeQX6v0+DpLPCnxxi3sSbb+vr+koAirOocK+fM=;
        b=IAz/RMtfpFQ3oZE0vI/dsUyx5lKzNmSRQbMAossm5mOiNk1x1hQ24ootyVuVA/Hxgd
         JX71VT8fOd9ujWpoMRJeiSV9m5f1X4fWre8afet2LFbaitl0cbk7q8KjnAC4rzF/WtbZ
         ZuOdPARP+UHnU6e6PGRYtGdUzUpQo3n10C51wwubXkLOeSNpisreqmX/D6q71+7ZJ2y9
         bpC3/8SZLWN9hViM6fjWpDO/JBhFadyiuzC1tVaPHLOFAlOk3g1JgA4D+0potAvHf2W3
         E6vwXxu98Zm2Fvr1hndUBiHovwvFk0izE32P8veg/mJxJ5Rmp8XwJXblWhf7PdKTxDZX
         iU1g==
X-Forwarded-Encrypted: i=1; AJvYcCVTLM101w9CLzxoOOZZMjCcnGxcGZAkpbxo0Ld/xt8T1xvgksQpCgVlm+kWlXaOehkAzGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgTajNOqXf7v0gvoYANLoIFzd4JsWWqfJogjK2raQ+UyuMJ2l2
	aCXRiaMZNSOmSHTQKByhx7haHo0joI+70q/P8gsZW/zZPNyMQck6cEVFx8AqmQ6zszuFDKteAFx
	lMdK/Ag==
X-Gm-Gg: ASbGncsLW2djJ85Mi9jrAfe0FOvhOHvD3TVsFic+iChku76p/N5iv24ljv6owt0Vwaz
	woEB6V0hhhhGGwzbzKwAcjuUwU7sDg02SO4JGeCjXity2NAAUVyVpODLg76FwlxHMXtiofagMny
	B6ciUBKQz3Nivd8+EbEY3L9XL5xeHYK/V+sVnBOfWlwoyCNBABKSd2SwUhCCtsSOaIKQL8QypaY
	VeaSfl8v8+APSh4qd1A7TEodyun5Bh0879+TZxG6kwRT5oGnTqz+PS1mx0xSBC8DWP4gA45jkyy
	BGBDfpC5EB2LuiFek5sIkGPK
X-Google-Smtp-Source: AGHT+IGsdo+TGSCRmp3B4O5ZXbMtNacIMKRiMYU4k9k8belFAv5ouZ5KYGfMzUS1fX7dZStfpaGbOQ==
X-Received: by 2002:a17:906:31d6:b0:aa5:3c28:e0ae with SMTP id a640c23a62f3a-aa580f2c1c7mr1337189866b.15.1733008295094;
        Sat, 30 Nov 2024 15:11:35 -0800 (PST)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996ddbfbsm328201966b.51.2024.11.30.15.11.34
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Nov 2024 15:11:34 -0800 (PST)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa549f2fa32so455834766b.0
        for <kvm@vger.kernel.org>; Sat, 30 Nov 2024 15:11:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUUQ6CiIhK3tAW0leqTRa9KxYKbMWtlvGnTjTWMp3Z4Y5yDylJLv8n8JrefnxFoajnxmD4=@vger.kernel.org
X-Received: by 2002:a17:906:3195:b0:aa5:9303:1b96 with SMTP id
 a640c23a62f3a-aa593031ccemr1127506566b.50.1733008293952; Sat, 30 Nov 2024
 15:11:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241129231841.139239-1-pbonzini@redhat.com>
In-Reply-To: <20241129231841.139239-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Nov 2024 15:11:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjP5pBmMLpGtb=G7wUed5+CXSSAa0vfc-ZKgLHPvDpUqg@mail.gmail.com>
Message-ID: <CAHk-=wjP5pBmMLpGtb=G7wUed5+CXSSAa0vfc-ZKgLHPvDpUqg@mail.gmail.com>
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 6.13
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Nov 2024 at 15:18, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This was acked on the mailing list by the RISC-V maintainer, see
>   https://patchew.org/linux/20240726084931.28924-1-yongxuan.wang@sifive.com/

Please don't use random links.

Maybe patchew will stay around. Maybe it won't. This is the first I
ever see of it.

It seems to be maintained by Red Hat, and yes, at least it contains
the email message ID as part of the URL.

But when I tried to go to patchew.org and then click on lkml.org, I
get " https://patchew.org/lkml.org/" and a big "Not found" page.

And when I clicked on "Linux", I get a working page, I can't even see
the raw messages without downloading some "patch mbox".

So "maintained" is perhaps too strong a word.

Please use lore.kernel.org links instead. Maybe that won't stay around
forever either, but at least it works.

Lore also deals with a *lot* more lists, and has a lot more history. I
tried to look up old stuff on patchew.org, and it just doesn't exist.

Put another way: patchew is objectively *much* worse than lore. So
don't try to make it a thing.

            Linus

