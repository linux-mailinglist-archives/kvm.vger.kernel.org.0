Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D333F212F
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 21:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhHST6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 15:58:20 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:15178
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233995AbhHST6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 15:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKyzgdMzuPmcGOKipIGph2vKHxhRwOiXZWxDOIEFhxJKT6jXHhwOCY++z9HIx0O2F3gy/SDEfBvGtfneb6aJnZsYFRopMCxprWPw1/nGESrntXcONTm4MGQP9EYAoBMyem0oPalyErJ6fmL9S2gGuCpBKlT3yqrlH23LcWhu7QBgJHDETkl6ZzabTIdw+GsZtzn4xCO2Q0EoWl/LpJ6i6Ak95wRKIgQG+ga+RQp7akHbpsU7xOHgnvAapDz/1jGlorudxuJSDGB1jeqPO/YV41PVhiJTI6Z4fJv6PVclNP8rMdMDz/vKF+cyeXjsN0QnjSfZdNwe0rk3EtJT0hYTIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGcv4PF/48/Hux1yYzJyaDdbFQHx+eBFulGw2SnXz88=;
 b=k6JzrFyXx9hz2Elqr5AjTwzz8CbSCExiBrHhN1l6g5NsI423DWJQRmtm53QrFVPiRfaSO7zE6umFJuaJ5dmicvuPUDhDIoC97Vm+0MnfeO3nCA1zweINbc1/0yFZXBBEv+FWyFhbz+zWW3eBnN0UeEQfwgdfJVouUy4x66h5CHGTIszysuwgrkoIpGuvxaJarap1UMBrIgZrSOVBS7JI1ml129yYalYbD1Y6sIA4ueHJkVZp6JrXXEuow58stzm9d5ye5T6HGzPxbDuvDbLrKizjHIXvv52KOJJMGfyMa5e/W4eMXj3LWKe3W3OLtnvIZsEl6cd143hxTKz+K0vYig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGcv4PF/48/Hux1yYzJyaDdbFQHx+eBFulGw2SnXz88=;
 b=YfPwbM7pLTWDhJD2czOsVZOx0i1muKGOiZihqRfj8U4biXbDPv+lbWLlm4wnM7rQ+IGQMFOPojjIWA8O8p5ZzGEgBkN4qW13EULOWr9/yWL91WSr0umBMUqPJifP7VYsMWFeQTOUYK0XqSwZF7HakpwDaWP+j0EXvv926hdKfjBvkExsNVj2IY9oJIyQzGhek+wCJZRQOgRkIYtzzGn/jw1S+AxbaH1YglIXSgWbom4Xm8+Lr2geAi0MS4ErRon4a/PLBD6eBrdxgCh9n39tRIxhkfWth/DaIfPJmP7/UjgoleL2vulJL2du+0jnmCEmbbnSGGx/dxW3uqPCFzaEDw==
Received: from DM5PR15CA0059.namprd15.prod.outlook.com (2603:10b6:3:ae::21) by
 DM5PR12MB1818.namprd12.prod.outlook.com (2603:10b6:3:114::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.19; Thu, 19 Aug 2021 19:57:40 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::23) by DM5PR15CA0059.outlook.office365.com
 (2603:10b6:3:ae::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Thu, 19 Aug 2021 19:57:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 19:57:40 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Aug
 2021 19:57:38 +0000
Received: from [172.27.0.75] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Aug
 2021 19:57:34 +0000
Subject: Re: [PATCH V2 09/12] PCI: Add 'override_only' bitmap to struct
 pci_device_id
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <jgg@nvidia.com>,
        <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210819163945.GA3211852@bjorn-Precision-5520>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <cd749d14-16ba-6442-0855-32c1bfac6e2d@nvidia.com>
Date:   Thu, 19 Aug 2021 22:57:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819163945.GA3211852@bjorn-Precision-5520>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ac3aa0a-87d2-46fe-45ef-08d9634b99ce
X-MS-TrafficTypeDiagnostic: DM5PR12MB1818:
X-Microsoft-Antispam-PRVS: <DM5PR12MB18186E41DD8C7D297B2E3943DEC09@DM5PR12MB1818.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0x/5UAfpCXV0ZPbd9xafMPswjLFlqAWpJrQyhlN2LmBL6HeA7Vrv9Oud3v+shADZs65XvNhVJEVqMD5HgHw+Fzem6AYmwQGDySnjiQ8J/FE3TkzSCaWCd7RUcioUy1tjnuEptuSxVg2jNaWPA0zg/l5A2XvMSSxHi+xa0NPgi/qZVNeGqN7JEcxnTFmQnZWHnfRxin8+brZiH6Ng00SD/AVMbO42kz727BeLUU5CfL8IAmt42WregHocqu6fG7m/aIWVgTLDz+ENrkHE4Ai/EK8nqznWvvwHAnVO2bcWvBBcVA00U9NPEtctx2z6cYmMnD5uLLX542A1XtO2igYuhN6VkX6FnwyLkF5j+1GKbNIpBUSrooOaPEvVfEGWNnQnFLCL9+eC0bruo4KFr9BWvs9zBUQJLe/S/rn9ofhdPGPpx5YgyCj8uYZJsDcvYMh1/fxfH0044X77b8/NZZJENEkVjwFX2pRV5VWcjs6Gbvbu7G3+HN9Wnk495C5xEb568/TZtyU6rH+PATbmU3sbUPz73lWlCScQBGaYMRqy1DZtG0CxWzZSclJteMNCJnRo4JVY60oYK/WbjHk1Mlio2O3e9A69rKrQrjk9rrgjcmBOcZOQDooRP7EAQSHLfqmyQDaTXPDThAxXN4zPwyoRkJdBm3HZBINpd+k8ZZhIi8cqJC1n1OMpwTR8Y1gIRnLFdtYCRM+Y8fAQrZ0nFUC5YrVSBLO2rUz0d0xXS1Mpe8Q=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(36840700001)(2616005)(426003)(16576012)(5660300002)(31696002)(16526019)(8936002)(53546011)(336012)(478600001)(86362001)(186003)(82310400003)(31686004)(110136005)(70586007)(356005)(2906002)(47076005)(7416002)(7636003)(4326008)(54906003)(8676002)(82740400003)(316002)(107886003)(6666004)(26005)(6636002)(36860700001)(70206006)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 19:57:40.2725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac3aa0a-87d2-46fe-45ef-08d9634b99ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1818
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/19/2021 7:39 PM, Bjorn Helgaas wrote:
> On Thu, Aug 19, 2021 at 07:16:20PM +0300, Yishai Hadas wrote:
>> On 8/19/2021 6:15 PM, Bjorn Helgaas wrote:
>>> On Wed, Aug 18, 2021 at 06:16:03PM +0300, Yishai Hadas wrote:
>>>> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>    /**
>>>>     * struct pci_device_id - PCI device ID structure
>>>>     * @vendor:		Vendor ID to match (or PCI_ANY_ID)
>>>> @@ -34,12 +38,14 @@ typedef unsigned long kernel_ulong_t;
>>>>     *			Best practice is to use driver_data as an index
>>>>     *			into a static list of equivalent device types,
>>>>     *			instead of using it as a pointer.
>>>> + * @override_only:	Bitmap for override_only PCI drivers.
>>> "Match only when dev->driver_override is this driver"?
>> Just to be aligned here,
>>
>> This field will stay __u32 and may hold at the most 1 bit value set to
>> represent the actual subsystem/driver.
> The PCI core does not require "at most 1 bit is set."
>
> Actually, I don't think even the file2alias code requires that.  If
> you set two bits, you can generate two aliases.
>
>> This is required to later on set the correct prefix in the modules.alias
>> file, and you just suggested to change the comment as of above, right ?
> Yes, __u32 is fine and I'm only suggesting a comment change here.

great.


>
>>> As far as PCI core is concerned there's no need for this to be a
>>> bitmap.
>>>
>>> I think this would make more sense if split into two patches.  The
>>> first would add override_only and change pci_match_device().  Then
>>> there's no confusion about whether this is specific to VFIO.
>> Splitting may end-up the first patch with a dead-code on below, as
>> found_id->override_only will be always 0.
>>
>> If you still believe that this is better we can do it.
> I think it's fine to add the functionality in one patch and use it in
> the next if it makes the commit clearer.  I wouldn't want to add
> functionality that's not used at all in the series, but it's OK when
> they're both posted together.

Ok. We can do the separation if all agree that the first commit is have 
a dead section.

Alex,

we would like to get few more reviewed-by signatures and we'll send the 
V3 series in a couple of days to make it to 5.15 merge window as we planned.

Are you ok with the series after we got the green light for this patch ?

do you think we need another pair of eyes to review the other patches ?

-Max.

>
>> if (found_id->override_only) {
>>      if (dev->driver_override)
>>        return found_id;
>>    } else
>>      return found_id;
>>
>>> The second can add PCI_ID_F_VFIO_DRIVER_OVERRIDE and make the
>>> file2alias.c changes.  Most of the commit log applies to this part.
