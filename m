Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732737BC538
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 08:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343618AbjJGG4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 02:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343578AbjJGG4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 02:56:10 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2069.outbound.protection.outlook.com [40.107.215.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C184BD;
        Fri,  6 Oct 2023 23:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcmWn73NH/rVMhw/IkIFC85s0jMGle0p11r5FcEwCWbeeMjp30bqjOaDlhsved+IEkVTOiYojGjGCOMi9ciu8PNFyWYz0qILd4ZfBpVPLQY6V3/OBxt/lYuCHQ0zP8J49RPr+5Zr4icGuT1Jt2iXzdD1iKJRYPuc6xPkaK1GSMVo/DsgWdDZ101RXnKrJbyVkdMxTpGhAaOUOsT6UcEjRHUb7vXNHNvsFN0buZRZ9xgajIvh4+xFrluJQ14xzNgfQLcNAXJw9BUtTeizDYdao1+nzJHSAbUwav/P6oZzU1ceaUB7WiulHZHh6yaXzQW9tVuMJJQnovdkcgtUGZTKmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmAQQl8A0PCsUojiB3YSOfAuymoeUEitnUHJzywMjMY=;
 b=hUNFkve3v18jVluqmMjUoSFiu5OZTZdjLsD1VP31L2OWcYsJ66c1SYjagxNI83U4MXeJJsfCERBxYIz4qEJgF9XhOjQMunQdQWHb7kvdbUnkF9nH4u8qkzIru9FD215dWMKInyJ5J42+62w3zN03Rs95WnRYkcwu4GF5bcXoAMHyDR1jC1UxhX5qVR2Rh9wb3srxxEN1xL0I06ESwzrmjgOP1sKSNqivgwxKYG+DQq6DvyG8ctML16bnIl2rRiFb5W7m90v7LR6c9VE5WCN2JvlQTHN1+LL89nJ+tVs8/9Y0uT2Yok/F2vKfa2uIGDbht7LSxc2e/53wLEly8SmdqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmAQQl8A0PCsUojiB3YSOfAuymoeUEitnUHJzywMjMY=;
 b=ni413uTqNxlw65q8g1WBi5WYN4ope1u1IugbcVoHFwbzic0ZOwToku4hmnegEmJemQGp+uK4xpyGeKYvwbNf8BdDwJPiRNX5Rneiw2MksJpXjcCFK/P2Z7iXzhYo8stfCEb/wJp4n20JxI0wQSY3zriSbr8zc+0uzPv2d0AxpQv5mOYWuQTTgtlJGuXTzx9QGkxYa7sMRibrfRQW8RXMAkQm/mt7/m+nOHc+Shq8PhCtc8IFMEJ0SGndmh9URzVE8TAJnLLQniXrotdNbJDTenW5+W4PXhgWDhlaAC5Bt3Anvd42xNo8ZnClifTerELx5lClc2iuuFem/9Lk3jjDqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by TYZPR06MB6745.apcprd06.prod.outlook.com (2603:1096:400:45a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.38; Sat, 7 Oct
 2023 06:56:04 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6838.033; Sat, 7 Oct 2023
 06:56:04 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH v2 1/2] tools/virtio: Add dma sync api for virtio test
Date:   Sat,  7 Oct 2023 14:55:46 +0800
Message-Id: <20231007065547.1028-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
In-Reply-To: <20230927111904-mutt-send-email-mst@kernel.org>
References: <20230927111904-mutt-send-email-mst@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|TYZPR06MB6745:EE_
X-MS-Office365-Filtering-Correlation-Id: d4f1d500-c40f-47ff-a437-08dbc7027934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PqOhxHxAd2s811+oko7SrSKHuGTxtjtKq3gy/veBMuZPJoe3qRjPlPh5oJwMaAEfa06bI3FXnb8GLuyk1eMRuJmTADD67JeKKaEAyTEJZZqfajvhtq8vqE+ORgSlMHcMDaMePRXIxDKCGmDQuz4Q8jAVJY4U5CTDmAGMX8b12lCq/CuJ2npxP237x3JzJ0L43EiYXDWE+qAXf/CgKrMSR9iPIBSuZXqJisr31UhFcDYQw3BF1QPgeTEaURqvBVuwF3v+ukgM0Fb97uvLZJs1S+BHS0+iFIsq5Gxt4uuJHqYeThAyShWTxZWDruQqx4WgDGIrGKkUUr+RMXhOcWbDdvLX6RF2OrPVuH8gzXS7LurxaK9tuyskRhSXSz/Y2AoZNuuv/fnW4V/F7kLgCMsfpm8u99lOWGps7nG+Yo2bO+sOj7O2hCb2dEAv03Cobruw+tl4Z/PshLbuChQrfvw4JDb2Qxk1sRVRAeeh7mHyEMOatW4TsujpjLBdwsFOcWy7nWN3Ux5fNHfYHtXYXuu49JrJGaUPh0iwwus7zgTvq/MoFw0UXro4u1En625AZKYKcyESR7QSg2hvEIvnrexoTTfZO081CdDROHS6TEB0AMJP3o4RifbduHXbdOb3JrTb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(346002)(39830400003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(2906002)(4326008)(8936002)(5660300002)(8676002)(86362001)(36756003)(316002)(41300700001)(6636002)(66946007)(66556008)(66476007)(110136005)(9686003)(6486002)(6512007)(478600001)(6666004)(2616005)(38100700002)(38350700002)(1076003)(26005)(107886003)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ayjCmb2+9IZR6IrAZ9de4Cvsj6BQD0QnerNq8r8IW6AySnkHLG8yuv7tsw/6?=
 =?us-ascii?Q?1+FjHX2oY9WRcsIh4jvPrxnIdHgfyVfGO01PUs3cEDPg0SF6kixsJwSjuI7t?=
 =?us-ascii?Q?vEqD3yyddjNtS0soQY5HDdjylmFgLkbs37WQlp/AJ9LHa9U2cqLX2Sgld77O?=
 =?us-ascii?Q?47jlNmFF0BtnnxUtJ6U+KHgMSwSlgFT9mCC4QyOrYstlrAeWOZSk61e0SyHu?=
 =?us-ascii?Q?C08wudUv1M+DwoOYPjo3KER4x466Nf2XFPtXdY/Q9l0Lup8q8NVd4UYiGJpB?=
 =?us-ascii?Q?rv2jtRJIuclUxO9BRfqq5z1nA4pdvVO0fEhDXGRcbeIQUfXs01iQh4MhUQaQ?=
 =?us-ascii?Q?s6fL5rv917bQrS2onRgAVInYiUWwxmj1DYDAoJZuntpMVM/xS2ePhX/Du9qS?=
 =?us-ascii?Q?DT7s4Bq1ww6ZVKPR8CaaPDDY2yujrItvB826X1KQ43Nf7ncgpabn1BARDdBR?=
 =?us-ascii?Q?jZ4G21CLiOnneNskEAgeCSglpFovsvgkPoR8a1GLfjeWKWHagnEdHNV7D55c?=
 =?us-ascii?Q?lmTXzHuzxMapFtVnLeyGTmGSQyWjFKnYYgt7xjfy9PSeQIJZxS9WdF9O0ZmL?=
 =?us-ascii?Q?0qV/H960fpq8GL2aflLG5wspMHJtVwIkyzDEGDI3mJjSs/mR8UYAD5hPNfEz?=
 =?us-ascii?Q?b+cl5/sdrS2JtqGVCV8nlvT/EQ8BQyAZ80ja4zjuetxxBOXKEndQtbW3Kwcd?=
 =?us-ascii?Q?WlkVPXE2rD0fBucZOdwioK6A82VJg6R2l4FM76Ub+FS5IrO5nyJT6SZN/XVb?=
 =?us-ascii?Q?cPnikVasSJchw9p6iMRwkkuO3XYfYYF/BdCFdqaYkbM5gdxxpsI9xKXGIgaM?=
 =?us-ascii?Q?SYMMWmeLvxtfOQ56S4IcIv/2VHdssvlzXkQry1szlaTIc8BaQhcjMCrCuX0X?=
 =?us-ascii?Q?XgemBO8ooNMpCks0fmQ51gX7ova5DT/+h0Ad/pQ9uXIdOD5mGg+PrdJIgM0E?=
 =?us-ascii?Q?CI3M4ftAJt5IRnKrg1VbbqM5QWzoOWELW8WyHpwN1PZtRP6IZjOIM7SICm3F?=
 =?us-ascii?Q?zF1B1Qajtbyy9+80/HYT69LEzkst6Re60+jPCqWhTuQCOO+u+N4y17leEB40?=
 =?us-ascii?Q?DB3yxnYNCbbcBj6e9K7kK0yYaEhHX8ZJamg3hrYK7AahEDP4nIQdhH4/Xkwv?=
 =?us-ascii?Q?fvcylJOHqDC7LGGB7fhJ07HYrzkEKXXug96SwqIIR2k+5HL0n0rVVj54UHfd?=
 =?us-ascii?Q?CUlSb/fExnvv7oy+SErYtj1mbQ8yr1IqXs8+PTPaY6CkxdijnQh7TGm71BIW?=
 =?us-ascii?Q?p1mtIeoSrcR21H02lSkzu50IU71J+daqNSvamRSikuAfvqQZe7v9nv6guY3Z?=
 =?us-ascii?Q?kecjzMOUlPvgPa65qPoApLeButUqW+pw3ux7ztc19BfhdqrBm8X3lUYx4crK?=
 =?us-ascii?Q?0Wp49HRTRlZRMRUrtr/4ALe423h4aVvULcDaO0sd/wt5Q3E7GDz99TPeKbZk?=
 =?us-ascii?Q?cbcq5hHCTAEf9ewZttgDpyBE3Eu+um1knPl44pmV3TBI2gF4spbdBAfLV4qd?=
 =?us-ascii?Q?x5mCa5Nt6s0EPRk2fY9xMCAff2gO0hm1lfta4iFIOhb3UCgpxRQzVchVeR7q?=
 =?us-ascii?Q?BJCY9zmaKR6PmccEf5pylNY+L9UcDeP/MehFhrecUlxAZcgVol/QItnIIA0K?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f1d500-c40f-47ff-a437-08dbc7027934
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2023 06:56:04.2418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LekE///l/2t/emQ5tachb38OXYW27x+mM0rETfEwh2Eh/QM+5GhyDNTwvPpA0f7Gsuc+tjyalG/G5VN/MUVfM26BuFm36kQI6qgY+W4IYY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6745
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liming Wu <liming.wu@jaguarmicro.com>

Fixes: 8bd2f71054bd ("virtio_ring: introduce dma sync api for virtqueue")
also add dma sync api for virtio test.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 tools/virtio/linux/dma-mapping.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/virtio/linux/dma-mapping.h b/tools/virtio/linux/dma-mapping.h
index 834a90bd3270..822ecaa8e4df 100644
--- a/tools/virtio/linux/dma-mapping.h
+++ b/tools/virtio/linux/dma-mapping.h
@@ -24,11 +24,23 @@ enum dma_data_direction {
 #define dma_map_page(d, p, o, s, dir) (page_to_phys(p) + (o))
 
 #define dma_map_single(d, p, s, dir) (virt_to_phys(p))
+#define dma_map_single_attrs(d, p, s, dir, a) (virt_to_phys(p))
 #define dma_mapping_error(...) (0)
 
 #define dma_unmap_single(d, a, s, r) do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
 #define dma_unmap_page(d, a, s, r) do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
 
+#define sg_dma_address(sg) (0)
+#define dma_need_sync(v, a) (0)
+#define dma_unmap_single_attrs(d, a, s, r, t) do { \
+	(void)(d); (void)(a); (void)(s); (void)(r); (void)(t); \
+} while (0)
+#define dma_sync_single_range_for_cpu(d, a, o, s, r) do { \
+	(void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
+} while (0)
+#define dma_sync_single_range_for_device(d, a, o, s, r) do { \
+	(void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
+} while (0)
 #define dma_max_mapping_size(...) SIZE_MAX
 
 #endif
-- 
2.34.1

