Return-Path: <kvm+bounces-18842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4D68FC14D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 03:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55CDD2857FF
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABC250A6D;
	Wed,  5 Jun 2024 01:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RximsjGi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1345E8F44;
	Wed,  5 Jun 2024 01:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717551065; cv=none; b=k04rHuJiuO7BuTryiJ9lZzpVnYCeGKM8nsfi04n/h0LEBQoxNZ7HhTbx+N+lhmrWM4Anwh3GnmeaQCvNqSgJPmXOhuH4J3D4oxBYTG/xZRHRn/ojw8vwjTuULw0QDZP+hBnp1gl1Qu3y/+RNEdyvdVsrWH+/pe3j803Ku/TIxkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717551065; c=relaxed/simple;
	bh=oMFqjyaNUaUW7MZyO8At6a0sBvjCvmFopXWwzRxaLoM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=RrmJU3mYOMhSRLsqJli9Tf0b7L0vwI7XoKjcnVhGkhuHPXW8S2cH5neCPTkBeSNmGpVk6L0jHHG9ljzuWP+rUWY583YGPno6mpR0L+2VXqRoiONC44mPiKarxE60KOC79m8+Mv4EvsNCCG2XQslDCfokD5KmNeY6HX9mK+hqrDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RximsjGi; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f63642ab8aso38653595ad.3;
        Tue, 04 Jun 2024 18:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717551063; x=1718155863; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMFqjyaNUaUW7MZyO8At6a0sBvjCvmFopXWwzRxaLoM=;
        b=RximsjGi5RC4LMj7G+qT9pPhzuqZgCSqSlpbwmkCvLNeqBMwPOWTCrlLSDmnvZP6P6
         0M5SGa+TARKK5jD3ghqMrQ8dP9j4FwIlSNtDAJKDr+sWiO+48zKVELNKjsuDaG3oyCee
         w14XdxNwHoruuSLc20qmJrSY7BN1c2VwaiOEH9MTHbQLxAFjQwHxszkjUNiQNTU03jr/
         UGmOOCCQFNyLWgFjSb2ytf0D5zHDAf0LtlbsFamfhmDqWQYIYVgiy0+MASYgJV01DpVC
         VJTL58dFfmN4Vq+H73iFTizoD5QEM28sSG7v8KmLjpiBoL/5b+vB6G66Pv8vdzwL8rDQ
         NHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717551063; x=1718155863;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oMFqjyaNUaUW7MZyO8At6a0sBvjCvmFopXWwzRxaLoM=;
        b=BlVYJ0Bp6woBqEH2c3b2fygL7Nawnuw+56RnvKks6qW/3AxZKk2NkTxzJzWvimwQNB
         64xgc773WiuA5ooto6ltFPO2amRd3aR1isfuUTvK9+Qqvsk4eePvXihHdCdNgcAFe9F5
         bN0WSHV4EPE7opqp4n57u0PG0iVU3u9+oZJWpOCzHoFWhNLk80dhciOa09pnWav59HzC
         oDgm2OfYkeb4kW7/NQoKy4NJFmbaCI6WfCPN9a3fFKzzH7Kzp6bhWVRRm0iFq8gRH3dT
         ayggQLaAOpPPo8u++jSZJQjSz27m1zT2uRbxWKeUMWBbnGEvgXozslzBhbPQSSgnbBqB
         VUlw==
X-Forwarded-Encrypted: i=1; AJvYcCVW/JMrnpbgUeJfueO3DB7/Vr2SRdEZGNGRDQEx35UOswoRRG+w7FQP+bnI3k7kE1oPIvqaXQEH9bWG4Xgq8nRC3zmU+MPkdR/h3w==
X-Gm-Message-State: AOJu0YzaZfJ8s8bM56ECIyciYtsaFV67wAk7K/cZ0YLc9GKvT8ioRbNz
	4dnJwz/Cq0UYKCTK1ffmkwGfGEzD6ngdX8hwwQ9vsBvyk2CzYblW
X-Google-Smtp-Source: AGHT+IEQdfGcTnAmLkVLYq/CG93xdrvKP4ywajLlyP1F1uOtFPKBicgv5nQvTdWwJeOkUUu/zU2ZfA==
X-Received: by 2002:a17:902:e5cf:b0:1f6:6cd5:d030 with SMTP id d9443c01a7336-1f6a5905e98mr16233765ad.1.1717551063238;
        Tue, 04 Jun 2024 18:31:03 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63242512dsm89889705ad.305.2024.06.04.18.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 18:31:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 11:30:58 +1000
Message-Id: <D1RP1BC65XW5.NC0D2AFAL0TD@gmail.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>, "Nico
 Boehr" <nrb@linux.ibm.com>, "Steffen Eiden" <seiden@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] s390x: small Makefile
 improvements
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
 "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
In-Reply-To: <20240604115932.86596-1-mhartmay@linux.ibm.com>

On Tue Jun 4, 2024 at 9:59 PM AEST, Marc Hartmayer wrote:
> The first patch is useful anyway, the third could be dropped to be consis=
tent
> with the other architectures.

Interesting. Is this the reason for the warning on all the other archs?
Maybe they should all use the same options and all remove the explicit
PHDR specification?

Thanks,
Nick

