Return-Path: <kvm+bounces-68558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D9ED3C0F4
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:53:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DBAC64271A9
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A21D63ACEFA;
	Tue, 20 Jan 2026 07:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="l9ONDIly"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB650095A;
	Tue, 20 Jan 2026 07:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768895473; cv=none; b=BP+EdIPl1xjwZO7xS7ud4YrEcoT3bMmLDcv4tribNorr0yUmHW7+adcupJaAyqcXnsADP+KeOjx+l2vQrXqS/T8owahJkKfAkA6tRw8EhALrL5l0sWlBTcN45uJQ0Pl58NnhyOpPmEDxAQNdw3cs8Kjn3MmACTVfCgzZbqtkfZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768895473; c=relaxed/simple;
	bh=E/gybQK9/xbN+LH/lKyRmvgNqgdQThbTehYuuD826iY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cFSbyiiUiLVDkqEDetgkhTs6l9ycYGhq7XQmKdnXdMR2pwMHYoCnHf1rrreC2jemGklv/fQlFj54aNISNbovp55XnXKPH41g9CK0G9SMbomjuHHBhFzqoHR58aDHXPQcloQM6eetIBzH3JKBcQEq///XnnJkMVthENiIexxt97E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=l9ONDIly; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J8RCzY1a0oCoAgeopL3nueqwZdcIAvhUx9HBvAsry3c=;
	b=l9ONDIly0/57jK4JFqyvM685xSgnFX5GqQYD2ABO7urxW67BKJ1/bVxJnbkvKoJNOUkCHYBuJ
	wD1VlurKfvorKI91w+AeFeaCp5nfCAWDvoFIob5Qn123k2HAYsk3TW7bUQvFW9gbjGUrHuLRyU+
	3gyzvuzr8ce9h8zZRDNhDRY=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dwKDW26VMzLlt3;
	Tue, 20 Jan 2026 15:47:39 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id C74A940565;
	Tue, 20 Jan 2026 15:51:01 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 15:51:01 +0800
Subject: Re: [PATCH 4/4] hisi_acc_vfio_pci: fix the queue parameter anomaly
 issue
To: Alex Williamson <alex@shazbot.org>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20260104070706.4107994-1-liulongfang@huawei.com>
 <20260104070706.4107994-5-liulongfang@huawei.com>
 <20260116100722.5bdb30d4@shazbot.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <5095fcc5-502f-ec07-8a6f-cb6112ca9bcd@huawei.com>
Date: Tue, 20 Jan 2026 15:51:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260116100722.5bdb30d4@shazbot.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)


On 2026/1/17 1:07, Alex Williamson wrote:
> On Sun, 4 Jan 2026 15:07:06 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> When the number of QPs initialized by the device, as read via vft, is zero,
>> it indicates either an abnormal device configuration or an abnormal read
>> result.
>> Returning 0 directly in this case would allow the live migration operation
>> to complete successfully, leading to incorrect parameter configuration after
>> migration and preventing the service from recovering normal functionality.
>> Therefore, in such situations, an error should be returned to roll back the
>> live migration operation.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 394f1952a7ed..e0cc20f5f38b 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -406,7 +406,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>>  	struct device *dev = &vf_qm->pdev->dev;
>>  	u32 que_iso_state;
>> -	int ret;
>> +	int qp_num, ret;
>>  
>>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
>>  		return 0;
>> @@ -423,18 +423,18 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	}
>>  
>>  	/* VF qp num check */
>> -	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
>> -	if (ret <= 0) {
>> +	qp_num = qm_get_vft(vf_qm, &vf_qm->qp_base);
>> +	if (qp_num <= 0) {
>>  		dev_err(dev, "failed to get vft qp nums\n");
>> -		return ret;
>> +		return -EINVAL;
>>  	}
> 
> Do you really want to clobber the errno or should this be something
> like:
> 
> 		return qp_num < 0 ? qp_num : -EINVAL;
> 
> And if you do that it might make sense to continue to use ret rather
> than add the new variable.  Thanks,
>

OK, your proposed fix doesn't require introducing a new variable.
I'll address these issues in the next version.

Thanks.
Longfang.

> Alex
> 
>>  
>> -	if (ret != vf_data->qp_num) {
>> +	if (qp_num != vf_data->qp_num) {
>>  		dev_err(dev, "failed to match VF qp num\n");
>>  		return -EINVAL;
>>  	}
>>  
>> -	vf_qm->qp_num = ret;
>> +	vf_qm->qp_num = qp_num;
>>  
>>  	/* VF isolation state check */
>>  	ret = qm_read_regs(pf_qm, QM_QUE_ISO_CFG_V, &que_iso_state, 1);
> 
> .
> 

