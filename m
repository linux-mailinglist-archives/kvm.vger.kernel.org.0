Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E567D38FA
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjJWOJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjJWOJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:09:14 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2124.outbound.protection.outlook.com [40.107.22.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9226510A;
        Mon, 23 Oct 2023 07:09:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jajC9af9+x4G1dM3v6LqoylyaTdPtSLnIVIWKtQX9qegF/t5IWh+WUoCVlVYc9+fw3apeqvKPUonG3r7qejmL87HTgk1z3QeZpvpLh0LKT8/1NotnMUEwaC8pjW8v87uY5PxI6tcaxJTiU9CtI5TX7MDPORaNxq6DeRfrh8CJWABTa7mdPm7NCAG37uV/OfPRlKQZBTXCUoDpYpDEGGOiBb/tdf7cN2Lo+Zb5GE7t5uqXONo4/LTFZpRoVvvW/g1TIn3Z7hi2j4lS0BBF/cgEKCKzK4oqxsu504klZiPuDvlA7+BIXSxhdZv527lfCT1m24Tk3l0MYHZieJt5jzWxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPy20JUzJmAqURehU9yZUzWGAlc5qSnzfcAwkqFbJrc=;
 b=EuTpveatREcnw/h++QxGPmSz0jDbT+8ldKZQVVpA+J4SeN4qQXu0gkU8S6JCQ+vnMzkecGKErLGf/tk3/QNYzDxa4SKRNHGeAD2gdGMzhs0CBOd9ZUZA4SI9uqLG4iqhsaT4WyiqYrl9qqG3HjvoykBptOB+f4TED7L+OZ0tCYv41rGAgA6Baob+aF7zwx8gc7uLPAjYP0rMlcG7nTKGqX+Nv38BawEiBFNg74GmImCwtFnnQQ0fXY93g1uQOhjaYv0v80TZ3fCvkqIa9y9WC7KN6sYli97HnTKUdH0OpmVvGkVYTuRKCeqqf9hkmAv0oVFLhNeKutfuoBJmL4emTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPy20JUzJmAqURehU9yZUzWGAlc5qSnzfcAwkqFbJrc=;
 b=FD+PfklAv54eNmkDFmqmcQf0cuNs+5SSPFryA3UnrmRjpB8E2UX4C7Y51M6nSaNYmKDk3kHCIkcHcZmA8iohCRobdIDuAizZ4iexKc/rbvglKnB0oMtQ0P9m8qpOjU8Cayit0FulBjCGCi+pJv6WL+dKzdiv5VjLQUMBfhd/bUZFryOrUZ2C3yT1Wre0XpX+aSnZeIfuUAhzpNSbrrTm7ZwPKpg2BIIHG9XD25kgivIlVwCvssIQJp1BvZP29WDXe59ofbwpecr4v6toA3ClSQLCBPuQqXFYCnsHtf++UWGS0NL9wDrrCcm6BUe+LjNJmd14c00BnVJWCsxUrWLrwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PR3PR02MB6460.eurprd02.prod.outlook.com (2603:10a6:102:5e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Mon, 23 Oct
 2023 14:09:10 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Mon, 23 Oct 2023
 14:09:09 +0000
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
Subject: [PATCH v2] vsock/virtio: initialize the_virtio_vsock before using VQs
Date:   Mon, 23 Oct 2023 17:08:33 +0300
Message-Id: <20231023140833.11206-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0094.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::35) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PR3PR02MB6460:EE_
X-MS-Office365-Filtering-Correlation-Id: d1965bbc-2952-425b-4e2c-08dbd3d1a082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iy/P+5oVl+OcTIB84VMDxy65B2SMGUmSqCcrg782iR927F9z+uMiXU8KCI/PlT4p9fDIIS1xLZbdW5g6ITdM/cuo/Gt+Hd2i/wLwkj+9f/oR03AU0AZdPLFGGT7d4WaqAML3kQOFCMeulGsiKEi/YMl1989dQOOu8QMrx2nDLjHU1La1G5OXg0aaWILUd8Pcrx+ScLfOUjU8W1NVJEQmCy8Q205DgfUop4bZQaP9nu+KIEe/VKxJLqrTxyeR4MJkEITq4Tx6Los+84HOjaGUC+6WcIXinA7Pdm5kBBnePfD9Y0mfQs5taiREMpwbQ01cywVxuTao+4BZBJEJo0F7tUdAoGox5MsdIFv+31KNqhC8AvURTnJFjZdeDo/BduFIFlvMtuaG93rstNYWl1SBjZhT8HygDuy6RIO5r+UW3VNJ5ipSOmZhITNY8Cg9KvOjPkBNF4nTnE1cKffgrcLv5qqrDs+Dr/dmF7lDnI1xA+ExBSnoSfajLufi3ocs68OW6QStzdMHHDuJR93+axJ4HxjUyfGDldJZxT2JoH3Dy7pSBBzLpG3Rtn9JGIeU5tEm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(376002)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(2906002)(38100700002)(44832011)(66556008)(316002)(66946007)(6666004)(54906003)(66476007)(2616005)(110136005)(107886003)(1076003)(6506007)(478600001)(6486002)(6512007)(83380400001)(4326008)(41300700001)(86362001)(36756003)(7416002)(5660300002)(8936002)(8676002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jCNMNN38FvmV9z5y+ztUsw9ecYa1hSo+zgwyvZR/J8X0ilsBtRFqxCR6Njka?=
 =?us-ascii?Q?Kgkqmf8R1BAel6o9qVeJPignnpTByko2NeSQX3IHxFSoupZHTsB9fR0SDY4Q?=
 =?us-ascii?Q?75rbFIv20xwfB4xdHRU86rbDmi5Di43meYrfANOiEKdq7TKAUbFsn8DwIFxC?=
 =?us-ascii?Q?57Gcd1tyhacf/ihvN7UvjD1usINFbKZ7Ak8rrT187FzTB0DSojpjsPjl4yYV?=
 =?us-ascii?Q?sJ1m20byiM6ByT3zkYAy7ZRJUZCnBzvThGP7TGCd95utqje6mEc9kAiBCN5r?=
 =?us-ascii?Q?S1/qJ5dBOqdqNdCy+JfvusBdkiTMpQkAgbkuRPjzlHqC1HV9GhkmSM4J0KIx?=
 =?us-ascii?Q?m+yfhVE1pk2wbL8NG8Es5p9Cm8GVyuFqH1Kbmjj943NZwSuYeEEgrLN8uWHh?=
 =?us-ascii?Q?2+7la99BWmmWYmaJRd5epT4eIWU2B49b+xQPCUtOsDiBjPwJW6KcB/T4cvdg?=
 =?us-ascii?Q?r01IE8cKNBKNHHkyuH9m827BuB37Nq+MYA+j2SAEP17OhLY4hHjuWptdCHLV?=
 =?us-ascii?Q?WPfKgNFsYGkFh0OZjhXaKbFwSghNLjdKdezM21G9wSdj3PZpkO6fRSlUYoa5?=
 =?us-ascii?Q?QjY3b8JWTpEZAZcTh4Y9u8+ib/IbTLGKyX8s5wbZDoECohCDp2A5mt9f2jES?=
 =?us-ascii?Q?uhWIh5daR63lCR1RnOqv9X0lMxpT/roSpdGSxrHNJLfNCusDU4V4HGjIYJHm?=
 =?us-ascii?Q?zEqR+NzAKbkLR/pR/inQB5cJLJmMfek38uXfR6zEAkay0pDLcN/BDaqaIL23?=
 =?us-ascii?Q?RaGB5hu6/L9BCklwGKcimfvxPCFIne391RWVMJCeewkutGOe8YOfjgbkRSTV?=
 =?us-ascii?Q?37TfnzzUkVajV2D4vjnd7drxvqIXesFRtWbtVI5CgRzbxdWt1RN8zPZA2ayg?=
 =?us-ascii?Q?wLndfEIPLi+hTr39Pv3LGtaAH3WWNRNICI/WYvB/o5Dk6i1yw970LbnB2ll1?=
 =?us-ascii?Q?BfQ+r/cWe53QPDy8Xe6aZ7ZheIyeaBGKKCYO4zCkFLET088BqKWPWw2AQWpP?=
 =?us-ascii?Q?9XI3EBwGNUNlgeIDKjxgCxRxDwVY2kotIHudAdrWOBO0Mpf0zFxND+AyzSmW?=
 =?us-ascii?Q?HbhiCWxQVyaBQ94hO0pvDjKvRW24n5fTTXTYb3sx8E3xpV6LAPM1yMHNYOX3?=
 =?us-ascii?Q?2Aga0oL2AolLa5+LinC7iaNLqhJBL6GSJlQLN56sYt9DbVBhzngT5Tb9D1Ir?=
 =?us-ascii?Q?C8l4D94D67Mxf01Z/jTVan/ZlRD5jxTNLZDCMQgSD01hFbUxkK0c0GW3fKhl?=
 =?us-ascii?Q?mB8nMiBlnnEM/u6Pi8bQ6etWrdb5frPMfYtGxHF0MWPNeWkrMrRpFGsqJ8qb?=
 =?us-ascii?Q?40onkB10tdsOTXKKrIYzd8eZMbG7f0y+DgLBVtf/WN4REmahDhLTqjj0gF/w?=
 =?us-ascii?Q?XaHmoDcO+nTFWFZH10TQ51GaWdYKMo4OtI82u3IU2y83sXnaSV/bU5mNrfuU?=
 =?us-ascii?Q?tpZJ6g684SYdlIpWJ+KiRI4tEpXEWtnAPgp1qGnPJ6KKSrop5BCapC6PD4IV?=
 =?us-ascii?Q?dr1qz4tZh0z1f7P5/w6mAIW6tgKalYVBl7OOMiURWyCcILejGRb2u5X4PNSD?=
 =?us-ascii?Q?ecRlzY+efcwLdapcsAoYdIwc/6YLWBsYUXgwT/SqH+NSPHny/lfdVvyEQNsS?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1965bbc-2952-425b-4e2c-08dbd3d1a082
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 14:09:09.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mY6Lx/KB8kGkclcjp4rheoAqTTEiQBj/mEBH85sVqc+DeIxtWK9CSwQEtxAF+TNklZKHo38Nw2oFhsz5Q/nbfgwfW+uqKvfVIle3rTaOt3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR02MB6460
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once VQs are filled with empty buffers and we kick the host,
it can send connection requests.  If 'the_virtio_vsock' is not
initialized before, replies are silently dropped and do not reach the host.

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
v2: 
- split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved 
  the_virtio_vsock initialization after vqs_init

 net/vmw_vsock/virtio_transport.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..92738d1697c1 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -559,6 +559,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
 
+	return 0;
+}
+
+static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)
+{
 	mutex_lock(&vsock->rx_lock);
 	virtio_vsock_rx_fill(vsock);
 	vsock->rx_run = true;
@@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	virtio_vsock_event_fill(vsock);
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
-
-	return 0;
 }
 
 static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
@@ -664,6 +667,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_fill(vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
@@ -736,6 +740,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_fill(vsock);
 
 out:
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.34.1

