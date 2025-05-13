Return-Path: <kvm+bounces-46308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B55EAB4E8D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:53:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB95B865EA0
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 08:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDE920E6ED;
	Tue, 13 May 2025 08:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHybqdPq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A421DB12E
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 08:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126408; cv=none; b=HlzrhCSyLLtje6bITLeuyyEnzXR6267eSARAA2buQjZ9j5ZC1krQ4HOjUqDaqbp9gZe0qcJcYgdUCIu2J91ANzafduxZGsKCYNd0onL9ZX+t6zuxOw70Uo1PeAbjQbti+BnjM52qaZ6Zxde3yKo4lh6etQsCW3DuTdL5bg0fPuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126408; c=relaxed/simple;
	bh=KQZ+iXiAFPkxLPIE21Tbwpzk3RkIHaafzHl5b1wK0G4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a87doi6ftyfETiixv5lv6/iN92bCx9hVnqUFwsViL8M5EzXD8mPRXnYTa1nw75hishTkYAPCEX9eDJlP1iCm6ZEAc6UXbxyMp7nk0rUMCXD6AGHPADsClpI0cYCP7CojB0EVPm6USthvGlyt8tYatRSlc4vP3+6imNpwpPdCmmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHybqdPq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747126405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1c399StXOuA/U3cRc3qzs9RfJEJILu72MXX9iqzRvVo=;
	b=NHybqdPqpeos68XsLuSP3PWWFxsIb2Q0M1fLjcjY2rl4EG66Yd1sDIqcxV1QUaRDmYFmiv
	ZYI9tWp/AcLqFHjcUZTUwlrIobSEOyW/pSMoPUSfq7HWGG9tasaZjOetlHMnbjc/zfkfqi
	8mtbMUMVnE/2ZCspgz7ANdN6JQuI+f8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-ewz-AKXJNY6cTxsN0t0qrQ-1; Tue, 13 May 2025 04:53:22 -0400
X-MC-Unique: ewz-AKXJNY6cTxsN0t0qrQ-1
X-Mimecast-MFC-AGG-ID: ewz-AKXJNY6cTxsN0t0qrQ_1747126402
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso26085565e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 01:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747126401; x=1747731201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1c399StXOuA/U3cRc3qzs9RfJEJILu72MXX9iqzRvVo=;
        b=v4Ch27GVqU4Xg+MeD4Slww8QU6Mb6omkNoMwAmYIUoloFGOhIEGktidRFVSpFDPQaa
         qie3W6VZYOsi19w9+q2JhwhIuuEYeigL9AAJ7bZbZk0qCAyyIALxDtzUkyRVq4W/Z2CW
         g79Pg500QCIJK6SP3ipm7BUCKA8hngsmiBWjicwKMPnIlwUP3r3YccyjgR2B94JInNug
         XC/ZR2C6uqm1vBrxr+KBltawB05Mb6kAEHdvJspR4i1Po709wYWoisfEEoiYDPjuVsSq
         DQSho8oZXYGwXKbwmGf7N+9JoPJ4V9IDhScQAVhYXeBHyqplGPPuNuSG0NPtbDT/R0S2
         dYlA==
X-Forwarded-Encrypted: i=1; AJvYcCWMMKo8cwp66vyahIxppwHxyCp1mi77ZVzezX1BsL3+QvBBYGv/V0Z4nJrmRZlXq4rGFpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoVLvTYuoWjYOPPoveHcVFTEJA5j53XmuFrSdn6QBxWB47f9DC
	MWbugQGK7Lau+jG/FKmtdJ5uLxvH5wE9o032DPg5IrQTJG9aP30PTv0nPs6ySwAEfv04bvFByoc
	pBdb6qsdmJ2+WC9PUxRO2DV9dq7JEMBNaQ9QbaYbh/7/G3Cl3Sw==
X-Gm-Gg: ASbGnctgWcKOFJOhmxPBTqj3lpnUM3yvw/4MfsPj0kGngHgE0qxbmND1T5GrwPXoInj
	JG/ulA2esgcVY8YDEQAiCcyXPOxMWcezll+aHGzgIkqscrDJatHagLADHdFAx2sy86oTVZ2GIMa
	puR+fwhI+Lyn4rU1TS6mwFUKcQbl+ETRlh7Cbg1tbRUOoYhVG20Fq26I9Z/o4i2ZovaKt/onvA/
	zfLtO/0+xcdzHJw4SiFRjC9Bw2Xib3kGoIdGYDynIxuRTnKFZE+E0svdL60BikEMywbi1a6laxF
	7YLVokp1RqLy872TPJbl8gw3cNK5SFGI
X-Received: by 2002:a05:600c:3148:b0:440:6a68:826a with SMTP id 5b1f17b1804b1-442eace91cemr25179655e9.13.1747126401662;
        Tue, 13 May 2025 01:53:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF549ifJeYTkxz/mvc+aA9gSenujAFnJKqtWZXl8rGu2VGPfZkDo5Kuof3IaWJiNGT8MFf/cQ==
X-Received: by 2002:a05:600c:3148:b0:440:6a68:826a with SMTP id 5b1f17b1804b1-442eace91cemr25179245e9.13.1747126401294;
        Tue, 13 May 2025 01:53:21 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aeccdsm198387905e9.32.2025.05.13.01.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 01:53:20 -0700 (PDT)
Date: Tue, 13 May 2025 10:53:17 +0200
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
Subject: Re: [PATCH v4 17/27] hw/i386/pc: Remove deprecated pc-q35-2.7 and
 pc-i440fx-2.7 machines
Message-ID: <20250513105317.0185bf3b@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-18-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-18-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:40 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> These machines has been supported for a period of more than 6 years.
> According to our versioned machine support policy (see commit
> ce80c4fa6ff "docs: document special exception for machine type
> deprecation & removal") they can now be removed.  Remove the qtest
> in test-x86-cpuid-compat.c file.

same comment as 1/27,

I'd squash pc|hw_compat_2_7 removal in here

other than that loos good to me, with above
  Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  hw/i386/pc_piix.c                   |  9 ---------
>  hw/i386/pc_q35.c                    | 10 ----------
>  tests/qtest/test-x86-cpuid-compat.c | 11 -----------
>  3 files changed, 30 deletions(-)
>=20
> diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
> index 98a118fd4a0..98bd8d0e67b 100644
> --- a/hw/i386/pc_piix.c
> +++ b/hw/i386/pc_piix.c
> @@ -755,15 +755,6 @@ static void pc_i440fx_machine_2_8_options(MachineCla=
ss *m)
> =20
>  DEFINE_I440FX_MACHINE(2, 8);
> =20
> -static void pc_i440fx_machine_2_7_options(MachineClass *m)
> -{
> -    pc_i440fx_machine_2_8_options(m);
> -    compat_props_add(m->compat_props, hw_compat_2_7, hw_compat_2_7_len);
> -    compat_props_add(m->compat_props, pc_compat_2_7, pc_compat_2_7_len);
> -}
> -
> -DEFINE_I440FX_MACHINE(2, 7);
> -
>  #ifdef CONFIG_ISAPC
>  static void isapc_machine_options(MachineClass *m)
>  {
> diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
> index b7ffb5f1216..a1f46cd8f03 100644
> --- a/hw/i386/pc_q35.c
> +++ b/hw/i386/pc_q35.c
> @@ -648,13 +648,3 @@ static void pc_q35_machine_2_8_options(MachineClass =
*m)
>  }
> =20
>  DEFINE_Q35_MACHINE(2, 8);
> -
> -static void pc_q35_machine_2_7_options(MachineClass *m)
> -{
> -    pc_q35_machine_2_8_options(m);
> -    m->max_cpus =3D 255;
> -    compat_props_add(m->compat_props, hw_compat_2_7, hw_compat_2_7_len);
> -    compat_props_add(m->compat_props, pc_compat_2_7, pc_compat_2_7_len);
> -}
> -
> -DEFINE_Q35_MACHINE(2, 7);
> diff --git a/tests/qtest/test-x86-cpuid-compat.c b/tests/qtest/test-x86-c=
puid-compat.c
> index 456e2af6657..5e0547e81b7 100644
> --- a/tests/qtest/test-x86-cpuid-compat.c
> +++ b/tests/qtest/test-x86-cpuid-compat.c
> @@ -345,17 +345,6 @@ int main(int argc, char **argv)
> =20
>      /* Check compatibility of old machine-types that didn't
>       * auto-increase level/xlevel/xlevel2: */
> -    if (qtest_has_machine("pc-i440fx-2.7")) {
> -        add_cpuid_test("x86/cpuid/auto-level/pc-2.7",
> -                       "486", "arat=3Don,avx512vbmi=3Don,xsaveopt=3Don",
> -                       "pc-i440fx-2.7", "level", 1);
> -        add_cpuid_test("x86/cpuid/auto-xlevel/pc-2.7",
> -                       "486", "3dnow=3Don,sse4a=3Don,invtsc=3Don,npt=3Do=
n,svm=3Don",
> -                       "pc-i440fx-2.7", "xlevel", 0);
> -        add_cpuid_test("x86/cpuid/auto-xlevel2/pc-2.7",
> -                       "486", "xstore=3Don", "pc-i440fx-2.7",
> -                       "xlevel2", 0);
> -    }
>      if (qtest_has_machine("pc-i440fx-2.9")) {
>          add_cpuid_test("x86/cpuid/auto-level7/pc-i440fx-2.9/off",
>                         "Conroe", NULL, "pc-i440fx-2.9",


