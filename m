Return-Path: <kvm+bounces-7030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BACD083CED7
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 22:48:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 492961F28A27
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 21:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F88B13AA29;
	Thu, 25 Jan 2024 21:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmzzfGms"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BAC634E8;
	Thu, 25 Jan 2024 21:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706219301; cv=none; b=C3hWt4FJEumGECB5TYGh5NOWm1NanGBO5lkSOvGM8JepFFmF+xknI1/NlVSa6+bhYm3lm+9H/Q+8ldafgoqwLqiSz0UjSjA3sLKZ2rZcXHxRzLdsTRD9yJhaoD6TF+KMe/ji2TvSTWQshJu2dclLsamPGoINpxuBYax9D6cHSBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706219301; c=relaxed/simple;
	bh=gxD6wLjO9/201y2Y9XhzXJidT9LORX6jQWUUbKfoiZs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pB8RP9jmsm49J+nFNaBAsFtqp9ZBnnDbhFA2b/7McinOGP/55EDjz7k3EkCkBVqlsK9KOiIqWyCn50Z7Gbdo1eMJLvOQCZ5xZXSbRD7LspsTvdDnJ/77A5ewxRTbB0JRKUljeLX4RvCYG7iTTzeTHd1YEJkxFr+5erCJPsQTlUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmzzfGms; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5101d38e9b1so204168e87.1;
        Thu, 25 Jan 2024 13:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706219298; x=1706824098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrKeQewcWwFL5vL1nGiLtWlm7WkCmJpd3uurZ4CeExQ=;
        b=kmzzfGmskvdMeYpRtp/dEwBUJapWWr+8abKZC7Kk+qM3VhUktmekKn5rGvMgMFyiZu
         /SVdqEvFDZCiFSHXApKfSTbKfqwttKQXFW8cj0MsMulJtquIpXIJJcqbhNVFEufalnwA
         29fkRQ2VwnCBRdFLd0/KwT7OyGePLBl1F0jzAHGoLYjHLcfknxs++GSwKaQjRz+unrb4
         6AE9fBvr+mklHQSpP4/9eJjCp+HeAYqWePljIEGSEeFoYbgVKbIN/95QaR5ENGd0USJ1
         XT4jEjifZGWHflOrzMYNnxf9XK3zNbNHo/gz1Y0tOwLYwRXNMk0YpcU1xsHZEaHzcx0N
         53TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706219298; x=1706824098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qrKeQewcWwFL5vL1nGiLtWlm7WkCmJpd3uurZ4CeExQ=;
        b=qpK7tjR+DBlCOXOvjLJp7AieCDXfLhhpLJBQoLi7z5BCZr3w4ex7sv/2kUYV/6fmtI
         q7Gxle+Gb9Fq4zM7IyP0pMsb4wCbrIKrLaFGlxRH0F3YOT1ZQ+Al25CksD4p4qjOHYdb
         3WC/4OGt7GoEhaIUr+dGVss9pP2SUZOPV2B56ZTDh0fVkxEs9qxar/vUzRLGPU2eDhb9
         izNTez18nFS7bTB3zLl6T6cowKxu3hscadlglkow0KaKz0qX862xKI1qntEb0avqMrUX
         aDq1zViWRgQe08qwXWNtcVNvjyyKE6MV3d2S2SlqodgiiK4gBo+oFt11F7Fk86+XRCYJ
         0kug==
X-Gm-Message-State: AOJu0Ywx25YvHfQLh9Nn45J68PjmcKw79h2Upabjv5BIMparLhYvgu44
	9g/4G7Grs0QxRh+iMUonzY3o1Mc0JdQgZof+pHLNs64fnI9mxUZq
X-Google-Smtp-Source: AGHT+IFkzs0/quHfA3kUyUVwzlPbepDoGXYlGjDLUf8IXT9q1mUX4cF6lZ2nyJU3cs/sXFZTNpT1rQ==
X-Received: by 2002:a19:4f07:0:b0:50e:84f9:22dc with SMTP id d7-20020a194f07000000b0050e84f922dcmr575332lfb.2.1706219297770;
        Thu, 25 Jan 2024 13:48:17 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id q16-20020ac24a70000000b0051018c2f199sm351375lfp.206.2024.01.25.13.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 13:48:17 -0800 (PST)
Date: Thu, 25 Jan 2024 23:48:13 +0200
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linuxarm@openeuler.org>
Subject: Re: [PATCH 1/3] hisi_acc_vfio_pci: extract public functions for
 container_of
Message-ID: <20240125234813.00005f5d.zhi.wang.linux@gmail.com>
In-Reply-To: <20240125081031.48707-2-liulongfang@huawei.com>
References: <20240125081031.48707-1-liulongfang@huawei.com>
	<20240125081031.48707-2-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jan 2024 16:10:29 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> In the current driver, vdev is obtained from struct
> hisi_acc_vf_core_device through the container_of function.
> This method is used in many places in the driver. In order to
> reduce this repetitive operation, I extracted a public function
> to replace it.
> 
It is better to use the passive voice in the patch comment.
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 21
> ++++++++++--------- 1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c index
> f4b38a243aa7..5f6e01571a7b 100644 ---
> a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c +++
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c @@ -641,6 +641,12 @@
> static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
> *hisi_acc_vde } }
>  
> +static struct hisi_acc_vf_core_device *hisi_acc_get_vf_dev(struct
> vfio_device *vdev) +{
> +	return container_of(vdev, struct hisi_acc_vf_core_device,
> +			    core_device.vdev);
> +}
> +
>  /*
>   * This function is called in all state_mutex unlock cases to
>   * handle a 'deferred_reset' if exists.
> @@ -1064,8 +1070,7 @@ static struct file *
>  hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>  				   enum vfio_device_mig_state
> new_state) {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> container_of(vdev,
> -			struct hisi_acc_vf_core_device,
> core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hisi_acc_get_vf_dev(vdev); enum vfio_device_mig_state next_state;
>  	struct file *res = NULL;
>  	int ret;
> @@ -1106,8 +1111,7 @@ static int
>  hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  				   enum vfio_device_mig_state
> *curr_state) {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> container_of(vdev,
> -			struct hisi_acc_vf_core_device,
> core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hisi_acc_get_vf_dev(vdev); 
>  	mutex_lock(&hisi_acc_vdev->state_mutex);
>  	*curr_state = hisi_acc_vdev->mig_state;
> @@ -1323,8 +1327,7 @@ static long hisi_acc_vfio_pci_ioctl(struct
> vfio_device *core_vdev, unsigned int 
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device
> *core_vdev) {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> container_of(core_vdev,
> -			struct hisi_acc_vf_core_device,
> core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hisi_acc_get_vf_dev(core_vdev); struct vfio_pci_core_device *vdev =
> &hisi_acc_vdev->core_device; int ret;
>  
> @@ -1347,8 +1350,7 @@ static int hisi_acc_vfio_pci_open_device(struct
> vfio_device *core_vdev) 
>  static void hisi_acc_vfio_pci_close_device(struct vfio_device
> *core_vdev) {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> container_of(core_vdev,
> -			struct hisi_acc_vf_core_device,
> core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hisi_acc_get_vf_dev(core_vdev); struct hisi_qm *vf_qm =
> &hisi_acc_vdev->vf_qm; 
>  	iounmap(vf_qm->io_base);
> @@ -1363,8 +1365,7 @@ static const struct vfio_migration_ops
> hisi_acc_vfio_pci_migrn_state_ops = { 
>  static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device
> *core_vdev) {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> container_of(core_vdev,
> -			struct hisi_acc_vf_core_device,
> core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hisi_acc_get_vf_dev(core_vdev); struct pci_dev *pdev =
> to_pci_dev(core_vdev->dev); struct hisi_qm *pf_qm =
> hisi_acc_get_pf_qm(pdev); 


