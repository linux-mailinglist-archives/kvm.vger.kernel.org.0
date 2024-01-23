Return-Path: <kvm+bounces-6719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1BF838701
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 06:50:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D35B1C22B86
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 05:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30E85255;
	Tue, 23 Jan 2024 05:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCyJkcOQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C0F522C
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 05:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705988948; cv=none; b=PPxKt6RnUN9eVFKJN0Y//ovN7fP5qBzw6Tohn6wsMCirq4tBpG5uAFdFJNLJlWjeuW5HRXspIQsOzkacJ0vkRrFasYTVcX7rTHbPeDxpYAif6aieYLGxkbqVDg2qzFzxepZPYQ2VwPyXpIaf+s1hurUdxa3+L63gDVmpreT2nMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705988948; c=relaxed/simple;
	bh=fu4V4jucs6dat50M/WGMmfUCnEAZ7B7miJilOmYjQCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XKPwe/sUQhSrxsvExHhVTrbDmyKZ3I1r+bkDYzWaUy0pTKfhOqyRONHe1omw2SlK8+bfkYeviCL3VdYECLF5QB21pqYur6s1v1RFKx71ZtS05TepKxqrZIGhXmt7BY76I/v1cdLNqmVN7yf7j4oEXKFT4jwb/aTJ24NWznNLYAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SCyJkcOQ; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-466faf5846eso632678137.0
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 21:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705988945; x=1706593745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGWFIgPM+i7sy9OAsZEHC3tF/I68FLzyifoG6R+5O+0=;
        b=SCyJkcOQFad5QeLYBt/CN96DlNt2TJ8WIZxKawZntNAFsM2m50jsnR1VqDdbEtj8b/
         6u8eXvtA6/eXF1U5UOenITrs8VzSdz64cPgrrYHIrkLNxkSljvB5amctq6Gto/ycf8Ce
         mfISh5mn+dBBTmirfX0IA70E1PcRZK+LujKBkOkE+gOrTQsb254yXwaDwZQHQXpFOfo3
         LqSke0TJsYPnCdzsvdG4WX9ofg0/IlcVrT4S5mr0Go3R6w2Vv3z2bEqHPi9D7hOCWPam
         pdH/Dbw0VJpPRCJI7rrKC7PWGUeGYAGvucf3zcy2JIgtQW+6YMw86hHDUazj9WmRRTTD
         2xpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705988945; x=1706593745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XGWFIgPM+i7sy9OAsZEHC3tF/I68FLzyifoG6R+5O+0=;
        b=I+bDp7n1UFCCa/sPnEObsyK/2RYAyIi5dLVOBH5HUnEGKibRos3OjAU0yPW0fQCF10
         XBSupNY8lE8xCyM6JqIW/56Z01WDNKQg2IIrbvefTWLFrdZPwhdGBD+M7wlbcxoTlWev
         hpti4QNRRRPprFf+GYxd7xPJe/7pyqofIwFK1fMBVQKViOxLksf/lF6n0PivsMaDwDqf
         9KcpvKzSpM5Euu9SrMK2qBoadfqYGomQ2WbCbmWvUHE/L0lVvjpJbDFjBEjxZc5csiu1
         YPmK/a0HxEp3f31bzCGnbR7Pi1Ez5IPz7jcBbox2oZMSQMUN6r+79Jk8fJFdlgo9bHVT
         b6Uw==
X-Gm-Message-State: AOJu0YxmkoD+OIv7kRd5HLxShH2XA1f8FS/iEb+PeSm5G62Pe0cYbuRR
	simO0iHxV4c+9zkQT1Lq/5O7V0uX54bNG9X4KkbCbr99+z3AHHzH/B+CLvlOYx9rXdU4cmPSFH1
	twoZN4EzVnglsubbjSnhGmsAAiAg=
X-Google-Smtp-Source: AGHT+IEGeNkPgWGB2ABOu+k0n1xgc8g0ke5OU9+x6qKIzezRXOSKHl+yIjtOmtVfaKEE0HM4paszPnbDaOrSmaVRSdk=
X-Received: by 2002:a67:e3a7:0:b0:469:aec1:b42c with SMTP id
 j7-20020a67e3a7000000b00469aec1b42cmr2494332vsm.5.1705988945512; Mon, 22 Jan
 2024 21:49:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122145610.413836-1-alex.bennee@linaro.org> <20240122145610.413836-2-alex.bennee@linaro.org>
In-Reply-To: <20240122145610.413836-2-alex.bennee@linaro.org>
From: Alistair Francis <alistair23@gmail.com>
Date: Tue, 23 Jan 2024 15:48:39 +1000
Message-ID: <CAKmqyKPawDYf1DBhGb05qnphOKNt8PATHiwaZVBuhS14sHAR0w@mail.gmail.com>
Subject: Re: [PATCH v3 01/21] hw/riscv: Use misa_mxl instead of misa_mxl_max
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Michael Rolnik <mrolnik@gmail.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Pierrick Bouvier <pierrick.bouvier@linaro.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	Laurent Vivier <laurent@vivier.eu>, Yanan Wang <wangyanan55@huawei.com>, qemu-ppc@nongnu.org, 
	Weiwei Li <liwei1518@gmail.com>, qemu-s390x@nongnu.org, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Alexandre Iooss <erdnaxe@crans.org>, 
	John Snow <jsnow@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Alistair Francis <alistair.francis@wdc.com>, 
	David Woodhouse <dwmw2@infradead.org>, Cleber Rosa <crosa@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Bin Meng <bin.meng@windriver.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Aurelien Jarno <aurelien@aurel32.net>, Daniel Henrique Barboza <danielhb413@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Thomas Huth <thuth@redhat.com>, 
	David Hildenbrand <david@redhat.com>, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>, 
	Eduardo Habkost <eduardo@habkost.net>, Brian Cain <bcain@quicinc.com>, Paul Durrant <paul@xen.org>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 12:57=E2=80=AFAM Alex Benn=C3=A9e <alex.bennee@lina=
ro.org> wrote:
>
> From: Akihiko Odaki <akihiko.odaki@daynix.com>
>
> The effective MXL value matters when booting.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Message-Id: <20240103173349.398526-23-alex.bennee@linaro.org>
> Message-Id: <20231213-riscv-v7-1-a760156a337f@daynix.com>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  hw/riscv/boot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
> index 0ffca05189f..bc67c0bd189 100644
> --- a/hw/riscv/boot.c
> +++ b/hw/riscv/boot.c
> @@ -36,7 +36,7 @@
>
>  bool riscv_is_32bit(RISCVHartArrayState *harts)
>  {
> -    return harts->harts[0].env.misa_mxl_max =3D=3D MXL_RV32;
> +    return harts->harts[0].env.misa_mxl =3D=3D MXL_RV32;
>  }
>
>  /*
> --
> 2.39.2
>
>

