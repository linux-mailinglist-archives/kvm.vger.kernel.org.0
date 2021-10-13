Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C4742C322
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhJMO36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:29:58 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:8800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235709AbhJMO34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:29:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyxncULsUaJonNMiIAgcijuwpa9dfVoGwR5dNsCLHFdmemtLUE8eaxJWKZKYhicz+Fb0liPbhDCQUJEgH6vsH48G/kXCyEtRXsRGBaEQqWuAgjwrxFP99gR7NyllqAnkEbP2841mKe/cH7x6+B4sTlbvJtTWm9ZJKGs9aTA2kmkNNjyrL+7O9K/eqD0tBvXcB2w7caIK3n2ie5Bxz3/SRb+MScDjfoE5aKztj91GNCp0DnMwpE9SFWHI43ghBBkFwXi6kqwSvpgmMPKFzpbmYaLEKAye2vViXlR2tCgoWpyGPld9thM9bJv6jNpjgNf3umjaPOD2eH3Vm7beSLSg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUsp2aYkwpE4u+8H5yzzLFAxbIdNtDtgJazXqCJlwAk=;
 b=igpjixzKTGc0IT7wJ1gesPynicwtHIasQvJTm/JxHvjFHPeuzxQ8HToJo1VNs4jHWJ0lL42zQ4RvA81k0Y8ZT8BqaFKJDFq5g7BBIpxhud/IYmv98XFiwfVn8NZuveyo96M8hrCo4Ml5WlkP0yIMEAci5FWcBlLWv2vnAC1gvQOh89c84gQVkqW7F+HnMCQ2OcILZpy6gOixsWWtx9MU8A1OvQQ90FGwPmF9oXBRe43Ue0r/1Wc/AWM/tYWofK0SFbj0iWGmggQqHlPjODdWvKu2lfz0cc42STYNs2D9aK7EMtYYi/rv9RInhxVhbNOiiStyDdZeseh9cJFSLeHuMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUsp2aYkwpE4u+8H5yzzLFAxbIdNtDtgJazXqCJlwAk=;
 b=HjcLm/ZGi++NxIzZ5E4zC5zlMIzAAYAwcHXi/1oYP+9qqKdHntcSeSQ4ht12GB8i4FNeWHq7kFiHRckY6lQ3Ytl/IeCcLv/8759ZcfCgBdYAYFVYTNRBK8jK79sNWKEN2Rj1lLC7234jB+ouS8J1An5whruB0J+wNGTvZPII9ir++T569ZuJmrPe8vUAD4tAd7k+iOdlLWes3z9FuX2/oqG/gFdf3RCIGxqKcUkNjg6oJQ9ozT2Ki2BUn1f2Oi4frxKugFQdLdO94V/yqCwBn2+byw2RWbjy7Mx31YhFDXzcQ/4RL4WxENdVx+qJxLKyipX5K5slmyZFLZ/pYGp7JA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 14:27:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:27:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 0/5] Update vfio_group to use the modern cdev lifecycle
Date:   Wed, 13 Oct 2021 11:27:45 -0300
Message-Id: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YTOPR0101CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Wed, 13 Oct 2021 14:27:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafEU-00EVF5-5Z; Wed, 13 Oct 2021 11:27:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82a78a1c-bcef-4dbd-6b52-08d98e55a387
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5287D2C07A8F007F4DE1C8D9C2B79@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5dlFoH37KRIq4cV3EJIqJm+PJJc28RuKNWWXjGu52y7V7hU7h/piMoet0PH2tbNzA4dZLmWi/fV9ojRCB3tu1bowv1VNqYgfyvh9Nx2zG9Wzu/Wlvi2hREaZt5+3a4fyl5ayHuE5s8f4xLRW1Tgp6IoPUhH6MVXSWAQKe1TSrGrk/cr0PqgOgbsOiNgj0FC+Dm2/Se5U9XSN+N1YeiGIfXvbwaqW+uQfIr198+kIC0McLUKylQr61tbirxvi4BE0N5lfsDFhht+t2SC45a4LeHAfjRSsGgriCquAsK6cxyjYZMyC4DLbgZp9uL8c7QEH16O5syyeSXngwQ2NDDQSxkrnaSlI91Mb6jM2N/hZwKzCRHtzC1jvL6k+BJoMjTdupQpW07YUwNawlhrxYyXNLUsxbE3gh6kA9WCApgU+rhRCs7ZiKeSyhIas/XlKipa0GkueXP9Gp5CF08uNyQDxHnK0pKItwQX4IDfAQPIahOTzAmjwUvPFkT48nwx7/EuX7yKcd6Oo+iB3rjoU76n0bf4he+gArDMUFUUdDdfUdvTGMEUurPhYTNFT8QceVIuRMWqLTZkZhAHk37PP4aNr9jNGn5C6ESZ+kWGlgHxiHFgiuItQmw4lyR0JbAzBBvrXS4yfhNguaRinar7ynM3eouelaO5vHLsLq8z1//L6YrYz8ndmnIiF5lj7URqC8DWAL0Rsa3YmkMSX78YKSX/gmKa+YPviOUxGAK4+0mi7TzvVX2g1L85SuXyQUHS+In+fGdta4tQ70ttZgy4y8eVvL1gCmLEbXTHsn9pdiUoFCB1985TJB545nFwLFJVDrQQh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(83380400001)(86362001)(966005)(186003)(9746002)(316002)(2906002)(9786002)(508600001)(66556008)(36756003)(8936002)(426003)(66476007)(110136005)(4326008)(2616005)(6666004)(54906003)(66946007)(38100700002)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUlINFJXUEUzV2FSZ2I2UDNjMjBablI1QnNzMnNEY1htS3paWHR6RzdpVDVH?=
 =?utf-8?B?aDZNRndoTnQ5Z1ltaTF2RGtGYTlnTXVSK1lXRHUzaGh6OGQ4MWU1VHVSZFQz?=
 =?utf-8?B?bC92bzA4OTIvS21waXhBTDFXUFNHYVR4alhFY3ZXYW5wZzNWWGNCamR3MzFw?=
 =?utf-8?B?L1YyTGhKSEQ2MXVHU1A0RlFWNGdXRTgwT1FxRW93bnA3ejYrOEJSaWFLa0ov?=
 =?utf-8?B?RWxvRkRaQU80c1hyRlhhQU1xU0FJVzF5R3hTU2lGaUpMU2w4bFFpYUVHTDFQ?=
 =?utf-8?B?eEhsVk1icDcrTThSKzU2Z1J5MEFubXNuL2R1V2QwdmdweTBTeEljMG5KSmtJ?=
 =?utf-8?B?dEsvYlJvaWZrTXdhT2pNTFdLRS80TU5nbkF3enFkR0d6TXR3dDFCdHhRSXpY?=
 =?utf-8?B?RXd3VnUxdGlRdlM3WUhkaFR2Z1hFaTlhRGl6a2ZUMUpybjBTZHRWZWpyWUJG?=
 =?utf-8?B?eHZZaEZIT0J3Qm9Ed0FUUHZlT1Z2NzBFeTU0dlY0VVAyNFl3SEZxR3ZxaGpa?=
 =?utf-8?B?YTlyY2d2TGQ1eS9pamp0SGNTWnI5cVhQM0hRSjUzOTVqb0s2eVNJeEN3RXdS?=
 =?utf-8?B?bFRwS0RKM0VuYVAxWTBMN29jWTZ5ODhIMEJ6d0RWamgrKzRTNFFKZFNDbTZ1?=
 =?utf-8?B?am0zb0FhM1YrNkJWeXpqVkk2NkIxWlozV3h6bVVCYVZPREZ3d1AxSDMyb0lH?=
 =?utf-8?B?ZVpxZGtxSkk2N2Foci9IeVlSU3BXZmo4dkJDMlAyNXdKS29VUTMyS1d1STg4?=
 =?utf-8?B?RWVUNGxoVnpCQ1RlYSt6THk5UzdKY290OTgvN1JUUXJmRGtxOGFTVHQ3Q082?=
 =?utf-8?B?M1FxZDNGckVhT0ZNL2g4TktKaTk2ZTBHUVJnMmgxSXE2ZTZDdFhSTkI0dzBs?=
 =?utf-8?B?MHhQMGxuQXNoVTJycDEyM1BmSEtHdnh4YWdBcGlGYkhqdWpsRzNCTks4VUdi?=
 =?utf-8?B?eTluU2lsdTVDaFY2S0FSZFVlTGdkTkgxdXdFL2ZPRURRSUVMZXJib0VKWUVB?=
 =?utf-8?B?VUVmaTl6NDRvbE55MzU2c2VIUUIyUTZsVUp0WjBnSHdSZ1dtbjFSNVNoZmc4?=
 =?utf-8?B?R2hGZmtvTFlxUHdBMG0yWDJyQzdvSUZzc05tc1dENlErQ3VRQlRnZWxFa2pz?=
 =?utf-8?B?TlFuWXpKNHhVQzVKN3JEbkVHRGh3bzFSekFwTjJ5QWVCY3pqNmJPYkZNMnBz?=
 =?utf-8?B?R3YzRFlZL3I4WFUyWjdKMHNqYzIxNVJ1eStTQ1liUjgweWh6eGc4N3NrVE1J?=
 =?utf-8?B?MW9UbmRpT21mMWJKN0JRYldINlZKNXBpNndWNElWbGtxMWZKS0lvcklxTE9S?=
 =?utf-8?B?cEJNR2orbWI0YWJQa0t5cDNpbDN3d3ptQytWeXFMT2s0bktwOE81Sk05U2tW?=
 =?utf-8?B?djI5bkRPdHMxdFp5REVDcTZ2N051VW5yWk04Z2o5ZTJ1ckM2NURDbE04QXF1?=
 =?utf-8?B?SlZCem1PN1NSbktuWUFxdGlWeXZzUGN5S2ttM0lpSUJHbGxEZXp4OGNJOUFB?=
 =?utf-8?B?c3hxcWRZbjdEd2xZNDQ2TVdPV0ZRK1VKMDVuM0hlcEhYUGdGRG13aFZ3SHl5?=
 =?utf-8?B?ejRNK1JTdUJFRU5mTHp0VjMwdUFGamtrOTN3MzFFYWErY3pJVEEyNytNOW1N?=
 =?utf-8?B?M2huK3Y1ZWpOZXp2QzdTYlRNZm1Kdzc2TjNCRFBsb2pvaklRT1Q3SG90NVly?=
 =?utf-8?B?WDhRczRTOUpNRnlGekx2YjJzYmhlVEhheVowbWRVZkVCWlU3cVl5WnZwcmEx?=
 =?utf-8?Q?xJSwOb7ewl+ZXN3eyqrEigX6FrMTV/ErKqqbP2z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a78a1c-bcef-4dbd-6b52-08d98e55a387
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:27:51.8343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiRBxZYuMdWrccAttVtDWjXEgw59lSL6tP1xKpwXbtF/KnmuinAOuSN61eIfkGyd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These days drivers with state should use cdev_device_add() and
cdev_device_del() to manage the cdev and sysfs lifetime. This simple
pattern ties all the state (vfio, dev, and cdev) together in one memory
structure and uses container_of() to navigate between the layers.

This is a followup to the discussion here:

https://lore.kernel.org/kvm/20210921155705.GN327412@nvidia.com/

This builds on Christoph's work to revise how the vfio_group works and is
against the latest VFIO tree.

v2:
 - Remove comment before iommu_group_unregister_notifier()
 - Add comment explaining what the WARN_ONs vfio_group_put() do
 - Fix error logic around vfio_create_group() in patch 3
 - Add horizontal whitespace
 - Clarify comment is refering to group->users
v1: https://lore.kernel.org/r/0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com

Cc: Liu Yi L <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (5):
  vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
  vfio: Do not open code the group list search in vfio_create_group()
  vfio: Don't leak a group reference if the group already exists
  vfio: Use a refcount_t instead of a kref in the vfio_group
  vfio: Use cdev_device_add() instead of device_create()

 drivers/vfio/vfio.c | 372 ++++++++++++++++++--------------------------
 1 file changed, 148 insertions(+), 224 deletions(-)


base-commit: d9a0cd510c3383b61db6f70a84e0c3487f836a63
-- 
2.33.0

