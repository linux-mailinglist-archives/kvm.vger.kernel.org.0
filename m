Return-Path: <kvm+bounces-4131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1905480E266
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 04:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F0FAB214A2
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 03:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19FF28C17;
	Tue, 12 Dec 2023 03:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e9TqMgWq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1836BA
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 19:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702350027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/GWabnUccw3NaInncXMDYCSfx9WQ13D52xz9bmZnXo=;
	b=e9TqMgWq1zdVPcjCfOZwvFxzwvDHf2fOMbTNbWuTNXSGaSh0ksqpI9L2s2IpvXHYgUt1E5
	7XjxA9mdC0gC8NMtzESSH0LkYN1PIAzZuET8qAgMQJlKjgYnlgH5PgUG8ELMci20P7Vimt
	pECdYPyoxUWkwkAbrPzXk0YUBx84t8M=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-m7uBQK82M7K5RR384gXm_A-1; Mon, 11 Dec 2023 22:00:25 -0500
X-MC-Unique: m7uBQK82M7K5RR384gXm_A-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-590b580ae39so3674457eaf.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 19:00:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702350025; x=1702954825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/GWabnUccw3NaInncXMDYCSfx9WQ13D52xz9bmZnXo=;
        b=CNa1usjbG1FWykcGClVxtRcarLNBrp6lSUOYKuMQW5jPev6KSKPDiEEn6YQYeLJ0cN
         FvovRFATAGmyT+OayO0ZxLIDix2/QPO/7W2kdzpD8HEfftCim00RlTYEkgGsf1dnafTo
         GrYleo2fpgmH+93bbZ/T3b8kV7LFArvecSpYMuvLAW7VbbtK49XT/wpfGPZJzWJtm3bo
         sThF0P4iBOs1RLXbIKo+S+d3eKFAyb9d4+ru6L9Hi0yN5vnnb2Lkcd8lJULiz+v1AqJI
         LR7UYfZz5fSnAQkRkJR6OdVO7goZBx8euEnMnNscwaY4F4VMnesMeJfzjSOLCtKrvUaX
         C0eA==
X-Gm-Message-State: AOJu0YyAdJhA9le4RrfvipFeCcSG/BqdFpKoiqIU85TsSvv0SXyOwNUg
	kroTMh8ionXPn1pPR+UJAPPjVeFzVAB2U9p1DQ6gXZ+thKphaYyF8rElGT2RN0d2EA9N0nKy1cI
	pEl10LUX/7DINEISlWzJHRCaEi11J
X-Received: by 2002:a05:6358:260e:b0:16e:4c3:f8c3 with SMTP id l14-20020a056358260e00b0016e04c3f8c3mr6935871rwc.11.1702350024819;
        Mon, 11 Dec 2023 19:00:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEp3OwNK9PoGoQnXeeX4+viPi6Hk3B5tFT4RIMaX8AFHJ44Lb0NnCW5h1v++Uvw9C1SRvVa6MdgSmune5oTLWk=
X-Received: by 2002:a05:6358:260e:b0:16e:4c3:f8c3 with SMTP id
 l14-20020a056358260e00b0016e04c3f8c3mr6935850rwc.11.1702350024367; Mon, 11
 Dec 2023 19:00:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com> <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org> <56082.123120804242300177@us-mta-137.us.mimecast.lan>
 <20231208052150-mutt-send-email-mst@kernel.org> <53044.123120806415900549@us-mta-342.us.mimecast.lan>
 <20231209053443-mutt-send-email-mst@kernel.org> <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
 <20231211115329-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231211115329-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 12 Dec 2023 11:00:12 +0800
Message-ID: <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tobias Huschle <huschle@linux.ibm.com>, Abel Wu <wuyun.abel@bytedance.com>, 
	Peter Zijlstra <peterz@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 12:54=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Mon, Dec 11, 2023 at 03:26:46PM +0800, Jason Wang wrote:
> > > Try reducing the VHOST_NET_WEIGHT limit and see if that improves thin=
gs any?
> >
> > Or a dirty hack like cond_resched() in translate_desc().
>
> what do you mean, exactly?

Ideally it should not matter, but Tobias said there's an unexpectedly
long time spent on translate_desc() which may indicate that the
might_sleep() or other doesn't work for some reason.

Thanks

>
> --
> MST
>


