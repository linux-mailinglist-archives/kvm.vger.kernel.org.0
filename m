Return-Path: <kvm+bounces-57049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3E7B4A11B
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18C9A4E363D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 05:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156372E888F;
	Tue,  9 Sep 2025 05:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b="fuH4//gm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0F1221F26
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 05:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394530; cv=none; b=QDGr8FF5G9PO+37GszKM+n/SQnuXyfU6j+xfbe42H0nCNFv6tUIqjsEH8giURZBm7gJMvhOrT/MYCIFtgraKFWIYbcxEabAew012mswhUHNTj7+YlI9/FK8wFvrt0M3MfTwXdblogM80gMWOS8Zm9KgrG6xfuR27NllDabQ6rDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394530; c=relaxed/simple;
	bh=CPT83K5BQ2++eeCdTesMxh0fJYcO6fqWAnQ60c8osbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ghZ1q5uGd5GFsgW1j8D4WLnoM0+NfOi33ikGb4Tr1xtpaAVGHDx/Aesgg4StXLCyEwV8mr5F0DhxKXEo9NZMB2kfP2qmqlFmZAf4MBAvhDJpenv2fYA/TgDt3hiMnv4SM6OqCchg5Ld9cVYdbDRYkOusjpfJ+zWd5sKjTVfIqvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b=fuH4//gm; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-60f47bcdc52so1755115d50.2
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 22:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google; t=1757394525; x=1757999325; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8v83NhoMV3/Set65PIGiCZnF+wEhzRaTeeF1y4TM/iY=;
        b=fuH4//gm61K0OUEijp4amLFYCYUn0lphy/O+hLCtgrhxqnMNpKy5x2tdFb10dxJGHk
         isFV0iSjsw1Z263LZVT4o0xIAwbnxKAWGLz3rRWvX2RNWBGWgQWhrezyCnhqAVs1PF9T
         wI/KrgIIZ3UW0VqIRWLth6KGxh7FfCAKYVbWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394525; x=1757999325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8v83NhoMV3/Set65PIGiCZnF+wEhzRaTeeF1y4TM/iY=;
        b=p8D5AtJZ0Hhv67CVIm+jYkojnYV+shWUGT2YSNrDqMehuLagqGTTKgY1RzB9PCLsq0
         qvg+5GNPC5l5aJn2iCTPXGeeOiQhURhnFMn20LAMnGqYguuKJiJFW4TyP99Gl9YDDnvF
         38UQuGQM6kbOGjy8qzSFgbQbfp2HCM3SfHS86tAdw7j8/qh45ixPFvmoreQwzwpg8V8c
         UJf+mjcr8RmvG8rzFklV43M3hN3yR2ojCe5LdCl/9P6Zo7ry6crSAZdHV9enXA8A3blU
         B/6Hy9/UQ/XB6aoJ0LMrjYPf4EhemFXjJKHPutG5qpzz2PpEeMaVLKwQehhKsgMkHMy3
         82Yg==
X-Forwarded-Encrypted: i=1; AJvYcCUkrQ4hNirQJrcC5B3zAEN/EHzXIYkjiL+XKCFQYKHM8E6HqHI16zgvyH5eUHZ4V8TiWxg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdQfQD+hxsLviS08EcRjeCbSNvuiOAnhzqtEapJPceMbt9Saru
	FBBwRTms3ypw/kKuF+8NWnzgfWLZ0i+6SBzV4yaUtnMHy0irI65EJonN8NfIea8aYlPNZtkrDz9
	5w5yZmWyf3S27rQYrEqbeij/kolrKNxnhCzqX
X-Gm-Gg: ASbGncvzGEETbOF9gjTtl78VwJ+QjCwErspWR7hrNSxgUZE+YUN4F5t8ixgRhdJN7HF
	qiqkFyq3eaEjEu8zFbRE9cjDT5HnyRmIl7YuTI8/lPVLxNGPvoyJ+blzIhNlhmICuaBwiaFjJAx
	OFkg3nwdgWF7xO0rEcWT0n81dxxREW3312IYbq62k9QncrcTSoJCujLGH5t7VeZgQSRIVjPcQmg
	0l80Y1rdoJJHeaIbQ==
X-Google-Smtp-Source: AGHT+IHkUFM3tIDPd+HCHUsiQaSV2Uumae9Nz9ns0Y9dI67zYpHeBh+7GAWmWM5/jnTI8MgQRVzuAyjRsDPU3DiDOWk=
X-Received: by 2002:a05:690e:250d:10b0:5fb:78c2:b71f with SMTP id
 956f58d0204a3-61032fe7a13mr8005880d50.18.1757394525330; Mon, 08 Sep 2025
 22:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACPK8XddfiKcS_-pYwG5b7i8pwh7ea-QDA=fwZgkP245Ad9ECQ@mail.gmail.com>
 <20250904-11ba6fa251f914016170c0e4@orel>
In-Reply-To: <20250904-11ba6fa251f914016170c0e4@orel>
From: Joel Stanley <joel@jms.id.au>
Date: Tue, 9 Sep 2025 14:38:34 +0930
X-Gm-Features: AS18NWD7IqIrRLFAZ974tA0j1eH-dJLYx1GRysFMdqkPB52xRhZMNwMvKB_OEak
Message-ID: <CACPK8XcV_zCy7sVeSg+muCQ89ZxuhPPXJPMztSisi_oHgMK_Sw@mail.gmail.com>
Subject: Re: [kvm-unit-tests] riscv build failure
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm-riscv@lists.infradead.org, Nicholas Piggin <npiggin@gmail.com>, 
	Buildroot Mailing List <buildroot@buildroot.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Sept 2025 at 07:54, Andrew Jones <andrew.jones@linux.dev> wrote:

> I applied similar steps but couldn't reproduce this. It also looks like we
> have a dependency because configuring with '--cc=/path/to/mygcc', where
> mygcc is
>
>    #!/bin/bash
>    for x in $@; do
>        if [[ $x =~ sbi-asm ]] && ! [[ $x =~ sbi-asm-offsets ]]; then
>            sleep 5
>            break
>        fi
>    done
>    /path/to/riscv64-linux-gnu-gcc $@
>
> stalls the build 5 seconds when compiling sbi-asm.S but doesn't reproduce
> the issue. That said, running make with -d shows that riscv/sbi-asm.o is
> an implicit prerequisite, although so are other files. I'm using
> GNU Make 4.4.1. Which version are you using?

As Nick discovered, it was the older version of make that was causing
the issue. Thanks to you both for sorting it out! I'll send the patch
along to buildroot.

> Also, while the steps above shouldn't cause problems, they are a bit odd
>  * '--endian' only applies to ppc64
>  * -j385 is quite large and specific. Typicall -j$(nproc) is recommended.

This is a curious number. I went digging, it seems buildroot does a $nproc+1:

PARALLEL_JOBS := $(shell echo \
        $$((1 + `getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`)))

Knowing how these things go I'm sure there is some reason they do this
instead of calling nproc.

Less counting perhaps? getconf ends up reading sysfs:

openat(AT_FDCWD, "/sys/devices/system/cpu/online", O_RDONLY|O_CLOEXEC) = 3
read(3, "0-383\n", 1024)                = 6

Whereas nproc calls sched_getaffinity, and then depending on how new
the glibc is will loop over all the CPUs to get a count:

sched_getaffinity(0, 128, [0 ... 383]) = 48

coreutils has this to say:

  /* On systems with a modern affinity mask system call, we have
         sysconf (_SC_NPROCESSORS_CONF)
            >= sysconf (_SC_NPROCESSORS_ONLN)
               >= num_processors_via_affinity_mask ()
     The first number is the number of CPUs configured in the system.
     The second number is the number of CPUs available to the scheduler.
     The third number is the number of CPUs available to the current process.

     Note! On Linux systems with glibc, the first and second number come from
     the /sys and /proc file systems (see
     glibc/sysdeps/unix/sysv/linux/getsysstats.c).
     In some situations these file systems are not mounted, and the sysconf call
     returns 1 or 2 (<https://sourceware.org/bugzilla/show_bug.cgi?id=21542>),
     which does not reflect the reality.  */

Anyway. That's how we arrived at 385!

Cheers,

Joel

