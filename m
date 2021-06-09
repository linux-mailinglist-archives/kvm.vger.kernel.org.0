Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B381D3A0F9D
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 11:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhFIJ2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 05:28:18 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:19585
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238003AbhFIJ2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 05:28:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kf53NbDr1D2hU30tyTdyUgbGgFu6mJISJqIsTVcnbhRsC/mHeb/bW1RoxqF0nM6GbdebEY2KsnblbqNh4mMeUxuVH7y0SFn2rWkRaDBrzgux5WN4ohIrwwTBh5nznTg5UKoXJIdg9kzjEywi8O2bSQ2WvVNLznPuSGSWL+VRBZS5UiszY2VRKazj8AphlAeDCu2wtR1KOWz7VutGsPMV0gq7HoIcbZVQeLtKDiKzKtFFDQERkM/di5K45RrXu+6GbQwpRK+jqOM51p/N6bffXl8Aoe9GbUy2IuYIEXYDKSJ4f5fhdd5K8UQ7PxzRBLDZDz1sKBy6rTicHDCQzZrpYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3CAbc9pITugyFfFDuEvH1RNfKNv0oX3zTqpeyrNZ1g=;
 b=YnYk2xtmMYREeCo9FEe+M/y6iwLYYoDtdaI1Xmkze62dnhPunczmYsNdBN+VCwyBnuAW11TduWpruf5WwBqFwo9DIDt1n6T7nks1HGGEsOQ4NDznf9lsOrknexoiCzV7AHb4oMZ/cUZ6r4QfEqzO90fi4hw9HLkUGOfbVRoFF68okVXzbPm+ud0FdugVGvvsjMfZAklZSGDx3+iuRGQK/wDm/Z9uxfqe52T3gG7Ug8IRoKUgoCdTrAkTUATAvoIeStCpxAok4C9YFK4gz60pCHOqqVdd5biH4PWfsrDPDHj3WzNsIlxOOW2YN1V5YHwZgSKG+i6/FOJ1RAGsGeMTvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3CAbc9pITugyFfFDuEvH1RNfKNv0oX3zTqpeyrNZ1g=;
 b=A8JscjYhhBoTmrGeczG/LJTRJ9uhP6V1DFlrMZXC3f9OHsS2Re81wUOKcxADAjpNKf3/uVsRayWmFAWAV2nhVqu+e0L3L1W0H0DPlPn1hfz073xaKatEqm6eyyb0+7yO/AdyOk73wL9IiisAnWzcaqFeeV25/xUQBZ6ffJZnE7wkIDjU2mr7euZl4LFIMAYUgLXNM/XH4nxgHX5j2Fx+mHq10AB1rNKw+BsPLAqJuIla4e3cBpTsE2DIMmio7f27czokiWjxHT98ukizsKxB66xm5wY2BoXhtU+ZV3lZPzrEWGS8YBC7a3d96OapbSHWfjMUW6EMuH1cxyjLXfYjmQ==
Received: from BN6PR13CA0028.namprd13.prod.outlook.com (2603:10b6:404:13e::14)
 by DM5PR1201MB0138.namprd12.prod.outlook.com (2603:10b6:4:56::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 09:26:20 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::c5) by BN6PR13CA0028.outlook.office365.com
 (2603:10b6:404:13e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Wed, 9 Jun 2021 09:26:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 09:26:20 +0000
Received: from [172.27.14.222] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:26:14 +0000
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <aviadye@nvidia.com>,
        <oren@nvidia.com>, <shahafs@nvidia.com>, <parav@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <cjia@nvidia.com>, <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <25bde3a0-67ea-c01e-b99e-c9323d3a82f7@nvidia.com>
Date:   Wed, 9 Jun 2021 12:26:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608192711.4956cda2.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a17d85df-ef2f-481e-b9eb-08d92b28a46c
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0138:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0138FDE88690033046C10C08DE369@DM5PR1201MB0138.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OIKDiHVJDFpG754E2Mq9XRLWDCDoyYDqvbDGnI477A/TVm/RMO4HlJvkpdRIFA9tp6dnmF3WFy9/4qncD4umrkkgnEcH185EYxo8urFivu2xb5wuouO7gV8EH7nkLzHXyssu/R3CnNDYX4MOMbpmx4dVx3b7uhyrUF/k5T9PwVW2Iii8Wq1rcP7ibIyexTHbPWskf0GaKlpTDeSw+fScGP3PKtmZwRJ1Q4zYYTkAi3RvMfKNAGW79lz9EaKFGpehKNpI9NsRNMsPeP4gVShfMzxlDBZMvEPLiVETJ2lPshAORsmr+BXQ5On+H+ltm/bpcYXV0IB7jSriLbYQ0hgvN65dHFIIxWbCcEYmewHgnY21Nafd4b74U+n51q9aNx2gJeJsMqn+RKULTXDfK9fepfmFZiUMkXN00aN9me+NVFmD/raHJNvle8p1jFAQPfJ4LRUtjzTtXEgGZvnjvLKdvTTewS69B47/Hp2OOt/oD3shvx/wnvFEPi8AoVnCIAS/ymUIkd1nA+z0P9r12N7j+k9Rm25wTSY8xML77Jd5j05cNuKY2+cU2hcpUwP4TPsSsrFyscLSL4rahJBcVsbOTtvhCMG0IeX+JqwZ7GiEXZwLyI+08yFBe1hy1BhVjFJmxddChO6qqBsJuvJkqaNwYC0N2d9n/rPzzTghrFz7lKf1CNfrGkXaZtq6w1ykAufx
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(36840700001)(36756003)(5660300002)(6636002)(70586007)(7636003)(31686004)(86362001)(6666004)(47076005)(70206006)(356005)(82740400003)(36860700001)(82310400003)(316002)(8936002)(336012)(54906003)(4326008)(110136005)(8676002)(16576012)(36906005)(2616005)(426003)(26005)(16526019)(478600001)(186003)(31696002)(2906002)(83380400001)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:26:20.5052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a17d85df-ef2f-481e-b9eb-08d92b28a46c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0138
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/9/2021 4:27 AM, Alex Williamson wrote:
> On Tue, 8 Jun 2021 19:45:17 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Tue, Jun 08, 2021 at 03:26:43PM -0600, Alex Williamson wrote:
>>>> drivers that specifically opt into this feature and the driver now has
>>>> the opportunity to provide a proper match table that indicates what HW
>>>> it can properly support. vfio-pci continues to support everything.
>>> In doing so, this also breaks the new_id method for vfio-pci.
>> Does it? How? The driver_override flag is per match entry not for the
>> entire device so new_id added things will work the same as before as
>> their new match entry's flags will be zero.
> Hmm, that might have been a testing issue; combining driverctl with
> manual new_id testing might have left a driver_override in place.
>   
>>> Sorry, with so many userspace regressions, crippling the
>>> driver_override interface with an assumption of such a narrow focus,
>>> creating a vfio specific match flag, I don't see where this can go.
>>> Thanks,
>> On the other hand it overcomes all the objections from the last go
>> round: how userspace figures out which driver to use with
>> driver_override and integrating the universal driver into the scheme.
>>
>> pci_stub could be delt with by marking it for driver_override like
>> vfio_pci.
> By marking it a "vfio driver override"? :-\

Of course not. We'll mark it as "stub driver override".

>
>> But driverctl as a general tool working with any module is not really
>> addressable.
>>
>> Is the only issue the blocking of the arbitary binding? That is not a
>> critical peice of this, IIRC
> We can't break userspace, which means new_id and driver_override need
> to work as they do now.  There are scads of driver binding scripts in
> the wild, for vfio-pci and other drivers.  We can't assume such a
> narrow scope.  Thanks,
>
> Alex
>
