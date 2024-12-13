Return-Path: <kvm+bounces-33730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 756049F0F63
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 15:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AAA0164D18
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 14:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7541E1C01;
	Fri, 13 Dec 2024 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n7cm5HXO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1881DF975
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100804; cv=none; b=p9AEH7N7lDHv1wQWkWheONii34Kx8y1ELYLFPudG1AKMToQKeY+3jeLVtx4XeYnBBcwrMQ08/8RW/HCtc8EB2UFXvx6cCyOPrPqat42/HCCxi50nXJf7IpRVy063e56+84Ks9z3gzTaLg7o0zlqzqexbGwMeuV57g56MfD+SJC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100804; c=relaxed/simple;
	bh=wBqUYrDGzq8/Ph2W7HoSJKRld+XHMM3JOZ3PqC7C6+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JpjzHyRgbpjDToJ/fHAYc/I4gg/b0poqYD8yXS1spttXjhH0ajrL4mvFd5Y0NP0N25xHbppV3vIwdwjMXNLnWNB/ZaRox3oIjcvP7hg8LUEup5o4sl/ewiXcdPph/7RqEvthNGuWXG8KHp1Zjtol2MxFwSUUUpLjcQPVJkQZJRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n7cm5HXO; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a7dfcd40fcso168815ab.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 06:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734100802; x=1734705602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1o6cXCczlOJrW820tbI3ejXvq3a/VUwUy4HgwjZcug=;
        b=n7cm5HXOII7l0pifckG1G0KO5jIfknmR/vRJSZsnyjND9PnQuX7g6B+lJvUF+4zBxi
         eC6OW3yBky/+tXdDqRhB7ut+kCzqIHo5jXn+gBy5GctznrfFL+SPmiEQD6gk+Rd3EUIJ
         kMvRngSsg2/FfdyOKSo9eVYMmAFT0oDs1fb0kHD3jCBfQUHgjIldEHjYgzLYYSgIWY9R
         WJrockPS/4csYzk3gJFE7330vyEEnmJtod9RPNQJF88qmT8KpeJrg2/KdBX1kt3wdI1g
         T3z4UFxBlbK7ZqVwKiwo1ai+11VGD78rjIrT1mHios6KrDhVDThK0oYq7KTzYVQSYb1q
         Atzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734100802; x=1734705602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y1o6cXCczlOJrW820tbI3ejXvq3a/VUwUy4HgwjZcug=;
        b=sfnTC8M7NOJuItegPK0uzjnRXvAJzHJql4B3CfoDNkH3LVzIu0CF3tql+w+HZg3kgA
         BCsHlnFHp6d6aWVf6YVQYOnz0t/O0zKarYpQ74mwav/9Bi2Ixto5Mn+NE6oezKd9Ht1k
         5HmF9ENxMKyfQH+N8KNoeNhduTLzGgDKTyMwKNimWPD6o2pDiLpZ0/rq8+XCMRO57KJl
         GANnIdLOxWoOepVOcdDRh8/ycFCNhzbgbUsv8QWcKmTof3UK8yBrjf/u8MJ+O4sYcff6
         DE5jD5PKztUHQ6rjsV2mhLJRDA9YEUqRIupwEX9slylAldgi26mZAh30iA0WGofXE+FK
         jeQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHbQpFZHfdKu3U5iAzkpzRzSfTPO71yIXSITNMaRtXYicoCZsDltJpdmDP7ZawZsK6xV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTVVFuSguThlvPljOav3JJTHQQF/hq4mDab1Vx5V7cErMPcRJV
	/ROKu5njh0jGRxmKGhfH1Gwz+mLlEdSZ5m0IDN7hkjy1JcKQgukMfECNjhtuOn+4JoBgHfK7885
	i4Fl8+cJPofeqdzNlfAHPiZZfFhnoAQfGxwUy
X-Gm-Gg: ASbGncvzzN9YK9Et9cRQgPX/Ig70W8WNcSoe+vuKVVvdVlOzdZAxUIeNsufcMwcl9aL
	1KT7l84xyjqWRxFrD80bIO2arskpr9fhj8a5/
X-Google-Smtp-Source: AGHT+IG9Da28jDo3gMfdHEXumlT9aNakfaU2EFaMPQ/m5hhfUBa5umXHfjGD94SKFdUR9uWgqT27M8DdZa0v4Faq+Cc=
X-Received: by 2002:a92:912:0:b0:3a7:deca:1fe6 with SMTP id
 e9e14a558f8ab-3b0287e813cmr2140715ab.13.1734100802321; Fri, 13 Dec 2024
 06:40:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com> <20241211013302.1347853-4-seanjc@google.com>
In-Reply-To: <20241211013302.1347853-4-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Dec 2024 06:39:51 -0800
Message-ID: <CALMp9eQjGXrCpuwqYc5sddrTNWRO+gA-P0jONtzfb8W-E2STBw@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: x86: Apply TSX_CTRL_CPUID_CLEAR if and only if
 the vCPU has RTM or HLE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 5:33=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> When emulating CPUID, retrieve MSR_IA32_TSX_CTRL.TSX_CTRL_CPUID_CLEAR if
> and only if RTM and/or HLE feature bits need to be cleared.  Getting the
> MSR value is unnecessary if neither bit is set, and avoiding the lookup
> saves ~80 cycles for vCPUs without RTM or HLE.
>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I'm not sure why you cc'd me :), but...

Reviewed-by: Jim Mattson <jmattson@google.com>

