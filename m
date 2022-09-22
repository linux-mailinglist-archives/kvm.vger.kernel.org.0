Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CC15E6BA2
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiIVTUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiIVTUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:32 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E003BCDCC7
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0EuVqnNtbjn1nOoBshfq1hMn+6qSOcg83vCs8js+MjiK9Wb6Ktu//RftnqeAL4FuMwoLJK1zAodMx0wHJpno/fba2MBZdNWT0t//vIwcxMwuJz+eeqZ67931dIR8SloVNrJpZ3ILlpepNQs0hJSJHavhLQjsxkRbB+9OEkIptZxqOYDAJ6Prcqibaq4M+3/SElxtOwxSS6p5OZp4Q4qrXq9XxDTA/P6ctMJBEY4UmeQcA4QoxeV7sYQQZ2nrFyYp1IfN3u2FI27wl3Riw4wksCsPKXOyG3/FbIReEZhfF8XzFt1GqnRHMi2yrA0xUptWDqLtfAfkfuRW3wMULVE1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qP63vvVgpExxyqcvecSfHNkIw3Jhfpxk0d3no5gOXDs=;
 b=ioTJesScXfuSOL/BqFjuc8tWB/X680CGukud2BIFBRl1j+hY8tzOHO/GHPNKAKm+gQehxEttbDOPsTk0vh0grxrZRU8Zdc4waZ7/WQ9XUvtWheOrKrs0UN2i7C2JAQsAGShGw4vrXnOpnSolRO5W9ZN1La8WChcnrnAdkRFc+wsyNjV7ehd1+lPgeMqZPRIWJynkwyftafL1JuYrtV8HXNzzh8AsFcKGTC1t4OTnd3bm3IGP+pIZnIHvzFMyVg85QyrjjR+semHGvSsw25x3XWeDj6Vqm14l0xE+AlpPB7d5k9pA2qC9AbxsJqL7Od6mLnn+Pl0FB1yMJ3KhiyMnGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qP63vvVgpExxyqcvecSfHNkIw3Jhfpxk0d3no5gOXDs=;
 b=U69sXhGVlDQzBlaYYuAsagR0eJWfWiYZqdXdlBsWUH6AmvIEWKAepE7dZcq7a2lCETBolmP8O16X/XfP3gUSLVBEjbtGhzTE66UhyjrfYt8j6zUraP6lEe4j2dKwalJvn9rNcquYJswplITuPwFPTQ8QbFFwDL0Im6DcczDWHLpnKr4T5xFO4v3tqpf4ZmyU9/GQYEOYH2CuXOe88BOb6S0bn5Au7Ip2rUmH+CQBM4h3gAu62ZN+qeQTrxa/pfRsTJ2ElOmerFLYab+oZTdasN5r7xFP3sN7zYUF/a3mk/M5QzMewQCgbgz/002guatGZ6rtJdZBQRAjVvKCBi8GvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:27 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 1/8] vfio: Add header guards and includes to drivers/vfio/vfio.h
Date:   Thu, 22 Sep 2022 16:20:19 -0300
Message-Id: <1-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0046.prod.exchangelabs.com
 (2603:10b6:208:25::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: b84f927f-5e52-4ced-283e-08da9ccf815b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JI1A3R8HJtNQ71evZHb5lNTJAxxbui0HLGrRZTR1v3HWmRe2ymzg1C5lvvmvGOyqIquZaIagE2j7n56z7zbkYouxV07C9DMmHPXz9Etd5fk7C4ct5n+GUHlg1rwey93a/V8racO6YLYeEUw8c8Dk4cjvGo2juAvbDmj99vGGkenJvyT2Iv8hQN2v7boC11HsNqgM/06XVVgZ651butpvZ1HsfIFn6AFtAzRyGbRcXoURQ0uQw2P6RXXpQffbe0KfXPdKRAQLMfhm2CJaWx1DcZC17FgRzpXOS3rgR9u1ts0yQxHfo9XQcsUfBM3/1gp9rptkoZqMERRWf96BJQ/Kjl+5RxdtSCnjywSIq0YWvX8lDX0dA1TtGxslbN/aFrz5HDOx4dT2Oq/jkxhQ/QL7YXeM3tLWBr5XA133yVtu5E+6DjnI9XxSpCaXHS3zo3Sf47Iw8mgEt0MW6rPBLtksYv6MWaptZs3HgtFRMhUcC47WBhLcFxoM+DHLEdnvEYLMZWOzB3ZnX3Ml1bLEljsKueAMhIFAKp52gSdpM90u45bQloP7K50eO6iadY9qOQHvd5d+Tb1eb8fxgKFN1zX+3WdbP2Pn1qDzD9g2lLOS8qMccCdgGnYT0gfWcDD+OP+D3kXgLSOzqL+dNf58rVldGgbfCpnw6OhBw+3qlsW66+jvu9rEEIwJDwW+Z8cFVzu28qRB7ju+o3Sl2wjQUYCrp47/bcihVRnuHyehKOtictV+O3F1vTxQ0CZQFT2QFBpG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(6506007)(6666004)(26005)(6512007)(86362001)(4326008)(8676002)(66476007)(66556008)(38100700002)(110136005)(66946007)(41300700001)(36756003)(2616005)(6486002)(478600001)(2906002)(316002)(5660300002)(186003)(4744005)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zeA9COQPvURo3drDmJCejy6XFw7LB7/ueGl+FWmE8lX1DoPGp/jWHgHkqFKV?=
 =?us-ascii?Q?dhIm1iUeUWmZiqltMITRRkaWbYnC4A7+Y74na5VAFZwBUwvt+4907Z/Whk1q?=
 =?us-ascii?Q?vw10Ze0snL4JWoljdplqlXDQRs1jQtlpFSLbGYhRtBuuWjnOyf4O8OD/Mf3K?=
 =?us-ascii?Q?3ZdJISmZq5zAeiIguUPwgwigQZUFATnTIaEk1MMuHuh0Z46Ll9lVAY/hui+g?=
 =?us-ascii?Q?1zr/lhdZDITR02buj4brYxoutJfO/sPDw5yaVOEHCPZw8z8BF9TsCw+UEQB/?=
 =?us-ascii?Q?7SujcmbblFchYKHjyAe0MiZ6VtVoSsiNt4DJHKaNXChuUPEjjKl4cbAM7LDn?=
 =?us-ascii?Q?upOT/PyzDCVvnz2HpuFiZv1aVzZVLCo061nuQ/i+ApoFE0s4E1q1GNUwbmrq?=
 =?us-ascii?Q?P28vz2B63Pw33uiz2Wmo+OqPYRXoHMQgKhoT5eOGMNLDne9Apor+K5WUZJDa?=
 =?us-ascii?Q?U0ItVEyw69rtrKaYzw8usy5pUYGzGp9/zcm1s09kdXAmc9ivHRgdvvJFdcoi?=
 =?us-ascii?Q?b2UlkHAi1UhPKVgLwYFZZ979xd7cUR1ytwLbqsWITxPLpK2WDjUiYeyor4Lc?=
 =?us-ascii?Q?WAt8U/bTB/L1auAHeKFcXckj/W+lwPcJoxwqy638ehzZrLLxRAjS9OsNT5ir?=
 =?us-ascii?Q?9AZc8sSFMTo6CbLa+GlVz94pjUetousMujudJVgQH5DMK5EKzWORwLeNcy/H?=
 =?us-ascii?Q?yM3bhthuRZDxYSef6IIRsQSPugbK9U019pypPYCRA4d9UnxmVrPAZYJOTfwF?=
 =?us-ascii?Q?HjWSD2ant5UkAetBsvweFYXc5K6ltusaNLBlzztaZBEt72qaGZzrjH1wFqEB?=
 =?us-ascii?Q?ey6BDcncma1BCT3lAroy8pD4DYddEzaOWeOI/CtGn4BO44YQL+SBo/pg/Gsp?=
 =?us-ascii?Q?tO/Df1SAJeQU5ie3RZSWsz8tshYyKVR2/t79Nn/lFcz/ICjw3nJ0s25k2JIh?=
 =?us-ascii?Q?I9ktnKyMOnrCec6P6Zv1hQBAhoyeXEUx1mg3WqlhvthzFu1QxIlWQlSqVxVW?=
 =?us-ascii?Q?5JTJoVig4/vv3ARxeBQBri4FDoUlJ+/v+fhAfAblP8GVnYTl27GCBpVaiGbz?=
 =?us-ascii?Q?j/92LDAOhZCFHe+JUlrVp4oI+VrRVcrnhBqTaZRiKUzrVLXehTGAAZgJkkD2?=
 =?us-ascii?Q?7xsOq5VO/Qdxr2gW76YvrLYOY+JpRh4ysLZP7FHOYPRIBihOWzNa4AKm4kmp?=
 =?us-ascii?Q?RnEYXp02ilyxb0N5Coe8Hg6JQUNwo/lmQJ4QmVKClicKv2XLmizUFVyUb6dt?=
 =?us-ascii?Q?/AfZ6u9gS5oQeS8PU5BjrRToOejGq6dxq3082Nb4rkAhJLUvN1CzPGYS8Xio?=
 =?us-ascii?Q?myWf8Yd8xQlWWTd1i6ikuPbgdKU47eN67e6cHeOcjZs2AGA+jHP0yy4BpOHP?=
 =?us-ascii?Q?48uz4W9uFnMlO0rdbe2vsp3MVPUa3b0sNN8RbPUCHDWHY4RTRR/No0Ya8wqi?=
 =?us-ascii?Q?0N3XAeTxGsfg8qOK/Y0ZI72uIO7nsPOt4/MRN6EH1CWPWQ77IAqOVyTqMJ5N?=
 =?us-ascii?Q?i3YaREYXTt/WT18iSojzsmzgZBJ/kcfcgOF/UvYh+iWzwsS7l09aCC23dm3b?=
 =?us-ascii?Q?B/K0y5pdpoWn63o8ha8DaojuPbn+E25XEj7ovoFr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b84f927f-5e52-4ced-283e-08da9ccf815b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:26.9838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANwVmf/QerosxJPz9IXxncLpzQ6wiSDBWeTepQBOnGrT8o5D0ximaMYnnRMXmfpF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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

