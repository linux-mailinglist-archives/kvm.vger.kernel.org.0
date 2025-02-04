Return-Path: <kvm+bounces-37236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C8FA2737F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 356173A84BF
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209C62135B2;
	Tue,  4 Feb 2025 13:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i15LuhlG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE72320DD4B
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738676404; cv=none; b=EomeR/ezz96u6h2WspNHVzbN+syx8ixkrRQ74JIRm1vJh8CUtDCGTcIgZcf8TW6DZTTLVVM3Tj+uPNZZRCXe0C3bsEv85lvXWw4BAeSaILQKRSdmGJmfdIOxDDbrnPf9ikNfIRJ+EoaBYRlGF5S9IUbeqeLzODyo/qCGfUsvIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738676404; c=relaxed/simple;
	bh=f1boeRXHC7LRX1uuqcTg/rIM0N9MookuaJOLi48mBFk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgkOI2S5BgXZum5V4a4qQGvlVqipeihsBHkoqRjGU8WuVwhDz6yddaaqhD8rpAwccRfdOfZgPZ9z5/ws4tusYaWOwNExbo5BzUKNhkwTNxFXLvaqkr7avxYEscZph2mpk5+EteqaTV9OYhgSaxGbpBqxZWi2stVm1TzwxGe/PzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i15LuhlG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738676400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fpwi/uAGiZl2TO6E2msFPHs/wAJOGyBG92fvc8C3tmE=;
	b=i15LuhlGayFavDq1PuG5e7ZwQSOMMb0V8VAA9WBzTj9wfZEscMnRbOLeGc95/X7752C4qL
	9J1hPVO0wLECEd49ILan5/flkwswMoyMpMg3AU6VdFIFyKMw/9La684Aiyx4nAZMsUTPpo
	oT5IWnr8dBUf227AH1YTFMukzwNHJkc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-o7AxkW49NF29KgGX4uwGOQ-1; Tue, 04 Feb 2025 08:39:57 -0500
X-MC-Unique: o7AxkW49NF29KgGX4uwGOQ-1
X-Mimecast-MFC-AGG-ID: o7AxkW49NF29KgGX4uwGOQ
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dae2ab056so192180f8f.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 05:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738676396; x=1739281196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fpwi/uAGiZl2TO6E2msFPHs/wAJOGyBG92fvc8C3tmE=;
        b=wpSdKqXHxUw5KPW9nO32aOeyOu/0lm8nXqsIHGcDzkGNdAUxFvIrY2SSNAxkwF9r8s
         yGdz5+RV3xd/QRtpo0ZyLJug5xzk7TzWWl7jWSFnDhbKhm3ONHG9+D9uj9zMe+BGj5p0
         V7qxe+apn8tZl6PV8WldVsLIhHLtfjuYTP30W0++14nnOqzcx6ayoCSANuMZ9q1RAYB1
         BNr/U6lCI/eqYt1VRmZ0MGaxzbZ32StDWboe/W3O0HU8q8GjZsHiKeSN/u0K6mPyuT9s
         zmeuNYg4l/IrTWsQ9nQcY/GfivYAOM2kdBV3i61T/8pdi3BJlmpa4kqYHYPt5Cz/C8bQ
         pQPg==
X-Forwarded-Encrypted: i=1; AJvYcCV3UEn9kXzp4bymq2oM0ksm+Wb+rm9EIAXSMb5uSn1kFKefDQbIu8rUTnrjO4xezlt0izk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0cFsc6orlvvpHnXqhduPkGfHC2pu38wlXi8CHsVXAUANUbgI2
	w3+JlFpoCQlD/9ka/9+xlSX2POQILCj0kkjN3MQ1J8quVyuAE9WI+HAI9+f7Ooz6SQKilgUaR3R
	3DU2Ei096PsYalDk8fY3PkgijE+kqZj+aq4r7JbpyUcttrtN9NA==
X-Gm-Gg: ASbGnctDv1/cLU2GBlJcUg7/ubiQNCg3vklNLS5IwTDz8ydU5IMJOxhXBJVl0t3SUjG
	1Swjm0kcI//GvOo/x/lLAwPnWxCOCqrzuMPs+0ptKaVWnRaZCPFxytAR53RhUYV6RF3Mwcb9alT
	3Km8vkLaNua9d1rccN4SmADUCtl2kYnDW31+C+IHuHXaM3pxryeMYPhCS87Yw1A0+ovdJKrhjIY
	ZGPDkzUrDaTfKlyXWlN4b8qb5MnXLgkI+EjH6gOJzUWT0X2MOQy8i/MJkN8LfTIb2LTDpLytVTm
	UTgvYL8K7bamYza6/KVS00+yQQv5V5HUzT0C/qy3Of+98p8cDyNS
X-Received: by 2002:a05:6000:1882:b0:38d:ac77:d7cb with SMTP id ffacd0b85a97d-38dac77e622mr1511609f8f.25.1738676396099;
        Tue, 04 Feb 2025 05:39:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWS06XkS4wfY87PLKsU5U+H33xduHzvci02Yyz8BZjsSU1w5EfjswfpK2x2K0vZhyJYXoDeg==
X-Received: by 2002:a05:6000:1882:b0:38d:ac77:d7cb with SMTP id ffacd0b85a97d-38dac77e622mr1511579f8f.25.1738676395601;
        Tue, 04 Feb 2025 05:39:55 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc1315esm221741005e9.6.2025.02.04.05.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 05:39:55 -0800 (PST)
Date: Tue, 4 Feb 2025 14:39:53 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Richard Henderson <richard.henderson@linaro.org>
Cc: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, Yanan Wang
 <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Harsh
 Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org, Zhao Liu
 <zhao1.liu@intel.com>, "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>, Paolo
 Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 4/9] hw/qdev: Introduce DeviceClass::[un]wire()
 handlers
Message-ID: <20250204143953.27430bc3@imammedo.users.ipa.redhat.com>
In-Reply-To: <b7646baf-a07d-4ded-804c-6809173c1f6b@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
	<20250128142152.9889-5-philmd@linaro.org>
	<b7646baf-a07d-4ded-804c-6809173c1f6b@linaro.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jan 2025 12:52:39 -0800
Richard Henderson <richard.henderson@linaro.org> wrote:

> On 1/28/25 06:21, Philippe Mathieu-Daud=C3=A9 wrote:
> > We are trying to understand what means "a qdev is realized".
> > One explanation was "the device is guest visible"; however
> > many devices are realized before being mapped, thus are not
> > "guest visible". Some devices map / wire their IRQs before
> > being realized (such ISA devices). There is a need for devices
> > to be "automatically" mapped/wired (see [2]) such CLI-created
> > devices, but this apply generically to dynamic machines.
> >=20
> > Currently the device creation steps are expected to roughly be:
> >=20
> >    (external use)                (QDev core)                   (Device =
Impl)
> >     ~~~~~~~~~~~~                  ~~~~~~~~~                     ~~~~~~~=
~~~~
> >=20
> >                                 INIT enter =20
> >                     -----> =20
> >                           +----------------------+
> >                           |    Allocate state    |
> >                           +----------------------+ =20
> >                                                   -----> =20
> >                                                          +-------------=
--------+
> >                                                          | INIT childre=
n       |
> >                                                          |             =
        |
> >                                                          | Alias childr=
en properties
> >                                                          |             =
        |
> >                                                          | Expose prope=
rties   |
> >                                  INIT exit               +-------------=
--------+
> >                     <-----------------------------------
> >   +----------------+
> >   | set properties |
> >   |                |
> >   | set ClkIn      |
> >   +----------------+          REALIZE enter =20
> >                     ----------------------------------> =20
> >                                                         +--------------=
--------+
> >                                                         | Use config pr=
operties|
> >                                                         |              =
        |
> >                                                         | Realize child=
ren     |
> >                                                         |              =
        |
> >                                                         | Init GPIOs/IR=
Qs      |
> >                                                         |              =
        |
> >                                                         | Init MemoryRe=
gions   |
> >                                                         +--------------=
--------+
> >                                 REALIZE exit
> >                     <-----------------------------------               =
         ----  "realized" / "guest visible"
> > +-----------------+
> > | Explicit wiring:|
> > |   IRQs          |
> > |   I/O / Mem     |
> > |   ClkOut        |
> > +-----------------+             RESET enter =20
> >                      ---------------------------------> =20
> >                                                         +--------------=
--------+
> >                                                         | Reset default=
 values |
> >                                                         +--------------=
--------+
> >=20
> > But as mentioned, various devices "wire" parts before they exit
> > the "realize" step.
> > In order to clarify, I'm trying to enforce what can be done
> > *before* and *after* realization.
> >=20
> > *after* a device is expected to be stable (no more configurable)
> > and fully usable.
> >=20
> > To be able to use internal/auto wiring (such ISA devices) and
> > keep the current external/explicit wiring, I propose to add an
> > extra "internal wiring" step, happening after the REALIZE step

we partially have such wiring in place
  hotplug_handler_plug
'hotplug_' prefix is legacy remnant to confuse every, it really
should be renamed to just plug_handler or 'wire_foo'.

For bus-less CPUs it's used both on hot- and cold-plug paths.

It does take care of wiring after realize part is completed
(basically exposing device to the external users).

And I it also handles 'bus' based plug workflow
see qdev_get_hotplug_handler() assuming bus owner has provided a callback.
It's likely no-one had cared about ISA, as it was out of
hotplug scope when the interface was introduced.

Unplug part is however is not wired directly into unrealize() stage,
but rather to an external caller (mgmt or guest), which
essentially unwinds into the same hotplug_handler chain as plug,
to unwire device and then the same external caller does call unrealize
on device. (see:hotplug_handler_unplug() )

As for more direct hack, there is also DEVICE_LISTENER_CALL() callback,
which is more close to this approach (modulo users are hidden as
there is not explicit wiring).
Unrealize part is called too late (which probably is not right),
and realize part is called before subtree is realized (might work for
current users, but likely should be placed at the same site as wire() call.

Hence we should think if already existing methods could be reused/adapted t=
o,
before adding similar wire/unwire mechanism.


> > as:
> >=20
> >    (external use)                (QDev core)                   (Device =
Impl)
> >     ~~~~~~~~~~~~                  ~~~~~~~~~                     ~~~~~~~=
~~~~
> >=20
> >                                 INIT enter =20
> >                     -----> =20
> >                           +----------------------+
> >                           |    Allocate state    |
> >                           +----------------------+ =20
> >                                                   -----> =20
> >                                                          +-------------=
--------+
> >                                                          | INIT childre=
n       |
> >                                                          |             =
        |
> >                                                          | Alias childr=
en properties
> >                                                          |             =
        |
> >                                                          | Expose prope=
rties   |
> >                                  INIT exit               +-------------=
--------+
> >                     <-----------------------------------
> >   +----------------+
> >   | set properties |
> >   |                |
> >   | set ClkIn      |
> >   +----------------+          REALIZE enter =20
> >                     ----------------------------------> =20
> >                                                         +--------------=
--------+
> >                                                         | Use config pr=
operties|
> >                                                         |              =
        |
> >                                                         | Realize child=
ren     |
> >                                                         |              =
        |
> >                                                         | Init GPIOs/IR=
Qs      |
> >                                                         |              =
        |
> >                                                         | Init MemoryRe=
gions   |
> >                                                         +--------------=
--------+
> >                                 REALIZE exit       <---
> >                           +----------------------+
> >                           | Internal auto wiring |
> >                           |   IRQs               |  (i.e. ISA bus)
> >                           |   I/O / Mem          |
> >                           |   ClkOut             |
> >                           +----------------------+
> >                      <---                                              =
         ----  "realized"
> > +-----------------+
> > | External wiring:|
> > |   IRQs          |
> > |   I/O / Mem     |
> > |   ClkOut        |
> > +-----------------+             RESET enter                            =
        ----  "guest visible" =20
> >                      ---------------------------------> =20
> >                                                         +--------------=
--------+
> >                                                         | Reset default=
 values |
> >                                                         +--------------=
--------+
> >=20
> > The "realized" point is not changed. "guest visible" concept only
> > occurs *after* wiring, just before the reset phase.
> >=20
> > This change introduces the DeviceClass::wire handler within qdev
> > core realization code.
> >=20
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > ---
> >   include/hw/qdev-core.h |  7 +++++++
> >   hw/core/qdev.c         | 20 +++++++++++++++++++-
> >   2 files changed, 26 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
> > index 530f3da7021..021bb7afdc0 100644
> > --- a/include/hw/qdev-core.h
> > +++ b/include/hw/qdev-core.h
> > @@ -102,7 +102,12 @@ typedef int (*DeviceSyncConfig)(DeviceState *dev, =
Error **errp);
> >    * @props: Properties accessing state fields.
> >    * @realize: Callback function invoked when the #DeviceState:realized
> >    * property is changed to %true.
> > + * @wire: Callback function called after @realize to connect IRQs,
> > + * clocks and map memories. Can not fail.
> > + * @unwire: Callback function to undo @wire. Called before @unrealize.
> > + * Can not fail.
> >    * @unrealize: Callback function invoked when the #DeviceState:realiz=
ed
> > + * property is changed to %false. Can not fail.
> >    * property is changed to %false.
> >    * @sync_config: Callback function invoked when QMP command device-sy=
nc-config
> >    * is called. Should synchronize device configuration from host to gu=
est part
> > @@ -171,6 +176,8 @@ struct DeviceClass {
> >        */
> >       DeviceReset legacy_reset;
> >       DeviceRealize realize;
> > +    void (*wire)(DeviceState *dev);
> > +    void (*unwire)(DeviceState *dev);
> >       DeviceUnrealize unrealize;
> >       DeviceSyncConfig sync_config;
> >  =20
> > diff --git a/hw/core/qdev.c b/hw/core/qdev.c
> > index 82bbdcb654e..38449255365 100644
> > --- a/hw/core/qdev.c
> > +++ b/hw/core/qdev.c
> > @@ -554,6 +554,15 @@ static void device_set_realized(Object *obj, bool =
value, Error **errp)
> >               }
> >          }
> >  =20
> > +        if (dc->wire) {
> > +            if (!dc->unwire) {
> > +                warn_report_once("wire() without unwire() for type '%s=
'",
> > +                                 object_get_typename(OBJECT(dev)));
> > +            }
> > +            dc->wire(dev);
> > +        }
> > +
> > +        /* At this point the device is "guest visible". */
> >          qatomic_store_release(&dev->realized, value);
> >  =20
> >       } else if (!value && dev->realized) {
> > @@ -573,6 +582,15 @@ static void device_set_realized(Object *obj, bool =
value, Error **errp)
> >            */
> >           smp_wmb();
> >  =20
> > +        if (dc->unwire) {
> > +            if (!dc->wire) {
> > +                error_report("disconnect() without connect() for type =
'%s'",
> > +                             object_get_typename(OBJECT(dev)));
> > +                abort();
> > +            }
> > +            dc->unwire(dev);
> > +        } =20
>=20
> Mismatched error messages (wire vs connect).
> But, really, just check both directions properly at startup.
> There's probably lots of places where devices are never unrealized.
>=20
> Otherwise, this seems sane, having a kind of post_init on the realize pat=
h, running after=20
> all superclass realization is done.
>=20
>=20
> r~
>=20


