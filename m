Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030903F4D85
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 17:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhHWP3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 11:29:44 -0400
Received: from mail-bn8nam08on2088.outbound.protection.outlook.com ([40.107.100.88]:5856
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230380AbhHWP3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 11:29:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMYQ1afa/TzNOuGSbEhUR8aKI3OFiIRX7VJO0u/rqWJfMlXUknAUdkrSZpJbtjm908XCqcuDpkQ8U2N51LgB2e+tPxNehaALW2v5v5BZvqKqaHSIZ5n8W+eKsTrFKkb4n/+TssPs9/2SfoFt4GX5BcIZODoFH9XXwRaU62dyUaG34kS9bP5qq9MVPT2Fi5s/fX6Daxd9STaRGMVDdeEy86dtyBObKDaprhf1NKb+u/N3JiNyA0bWYpbTHV/0F3r5BxLaaS2yj7NYGggaK50Eb32j3AffbKxzArtMwkBEOFc4QNuCI6T9MOc6ZAffPXvcZtbBrIbbC1MFJXb2lrr9XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNEs3u0zSvoRBiBxgRSJOOFae5LCdo8zc4TPY9bvovk=;
 b=jUm0xYuHM15OvfwPCnNZddvfQueSu1B2FMUDEL0AeTZaZbM0EOl9SxyQTjr4pwpSbQ+B3JJyf47MzROYZd7sEQgrg9Vsdbrn6IQrbBcKVJIFU5A0CCd+qWplXwB0yQwKK5eT0P66YA7RduTqKSbKQyjhl8CX+u+IXjKxgaa3ZHFDFqa1JrJ+VKxkpJ5IVAlRz1od8fMjO/Q3sMm8aKlYYhG6UUUpVCrvwSANDMWbAI/t4sE4cllRQ7YtHxKTy/iOi2RIma1uHFTdkNvXsk2V1A+f9IJcIi7oYMsnLOW7rzT+YeDPOz/N+vwlZkELvm4hDd7WmzcSwAZVBAUnvdcVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNEs3u0zSvoRBiBxgRSJOOFae5LCdo8zc4TPY9bvovk=;
 b=o2W81zXjfuRWMR4DR7W1caI+su2EGMnVclwpQi3ZwxLg3c5lgaZa9z3/kP+0x0Sd9SvBVGIB6EXnTutHAvbmWkaLPeJVqrEJBnU6FhZmJW/GK/a3lMjEzS2il6B15mJoSbQ1iFO0SK4skzihxDtxK+tRxccdz6golTPh+HZVYqfNaM+oezWCwOtDWiRVblDIVLjRpFOaHShVGz1dzG4RXmUsemGhoOzV2YbJVyB98Famypj1SPUxiO2OohB6vRDTjwOXn6AmZWGph80fq8VhTq88xvOizR8uDaq7CrLzPKgGCAsomY0CK5+1VAyB5YucAHyNlRdKgL/Tawz7L0Z4xA==
Received: from BN9P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::9)
 by MWHPR12MB1822.namprd12.prod.outlook.com (2603:10b6:300:114::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Mon, 23 Aug
 2021 15:28:58 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::cf) by BN9P221CA0002.outlook.office365.com
 (2603:10b6:408:10a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend
 Transport; Mon, 23 Aug 2021 15:28:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 15:28:57 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Aug
 2021 15:28:56 +0000
Received: from [172.27.13.55] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Aug
 2021 15:28:52 +0000
Subject: Re: [PATCH V3 06/13] vfio/pci: Split the pci_driver code out of
 vfio_pci_core.c
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <jgg@nvidia.com>, <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
 <20210822143602.153816-7-yishaih@nvidia.com>
 <20210823091624.697c67d6.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <393721ae-2183-2b1b-f670-8006992c4e55@nvidia.com>
Date:   Mon, 23 Aug 2021 18:28:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823091624.697c67d6.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28ab6a69-bf49-4615-826c-08d9664ab970
X-MS-TrafficTypeDiagnostic: MWHPR12MB1822:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1822D580D78509474F2FC860DEC49@MWHPR12MB1822.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QijZHw65fsoUyUnjpdN0VY2764Q07MZ8eX1ceRsMPvtpZnbBMYEkparmRpNQQFGwdPcliHjFEkH0VStiIUnruBxjMZzaESTYKor+09Hq9sV5oCqc06+H7GRu07horBMFgF0RjFpYGURPV3yGRjVOWrSrvM2Iun8ovNuFpWlaGz5giKLEyMnSAmC1u2yWwwEEm28aXsZS7fES7L+ll0Hp0zn18AlpXlk2vH4Q1dWkp2oHjbmKkoOTvJ2Bs65PayMTi0g5/IQiJY2eoNR6EKo0QjXJ59mAkyVlmZUsCzmlC4/O6F7fc82UYP445q2k5yuyYlijuMPCKR5F/dDUFePaF55Y/BzDHNUIqrfrz+kdQL/S1XgnCuakoVfCEmaadma+82149be8gDgScyjX8+R8A2FWw4bkDG7T6e8Z5mHRiMurzeBBPP2a+bI6gELLVnC6wh8IE5B0lk3ZfA0EZIyXhY0aSeiurawiSVmmcm3G/9a+yrI6PXbg90JzvFRRuOmBJBW15jz7VSfnxOO0HpEV91WKtaEj5EcT7bPEJ4Mqr+tKC3Coyl0NlfrBuV/M/eVPH6uU487H6GjDJ4on3EqEF8kUAu08b56cVKnf5nRZE0/4JteO/hJJrtwCvou6+dUGJPou373GHIBisTrKePH9iVRbU9QfweNImSb9C3fSD+347r2bTwv1nXw1e9AylBTPdlVRNsBmZLd1oCEJLDOvskv52g83QkfPC/eRGO6n4Ts=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(31696002)(8936002)(36756003)(356005)(8676002)(82740400003)(2616005)(7636003)(426003)(16526019)(186003)(336012)(5660300002)(82310400003)(110136005)(2906002)(47076005)(6636002)(16576012)(54906003)(36906005)(26005)(478600001)(107886003)(53546011)(70586007)(7416002)(70206006)(4326008)(31686004)(36860700001)(86362001)(6666004)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 15:28:57.2768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ab6a69-bf49-4615-826c-08d9664ab970
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1822
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/23/2021 6:16 PM, Alex Williamson wrote:
> On Sun, 22 Aug 2021 17:35:55 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> new file mode 100644
>> index 000000000000..15474ebadd98
>> --- /dev/null
>> +++ b/drivers/vfio/pci/vfio_pci.c
> ...
>> +static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>> +{
>> +	might_sleep();
>> +
>> +	if (!enable_sriov)
>> +		return -ENOENT;
>> +
>> +	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
>> +}
> As noted in previous version, why do we need the might_sleep() above
> when the core code below includes it and there's nothing above that
> might sleep before that?  Thanks,

This is used to mention vfio_pci_core_sriov_configure might sleep.

If this is redundant, can you please remove this one line upon merge ?

>
> Alex
>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 94f062818e0c..87d1960d0d61 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
> ...
>> -static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>> +int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>>   {
>>   	struct vfio_device *device;
>>   	int ret = 0;
>>   
>>   	might_sleep();
>>   
>> -	if (!enable_sriov)
>> -		return -ENOENT;
>> -
>>   	device = vfio_device_get_from_dev(&pdev->dev);
>>   	if (!device)
>>   		return -ENODEV;
