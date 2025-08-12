Return-Path: <kvm+bounces-54550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C54B23940
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 21:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CF6C2A8535
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC042D663D;
	Tue, 12 Aug 2025 19:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQcNJ6en"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ADD2475F7
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 19:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755028125; cv=none; b=q5WuTukHYGN0HoY40nHuXp9MmEv5QHDlTgGq5upxaw82l29KNHJpVXiyqh1CHblgFpumc7DL0CqqXSZWfzv+iQtRcOz/XFKUguPm/DsqSiPC9THPXGPX57n3/nYPYQPhLUm8Y8HpzwBd0arb+tcve/cMV1qMRpTvy8TDlIkhkWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755028125; c=relaxed/simple;
	bh=9psjKyr4NBPCPwa7KR+TlX4NzEnD7dmpj08yU9mJc/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r3mi3Lrxtpj8qu6ppZhGfWLFMjwiQHJeOsPTOnkfJm0n0SV9896b6HkaySdRf3dRKcds6XEh4n3r6I0qAH+zeIXosTY24S6x6gkGvxkJwUXtgS92/2II86xPWrY35jIPv2FS3Sahu5uPU3OlWjfZD5eKNmGKI6Zzp3z0c/fThXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iQcNJ6en; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-618660b684fso2804a12.0
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 12:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755028122; x=1755632922; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9psjKyr4NBPCPwa7KR+TlX4NzEnD7dmpj08yU9mJc/4=;
        b=iQcNJ6enN8++UPVKdjGOjQhvOqWNnKmeQt8QTkc+UMI+Z8P8omt9hTPi5BbuyMyHkc
         gPXZy5T4WLlqGUxvinKgaOtkbdld9UbuAp1uO4pFL3FqACl79wTqIgjrz/7i8CWb7JMq
         BOt22bR58PLdAAggcJjozX6+YXl0d5QsGRwQXbulwM9tY3kx1UPLF1SwpHwPSvIl9Int
         oB/C+7888SF36iciCH1HCrL8Lbc5UkbjoXkMgCbwkgVpGftyOlfeK2qhn0KLU5rl3Qbb
         EFVt9ZBeXLyDKoz9RHSI09bUxb2kvpMq5ZjK+6UF+9dbc1OT8iyxBy66FoVVqxF4UpFo
         YQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755028122; x=1755632922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9psjKyr4NBPCPwa7KR+TlX4NzEnD7dmpj08yU9mJc/4=;
        b=CaKymI6Hcv6gVhd1jVkedSAFvziBnwdACNEqRouJIVPmzVvHz/AV02aB/rHkjWZO5/
         FC3+62kmjUPgaEqTb0cOcfV+zY+/MY+WSRYYFU5jgs9R3MgF+a5ec/g6mjYuw1Fq4LbV
         O8WueVrBatWUfXZD4jccLyF7pXETXP0L4znZciLhTgrclW52hxv6QNNMJDz7U+mIReOD
         ZU6u0uLZJnMA8WOmi8paAlldCKwemyd8/fu0sdGBHUPPCS9R1tVUAK14NWdHWtnLcpdg
         PND1221y3zPncjTdNFk6hUYhGWdZnvYo4PAYtkSFIeb55tqLlksj0E9b8jLuE9uIlt9G
         HSrg==
X-Forwarded-Encrypted: i=1; AJvYcCVHzQbFuv2pHFJhmrRwbwznM0FTD7dV4RI+a6wZVtGRaDXpSa5ja4Lzcfscyyr/ZE/JtA8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7qD8b8VZx+u4TyX+bqwkQo5f/OLZbEh1SNnHLyLkF4DGFE3RY
	89royQvnCzKey0ttIBa/S+Ps/TKm7agR2SL7MHcOdWVtC1k2eYa81m8Sc6E7ku76bnNtnuamaI5
	8viJIdp5ML4rwaTNL6r4gc2UphW1z8fH/RB17RrdW
X-Gm-Gg: ASbGncvIiakINCx71uNk9QwyPHA6LFiOryu86mQyLIskvJxCh1O10/AnXRcwy3XSJkC
	VI2pLeNKX0l+LjaRsND96xOwKTQyr4cpziCzP0zNODVi+HZox94Bh//fp3/2MriCZbkdzELA7x6
	VaywJ6YdajLk+xfNnfTJiDkrjc4eyrBJ7nlKLhl07g2lKlHOu71JnzpUkDiCwbusIqBdG0Y9XpN
	9B5QgQ=
X-Google-Smtp-Source: AGHT+IGftJax7USoWQCTuPAvdYJs7t6SEj1ciu1krYf3HoropGgWq5ReXJTVPdfhlRt7I3lopmJn7hvhkkuUiTzXeZo=
X-Received: by 2002:a50:8e42:0:b0:618:1799:5baa with SMTP id
 4fb4d7f45d1cf-6186b318662mr8384a12.7.1755028122155; Tue, 12 Aug 2025 12:48:42
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804064405.4802-1-thijs@raymakers.nl> <29268732d8c7656771565ab3c971decf0b12a04d.camel@infradead.org>
In-Reply-To: <29268732d8c7656771565ab3c971decf0b12a04d.camel@infradead.org>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 12 Aug 2025 12:48:30 -0700
X-Gm-Features: Ac12FXwZUemHh7ok_ZzptbM40VRF_YghTsnYkeQob-Cagt2eESIAr5YUDQdlbLY
Message-ID: <CALMp9eTDQCpS5kFJWJ_y8WRYz2peXQ1V+x4d=5VbK3cL-A1LoA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: x86: use array_index_nospec with indices that
 come from guest
To: David Woodhouse <dwmw2@infradead.org>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, stable <stable@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 3:37=E2=80=AFAM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Mon, 2025-08-04 at 08:44 +0200, Thijs Raymakers wrote:
> > min and dest_id are guest-controlled indices. Using
> > array_index_nospec()
> > after the bounds checks clamps these values to mitigate speculative
> > execution
> > side-channels.
> >
> > Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> > Cc: stable <stable@kernel.org>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > Sean C. correctly pointed out that max_apic_id is inclusive, while
> > array_index_nospec is not.
>
> Fixes: 715062970f37 ("KVM: X86: Implement PV sched yield hypercall")

And possibly:

Fixes: bdf7ffc89922 ("KVM: LAPIC: Fix pv ipis out-of-bounds access")

Though, perhaps the blame really lies with commit 4180bf1b655a ("KVM:
X86: Implement "send IPI" hypercall").


> ?

