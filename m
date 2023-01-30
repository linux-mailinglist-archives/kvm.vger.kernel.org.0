Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D6268192D
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbjA3Sat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238254AbjA3Sac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:30:32 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20602.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC83D0BC
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:29:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M77je2SZQAk0ilxU8ZNqHJrlgKQtkJg1qyYA9TDHfwGgbx8ub0pW0LotMCnSa4FV06jR2T3cQ5SMJcXX/HnNXyK3539A34QyV4rrYSqZz8fjvUErCObMKSeNCjYNSo5K5xVCsCQY0Y2fDT6rSjDGYR/PEo9JZneXNnQ/u55ZyBWXju7j0KA8CZ8AWyAcQmVEM3J36iXItd7S2IqMtKJ2pbnDaMDmJfl1SRnkGdmBpR34DGpYI3oR8JKJHwD3hVOfEq5cFJB/MGRh2knfXWomsKdHG4Mpevq8pnao+DOqB1ZlGJ1aKWCiThBG7zRcznlpZ1b/SyhrcW2CNeUGxWuNMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWjcXSuECjnxiGTvuAmHBGi+F4VQAgZ3M35pwKf/X74=;
 b=jRIq0omevJAq4OElASL92D8IBXP+gWvThlh4+kmdblr/6EZFq+r7T23/zslFkhYhLYR/0RaSc5/K+DEhfsqs4VEoH68h7cPwBcFV81wTU1LrwhyatvvGgSDUWEusnrUzVXSd/9w3eAIEofyQec9QJs7j+W97pWqDvnR//4btseUQo6aQgQDi8/Q1MKF2e7DNsMrSwJPaK5uthVz53ULSNKGblGXJ8cRndVyRh8iLcCDJ/QzCI96bi4J0VCbVZM7Om74DLVk78XRLZcTVdP3Gbv6QfddP3epRRYzQ5b2j7SydpNVBHEF+Kl5r83wjDS5pJg07voM416sXMqInTZgAAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWjcXSuECjnxiGTvuAmHBGi+F4VQAgZ3M35pwKf/X74=;
 b=oxvJ3W+NgLVCRwtcp5eJXtMtZBzEoIMU7JgKjhpfdVEb3NzGRjfCgDd7FxyhiLBLmLBYY3GhQ4VzfUQ++rNLsMmhQOwktPPH8wjJt0sgryageQZUI3d0B07QdOaoaGoSOZgmpNAGbVJ50e2IofoHawVDFU/AWuftveGpKQXtYTC7X7tsiXl05oWuG+WwPe7PirLqIvdZYkuCB22N0BekNWrrPbc6Q1sRjXyJJD0sVzBbpzZWW0eaFyKZjlpSmblsHjPWGcCG6y0h/KCmMA20UA13e1yLJtvdmLrkaIFPsPAxbcFKiu5oNorSropbhsB51cuOcqBaQOYJaCn6RN2h7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 18:28:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 18:28:55 +0000
Date:   Mon, 30 Jan 2023 14:28:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <Y9gMZmvFDOW5LaWv@nvidia.com>
References: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0115.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d4c72b-6443-49fb-3cdb-08db02efd888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wD+qEOzvSl1S/o64WM94JiOBZZZORi8jyQWjc8mCk1WT7223+7R0uEI1vZx1tEKeMT2XMSWg3z9TXv0CLhFuAgbMg8w8B99EZGzPfFjopdQguTfErrhQv0XI9S1uO337WDwGatv6lcH2qKIyzFUoEbrcqIzi+EdLFqUh+QzC3VH/HJ5NBgiEKqO+amD66vSgqDOQnzT703LKu6eoHLzaTGfQ1ga91CoREABIV8oIf2cUU02RW0MwRCh5gX4jsxlVEYq7iBx/EzTuS3K2Y2BeS1+1/qRaz+I8UsEt28adXzVUrOWd2wful01XS0Fd5wtRoCH0SC+VOMamcERNK0QqFaEJ2hHqJeRIDhWwFWGoCRQqp0OGhbQuGwc0yJOuLvrOtjF9tjCAcoLcSwbNnUCg03vqRJLHZolAXyHZMfkDHcPZvbuiBWDjjhDITswaq5foOkAAxAVjDA61w4ixgUdxIWAkpD7aJiapCqQNCGo7+2hkXB8xPaKpaS38V6+JodBwqzhOAoruy4No/TnsEj42/tJeEFHOgH5Kq+JCti9XzrDKz9wlpj2f2C+Eel8Gz9YyrFFF820qlo0/s4RgWFVEPhZhS1BQoZZowhLGQwuRNpvCmCRJtS5jxMG/fzdQjpwBJsM5cfdfqROmffgjoFCoW5IMep/oCkci6TbKRwgmQDwc6UyZfxB9jMMS1ranO1GeAxYVa7Hnc07P3vXfdb7ZxQaxUQYqEWCPTqf4/C7tO3K6cbJkujaJBDk9QYdNOusjqUFR8EbKA5h/PqEQ1drRQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(8676002)(38100700002)(66946007)(8936002)(66556008)(316002)(66476007)(83380400001)(5660300002)(26005)(186003)(6512007)(2906002)(110136005)(41300700001)(478600001)(6506007)(966005)(6486002)(86362001)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7EJnbD3zWteSblKxFZ3UFWiWUoFGzfl8V/kozj51cpDzwj7GshEgEGsCyBq?=
 =?us-ascii?Q?DF7T3KrF0mTsX3X0nbdeKGkFRTpsMcAaSWVhouPWwLhGNo4rdew/yexAT0d3?=
 =?us-ascii?Q?QPeVNFeRor6W+Sbob81OVgmQZDKCLZ52PaLKq3pumRO+j+G4H82/2UP7UgRB?=
 =?us-ascii?Q?HFnH0Ip1YRqFJ1xhe4tWYaPHloseFCXThZapSbERztuUvqFXGYEIvWE4ne22?=
 =?us-ascii?Q?OY5NXOo6eE02bDJGWuXKwfOJIS8xkrvsPYaxyhd9YK7kspe+ZS+W1fGl6L4O?=
 =?us-ascii?Q?Le9UJ47/+cwRjZzuQESk8suOmQeEvGFEEu3P1457j/Bzy3gSQJdKvrzffWUw?=
 =?us-ascii?Q?lPF0jBAZEmiuHCdSMmKIzWIGQdT3oQDNZuW+6BpYlpsgpAO50GaJNJVzPRxj?=
 =?us-ascii?Q?Vb1qUS2t0VRLJXA/HwXmGRHFCD2YOnaxfbtvCN7y/gQ4wJXcqxCH5RHaYbbl?=
 =?us-ascii?Q?usvQr8eAXIT+iavxTXqVXFkRLrzYLw7er3LuGX26PvtqX026g8q1ZtdjVBGD?=
 =?us-ascii?Q?l+wuE+fAzwfc1GtzfDM6txcvJeTux6Lk5CUxS6B0g06JtqGF1onhgpnuJSuJ?=
 =?us-ascii?Q?WtUXxNUuXiZjZ6TS2lqNEQbzh0n9ADBQdtZRCB2HUu+QDIO+QupwUlcu60fG?=
 =?us-ascii?Q?V/UtiSm2s8DBgHKV6JAv5FcczKdX20njMW6JyyR5OpNqfqd0Gn64P/QgLFiP?=
 =?us-ascii?Q?fIng3aHMMY7qZVUzJrqn/19yMoYnVMUqh+lJQMnMtMaM7Cun9oDUjE8Mbx/e?=
 =?us-ascii?Q?UMzRMkTeW84FX8Hk4EYcOPBjzG/GwVZ3Y+rFMSWJHgyP4Ub16K2dsTfRpTYF?=
 =?us-ascii?Q?Mg7VlNFZzCl8GHV3Itbfyuuyh597O8aqICq5ncw7khH9YQFPUxYxw7fxItx7?=
 =?us-ascii?Q?SHWkr7Uf84KrkHrUOq4vQGGnCcYkiLnzr9KXdymoBL2V+ek1U1af+CoDVTos?=
 =?us-ascii?Q?dFjzefLT5qfoCDxBHovzMj7HjC0M9/QwegtG0R7Cc5NyklYJDmBGNDk6ETJZ?=
 =?us-ascii?Q?lMqArUE1BSpMVvmt06cBfeRfsWTuqkrwKJE0XQHZE9XlMnfJX7WKhv34khYs?=
 =?us-ascii?Q?kZL0DUyZkQtg9gVzLLnplH1iXax+CnO3Xm9FbMUPIpkApG9WpYbqSTryyIO8?=
 =?us-ascii?Q?7y0opc3N343s87buImuT9TfDKO0WVLoqq1gih6pshJwLzyRMQBzQDuiitpzl?=
 =?us-ascii?Q?nGrIMcpgBLxJ7DeZsQfJkwxAJCutZsnKGRcYAiV7Sj9RIdZ89GzGzsAkl6HB?=
 =?us-ascii?Q?psU38rvEiMdQK/gA8xSfIhQjiuaSO6SiEDs7LJ4ARldzFrGrtWnjSbvVuznx?=
 =?us-ascii?Q?oYrhYfC0xXtUrVagYYjfMGI7iUHBnqLlwC5RzG4qFrQHvCPQ2hzl4wPVRQON?=
 =?us-ascii?Q?9JULlhwQXQx9UFqr1hyFZvaHv9jvVncAExIN8GaP4xkFjPb3bmLwEYtgVtvM?=
 =?us-ascii?Q?zBQWx+Zugv/VYd2gDc7+rdIY/7T65SJ7IEj+ZoiUd2RKYVATy+rWlyhdRotG?=
 =?us-ascii?Q?PdMikeC//lfqMa1JKRF7LCSCftKhY0OLcRzvB4L4lYx0QJNVmeUi1bOSznoE?=
 =?us-ascii?Q?xLex+Uz5wVUuu3E71Xj+8Pr7MalQAMfUJLGivZ3X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d4c72b-6443-49fb-3cdb-08db02efd888
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 18:28:55.7397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewHK8xio3qXv+ZejEH+g7U5y13yYkf8n4bbuwdSSNUiiOSWLlVt8CuE0HKUHdsK1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 01:50:28PM -0400, Jason Gunthorpe wrote:
> Add a small amount of emulation to vfio_compat to accept the SET_IOMMU to
> VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working on a
> no-iommu enabled device.
> 
> Move the enable_unsafe_noiommu_mode module out of container.c into
> vfio_main.c so that it is always available even if VFIO_CONTAINER=n.
> 
> This passes Alex's mini-test:
> 
> https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-open.c
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/Kconfig           |   2 +-
>  drivers/iommu/iommufd/iommufd_private.h |   2 +
>  drivers/iommu/iommufd/vfio_compat.c     | 105 +++++++++++++++++++-----
>  drivers/vfio/Kconfig                    |   2 +-
>  drivers/vfio/container.c                |   7 --
>  drivers/vfio/group.c                    |   7 +-
>  drivers/vfio/iommufd.c                  |  19 ++++-
>  drivers/vfio/vfio.h                     |   8 +-
>  drivers/vfio/vfio_main.c                |   7 ++
>  include/linux/iommufd.h                 |  12 ++-
>  10 files changed, 136 insertions(+), 35 deletions(-)
> 
> v3:
>  - Missed kdoc
>  - Incorrect indent
>  - Consolidate duplicate code into vfio_device_is_noiommu()
> v2: https://lore.kernel.org/r/0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com
>  - Passes Alex's test
>  - Fix a spelling error for s/CONFIG_VFIO_NO_IOMMU/CONFIG_VFIO_NOIOMMU/
>  - Prevent type1 mode from being requested and prevent a compat IOAS from being
>    auto created with an additional context global trap door flag
>  - Make it so VFIO_CONTAINER=n still creates the module option and related machinery
>  - Comment updates
> v1: https://lore.kernel.org/all/0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com
> 
> Alex, if you are good with this can you ack it and I'll send you a PR. Yi will
> need to rebase his series on top of it.

Alex are we OK?

Jason
