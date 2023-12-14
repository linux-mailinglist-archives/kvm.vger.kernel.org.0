Return-Path: <kvm+bounces-4449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50579812B15
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 486BC1C2151B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 09:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAFC2869B;
	Thu, 14 Dec 2023 09:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gNOGK88d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D777BD6E
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:04:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfOEmHqOaPvgLDHEKs+u5XTClqPHfG8GV5KWV7a6VDHDIl1luouinQ+jE/be902HGMdl5NKR52dCgZP/Eav+VnUAy1E3CMLewaW4DqsyyAzs9UAeCv6YTNq90CtOADcIdOmZKeGwAdcqOuwwOmODs31muz+wLMsbbL6yz4VTpc70wRdZutWyxrmAzMUUKdTNf9PupiuSQyLCgWvV8ed8FO5fZTX0ZUiDGPuvD66wffNSAraiviYO72yvJLVld+JppRBnIbWMyF1GXCbqmcapNIqNUQK6kDRFy9MUNJwILIRsuANZA8DPeP8LEi0GpQ66Ub7lpjpSDVchrZ9qBj0NjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/RHxymu/7jNag+cFM43/Vp/eYR942a2bhXb8UvUzA4=;
 b=ZEX5KqgM11ecg3Pou4p0blNekLBqVvEWjTXyJwnN7j3ED2vNfQtMHGUaFKJJSI48cDAnKmQWDCKZLuBPgQRn5+NWdZZ3YYb5lAeaFKqBgQUR89VV/AI3Fjt9JFmLAns8WceDrdvRwoXnQRc0o080jdqoWcG4E4pBtwOgVKV57d2RcfFGZdxU02b7vFLw4nqadP4Syb5Bf/GM1WHT2DG7eiHpRNlZh8UEhn+uBTgyaMdcmUtF4WewjRzJnuRF8KFuwtDYNxPPjey+85i9koORS3uYay0h+ucoF9y2RHHqcmZ2IsrsmtrtrEHBO3IHZ9vGDIHJFMADHS87qeYfFMoQ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/RHxymu/7jNag+cFM43/Vp/eYR942a2bhXb8UvUzA4=;
 b=gNOGK88dko/9v6hJZKzDbENs1LBiFa1pD24ljhglOXGd4BPEqyQK8+VeNfbSPVJEaOFujaigq0+e8dUqnupRvbhFRvtmBFMPU0+5ApsueLVbLCAHAz4iWFtQqn+QHCIiLN8ojuTQCqF0BwGxR4MJlmNAp5voWQix9ReIoQ93BcT+5XjrUJ4NP6p3C+csrt+MeINze/si5V29j7UcDGdV6ZjBqttO5/fiUrbLmCJ4c2hDm5KsOwZXAMr7RBVHNUpRMfq6clLC5fodqZxh4p9wiy6/e5hBzX0NpGxZgnHxMRsitTV9iiZCritSkyRMN3StmJu11Az01vFFbXPtAC2ijQ==
Received: from DS7PR05CA0104.namprd05.prod.outlook.com (2603:10b6:8:56::16) by
 CO6PR12MB5473.namprd12.prod.outlook.com (2603:10b6:303:13e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.28; Thu, 14 Dec 2023 09:04:14 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:8:56:cafe::f5) by DS7PR05CA0104.outlook.office365.com
 (2603:10b6:8:56::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.8 via Frontend
 Transport; Thu, 14 Dec 2023 09:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 09:04:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 01:03:58 -0800
Received: from [172.27.58.65] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 01:03:52 -0800
Message-ID: <ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
Date: Thu, 14 Dec 2023 11:03:49 +0200
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
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231214013642-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|CO6PR12MB5473:EE_
X-MS-Office365-Filtering-Correlation-Id: 8466e6ca-c62e-4dbf-1de7-08dbfc83a4d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BGACKXakwLXhaKTJc4BSEMBxg0f1gEkjyeOexeHLUEHX6v5wo48tl+6B45TuXrZYDhjGs2ytIoB6hGRGSGvoAJFJu+iqPQhoGWkOcN3CiWfqfEF7q7JZzABg6zdjUTvc4odhYjBV97/uVWK+PDJ10G2RwxhNyxb1QZRbpjWtqSJIRH9i1fVtxk6m9jAZE+j7V/nSW+5OPSJNAi68j2/X8yrkCPR9koytJxLJaRrxftJCYve/Wnem8QEqjexGZugVqUw4sAzhnzlf37kZ7HpsooUonlfTGw8Ed1Dq5SRfL04G3Vyrg1oe5LQOKvtPyYK7VBR5kM6VRh/SBvHTtAyP5HKx6KbMJoBHBVPYuT4xFmCwQSztJ3P6AaQ3MYLKy3M8S8WgRiyOMFr3qejmzYG/i0i71FLpm3oNx+AG6eR9vbE4U4AnOZXFJfI8a6/M/5WSOB9hfQireA0qf9lO9sIhhk2hNnOqP64pFY5sjBtZ5uQ2FUFeHAVYud+ncSivrzz2R7bDX/RjFiGqP+D6AsC2ZvUIXpLDxgotwO4+Juc9owEyETb3W4CEi/omdPTaJYDwRQaroXK/gBZ44ucgIGFZtytlY0n3ywNoykKm33/Qe/46dAWiZHGTwFk4IQpukdz2YA4OyTeB433Kr4i8pHqvMLLYdNiu5Thv8nKRTCtdsnr3IY8/LVO3UrQL8iqic4FHPVilywi9VsnOuF3ssqe0B7i/nuRc4rNsMxcGNZpN4BmoRtcdp/nvL+H/1XLyG/XkB/443nwZEcTKnQnIh/YbUeAyNFT6v3xuHRx7MC36b0jHEvfAPsnu3I5hyJgI2iJL
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(82310400011)(1800799012)(64100799003)(186009)(451199024)(40470700004)(46966006)(36840700001)(356005)(86362001)(36860700001)(82740400003)(7636003)(36756003)(31686004)(31696002)(40460700003)(40480700001)(53546011)(478600001)(6666004)(426003)(83380400001)(26005)(966005)(16576012)(54906003)(70586007)(6916009)(70206006)(336012)(16526019)(47076005)(316002)(2616005)(107886003)(4326008)(8936002)(8676002)(41300700001)(5660300002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 09:04:13.8258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8466e6ca-c62e-4dbf-1de7-08dbfc83a4d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5473

On 14/12/2023 8:38, Michael S. Tsirkin wrote:
> On Thu, Dec 07, 2023 at 12:28:20PM +0200, Yishai Hadas wrote:
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
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   MAINTAINERS                      |   7 +
>>   drivers/vfio/pci/Kconfig         |   2 +
>>   drivers/vfio/pci/Makefile        |   2 +
>>   drivers/vfio/pci/virtio/Kconfig  |  16 +
>>   drivers/vfio/pci/virtio/Makefile |   4 +
>>   drivers/vfio/pci/virtio/main.c   | 567 +++++++++++++++++++++++++++++++
>>   6 files changed, 598 insertions(+)
>>   create mode 100644 drivers/vfio/pci/virtio/Kconfig
>>   create mode 100644 drivers/vfio/pci/virtio/Makefile
>>   create mode 100644 drivers/vfio/pci/virtio/main.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 012df8ccf34e..b246b769092d 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22872,6 +22872,13 @@ L:	kvm@vger.kernel.org
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
>> index 000000000000..3a6707639220
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/Kconfig
>> @@ -0,0 +1,16 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +config VIRTIO_VFIO_PCI
>> +        tristate "VFIO support for VIRTIO NET PCI devices"
>> +        depends on VIRTIO_PCI
>> +        select VFIO_PCI_CORE
>> +        help
>> +          This provides support for exposing VIRTIO NET VF devices which support
>> +          legacy IO access, using the VFIO framework that can work with a legacy
>> +          virtio driver in the guest.
>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
>> +          not indicate I/O Space.
>> +          As of that this driver emulated I/O BAR in software to let a VF be
>> +          seen as a transitional device in the guest and let it work with
>> +          a legacy driver.
>> +
>> +          If you don't know what to do here, say N.
> 
> BTW shouldn't this driver be limited to X86? Things like lack of memory
> barriers will make legacy virtio racy on e.g. ARM will they not?
> And endian-ness will be broken on PPC ...
> 

OK, if so, we can come with the below extra code.
Makes sense ?

I'll squash it as part of V8 to the relevant patch.

diff --git a/drivers/virtio/virtio_pci_modern.c 
b/drivers/virtio/virtio_pci_modern.c
index 37a0035f8381..b652e91b9df4 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev 
*pdev)
         struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
         struct virtio_pci_device *vp_dev;

+#ifndef CONFIG_X86
+       return false;
+#endif
         if (!virtio_dev)
                 return false;

Yishai

