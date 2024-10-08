Return-Path: <kvm+bounces-28122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7F59944BF
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 11:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5728288812
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 09:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B4D13B5B6;
	Tue,  8 Oct 2024 09:51:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276E817C215
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 09:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728381063; cv=none; b=F45VHSNAC+XD7wOvA2iWeFDN5WyeAGXyUQRvAjCaDxnVtI/qQmj+wWA9lfPT7U3sXQQGez8UcbUfbUigm5jbMTKFiqKGnd1xPBQ7YLIFWRKVnWWn0j1gT/LehiceyuYAfLNdL2fL053F+DNBbeS8rcUtuvLv67iJ6RX+go/lrIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728381063; c=relaxed/simple;
	bh=ckKMV0Iw5QJ0QEtBvME3vgF/rrygZgBP1ZhCphuJANw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKC5hs28LyRgpOgZ3VSN6jMCq5pLA8xhEwhFLgpSjIpiw2mRJ2WC59G/XLOnEPHQdB7D8mq9Jr1U69uH6Kmv+0LZvv0OehhyCmZ2NMR1XddBp1Guuc+bu4N1CpdUaJkHGmy/WwCQcnhfWA91uXNSkU2Ued2AeyaSISgHF0OayOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XNB7q1w2sz6G9Mf;
	Tue,  8 Oct 2024 17:49:43 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 56C811402C6;
	Tue,  8 Oct 2024 17:50:57 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 8 Oct
 2024 11:50:55 +0200
Date: Tue, 8 Oct 2024 10:50:53 +0100
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
Message-ID: <20241008105053.000059ee@Huawei.com>
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

On Thu, 19 Sep 2024 14:11:19 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Custom topology will allow user to build CPU topology from CLI totally,
> and this replaces machine's default CPU creation process (*_init_cpus()
> in MachineClass.init()).
> 
> For the machine's initialization, there may be CPU dependencies in the
> remaining initialization after the CPU creation.
> 
> To address such dependencies, create the CPU topology device (including
> CPU devices) from the CLI earlier, so that the latter part of machine
> initialization can be separated after qemu_add_cli_devices_early().
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Other than question of type of category from previous patch this looks
fine to me.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

However, needs review from others more familiar with this code!
> ---
>  system/vl.c | 55 +++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 36 insertions(+), 19 deletions(-)
> 
> diff --git a/system/vl.c b/system/vl.c
> index c40364e2f091..8540454aa1c2 100644
> --- a/system/vl.c
> +++ b/system/vl.c
> @@ -1211,8 +1211,9 @@ static int device_help_func(void *opaque, QemuOpts *opts, Error **errp)
>  static int device_init_func(void *opaque, QemuOpts *opts, Error **errp)
>  {
>      DeviceState *dev;
> +    long *category = opaque;
>  
> -    dev = qdev_device_add(opts, NULL, errp);
> +    dev = qdev_device_add(opts, category, errp);
>      if (!dev && *errp) {
>          error_report_err(*errp);
>          return -1;
> @@ -2623,6 +2624,36 @@ static void qemu_init_displays(void)
>      }
>  }
>  
> +static void qemu_add_devices(long *category)
> +{
> +    DeviceOption *opt;
> +
> +    qemu_opts_foreach(qemu_find_opts("device"),
> +                      device_init_func, category, &error_fatal);
> +    QTAILQ_FOREACH(opt, &device_opts, next) {
> +        DeviceState *dev;
> +        loc_push_restore(&opt->loc);
> +        /*
> +         * TODO Eventually we should call qmp_device_add() here to make sure it
> +         * behaves the same, but QMP still has to accept incorrectly typed
> +         * options until libvirt is fixed and we want to be strict on the CLI
> +         * from the start, so call qdev_device_add_from_qdict() directly for
> +         * now.
> +         */
> +        dev = qdev_device_add_from_qdict(opt->opts, category,
> +                                         true, &error_fatal);
> +        object_unref(OBJECT(dev));
> +        loc_pop(&opt->loc);
> +    }
> +}
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
> +
>      drive_check_orphaned();
>  
>      realtime_init();
> @@ -2638,8 +2672,6 @@ static void qemu_init_board(void)
>  
>  static void qemu_create_cli_devices(void)
>  {
> -    DeviceOption *opt;
> -
>      soundhw_init();
>  
>      qemu_opts_foreach(qemu_find_opts("fw_cfg"),
> @@ -2653,22 +2685,7 @@ static void qemu_create_cli_devices(void)
>  
>      /* init generic devices */
>      rom_set_order_override(FW_CFG_ORDER_OVERRIDE_DEVICE);
> -    qemu_opts_foreach(qemu_find_opts("device"),
> -                      device_init_func, NULL, &error_fatal);
> -    QTAILQ_FOREACH(opt, &device_opts, next) {
> -        DeviceState *dev;
> -        loc_push_restore(&opt->loc);
> -        /*
> -         * TODO Eventually we should call qmp_device_add() here to make sure it
> -         * behaves the same, but QMP still has to accept incorrectly typed
> -         * options until libvirt is fixed and we want to be strict on the CLI
> -         * from the start, so call qdev_device_add_from_qdict() directly for
> -         * now.
> -         */
> -        dev = qdev_device_add_from_qdict(opt->opts, NULL, true, &error_fatal);
> -        object_unref(OBJECT(dev));
> -        loc_pop(&opt->loc);
> -    }
> +    qemu_add_devices(NULL);
>      rom_reset_order_override();
>  }
>  


