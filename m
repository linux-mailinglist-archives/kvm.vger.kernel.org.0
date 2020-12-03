Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED62B2CDDEF
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 19:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbgLCSns convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 3 Dec 2020 13:43:48 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgLCSns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 13:43:48 -0500
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Cn4Sj3QmgzVgff;
        Fri,  4 Dec 2020 02:42:13 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 4 Dec 2020 02:42:59 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.1913.007; Thu, 3 Dec 2020 18:42:57 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        wangxingang <wangxingang5@huawei.com>
CC:     Xieyingtai <xieyingtai@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        qubingbing <qubingbing@hisilicon.com>
Subject: RE: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Topic: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Index: AQHWvZ36CODK3kmCyk2T9hmchYhCqqniWTe/gANqCPA=
Date:   Thu, 3 Dec 2020 18:42:57 +0000
Message-ID: <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
In-Reply-To: <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.67.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu
> [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Auger Eric
> Sent: 01 December 2020 13:59
> To: wangxingang <wangxingang5@huawei.com>
> Cc: Xieyingtai <xieyingtai@huawei.com>; jean-philippe@linaro.org;
> kvm@vger.kernel.org; maz@kernel.org; joro@8bytes.org; will@kernel.org;
> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> vivek.gautam@arm.com; alex.williamson@redhat.com;
> zhangfei.gao@linaro.org; robin.murphy@arm.com;
> kvmarm@lists.cs.columbia.edu; eric.auger.pro@gmail.com
> Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
> unmanaged ASIDs
> 
> Hi Xingang,
> 
> On 12/1/20 2:33 PM, Xingang Wang wrote:
> > Hi Eric
> >
> > On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
> >> @@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void
> *cookie)
> >> 	 * insertion to guarantee those are observed before the TLBI. Do be
> >> 	 * careful, 007.
> >> 	 */
> >> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> >> +	if (ext_asid >= 0) { /* guest stage 1 invalidation */
> >> +		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
> >> +		cmd.tlbi.asid	= ext_asid;
> >> +		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
> >> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> >
> > Found a problem here, the cmd for guest stage 1 invalidation is built,
> > but it is not delivered to smmu.
> >
> 
> Thank you for the report. I will fix that soon. With that fixed, have
> you been able to run vSVA on top of the series. Do you need other stuff
> to be fixed at SMMU level? 

I am seeing another issue with this series. This is when you have the vSMMU
in non-strict mode(iommu.strict=0). Any network pass-through dev with iperf run 
will be enough to reproduce the issue. It may randomly stop/hang.

It looks like the .flush_iotlb_all from guest is not propagated down to the host
correctly. I have a temp hack to fix this in Qemu wherein CMDQ_OP_TLBI_NH_ASID
will result in a CACHE_INVALIDATE with IOMMU_INV_GRANU_PASID flag and archid
set.

Please take a look and let me know. 

As I am going to respin soon, please let me
> know what is the best branch to rebase to alleviate your integration.

Please find the latest kernel and Qemu branch with vSVA support added here,

https://github.com/hisilicon/kernel-dev/tree/5.10-rc4-2stage-v13-vsva
https://github.com/hisilicon/qemu/tree/v5.2.0-rc1-2stage-rfcv7-vsva

I have done some basic minimum vSVA tests on a HiSilicon D06 board with
a zip dev that supports STALL. All looks good so far apart from the issues
that have been already reported/discussed.

The kernel branch is actually a rebase of sva/uacce related patches from a
Linaro branch here,

https://github.com/Linaro/linux-kernel-uadk/tree/uacce-devel-5.10

I think going forward it will be good(if possible) to respin your series on top of
a sva branch with STALL/PRI support added. 

Hi Jean/zhangfei,
Is it possible to have a branch with minimum required SVA/UACCE related patches
that are already public and can be a "stable" candidate for future respin of Eric's series?
Please share your thoughts.

Thanks,
Shameer 

> Best Regards
> 
> Eric
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
