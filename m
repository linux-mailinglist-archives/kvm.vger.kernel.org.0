Return-Path: <kvm+bounces-66090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE9FCC50D5
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 20:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC8C6304391C
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 19:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C52C33711D;
	Tue, 16 Dec 2025 19:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQkHgQ8r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F42332ED9
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765915158; cv=none; b=GyLVphMjDZ7iPQf2Zv7kdiA0Rwp3Em04FTiEoJM4srWf92w1PvcQTUCBJmgUudl8h9zDJxahBG2IrnkTZRd6AeSuwN4X+LrAdSBfRiBYepBwz7wCX9Ey1Kw7mUfmjUDiuXjraS5fqSyl8vXdOhN/NQXZ1H1ySbF1H343kXkCVVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765915158; c=relaxed/simple;
	bh=vz6zEIxg/+wl/MDvP+RvMv0qeimFFpWWQmNPdyV4ahQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVajPJ09Lk+4aEqHlzV5YVWhzxrYBdi/XGhnHn4PQX4yBXhtnYogV/WT5rFwAd5z4l2Vh/fh+dY2BxrbXrqvKQb4O01/gnOf2ViAxxYcrUcd/sRkBqNFl+IbCSLzpPpOqOuKX0jhdn4Sblz5OTs9TrpFbo+Lt6QcMd/qu2ZMuOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQkHgQ8r; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so55426115e9.2
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 11:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765915155; x=1766519955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjniS35+gFl94KgDPsESP+GSizMKZS5/qxbShY9gflU=;
        b=mQkHgQ8rCUqYWNQeWJT+spqbmbXpQXZBVbGCJeUWSHpIIPcLjCD4WKKtC8gq5X3V1h
         uPiB7fkh1u26HvOc8vP0tjZDG+gQ1gR9wTMPHbNV4zBRAbei19yhIG0FspKIuG3edPK0
         72/VM1hTUDRmIWXpjPpznytNY4UqOpmQIzRnuJTNADpvdQnHJgs6SgXGQuJsA6Sgqhxs
         zXqpHAPK7R5P+tZpGQWEYNg3Sz3YMI1g9UpKuOJMk7yQEFOBsLJQvZaCUvjWGEcJ4Are
         Fg2kSpbK3lzL89h7g+ICvVPL0tR3UUaUaT1nr57OdgNuQDNj8K+OUu9RuKEqu4L+p/RI
         XCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915155; x=1766519955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GjniS35+gFl94KgDPsESP+GSizMKZS5/qxbShY9gflU=;
        b=O3U8c/hV+lQSTd9lT2M7gFff68OnrA2YjdmPGUucp2OZMgVqmciOkhDh69pX7FbExh
         CQjx/orLpWxtbJaMZF6DrijJxymcwcH6UEdmLWl04OlqpSKhDx2umHUaPKHQGmqUFs+0
         B2dzuygoahMEcFObWxqlOXDT9boPh0QzspcWNXgHfB0ziSpWCpap8o8nKGw9jtRCuuXo
         VChlafizdPdNN9peksqJYG8UozWJ/MhOdLSg32sD/Dy7YNAjLXiFEQmrpOHBFIIsxnhh
         Ds0Ub7O7bdbEQ9A9EBY9tRyEuHtFBn/GkfPGvy/eGAisMhdc6qC9DswNmnl/6wx3BtHg
         0e/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXOgrzXCq70q1YErAjoU/rqTJU1iBUTHfaloDKweCDb0YueES8qSlZhwNDDWkanjy8wkF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgXAThcq5xt9JEaTSxgpkRfbdjXGWkLys8yQEAEuoUblyD8sF6
	uCRiiBl5J1KAk6aVSVqlG+K9IqiI8mXrlI+5gbb64C4cyZAvdDWjcBQk
X-Gm-Gg: AY/fxX6xqN9JqLRaZQ7uFh1VVnAdYpFX76//GHa4tEv96syR9sdl4lKqKUJ8jgZF+Zi
	VzD3a76HFluk3DSn+nnm5APjWqn+2tq95UP5U4OHooH5OCrT4XXveUM+b9ZPYyL4wggKr05qjZA
	SUvLNF640//4uq976HnPfNzEjsufJVQMJLXnGHnq69OCSwwO68DyzKBKBR/UahMbJPF+qkHH6ka
	VaSzaw7PvqW1/bqdQ2xUdP8hmZXHi2TDfZU5S8QkDvs5wTexIcY//TFAxqP8IFhwg4EYf3pgWvh
	6CD3TIcgCmSPIrSvKVsQY3cgxEk12a5EoAProf90UcuOlL3Yw/F2oiTvvPf3q60ML2fP1Tng+zd
	GZiKrrMY86wCvRAwyhnFdAyM1WrKxBWBMuqIhjFtKIm/r/PZBDmII1vKIMBql1CvBFa3+kiTUnn
	UbEFgmRmHDIX3ZmAbF4aqvE2AUpyEZsycYjGHCOQEsR9pKhSnbPRlrOMp60XmgMqQ=
X-Google-Smtp-Source: AGHT+IGkMCP0kONGgG89SYNUeIIN6orwCVUUHEl6uObTm3wydLwUSISgvgOvaVGUZQxtmSBHQ8CSsQ==
X-Received: by 2002:a05:600c:4595:b0:479:3a87:2092 with SMTP id 5b1f17b1804b1-47a8f9145edmr152180075e9.36.1765915154784;
        Tue, 16 Dec 2025 11:59:14 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310ade7c3fsm779077f8f.26.2025.12.16.11.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 11:59:14 -0800 (PST)
Date: Tue, 16 Dec 2025 19:59:12 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, Ingo Molnar
 <mingo@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Ajay Kaher
 <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Boris
 Ostrovsky <boris.ostrovsky@oracle.com>, xen-devel@lists.xenproject.org,
 Jean Delvare <jdelvare@suse.com>, Guenter Roeck <linux@roeck-us.net>, Denis
 Efremov <efremov@linux.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
Message-ID: <20251216195912.0727cc0d@pumpkin>
In-Reply-To: <14EF14B1-8889-4037-8E7B-C8446299B1E9@zytor.com>
References: <20251126162018.5676-1-jgross@suse.com>
	<aT5vtaefuHwLVsqy@gmail.com>
	<bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com>
	<aUFjRDqbfWMsXvvS@gmail.com>
	<b969cff5-be11-4fd3-8356-95185ea5de4c@suse.com>
	<14EF14B1-8889-4037-8E7B-C8446299B1E9@zytor.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Dec 2025 07:32:09 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On December 16, 2025 5:55:54 AM PST, "J=C3=BCrgen Gro=C3=9F" <jgross@suse=
.com> wrote:
> >On 16.12.25 14:48, Ingo Molnar wrote: =20
> >>=20
> >> * J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> >>  =20
> >>>> CPUs anymore. Should it cause any regressions, it's easy to bisect t=
o.
> >>>> There's been enough changes around all these facilities that the
> >>>> original timings are probably way off already, so we've just been
> >>>> cargo-cult porting these to newer kernels essentially. =20
> >>>=20
> >>> Fine with me.
> >>>=20
> >>> Which path to removal of io_delay would you (and others) prefer?
> >>>=20
> >>> 1. Ripping it out immediately. =20
> >>=20
> >> I'd just rip it out immediately, and see who complains. :-) =20
> >
> >I figured this might be a little bit too evil. :-)
> >
> >I've just sent V2 defaulting to have no delay, so anyone hit by that
> >can still fix it by applying the "io_delay" boot parameter.
> >
> >I'll do the ripping out for kernel 6.21 (or whatever it will be called).
> >
> >
> >Juergen =20
>=20
> Ok, I'm going to veto ripping it out from the real-mode init code,
> because I actually know why it is there :) ...

Pray tell.
One thing I can think of is the delay allows time for a level-sensitive
IRQ line to de-assert before an ISR exits.
Or, maybe more obscure, to avoid back to back accesses to some register
breaking the 'inter-cycle recovery time' for the device.
That was a good way to 'break' the Zilog SCC and the 8259 interrupt
controller (eg on any reference board with a '286 cpu).

	David

> and that code is pre-UEFI legacy these days anyway.
>=20
> Other places... I don't care :)
>=20


