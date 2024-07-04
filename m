Return-Path: <kvm+bounces-20951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B8B927364
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 11:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1C1C1F22E0A
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 09:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90AB1AB52B;
	Thu,  4 Jul 2024 09:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yKHlucMy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CD91A2C17
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 09:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720086852; cv=none; b=g34n3Qc5v/a+5BGIfcyld0bMuLbR0fAkRdq9IWejCGynznnJPJcPjMFifM8Tod3G1TcnjhMwijhKQC2hXYmlHjkXx/0qzcvAoGzAnbLIkd5KkJLHXP2AchbXHbl53ANbpymHjz3rk5zgby2pXsD/MRhAK4KrlXG+rsvnq0lMPaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720086852; c=relaxed/simple;
	bh=7EqW54N/gD3QtdDyUfKaeFo8kacnhFKJfEsd1V3cH2Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RJRUbx5zA8iQQEiuLc8h2SucdNFaNqxbOd85/AbL/501vtthKWXhWqv8sUmK/cYRT6d+y+1q1Cp5KLrswpC/EY5s1+u2WQlQBqPeoW4AQHSKJNZvabrmiClRGf6TCoScBRSsY2+gqCIvNgrjwt4gtvTEpyctHFevnGcuC21Phl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yKHlucMy; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a75131ce948so51597066b.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 02:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720086849; x=1720691649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7EqW54N/gD3QtdDyUfKaeFo8kacnhFKJfEsd1V3cH2Y=;
        b=yKHlucMySGCMv9LifxMODjE/aRCosYFaYPQPDk/y5AxZBNxRFa+/mZBWm/F21AfvXZ
         ki+c3YB5C2S4682WZ4hCbM5ILsq3jnF4jWQL/70REFHjRwQKWzgX0Bxc0yq/WHqPuuAF
         CLbYXNVFsCXaWR5hJT7PEN/NNFP171ctVBnixDeur94VDNVaePf0eBMZzkAUsG3gp87F
         Bw1lOq48nHyDDA+prANErOP0Hyfb+b4hInEFGMatZybKhKGDMWe1+/kXUjEvUWuUaTb3
         CCdqlWv9cbBFrHhWXReoIQSuJ6iGsIDrfRscKIXD4GG17vfcQOMHIUA7i/L8MbifnXqd
         qtQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720086849; x=1720691649;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EqW54N/gD3QtdDyUfKaeFo8kacnhFKJfEsd1V3cH2Y=;
        b=AC6bJhC0StTz6vM6RQbShw7IwyRPVWtZLCzVfPRSuwNGIKZA1z19HvaG+e99szqksS
         /UmemUO8r3T0zGNpyKQXMWJJta4kKU7zXLilEQGuRxP4XCXb9MbVLDU+Z+7W6ZnHAfSW
         Q3ams3JihA8QwtXkeESBQ0t4EZRagYf8+APzqzwAZCnhWE1DzHtLavk580uZNe+u+Z33
         C6Z2byIDuD4flVE2OB1QDcTcFDOWtf+ipuY6dj8Yyf0ATbO49y2fzsjK4TVhfSOlMPtK
         c4A4liBf9pdq5w6jdo8gEng6BA5or2p6dB4KXQiNhd2K88tyQwRKHvPOA4mFQ5ERVz1N
         VEmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrZXer6rMdCCeL9f63wYzm9bQOkA9/anxWHjr71R2roPWx6OQf6DFPA1eLAkXUP/8i5YP59so43JNnpjYA6SOJtRVL
X-Gm-Message-State: AOJu0YxfshzCB0Wq+4yKEX0n89ebZ3n2v+nTJl1fo3PQc3SlzOFnXo5Y
	PE+1loaMLu3QTXZ3u/8ROeb+QfIMaSY74HhoIpZQYRFqUNdTr+0+oA2bCGsII+s=
X-Google-Smtp-Source: AGHT+IHhms2ySVos1DQadnupcMl7GBV3e4GVECd6bLUke7XEY70r62UxvB9fXPw+myzqsl0a2ppdyg==
X-Received: by 2002:a17:907:3f8e:b0:a72:6ff6:b932 with SMTP id a640c23a62f3a-a77ba711c8emr72156166b.51.1720086849174;
        Thu, 04 Jul 2024 02:54:09 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab0651easm582648566b.137.2024.07.04.02.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 02:54:08 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C362B5F839;
	Thu,  4 Jul 2024 10:54:07 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,  qemu-devel@nongnu.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Paolo Bonzini <pbonzini@redhat.com>,
  Richard Henderson <richard.henderson@linaro.org>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Sergio Lopez <slp@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  Paul Durrant <paul@xen.org>,  kvm@vger.kernel.org
Subject: Re: [PULL v3 58/85] hw/i386/fw_cfg: Add etc/e820 to fw_cfg late
In-Reply-To: <6680fde4c583a892cfaf275f19b5369ce3859850.camel@infradead.org>
	(David Woodhouse's message of "Thu, 04 Jul 2024 09:09:16 +0100")
References: <cover.1720046570.git.mst@redhat.com>
	<93c76555d842b5d84b95f66abecb6b19545338d9.1720046570.git.mst@redhat.com>
	<6680fde4c583a892cfaf275f19b5369ce3859850.camel@infradead.org>
Date: Thu, 04 Jul 2024 10:54:07 +0100
Message-ID: <87r0c9o534.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

David Woodhouse <dwmw2@infradead.org> writes:

> On Wed, 2024-07-03 at 18:48 -0400, Michael S. Tsirkin wrote:
>> From: David Woodhouse <dwmw2@infradead.org>
>
> Oops, that was supposed to be
>
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> Not the end of the world if it's too late to change it.

If attribution matters we do have .mailmap and the gitdm metadata for
after the fact fixups.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

