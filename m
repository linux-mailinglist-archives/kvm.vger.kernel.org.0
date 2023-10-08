Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0CE7BCBDA
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 05:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbjJHDSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 23:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbjJHDSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 23:18:00 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2079.outbound.protection.outlook.com [40.107.215.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA27BF;
        Sat,  7 Oct 2023 20:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLbsNRIMq26TQYoedyoYH83d/Jl3qMB1lsgtD1qJYjxRbgn1MLAMCoNFAkIgHCfwTL2ig8wQTSRm81QhCu67PhvXkPDXr0+2nYua9hz8gf8WYHReYjLS7zsb9c/UoOIaqUXhdWescIGDpSe5BD2Z9PL2KAVm3Dt+Je/0tNGpLJhyC2qK70ItmHG/O0KH82m9kPEuBYRgSyY8mmHlCF/kcKylRxTlT8e9d2znJho2WEAeS9p0Iwibf0z3Zdd4r4klltifK+gCAonBGDxWmXVPxt7BPUiAaVUPCgNMFms2VWJ6U6DPXVj0xBjArpAqFbGve5C1OmfyoQ9bW+I/g2ZK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmAQQl8A0PCsUojiB3YSOfAuymoeUEitnUHJzywMjMY=;
 b=im2EoKIQ8KYAGJvuRKhFnpahAsqN5d/2t0mpgyl9dLZjk3NMuJN+3/liE6K32T9t1CkImW1ejqpzuNr2VdV2ICSrIFrHVXpdoLvLX1b+M/H+LA1hVHhCSgsEWcd55a+Rg0y+GwkfrHYvYIgKuDI4x6dshVnBGMdu4Sv3yYWTtuLgmIQdDFIViYCDOa9nq2QLuykIJnWgIJx5HxNE8NOuoJ5TvZxS6fztSD6EUvQqY/eyL97+Oj/4f13W14Ih5IS4D6ZL8UzXDJaWOBAXofwNusM1lDsQQsKawKLuXq7XurwpXppqJMckmonVIdb+ILMf8qgN787iTSdICjpNB1T/Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmAQQl8A0PCsUojiB3YSOfAuymoeUEitnUHJzywMjMY=;
 b=JuT9CDWYYRv+I/4PyMezFl+iR3tTpD/dEbqRaC1UnqweBhyXJQUQir5cDzm2F/4ttlo+U+awTCG+dlCVzoSf/IrsQtO6nxLqgb3NuBdOXc9B/0mEFXWwt3gPEb4zHA+p9il6OVA5Lz70bS/DPiS853pFEW0/1mdCpiwoaonjBQxMKfDRs2GmD3AcT3rNT9pC6TmxQTruxwnV0VR6dsdJpTpZWG+jnteQ595IbzcCZQoHYRoUtzjFVKxjM1oosQbyPCiCRZ5R4J5r+9Z3+PbSpp8ZaLyW5iiiWXAiLlLTdA94Ola48/pGg6TU879jP3jAn26qt3x4+ZO4Ielm/Jp/1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by TYZPR06MB6514.apcprd06.prod.outlook.com (2603:1096:400:454::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.41; Sun, 8 Oct
 2023 03:17:54 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6863.032; Sun, 8 Oct 2023
 03:17:54 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH v2 1/2] tools/virtio: Add dma sync api for virtio test
Date:   Sun,  8 Oct 2023 11:17:33 +0800
Message-Id: <20231008031734.1095-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0053.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::17) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|TYZPR06MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b7873b4-fe76-4f89-619c-08dbc7ad2942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZpiVRySAxrpOELbK2TL6Q2neFcAWJTPTp32LrLD6qns+LN1XrrpQxSlmg9LR//p1GLVXbpkTIpm9TDbR+tjsJEIb77P7AYMJ4xVsr7Guw+GMCfDXH9zPKgG65DkGw8WHAHmkhJwOKP4DkL9WBFgt14TO5/abFLUkB1qga9xSSf8rwodjDNnzG4nlGtxu7xEX78ddccjpm/JE5kGuQr8IKnPxg5eHSVSfEY7ZhcLTcKpfMnYnzRczPSuRlmXTu4O+1SBWSWPPj9J67k6kH8VV+lpd0Py04HSqwM32+23TGt8EyUAAHuUXOPVxmv7YrLQGLklok2HM6dWyf9zhLfU+Z/ixGQSePO6ag2wxxpetre3+VTpCd77oq1ySRu8pZNAv8uNNxvYUScb0W7XKiGrz1OedluAArG+KeJ3ktziz96cRjzY+uvHnSVWpdyKqYz+xLPzre5V+3BA3u//N3O9vzIEe/C3WMHcRe3ITy2LSvGLIVekTI6MSvhFDl3aO9LVUE9GskuhLFSIhmUNL3JW0sWG7KetjlJQeLzQcc216uExu+/HVDt8vJKAuw8OHYnL2L4LRYwNIeWs5sl9EtvACDBSVdNetD0oIaZSqLwM/VcoVc/WycpuUdqjHdv4pQn5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39830400003)(396003)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(478600001)(66946007)(110136005)(66476007)(66556008)(6636002)(6486002)(316002)(38350700002)(6506007)(2616005)(6666004)(38100700002)(9686003)(26005)(1076003)(107886003)(52116002)(6512007)(36756003)(41300700001)(4326008)(5660300002)(8936002)(8676002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LOEOmlp1k57CfPJsvCNqUG9tXTKcuKiMdzS5yViuSpv34TAuxrhA1SGBdiFm?=
 =?us-ascii?Q?b6eh66qr86kBo9CGL1Us1RUF4u2KgJYHeYi6n7B3C2Zh7rjcI5/QoZhQo6Xp?=
 =?us-ascii?Q?VQ6PgmxHTgAnaWprotU1hwb/glOCfqwiGfXcm2n01NrmQatx9FL14OGTvf9N?=
 =?us-ascii?Q?9Rt7qcJB6axrHk84Ump/nd5t/cjt7nyedQOxPrxJ4xDf2hNDsVVzKXkJdm9T?=
 =?us-ascii?Q?yPa1wJFWqMv0yGPH8oCeX9184cJnc1V1dY4LtudLzpDVsdkgNLSW0lbwokCh?=
 =?us-ascii?Q?Ozpx95LBnG37J6MuqwrfngCX9DPhTwCb2tmMhw3wgvL5ptGzS9GWivzFM/I4?=
 =?us-ascii?Q?Unlzz0rtjViRijKShP0f+T8uKUkNMfwd8PiTgdlxwJ73pBSophmTvOL38zzR?=
 =?us-ascii?Q?PDnUyXlOrQvxtfTBYv2OdZlZfO+zmPj+mpZMLInnNhx03a0juAmyoEYOmXuN?=
 =?us-ascii?Q?/Q3wrceiUiBqDjfe8bokckgjez/Fw/jrQM+yoyyiTyAfHz0UYpMOPMhPrzER?=
 =?us-ascii?Q?2anQ8dqgiMeua4A2V2trsvuhElYtgkyC/BF0PjbbQLp5d6h+B/WbYOaxPfEl?=
 =?us-ascii?Q?XVGLowsBZF8lP3kjiK63dLx73l8aTQeoPxsQNwsmL+IucB45CxtsILDykHBN?=
 =?us-ascii?Q?XTVyHTtpqpLMrcmIme2vdp9rjHRpWV9pmtqBMRIN7NtyccZvXmaTtIBHVs16?=
 =?us-ascii?Q?kAswyq5/vaac0e0ZnVe5KdttdSBEAjn1LBFQEh3vZZ8HHKiNF73XfWv2sVU6?=
 =?us-ascii?Q?K8YA6fnSYDbtkv2sSmknUJx6r4x1+boxkl1E6zZZUgw2oPy0qwoZzUIYZb27?=
 =?us-ascii?Q?IwOXUCSUyEYbsVce9R/HeoIpZPKHQn2eA+d28zpUaqlRM8tu9m+agJp4Q4UB?=
 =?us-ascii?Q?FsO0Mcpbn0njOJT8YfnWsXoTh8ymKMsw0ql4o0eoXSCaaOWV0TTRmiB2wiW9?=
 =?us-ascii?Q?JyUrCfMpTYGcpRL51T3ynBP6DSbzN//md+76rs538ErG84dvawfZjKiW90ze?=
 =?us-ascii?Q?rlYhBF05Pv31VN/47T5R/FOTUHztqhbV6rEi98P1tNW8N2OcuPSg8APEg759?=
 =?us-ascii?Q?9gxrv00kjaJKjLP97OyZTkzRc28e6bRKI5ASTXhp1S61rROX9IPvUsYkSMQq?=
 =?us-ascii?Q?ecmD3UhPtoQMD/qfZlWdQr+cYW3dnn3+1sAE+NNeQe8DmIX7HzhGbe1ONwM/?=
 =?us-ascii?Q?madbnp7M8FbPiRlnuh3//jmZ8bTb70CtuY2XtLxy0FqXhY0YJ1i93p9VCX+m?=
 =?us-ascii?Q?i067MsUTmmL1b5V7KtUbf5+MsvWGe11Q7p6DYBKk/2VzBdqvRDbMeOYKe8TY?=
 =?us-ascii?Q?3BESrZ/0ZnaGTR365cd4QvAo7BhW6KTJ++hed/AmFTuz17pb0LoAJT/cuyoF?=
 =?us-ascii?Q?mn4nccvGgyBeZnuJCPjFeaJlh4k/lcS/ExLzpOoWb7kFihzcV6ddtbRvSyXH?=
 =?us-ascii?Q?wjTrX6MjkbpLfsBTT1ZXsc+uUjLAs9FklnOxTL9FpWeie3IkfVTLZhXDC7NC?=
 =?us-ascii?Q?JWU+vbZ/UER9pgn3ZF1Nf+XLJvt9Ib6pBy/KYsw/yctn54JHv7hiwLgNf/Os?=
 =?us-ascii?Q?WqqFw0o1JfI2wRZotRZXF/pl99QSHunC0GsCq7+8n/A6zd7DKwjU7e79eeLQ?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7873b4-fe76-4f89-619c-08dbc7ad2942
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 03:17:54.0880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDvbADrDZ0nQhg2JBWOnNsJpHOJSfLvEXzteuTn6xM4sABD87aENqfRI55a1o4FFWq8Rttb//xd1l+dBDX/hEzkD2dulvVsstPCPyJJEuXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6514
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

