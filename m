Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962B230BDC7
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 13:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhBBMJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 07:09:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12382 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhBBMJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 07:09:36 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DVNq54Kjjz7YvC;
        Tue,  2 Feb 2021 20:07:29 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 20:08:46 +0800
Subject: Re: [PATCH v11 03/13] vfio: VFIO_IOMMU_SET_MSI_BINDING
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <joro@8bytes.org>, <maz@kernel.org>,
        <robin.murphy@arm.com>, <alex.williamson@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
 <20201116110030.32335-4-eric.auger@redhat.com>
CC:     <jean-philippe@linaro.org>, <jacob.jun.pan@linux.intel.com>,
        <nicoleotsuka@gmail.com>, <vivek.gautam@arm.com>,
        <yi.l.liu@intel.com>, <zhangfei.gao@linaro.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <635db234-33ff-c079-40cb-2de00c089e7c@huawei.com>
Date:   Tue, 2 Feb 2021 20:08:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201116110030.32335-4-eric.auger@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/11/16 19:00, Eric Auger wrote:
> This patch adds the VFIO_IOMMU_SET_MSI_BINDING ioctl which aim
> to (un)register the guest MSI binding to the host. This latter
> then can use those stage 1 bindings to build a nested stage
> binding targeting the physical MSIs.
[...]

> +static int vfio_iommu_type1_set_msi_binding(struct vfio_iommu *iommu,
> +					    unsigned long arg)
> +{
> +	struct vfio_iommu_type1_set_msi_binding msi_binding;
> +	unsigned long minsz;
> +	int ret = -EINVAL;
> +
> +	minsz = offsetofend(struct vfio_iommu_type1_set_msi_binding,
> +			    size);
> +
> +	if (copy_from_user(&msi_binding, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (msi_binding.argsz < minsz)
> +		return -EINVAL;
We can check BIND and UNBIND are not set simultaneously, just like VFIO_IOMMU_SET_PASID_TABLE.

> +
> +	if (msi_binding.flags == VFIO_IOMMU_UNBIND_MSI) {
> +		vfio_unbind_msi(iommu, msi_binding.iova);
> +		ret = 0;
> +	} else if (msi_binding.flags == VFIO_IOMMU_BIND_MSI) {
> +		ret = vfio_bind_msi(iommu, msi_binding.iova,
> +				    msi_binding.gpa, msi_binding.size);
> +	}
> +	return ret;
> +}
> +

Thanks,
Keqian
