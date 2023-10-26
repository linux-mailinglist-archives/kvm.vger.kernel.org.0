Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61607D8246
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 14:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344880AbjJZMIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 08:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbjJZMIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 08:08:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4281CE5
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 05:08:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhZy7tKlDzbh2y80F4R5XkUpUQd5GLxLRJvvwxHIEyEiCnWZkT1bW4EG5TUAlnQTXeqw4ydUOM+flnw1gTkdaG5XIHWFYRkxl5t7WMj5IsC54nOrPExFhTpaqCrCkBWtrOd9ofP94Jsz3ZraU96/jQw3N0EACjfqWdKT0trs0OmHr95IGeEDf4JV592fYxfNL9d3KNpCa4DTgZJ+pat31u7QW2IrXdyMAoMWRW44zc12kod5XHY8pBnOgtWjqpNcMtpMe16Kob5qkKUcizkmVij1GaNLxURRudkO/JZ0z3WqHgl78T1ja9ItNY2zKJrHRXhSifGmw3wD3NmrX4+a2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/n9Q/o0B2x9bAfv+c3GJjXDJZ1Ib5BMT2FRYRBx8HU=;
 b=lIufQMr+QMgQiRur4xxz2Xl+fMwrIugwWt+5tPOwt+dZ0rWIV9HzlFr2BktBMwxcsRvYX5t1k/CvAebbjq7R7D0r5Bj54+l+no+zq6bHHkR65D5f0ujPJo7WdFsGgEEDIiDvm5QMx9IjmyW6qN/9QM6sDUyvaS20s34h9KZlXRHh8KSud0iUHySpStVQl6VdmQv0F6E/OwDWYbuHM3mqjFAfwg2hlLrRV7AO447JyWGIScRO3sRcHudtYAuOoOwuRAjeB+PaoCZIVkNbSXgDxc/AL3Vd8h0IYJqMhQb2wlwlEn5gxAtKU6RGFlQ4KAxVVEgwVGaxn0uhGOqLxKM+sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/n9Q/o0B2x9bAfv+c3GJjXDJZ1Ib5BMT2FRYRBx8HU=;
 b=NkToNolYO6PDqSaw6YPO7HFrgsu7J5ueV/H451xhr7WnM6zFTE3El2qb8pUunc6SecraERChvC75Pm9UHLR/M1XWcEG/VkWUqsqb1YBL35q3RDKA+tzwcxSLDhKy+8Cc6gozGaf5sV3jnxyYIjByAwySTIUhmDh1U2poQK/yU8IRPWRY7o+oaAWfCQuPbpm/di3QPZsJ4mq+n82PFJKMIqQyF+waZCA/KYJONKU+55bSb6uO3jFpnZEgoEOL0+dUMn+Ee/Jsi7RH1BqjUSr1uG1HOm6RjKLuSolyRqPey36fZ8Q3r9O/13DZix2ZtV50qhTjX1FFlBfiu1bCdEXG+Q==
Received: from MW4PR04CA0311.namprd04.prod.outlook.com (2603:10b6:303:82::16)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Thu, 26 Oct
 2023 12:08:37 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:303:82:cafe::15) by MW4PR04CA0311.outlook.office365.com
 (2603:10b6:303:82::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22 via Frontend
 Transport; Thu, 26 Oct 2023 12:08:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Thu, 26 Oct 2023 12:08:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 26 Oct
 2023 05:08:19 -0700
Received: from [172.27.0.203] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 26 Oct
 2023 05:08:15 -0700
Message-ID: <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
Date:   Thu, 26 Oct 2023 15:08:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231025131328.407a60a3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|BL1PR12MB5352:EE_
X-MS-Office365-Filtering-Correlation-Id: be3aaf56-a307-4beb-8fda-08dbd61c4866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86SK5nq3f0OoJ3tGFVpbBni8L2Ucv6jp3qqApwOhrGfM1aAq+TLvLy3mcqX8txY6Y/Igs9t/Beub3wfdvCMcBOEDB6jtxDEjwD92bYD3Y2i29uXrd6C4NYHlsMTIcdJnxh4Ll//gXdNR+FJBbFYQ9WT8lHI4qmUqYMhz+l+gVBtQsO+S2VQXbAAnJxHz1E+ksBrROxekFuJ8pT0IAxLLvt2KBZV1lqPAICYG26bvHjWDdo4d830pJwsThW1sk/qir2J18ZH7EyNTnOyKOrADbsiHUVkf8S555WMQVGv0WjiAwc/ymzRisvoHXoUM1+1SaCw7If0F3/yx1ILmeyHCF2bsqU7eYXDnm/MCwfksq3VQY2FMq7a19LB+SLapNJRUjqSwfK9imbb3Wy95Jko1Oc4/nQh8XTQmoKdI3SuYL6KzKND7ql+q2QfyzVwdUe+C/lloCzKIO8bI7DC//E1Z1uMPFJqOHx3xbE2qPR9YGnDwCl2QKwC5KWVgjaQoj3MDp609SBrZrAf0UCbzKm+zg3nBoBv3lbt/RJD7S1OdcrnjoUjERGijNdFR+qgtT/Xvprb+mBi1JIhKJuvWgs+v1u9+DDGFBvD5CFREJWIa7nTEIBUW3kCvTMoDeKuD4WvGobFNru5gZVS2Z08mGeLfxtQ2K69GktGLvaBT37GviNlRoY2Ra+hYSzdygYFxlZ9vtHbCzbujnP8jwKDWNGd+RPF/Gt4LSWWzdxmiDmmux4tc60r4uHYlkF8aGj0Rb4LAz7CntieXwTEs/i4XCyXF3UYH3nXr9qfw4ebYuMhskXY/bDsxG1K3WrED8rLFEFe6
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(451199024)(64100799003)(82310400011)(186009)(1800799009)(36840700001)(46966006)(40470700004)(31686004)(2906002)(30864003)(5660300002)(40480700001)(40460700003)(16576012)(83380400001)(7636003)(26005)(356005)(82740400003)(41300700001)(4326008)(8676002)(8936002)(70586007)(2616005)(107886003)(70206006)(54906003)(316002)(6916009)(36756003)(16526019)(53546011)(6666004)(478600001)(36860700001)(336012)(426003)(31696002)(966005)(86362001)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 12:08:36.3447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be3aaf56-a307-4beb-8fda-08dbd61c4866
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 22:13, Alex Williamson wrote:
> On Wed, 25 Oct 2023 17:35:51 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> On 24/10/2023 22:57, Alex Williamson wrote:
>>> On Tue, 17 Oct 2023 16:42:17 +0300
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>   
>>>> Introduce a vfio driver over virtio devices to support the legacy
>>>> interface functionality for VFs.
>>>>
>>>> Background, from the virtio spec [1].
>>>> --------------------------------------------------------------------
>>>> In some systems, there is a need to support a virtio legacy driver with
>>>> a device that does not directly support the legacy interface. In such
>>>> scenarios, a group owner device can provide the legacy interface
>>>> functionality for the group member devices. The driver of the owner
>>>> device can then access the legacy interface of a member device on behalf
>>>> of the legacy member device driver.
>>>>
>>>> For example, with the SR-IOV group type, group members (VFs) can not
>>>> present the legacy interface in an I/O BAR in BAR0 as expected by the
>>>> legacy pci driver. If the legacy driver is running inside a virtual
>>>> machine, the hypervisor executing the virtual machine can present a
>>>> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
>>>> legacy driver accesses to this I/O BAR and forwards them to the group
>>>> owner device (PF) using group administration commands.
>>>> --------------------------------------------------------------------
>>>>
>>>> Specifically, this driver adds support for a virtio-net VF to be exposed
>>>> as a transitional device to a guest driver and allows the legacy IO BAR
>>>> functionality on top.
>>>>
>>>> This allows a VM which uses a legacy virtio-net driver in the guest to
>>>> work transparently over a VF which its driver in the host is that new
>>>> driver.
>>>>
>>>> The driver can be extended easily to support some other types of virtio
>>>> devices (e.g virtio-blk), by adding in a few places the specific type
>>>> properties as was done for virtio-net.
>>>>
>>>> For now, only the virtio-net use case was tested and as such we introduce
>>>> the support only for such a device.
>>>>
>>>> Practically,
>>>> Upon probing a VF for a virtio-net device, in case its PF supports
>>>> legacy access over the virtio admin commands and the VF doesn't have BAR
>>>> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
>>>> transitional device with I/O BAR in BAR 0.
>>>>
>>>> The existence of the simulated I/O bar is reported later on by
>>>> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
>>>> exposes itself as a transitional device by overwriting some properties
>>>> upon reading its config space.
>>>>
>>>> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
>>>> guest may use it via read/write calls according to the virtio
>>>> specification.
>>>>
>>>> Any read/write towards the control parts of the BAR will be captured by
>>>> the new driver and will be translated into admin commands towards the
>>>> device.
>>>>
>>>> Any data path read/write access (i.e. virtio driver notifications) will
>>>> be forwarded to the physical BAR which its properties were supplied by
>>>> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
>>>> probing/init flow.
>>>>
>>>> With that code in place a legacy driver in the guest has the look and
>>>> feel as if having a transitional device with legacy support for both its
>>>> control and data path flows.
>>>>
>>>> [1]
>>>> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
>>>>
>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>> ---
>>>>    MAINTAINERS                      |   7 +
>>>>    drivers/vfio/pci/Kconfig         |   2 +
>>>>    drivers/vfio/pci/Makefile        |   2 +
>>>>    drivers/vfio/pci/virtio/Kconfig  |  15 +
>>>>    drivers/vfio/pci/virtio/Makefile |   4 +
>>>>    drivers/vfio/pci/virtio/main.c   | 577 +++++++++++++++++++++++++++++++
>>>>    6 files changed, 607 insertions(+)
>>>>    create mode 100644 drivers/vfio/pci/virtio/Kconfig
>>>>    create mode 100644 drivers/vfio/pci/virtio/Makefile
>>>>    create mode 100644 drivers/vfio/pci/virtio/main.c
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 7a7bd8bd80e9..680a70063775 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -22620,6 +22620,13 @@ L:	kvm@vger.kernel.org
>>>>    S:	Maintained
>>>>    F:	drivers/vfio/pci/mlx5/
>>>>    
>>>> +VFIO VIRTIO PCI DRIVER
>>>> +M:	Yishai Hadas <yishaih@nvidia.com>
>>>> +L:	kvm@vger.kernel.org
>>>> +L:	virtualization@lists.linux-foundation.org
>>>> +S:	Maintained
>>>> +F:	drivers/vfio/pci/virtio
>>>> +
>>>>    VFIO PCI DEVICE SPECIFIC DRIVERS
>>>>    R:	Jason Gunthorpe <jgg@nvidia.com>
>>>>    R:	Yishai Hadas <yishaih@nvidia.com>
>>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>>> index 8125e5f37832..18c397df566d 100644
>>>> --- a/drivers/vfio/pci/Kconfig
>>>> +++ b/drivers/vfio/pci/Kconfig
>>>> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>>>>    
>>>>    source "drivers/vfio/pci/pds/Kconfig"
>>>>    
>>>> +source "drivers/vfio/pci/virtio/Kconfig"
>>>> +
>>>>    endmenu
>>>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>>>> index 45167be462d8..046139a4eca5 100644
>>>> --- a/drivers/vfio/pci/Makefile
>>>> +++ b/drivers/vfio/pci/Makefile
>>>> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>>>>    obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>>>>    
>>>>    obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>>>> +
>>>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
>>>> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
>>>> new file mode 100644
>>>> index 000000000000..89eddce8b1bd
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/pci/virtio/Kconfig
>>>> @@ -0,0 +1,15 @@
>>>> +# SPDX-License-Identifier: GPL-2.0-only
>>>> +config VIRTIO_VFIO_PCI
>>>> +        tristate "VFIO support for VIRTIO PCI devices"
>>>> +        depends on VIRTIO_PCI
>>>> +        select VFIO_PCI_CORE
>>>> +        help
>>>> +          This provides support for exposing VIRTIO VF devices using the VFIO
>>>> +          framework that can work with a legacy virtio driver in the guest.
>>>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
>>>> +          not indicate I/O Space.
>>>> +          As of that this driver emulated I/O BAR in software to let a VF be
>>>> +          seen as a transitional device in the guest and let it work with
>>>> +          a legacy driver.
>>> This description is a little bit subtle to the hard requirements on the
>>> device.  Reading this, one might think that this should work for any
>>> SR-IOV VF virtio device, when in reality it only support virtio-net
>>> currently and places a number of additional requirements on the device
>>> (ex. legacy access and MSI-X support).
>> Sure, will change to refer only to virtio-net devices which are capable
>> for 'legacy access'.
>>
>> No need to refer to MSI-X, please see below.
>>
>>>   
>>>> +
>>>> +          If you don't know what to do here, say N.
>>>> diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
>>>> new file mode 100644
>>>> index 000000000000..2039b39fb723
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/pci/virtio/Makefile
>>>> @@ -0,0 +1,4 @@
>>>> +# SPDX-License-Identifier: GPL-2.0-only
>>>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
>>>> +virtio-vfio-pci-y := main.o
>>>> +
>>>> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
>>>> new file mode 100644
>>>> index 000000000000..3fef4b21f7e6
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/pci/virtio/main.c
>>>> @@ -0,0 +1,577 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>> +/*
>>>> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>>>> + */
>>>> +
>>>> +#include <linux/device.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/mutex.h>
>>>> +#include <linux/pci.h>
>>>> +#include <linux/pm_runtime.h>
>>>> +#include <linux/types.h>
>>>> +#include <linux/uaccess.h>
>>>> +#include <linux/vfio.h>
>>>> +#include <linux/vfio_pci_core.h>
>>>> +#include <linux/virtio_pci.h>
>>>> +#include <linux/virtio_net.h>
>>>> +#include <linux/virtio_pci_admin.h>
>>>> +
>>>> +struct virtiovf_pci_core_device {
>>>> +	struct vfio_pci_core_device core_device;
>>>> +	u8 bar0_virtual_buf_size;
>>>> +	u8 *bar0_virtual_buf;
>>>> +	/* synchronize access to the virtual buf */
>>>> +	struct mutex bar_mutex;
>>>> +	void __iomem *notify_addr;
>>>> +	u32 notify_offset;
>>>> +	u8 notify_bar;
>>> Push the above u8 to the end of the structure for better packing.
>> OK
>>>> +	u16 pci_cmd;
>>>> +	u16 msix_ctrl;
>>>> +};
>>>> +
>>>> +static int
>>>> +virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
>>>> +			     loff_t pos, char __user *buf,
>>>> +			     size_t count, bool read)
>>>> +{
>>>> +	bool msix_enabled = virtvdev->msix_ctrl & PCI_MSIX_FLAGS_ENABLE;
>>>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>>>> +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
>>>> +	u16 opcode;
>>>> +	int ret;
>>>> +
>>>> +	mutex_lock(&virtvdev->bar_mutex);
>>>> +	if (read) {
>>>> +		opcode = (pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled)) ?
>>>> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ :
>>>> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ;
>>>> +		ret = virtio_pci_admin_legacy_io_read(pdev, opcode, pos, count,
>>>> +						      bar0_buf + pos);
>>>> +		if (ret)
>>>> +			goto out;
>>>> +		if (copy_to_user(buf, bar0_buf + pos, count))
>>>> +			ret = -EFAULT;
>>>> +		goto out;
>>>> +	}
>>> TBH, I think the symmetry of read vs write would be more apparent if
>>> this were an else branch.
>> OK, will do.
>>>> +
>>>> +	if (copy_from_user(bar0_buf + pos, buf, count)) {
>>>> +		ret = -EFAULT;
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	opcode = (pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled)) ?
>>>> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE :
>>>> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE;
>>>> +	ret = virtio_pci_admin_legacy_io_write(pdev, opcode, pos, count,
>>>> +					       bar0_buf + pos);
>>>> +out:
>>>> +	mutex_unlock(&virtvdev->bar_mutex);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int
>>>> +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
>>>> +			    loff_t pos, char __user *buf,
>>>> +			    size_t count, bool read)
>>>> +{
>>>> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
>>>> +	u16 queue_notify;
>>>> +	int ret;
>>>> +
>>>> +	if (pos + count > virtvdev->bar0_virtual_buf_size)
>>>> +		return -EINVAL;
>>>> +
>>>> +	switch (pos) {
>>>> +	case VIRTIO_PCI_QUEUE_NOTIFY:
>>>> +		if (count != sizeof(queue_notify))
>>>> +			return -EINVAL;
>>>> +		if (read) {
>>>> +			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
>>>> +						virtvdev->notify_addr);
>>>> +			if (ret)
>>>> +				return ret;
>>>> +			if (copy_to_user(buf, &queue_notify,
>>>> +					 sizeof(queue_notify)))
>>>> +				return -EFAULT;
>>>> +			break;
>>>> +		}
>>> Same.
>> OK
>>>> +
>>>> +		if (copy_from_user(&queue_notify, buf, count))
>>>> +			return -EFAULT;
>>>> +
>>>> +		ret = vfio_pci_iowrite16(core_device, true, queue_notify,
>>>> +					 virtvdev->notify_addr);
>>>> +		break;
>>>> +	default:
>>>> +		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
>>>> +						   read);
>>>> +	}
>>>> +
>>>> +	return ret ? ret : count;
>>>> +}
>>>> +
>>>> +static bool range_intersect_range(loff_t range1_start, size_t count1,
>>>> +				  loff_t range2_start, size_t count2,
>>>> +				  loff_t *start_offset,
>>>> +				  size_t *intersect_count,
>>>> +				  size_t *register_offset)
>>>> +{
>>>> +	if (range1_start <= range2_start &&
>>>> +	    range1_start + count1 > range2_start) {
>>>> +		*start_offset = range2_start - range1_start;
>>>> +		*intersect_count = min_t(size_t, count2,
>>>> +					 range1_start + count1 - range2_start);
>>>> +		if (register_offset)
>>>> +			*register_offset = 0;
>>>> +		return true;
>>>> +	}
>>>> +
>>>> +	if (range1_start > range2_start &&
>>>> +	    range1_start < range2_start + count2) {
>>>> +		*start_offset = range1_start;
>>>> +		*intersect_count = min_t(size_t, count1,
>>>> +					 range2_start + count2 - range1_start);
>>>> +		if (register_offset)
>>>> +			*register_offset = range1_start - range2_start;
>>>> +		return true;
>>>> +	}
>>> Seems like we're missing a case, and some documentation.
>>>
>>> The first test requires range1 to fully enclose range2 and provides the
>>> offset of range2 within range1 and the length of the intersection.
>>>
>>> The second test requires range1 to start from a non-zero offset within
>>> range2 and returns the absolute offset of range1 and the length of the
>>> intersection.
>>>
>>> The register offset is then non-zero offset of range1 into range2.  So
>>> does the caller use the zero value in the previous test to know range2
>>> exists within range1?
>>>
>>> We miss the cases where range1_start is <= range2_start and range1
>>> terminates within range2.
>> The first test should cover this case as well of the case of fully
>> enclosing.
>>
>> It checks whether range1_start + count1 > range2_start which can
>> terminates also within range2.
>>
>> Isn't it ?
> Hmm, maybe I read it wrong.  Let me try again...
>
> The first test covers the cases where range1 starts at or below range2
> and range1 extends into or through range2.  start_offset describes the
> offset into range1 that range2 begins.  The intersect_count is the
> extent of the intersection and it's not clear what register_offset
> describes since it's zero.
>
> The second test covers the cases where range1 starts within range2.
> start_offset is the start of range1, which doesn't seem consistent with
> the previous branch usage.

Right, start_offest needs to be 0 in that second branch.


>   The intersect_count does look consistent
> with the previous branch.  register_offset is then the offset of range1
> into range2
>
> So I had some things wrong, but I'm still having trouble with a
> consistent definition of start_offset and register_offset.
>
>
>> I may add some documentation for that function as part of V2 as you asked.
>>
>>>    I suppose we'll see below how this is used,
>>> but it seems asymmetric and incomplete.
>>>   
>>>> +
>>>> +	return false;
>>>> +}
>>>> +
>>>> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>>>> +					char __user *buf, size_t count,
>>>> +					loff_t *ppos)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>>> +	size_t register_offset;
>>>> +	loff_t copy_offset;
>>>> +	size_t copy_count;
>>>> +	__le32 val32;
>>>> +	__le16 val16;
>>>> +	u8 val8;
>>>> +	int ret;
>>>> +
>>>> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
>>>> +				  &copy_offset, &copy_count, NULL)) {
>>> If a user does 'setpci -s x:00.0 2.b' (range1 <= range2, but terminates
>>> within range2) they'll not enter this branch and see 41 rather than 00.
> Yes, this does take the first branch per my second look, so copy_offset
> is zero, copy_count is 1.  I think the copy_to_user() works correctly
>
>>> If a user does 'setpci -s x:00.0 3.b' (range1 > range2, range 1
>>> contained within range 2), the above function returns a copy_offset of
>>> range1_start (ie. 3).  But that offset is applied to the buffer, which
>>> is out of bounds.  The function needs to have returned an offset of 1
>>> and it should have applied to the val16 address.
>>>
>>> I don't think this works like it's intended.
>> Is that because of the missing case ?
>> Please see my note above.
> No, I think my original evaluation of this second case still holds,
> copy_offset is wrong.  I suspect what you're trying to do with
> start_offset and register_offset is specify the output buffer offset,
> ie. relative to range1 or buf, or the input offset, ie. range2 or our
> local val variable.  But start_offset is incorrectly calculated in the
> second branch above (should always be zero) and the caller didn't ask
> for the register offset here, which is seems it always should.

OK,  I got what you said.

Yes, start_offset should always be 0 in the second branch, and the 
caller may need always to ask for the register_offest and use it.

As current QEMU code doesn't read partial register/field we didn't get 
to the second branch and to the above issues.

I will fix as part of V2, it should be a simple change.

>
>>>> +		val16 = cpu_to_le16(0x1000);
>>> Please #define this somewhere rather than hiding a magic value here.
>> Sure, will just replace to VIRTIO_TRANS_ID_NET.
>>>> +		if (copy_to_user(buf + copy_offset, &val16, copy_count))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	if ((virtvdev->pci_cmd & PCI_COMMAND_IO) &&
>>>> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
>>>> +				  &copy_offset, &copy_count, &register_offset)) {
>>>> +		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
>>>> +				   copy_count))
>>>> +			return -EFAULT;
>>>> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
>>>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
>>>> +				 copy_count))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
>>>> +				  &copy_offset, &copy_count, NULL)) {
>>>> +		/* Transional needs to have revision 0 */
>>>> +		val8 = 0;
>>>> +		if (copy_to_user(buf + copy_offset, &val8, copy_count))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
>>>> +				  &copy_offset, &copy_count, NULL)) {
>>>> +		val32 = cpu_to_le32(PCI_BASE_ADDRESS_SPACE_IO);
>>> I'd still like to see the remainder of the BAR follow the semantics
>>> vfio-pci does.  I think this requires a __le32 bar0 field on the
>>> virtvdev struct to store writes and the read here would mask the lower
>>> bits up to the BAR size and OR in the IO indicator bit.
>> OK, will do.
>>
>>>   
>>>> +		if (copy_to_user(buf + copy_offset, &val32, copy_count))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
>>>> +				  &copy_offset, &copy_count, NULL)) {
>>>> +		/*
>>>> +		 * Transitional devices use the PCI subsystem device id as
>>>> +		 * virtio device id, same as legacy driver always did.
>>> Where did we require the subsystem vendor ID to be 0x1af4?  This
>>> subsystem device ID really only makes since given that subsystem
>>> vendor ID, right?  Otherwise I don't see that non-transitional devices,
>>> such as the VF, have a hard requirement per the spec for the subsystem
>>> vendor ID.
>>>
>>> Do we want to make this only probe the correct subsystem vendor ID or do
>>> we want to emulate the subsystem vendor ID as well?  I don't see this is
>>> correct without one of those options.
>> Looking in the 1.x spec we can see the below.
>>
>> Legacy Interfaces: A Note on PCI Device Discovery
>>
>> "Transitional devices MUST have the PCI Subsystem
>> Device ID matching the Virtio Device ID, as indicated in section 5 ...
>> This is to match legacy drivers."
>>
>> However, there is no need to enforce Subsystem Vendor ID.
>>
>> This is what we followed here.
>>
>> Makes sense ?
> So do I understand correctly that virtio dictates the subsystem device
> ID for all subsystem vendor IDs that implement a legacy virtio
> interface?  Ok, but this device didn't actually implement a legacy
> virtio interface.  The device itself is not tranistional, we're imposing
> an emulated transitional interface onto it.  So did the subsystem vendor
> agree to have their subsystem device ID managed by the virtio committee
> or might we create conflicts?  I imagine we know we don't have a
> conflict if we also virtualize the subsystem vendor ID.
>
The non transitional net device in the virtio spec defined as the below 
tuple.
T_A: VID=0x1AF4, DID=0x1040, Subsys_VID=FOO, Subsys_DID=0x40.

And transitional net device in the virtio spec for a vendor FOO is 
defined as:
T_B: VID=0x1AF4,DID=0x1000,Subsys_VID=FOO, subsys_DID=0x1

This driver is converting T_A to T_B, which both are defined by the 
virtio spec.
Hence, it does not conflict for the subsystem vendor, it is fine.
> BTW, it would be a lot easier for all of the config space emulation here
> if we could make use of the existing field virtualization in
> vfio-pci-core.  In fact you'll see in vfio_config_init() that
> PCI_DEVICE_ID is already virtualized for VFs, so it would be enough to
> simply do the following to report the desired device ID:
>
> 	*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(0x1000);

I would prefer keeping things simple and have one place/flow that 
handles all the fields as we have now as part of the driver.

In any case, I'll further look at that option for managing the DEVICE_ID 
towards V2.

> It appears everything in this function could be handled similarly by
> vfio-pci-core if the right fields in the perm_bits.virt and .write
> bits could be manipulated and vconfig modified appropriately.  I'd look
> for a way that a variant driver could provide an alternate set of
> permissions structures for various capabilities.  Thanks,

OK

However, let's not block V2 and the series acceptance as of that.

It can always be some future refactoring as part of other series that 
will bring the infra-structure that is needed for that.

Yishai

>
> Alex
>
>
>>>> +		 */
>>>> +		val16 = cpu_to_le16(VIRTIO_ID_NET);
>>>> +		if (copy_to_user(buf + copy_offset, &val16, copy_count))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	return count;
>>>> +}
>>>> +
>>>> +static ssize_t
>>>> +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
>>>> +		       size_t count, loff_t *ppos)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>>>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>>>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>>> +	int ret;
>>>> +
>>>> +	if (!count)
>>>> +		return 0;
>>>> +
>>>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
>>>> +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
>>>> +
>>>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>>>> +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
>>>> +
>>>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>>>> +	if (ret) {
>>>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
>>>> +				     ret);
>>>> +		return -EIO;
>>>> +	}
>>>> +
>>>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
>>>> +	pm_runtime_put(&pdev->dev);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static ssize_t
>>>> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
>>>> +			size_t count, loff_t *ppos)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>>>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>>>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>>> +	int ret;
>>>> +
>>>> +	if (!count)
>>>> +		return 0;
>>>> +
>>>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
>>>> +		size_t register_offset;
>>>> +		loff_t copy_offset;
>>>> +		size_t copy_count;
>>>> +
>>>> +		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
>>>> +					  &copy_offset, &copy_count,
>>>> +					  &register_offset)) {
>>>> +			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
>>>> +					   buf + copy_offset,
>>>> +					   copy_count))
>>>> +				return -EFAULT;
>>>> +		}
>>>> +
>>>> +		if (range_intersect_range(pos, count, pdev->msix_cap + PCI_MSIX_FLAGS,
>>>> +					  sizeof(virtvdev->msix_ctrl),
>>>> +					  &copy_offset, &copy_count,
>>>> +					  &register_offset)) {
>>>> +			if (copy_from_user((void *)&virtvdev->msix_ctrl + register_offset,
>>>> +					   buf + copy_offset,
>>>> +					   copy_count))
>>>> +				return -EFAULT;
>>>> +		}
>>> MSI-X is setup via ioctl, so you're relying on a userspace that writes
>>> through the control register bit even though it doesn't do anything.
>>> Why not use vfio_pci_core_device.irq_type to track if MSI-X mode is
>>> enabled?
>> OK, may switch to your suggestion post of testing it.
>>>   
>>>> +	}
>>>> +
>>>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>>>> +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
>>>> +
>>>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>>>> +	if (ret) {
>>>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
>>>> +		return -EIO;
>>>> +	}
>>>> +
>>>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
>>>> +	pm_runtime_put(&pdev->dev);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int
>>>> +virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>>>> +				   unsigned int cmd, unsigned long arg)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
>>>> +	void __user *uarg = (void __user *)arg;
>>>> +	struct vfio_region_info info = {};
>>>> +
>>>> +	if (copy_from_user(&info, uarg, minsz))
>>>> +		return -EFAULT;
>>>> +
>>>> +	if (info.argsz < minsz)
>>>> +		return -EINVAL;
>>>> +
>>>> +	switch (info.index) {
>>>> +	case VFIO_PCI_BAR0_REGION_INDEX:
>>>> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>>>> +		info.size = virtvdev->bar0_virtual_buf_size;
>>>> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
>>>> +			     VFIO_REGION_INFO_FLAG_WRITE;
>>>> +		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
>>>> +	default:
>>>> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>>> +	}
>>>> +}
>>>> +
>>>> +static long
>>>> +virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>>> +			     unsigned long arg)
>>>> +{
>>>> +	switch (cmd) {
>>>> +	case VFIO_DEVICE_GET_REGION_INFO:
>>>> +		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
>>>> +	default:
>>>> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>>>> +	}
>>>> +}
>>>> +
>>>> +static int
>>>> +virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
>>>> +{
>>>> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
>>>> +	int ret;
>>>> +
>>>> +	/*
>>>> +	 * Setup the BAR where the 'notify' exists to be used by vfio as well
>>>> +	 * This will let us mmap it only once and use it when needed.
>>>> +	 */
>>>> +	ret = vfio_pci_core_setup_barmap(core_device,
>>>> +					 virtvdev->notify_bar);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
>>>> +			virtvdev->notify_offset;
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
>>>> +	int ret;
>>>> +
>>>> +	ret = vfio_pci_core_enable(vdev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	if (virtvdev->bar0_virtual_buf) {
>>>> +		/*
>>>> +		 * Upon close_device() the vfio_pci_core_disable() is called
>>>> +		 * and will close all the previous mmaps, so it seems that the
>>>> +		 * valid life cycle for the 'notify' addr is per open/close.
>>>> +		 */
>>>> +		ret = virtiovf_set_notify_addr(virtvdev);
>>>> +		if (ret) {
>>>> +			vfio_pci_core_disable(vdev);
>>>> +			return ret;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	vfio_pci_core_finish_enable(vdev);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int virtiovf_get_device_config_size(unsigned short device)
>>>> +{
>>>> +	/* Network card */
>>>> +	return offsetofend(struct virtio_net_config, status);
>>>> +}
>>>> +
>>>> +static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
>>>> +{
>>>> +	u64 offset;
>>>> +	int ret;
>>>> +	u8 bar;
>>>> +
>>>> +	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
>>>> +				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
>>>> +				&bar, &offset);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	virtvdev->notify_bar = bar;
>>>> +	virtvdev->notify_offset = offset;
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	struct pci_dev *pdev;
>>>> +	int ret;
>>>> +
>>>> +	ret = vfio_pci_core_init_dev(core_vdev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	pdev = virtvdev->core_device.pdev;
>>>> +	ret = virtiovf_read_notify_info(virtvdev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	/* Being ready with a buffer that supports MSIX */
>>>> +	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
>>>> +				virtiovf_get_device_config_size(pdev->device);
>>>> +	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
>>>> +					     GFP_KERNEL);
>>>> +	if (!virtvdev->bar0_virtual_buf)
>>>> +		return -ENOMEM;
>>>> +	mutex_init(&virtvdev->bar_mutex);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +
>>>> +	kfree(virtvdev->bar0_virtual_buf);
>>>> +	vfio_pci_core_release_dev(core_vdev);
>>>> +}
>>>> +
>>>> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
>>>> +	.name = "virtio-transitional-vfio-pci",
>>>> +	.init = virtiovf_pci_init_device,
>>>> +	.release = virtiovf_pci_core_release_dev,
>>>> +	.open_device = virtiovf_pci_open_device,
>>>> +	.close_device = vfio_pci_core_close_device,
>>>> +	.ioctl = virtiovf_vfio_pci_core_ioctl,
>>>> +	.read = virtiovf_pci_core_read,
>>>> +	.write = virtiovf_pci_core_write,
>>>> +	.mmap = vfio_pci_core_mmap,
>>>> +	.request = vfio_pci_core_request,
>>>> +	.match = vfio_pci_core_match,
>>>> +	.bind_iommufd = vfio_iommufd_physical_bind,
>>>> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
>>>> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
>>>> +};
>>>> +
>>>> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_ops = {
>>>> +	.name = "virtio-acc-vfio-pci",
>>>> +	.init = vfio_pci_core_init_dev,
>>>> +	.release = vfio_pci_core_release_dev,
>>>> +	.open_device = virtiovf_pci_open_device,
>>>> +	.close_device = vfio_pci_core_close_device,
>>>> +	.ioctl = vfio_pci_core_ioctl,
>>>> +	.device_feature = vfio_pci_core_ioctl_feature,
>>>> +	.read = vfio_pci_core_read,
>>>> +	.write = vfio_pci_core_write,
>>>> +	.mmap = vfio_pci_core_mmap,
>>>> +	.request = vfio_pci_core_request,
>>>> +	.match = vfio_pci_core_match,
>>>> +	.bind_iommufd = vfio_iommufd_physical_bind,
>>>> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
>>>> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
>>>> +};
>>>> +
>>>> +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
>>>> +{
>>>> +	struct resource *res = pdev->resource;
>>>> +
>>>> +	return res->flags ? true : false;
>>>> +}
>>>> +
>>>> +#define VIRTIOVF_USE_ADMIN_CMD_BITMAP \
>>>> +	(BIT_ULL(VIRTIO_ADMIN_CMD_LIST_QUERY) | \
>>>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LIST_USE) | \
>>>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
>>>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
>>>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
>>>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>>>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>>>> +
>>>> +static bool virtiovf_support_legacy_access(struct pci_dev *pdev)
>>>> +{
>>>> +	int buf_size = DIV_ROUND_UP(VIRTIO_ADMIN_MAX_CMD_OPCODE, 64) * 8;
>>>> +	u8 *buf;
>>>> +	int ret;
>>>> +
>>>> +	buf = kzalloc(buf_size, GFP_KERNEL);
>>>> +	if (!buf)
>>>> +		return false;
>>>> +
>>>> +	ret = virtio_pci_admin_list_query(pdev, buf, buf_size);
>>>> +	if (ret)
>>>> +		goto end;
>>>> +
>>>> +	if ((le64_to_cpup((__le64 *)buf) & VIRTIOVF_USE_ADMIN_CMD_BITMAP) !=
>>>> +		VIRTIOVF_USE_ADMIN_CMD_BITMAP) {
>>>> +		ret = -EOPNOTSUPP;
>>>> +		goto end;
>>>> +	}
>>>> +
>>>> +	/* Confirm the used commands */
>>>> +	memset(buf, 0, buf_size);
>>>> +	*(__le64 *)buf = cpu_to_le64(VIRTIOVF_USE_ADMIN_CMD_BITMAP);
>>>> +	ret = virtio_pci_admin_list_use(pdev, buf, buf_size);
>>>> +end:
>>>> +	kfree(buf);
>>>> +	return ret ? false : true;
>>>> +}
>>>> +
>>>> +static int virtiovf_pci_probe(struct pci_dev *pdev,
>>>> +			      const struct pci_device_id *id)
>>>> +{
>>>> +	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
>>>> +	struct virtiovf_pci_core_device *virtvdev;
>>>> +	int ret;
>>>> +
>>>> +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
>>>> +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
>>> All but the last test here are fairly evident requirements of the
>>> driver.  Why do we require a device that supports MSI-X?
>> As now we check at run time to decide whether MSI-X is enabled/disabled
>> to pick-up the correct op code, no need for that any more.
>>
>> Will drop this MSI-X check from V2.
>>
>> Thanks,
>> Yishai
>>
>>> Thanks,
>>> Alex
>>>
>>>   
>>>> +		ops = &virtiovf_acc_vfio_pci_tran_ops;
>>>> +
>>>> +	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
>>>> +				     &pdev->dev, ops);
>>>> +	if (IS_ERR(virtvdev))
>>>> +		return PTR_ERR(virtvdev);
>>>> +
>>>> +	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
>>>> +	ret = vfio_pci_core_register_device(&virtvdev->core_device);
>>>> +	if (ret)
>>>> +		goto out;
>>>> +	return 0;
>>>> +out:
>>>> +	vfio_put_device(&virtvdev->core_device.vdev);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static void virtiovf_pci_remove(struct pci_dev *pdev)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
>>>> +
>>>> +	vfio_pci_core_unregister_device(&virtvdev->core_device);
>>>> +	vfio_put_device(&virtvdev->core_device.vdev);
>>>> +}
>>>> +
>>>> +static const struct pci_device_id virtiovf_pci_table[] = {
>>>> +	/* Only virtio-net is supported/tested so far */
>>>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
>>>> +	{}
>>>> +};
>>>> +
>>>> +MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
>>>> +
>>>> +static struct pci_driver virtiovf_pci_driver = {
>>>> +	.name = KBUILD_MODNAME,
>>>> +	.id_table = virtiovf_pci_table,
>>>> +	.probe = virtiovf_pci_probe,
>>>> +	.remove = virtiovf_pci_remove,
>>>> +	.err_handler = &vfio_pci_core_err_handlers,
>>>> +	.driver_managed_dma = true,
>>>> +};
>>>> +
>>>> +module_pci_driver(virtiovf_pci_driver);
>>>> +
>>>> +MODULE_LICENSE("GPL");
>>>> +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
>>>> +MODULE_DESCRIPTION(
>>>> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO device family");
>>

