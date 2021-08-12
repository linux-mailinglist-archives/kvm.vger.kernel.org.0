Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A943EAD90
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 01:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbhHLXWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 19:22:18 -0400
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:24227
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230244AbhHLXWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 19:22:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnFqb+fWo5mQGu6RotpN70fv0BXfDejNEzpNRkm3Q/AMfO5KLFr86mFkfiiPZ65C6ci5UAUNSIEEv5bhkrMzhuX+iHFSrO/WS9rdznKDdR1c4gtBvf9zej5HuitoYULS9HjGFRPmkqDFYDNqDf48/cjmLdwgj8K/hsSKs+VqNHkY3H35x9fspCVwqzLzCKk/sv+xoNb8z26gGe0W9wuMRStSmr55AALMxcdfaLTRlGH4r7zv01CYivQam2pYPPm2mYlC4avemlN9AewVT4Gjn1RK2P71ZtMeAFeRJ0uzL4lv00Re8lElA7N23j2Q+D76+BQav6mdKS4+LFuLEw9yOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqrcG7RSY86czLZXeAO0ll0sRwM1au68ZVtHl8K5iOk=;
 b=f9cVpKMKNgCt+2x7WfKw0bXZOCgJUe96GdEgdpdqWrP6wU7xUR3+lAmitfZ7L5dC3OfOzOIYugRj/mNSmEwSugs+xBdvuPV7w2m79+pA4wNq8A1W2Us4x8p67SJJswPQtTH9xEZgmc4RrDJNtj6GzVQv99/G9qJJg9gyBSkzBprXbE3AXF7JbnA36gulyfvkI94VRKB1RSOtTW51NW8u8QJIP7FDdwzTgGNcvUel6Tg0oRY2L7isICKOtVZKK+3vZnRX3CzmGRMsBuKvbpQwArmZjS2yAIzN1Fr8q/I9zO6BC0buWGpYPfIKxjngxrZ8OQmKn1GsTcvIBHLTJjAwaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqrcG7RSY86czLZXeAO0ll0sRwM1au68ZVtHl8K5iOk=;
 b=Hs6YD/deZ/3of1zBNKM9XIF+NdEHJfFqaQar2MDcyPm2pY5Ms3utJUNUbA8AvWX99zDKuJxkJUdW6hr9W+e0z6Qq1iI7EAFo1K+SFcIniKLcc5sJC9despfA5XUWrK8bDlBeUXCiLjj9drdsefP9Ryxb32pNUsrUyKuS2vQzUt61TdjB+P7qyY+uDgE038Br9wwKh8mzquA5DdG+7PMzs5cljOkJ70ctBbstBOrKu0pzuC+Mg+rm+muCxquBQgg767ERXhTw0mkc2caLo+TrHRWBuC7RzV0lvvT5XlEkQavlEGQW45GxNPQSCA667iahLAt4ZwlXtBaopsmMfYnotw==
Received: from DM6PR01CA0001.prod.exchangelabs.com (2603:10b6:5:296::6) by
 CH0PR12MB5371.namprd12.prod.outlook.com (2603:10b6:610:d6::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.15; Thu, 12 Aug 2021 23:21:50 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::3f) by DM6PR01CA0001.outlook.office365.com
 (2603:10b6:5:296::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend
 Transport; Thu, 12 Aug 2021 23:21:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Thu, 12 Aug 2021 23:21:49 +0000
Received: from [172.27.1.20] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Aug
 2021 23:21:44 +0000
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>, <bhelgaas@google.com>,
        <corbet@lwn.net>, <alex.williamson@redhat.com>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210812202632.GA2504075@bjorn-Precision-5520>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <580beaa0-d15d-4e42-5a7b-073885416df9@nvidia.com>
Date:   Fri, 13 Aug 2021 02:21:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210812202632.GA2504075@bjorn-Precision-5520>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 031bc1ce-8f3c-4ec4-514a-08d95de7f649
X-MS-TrafficTypeDiagnostic: CH0PR12MB5371:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5371F6170BEA3E7F7154C388DEF99@CH0PR12MB5371.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64J9atHo/pnKtRyYJUKD/HiD7FCiQMo+o8nvt3bAUcJZBOw9lcNQ1W0TCnLGZ3O015/R5NAw0Gh5AZhrn6kZmt01Cg4Ew0nayfmR66ux4bi7RhQ3JHgd/79nm6P/48WlXM6P90Mpxp86MPmOl+JxApkI6Yv1Y9hKMzCx6HWowsttq8nAeOse7iSIiVxWoaZ8IHRkJgGo6IWwnmXnL9sw8yHNuJLT2NKLMVQ4vlro9Dl3lroy2ziD7EfIkmbOiKnDf/zvxdHSt9/Dxo2/5aU666O8SjXiXheaDM6P/Rb1/Nv05sYFDYu9gbWHg37tHXCpFhyEtz9F84yIn0RgsSv65ZvZyTdIs8kFyc2EuQW+LZEu4aVSi4tvTA/sJA1Ls9f41EdJe2hfxMmjV5Pk0mk9I2sYfU9vczZ70fRj147gYPY4XZU5KrRr9TnxCtrG+vB/dHG76lDJfl1MfK0QfrZtC1YN8G2w85tOx8YzDN5jm8mrkXBVK7tetZO7Q+i2i3gJs/qQnT/eJkp6qJF2rYDJNlG000GqZSkx2WQySRgbspDo7hw9YSkIsSNLCzcDhLnqRogPKNJ1IXVDYEL3QmJYvhgkOzy/rKmqFS1MLIrlVBPOuLl2P2R1YV9BSKxMfFEC4yITdZlhKi+6UYWKOt3xxQehuLz3cuQsNB8PGVAfYJyne0G6k+gksSERykRgwINbyCtdQnTkhcdUTnEnp15wg+GejATknNsyErSt+S3ZYdo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(46966006)(47076005)(336012)(8936002)(31686004)(83380400001)(6666004)(2616005)(107886003)(7416002)(70586007)(356005)(6636002)(426003)(82310400003)(5660300002)(7636003)(53546011)(110136005)(54906003)(70206006)(2906002)(4326008)(36906005)(316002)(16576012)(86362001)(478600001)(8676002)(16526019)(186003)(26005)(82740400003)(31696002)(36756003)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 23:21:49.9404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 031bc1ce-8f3c-4ec4-514a-08d95de7f649
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5371
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/12/2021 11:26 PM, Bjorn Helgaas wrote:
> On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
>> On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
>>> On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
>>>> On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
>>>>> On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
>>>>> Do the other bus types have a flag analogous to
>>>>> PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
>>>>> other bus types, it'd be nice if the approach were similar.
>>>> They could, this series doesn't attempt it. I expect the approach to
>>>> be similar as driver_override was copied from PCI to other
>>>> busses. When this is completed I hope to take a look at it.
>>> I think this would make more sense as two patches:
>>>
>>>    - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
>>>      since nothing in PCI depends on the VFIO-ness of drivers that use
>>>      the flag.  The only point here is that driver id_table entries
>>>      with this flag only match when driver_override matches the driver.
>> This would require using two flags, one to indicate the above to the
>> PCI code and another to indicate the vfio_pci string to
>> file2alias. This doesn't seem justified at this point, IMHO.
> I don't think it requires two flags.  do_pci_entry() has:
>
>    if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>      strcpy(alias, "vfio_pci:");
>
> I'm just proposing a rename:
>
> s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/
>
>>>    - Update file2alias.c to export the flags and the "vfio_pci:" alias.
>>>      This seems to be the only place where VFIO comes into play, and
>>>      putting it in a separate patch will make it much smaller and it
>>>      will be clear how it could be extended for other buses.
>> Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
>> to the string "vfio_pci", that is just really confusing.
> Hahaha, I see, that's fair :)  It confused me for a long time why you
> wanted "VFIO" in the flag name because from the kernel's point of
> view, the flag is not related to any VFIO-ness.  It's only related to
> a special variety of driver_override, and VFIO happens to be one user
> of it.

In my original patch I used

#define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE

and in the pci core code I used PCI_ID_DRIVER_OVERRIDE in the "if" clause.

So we can maybe do that and leave the option to future update of the 
define without changing the core code.

In the future we can have something like:

#define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE | 
PCI_ID_F_MY_BUS_DRIVER_OVERRIDE)

The file2alias.c still have to use the exact 
PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to add "vfio_" prefix.

Is that better ?

>
> I think a separate patch that maps the flag to "vfio_pci" would be
> less confusing because without the distractions of the PCI core
> changes, it will be obvious that "vfio_" is a file2alias thing that's
> there for userspace convenience, not for kernel reasons.
>
> Do you envision any other prefixes in the future?  I hope we don't
> have to clutter pci_match_device() with checking multiple flags.
> Maybe the problem is that the modules.alias entry includes "vfio_" --
> maybe we need a more generic prefix with just the idea of an
> "alternate" driver.
>
> Bjorn
