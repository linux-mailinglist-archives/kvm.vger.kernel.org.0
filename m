Return-Path: <kvm+bounces-36596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77618A1C4C5
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 19:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E9FB188725F
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 18:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0105886328;
	Sat, 25 Jan 2025 18:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVpkKggl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9B778F3B
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737828759; cv=none; b=KGW5l5PCvo5f7ySrgsqu0sRnd0qDFbWaxxWXdYsQC6Vx92NS9iSC6Za+RL/kim9/NXymVFvGmfpgkee9DGVK4eKg9XaTQ5YrDhdISHKKvwvqhKUS7jWhvUCEBttyiy+xgEC4+pbQ6v74weMTagam1S5vVTt2yKWfXu+X27iGlM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737828759; c=relaxed/simple;
	bh=XVfmQaZ3PYhjo+K/KkLreNMEX594TelDza3yMvh7Hj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m37cl014BWg1lPX3WOpD/1NfPhzjlEdEAnshw7RGDrg+HVgJJbL3xbBM0JKYUgK615utcpp5Oaah5j6Y56MwQe3U8TY7Z5Z8gDG79g/7IZS7Yar8gyX3uH8eJFPwIKeU5xxobJzqvLOWVsTNkiIZiRHHf/AAyvEP4TuC3XWYCSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVpkKggl; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d0d32cd31aso4570935a12.0
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 10:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737828755; x=1738433555; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rMLt27NMjEmkE9H+glufdZQUBmjb6u1KINgYY9Rl+Co=;
        b=TVpkKgglOyj1yoZ+NtJmcA/SWzjzmYXh9Hx+DLCju0hmlbXgVpV/M+5JoMVS7Yw1L0
         3S1Uq7YY5K9aHUrhCkeEyMiF/IJQFs7+qht0+7whVtgK79/G/FqILmeQcFheheuvxf8k
         6bdqY2TeEm4fFEy9ySgt6Ow9u231/I//mtYK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737828755; x=1738433555;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMLt27NMjEmkE9H+glufdZQUBmjb6u1KINgYY9Rl+Co=;
        b=BdNAIs05kWVuVvvfJ5lnyENr3bAMjQzliPNSP75QMztiZYy62Xjtz8TrQRVp3/759A
         AlgLE3m6ffr2tRvmgv6tumjtTmW3vWYc+eGMJxICKYCqy0zDKIk+QMrqeoj/PoioPgwK
         cp/4F6+71gxbhdI2yI1UDwM884hPLHBrPWA4Xir7hohNen7ImY66sBAQ0k/d2uPe5loM
         epG57DFZYVNXMyWlKw5lKI3knUHGsCKZH1dsZPbjIH51XpKjONmQNaZl5YgZJKheTV5P
         dmEBcjqq44uYt+nj49t500J9eWO3yURJr8gDRo43iIghr1zTgZn50jPv6JJuaeYo31pc
         8C3A==
X-Forwarded-Encrypted: i=1; AJvYcCV0v7COzJhXBKH/KRQcQHV8FD3rPYUrVsQmxRHdfb8IkNyfoH9q/g4gocFfe6E87cjThDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhCDp9K0xixGcx7CrPrFQnYLxj4t+e199690zHYtidEKGqBDPU
	ei0Eqqd+gfbgCJ/Usg6SXDnR50aYPEdOrED1zKxtyOuWAQ6aBG//tSFZsSTnqKWYlovcKP+LoZj
	vQrQ=
X-Gm-Gg: ASbGnct6HGFGEAZ1pX/hrsSPpT5zHFsaIYOIxCWRj5MVr/WTR2hcxiLVrs8WVLpAEDW
	hGbzEUMD/j6ZKMjfYiju9fsTEKF9vM5yyYCB3lwTDbeuhTmcT8wdK6u8SFuGAElXCiUmI62edX4
	/ehaBpUWFThHXvIQTiUIhR8zUMNG3kITcOppCIhClvahSTrAskguI8BnmUdenlwE26Zg4dEBloI
	M1EtfnLcr+iWVvT48iQY0c0kDGqKPNdfiFRHiGodfo1S9VZmBpumjcrPOs4lHjwGN+KpaLe3kbU
	wt+0PNoCMyRtKmpBXrwEOLqjlIoC7UiiCwdWI+5d+I+6UjUDKKlUccE=
X-Google-Smtp-Source: AGHT+IH/Is9r0t6FbtId6/vehVBvcMPp0pE2uoknF5vxLOuVkYvz31mQ/WTAXFRx1tqL1DyOA7c3sQ==
X-Received: by 2002:a50:bb41:0:b0:5db:f2dd:cb4a with SMTP id 4fb4d7f45d1cf-5dbf2ddcc98mr27739815a12.27.1737828755023;
        Sat, 25 Jan 2025 10:12:35 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab675e12770sm321904166b.28.2025.01.25.10.12.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2025 10:12:33 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab69bba49e2so1270766b.2
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 10:12:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqSrkS2xfIKYh4F1hIUyHm9Ba9SrLbzBp4H+Z9IMkCujmrbu0HOteGZ4txz4BDQ4/HCz0=@vger.kernel.org
X-Received: by 2002:aa7:c505:0:b0:5db:e7eb:1b4c with SMTP id
 4fb4d7f45d1cf-5dbe7eb1df7mr33463387a12.10.1737828753142; Sat, 25 Jan 2025
 10:12:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com>
In-Reply-To: <20250124163741.101568-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Jan 2025 10:12:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
X-Gm-Features: AWEUYZnxHaOXHuTIGK4lEUwOLkOMT-oSnLfF77YVrbGwTAq3CsB4wZxMMc9_JA8
Message-ID: <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Let's bring some thread setup people in on this..

The kvm people obviously already solved their particular issue, but I
get the feeling that the kvm solution is kind of a hack that works
around a user space oddity.

For newly added people: see commit 931656b9e2ff ("kvm: defer huge page
recovery vhost task to later") and the explanation below, and this
thread on the mailing lists:

    https://lore.kernel.org/all/Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com/

Arguably the user space oddity is just strange and Paolo even calls it
a bug, but at the same time, I do think user space can and should
reasonably expect that it only has children that it created
explicitly, and the automatic reclamation thread most definitely is a
bit too implicit.

On Fri, 24 Jan 2025 at 08:38, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> * The recently introduced conversion of the NX-page reclamation kthread to
>   vhost_task moved the task under the main process.  The task is created as
>   soon as KVM_CREATE_VM was invoked and this, of course, broke userspace that
>   didn't expect to see any child task of the VM process until it started
>   creating its own userspace threads.  In particular crosvm refuses to fork()
>   if procfs shows any child task, so unbreak it by creating the task lazily.
>   This is arguably a userspace bug, as there can be other kinds of legitimate
>   worker tasks and they wouldn't impede fork(); but it's not like userspace
>   has a way to distinguish kernel worker tasks right now.  Should they show
>   as "Kthread: 1" in proc/.../status?

So first off, let me just say that I still absolutely think that the
current "vhost workers are children of the starter" is the right
model, even if it has caused some issues because of various legacy
expectations.

But in this case I do wonder if we should hide the implicit kernel
threads from user space somehow.

Keith pinpointed the user space logic to fork_remap():

   https://github.com/google/minijail/blob/main/rust/minijail/src/lib.rs#L987

and honestly, I do think it makes sense for user space to ask "am I
single-threaded" (which is presumably the thing that breaks), and the
code for that is pretty simple:

  fn is_single_threaded() -> io::Result<bool> {
      match count_dir_entries("/proc/self/task") {
          Ok(1) => Ok(true),
          Ok(_) => Ok(false),
          Err(e) => Err(e),
      }
  }

and I really don't think user space is "wrong".

So the fact that a kernel helper thread that runs async in the
background and does random background infrastructure things that do
not really affect user space should probably simply not break this
kind of simple (and admittedly simplistic) user space logic.

Should we just add some flag to say "don't show this thread in this
context"? We obviously still want to see it for management purposes,
so it's not like the thing should be entirely invisible, but maybe
Christian / Eric / Oleg have some opinions on how to do this cleanly
in "copy_process()" or similar?

               Linus

