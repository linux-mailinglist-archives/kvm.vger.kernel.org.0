Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF59D5EF84E
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiI2PFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiI2PFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:05:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F1570E53
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:05:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqW3xQVFO7+5ICxYwy6YTK5ROS7vYkAei/ns5/FoZKUp9Jy2fdXc2q2E9nJ3DPvHigPK+JBAYDNOMeBf8PwU9n8sb7wYrNoO8AHAV2LpoqHFXHzs6dZOoioQLNbNYaBAMFWe7z4gqdLZ+gDuDLd6t1SN5k/IaYqzeL2WC6tEWSK8HOAZiP5BiuOFDUsR8pMIkgGRQrCb/rm3IW5d8mbD7TZtIJaPHYQ3W1r9e4/8KMAr3yN9aWTZYIJixAGP6u8cFEWq3yPne+dnmiP3AbdjZ2Zc6mVk8ZcvBY3fvLEbawtAzA4app5rP1LuQa//B9rGR1wQuuhumCO+Nqe1vmu9lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41eXCqzkAZhFJeqGwUL/WHYe8UHnQudB8HeZCoApyOg=;
 b=AQ+74GmZ1rjxoipGNYYTZNrzkUWDSyNa1a5FVWvtM/q38i8db+S9lax/zDVGp+s5GF6bwJJUAYQ11FpJn7n12d2uwaXDOX9swsjSmJJ9fZZGpjgk4bRSZyaXy3kqneCYy6Vd2dFOysWvUSnJh/hpUF/g9jD9qicqmf8Vs0e70mNEKPVhgb/3KrHcbpwAZEulSqR/jcwpGXGxvfXJHbCiFg6pthgyGC0vf38EavDc72kY352O440ndplIQhhhDUYXExrsXgfWaGtitOc1uT0RJP2itLTh5onPIXsNiu7VJ716t+oNbFDcgGuzCECWs5mmOT1H0HHPVZF/75m5h3onOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41eXCqzkAZhFJeqGwUL/WHYe8UHnQudB8HeZCoApyOg=;
 b=MPxBHpv4Eh3MPYl5qEUlLoGXfnA6gXya4mhbBCGz9MEfB87N0k8WhEpej8wDdYbNtvMblCqCahudiGOHA75zvp+bnijcIXLGJ1GYqjMbjISOP8HHR1O81PgMwQWj5XnYjict9VRlmxQUIbGUgPJ0tdegFX/tF2lMh51pUmFhUUur+TUuaSXDHwaPF46NS9dIM+5g4FzXT4EyNR0ZPfumOAmo8A99SZ9A/ifODvnq2j+6mBJ4IZWQuREXDBNQ0L3Y/vYTiidJboLfW1CFfA+QgdSMkQ0wa8/3CZFmifdG+GeXLmO3x5LYfrWG03MB1Z2vvMranHvBzfvsAhzC4uIOFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 15:05:01 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 15:05:01 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 0/4] Simplify the module and kconfig structure in vfio
Date:   Thu, 29 Sep 2022 12:04:54 -0300
Message-Id: <0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0061.namprd02.prod.outlook.com
 (2603:10b6:207:3d::38) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: d407cc2c-e08a-4967-a066-08daa22bfabf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1Q4dSCt4Xre2ZfbP/7kbHRRLMU3h6BFwvrKCel+N61u9E+DSjSAsNm2RK3+L7mNWm/9PTZiJrJAa9/1g/wA6eSoXu9IqcEcYRf1vIKX9wYhvlDU7dApUtdssYCbLkLVMztuCnEzW580ZsoL6fMP+boyngyQhpp43Mf9FbxYKUZ/nP/sugfUeyHcRUv/UCG2kzajuA3uXsquO0UFT3BCcR0QDfWoO4yvjJCTz5OtgrbRJMgDyJUUdOQli2R++JmLCqmzGEnVlEplArDwhH37rw9AXfpMMB/yqBmroOviwqAguVb7MwmoIdUGhSg1F57/jErLRTXeulzshRGn+x54lkPEsKdmupXGAcGzDXjcS0wK0gQLy1KeAObtN4Ir6UMC/y3OsCQQjGPE3j0Xc/FZ4RYK7+oYbcx22XE3iPRyGeys0wCAtEsLvgm+5nyiMrxQ5zGtNEII+ZMcDOiKq4oRRtaESPGP8CpECgT7yQQQ0I6Fj06GCKmt7OEqzZ3dkSuj06yI6+RPWfJqaHwxADyJb85JHd0V7mfqOdJnmt9TtcHU/bOEM1gnI+ZSiAmq17RbV98m2JZlGsFWOSOLc1JEZMKdEBVm8TSFKadUs4Gu/oY8UB7lCscFPiZjMgqx0XMVd6cx/sUtEFl0gqNgIWWErOUYhZQpjnMooB3FRcn2di1MsmpY3MMUmriWRUVJkdO5wlSfjvgH3FRKlN/BGZVuvB1cotwi/5/EIuxhBOGy+YZW8hwaCazrBBanxoirl1MC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(8676002)(83380400001)(186003)(38100700002)(2616005)(4744005)(6512007)(2906002)(41300700001)(8936002)(5660300002)(6486002)(478600001)(26005)(6506007)(6666004)(66476007)(66556008)(316002)(66946007)(110136005)(36756003)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2b+7+/hLuUROph6GMGtbmIMklnY7cvs+Lk3QuUoSWEF4E+1lwtO7RygkyVE/?=
 =?us-ascii?Q?Nn22EANcB8pg0UYcc2RqVUEFnjfVo+OkIL55n8GGvdD2sOxRVW69/WvlDZ0U?=
 =?us-ascii?Q?UEGSsXWrr2xMni1pXTA3l8LYGitIBtpjA5xLf+yVFMxxrqaiMgqGX3vroDUE?=
 =?us-ascii?Q?aAphx72YQGcDqAEOZPgH/LEHt4rpXxv8X2Q9qUM884sZtu9kHEXA2/FV9rAd?=
 =?us-ascii?Q?gb4KkqIUYCe7cC8XQFbpIwaWMy/ozm8dmef/XjKLHUOyEDUHxNQm32MapGUm?=
 =?us-ascii?Q?CfCMBoo7dinjMLWZTzzU8N6PmaWyt7d2+uOMgKQz1HSLt1xpJ913Yic/3ysQ?=
 =?us-ascii?Q?aWmveP5+xP6bDlVAYDcWyMY9i/nSpQBrmauvvEtHLaNQTGKYc+hzVoEd+ey5?=
 =?us-ascii?Q?p23ww9sSIkRM/tZ1at1hS2e4O4rXd+fvidAovSZVZ4vscaTyyrKB9bCTljsR?=
 =?us-ascii?Q?ocx2Nhjamj0/FUemh5aHndcc6EicCT2Dq1cyw7yL/opaXGtLQmHny/DLfuYo?=
 =?us-ascii?Q?9d4GlADY/4nzcOtOVMQ2uBG2Elc19KEUACLggIUoyUA1dDyahkZfCKNQ9JBk?=
 =?us-ascii?Q?hZy6SpRzccluqHXD0V9FWapoYOQGW840+cRH5L5wpmMs+j8THM56rVy7BcqW?=
 =?us-ascii?Q?Tuq3NyhjZdTjHngfCijLzPVWPuiVkCyhvghigXif5ZhK8h8UqqMRtzhdp1Bx?=
 =?us-ascii?Q?PAAIdpH46Iv1SNQaFxygYzIlyC1XqolmfJ1CeKtPy5wTG570mCtFAp+SvxyM?=
 =?us-ascii?Q?iyYxkrEVJjxI7PSLnAjREi1B06Ftc/0P9O9LVjqBfmWGCkSuL3kQLtoLlTRG?=
 =?us-ascii?Q?RkDuCjZD0iUGdbWfc4NqBlxwLjM6Biq9dQifZ15WLwRyrUBn9nF3QQKUEqzC?=
 =?us-ascii?Q?4Clkv81hwP9FODGEiXYNsXaHmFiCHASG7isGIM+kXVGUwwvFCqRo29oR32vC?=
 =?us-ascii?Q?YR/SqNvaLzYCroQZqo1ToAMulEd8n8HX+JANZlYl9Z+2bC1meAI5QmfvWcpH?=
 =?us-ascii?Q?Ag21omV+Llfa2jVcGGERMa+7REwr+cydDyU4ZHMpEF7F9pVkkLghmnRq0viT?=
 =?us-ascii?Q?LwOSQ81aAwqdiWGkY7suYKmTShykT+flDcgd/vmeFJ2SfBYlwVT05mcZp78a?=
 =?us-ascii?Q?O6xoehCGoRdtcIWj5z7zt6OwkM+aKaIctSeaJPSYtiSFfjUB2b28v53W2EK9?=
 =?us-ascii?Q?zMSOoLBA96JuP5Lv45RyUA2WF5k9L93vzszO4VvbtzXMd+rm/9HIhQWmyzKh?=
 =?us-ascii?Q?KUs51TAbygw7A6TC8E8It1QxkECU1pe2jyepfn4wY7v97su98Zf8p+WTlX35?=
 =?us-ascii?Q?InEtmRgw8TlQwqBM+SdQt1OCAt2UT2QTfizI4sKxZKwkKGEKpJZiDIPkP/ed?=
 =?us-ascii?Q?EwIco9h1pCaPwDbUbE467Jv/FHsxPeucbAO8zCTJnECn1tK6m326dObHzVeq?=
 =?us-ascii?Q?Xq+6GL4ZqM0DkHH1FDkdHhYKwFfg7TkOUqN4TAPipDswgVGXLSHi5EurRIh1?=
 =?us-ascii?Q?SOB4gXotMiN9MPZegNVRDwWFxzWV7PVJk1Y0uQGVr7eAegxshtuwn0Gkf07p?=
 =?us-ascii?Q?hyM3wO+B3PU25zsE5Vg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d407cc2c-e08a-4967-a066-08daa22bfabf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:05:00.1439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZ2mQyQXV4HX9WvCZJvpEDG16Mpz+w9eouwb445nihZi/M9JlhANpDx7WFxZpCK8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series does a little house cleaning to remove the SPAPR exported
symbols and presense in the public header file and reduce the number of
modules that comprise VFIO.

Jason Gunthorpe (4):
  vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
  vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
  vfio: Remove CONFIG_VFIO_SPAPR_EEH
  vfio: Fold vfio_virqfd.ko into vfio.ko

 drivers/vfio/Kconfig                |   5 --
 drivers/vfio/Makefile               |   5 +-
 drivers/vfio/pci/vfio_pci_priv.h    |  21 ++++++
 drivers/vfio/vfio.h                 |   3 +
 drivers/vfio/vfio_iommu_spapr_tce.c |  75 +++++++++++++++++++
 drivers/vfio/vfio_main.c            |   7 ++
 drivers/vfio/vfio_spapr_eeh.c       | 107 ----------------------------
 drivers/vfio/virqfd.c               |  16 +----
 include/linux/vfio.h                |  23 ------
 9 files changed, 109 insertions(+), 153 deletions(-)
 delete mode 100644 drivers/vfio/vfio_spapr_eeh.c


base-commit: 55b1f51cc7a16e08efd93d4c7f4f826b41d6715d
-- 
2.37.3

