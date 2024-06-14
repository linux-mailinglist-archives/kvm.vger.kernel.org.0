Return-Path: <kvm+bounces-19642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C67908046
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9154D1C217B9
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 00:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC16C8BE2;
	Fri, 14 Jun 2024 00:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="joOpebNT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916281854
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718326179; cv=none; b=k2Q92PpV/Lg8qmFzSTFIPv0Td8EYzbhP0kFQkUx4Jegc2vFNSapFgzQqW3ZrU5Y3+fW8kXDrasGkM6yrrf3R1UOA2/R2Ou4Ot8z0SZCmSYZ/2HOCOJiZ/AZ3opbOw+ZNmJGpFGxfH3gQ78mBDjLlis6861jagK1YOguMlBBw4rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718326179; c=relaxed/simple;
	bh=RC57j+AFq7qEMzV3k7wcHFKfBu67kGuTJyxXVfTp/mU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=VmYxN2fSozvwMmDhGQHqUoM2L2YmktAnDkSCPr6i00yz1gWBvQgcl8T6yQNcEL7qCqLyyG9EUtBcaZD2S2mexdbKcqXOFdyfsddadglrtgvbwn1kx+1GJ+1/iHynZH8gStu1sw1RWJFRuzA8hRdNPFxKYwmdi2j0eQiV6oHmlP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=joOpebNT; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-681bc7f50d0so1979129a12.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 17:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718326178; x=1718930978; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gm4Hb6i7fbrnH7R8cmzEba7HagJEj2yQb038IW/8vDY=;
        b=joOpebNTls5SEx4i17pllq4DgphaMHWJxo3nwhSNI8366I3NEkUcHDkN/Rng0cGDUt
         uYe2+f8Ek1cbPyooXq0p6SpzpF8f4hWCOvgtk7hihXYd8rYWcZAdNM7jQbuSl25BElfh
         62/+u9CuXVDJjaralNs2zEZ2PYJv0o4WumHRkVFA48Cz3cbcdhrwK67eSNqCA5y2U9en
         m5a2fAACJkaybSOPYIPw0E7Y2Z98mQNN7EUmazFOpWxAxJPQEk05ZDg5ZNt/e53KQCxb
         3IehWgs1vz2Gkl/k5RUG8FTC5MocMOSa8pevrf+hJoSzhSVz5IF28XYk5MAV8IIlJ1tc
         xDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718326178; x=1718930978;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gm4Hb6i7fbrnH7R8cmzEba7HagJEj2yQb038IW/8vDY=;
        b=r2OBGPS5eevj+pbULgoBE6jRg92T6txtTU8DBWLfUDuTEDloM9jF1FHY5Dour34Yha
         y1Sxl0Wie2i6onChZAq5n7e1hvfl3NqonIvbpIkx5meYJR7E+9+0u8gFgu1Zw548y2U6
         NJSBAclLj/3PDFW9x9aoWY13+dfRm1iS/JpkPKAx8pJtu+3RmUcNur0L62Y+rIdMkwLJ
         zTaDi+qNuY3xzigpSANZr3s/LC8/wlyUmkqO6b69H/cYC0a0T4q9DiAsI6FkyiznsvJ2
         yG/4Z6MnlxlGwIos5wOuD+hoAMYIbANdeIhldAAwMuaXBNIax+JonDZMmKAoNF6BrrFv
         oIQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL2djfb6q7e5mKqYrba8NlCsyU3MMWpuHXYpfvZbPNIu88cygbSeKn+6SihklG6PxB+VJhx01ZJe4L3W17qTiNB9Sm
X-Gm-Message-State: AOJu0YycihZ1c9EujLaI4WMZ4vhM3qMBsZRpNeVYaCtHZVYnVZ0R2t7w
	FfqgAuqIKuA0jWpe81ckRTDlq6nNqlr/fkf1QJeFAXBUadSzakM5
X-Google-Smtp-Source: AGHT+IGaYtmVmP0hU994O0pYGub/6u85qNL2lfgJDZUt+zy83kH0//h95HIZI/E35utcJdwAqy1jtg==
X-Received: by 2002:a17:903:40d2:b0:1f6:ed6d:7890 with SMTP id d9443c01a7336-1f84e2cc0b3mr62423245ad.16.1718326177771;
        Thu, 13 Jun 2024 17:49:37 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855ee6a7bsm20424075ad.159.2024.06.13.17.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 17:49:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 10:49:31 +1000
Message-Id: <D1ZBSHN37PW8.DY3DATNS27IE@gmail.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] Bump Fedora version to 40
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>, "Paolo Bonzini"
 <pbonzini@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240607065147.63226-1-thuth@redhat.com>
In-Reply-To: <20240607065147.63226-1-thuth@redhat.com>

On Fri Jun 7, 2024 at 4:51 PM AEST, Thomas Huth wrote:
> Version 37 is out of date, let's use a supported one instead.
>
> The "xsave" test now tries to execute more tests with TCG, but one
> of them is failing with the QEMU from Fedora 40, so we have to
> disable the xsave test for now.
> The problem will be fixed in QEMU 9.1 with this patch here:
> https://lore.kernel.org/qemu-devel/20240603100405.619418-1-pbonzini@redha=
t.com/

Could make them kfail and keep it running.

But anyway this works for me.

Acked-by: Nicholas Piggin <npiggin@gmail.com>

> And there is also an additional problem with the "realmode" test. As
> diagnosed by Paolo: "It turns out that with some versions of clang,
> realmode.flat has become big enough that it overlaps the stack used
> by the multiboot option ROM loader. The result is that a couple
> instructions are overwritten." Thus disable the realmode test in the
> Clang build until the problem is fixed.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .gitlab-ci.yml | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 2af47328..b689a0c9 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -1,4 +1,4 @@
> -image: fedora:37
> +image: fedora:40
> =20
>  before_script:
>   - dnf update -y
> @@ -216,7 +216,6 @@ build-x86_64:
>        vmexit_ple_round_robin
>        vmexit_tscdeadline
>        vmexit_tscdeadline_immed
> -      xsave
>        | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
> =20
> @@ -268,7 +267,6 @@ build-clang:
>        pks
>        pku
>        rdpru
> -      realmode
>        rmap_chain
>        setjmp
>        sieve
> @@ -289,7 +287,6 @@ build-clang:
>        vmexit_ple_round_robin
>        vmexit_tscdeadline
>        vmexit_tscdeadline_immed
> -      xsave
>        | tee results.txt
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
> =20


