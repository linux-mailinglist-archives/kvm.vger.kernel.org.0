Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAFB5BF24F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiIUAms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiIUAmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:43 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3492943630
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzCKDIwJF6GMx1poPiKAA4ZVZYl9BPrx0Dlcw1d89nu2uDLuc5ksM/yEpwk/FTpjJqwFLjBrKssb0B7U0l2rPIaock7ls5STVIxLYwk368ryumhcqMPkyeRbWqHZ+EchuP7Cs2H04bGEtT4zPiKUP3BOh+rD2NkJk+gQnmm43lMzdUW/Vqp4OhCGC90Dzd9KBcKqVCIf1Jywi1o78jY1s7mH3VgJVfoqrGBi2AG0B1FhyyITT6pD6Kf1aNjvoq+xs+UNQi8eogxjlRzmWMgLYqByjZVTE0x3lAnF2x1J4ZnziQaimIjlXx+UK6A9hKGEV5AO2TMQgGi1Q2kWal9uBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4Gw9IEnbgZTPKdJmyU1roam6Q+WDiikFAkoVCaTyDg=;
 b=QIbd2aMYgnfPlCeRy2UUQe7qGMWoiAeKWFDJ7YoDeyGNQrQ41ttcYlDADO9g7+madJWL6FT7cOSuYcVPZ394OH6pzxIAeRxLbcrA+3uw2XmK6KPw0nme31edd5LU99ZFWUz6LeFomo1tthVNzUIs/tX75wXFs3GcEGKQ3ECMrhp8bS23vUb5R0zYlMiQvE+Kfr9+gtywF+PUoE5wDLgttfoI07TAYrc9Q8E3WJfYiGR0pRC44XQJl2CInvHric9y4qTkIALDqXq0GjW0q1vtQtDdHiT5fPi1Eo+3zrxOotKLkXewZEuXJV0p7SgCVm0iDccDMECaCpC1o36zassNJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4Gw9IEnbgZTPKdJmyU1roam6Q+WDiikFAkoVCaTyDg=;
 b=VrXkMnwrthRQOdzUYa4Yj1QAms42jG0+dKGp5eLOOEy2LkK8zmxVRskMnRT+JQ8uYyG4QmuyDV7CYPYYGXeeI7Aw1t4nS7hUnAoemTDUD7dY9TYvKmgyae8HrC/Nlp/JMVrgWGf9GAq5soivH2Y54isPRTwxxkAr7J2KVpCYhKU2y/TX6WeKa1kR39z9pomERvh8brEBCsNf6JWCiZO9YGB/hKZXSE/1lR2P5qkW86IhZtG9XJjmBFcz0bMlf8KAUIAkur7Y8HST8CoXJIH6X90DQwA2cJOxaAPvhbqdk5AS0cxizWkeAqmotq89HyVR+8eBJF3/cd9tVTcalfWDSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by CH0PR12MB5313.namprd12.prod.outlook.com (2603:10b6:610:d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 00:42:40 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 1/8] vfio: Add header guards and includes to drivers/vfio/vfio.h
Date:   Tue, 20 Sep 2022 21:42:29 -0300
Message-Id: <1-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:208:234::10) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|CH0PR12MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e52f029-bebf-4468-5e98-08da9b6a2e91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRg+jOAqfUmeIUs6a8onx2z4F8BxpE3K8rUrW/G6NynjW+rSZ3N7CulQ08qCU0ARp371eT2nrSh+zu2X0V6G8OInjci31d+m+XuFKKaly0YY+xG/ipDiE2qpOQRTEKY96EKxMDe66glqe06ajKKhRem4ytnVqdVkFEwOz9Df/6L6zG0OxnTpUKsVsYdLDBBT4a0U8W0w1RhEjpO8hi7H5E56o99zJGFQwI91xxekLBt8muD6GUm5GU9WA4QzV6vDGvkMLua5pHqW7C0qL1OYnvv7KzVLnJ/LQveVwGxNOU+qKivEswVn+8MHfBd1Oskc0IwNjrE5I/l78srdQpknqB29BlniuVl0fp2mba5PSUYyXRaQdDoP/Zn1raFPV7BjwlICRcwV/LoXGR1rvJ8fpzX5/fTOtrCdU0vwwH17Um5sunWrr0EGj4XotCwYeZnFQGdMNpcM++YkxwdvouzTMF4qle76PYO7AQscSnZXFQIOJXFiFoeJPm+PbZYsMo5yTpUK1S3WQy+e4aY5v3za5IcyrY4EEZh4HSpTkB1ks3p9RPTSATQVlsT8dL5NDNR0gIZdf8rwQ3YkToyQ+xFBmFajfsN/eqsE9NUredar1LOO/gCEyXRBaMKqydhu7058HMLHiEtd1ILgEhlI1ZTcYNoTULWVpTAWWmMkt9zfHmGJai4WYTq+b5DD4QZvj/w+HXZVBwG4kC9pLGKqSUb5YLsdiTRuFQZrn2wirvJ8J0x3mZRo/RO+mXh4KWAl5uIv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199015)(6666004)(478600001)(6486002)(41300700001)(8936002)(86362001)(5660300002)(4744005)(316002)(8676002)(110136005)(66556008)(66476007)(4326008)(66946007)(38100700002)(2616005)(186003)(6506007)(6512007)(26005)(36756003)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9VO+HinSLsWfJ3qvuXFhYnh2jv1+4gHH4InYtflckzj0LA93YrVeRUFPRyZb?=
 =?us-ascii?Q?O+TBu8u5nkmb0fnQ5vYZ1xgpN+bHpsC182F3Clv4Xj9L5fmO5idX2yvhpgdQ?=
 =?us-ascii?Q?WYXObZXYo6wdBehbR503zk1iXB5RtyP9FqM+1EFRh22k7+2Xw/mgfTtpwSxG?=
 =?us-ascii?Q?Feo+95T90gA5bYnkxG0spFaEpguPRpi3lvCrxIy0g0O6LzJ3et4hnwgr5u+w?=
 =?us-ascii?Q?li6vCaJZqrPZDkvnTP1Kk/eBimvClytvyrgRQ+cvT7cjXOL/rTDNsCfAyeuu?=
 =?us-ascii?Q?ZTGGnlY2GSbqdsOG1RygVoxowiEnXepFFkGU6EuunRFxdZSuUYPinMfO0Rdl?=
 =?us-ascii?Q?Eneh4SPbGY+Ofjas8vToon4S+QgPZ/NJrAB1mDJRCMOACsqxOLZjmFVqBMXi?=
 =?us-ascii?Q?VhVIL+3yHZQNtLnx6ElTqfKPCpigYj8tWL6KVfYWr2f2nGdoi2Fb4nNgqI1C?=
 =?us-ascii?Q?s66iotK1Im6ugSi4bLxgFj9bTAfOGP1y816pcBC31cK81Q5kYAjl74bKeKpV?=
 =?us-ascii?Q?yDyJ5V+XXFvyTpy7mhqEoYyqCnuUyuRVUmM8Xu9v0z93K2KYoUSHIm9KxBsg?=
 =?us-ascii?Q?zkmuZFAtVzJbvuO7Ik+bAjgp2yeEG6IlCN40Ziv4pgtRRIFb29JEK/AU7DzT?=
 =?us-ascii?Q?zqG3r0dMpksas/lu7QIDkhxAj8zihreCFM6WFvYaiP3drEgG3Vd13KZETtGF?=
 =?us-ascii?Q?jvBDNdKAQV+ezcxiY/BYB9WEGXspeHebc+2dUhh82h/e+N63pqoeXJltRK6N?=
 =?us-ascii?Q?soV+qjFvbLmTHf6LwL0MHuFX5MOK2MEGxsJxOmHnJOyB1Soec4SN9U2nH9KA?=
 =?us-ascii?Q?MPPsc/isMsQn2PuatMlRiv66YQi2W9k5m8Czd+f9PwrN8P8CqPD6pNecwuyQ?=
 =?us-ascii?Q?2vR1GdwHO/EnaicDCsJz1TUb1MY5BD++SM20VIngH0d0Lw+PvDyJGh5cWb2V?=
 =?us-ascii?Q?zub7zNvNs6qqyZmLVmuZgCqq2m6kF8K47x88hLKVN33fU/vrTqdWpjRqxULw?=
 =?us-ascii?Q?BR21oM0ceERq3I2llyiFV1UC16dR1z66Xawso9Z4hAeq13TKiikKgXVJ1Mp/?=
 =?us-ascii?Q?YmZ8Nf24YX/slXPe5+RT+JQ9aDu2N7j2dOX+vx0Ai7w6yJGiY5RwJaCNYR/G?=
 =?us-ascii?Q?bRidXwk5f2Qy1fLjC4dknPGuwJGscv5kEOHsyIHJQoiK6EpOzpU0aZVrxh4+?=
 =?us-ascii?Q?4uXC0YyDV1aCz/PMxLPYZQsjvvkCc7FkjeTEhrHD7Q2e7nZbz3qP6Jbo4DNX?=
 =?us-ascii?Q?UqcFZKD2kxe+hum33/kGjKDgc+y9vnmnCrY03pLBeMznQsx8FNuUObx7Yb4J?=
 =?us-ascii?Q?U4ww3DAjnuJhSYqwTw+W3MnCrEmwWHKWI6fT0ciOP5n9AsakjXd0rFE+HH7W?=
 =?us-ascii?Q?mgsFxvIBddR0BEicmo4DUboZJP/mU9I2v1674sxVk+w7AjnK2NMJHrv2Splh?=
 =?us-ascii?Q?6r4IMwVo9FV1tLZTFX3R8UFZObqXroBNAhGGTNihDS5BUpx0Mc3O7w4a6FFy?=
 =?us-ascii?Q?yJ9Mn9CJ3rZxokxCVPDvEU+zvqZoN18nBWhHGEjv+vRFxjWfGCYpxgax7wsw?=
 =?us-ascii?Q?JTndN0+/JmyjKNE8tfMtePVmAZax3Yq6MIckw80I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e52f029-bebf-4468-5e98-08da9b6a2e91
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:37.7088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VliSUX5Xh4S0ON8vWn0KK63HtN5Z/sRxbX94U6ySPt2KhIYaewGQK4LA0AV1liyi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5313
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As is normal for headers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 503bea6c843d56..093784f1dea7a9 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -3,6 +3,14 @@
  * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
  *     Author: Alex Williamson <alex.williamson@redhat.com>
  */
+#ifndef __VFIO_VFIO_H__
+#define __VFIO_VFIO_H__
+
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/module.h>
+
+struct iommu_group;
 
 enum vfio_group_type {
 	/*
@@ -69,3 +77,5 @@ struct vfio_iommu_driver_ops {
 
 int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
+
+#endif
-- 
2.37.3

