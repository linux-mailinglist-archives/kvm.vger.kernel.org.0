Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A08B7D401F
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 21:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjJWTXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 15:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjJWTW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 15:22:56 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2119.outbound.protection.outlook.com [40.107.15.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A8310EA;
        Mon, 23 Oct 2023 12:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzTRT53CI167ci6FejcULyR0Jw13pbJWwY60AChmdOqVS/pfnYvAgxy3MlnQw4eu1b1W1/4cSdVlX2/jTqqp1lDVeuGtNxCeRZWDkqlTjMGnZ1ycT65gFyNneyCSVKl279vdvOKK+sSrymKiA48EGeeHwtUOzuwi9EAAWIBKHy2oDwQxOLKqeZhSrXU7gx+HhRLKBJQ+QuknxqZxgIPbrkZXlfuI62UQc2KzAfonIvhBz9P/iQl7TiwKnAzCUtyvgRqsi/PZ+cNuVBXZBLsaQlrCbMfeOPEQGhlXto6Q8GwqIWw80MoIlEJVkvIskInEpqFWoyiCTiwGC4Y13SR4OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wTuNbWBmI3EIdDCMVRJRt391lS4YweGBs2kDaSN5O8=;
 b=K4+teR5zqbf2Ysw6mpY+zMy12t1Y57OSGG5Vx0MKfCxJJfOxAh+GBzovenyQocl11ZBKmRRXS83fP7jLf9Mdl0pzLVTOuDy0vNzLsN6ujVCowzayINufvseCbeTgSUilxjC1kfgmMNedjgdJm6AIkR1PLHckIl6Ec1UnoY3GrCcPU0a1YKhDr41MSJUR23mXIPHW9a6edT5nWdpwxy/RgC5iNmuO2xUNzE3ad6Voi4zPWxRLzNj43rSXLS6Xs/2AOUsgoyWZ0QkzcNcCcvvpcTGnJ91htkRuAZybEBZnykzZpL62chf/IugFczDZDsETolzqygrkozvnXKq7cVL38g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wTuNbWBmI3EIdDCMVRJRt391lS4YweGBs2kDaSN5O8=;
 b=klmYe/ekH4QreuwV6eK+gG72qVlKEMV9s6TVmC8gdo3du29OJ55WZBqJ3bPpY1KieUlp6j424AZsQlDMPv6zG0zJ7a2Qxh0JJ+TMSPyAtzi1VxmuXMKM/lF4C9+yV8w+xFPyEJ0VNVUNEVQxqNRwq0sCqqwdOge430V5QZ/WikSp46iTuTqbJnpJOecvdCVVG4xAU6VqTvWE308lzw8+5ALWlEwpvjbwV8h/eaO0r1vfbYAxMhWHE9x0i3dgnXQfzGLHPVItm9hJlyzMsVgUjqXWw2WfVpQrYNXgNsA97eGStfZ3q3VcxXJvE0cBopOruV3ofw50DFIeYMgHsUoxNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by DB8PR02MB5947.eurprd02.prod.outlook.com (2603:10a6:10:115::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Mon, 23 Oct
 2023 19:22:46 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Mon, 23 Oct 2023
 19:22:46 +0000
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
Subject: [PATCH v3] vsock/virtio: initialize the_virtio_vsock before using VQs
Date:   Mon, 23 Oct 2023 22:22:07 +0300
Message-Id: <20231023192207.1804-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::32) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|DB8PR02MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: f7dffa99-34dc-45f0-436f-08dbd3fd701a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjhyTucnAScwiBcFQ+kB8HFxHkCCWChXCO/J5OwqzQKYvz7+xnilUcNGx5isHjAXtk4c4P1Q44nZGW5tWa1GHvtZUsGeGWsCxf1/RamQ5SqKRnh+wDhzUKr3r6TIO+9pQxVtTfZ/ulam1UNn9DzpWC+8hkAgL4lLuW9qY0jw/JcyRbheyzgphIVZcbAUF1ueTlIv5c5BoE2UDuj/RpcymknDuNLjJHFjw9OczxeRMI1LSA7l+cza1ayNUGIUTyqpz4nNquZ7sQ5SJrt6QQoaVmKLtFZcEn/9Sk4iAaqD8PSMD02pUfSpn6Ji233XWUSAGFBT1pAKaPWCNihQplBwGnYKZam1bcL9X4FZEyxovszSl5V3rxjEcv1BYJedUbQYarkMmjMhDR+hX0OYZ1GORjPyZ9pyi5jdaaiKEV7w1ZO4clgBPXWpqrfeml9+yXo5YTp2waKfjllLOkDw92XmoiyxegI4EJVG1vUAtQdn743q64iNYqJx4PG+IvtwwJ9k4g4K7BhyA3S8ifRCcjTqvMlLzXtH3Oe29WuDz1xC7yQ2dEW97YH7qZmXcSgocoxd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(26005)(38100700002)(2906002)(41300700001)(36756003)(44832011)(86362001)(5660300002)(7416002)(8676002)(8936002)(4326008)(2616005)(6506007)(478600001)(6666004)(107886003)(110136005)(1076003)(66946007)(66556008)(54906003)(66476007)(316002)(83380400001)(6486002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cG4QM/yF8eNJkXZMOojXq1sRz8WpORw/x42Qe4fuqtYuXLU/KU5KdKokKS1G?=
 =?us-ascii?Q?vSBSYMtw1RuO0vUg50ruolQ42g8qV5AmgiAMhELATomjWpwpodLbUsVElYzn?=
 =?us-ascii?Q?y9yYVQYrva+GkobLU9obCoNFsfnqPzMwXbXQAqVPKw1EQz5l4Anho3HJjhnZ?=
 =?us-ascii?Q?+22/LxAsxccSSY36I6y5ycltLL9ilv0EdV9K1nHjhk7xN5YBauqDy463NaUc?=
 =?us-ascii?Q?OQ2flaR4rMOp7tgxx/8kRy736RjWpb/kcC2tTB7Hi7EwbE5T+SBwymcVHV6G?=
 =?us-ascii?Q?GivMXfqed9Rd2SSfV2uEci6cAsg5N9puOcPrkBIY8h0EAxSlN2o5/3FJiAmu?=
 =?us-ascii?Q?bQysXs9hU9WUg6JxAjjaSb8NKLvsVF7Dh6wAdnxhgk1wRaEcQcn3jfVVxqSx?=
 =?us-ascii?Q?86ntZ6SD1Bd7CjRrp2+f8CbSct/qqa7I16NGaPkp218gIA351WCJMp4PV1ca?=
 =?us-ascii?Q?+bQvAyTHrrs+0uu7eLredRnvpw34Pdh2AnyKKo3EZwj+FJqi0C0r94s4SrIh?=
 =?us-ascii?Q?U+NLpIrXygc2mc8ocb7jL7dscHObTj8smwG+Z7bEQlblahSBl4/osDkjlPix?=
 =?us-ascii?Q?RYG62ixYJRQPf+CKeAdwjjUW4m9OiAmqN+Hje9vzrOATVH6gsz/ztxKUkOLn?=
 =?us-ascii?Q?+hYqU4ROJLo5xhpGxBazbCqjWeBNSBKbgRFbgJ/EPjQOgfkWurzIk77o7VpA?=
 =?us-ascii?Q?dJQDWKiTM0RCK9qBM5qbshzE9nLlbSbQhH7+58dK0C9Pj1idNdoXUqQmwZKx?=
 =?us-ascii?Q?H0k8mY/oFx6lY33BU8qU6AKjU6698xajppD7uQxNdndqRWUUZrzS+L4arl17?=
 =?us-ascii?Q?/HQmV6ybVRF9wxciINH0RSGJyO1JRlLCQSOMzQ+J1X3UEqF22lDZEcXXCSLK?=
 =?us-ascii?Q?Qua7fzASBxSpOyajiqeHTlg3DxBK8aOOaz7l1M7cJux2ETi6aobQW/mix/Zk?=
 =?us-ascii?Q?/oE2sbq25+xfPVzftTU9trczeI4kJWmoi5PxrSOPjMz/kvBBXeKbvQiUEyyn?=
 =?us-ascii?Q?vebbgdr0Sil7mnoD6D54d99Mafg8epSt7LfLnS6Z5DPpHpenxlkEwTHSyNvm?=
 =?us-ascii?Q?qrUdsHRAIkYgJOn6jV4J7rWQTKclv0f3JfXnMjJ19CyYE9RB8wGHwKBQxV4+?=
 =?us-ascii?Q?iGKKzuGXXWd+pFmJBEpcGfprGJ5P9C1S9PAjUdezilFfW/aXNYP1og/RDw0G?=
 =?us-ascii?Q?lt+eycW56Si0fW2otBUpC4Y72FWbs1/GTm9tUb3zam1GERG0BIvbLPnk/kw+?=
 =?us-ascii?Q?akXHoLTxeiTaJ90E6MgTxlMUAigi/5ZXj1nf7jSu/oW6vbxp3VJwB3G+0H+e?=
 =?us-ascii?Q?DYyy/DrN+5oA5q46r2xlUL0lMGmdUtm5dPM67LPIVx9OyCuAqiFvQxFP1+hj?=
 =?us-ascii?Q?QOa0ZONDNI+tcjePGb0k/8mNnuC8hs+/6esWiBhb7sxmPilzBJBa7yP/uvO1?=
 =?us-ascii?Q?EuTPzq9WXebdwwfD+lyjLSrG/6N+q1yVbTyFDJA3kLl7IugsupyrwxlMq7jy?=
 =?us-ascii?Q?l2RbAPMNqc1CCvtPqyybW01R/8ip5zrqw1JORHKZzoNS1KciAUTrieZm6APl?=
 =?us-ascii?Q?aOOKjzRyYgKDJV8SuN9pJ69TyS20MDYjYdXYh3n2qlRqXFONKgL+EsuVOHcQ?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7dffa99-34dc-45f0-436f-08dbd3fd701a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 19:22:46.5870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqwxDNakmtCHWeOv9C7rC+vGfhOwfScjSfuj+K1JSX3fD+5PZHFuuXamQ77VkUFSRFVwvFqMZpABHIZGttqk+IYaJAOu67u1zubZUFJDL7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR02MB5947
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once VQs are filled with empty buffers and we kick the host, it can send
connection requests. If the_virtio_vsock is not initialized before,
replies are silently dropped and do not reach the host.

virtio_transport_send_pkt() can queue packets once the_virtio_vsock is
set, but they won't be processed until vsock->tx_run is set to true. We
queue vsock->send_pkt_work when initialization finishes to send those
packets queued earlier.

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
v3:
- renamed vqs_fill to vqs_start and moved tx_run initialization to it
- queued send_pkt_work at the end of initialization to send packets queued earlier
v2: 
- split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved 
  the_virtio_vsock initialization after vqs_init

 net/vmw_vsock/virtio_transport.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..c0333f9a8002 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -555,6 +555,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 
 	virtio_device_ready(vdev);
 
+	return 0;
+}
+
+static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
+{
 	mutex_lock(&vsock->tx_lock);
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
@@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	virtio_vsock_event_fill(vsock);
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
-
-	return 0;
 }
 
 static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
@@ -664,6 +667,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_start(vsock);
+
+	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
@@ -736,6 +742,9 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_start(vsock);
+
+	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 
 out:
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.25.1

