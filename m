Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B2A5972F5
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbiHQP36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237754AbiHQP3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:29:55 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3302D844D0;
        Wed, 17 Aug 2022 08:29:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8iJCbto8njg8IW+iyfKZviIzQKotJzxbwpfM5pnZmzmzkcwnadi/+09NRBeQer/fJ5ubp7QyOaxeUAJtc5/6KhwG3yf8ktmujtPCM0Y9VhBl5urBpjCMyZtlfZKt/9HmvMRjCyANCzON7uOEGM/dkmkkHH43i/9clCOE+UU26ZrkcUBu+iE2ZRLX70Ilb7mDlufh1bxdRpxqg1xPGqD/LCi0ioiqGQGglNqhahrc6hofkL1l8iHoUZSj2EM3Q4ZU0ZQP5n20KFpVlP4dH17gGj5ADdjJpSeHYgRLA/dDDTtyutg60B6FBTgja12QRB/1iWIk9+KhVJZHKAyxjsP1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9P/2BstJOZy0lNUo5R0fY+52neHT1SjZgzpW5+oLxTs=;
 b=Hn0RhgEH/YBrtQeEkgWK+OXe1eIOtakrJnUrkT/DtEo91x4EdQH1mLEm2+/JOQO+P3VSIbo6CJpQuq27U4i5QOinZk1V0wOw9cLZSEvk8TplB7bGn4eqHE6//nwBwM5aaz3XTDd5ww74eMR8XveRsnT1duHpzj6PZzxsfgvbasw2dLpsxmtPctcPOKLDk7oADRORlMN9XRu3toBa5/DtbIfS5c4XQDlaDsZH5gIYHfuIYS7UBqW9jzfWkpP3hax26W70vWAuz7M3sr2bdVUkVOybeT/zxQIxJOwKm84RjZ5rCK9pcTKRflB8UUPwxA48INjT+sB/ENBOatN0/CkR8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9P/2BstJOZy0lNUo5R0fY+52neHT1SjZgzpW5+oLxTs=;
 b=o9ixLTilHcaqDwm0Ec/cccwYsV+BWsbGI/U4pOunCA7Cz6tpE+bn+VoZqdSusFPwjSu7Rzt4K5NDk5+Nt40gYYTWnBUEJ/SXpRNfVNQTZV3Ps5arLV260vLT/JJfZBy+49dd93X4zK8FL9tU3wp+Y6wv7SbGSrjd4jKv8PnclIauyABnLXd9jGOWjoIT2PdDHFKxSOehcLjJpcj22eXyRMVkR0VKoNqoyyCJKGFn17zSkd4YweljQbm8FOe9q+Smba6MAvkTGIKklVEj/XYp2Z5NWTLfFz45WNsWLQ6XjuccErB3/ovtr2go9w84/K6salsdbzkSjqWrlen501sz+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.17; Wed, 17 Aug 2022 15:29:52 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 15:29:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 0/2] Remove private items from linux/vfio_pci_core.h
Date:   Wed, 17 Aug 2022 12:29:49 -0300
Message-Id: <0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20e501de-80a8-4151-2900-08da80655467
X-MS-TrafficTypeDiagnostic: DM4PR12MB5962:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/O5QF/1F5/+9zpkVrNS8p/r3wJItr13LuJPU50GajSWEqGho/ij3BL/2Mq8Om4cmrHRARmYz/kAy9tAVTuJzQhbqkVjTeQ7hvTM/9nA0FalupsaK/uoSFVU4tbQOBE7La7Lapv6xRnZ+KmAnbzQGyQsmbGztmnOCwYT8xquUCbN4sTXexp6MSor059Chny2XEMinW59+s4MgALhHbBO8J9VOpG3dHb/aruOsffNhCTJOayLdiVCYzMJ+K/ROQhIzdcwpYIcnuHrYxmH5tLNxl4njvNDZQtJykcqy/rH9dmVUd+Y9bM88hIu6yTQ4bc1MIBQhq3oQjbrnfsxMitoWvGiiTouHW01hxVCS6yCYUwTFQ9qQk8/L6YV+Bp1s4wqzLVdbddHcjKYROrvkUxmrSyfl9WjT7j0gfzoh9OyNJepNWmEDGIUp6EulXXdHKIgKDQoOhwlNNgLoo9jG7iRn4qrIRyXYLoKN2oES8E3tFogNJ1+RZzEwTvvGjjmArr1BUwG/Piox1V1NrnZqfv+Yg67HDMWfUCbeGpyxzKYDpCAUPEtBn3ZfG98FVFZ3j5YZhFcsobODC60oi7nhKxROQee7oYoSqfR8RgoQ3c+ADPDrOUMbY6Cx9cHKPs76ysrWvVS0eeE6xEoOOkJ0fwZT19xeCyaaVvsTNc/EOmF5SfSyhMs99i9OqA4HL59urL0REk3oJcba4r8+09t7YVyltZGFPRF3CbijOcfmxm6KUCjPu4IDRBzsE2KceAhayAmbGwb8csh7KK4hut8o0m/SFQ5WAwjLyT/Gzd0GWJQreE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(83380400001)(36756003)(2616005)(6512007)(6506007)(26005)(6666004)(478600001)(38100700002)(316002)(110136005)(6486002)(186003)(41300700001)(2906002)(5660300002)(8676002)(66476007)(66556008)(8936002)(66946007)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dc3pQ7jE3G6SwptenRyc8UUkeZ9fPoxOZmxo4uQHYZHM3ZWSBAmDM/jtPHKK?=
 =?us-ascii?Q?veRnDZ7PMOsaGpMgXdbPWO7+1lNmoMIyXeAnErWJa799Dwvew7oelbTlMDfa?=
 =?us-ascii?Q?xPldB/kD98wyD0Vl2m/OGt5GJN6TQywJ2+63roXC8MKw918P1GVSdTNNfVy5?=
 =?us-ascii?Q?Mx+48P2w840T1n/iFQfBLsPdSpkBTf0fX2BXH/DqZfZcVLPqF0y/cGW4+Qpl?=
 =?us-ascii?Q?hM0xsH4SFcU/ssAeInK5Mr/ILueNyrTQoTZjOKCq8onJuCstp/p9YzVfxxAP?=
 =?us-ascii?Q?D/tqDV3oR2r4B3vpnqb+SeJCvZ/zQY08jR1Sdf57qm+d9Lhu6FQ5V1K7HuwT?=
 =?us-ascii?Q?arJaB/+unQlU/AGUyCCc808hhc5wR8rQe/FFdODx26+/lqi+vJOmC7UIrZen?=
 =?us-ascii?Q?MejJLd77t3vdsupEVkmpM6F4TUnsT7z1MkCApECEMbUY0huvleLYg1m5HHuR?=
 =?us-ascii?Q?R6POY25R0u6IWvl83I5380jE1jwSU4nJ/dfzMFDmTtfMs1gRHH8sIf5aA+qt?=
 =?us-ascii?Q?ryGBYNJLXcmLFTzKhDxl5zPDfZFoXinyd+pc9i1PqgxWMFSqOm2oHVyFrVOU?=
 =?us-ascii?Q?dzcx9lGHgvyi3ch2fpY+lEnPJqbw3DV0J3CUMKjphF7gthm2mlD2mBHRJwIN?=
 =?us-ascii?Q?75cyKoMI4wTvMiUsqrC/nP80WQBmyLTzw93HutUHUHTqyPFW7mG3hot478xD?=
 =?us-ascii?Q?y/XWRP5s88It7aDUnItMFqzYiRjISuONVgGwJ3YiYhgQMFTME+BopgGr8mB4?=
 =?us-ascii?Q?4Xavxka24av6tUC9Q+ICXNPb9l/FH65vKuhZqft2AtzlhF2B7oohatfPug1w?=
 =?us-ascii?Q?np+Vs+VhD6mYczwYuxSZ1Vqvfbw4OKqv/ky3yuMwG0/U25ZygSLupuS1gstz?=
 =?us-ascii?Q?1RtdP4AkpGIv8pYMrfTxDZ26zISU0Qbn1M4vskvkvSR/1nskamTYz8Jo1r/D?=
 =?us-ascii?Q?wigxlhO5is4anlWyihotn945SY46+xNNpIkZdeBJwZ5a1sxYGoYKw8J7pXln?=
 =?us-ascii?Q?O0Gy6+x5+0bsUivvN6Dv1eWQQQM36/42eU+xsyKds6QcAgD3eSUfs9UCVXXq?=
 =?us-ascii?Q?9Fsw+1jiM/rF0VH7DZOugl2oP1aqywEmozy+oaHWmXYKmFfHBOQV6nOtHLGY?=
 =?us-ascii?Q?drzWvICco1i1EpvQblWFWnWWhMXM43lwhO/5edoCIZr/zYQ9uUfS/1JMLkMt?=
 =?us-ascii?Q?eOg2Hholkt9khibIEnuKHaPrMy1EA/sO78wrItacyL9Kx/jE32AONhHNQ+lJ?=
 =?us-ascii?Q?fZf2m7LTdEk/7y6RZn8w51WgzL4HIo3hmaUTK5WPXzTtq4AJ6o6+zS5ktzHe?=
 =?us-ascii?Q?tkbWc+6xyoLv5pOrbDL2nYKJ7EzYPCpYIqdwm7dppZxcB8ndZ1qD3fLravMc?=
 =?us-ascii?Q?zG8uqU4iNy738zNKcmSKYIlTrkySy67EyNDlmL+NR+DAkFOl/7veMP4OgpH9?=
 =?us-ascii?Q?1hbPnuwpc8Xyt6E1m9bCnmIz31nE5TvRWCxPW2A++KZhtkYbQTSaVYKEGX4I?=
 =?us-ascii?Q?havZhTRt5E0g3KgrnqUJRiesLdjUJqvJM7n6sqIcD9iqvkKc0QLVA73/DN2h?=
 =?us-ascii?Q?FUYo1GuKKYuQ5RrSAEtqJJOlrQ/a8bXwQgeF1654?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e501de-80a8-4151-2900-08da80655467
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:29:52.4164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSWmDMUiQsmpLLNCh3X4cP/+aKkGJD3t6qU1lVgZ9QTP/qQj784mZMrsOznUDV4s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The include/linux header should only include things that are intended to
be used outside the internal implementation of the vfio_pci_core
module. Several internal-only items were left over in this file after the
conversion from vfio_pci.

Transfer most of the items to a new vfio_pci_priv.h located under
drivers/vfio/pci/.

Jason Gunthorpe (2):
  vfio/pci: Split linux/vfio_pci_core.h
  vfio/pci: Simplify the is_intx/msi/msix/etc defines

 drivers/vfio/pci/vfio_pci.c        |   2 +-
 drivers/vfio/pci/vfio_pci_config.c |   4 +-
 drivers/vfio/pci/vfio_pci_core.c   |  19 +++-
 drivers/vfio/pci/vfio_pci_igd.c    |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c  |  28 +++++-
 drivers/vfio/pci/vfio_pci_priv.h   | 104 ++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c   |   2 +-
 drivers/vfio/pci/vfio_pci_zdev.c   |   2 +-
 include/linux/vfio_pci_core.h      | 134 +----------------------------
 9 files changed, 156 insertions(+), 141 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_priv.h


base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.37.2

