Return-Path: <kvm+bounces-18737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 939288FADCD
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D3A52821EE
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E32142909;
	Tue,  4 Jun 2024 08:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvNUmhwX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0650C1420DA
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717490650; cv=none; b=AY4JAcM155NYJBMaooIuYWNh/TCln4ZfYAqn6xQuyBDabT8ccSlPV76gtxBvKxdxw8JmK8DkOJbzmjb/q5WqS1RXTx1DMf/fY+vcBabV2WBAXWU3+zaOdqALpX5KWWb1CTs0T5w9OBTb7cJy/dLVOGn8RTW32qiqb8U1ZmbTMus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717490650; c=relaxed/simple;
	bh=ciuxs6tgwYqx6EKc53dtFl53zVr5+RcDpI6OFGygLYg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TdANx6krxKxi0eiAYWR06QKIx3kNGyAxFzFjkea8oUZM8/zIfCCcE3COf/9xcCcwV2MBN8KXsUqMOSsrkD34evPfhmBfsYWY5iZ8JLu36SCH1E2KD91f/gkxM15JGAWQXxEkPtMFIjXb2GrfIDlBEifKwhBhViPcOCxl1hkaBWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvNUmhwX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717490648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zh7oc39RI723rzfabH7zb7UQwK5DnQcHFkmye0dvQB8=;
	b=CvNUmhwXQvM/qhHnzRPiX4l32Wr+rHPZFYb11UKHWN6aWZ1LWbFlm8FaQ1Edtkdc+Un1e9
	0LO0yUn+4EMO+oSc0uVCP9Qz6QzZXdeGh7odoPdippjgarY8nTtenT6eBElUtaWHh+xgBQ
	lqWkyHGZq/uq8IFx78TZyNxhWwIxeu4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-27-4NDhaJXWMhGamih_1BkHOg-1; Tue,
 04 Jun 2024 04:44:03 -0400
X-MC-Unique: 4NDhaJXWMhGamih_1BkHOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE1AB1C03D84;
	Tue,  4 Jun 2024 08:44:02 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.93])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CF982875;
	Tue,  4 Jun 2024 08:44:02 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 720C521E6687; Tue,  4 Jun 2024 10:44:01 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Daniel P . =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Eduardo
 Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S . Tsirkin" <mst@redhat.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Eric Blake <eblake@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
  Peter Maydell <peter.maydell@linaro.org>,  Jonathan Cameron
 <Jonathan.Cameron@huawei.com>,  Sia Jee Heng
 <jeeheng.sia@starfivetech.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  qemu-riscv@nongnu.org,  qemu-arm@nongnu.org,
  Zhenyu Wang <zhenyu.z.wang@intel.com>,  Dapeng Mi
 <dapeng1.mi@linux.intel.com>,  Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration arch-agnostic
In-Reply-To: <Zl7S0IOlLvnua319@intel.com> (Zhao Liu's message of "Tue, 4 Jun
	2024 16:39:44 +0800")
References: <20240530101539.768484-1-zhao1.liu@intel.com>
	<20240530101539.768484-2-zhao1.liu@intel.com>
	<87y17mfccp.fsf@pond.sub.org> <Zl7S0IOlLvnua319@intel.com>
Date: Tue, 04 Jun 2024 10:44:01 +0200
Message-ID: <878qzlayi6.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Zhao Liu <zhao1.liu@intel.com> writes:

[...]

>> > +##
>> > +# @CPUTopoLevel:
>> > +#
>> > +# An enumeration of CPU topology levels.
>> > +#
>> > +# @invalid: Invalid topology level, used as a placeholder.
>> 
>> Placeholder for what?
>
> I was trying to express that when no specific topology level is
> specified, it will be initialized to this value by default.
>
> Or what about just deleting this placeholder related words and just
> saying it's "Invalid topology level"?

Works for me.

[...]


