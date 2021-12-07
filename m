Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6246C16D
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 18:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhLGRQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 12:16:34 -0500
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:60399
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229639AbhLGRQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 12:16:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9+Xr45kgaaYoXr4DenRU0hJ0v7LwJs/1QwIn4h0R2ftpl16/WNwTor6klPGpVUuch405oQ6TIFy/z6KckPlAkuABIxkDvXXuOnaSw+ZHudONwb4/T90iOCi2CzCOPwbfqOG52cvmTsDm82AJPu3u9w+mTAUtWN3PpbS+Yx0EubHweznVIF+giae9Pqk6Bhq5pgS8Ybk2eqNuuVbgkZr8TQ3p+J/6kxf9yL2+2SKSF2Q/Vu7DKv+4QVvhwu+GgphMeNFn9aAs5aXBWUb4MSxwO4u00T9uUbHSgKaQdgWM1D7Ix695IX2zdFsyD/2vWlUc49jdEErdiAH0Hc9dfMLdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygvhFD8EaPg4IQGqxjOQ0SrEwfTnoeJZj765No3+8zE=;
 b=mxY8202Vf5CJfUG0f/QWssa048yZO9YqV00qlu53ldUJJubBDKrZKShAkOpmTCR08VvTkw1xI/Vuhsf9zT0uGjHhcMHxn7AvoEPM1+AUjGPFnEhjoZYmSm2WB1tz5sGkyIeC/9z+tiQSfgz09SK9tEkLPa7bs0mEuU6fFled/rrbWjPrHDb9nhElCj1bVJlHKTrSUdiF+Vx5l1UhpG0O9vtK7vZ6FobTVkQticC64xaXMQQgABgGxKV14L4n8a/hmPiMRZ8/SnbjTd8C5/9K8wB33hock3MpeBesemL/Olm5t5qpkrSDB2FBeaNAovaJSD8hFZrLSpV+dVQS5jqkIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygvhFD8EaPg4IQGqxjOQ0SrEwfTnoeJZj765No3+8zE=;
 b=LbMJbBEK9rcG8qIz+viwLqDNPnkySWEhPCeRPBrIhN8/dGICAy160ikpmAzb2a3UCJZu7lFiGlvhjhSWUxXOnztL8npJuIryK/vRaLFLRVdyR/I6rCOYtTRuuYUGnUBeK1lx+2aVyl96qjxDFapYxT/3W4cWwvCpmjFEnbcY3T/c1bhDw/SX7v3r2Ch++EN8kw6dlclkFa+IN4P5zGcbwb6DgcEztQ0Pj0w67sXC7SUNVr3Lg6tamlxBkQPRO15rTJJnr1YpcZ8G6cQmqdh2lHQDTCQiRO611pW+vXVgjn2kVSMR3360tDj8mznFAGSdvDI5qQzgmLaTcztVWJkODQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5207.namprd12.prod.outlook.com (2603:10b6:208:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Tue, 7 Dec
 2021 17:13:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 17:13:01 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v3] vfio: Documentation for the migration region
Date:   Tue,  7 Dec 2021 13:13:00 -0400
Message-Id: <0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0006.namprd20.prod.outlook.com
 (2603:10b6:208:e8::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0006.namprd20.prod.outlook.com (2603:10b6:208:e8::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22 via Frontend Transport; Tue, 7 Dec 2021 17:13:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mue1U-0005aa-6D; Tue, 07 Dec 2021 13:13:00 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69284bac-7a16-42e2-98e6-08d9b9a4d2a1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5207:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB520791EEFE1DA667009A49B1C26E9@BL1PR12MB5207.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPBGKlpTbFN1ZL2MZybV8qZJhiB4kKmZl7Z1kMAj/UsvI1E+hnq+PdEAFvNsz+zZ1udarGlQ3iQ9H52ZbpFVhdQfGJIilt0O9Y2oSQBCJbMN5qMGZxkTSUuiERl/6MMdFFoLwlyMfJkbX8wQsfIjhMnSeW6hBst7UV4JEcoaaHupnFkNwromMrt3oCLXXcgmWS5WcPIcoAWLI5g5wtVTeOZ//jj8zS9ZsL5hWBoitwYiFkQBJyAiFGBXXQcMsj482mY5tmtnhyi0Cgjqu7YmlccRQ/GAOezXiVZsGEhWUzxc+YAKTypo8i5d5pohHuzV+H9SY/Akpb3vu73C8UezWElU8Y19SReCUBNcQ+iYcc/+PatkX6w+e1fJOaXLLUpxFyxdc8cx04zYhf1uiJZcxJi7ltQA6BqVPWqttco0BsHnof4pWWgsFKoFVtJeA8pKKws7+xMSqzmzE7+ozmqXxe8d5/ipCmpzboScrcXmpthw+DHByt1rde7msv5X8B9yGRZ80jIGaeUJ5OuMzqdH1Lvyt9Q9KhahAu8DXxJu7Q4YjEMbnJhnTSCbsEqkeMNEOW6uGpPi7SNCH2ireLt4BVSOw4YJhAeQRP8/NtpK2USik8k1rFe4Xj+5PpC8R7HWGWUTdZEZsMDvggreOUhvog/Jv8KaOrvhHxDNVhA4u6j5NzHT41ksu1Hi8fdYRZlwtAhkzsC2zmRiOMPm5lb8wRV6rgS9QH53Y31VQK/oCBrLm2MgjHDnwtEczsFpGnkztEjVgXjCe+tc1QlRCCfeTHDR1OG28IcY5hFIdOhcHT8IxKQFdzvmROxTe0qEMaueNZ0pXUb5RVe8+DfVT3xD+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8936002)(26005)(508600001)(966005)(186003)(5660300002)(2616005)(426003)(66476007)(66556008)(66946007)(8676002)(38100700002)(2906002)(83380400001)(9786002)(9746002)(30864003)(110136005)(316002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H/oreATZ6UYzzPdG4v4I/kJGmJAD9vcw/kjTPvbnpnXFkhN0XbUXxNXfIh1T?=
 =?us-ascii?Q?iPlKly906s4h1DSzwvZQQDyTL6zpgiOoeKTck0brzCkLNuQHSAbk5Us+nliU?=
 =?us-ascii?Q?hzmvFJXDiOunFoVG8NvUgZOnMXksf7l0cq5gOL/SdV/cN1zy91V4NyZMVX7S?=
 =?us-ascii?Q?t6gPkoQJykVzGbS24FALM9tcNxkOTgySg/TpsQBek2azTri2EbB+cJQ2NTyX?=
 =?us-ascii?Q?AVwZ9ixfHAEoLVD1c6HHUstVHsx2ut4F/WX0q8JzLweUCx7I87MKdCS3HLcz?=
 =?us-ascii?Q?n6o4R4s2najnBFODgZ8mq5Kkan+rwL8dZqclZfuJAbAQFVg5lBro1/Ba9oDZ?=
 =?us-ascii?Q?mkJgSx2XNoBEhvmstmONAuuXDsaloYz811qF5Z9NdGsue+0ecn1X+wEE1q8x?=
 =?us-ascii?Q?a/mmKyjbKKP/JTnwMcKSu3RQIW935/3zOyUQ+KjdsMKOViagUDav3jbMHNqG?=
 =?us-ascii?Q?EqWZQZ7+HMMwM7grrGFvlf78+WefNTIlyw/9R5Bkn5u0FEwEdgmLwv8dHwRt?=
 =?us-ascii?Q?+NcXv2cHj37dXr6q/yw4Hm8zs6iNegzKwZqWHD4MgsNZQhsWOL31L8edhect?=
 =?us-ascii?Q?/LrC0cQ5q4VJYs6X3QpZqy7AHbkM4OiJNYDlnushku0zglb6s+O7rUGiqvkD?=
 =?us-ascii?Q?bj9E+0viDAR2jt8cuguljANaEBsZvv9DnAXBYG5j2gf8VATRGRIW8xiDBcsV?=
 =?us-ascii?Q?S/QE0sbfm1yClEWTUo9KPpvHEcwE1JF4f4A3WUZ5vDboHwcj3CYlcHd3zVut?=
 =?us-ascii?Q?AEeQbAAnW2L79FvE3CGDThbxVEfolT39N5n6rl40Iz5E/vAYztOQaKOAyJhY?=
 =?us-ascii?Q?NMRI1LfuB4hPDe5bGmidn3IuVh/YnPllM1dwxWrRqnN3mS4z9y+blLM3d6pg?=
 =?us-ascii?Q?xoiZN3AY8uFFcCsQ13uzWt5GNZzGnT7HR/AkcR9CONWDza0cPLUaaUVsv5MZ?=
 =?us-ascii?Q?gVKe9+LRWVsNp9cPzq+IXdarO6WHac98MMKUbXMOL/Fu00bAsAiaRtuY6TlY?=
 =?us-ascii?Q?rdf/ZSXJIEZoDBcSO9hTvycPSKVNOu8+UPQD4wLmT6woR9nvOP0OeRiVVCDz?=
 =?us-ascii?Q?+EfQaDUojhpkkB+3uP2V1kF8r/wCGeiYB/afD5g/RozcyZgzMQT/GfTEuM77?=
 =?us-ascii?Q?qvZdrF+t9QYJ3BQ1O3+djN+D2HPLxSZvjamApohAvcz4vEhMGui1XapeGDGI?=
 =?us-ascii?Q?q/ZPNBu+ZYVed47fT4jjYTcudMJvmVhQ4wYwaEcBjUKpCVzvxSNVp9KDoOD2?=
 =?us-ascii?Q?fzfGpsaRDXfMy7RypB3yhTM9aceuyV+RPWFWcCVJTvyHBTZ/P2wH1NHE9JvS?=
 =?us-ascii?Q?HEMevP0wpfjbw4OHNn45KKouJAHA9s9HKnfcpfY3Loj4ANPfpukzaOqoRXs8?=
 =?us-ascii?Q?ISFkS8lWFQSZO4LTbRpfsOCvh90OC/vj7PhchPC2rAggKz339bt5ui7RzNkJ?=
 =?us-ascii?Q?awwUVntLa8z1vZgTrWNx83bi5AVw1V8oFyUspvbVJsXK9rOZNT3EXl3rDmuf?=
 =?us-ascii?Q?ZwSzhHDJ6owCei+PZbZvU1vgNEj6EbcTJETwoS/zPDRBuMOxWD5asxw/22DZ?=
 =?us-ascii?Q?EV9B7pz3HPGgKG3xTHI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69284bac-7a16-42e2-98e6-08d9b9a4d2a1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 17:13:01.1091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p2TNJeGE6cR0KX/s1psLCgifsOzbtCG9hpBfIYK+Kt3cpCQRv2glM5iAxKVim+kZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5207
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide some more complete documentation for the migration regions
behavior, specifically focusing on the device_state bits and the whole
system view from a VMM.

To: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst | 301 +++++++++++++++++++++++++++++-
 1 file changed, 300 insertions(+), 1 deletion(-)

v3:
 - s/migration_state/device_state
 - Redo how the migration data moves to better capture how pre-copy works
 - Require entry to RESUMING to always succeed, without prior reset
 - Move SAVING | RUNNING to after RUNNING in the precedence list
 - Reword the discussion of devices that have migration control registers
   in the same function
v2: https://lore.kernel.org/r/0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com
 - RST fixups for sphinx rendering
 - Inclue the priority order for multi-bit-changes
 - Add a small discussion on devices like hns with migration control inside
   the same function as is being migrated.
 - Language cleanups from v1, the diff says almost every line was touched in some way
v1: https://lore.kernel.org/r/0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index c663b6f978255b..2ff47823a889b4 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -242,7 +242,306 @@ group and can access them as follows::
 VFIO User API
 -------------------------------------------------------------------------------
 
-Please see include/linux/vfio.h for complete API documentation.
+Please see include/uapi/linux/vfio.h for complete API documentation.
+
+-------------------------------------------------------------------------------
+
+VFIO migration driver API
+-------------------------------------------------------------------------------
+
+VFIO drivers that support migration implement a migration control register
+called device_state in the struct vfio_device_migration_info which is in its
+VFIO_REGION_TYPE_MIGRATION region.
+
+The device_state controls both device action and continuous behavior.
+Setting/clearing bit groups triggers device action, and each bit controls a
+continuous device behavior.
+
+Along with the device_state the migration driver provides a data window which
+allows streaming migration data into or out of the device. The entire
+migration data, up to the end of stream must be transported from the saving to
+resuming side.
+
+A lot of flexibility is provided to user-space in how it operates these
+bits. What follows is a reference flow for saving device state in a live
+migration, with all features, and an illustration how other external non-VFIO
+entities (VCPU_RUNNING and DIRTY_TRACKING) the VMM controls fit in.
+
+  RUNNING, VCPU_RUNNING
+     Normal operating state
+  RUNNING, DIRTY_TRACKING, VCPU_RUNNING
+     Log DMAs
+
+     Stream all memory
+  SAVING | RUNNING, DIRTY_TRACKING, VCPU_RUNNING
+     Log internal device changes (pre-copy)
+
+     Stream device state through the migration window
+
+     While in this state repeat as desired:
+
+	Atomic Read and Clear DMA Dirty log
+
+	Stream dirty memory
+  SAVING | NDMA | RUNNING, VCPU_RUNNING
+     vIOMMU grace state
+
+     Complete all in progress IO page faults, idle the vIOMMU
+  SAVING | NDMA | RUNNING
+     Peer to Peer DMA grace state
+
+     Final snapshot of DMA dirty log (atomic not required)
+  SAVING
+     Stream final device state through the migration window
+
+     Copy final dirty data
+  0
+     Device is halted
+
+and the reference flow for resuming:
+
+  RUNNING
+     Use ioctl(VFIO_GROUP_GET_DEVICE_FD) to obtain a fresh device
+  RESUMING
+     Push in migration data.
+  NDMA | RUNNING
+     Peer to Peer DMA grace state
+  RUNNING, VCPU_RUNNING
+     Normal operating state
+
+If the VMM has multiple VFIO devices undergoing migration then the grace
+states act as cross device synchronization points. The VMM must bring all
+devices to the grace state before advancing past it.
+
+The above reference flows are built around specific requirements on the
+migration driver for its implementation of the device_state input.
+
+The device_state cannot change asynchronously, upon writing the
+device_state the driver will either keep the current state and return
+failure, return failure and go to ERROR, or succeed and go to the new state.
+
+Event triggered actions happen when user-space requests a new device_state
+that differs from the current device_state. Actions happen on a bit group
+basis:
+
+ SAVING
+   The device clears the data window and prepares to stream migration data.
+   The entire data from the start of SAVING to the end of stream is transfered
+   to the other side to execute a resume.
+
+ SAVING | RUNNING
+   The device beings streaming 'pre copy' migration data through the window.
+
+   A device that does not support internal state logging should return a 0
+   length stream.
+
+   The migration window may reach an end of stream, this can be a permanent or
+   temporary condition.
+
+   User space can do SAVING | !RUNNING at any time, any in progress transfer
+   through the migration window is carried forward.
+
+   This allows the device to implement a dirty log for its internal state.
+   During this state the data window should present the device state being
+   logged and during SAVING | !RUNNING the data window should transfer the
+   dirtied state and conclude the migration data.
+
+   The state is only concerned with internal device state. External DMAs are
+   covered by the separate DIRTY_TRACKING function.
+
+ SAVING | !RUNNING
+   The device captures its internal state and streams it through the
+   migration window.
+
+   When the migration window reaches an end of stream the saving is concluded
+   and there is no further data. All of the migration data streamed from the
+   time SAVING starts to this final end of stream is concatenated together
+   and provided to RESUMING.
+
+   Devices that cannot log internal state changes stream all their device
+   state here.
+
+ RESUMING
+   The data window is cleared, opened, and can receive the migration data
+   stream. The device must always be able to enter resuming and it may reset
+   the device to do so.
+
+ !RESUMING
+   All the data transferred into the data window is loaded into the device's
+   internal state.
+
+   The internal state of a device is undefined while in RESUMING. To abort a
+   RESUMING and return to a known state issue a VFIO_DEVICE_RESET.
+
+   If the migration data is invalid then the ERROR state must be set.
+
+Continuous actions are in effect when device_state bit groups are active:
+
+ RUNNING | NDMA
+   The device is not allowed to issue new DMA operations.
+
+   Whenever the kernel returns with a device_state of NDMA there can be no
+   in progress DMAs.
+
+ !RUNNING
+   The device should not change its internal state. Further implies the NDMA
+   behavior above.
+
+ SAVING | !RUNNING
+   RESUMING | !RUNNING
+   The device may assume there are no incoming MMIO operations.
+
+   Internal state logging can stop.
+
+ RUNNING
+   The device can alter its internal state and must respond to incoming MMIO.
+
+ SAVING | RUNNING
+   The device is logging changes to the internal state.
+
+ ERROR
+   The behavior of the device is largely undefined. The device must be
+   recovered by issuing VFIO_DEVICE_RESET or closing the device file
+   descriptor.
+
+   However, devices supporting NDMA must behave as though NDMA is asserted
+   during ERROR to avoid corrupting other devices or a VM during a failed
+   migration.
+
+When multiple bits change in the device_state they may describe multiple event
+triggered actions, and multiple changes to continuous actions.  The migration
+driver must process the new device_state bits in a priority order:
+
+ - NDMA
+ - !RUNNING
+ - SAVING | !RUNNING
+ - RESUMING
+ - !RESUMING
+ - RUNNING
+ - SAVING | RUNNING
+ - !NDMA
+
+In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
+device back to device_state RUNNING. When a migration driver executes this
+ioctl it should discard the data window and set device_state to RUNNING as
+part of resetting the device to a clean state. This must happen even if the
+device_state has errored. A freshly opened device FD should always be in
+the RUNNING state.
+
+The migration driver has limitations on what device state it can affect. Any
+device state controlled by general kernel subsystems must not be changed
+during RESUME, and SAVING must tolerate mutation of this state. Change to
+externally controlled device state can happen at any time, asynchronously, to
+the migration (ie interrupt rebalancing).
+
+Some examples of externally controlled state:
+ - MSI-X interrupt page
+ - MSI/legacy interrupt configuration
+ - Large parts of the PCI configuration space, ie common control bits
+ - PCI power management
+ - Changes via VFIO_DEVICE_SET_IRQS
+
+During !RUNNING, especially during SAVING and RESUMING, the device may have
+limitations on what it can tolerate. An ideal device will discard/return all
+ones to all incoming MMIO, PIO, or equivalent operations (exclusive of the
+external state above) in !RUNNING. However, devices are free to have undefined
+behavior if they receive incoming operations. This includes
+corrupting/aborting the migration, dirtying pages, and segfaulting user-space.
+
+However, a device may not compromise system integrity if it is subjected to a
+MMIO. It cannot trigger an error TLP, it cannot trigger an x86 Machine Check
+or similar, and it cannot compromise device isolation.
+
+There are several edge cases that user-space should keep in mind when
+implementing migration:
+
+- Device Peer to Peer DMA. In this case devices are able issue DMAs to each
+  other's MMIO regions. The VMM can permit this if it maps the MMIO memory into
+  the IOMMU.
+
+  As Peer to Peer DMA is a MMIO touch like any other, it is important that
+  userspace suspend these accesses before entering any device_state where MMIO
+  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
+  state. Userspace may also choose to never install MMIO mappings into the
+  IOMMU if devices do not support NDMA and rely on that to guarantee quiet
+  MMIO.
+
+  The Peer to Peer Grace States exist so that all devices may reach RUNNING
+  before any device is subjected to a MMIO access.
+
+  Failure to guarantee quiet MMIO may allow a hostile VM to use P2P to violate
+  the no-MMIO restriction during SAVING or RESUMING and corrupt the migration
+  on devices that cannot protect themselves.
+
+- IOMMU Page faults handled in user-space can occur at any time. A migration
+  driver is not required to serialize in-progress page faults. It can assume
+  that all page faults are completed before entering SAVING | !RUNNING. Since
+  the guest VCPU is required to complete page faults the VMM can accomplish
+  this by asserting NDMA | VCPU_RUNNING and clearing all pending page faults
+  before clearing VCPU_RUNNING.
+
+  Device that do not support NDMA cannot be configured to generate page faults
+  that require the VCPU to complete.
+
+- Atomic Read and Clear of the DMA log is a HW feature. If the tracker
+  cannot support this, then NDMA could be used to synthesize it less
+  efficiently.
+
+- NDMA is optional. If the device does not support this then the NDMA States
+  are pushed down to the next step in the sequence and various behaviors that
+  rely on NDMA cannot be used.
+
+  NDMA is made optional to support simple HW implementations that either just
+  cannot do NDMA, or cannot do NDMA without a performance cost. NDMA is only
+  necessary for special features like P2P and PRI, so devices can omit it in
+  exchange for limitations on the guest.
+
+- Devices that have their HW migration control MMIO registers inside the same
+  iommu_group as the VFIO device have some special considerations. In this
+  case a driver will be operating HW registers from kernel space that are also
+  subjected to userspace controlled DMA due to the iommu_group.
+
+  This immediately raises a security concern as user-space can use Peer to
+  Peer DMA to manipulate these migration control registers concurrently with
+  any kernel actions.
+
+  A device driver operating such a device must ensure that kernel integrity
+  cannot be broken by hostile user space operating the migration MMIO
+  registers via peer to peer, at any point in the sequence. Further the kernel
+  cannot use DMA to transfer any migration data.
+
+  However, as discussed above in the "Device Peer to Peer DMA" section, it can
+  assume quiet MMIO as a condition to have a successful and uncorrupted
+  migration.
+
+To elaborate details on the reference flows, they assume the following details
+about the external behaviors:
+
+ !VCPU_RUNNING
+   User-space must not generate dirty pages or issue MMIO, PIO or equivalent
+   operations to devices.  For a VMM this would typically be controlled by
+   KVM.
+
+ DIRTY_TRACKING
+   Clear the DMA log and start DMA logging
+
+   DMA logs should be readable with an "atomic test and clear" to allow
+   continuous non-disruptive sampling of the log.
+
+   This is controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the container
+   fd.
+
+ !DIRTY_TRACKING
+   Freeze the DMA log, stop tracking and allow user-space to read it.
+
+   If user-space is going to have any use of the dirty log it must ensure that
+   all DMA is suspended before clearing DIRTY_TRACKING, for instance by using
+   NDMA or !RUNNING on all VFIO devices.
+
+
+TDB - discoverable feature flag for NDMA
+TDB IMS xlation
+TBD PASID xlation
 
 VFIO bus driver API
 -------------------------------------------------------------------------------

base-commit: ae0351a976d1880cf152de2bc680f1dff14d9049
-- 
2.34.1

