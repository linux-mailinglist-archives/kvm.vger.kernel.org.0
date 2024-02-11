Return-Path: <kvm+bounces-8519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E32850B54
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 21:00:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F9E21F21F8B
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 20:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70965E3BA;
	Sun, 11 Feb 2024 20:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DHNepSWW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004495D487
	for <kvm@vger.kernel.org>; Sun, 11 Feb 2024 20:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707681612; cv=none; b=KgybAoJ/IiMOy3ZDUh4vPcSlVamQyQ+nXD/zl9oaj83KHwlfzPhFgPWrslz1V3APHG2Vx5lKjBNDv16gEv4Y6dRCa9cpUFU67ywGhKrQsgqpchm2oEaVq1X9jMX45OzMmEUHIDODiadVvTBvB7836Ec+Gacc0Fdm79O84GPp/Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707681612; c=relaxed/simple;
	bh=yHcIHSK6i6VhUKzbQ7HCE1nMkKO6GXpkQD3eG2PRvSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cqtKb2cdFjY93e1WC3CQlavD0kmwlTxSSVWdYuA43bdy7jNpf8s14myR8904IjLWgbjKWpPfIhj9yG/s60+gMx1581wDzRlirUOjfx0UFZWtXzXUI55zMJxpqb6a+uynkPzzWZ7nm1Ep+gvqeDPJ8KwKv4kH5u0GQh9qtlCEPlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DHNepSWW; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a29c4bbb2f4so324656566b.1
        for <kvm@vger.kernel.org>; Sun, 11 Feb 2024 12:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707681608; x=1708286408; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J45x/tj4nmdlGBDAbOeZG0/l8SPCbpFWq5LzEROciCk=;
        b=DHNepSWWHtEwK0HfiDSBiEflo/iN3ySNLlcWi4slhaJ/v7jSlPqm/pzwfPVG/mglx/
         ujVWa8sBc/ad7Tk+oGZ55ZxkVTmo2WMIQzTw+zc03lco9goaAFA+oMzLq5ERSH1C9n9h
         aMWhyKY7NoaGz6/mtKClGIO1p5m3rYVETmoXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707681608; x=1708286408;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J45x/tj4nmdlGBDAbOeZG0/l8SPCbpFWq5LzEROciCk=;
        b=Q/lKBbm+0rh14OxPZbCn0NphjUQvEB8fDunBG849wG6LO6fJxN46uimITNGfMZdaU6
         feME+f7ibaixJcTckZ+AJhLEYe+aizii3RQyPaMIoHQu1thOjueKo4cLAV4g1F7Aartg
         HKyxSZysZaqKHCOJRVLaSDAeCjyMkKoxNIaG+hO4b0rxy70xvpF1sdNm3wkoA+Hels6h
         eCFiu4XsutUlXsOcS9Z/scMs4QNrVncsvHYFqiiIh2EOprULSkDHHKOT+HPd2eEB6xsK
         f0/qhrjiNdnhQLiGhIJwxI4+FY3sV0fCjWywZz43x/3d+pcGdK9kSaUGg3YZAxH1CE7v
         h4xw==
X-Forwarded-Encrypted: i=1; AJvYcCU3HstZuBMKypgsKp3LslqQR3YNMo5okSrOyZkDy5Z3TH/fkWfBFkddp0XZc1RNlUqaw3ic2Z3L5A3BWwbUi0IC4QRA
X-Gm-Message-State: AOJu0YxhdkL32jxxAMeRItPvNYD20KmfwUBty03MVbeVIV4QntNHYZ06
	OWurBEC6U5J69ll2OmZK6Aj9GRCQk3FHF7AWhRWLqcfl9Jewa5Fmw+v8e+Ny1kViJObr7XtVnCs
	oMuo=
X-Google-Smtp-Source: AGHT+IFqH6ZxwIvSw4tTmmP5/C1SrMlxesscS5hzIo1nTWdVNWhR0/XjjPof5H2nh+3pCOZuE/RDjg==
X-Received: by 2002:a17:906:b84f:b0:a3c:9cc0:7d61 with SMTP id ga15-20020a170906b84f00b00a3c9cc07d61mr616221ejb.61.1707681607837;
        Sun, 11 Feb 2024 12:00:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCULDehmTo7Z5h8Psnrkxw6O3lmcCKjk1ZFPNLulUR5nLmIENEjgdvapaT8su6UeHArNNmL3R99miCohjzezw+VLRkwe
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id vh6-20020a170907d38600b00a3c838b0f1esm774591ejc.31.2024.02.11.12.00.06
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Feb 2024 12:00:07 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-55a179f5fa1so3334726a12.0
        for <kvm@vger.kernel.org>; Sun, 11 Feb 2024 12:00:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX3Zb1/DgfYd+7PdXqSlEwozr7k7utH5E1Q5+0ETtzcsFVKvuQwUAgnEcSM8QWGTqMjIyg7OKVmUe7AY2uRQ9Wa7rIf
X-Received: by 2002:aa7:da4a:0:b0:561:3880:ab14 with SMTP id
 w10-20020aa7da4a000000b005613880ab14mr2854639eds.26.1707681606348; Sun, 11
 Feb 2024 12:00:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com> <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
In-Reply-To: <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Feb 2024 11:59:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiKq0bNqGDsh2dmYOeKub9dm8HaMHEJj-0XDvG-9m4JQQ@mail.gmail.com>
Message-ID: <CAHk-=wiKq0bNqGDsh2dmYOeKub9dm8HaMHEJj-0XDvG-9m4JQQ@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Jakub Jelinek <jakub@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 11 Feb 2024 at 03:12, Uros Bizjak <ubizjak@gmail.com> wrote:
>
> I'd suggest the original poster to file a bug report in the GCC
> bugzilla. This way, the bug can be properly analysed and eventually
> fixed. The detailed instructions are available at
> https://gcc.gnu.org/bugs/

Yes, please. Sean?

In order to *not* confuse it with the "asm goto with output doesn't
imply volatile" bugs, could you make a bug report that talks purely
about the code generation issue that happens even with a manually
added volatile (your third code sequence in your original email)?

> So, I'd suggest at least limit the workaround to known-bad compilers.

Right now, I don't think we know which ones are bad.

If it was just the "add a volatile by hand" issue, we'd have a good
pointer to exactly which issue it is.

The other bugzilla entries I saw talked about ICE errors - and one of
them is quite likely to be the cause of this, because it really looks
like the code issue is some internal confusion. The asm that Sean uses
doesn't even have an unused result, so even the volatile shouldn't
matter, and seems purely a case of "limiting optimizations partially
hides the issue".

And then us adding another empty asm obviously does just even more of
the same, to the point that now the code works.

So I don't think we actually know which compiler version is the fixed
one. We only know that gcc-11 doesn't work for Sean.

                  Linus

