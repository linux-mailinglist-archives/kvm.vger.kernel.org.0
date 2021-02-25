Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B44325163
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 15:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhBYOPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 09:15:25 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12578 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhBYOPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 09:15:23 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DmZVj5cKzzMbNS;
        Thu, 25 Feb 2021 22:12:29 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Feb 2021 22:14:23 +0800
Subject: Re: [RFC v10 00/25] intel_iommu: expose Shared Virtual Addressing to
 VMs
To:     Liu Yi L <yi.l.liu@intel.com>, <qemu-devel@nongnu.org>,
        <alex.williamson@redhat.com>, <peterx@redhat.com>,
        <jasowang@redhat.com>
CC:     <jean-philippe@linaro.org>, <kevin.tian@intel.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>, <jun.j.tian@intel.com>,
        <eric.auger@redhat.com>, <yi.y.sun@intel.com>,
        <pbonzini@redhat.com>, <hao.wu@intel.com>,
        <david@gibson.dropbear.id.au>, <wanghaibin.wang@huawei.com>
References: <1599735398-6829-1-git-send-email-yi.l.liu@intel.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c7179970-731c-c40e-45e6-ad3a9f921af3@huawei.com>
Date:   Thu, 25 Feb 2021 22:14:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1599735398-6829-1-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 2020/9/10 18:56, Liu Yi L wrote:
> The high-level architecture for SVA virtualization is as below, the key
> design of vSVA support is to utilize the dual-stage IOMMU translation (
> also known as IOMMU nesting translation) capability in host IOMMU.
> 
>      .-------------.  .---------------------------.
>      |   vIOMMU    |  | Guest process CR3, FL only|
>      |             |  '---------------------------'
>      .----------------/
>      | PASID Entry |--- PASID cache flush -
>      '-------------'                       |
>      |             |                       V
>      |             |                CR3 in GPA
>      '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>        v        v                          v
> Host
>      .-------------.  .----------------------.
>      |   pIOMMU    |  | Bind FL for GVA-GPA  |
>      |             |  '----------------------'
>      .----------------/  |
>      | PASID Entry |     V (Nested xlate)
>      '----------------\.------------------------------.
>      |             ||SL for GPA-HPA, default domain|
>      |             |   '------------------------------'
>      '-------------'

A silly question: With nested mode, do we need to setup the second level
mappings (GPA->HPA) for devices before vm startup? If so, can you please
point me to the piece of code that achieves it?

On Arm, we setup the stage-2 mapping via the new prereg_listener [1].

[1] 
https://patchwork.kernel.org/project/qemu-devel/patch/20210225105233.650545-15-eric.auger@redhat.com/


Thanks,
Zenghui
