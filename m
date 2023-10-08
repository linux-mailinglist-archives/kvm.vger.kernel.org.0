Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7C17BCBDB
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 05:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344343AbjJHDSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 23:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344270AbjJHDSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 23:18:02 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2079.outbound.protection.outlook.com [40.107.215.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DC8BD;
        Sat,  7 Oct 2023 20:18:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVpewel+Melowzbc9FqRJA/2pRtHImlUTVdT1eqjndIANc5nIXQ+Y0R5iEeANHRnOW5Vk1ciNcM3cls9T4I74hg+Dke0lIOGR0iTJR855ml+Dv8bPQCD/dVLDSwL8EcfIVQXhFfo3gTwgknkydvqTnnQKrCzHnQxsJGv0/cdbhq07CoztNons7nhDHnlJB5IAbcRKC+1PJlYn0SemckR2GFy+AnJ8rLRVPoxybHdBwg8eFoF+0AYSjuO/ZMhaYCdlnDfb+PGzSBrd85ByToBLW6r5SEHr4PRWh0hiDYds8hsS+dwkX2PW6AJwZTVb1zYxQjX2J9P/XbEa7EVkxmlSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiSSt9+07jFyZ9CDYPxWwuiq4IslOeTq7xqk3JqSFgc=;
 b=Kr/MQ37HRAaK63uVHbKQcZ8oSArDZA89I9sT4nbiKbj83ATY9WGRcyaoYW6kyi+Q4ZIeFKIzEfUfKTi9NMNl0yORKToHA6mXgZT2ETikTaifbx4Q+rXcRFeRZFykVwHe9GX+qBZ7iZgsXfgQlL0kpUENhta7A5gGJfDWUxz4ft9x05ku7fz1iGdAorqhsTkwgi5rhTOuQS22VeA3Khkx3J+fEg+HblQtbWwagCeCV/3XNQgQhrQJec653EPkmAoP9FeRoBkbX8JrnMz1kTZ5912DjPY7Gyb7gRQ+QXVKT6iyoQhEcyCaGVGDzMltW1UJYKryRMP7thFlA/Ha2RutdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiSSt9+07jFyZ9CDYPxWwuiq4IslOeTq7xqk3JqSFgc=;
 b=Fq5+ePF11Qe8BARKKqrSD2m9A7VijRIKwcvaJ7SzFV2mpBe7s01hP+xCHoWrayar9smXjSJThMu4UBTkK4lSsT9ghc/gAJdaJyw/Cd0BuJyXGeivRpw8Prs4K5+NA1kPzgzBB6GcfvO6gmBkHbncJLrc3ctwRe8UXp+8VZQE+v+RV10NxrKPCpVocRxxWrbqzcv/UEeKEr4CN8fi8abZzQwWDRsMdbLYvfzd+mT9LWOxt8qa4CmX9FvXYA0FZyYVqhJkYx8EaPD83Uaae7GU8Av42WVF7QppKQM33YtoTPFLwqc8F3BlfDeftV1YmHlj0tfl3EgIGfAwx0F9Rp3rnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by TYZPR06MB6514.apcprd06.prod.outlook.com (2603:1096:400:454::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.41; Sun, 8 Oct
 2023 03:17:58 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6863.032; Sun, 8 Oct 2023
 03:17:57 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH v2 2/2] tools/virtio: Add hints when module is not installed
Date:   Sun,  8 Oct 2023 11:17:34 +0800
Message-Id: <20231008031734.1095-2-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
In-Reply-To: <20231008031734.1095-1-liming.wu@jaguarmicro.com>
References: <20231008031734.1095-1-liming.wu@jaguarmicro.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0053.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::17) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|TYZPR06MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: dce9fbd7-6aa6-4c2c-002e-08dbc7ad2b8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+vkVSdZM5DWdjpVXkOc4osz8FQ8e1liVn2vbiVoU5IEca0QfgfNd69ecB/1SijXb3jS4UNMIC4E45NJo3ohoWciVM9naab6lqQ56U1LmIh2+SJLnHoD9p6mrGA/ZLWWnG8SRwj/B45PALzyIfJwqDJNjrq7UhJqOFQFVRmF3pigcBwOmqpIUmEqr0H0O996BWzqK0XRbuRfB+7nv5HBH4lh2cxjgCtG7FPMJQ+aJGjMb4TUPQTjxrAERC7R4X95jQnVozsnhsaRq2NMhrTBuqvoY8Yvri+IWdYhREQD7By4Y05jCBhONiFKXsKB0BIPjBI9j7yWY9PVpLA+FlHB9hTWMCsSAB5imnYky7KblvcbsWZ69IXd0LQZQ9Em+IoiklKm+aYE7XS6w+PjtEMyThTG7rwSAkE2Mq2HX3wSHgSuhJNH6YQ9xFAdC0qmMaJOKdO8dFpAjqPa1lyKcuRBLGZ2L09mUZhOHfT+P6W7xd6NTT8r8d6it84FHZB5X9m26j5GjTtUizYYGyGWev0WqTlmLk73TKT2+aTJH1CudFNnBiIbaEBb/IZhkbgp1FjbMochvC7W07prB3lVfDoQvLNKU+MDaT6RDvdJvIdvaDtpeMP08WNCVi2xWJ9VO9lW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39830400003)(396003)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(478600001)(66946007)(110136005)(66476007)(66556008)(6636002)(6486002)(316002)(38350700002)(6506007)(2616005)(6666004)(38100700002)(9686003)(26005)(1076003)(107886003)(52116002)(6512007)(36756003)(4744005)(41300700001)(4326008)(5660300002)(8936002)(8676002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2gpkaHVcgywtV3jSBM59JL2PfJOvGtZ3Wp7n5Fd24duGImb+h08NCd426uiQ?=
 =?us-ascii?Q?6cjFXNg0PGuiMS2jPeoxSAlKSQmrxWx8TzIR39IoTosuiLRMk2jbpUtKwbMe?=
 =?us-ascii?Q?u8OISQcl3bB7FMSgt4QaVdktyjbMiieeu8ePRemKJZfSLqzHTFKtj8eRW3ST?=
 =?us-ascii?Q?Js8whE9Wq6NCVFIk58esC6MLFVzyWpYHa9C33L0QnoIjjUbIpBMAdKbM0bhv?=
 =?us-ascii?Q?1gqTMkKxu+ohCCpALkJs69sEM/8Hiyh/X9RBMB9r8CFYxEHw6ZtkWV3Bc+ix?=
 =?us-ascii?Q?MqnmTfUoKJpmcmH4gOUWYLuRJ3kR9VnjD+vncNAmVYJQHg2Kxxw9BboaCRst?=
 =?us-ascii?Q?lZyYgac8y+WhOwRfI8d/2i66ibvVKf4bZ+loGBykUWrXi/VtQK3NcIAv5aaQ?=
 =?us-ascii?Q?jm4dalaXnlLHTXyx7QDjSmF6mGyld80pXcVhWuTIiuu4xZAdspENCYMUhZ8C?=
 =?us-ascii?Q?k9i0lupN0gdnFgmpQLiXtBlH6on2pDTleUT9OuLw6WboK5Xoy8kGgmIIGmMe?=
 =?us-ascii?Q?IKYL9lLt0dGToLdrEAfGzC6lMlCdx7HGNT1znMXeCyQyMwi8Xcf3EJ1scdEe?=
 =?us-ascii?Q?bH1cEfvrhGA9ltJvN6UKbpJG6SKvCK2h2EdFAop3Yn+KdSAGIjP8pVpwoKDz?=
 =?us-ascii?Q?5T4WChcoeBvCBW3eAi98bi7C7DvsmI50aO9hOWD9gO/yA23RfbjiJB5SKazd?=
 =?us-ascii?Q?NfMWN4Ab8wptp2qMC+mzCw8KwetzQVA21uCAPO4jXM+Qo1g2pFq/D7MjV/5L?=
 =?us-ascii?Q?HXKEqakOsXJ/NapbOBa27rVo3+Q16RoQWX+1f6sbLVlvSBB0pG9qlK/yPEjx?=
 =?us-ascii?Q?dehGhNBVu+YElsu14XVQB7sY3hxbSb0uLpFPgDsXUn5R/HPa3GF6sMhuvxch?=
 =?us-ascii?Q?sDXZMNGbxFaRhdaeiW3YAYWZMdPUrx5/IP2jdRV0D5DQuKwqsYqJbeOBNiPo?=
 =?us-ascii?Q?Wv38c8YtJw+WKss/TU1ibS3rNPWCoxQjdg6UAys4pEvwjVbeeTDfWDxilcpx?=
 =?us-ascii?Q?1qXtvWWVFbPC8pySYk6R55DG3d18Tw+nYbN6IgJCww8aIjv9sww8dmGnDTJx?=
 =?us-ascii?Q?/B0SaL1sJQZX9YVJLHtw0hzPn+nw0qP3VawpKNIjRPaLWlz69wepkls8j5wB?=
 =?us-ascii?Q?T06RZK05hC/T4/Ah9UiRUjLZkjCnJRZaU7T5DhoXaoOWIfuEScvJ9Zr9Vutk?=
 =?us-ascii?Q?MqjAalX4wloIUL66dN4fcvko5tVFZIgK9zhSj3wlGlCy+0XkILMV75lHUhdo?=
 =?us-ascii?Q?Mrsyxonz73HCwWktxFGPK+mUV3MgBH5wCwVFx407gvfnR7tUJSGuvtdVQcD+?=
 =?us-ascii?Q?SWqNRjBZ5ExQm2JRJt9yoQSJZanZvdAc+vTAFprSKxIwBZdfWfx5KnBNY1v1?=
 =?us-ascii?Q?a2w67ujDqRzhZf3DJ0DcM1a3CAegaSMJoL6IFMZS77HTaGT5TCno5mFsx+Um?=
 =?us-ascii?Q?Nxip0DTOxo6QmCLbINY6oRv4ULnDmNFczzNfsE70l0r9V1DpbKAFnus2nJa0?=
 =?us-ascii?Q?V7QDe21aUsCjdDIZ55vul0HJLDICrIO0hhOVSmQEZ3IH6H2KZBikVk/YrZiu?=
 =?us-ascii?Q?K4X6n9lfco7HZTi7A3KxdmSJNod5HoSBxfYWg6/1EgGORAboh/fjyV45VBxR?=
 =?us-ascii?Q?wg=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce9fbd7-6aa6-4c2c-002e-08dbc7ad2b8d
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 03:17:57.8991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcZtrsyQtF/FHWuSTYlz3X8FgcWLgEBmpgQkc5plNGoMGh6HWvZgMo/MpwyhrwfS9FYr7Cr9qOlPuOLe2h5R3qUjNR5zGNb03jLgHhImX0M=
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

Need to insmod vhost_test.ko before run virtio_test.
Give some hints to users.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 tools/virtio/virtio_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 028f54e6854a..13572a677c35 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -135,6 +135,10 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
 	dev->buf = malloc(dev->buf_size);
 	assert(dev->buf);
 	dev->control = open("/dev/vhost-test", O_RDWR);
+
+	if (dev->control < 0)
+		fprintf(stderr,
+			"Install vhost_test module (./vhost_test/vhost_test.ko) first.\n");
 	assert(dev->control >= 0);
 	r = ioctl(dev->control, VHOST_SET_OWNER, NULL);
 	assert(r >= 0);
-- 
2.34.1

