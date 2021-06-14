Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BFC3A7261
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 01:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhFNXOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 19:14:35 -0400
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:7904
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229760AbhFNXOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 19:14:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYUP+zIDZgLTzDzLFtzETYSMtNIpMPYPxJET220Ha6N9AB20pyQ96brTV6AUP4DuSJih6sM3M41O2fcVHtHIC+oDiTV4nGQmiw1UeVNuMP+55Txn2KTSV/KPnwORc6mYDu+bMAqh3DWkiR8w078feyLP+lYTxH/ZzXDwSt9b6YXgDJ7JcC2PLEUXGBgsYTXeB0uvMXUgeO65QI9YTmn7gAq/SsRfGCfbjFBz1PixIXk8BZ30MqOicMEO0mNb6EWnUmgj5luXUKJfbMvyV2IbE/q+aur4QvfWDC8K9bSkmTavzyrRsyKbSMSdFEFCNriCII8u7wO7N+OmE1sH8YYLHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4minazzj7iydtCXpAj/tVMgKU3kyGwLSqV1R+t4OBKU=;
 b=Fq76S8Lv7/Tl1jJ6Ay3nA3tnB6TYDJ2HGuMW0LDsUIu/pfohOUehB/AfhnmkArQXHNn1dlMGQpguXpnH0i6T02zFQMDRqB6VWNAyo1v2/VQxI00Z8OP13wDKD5lLGYPLlCoDA2TIezMZilcsviMRpEHQKC4LyLatZ5f0sRkzRziCzn3Fc6kj7RG34eAyXHSlCogm9sWMhBZ66CVwXPwAH4e0sOg2eFGo/uFNjJ8KMAozKHeEC7/8cBYrRvHt3Z2RhxBjg7EdP+hyKbFA3NDRDu6PIxxIttLFhUSfrSer7L4tUMCsrHAuCFV9d4fVCgnUq2shyuxalu3uRD0FPnutRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4minazzj7iydtCXpAj/tVMgKU3kyGwLSqV1R+t4OBKU=;
 b=aLj0Q5BhityUJIpZWlrmwhEQ2nkmAqdOK3CXBI9WmEk98F42X+s00Nx2sHUQ6wYQOnORc07ave/OvkBtWFRLfddiRg5ki39Sc7P/PWizyqQrC5DZjgedZo4FcXNpffX2Wxr5mR5fAFxCLFqTicRyoNRaZoJ3t6omFd0MJZcPg8QrFxYpDpmolzx07d8XJR4pUL/ngaoQUSfGThJfxYawEg4a8AZ/h4EVZ37crF1+Z2/AxnBE+8gPDw54bz+vYYtpohmBhVpJXrwXm3yOrUbxE3+VaSePcVJdp7JEu1iSLNkxLUBcLfTVtcXWEKEEmROThKE4177CeoJMRZxyajs+kQ==
Received: from BN6PR22CA0048.namprd22.prod.outlook.com (2603:10b6:404:37::34)
 by BY5PR12MB4643.namprd12.prod.outlook.com (2603:10b6:a03:1ff::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 23:12:29 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::ae) by BN6PR22CA0048.outlook.office365.com
 (2603:10b6:404:37::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Mon, 14 Jun 2021 23:12:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 23:12:29 +0000
Received: from [172.27.0.122] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 23:12:24 +0000
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <20210614124250.0d32537c.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
Date:   Tue, 15 Jun 2021 02:12:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614124250.0d32537c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2e27925-ffba-408e-ec2b-08d92f89e1e5
X-MS-TrafficTypeDiagnostic: BY5PR12MB4643:
X-Microsoft-Antispam-PRVS: <BY5PR12MB46438FE20362A7F8EDB61AE6DE319@BY5PR12MB4643.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCnjsVTje9qxFLcpYAZCSx6e4XmgQRO+E8JP1wejpaNiDxKNzI4jqCRM/JqzY98b2xd/2XKVmBa+R0P2yUIN9SW8cWmsv/4O954X5EuYv2E1K0Q7RIhLPwWBdetijIpQ7ZFo5pvME3FhGccBIz+Um6CTJ5DaE7uk7yNVOtQK71Q2FF7MEKc246OzEtjl0hgI1y2yFTliRs91eJ/poC2eKGEz9s6Ga4bbrolnjFM68wWacTJrXVy+aH6fPVkCkgBUcY3cjOFJZ/47eeFdICcohUZ7rv4NohDKQNbguY1WE3WRGDQOd3Qaic7wvolgGewbjyGegGnGF+MYFxPFVU6yF9x1FkrE1e9oHcW8L6j7NoNr/g4bcrPHdyOSePGjMEILjNieI+2GOvvGHCUrQyLSC9YROFZiqmPFqGQYoWwxXLDLr9eb2SpPYeSylT7RMcRmXUCBkYqtH5oinl5alFYKuSmbHcVjcPWWknqRdf9KlZgmqAWZTOMv7Tp08TUK2xLqOmxbYLr/LQgAudpyaxJBKJPIt4DmnCtYSaSdGH95KYq1wG60Y+Geqo9xIGaJlWOiSUEoHXheEWWRJDAkrqovVtMpeHqkfYfSkwL+9n+ny97BM/SrcyEeMT1wNPjyVjkmMO+zXthDCvzND0nfKZmuuznE466K5sSwwQ6UeA08eMMFMDA3pBKOaeHL10A+U0h1
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(36906005)(83380400001)(336012)(478600001)(47076005)(70206006)(82310400003)(53546011)(6666004)(8676002)(31686004)(8936002)(2616005)(70586007)(186003)(5660300002)(16526019)(4326008)(36756003)(54906003)(36860700001)(7636003)(316002)(82740400003)(16576012)(356005)(426003)(26005)(86362001)(2906002)(6916009)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 23:12:29.4903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e27925-ffba-408e-ec2b-08d92f89e1e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4643
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/14/2021 9:42 PM, Alex Williamson wrote:
> On Sun, 13 Jun 2021 11:19:46 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> On 6/9/2021 4:27 AM, Alex Williamson wrote:
>>> On Tue, 8 Jun 2021 19:45:17 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>   
>>>> On Tue, Jun 08, 2021 at 03:26:43PM -0600, Alex Williamson wrote:
>>>>>> drivers that specifically opt into this feature and the driver now has
>>>>>> the opportunity to provide a proper match table that indicates what HW
>>>>>> it can properly support. vfio-pci continues to support everything.
>>>>> In doing so, this also breaks the new_id method for vfio-pci.
>>>> Does it? How? The driver_override flag is per match entry not for the
>>>> entire device so new_id added things will work the same as before as
>>>> their new match entry's flags will be zero.
>>> Hmm, that might have been a testing issue; combining driverctl with
>>> manual new_id testing might have left a driver_override in place.
>>>      
>>>>> Sorry, with so many userspace regressions, crippling the
>>>>> driver_override interface with an assumption of such a narrow focus,
>>>>> creating a vfio specific match flag, I don't see where this can go.
>>>>> Thanks,
>>>> On the other hand it overcomes all the objections from the last go
>>>> round: how userspace figures out which driver to use with
>>>> driver_override and integrating the universal driver into the scheme.
>>>>
>>>> pci_stub could be delt with by marking it for driver_override like
>>>> vfio_pci.
>>> By marking it a "vfio driver override"? :-\
>>>   
>>>> But driverctl as a general tool working with any module is not really
>>>> addressable.
>>>>
>>>> Is the only issue the blocking of the arbitary binding? That is not a
>>>> critical peice of this, IIRC
>>> We can't break userspace, which means new_id and driver_override need
>>> to work as they do now.  There are scads of driver binding scripts in
>>> the wild, for vfio-pci and other drivers.  We can't assume such a
>>> narrow scope.  Thanks,
>> what about the following code ?
>>
>> @@ -152,12 +152,28 @@ static const struct pci_device_id
>> *pci_match_device(struct pci_driver *drv,
>>           }
>>           spin_unlock(&drv->dynids.lock);
>>
>> -       if (!found_id)
>> -               found_id = pci_match_id(drv->id_table, dev);
>> +       if (found_id)
>> +               return found_id;
> a) A dynamic ID match always works regardless of driver override...
>
>> -       /* driver_override will always match, send a dummy id */
>> -       if (!found_id && dev->driver_override)
>> +       found_id = pci_match_id(drv->id_table, dev);
>> +       if (found_id) {
>> +               /*
>> +                * if we found id in the static table, we must fulfill the
>> +                * matching flags (i.e. if PCI_ID_F_DRIVER_OVERRIDE flag is
>> +                * set, driver_override should be provided).
>> +                */
>> +               bool is_driver_override =
>> +                       (found_id->flags & PCI_ID_F_DRIVER_OVERRIDE) != 0;
>> +               if ((is_driver_override && !dev->driver_override) ||
> b) A static ID match fails if the driver provides an override flag and
> the device does not have an override set, or...
>
>> +                   (dev->driver_override && !is_driver_override))
> c) The device has an override set and the driver does not support the
> override flag.
>
>> +                       return NULL;
>> +       } else if (dev->driver_override) {
>> +               /*
>> +                * if we didn't find suitable id in the static table,
>> +                * driver_override will still , send a dummy id
>> +                */
>>                   found_id = &pci_device_id_any;
>> +       }
>>
>>           return found_id;
>>    }
>>
>>
>> dynamic ids (new_id) works as before.
>>
>> Old driver_override works as before.
> This is deceptively complicated, but no, I don't believe it does.  By
> my understanding of c) an "old" driver can no longer use
> driver_override for binding a known device.  It seems that if we have a
> static ID match, then we cannot have a driver_override set for the
> device in such a case.  This is a userspace regression.

If I'll remove condition c) everyone will be happy ?

I really would like to end this ongoing discussion and finally have a 
clear idea of what we want.

By clear I mean C code.

If we'll continue raising ideas we'll never reach our goal. And my goal 
is the next merge window.

>
>> For "new" driver_override we must fulfill the new rules.
> For override'able drivers, the static table is almost useless other
> than using it for modules.alias support and potentially to provide
> driver_data.  As above, I find this all pretty confusing and I'd advise
> trying to write a concise set of rules outlining the behavior of
> driver_override vs dynamic IDs vs static IDs vs "override'able" driver
> flags.  I tried, I can't, it's convoluted and full of exceptions.
> Thanks,
>
> Alex
>
