Return-Path: <kvm+bounces-28125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF4B199457D
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 12:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F6BC1F21E6E
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C5417D366;
	Tue,  8 Oct 2024 10:30:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EBC179953
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 10:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728383445; cv=none; b=Hyq0w/Doc8WXMKQd0fk6elTieujK7IIvfCi5L3hLBs/A4gTe79V8/tyGOraIX3ZQQgW7omSfyBMjmPf4CFBHZ6+C5YI2WsouR2JGBp2uLDgAx4rcBBvWLn9QaBy3XiHQwqT0kVfRIZKw4F7a/l4d7Yax+gZB3uxAosV3sGQbqT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728383445; c=relaxed/simple;
	bh=zrtPbLQaSil9fjg/THgjKh3gCY9RQjJztw1pnryS1MY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+rmIRTgQbitj3oqvdf1EqcWamvlssJaL5NH9/QYJ12SNqudwXuD1htj4U3BUAJNTug5FHu7dXvVjnFOnrzmI4hq/FSs9NfFjUAwJMF+W3zkuDENEvU7Zd0cvYbdkCmDZfJnTFnQpQleizUBeW0aqtcd6p2Jm0ipz2OvlLIy+Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XNBy71NNgz6GFS5;
	Tue,  8 Oct 2024 18:26:23 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D6A581402C6;
	Tue,  8 Oct 2024 18:30:40 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 8 Oct
 2024 12:30:39 +0200
Date: Tue, 8 Oct 2024 11:30:38 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, "Anthony
 PERARD" <anthony@xenproject.org>, Paul Durrant <paul@xen.org>, "Edgar E .
 Iglesias" <edgar.iglesias@gmail.com>, Eric Blake <eblake@redhat.com>, Markus
 Armbruster <armbru@redhat.com>, Alex =?ISO-8859-1?Q?Benn=E9e?=
	<alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 00/12] Introduce Hybrid CPU Topology via Custom
 Topology Tree
Message-ID: <20241008113038.00007ee4@Huawei.com>
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 19 Sep 2024 14:11:16 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:


> -smp maxsockets=1,maxdies=1,maxmodules=2,maxcores=2,maxthreads=2
> -machine pc,custom-topo=on \
> -device cpu-socket,id=sock0 \
> -device cpu-die,id=die0,bus=sock0 \
> -device cpu-module,id=mod0,bus=die0 \
> -device cpu-module,id=mod1,bus=die0 \
> -device x86-intel-core,id=core0,bus=mod0 \
> -device x86-intel-atom,id=core1,bus=mod1 \
> -device x86-intel-atom,id=core2,bus=mod1 \
> -device host-x86_64-cpu,id=cpu0,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=0 \
> -device host-x86_64-cpu,id=cpu1,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=1 \
> -device host-x86_64-cpu,id=cpu2,socket-id=0,die-id=0,module-id=1,core-id=0,thread-id=0 \
> -device host-x86_64-cpu,id=cpu3,socket-id=0,die-id=0,module-id=1,core-id=1,thread-id=0

I quite like this as a way of doing the configuration but that needs
some review from others.

Peter, Alex, do you think this scheme is flexible enough to ultimately
allow us to support this for arm? 

> 
> This does not accommodate hybrid topologies. Therefore, we introduce
> max* parameters: maxthreads/maxcores/maxmodules/maxdies/maxsockets
> (for x86), to predefine the topology framework for the machine. These
> parameters also constrain subsequent custom topologies, ensuring the
> number of child devices under each parent device does not exceed the
> specified max limits.

To my thinking this seems like a good solution even though it's a
bunch more smp parameters.

What does this actually mean for hotplug of CPUs?  What cases work
with this setup?
 
> Therefore, once user wants to customize topology by "-machine
> custom-topo=on", the machine, that supports custom topology, will skip
> the default topology creation as well as the default CPU creation.

Seems sensible to me.

Jonathan

