Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4005F32BD
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJCPjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 11:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJCPjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 11:39:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2477F21
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 08:39:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJx6xsdYmXJQOqga5j4jrVdBU9+dy/7gAsjqyvyc2GlqOUy4u2MTDpCCYiyU1X6WAsj0PHPNUKRFJSO21OsIXn+gcBN2dIDDyyz7RiqmJYZyuLJgGJkcrRwJ47TcZbToCu11MZSWLa9aOYG0P5dIZ8p4xFbONDZHSjd78VEu9oCEghp2CHrFtMpWwS5kHsZGHEG47JediARXEF+RyuPBH7bG0REYGiiZ7cTY/w9H2Q5DDI/QZ7x45b5L6aNNzzm8DkbLC5KFTKVYJsCDhqFxXqEQBoXzBGNi1BNjR0uB6OPeOmm38tMwS4sE2DTOh1IW2QXkh+GmODt7LLrlmDn+cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRDXqDHX3kVxO8OcurD/1uM6q0kYj3kVf0ZEqclkIL8=;
 b=fhdbCcgKjhoa94l2wKnjKAajqiCZ2u1EU/Ruy4aj6ZD++LEYR5CvfsXr6PWCRqxWs/t7SbkdHW25wtoFXtJ1caPv2qwdnCilRmx0A8WtaHdpYLnZITQo8rV5yVEgT5aq7JJ2T3Gr/cof6HE8Cz6c3lEx6mphSpkEbFiXDQejNHepX3O7HgXY0FlfklmeIqG2kTYTPrxxgfsq4Pc+rAuzhCZ2x/u9bJRB/aYwxgmUO7IVp+pI9pTYtSXnepHa+EHtg6VaRSCI6ZCKuSypBQikGa1+3oDnBtzI6CGcbGvqigfyo6h15IiybCFtzD6H0ZApeaaSxK8g+XnBDioxBQwRXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRDXqDHX3kVxO8OcurD/1uM6q0kYj3kVf0ZEqclkIL8=;
 b=ZeB6eXER43oWXZO0NHBgFJkqxJs8T7sPJj4BoHgRxZCTMu7Cz8+8djG/nCX0wRH0I5mipXC7ZVJ6lhX/MlJBX7VREMtnP/prh54A12A7t4ocuOsijE0qar/MMN5qsn0sz0Usq2r4Hp5fNmCg8NmcVNlPA9xkEyqsfe/5glfuDPS/qDPVjFqT4C/KLjVVQkOQIds5d+ChNcJVzfWTjZwV3PBP7m7jG9Nm9KeKoBRFZMeKSQiIuNV6lkINPONauapfqLxz3eFqAceFswn85ueWEKIE93+6Q6mZDinstdp70/3yNrIqcoS5b27cqSCfkCjsgxu2PT5mA0TZ/Q68Q3tOHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 15:39:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 15:39:35 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 3/4] vfio: Remove CONFIG_VFIO_SPAPR_EEH
Date:   Mon,  3 Oct 2022 12:39:32 -0300
Message-Id: <3-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:208:236::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: a6403ba8-2723-4635-f564-08daa5557906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z99h+VFl4Hg8QhSENUolT2pR6pHsnKXAEddy6qffX1dKChICqg7PFeH/4ccRfr5d3nCOU1m3bsjXVHoiDoqgSbxgigdmCE8bK4PT1Yx9rcHP80ZyH73O96nojj/KrW0SmPNF4PUJS/KQ+nbkm/rtyL/XxtIeQqYM4ntHktNVzKlSkZ4rOx7eO3mAUsXDbuO/mhqIl5ajDkQ+5l5gocQ3LXTRJeIsvEXMmksF6ZMe+hpperBld5obhJOmROdALH528fjFHkd4nsxMbtbIwUgyOJ28QjwvothSb+Yrqk2a/L110yN/6F3UItm0J4W5P7SfwoG96OEu4xAx7w+CDh5AAnCaQKG6b2nkWQ2lg296X05bx2ao9S8C4pLSWgi2yHgbl9lGgprFzTWyc+vxGrMLyX1Aa1et947ub1+CST7HJhNXgBiu2AO/d8gmtbppGThTGwsgkHXRacwhTXBvzFDlgs4+LHAYVI/TmhMemjYIbftc2ZPF/cZUhhF6SiW1m9ahIgPYc6Vf/VL4RWCP+pY1r3xRmOaVMijg5lyCvnHkXVcMBpOX0gKhdcxW15ObHLz3atbLEYIO/AYWcQBjiXrOQo2/WbzNcm13npssVH2ozSdF+xKOaYHwBxwpS12CxiqR71r6KeFG8YN7h43F7+E3D1OLUMMwr3zcEmkgejYopIsmx/ARHoC1hI6f5LUZsI5jRdKG+C/scmBfOJrdNDTi4ECjJCbUwJ4dmWfiMUODUpvhK1W84PHTkC2tEb0/N6vz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(6506007)(6666004)(38100700002)(8676002)(66556008)(66946007)(66476007)(36756003)(86362001)(478600001)(2616005)(186003)(26005)(6512007)(6486002)(110136005)(316002)(2906002)(5660300002)(8936002)(83380400001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XI71kJtWg6bVWrg2ZheZeLE4rfvt8tK2FA4uvBM3+Tr+Kh0Q8AboBolPCdUn?=
 =?us-ascii?Q?B+kYcecMYaAotQtc80nx/guGt/ggtOwIPa1uTtaV39UZAJj9B1y3oGP2JwJa?=
 =?us-ascii?Q?WDUCtbWbHeSZ7ncInbrGQDiBW84A69KGLtrns/hXY57GZ+P5RGBT/Y1a0LqP?=
 =?us-ascii?Q?2kJHc/MBtoCC0YzoeL6tC4bmzqr4Pmxy/p95eSFC4fXiMMWUUvbdv3EZ3xuU?=
 =?us-ascii?Q?Cj2AyGUHFSzzWrDL3YK0Sa93HxXRefn5f0LLYc2tDF3cMNoCUtdflO622oc6?=
 =?us-ascii?Q?m5hKRuLnsw1eyc/fP9sfzqck/LMI2LUAnyVqiKaDVekyPnJLFQF/Nm9NqUGL?=
 =?us-ascii?Q?y6AuGXgItXOlIHlOGT+OyfAUmLKRZy+vYWn9LiQFE43RC80Pp48vMTOwA6SP?=
 =?us-ascii?Q?LZTN3NOpOdmdGMFkRBEsWOyyIJycVuaj7r9a0EtuV5ODuPJ/LHmC1foHc4DL?=
 =?us-ascii?Q?Cbk2U5gq5CsC/UJPqSxLDiGLmSRpc0bReGvVUjy+8ek1W8GJOQ67I9vf6hE3?=
 =?us-ascii?Q?Y7RRIfpu49GZ6X4Y7G8iLI4rzmtCaeIRXm5nTzLywkL53lqC20y57mKnP02l?=
 =?us-ascii?Q?2uS/4iZQZ1J58Qkq8XrIwGZuJp1LoSrG2cE88ip9u6l61ZWpZukNgCdrcKlL?=
 =?us-ascii?Q?TmOcRw9N4yCGZBdnca1gjHOheBbnPAAoLxKlP05SKn73cbB21Rb6I89HFkvN?=
 =?us-ascii?Q?mji+Z/oALEOIR/jC34N1scZ5p/9db54ofOkvFXv5WWeA2EWlRmbH6Mb+mH1J?=
 =?us-ascii?Q?CRrfjPN+BYHF0jxKYNVGz0FEYTIBuo6rVta2IoKVt3FfdR44DazMDZYx1aCR?=
 =?us-ascii?Q?QLDfCauGKG6sR+MjM63M6TVgTLP48RMkxdiJya7BCzDBMrciL6XHwF9jG6UZ?=
 =?us-ascii?Q?xshR7SNndU4ugvGScy142XUNBC9YjCkZ9ZhM4kjb+SLdtMrZt4KXJbNa2wq7?=
 =?us-ascii?Q?Yf6AnyCtVz7IT4d2NJXaZlhrBpHZf+fstwEY9gBf8FpXvljdVRiQeusvH46o?=
 =?us-ascii?Q?AFlhv4MR0lKsNPFNH2ddDt9VVkpEqEro5xrrH1Mg5hizZJf4u/KRehuAJyhN?=
 =?us-ascii?Q?3WBeRscCo39crJuqyz4K6MrPLGjuv2xTdwR9YnYXfXttd94rujC9PC7YzqDk?=
 =?us-ascii?Q?BLBJnPn68Bg0Ly3yJbK3k5ydrCyAR/zvZ19gT5N0+Z9svsd6SK2NK4jPc8OM?=
 =?us-ascii?Q?oFkKQI3Tvkxcoyd7TMMTdQS+5TRqwN30hL53JQHdKLB+24zxg4UjNoBCoPuJ?=
 =?us-ascii?Q?Wj31f7rGRcMzdfeLTebmDZTPOM9AiA1nYRl7Wp/V5BQAVtHnmGxaCx5SpTKp?=
 =?us-ascii?Q?YTDiVbFjlKlcVesF/Rd3vbFltLBHa0SDzMPpg4eKVCJSxuWttF4B3swPwnAe?=
 =?us-ascii?Q?UkVv9KAeGGE9AKVeMfMc3fSFhHvGW7yJ8OUAyVbhP4yqEIZWh8k0ZYpjsLeF?=
 =?us-ascii?Q?bQ57V2KlUcKGjy1mtToQ98cznNr/IAiwFm0H6ia2uMW1WGAog9NojOBkkFkV?=
 =?us-ascii?Q?+CLdM1V8q5MPRvHI9PK8A+/hqPK6WiOl3ebB0tWVNY2hjQRFSZGE23Bi9gdj?=
 =?us-ascii?Q?cP9SveXKXr/WhK/7siE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6403ba8-2723-4635-f564-08daa5557906
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:39:34.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmGZ6dj0aqehq202sjidUsK9HA9PRfYLVmOiQdhIjeeSqHsxh+/LMB1lARxdULyH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need a kconfig symbol for this, just directly test CONFIG_EEH in
the one remaining place that needs it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig             | 5 -----
 drivers/vfio/pci/vfio_pci_priv.h | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 86c381ceb9a1e9..d25b91adfd64cd 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -20,11 +20,6 @@ config VFIO_IOMMU_SPAPR_TCE
 	depends on SPAPR_TCE_IOMMU
 	default VFIO
 
-config VFIO_SPAPR_EEH
-	tristate
-	depends on EEH && VFIO_IOMMU_SPAPR_TCE
-	default VFIO
-
 config VFIO_VIRQFD
 	tristate
 	select EVENTFD
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 24d93b2ac9f52b..d0fdc0b824c743 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -101,7 +101,7 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH) && IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)
 #include <asm/eeh.h>
 static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
 {
-- 
2.37.3

