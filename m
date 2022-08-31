Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870EA5A731B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiHaBCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHaBCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:09 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA7E6EF23
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqZIezd+PKrkrgCsXY8aKOJG+LUiY/NtuceyCNbMgMyfYgKOMmREuavgNno9ks+I8+2Pt8dbW24cJm1vVaE99yRN/RRscHmSrfulRo25xyV1OQILBmRs3plqpBtE9X/8Y0CzsfSwsJfHHzgz0BpQKbXuWcLRj01whZGhxSsmrnYcbDIowkFqwvmnEb0RNdJUiuxLC3NShSgobukco97sXj6zAkGGHbibQDT8u9oSyPrNsucil6ABXo1h/TNlvxImwkj6YOyuuaVyHSXgNRooBYi/d29Pp/vkwRnRooyhf5dLYgbtfUr31s0TDsXK3w4eoX3xgTbe1QKW4yoilNWZhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjIKc0HGQjI8VWQK5vrD802707uL2erumSb9i6w96AU=;
 b=I213PN8aiUFU4X/gMDfQ+Vp7rVq9vXSSMr3ZYAfTNPGxdQCcBQYg1B2MH4sktXlSl/dCw+0Q/QidY/yI22LSOzAaxfuPPz+x42luWZwLqQYNHNQUFr0sVErqpRWBkLm1etC6a1ha2dQIT/R6VWttT8tVVM+YSvuJfhZMzXZ5BDWC4WdGzihXD8JuQvlwc2Rkn3pTdlqpAl5YJHnUinnyZmYsTcs4zEZHeN/P4iyqWuTi1PZGzMAcrMYbCTRc5TEZdT0EMBfNgcIdUuYnxtYKaROWVnWWyUsftvSe4P1YaqiM6WW/phmIMzqZPBnMfij2SZiCy1xYMxHTjeCFIFkVkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjIKc0HGQjI8VWQK5vrD802707uL2erumSb9i6w96AU=;
 b=X5EhLUB+ZSX8LQQHjRKnhkiu84rv5SUGMDs8dbEr4NW39I9RRKArDQGRKl05Eg+zVoVEnOuypAkfJz0rz9s4ig0gtiVAxYv7UeMFCY5viuzkBbvMQkPkDpKrTTFkkHsqpDKv3IJ84m5oZULrUhAi+vb2ffs3j/87KoxorhVd2f2TKFwfmu3dehVsDOwQaJqb2B6l7/4Zej4NMlp87PrRrxDyDA1h7eGze6aCuEEUXNbq6fkde6FaGfKx/aYwvgrxvzxoylJ4UPvs+4UNp5477vZ+IcB2ZRuSS9zenBBayGxF0oCQAB+I+765rusDS3ismKlgt4XFlRvOthqmlBxhTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:06 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:06 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 1/8] vfio: Add header guards and includes to drivers/vfio/vfio.h
Date:   Tue, 30 Aug 2022 22:01:55 -0300
Message-Id: <1-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52d99807-f494-4d45-3f58-08da8aec6ada
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gd6e8bQMV3ZeO6D6b5akCy2O2ELtO6brSlSaFOR9kEVoJ/ukMyyO/1bZOpoeUXNnWvnfkharbcwH4K0COSbvZZbx8G2NogJrhDhhY3eInmK8L1wyMWJjmQiLmyi/9nCQWVRBKxDQPTO6SZZhVNoTlMFTiQ36hRXaREs4hgMyPTXPdu1GYW3QEXLanZ0JKkV0cxz7V43mAvUp8+NK/jW2h/Pxh6tkE/htYuxKogSjYm0kB9pAAlO2cNmzpzOOFOGqZ/KdYRzQ1RcdVQu1z9XkLGQIJpsG9a0bMnVIIKV1lsjMDyAVS2+cS4aIO04IpGqvcZtLtPzMWfjK/jDqmQGPKprSpoBsLmor5JbQ2vyMivGsxPBL+cly5sX+3+dfLKse0jlx8e3GQxT0+DAocfZ7vjbtvqzxt2dj8z37AfdPSfXbmVZG0lmgW8mpaee778M/1DYCg6PBYV2i4TXxh+zb3TehITp8hcd7U51xQjuLW5ldz7Ul7fvso+vGOo33J4/qbIbpm57JPxf5gyOd4DawEn7ZLTXlf31lMmsWAziyublF7oF1gd7huqlD/7q6hgFYBH9jDqgLbmlU9h3ZRo6rmbcxaT229vnmzXfr6KjUiMyAUWCPp69LngQBwWJ9cf6TyLt4If9t5ncQP3ynbD48TxRsi1aC+sIfYum0BEMv1K/2cndjYMqrHHtFhPlO52swG40dLmWLpEP2rI250k2YdGAHu+1B/Hm2UWwPUqS52y6DuiL5zofYdrYky8MJca0j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(4744005)(6512007)(6666004)(38100700002)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CNei8y1+K+eoteJ2EbyZ6fjEnRz9W+trFFBFTgyU+zNWjF7Xxhv9CgzrP/ka?=
 =?us-ascii?Q?/+sM24gphgqbh5FLYM0DMzNUjn64iiN2/3UHU2bBrGqhFPCPzvizUOWj/wPA?=
 =?us-ascii?Q?5we0aAhEbcu1faHek6xfjkFsJiS+C+lJedULldQjfXomIggKsiWM7YOku0EU?=
 =?us-ascii?Q?hQW18LuSF7wcqmVrwmqahqWOFJEjKopRxnejsD00Yv0Up40ttlabikVuF2gd?=
 =?us-ascii?Q?eQXIccwk9SMHoZXR76eFO2e13Fk/FO7MLfsJqT4zoyRQdfCS1Ly6isJx43d4?=
 =?us-ascii?Q?ySlvLowG9JBnsrLtGMSpC9yWshhb73Ps5OU/eIDjWYaATSKrmVOtR7XPMlIF?=
 =?us-ascii?Q?MFTON+QOyecrLnHa2qdfK+EYKaqtZdh7hDjOvhY4OleDCwWTQN0e0FqIQltC?=
 =?us-ascii?Q?XUGvniPvsZe8Yh0hJV+5DF58W6izre8RKD7VP/aSfV2LRXjnqAcNHIoTbd3g?=
 =?us-ascii?Q?sZuvHPIVxtoYKl+5Mw8t9yXJ1UkFP6PNS2WG74c+ef8UgDL3y6VvZRwupGxc?=
 =?us-ascii?Q?3nXjZwS9de7t82EC+o+7W1LVRUyNAvR8uCIShlteS0M1iTs6UDVbDVgzT7Kg?=
 =?us-ascii?Q?xmMUjXigoMQNpfp507tTOKexC144Sn9V7ev906VjVBssVhbG0IubNNjVuY+d?=
 =?us-ascii?Q?uyUkbC5bt6U5II8UhDJmEA7nKyWN4sXMkry6ZHapsYLQ59aWbTphGwao6sjP?=
 =?us-ascii?Q?4EhenisqEbAtggQaUkCcacXs4BdJK/VTwA3fYal8fmOJmqR+wyfsaPbEsmdg?=
 =?us-ascii?Q?/EnMU+Wgsd2C1M7xEJzpYDJe4+jwmgkHL3lNawUifAcURz7TCS8XtPA0/6H2?=
 =?us-ascii?Q?8RR8i2U1wQoMnAwboS6s2bjtk8NcxacDahsCniu3sKdR82o8CJhnyRN/BaWc?=
 =?us-ascii?Q?AiXxnDBBeGE54W03moss/C7nlUCWq1cVNe0Xc0/PoAjpUoUiV7hIgUrRZ8hr?=
 =?us-ascii?Q?lWGJTjgXcuhbkY0FWEmeh9Z8u0Q5cXVkUGHi5kIlA+s2YdX1y9L9LEAHZ5hs?=
 =?us-ascii?Q?dAku3Ym0jQ7w6HUXLLn6BXCpDsSclKXOAIxkCsAvL8Ev+cpBg0QzBgw8whAv?=
 =?us-ascii?Q?qxmnTf/veXA/757SLAZHNNDpUK9LwOZhbUGPsPHrdh3BFm4beIn1PX+t9VgC?=
 =?us-ascii?Q?e5Hz7Nb5AdO28VMDJnFowSqqFGoYdkEeV1K/bKOyJNPsuNsdL766fSX34vKM?=
 =?us-ascii?Q?OydhkuesM2N3j6iJBj6ztT2xei9Sx9p3hwQtwpgCDBaP1ktETl5jDVo3t/ft?=
 =?us-ascii?Q?vhUEveB3VxTjB5PH6JERMRaVoxj4gGOzo9ThQ15shDDctuNCJ5i9GOgYEYqT?=
 =?us-ascii?Q?DzrXWFZrOoQ9RHmr274JtY/hkr4JNeoWPV9667e5UGbgYn/CEzJyLf0iVG+R?=
 =?us-ascii?Q?IQll2/zpgsu94YIcmV4GKH46yk1Rs330asR039HeDeBfVjvHvIY22mDYh9bT?=
 =?us-ascii?Q?m33ua8qIPrcvtWIe3+KGquhdx6V9rOh2NmUimW97lfVQnv0ev6/uFjeWSchm?=
 =?us-ascii?Q?E72kVAeWL8EV7O47yGXxvJhIlDM0LCKAIsoaR+QJp+7UTrNKFE2XtgwtoBps?=
 =?us-ascii?Q?fXcvVzVwPbBdPZqRdO0ioVHHSZgQJT4rU7VbEQ3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d99807-f494-4d45-3f58-08da8aec6ada
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:03.6886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +KaTAbCkrVna/Wi/tdmmAzo3DPAnQt/SDzW5mkH6D6aiAmWiFoh9cbkcl+uM7vGr
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
2.37.2

