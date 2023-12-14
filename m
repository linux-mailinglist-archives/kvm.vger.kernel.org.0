Return-Path: <kvm+bounces-4457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F3B812BCB
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0D5B2822AC
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 09:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D962A30D06;
	Thu, 14 Dec 2023 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gpfguuDm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24598B7
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:37:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaOjyynDrF/TOtBCDBbf9p+fXFxSmmWZOjsqfrVdr5lS0ZSGaGz0xJD6kncvkxqTbqTYeJczI2mz7/6/gmk5UaF5viA6qVKxGrxt3K3oMG0hV6V+qc1oy85eYnO7Kz0kE7Z8l4QNrRBu4hurjE2hj62Acu94n/6q8DT8HR91PqzYKQ8fxudl0x9YhwIf22L1ozexvJQgodcZC7WPOuf1yBk/UvxwTLMEhCIN7QEy9F5jXEbKRs88NktpkQx8S1jmg756pgkMFZvaEJU432z8skDKug5hi5mgdMKtm57bAMilRkJytW+mv3UFPyU1t0b0hBe0CpT8iDkz+dSoh63T7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lv/ykUTyxXpCjdXygp5Y113WtyjEX+Ewo2/qTom714=;
 b=GOBA44dHngEJqtwBPDZWbNcYtRFMLgmGHo4PVeq8nZyGJps81GnDXchFMD0htgqjHf9f4NUmnB8HE1pu0MG94YcisSsJr3YN46TDZLZ3RfQFFW9Zrwp5N83PI1yZjDvASopUmZXYAms6HvyqcbCmKn8wQbPC7JKhwhn5ASNmjDSAB4gsGdtpylacwKML3UWjqsYIPPE5lIQ3AgaUs9vPCtPd7EL/bGZYm1ROIUB4UAvDJbjI1bokokDaIXkL36kw5opAqi0BMdFBq2ZoUWW4Xwpn7/p8A72SxNBl9liuGFhLKolatecVN1dMWDqlgWuhSR7eXYD+1pFzipATGf65Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lv/ykUTyxXpCjdXygp5Y113WtyjEX+Ewo2/qTom714=;
 b=gpfguuDmSnegZDUCo7Nlio5q1CcaGIpFmDCjbIZCDDl7lm369gKZbCaT207eHTWdjHP35tDROFIZjTgqyHn9Snevk27kWqhQ+vnWU30/jGn5bPQ13PO60pa+SHKPYBeVtb+1cPI2DFFRrM/hLQTs/dyfG43a9n6x6IkJL4GGUh9pSoeWKJH76oDXtoeJOkVdiTE1xNTW58NgkI/MZ11canwgfyVKTO0T2FB8uBBr6RcFZQxWMsVnGkwwowOEy/U6kj/jzPdoO3txH6mz8D6VsvHk/guIuUDiQRgXB1hKYP6gjKtbMJ6oK+uhnEvwWQdpqUuWscUQ6o0IkW2TI4+26A==
Received: from MN2PR15CA0011.namprd15.prod.outlook.com (2603:10b6:208:1b4::24)
 by DS0PR12MB8576.namprd12.prod.outlook.com (2603:10b6:8:165::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 09:37:33 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:1b4:cafe::c6) by MN2PR15CA0011.outlook.office365.com
 (2603:10b6:208:1b4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 09:37:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 09:37:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 01:37:17 -0800
Received: from [172.27.58.65] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 01:37:12 -0800
Message-ID: <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
Date: Thu, 14 Dec 2023 11:37:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <alex.williamson@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
 <20231214013642-mutt-send-email-mst@kernel.org>
 <ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
 <20231214041515-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231214041515-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|DS0PR12MB8576:EE_
X-MS-Office365-Filtering-Correlation-Id: f11806a4-0dab-46f5-1475-08dbfc884cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2jZ8Zd3W1sEB+EcBxt4cPcu9ypV/eqVlwpcNQrVrQzRPj5W4KOlhEzoZmw5Hf254AIKPwP+efpA/HwDDeTlPJbFxQDJ5AdLGbYAD6wptZQnCD1rxqAV5yGvnspziIOKP2IBa04Z+Vkh+KJSTk74BnlIpERtyUpPTU9BRvWaFhALXyVWFYeOIOSFcg5xdZQr3wF5X3iuBt1mFT7Is/iGO8tfDjbmcJ6uh1+i7P2af+Jy7kfizK8WTBzQagNmAQSG8RQeRkHMsT8aoCeL3r63ZWF0iCmH71K7PJyL5k+4nsRttRNTfheyQo7ygsPz6KdAeROX2mhjfifHTbPZPvzMxkJyE2bVV4MXChZfuKS2Y95bAQYiV2pvrGoLcrESqtE+BlZ1WyN6TZ5E5fAAFroFHn4D8gHIUabDBS1SBjV4YgPTun+Xl29w0Qf+53BiSjPxglLaWa3DbcZcOximvyS8hVDyq+/p9WnwfZ6wrAY/GE2zPdmK2sQ1/R7pnzNpVMByLPMxP7x36RuEiGU5exmcBoHwfhpcRbtPGyB0zyIYlUeuRCPQCDbIjJXzqEufUZyIqwZSozIoKZmdHWtcLD8UHJCV7+FCfsM0+4HGvgGBSxcVV2YCP27m9YnXHFt4W8IvJ1uM9U0tpt6kmkvRmTFM37+TPDbDs8ihx85MUa4PU7g0yahblz9Yro3tVB0cnXW91AZ2IT1Hx7Up6f06O27P6CL8ldnWFdwnt9LeYVsnL6heL+SdoYsIbiKWoiVn2tNJNKYoTGQQF/8C3AFzxSf0BcHbmJ3CK7YjqAH3h/Vz68bT7viQJCniq1Zmvb0V73QkR
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(396003)(376002)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(82310400011)(46966006)(40470700004)(36840700001)(82740400003)(7636003)(356005)(40460700003)(2906002)(36756003)(41300700001)(31696002)(86362001)(31686004)(2616005)(4326008)(8676002)(8936002)(966005)(478600001)(40480700001)(336012)(426003)(83380400001)(54906003)(70206006)(70586007)(316002)(6916009)(16576012)(36860700001)(5660300002)(53546011)(16526019)(107886003)(47076005)(26005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 09:37:33.3123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f11806a4-0dab-46f5-1475-08dbfc884cac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8576

On 14/12/2023 11:19, Michael S. Tsirkin wrote:
> On Thu, Dec 14, 2023 at 11:03:49AM +0200, Yishai Hadas wrote:
>> On 14/12/2023 8:38, Michael S. Tsirkin wrote:
>>> On Thu, Dec 07, 2023 at 12:28:20PM +0200, Yishai Hadas wrote:
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
>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>> ---
>>>>    MAINTAINERS                      |   7 +
>>>>    drivers/vfio/pci/Kconfig         |   2 +
>>>>    drivers/vfio/pci/Makefile        |   2 +
>>>>    drivers/vfio/pci/virtio/Kconfig  |  16 +
>>>>    drivers/vfio/pci/virtio/Makefile |   4 +
>>>>    drivers/vfio/pci/virtio/main.c   | 567 +++++++++++++++++++++++++++++++
>>>>    6 files changed, 598 insertions(+)
>>>>    create mode 100644 drivers/vfio/pci/virtio/Kconfig
>>>>    create mode 100644 drivers/vfio/pci/virtio/Makefile
>>>>    create mode 100644 drivers/vfio/pci/virtio/main.c
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 012df8ccf34e..b246b769092d 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -22872,6 +22872,13 @@ L:	kvm@vger.kernel.org
>>>>    S:	Maintained
>>>>    F:	drivers/vfio/pci/mlx5/
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
>>>>    source "drivers/vfio/pci/pds/Kconfig"
>>>> +source "drivers/vfio/pci/virtio/Kconfig"
>>>> +
>>>>    endmenu
>>>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>>>> index 45167be462d8..046139a4eca5 100644
>>>> --- a/drivers/vfio/pci/Makefile
>>>> +++ b/drivers/vfio/pci/Makefile
>>>> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>>>>    obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>>>>    obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>>>> +
>>>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
>>>> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
>>>> new file mode 100644
>>>> index 000000000000..3a6707639220
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/pci/virtio/Kconfig
>>>> @@ -0,0 +1,16 @@
>>>> +# SPDX-License-Identifier: GPL-2.0-only
>>>> +config VIRTIO_VFIO_PCI
>>>> +        tristate "VFIO support for VIRTIO NET PCI devices"
>>>> +        depends on VIRTIO_PCI
>>>> +        select VFIO_PCI_CORE
>>>> +        help
>>>> +          This provides support for exposing VIRTIO NET VF devices which support
>>>> +          legacy IO access, using the VFIO framework that can work with a legacy
>>>> +          virtio driver in the guest.
>>>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
>>>> +          not indicate I/O Space.
>>>> +          As of that this driver emulated I/O BAR in software to let a VF be
>>>> +          seen as a transitional device in the guest and let it work with
>>>> +          a legacy driver.
>>>> +
>>>> +          If you don't know what to do here, say N.
>>>
>>> BTW shouldn't this driver be limited to X86? Things like lack of memory
>>> barriers will make legacy virtio racy on e.g. ARM will they not?
>>> And endian-ness will be broken on PPC ...
>>>
>>
>> OK, if so, we can come with the below extra code.
>> Makes sense ?
>>
>> I'll squash it as part of V8 to the relevant patch.
>>
>> diff --git a/drivers/virtio/virtio_pci_modern.c
>> b/drivers/virtio/virtio_pci_modern.c
>> index 37a0035f8381..b652e91b9df4 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>> *pdev)
>>          struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>          struct virtio_pci_device *vp_dev;
>>
>> +#ifndef CONFIG_X86
>> +       return false;
>> +#endif
>>          if (!virtio_dev)
>>                  return false;
>>
>> Yishai
> 
> Isn't there going to be a bunch more dead code that compiler won't be
> able to elide?
> 

On my setup the compiler didn't complain about dead-code (I simulated it 
by using ifdef CONFIG_X86 return false).

However, if we suspect that some compiler might complain, we can come 
with the below instead.

Do you prefer that ?

index 37a0035f8381..53e29824d404 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct 
virtio_device *vdev)
          BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
          BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))

+#ifdef CONFIG_X86
  /*
   * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
   * commands are supported
@@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev 
*pdev)
                 return true;
         return false;
  }
+#else
+bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
+{
+       return false;
+}
+#endif
  EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);

Yishai

