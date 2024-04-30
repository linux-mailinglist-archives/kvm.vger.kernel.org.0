Return-Path: <kvm+bounces-16218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EFD78B6C96
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 10:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A53828311A
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 08:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A67C5467C;
	Tue, 30 Apr 2024 08:16:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0B73BBE3;
	Tue, 30 Apr 2024 08:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714464974; cv=none; b=hhO8qIoMWZNXGGtoN5wu2ucp620edqbvoQh2C03WkTqZY66Tbu+ox/5jRVyEzLxQvw4A096lTRRlRK1E0KJ/YqwphUrZLbfFt6qDsPdnFYifHWGlX0B0lS+NFbYyd/IMDzS2hg0KSHhx9XYJ4JhntYPBB+DrVSSRR+Zvuj7OtoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714464974; c=relaxed/simple;
	bh=HDyM3m3TGv9X/zHy050CdrWlgb3mJGwItrwS0q5WZZk=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AXXhcfd5uEfAeECF88WBtOcls3fvC5yBzHfKeBK37jVvg/AgRkSgUJ18gDkRXv2V2FTqVs1EnSZX2wrOUn2bhK5+/NA1i7JMGv66a/VyxH/NxfoW8J7F41BHt+qxN13K38NlpNnTQz9YD38wToY1NL7sfyW5N8Aj91xiHJr1ym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VTCcT1VXBz1R9sK;
	Tue, 30 Apr 2024 16:12:57 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 6538A180A9C;
	Tue, 30 Apr 2024 16:16:06 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Apr 2024 16:16:05 +0800
Subject: Re: [PATCH v3 1/3] vfio/pci: Extract duplicated code into macro
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@ziepe.ca>
CC: Gerd Bayer <gbayer@linux.ibm.com>, Niklas Schnelle
	<schnelle@linux.ibm.com>, <kvm@vger.kernel.org>,
	<linux-s390@vger.kernel.org>, Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>, Julian Ruess
	<julianr@linux.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-2-gbayer@linux.ibm.com>
 <20240429200910.GQ231144@ziepe.ca>
 <20240429161103.655b4010.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <8c1cb908-1de8-eac6-7afa-7495b23a7fe9@huawei.com>
Date: Tue, 30 Apr 2024 16:16:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240429161103.655b4010.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/4/30 6:11, Alex Williamson wrote:
> On Mon, 29 Apr 2024 17:09:10 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
>> On Thu, Apr 25, 2024 at 06:56:02PM +0200, Gerd Bayer wrote:
>>> vfio_pci_core_do_io_rw() repeats the same code for multiple access
>>> widths. Factor this out into a macro
>>>
>>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>>> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
>>> ---
>>>  drivers/vfio/pci/vfio_pci_rdwr.c | 106 ++++++++++++++-----------------
>>>  1 file changed, 46 insertions(+), 60 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
>>> index 03b8f7ada1ac..3335f1b868b1 100644
>>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
>>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
>>> @@ -90,6 +90,40 @@ VFIO_IOREAD(8)
>>>  VFIO_IOREAD(16)
>>>  VFIO_IOREAD(32)
>>>  
>>> +#define VFIO_IORDWR(size)						\
>>> +static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
>>> +				bool iswrite, bool test_mem,		\
>>> +				void __iomem *io, char __user *buf,	\
>>> +				loff_t off, size_t *filled)		\
>>> +{									\
>>> +	u##size val;							\
>>> +	int ret;							\
>>> +									\
>>> +	if (iswrite) {							\
>>> +		if (copy_from_user(&val, buf, sizeof(val)))		\
>>> +			return -EFAULT;					\
>>> +									\
>>> +		ret = vfio_pci_core_iowrite##size(vdev, test_mem,	\
>>> +						  val, io + off);	\
>>> +		if (ret)						\
>>> +			return ret;					\
>>> +	} else {							\
>>> +		ret = vfio_pci_core_ioread##size(vdev, test_mem,	\
>>> +						 &val, io + off);	\
>>> +		if (ret)						\
>>> +			return ret;					\
>>> +									\
>>> +		if (copy_to_user(buf, &val, sizeof(val)))		\
>>> +			return -EFAULT;					\
>>> +	}								\
>>> +									\
>>> +	*filled = sizeof(val);						\
>>> +	return 0;							\
>>> +}									\
>>> +
>>> +VFIO_IORDWR(8)
>>> +VFIO_IORDWR(16)
>>> +VFIO_IORDWR(32)  
>>
>> I'd suggest to try writing this without so many macros.
>>
>> This isn't very performance optimal already, we take a lock on every
>> iteration, so there isn't much point in inlining multiple copies of
>> everything to save an branch.
> 
> These macros are to reduce duplicate code blocks and the errors that

Although simple and straightforward writing will result in more lines of code.
But it's not easy to squeeze in "extra" code.
The backdoor of "XZ Utils" is implanted through code complication.

Thanks.
Longfang.

> typically come from such duplication, as well as to provide type safe
> functions in the spirit of the ioread# and iowrite# helpers.  It really
> has nothing to do with, nor is it remotely effective at saving a branch.
> Thanks,
> 
> Alex
> 
>> Push the sizing switch down to the bottom, start with a function like:
>>
>> static void __iowrite(const void *val, void __iomem *io, size_t len)
>> {
>> 	switch (len) {
>> 	case 8: {
>> #ifdef iowrite64 // NOTE this doesn't seem to work on x86?
>> 		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
>> 			return iowrite64be(*(const u64 *)val, io);
>> 		return iowrite64(*(const u64 *)val, io);
>> #else
>> 		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)) {
>> 			iowrite32be(*(const u32 *)val, io);
>> 			iowrite32be(*(const u32 *)(val + 4), io + 4);
>> 		} else {
>> 			iowrite32(*(const u32 *)val, io);
>> 			iowrite32(*(const u32 *)(val + 4), io + 4);
>> 		}
>> 		return;
>> #endif
>> 	}
>>
>> 	case 4:
>> 		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
>> 			return iowrite32be(*(const u32 *)val, io);
>> 		return iowrite32(*(const u32 *)val, io);
>> 	case 2:
>> 		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
>> 			return iowrite16be(*(const u16 *)val, io);
>> 		return iowrite16(*(const u16 *)val, io);
>>
>> 	case 1:
>> 		return iowrite8(*(const u8 *)val, io);
>> 	}
>> }
>>
>> And then wrap it with the copy and the lock:
>>
>> static int do_iordwr(struct vfio_pci_core_device *vdev, bool test_mem,
>> 		     const void __user *buf, void __iomem *io, size_t len,
>> 		     bool iswrite)
>> {
>> 	u64 val;
>>
>> 	if (iswrite && copy_from_user(&val, buf, len))
>> 		return -EFAULT;
>>
>> 	if (test_mem) {
>> 		down_read(&vdev->memory_lock);
>> 		if (!__vfio_pci_memory_enabled(vdev)) {
>> 			up_read(&vdev->memory_lock);
>> 			return -EIO;
>> 		}
>> 	}
>>
>> 	if (iswrite)
>> 		__iowrite(&val, io, len);
>> 	else
>> 		__ioread(&val, io, len);
>>
>> 	if (test_mem)
>> 		up_read(&vdev->memory_lock);
>>
>> 	if (!iswrite && copy_to_user(buf, &val, len))
>> 		return -EFAULT;
>>
>> 	return 0;
>> }
>>
>> And then the loop can be simple:
>>
>> 		if (fillable) {
>> 			filled = num_bytes(fillable, off);
>> 			ret = do_iordwr(vdev, test_mem, buf, io + off, filled,
>> 					iswrite);
>> 			if (ret)
>> 				return ret;
>> 		} else {
>> 			filled = min(count, (size_t)(x_end - off));
>> 			/* Fill reads with -1, drop writes */
>> 			ret = fill_err(buf, filled);
>> 			if (ret)
>> 				return ret;
>> 		}
>>
>> Jason
>>
> 
> 
> .
> 

