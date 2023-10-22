Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465907D21E9
	for <lists+kvm@lfdr.de>; Sun, 22 Oct 2023 10:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjJVIVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Oct 2023 04:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVIU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Oct 2023 04:20:58 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B821793
        for <kvm@vger.kernel.org>; Sun, 22 Oct 2023 01:20:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xrq03d+lj8jBp1wkaHhUmWg3/WFQBVOC6VV+vMpA1QhiIYAZeKDQFBGExWJK4jktD0rTolcu0egdMBz00IpBoQIc/3n36ogDgn+QVkFgIYRYEO8jzCZlPgzFtI/ofKE6qsWu3ICg3UfnhOtAuStlec5KKeIZqyDsGTLKbq9QyMejQWeuU3XYFLzBRhgx1sD1VSTL+p28AMgX4c6Omcj2l/PGSEjfPuXRLqgc69IgwxXFOFigb8aIyizuXCa+VYKgCXXcmMEjAO8yO9Bh1UFsZ4VNaZqHiBxmVVeFh/1mz2nItaEwHLwqX4bhBDe6LyNqt6jutjZAL0U22F1yUqJpkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBOjefJQAobYiWeSl5r5w8HaKoT5F6XPax9nj3o6gUQ=;
 b=myNXbiCxwLfeHGBpuFV3EJcFItLD5c4HhquNVfdDIqfSn4m3B7Mi4PVgug2/hJ1sPYIsrFjqaZSwPFX7jJQnWHlULVMhB2eBvyKWAxvPkLb1fw2PJDRqHiKq2dEYbXcIDUW0KTx/IiwZFoU2ZLhx6J/qX+fwlpbIq2Hv0fCNarXZ2ibxIvCyugn3OLtGydLTWDR7mLmsZOALr5QVJ9IzaiN2T7fe4PERoFK92O3vQ/rZFTPUkN6jcU7abD6XGJUaRFvowVMjnrfpGAbJeM37B4TtCnfnmiIHSQQ11bidlJa8L+BBJTFYM2UBzldqJKy+tPm3NpDEwqGKNAPAjigFCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBOjefJQAobYiWeSl5r5w8HaKoT5F6XPax9nj3o6gUQ=;
 b=XAvC9xsZaSXfowFkvnH2DAZHOA5Cp8pcrPQyaZoxZVdQQ1M6+T45RrkvhbBm3UXXSSNB9hwYWYdD54+8OP6wo1zoiawvidD8UOpD+PQlFhYGCk1P5LBNGGVwLLhE2HuKVhOAkh2WWqCUkb2k+pSteQ8YiywkKGprwK+81ll8S4jY0/lnmQc52cGd26jeSMsf6NXlvmpdSRZRR0K1QJ/Y6YfleFErEtohxSJSCzN+f/3zzHHZugiPtWz4SZn4/7zHbSoHcFXTPbD+bfFRla+qA5OswGWfKaSvVBa5UDEUidZ8+0uUdAdChdYf1nzEt3gHRiX8csRxb9uu+HGh4jvSyw==
Received: from BN9PR03CA0390.namprd03.prod.outlook.com (2603:10b6:408:f7::35)
 by PH7PR12MB6934.namprd12.prod.outlook.com (2603:10b6:510:1b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Sun, 22 Oct
 2023 08:20:51 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::bc) by BN9PR03CA0390.outlook.office365.com
 (2603:10b6:408:f7::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29 via Frontend
 Transport; Sun, 22 Oct 2023 08:20:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 22 Oct 2023 08:20:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 22 Oct
 2023 01:20:38 -0700
Received: from [172.27.13.77] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 22 Oct
 2023 01:20:34 -0700
Message-ID: <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
Date:   Sun, 22 Oct 2023 11:20:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Content-Language: en-US
To:     <alex.williamson@redhat.com>, <mst@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>,
        <jasowang@redhat.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|PH7PR12MB6934:EE_
X-MS-Office365-Filtering-Correlation-Id: d31407b0-2949-4bbd-722e-08dbd2d7cd4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkDkKHphRTTfmmggOjawmlO1bkHtT8Px98emL9TxH1Hrq2SfcCWvrn9xMkiX57zMM+FfahvU3j/PcXzjU7U19fUZnrgZv26dF3l2EPOwT04vjvtkIgORLKCxc+5GKzNTACatBvD+w1XUkhWvFfQXa0XEAg0UG4+NSf6MzYk+0pcjitWjfn5OYmwmYFQuwscl3nd5EKvyd7Vv4lmza6AhzXYsmw/a6QP7/j5Lwe4yf+73LL/ApZGqKAy8k5TocjG0vGvgkcGnK9ElOmq7al0uld8+/PcY9nJJ5rDB6KggA5Pbi4SFLK4/p2JvG4828UeZ6lkguVRhJEKNU/Q+JIROBze1f37ILbhkpkLgxRSz/YBITIla00enBlagB6La6pCt/5kdIxrXSDyIQz+BN68AhED4OTGXWCKWdYhgr6M4bD83PK9ryT1iAL/j3Xzzn8bZlMJ9cyDRN8BQBmKQh4wkhTkPRUWYu++WjP1o+EDZcZm+0sT7yzad72MAMQS67mUXKyEwx7wpW0D0oYa7dCQ0HQ7gHYfTbkenF7naC09UEFhTuZDbiMbDn/glu8I4Ud+04ya3RsvfEe28Z+E4p31xfrNuCCUGV0LcbhPqu4aIjuZroEe70CBBvPfqkmirUFQE0q0fHy10MdO1loR5/nJWI4yC56/NEnPg7sJ8H/fViVKPFuSzie1TPeVJsFUM5mJxpvk6cKVPnzEozAf0EkV2y1TBe9iiZ5ugQGD/JeXHQAKlfYbt2YYYz/xw7a57b1gaMFap93lE64Oilr/M7M7/uVT2yX85+0ytrTZ2LYDyXdI7DWI/JaTXubF25Lq0W75YqRKSj5EkKpQIY0DoFQ5XpA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(396003)(136003)(230922051799003)(64100799003)(82310400011)(186009)(1800799009)(451199024)(46966006)(40470700004)(36840700001)(86362001)(31696002)(966005)(5660300002)(70586007)(70206006)(83380400001)(110136005)(31686004)(54906003)(40460700003)(7636003)(356005)(336012)(36756003)(2906002)(8676002)(4326008)(16576012)(26005)(316002)(6636002)(2616005)(8936002)(53546011)(47076005)(6666004)(478600001)(16526019)(426003)(41300700001)(82740400003)(36860700001)(40480700001)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2023 08:20:50.5882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d31407b0-2949-4bbd-722e-08dbd2d7cd4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6934
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 16:42, Yishai Hadas wrote:
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
> - Fix common config map for modern device as was reported by Michael Tsirkin.
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
> Feng Liu (5):
>    virtio-pci: Fix common config map for modern device
>    virtio: Define feature bit for administration virtqueue
>    virtio-pci: Introduce admin virtqueue
>    virtio-pci: Introduce admin command sending function
>    virtio-pci: Introduce admin commands
>
> Yishai Hadas (4):
>    virtio-pci: Introduce APIs to execute legacy IO admin commands
>    vfio/pci: Expose vfio_pci_core_setup_barmap()
>    vfio/pci: Expose vfio_pci_iowrite/read##size()
>    vfio/virtio: Introduce a vfio driver over virtio devices
>
>   MAINTAINERS                            |   7 +
>   drivers/vfio/pci/Kconfig               |   2 +
>   drivers/vfio/pci/Makefile              |   2 +
>   drivers/vfio/pci/vfio_pci_core.c       |  25 ++
>   drivers/vfio/pci/vfio_pci_rdwr.c       |  38 +-
>   drivers/vfio/pci/virtio/Kconfig        |  15 +
>   drivers/vfio/pci/virtio/Makefile       |   4 +
>   drivers/vfio/pci/virtio/main.c         | 577 +++++++++++++++++++++++++
>   drivers/virtio/virtio.c                |  37 +-
>   drivers/virtio/virtio_pci_common.c     |  14 +
>   drivers/virtio/virtio_pci_common.h     |  20 +-
>   drivers/virtio/virtio_pci_modern.c     | 441 ++++++++++++++++++-
>   drivers/virtio/virtio_pci_modern_dev.c |  24 +-
>   include/linux/vfio_pci_core.h          |  20 +
>   include/linux/virtio.h                 |   8 +
>   include/linux/virtio_config.h          |   4 +
>   include/linux/virtio_pci_admin.h       |  18 +
>   include/linux/virtio_pci_modern.h      |   5 +
>   include/uapi/linux/virtio_config.h     |   8 +-
>   include/uapi/linux/virtio_pci.h        |  66 +++
>   20 files changed, 1295 insertions(+), 40 deletions(-)
>   create mode 100644 drivers/vfio/pci/virtio/Kconfig
>   create mode 100644 drivers/vfio/pci/virtio/Makefile
>   create mode 100644 drivers/vfio/pci/virtio/main.c
>   create mode 100644 include/linux/virtio_pci_admin.h
>
Hi Michael,

Did you have the chance to review the virtio part of that series ?

IMO, we addressed all your notes on V0, I would be happy to get your 
feedback on V1 before sending V2.

In my TO-DO list for V2, have for now the below minor items.
Virtio:
Patch #6: Fix a krobot note where it needs to include the H file as part 
of the export symbols C file.
Vfio:
#patch #9: Rename the 'ops' variable to drop the 'acc' and potentially 
some rename in the description of the module with regards to 'family'.

Alex,
Are you fine to leave the provisioning of the VF including the control 
of its transitional capability in the device hands as was suggested by 
Jason ?
Any specific recommendation following the discussion in the ML, for the 
'family' note ?

Once I'll have the above feedback I may prepare and send V2.

Yishai

