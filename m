Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D487CE6AB
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 20:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344824AbjJRSdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 14:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjJRSde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 14:33:34 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2130.outbound.protection.outlook.com [40.107.13.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31312114;
        Wed, 18 Oct 2023 11:33:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbdE2xi4ItJvpZsQt76xwj9f5cm8bIrTzOf1fS32U7L07KH2GQNKrfKJeMe5ryEV5qFlb19nTK341xyTpxTGg/MM4AXdVUFSw6NiGms2MwBl0A3Jp/tVsx9wkNjD9QBUpxfqZ3v72pp3tOrB2/hotpFSRrZfh8cBe3qoxFvbwjtYpww4j0oENpkJf8fFANF39/Ofev0+OhvMP5UJwOqHMj3bChufKaT+TkPjgRDV1gw4lOtXhlcsHfYiu/2FYFuelQnhMbS4zQVt5F74DEcevf2vKBpDrJ/PwY2vGipsqBISFlwIa2ZMqHjzr1BHtRAJrx/3aTC2LDrsugqlsr0WAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evUAGQf5IYhFKWZHAxtq8BuJvPx+ARK5yZPGDZy0KCE=;
 b=Hh0N9xzHLMPuAA51qU/Vi5EAkeeMXb5GLzNQMTX/DIs9x9xHfvVSHgqxPlUwDhsXVBFYTnBJCckjL3COc5cRVwqcdaO3R3CC8Qx0jn1e4rwFGdgLFAHhXbwBaMvjEdnhvhaolwVtx+0mghFzQyW2jT/MnCR4brbUfxyF9ByGz6G4ksT0HmVaccSE2ayvgJi77Yb1LE1xPkZVhsBmj2reVUAjXdTyzdrQPspAtTuehVxJcerY0Xqpm3+arU5QxQokz7ZtXDXa6x27eHP8prKQmsLlepVcHMYQ9zpienFgFqm/ce99jrmLpzT8D6Ee1gRAlOrl4/rpiftdEsEhhzP6iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evUAGQf5IYhFKWZHAxtq8BuJvPx+ARK5yZPGDZy0KCE=;
 b=dLj+9AkjYHjvpChYDRqREaK2t73MKH81OXUuGKA+hB+UYMbrCuWXvK+XPGPryYABqeOs9hEKVqHJgVt6kJM95I8KSE+YDk2HgK9NfA/pnC78u5xT3XMKhvD1to8ypXnXLw8tJ5bdPEVoau5IBA8YFIatPJJ/2EQjOxqzhPnDZi8mGEPVFwWAXsA7dUv6uxuk068FFML1jZ+uW2LnCdWEcgYozam/LT16o96akn2nUMmrXFfjay8YiShYQrkb2yrJa5dXl6O2QHGL94kgn/cd5ybkCuTRxRmocJxXWXkmMH0Q+5k0EmSPf+SGuM+aDsnDJM49bEjlOidQp6aRVfaAQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from DB7PR02MB4521.eurprd02.prod.outlook.com (2603:10a6:10:65::25)
 by AS2PR02MB9191.eurprd02.prod.outlook.com (2603:10a6:20b:5fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.22; Wed, 18 Oct
 2023 18:33:27 +0000
Received: from DB7PR02MB4521.eurprd02.prod.outlook.com
 ([fe80::c3aa:5631:dfe9:e09c]) by DB7PR02MB4521.eurprd02.prod.outlook.com
 ([fe80::c3aa:5631:dfe9:e09c%4]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 18:33:27 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH] vsock: initialize the_virtio_vsock before using VQs
Date:   Wed, 18 Oct 2023 21:32:47 +0300
Message-Id: <20231018183247.1827-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0033.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::46) To DB7PR02MB4521.eurprd02.prod.outlook.com
 (2603:10a6:10:65::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR02MB4521:EE_|AS2PR02MB9191:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c7cefad-7339-4899-8dae-08dbd008b837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHbdFQoZWtccWB8ItB/6jW7p6jJDHEPwb/oS1LGJpsAkGBUTp65rrJh2SX72GpWfmZnxIHe+lyEXxpm3TA3xrSQY3dQXW7G68z/LXpkVcBE9BKx/1LlbdYBFWdi4uqCGwFKIYKkbRoqvKxZthAzBuyG/Tc5bFS+QR2KwAeVBoGDC3TOKHnSJb1HvuMGKoPm34g9jvSbFvYAVQgmAIDsmNk6fdOBO9GwUX93n0rXIIYSoIPz4gKnJ9a8vM+lIyTCyNH44I3chFNSTx5sbRtEAFNHS3J545LFEu5uRquUhekUH/YbOt4UxKFxtZmO9YeneH7oDoGhDDzr02nbYHWVhd1x211hvj1vqcOgkxkC+syJKd2M4QZvfnJqXtpH9lCQ0W9W9KjasaGqGD5bdK50Zhu38D1jcLpZnYuDKt52z9EEuCh5tjVpBVSekHGbWM+ow/mjmyTxsUMeUX7aW92ObdJZAlUvUaV8iHNQ3ei9HXVW8F3G+rAqJYaFsxqL6rBfxqHUk5CgQvhnozgJ6FxzgOg6hKj/p/GWyJP7iVDuaBBgp3+LfPMqe8R2P5XU9wjwa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR02MB4521.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(376002)(396003)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(83380400001)(38100700002)(107886003)(2616005)(36756003)(6512007)(44832011)(316002)(66556008)(478600001)(110136005)(66476007)(2906002)(54906003)(7416002)(66946007)(1076003)(8676002)(8936002)(4326008)(5660300002)(6506007)(6666004)(86362001)(6486002)(41300700001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D4wUM33fliEQFIk3XKu9k/rXam/yrTmqERYGmkvbScA9uGvkautfn9PhqevN?=
 =?us-ascii?Q?zxy+LiwNlVFht5oN2A2wK5DQCuHc8Mv2FdDQiCn3wdB8IvE8Qi/epKIvaiW0?=
 =?us-ascii?Q?LIPCZIO3flEL9k0oQpRiIz+vSxkC+ltEeqyUHnPt/p6Jd+S1AqSjxS3BHyEx?=
 =?us-ascii?Q?2rdg+QhHPd/WbW0lVKcErikC6ZtUIb739IA83S+uK95geCKFhDzUHyNJersL?=
 =?us-ascii?Q?7nsKjavF6yaaoD6EqkkoPeupMgr7wctQl3w9rKjEvv844FQObBI1NNd4vUdM?=
 =?us-ascii?Q?kJ1FsSp3DFxjnFA43020HHciOuZyII4zB7fW3Kfz792lZ96So7H9Rzc/+obY?=
 =?us-ascii?Q?Gip10U+/xH4D+bq4rf25Rv2Z8pcENpVbL1a1etHvap33RHgx3jNfuQb6M2gm?=
 =?us-ascii?Q?lr2EQ3Z8ZtDMkaRd+6LJdfw2YdEsTrmBByO9E9hpkgAJPpopqU/KHS8PDTYi?=
 =?us-ascii?Q?TunVAA6JcoQwwvPtPYuu+ewd4Mjn3bI9s7ZNcW2YWaHC3/uAHvL6/kzTlYfQ?=
 =?us-ascii?Q?iX3WcS8ZWVsdbkrf7URj9XBGwPdgkWoMPmov7LkkVaXy0I35DgUtBI8PnTdQ?=
 =?us-ascii?Q?5ATFjOI12uabO2M7IDy6rYOzQnYHWe0BdIBJy3vhVPwd6rGt98lFZ807uUaZ?=
 =?us-ascii?Q?fJjsIYo2ol8/iSE3tiMR4k8BNnojDAkqzzfychPx8RQ1YfQ96JZNVBWRyKzw?=
 =?us-ascii?Q?eOj+AyVR2Lcrad/8jZ0f/fjJ3sXL3ApKJQlmDCtF7qL2GZlYhy9NPHvCBt6l?=
 =?us-ascii?Q?SJbIVzs412P9NiX5pm/ad9jLpQiweIDOowc8/of+R0XozEn9QyF6ipzWLC44?=
 =?us-ascii?Q?6vmlQbM8C/tmcAzOfJV4dg9p6z5FBXhy1tcs2pekCo8ZDVZ6YMGZsDGl/mQQ?=
 =?us-ascii?Q?w//2EYoghejPJyrJIaEldKEGWExnDrXlepYsrVuWU8LWrelIKZh3j270tCNh?=
 =?us-ascii?Q?zSFPfRYh46E1EVIutW06+PeEifUX2EG9MlC1WmwM6rrrZ1ZhzNg6Vah2qz9n?=
 =?us-ascii?Q?g5bBhpRIleDSYTGfrgWvOCo3DwXimolmZsAPFeS7A5/rl1NanEdUq4SIhdXP?=
 =?us-ascii?Q?KWj1fTVHX75COWIkSVVR2qGarNzxYz1Ogrn5i23xBHEnXhILjWEgM/Fi4w6E?=
 =?us-ascii?Q?4w1o8bdt4R3usX0i/DR9S60fRqgXTbC7VeXblKKuAn2iwoKrHyBvTyvIrYQt?=
 =?us-ascii?Q?JiFWpHNVatxyUr+Z6laWaoadVdl2742Gp/l5wYiNrrY4at8qMXBP3sJs9yRr?=
 =?us-ascii?Q?Q+iBh+rYtkynvSTJ21R2XallvpYoShi4tv+mQMSNgOCSd/fijiVm10lKhxQq?=
 =?us-ascii?Q?SP7G5ZIeeOm5OeOfN5lnYHIb59njf6v6lWQv/gHb/Kn2AX7I9b/0H7DaKCkD?=
 =?us-ascii?Q?DzZnLCUfzXgxJBAwvMYg9qDGTtDm8kPIwURFmtRV08G4dvB9B0j3YfWU2mW4?=
 =?us-ascii?Q?VfubE9MtPMGlAom5hgapLxZRDVBWPvKQ5DZcCp/3nr89nylKKNS4gSYzlQVq?=
 =?us-ascii?Q?+9ieUFq7s7G3aoLsCi52pIpQ79JUP206fx3txCrWqyhpJxu3MxwMaSmxdOAk?=
 =?us-ascii?Q?NGMRwjRIV+1/8Los/rofSkPTTqg2YgQj3uitHWERgIhPFvPK+hw7YN/reHnA?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7cefad-7339-4899-8dae-08dbd008b837
X-MS-Exchange-CrossTenant-AuthSource: DB7PR02MB4521.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 18:33:27.3743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rs5kvZ68z56DeECIZL+WVU4kdZCiNU/AL9ekh3zrldQVfZE1OQ8FkIjk//vCAPpDZpou5UpFCichbY9+pkgJm4iIaJOrl6NQt+NER2IyrTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR02MB9191
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once VQs are filled with empty buffers and we kick the host, it can send
connection requests. If 'the_virtio_vsock' is not initialized before,
replies are silently dropped and do not reach the host.

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
 net/vmw_vsock/virtio_transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..eae0867133f8 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -658,12 +658,13 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		vsock->seqpacket_allow = true;
 
 	vdev->priv = vsock;
+	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	ret = virtio_vsock_vqs_init(vsock);
-	if (ret < 0)
+	if (ret < 0) {
+		rcu_assign_pointer(the_virtio_vsock, NULL);
 		goto out;
-
-	rcu_assign_pointer(the_virtio_vsock, vsock);
+	}
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
-- 
2.34.1

