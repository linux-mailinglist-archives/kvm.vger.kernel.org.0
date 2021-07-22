Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431D63D205B
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 11:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhGVI0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 04:26:06 -0400
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:16657
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230419AbhGVI0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 04:26:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpxXL8t+OxbNDcl70Ogb0ztVca3O0OC/Xt1e2GeINDdbdB5hx0DqGBZwlpJCgdKVIGf0iXNYiyIeeSNskDjicPGQpw4IDdemENTMBpCnSLOhD9FeB3jGlOX0VMqo0CsmnJKUyx+4dyiwQmsiCM2gnIrHBdzI0dGNBer11GmhPjaD0oNpKO0lreOEzD7OsP99UQjMvA+3laqdJlSi5HQCcnt1B1ZmAo2ymcC5liNJWo3abXd+i+znVqPSgLCT4aqfjnud6v+c43XY8uT+nvDudeBMcCmt2rKGXWY7a01tUveBdND5nUd7RC4QKDeXO/Rq2wvb1lA48L2b2rivvuHxUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXlbI3v/FcFzaAP4ATY9J36ylt24lciBYySY/nxBpAo=;
 b=Wa6LGJhrTa4+8/ev+iXIcLBVYKhRflUUqcwLGP6WqIs9XukICN4K2K8QXmSSrufO2o3YYN0ee0jX6CvFT1l7jOgOmU3r5KTfwzd0Sh0WbZwAu6zSWHf/daftHRxQX2pFYWwZdNT0h9f17Jpz6AsLy+iGTQMQeTTIVRDdf0od1CDDbNwQt/ob36oLQFAGyIBDq8RxpDR+kZTRVL73AfS/aED5wIVOcICUyrXUfXDCZWehYC3DmSngJ/tgMcqPc0jO/KP2nCZD6lJKksjPko7pyG7+kWzOOdpEpIA8zp+iQ/6IJsM9V3h19TDbmMb8LoFcP2TIjvJVHHFDNgSQDoeLaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXlbI3v/FcFzaAP4ATY9J36ylt24lciBYySY/nxBpAo=;
 b=nDI5BwzLfQrKHcylpEdSWXH8xU7GqHX4LWOBJ2x/5+kdLxxJxr2ahJPaG1m50UcgixYwFg92w8k+7sq+7RlkUQ7AQJERAsF33h/B8cd/gnxp1+TzOpaCWX6DFjs410W1rl8oa4jwpNRGsALCtgHTyAj9VgUbO8CrueKjcc7C+3NUBKNO9Kn9JwsHGfDsYLFSu4jlGfex/HFouskHpF++jftXeslHhlG4f7D17SUXPVfWDNwBPZBocLq90j8Dlm5W6SpuNQKwxzQT/Y6Vgip65iins5mt+23JDgI2XDWCVZXzmC43sARmrmPHvP5sTgSx1Qi5QeCTGphk9ZNeFXtU6A==
Received: from DM6PR03CA0062.namprd03.prod.outlook.com (2603:10b6:5:100::39)
 by CY4PR12MB1863.namprd12.prod.outlook.com (2603:10b6:903:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 09:06:38 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::96) by DM6PR03CA0062.outlook.office365.com
 (2603:10b6:5:100::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 09:06:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 09:06:38 +0000
Received: from [172.27.13.232] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 09:06:33 +0000
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
To:     Leon Romanovsky <leonro@kernel.org>
CC:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <maorg@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com> <YPhb6o06fX+/FiTY@unreal>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <0b8db422-749d-9d93-6b3b-957259f3d0cb@nvidia.com>
Date:   Thu, 22 Jul 2021 12:06:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPhb6o06fX+/FiTY@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50b3dd1f-319c-4473-7fde-08d94cf00374
X-MS-TrafficTypeDiagnostic: CY4PR12MB1863:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1863197A0CD88EE047542BD1C3E49@CY4PR12MB1863.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmE6X9B/FKL8rN/JxtBqEd5bjaXB/SB4/4MGsgGZWC+ZuQ8mH/lCzn/XlemM5TLxE1zpGvQprMY2ktGXWx8gyUUSUDhNzsna5ztnXeeGOeHt7mz3eRD4AUQu1s8+t2It2ys/fhHR+Q2UkgvnaNrj6Ezxk6HwPZMfPA7iUHWInsJOYiXUqZHYuWgDVE+i/mgY5xllpDz5B+d3dBLXBm9KooiKhi4lELq3Zo9KmmRvG9zrmkqkFvIBNgiKnLKimGs8ImMRDpS+jC+k/0V2zI6nSUYClbwVXPYlemcM0fGifoPO3rgmQSuN/6EJ7o0m33GCd3QXW6+lC1/VmeCkNAY12Aa3crYYGw+Eeu+Fb246iXIUXyynTaqzp3+oVg8EeE5tlDMzhZ6AmHAfuUnB4VeFE/EwHBP2jPXmXu1Gq4JvphRK3o9yDoGslm7DVxVkJv83EknGv4rvSzDN5+9OV5wsHZE0xn7E4nVFosfoyP0RVejqm2dPaSpQy7B8P6Y8xz0w4bMSWPoAKe+pb27wpVXMNexy82gDZm+ZlExY3MY8p7imJZST/1/C05H5TD2Leuo6z0JF3ALuMOYhhVDm0wa6ZlLIttY+1z8QylkXUT1cKhB8x+Yo3+BXNIB+pKWssINQfJ9MbpRKKr6x/Rl/wIs6yfsrIK4Aq/GXIiBEnH/NSeyDNraBy4lGJWxFlTWci4PAvFTmbMB6UCQOPKaC7Ycs1vZCpkXOhS5pv47ZQqXD/X0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(36840700001)(46966006)(4326008)(336012)(82740400003)(16526019)(2616005)(107886003)(36906005)(5660300002)(82310400003)(186003)(7416002)(356005)(47076005)(53546011)(26005)(36756003)(31696002)(7636003)(70586007)(70206006)(83380400001)(86362001)(36860700001)(8676002)(316002)(478600001)(31686004)(2906002)(6916009)(8936002)(54906003)(426003)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 09:06:38.2335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b3dd1f-319c-4473-7fde-08d94cf00374
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1863
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/2021 8:39 PM, Leon Romanovsky wrote:
> On Wed, Jul 21, 2021 at 07:16:09PM +0300, Yishai Hadas wrote:
>> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>>
>> Now that vfio_pci has been split into two source modules, one focusing
>> on the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
>> (vfio_pci_core.c), complete the split and move them into two different
>> kernel modules.
>>
>> As before vfio_pci.ko continues to present the same interface under
>> sysfs and this change will have no functional impact.
>>
>> Splitting into another module and adding exports allows creating new HW
>> specific VFIO PCI drivers that can implement device specific
>> functionality, such as VFIO migration interfaces or specialized device
>> requirements.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/Kconfig                      | 30 ++++++++------
>>   drivers/vfio/pci/Makefile                     |  8 ++--
>>   drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
>>   drivers/vfio/pci/vfio_pci_config.c            |  2 +-
>>   drivers/vfio/pci/vfio_pci_core.c              | 41 ++++++++++++++++---
>>   drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
>>   drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
>>   drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
>>   drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
>>   .../pci => include/linux}/vfio_pci_core.h     |  2 -
>>   10 files changed, 66 insertions(+), 39 deletions(-)
>>   rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)
> <...>
>
>> -#include "vfio_pci_core.h"
>> +#include <linux/vfio_pci_core.h>
>> +
>> +#define DRIVER_VERSION  "0.2"
> <...>
>
>> +MODULE_VERSION(DRIVER_VERSION);
> Please don't add driver versions to the upstream kernel, they useless.
>
> Thanks

This just preserves the code for driver/module version that was in 
vfio_pci.ko before the split.

However,  this can be removed in V2 if we may need to have.

Yishai

