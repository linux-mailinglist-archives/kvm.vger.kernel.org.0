Return-Path: <kvm+bounces-64924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7B6C91506
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F89E4E28C6
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 08:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7900A2FD668;
	Fri, 28 Nov 2025 08:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="SCrmvzLM"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094D42DF151;
	Fri, 28 Nov 2025 08:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764319980; cv=none; b=CKWRs5MS1qOYqx4fD71BZPU8HkliiSsHKtJRxkWHqhQzEIae9TmCCbJ7N12zYuC6KbZOv4Ml4p8HUK1S3lrGwY76NlMkO4ae52O5dB+kjWZbu+xtIna+P4ebAm74g81RIikLzF2cpNTbY7zC9D3EGMlO9SRVUyIdReRn79Gp0TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764319980; c=relaxed/simple;
	bh=tcJnmG/0N41wLsikN8n+boY/xzfoXWe6sikUsFin6M8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Bz8xEGWMjFc39w4LF4u40kvH4jAfIS95w7ugBJhUbdxoEFIyE04fm66xsnwcOo7GHpLkRp9UZUZ206jzvkRsYbCDmSWNyRrF7ob/K77wuCqpLoGM0BS+qYngtbsSoOKOh5T4GAVARNJFaRM0TIw9wC0hq8AjlMRGaiDuBXNRCkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=SCrmvzLM; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ayeORpzjOdSu5Dq1+NuiLmYPQmPfa5NTJ2zt1jOYWc0=;
	b=SCrmvzLMmh6Hd3DbJ/bqPri2/8mw7SfJDmO30i3bxLYDUfybVvkPFlzScb2MrwDTA6IWJSRe0
	BjeVqsKYP1cC+EJXe43rfWBYkvZkMo7W3WUoLgDNT2q7hJ/JmNpgA0fH/VdXxsex6QKEJjVTrgJ
	3qtEaJqxro70/djqoli5NKU=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dHn7T5BYYznTY7;
	Fri, 28 Nov 2025 16:50:29 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AB451401F4;
	Fri, 28 Nov 2025 16:52:54 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 28 Nov 2025 16:52:51 +0800
Subject: Re: [PATCH v2 02/22] vfio/hisi: Convert to the get_region_info op
To: Alex Williamson <alex@shazbot.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, Alexander Gordeev
	<agordeev@linux.ibm.com>, David Airlie <airlied@gmail.com>, Alex Williamson
	<alex.williamson@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Brett Creeley
	<brett.creeley@amd.com>, <dri-devel@lists.freedesktop.org>, Eric Auger
	<eric.auger@redhat.com>, Eric Farman <farman@linux.ibm.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, Vasily Gorbik <gor@linux.ibm.com>, Heiko
 Carstens <hca@linux.ibm.com>, <intel-gfx@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, <kvm@vger.kernel.org>, Kirti Wankhede
	<kwankhede@nvidia.com>, <linux-s390@vger.kernel.org>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Nikhil Agarwal <nikhil.agarwal@amd.com>, Nipun
 Gupta <nipun.gupta@amd.com>, Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, <qat-linux@intel.com>, Rodrigo Vivi
	<rodrigo.vivi@intel.com>, Simona Vetter <simona@ffwll.ch>, Shameer Kolothum
	<skolothumtho@nvidia.com>, Sven Schnelle <svens@linux.ibm.com>, Tvrtko
 Ursulin <tursulin@ursulin.net>, <virtualization@lists.linux.dev>, Vineeth
 Vijayan <vneethv@linux.ibm.com>, Yishai Hadas <yishaih@nvidia.com>, Zhenyu
 Wang <zhenyuw.linux@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, Kevin
 Tian <kevin.tian@intel.com>, <patches@lists.linux.dev>, Pranjal Shrivastava
	<praan@google.com>, Mostafa Saleh <smostafa@google.com>
References: <2-v2-2a9e24d62f1b+e10a-vfio_get_region_info_op_jgg@nvidia.com>
 <b5ffda6e-d8e9-5f02-69b3-e9f1a0901f90@huawei.com>
 <20251123194535.42acb382@shazbot.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <9cdadb2d-579f-f86a-ac4e-a15c792506aa@huawei.com>
Date: Fri, 28 Nov 2025 16:52:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251123194535.42acb382@shazbot.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/11/24 10:45, Alex Williamson wrote:
> On Mon, 24 Nov 2025 09:39:58 +0800
> liulongfang <liulongfang@huawei.com> wrote:
> 
>> On 2025/11/8 1:41, Jason Gunthorpe wrote:
>>> Change the function signature of hisi_acc_vfio_pci_ioctl()
>>> and re-indent it.
>>>
>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>> Acked-by: Pranjal Shrivastava <praan@google.com>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 57 +++++++++----------
>>>  1 file changed, 27 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> index fde33f54e99ec5..899db4d742a010 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> @@ -1324,43 +1324,39 @@ static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
>>>  	return vfio_pci_core_read(core_vdev, buf, new_count, ppos);
>>>  }
>>>  
>>> -static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>> -				    unsigned long arg)
>>> +static int hisi_acc_vfio_ioctl_get_region(struct vfio_device *core_vdev,
>>> +					  struct vfio_region_info __user *arg)
>>>  {
>>> -	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
>>> -		struct vfio_pci_core_device *vdev =
>>> -			container_of(core_vdev, struct vfio_pci_core_device, vdev);
>>> -		struct pci_dev *pdev = vdev->pdev;
>>> -		struct vfio_region_info info;
>>> -		unsigned long minsz;
>>> +	struct vfio_pci_core_device *vdev =
>>> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
>>> +	struct pci_dev *pdev = vdev->pdev;
>>> +	struct vfio_region_info info;
>>> +	unsigned long minsz;
>>>  
>>> -		minsz = offsetofend(struct vfio_region_info, offset);
>>> +	minsz = offsetofend(struct vfio_region_info, offset);
>>>  
>>> -		if (copy_from_user(&info, (void __user *)arg, minsz))
>>> -			return -EFAULT;
>>> +	if (copy_from_user(&info, arg, minsz))
>>> +		return -EFAULT;
>>>  
>>> -		if (info.argsz < minsz)
>>> -			return -EINVAL;
>>> +	if (info.argsz < minsz)
>>> +		return -EINVAL;
>>>  
>>> -		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
>>> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>>> +	if (info.index != VFIO_PCI_BAR2_REGION_INDEX)
>>> +		return vfio_pci_ioctl_get_region_info(core_vdev, arg);
>>>  
>>> -			/*
>>> -			 * ACC VF dev BAR2 region consists of both functional
>>> -			 * register space and migration control register space.
>>> -			 * Report only the functional region to Guest.
>>> -			 */
>>> -			info.size = pci_resource_len(pdev, info.index) / 2;
>>> +	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>>>  
>>
>> Please adapt based on the latest code in the Next branch.
>> Code updates have already been made here.
> 
> I resolved this on commit, please verify in the vfio next branch.
> Thanks,
>

On the next branch, the code after your adaptation modifications is correct.

Thanks.
Longfang!

> Alex
> .
> 

