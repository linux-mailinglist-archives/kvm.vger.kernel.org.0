Return-Path: <kvm+bounces-9942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2BD867AA7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 186C31C21676
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0556212BEBF;
	Mon, 26 Feb 2024 15:47:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DB012B159
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708962461; cv=none; b=FdWUKPfu61Bf36lJlX2sVBPMtyX+wnIEEUUaiEMmm/m65KBMJXIfX9E3ztLamFijs/1DZGe+Od2TIX6c+08URyyaid8Dz56zeMlWcsQADWxldWQJL+A+z3D+zJBsIcvU5hy8AvtDz3S0M32kL33poUy88Zm2azRu0nYOdOtMhI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708962461; c=relaxed/simple;
	bh=+XAnqyHPO44Sk+87TS4soUnmmFPeOnxtZV1T7yT68Mw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ry8rxBfHQ0TOrwZx8cW5/O3mktlyDfrmB1WaXMXC+4MCY5DolsXd4vJ6Kv33zASsSPCk7qB85NF+Uobk+iArn7hTSxgwRXHp+meNT5DoTap0oSekwJlsMfJWW9coY8dzNDvygrpuoTI1eFwSXo8NGqvuLd0bq9CNc+ynwGcVp94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tk4dK68jwz6JBV6;
	Mon, 26 Feb 2024 23:43:01 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id DF0BE140DAF;
	Mon, 26 Feb 2024 23:47:35 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 26 Feb
 2024 15:47:35 +0000
Date: Mon, 26 Feb 2024 15:47:34 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Eduardo
 Habkost" <eduardo@habkost.net>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?=
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S .
 Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, "Sia Jee Heng" <jeeheng.sia@starfivetech.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>,
	<qemu-arm@nongnu.org>, "Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu
	<zhao1.liu@intel.com>
Subject: Re: [RFC 8/8] qemu-options: Add the cache topology description of
 -smp
Message-ID: <20240226154734.00000d6e@Huawei.com>
In-Reply-To: <20240220092504.726064-9-zhao1.liu@linux.intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
	<20240220092504.726064-9-zhao1.liu@linux.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Tue, 20 Feb 2024 17:25:04 +0800
Zhao Liu <zhao1.liu@linux.intel.com> wrote:

> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Hi,

A trivial comment, but also a possibly more significant one about
whether the defaults are correctly verified.

Jonathan
> ---
>  qemu-options.hx | 54 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 47 insertions(+), 7 deletions(-)
> 
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 70eaf3256685..85c78c99a3b0 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -281,7 +281,9 @@ ERST
>  
>  DEF("smp", HAS_ARG, QEMU_OPTION_smp,
>      "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"
> -    "               [,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
> +    "               [,dies=dies][,clusters=clusters][,modules=modules][,cores=cores]\n"
> +    "               [,threads=threads][,l1d-cache=level][,l1i-cache=level][,l2-cache=level]\n"
burns more characters but I'd go with
l1d->cache=topo_level

As level for a cache has a totally different meaning!

> +    "               [,l3-cache=level]\n"
>      "                set the number of initial CPUs to 'n' [default=1]\n"
>      "                maxcpus= maximum number of total CPUs, including\n"
>      "                offline CPUs for hotplug, etc\n"
> @@ -290,9 +292,14 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
>      "                sockets= number of sockets in one book\n"
>      "                dies= number of dies in one socket\n"
>      "                clusters= number of clusters in one die\n"
> -    "                cores= number of cores in one cluster\n"
> +    "                modules= number of modules in one cluster\n"
> +    "                cores= number of cores in one module\n"
>      "                threads= number of threads in one core\n"
> -    "Note: Different machines may have different subsets of the CPU topology\n"
> +    "                l1d-cache= topology level of L1 D-cache\n"
> +    "                l1i-cache= topology level of L1 I-cache\n"
> +    "                l2-cache= topology level of L2 cache\n"
> +    "                l3-cache= topology level of L3 cache\n"
> +    "Note: Different machines may have different subsets of the CPU and cache topology\n"

>  
>          -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32
>  
> +    The following sub-option defines a CPU topology hierarchy (2 sockets
> +    totally on the machine, 2 dies per socket, 2 modules per die, 2 cores per
> +    module, 2 threads per core) with 3-level cache topology hierarchy (L1
> +    D-cache per core, L1 I-cache per core, L2 cache per core and L3 cache per
> +    die) for PC machines which support sockets/dies/modules/cores/threads.
> +    Some members of the CPU topology option can be omitted but their values
> +    will be automatically computed. Some members of the cache topology
> +    option can also be omitted and target CPU will use the default topology.:

Given the default could be inconsistent I wonder if we should 'push' levels
up.  So if L2 not defined it is set either to default of equal to max of
l1i and l1d level. L3 either default or same level as l2.

Won't always correspond to a sensible system so maybe just rejecting
cases where default isn't possible is the best plan.  However I don't
see that verification as the checks on higher levels are gated on them
being specified.

> +
> +    ::
> +
> +        -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
> +             l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die
> +
>      The following sub-option defines a CPU topology hierarchy (2 sockets
>      totally on the machine, 2 clusters per socket, 2 cores per cluster,
>      2 threads per core) for ARM virt machines which support sockets/clusters


