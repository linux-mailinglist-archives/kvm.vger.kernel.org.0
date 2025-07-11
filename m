Return-Path: <kvm+bounces-52204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9C9B02611
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 218655C3A8A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 21:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457AD1F09B6;
	Fri, 11 Jul 2025 21:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KiNVHY1U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BB81B414E
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 21:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752267756; cv=none; b=AWP6QkSVI/qzBAMHmvXQGIMpGBEm2QVXxLwx83son0KvRGo8svZB77cisnEKYTzsBBV2fieY/GAPET6PhSVmGMRDIcxi/9egD0UV17l/RuSR8bYrE7n63UyorJBuLCaKXtq8aSLKTONLcNKCjqZ1O4zPaPwU2EVaQkiS+S9/diU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752267756; c=relaxed/simple;
	bh=1oYrVlJ3uE3Qwi3bcjrfiVQw+/6MI5IE+S4RFoz2UP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rh9DlLnSfNwCzFniwojD9/5bt21xQPkSNVEZmWotBO668SEv1bP+DJP5TqgCCo/eyZ2qEP10InCxpQ3SGSS5Pm6dTLJp99X9jS2dXnPqY3g+kdaFpHeLiEDOW4a+O4vTvMcwjRJVuqHfK5VbEZihpGFAIxfjcZC48mxnp4rp//M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KiNVHY1U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752267753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B8wqL7cjLc9wrp/M0s58Eu3w42p4LxpTNqj9aXGf6TE=;
	b=KiNVHY1Ulr+PmB3UsfzC/RYHfmYdKQ1EzhXfRwHFh2aKJPSxu7LIwGzplTTmhmjPuWYYTE
	8+PpFbc5uimjYZokYYby0Mv6I7Rmvv/C3NJurn1UFHI1G1mUrMf0CnEH6EkYtnFBp5DHQ1
	jhFZASRDSPoGMIdGdT5qU4WeO8SSi6s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-5eGQMS60OlK-XyqdoCvsrA-1; Fri, 11 Jul 2025 17:02:31 -0400
X-MC-Unique: 5eGQMS60OlK-XyqdoCvsrA-1
X-Mimecast-MFC-AGG-ID: 5eGQMS60OlK-XyqdoCvsrA_1752267750
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-607434dbc78so2539618a12.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752267750; x=1752872550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8wqL7cjLc9wrp/M0s58Eu3w42p4LxpTNqj9aXGf6TE=;
        b=F9Q2Gj3g+/WBXP/ZMsvvOW+SMnSAFaxRPHbVyXXYxgKlCIieT0ETjBwuDpIzB2tymq
         jbe4GsTf/zNfwN2tE48QoY1EGCKydVK/K59EDp67OE93d5f1xJR6hRRVEW1AKDLyZAcW
         B2M4cOZNGXeUlcFjNnVL66uDhmHZJpK9xEaUcil4zIDC7r/jjKjfI5hZp07zN2bR3GGJ
         MYtnHAZt9bmp8ck2CBHvEGVb2yZmrjHLUoSjnnlB7vS9V7zte+OxkGOTQ87vx8UEEzIb
         f9U4BArUBR8XTxmJeU7MJlu5ti3Wzea++5f0txU5r1z4S3SR+VK2BNSsGtPfBv/azokb
         UtAA==
X-Forwarded-Encrypted: i=1; AJvYcCVfwPu+Uk5cf0tDCAno/ALhine93oMbW8Ol8xPoHyLstGrRiJrEMuN4nlJpG1zDEcLSeno=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuVkWdTt7ZJbSA8VghwyPr7vpjpMk/o9MJ1CP+sIp+i4CLfKeq
	kGOxxm0aVf8k05fXod9Bsgd1Yi+24P3Sbuyz3Zi4E8/yWpyABkqoDvnJDCcTk/Fko5yAhEmyKTG
	doyTh9Vp+jcZ5vgmAthOeXHhgoxMBBNe/ylS2mi/FBomknh7zem0O/g7GvKzMBqHvhCo0p22r+z
	t1dbvTJWPhgUt9u30NOy5zlMwD85yd
X-Gm-Gg: ASbGncvG8tiA6IGQxAC18llvtKxPMG05u2LVx0NH2qIozyc1C1YWkXnzkL+9R1JLe30
	aZG2z7LJeyW2UD1Honqii0qRlBvcAeBtWL6b6ZrGGb1XA3M/v/tNJhp9Zw/6PCsJvpY/xpoDgPd
	C+poUp4XnnESlWZfsdp4NPjg==
X-Received: by 2002:a05:6402:20c9:b0:607:f257:ad1e with SMTP id 4fb4d7f45d1cf-611e84ad4e9mr2950270a12.22.1752267750345;
        Fri, 11 Jul 2025 14:02:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH83FFTu2jsAw1nlpLlMtsjXIeiEGRxdDqdXdoTELtLHJ1dyi7MtcZP+zW6IgfrCrgu9h4FoDwTNGHCP3jNFNM=
X-Received: by 2002:a05:6402:20c9:b0:607:f257:ad1e with SMTP id
 4fb4d7f45d1cf-611e84ad4e9mr2950253a12.22.1752267749955; Fri, 11 Jul 2025
 14:02:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711053509.194751-1-thuth@redhat.com> <2025071125-talon-clammy-4971@gregkh>
 <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com> <2025071152-name-spoon-88e8@gregkh>
 <aHC-Ke2oLri_m7p6@infradead.org> <2025071119-important-convene-ab85@gregkh>
In-Reply-To: <2025071119-important-convene-ab85@gregkh>
From: Richard Fontana <rfontana@redhat.com>
Date: Fri, 11 Jul 2025 17:02:18 -0400
X-Gm-Features: Ac12FXx9o38iv3wKGucEiB-BlcHSskPmrdROt4FLG3oX4rus7oZ3AtWQf9LYTm8
Message-ID: <CAC1cPGx0Chmz3s+rd5AJAPNCuoyZX-AGC=hfp9JPAG_-H_J6vw@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Thomas Huth <thuth@redhat.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Thomas Gleixner <tglx@linutronix.de>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-spdx@vger.kernel.org, 
	J Lovejoy <opensource@jilayne.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 3:38=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jul 11, 2025 at 12:32:57AM -0700, Christoph Hellwig wrote:
> > On Fri, Jul 11, 2025 at 09:30:31AM +0200, Greg Kroah-Hartman wrote:
> > > That's a crazy exception, and one that should probably be talked abou=
t
> > > with the FSF to determine exactly what the SPDX lines should be.
> >
> > It is called the libgcc exception and has been around forever for the
> > files in libgcc.a that a lot of these low-level kernel helpers were
> > copied from as the kernel doesn't link libgcc.
>
> Ah, so it would be something like this exception:
>         https://spdx.org/licenses/GCC-exception-2.0.html
> but the wording doesn't seem to match.
>
> I'll let the license lawyers figure this out, thanks for the hint!

This one

 * In addition to the permissions in the GNU General Public License, the
 * Free Software Foundation gives you unlimited permission to link the
 * compiled version of this file with other programs, and to distribute
 * those programs without any restriction coming from the use of this
 * file.  (The General Public License restrictions do apply in other
 * respects; for example, they cover modification of the file, and
 * distribution when not linked into another program.)

is `GCC-exception-2.0`

while this one:

 *    As a special exception, if you link this library with files
 *    compiled with GCC to produce an executable, this does not cause
 *    the resulting executable to be covered by the GNU General Public Lice=
nse.
 *    This exception does not however invalidate any other reasons why
 *    the executable file might be covered by the GNU General Public Licens=
e.

does not seem to be in the SPDX exception list. It is very similar to
`GNU-compiler-exception` except it specifically mentions GCC instead
of saying "a GNU compiler".

Alerting Jilayne by cc.

Also, and a question I remember wondering about a while ago, I don't
know how SPDX treats situations where, as apparently in this case,
more than one exception applies to a license grant. I don't think SPDX
syntax allows `GPL-2.0-or-later WITH GCC-exception-2.0 WITH
{some-additional-SPDX-exception}` or
`GPL-2.0-or-later WITH GCC-exception-2.0 AND {some
additional-SPDX-exception}`, i.e. I think SPDX assumes that only one
exception will ever apply in a given case, although the `AdditionRef-`
construct provides one way of dealing with this.

Richard


