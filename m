Return-Path: <kvm+bounces-9304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2180C85D82E
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 13:47:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5CCB1F22075
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 12:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C6A69952;
	Wed, 21 Feb 2024 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UJhB0Lhb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D3C3C493
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708519590; cv=none; b=AaN6319ZExMTFZo5Jlpe1ObxLAXPuEGwV2Mzj9L7Vp0Mlz3pOps6imk8aH7pAt4/Emuvn7K9cq5xwWbWjj/6p/ubyRRlaLI2bgV0os0WHO+2P/bUGdpA2w9rbxRPrZJPwJf2pUJcnqmoGetdMkyXr9nQhlf32CIO3O9MTrhPJiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708519590; c=relaxed/simple;
	bh=1iexVoUtne0uwMm3X5g4isib1rGzoT+nsL4x7h2r14Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qaJ/8Nbzbzu2M+MplH9/xclvq4waNziRXLG6jMqQeGWoeP7R9EDGalXb+ClVNbR+XNHb75jRlEi1Gmml2PEAUOE585WBXJ3BcF2in28WQ1IdGu9u9SIpUcvvSmj64FmoqlNRsHdvUGI48Qogs+R6xPPvJl5OIfXk/MgKtnu7d6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UJhB0Lhb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708519587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5+iFDGsoywuH5+H7Hd1QIQz6/y36MS3F778kGZSKiq0=;
	b=UJhB0Lhbvnh1Rf8Q69AgMTQ1niH72olT1UwUVU0OERx0417bMhowcVHm6by1fZ/J1X3tDu
	YHWQyXSbIWotWCNbw242AKWd/UUp6JrZlxHKM96b2ZcSIj0gBkGxf1Qubyqg99KI3hIvMi
	kFwxkCcrgNxh1z+3a2ERB5slO+3C3oM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-guzpp1vhOniCWJKEZF_cKg-1; Wed, 21 Feb 2024 07:46:23 -0500
X-MC-Unique: guzpp1vhOniCWJKEZF_cKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3E28845E61;
	Wed, 21 Feb 2024 12:46:22 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7533210800;
	Wed, 21 Feb 2024 12:46:22 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 67A6421E6740; Wed, 21 Feb 2024 13:46:21 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
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
 <dapeng1.mi@linux.intel.com>,  Yongwei Ma <yongwei.ma@intel.com>,  Zhao
 Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
In-Reply-To: <20240220092504.726064-5-zhao1.liu@linux.intel.com> (Zhao Liu's
	message of "Tue, 20 Feb 2024 17:25:00 +0800")
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
	<20240220092504.726064-5-zhao1.liu@linux.intel.com>
Date: Wed, 21 Feb 2024 13:46:21 +0100
Message-ID: <871q9656jm.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Zhao Liu <zhao1.liu@linux.intel.com> writes:

> From: Zhao Liu <zhao1.liu@intel.com>
>
> Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
> -smp to define the cache topology for SMP system.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

[...]

> diff --git a/qapi/machine.json b/qapi/machine.json
> index d0e7f1f615f3..0a923ac38803 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -1650,6 +1650,14 @@
>  #
>  # @threads: number of threads per core
>  #
> +# @l1d-cache: topology hierarchy of L1 data cache (since 9.0)
> +#
> +# @l1i-cache: topology hierarchy of L1 instruction cache (since 9.0)
> +#
> +# @l2-cache: topology hierarchy of L2 unified cache (since 9.0)
> +#
> +# @l3-cache: topology hierarchy of L3 unified cache (since 9.0)
> +#

Too terse, just like my review ;-P

>  # Since: 6.1
>  ##
>  { 'struct': 'SMPConfiguration', 'data': {
> @@ -1662,7 +1670,11 @@
>       '*modules': 'int',
>       '*cores': 'int',
>       '*threads': 'int',
> -     '*maxcpus': 'int' } }
> +     '*maxcpus': 'int',
> +     '*l1d-cache': 'str',
> +     '*l1i-cache': 'str',
> +     '*l2-cache': 'str',
> +     '*l3-cache': 'str' } }
>  
>  ##
>  # @x-query-irq:

[...]


