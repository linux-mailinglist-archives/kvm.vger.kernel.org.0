Return-Path: <kvm+bounces-20449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59DAE915D27
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 05:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 042391F21252
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 03:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260D845038;
	Tue, 25 Jun 2024 03:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBetT2+j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AB13D6B;
	Tue, 25 Jun 2024 03:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719285096; cv=none; b=iYhk4Yylor9L30TfiDPQmalEnvnux3+FKcgTHH7KamksvCxW4wuzjb3Ob6LdOPIG9cKNmKcgYYQbxi5uhGBLQvKWasjtKiKXN4Yi696RvphvklNuZ3BA39dqjjUDO5HgJCwTkpElk0TyrAuo8JkeVKLw72lincNB2atO8tgEN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719285096; c=relaxed/simple;
	bh=i5DWtJiuOR9vmSmeo2TCOcUVqTT7wTCCsqmwNHw+ocw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=AJnqvUxqRlQwDKErpAYAl3W1B8bZSEB5TT7aNXJbQAVpZES4LUpkNAKOVRKOx5Po1558N1CJhxg3c0AKj1p43ki0ElEbgxPoSPz0t0bFDrXcRGhtAz+qNgIFwkdQry9mK1GEsC3lDJvtFVHtO1grPutTG0LVZcSxQI3oiN06tBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KBetT2+j; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5c1cabcb0c1so2455724eaf.0;
        Mon, 24 Jun 2024 20:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719285094; x=1719889894; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5DWtJiuOR9vmSmeo2TCOcUVqTT7wTCCsqmwNHw+ocw=;
        b=KBetT2+jqYsaLci5qBiJnC4QAgucvFswGV8G9727mS1oacYNDK8y3KObPtT2TZS3pm
         yX7hurnLi+wR6GKh3CGvdNwwZJiYuqf8rWg11oahXYqZ4c0/jbTT6Mj9DRbSl0NK3SQx
         7qShy3V9/1Dv2Og6m6ftV+ZDJwDkmZReq5EZyRsnJBgefdUVTmuLb7cULAyiYPY2/9+w
         nszwTs9KBuPdIRE62lvUzaFJCZwhjdhK/5X2XQfysmhloFu3Y4m0K0hmRwcRkfiD1axE
         GugaWl6cI+LeW6gQXUchTnVgSJP/V2ef3lQM4D9MK7W4xFI8uSBnQaAvaT7yvK6eWDT2
         qCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719285094; x=1719889894;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i5DWtJiuOR9vmSmeo2TCOcUVqTT7wTCCsqmwNHw+ocw=;
        b=PQ5WtO9m1RoMySwZvddL0pSnlPdMdRbIJrPoY9wgbvposHtWNUEgbxXUpqJxBR4umR
         +vhdEP7i6e25I3PL+7HG7s0KjZ0eGVGYnlFit4f+1DDjLbBcD3Z0C/gguoSQ/T+fMtBt
         v6tmzfChCgmnwtA4UVIpwH0LEhIn5zjKZ51GYW7Cicm4IM8HHXyiW5TkyexrfyG3EvHV
         f6G0D9qIzcXGXUk+dd/3Kbj8yqrOpn9sD1r8FLAmt7AVqSev4IwkeNyQxhis5xdM7stu
         Im1Jwuj3wVURAS06N8EwHj3MVqTLQYDxOTZrpwCvk0orBiMqb6XZhbaXJSmMibM1GqMH
         fxow==
X-Forwarded-Encrypted: i=1; AJvYcCW/RzEafXonCyR7zRs87UUZHlrQncLYJcu2WCdzNhaPIWX83zy7Yfrr1BQomcW0X/TGx76UGq7hC7kcwvAr/3587mHn/Q5evzBpMYDcpZrFjoszJoFa6B9NVBmSXZD4zA==
X-Gm-Message-State: AOJu0Yx6oCUp+o55I78RQD0FuKungKZ4v66slXctL2x2Nd9tEpkUOThK
	jzjNwNjokQOr/eOl5G2zABYtW9TDtRU8l73Et7cpmk2hxGgRY0XMcqdipw==
X-Google-Smtp-Source: AGHT+IENscmIagp5OaD7fQwCFhMMEkb6K78pblMf6Mt/3/Jx18zeXDtFETFUi9ex3JlFXRVP9iHPXw==
X-Received: by 2002:a05:6358:7243:b0:19f:4eda:f733 with SMTP id e5c5f4694b2df-1a23fd8c691mr699250455d.31.1719285093783;
        Mon, 24 Jun 2024 20:11:33 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb32b9f8sm69844545ad.114.2024.06.24.20.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 20:11:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 13:11:27 +1000
Message-Id: <D28RP5IXSPC2.2IMPCI9P5948Z@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE
 interpretive execution (format-0)
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, "Thomas Huth"
 <thuth@redhat.com>, "David Hildenbrand" <david@redhat.com>,
 <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-8-nsg@linux.ibm.com>
In-Reply-To: <20240620141700.4124157-8-nsg@linux.ibm.com>

On Fri Jun 21, 2024 at 12:17 AM AEST, Nina Schoetterl-Glausch wrote:
> The STFLE instruction indicates installed facilities.
> SIE can interpretively execute STFLE.
> Use a snippet guest executing STFLE to get the result of
> interpretive execution and check the result.
>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

This one is beyond me... one minor thing, you could move the
prng patch to just before this one.

> +++ b/s390x/snippets/c/stfle.c
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright IBM Corp. 2023

> +++ b/s390x/stfle-sie.c
> @@ -0,0 +1,134 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright IBM Corp. 2023

Time to flip your calendar page? :)

Thanks,
Nick

