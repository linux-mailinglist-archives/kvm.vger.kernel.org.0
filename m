Return-Path: <kvm+bounces-28123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 088B69944DA
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 11:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95C80285251
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 09:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA2318C916;
	Tue,  8 Oct 2024 09:55:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E6B15B12F
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728381352; cv=none; b=Ym77NhliNsuXIb+cUJ5TZbCMuoeZf5tctGrFl6ginV7hGX3sEy97ivVMyEA0mfTF4NucNRweZYPxPaZWfwuJAaYHQHhulQQfZ0YH0XmBlxUsDfyKgY7Tt6VIjLD5h/9bqF/FUu9YP7D2ZfuPPrAiAeW9XZkLbF3cEkXOmyjkamw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728381352; c=relaxed/simple;
	bh=O8Q36Xo+cPNBvFOgNwgf6fmRriELBLPSfj8FF/IB0Lo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9fu8Woa9nDgUfiZNxGn4VN+/vdOVFB4i5i5GO+FAK56c3CMqicUlX0dw2e6WbjfUNkvuB9BHbWADqspCry/vIq7/jWyTyL877QpLvM7gGY0OI8ILcDs2gFwJXN9YTBJQhRd7Ji6ZN3GgA1YgWNMTmiuH1LwePCR61DUThFdCmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XNBGY3wmBz6K9TQ;
	Tue,  8 Oct 2024 17:55:33 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BECA1402C6;
	Tue,  8 Oct 2024 17:55:48 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 8 Oct
 2024 11:55:46 +0200
Date: Tue, 8 Oct 2024 10:55:45 +0100
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
Subject: Re: [RFC v2 03/12] system/vl: Create CPU topology devices from CLI
 early
Message-ID: <20241008105545.000013e0@Huawei.com>
In-Reply-To: <20240919061128.769139-4-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
	<20240919061128.769139-4-zhao1.liu@intel.com>
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
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)


> +
> +static void qemu_add_cli_devices_early(void)
> +{
> +    long category = DEVICE_CATEGORY_CPU_DEF;
> +
> +    qemu_add_devices(&category);
> +}
> +
>  static void qemu_init_board(void)
>  {
>      /* process plugin before CPUs are created, but once -smp has been parsed */
> @@ -2631,6 +2662,9 @@ static void qemu_init_board(void)
>      /* From here on we enter MACHINE_PHASE_INITIALIZED.  */
>      machine_run_board_init(current_machine, mem_path, &error_fatal);
>  
> +    /* Create CPU topology device if any. */
> +    qemu_add_cli_devices_early();
I wonder if this is too generic a name?

There are various other things we might want to do early.
Maybe qemu_add_cli_cpu_def()


> +
>      drive_check_orphaned();
>  
>      realtime_init();
> @@ -2638,8 +2672,6 @@ static void qemu_init_board(void)
>  



