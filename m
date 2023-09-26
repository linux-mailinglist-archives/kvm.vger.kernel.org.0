Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC907AE4D0
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 07:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjIZFAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 01:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjIZFAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 01:00:48 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2056.outbound.protection.outlook.com [40.107.255.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0902FE6;
        Mon, 25 Sep 2023 22:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6zgkHyAMZMqi4AUxoXVinc64/A9ZmMbc9j6HgA9eaS3/d423ZwpYO9a5CbGBq8wJk3FYTG3j8WHcYH58pGyIrHKUVe8i8kIpxHpRRo6FbHZpcJLGy2HviUrSE6KaDllIrprWwMdKjY3/iz6hTSoz2J7WpJ6hdYswBbcfR/kMyRZiFmNlz88m9W1p6NbeaE5ZBDb/1VjHNhaRRsCEtQAr2dpssoED0zwjAa8+uhADWBhieymJnJccUMmVA060Qx63xEYemGTIUSt3c8psFvsfGxZEPe6rX1gaTNgXk52ebDoHmT6PSl6l8es3yGMjNHarxFSuRFnzSeXqL0mMihzBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+d57ygvPLWNbJub+HBNEhkYaga1m2TUe7bjH0aUJ3c=;
 b=nBntsL6U/zU+AZXIf0UiuCl8ragqrKW35SbCVx8P3tnr1VBt8AEJZyKcyVBTfaNkq1WYZrFYOR0j0bv8GBFwvixrxgNnw1dbZibON+yZ10XAy8j39eY+HkVteymCo2VwkmLHc3cZydU65JrfNsbkTzUIbvKqeFCaAityuzykl/gpcd/Sj41bN0lFkXUc1FIiMl7cXeDnY09OC6voTRX2kGsiqDiXRKkQ8H2YYpEndh/GpksGAC1VohgbwOfkaA+ajy7MCLPxqV2iRKtji++4/SooTh8B1iAG84tOJx/dgdhDWK3c943PX/C/ko+Ab4NoOJstAGCHwP94D0pHFetIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+d57ygvPLWNbJub+HBNEhkYaga1m2TUe7bjH0aUJ3c=;
 b=qakiJg0Ub6iHW07jEScoEtUFd+oJ8B97XBqLPr/QAY4fjTyJ84GLI3MPJZiG9MQWhpFv+ECadT6gYEOP89p+MRUcx+3JWgpCnxMP26Hn+icTYYSz0H/O6GlIA71LWNxeGSscY3r+KD9rNefyt5qQ4lNDcrrZQPD80xSotNjbAwQuMKF6Z77o7fhGH/kRG7/Zwkd7Jf4g/DbEUuGSGEbyH+bosxuUNjILh2UEd4UCaqc/ceBRn8oPIeFCpGwIxx1NAXvmXf3HrqiVM6Gdz04GCsyn3qlJvweOFFYKjeyeZjBem8vakcmEfF9h/7I3gXNMt3eKPjQUvqk2EvScz/3jlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by PSAPR06MB4088.apcprd06.prod.outlook.com (2603:1096:301:32::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 05:00:38 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 05:00:38 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        398776277@qq.com, Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH 2/2] tools/virtio: Add hints when module is not installed
Date:   Tue, 26 Sep 2023 13:00:20 +0800
Message-Id: <20230926050021.717-2-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
In-Reply-To: <20230926050021.717-1-liming.wu@jaguarmicro.com>
References: <20230926050021.717-1-liming.wu@jaguarmicro.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:195::21) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|PSAPR06MB4088:EE_
X-MS-Office365-Filtering-Correlation-Id: fc5a3800-4d75-4049-7a21-08dbbe4d86c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e9kFslG+IiWTbmhx8ITI4AgUBSHAToHxbvZUOHl2fkKBqDVVlExmvjl5NuM36GfGYtYhjkzpdF2JDliUmPau63efC8qAbqBLbIrpBCeyqFqDQOOM3BQRhFh/DPO68/g0G1oze5l/SxRzd1LvYBC4k/ca1jBHbSddhw+pHTCz/tPeADoOlr8ptVhz34qvzIHf78b9YPle6WRLEO26+ZNJp/u6M22WTVxPFdDh8TavymBhhUxE9msMFJCoZZAZbkD/rnoF9wNr6jAm9y6Y1KXYZHI7/uu6xeJKGiISmxuyg5olMORKv3dnre9J1evudDaXZ4cCb4ITuW/p5yCbZtzprIVXIOOVJcSqzvwuZ6VgW+W1XycFhSPh3uRiBAZRHp3k+9ZybeC3ZnbqCU0cKZHwK+0u2+mEK7oDVNLwaa/3Baqa8QgHnB4SR9WlP6CCPpjRzyGjnVQG4BOSEEjnGBsZ//ATpr/8vuccp6E2pYgZqJVTPhzkEkQ2Jx20lA2dv0XfLIVP5fa6pvpbMsQKVBqhIAJwMGostZx0IsREeNi6Uc/op7hKgeBAIKbN4ntUT0v1z5KmePG0zn94xEED8ALhpwmrqrphoMMY+tV/Hd/krSjf4dnB6TrdfWYk7yeIoYcP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39830400003)(136003)(366004)(230922051799003)(1800799009)(186009)(451199024)(107886003)(1076003)(26005)(4326008)(8936002)(8676002)(316002)(66556008)(478600001)(41300700001)(110136005)(6636002)(66946007)(5660300002)(9686003)(6512007)(52116002)(4744005)(2616005)(2906002)(66476007)(6486002)(6506007)(6666004)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+65P2qFy40MQ+bw2HNGPNkLkCgK26L6zx3uEFey4QDPt7aKq136wc79XEL9I?=
 =?us-ascii?Q?UhKxHHj/Qxzl38AyxEvNuYi0hgfVUuhQBj5/rBR+giufYiTkFOVcXV73d9ML?=
 =?us-ascii?Q?sgMQOPO6OIjd53dciJ7ghRdGFFcaALQ1RSuqXQKFS07gfFJ7XZe6LoxrY6fY?=
 =?us-ascii?Q?aFVFFc20ipaAQ4Zok2Aqnef5JATxn+3Vm4gU/iQZYD/G3ID8O+rRCqPTRRtn?=
 =?us-ascii?Q?z3j0EupkgGvese6wJgvAoLRhY7BYkSTIyBfT10pEbuwzLOV5dYL2F8D+5dJD?=
 =?us-ascii?Q?LyJGEeK7sd86KQ0pe4oc20EuwX+6W1WJY9CJHwxyx/N4JSZQTB105dHwXFk1?=
 =?us-ascii?Q?TPWjp0M5fBIq1ydmTzMWUJi+KqeUFazlu2QDagWxbkaefR6WGQLexPRiAW4u?=
 =?us-ascii?Q?t6hw448hjs4MIUszS4E2pEtKAjNuojmQgv/NWpBL1pHaeoGFA1BTfaVWzpWF?=
 =?us-ascii?Q?MrJj6TNl3/rtDWOe/HoUe3fQyj7GiRKZI/gFb8eAaYYs9OyliGC7RvW6pXdu?=
 =?us-ascii?Q?wT6JYmV7rNm/pSF4FOb22xomelwuiYl2pT8c0XtduPNZpLF3E/t3Zr+zltqG?=
 =?us-ascii?Q?GiXDH77XByuBlkQ7FCvWf2dGBgFkOjTD8VyOL1EDNK/FqqZzW6Xhx4SjT3nE?=
 =?us-ascii?Q?qE5ojS8a+duYLiYorLC0TePqSrl/dysrEgXs+jc7i6C3xo0hYXl7k9nxkO98?=
 =?us-ascii?Q?BV7rEq43hX8tMnoGNMcVaOuF3mg6KISKp9Be+wEsEJSS+GIPdRoBvueS1r/8?=
 =?us-ascii?Q?AT3VUeveYD5vLyaLiSlNsFUQSJBYYlHJSy53VoN6azvGJIKI3yyw4nQbYHv0?=
 =?us-ascii?Q?E48IpWabYHgd5ykSGMKqGoLQgFv/BhzNpGqFFi/k7VIe51OUwgbeMfykwkGx?=
 =?us-ascii?Q?xST/BAStKnRYbBYSAYZ1/Nojskg1jq8C53bOWEX+0a34X3fbwD1iWysjmubk?=
 =?us-ascii?Q?mOs7SylM5P3cnOr7iyJijRMi6uy3rhqJAMyIF1EhKovO7T6fw2+a9SdnXRYb?=
 =?us-ascii?Q?9AHk665eOFQQocSIKIdinb2V1joRHeiupTty29gOUVZmxbShABcwncjWJeTz?=
 =?us-ascii?Q?1rmxFgs+mAGmC95Hulrx3JDtjqeMj/2hzNlcKFqHExlXBEAe6v6B866LFd+x?=
 =?us-ascii?Q?Q923sLR+MclOgi18JFW/IC2Bpwa+zx083vsgE4m/OKbDxosIzvFBe+Fe/RMH?=
 =?us-ascii?Q?2HAFi7LzIWI2Vvj6sl98KmYjkoWgu8irQPTO9Dj3S3MQvb+pZHOlImMUidaP?=
 =?us-ascii?Q?r7VeS8GFMarlIHEQFFsvj9cSDlaDRmgco6c3Izgm5AWzOXW9WpGGLNr0s9Mt?=
 =?us-ascii?Q?tTtiFiBzpOc8nhcvq29dwJ1guJpQCyCqNoXKGninR6XOCkQbc0IwzcDvWGCq?=
 =?us-ascii?Q?22lyjvOtwjt66voWv0rOJXkG1eFWXD47Sxgfr/tgJhbREQ4aWMvHhzYmIJCM?=
 =?us-ascii?Q?IzLu07idGR5mdg5mbQFffrzcamck+fZCjGsNMV6nk9uWNPP7iaaUmRUlY23b?=
 =?us-ascii?Q?tX2cZaXsBXe64CybZaoMscQFozsYXF3VRLVBoN3Kis57n5BYQJwqoUQxx/HB?=
 =?us-ascii?Q?F75hPOKTyoZGEUFfRLy3kJqGkAUak92Z6nbAw2mWKQvHeCObN4GaQIxtjAEF?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5a3800-4d75-4049-7a21-08dbbe4d86c8
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 05:00:38.7986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jVj1swQ7BbH6mUy3y1nzeNARZa6IdmbhVpARYVVBfshJA23+YykoR3bd+GbWGZz5xzyVN6C4UKXmWULvzRWct9TsRtjHApKyKY8/o0DC7Q=
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

Need to insmod vhost_test.ko before run virtio_test.
Give some hints to users.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 tools/virtio/virtio_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 028f54e6854a..ce2c4d93d735 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -135,6 +135,10 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
 	dev->buf = malloc(dev->buf_size);
 	assert(dev->buf);
 	dev->control = open("/dev/vhost-test", O_RDWR);
+
+	if (dev->control < 0)
+		fprintf(stderr, "Install vhost_test module" \
+		"(./vhost_test/vhost_test.ko) firstly\n");
 	assert(dev->control >= 0);
 	r = ioctl(dev->control, VHOST_SET_OWNER, NULL);
 	assert(r >= 0);
-- 
2.34.1

