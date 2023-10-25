Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709F87D6F1C
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344669AbjJYOgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjJYOgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:36:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7E9DC
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:36:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+3fs61Rstilbz4h+D35bqaYf4NAG/24kyObiUnuU+0Dz5dxhHKzB3EHeN+AGGHfHz5xLeEKopYLQWpYSfrxVvmw+5C0g/fmUKFWbKbfXvbfT2X54nJRuvcN8elL4yJgtr8Ni698IOWtYp9N+d8GcALhc2W64bGYwJnI4QCqKq6G15a6jBFjP3TExosewjZBE70e5tkwQB4Fks9XMj71Wpn0h8BNxtBWAEhzFokXpwXJOVfw4+A2CvxeTHl5Di/T/Gh4SpsuDmT2WMc/o6a6BWDhKgeEf2x5xvDsauMpJlV/NdbtsT0cq81pwNgUWTMQQEGFxVpK+bwA8J25CFFBjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ2cm8WsBAAvIRcZMxnfpnp+Yx/S8Xvx8JewkIr2ZtM=;
 b=bsDFl3nYdYR4nfA4+uWNR3WJbFz5lkkkHYr2qEN8gM1OiXNoXl76ZEUfHWEmQlQq23YfLAGF4vlv2Y7A5TsNO8NF+EovcYLI05kKygoYVM5izlnTpmDoV8EJDkySDKuihnBlnQ2RBMztpjhE86f4K1L5jeTF/gqLVGk+5Maf0As2Rl3+k5X62ImkCCR6GiAxDtCqLApjAxvywSJXtKtFt75jPhbBaZziPNC4fbHnNXInv+V5ia/JCwiFkrQ3bGZ1Y9LNRFZjofmvePjKLn+tHBfrSIkTFPZ3AC5c8Gy60qbFdlK8T5ozw+ne7kwHHO2wKQpvGHSDj2KwISTLQbh4yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ2cm8WsBAAvIRcZMxnfpnp+Yx/S8Xvx8JewkIr2ZtM=;
 b=GDYvsELvqT8f47aYhFJ7urq3zZKEcZVrPFZHU5xLFusqbiVoIev6D0sN99Y+JllAl7XspT3H39t57QTfuWpq9MvACnmDySd8OV1CdiqprHFS+p4BkiEh9c2PJI/cDOoelAFYo3aSKgKmN9QZ0YnyyCsJvo4ZPg8Jo+0TKrGTvkT4ceLlZEnK6X9/sBeJuYRz25QTwiWKUnPG1tvjZ+c5snF0kAZtrSxc26oyj9CC52SKYhiResujpxfBsMIoe39asKS0KEE+Da1EdUHpUsjiDYuuEFgN8AF60uH60l9MlOuQ/bnadW/1m1mtPebtDqu1uX+CHrGxjTwacmNpyd45dA==
Received: from MN2PR06CA0002.namprd06.prod.outlook.com (2603:10b6:208:23d::7)
 by SJ0PR12MB6991.namprd12.prod.outlook.com (2603:10b6:a03:47c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 14:36:10 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::c7) by MN2PR06CA0002.outlook.office365.com
 (2603:10b6:208:23d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19 via Frontend
 Transport; Wed, 25 Oct 2023 14:36:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Wed, 25 Oct 2023 14:36:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 07:35:57 -0700
Received: from [172.27.14.159] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 07:35:53 -0700
Message-ID: <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
Date:   Wed, 25 Oct 2023 17:35:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231024135713.360c2980.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|SJ0PR12MB6991:EE_
X-MS-Office365-Filtering-Correlation-Id: be4871a7-c7c2-4ed2-4405-08dbd567bb16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zHZUWgOmzYiY3i20lcJsqBfMs4zu8lg6ERTRvqD4YzuxjHN0d8S9Ed0NtheigQRmVMUGLEbooh0UyM/rN31J09yjGmbJkpH5UAVNGOaP8MeKXJa4FXHVCQdiaU+HLP5Zk+R42oj5gzWCVgqg5i2QPW3ZlHzguzhVnsmv83dHdS/Q4O1DqbkFgLNmElwc0mmoA2k9lDfen9DVXBZHt5borCCgIcODyjiwg8k1sWNdNCd9Vkc9ruyoJC62ciL+99I7wAQv+CS83y1ZpiITkMXlRy+CM7v6p/Yw4bxR18Z/BvtDmtFM4P/MkLh2iHga1SlQTbEQFXyXJNQjI1TmQO3T2OGh2cIYbRU5ieJfcCdEMIMVCzB1p4o1WCDA1VfI8qBVUm1/ooE2LYtIl5nVUCZrjJ4x5ssBywrI06mrdyjHL+mz8u9nBBwsVMclqhJZQTbbQVV0MgTcN9z6o1mQ9Gh13XbegQW+HDA7m2GUioYyjfnQO4Wv9YI3ayZAqacCLBQILcbTsoWAPVgwfPq8B2DtdDfg1CW/agRm3hzpu1MTclJQaZPrK7rFQu+rGBSrpac5p4GUAWmPz6hKvNmuo+8JP7nJNYGsMdEl6OoxEL4hOvI8J63eecMMI8/gYgivlWjrp/NLJf0hHXOhz1kRt0awf/X1WQ8LdOTZz6Fh0OENj9l7cBWMHwKXgoeA+XrKdFuYfj4m4xIwnLYfuf+JxDGSY6UBjZBKMdH4kbf+hiSBNRyQMw8A5WdWLeqoBHYfY5fnsgEB9G3ZseU/eBjGLDZclcPtdL7hu5wtLvFJ4Oi9HdSGcXro17ArP6gSuMWmxNEc
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(136003)(346002)(230922051799003)(451199024)(64100799003)(82310400011)(186009)(1800799009)(40470700004)(46966006)(36840700001)(7636003)(31696002)(40480700001)(107886003)(83380400001)(2616005)(82740400003)(16526019)(26005)(53546011)(426003)(336012)(356005)(36860700001)(16576012)(2906002)(30864003)(316002)(966005)(41300700001)(4326008)(478600001)(70206006)(8936002)(8676002)(70586007)(47076005)(6916009)(5660300002)(54906003)(40460700003)(86362001)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 14:36:09.8172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be4871a7-c7c2-4ed2-4405-08dbd567bb16
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6991
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 22:57, Alex Williamson wrote:
> On Tue, 17 Oct 2023 16:42:17 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Introduce a vfio driver over virtio devices to support the legacy
>> interface functionality for VFs.
>>
>> Background, from the virtio spec [1].
>> --------------------------------------------------------------------
>> In some systems, there is a need to support a virtio legacy driver with
>> a device that does not directly support the legacy interface. In such
>> scenarios, a group owner device can provide the legacy interface
>> functionality for the group member devices. The driver of the owner
>> device can then access the legacy interface of a member device on behalf
>> of the legacy member device driver.
>>
>> For example, with the SR-IOV group type, group members (VFs) can not
>> present the legacy interface in an I/O BAR in BAR0 as expected by the
>> legacy pci driver. If the legacy driver is running inside a virtual
>> machine, the hypervisor executing the virtual machine can present a
>> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
>> legacy driver accesses to this I/O BAR and forwards them to the group
>> owner device (PF) using group administration commands.
>> --------------------------------------------------------------------
>>
>> Specifically, this driver adds support for a virtio-net VF to be exposed
>> as a transitional device to a guest driver and allows the legacy IO BAR
>> functionality on top.
>>
>> This allows a VM which uses a legacy virtio-net driver in the guest to
>> work transparently over a VF which its driver in the host is that new
>> driver.
>>
>> The driver can be extended easily to support some other types of virtio
>> devices (e.g virtio-blk), by adding in a few places the specific type
>> properties as was done for virtio-net.
>>
>> For now, only the virtio-net use case was tested and as such we introduce
>> the support only for such a device.
>>
>> Practically,
>> Upon probing a VF for a virtio-net device, in case its PF supports
>> legacy access over the virtio admin commands and the VF doesn't have BAR
>> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
>> transitional device with I/O BAR in BAR 0.
>>
>> The existence of the simulated I/O bar is reported later on by
>> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
>> exposes itself as a transitional device by overwriting some properties
>> upon reading its config space.
>>
>> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
>> guest may use it via read/write calls according to the virtio
>> specification.
>>
>> Any read/write towards the control parts of the BAR will be captured by
>> the new driver and will be translated into admin commands towards the
>> device.
>>
>> Any data path read/write access (i.e. virtio driver notifications) will
>> be forwarded to the physical BAR which its properties were supplied by
>> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
>> probing/init flow.
>>
>> With that code in place a legacy driver in the guest has the look and
>> feel as if having a transitional device with legacy support for both its
>> control and data path flows.
>>
>> [1]
>> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   MAINTAINERS                      |   7 +
>>   drivers/vfio/pci/Kconfig         |   2 +
>>   drivers/vfio/pci/Makefile        |   2 +
>>   drivers/vfio/pci/virtio/Kconfig  |  15 +
>>   drivers/vfio/pci/virtio/Makefile |   4 +
>>   drivers/vfio/pci/virtio/main.c   | 577 +++++++++++++++++++++++++++++++
>>   6 files changed, 607 insertions(+)
>>   create mode 100644 drivers/vfio/pci/virtio/Kconfig
>>   create mode 100644 drivers/vfio/pci/virtio/Makefile
>>   create mode 100644 drivers/vfio/pci/virtio/main.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7a7bd8bd80e9..680a70063775 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22620,6 +22620,13 @@ L:	kvm@vger.kernel.org
>>   S:	Maintained
>>   F:	drivers/vfio/pci/mlx5/
>>   
>> +VFIO VIRTIO PCI DRIVER
>> +M:	Yishai Hadas <yishaih@nvidia.com>
>> +L:	kvm@vger.kernel.org
>> +L:	virtualization@lists.linux-foundation.org
>> +S:	Maintained
>> +F:	drivers/vfio/pci/virtio
>> +
>>   VFIO PCI DEVICE SPECIFIC DRIVERS
>>   R:	Jason Gunthorpe <jgg@nvidia.com>
>>   R:	Yishai Hadas <yishaih@nvidia.com>
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index 8125e5f37832..18c397df566d 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>>   
>>   source "drivers/vfio/pci/pds/Kconfig"
>>   
>> +source "drivers/vfio/pci/virtio/Kconfig"
>> +
>>   endmenu
>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>> index 45167be462d8..046139a4eca5 100644
>> --- a/drivers/vfio/pci/Makefile
>> +++ b/drivers/vfio/pci/Makefile
>> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>>   obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>>   
>>   obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>> +
>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
>> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
>> new file mode 100644
>> index 000000000000..89eddce8b1bd
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/Kconfig
>> @@ -0,0 +1,15 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +config VIRTIO_VFIO_PCI
>> +        tristate "VFIO support for VIRTIO PCI devices"
>> +        depends on VIRTIO_PCI
>> +        select VFIO_PCI_CORE
>> +        help
>> +          This provides support for exposing VIRTIO VF devices using the VFIO
>> +          framework that can work with a legacy virtio driver in the guest.
>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
>> +          not indicate I/O Space.
>> +          As of that this driver emulated I/O BAR in software to let a VF be
>> +          seen as a transitional device in the guest and let it work with
>> +          a legacy driver.
> This description is a little bit subtle to the hard requirements on the
> device.  Reading this, one might think that this should work for any
> SR-IOV VF virtio device, when in reality it only support virtio-net
> currently and places a number of additional requirements on the device
> (ex. legacy access and MSI-X support).

Sure, will change to refer only to virtio-net devices which are capable 
for 'legacy access'.

No need to refer to MSI-X, please see below.

>
>> +
>> +          If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
>> new file mode 100644
>> index 000000000000..2039b39fb723
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/Makefile
>> @@ -0,0 +1,4 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
>> +virtio-vfio-pci-y := main.o
>> +
>> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
>> new file mode 100644
>> index 000000000000..3fef4b21f7e6
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/main.c
>> @@ -0,0 +1,577 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/pci.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/types.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/vfio.h>
>> +#include <linux/vfio_pci_core.h>
>> +#include <linux/virtio_pci.h>
>> +#include <linux/virtio_net.h>
>> +#include <linux/virtio_pci_admin.h>
>> +
>> +struct virtiovf_pci_core_device {
>> +	struct vfio_pci_core_device core_device;
>> +	u8 bar0_virtual_buf_size;
>> +	u8 *bar0_virtual_buf;
>> +	/* synchronize access to the virtual buf */
>> +	struct mutex bar_mutex;
>> +	void __iomem *notify_addr;
>> +	u32 notify_offset;
>> +	u8 notify_bar;
> Push the above u8 to the end of the structure for better packing.
OK
>> +	u16 pci_cmd;
>> +	u16 msix_ctrl;
>> +};
>> +
>> +static int
>> +virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
>> +			     loff_t pos, char __user *buf,
>> +			     size_t count, bool read)
>> +{
>> +	bool msix_enabled = virtvdev->msix_ctrl & PCI_MSIX_FLAGS_ENABLE;
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
>> +	u16 opcode;
>> +	int ret;
>> +
>> +	mutex_lock(&virtvdev->bar_mutex);
>> +	if (read) {
>> +		opcode = (pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled)) ?
>> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ :
>> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ;
>> +		ret = virtio_pci_admin_legacy_io_read(pdev, opcode, pos, count,
>> +						      bar0_buf + pos);
>> +		if (ret)
>> +			goto out;
>> +		if (copy_to_user(buf, bar0_buf + pos, count))
>> +			ret = -EFAULT;
>> +		goto out;
>> +	}
> TBH, I think the symmetry of read vs write would be more apparent if
> this were an else branch.
OK, will do.
>> +
>> +	if (copy_from_user(bar0_buf + pos, buf, count)) {
>> +		ret = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	opcode = (pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled)) ?
>> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE :
>> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE;
>> +	ret = virtio_pci_admin_legacy_io_write(pdev, opcode, pos, count,
>> +					       bar0_buf + pos);
>> +out:
>> +	mutex_unlock(&virtvdev->bar_mutex);
>> +	return ret;
>> +}
>> +
>> +static int
>> +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
>> +			    loff_t pos, char __user *buf,
>> +			    size_t count, bool read)
>> +{
>> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
>> +	u16 queue_notify;
>> +	int ret;
>> +
>> +	if (pos + count > virtvdev->bar0_virtual_buf_size)
>> +		return -EINVAL;
>> +
>> +	switch (pos) {
>> +	case VIRTIO_PCI_QUEUE_NOTIFY:
>> +		if (count != sizeof(queue_notify))
>> +			return -EINVAL;
>> +		if (read) {
>> +			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
>> +						virtvdev->notify_addr);
>> +			if (ret)
>> +				return ret;
>> +			if (copy_to_user(buf, &queue_notify,
>> +					 sizeof(queue_notify)))
>> +				return -EFAULT;
>> +			break;
>> +		}
> Same.
OK
>> +
>> +		if (copy_from_user(&queue_notify, buf, count))
>> +			return -EFAULT;
>> +
>> +		ret = vfio_pci_iowrite16(core_device, true, queue_notify,
>> +					 virtvdev->notify_addr);
>> +		break;
>> +	default:
>> +		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
>> +						   read);
>> +	}
>> +
>> +	return ret ? ret : count;
>> +}
>> +
>> +static bool range_intersect_range(loff_t range1_start, size_t count1,
>> +				  loff_t range2_start, size_t count2,
>> +				  loff_t *start_offset,
>> +				  size_t *intersect_count,
>> +				  size_t *register_offset)
>> +{
>> +	if (range1_start <= range2_start &&
>> +	    range1_start + count1 > range2_start) {
>> +		*start_offset = range2_start - range1_start;
>> +		*intersect_count = min_t(size_t, count2,
>> +					 range1_start + count1 - range2_start);
>> +		if (register_offset)
>> +			*register_offset = 0;
>> +		return true;
>> +	}
>> +
>> +	if (range1_start > range2_start &&
>> +	    range1_start < range2_start + count2) {
>> +		*start_offset = range1_start;
>> +		*intersect_count = min_t(size_t, count1,
>> +					 range2_start + count2 - range1_start);
>> +		if (register_offset)
>> +			*register_offset = range1_start - range2_start;
>> +		return true;
>> +	}
> Seems like we're missing a case, and some documentation.
>
> The first test requires range1 to fully enclose range2 and provides the
> offset of range2 within range1 and the length of the intersection.
>
> The second test requires range1 to start from a non-zero offset within
> range2 and returns the absolute offset of range1 and the length of the
> intersection.
>
> The register offset is then non-zero offset of range1 into range2.  So
> does the caller use the zero value in the previous test to know range2
> exists within range1?
>
> We miss the cases where range1_start is <= range2_start and range1
> terminates within range2.

The first test should cover this case as well of the case of fully 
enclosing.

It checks whether range1_start + count1 > range2_start which can 
terminates also within range2.

Isn't it ?

I may add some documentation for that function as part of V2 as you asked.

>   I suppose we'll see below how this is used,
> but it seems asymmetric and incomplete.
>
>> +
>> +	return false;
>> +}
>> +
>> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>> +					char __user *buf, size_t count,
>> +					loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	size_t register_offset;
>> +	loff_t copy_offset;
>> +	size_t copy_count;
>> +	__le32 val32;
>> +	__le16 val16;
>> +	u8 val8;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
>> +				  &copy_offset, &copy_count, NULL)) {
> If a user does 'setpci -s x:00.0 2.b' (range1 <= range2, but terminates
> within range2) they'll not enter this branch and see 41 rather than 00.
>
> If a user does 'setpci -s x:00.0 3.b' (range1 > range2, range 1
> contained within range 2), the above function returns a copy_offset of
> range1_start (ie. 3).  But that offset is applied to the buffer, which
> is out of bounds.  The function needs to have returned an offset of 1
> and it should have applied to the val16 address.
>
> I don't think this works like it's intended.

Is that because of the missing case ?
Please see my note above.

>
>
>> +		val16 = cpu_to_le16(0x1000);
> Please #define this somewhere rather than hiding a magic value here.
Sure, will just replace to VIRTIO_TRANS_ID_NET.
>> +		if (copy_to_user(buf + copy_offset, &val16, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if ((virtvdev->pci_cmd & PCI_COMMAND_IO) &&
>> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
>> +				  &copy_offset, &copy_count, &register_offset)) {
>> +		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
>> +				   copy_count))
>> +			return -EFAULT;
>> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
>> +				 copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
>> +				  &copy_offset, &copy_count, NULL)) {
>> +		/* Transional needs to have revision 0 */
>> +		val8 = 0;
>> +		if (copy_to_user(buf + copy_offset, &val8, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
>> +				  &copy_offset, &copy_count, NULL)) {
>> +		val32 = cpu_to_le32(PCI_BASE_ADDRESS_SPACE_IO);
> I'd still like to see the remainder of the BAR follow the semantics
> vfio-pci does.  I think this requires a __le32 bar0 field on the
> virtvdev struct to store writes and the read here would mask the lower
> bits up to the BAR size and OR in the IO indicator bit.

OK, will do.

>
>
>> +		if (copy_to_user(buf + copy_offset, &val32, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
>> +				  &copy_offset, &copy_count, NULL)) {
>> +		/*
>> +		 * Transitional devices use the PCI subsystem device id as
>> +		 * virtio device id, same as legacy driver always did.
> Where did we require the subsystem vendor ID to be 0x1af4?  This
> subsystem device ID really only makes since given that subsystem
> vendor ID, right?  Otherwise I don't see that non-transitional devices,
> such as the VF, have a hard requirement per the spec for the subsystem
> vendor ID.
>
> Do we want to make this only probe the correct subsystem vendor ID or do
> we want to emulate the subsystem vendor ID as well?  I don't see this is
> correct without one of those options.

Looking in the 1.x spec we can see the below.

Legacy Interfaces: A Note on PCI Device Discovery

"Transitional devices MUST have the PCI Subsystem
Device ID matching the Virtio Device ID, as indicated in section 5 ...
This is to match legacy drivers."

However, there is no need to enforce Subsystem Vendor ID.

This is what we followed here.

Makes sense ?

>> +		 */
>> +		val16 = cpu_to_le16(VIRTIO_ID_NET);
>> +		if (copy_to_user(buf + copy_offset, &val16, copy_count))
>> +			return -EFAULT;
>> +	}
>> +
>> +	return count;
>> +}
>> +
>> +static ssize_t
>> +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
>> +		       size_t count, loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	int ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
>> +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
>> +
>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>> +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
>> +
>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>> +	if (ret) {
>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
>> +				     ret);
>> +		return -EIO;
>> +	}
>> +
>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
>> +	pm_runtime_put(&pdev->dev);
>> +	return ret;
>> +}
>> +
>> +static ssize_t
>> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
>> +			size_t count, loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	int ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
>> +		size_t register_offset;
>> +		loff_t copy_offset;
>> +		size_t copy_count;
>> +
>> +		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
>> +
>> +		if (range_intersect_range(pos, count, pdev->msix_cap + PCI_MSIX_FLAGS,
>> +					  sizeof(virtvdev->msix_ctrl),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev->msix_ctrl + register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
> MSI-X is setup via ioctl, so you're relying on a userspace that writes
> through the control register bit even though it doesn't do anything.
> Why not use vfio_pci_core_device.irq_type to track if MSI-X mode is
> enabled?
OK, may switch to your suggestion post of testing it.
>
>> +	}
>> +
>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>> +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
>> +
>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>> +	if (ret) {
>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
>> +		return -EIO;
>> +	}
>> +
>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
>> +	pm_runtime_put(&pdev->dev);
>> +	return ret;
>> +}
>> +
>> +static int
>> +virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>> +				   unsigned int cmd, unsigned long arg)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
>> +	void __user *uarg = (void __user *)arg;
>> +	struct vfio_region_info info = {};
>> +
>> +	if (copy_from_user(&info, uarg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (info.argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	switch (info.index) {
>> +	case VFIO_PCI_BAR0_REGION_INDEX:
>> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>> +		info.size = virtvdev->bar0_virtual_buf_size;
>> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
>> +			     VFIO_REGION_INFO_FLAG_WRITE;
>> +		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
>> +	default:
>> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>> +	}
>> +}
>> +
>> +static long
>> +virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>> +			     unsigned long arg)
>> +{
>> +	switch (cmd) {
>> +	case VFIO_DEVICE_GET_REGION_INFO:
>> +		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
>> +	default:
>> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>> +	}
>> +}
>> +
>> +static int
>> +virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
>> +{
>> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
>> +	int ret;
>> +
>> +	/*
>> +	 * Setup the BAR where the 'notify' exists to be used by vfio as well
>> +	 * This will let us mmap it only once and use it when needed.
>> +	 */
>> +	ret = vfio_pci_core_setup_barmap(core_device,
>> +					 virtvdev->notify_bar);
>> +	if (ret)
>> +		return ret;
>> +
>> +	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
>> +			virtvdev->notify_offset;
>> +	return 0;
>> +}
>> +
>> +static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_enable(vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (virtvdev->bar0_virtual_buf) {
>> +		/*
>> +		 * Upon close_device() the vfio_pci_core_disable() is called
>> +		 * and will close all the previous mmaps, so it seems that the
>> +		 * valid life cycle for the 'notify' addr is per open/close.
>> +		 */
>> +		ret = virtiovf_set_notify_addr(virtvdev);
>> +		if (ret) {
>> +			vfio_pci_core_disable(vdev);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	vfio_pci_core_finish_enable(vdev);
>> +	return 0;
>> +}
>> +
>> +static int virtiovf_get_device_config_size(unsigned short device)
>> +{
>> +	/* Network card */
>> +	return offsetofend(struct virtio_net_config, status);
>> +}
>> +
>> +static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
>> +{
>> +	u64 offset;
>> +	int ret;
>> +	u8 bar;
>> +
>> +	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
>> +				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
>> +				&bar, &offset);
>> +	if (ret)
>> +		return ret;
>> +
>> +	virtvdev->notify_bar = bar;
>> +	virtvdev->notify_offset = offset;
>> +	return 0;
>> +}
>> +
>> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_init_dev(core_vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	pdev = virtvdev->core_device.pdev;
>> +	ret = virtiovf_read_notify_info(virtvdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Being ready with a buffer that supports MSIX */
>> +	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
>> +				virtiovf_get_device_config_size(pdev->device);
>> +	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
>> +					     GFP_KERNEL);
>> +	if (!virtvdev->bar0_virtual_buf)
>> +		return -ENOMEM;
>> +	mutex_init(&virtvdev->bar_mutex);
>> +	return 0;
>> +}
>> +
>> +static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +
>> +	kfree(virtvdev->bar0_virtual_buf);
>> +	vfio_pci_core_release_dev(core_vdev);
>> +}
>> +
>> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
>> +	.name = "virtio-transitional-vfio-pci",
>> +	.init = virtiovf_pci_init_device,
>> +	.release = virtiovf_pci_core_release_dev,
>> +	.open_device = virtiovf_pci_open_device,
>> +	.close_device = vfio_pci_core_close_device,
>> +	.ioctl = virtiovf_vfio_pci_core_ioctl,
>> +	.read = virtiovf_pci_core_read,
>> +	.write = virtiovf_pci_core_write,
>> +	.mmap = vfio_pci_core_mmap,
>> +	.request = vfio_pci_core_request,
>> +	.match = vfio_pci_core_match,
>> +	.bind_iommufd = vfio_iommufd_physical_bind,
>> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
>> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
>> +};
>> +
>> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_ops = {
>> +	.name = "virtio-acc-vfio-pci",
>> +	.init = vfio_pci_core_init_dev,
>> +	.release = vfio_pci_core_release_dev,
>> +	.open_device = virtiovf_pci_open_device,
>> +	.close_device = vfio_pci_core_close_device,
>> +	.ioctl = vfio_pci_core_ioctl,
>> +	.device_feature = vfio_pci_core_ioctl_feature,
>> +	.read = vfio_pci_core_read,
>> +	.write = vfio_pci_core_write,
>> +	.mmap = vfio_pci_core_mmap,
>> +	.request = vfio_pci_core_request,
>> +	.match = vfio_pci_core_match,
>> +	.bind_iommufd = vfio_iommufd_physical_bind,
>> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
>> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
>> +};
>> +
>> +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
>> +{
>> +	struct resource *res = pdev->resource;
>> +
>> +	return res->flags ? true : false;
>> +}
>> +
>> +#define VIRTIOVF_USE_ADMIN_CMD_BITMAP \
>> +	(BIT_ULL(VIRTIO_ADMIN_CMD_LIST_QUERY) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LIST_USE) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>> +
>> +static bool virtiovf_support_legacy_access(struct pci_dev *pdev)
>> +{
>> +	int buf_size = DIV_ROUND_UP(VIRTIO_ADMIN_MAX_CMD_OPCODE, 64) * 8;
>> +	u8 *buf;
>> +	int ret;
>> +
>> +	buf = kzalloc(buf_size, GFP_KERNEL);
>> +	if (!buf)
>> +		return false;
>> +
>> +	ret = virtio_pci_admin_list_query(pdev, buf, buf_size);
>> +	if (ret)
>> +		goto end;
>> +
>> +	if ((le64_to_cpup((__le64 *)buf) & VIRTIOVF_USE_ADMIN_CMD_BITMAP) !=
>> +		VIRTIOVF_USE_ADMIN_CMD_BITMAP) {
>> +		ret = -EOPNOTSUPP;
>> +		goto end;
>> +	}
>> +
>> +	/* Confirm the used commands */
>> +	memset(buf, 0, buf_size);
>> +	*(__le64 *)buf = cpu_to_le64(VIRTIOVF_USE_ADMIN_CMD_BITMAP);
>> +	ret = virtio_pci_admin_list_use(pdev, buf, buf_size);
>> +end:
>> +	kfree(buf);
>> +	return ret ? false : true;
>> +}
>> +
>> +static int virtiovf_pci_probe(struct pci_dev *pdev,
>> +			      const struct pci_device_id *id)
>> +{
>> +	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
>> +	struct virtiovf_pci_core_device *virtvdev;
>> +	int ret;
>> +
>> +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
>> +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
>
> All but the last test here are fairly evident requirements of the
> driver.  Why do we require a device that supports MSI-X?

As now we check at run time to decide whether MSI-X is enabled/disabled 
to pick-up the correct op code, no need for that any more.

Will drop this MSI-X check from V2.

Thanks,
Yishai

>
> Thanks,
> Alex
>
>
>> +		ops = &virtiovf_acc_vfio_pci_tran_ops;
>> +
>> +	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
>> +				     &pdev->dev, ops);
>> +	if (IS_ERR(virtvdev))
>> +		return PTR_ERR(virtvdev);
>> +
>> +	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
>> +	ret = vfio_pci_core_register_device(&virtvdev->core_device);
>> +	if (ret)
>> +		goto out;
>> +	return 0;
>> +out:
>> +	vfio_put_device(&virtvdev->core_device.vdev);
>> +	return ret;
>> +}
>> +
>> +static void virtiovf_pci_remove(struct pci_dev *pdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
>> +
>> +	vfio_pci_core_unregister_device(&virtvdev->core_device);
>> +	vfio_put_device(&virtvdev->core_device.vdev);
>> +}
>> +
>> +static const struct pci_device_id virtiovf_pci_table[] = {
>> +	/* Only virtio-net is supported/tested so far */
>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
>> +	{}
>> +};
>> +
>> +MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
>> +
>> +static struct pci_driver virtiovf_pci_driver = {
>> +	.name = KBUILD_MODNAME,
>> +	.id_table = virtiovf_pci_table,
>> +	.probe = virtiovf_pci_probe,
>> +	.remove = virtiovf_pci_remove,
>> +	.err_handler = &vfio_pci_core_err_handlers,
>> +	.driver_managed_dma = true,
>> +};
>> +
>> +module_pci_driver(virtiovf_pci_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
>> +MODULE_DESCRIPTION(
>> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO device family");


