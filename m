Return-Path: <kvm+bounces-18646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9F78D8232
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C1B6284588
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310F812BF3A;
	Mon,  3 Jun 2024 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajMUk+kZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F0F12BF1C
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417546; cv=none; b=oA1dyYTDZBLE/1SBgXM0WmTAujpLhaYFeEvv4IgFRllNhk4udxpW12GKXCjIrBNadgMFDrR5shKwGjyK8uWJYoTIwQScDdsfOtoRzaTRGBYolgYL5SasnqiXms9fHpSJ1GbTRZU1VSTeE6hobSkF292F/5mA4E4p6amV8pDWRDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417546; c=relaxed/simple;
	bh=3/YA9IJDao+5PAJYiTyJtRoCNZhz4nw/tVLRev+dLws=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qji/nojqBasn67tL1cZRMuh8xpQwtZo3pKKEb1to3Zab0BmSOuIdaIIR/rB+Ro88wZxF8SHt4ykzotuZXKnWKY7pGoRYR+CI2uUXqxDIxNfqk2i6NOTXDb1j7iJDM4Ge/hyXt4TIarFdu8qZSoQwLbbOKrMB9AOLEV7MosLz+dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ajMUk+kZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717417543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Efb5Ek9FsC2ECwoOU3U6omc2wMgF8Ch8l1dKcamqGD4=;
	b=ajMUk+kZEJJwabOWmTajF64rPpaT4EKeqtURD6/ZL834Bey/ncML8koXncU25gWottjKQ9
	6BjYIZjv4wnUwsYgzFTRoIkla95x2g+eiyKxWe6ykNNcr0MzGOyRKqEDb8DsDSiuLLYG4z
	rUZGzWclRnzYuh6yCgB1efMNTXXcWlU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-9n3jOQJNMxmz9d8CAE3qzw-1; Mon, 03 Jun 2024 08:25:38 -0400
X-MC-Unique: 9n3jOQJNMxmz9d8CAE3qzw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64875101A54F;
	Mon,  3 Jun 2024 12:25:37 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.93])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18AFD40147E;
	Mon,  3 Jun 2024 12:25:37 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 3F38D21E66E5; Mon,  3 Jun 2024 14:25:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Daniel P . =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Eduardo
 Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S . Tsirkin" <mst@redhat.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Eric Blake <eblake@redhat.com>,  Markus
 Armbruster <armbru@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,  Peter Maydell
 <peter.maydell@linaro.org>,  Jonathan Cameron
 <Jonathan.Cameron@huawei.com>,  Sia Jee Heng
 <jeeheng.sia@starfivetech.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  qemu-riscv@nongnu.org,  qemu-arm@nongnu.org,
  Zhenyu Wang <zhenyu.z.wang@intel.com>,  Dapeng Mi
 <dapeng1.mi@linux.intel.com>,  Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration arch-agnostic
In-Reply-To: <20240530101539.768484-2-zhao1.liu@intel.com> (Zhao Liu's message
	of "Thu, 30 May 2024 18:15:33 +0800")
References: <20240530101539.768484-1-zhao1.liu@intel.com>
	<20240530101539.768484-2-zhao1.liu@intel.com>
Date: Mon, 03 Jun 2024 14:25:36 +0200
Message-ID: <87plsyfc1r.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

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
> helpers for topology enumeration and string conversion.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

[...]

> diff --git a/qapi/machine.json b/qapi/machine.json
> index bce6e1bbc412..7ac5a05bb9c9 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -1667,6 +1667,46 @@
>       '*reboot-timeout': 'int',
>       '*strict': 'bool' } }
>  
> +##
> +# @CPUTopoLevel:

I understand you're moving existing enum CPUTopoLevel into the QAPI
schema.  I think the idiomatic QAPI name would be CpuTopologyLevel.
Would you be willing to rename it, or would that be too much churn?

> +#
> +# An enumeration of CPU topology levels.
> +#
> +# @invalid: Invalid topology level, used as a placeholder.
> +#
> +# @thread: thread level, which would also be called SMT level or logical
> +#     processor level. The @threads option in -smp is used to configure
> +#     the topology of this level.
> +#
> +# @core: core level. The @cores option in -smp is used to configure the
> +#     topology of this level.
> +#
> +# @module: module level. The @modules option in -smp is used to
> +#     configure the topology of this level.
> +#
> +# @cluster: cluster level. The @clusters option in -smp is used to
> +#     configure the topology of this level.
> +#
> +# @die: die level. The @dies option in -smp is used to configure the
> +#     topology of this level.
> +#
> +# @socket: socket level, which would also be called package level. The
> +#     @sockets option in -smp is used to configure the topology of this
> +#     level.
> +#
> +# @book: book level. The @books option in -smp is used to configure the
> +#     topology of this level.
> +#
> +# @drawer: drawer level. The @drawers option in -smp is used to
> +#     configure the topology of this level.

docs/devel/qapi-code-gen.rst section Documentation markup:

    For legibility, wrap text paragraphs so every line is at most 70
    characters long.

    Separate sentences with two spaces.

> +#
> +# Since: 9.1
> +##
> +{ 'enum': 'CPUTopoLevel',
> +  'prefix': 'CPU_TOPO_LEVEL',
> +  'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
> +            'die', 'socket', 'book', 'drawer' ] }
> +
>  ##
>  # @SMPConfiguration:
>  #

[...]


