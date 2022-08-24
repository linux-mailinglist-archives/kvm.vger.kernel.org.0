Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD7D59F35D
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 08:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiHXGDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 02:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiHXGDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 02:03:21 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5924391D35
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 23:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxlmyBLJQhSJYP2FLif7OLwbRBNOZun3ICtLh87zGoDLXemLNv5+a34eqMw0HjYtMpjcf9n5DxZXBw39fPL76KXcKRPubBBGw49Us4Dl1I6lmo3gQsue6rPAkPpFW/xjFiCQhBw0LT9GTEiop4nqHghhV6tzfMTXZM6WPrtYtiFiqqL7pGrBXR5UgA+PppAkqWoqQDjIZrvveufIdZ1Lui0PFngBJjeKkA7Z9cLhXQyjD0AJ1pu5ChKo7VfuV8VU1EL6pCn2a8nkhKYyy9Z5aIF87ruXAamRgg6WIB3XTQ9pg5OV8y82fnn3WNgDcE2UOR3yZCKI29ksfjy5appxzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2W05FjzWXJjLViokw6MBI9wO42tmaAewwMrltv3Wbc=;
 b=LPOsVjImwgkzPxS8pwACJfsFDeKtfSaFoojedekC75Xan972KRXrxujhU2X+UP8hp3vV17oolEhcyg3ZHkQGrwv1ba+10emBkZ3CGMUhtWvtPZAYhyK/FCuVnmgXLqDwHJdSEV8Rltl8NkmVdhAxZw3t77q5034Pz+kWS8Xc61V7kEl/5f1IEK+eghQEmruOfTzrg5kmca7wR26oGCELHx75dzILbsQ3SELY7Va8EXhG7S1DNpJwk7McltPZNFbTKk9nduutDN/TtMtRBFdWvSnJimFJBkPsG/+D4aWzZYVOSJCJ8ay0OEBIuPi+vnPy2BjqkPJkcn7qrVetgH5HOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2W05FjzWXJjLViokw6MBI9wO42tmaAewwMrltv3Wbc=;
 b=CNamQEMoCs13gUZtZTrx2D5X2RCnBTA8PtfyZah88aPpB243ZIsnffYpfpsl5EkplCcskexzy3amS34ErtBEuMHCDduc6Yv7NRZrSO9s2YV3vHcnCjNl0RcV/sWBw9GkHR5lfX9UiL6bycV2vRRf5d+iDhGNjvWr8ba/v2CsBUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB5914.prod.exchangelabs.com (2603:10b6:5:14f::31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 06:03:18 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::7058:9dd4:aa01:614a]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::7058:9dd4:aa01:614a%4]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 06:03:18 +0000
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        gankulkarni@os.amperecomputing.com, keyur@os.amperecomputing.com
Subject: [PATCH 0/3] KVM: arm64: nv: Fixes for Nested Virtualization issues
Date:   Tue, 23 Aug 2022 23:03:01 -0700
Message-Id: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.30.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::28) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262fc823-5d75-478d-bc88-08da859656fe
X-MS-TrafficTypeDiagnostic: DM6PR01MB5914:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /e5S5mWzDcv4KKlvEuEBTRoNY17ZnwRJCZpNAkUAM4JeN5m+OG4Qynag0BH0R0MOuhOHe3mL2lqOv55ZI4428bB32EGJWVsY/rll+s73jmNaJNL4kBAGdwfT1Ch06tUlHy5dBQe70TFzwZoCxRau9qv+k/hSPGm3h1HPY7IzHmw+nFCKprRQ2KPVJsCiXvW49cxVf8X+TuwySK/5XdEyzN6kwZcCl9as69tiZ1Jah/JxieeuffHsYBGZllRHYYY22666+tcEzbnSdkf3Rnu2/lW7bV3pmMbC1WOQVQeftn1JHcCfgqa2a0COcRVVV4mbpI5kbXeSNHUrBuSIKjS+nJqsOcKyCsnNBgq/yZeyAp+UiKLz535pk5HItzD7WHumRIcMDhNAUifdj74ZPTf3K5hzb120YokAnICzIiQjAMiw6FIA1Joteul8CSoC9Yq6VVIIApRR9bjLo0V4z2Li8Qg2anazocZaGFh3MS7D8+YNSsX0O/NQO0DNRT4t9auzSAGR8RVoFa29SdJGMlLpvDrXeOVr0hzU28JUO5ruLTh/7BkeIPP0spC/Dbs3NCC0RIBhJhOUunNrEA+3n9A+j4UqeIRqedS8i+vjiX24Pcfyu3s+SFkF5SyL2vO0JFZLUsOvnvGr72ihUddrx0CAz+re26IuxhSVBbMjOIu7hYsfO8ewmpomCHE+YvPRLMVTlzhxlUmEt/f+H0p09rGcbX2/OdGW1LcmYd8OuFfQmghAW5ym7gJActsV+QvyfQpDt6xua6pYMFz855Eqzzsmlt5OfQRZ3OjDc4UfE3golFc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39850400004)(396003)(376002)(136003)(346002)(86362001)(38100700002)(38350700002)(6916009)(316002)(2906002)(8676002)(4326008)(66946007)(66556008)(8936002)(66476007)(5660300002)(2616005)(966005)(4744005)(1076003)(41300700001)(478600001)(6512007)(186003)(26005)(107886003)(6666004)(52116002)(6506007)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QOVLRCMbA9VR4MZdNKZ3b720pxbjyS5sl/7opCCQGyaVhM/lAinkDiswI276?=
 =?us-ascii?Q?zkf/b770Wo/L2HelsUH4IInIrTQDi7NdN4WkNCNQ0ASgewi4omZct99jCdon?=
 =?us-ascii?Q?36TBFXuYG6db1Pc4V38A4iqDJozb5JypzPWkRptdBMSoGVL9SS8jzGJPWgXJ?=
 =?us-ascii?Q?1H/3iDmxZbVPPFNUCJwp9gZf8CxcmALfs3tq4r8w5PLjHmi1cEMA7zcRxOQV?=
 =?us-ascii?Q?hVsYm6kLPFqhPFDFK+3sQXx0PT+eRP7TJqtc4Rs3Jy/AyrDlk/SPv9kReQJJ?=
 =?us-ascii?Q?KRChd0oVOh44R1jpF9KXHME7jFPac2XOB5RJrKlcBJjirvW+EBztV46flfTZ?=
 =?us-ascii?Q?j6Lrf1tYuxKHhiF/wX6vH4MV8elF0Plf+Z4FY33mDIMac7tt6+Lh+OIW2GyM?=
 =?us-ascii?Q?UXJtiXs3a78i/wKVx/EhHMB/ZTtc4VlTo9UN3jJ+EssvlFfGhOsVW2bCCZxY?=
 =?us-ascii?Q?xKYO9m/8LLSKsedeJ2XjgLLGiLY0kGb0C8TGkkJts6q8HNMypl//Fjl3sKf1?=
 =?us-ascii?Q?bREeeDwDj2dEDM9Db5BMSKRA/tHvDweuXYsAr21vtUWAGF2/sRV/WCPh63r+?=
 =?us-ascii?Q?cinbr6djeJ4J23Q52/Y9bLllTFu0jIxldR4f/eY9ME9CEgcggFD/QqNv8Jlh?=
 =?us-ascii?Q?l35BapUWkhvlBViWZKv/7mStqpJ8GdedryT3xN+cuqj89fg2mhgYU+yaFu/1?=
 =?us-ascii?Q?AyUsqf/b27O9eOJ9CsC6bwtescWRiavbvwrZL7C7bRcBbynfHmvisrIFXVI0?=
 =?us-ascii?Q?ovUxJ3bMFIkmK+9+7T8YG2K21Q4mu7ZjDkok6XgvJuJpGl1A5vkySEQpHx8V?=
 =?us-ascii?Q?XfhmquHVsfKDpRrzZoUyG0WQMiVgQj+aP24ySiEZj62Bh24o+ReCNhme3JLY?=
 =?us-ascii?Q?bh+drl0UTFJL6PqdGYxLpQ2DhSR6YZwN3zCE+vV1/y4C4eqZHn4u2fwrVAVN?=
 =?us-ascii?Q?PeitLwtla+yHS/MLD7Ndtml36Nu6cJiwcaHM+EJn/1aZiXcwdKv/+vx2MOEa?=
 =?us-ascii?Q?CT1r0Up/lBrxuJhdQoSgnWJV/H/qvWE0q0RUQW41KJWegsyxlrRAXyl8LZ5B?=
 =?us-ascii?Q?2R/m+/WSxpzMgXh0NfB9WF2j3FYUw8durkT4b3d85eVqmWyT5jh7my1nWG3b?=
 =?us-ascii?Q?8zd/RICKZ3ED2kC1VmoR8xO5rYGzGDBdziVOorNSSfg/nofxjIqHS+UkS8xK?=
 =?us-ascii?Q?VE4oxpN2DLTlzaMosMzAdVilhZ157fG/lLpY9sshfzxXhxejdxMO9SDfauOJ?=
 =?us-ascii?Q?IV4QqIPRmDuCrUgjY6yLJO7d3ixk0+AkQrn41MM2y04Dc1NyqyiSm8RFA3hK?=
 =?us-ascii?Q?SU6xxrhOxujb+xLERk6eRbsxovlrgoCFu0Bq/sFGggmK8VQjqMekonjZjaXX?=
 =?us-ascii?Q?6p43hTZqxqmrmXxVOiXR1wVzjjSx5fQprtjfqHMQPZPdWimP0v7o5vR4eQb4?=
 =?us-ascii?Q?JSGT4xeLz4VqDpTG/eF0vZ85GB397vSJpWlkyaf5TveFD/4NtwOl0Wa7PXCr?=
 =?us-ascii?Q?maD9xVehWf0x6/QM7unRVDAmxXT+xB6UrQTJbFDFGCzxRr/vwGtjgf7enTGp?=
 =?us-ascii?Q?CARtLxMA8rBfnkiVjgvKPeB2TVBr/SlWaD/o+KkpP87TH3PGeZzumrhPymEJ?=
 =?us-ascii?Q?h90L5pxRuRyJCpMg3E3Kg8Y=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262fc823-5d75-478d-bc88-08da859656fe
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 06:03:18.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fvnC4Xc4efHdRbs6gvBG0ovq7N7xvB8WCLJHXk9mR1bnUH4Py0EjYA9EMjz/Sz3Ik64ycB4UYk0f/RM2rbM6Nuvi0CIrVUf12KcG4g2yYJb7WIwN1iuDb/RKBwTrD/7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5914
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series contains 3 fixes which were found while testing
ARM64 Nested Virtualization patch series.

First patch avoids the restart of hrtimer when timer interrupt is
fired/forwarded to Guest-Hypervisor.

Second patch fixes the vtimer interrupt drop from the Guest-Hypervisor.

Third patch fixes the NestedVM boot hang seen when Guest Hypersior
configured with 64K pagesize where as Host Hypervisor with 4K.

These patches are rebased on Nested Virtualization V6 patchset[1].

[1] https://www.spinics.net/lists/kvm/msg265656.html

D Scott Phillips (1):
  KVM: arm64: nv: only emulate timers that have not yet fired

Ganapatrao Kulkarni (2):
  KVM: arm64: nv: Emulate ISTATUS when emulated timers are fired.
  KVM: arm64: nv: Avoid block mapping if max_map_size is smaller than
    block size.

 arch/arm64/kvm/arch_timer.c | 8 +++++++-
 arch/arm64/kvm/mmu.c        | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.33.1

