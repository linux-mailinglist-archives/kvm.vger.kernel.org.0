Return-Path: <kvm+bounces-19638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3560F908035
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7171283BBE
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 00:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B49A2107;
	Fri, 14 Jun 2024 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYE7Ihh3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1091479CF;
	Fri, 14 Jun 2024 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718325829; cv=none; b=hclxoOtvjk9TyjUojSrznY54Vu9ozXcjh+1eK9mGwf/kNN8EJuIYWmRSdhRQCiixRj4lLMk4SiNxLaa4rB/xWckgJ2EQMclYoEPs3WAPixhglJ3hg/4RODd1ywIimOQ7eUNM3/kpn5LH0QtmX2wmwMx7HlOwSCIR/dqI1T5awO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718325829; c=relaxed/simple;
	bh=YeGjlmbTI36irvbQqfOfz9A45ri6Xl8G0t1fxDrHCI0=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=Ytgfl4hs1b/F184X4wSdQ9On14/heAHPLu06YiFdRCdE0n8vEQBOmXaAi+A4vJni8MU93eLsM5PZPh8BBmaYFPbTfacKadYzvWfTaqU/4cVvM5kn0SDklDgY+fAmhGsm2nK+INHzmw6cIZEFNRVlEKFCvUr1OyUgznw0aQ7eWNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYE7Ihh3; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3d21f7cc6c0so860063b6e.0;
        Thu, 13 Jun 2024 17:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718325827; x=1718930627; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eWVs6LwRBJG+U3k9Ejxz2oBmjdXJxvB7EaltXDx1Yc=;
        b=iYE7Ihh3VVeui8ItJoBHG9KNp61ClbjEP30nUMlBz/fcDwnHp+7Q8w7VzqeGg805oT
         6JX/4OTbDoyDZhFy/usDc9cJdLKZSBJVTBwjJ8SfOxLk29agN7j6vVyO5tyc18gOu/yt
         kizMCYRJguAs2fGC08CBHbK6BdtUMHUngx2IHnT4bB+YOiuBiR+YgxYSbIg0CIq2/ujh
         Ktg+UISo8enN5NjPutxVcGRmH8YJYGzfoFkApuY7wTBkEWmcJ5/bHSLSHhHed0WMs01i
         kGR1oLd1uWXdJ32YwEt7MyMGablYpDjUpo4QfjiurWRY5ZIY4FuV1r9rP3OVJvaNLdsR
         EXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718325827; x=1718930627;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/eWVs6LwRBJG+U3k9Ejxz2oBmjdXJxvB7EaltXDx1Yc=;
        b=Dbs0iTFnYcDigrTqD2KKkKMNT4LTrLfmkhBnYkoWJWDw4RmaKxzei31R5YMvZbjd98
         C2LZbJ1aDOQw4GZo9zbiea/mZE017qWfHTO+ixRYhCbYBay5ErCQ7NQGQ5fB2h2PJpVu
         seO1AKc2ZdclTwM/jXC5KIOZmqjVhOto2AlEXSe8OG03Q0l7gWvdNfplB2fV722XuV2+
         q9Tu4Vi7W+7HB8D21/rCx0t3sapkbpAfL3/77C/cFqfYS5mdECKmgbSOi07b0i2YSjaL
         s3ZIR+nyUrBRJtYW7h6VNkAIROYSUGMAO1FJV/tZQ7ZbNgiVK9GJkLdwF1slReGd+PHW
         xG7A==
X-Forwarded-Encrypted: i=1; AJvYcCV10Se6tJPk1maIkIyU0o7DTYg+Ci0bjU5HkkTbf2Ij8fwA9ML1i05xVvvxO1n+257OLxqNZzqd3HWWdp9kHSgxtYrFYPW/S0UgcP7oZYXCzzX0AU1sHRecINY48xRFQQ==
X-Gm-Message-State: AOJu0YwRQrwiBxqt1nN82HcmpLop+0Voe1EDhIoDvkYf3PoN+XJWniJV
	/VOAqPyWkxsOwJxssqzVxS9nwovYeHcUdwN4jqZn3Ugt6P8cWyYj
X-Google-Smtp-Source: AGHT+IG/WsixQvvfFJeL2cK/SvFU0QWQIcY3fHQHS0r/xzXjpdjaDngQ5f4l/dQsk2QM6rvOkN+UjQ==
X-Received: by 2002:a05:6808:1992:b0:3d2:24d3:80f3 with SMTP id 5614622812f47-3d24e9dc797mr1382862b6e.43.1718325826876;
        Thu, 13 Jun 2024 17:43:46 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc922643sm1950344b3a.31.2024.06.13.17.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 17:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 10:43:39 +1000
Message-Id: <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
 <linux-s390@vger.kernel.org>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <kvm-riscv@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o
 targets
X-Mailer: aerc 0.17.0
References: <20240612044234.212156-1-npiggin@gmail.com>
 <20240612082847.GG19790@gate.crashing.org>
In-Reply-To: <20240612082847.GG19790@gate.crashing.org>

On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
> > in dependency chains that cause them to be made as intermediate files,
> > which get removed when make finishes. This results in unnecessary
> > partial rebuilds. If make is run again, this time the .aux.o targets
> > are not intermediate, possibly due to being made via different
> > dependencies.
> >=20
> > Adding .aux.o files to .PRECIOUS prevents them being removed and solves
> > the rebuild problem.
> >=20
> > s390x does not have the problem because .SECONDARY prevents dependancie=
s
> > from being built as intermediate. However the same change is made for
> > s390x, for consistency.
>
> This is exactly what .SECONDARY is for, as its documentation says,
> even.  Wouldn't it be better to just add a .SECONDARY to the other
> targets as well?

Yeah we were debating that and agreed .PRECIOUS may not be the
cleanest fix but since we already use that it's okay for a
minimal fix.

Thanks,
Nick

