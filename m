Return-Path: <kvm+bounces-18740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BC18FAE21
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4CACB24C64
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1D9143733;
	Tue,  4 Jun 2024 08:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxUy5t5Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA3213D639
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 08:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717491300; cv=none; b=glRKZjduGhyoF4o1m3MlhMX+Zzb8TXvHG1ZxybxRY91WOhulAu+lwuF4C/p0uEMhMACoGEQoUVKaco2XS8XjphsR3at/BXBR8FVE95QJkPHTzKXbvda3JDKAyj4uroq6/oBC2hXj6WwJZKgT/sLZB1pNISMzKekLikEwcO9Nal8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717491300; c=relaxed/simple;
	bh=K9FuEuotZvF8UQJYKFigAzxgiAvPkHT8DdQiIPYv/Co=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gmPa2d2IAHvWN7eNy3zKNGH9/37SmVcrIPVJKpzOanPUtaD6GiYR7wujCZRkzBzcE1gq8ETNDspjcXcU+CihDAmrfWc3DSPDWRUScJlwiDM9yTusDNr1N4o/uMGs2GdavIkALrNv51WmYEccdUK3sExEck+iki427pDcgQSbA9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxUy5t5Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717491298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Kh6eB6FJO7y29jcT+D89kAQxKrmCwTX41ilLKqtUEQ=;
	b=bxUy5t5Q38aZqej26TWuU5Jo2sUkNrHHDNiD4SRsRv4a4EGMSsUqTN1JBx7lozNjplR+B0
	guw/jaJ4v5cXa9d3EZZNic5G7gEOpE9y4U8UXV8YT3ERMnskCMRAwWvDjDwrLYBjA5Uzni
	jT5HdX67wvaktA+bEr/dtsyETOJlo+4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-m6nBrRR1Plq-R6WoAWdtFA-1; Tue, 04 Jun 2024 04:54:54 -0400
X-MC-Unique: m6nBrRR1Plq-R6WoAWdtFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5831D8025EF;
	Tue,  4 Jun 2024 08:54:53 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.93])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5656E3C23;
	Tue,  4 Jun 2024 08:54:52 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 6349221E6757; Tue,  4 Jun 2024 10:54:51 +0200 (CEST)
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
Subject: Re: [RFC v2 3/7] hw/core: Add cache topology options in -smp
In-Reply-To: <20240530101539.768484-4-zhao1.liu@intel.com> (Zhao Liu's message
	of "Thu, 30 May 2024 18:15:35 +0800")
References: <20240530101539.768484-1-zhao1.liu@intel.com>
	<20240530101539.768484-4-zhao1.liu@intel.com>
Date: Tue, 04 Jun 2024 10:54:51 +0200
Message-ID: <87sext9jfo.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Zhao Liu <zhao1.liu@intel.com> writes:

> Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
> -smp to define the cache topology for SMP system.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

[...]

> diff --git a/qapi/machine.json b/qapi/machine.json
> index 7ac5a05bb9c9..8fa5af69b1bf 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -1746,6 +1746,23 @@
>  #
>  # @threads: number of threads per core
>  #
> +# @l1d-cache: topology hierarchy of L1 data cache. It accepts the CPU
> +#     topology enumeration as the parameter, i.e., CPUs in the same
> +#     topology container share the same L1 data cache. (since 9.1)
> +#
> +# @l1i-cache: topology hierarchy of L1 instruction cache. It accepts
> +#     the CPU topology enumeration as the parameter, i.e., CPUs in the
> +#     same topology container share the same L1 instruction cache.
> +#     (since 9.1)
> +#
> +# @l2-cache: topology hierarchy of L2 unified cache. It accepts the CPU
> +#     topology enumeration as the parameter, i.e., CPUs in the same
> +#     topology container share the same L2 unified cache. (since 9.1)
> +#
> +# @l3-cache: topology hierarchy of L3 unified cache. It accepts the CPU
> +#     topology enumeration as the parameter, i.e., CPUs in the same
> +#     topology container share the same L3 unified cache. (since 9.1)
> +#
>  # Since: 6.1
>  ##

The new members are all optional.  What does "absent" mean?  No such
cache?  Some default topology?

Is this sufficiently general?  Do all machines of interest have a split
level 1 cache, a level 2 cache, and a level 3 cache?

Is the CPU topology level the only cache property we'll want to
configure here?  If the answer isn't "yes", then we should perhaps wrap
it in an object, so we can easily add more members later.

Two spaces between sentences for consistency, please.

>  { 'struct': 'SMPConfiguration', 'data': {
> @@ -1758,7 +1775,11 @@
>       '*modules': 'int',
>       '*cores': 'int',
>       '*threads': 'int',
> -     '*maxcpus': 'int' } }
> +     '*maxcpus': 'int',
> +     '*l1d-cache': 'CPUTopoLevel',
> +     '*l1i-cache': 'CPUTopoLevel',
> +     '*l2-cache': 'CPUTopoLevel',
> +     '*l3-cache': 'CPUTopoLevel' } }
>  
>  ##
>  # @x-query-irq:
> diff --git a/system/vl.c b/system/vl.c

[...]


