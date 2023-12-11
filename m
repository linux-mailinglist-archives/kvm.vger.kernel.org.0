Return-Path: <kvm+bounces-4026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A40F80C324
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 09:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A00481F20F7F
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 08:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADD020DE2;
	Mon, 11 Dec 2023 08:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jiYUiSPJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CDDE5
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 00:28:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zx+GtPjFrFbRhIiga9ht8Ak5KvbegtNob9S6frFPOew2XIO4gjbPhLVBowPP5c7KLjHE0uZVjAhDSbP1LiWEfc6pET+ABc1sHmtjUEMsCWp73aZW0Te4SEpNPxaskG0amW8VVjakPhEOLZL8uzwmI7V5v50+OMIwVZB6mjbL/PfUZVcHIq2oiPq9woQReil74uU/aBCjUcVfaU35G1rLLYkKdW6in5jI+dSjBNwidyWxUiOSnLtfYCk19vAei9DjgAJxBRFsIjaQyey31l+TRpwRdgbxB+KlJtHI6CXscPSh41UnGHATYZXs0kKuh3jtS5cwbw3WNh9fNG+t7pN6Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnlEZLRP/P5Nhgm5H/RtdKWRMDLS9aibizr6j+o3jsA=;
 b=aA/qwz9xrDKgqsi1brvhvb7dnnsqpbhwssg4mEI96BLWjEtRjaeEYgbs1bm+GJSr1rSgpFTqrJI2MrFNCPmfIqK7K18/gk/ymlJ7WGLSJlvQ52N2iRrCDmYtI9qZd0pgmAvrh4Za25tD31dMT4C2P8BWAGbgaTyzn4luiguqG42w3VNRznJK+A4WMQ2TllJnsgTgnIrz4qCpIOc2ZkTMORzmfYOVS7qgakcfTSKqJB6p97uvDO9Wuv5hnszCSA+IT2tnr0qHFy+e0qY9KdNSZtc0yhvumCgcI5o7XvEhJ3cvqxsEjnWXmzzBGQbfzceJQSunyTr6JhiI36boAfbxow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnlEZLRP/P5Nhgm5H/RtdKWRMDLS9aibizr6j+o3jsA=;
 b=jiYUiSPJe8EWvautEHnCrjzlWUwRKvKz0OgRkmru6o8TXJfMGBNGpcgLCbADJuVBjdx9FpFoCRqUjKAce0SOIvqkLsFAhyNiZrossRevkaurMJztvjRAdgqt5pRL2qJChn6AdwWrc0gkOvIDgqhRxx9cSxWfeMm4An812VFLMdcaMIcmczXVKKA+YrdfuneHdxIlgJfqwiLHMPuHN0Q14x0EpTtqoMvx0buyQH69R+YSfj71h3Cq4nbf5otxRin/tkH/FKcI4I8UMjHmxBJVqYvS6P5alPm044aSRq9TV2pnqiUJ5tVdkdbrihr40p8uD/xQ33edyt8v7J9wJ/qQZg==
Received: from BLAPR03CA0134.namprd03.prod.outlook.com (2603:10b6:208:32e::19)
 by MN2PR12MB4392.namprd12.prod.outlook.com (2603:10b6:208:264::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Mon, 11 Dec
 2023 08:28:44 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::a9) by BLAPR03CA0134.outlook.office365.com
 (2603:10b6:208:32e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32 via Frontend
 Transport; Mon, 11 Dec 2023 08:28:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.18 via Frontend Transport; Mon, 11 Dec 2023 08:28:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 11 Dec
 2023 00:28:30 -0800
Received: from [172.27.58.65] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 11 Dec
 2023 00:28:25 -0800
Message-ID: <7929884c-f8f3-4977-9474-33830cde0a07@nvidia.com>
Date: Mon, 11 Dec 2023 10:28:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 vfio 0/9] Introduce a vfio driver over virtio devices
Content-Language: en-US
To: <alex.williamson@redhat.com>, <mst@redhat.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>, <jasowang@redhat.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231207102820.74820-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|MN2PR12MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 14a0387f-6be1-48ec-d45a-08dbfa23307b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TVRmYreoWm8G/oTQv0NybMEzgSR5qvYG8WNb/7U8+OTxGb7652XU2T3Xaga4RTSb4t3AyIIBETo5ieIK00RO/TkavezAJrNVv/gYAW/Z9nKsOezRCFKGaWh2SHtZDTtEz6Xv8mccqAyNycAVxzRuqeXm3THUlOTpYIir7a/uLB2oy+N4mFPQZ+AmPRc+49MKb+O61lpKENhfgBtzY5NLve0fham9sJUSTaarcoCJV7FkCLeKUSVRYf6Ju45qfc0iS8qhDyuTelxHNWrER1jeJUKbJOHegz6yD04w+lo7KYNPRJagDdToAu2ac7cV4skxg/ngdk9R4SXII3sjWcDQSmgsJlh6XfI3e2f010482B4vd4lYZHFaZJGbi/o0OJeBNW9jzUmetn5ZCOtW5atJhbVPX6Ar3FWlNuQ5AKG+JdbqX0jCbeJqSuIoD9mkEXukyrjbFDZbf7P9x/Lreba14yq4W1Ys5RQ0YKkWjUB1axkAF5G7iN2Re9OKIMkPdXceNNkNk32u9lGDbssmY6M5UT1qeI9Wd9TUG7Dy3CocnhhNCoFQNESj+WraDzRzMYtc3DuldsnCgmDYQqfBB19gVv2OydSEUOW8LsnPeg7/12gYNeRCfg9tF3gmu9+QFGyco92FWgS1C3pojrZpwyxCxC1JpUM6gqBih1gV6CWoaxD/pgWwtm55kyByVI6aYKYKHcKuPPxwwrxnor1Y6uU+8F2AxGNexpyVJLRQ/nbqyRF3re7W60JjtQjPi9W7oBHZu6+6yhZFDmith+qa/PZ0PS80md0ZCPy4XOpO3ExFeWXbn2P/0c6u6iNwLHYn5JlVyzR2gQHc0PC4mqJUJnn6XpekKPJvKeVRitujnDasxHEubN6cR4QqJFEAFBOr918l
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(451199024)(1800799012)(186009)(82310400011)(64100799003)(46966006)(40470700004)(36840700001)(83380400001)(2906002)(478600001)(356005)(41300700001)(31686004)(82740400003)(7636003)(70586007)(54906003)(70206006)(426003)(30864003)(40480700001)(966005)(16576012)(110136005)(316002)(86362001)(31696002)(4326008)(8936002)(8676002)(53546011)(40460700003)(36756003)(47076005)(5660300002)(36860700001)(107886003)(26005)(336012)(16526019)(2616005)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2023 08:28:44.5246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a0387f-6be1-48ec-d45a-08dbfa23307b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4392

On 07/12/2023 12:28, Yishai Hadas wrote:
> This series introduce a vfio driver over virtio devices to support the
> legacy interface functionality for VFs.
> 
> Background, from the virtio spec [1].
> --------------------------------------------------------------------
> In some systems, there is a need to support a virtio legacy driver with
> a device that does not directly support the legacy interface. In such
> scenarios, a group owner device can provide the legacy interface
> functionality for the group member devices. The driver of the owner
> device can then access the legacy interface of a member device on behalf
> of the legacy member device driver.
> 
> For example, with the SR-IOV group type, group members (VFs) can not
> present the legacy interface in an I/O BAR in BAR0 as expected by the
> legacy pci driver. If the legacy driver is running inside a virtual
> machine, the hypervisor executing the virtual machine can present a
> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> legacy driver accesses to this I/O BAR and forwards them to the group
> owner device (PF) using group administration commands.
> --------------------------------------------------------------------
> 
> The first 6 patches are in the virtio area and handle the below:
> - Introduce the admin virtqueue infrastcture.
> - Expose the layout of the commands that should be used for
>    supporting the legacy access.
> - Expose APIs to enable upper layers as of vfio, net, etc
>    to execute admin commands.
> 
> The above follows the virtio spec that was lastly accepted in that area
> [1].
> 
> The last 3 patches are in the vfio area and handle the below:
> - Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
> - Introduce a vfio driver over virtio devices to support the legacy
>    interface functionality for VFs.
> 
> The series was tested successfully over virtio-net VFs in the host,
> while running in the guest both modern and legacy drivers.
> 
> [1]
> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> 
> Changes from V6: https://lore.kernel.org/kvm/20231206083857.241946-1-yishaih@nvidia.com/
> Vfio:
> - Put the pm_runtime stuff into translate_io_bar_to_mem_bar() and
>    organize the callers to be more success oriented, as suggested by Jason.
> - Add missing 'ops' (i.e. 'detach_ioas' and 'device_feature'), as mentioned by Jason.
> - Clean virtiovf_bar0_exists() to cast to bool automatically, as
>    suggested by Jason.
> - Add Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>.
> 
> Changes from V5: https://lore.kernel.org/kvm/20231205170623.197877-1-yishaih@nvidia.com/
> Vfio:
> - Rename vfio_pci_iowrite64 to vfio_pci_core_iowrite64 as was mentioned
>    by Alex.
> 
> Changes from V4: https://lore.kernel.org/all/20231129143746.6153-7-yishaih@nvidia.com/T/
> Virtio:
> - Drop the unused macro 'VIRTIO_ADMIN_MAX_CMD_OPCODE' as was asked by
>    Michael.
> - Add Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Vfio:
> - Export vfio_pci_core_setup_barmap() in place and rename
>    vfio_pci_iowrite/read<xxx> to have the 'core' prefix as part of the
>    functions names, as was discussed with Alex.
> - Improve packing of struct virtiovf_pci_core_device, as was suggested
>    by Alex.
> - Upon reset, set 'pci_cmd' back to zero, in addition, if
>    the user didn't set the 'PCI_COMMAND_IO' bit, return -EIO upon any
>    read/write towards the IO bar, as was suggested by Alex.
> - Enforce by BUILD_BUG_ON that 'bar0_virtual_buf_size' is power of 2 as
>    part of virtiovf_pci_init_device() and clean the 'sizing calculation'
>    code accordingly, as was suggested by Alex.
> 
> Changes from V3: https://www.spinics.net/lists/kvm/msg333008.html
> Virtio:
> - Rebase on top of 6.7 rc3.
> Vfio:
> - Fix a typo, drop 'acc' from 'virtiovf_acc_vfio_pci_tran_ops'.
> 
> Changes from V2: https://lore.kernel.org/all/20231029155952.67686-8-yishaih@nvidia.com/T/
> Virtio:
> - Rebase on top of 6.7 rc1.
> - Add a mutex to serialize admin commands execution and virtqueue
>    deletion, as was suggested by Michael.
> - Remove the 'ref_count' usage which is not needed any more.
> - Reduce the depth of the admin vq to match a single command at a given time.
> - Add a supported check upon command execution and move to use a single
>    flow of virtqueue_exec_admin_cmd().
> - Improve the description of the exported commands to better match the
>    specification and the expected usage as was asked by Michael.
> 
> Vfio:
> - Upon calling to virtio_pci_admin_legacy/common_device_io_read/write()
>    supply the 'offset' within the relevant configuration area, following
>    the virtio exported APIs.
> 
> Changes from V1: https://lore.kernel.org/all/20231023104548.07b3aa19.alex.williamson@redhat.com/T/
> Virtio:
> - Drop its first patch, it was accepted upstream already.
> - Add a new patch (#6) which initializes the supported admin commands
>    upon admin queue activation as was suggested by Michael.
> - Split the legacy_io_read/write commands per common/device
>    configuration as was asked by Michael.
> - Don't expose any more the list query/used APIs outside of virtio.
> - Instead, expose an API to check whether the legacy io functionality is
>    supported as was suggested by Michael.
> - Fix some Krobot's note by adding the missing include file.
> 
> Vfio:
> - Refer specifically to virtio-net as part of the driver/module description
>    as Alex asked.
> - Change to check MSIX enablement based on the irq type of the given vfio
>    core device. In addition, drop its capable checking from the probe flow
>    as was asked by Alex.
> - Adapt to use the new virtio exposed APIs and clean some code accordingly.
> - Adapt to some cleaner style code in some places (if/else) as was suggested
>    by Alex.
> - Fix the range_intersect_range() function and adapt its usage as was
>    pointed by Alex.
> - Make struct virtiovf_pci_core_device better packed.
> - Overwrite the subsystem vendor ID to be 0x1af4 as was discussed in
>    the ML.
> - Add support for the 'bar sizing negotiation' as was asked by Alex.
> - Drop the 'acc' from the 'ops' as Alex asked.
> 
> Changes from V0: https://www.spinics.net/lists/linux-virtualization/msg63802.html
> 
> Virtio:
> - Fix the common config map size issue that was reported by Michael
>    Tsirkin.
> - Do not use vp_dev->vqs[] array upon vp_del_vqs() as was asked by
>    Michael, instead skip the AQ specifically.
> - Move admin vq implementation into virtio_pci_modern.c as was asked by
>    Michael.
> - Rename structure virtio_avq to virtio_pci_admin_vq and some extra
>    corresponding renames.
> - Remove exported symbols virtio_pci_vf_get_pf_dev(),
>    virtio_admin_cmd_exec() as now callers are local to the module.
> - Handle inflight commands as part of the device reset flow.
> - Introduce APIs per admin command in virtio-pci as was asked by Michael.
> 
> Vfio:
> - Change to use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for
>    vfio_pci_core_setup_barmap() and vfio_pci_iowrite#xxx() as pointed by
>    Alex.
> - Drop the intermediate patch which prepares the commands and calls the
>    generic virtio admin command API (i.e. virtio_admin_cmd_exec()).
> - Instead, call directly to the new APIs per admin command that are
>    exported from Virtio - based on Michael's request.
> - Enable only virtio-net as part of the pci_device_id table to enforce
>    upon binding only what is supported as suggested by Alex.
> - Add support for byte-wise access (read/write) over the device config
>    region as was asked by Alex.
> - Consider whether MSIX is practically enabled/disabled to choose the
>    right opcode upon issuing read/write admin command, as mentioned
>    by Michael.
> - Move to use VIRTIO_PCI_CONFIG_OFF instead of adding some new defines
>    as was suggested by Michael.
> - Set the '.close_device' op to vfio_pci_core_close_device() as was
>    pointed by Alex.
> - Adapt to Vfio multi-line comment style in a few places.
> - Add virtualization@lists.linux-foundation.org in the MAINTAINERS file
>    to be CCed for the new driver as was suggested by Jason.
> 
> Yishai
> 
> Feng Liu (4):
>    virtio: Define feature bit for administration virtqueue
>    virtio-pci: Introduce admin virtqueue
>    virtio-pci: Introduce admin command sending function
>    virtio-pci: Introduce admin commands
> 
> Yishai Hadas (5):
>    virtio-pci: Initialize the supported admin commands
>    virtio-pci: Introduce APIs to execute legacy IO admin commands
>    vfio/pci: Expose vfio_pci_core_setup_barmap()
>    vfio/pci: Expose vfio_pci_core_iowrite/read##size()
>    vfio/virtio: Introduce a vfio driver over virtio devices
> 
>   MAINTAINERS                            |   7 +
>   drivers/vfio/pci/Kconfig               |   2 +
>   drivers/vfio/pci/Makefile              |   2 +
>   drivers/vfio/pci/vfio_pci_rdwr.c       |  57 +--
>   drivers/vfio/pci/virtio/Kconfig        |  16 +
>   drivers/vfio/pci/virtio/Makefile       |   4 +
>   drivers/vfio/pci/virtio/main.c         | 567 +++++++++++++++++++++++++
>   drivers/virtio/virtio.c                |  37 +-
>   drivers/virtio/virtio_pci_common.c     |  14 +
>   drivers/virtio/virtio_pci_common.h     |  21 +-
>   drivers/virtio/virtio_pci_modern.c     | 503 +++++++++++++++++++++-
>   drivers/virtio/virtio_pci_modern_dev.c |  24 +-
>   include/linux/vfio_pci_core.h          |  20 +
>   include/linux/virtio.h                 |   8 +
>   include/linux/virtio_config.h          |   4 +
>   include/linux/virtio_pci_admin.h       |  21 +
>   include/linux/virtio_pci_modern.h      |   2 +
>   include/uapi/linux/virtio_config.h     |   8 +-
>   include/uapi/linux/virtio_pci.h        |  68 +++
>   19 files changed, 1349 insertions(+), 36 deletions(-)
>   create mode 100644 drivers/vfio/pci/virtio/Kconfig
>   create mode 100644 drivers/vfio/pci/virtio/Makefile
>   create mode 100644 drivers/vfio/pci/virtio/main.c
>   create mode 100644 include/linux/virtio_pci_admin.h
> 

Hi Michael and Alex,

It seems that we are done with all the last notes here.

Michael,
Based on Alex's note here [1] "the preferred merge approach would be 
that virtio maintainers take patches 1-6 and provide a branch or tag I 
can merge to bring 7-9 in through the vfio tree"

Can that please be done to proceed here ?

[1] 
https://patchwork.kernel.org/project/kvm/patch/20231205170623.197877-9-yishaih@nvidia.com/

Thanks,
Yishai

