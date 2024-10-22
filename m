Return-Path: <kvm+bounces-29417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 714139AB125
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 16:45:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8278B23CB1
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767DB1A0BE0;
	Tue, 22 Oct 2024 14:44:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5311A01AB
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608283; cv=none; b=DJm6bnDsxEeKdkKCf0axIdwFU/CBDD92Lvc4e4tCQcY1LH+ORBYzydZfybsDTwOxGsLlgKB2DhoTVz64fD2+vG3wFESB9L07WijmQ5uCkd9AEGGoIz6NpgH/42A4eysMkJxViMUmur6zTTuhPIxyLSeZBYqvA1/p/WD/QQ61kDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608283; c=relaxed/simple;
	bh=fmcSPGwUxCXR3lWs/7xq45VVwxCtjYhUI+2xpjqzwUo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etOv6BqivvSkzQ7OZ6o5Pj05d6kmvhh12HspuGaR+LI/49ct0ueFHkUKuSUaqZm63x59Xl/koeVjyPpb+aVxuYqCMw6qmDEcR+A6YUMt/MQkI3n8Jk134GDWhWNhrL+Hse0FJUilHjcgFBeS1Zjj0MPt1FVMSosFFoRqgycOpbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XXw0b2ftvz6JBBn;
	Tue, 22 Oct 2024 22:43:43 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BD65B1400DB;
	Tue, 22 Oct 2024 22:44:38 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 22 Oct
 2024 16:44:37 +0200
Date: Tue, 22 Oct 2024 15:44:36 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S.Tsirkin " <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Alex
 =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v4 5/9] hw/core: Add a helper to check the cache
 topology level
Message-ID: <20241022154436.000028af@Huawei.com>
In-Reply-To: <20241022135151.2052198-6-zhao1.liu@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
 <20241022135151.2052198-6-zhao1.liu@intel.com>
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
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)

Resend. Claws-mail is still chewing up the to list for unknown reasons
and I forgot to fix it by hand.

On Tue, 22 Oct 2024 21:51:47 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Currently, we have no way to expose the arch-specific default cache
> model because the cache model is sometimes related to the CPU model
> (e.g., i386).
> 
> Since the user might configure "default" level, any comparison with
> "default" is meaningless before the machine knows the specific level
> that "default" refers to.
> 
> We can only check the correctness of the cache topology after the arch
> loads the user-configured cache model from MachineState.smp_cache and
> consumes the special "default" level by replacing it with the specific
> level.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Looks like useful sanity check code to me.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>




