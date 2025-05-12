Return-Path: <kvm+bounces-46166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C6EAB3569
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 12:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6258A189475A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 10:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4010D26FDB0;
	Mon, 12 May 2025 10:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCChHwCg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920DA267F46
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747047282; cv=none; b=TuNJ9kN3LHoauBBnK6FBj5//FEaEzXd4smo2HF5zZuGS3jpnanvFE0OmFbLhUFFru+StqYTN/ENqS+1ongnvqoMZlBaW989aA31+OnsFKKAglFOpy6HWYKN/REmqP3Kp3XS4bZZRBVg4f5Oc4RZNiXGNHvbGblfzEkY/04OQgxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747047282; c=relaxed/simple;
	bh=EDXvHzmlF3uvogSVqe/c3J2PPS71nZZ68cBvbKpSvuk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aN856MsciVJuKq4v8wkCOfB/AcmJvGDi4joa4rfpZvJTnRguGCGhu52rc7xP8dnfWGPenRko+bIp+5KFR3sIvHdRFDqmucn20n7But4ffhtVTdQe+EHrm7RLcmIfTyEIM4rPf/6waGgF2CfxarGn2//9incLt7UtqZ7YjDtMSEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iCChHwCg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747047279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrhwlyGHBUeZB9shLrDj8sqTvUNxSWhy6HB7k6LP93M=;
	b=iCChHwCgNuvlCMaK+o4+zvzUysqvfT54c6npibsqHDje1BOTBNRkg+FmXC1dmvfL++R79J
	C/dkjhOUFHRoy2bEOQoz9cLY/21dq9foVfogHa9BDc54BqiUJvJdfUcKIWI/oZk64WPHg8
	qmpKHgzHxMOsqL2dD2mMQN/HBbdeLUM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-44B2jiPpPf6gVRkeWUfX9g-1; Mon,
 12 May 2025 06:54:36 -0400
X-MC-Unique: 44B2jiPpPf6gVRkeWUfX9g-1
X-Mimecast-MFC-AGG-ID: 44B2jiPpPf6gVRkeWUfX9g_1747047273
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4108E180045B;
	Mon, 12 May 2025 10:54:32 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.27])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F165180049D;
	Mon, 12 May 2025 10:54:30 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 506DC21E66E3; Mon, 12 May 2025 12:54:27 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,  Thomas Huth
 <thuth@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,  Xiaoyao Li
 <xiaoyao.li@intel.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Paolo Bonzini <pbonzini@redhat.com>,  qemu-devel@nongnu.org,  Richard
 Henderson <richard.henderson@linaro.org>,  kvm@vger.kernel.org,  Gerd
 Hoffmann <kraxel@redhat.com>,  Laurent Vivier <lvivier@redhat.com>,
  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Yi Liu <yi.l.liu@intel.com>,
  "Michael S. Tsirkin" <mst@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Alistair Francis <alistair.francis@wdc.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  qemu-riscv@nongnu.org,  Weiwei Li <liwei1518@gmail.com>,  Amit Shah
 <amit@kernel.org>,  Yanan Wang <wangyanan55@huawei.com>,  Helge Deller
 <deller@gmx.de>,  Palmer Dabbelt <palmer@dabbelt.com>,  Ani Sinha
 <anisinha@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Fabiano
 Rosas <farosas@suse.de>,  Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
  =?utf-8?Q?Cl=C3=A9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
  qemu-arm@nongnu.org,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  Huacai Chen <chenhuacai@kernel.org>,  Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties
In-Reply-To: <aCG6MuDLrQpoTqpg@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Mon, 12 May 2025 10:06:58 +0100")
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-13-philmd@linaro.org>
	<23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
	<aB2vjuT07EuO6JSQ@intel.com>
	<2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
	<CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
	<aCG6MuDLrQpoTqpg@redhat.com>
Date: Mon, 12 May 2025 12:54:26 +0200
Message-ID: <87jz6mqeu5.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Mon, May 12, 2025 at 09:46:30AM +0100, Peter Maydell wrote:
>> On Fri, 9 May 2025 at 11:04, Thomas Huth <thuth@redhat.com> wrote:
>> > Thanks for your clarifications, Zhao! But I think this shows again the
>> > problem that we have hit a couple of times in the past already: Proper=
ties
>> > are currently used for both, config knobs for the users and internal
>> > switches for configuration of the machine. We lack a proper way to say=
 "this
>> > property is usable for the user" and "this property is meant for inter=
nal
>> > configuration only".
>> >
>> > I wonder whether we could maybe come up with a naming scheme to better
>> > distinguish the two sets, e.g. by using a prefix similar to the "x-" p=
refix
>> > for experimental properties? We could e.g. say that all properties sta=
rting
>> > with a "q-" are meant for QEMU-internal configuration only or something
>> > similar (and maybe even hide those from the default help output when r=
unning
>> > "-device xyz,help" ?)? Anybody any opinions or better ideas on this?
>>=20
>> I think a q-prefix is potentially a bit clunky unless we also have
>> infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
>> and have it auto-add the prefix, and to have the C APIs for
>> setting properties search for both "foo" and "q-foo" so you
>> don't have to write qdev_prop_set_bit(dev, "q-foo", ...).

If we make intent explicit with DEFINE_INTERNAL_PROP_FOO(), is repeating
intent in the name useful?

> I think it is also not obvious enough that a 'q-' prefix means private.

Concur.

> Perhaps borrow from the C world and declare that a leading underscore
> indicates a private property. People are more likely to understand and
> remember that, than 'q-'.

This is fine for device properties now.  It's not fine for properties of
user-creatable objects, because these are defined in QAPI, and QAPI
prohibits names starting with a single underscore.  I append relevant
parts of docs/devel/qapi-code-gen.rst for your convenience.

Why does QAPI prohibit leading underscores?  Chiefly because such names
are reserved identifiers in C.  Instead of complicating the mapping from
QAPI name to C identifier, we restrict QAPI names and call it a day.

The mapping between device property name and C identifiers is entirely
manual.  When a property is backed by a member of the device state
struct, naming the member exactly like the property makes sense.  Having
to mentally strip / insert a leading underscore would hardly be
terrible, just a bit of friction.  I'd prefer not to.




Naming rules and reserved names
-------------------------------

All names must begin with a letter, and contain only ASCII letters,
digits, hyphen, and underscore.  There are two exceptions: enum values
may start with a digit, and names that are downstream extensions (see
section `Downstream extensions`_) start with underscore.

Names beginning with ``q_`` are reserved for the generator, which uses
them for munging QMP names that resemble C keywords or other
problematic strings.  For example, a member named ``default`` in qapi
becomes ``q_default`` in the generated C code.

[...]

Downstream extensions
---------------------

QAPI schema names that are externally visible, say in the Client JSON
Protocol, need to be managed with care.  Names starting with a
downstream prefix of the form __RFQDN_ are reserved for the downstream
who controls the valid, reverse fully qualified domain name RFQDN.
RFQDN may only contain ASCII letters, digits, hyphen and period.

Example: Red Hat, Inc. controls redhat.com, and may therefore add a
downstream command ``__com.redhat_drive-mirror``.


