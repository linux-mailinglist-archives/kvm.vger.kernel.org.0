Return-Path: <kvm+bounces-19639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F2B90803B
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD720283DF8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 00:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33FF3D66;
	Fri, 14 Jun 2024 00:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxDPtxmo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3162C132
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718325958; cv=none; b=IbP11/1lN1QTvaecRGCHmDOc+C9/nV0a55mwbt4sppGa11nBI+WGEZqCibMe9M09e5MXhBBVtAUT5LLJAblChtmVNxvzkrqCanJJcuyUBNQknmM/fFcrGXyS897HltQPXgWiRmID6JoNWWFNYW9FBCgO49ydFqxzGb9G8dH1D8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718325958; c=relaxed/simple;
	bh=wf50J3Z0LO2AnJbsyOnFa0knSbV/bftXdqoV4OdyQq8=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:
	 References:In-Reply-To; b=udrh/qyUtBxkal/eyXIKR4jAwQK0aE1rXHsUhte+5FSjOdgFAX7AuN5Ys3sLOGEu+/lZY3Yq0OL3A6ZDiryXz5KNynm2rgoMpePAIdx7WluS1AXzhVWu1L7Nw2fzMC8rhYLCIiMwFXj1CJcO5T4KXNbtTqpAQ2JbsOfw+n/De5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxDPtxmo; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f862f7c7edso3751645ad.3
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 17:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718325956; x=1718930756; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VT6V4GqFZFi3+cXJS60Ma9BN93cQbTb5LPJPeaEu/YU=;
        b=hxDPtxmoWuSgUp4uI/qCM6SuC7BCHnoN15+RXzA4TsH4porl1vNEC7j+ytfm0Bv+Nm
         gLtf6o/1b0du2rxpNMPmoWEwdORqE87BeaXSWw+avrtnWMKb+sWaoc2ByyQxZaVZdHRX
         8ok2eOL+i4lItI2OowgxmppvKhPi+paJGEfd5nbMmRK6GUqa2+z/iu0kCZwIfsRKZbuG
         T57GD3r8sjWpoLwuq0exgazBZWRS4cen8u5qlxgaBxhW8nejRHWPA497O4/Eu/Pz58cy
         UVEHgLo0FlfX3KCfTsqWOv/yhwD7ivaAmxc74rKRDKQno//apas6WWkD1ibUMAJV90XF
         Ce+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718325956; x=1718930756;
        h=in-reply-to:references:from:subject:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VT6V4GqFZFi3+cXJS60Ma9BN93cQbTb5LPJPeaEu/YU=;
        b=gEvBkzfyVy/XvHF/525sUwWrB7DaQDFxMB7INxSGCQggAvN5MBbtBpobxxNZE+21iw
         SWhiioU8H1OGGo0oT/ZcqynvwGxfkUnBOXQdf20UtXvLyIN0m3vMZtlgC9kHNw1PiOM6
         Iz0PXydO/9ypNvdtlLNkfzD65bXGXZERDhKjNrjfGKnwAL1QPBFFnsTYYIfIUTP5Hsel
         F9HN+QAaJ7HB7sOfSzL9XB3uBcxFwAMnJYG/5WbZ2j3WOfl1LUqgMrRWnbSURf3oh1oH
         oaEN1iQJerhSV4BtCbrr7nJfzkdoBNeAwqHR12bdbe7ekD8iKhU3z31skI5NHMjVh38N
         lm7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUrcmeP4Ay6Li5z/BuztFasn9gTC2wBFaD4LTZrxjeu2gzbdutfqqNBJwvM/+gU+FuTxlP3l44G/pUuv5YIblkyg6Th
X-Gm-Message-State: AOJu0YwNQTlR95nvaZQ+3uupI6QRMsPVJg3IscAOpcbJkv9oZxpyVlxs
	cL8WqNIaoyioT/U9lUVPDQtVoFbJOQjkPZLCj4bD3UyF0kwihnX/
X-Google-Smtp-Source: AGHT+IFqOhH7vazEYDm4FyscvyOwf66wlp5CwV/1JIdP9lk9A1TcGA9M4s2/RZW9eyYucYBx2bN5aQ==
X-Received: by 2002:a17:903:2341:b0:1f6:7ee8:8935 with SMTP id d9443c01a7336-1f8629fef3bmr15502985ad.59.1718325955861;
        Thu, 13 Jun 2024 17:45:55 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f0251esm20412775ad.201.2024.06.13.17.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 17:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 10:45:50 +1000
Message-Id: <D1ZBPNWUNEUL.2SA91WMODAX9B@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>, "Nico Boehr"
 <nrb@linux.ibm.com>, "Andrew Jones" <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci: Test that "make
 check-kerneldoc" does not report any errors
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240607063616.60408-1-thuth@redhat.com>
In-Reply-To: <20240607063616.60408-1-thuth@redhat.com>

On Fri Jun 7, 2024 at 4:36 PM AEST, Thomas Huth wrote:
> To make sure that we don't regress with the formatting of the
> comments, we should check this in the CI, too.

Could make it a script, but this works well enough too.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .gitlab-ci.yml | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 23bb69e2..2af47328 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -310,6 +310,8 @@ build-centos7:
>       setjmp sieve tsc rmap_chain umip
>       | tee results.txt
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
> + - make -s check-kerneldoc 2>&1 | tee docwarnings.txt
> + - test -z `cat docwarnings.txt`
> =20
>  # Cirrus-CI provides containers with macOS and Linux with KVM enabled,
>  # so we can test some scenarios there that are not possible with the


