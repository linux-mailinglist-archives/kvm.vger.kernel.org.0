Return-Path: <kvm+bounces-46307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFD5AB4E38
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD90719E3267
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 08:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E071420E002;
	Tue, 13 May 2025 08:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fEx7j+ga"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB4C20CCD9
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 08:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747125390; cv=none; b=C6TZILhNqkSP3w4yixw7PMgWL2XgKPunZK39k17cd8O0Wz80xews8kHZwJgQqzPF3Eh8sc1VJ3tneo5Eoi8xpHATgGlmFTJYqBy+VXVomqwkF8yM3GERUHebnORfZgocP+hx7mw2MJjN32AnLTsAGXe5uDgBtOA7La7vOvxhlqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747125390; c=relaxed/simple;
	bh=hWt5kMi2qQAyYfP8ZAY55LSxGBk05eKfg0NFs8XuWZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LuCkmY+nirUpP7M2BNrJ7y91DH6RXzo9dGZi4muXvn8Fq9GPabv7fB9ScaM2tzUAE9wnWs5TRDg75EJr754lFCMCM/RUXDlUBzsXi+Q1s3G/LUhKhipMqi0FakeZafslST1krHzaFO+mB2rPKzytEvjo2Vvq+u1HITlco7olSq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fEx7j+ga; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747125387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wVAl0zVgqH87YvdqKchpA84YKh5NANrF4mrLmsOjL/k=;
	b=fEx7j+gaeARsUcHEOV2MSwTXCCEVdiISPfdJB2F+KVpRNm3wblc6NfEzjiIL9h0kSA3acN
	GprJrHKMx+lQMRxw5DknWi09aPdhifXFxotri/MJyH4SqUnBD9nzEA+SX/Yt4xtJogTyOW
	WvaAyovX5rS11KC1ru7mJstzJWCb5WA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-t6RzTiGHNAacds2PalwrhQ-1; Tue, 13 May 2025 04:36:26 -0400
X-MC-Unique: t6RzTiGHNAacds2PalwrhQ-1
X-Mimecast-MFC-AGG-ID: t6RzTiGHNAacds2PalwrhQ_1747125385
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a0ba24d233so1730932f8f.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 01:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747125385; x=1747730185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVAl0zVgqH87YvdqKchpA84YKh5NANrF4mrLmsOjL/k=;
        b=M45XGZgwT5iZLXm1g8elH67EBRvT6rndb3KdlPo+ivoAg0nZapvAXWjIrm3RQSjrcK
         S7/k9Pa0FKjGbZjP2bps1teWWH98OZUHp46JWX1lglbIB2wRJFokLSQ3jOwOCjfJaWtm
         BCs3QEwvrWdqCijNbSAD/L5B0kS24XtuAkhltb8JQrMx86TDAQT5ZowlrD95VqRRUyUd
         CDpjP2LQuujrnG1ypnkmzMfTvpWBHDraRn2/jbUuju8ExC8EsbWIQUJsDY46Tc7Z0tYL
         1w+cSpbjgJdc1yJGZRopoyk4iLWUrRESuZKTSMa6GB1FTb3bK2pfge5KOW+7ryMlitZy
         vI4g==
X-Forwarded-Encrypted: i=1; AJvYcCVGqayN3iL5YMOAUmO7o6TqSSjZHTB/35fXRgU9ff9idDeUIswplhsinrSrKBD7/u8/050=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8eQSDD40L0t/TtD7S+JUhLqZyE0tAefYtlntIKTWVNdqRQ9Me
	pFoWuXTZOTPyh3b0ijwD55jvzc55+73dlpwX19JO7WsRf2x1ABoRdmg4l8qhX+mVGfHtFzatljj
	+c/jYANjyBsT5yINi/HdPV40NlPvWMR9fOdB8vpJU2ZotOJ7Qxw==
X-Gm-Gg: ASbGncuXZ/SwpXsTrYuXYq0w1By+tLUxfjgnoA7QF83U0LKwiWwhISTZmqSm4zqEUPL
	gARtmlR4CW9lz1dNWvbzmZZZo19W1PULKOnitG8G0LBW5nlHGZGq9/bUJDa/7aRH0utLQFLLXGu
	tNZoHxFF4bcqk2fndLwssiAnfqFkX4M9Y7jE8stK+nJV7ZgPYbRnHk4CHhpGGvwhIiKeN85Have
	aVp7IaW3HMrL9koQUjynLMv70SKJFdmfGiEuRMkTnq5qb1WPbiZqL90IGU44J+du2ipL5dPf8cP
	s53hyTY7oKjTFF6m4Q6IzQofu3b+YlPD
X-Received: by 2002:a5d:64ac:0:b0:3a1:1229:8fe0 with SMTP id ffacd0b85a97d-3a1f6482c15mr14480671f8f.38.1747125384895;
        Tue, 13 May 2025 01:36:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgEYDVr7iQlgSKGrFECgtHY6riy1T/KVm0n7Q+QhUYIat1jVjUcti8+9lRaaJT6mKdrN8lsQ==
X-Received: by 2002:a5d:64ac:0:b0:3a1:1229:8fe0 with SMTP id ffacd0b85a97d-3a1f6482c15mr14480634f8f.38.1747125384492;
        Tue, 13 May 2025 01:36:24 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57ddde0sm15646436f8f.14.2025.05.13.01.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 01:36:24 -0700 (PDT)
Date: Tue, 13 May 2025 10:36:22 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Zhao Liu
 <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>, Helge Deller
 <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha
 <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Jason
 Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 15/27] hw/core/machine: Remove hw_compat_2_6[] array
Message-ID: <20250513103622.07e2fce4@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-16-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-16-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:38 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The hw_compat_2_6[] array was only used by the pc-q35-2.6 and
> pc-i440fx-2.6 machines, which got removed. Remove it.

see my comment in 1/27

>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/hw/boards.h | 3 ---
>  hw/core/machine.c   | 8 --------
>  2 files changed, 11 deletions(-)
>=20
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 5f1a0fb7e28..a881db8e7d6 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -841,7 +841,4 @@ extern const size_t hw_compat_2_8_len;
>  extern GlobalProperty hw_compat_2_7[];
>  extern const size_t hw_compat_2_7_len;
> =20
> -extern GlobalProperty hw_compat_2_6[];
> -extern const size_t hw_compat_2_6_len;
> -
>  #endif
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index e7001bf92cd..ce98820f277 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -275,14 +275,6 @@ GlobalProperty hw_compat_2_7[] =3D {
>  };
>  const size_t hw_compat_2_7_len =3D G_N_ELEMENTS(hw_compat_2_7);
> =20
> -GlobalProperty hw_compat_2_6[] =3D {
> -    { "virtio-mmio", "format_transport_address", "off" },
> -    /* Optional because not all virtio-pci devices support legacy mode */
> -    { "virtio-pci", "disable-modern", "on",  .optional =3D true },
> -    { "virtio-pci", "disable-legacy", "off", .optional =3D true },
> -};
> -const size_t hw_compat_2_6_len =3D G_N_ELEMENTS(hw_compat_2_6);
> -
>  MachineState *current_machine;
> =20
>  static char *machine_get_kernel(Object *obj, Error **errp)


