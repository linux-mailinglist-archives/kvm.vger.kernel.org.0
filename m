Return-Path: <kvm+bounces-8954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C11C858D9C
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 08:20:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2317BB218E3
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 07:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CCF1CD0C;
	Sat, 17 Feb 2024 07:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNKAVeRg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A051CAAD;
	Sat, 17 Feb 2024 07:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708154405; cv=none; b=NMlIXRQsb8l3mJ5mQSc5QMslAdXImtnY3aYjGebLv781TljkGRdgAVMmVRKU+zB+i5Xr95j8wkVbgJqMBOA6bc/7+7TlF7JedhYIUDy/XCLu3xHR6SQ3j3g2wtnMViGAEwYALdQanLP7M3JLBeUen+Ri4QYLj+kyee0SDQATWfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708154405; c=relaxed/simple;
	bh=0r/mcDX9INprGCcwU6dSv7nrT7Y62HTCBakDChmI/xs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=oTGblXX3spPFds3eEJm/Dw5krR4YCC2TKUgQZcH5Tr2TGozJI/V0g02QO2HSiIn1qruDuA13zTBVk27MQoLeah7cBL7emZLiCmkw5A0nNn6nozXD+ivHJGf7KUGUazuRlNJgcSeO5hdRjDwBnKnpPpwhUjb2kgO0QSiaUd1m4dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNKAVeRg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d751bc0c15so26487645ad.2;
        Fri, 16 Feb 2024 23:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708154403; x=1708759203; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfIxsLt7/ArIHKSH0XLbtdtiRdY5BKjg0yAd6fCtPMY=;
        b=eNKAVeRgwkqS0rQVqCwxgWS87ZTX8fTGUJaP6AnJaq/cV9MXFK48se5BgQfbXjES+T
         enKpQ09QJmtzRowt2N+F2JGw5M/PVLn9T3okEZV8WX/8BrKu8kZox5vmxPGyvtxYGZ8P
         OEquvwKpNUoBl9Mcmu6Zl/sxu2xsn6QjMwN9xUQVEmWQ0QPd+ynCTlntoyhVTT6rzUAv
         bWYaArG7i6E1Tu4wlddAJFdVUlxHnqVonk6/rNrZar3mYSoq9DrhrHmdwjVzNunHNlas
         bvXbyRmcrkggIVO+4pYTzEbXxCNL2sBR/vawtq3Wizv6NEOtrQWCkv6tDgeOwhKlUj6R
         US4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708154403; x=1708759203;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WfIxsLt7/ArIHKSH0XLbtdtiRdY5BKjg0yAd6fCtPMY=;
        b=Q8KfJptUnKKojWzyZnL9qZhgEMgSu9eNYRomrh5cU0i+3QOYBD1A47sXCxL+jcqmEa
         AtyMaIQ7NKs5dQ87ossbLZ8O3tHTgN1vIbXg/GEPyMfA84iAq+eM5BN8s/fBPA8ocECq
         +7Zv39zjn0J0qnR4f6UXxLBSciWmzhCeaamkFd9ik4qidPTdvCQqwDluj9tcVcsfKX46
         nkd8uan3UeI2qzaBuro/qCEJkHZ2/HPa7MXJFE5ObyUVPb+FMhnxt3FzJtpjoPOK1mbI
         aVNgsNGJbyJA98WI5OUTLXEUKG5s+Qe0s6xAUIuS98NGOChnOOJ1U8sbGfKJsEkDp8Tl
         U+/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPzobTENHhhd5DhJMPjmLCzsgYnnOXqD5s+PdlAZjJhK5MlzRhIJe8NcJlXGtSrs14TytghYJqPU/stbHBltEhT2rFYtTSci4cag==
X-Gm-Message-State: AOJu0YxAMaPaE+GXgcPP2wY30+7udrbbfVBmQB5l++3vOS9kt6vqmHBT
	HyDwsihozTQdNPPrjK/e4aIoIkOEH8C/YL5fEPlxLtQKdVL8OoX2
X-Google-Smtp-Source: AGHT+IHeuo0k9fAN0txniwLyphYby2uu9UX6Hw/WFiRGnP8mxfVbUdCFutgfkGyqtdVbG1X9PA0DNg==
X-Received: by 2002:a17:902:dad1:b0:1db:4df0:a31f with SMTP id q17-20020a170902dad100b001db4df0a31fmr8038401plx.6.1708154403370;
        Fri, 16 Feb 2024 23:20:03 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id w3-20020a170903310300b001db4f25b168sm868865plc.255.2024.02.16.23.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 23:20:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Feb 2024 17:19:54 +1000
Message-Id: <CZ7673PUQ853.DB10GSBEZ65Z@wheely>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH v4 8/8] migration: add a migration
 selftest
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240209091134.600228-1-npiggin@gmail.com>
 <20240209091134.600228-9-npiggin@gmail.com>
 <abbcbb47-1ae7-4793-a918-dede8dcaf07f@redhat.com>
In-Reply-To: <abbcbb47-1ae7-4793-a918-dede8dcaf07f@redhat.com>

On Fri Feb 16, 2024 at 9:15 PM AEST, Thomas Huth wrote:
> On 09/02/2024 10.11, Nicholas Piggin wrote:
> > Add a selftest for migration support in  guest library and test harness
> > code. It performs migrations in a tight loop to irritate races and bugs
> > in the test harness code.
> >=20
> > Include the test in arm, s390, powerpc.
> >=20
> > Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   arm/Makefile.common          |  1 +
> >   arm/selftest-migration.c     |  1 +
> >   arm/unittests.cfg            |  6 ++++++
>
>   Hi Nicholas,
>
> I just gave the patches a try, but the arm test seems to fail for me: Onl=
y=20
> the first getchar() seems to wait for a character, all the subsequent one=
s=20
> don't wait anymore and just continue immediately ... is this working for=
=20
> you? Or do I need another patch on top?

Hey sorry missed this comment....

It does seem to work for me, I've mostly tested pseries but I did test
others too (that's how I saw the arm getchar limit).

How are you observing it not waiting for migration? I put some sleeps in
the migration script before echo'ing to the console input and it seems
to be doing the right thing. Admittedly the test contains no way to
programaticaly verify the machine was migrated the expected number of
times, it would be nice to try to match that up somehow.

Thanks,
Nick

