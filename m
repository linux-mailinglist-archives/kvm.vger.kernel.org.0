Return-Path: <kvm+bounces-46302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 395D3AB4DAC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 906813B3821
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 08:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521891F584C;
	Tue, 13 May 2025 08:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUShxRIQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EDA1F5424
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 08:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123710; cv=none; b=nVJR+19HLydcCKp/spSsj1IomVWb0bfVzYoOLkpBPdnldiI/BakIom1YCyz8puwC2TnWwGMEtffGQ3KhWJJlUq+Qppt2T/r+AaQnt4ecyQlPOsA4hqOO+JMWdFmlzyTs87bmPpgdTyGFWK0Gp6GqRgsdVTCuQ5EraLVazdB3N80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123710; c=relaxed/simple;
	bh=y05rK/geavaNrB3PHWtOJ+zgvLpJvQ3MPvMJo9zeBX0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kkqnxAAIU9089gdKnfZZg5F4mFhUUoPT709IaHnuSWqZwHCEPHQb1yn6yV8ZOSi3mXBk8UU/sk7maQdBkrCcc70ocVkpiiqh6HZXJHIML84lPoDnpR4h33a1pSb9hJ0iJmNnOHxKslyMh7DXtGfPcFHjkrKyfIdV+2ioCNQK0QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VUShxRIQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747123707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I+Gv9eTQq4KU9E7dEF3HAfmHKcWMwL8LbrI4vrBOurs=;
	b=VUShxRIQ+0Kmlg/mh8nESzCLlJJKESy1eJ6x7elTIDhTfR9netaadblSBizqfgrf/Ph1h8
	lfVcYZIYFC8Be72SPg0U7z8gsH5PKztK2bwKfkB/LZ0tyXAF4YFAbNA4xHl8VV5x33/eM6
	2L4kF0TbaRCwoK+rQU0Kx4+nUqw+TCg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-Tdm_Y8VHNDu_jRyW3wVE9A-1; Tue,
 13 May 2025 04:08:24 -0400
X-MC-Unique: Tdm_Y8VHNDu_jRyW3wVE9A-1
X-Mimecast-MFC-AGG-ID: Tdm_Y8VHNDu_jRyW3wVE9A_1747123701
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E6531955D8F;
	Tue, 13 May 2025 08:08:20 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AFA818003FC;
	Tue, 13 May 2025 08:08:18 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id C227321E66C3; Tue, 13 May 2025 10:08:15 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,  Peter
 Maydell
 <peter.maydell@linaro.org>,  Thomas Huth <thuth@redhat.com>,  Zhao Liu
 <zhao1.liu@intel.com>,  Xiaoyao Li <xiaoyao.li@intel.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,
  qemu-devel@nongnu.org,  Richard Henderson <richard.henderson@linaro.org>,
  kvm@vger.kernel.org,  Gerd Hoffmann <kraxel@redhat.com>,  Laurent Vivier
 <lvivier@redhat.com>,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Yi Liu
 <yi.l.liu@intel.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Eduardo
 Habkost <eduardo@habkost.net>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Alistair Francis
 <alistair.francis@wdc.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  qemu-riscv@nongnu.org,  Weiwei Li <liwei1518@gmail.com>,  Amit Shah
 <amit@kernel.org>,  Yanan Wang <wangyanan55@huawei.com>,  Helge Deller
 <deller@gmx.de>,  Palmer Dabbelt <palmer@dabbelt.com>,  Ani Sinha
 <anisinha@redhat.com>,  Fabiano Rosas <farosas@suse.de>,  Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>,  =?utf-8?Q?Cl=C3=A9ment?= Mathieu--Drif
 <clement.mathieu--drif@eviden.com>,  qemu-arm@nongnu.org,  =?utf-8?Q?Marc?=
 =?utf-8?Q?-Andr=C3=A9?=
 Lureau <marcandre.lureau@redhat.com>,  Huacai Chen
 <chenhuacai@kernel.org>,  Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties
In-Reply-To: <20250512172226.433900f8@imammedo.users.ipa.redhat.com> (Igor
	Mammedov's message of "Mon, 12 May 2025 17:22:26 +0200")
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-13-philmd@linaro.org>
	<23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
	<aB2vjuT07EuO6JSQ@intel.com>
	<2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
	<CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
	<aCG6MuDLrQpoTqpg@redhat.com> <87jz6mqeu5.fsf@pond.sub.org>
	<20250512172226.433900f8@imammedo.users.ipa.redhat.com>
Date: Tue, 13 May 2025 10:08:15 +0200
Message-ID: <87msbhgcgg.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Igor Mammedov <imammedo@redhat.com> writes:

> On Mon, 12 May 2025 12:54:26 +0200
> Markus Armbruster <armbru@redhat.com> wrote:
>
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>=20
>> > On Mon, May 12, 2025 at 09:46:30AM +0100, Peter Maydell wrote:=20=20
>> >> On Fri, 9 May 2025 at 11:04, Thomas Huth <thuth@redhat.com> wrote:=20=
=20
>> >> > Thanks for your clarifications, Zhao! But I think this shows again =
the
>> >> > problem that we have hit a couple of times in the past already: Pro=
perties
>> >> > are currently used for both, config knobs for the users and internal
>> >> > switches for configuration of the machine. We lack a proper way to =
say "this
>> >> > property is usable for the user" and "this property is meant for in=
ternal
>> >> > configuration only".
>> >> >
>> >> > I wonder whether we could maybe come up with a naming scheme to bet=
ter
>> >> > distinguish the two sets, e.g. by using a prefix similar to the "x-=
" prefix
>> >> > for experimental properties? We could e.g. say that all properties =
starting
>> >> > with a "q-" are meant for QEMU-internal configuration only or somet=
hing
>> >> > similar (and maybe even hide those from the default help output whe=
n running
>> >> > "-device xyz,help" ?)? Anybody any opinions or better ideas on this=
?=20=20
>> >>=20
>> >> I think a q-prefix is potentially a bit clunky unless we also have
>> >> infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
>> >> and have it auto-add the prefix, and to have the C APIs for
>> >> setting properties search for both "foo" and "q-foo" so you
>> >> don't have to write qdev_prop_set_bit(dev, "q-foo", ...).=20=20
>>=20
>> If we make intent explicit with DEFINE_INTERNAL_PROP_FOO(), is repeating
>> intent in the name useful?
>
> While we are inventing a new API, I'd say that _INTERNAL_ is not the only=
 thing
> on my wish-list wrt properties.
> It would be also nice to know when a property is set by internal or exter=
nal user
> or if it still has default value.

We commonly assume "value is default implies user didn't touch it",
which is of course wrong unless it's a value the user cannot set.

> Basically we are looking at different flags for properties and INERNAL be=
ing
> one of them.
>
> Maybe instead of specialized macro, we should have a more generic
>    DEFINE_PROP_WITH_FLAGS_FOO(...,flags)
> So we won't have to rewrite it again when we think of another flag to tur=
n on/off.
>
>
> From previous uses of x- flag, some of such properties are created as
> temporary | developer-only and occasionally as a crutch (still no intende=
d for end user).
> But then sometimes such properties get promoted to ABI with fat warnings
> not to touch them. Having stable|unstable flag could help here without
> need to rename property (and prevent breaking users who (ab)used it if we=
 care).

I think QAPI's explicit 'unstable' and 'deprecated' flags have been a
success.  Their meaning is clear, and they come with documentation
(because adding them without won't compile).

Pushing QOM closer to QAPI when we can makes sense to me.


