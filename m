Return-Path: <kvm+bounces-47686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E4EAC3C2C
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 141F27A16DD
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 08:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C488D1E9B0B;
	Mon, 26 May 2025 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XAQvMSDH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F212AEFE
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748249914; cv=none; b=a1GQwW/6VfEMpnBU4JBdVg12R0ALUSCoKm5QtL+gH1HmulrL1FzTzCCtxutX7MsdZ3BVx3KlA0w+RgNx0j73IYamWXpppDrJlLzsmEisMpA3rJ3FOfsA2a2usrIRbRd72iet5uHlF3KL/C0WuXXbUmZ1ySKRfKKk6ygjbIFBclU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748249914; c=relaxed/simple;
	bh=aJXOIB3PXjfdQVTBSrdtBYKMKi5Eb/XdWBg0BVS4qug=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gHOWGK72//ItSxeu4k/iyt0N+pAF138VospTQsOr4rvLmmMG5WotrbILD8kXy1w4NcctHmDgFHMY7YhG8YLoRYPww5wY33MUWb8shN10aFWEYeyrl88TGWa4sbHb8KHdGfXkyQ/09NdgQV84XBTGOSeovZoH26stHcvuEhv7LYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XAQvMSDH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748249910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jzzd0Z2q7oavj1TygOVzuj6Z/b/VFUvuYV5UB2zwGk4=;
	b=XAQvMSDHXO8JgseeO9xPAV1I+hl5FXoOvKMX/zlp8KgxGm2HFmlGFYSIFveyQsT96jwMW9
	p9pMq+fYHj90/qaJb29B4rFmNM8n1Hrsopqbpriw2qYTJ9gBAMUCedBxDdx9yMqohW3w5l
	1qYjBDNKIBrGXmG1h//BpyXKOiskUAw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-gabRBkCUN3ihfu9bwQcvGg-1; Mon,
 26 May 2025 04:58:28 -0400
X-MC-Unique: gabRBkCUN3ihfu9bwQcvGg-1
X-Mimecast-MFC-AGG-ID: gabRBkCUN3ihfu9bwQcvGg_1748249905
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19EB81956095;
	Mon, 26 May 2025 08:58:24 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.2])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4244F1956095;
	Mon, 26 May 2025 08:58:22 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id CA91B21E66C3; Mon, 26 May 2025 10:58:19 +0200 (CEST)
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
Date: Mon, 26 May 2025 10:58:19 +0200
Message-ID: <874ix792ac.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

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

I'm afraid we haven't answered your question clearly, yet.  The answer
is yes, QOM properties that are not qdev properties do exist.  The first
one that comes along: ich9_pm_add_properties() adds a bunch to device
ICH9-LPC.  They are exposted externally.  To see them, try

    $ qemu-system-x86_64 -device ICH9-LPC,help

[...]


