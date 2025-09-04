Return-Path: <kvm+bounces-56824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0896BB43B14
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 14:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 931DE1C27E5D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 12:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6172D0C9A;
	Thu,  4 Sep 2025 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ImkBjQkQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9925F2D3720
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756987735; cv=none; b=C8ngd5qNUQfISSGLgaDZ5z2YNFHUzRze9BdY6Ka86NGOLG8boiWSDYbYBforwIyW7xcrgAcyJvc6/geVMWD1b3+qG513fOtTzOzyMgjz0ye511x/bJq8DbJJbh5symvPu2D8HGHZ+OSIjSmEQ10gWQ2OQnv+GqLT4Urow73i5qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756987735; c=relaxed/simple;
	bh=OFZb8uoRwWrOuqnnhN4xUAUbG3h/DQ2j5rhiMC4RH/c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2XB4uGNskNhmDUeyk2J0NMnCxy77Ksafo/8B7JOAktd7AcgHBFcfJvRI4rzZxUtTQXnEUI1VPa1r7AV6dWc5/7QUWomsqIhFfuPKZcjU+VdFQkcTbpxJnSvt7dgyDJf/7KGTx0306jAImZg2ZTKayMHY1voi0WsltG+XvUGl1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ImkBjQkQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756987732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RGfsbECkN8yDi9zfYlQG8Tqcfjb7p7ijr5WocyCehHg=;
	b=ImkBjQkQomJUMirJA1KUN5j6d16u7g26loI8bUkESfKKmhPu8Q/zQ2yqTPTguH8mnsQVMh
	ff927sA05gOyzVG94ujkBa2ahVbJ7wTk0Lt/VT3rNOJB0COAd6mnnzpbfXhtXGKIeLfgm5
	LXndA623GRYcC0K1CQX3Gr+6i9KAndA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-RCtxCsCfNh-N51RsbS8ZOg-1; Thu, 04 Sep 2025 08:08:51 -0400
X-MC-Unique: RCtxCsCfNh-N51RsbS8ZOg-1
X-Mimecast-MFC-AGG-ID: RCtxCsCfNh-N51RsbS8ZOg_1756987730
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3da4c617a95so846559f8f.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 05:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756987730; x=1757592530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGfsbECkN8yDi9zfYlQG8Tqcfjb7p7ijr5WocyCehHg=;
        b=gGO3gVTTUzD1M72jKxdJcB0FUe1AIBwPtZhxEIR2QWMWR/q5Zs9jWue6sx3IA1rXdu
         UWMiDt+NbgRPkigZEVt5D7WcXehUW9/ejNT5WDgzPvPFZWktb1e0Cu9LWxN9aPIbM4KK
         3ODm7U8AxOhpMeKSHeVPNxyHwsbZ7W2r1ogVaYITxmYMVHw7heNwl4p4Um/T4KFT7piF
         9TovAOySpqzhNWWyiRO3RADpHRN0FgpjxBYG2FPhb4t7Gxhl9+ttPnP3C4MG01xEuGPJ
         HKoYMa+fHEOCJliAbNVvuS0b3+DtNsoxQUB8ifVN4BOQikGGhgxUrbee231Hv9fa+18g
         gpNA==
X-Forwarded-Encrypted: i=1; AJvYcCXP4FTJ8PFeb96oMS6gGdktJcdw4QXAcmtA4/c09b1J60990FgaAgtDLpIDSRYKGeSseBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxejvtD9mpsaLa85+3K6X+y227z1fSgAxb6pTVspT/8M/3J9BIM
	fZls5I7ewNvZEXs9iUcXNnMpc1bxwnv+R2sK+TPOqdfJGCCVWrlo1DPvmjRfrXITmK9JcEMMBzd
	QZ3Lx8JwW39kyyVeYC2OPfTzdmBfvzS1GMym93beSr/TUlsJ7VCBq9w==
X-Gm-Gg: ASbGncvMWnmfw8wRXCbg4fFk0wa0WOmCKHzka8i7WzBc/X7nNqMb7BRytKpCxoJcsak
	RYei8TjXtJumAJi4xf5h4oqxIeDt+FbwesAUASAHIEzKfmoYScUftFGqe/PrbrN5w0puqxDvHM5
	NR4Jq9keM7FExbKU76d+MyB9aRH7lFdvz3jgEyGi8oFeZHNZBTTdpXQOXERJwoyrZ62m7CIpyLx
	G0TkhiloCkvEm6ooBKQEGPN96tQx2DFbqOV5ey/PTetzWc52XuKpRTrreZSrsSZNe5CJpSU0Uds
	mfNKLPXUyRXc7bo0plu66GPjU1gjyA==
X-Received: by 2002:a05:6000:2681:b0:3df:1a8b:ff40 with SMTP id ffacd0b85a97d-3df1a8c028amr3675244f8f.43.1756987729449;
        Thu, 04 Sep 2025 05:08:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX0PPz3yh7ncUtLm/xW0ZxJtT+AldckvinW77LYH+EITFhgO23Jx24JW/wmCpN9gO6bSEhZg==
X-Received: by 2002:a05:6000:2681:b0:3df:1a8b:ff40 with SMTP id ffacd0b85a97d-3df1a8c028amr3675186f8f.43.1756987728720;
        Thu, 04 Sep 2025 05:08:48 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d53fda847dsm18324880f8f.0.2025.09.04.05.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 05:08:48 -0700 (PDT)
Date: Thu, 4 Sep 2025 14:08:44 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>, Peter Xu
 <peterx@redhat.com>
Cc: qemu-devel@nongnu.org, Reinoud Zandijk <reinoud@netbsd.org>,
 =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Alistair Francis <alistair.francis@wdc.com>,
 qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>, Helge Deller
 <deller@gmx.de>, Matthew Rosato <mjrosato@linux.ibm.com>, Fabiano Rosas
 <farosas@suse.de>, qemu-rust@nongnu.org, Bibo Mao <maobibo@loongson.cn>,
 qemu-riscv@nongnu.org, Thanos Makatos <thanos.makatos@nutanix.com>, Liu
 Zhiwei <zhiwei_liu@linux.alibaba.com>, Riku Voipio <riku.voipio@iki.fi>,
 Cameron Esfahani <dirty@apple.com>, Alexander Graf <agraf@csgraf.de>,
 Laurent Vivier <lvivier@redhat.com>, Harsh Prateek Bora
 <harshpb@linux.ibm.com>, "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, qemu-ppc@nongnu.org, Stafford Horne
 <shorne@gmail.com>, Sunil Muthuswamy <sunilmut@microsoft.com>, Jagannathan
 Raman <jag.raman@oracle.com>, Brian Cain <brian.cain@oss.qualcomm.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, devel@lists.libvirt.org, Mads
 Ynddal <mads@ynddal.dk>, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Jason Herne <jjherne@linux.ibm.com>, Michael Rolnik <mrolnik@gmail.com>,
 Weiwei Li <liwei1518@gmail.com>, Laurent Vivier <laurent@vivier.eu>, Ilya
 Leoshkevich <iii@linux.ibm.com>, qemu-block@nongnu.org, Peter Maydell
 <peter.maydell@linaro.org>, Kostiantyn Kostiuk <kkostiuk@redhat.com>, Kyle
 Evans <kevans@freebsd.org>, David Hildenbrand <david@redhat.com>, "Edgar E.
 Iglesias" <edgar.iglesias@gmail.com>, Warner Losh <imp@bsdimp.com>, Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>, John Snow <jsnow@redhat.com>,
 Yoshinori Sato <yoshinori.sato@nifty.com>, Aleksandar Rikalo
 <arikalo@gmail.com>, Alistair Francis <alistair@alistair23.me>, Marcelo
 Tosatti <mtosatti@redhat.com>, Yonggang Luo <luoyonggang@gmail.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Artyom Tarasenko
 <atar4qemu@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost
 <eduardo@habkost.net>, Aurelien Jarno <aurelien@aurel32.net>, Richard
 Henderson <richard.henderson@linaro.org>, qemu-s390x@nongnu.org, Alex
 Williamson <alex.williamson@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Ani Sinha <anisinha@redhat.com>, Roman Bolshakov
 <rbolshakov@ddn.com>, Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Chinmay Rath <rathc@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, Cleber
 Rosa <crosa@redhat.com>, kvm@vger.kernel.org, Song Gao
 <gaosong@loongson.cn>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Halil Pasic <pasic@linux.ibm.com>, Eric Farman
 <farman@linux.ibm.com>, Palmer Dabbelt <palmer@dabbelt.com>, Leif Lindholm
 <leif.lindholm@oss.qualcomm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Michael Roth <michael.roth@amd.com>, Mauro
 Carvalho Chehab <mchehab+huawei@kernel.org>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau
 <marcandre.lureau@redhat.com>, Mark Cave-Ayland
 <mark.cave-ayland@ilande.co.uk>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, John
 Levon <john.levon@nutanix.com>, Xin Wang <wangxinxin.wang@huawei.com>
Subject: Re: [PATCH v2 001/281] target/i386: Add support for save/load of
 exception error code
Message-ID: <20250904140844.5b670290@fedora>
In-Reply-To: <20250904081128.1942269-2-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
	<20250904081128.1942269-2-alex.bennee@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  4 Sep 2025 09:06:35 +0100
Alex Benn=C3=A9e <alex.bennee@linaro.org> wrote:

> From: Xin Wang <wangxinxin.wang@huawei.com>
>=20
> For now, qemu save/load CPU exception info(such as exception_nr and
> has_error_code), while the exception error_code is ignored. This will
> cause the dest hypervisor reinject a vCPU exception with error_code(0),
> potentially causing a guest kernel panic.
>=20
> For instance, if src VM stopped with an user-mode write #PF (error_code 6=
),
> the dest hypervisor will reinject an #PF with error_code(0) when vCPU res=
ume,
> then guest kernel panic as:
>   BUG: unable to handle page fault for address: 00007f80319cb010
>   #PF: supervisor read access in user mode
>   #PF: error_code(0x0000) - not-present page
>   RIP: 0033:0x40115d
>=20
> To fix it, support save/load exception error_code.

this potentially will break migration between new/old QEMU versions
due to presence new subsection. But then according to commit message
the guest might panic (on dst) when resumed anyways.

So patch changes how guest will fail
(panic: old =3D> old, old =3D> new
 vs migration error: new =3D> old ).

Peter,
do we care and do we need a compat knob to make existing
machine type behave old way?

>=20
> Signed-off-by: Xin Wang <wangxinxin.wang@huawei.com>
> Link: https://lore.kernel.org/r/20250819145834.3998-1-wangxinxin.wang@hua=
wei.com
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  target/i386/machine.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index dd2dac1d443..45b7cea80aa 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -462,6 +462,24 @@ static const VMStateDescription vmstate_exception_in=
fo =3D {
>      }
>  };
> =20
> +static bool cpu_errcode_needed(void *opaque)
> +{
> +    X86CPU *cpu =3D opaque;
> +
> +    return cpu->env.has_error_code !=3D 0;
> +}
> +
> +static const VMStateDescription vmstate_error_code =3D {
> +    .name =3D "cpu/error_code",
> +    .version_id =3D 1,
> +    .minimum_version_id =3D 1,
> +    .needed =3D cpu_errcode_needed,
> +    .fields =3D (const VMStateField[]) {
> +        VMSTATE_INT32(env.error_code, X86CPU),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>  /* Poll control MSR enabled by default */
>  static bool poll_control_msr_needed(void *opaque)
>  {
> @@ -1746,6 +1764,7 @@ const VMStateDescription vmstate_x86_cpu =3D {
>      },
>      .subsections =3D (const VMStateDescription * const []) {
>          &vmstate_exception_info,
> +        &vmstate_error_code,
>          &vmstate_async_pf_msr,
>          &vmstate_async_pf_int_msr,
>          &vmstate_pv_eoi_msr,


