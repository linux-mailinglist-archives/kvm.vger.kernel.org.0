Return-Path: <kvm+bounces-14719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D608A6275
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 06:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3FE9B225AD
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 04:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE0D2C1A0;
	Tue, 16 Apr 2024 04:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIOY8abm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5DD17554;
	Tue, 16 Apr 2024 04:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713242135; cv=none; b=PN6up2Rcu2hDY+X6liD1sHz2XNLvNjPY9inSw3+NbcC1a/AhMWbDpOZAwh7rCnRFCw/KTFm8OvxvEpf7jBNzrDv44ndUizFSkMXOBIA+hTNQafEnv/VrCfQGYWZkTGwo5txLPZRZ1kBtg7xAF80v4ByQdoIKefWdHG6wdXeNJuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713242135; c=relaxed/simple;
	bh=cOhgRnNctXUdNJ0jnqCUCl9Xz1y3NSNZO3gnr1MZedo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=LRpLicgy/AiwGVxGI6X8/LhEJJ+SCuVA+xCOVyJgx0HmBg8cEmbCFv/bvnddfwCV096PHrE71agBSuCys1S3kG6o/WLkcbjLNMcXYxFpk+yWHMrtzCuuYTZxPwUZCb9rK0htdhJVc3xcEhDbQCQ7cbaZWDaqBd85tzNiHz5r8Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIOY8abm; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-22fa18566adso2298515fac.0;
        Mon, 15 Apr 2024 21:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713242133; x=1713846933; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLwD5HzpxmeB+EVnNEtNspSSCQV8hfcKNpR+O4Wv5vY=;
        b=YIOY8abmNo+iIGyYi+aBOoG4W7MRy8O8teoNo1VevMALyZLlxMkAFfhlMasJ7rU1tC
         a4Z0ZDtfbeaLiPHmChLqpoytjFAhu3g4RdtewH2Tn4vEWy91yAMGD+MyTkUgzU7cCEK+
         pgFDbkUNvg9pt4s9AAyKLly/7AFA1S29PvPcTbwF8Sra7b4tQQaCR+CsE1hNWWd7ZPls
         BZtFY7l4uQ4Np58dMngVru0MuakEbJpNtV8UjsHAAkcAUsPm+6QqjPnrMOH0uiAHsYGL
         ZVTjBdplKKa0WdQfJ/OqxxmOGjp2lnf1Z+tesFAe57DkYmWkb/r0LEwBO7OFGOYi8Q+2
         7hGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713242133; x=1713846933;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GLwD5HzpxmeB+EVnNEtNspSSCQV8hfcKNpR+O4Wv5vY=;
        b=aQH1JUzE4JWi0Q+psOgbkdhnWdYSORQuQGKgtA0ULaVxrku0Wj80x85iE6O1hZ5tIT
         xn2nNN/b+V4B5fXrB3xHKnL6ohbECnWkenhhuHukEWNdVBOGZNA6oQwUR9DHIl6nbkA9
         l0vZlq5EUektdGi5oarWZcQ0MWrvXOPj4ooVVfbAkHoZ2yj3Ld1oYhoMGRPQWx10/gKA
         thWIMwPPb9uUUi6Ng8NtTR32msjat26WUvGjIkqljbk1YA+R/CRqFbaqwEhoWrnYUZXc
         1gkP/2XRZOaOz561e504/1NPRnAD8WwhaPyjaByq4snlG6LE3I9ZIrhX6ZL8SlKH7eNI
         ubmA==
X-Forwarded-Encrypted: i=1; AJvYcCXCMx8CNK4GM22zJttfXH33tiC60pN4zIKd3Ld7urpUYdgtSiUo3zZtVa6riHOCHGXPr/jWoCI9MSwJdXsmGPJg+yDVSMyWXoe+8nYtcOKg5+sMm04Hc15Llo7rTOLF7Q==
X-Gm-Message-State: AOJu0YwImq8gM841Mo5uGvYL1Lq/N+GPklqWJwKn1bngy3bnwKskIf9n
	kHqRwcQAqUDGjGaMmzbXed7TI+Cn/D5kZCXa3rHyKiJHzKSMZyLP
X-Google-Smtp-Source: AGHT+IE9S6g9yWAyzxiSrTkK0Xnbz1r5P0C/mXjGgRtHJrKsrnnxUq3ZmoOWYvnoFIsnuCl/8FucJg==
X-Received: by 2002:a05:6870:430e:b0:221:8a03:6dea with SMTP id w14-20020a056870430e00b002218a036deamr14305357oah.38.1713242133121;
        Mon, 15 Apr 2024 21:35:33 -0700 (PDT)
Received: from localhost ([1.146.4.136])
        by smtp.gmail.com with ESMTPSA id u4-20020aa78484000000b006ed59179b14sm8047375pfn.83.2024.04.15.21.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 21:35:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Apr 2024 14:35:23 +1000
Message-Id: <D0L9N9ZR13SS.2DNXJZGI7T2BF@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Shaoqin Huang"
 <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller" <ricarkol@google.com>,
 "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan" <gshan@redhat.com>, "Nina
 Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean Christopherson"
 <seanjc@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [RFC kvm-unit-tests PATCH v2 01/14] Add initial shellcheck
 checking
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <20240406123833.406488-2-npiggin@gmail.com>
 <27ba7613-1344-40b8-bc4d-9a9903ebdcfa@redhat.com>
In-Reply-To: <27ba7613-1344-40b8-bc4d-9a9903ebdcfa@redhat.com>

On Thu Apr 11, 2024 at 5:03 PM AEST, Thomas Huth wrote:
> On 06/04/2024 14.38, Nicholas Piggin wrote:
> > This adds a basic shellcheck sytle file, some directives to help
>
> s/sytle/style/
>
> > find scripts, and a make shellcheck target.
> >=20
> > When changes settle down this could be made part of the standard
> > build / CI flow.
> >=20
> > Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> ...
> > diff --git a/README.md b/README.md
> > index 6e82dc225..03ff5994e 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -193,3 +193,6 @@ with `git config diff.orderFile scripts/git.difford=
er` enables it.
> >  =20
> >   We strive to follow the Linux kernels coding style so it's recommende=
d
> >   to run the kernel's ./scripts/checkpatch.pl on new patches.
> > +
> > +Also run make shellcheck before submitting a patch which touches bash
>
> I'd maybe put "make shellcheck" in quotes to make the sentence more reada=
ble?

Agreed.

Thanks,
Nick

