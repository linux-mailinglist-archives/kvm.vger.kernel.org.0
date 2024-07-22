Return-Path: <kvm+bounces-22050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 758FD938FDF
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 15:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3F131F21BB1
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 13:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C71916D9A2;
	Mon, 22 Jul 2024 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AGjXw1wa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D3016A38B
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 13:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721654756; cv=none; b=S96cubJdODWI6Hf1HyENVoFAYbBHgGacPZQm1BBFPzB8MCQI3o6PQhUoHzqgBstvHMs8VF7gwjfw+U6jptZLTCm+P+GK3fMFQ0hveMfkTfpUqczRTJ0IvKLHNub0i8hZcQsgRyyB7gECsMCDIMeC9F5hZrG1xYO8g4bdfi6x0P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721654756; c=relaxed/simple;
	bh=MDgnBCGSXvqQCekepCnWYZHIZK0g+iutHCWq9zRaNBI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lzQaZR/8RuQRxIjj6xAjR57r6pl6tFuNDzqqux/Eqq/UidFXZ6jz74ZhfQQ+1mL5mlogFQjEKpvQBa8qZIOQQWWSxPs/sJ4LXyue3Jow6Spf07b70/9PAJm2T5+hMBYBfGRaOorBz5Hv3Ss3ZhgGW6YNsK0JRpuFtzUrcMmAeCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AGjXw1wa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721654753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=04tgYp28H6fbQsDrXzcIGR3NEN71W7VaA3H2XpdKMHI=;
	b=AGjXw1wad1Bgbr0Qoxb0QrlKLWEGW2HLieW7uZz6o2jWdEvwF7p4tjUAh5hQIkF1mCOUY+
	0BAalxOzs/8oacyqOLnXIChHpU+/sMXmz/w2/je5bl9QDmvTxuZjhjuuI78S/2pHCR3d4W
	afxGXSvjugsvZ50axIfXAc27CuXM8LE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-t16BuqhTMX6bzZ0XjL_oaw-1; Mon,
 22 Jul 2024 09:25:47 -0400
X-MC-Unique: t16BuqhTMX6bzZ0XjL_oaw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2CE71978CF2;
	Mon, 22 Jul 2024 13:25:22 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 649091932AA9;
	Mon, 22 Jul 2024 13:24:28 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 60CC721E669B; Mon, 22 Jul 2024 15:24:24 +0200 (CEST)
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
In-Reply-To: <20240704031603.1744546-2-zhao1.liu@intel.com> (Zhao Liu's
	message of "Thu, 4 Jul 2024 11:15:56 +0800")
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
	<20240704031603.1744546-2-zhao1.liu@intel.com>
Date: Mon, 22 Jul 2024 15:24:24 +0200
Message-ID: <875xsx4l13.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

One little thing...

Zhao Liu <zhao1.liu@intel.com> writes:

> Cache topology needs to be defined based on CPU topology levels. Thus,
> define CPU topology enumeration in qapi/machine.json to make it generic
> for all architectures.
>
> To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
> and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
> CPU_TOPO_LEVEL_SOCKET.
>
> Also, enumerate additional topology levels for non-i386 arches, and add
> a CPU_TOPO_LEVEL_DEFAULT to help future smp-cache object de-compatibilize
> arch-specific cache topology settings.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

[...]

> diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> index fa6bd71d1280..82413c668bdb 100644
> --- a/qapi/machine-common.json
> +++ b/qapi/machine-common.json
> @@ -5,7 +5,7 @@
>  # See the COPYING file in the top-level directory.
>  
>  ##
> -# = Machines S390 data types
> +# = Common machine types
>  ##
>  
>  ##
> @@ -19,3 +19,48 @@
>  { 'enum': 'CpuS390Entitlement',
>    'prefix': 'S390_CPU_ENTITLEMENT',
>    'data': [ 'auto', 'low', 'medium', 'high' ] }
> +
> +##
> +# @CpuTopologyLevel:
> +#
> +# An enumeration of CPU topology levels.
> +#
> +# @invalid: Invalid topology level.
> +#
> +# @thread: thread level, which would also be called SMT level or
> +#     logical processor level.  The @threads option in
> +#     SMPConfiguration is used to configure the topology of this
> +#     level.
> +#
> +# @core: core level.  The @cores option in SMPConfiguration is used
> +#     to configure the topology of this level.
> +#
> +# @module: module level.  The @modules option in SMPConfiguration is
> +#     used to configure the topology of this level.
> +#
> +# @cluster: cluster level.  The @clusters option in SMPConfiguration
> +#     is used to configure the topology of this level.
> +#
> +# @die: die level.  The @dies option in SMPConfiguration is used to
> +#     configure the topology of this level.
> +#
> +# @socket: socket level, which would also be called package level.
> +#     The @sockets option in SMPConfiguration is used to configure
> +#     the topology of this level.
> +#
> +# @book: book level.  The @books option in SMPConfiguration is used
> +#     to configure the topology of this level.
> +#
> +# @drawer: drawer level.  The @drawers option in SMPConfiguration is
> +#     used to configure the topology of this level.
> +#
> +# @default: default level.  Some architectures will have default
> +#     topology settings (e.g., cache topology), and this special
> +#     level means following the architecture-specific settings.
> +#
> +# Since: 9.1
> +##
> +{ 'enum': 'CpuTopologyLevel',
> +  'prefix': 'CPU_TOPO_LEVEL',

Why set a 'prefix'?

> +  'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
> +            'die', 'socket', 'book', 'drawer', 'default' ] }

[...]


