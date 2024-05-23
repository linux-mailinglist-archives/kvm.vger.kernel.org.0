Return-Path: <kvm+bounces-18070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B308CD91E
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 19:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E12C1C2162B
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0062976034;
	Thu, 23 May 2024 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dYq99Ek+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82269208C3
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716484918; cv=none; b=CHaVYUF8jjb1zJgNIGsRC+oIqnw79zHOphtcLGNGe/ve4wS8oXZD/yTyZ/pm2boqp4+00Gg6gHXn7MkWVzvssYmZeoIXVW6rFclSK50G5siIrvpmF4P9P7rWtv0chh24CIlYM4wVvvS9raa71MCjbaOSE/luPvbWGkRehcZNGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716484918; c=relaxed/simple;
	bh=p4l2t6I+lwT3BEpz+lNnMTPic01xwFiPS/KX8MJ/Md4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+/nOAAXPhGJJrCer3E7J9Wv/MwxJ5WviRYOyhTB4W2TwqT3mdWfRWvtnVJ6SLD4mB/YZuDfr6k+6dSMW3EOlEsBZPjtPIWozAi1hv3VVt6knxCGrEbQOGIE/X67TVYx43cmOa28ajuQh16YpFnZGjpZBKKbTi09BnNDmFoLgOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dYq99Ek+; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-572f6c56cdaso1057a12.0
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 10:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716484915; x=1717089715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kguOkz8BBoxZq/59dTE1BE5v78wz8qUVU81MIvbz22g=;
        b=dYq99Ek+2a1lDql+wYWGSwzyiWey+I0Pz5ghCrNs56V/zm2Ib36luuclnMPFkQJ9xp
         U0+5LyMD807dTHNxPabjU5ePgJ8LnlTYEpZBl9pQf2VhZDJzMN5knBtmkoLIWoDfhOHQ
         MiBS3XoqmahO7PaCVrwTkqOP9KjAkUsHj7WFkL+bEv3zLk3EnJLJTpBRM5Si1DC9QUdQ
         S+nJbLlEreGJVW/JxVUZkK4FIPTXnv9i+kkEIVyTHwM9HXDm5Hz89k5d9jQuxroNAzKj
         YsOSrjb4j/jepc8KQF4a+coKwSdVaRJxYVmtN+c8uVP7y1aGdVTuY3AnaHA/zaT0DqFr
         7EkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716484915; x=1717089715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kguOkz8BBoxZq/59dTE1BE5v78wz8qUVU81MIvbz22g=;
        b=myzoi1oW9UUFUu0Jn+Q0ieZfhGQKvEutQ9nFF8cc44KYGtkyfelkxj77CROv1aqrz/
         k90MsW+5RPjzQ/pp9iJR6hWxrrD6e7E/wc82Vy9u0zIz7zOj7HO4ge9E5wkGabKjr39P
         /S5/HSZhg4+P5DlH7Zy5PRmBOmyXHom17mGTNy2HGv7S1c/9EzC96xsI3zvUFwHkcbG2
         1+PchgHkMiq5uqtMOymT50sYb/eo/xtdV4QnvNvb/Db8MJfSFF+L7HtZgAI6YSR9AERw
         vDark/Sqbut/0zvudEe9aWYVGCMMu/REkmA7HLs/qBWhzsWXlnk5gDSby47eRd2rUxfM
         xi+g==
X-Forwarded-Encrypted: i=1; AJvYcCUfanu4rKvwIqemVcrM6cElDrz7pvNDnwX8OsjpyhQoQs2hfKQiToqYQnTmhcd4b4ypMQG/gFLz6/QdWAKTMusJyM8W
X-Gm-Message-State: AOJu0YwaIqCsJELdvY8T7PdDy1aGmiqO/jAfHET7F44UmJGmaZWLqu/6
	XKEUdMx243v7ICdHGE7WqzL/e9QeiJRIjOAfacB0d0uZwMkTpMacprqhFfsYmOaWCQAknoatMwz
	xutcRBVaPJsao9nOmmgbr7xt1H3g9ZQQPnJOd
X-Google-Smtp-Source: AGHT+IH+78xJj6jnX1rb2rKorVGrZ9GXUUGh5OuKw+d0r72nAyfAyGgJ+q4JesoTazL/0S+HDYKfZPbqF4LoZrYt1/g=
X-Received: by 2002:a05:6402:254a:b0:573:4a04:619 with SMTP id
 4fb4d7f45d1cf-57843f58ae3mr255037a12.4.1716484914607; Thu, 23 May 2024
 10:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
 <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com>
 <481be19e33915804c855a55181c310dd8071b546.camel@redhat.com>
 <CALMp9eQcRF_oS2rc_xF1H3=pfHB7ggts44obZgvh-K03UYJLSQ@mail.gmail.com>
 <7cb1aec718178ee9effe1017dad2ef7ab8b2a714.camel@redhat.com>
 <CALMp9eSPXP-9u7Fd+QMmeKzO6+fbTfn3iAHUn83Og+F=SvcQ4A@mail.gmail.com> <87cypdha4i.ffs@tglx>
In-Reply-To: <87cypdha4i.ffs@tglx>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 23 May 2024 10:21:42 -0700
Message-ID: <CALMp9eTCu0P79rX4f4j=9NFSy0L5DqoWqruAe95Qq9P1R=ucKA@mail.gmail.com>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC deadline timers
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 1:20=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> On Thu, May 16 2024 at 09:53, Jim Mattson wrote:
> > On Wed, May 15, 2024 at 2:03=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat=
.com> wrote:
> >> > Today, I believe that we only use the hardware VMX-preemption timer =
to
> >> > deliver the virtual local APIC timer. However, it shouldn't be that
> >> > hard to pick the first deadline of {VMX-preemption timer, local APIC
> >> > timer} at each emulated VM-entry to L2.
> >>
> >> I assume that this is possible but it might add some complexity.
> >>
> >> AFAIK the design choice here was that L1 uses the hardware VMX preempt=
ion timer always,
> >> while L2 uses the software preemption timer which is relatively simple=
.
> >>
> >> I do agree that this might work and if it does work it might be even w=
orthwhile
> >> change on its own.
> >>
> >> If you agree that this is a good idea, I can prepare a patch series fo=
r that.
> >
> > I do think it would be worthwhile to provide the infrastructure for
> > multiple clients of the VMX-preemption timer.
>
> That only solves the problem when the guests are on the CPU, but it does
> not solve anything when they are off the CPU because they are waiting
> for a timer to expire. In that case you are back at square one, no?

If the vCPU is in virtual VMX non-root operation while not running,
and the timer fires late, then we just emulate a VM-exit from L2 to L1
the next time the vCPU gets a chance to run. The L2 guest will not run
past the deadline, nor will the L1 guest run before the deadline.
That's all fine.

> > (Better yet would be to provide a CLOCK_MONOTONIC_RAW hrtimer, but
> > that's outwith our domain.)
>
> That's a non-trivial exercise. I respond to that in a separate mail.
>
> Thanks,
>
>         tglx

