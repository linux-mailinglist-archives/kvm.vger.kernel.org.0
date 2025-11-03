Return-Path: <kvm+bounces-61775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB8CC29C2D
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 02:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA759188F7A8
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 01:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4606726E704;
	Mon,  3 Nov 2025 01:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="WhfNGhW5"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A495B26CE0F;
	Mon,  3 Nov 2025 01:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762132318; cv=none; b=jmCmMEtU9/MEVuCxsnx0A6lTd09IV/H4EMcTZ4EkYYAChxmdbSwMv7UejAKKhPCMZOiSLJK+I3Ke31oVpcT53Wt8quVgyrRJ8E+FAydvrIyHkmzQpX3xtnpEuMCAK0uMpGjppQe/1X6RWdReKfq5aJGYSk22TsUPmiNCGZJs5Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762132318; c=relaxed/simple;
	bh=OObnbOurmUBnsR8DdU+LSqR9KziWySdWAuiFPthEiNQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=P1ruxb4zA96cO/DzhBEMLwpfRJpe9qDWFNG1AYa2v/IeL3PvGWZ6PtBgkr/j0dmt27B4jk1x00ehrGw0mSu6il8aYgG/JKvsaQqffiP3xc4jUqF+uE1CFhcWp/5udAdGEya5s5skDhZbG9Wfk5ab6zx2yi/PwA24UnBDHs1rus0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=WhfNGhW5; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hcU1uo2c5xmsCi47GF3xOFBCAX+ntvxmuboNdEVPJjc=;
	b=WhfNGhW5pbA13j4FcbvRpvaV5jG+MxO6z83P6yzBRwCZQmplC5JJ/zfT/Tr/dLYJ2S0XHf9Vi
	n+y2/9jZAovM1vsV5Kc5iKhD3OwyFQsJ2pOGRmzAPcpVcWtaI5wjLALkkAN44VpJJV751cLZUW6
	D+v6BeuIXgOBTDRnYGh4uRA=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4d0D6368NZzpStg;
	Mon,  3 Nov 2025 09:10:19 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 8355A140276;
	Mon,  3 Nov 2025 09:11:46 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Nov 2025 09:11:45 +0800
Subject: Re: [PATCH] vfio: Fix ksize arg while copying user struct in
 vfio_df_ioctl_bind_iommufd()
To: Raghavendra Rao Ananta <rananta@google.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, David Matlack <dmatlack@google.com>, Josh
 Hilke <jrhilke@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex@shazbot.org>
References: <20251030171238.1674493-1-rananta@google.com>
 <5e24cb1e-4ee8-166b-48c7-88fa6857c8dc@huawei.com>
 <CAJHc60yak=kOQmap7Tmp=84cx7Z=h_15K_ZP9kdvxBc1h15rgg@mail.gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <9a153cfc-3c41-398b-4682-6d04e1880cc9@huawei.com>
Date: Mon, 3 Nov 2025 09:11:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAJHc60yak=kOQmap7Tmp=84cx7Z=h_15K_ZP9kdvxBc1h15rgg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/11/1 1:09, Raghavendra Rao Ananta wrote:
> On Thu, Oct 30, 2025 at 6:34 PM liulongfang <liulongfang@huawei.com> wrote:
>>
>> On 2025/10/31 1:12, Raghavendra Rao Ananta wrote:
>>> For the cases where user includes a non-zero value in 'token_uuid_ptr'
>>> field of 'struct vfio_device_bind_iommufd', the copy_struct_from_user()
>>> in vfio_df_ioctl_bind_iommufd() fails with -E2BIG. For the 'minsz' passed,
>>> copy_struct_from_user() expects the newly introduced field to be zero-ed,
>>> which would be incorrect in this case.
>>>
>>> Fix this by passing the actual size of the kernel struct. If working
>>> with a newer userspace, copy_struct_from_user() would copy the
>>> 'token_uuid_ptr' field, and if working with an old userspace, it would
>>> zero out this field, thus still retaining backward compatibility.
>>>
>>> Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
>>
>> Hi Ananta,
>>
>> This patch also has another bug: in the hisi_acc_vfio_pci.c driver, It have two "struct vfio_device_ops"
>> Only one of them, "hisi_acc_vfio_pci_ops" has match_token_uuid added,
>> while the other one, "hisi_acc_vfio_pci_migrn_ops", is missing it.
>> This will cause a QEMU crash (call trace) when QEMU tries to start the device.
>>
>> Could you please help include this fix in your patchset as well?
>>
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -1637,6 +1637,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>>         .mmap = hisi_acc_vfio_pci_mmap,
>>         .request = vfio_pci_core_request,
>>         .match = vfio_pci_core_match,
>> +       .match_token_uuid = vfio_pci_core_match_token_uuid,
>>         .bind_iommufd = vfio_iommufd_physical_bind,
>>         .unbind_iommufd = vfio_iommufd_physical_unbind,
>>         .attach_ioas = vfio_iommufd_physical_attach_ioas,
>>
> Sent as a separate patch in v2:
> https://lore.kernel.org/all/20251031170603.2260022-3-rananta@google.com/
> (untested).
>

I've tested this patch locally, and after applying it, QEMU no longer fails to start
and the functionality works as expected.

Thanks.
Longfang.

> Thank you.
> Raghavendra
> .
> 

