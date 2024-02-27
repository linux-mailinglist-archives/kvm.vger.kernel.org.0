Return-Path: <kvm+bounces-10072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE11868E09
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:52:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3A981C24051
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8455B1386C2;
	Tue, 27 Feb 2024 10:51:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE45D1386BB
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709031113; cv=none; b=U5eOx35pmC+RcTTzd1AQRAVafz2muX/TCQZTs16QNWR4Iy5jE0fgoNkCSUqsSYwKuwXAanmBYzlnLQNUNJjZrNjtjg7FiM9/g1/+5pO4/93AuoDBWRkUJBkmu8d+kQ5rqZxKiSEUs0Yq32OFxeLWQBqCiIgzuE3A2r5reMgX8ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709031113; c=relaxed/simple;
	bh=Ct6AcGCokeemhLzltgGuy5Zfcl/2NZFRgBKiJPaJA78=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8l1P6tvIfKRuDDiPRei3PqDDtbEKFIVpQLmFgJPDVpvEN+FoTUF1rWDg7H3RkZvU6CePD9AD0BCvS037XxWINULgs9Khtzb2Jmiqilm705WDcxXU5V002dWJtt3EcMUreJ3ktYS47glcsrZ4ocs7offaWeOyhc7KCYwfvX0idI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TkZ1V5Kwjz6J9xv;
	Tue, 27 Feb 2024 18:47:10 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 0695A140F4E;
	Tue, 27 Feb 2024 18:51:47 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 27 Feb
 2024 10:51:46 +0000
Date: Tue, 27 Feb 2024 10:51:45 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
CC: "Daniel P . =?UTF-8?Q?Berrang=EF=BF=BD?=" <berrange@redhat.com>, "Eduardo
 Habkost" <eduardo@habkost.net>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Philippe =?UTF-8?Q?Mathieu-Daud=EF=BF=BD?=
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S .
 Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?UTF-8?Q?Benn=EF=BF=BDe?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, "Sia Jee Heng" <jeeheng.sia@starfivetech.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>,
	<qemu-arm@nongnu.org>, "Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu
	<zhao1.liu@intel.com>
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
Message-ID: <20240227105145.0000106d@Huawei.com>
In-Reply-To: <Zd2pWVH4/eo3HM8j@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
	<20240220092504.726064-5-zhao1.liu@linux.intel.com>
	<20240226153947.00006fd6@Huawei.com>
	<Zd2pWVH4/eo3HM8j@intel.com>
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
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Tue, 27 Feb 2024 17:20:25 +0800
Zhao Liu <zhao1.liu@linux.intel.com> wrote:

> Hi Jonathan,
> 
> > Hi Zhao Liu
> > 
> > I like the scheme.  Strikes a good balance between complexity of description
> > and systems that actually exist. Sure there are systems with more cache
> > levels etc but they are rare and support can be easily added later
> > if people want to model them.  
> 
> Thanks for your support!
> 
> [snip]
> 
> > > +static int smp_cache_string_to_topology(MachineState *ms,  
> > 
> > Not a good name for a function that does rather more than that.  
> 
> What about "smp_cache_get_valid_topology()"?

Looking again, could we return the CPUTopoLevel? I think returning
CPU_TOPO_LEVEL_INVALID will replace -1/0 returns and this can just
be smp_cache_string_to_topology() as you have it in this version.

The check on the return value becomes a little more more complex
and I think you want to squash CPU_TOPO_LEVEL_MAX down so we only
have one invalid value to check at callers..  E.g.

static CPUTopoLevel smp_cache_string_to_topolgy(MachineState *ms,
                                                char *top_str,
                                                Error **errp)
{
    CPUTopoLevel topo = string_to_cpu_topo(topo_str);

    if (topo == CPU_TOPO_LEVEL_MAX || topo == CPU_TOP?O_LEVEL_INVALID) {
        return CPU_TOPO_LEVEL_INVALID;
    }

    if (!machine_check_topo_support(ms, topo) {
        error_setg(errp,
                   "Invalid cache topology level: %s. "
                   "The cache topology should match the CPU topology level",
//Break string like this to make it as grep-able as possible!
                   topo_str);
        return CPU_TOPO_LEVEL_INVALID;
    }

    return topo;

}                


The checks then become != CPU_TOPO_LEVEL_INVALID at each callsite.

Jonathan



