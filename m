Return-Path: <kvm+bounces-46343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E52AB535C
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 13:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 291FD461D03
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16ECC28C5A7;
	Tue, 13 May 2025 11:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZsXKvAbL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F5253F1B
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 11:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747134087; cv=none; b=I4kdIdWFJchZgTdLSfkIYRiquALjeKxPyKcQR+/nUAMQsfaHVGUbabxCEUL9ynqNS9WBCod48ysMaO0Qk2JSQd1kqVIWWwXumS8zSVEzZVNnNd5/fD0rGQpz8YrP0MPmih8Ei3L0FdriykIERHxujcdZOt33TXrXge/6jMBfcJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747134087; c=relaxed/simple;
	bh=LyGtikM+Z/LwqKetaaf7fzBqSjJIV7gFNqYTAxmYYdc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=k7Simp/4HVoHcnheEn+JdxUgWDj6W8Z1UhLkc2gX+yE7UTdlS/Vf06Ks1i1HlYTd55r+778DACHHl9iYSpsoWgdhthxE+yvJHlIeA4ayPejr2m/crNavArfvCAAU9JAEKmHAYb22PEXlLcfan3k+r8qZ3GkuVllhR2ciCUEPPi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZsXKvAbL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747134084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TS2yL7ZCoRqSI1GlyDP1hf6SFl052EjkRDbZaOdY3kM=;
	b=ZsXKvAbLP1wvf6+Pm+ITBh8jSgO8zw0hGYNhiEyemdCkZ+4DVa2ZjK1uE7Aw/OdsyFBsWr
	kxhA5/vQRsZbBbvBLKDnWfPlpYFgDHe5Llp8YUUambkcw3VD4E2AdLceU5i+4eAsByvuYN
	cow77nyhwJ6FEOl2ilL0aJ4eOewY6xc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-x9G-84KkPWytHRhwPHMyKQ-1; Tue,
 13 May 2025 07:01:20 -0400
X-MC-Unique: x9G-84KkPWytHRhwPHMyKQ-1
X-Mimecast-MFC-AGG-ID: x9G-84KkPWytHRhwPHMyKQ_1747134076
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A636A1953976;
	Tue, 13 May 2025 11:01:15 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDAA830001A1;
	Tue, 13 May 2025 11:01:13 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1772A21E66E3; Tue, 13 May 2025 13:01:11 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: Mark Cave-Ayland <mark.caveayland@nutanix.com>,  Daniel P. =?utf-8?Q?B?=
 =?utf-8?Q?errang=C3=A9?=
 <berrange@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,  Thomas
 Huth <thuth@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,  Xiaoyao Li
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
In-Reply-To: <60cd3ba8-2ab1-74ac-54ea-5e3b309788a1@eik.bme.hu> (BALATON
	Zoltan's message of "Tue, 13 May 2025 11:26:31 +0200 (CEST)")
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-13-philmd@linaro.org>
	<23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
	<aB2vjuT07EuO6JSQ@intel.com>
	<2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
	<CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
	<aCG6MuDLrQpoTqpg@redhat.com> <87jz6mqeu5.fsf@pond.sub.org>
	<eedd1fa2-5856-41b8-8e6b-38bd5c98ce8f@nutanix.com>
	<87ecwshqj4.fsf@pond.sub.org>
	<60cd3ba8-2ab1-74ac-54ea-5e3b309788a1@eik.bme.hu>
Date: Tue, 13 May 2025 13:01:11 +0200
Message-ID: <87v7q4epvs.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

BALATON Zoltan <balaton@eik.bme.hu> writes:

> On Tue, 13 May 2025, Markus Armbruster wrote:
>> Mark Cave-Ayland <mark.caveayland@nutanix.com> writes:
>>> On a related note this also brings us back to the discussion as to the relationship between qdev and QOM: at one point I was under the impression that qdev properties were simply QOM properties that were exposed externally, i.e on the commmand line for use with -device.
>>>
>>> Can you provide an update on what the current thinking is in this area, in particular re: scoping of qdev vs QOM properties?
>>
>> qdev is a leaky layer above QOM.
>>
>> qdev properties are also QOM properties.
>>
>> All device properties are exposed externally.
>
> That was clear but the question was if QOM properties (that are not qdev properties) exist and if so are they also exposed? If not exposed it may be used for internal properties (where simpler solutions aren't convenient) but maybe qdev also adds easier definition of properties that's why they used instead of QOM properties?
>
>> We use device properties for:
>>
>> * Letting users configure pluggable devices, with -device or device_add
>>
>> * Letting code configure onboard devices
>>
>>  For onboard devices that are also pluggable, everything exposed to
>>  code is also exposed externally.  This might be a mistake in places.
>
> If a device is pluggable, theoretically a user could create a machine from them declaratively, e.g. starting from a "none" machine or like plugging cards in a motherboard so their properties should be exposed as long as those properties correspond to the device pins they model or configurable options. Only properties that are implementation details should not be exposed because setting them can break the device. There are a few places where we have such properties. But you say "in places" so I think you meant the same.

Building machines declaratively has been the dream for many years.

I chose to write "might be in places", because I can't point to examples
offhand to support a stronger claim :)

External interfaces should be intentional, i.e. carefully curated to
serve actual use cases.  They should also be stable and documented.

The QOM parts of our external interfaces are largely accidental,
unstable, and undocumented.  We have some internal need, we create
something to serve it, and expose it externally simply because we lack
the means not to.

>> * Letting the machine versioning machinery adjust device configuration
>>
>>  Some properties are meant to be used just for this.  They're exposed
>>  externally regardless, which is a mistake.
>
> Question is if we want to allow users to tweak these compatibility options, like selectively enable/disable when migrating between QEMU versions or for testing. It might have some uses and maybe that's the reason why people would like these to go through deprecation instead of just dropping them. Marking some properties not exposed would get the same resistance then so may not solve the issue.

If you need to mess with properties to make migration work, that's a
bug.  That's versioning machinery's job.

External interfaces just for testing can be okay.  We should not promise
stability there.  We should still be intentional, and we should still
document.

Attempts to get rid of external interfaces always draw resistance, even
when they're accidental.


