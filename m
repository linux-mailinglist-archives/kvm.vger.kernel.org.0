Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5107E3BBA6A
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhGEJoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 05:44:18 -0400
Received: from mail-sn1anam02on2053.outbound.protection.outlook.com ([40.107.96.53]:3687
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230000AbhGEJoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 05:44:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7u3KRA7mxZV9yuqzmCA3T/pxGIod8DthexWMLAb1uzFmShE19xovBknbqKAe3KJHgdkPBdqtBUgFwsyMNcQxHZLJF6001g/G29ahWnWaLq0+eaRkgQ5N2cYG1GenZBBMraqwP+KZPF+aEr5eVWi3LScMSXwU1BhRvcQW23I+zHH6zHq8B6OJCH+756MGixjxRyfYXOXjkXipffXzW6TCHo4HIq8AnHjUyziaw6jQY0mcVlPwCo8FXyqpWhct5SunYi6b00EdgjQci+2LLwjbT+3OVpu4kiEgqbA7CgW8QwPCHFboGBAq/QuHFKaTW+McHvbK1rFrYRjM/dmthHLnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbn8syCm8gctlvWh0rG7DiclEAaAGJgKoIFeHS1z0j4=;
 b=d+j4OuXPVqJMQ/bCIz3x4dRaTKKZG1CZ1JHkQjcX/n32NUIQkAk8+84spexRspPNtvhKa6Tx4zUSJzugdrzS4pj6c3MU0eTKpSJsmCqhxpoYvFq3GNggQDhtEe1ctRjgLx3MS9ABMK2q9Lur3R1ynQVt+3cXmYhoXLy4Nte+nabgkDhbxa62AWC1TexHhtoHVxTY11rN1jGaozCu5GT1OIghOeg4+TDpRvnp8gIpmX4gtnolgreNNfXbUEbLvLfuhwkhy78AiJXaPCz/BtEjQ2yoduKlmVYVIghQm2xLfH2JN4wr2G4fT8JYvuuB8lov9LEroG3cXuqLAedHePsMow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbn8syCm8gctlvWh0rG7DiclEAaAGJgKoIFeHS1z0j4=;
 b=UV12jDBkShjJas7IOJwtkw/6ov+6rnKC8wgawoiBlFU7MjTqUzh1hQlA5kwCxdOR+B0AXwFjjlX8PgjGn3ndSBiq+SdqstzD6dGhisMnGWtUeuTIz/Q4qHq/Bm4ITTpdd8wHcg3aNeuMODLwRTUoVE2EGV8bIiLlcO/zaDdMcxUyVOvO8Jp80Xx+5EUf/PVzyQXSFe39usmzRQgcHExobhaZQz1RYg6H3JQufLM5WGgvD7Uo8CTNXW13pehV+jEneSqy4lUXr6JpWSeGEl2hIKDVGUIXI5ahXzi20vAMDS0YvqWRkojKnM8tWDBPiy4Tz6ogbHt9E+lkwW/0ronDXw==
Received: from BN9PR03CA0682.namprd03.prod.outlook.com (2603:10b6:408:10e::27)
 by MW2PR12MB2457.namprd12.prod.outlook.com (2603:10b6:907:10::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Mon, 5 Jul
 2021 09:41:37 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::a1) by BN9PR03CA0682.outlook.office365.com
 (2603:10b6:408:10e::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend
 Transport; Mon, 5 Jul 2021 09:41:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Mon, 5 Jul 2021 09:41:37 +0000
Received: from [172.27.15.98] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Jul
 2021 09:41:33 +0000
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "Leon Romanovsky" <leon@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal> <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
Date:   Mon, 5 Jul 2021 12:41:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ac479fa-e0bc-4dde-d63f-08d93f991578
X-MS-TrafficTypeDiagnostic: MW2PR12MB2457:
X-Microsoft-Antispam-PRVS: <MW2PR12MB24572C1F08D267BDA4D6B82EDE1C9@MW2PR12MB2457.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Knc6HUGR9p2H/f+QrSJyLTT0YUEr69EONq0+7vnO88KRQ9EYFWgT8bk6liZp/rzKt59k/IA+c81p44aEn3J6X60iHLI+w4cwbe3BYUF0TYbG4ihU49FqFYHmKV5ZPZGcg3lFS80f/p8KS/Ph4xW+Hk4fBkiW/+RVkOeL9YVcXgu52XOt1dYENlrRwXg+zun3PgYMuL7ZOfbhd/XoVKAH6FkXkJIbmj9Hb3bTO956wy21mvKriWbOQyxSwlFZgNSkLzMirN59JPu4xphJmix1lp+sKBzKTcwdB5Y5XUX03L73zZ8gaLS0s+bvVTaMmodF5FNn40C49QBWByyT+xpie86+jWPKe8IyBLOAbgADDrIprzJdLfQJAcNqtFebz+PUMtQr28Xzv6NjK9tIBt954mkaUihjPskvs63weWCpIDYq+/2ham5fImGyb5Jq7lgQFwWLUfGt5tEt7Rkn5yZj8z80HIivQ8+ez8T7nV5kRoacPX1CMVpyhvBGOvQrKXjhM4E3WvvB+3hLMNcRihDXEorAaHvygM4F0nQnoLQxUBwb4jUV/zo2aviClgq40UR5zq9g3N8N9Z7LuKT6uJ74c6I12mVT7vPdNkXPZ6gSiHmksmARX9p+MGd0n8EI2cBJM6e56BUnYUQf8gbsweoACTJKDfjIadgaqFGifEnrZgu7bxuN/5Hny7Wd2awFHQjylBaw84blSEGxJ7810J4lbWmE0PvGwTFjBuUs6OSZE30=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(6029001)(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(36840700001)(36756003)(7416002)(47076005)(31696002)(70206006)(53546011)(70586007)(186003)(26005)(4326008)(16526019)(36860700001)(82310400003)(110136005)(54906003)(82740400003)(5660300002)(478600001)(8936002)(356005)(16576012)(86362001)(316002)(36906005)(8676002)(7636003)(336012)(2906002)(426003)(2616005)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 09:41:37.0014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac479fa-e0bc-4dde-d63f-08d93f991578
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2457
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/5/2021 11:47 AM, Shameerali Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Leon Romanovsky [mailto:leon@kernel.org]
>> Sent: 04 July 2021 08:04
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-crypto@vger.kernel.org; alex.williamson@redhat.com; jgg@nvidia.com;
>> mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
>> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
>> yuzenghui <yuzenghui@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
>> Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for HiSilicon
>> ACC devices
>>
>> On Fri, Jul 02, 2021 at 10:58:46AM +0100, Shameer Kolothum wrote:
>>> Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
>>> This will be extended in follow-up patches to add support for
>>> vfio live migration feature.
>>>
>>> Signed-off-by: Shameer Kolothum
>> <shameerali.kolothum.thodi@huawei.com>
>>> ---
>>>   drivers/vfio/pci/Kconfig             |   9 +++
>>>   drivers/vfio/pci/Makefile            |   2 +
>>>   drivers/vfio/pci/hisi_acc_vfio_pci.c | 100 +++++++++++++++++++++++++++
>>>   3 files changed, 111 insertions(+)
>>>   create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
>> <...>
>>
>>> +static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>>> +	.name		= "hisi-acc-vfio-pci",
>>> +	.open		= hisi_acc_vfio_pci_open,
>>> +	.release	= vfio_pci_core_release,
>>> +	.ioctl		= vfio_pci_core_ioctl,
>>> +	.read		= vfio_pci_core_read,
>>> +	.write		= vfio_pci_core_write,
>>> +	.mmap		= vfio_pci_core_mmap,
>>> +	.request	= vfio_pci_core_request,
>>> +	.match		= vfio_pci_core_match,
>>> +	.reflck_attach	= vfio_pci_core_reflck_attach,
>> I don't remember what was proposed in vfio-pci-core conversion patches,
>> but would expect that default behaviour is to fallback to vfio_pci_core_* API
>> if ".release/.ioctl/e.t.c" are not redefined.
> Yes, that would be nice, but don't think it does that in latest(v4).
>
> Hi Max,
> Could we please consider fall back to the core defaults, may be check and assign defaults
> in vfio_pci_core_register_device() ?

I don't see why we should do this.

vfio_pci_core.ko is just a library driver. It shouldn't decide for the 
vendor driver ops.

If a vendor driver would like to use its helper functions - great.

If it wants to override it - great.

If it wants to leave some op as NULL - it can do it also.


>
> Thanks,
> Shameer
