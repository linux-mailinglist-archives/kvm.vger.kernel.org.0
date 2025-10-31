Return-Path: <kvm+bounces-61631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C6DC22E1D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 02:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 880D5188B084
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C192A24DD09;
	Fri, 31 Oct 2025 01:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6goHhqro"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EB742AA9;
	Fri, 31 Oct 2025 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761874465; cv=none; b=LqtejjEHBe/hykKTkakzHHW8ljmGAHJ7hA2uJasmWEndVUdcILA3dQWo42Zgs7wLkLlK16NPbmeNeEQ6z6vDkjTHEfABc1HzHBvnKtuvXNnsUf2YAFUlv79uFe4sypH9b4HBUVoCk6p+gJ93NTtgk0tyU6OP3KW8ktJiludjrB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761874465; c=relaxed/simple;
	bh=Q9oNvyTATMCp8xwFMIhlDHEhPLJKTKTXbxJQj/E/zVg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=N/QlGie61TEXVAe+Aj85hE2GkqHCpGYvp/Wgi9W2BJ6UM7XhnfDQnlvvF30FEOn42y99oOxnH6VxFixfSaCWN4PZCh3PNHJ4Rvol1c/V0a1Rgvs0YW4tbaQcpK4E80/tQbZJLr/l4cPmWk0sIXNx+Q4u+/0b3SV11a1UksyY5OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6goHhqro; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1D6RlblNdEyz/Gp1GCwZckK1/Czr6pQNPcHDM0r3WUs=;
	b=6goHhqroXNxpR91/jD67fOmGgEG0fex1H9x48zkCmUaSr2bE7n0vaBFibcGtX4o7GAokQWXg0
	tIddyuaRqAqaZURDWVMacw9TZ+HVXo8sjShPu3LU+Dy7DcPhh8B3VPlD3U7+W669kFqxXkYyKY2
	klRzh3l5obTWUi9AIOyqtas=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cyNlS3y7lzcZyk;
	Fri, 31 Oct 2025 09:32:52 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 77923140137;
	Fri, 31 Oct 2025 09:34:19 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 09:34:18 +0800
Subject: Re: [PATCH] vfio: Fix ksize arg while copying user struct in
 vfio_df_ioctl_bind_iommufd()
To: Raghavendra Rao Ananta <rananta@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Alex Williamson <alex.williamson@redhat.com>, David Matlack
	<dmatlack@google.com>
CC: Josh Hilke <jrhilke@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20251030171238.1674493-1-rananta@google.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <5e24cb1e-4ee8-166b-48c7-88fa6857c8dc@huawei.com>
Date: Fri, 31 Oct 2025 09:34:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251030171238.1674493-1-rananta@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/10/31 1:12, Raghavendra Rao Ananta wrote:
> For the cases where user includes a non-zero value in 'token_uuid_ptr'
> field of 'struct vfio_device_bind_iommufd', the copy_struct_from_user()
> in vfio_df_ioctl_bind_iommufd() fails with -E2BIG. For the 'minsz' passed,
> copy_struct_from_user() expects the newly introduced field to be zero-ed,
> which would be incorrect in this case.
> 
> Fix this by passing the actual size of the kernel struct. If working
> with a newer userspace, copy_struct_from_user() would copy the
> 'token_uuid_ptr' field, and if working with an old userspace, it would
> zero out this field, thus still retaining backward compatibility.
> 
> Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")

Hi Ananta,

This patch also has another bug: in the hisi_acc_vfio_pci.c driver, It have two "struct vfio_device_ops"
Only one of them, "hisi_acc_vfio_pci_ops" has match_token_uuid added,
while the other one, "hisi_acc_vfio_pci_migrn_ops", is missing it.
This will cause a QEMU crash (call trace) when QEMU tries to start the device.

Could you please help include this fix in your patchset as well?

--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1637,6 +1637,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,

Thanks.
Longfang.

> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  drivers/vfio/device_cdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 480cac3a0c274..8ceca24ac136c 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -99,7 +99,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>  		return ret;
>  	if (user_size < minsz)
>  		return -EINVAL;
> -	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
> +	ret = copy_struct_from_user(&bind, sizeof(bind), arg, user_size);
>  	if (ret)
>  		return ret;
>  
> 
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> 

