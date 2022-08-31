Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEEA5A731F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiHaBCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiHaBCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:19 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488A7AEDA9
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJJ7r18CNTGg1ED2B7L7UuCzlQqPzbM/kvvGyL0RSSvkPAQgGWcJVYV47oGrkd7/11iNDd/Od2OqB3GYZKL1RmkP0e4RlGrBD5VoEajSNBWori1abm8M07uayNj2HW1M89AjQ4NA1LH6nURHut7meLQoQgSZ/XFjNK43hjE3s8cxqJDGxLE37MKw4DhLtD9loz7wVYMCb4iaWg3yyFjDFg90+ef7hb0nh61L0rzijiRlUU10VdsOKokxJze/Fj9ZsYO8gIp1ou2rKfo0vlCh2+PTfn4elEORJvunuYyDDG/VGeOdTAemGRQtMoX5NQQqqOC01vYSQArbbz0FKdHnlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aUKJrrWlM+LtmB30batMTT3uepEW+w4PxHvNYYeoxo=;
 b=hvRPTexAm2mbyTjr2kfJ/TIJN3XbIeLiRHovj5MZ1hzeh3Xu7++BVr5N1xKQ/qykL/WihyjgXYDSZm8hkjkgUuKRcu8wKjyXzI0N6yhKiJzGxk2B6hZEU77ufdL2VsYfPcQh8IlACb9i/bJLOgdCYamSB8QaC3k2m14Lxe4UpOd2sfoYilMkh8tcYNW/Mzo678moi9X0EaCApiPGBWwpmR7MZKtudI8UzwNb99RcMmOIxbEGEaCWZcqTdtLGf61dwvhtRzAUKccEL5aqNl+NDbU06CFdxGSlvbTlC38JnhEV8hmS93UCBmmZp5xrmgT+FaMSpxoSVGuljNansWhUIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aUKJrrWlM+LtmB30batMTT3uepEW+w4PxHvNYYeoxo=;
 b=ZKkMM+oUlTiG6sUBAzs3LU1Eu3glr87W9c+Lw3Z0Nkk42csS4BCd8O+7hZeJOjX0Rsmz0XKF5G7scI/5dS1bGLoZmYb0dctTgymCrKiDq6ct7XOZfXfvzUm2wGkSMKo0VBUysVBnmT7vfCTAncvHt3x2dr2rHXN0QgSTwExi9SE0Eva5JOtlmGoker/BXqFaV6shIIUiXuSd9IKXCcx8VSHetPRpYoXOLxEOgjPkKSW56JbxZg3oNxISu0bH1HvRgGwIS3ugV81Xcf8I3viHw+Uf3/aC1yOinayLQ05qQU619XxtfjkOb6LPc5zH/6PvFnC9SyKytpJdD5s1X++EMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 0/8] vfio: Split the container code into a clean layer and dedicated file
Date:   Tue, 30 Aug 2022 22:01:54 -0300
Message-Id: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:207:3d::46) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 790940ba-027e-4df7-a810-08da8aec6b6b
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WRIzvSmXYcdrB1ItLAKhhAXXlGwgiR1nZ+gEI5f5C3R7vONVWbg+MUl3rUP4hlUxKc0eZh6OsWykFju9cITtZqiiAGb0PXwoh66mBVb+QE1xx7IJb/hWHGj8g0cc9OtSaLuqTEhpNRmxrRQX7P0F5SWwJ7zEmzdIIU9g+IaMqac0G283Pg1Efqpwmv6xyyjRA6TfohyplzGazDlBWRmFuLa52LS/xr+KcQgEvOJnglYsA6dRoSDSOixuFkbp+tnzWQqGJe2VcNhTJC+9MqBIiWKOOO00+xNXrgD+9MFt1BwRtNNg/h+NaMraw203rhI5r04GUqQTAzF+Vz1YE82FGyaI8xumgp2v8G+UuZ+b6g/9z7y4oYHy/FHHv6JaBtVJbKV4M25UEEgUT7m3M2d461/fzHeSmVwrv/sUgfKcZhmn3Yiw2F5R3ft0d+iVBOoRA1JEA60YNCSsJVusewN/ZPl0Uwh/LK84IIgybNids1RdYoLzcKB1yW8BNLAMVv4ai9UfbMalv92So6/AaKCf9lLo1kUqRr9Fm6E0OJufRU6O6MJIWTiWSAgB+om4I0zHVcYM4gfCftPxbMqJ2+gbUIDjhkE+022Y+1ks9pTwFkMh00oso2QmU9tappSEgzv9CzDYINHoBgHEIrcRw8AHiBSDUW97ZP9Lh0/HahvinTWa73ngfjxRGoJwoYLgkTqMdbn0zphPUB/PSUC5zrC/kI+CCE/UcXTFkgjMNSGtOSMhcBLoS+YX/rZDVNFl6Lh602xuOMHY23+CLGAGKffH9cLJydAu9G6ZoZNg9+hiuh4LK3vrqDP/WX4wWSjXDqiTFh9sESVVo67IU+aIl5S5tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(966005)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(6666004)(38100700002)(83380400001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UksI4tv3Iu9+30W3f2MSHH9QB6mYOAtJu+rjay8i+0t7HTh42rDVHgKiez2R?=
 =?us-ascii?Q?orOolHYaZN1j8yQ2GS+qNMoKi+QkVjFQOfwK3y9Gm73acO1AmRE5lkacwj0Q?=
 =?us-ascii?Q?m63RC9hXd/NctcLf+gYnQApMvjVBZjgxL7W1qfwcwWRZALPs1W3wgL2WhHJ3?=
 =?us-ascii?Q?47UWydJncwXp2yWGe/Qe4Ut57oYZx0QjPwgY/t86kAHXPCZAF7tI1kO+q1NN?=
 =?us-ascii?Q?sTPfRPb57cZCv8Op6IRxbv4XfHsPRm/Fvd1x6SbY+LEyKwwsLww5aj2o+Nto?=
 =?us-ascii?Q?tcyIvuBo3/SGluZMVPjR/kLO0sDnGdml7elar9vVuvbbbW+j4e6QRggfZCJN?=
 =?us-ascii?Q?TqiYGktOTCwm3vaE+eyzDb3fpFVfdCi4kdudXFGDRXN7h0F206Yt0aEcIHWX?=
 =?us-ascii?Q?uq5QK7bXjjvJtfaFSoHmPfc05MBhZS2Zdxn22gAh6c/Vj9lU4aEpH+gcyJfr?=
 =?us-ascii?Q?yatAd2kVSw03D3dCCWcIWF9aIfhGk16FxtvacN88LtD+bSexa3LOBnJHYVCq?=
 =?us-ascii?Q?f8ArDwTsU+lolWjwLhIXHJr5tM8HJQjkSdP4kM9KjujG2XPSR1w6E63wtPOS?=
 =?us-ascii?Q?2QII/k4Rcx4s0DsXMYprg1OL6fS2diGkRqlUyhDhPN9bG+Q2NoVa1G7OGms0?=
 =?us-ascii?Q?nDrpQxXnVcQ8LUQzZzo3wIcxev4nypoN47szxnMRBiwAcKXc5WjWqeuacxHq?=
 =?us-ascii?Q?NktMLTdYVd5eaiyCgV2UoDXY8n8RR12DlQpH/f2E2hrugjRQZZ9kVXPLqY6L?=
 =?us-ascii?Q?vg/50j78KaPJm1RQURSJ/hZVsp2lDgNdGJq5TL9FHoNU2YvW6WuGnKYygjeI?=
 =?us-ascii?Q?rj3YCQ2ejfxxvXBKJU4PGrWlUb1V80rH4KLIXVe3kQPCkNsbqhrTVOY0mkhd?=
 =?us-ascii?Q?kD8s4XWbqgXKKYd4OT8B0Ag0+QPTwFxG/FHxO8Vt2d/x1Mzn8bMXQogHa7vT?=
 =?us-ascii?Q?X/8tGKthnMF2puO0KeWJHunHExsHcs19eiu/kKTSJuO8wG+1JEeLtxsp/5Li?=
 =?us-ascii?Q?89EQEealmOjjzO8m57wSFv/JB1jtc9WYVZknyro9VA59q3A/tsFkDd1nxv1v?=
 =?us-ascii?Q?EqViw106Rbr0osi3JPGWS/p/N4A66JnGrVS6qn4IF1+BlLm/0WeO4uWKpu0N?=
 =?us-ascii?Q?oJPdaQ8GMqpyMYpuRqwHIvfu0V9FEA9iYKrDQOFT8ngE+8cElor7lYQiVnlF?=
 =?us-ascii?Q?tsuMqWASLfgekoTSi1t5jObRxpyYlJXvRRRp1uogTJsI+akphNLViRSeN8iQ?=
 =?us-ascii?Q?TOe2fok8syvdtCtWSPqN5DRvdnFiu6TNmKfa8CCpkueCEdCMmleOrZZkVYsS?=
 =?us-ascii?Q?cxRJiNegiAU2XvH2j51PWltMbcBVsHKxvNiNaoxksGfY+tncuDlZQ/A18gDC?=
 =?us-ascii?Q?2max7rzq1jyCYpp7vqjN7JDynBJK8QNg8TJwXoqz8pcCyndsKI2rEP7cLGOA?=
 =?us-ascii?Q?ztbGr2GQgrecOmNPCug38nvYZUuNpj1qZAOZoRL7cpC7KFAD73Q22CMIOWKn?=
 =?us-ascii?Q?JYQeTztKHsTp29s6HnXM6l6y1wBDwZ4eLDXIk30/pKKEcOJZ9eUj5/3NvVbH?=
 =?us-ascii?Q?KBSF1Hm2rodgz0G9nQ7kSbq+Nkd0yym4s9WHQjkI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790940ba-027e-4df7-a810-08da8aec6b6b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:04.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykQT70/MBL9R3K709go1LcsfntWvgkLlI70A2/hIExYeYrGPqKQw7qPAsqSpFA6o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This creates an isolated layer around the container FD code and everything
under it, including the VFIO iommu drivers. All this code is placed into
container.c, along with the "struct vfio_container" to compartmentalize
it.

Future patches will provide an iommufd based layer that gives the same API
as the container layer and choose which layer to go to based on how
userspace operates.

The patches continue to split up existing functions and finally the last
patch just moves every function that is a "container" function to the new
file and creates the global symbols to link them together.

Cross-file container functions are prefixed with vfio_container_* for
clarity.

The last patch can be defered and queued during the merge window to manage
conflicts. The earlier patches should be fine immediately conflicts wise.

This is the last big series I have to enable basic iommufd functionality.
As part of the iommufd series the entire container.c becomes conditionally
compiled:

https://github.com/jgunthorpe/linux/commits/vfio_iommufd

This applies on top of the prior two series:
 Break up ioctl dispatch functions to one function per ioctl
 Remove private items from linux/vfio_pci_core.h

Jason Gunthorpe (8):
  vfio: Add header guards and includes to drivers/vfio/vfio.h
  vfio: Rename __vfio_group_unset_container()
  vfio: Split the container logic into vfio_container_attach_group()
  vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
  vfio: Split out container code from the init/cleanup functions
  vfio: Rename vfio_ioctl_check_extension()
  vfio: Split the register_device ops call into functions
  vfio: Move container code into drivers/vfio/container.c

 drivers/vfio/Makefile    |   1 +
 drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  57 ++++
 drivers/vfio/vfio_main.c | 709 ++-------------------------------------
 4 files changed, 766 insertions(+), 681 deletions(-)
 create mode 100644 drivers/vfio/container.c


base-commit: 456bc2e671af7852f8a028c8069906b6b6fa1ff9
-- 
2.37.2

