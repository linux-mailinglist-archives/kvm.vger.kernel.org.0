Return-Path: <kvm+bounces-68338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C291D33923
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5FE84302E32A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB99399A6C;
	Fri, 16 Jan 2026 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Fms3X/G4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gzHltffC"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDF13112BA;
	Fri, 16 Jan 2026 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768582086; cv=none; b=XKSxuAWoxRKWnDH9DlfK9w+tu/x/JPhbbQ4WcZB4CHNdYJ9/naYhvF3lVXKxXfVo5RuFUJCQ7Z4pPaRSsfGiysb10lb1m2QSVWnbSxYaqmeOTt9O1DULG05T+hT53qBo0qZzoZmbr/6X50gx8RO7H58V6fxU/N5mgcrGtY1OmNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768582086; c=relaxed/simple;
	bh=kv93VILWo8p9r718ItKhInB6uaVA40ZtV9H7EXLVR9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LkIyOHWmuujfzHBy07Qm6IOkV7cSYTl8SPymzAYLuuc2tSWk13CfoAp8CbbsD/Uk9mVwB9G6rP8ey2ZHyLudODSTYJ+gXhamqF493mfCcAbH5zNPsIub1fX/5ZUilKMSbGLCiX1Yi3XQ4m4s+/TQoDqzwtLdrxYpwxWJjmdBsMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Fms3X/G4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gzHltffC; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D3AAB140005A;
	Fri, 16 Jan 2026 11:48:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 16 Jan 2026 11:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768582081;
	 x=1768668481; bh=b0YkCaklZLSrxvGSfjQ1j13UhAJJofAA6wN6u/0cziM=; b=
	Fms3X/G4ejk5O9nuihDww6bgo5zdjJ7eE3JnJcCNO+Oa57OBSQFso9zXpcr4oR4m
	YATRQ7B3e3E4PPo+LCJ5ND+nqGen8F1jN/2ThLHuDAEvbbkf1wFQdjcL+ufe5M2k
	75KT5Ldo0k17SJWPZCiNTpOTg3DMaHeqxC/4i/DGvmr/Tf49SX7KvJR2CtHproTm
	V1KRzD/McyQu2ymze8q/WsttGY6jo2gChVU3OgvssZx2x+Kdtr4CKSr9x2gcycoJ
	Z6dxKW27rtWWmq8z6xBpR38pWoV4l5+r/bvEsrMRE3GffYYiSiTq76GYOdQw4dem
	ztMDWiNL+Ipiss28Vj5JcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768582081; x=
	1768668481; bh=b0YkCaklZLSrxvGSfjQ1j13UhAJJofAA6wN6u/0cziM=; b=g
	zHltffCd2W1fsJWyIOAcrGosyThnAawZXn9nC1Ky8lNRSriVPTDF1Hyzq1Qdrj7M
	pNG4W4zi7ptK9EcRqm+v1p0ow7d+D5bUI/KPooGs82UotBaSKBhq3tf5Fn2wZ+YY
	HPVS1/JKfYxVmx+xXPApF8khCTBhvNiXYpBKOanBI/JQpXW+zwrHsWdXByjOQ0h+
	+huMsHKTdQ8UldSXV2BhEHhvzdueNOSUoxiMIRrZS3n77+riq85L2v881mecnTki
	I9M+DZIU9THga2xWhfwymohUGEUoCQUmrO3BbfzoguCPFzJqskpbk7UqKxqobqLG
	6ivGInA4iAfIFGH209BSw==
X-ME-Sender: <xms:wWtqaZ1pvctuCRaN8VxuVNjE-MwVhVFd2fUAvyqDYpHjpqMkQGy66Q>
    <xme:wWtqaZZ1MlPkO6BFE6DUSq9xuyvfhVixvHiN9b9zJ84vHyW5DpqYOJkwFy8-Rpf5I
    M6vStHzZ39i_yj5EyD7W-PZRN7nM-fFwpM_QIdpRQ9hYgN5j7WGqd8>
X-ME-Received: <xmr:wWtqaRKk3qLUX3ysraDYQT7gkEFxWHTNN8AfRa2Vx-wvDafEJRpyyGfUDyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdelgeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepiedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhhiuhhlohhnghhfrghngheshhhurgifvghirdgtoh
    hmpdhrtghpthhtoheprghlvgigrdifihhllhhirghmshhonhesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhonhgrth
    hhrghnrdgtrghmvghrohhnsehhuhgrfigvihdrtghomhdprhgtphhtthhopehkvhhmsehv
    ghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:wWtqaYEm_MsAWR1M3rH7etfJlounaSE1Wb1Y55MwBaK4MJrAtCBnWw>
    <xmx:wWtqaYvB6M8NPsGd1VEvdZRPO3P9Z75ExRrGcSmoYb7Co0s1Q0xoyw>
    <xmx:wWtqaXtO75isFA5PJzkPaUdStsSrOfQR_6L3zEyjc0MJbfyFh0NiXA>
    <xmx:wWtqaWDIDg3rwSVxuQGlkeg74It4zwUQNBaf_1tad9aTXOeHvkP44g>
    <xmx:wWtqaTt0F0O7Go1sJV7HnsDUPnwNzVmB2RgMs4xSrCIEKMegnNKxemrX>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jan 2026 11:48:00 -0500 (EST)
Date: Fri, 16 Jan 2026 09:47:58 -0700
From: Alex Williamson <alex@shazbot.org>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] hisi_acc_vfio_pci: fix VF reset timeout issue
Message-ID: <20260116094758.09fc60d8@shazbot.org>
In-Reply-To: <20260104070706.4107994-2-liulongfang@huawei.com>
References: <20260104070706.4107994-1-liulongfang@huawei.com>
	<20260104070706.4107994-2-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 4 Jan 2026 15:07:03 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> From: Weili Qian <qianweili@huawei.com>
> 
> If device error occurs during live migration, qemu will
> reset the VF. At this time, VF reset and device reset are performed
> simultaneously. The VF reset will timeout. Therefore, the QM_RESETTING
> flag is used to ensure that VF reset and device reset are performed
> serially.
> 
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 24 +++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 ++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index fe2ffcd00d6e..d55365b21f78 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1188,14 +1188,37 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  	return 0;
>  }
>  
> +static void hisi_acc_vf_pci_reset_prepare(struct pci_dev *pdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
> +	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
> +	struct device *dev = &qm->pdev->dev;
> +	u32 delay = 0;
> +
> +	/* All reset requests need to be queued for processing */
> +	while (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
> +		msleep(1);
> +		if (++delay > QM_RESET_WAIT_TIMEOUT) {
> +			dev_err(dev, "reset prepare failed\n");
> +			return;
> +		}
> +	}
> +
> +	hisi_acc_vdev->set_reset_flag = true;
> +}
> +
>  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
> +	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
>  
>  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
>  				VFIO_MIGRATION_STOP_COPY)
>  		return;
>  
> +	if (hisi_acc_vdev->set_reset_flag)
> +		clear_bit(QM_RESETTING, &qm->misc_ctl);


.reset_prepare sets QM_RESETTING unconditionally, .reset_done clears
QM_RESETTING conditionally based on the migration state.  In 2/ this
becomes conditional on the device supporting migration ops.  Doesn't
this enable a scenario where a device that does not support migration
puts QM_RESETTING into an inconsistent state that is never cleared?
Should the clear_bit() occur before the migration state/capability
check?

Thanks,
Alex

> +
>  	mutex_lock(&hisi_acc_vdev->state_mutex);
>  	hisi_acc_vf_reset(hisi_acc_vdev);
>  	mutex_unlock(&hisi_acc_vdev->state_mutex);
> @@ -1746,6 +1769,7 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
>  MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
>  
>  static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
> +	.reset_prepare = hisi_acc_vf_pci_reset_prepare,
>  	.reset_done = hisi_acc_vf_pci_aer_reset_done,
>  	.error_detected = vfio_pci_core_aer_err_detected,
>  };
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index cd55eba64dfb..a3d91a31e3d8 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -27,6 +27,7 @@
>  
>  #define ERROR_CHECK_TIMEOUT		100
>  #define CHECK_DELAY_TIME		100
> +#define QM_RESET_WAIT_TIMEOUT  60000
>  
>  #define QM_SQC_VFT_BASE_SHIFT_V2	28
>  #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
> @@ -128,6 +129,7 @@ struct hisi_acc_vf_migration_file {
>  struct hisi_acc_vf_core_device {
>  	struct vfio_pci_core_device core_device;
>  	u8 match_done;
> +	bool set_reset_flag;
>  	/*
>  	 * io_base is only valid when dev_opened is true,
>  	 * which is protected by open_mutex.


