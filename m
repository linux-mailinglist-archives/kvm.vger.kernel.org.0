Return-Path: <kvm+bounces-18879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C258FC96C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4E07281BF5
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1975191492;
	Wed,  5 Jun 2024 10:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGK3jO/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AAB1420B6
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717584801; cv=none; b=tR4fI3tN9o6JTW2Fz68zou7MD3lV1a6Mg/i1hPs1Q0rlbI1YalAaeVZ1tsOjxkHCxdgieguuD0M3VfY9I7LlihkUy5pVtcfr6Ru0E8G2cUbRdS62Bp+OgYmXhIAK91HEWGgRXQ8Y7QudCWLvaeXfXyCPn7h4AvjsFyMnqwSXBzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717584801; c=relaxed/simple;
	bh=VEAusTvFQulHOoYDRhgF191gsLmvbnFCHzlSIeqheq0=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=NNrOXB0+kLrYY1mACK/Vte9EufXoG174oY7+TGcosQQ5YWRtooI41uXTkFSApxe50agS59e8sFhSwJYfWhekA9NYYw2BEJOeXZtfmVXf++rJ1DbPuJEh19QcvHj1uE+ba7TazL7CwF7ALcIvQxHvwNjn27fj1GLHSdJHqI2yZUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nGK3jO/I; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f612d7b0f5so5448765ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 03:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717584799; x=1718189599; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEAusTvFQulHOoYDRhgF191gsLmvbnFCHzlSIeqheq0=;
        b=nGK3jO/IgyF+4Ge3znfZi939eA8vulm8oV8Pwt4yd/KLSa0VBh5qkE/pBg3q5xplP3
         YvSEsMPpezCDCjOsxHTjZFSSkkVhnBlnUM0JrgZuLZ5+7bDHJ/ZVoNUqO52YjvxgUwB1
         2fXFMxzBB5c/n/f2U30FjzMX6rxB0u91TXOhDXY5nV+taPdYxbx00GI57e12Mxmm/YW+
         kl/CS+st3+vvmu/pQJnj3CNavDoh7e1qCPfxG02PZcdlo3Nq7Hi6tg0hbJIRJqri51KD
         eqgMv7a0pVLHtFn1NSDpR5UfNnuQ9ghF17iX1S8yzW/1/LkLFjnaKQuBNsWXZJ0bcYMz
         Z3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717584799; x=1718189599;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VEAusTvFQulHOoYDRhgF191gsLmvbnFCHzlSIeqheq0=;
        b=UvBasE/GOC7jOZbz6RS11uwoHhUlpyrjcLm6c29PUF0WHz/THMQ0Fp482ESvePsjEQ
         92zxrvz6Ah5shzf4kQGp/zyxo1c/T47OG27VK382+JtDezkV89zTK95TVddXE1S9Sn9G
         JxAs4AclMUypt726vkmN4iM7rxx+rQPNRcyzr1FKFtHHbi6WpRLPppngSuCewTjQbS9k
         QZ8P6b1pj8xngkEahv4WR4ubu1VAkDHY6iVh+HFiA8uk5XSHHhZcpHUDCcqyP9ZForah
         Wt29mEHIlOg747OM1nICB6hjh0QDTKJ5whVVhtfSeLJUt5jG16YvxxKW4xoldj5Bt7tC
         DpQA==
X-Forwarded-Encrypted: i=1; AJvYcCW3WkKbJCASS77vUPLysv10iMgJLYY91wXo++pOR1eoS4Gh+j+eNS+4PU4yuXnTn+PKA7klDCGDbLrWU4avNanVWUdX
X-Gm-Message-State: AOJu0YzATujAPnGf8rm8c765/9PVSxYxXMmud1iEWLUMtZNYUvjmKZbV
	9SpKDF+cfJJGrdhoHzFdVEUndaPh8C/nijVSXALtdc6BHxKR0Wj6
X-Google-Smtp-Source: AGHT+IENogmQgAGkfGinFZ2JnJemLA6bJ/w0ezfsC8jWldaANdTfizKjOJevwfffZr/rr+WdJdygHQ==
X-Received: by 2002:a17:902:c401:b0:1f3:81c:c17 with SMTP id d9443c01a7336-1f6a56ec147mr37648145ad.23.1717584798884;
        Wed, 05 Jun 2024 03:53:18 -0700 (PDT)
Received: from localhost ([1.146.119.152])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f669005d45sm64182775ad.132.2024.06.05.03.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 03:53:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 20:53:12 +1000
Message-Id: <D1S0ZSXXGJFC.2IE9N2O8K9ETJ@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>
Subject: Re: [RFC kvm-unit-tests PATCH] build: fix .aux.o target building
X-Mailer: aerc 0.17.0
References: <20240605081623.8765-1-npiggin@gmail.com>
 <87cyovekmh.fsf@linux.ibm.com>
In-Reply-To: <87cyovekmh.fsf@linux.ibm.com>

On Wed Jun 5, 2024 at 8:42 PM AEST, Marc Hartmayer wrote:
> On Wed, Jun 05, 2024 at 06:16 PM +1000, Nicholas Piggin <npiggin@gmail.co=
m> wrote:
> > Here's another oddity I ran into with the build system. Try run make
> > twice. With arm64 and ppc64, the first time it removes some intermediat=
e
> > files and the second causes another rebuild of several files. After
> > that it's fine. s390x seems to follow a similar pattern but does not
> > suffer from the problem. Also, the .PRECIOUS directive is not preventin=
g
> > them from being deleted inthe first place. So... that probably means I
> > haven't understood it properly and the fix may not be correct, but it
> > does appear to DTRT... Anybody with some good Makefile knowledge might
> > have a better idea.
> >
>
> $ make clean -j &>/dev/null && make -d
> =E2=80=A6
> Successfully remade target file 'all'.
> Removing intermediate files...
> rm powerpc/emulator.aux.o powerpc/tm.aux.o powerpc/spapr_hcall.aux.o powe=
rpc/interrupts.aux.o powerpc/selftest.aux.o powerpc/smp.aux.o powerpc/selft=
est-migration.aux.o powerpc/spapr_vpa.aux.o powerpc/sprs.aux.o powerpc/rtas=
.aux.o powerpc/memory-verify.aux.o
>
> So an easier fix would be to add %.aux.o to .PRECIOUS (but that=E2=80=99s=
 probably still not clean).
>
> .PRECIOUS: %.o %.aux.o

Ah, so %.o does not match %.aux.o. That answers that. Did you see
why s390x is immune? Maybe it defines the target explicitly somewhere.

Is it better to define explicit targets if we want to keep them, or
add to .PRECIOUS? Your patch would be simpler.

Thanks,
Nick

