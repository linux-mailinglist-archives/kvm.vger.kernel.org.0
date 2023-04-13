Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23446E08C1
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 10:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjDMITP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 04:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjDMITN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 04:19:13 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C5D98;
        Thu, 13 Apr 2023 01:19:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6els6t3IMmHE7bi5lTxQV8yKVm1TBnuNVNg8fbTvw87yXNbXfl8DA7LLUkQlrMoF9HpQZE3yvA7aspl2E+wdD0kcERBwbic7EwMc7JKjultBipDIgUMU2Doqzwgt1H+cPJGP+83TwEvORGUlxlLoPARPaeKlwgpg58UPAsIOIo/Zux9XyjeTbuSnJ/PQClbfQHrb/xujCphtmHWZbES4/W9fRftpDg5n4tk2QyeK36w5ARrQuV54FwpDnoM9XzmhLB9VvU+ehje86dcrCg/dUzSGunLvknRYLZrGustcAyvQeabBhnz/ZkSVytGsMZhv6KH+DEwHk9xgBBjY/7MQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMT7eBGdizo2uu3MKLWBa77PDMe9zAJ7RJpj9alI6cM=;
 b=jtAnZE61JZdlVqXpCRrpiUBeSCVh9LBJNg/aW8WH/+aCd+0hc5HNLZnKBlE7GrMTv9y9ZAPjNWWg1DQ4mOaBV+PY0gTbbDxpKVp6DjGclAVXXQzisYCU+1hPsr63fseZLSImFL+K3pxcNFCqVSasf6HR+2D02rM3GN3JdLKiK0qqkpNn+18jYXIAUAT68rb/t9+ZzT/v/jKFqT+4z9gVxYgmNGc8hVzWUMIWTDsbD2VYNPm4MXIZxUZ2473U0c8meVqmF4+YR70sr8n6pbBlNulN8DMqk2OWUKXitt35Khq1kSSAYQFAcV0KGmWZZYoFWkLqojWwS8kMjPmg5mKJag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMT7eBGdizo2uu3MKLWBa77PDMe9zAJ7RJpj9alI6cM=;
 b=IgyxoOz7ZgARsl56HjQ/pZgrbrdQT2ny69OJHOGBlDNueF2f3tMGKnrJaAnNBSlVPTwb7ipjc6bWAO4yGUyIDW6p5bMyNo+w4ZJaIxZvbaFpyIGXyHHTfajGAPK3iOv2lQGJNicvJQslpMXse2sqAk7Bo8I/ziM6Yi1Cnw7hxME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DBBPR04MB7721.eurprd04.prod.outlook.com (2603:10a6:10:1f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 08:19:10 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 08:19:09 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, cohuck@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, viktor@daynix.com,
        Alvaro Karsz <alvaro.karsz@solid-run.com>
Subject: [PATCH 0/2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Date:   Thu, 13 Apr 2023 11:18:53 +0300
Message-Id: <20230413081855.36643-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0054.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::23) To AM0PR04MB4723.eurprd04.prod.outlook.com
 (2603:10a6:208:c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB4723:EE_|DBBPR04MB7721:EE_
X-MS-Office365-Filtering-Correlation-Id: 041d7579-9605-4218-7285-08db3bf7c183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xisb7CIyJY33nU0IXFt2u6mJH/1NyaHxzlOvErupE8VfwJQM/UAc7P3GzZM3GwOUEBta3L1679nUGL85wAIlcDX9inYxp93m1tjnbR5fBDKAfZ2DiQ2lOEvnKtGFeSHrPziHEQ7+nuD9b+A2sUSHPqg9UeZ3GMDaZwH25xAxcnzkle/iokFfhSSlhFKmjRlg657SInjPhhZzHPAydn6PJT+/qpcRrQVVONaiyUjzjgYaG6pE+tGMRIPqMlCRkBg9UEL3gptdiWvyowYa65Syll7D+/5tGFvpaPnHhFK5TiKmZUqBRAUAu5KX+kuttX3/Xugq3Ge6upn2q+KCQnv533096q7FlAimkCS6XHagXTQz9Q8UY0g2JWg7RiOwTrfBe7/h4yV/ESsKls9yWrGoZKhRQ8sDvbmfo7Jnnu15L45qZLUEVWoB82BjPeRkJklpLj3JHlJk3WXaoAzbaf4R1BVZUhLDI2DOcDTHzbsaVQQHWlxNrOqfIE8v2Et7Gbyrl5ODmJJRZbdkPdr0ZJAXDgUfqwi8WHxEByWwCOG79r87UCXagXPXYfrFuuuqnfcn/U0caDvkSMULxLZAD8sX3ULmxHvYY1a/Df8V0HAfkRk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(6666004)(52116002)(6486002)(966005)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(7416002)(44832011)(86362001)(41300700001)(5660300002)(8676002)(8936002)(316002)(38100700002)(38350700002)(478600001)(6512007)(6506007)(1076003)(26005)(2616005)(186003)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JEngdfS17y5qY1954HA9g2pcDOnP+RENuH2NzGZeWmsCkpTOCcBrmKz+ZBxW?=
 =?us-ascii?Q?UjhtADx3ZbR/Tht9H/n69lsznw3WBX6lBb51pTvqsOaHUCa+txEfJ+pcnBUD?=
 =?us-ascii?Q?bWWwmf8ScHbWew+3c8n+dIQCrQKa3LcZKUz+ZV0fyL1Ap74xGnrRX8OScajo?=
 =?us-ascii?Q?bTlFqH/SIvQhBu9dZTwKBqBEgpKzItjuKEMxbeI3tuXxlZMJRd8/6w4aXvR3?=
 =?us-ascii?Q?pefrdElw/O/vwahSwQhndD3ii7z4SSCC7p9p73CF2Tv+7LLLFSGyolV4O9bi?=
 =?us-ascii?Q?GM8tPBMFXi3AY8o6PMYw3+QLkQS+sywTGNuCMb48MtbLLGfyYwLqmzQ9ZNGU?=
 =?us-ascii?Q?yI7xhAcf3xS5QqXVEa0OrtYy/tPdccgbT9BPq+W3oQbiRTIZ+tpQwabkd083?=
 =?us-ascii?Q?R+ayuqcl0EwUEGjQirGNKP4oFClx2TF62KYIUFYi6fLzYTCobY/hqcgUC53z?=
 =?us-ascii?Q?kzUhUjc83q+QmJJQk0QISpI98q/0yrOahWJwFLDtQkyVIb5k3Wq+VanC37fp?=
 =?us-ascii?Q?uBIhSg0JnvlvqU8KGUhvHQAg7GEXT0xD8/Hr7yijvH1d1zaByp05AqY8FsQa?=
 =?us-ascii?Q?394AtwTM+75z1xuRqY5xg9I5z+SCLsW5MyWLkBSqxRm2dwJuxP3acEVMy3Lr?=
 =?us-ascii?Q?lf0os3zS7g3Z+nxAiwRmdHom6tGqh4wuoHhjsBFiahdcsaa8t2EMFZpR7c9L?=
 =?us-ascii?Q?/HSQlocjwoXM36hZSmS7CMA5qb3gbclC3ZuylWBI6nw4h1OqOTXhKD3TlA/c?=
 =?us-ascii?Q?0sLlxH5URcIgOVuBxdkRHqIaRv/jqqpkb1W8Zyzrt4H1H9xHisjmbXi6FRZC?=
 =?us-ascii?Q?3P3q9tKL+2CrEY0/dxJdoTZJMeqDiqOCVpenxTX+ogCkAAba2reFmqh9wYKs?=
 =?us-ascii?Q?5KGV8727mxUuGerW2ytS4TjeZo/YV4lRkpxNa7ZNJD2fH6gvbYxlZKK/9TBk?=
 =?us-ascii?Q?qENF+N0IyhZM/3XhXn2T7c8DyVtP6WDXDknkfNdsl/i1iODvYhL62wQuFB9X?=
 =?us-ascii?Q?kkYcp38XQXfiE2Sxn9SpBkmlb/S807R25J1PsaAuQncRX5RrqyymR8GMLiwF?=
 =?us-ascii?Q?Mrt4uhzm8wC+cO8KVjEP5pba0/tMsE3V6jiTKhTN8bBMtkUuhmJnu15ScQTh?=
 =?us-ascii?Q?R83UwFUgAm0wA92AEnfbr4ewndrVHheGBqR0q3YwOWgoZvRohNXyFiBeHRr0?=
 =?us-ascii?Q?cDIi7yVxT6WWCcM5yq+Hi58aS5uBhUJudu8fI4S2gXvZtpYfak8dPQnF31mt?=
 =?us-ascii?Q?LPORqS5xJyjhKLz4W95WMPjou2/SvI494pbAfDja7ALcUrMS70PlZdW7oJSv?=
 =?us-ascii?Q?Xz4G+QKfGM71E0EBRUBalJ+VpvKfRfyzSjvmLTwmQ3xVY3nmmDh8lNXO2H5y?=
 =?us-ascii?Q?e4+vMu5e76WNJoHxIvCaugxPpONsp3CRqhMgZhRmmfF4FFtISrxbSibdycBO?=
 =?us-ascii?Q?mhw+SfhW5YlVsx6KylVWZS7282LAiPWlEnHJsZYc+pfyRTkol0hENBz8/3lp?=
 =?us-ascii?Q?VYu+Wx7Df9GI8RKL/VUMeAwe89NV+dmiw+rmdmX31yQTeQ/EveKP2q8pIDd5?=
 =?us-ascii?Q?0Ik3Lpb8szsVJXLblW3vSicJ26Qv3HZms7szcfqhfJw/0p3sAUKKziEu0IE4?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041d7579-9605-4218-7285-08db3bf7c183
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 08:19:09.7570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tuzEmRHObzB+oGJKeN8J3MfKiqNnrfJO11PweZAHjc0C6vZHz966zRXutAj9B2jiTdDWvA0Aw5Fd89xI7h+SAXY1/0Bbqzt9Jl2Ba9rTbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7721
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add VIRTIO_F_NOTIFICATION_DATA feature support for the MMIO, channel
I/O, modern PCI and vDPA transports.

This patchset binds 2 patches that were sent separately to the mailing
lists.

The first one [1] adds support for the MMIO, channel I/O and modern PCI transports.
The second one [2] adds support to the vDPA transport.

[1] https://lore.kernel.org/lkml/20230324195029.2410503-1-viktor@daynix.com/
[2] https://lore.kernel.org/virtualization/20230409070706.3288876-1-alvaro.karsz@solid-run.com/

Alvaro Karsz (1):
  virtio-vdpa: add VIRTIO_F_NOTIFICATION_DATA feature support

Viktor Prutyanov (1):
  virtio: add VIRTIO_F_NOTIFICATION_DATA feature support

 drivers/s390/virtio/virtio_ccw.c   | 22 +++++++++++++++++++---
 drivers/virtio/virtio_mmio.c       | 18 +++++++++++++++++-
 drivers/virtio/virtio_pci_modern.c | 17 ++++++++++++++++-
 drivers/virtio/virtio_ring.c       | 19 +++++++++++++++++++
 drivers/virtio/virtio_vdpa.c       | 23 +++++++++++++++++++++--
 include/linux/vdpa.h               |  9 +++++++++
 include/linux/virtio_ring.h        |  2 ++
 include/uapi/linux/virtio_config.h |  6 ++++++
 8 files changed, 109 insertions(+), 7 deletions(-)

-- 
2.34.1

