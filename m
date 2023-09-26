Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEAF7AE4CE
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 07:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjIZFAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 01:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjIZFAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 01:00:47 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2056.outbound.protection.outlook.com [40.107.255.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533D5D9;
        Mon, 25 Sep 2023 22:00:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT8MKj+kY3Pd+OCIkVgR80L3pk3+fyBm4RKP1qHXYxrzWv+oPAmA1IEFs+KjaFysDbYmy6Uq6s+S3R5JhfD0jSWYfZA1DsjKE36rNoc5y55bnL1psjbptOkValLX4pRJdYgH1cVR5rcwfj/kUvJbCO7n/0PLgdIFyuQEqKp/bBKzYGDsE7xV4BaMyQbHnrMOgO1x6ckAICDXN55KDxhZ8ySRfi81x+2bK2jBNIkUzmLPo/qTwN13D1MXx0TisMN1p8QnEjpR7jkbITw2oFKcCfgTdlLdTWEEFJWtM8MJFcLGQ2u4fnjSPtHyc6B9nU79V9BIM4IyOtYC4KDlzdaFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmAQQl8A0PCsUojiB3YSOfAuymoeUEitnUHJzywMjMY=;
 b=cPvxw6yVjsvrL7by9KTYWkypV0BdCDP7a2OQ/eunUBcUExGcjgnDJkynNwQUf75s7z1v0/Qy3U+3az2unO3UdSQGINGLmlSeTScDXsO0j+lQWkoJwDWZw4d2YdePxRMGvBezOfgElI5hZjnw9O/w+vkPcvG/xjetvHZCzENLoy8CcTU2ukTXv7epB3bnUWpoYRTvMwQNoLiW6G9Hn+g3D3eY8lxxZ+Mhz7zpWUwc0WdN0pig0cCiXvVCzirOOTGtTVZhwJoHDWQkyl/1EpinaYRgkU/E8o9MZWD+3q8qFOsKE1O8bntl0NnQbOIxI8kBzKsGCbbFcuY6VUNHAiNxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmAQQl8A0PCsUojiB3YSOfAuymoeUEitnUHJzywMjMY=;
 b=eEP5YW17wsCJXRYEAmqgq9T9s3YKCaJFLrSn7rQOqjUM379fYKZrB8l7d59w/gE35W7On6w/NT7cEtfuB4qnJ/z8ebmyqmQv2wXPR3tf52cq0xlXC4YQlTAPpfFpU3ABV1XX63lLXjxa9pr8vuHe57yuAw9V5EsWM+udEdxYCjHPmkhODIkjXEiVJeFbu2uGHQDSJWLwQ0upgK1iNbTsC3FTfTp59INoVlyRnXWShHxKiWK87AHDtCopNMmMjtaxm8fTNTpbyj7Z2ehNHikqta5/GfbBNwfjVIMM1HeAXLaldGuDguSzb9rKSahacHTNkpUbLB9R4obNzl0ATWEQkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by PSAPR06MB4088.apcprd06.prod.outlook.com (2603:1096:301:32::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 05:00:34 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 05:00:34 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        398776277@qq.com, Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH 1/2] tools/virtio: Add dma sync api for virtio test
Date:   Tue, 26 Sep 2023 13:00:19 +0800
Message-Id: <20230926050021.717-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:195::21) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|PSAPR06MB4088:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d6aa460-b3e2-4bbb-41c6-08dbbe4d8410
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qV+FXulbhiL5V1rYCcWSaUr2OEebjNLvB+S0jFh1LAklNzsZTcPsC95Qfh7xw9AUcEtthTYR4NCvk6Xc6wfuO99qOtgRXRvhoZXS6Sycwip4Toj2vTX3aD9915C+JoKQpckhpup0GD9mfq65YziGSVGLVLDD4K1CQ5AHJLBlFO7ZRtNWtfuVQEIR4tYjyzGTbCJ1Mfa4Pzw2VxQkKo49WebfDnK6H3KcaHMXPKG1aLnGs1KuaxEo5IluwWqnJk7XwWnEQya9yqXwIh4C9oDCc4bpQ6mP/lHTfoD31TIlj0nCEnQW7ZB8cFcCriAd/sP2gYDmWApv2LzFTICu7ATZoo4ru0LymSRkCvZqAZebEQvBoN6rAimsf5rPFHOuRTr/LXqb4O7SEaWXuv5Vwt6UhgD8+b48tu0WyILxQBhjE2T3phwFrmchfT55WrFMhcrBeqtoEYuoj9jGmEjcGrhiA8lyNACTX5idTuBe2rVoSQSksfKE3V6Bgc1sFF+7/4YRCVjC3SSwM8i4dWy7jM5IxqhbYhCBptGtEZxO67ETfxC8DtN0f4RcatX4cLVX2LCkNo9ztQAOpAIr3Mw3ILW3CBEVSmrhmlvmRePK5vv5CKwMXaEbSYT5LOqse5wHdJUY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39830400003)(136003)(366004)(230922051799003)(1800799009)(186009)(451199024)(107886003)(1076003)(26005)(4326008)(8936002)(8676002)(316002)(66556008)(478600001)(41300700001)(110136005)(6636002)(66946007)(5660300002)(9686003)(6512007)(52116002)(2616005)(2906002)(66476007)(6486002)(6506007)(6666004)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZAKGojI6RMpmscGS99K8AGBHPtIeriyPntE5X4jDecyUPgvNsCuJ3Whejm/H?=
 =?us-ascii?Q?fz4TKMGdTnrTSh5MzxQoPpDBmaHwmk17dkFAP//yPqzqv4fL9eWsNV9P6eGH?=
 =?us-ascii?Q?pGxNne+lxQBVhvz6FW8L3BVEpd8iDitEKiimJeFxQIx1SGZG7Htt+qJ2zadY?=
 =?us-ascii?Q?4zn2213ti0rH3KzrNuHPltcY6nnG/pWPGJkoRh3iw66RWfZPbQoCvAcV7wwP?=
 =?us-ascii?Q?3EQ+eeTngzvwQH860gr0KiVzDpRXXAiGZxdpg3jnjCd38CEO9fW7WC2/7Qy0?=
 =?us-ascii?Q?ko2eYF/XVg/Y1njrQMnwEbyMARd9oRVAbrvITSunAeMPKxwWbjB1sl9B5oAe?=
 =?us-ascii?Q?Ap7zmknC9COp7xQ92FNb3YiR7jUzFId3ADa0224+hEtltn1meyXe3T8I38wg?=
 =?us-ascii?Q?IEwWHXaQIz8tb0HHd8kRV5cQUEpf5SSDYf0ZxAKXGbmrA68NgQnJe+RoIOd6?=
 =?us-ascii?Q?AkjVH4nWQnXsNOcYX8ZP6IaJ/Be9LVUlWv7e4DrqhwkbOTJn728z/AAnoUgw?=
 =?us-ascii?Q?WyF7LsxVPlJFD0SOhlATtq9fwAtydCkMVj2SJVU5jUIggvqpLJUsvZZkHNqr?=
 =?us-ascii?Q?SpTw+wUVZyUDCRDhwE84z6ft1nwKgiKQ25qH+fLIgP2eNUBlOLTKddH0n4mX?=
 =?us-ascii?Q?dfTu7hviZjJ7/e45/IpAtGb4kwn1FTSteulnKeLSjDckbYQdooQZOlCYv3HO?=
 =?us-ascii?Q?yZSnusk4KpTbJ1cqICtvi7H6Gyu2QK4A5BKfWsKU+bgVTBYmtsJZ3nzbU5+M?=
 =?us-ascii?Q?BNOfI0sub/qqlY0QqSFIXaW869Kvfn+OIGW21bjuA9MKbbJmsr9+QVjdZ7+d?=
 =?us-ascii?Q?KfLpuykgq1X5t969cHMf9ETZBancstDlKbFt0GXVlyaZZKCi7V+t53OAo9HU?=
 =?us-ascii?Q?PoYcE5X1yWvk6LVKQGXhgxClb0jZb6/bgIwa0KyXYj4qO+ZKc5j5zfGVrJvC?=
 =?us-ascii?Q?8UZ+sW2cFyksHKAPlvfjkY7QHIvw5YrWu0mNWOaqLtBRRMXxy8pCkXfNmtk+?=
 =?us-ascii?Q?2KgrTWNVWOmcF6L3cgxNGdc9GtzQAnho1Tb3H9W6DHyhnV7LPi2YwaZY1aIy?=
 =?us-ascii?Q?e9ueVufo8/3RY/wgYxHRYN/Jvbde1agmSroX0E5CSbnOimwIfuFusgT0Nk5H?=
 =?us-ascii?Q?kZ8b07h3SQQazQd8t1Bh4j621cVErGl9El+HmLsf7nvZVIT7HzmxJxJE7Qgj?=
 =?us-ascii?Q?hx8pEiHRzXLz6nOmay/CFXDcfRbFlWWJB2Mqj9WeSP950+oSN0HbbQjd4jjA?=
 =?us-ascii?Q?LSs6OqoLm2vmmo0XOYM52fkSyeV6GBvrMZSGiGxUdfqFC1RP0qL3/Xg0ggU6?=
 =?us-ascii?Q?2jRdl76MAazgss89ueEo8iLI8muVFmfsab5vTwhA6Vqv0F5mW80OXGjsOpPU?=
 =?us-ascii?Q?KUE85Njd6s4lwgOK0RhX72Pa/fktCooyrgXHLuCKYEsT1x9GkyhTOAyU3yFC?=
 =?us-ascii?Q?23XHPaVamewb44Xh/J1OTvNMX+W5YISKzg5bRIp0GAqT0KNhG7Qno6Gf08Un?=
 =?us-ascii?Q?gZ82ecc8Mfqk4Vo/Fsi4i6ORU4EJFcvbaaMRTQOTqdI4MOsXT3X+t/3XQDID?=
 =?us-ascii?Q?mnyXg4gJIqBfx56lZ1qIbtXI2YCuwg5wc2IrhRY29VnauS9Sipn1DH0Yv22+?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6aa460-b3e2-4bbb-41c6-08dbbe4d8410
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 05:00:34.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sP9pdj97ckyFbxrlEUK6wgsLbxKKscd/LHbmmR6IeqFEYFgC15KqfO1IXJpI1iTe+u1BCTF9YJR2Fwwd0rGSyf6OkMWH5x9DBKCacPEDIew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4088
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
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

