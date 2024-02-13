Return-Path: <kvm+bounces-8577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AB685230D
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 01:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 082651F21A5E
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 00:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB7D79EF;
	Tue, 13 Feb 2024 00:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WS6pgQjB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C77747C
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 00:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707783343; cv=none; b=Qgc+FK1LBXoGXMXgxPrS6YCvaCncuGExv9t4Ktee0XcxoFDlgVI464069y0eAnEuhS4H3yB3HOSjQjDYZ3I3mls6V9q4Y4GNt3bM2g9Frj35st6FPrmB+0tf9QCgFJGwnkTmxebWKA7EklL36kreb+eli4R7lOiqawWk6sqvbfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707783343; c=relaxed/simple;
	bh=ZcFoY5ZEo7lqTmg/W+sT9Io+9hDMm4y9c26cYdg4Zto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TWUSkFr43Kye3rQDx7Xzq4kUXsm3wGy7dQ7VS1KDT4mBvCKqVpyohnZgryEaGEHvfPuU9vYSdms5uKKwlNvYFRra77gncYnDABPiZFQyr8QkxfoBi2RqnldE1F7IGc/GyBZzqEkBz0yhHf25e7BACOmWecTy5bs6iw23ZXmbvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WS6pgQjB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1da1559d20fso27718685ad.1
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 16:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707783342; x=1708388142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F8m/Uv544GTXUPDpKb9f2WygW9/WqUJcSV7kQLbjOvw=;
        b=WS6pgQjBHDFUCcXt2Co04SNDqpcify7J6JI95vmxU40WDCnJmCKYE6Ajetqf5bt/LT
         baizBb/rHyqealT88waRAwTfEYATN5AdJVw4xe3rPvZzgrV/CP0M0IWv+AoWNhBVkWbu
         EXL9PjL0bV0djI+LiVx0OOZJDpYZ1yBsZokGBjj0qowjyRVsdX0E82doGaay5UcMIWzq
         Ee/bXgvbm9IKK2mhcBEu5tRF15QwZaiFJNGNlld2Q76IUMJ9N4cC0Zmf8O/sY9Ol9RtF
         77eS/2+Yh9qGPwGFk+Fs1hq1njGCFv1OWXBHlEdD0kZGt/nV47KwW6f8u6dBfxkauepr
         COgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707783342; x=1708388142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F8m/Uv544GTXUPDpKb9f2WygW9/WqUJcSV7kQLbjOvw=;
        b=t4wRfE4mrEkUgq9KKIdcmOD2qSkozUzL7FQu1WYVhJmENScd+MT15xpFEbNnCJhFSJ
         HaPLTZ0hWGAti6jhQfELqeHBeS89lnQ+ThZuhF3x+vEwrChiQHds7Dl5x2nIrBiV1WJq
         nBjoWLPYs7LZJ4r0ySlMuBMRNanyex82hrITwiTULtRAsLndR3gG/QBVKZxInMchUJ+C
         n3DThsRT1bNBbXmZTHIQFbiPZu1jBN6ud76hVyIdjgTy9Lqcu4OrKfOUO+Q5KNnWUqNy
         WXDg5JdZVf+45Wmo98y4MKHO3lh2JZAem1LgHruG7IlQUVr6kbsoIhiSyVg3MPeRE1Kw
         97Ng==
X-Forwarded-Encrypted: i=1; AJvYcCVHRc58L2yOEqLNWEn+sj0tZosBQwgh6ILYKKoG5g/8AT/cWDtF5i6NMpghO2zQ5E5b/8pAa/bKIg8FIr9HXU/m7VQH
X-Gm-Message-State: AOJu0Yx4bXLXD8xc5WKkoiJO2y4yalxIb/jK5c/S7gocuAaXXpzVYgaw
	5ah1yPbptGyeWt2I7FOTsZErfc0KVEJhMr1SGb76swZy3C3NC1T0Rh9ohYVgLeWRUm0noX2Fx58
	uEw==
X-Google-Smtp-Source: AGHT+IGyUzAwDS4yq3Uo4MVsgMTl9VONsf9vw6/dk7qFnwfDtow8fZ0mh45RNp2sB4nj9qB1af5Uk1i8dA8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:27c3:b0:1d9:f491:7732 with SMTP id
 km3-20020a17090327c300b001d9f4917732mr2818plb.6.1707783341588; Mon, 12 Feb
 2024 16:15:41 -0800 (PST)
Date: Mon, 12 Feb 2024 16:15:39 -0800
In-Reply-To: <CAHk-=wiKq0bNqGDsh2dmYOeKub9dm8HaMHEJj-0XDvG-9m4JQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com> <CAHk-=wiKq0bNqGDsh2dmYOeKub9dm8HaMHEJj-0XDvG-9m4JQQ@mail.gmail.com>
Message-ID: <Zcq0qwfjrOYPeR1h@google.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
From: Sean Christopherson <seanjc@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jakub Jelinek <jakub@redhat.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 11, 2024, Linus Torvalds wrote:
> On Sun, 11 Feb 2024 at 03:12, Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > I'd suggest the original poster to file a bug report in the GCC
> > bugzilla. This way, the bug can be properly analysed and eventually
> > fixed. The detailed instructions are available at
> > https://gcc.gnu.org/bugs/
> 
> Yes, please. Sean?
> 
> In order to *not* confuse it with the "asm goto with output doesn't
> imply volatile" bugs, could you make a bug report that talks purely
> about the code generation issue that happens even with a manually
> added volatile (your third code sequence in your original email)?

Will do.  Got a bug report ready, just waiting for a GCC Bugzilla account to be
created for me so I can file it...

