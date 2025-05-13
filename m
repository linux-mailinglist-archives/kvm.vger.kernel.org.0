Return-Path: <kvm+bounces-46345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF129AB539D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 13:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DDED7AE1F2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A1D28CF52;
	Tue, 13 May 2025 11:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D4sC98TE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7AC23A990
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 11:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747134886; cv=none; b=GsRR0TWQArfkUc83XthSnm1GdJaR43DdP8Mjt7/GRAyCN0NvdLqQmwe/hEcaHCnMNtGFeGNS9AjLfenF277PJ6huQZY1gEwv+CoWb3ZeVrwHI6VoolW8z0BAeuUYQD/TdDrKTN1nntSzt7oSSGCwrhRhCiKY113TbcZQkN4H9PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747134886; c=relaxed/simple;
	bh=OoqwyKaXIijdk0wtYgUfR3fx6ZDVZYEX4wtA2ilEMxo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfGOzdB4U0Zt0b8O8easgYK2vhNSC5dGG2DMdeHNNZLZHqZA1v09zihgXBfTrX6yiDnD/14oA2+vPipfTQzyDhDgHrJUHJ+Wnv3vXjpGUoO5crWd10QyvX3JGuVOk+a0xkfz+24mE1sIdv+u+MK+ivndj6wV/knTtnsdl6v2n4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D4sC98TE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747134883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hrWL8St/KjWNdQDgkpm2yN+yrijnA+A+ERdMiZgrZ2I=;
	b=D4sC98TE5QvqIQxL5+Ul8UsXlA8JHMfG59e5e6cG7nVHqjpWY+ul3ps6IPQxUbYSRbatoO
	WWwqOXUqiDR3jB2bUNsyvcDbQ1Uxm28wcVdv89HJwCjRMyz/6+x4QlEbSPZimlt/XY0kTD
	85nFDO+S944x+7EkesPcfp0145njBfk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-q7Wr9KwjN7uXYHPGLeM0Qw-1; Tue, 13 May 2025 07:14:43 -0400
X-MC-Unique: q7Wr9KwjN7uXYHPGLeM0Qw-1
X-Mimecast-MFC-AGG-ID: q7Wr9KwjN7uXYHPGLeM0Qw_1747134882
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a2057d164bso772256f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 04:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747134882; x=1747739682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hrWL8St/KjWNdQDgkpm2yN+yrijnA+A+ERdMiZgrZ2I=;
        b=VYXHxmcbCjkVdUgbseV5HoRrn2otf4RkBmVyvDMLhUtb+9im7XSQMt1lrARGA8i934
         /IFYL8sLNWrQn6eMIGanslTKzczWFFS/cdCcCtfaxkH0NFWIkn6RwLjYhf05afOQEasi
         5GL6fDbL5aWa66wzAyIAx29PXk/68VJuWYvNgw+e5Hm7sXhma3ndRrEJl9h0WxkMbHGf
         HYfl+eGdbNVNQcl02Sf1zR7ZSSZl2cW54kKFl/7ZrP1RGGm3WE9l6Z5GCHMJiM254XjW
         N+9c5twfAjiURYdk0vMhhzgNGD100Vo1O8q//tsXIClGizcE4P/IL6R9TykHiBca00gj
         A9HA==
X-Forwarded-Encrypted: i=1; AJvYcCWqf1O5JlCsCeACJ1N4AgPi6v/Tilnju/FWg5YfCzsY2lw9sR/REG/xn1RFBrSX2mmEhdU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVFn7yNTRvH/Vf91Z5sjgXKI5UxyL5SFSNtRyO+4jZjuyfTE2x
	c9uNKMxBduuYHsOxIt1XOgsdpr0pKvkUdRtxse1979PNVBwKBJ266Y40ImGxjFLBbVpg+zifrG/
	clDvZHTFlSj7K1ziL+uim8s8aCub+eIg7ddVeLffsq5FhLiuFLQ==
X-Gm-Gg: ASbGncvLXcGbFMUR1e79PrcnkXHvCxyZTHOOUcofL0a07dSP53Yf9gm7Kj4s3+jKyFW
	gJ1fBI49UBgd776yZP+bYD1liJp8F73kOC7tJSVu6WXcT6UepxBHite76fuiUrGHR9hbXRLf4Hb
	F9O7Ij6Kiri9fzd5O9/cLME0ancosiYZ4k7+VF8QchYrpNzg60FXeb+Unm5DYlyFs7JnWJDSG6I
	3WMRsSJclNeUpf/dgR+MuyfxmL7zDeS6xMF3LmMONxMOtYetocfOZE29+Uj7Q+ojoQT4eNwZ1x5
	dDLXsdgoNevdjTwPCYBOi+wCIXfYixG4
X-Received: by 2002:a05:6000:3113:b0:3a0:b308:8427 with SMTP id ffacd0b85a97d-3a1f6482d31mr13683859f8f.37.1747134881725;
        Tue, 13 May 2025 04:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFA3snbPG8QRbnrblP9wfN5lZEYrMvzqD3KCpso9gCqQnk2Tt5GM7Z4lipgqnFLC0sYrJWIfA==
X-Received: by 2002:a05:6000:3113:b0:3a0:b308:8427 with SMTP id ffacd0b85a97d-3a1f6482d31mr13683826f8f.37.1747134881344;
        Tue, 13 May 2025 04:14:41 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4d21esm16063106f8f.99.2025.05.13.04.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 04:14:40 -0700 (PDT)
Date: Tue, 13 May 2025 13:14:39 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>, =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif
 <clement.mathieu--drif@eviden.com>, qemu-arm@nongnu.org, =?UTF-8?B?TWFy?=
 =?UTF-8?B?Yy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai Chen
 <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 20/27] target/i386/cpu: Remove
 CPUX86State::enable_l3_cache field
Message-ID: <20250513131439.3ae54224@imammedo.users.ipa.redhat.com>
In-Reply-To: <aB3GsY71YH4usdSi@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-21-philmd@linaro.org>
	<aB3GsY71YH4usdSi@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 9 May 2025 17:11:13 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> On Thu, May 08, 2025 at 03:35:43PM +0200, Philippe Mathieu-Daud=C3=A9 wro=
te:
> > Date: Thu,  8 May 2025 15:35:43 +0200
> > From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > Subject: [PATCH v4 20/27] target/i386/cpu: Remove
> >  CPUX86State::enable_l3_cache field
> > X-Mailer: git-send-email 2.47.1
> >=20
> > The CPUX86State::enable_l3_cache boolean was only disabled
> > for the pc-q35-2.7 and pc-i440fx-2.7 machines, which got
> > removed.  Being now always %true, we can remove it and simplify
> > cpu_x86_cpuid() and encode_cache_cpuid80000006().
> >=20
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > ---
> >  target/i386/cpu.h |  6 ------
> >  target/i386/cpu.c | 39 +++++++++++++--------------------------
> >  2 files changed, 13 insertions(+), 32 deletions(-)
> >=20
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index b5cbd91c156..62239b0a562 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -2219,12 +2219,6 @@ struct ArchCPU {
> >       */
> >      bool enable_lmce;
> > =20
> > -    /* Compatibility bits for old machine types.
> > -     * If true present virtual l3 cache for VM, the vcpus in the same =
virtual
> > -     * socket share an virtual l3 cache.
> > -     */
> > -    bool enable_l3_cache;
> > -
> >      /* Compatibility bits for old machine types.
> >       * If true present L1 cache as per-thread, not per-core.
> >       */ =20
>=20
> I realize this is another special case.
>=20
> There is no support for hybrid x86 CPUs in QEMU, but it's also true that
> there are some actual modern x86 Client CPUs without l3 cache, such as
> Intel MTL's low power E core (and it has vmx support, i.e., support KVM).
>=20
> So I think we can keep this property as well, to have some more
> configuration options for users' emulation.

it also seems that libvirt uses it.


