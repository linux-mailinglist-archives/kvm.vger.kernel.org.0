Return-Path: <kvm+bounces-5898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF85C8289E3
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AFC71C246DC
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 16:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E692F3A1CF;
	Tue,  9 Jan 2024 16:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aLy5R4eJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A254F3A8C5
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2cd703e9014so2777021fa.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 08:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704817419; x=1705422219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wsg7zMm5Fdy1jA8s3lcgjoxedub8Q57T3G6fYjwRVq8=;
        b=aLy5R4eJCtQBcGHlPLkaa7GzgSp+w9xNL8HAoQHWSSbGrme9zy2Z6dpsv1upqdOCEh
         j6jKDWQP7DOUQ8ISQX+28hEwSlOgo/O0Ky02rl21ed2+HP0d4xykaOv7r57mP4R4GjgH
         c1nDgUPb5H3ADAN8ZTf5EOZK/InBBK/ntU3cgpcYTHX7FIm0q8bGYJZxZ2OHoZVOprzt
         chLmyta9CIbd96ZKggKoWA9sBepgDPmhV7iW5hT+SQeFgCu+XJUs3Myt416ZlQ66VEaD
         eoeZWFqANPy/AoeMSH2qCsWOuE1zfSiitAvNvvDYCeOk1ZZStBI97TwxDPByrek/AwHa
         n3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704817419; x=1705422219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wsg7zMm5Fdy1jA8s3lcgjoxedub8Q57T3G6fYjwRVq8=;
        b=hpDKWJYGHLvidWsLQvAnO3Nd2RcQoxtaliGatBtmXP9QaDbaM155CL1XjZ0PdyI0Bf
         vTJWyjuPYQ5UxYJ8CiyeRKhmdzFuZ80eHECkHYvL4AW6A4uoS6qBEPNLUyI3LizntQg2
         V+JBRX/A/AhJQ/i3VcgYgI0yYJxI2S+0/Gbc+o2VcDXNP6eRDNwo46QYmlThaKbTJxEJ
         jmrGEK9Ox4RaEi33kipSx6xdYrhjRJ3MoUdim6cvnjZblu9ykGZygdg2tXhwc58pIVBL
         BxZiHktAJXwEn28QmXtGLVnJS20ICRyd8zjSxJi2AhBfPJWA9tYPhEJ+U49UkLyJ7eia
         vncw==
X-Gm-Message-State: AOJu0YyOax1NGvPsmPn9Pm/J494JsQW4G2SjFoRDoylSdlbXbjFHtUQH
	TksU4fyXpodeH7APxfIlBmF1l+0XJPcYcCdmCpOmNoFjp8si
X-Google-Smtp-Source: AGHT+IENINkHdScslGoH1+e94F8Ik5C9aYB8w1MwoOyMisInkBOG5KStveZ4xiPiBsZa81JjQmBLru7M1qN9QTUClhM=
X-Received: by 2002:a2e:b712:0:b0:2cc:788a:3d4d with SMTP id
 j18-20020a2eb712000000b002cc788a3d4dmr2530358ljo.51.1704817418515; Tue, 09
 Jan 2024 08:23:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev> <e0facec9-8c50-10cb-fd02-1214f9a49571@redhat.com>
 <ab1337bc-d4a2-0afc-3e26-0d50dff4ea73@huawei.com> <ZZx5y_iy9kXg47SW@linux.dev>
 <CAAdAUtie4GFKAPhk4wDWnEmSOzWF+X-6eHwS79169JRv_=hKdg@mail.gmail.com> <c90a3fb4-62b7-5642-433a-b0cfb41d6992@linux.dev>
In-Reply-To: <c90a3fb4-62b7-5642-433a-b0cfb41d6992@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 9 Jan 2024 08:23:26 -0800
Message-ID: <CAAdAUthgbQ5i8gatF0daa6RPRUtQ79cU3renpBrjkHwroziA9w@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	Eric Auger <eauger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Zenghui.

On Tue, Jan 9, 2024 at 7:37=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev> wr=
ote:
>
> On 2024/1/9 09:31, Jing Zhang wrote:
> > Hi Zenghui,
> >
> > I don't have a Cortex A72 to fully verify the fix. Could you help
> > verify the following change?
>
> It works for me (after fixing a compilation error locally ;-) ), thanks!
>
> Zenghui

Jing

