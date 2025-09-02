Return-Path: <kvm+bounces-56526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E849CB3F239
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 04:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1DFD16AF66
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 02:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C70C2BEFF6;
	Tue,  2 Sep 2025 02:23:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEC64414;
	Tue,  2 Sep 2025 02:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756779795; cv=none; b=LsdqOpvy/IkbUy5utIE3chJOtHaxmxVCCsIpG98V0PEUe08LhlYIAW1U8ShGkWXIdxb0qdEiUfwffW1hFeFwnVEB1tKRiCiTcWY+pbOKv0xwMS9ItfJuzhcCUFZZqjS3AebVw/p+Kda9S0ZQBG9oJMrqqAc6NY1bLncipHHW4Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756779795; c=relaxed/simple;
	bh=vbp+xwAzKmTpo4AyNEDblh9m98+wpwZzDRDxxwY2tV0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=I11A00CLZFmcOwYmFhijNzSY1OeGCOnQD94f031mQncGegNr8fnc8M+MUY/mRFGIjEvb4lYMpoXURcQkxELzSDLzhZX8kV/00EheXnfCfU+F6r+/p0LGWI1zgq3nb92ynZvCXvuJU2EPVybgbc/u3npGJCHNICWXS084ssS3FLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cG8ZJ53scz13NSF;
	Tue,  2 Sep 2025 10:19:20 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 618801402EA;
	Tue,  2 Sep 2025 10:23:10 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 10:23:09 +0800
Subject: Re: [PATCH] hisi_acc_vfio_pci: Fix reference leak in
 hisi_acc_vfio_debug_init
To: Miaoqian Lin <linmq006@gmail.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Alex
 Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
References: <20250901081809.2286649-1-linmq006@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <47e97b77-edfa-3a90-f74c-068b24afe917@huawei.com>
Date: Tue, 2 Sep 2025 10:23:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250901081809.2286649-1-linmq006@gmail.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/9/1 16:18, Miaoqian Lin wrote:
> The debugfs_lookup() function returns a dentry with an increased reference
> count that must be released by calling dput().
> 
> Fixes: b398f91779b8 ("hisi_acc_vfio_pci: register debugfs for hisilicon migration driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 2149f49aeec7..1710485cbbec 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1611,8 +1611,10 @@ static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vd
>  	}
>  
>  	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> -	if (!migf)
> +	if (!migf) {
> +		dput(vfio_dev_migration);
>  		return;
> +	}
>  	hisi_acc_vdev->debug_migf = migf;
>  
>  	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
> @@ -1622,6 +1624,8 @@ static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vd
>  				    hisi_acc_vf_migf_read);
>  	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
>  				    hisi_acc_vf_debug_cmd);
> +
> +	dput(vfio_dev_migration);
>  }
>

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks!
Longfang.

>  static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> 

