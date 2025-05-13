Return-Path: <kvm+bounces-46313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28510AB4FB2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B34E0165AFA
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75C7226183;
	Tue, 13 May 2025 09:26:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA12253E1
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747128399; cv=none; b=nh3lWzkuHgW8W5ywwCotaMSz+W+J9dORx1qqNU2jyXnqeUcb7PS28DD+/QFygYGMVhv42xnU2Ci2qeEs+smJzwWePphZcYuAdX486zbE1VhazzlCgwBFPSPcEEbeeCoHpfOi2HD2jEr+OdByBjGcnsO0Oe3BcYFn1NTn2cClltY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747128399; c=relaxed/simple;
	bh=7IJy1STBafUPGlHYbDQIwbLaOYJ5YYRzZKCauwXGXfY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=e2b/c3MAkd+KR/BEolW4z+EskdgXUd5NR1gSdoMDWWtKBiXEBYV0qqnDW8GVHudgBpeHRwdUyp0Ho6kG3NlvIjXrdcsmWUc70fv03zVfSiIXlK7mJXYkLcIjInYxccP8eWHf7vz72M9tBXBobyAokxnxyeIYHO12M06xSsUmyN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id BAE3C55CA5C;
	Tue, 13 May 2025 11:26:33 +0200 (CEST)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id yB4rYU66MMtP; Tue, 13 May 2025 11:26:31 +0200 (CEST)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id B632C55CA5D; Tue, 13 May 2025 11:26:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id B3669745683;
	Tue, 13 May 2025 11:26:31 +0200 (CEST)
Date: Tue, 13 May 2025 11:26:31 +0200 (CEST)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Markus Armbruster <armbru@redhat.com>
cc: Mark Cave-Ayland <mark.caveayland@nutanix.com>, 
    =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>, 
    Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>, 
    Zhao Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
    =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org, 
    Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org, 
    Gerd Hoffmann <kraxel@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
    Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, 
    Eduardo Habkost <eduardo@habkost.net>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
    Alistair Francis <alistair.francis@wdc.com>, 
    Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
    Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org, 
    Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, 
    Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>, 
    Igor Mammedov <imammedo@redhat.com>, Fabiano Rosas <farosas@suse.de>, 
    Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
    =?ISO-8859-15?Q?Cl=E9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>, 
    qemu-arm@nongnu.org, 
    =?ISO-8859-15?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>, 
    Huacai Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties
In-Reply-To: <87ecwshqj4.fsf@pond.sub.org>
Message-ID: <60cd3ba8-2ab1-74ac-54ea-5e3b309788a1@eik.bme.hu>
References: <20250508133550.81391-1-philmd@linaro.org> <20250508133550.81391-13-philmd@linaro.org> <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com> <aB2vjuT07EuO6JSQ@intel.com> <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
 <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com> <aCG6MuDLrQpoTqpg@redhat.com> <87jz6mqeu5.fsf@pond.sub.org> <eedd1fa2-5856-41b8-8e6b-38bd5c98ce8f@nutanix.com> <87ecwshqj4.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 13 May 2025, Markus Armbruster wrote:
> Mark Cave-Ayland <mark.caveayland@nutanix.com> writes:
>> On a related note this also brings us back to the discussion as to the 
>> relationship between qdev and QOM: at one point I was under the 
>> impression that qdev properties were simply QOM properties that were 
>> exposed externally, i.e on the commmand line for use with -device.
>>
>> Can you provide an update on what the current thinking is in this area, 
>> in particular re: scoping of qdev vs QOM properties?
>
> qdev is a leaky layer above QOM.
>
> qdev properties are also QOM properties.
>
> All device properties are exposed externally.

That was clear but the question was if QOM properties (that are not qdev 
properties) exist and if so are they also exposed? If not exposed it may 
be used for internal properties (where simpler solutions aren't 
convenient) but maybe qdev also adds easier definition of properties 
that's why they used instead of QOM properties?

> We use device properties for:
>
> * Letting users configure pluggable devices, with -device or device_add
>
> * Letting code configure onboard devices
>
>  For onboard devices that are also pluggable, everything exposed to
>  code is also exposed externally.  This might be a mistake in places.

If a device is pluggable, theoretically a user could create a machine from 
them declaratively, e.g. starting from a "none" machine or like plugging 
cards in a motherboard so their properties should be exposed as long as 
those properties correspond to the device pins they model or configurable 
options. Only properties that are implementation details should not be 
exposed because setting them can break the device. There are a few places 
where we have such properties. But you say "in places" so I think you 
meant the same.

> * Letting the machine versioning machinery adjust device configuration
>
>  Some properties are meant to be used just for this.  They're exposed
>  externally regardless, which is a mistake.

Question is if we want to allow users to tweak these compatibility 
options, like selectively enable/disable when migrating between QEMU 
versions or for testing. It might have some uses and maybe that's the 
reason why people would like these to go through deprecation instead of 
just dropping them. Marking some properties not exposed would get the same 
resistance then so may not solve the issue.

Regards,
BALATON Zoltan

