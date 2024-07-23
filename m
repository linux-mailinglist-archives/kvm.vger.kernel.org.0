Return-Path: <kvm+bounces-22109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A02CC939EA3
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 12:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D18F51C21FFF
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 10:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DB214E2F6;
	Tue, 23 Jul 2024 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TO7hC5C5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3708414BF98
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 10:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721729686; cv=none; b=hrv/Absx0ueJYi45coOq7WUumK8Rs5bEfBK2l5VyEiCZrG77yRu1/cfS3JKVbQwfh8M9UpTOmKQT2GtjW1aZD3Rd4iIZcOcpGqDnzt4lbhJtQvLT4w6za3K16HlN+OGc1L5teGmDiqnOb4QqxlL28FtBUQJYHiSSJQ2/KzeF7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721729686; c=relaxed/simple;
	bh=4CJHgh5cgRECsoqMj/ejrEBGgptotzHikcSOu7Fp5OQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iPOmJWnC7KoeadqFIUzNby5mCntapiFQ2hRbpNWj2kkQba7n70eMGQ8iWCIs19Kb8jJM95m3wUpJhLRccY5CSkJEfR2vzrEgOfhpKzA8S//E9hr6NtcBw8n28fDgyesVMhdosa3+4pMcp75sTZl3BLLIWz9rLAuP/lcOIwrI97c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TO7hC5C5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721729683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u1Ky8nShwUmqI5mAf40wP6UVa7xKKOXsCs1JoLQsga0=;
	b=TO7hC5C5ncFVNYoGPIX7JaEg7J+QAVbNseTF9RynxlBrbswD8JcPBAUvbWctnG7n0IN/o0
	Ys3v0xWypIW/NLE5Ag5so5epfrbP48YAL07IPJEguH9AaMT/8CLOV2GgL8pcxNhW6pjTgg
	cRkExxJuOPWE1AWTKlZJTXiXuuZqQmY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-oacb-EhlMuG1IpFQzC6EFg-1; Tue,
 23 Jul 2024 06:14:37 -0400
X-MC-Unique: oacb-EhlMuG1IpFQzC6EFg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BD0D1955F43;
	Tue, 23 Jul 2024 10:14:34 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B272D3000192;
	Tue, 23 Jul 2024 10:14:32 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9E80221E6682; Tue, 23 Jul 2024 12:14:30 +0200 (CEST)
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
Subject: Re: [PATCH 1/8] hw/core: Make CPU topology enumeration arch-agnostic
In-Reply-To: <Zp5mRrjuZWnE+9gz@intel.com> (Zhao Liu's message of "Mon, 22 Jul
	2024 22:01:42 +0800")
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
	<20240704031603.1744546-2-zhao1.liu@intel.com>
	<875xsx4l13.fsf@pond.sub.org> <Zp5mRrjuZWnE+9gz@intel.com>
Date: Tue, 23 Jul 2024 12:14:30 +0200
Message-ID: <87ed7kwh2x.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Zhao Liu <zhao1.liu@intel.com> writes:

> Hi Markus,
>
> On Mon, Jul 22, 2024 at 03:24:24PM +0200, Markus Armbruster wrote:
>> Date: Mon, 22 Jul 2024 15:24:24 +0200
>> From: Markus Armbruster <armbru@redhat.com>
>> Subject: Re: [PATCH 1/8] hw/core: Make CPU topology enumeration
>>  arch-agnostic
>> 
>> One little thing...
>> 
>> Zhao Liu <zhao1.liu@intel.com> writes:
>> 
>> > Cache topology needs to be defined based on CPU topology levels. Thus,
>> > define CPU topology enumeration in qapi/machine.json to make it generic
>> > for all architectures.
>> >
>> > To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
>> > and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
>> > CPU_TOPO_LEVEL_SOCKET.
>> >
>> > Also, enumerate additional topology levels for non-i386 arches, and add
>> > a CPU_TOPO_LEVEL_DEFAULT to help future smp-cache object de-compatibilize
>> > arch-specific cache topology settings.
>> >
>> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
>> 
>> [...]
>> 
>> > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
>> > index fa6bd71d1280..82413c668bdb 100644
>> > --- a/qapi/machine-common.json
>> > +++ b/qapi/machine-common.json
>> > @@ -5,7 +5,7 @@
>> >  # See the COPYING file in the top-level directory.
>> >  
>> >  ##
>> > -# = Machines S390 data types
>> > +# = Common machine types
>> >  ##
>> >  
>> >  ##
>> > @@ -19,3 +19,48 @@
>> >  { 'enum': 'CpuS390Entitlement',
>> >    'prefix': 'S390_CPU_ENTITLEMENT',
>> >    'data': [ 'auto', 'low', 'medium', 'high' ] }
>> > +
>> > +##
>> > +# @CpuTopologyLevel:
>> > +#
>> > +# An enumeration of CPU topology levels.
>> > +#
>> > +# @invalid: Invalid topology level.
>> > +#
>> > +# @thread: thread level, which would also be called SMT level or
>> > +#     logical processor level.  The @threads option in
>> > +#     SMPConfiguration is used to configure the topology of this
>> > +#     level.
>> > +#
>> > +# @core: core level.  The @cores option in SMPConfiguration is used
>> > +#     to configure the topology of this level.
>> > +#
>> > +# @module: module level.  The @modules option in SMPConfiguration is
>> > +#     used to configure the topology of this level.
>> > +#
>> > +# @cluster: cluster level.  The @clusters option in SMPConfiguration
>> > +#     is used to configure the topology of this level.
>> > +#
>> > +# @die: die level.  The @dies option in SMPConfiguration is used to
>> > +#     configure the topology of this level.
>> > +#
>> > +# @socket: socket level, which would also be called package level.
>> > +#     The @sockets option in SMPConfiguration is used to configure
>> > +#     the topology of this level.
>> > +#
>> > +# @book: book level.  The @books option in SMPConfiguration is used
>> > +#     to configure the topology of this level.
>> > +#
>> > +# @drawer: drawer level.  The @drawers option in SMPConfiguration is
>> > +#     used to configure the topology of this level.
>> > +#
>> > +# @default: default level.  Some architectures will have default
>> > +#     topology settings (e.g., cache topology), and this special
>> > +#     level means following the architecture-specific settings.
>> > +#
>> > +# Since: 9.1
>> > +##
>> > +{ 'enum': 'CpuTopologyLevel',
>> > +  'prefix': 'CPU_TOPO_LEVEL',
>> 
>> Why set a 'prefix'?
>> 
>
> Because my previous i386 commit 6ddeb0ec8c29 ("i386/cpu: Introduce bitmap
> to cache available CPU topology levels") introduced the level
> enumeration with such prefix. For naming consistency, and to shorten the
> length of the name, I've used the same prefix here as well.
>
> I've sensed that you don't like the TOPO abbreviation and I'll remove the
> prefix :-).

Consistency is good, but I'd rather achieve it by consistently using
"topology".

I never liked the 'prefix' feature much.  We have it because the mapping
from camel case to upper case with underscores is heuristical, and can
result in something undesirable.  See commit 351d36e454c (qapi: allow
override of default enum prefix naming).  Using it just to shorten
generated identifiers is a bad idea.


