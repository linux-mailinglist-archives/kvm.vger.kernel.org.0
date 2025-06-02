Return-Path: <kvm+bounces-48163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE23BACAC6A
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C73C7189E6B3
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 10:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E39C1EDA3A;
	Mon,  2 Jun 2025 10:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5KUVgCd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5E51474DA
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 10:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748859997; cv=none; b=t0L3AYdUtrxWEUo8VOI49r20Fv1lmUIKC0Chwmdj5iA3o4XnTyboENG/gWpQ+3VI7/wW8iELlO3Ilhv44Ei00kwmrZ8osdSf2YDnWim2UQLs39uuf0MqFGkMFsvxfglhGy35YCcQSb+6Gw4TqFJxdhcRtRgsqMIyOJY++KY1TmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748859997; c=relaxed/simple;
	bh=hjUTSvOng+W7JEAyCf/KH/itZzV9YwnTBi8GIOhN5NY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f2ksKtD9KyR2Ojm9t+X9rB6MRqYkNPSoeU2EmIM1R289D5Vj9cIJsAdoMXw29Pg4XelGRaFNSLjMcvaX79KUu1DeNt3SknvbAmSsQP4QYUdokcGzTH0ZsPRBVDzmvaVdID4BZdxnJuFcnAw2hEF7GOnNlaQaNg1KOCo8Roln+/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5KUVgCd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748859994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjUTSvOng+W7JEAyCf/KH/itZzV9YwnTBi8GIOhN5NY=;
	b=M5KUVgCdWzAck43fBaNG4UDBqKWEVrwUOfcK2kg6R2ZMVhrcO3B8F5BjhVar5MxjZA9p4V
	/YgJbavJlAVlgHbE1jqIGb6jbc7zK2hyF5cQNnZhIMi6gSbG7x2ca0rLvQlua5ovTFOgkW
	Bw+hoT6L+unBtBSw+uQiRLU33WjwJEs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-vkNrHj-HNGG9n1b1vb69Tg-1; Mon, 02 Jun 2025 06:26:33 -0400
X-MC-Unique: vkNrHj-HNGG9n1b1vb69Tg-1
X-Mimecast-MFC-AGG-ID: vkNrHj-HNGG9n1b1vb69Tg_1748859992
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4eeed54c2so2743118f8f.3
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 03:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748859992; x=1749464792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjUTSvOng+W7JEAyCf/KH/itZzV9YwnTBi8GIOhN5NY=;
        b=kDKYIrNG+fYJYD98biyM4qq5zM3dbSXGaHFJl2QYfAI5fQEzIlPQWuMov77nHlfIJf
         8hLWTsY4qPFDr2CWZi/q8tT1FJW6CQwau+DB00gBhTdBdX3Q3sZMqbfqR8a9PFeKRuyD
         pcExXQ+q7tFDaTFAFakEQJ1k0QE2QTXZlI6xBenVNX7MXH8+PcI8xqvxAM/CoTgLG7Q4
         sNhQzIEeIbzRI3WlaJqACtS2RBCwoThhQepSk6N51RhbHeG2KG1Lax7bcxxSOVhTio/z
         RbWldYpt2g6QUEzdpdd4dWtIU54oo7uvO+8Urfk7TPZRH+4xiR0LgfQnUPJZYRRMf2hY
         DXJA==
X-Forwarded-Encrypted: i=1; AJvYcCUZA/rV4/snEUTSKOfeUeiA+X4ISNTh6H7WIO9VTS/KSrW0h4eqhmyvPZi20kFRCZc6sQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyahozPin90dlSvIghEoGRA7Rr6g5CCnqgwnUuYtuUkF9kHLjYF
	+5bKqQVKXP9asWrqP8CP3Be+IOhtiTeOgMiJM14jJLwWQ9blwsXmBoqciYrmu1Urz0ri1+jXWOr
	Vr4aKlVDogyyZHq2eSK1wKPslaVZ59MgmYJBhH9FerYpE7dtUSsV7aw==
X-Gm-Gg: ASbGncuynmeui4IUDDVSTbXHKzuIPvxqfqTN4gNng91FM94mV7pw4ji/OC/Cro7Wt8c
	7lxc9PJHzAPUCmQqvhMSmrv9N5YW/IL9AA1ECA8q77iy0MEDzWAmzzPeEEU+LBBvYpo+ilCpG5y
	Tb4Ind/sx4eidztpHAktei1hOMs+Lurf23FHTcsEgeXXYzLJf0BFpKZkttCNdTChLQxCh9YcbhI
	Y8ubTSxWptbmbgcYjszEZyAV0RO4yERI74YUDipoDPuYhtxw1BAQ193gK5xB5at9q7cEuHoA417
	KlbTbDAY7CtuuPlIHQwQX4W8lvncx2Fb
X-Received: by 2002:adf:eed2:0:b0:3a4:efbb:6df3 with SMTP id ffacd0b85a97d-3a4f89a47dfmr7990730f8f.10.1748859992271;
        Mon, 02 Jun 2025 03:26:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqfnK734UaQP4TQvGO+uFhkNUwUhX1mcxR/v3N9c0C0yY3xZbMEl/zvBP9EavzY06cA2KKrA==
X-Received: by 2002:adf:eed2:0:b0:3a4:efbb:6df3 with SMTP id ffacd0b85a97d-3a4f89a47dfmr7990708f8f.10.1748859991844;
        Mon, 02 Jun 2025 03:26:31 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d8006ff8sm116094735e9.34.2025.06.02.03.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 03:26:31 -0700 (PDT)
Date: Mon, 2 Jun 2025 12:26:30 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org, Richard Henderson
 <richard.henderson@linaro.org>, kvm@vger.kernel.org, Sergio Lopez
 <slp@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Alistair Francis
 <alistair.francis@wdc.com>, Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-riscv@nongnu.org, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Zhao Liu <zhao1.liu@intel.com>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>, =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif
 <clement.mathieu--drif@eviden.com>, qemu-arm@nongnu.org, =?UTF-8?B?TWFy?=
 =?UTF-8?B?Yy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai Chen
 <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>, Mark Cave-Ayland
 <mark.caveayland@nutanix.com>
Subject: Re: [PATCH v4 01/27] hw/i386/pc: Remove deprecated pc-q35-2.6 and
 pc-i440fx-2.6 machines
Message-ID: <20250602122630.2d28a9b8@imammedo.users.ipa.redhat.com>
In-Reply-To: <c2999ee1-c0a1-4a09-85f8-6c10ede14584@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-2-philmd@linaro.org>
	<20250509172336.6e73884f@imammedo.users.ipa.redhat.com>
	<91c4bf9f-3079-4e2f-9fbb-e1a2a9c56c7b@redhat.com>
	<c2999ee1-c0a1-4a09-85f8-6c10ede14584@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jun 2025 10:53:19 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> On 2/6/25 08:13, Thomas Huth wrote:
> > On 09/05/2025 17.23, Igor Mammedov wrote: =20
> >> On Thu,=C2=A0 8 May 2025 15:35:24 +0200
> >> Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:
> >> =20
> >>> These machines has been supported for a period of more than 6 years.
> >>> According to our versioned machine support policy (see commit
> >>> ce80c4fa6ff "docs: document special exception for machine type
> >>> deprecation & removal") they can now be removed. =20
> >>
> >> if these machine types are the last users of compat arrays,
> >> it's better to remove array at the same time, aka squash
> >> those patches later in series into this one.
> >> That leaves no illusion that compats could be used in the later patche=
s. =20
> >=20
> > IMHO the generic hw_compat array should be treated separately since thi=
s=20
> > is independent from x86. So in case someone ever needs to backport thes=
e=20
> > patches to an older branch, they can decide more easily whether they=20
> > want to apply the generic hw_compat part or only the x86-specific part=
=20
> > of this series. =20
>=20
> Yes, it is clearer this way than squashed.

ok, let's leave it as is.

>=20


