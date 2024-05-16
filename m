Return-Path: <kvm+bounces-17518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 799988C721E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D0621C21391
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 07:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947E184D2C;
	Thu, 16 May 2024 07:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="M47PdHeQ"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2063.outbound.protection.outlook.com [40.107.6.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438B1E48A;
	Thu, 16 May 2024 07:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845055; cv=fail; b=MMaN6JlEh5kxH+Z9Uyd4tMkXFpunQyZMr0JhD6ai1RvkH8XiJPqfEj6cqY+fXU9dTSS8w14YhelP12Bq08mfO6sMjDH5JNqhP4igyFv//yRJgQus9hRjFk5QshIDi1rK6mIJSYp5sOPxhgg+4o/CoPZ2EpBfzN1gESStTK6rSQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845055; c=relaxed/simple;
	bh=/Et4y1Wa1lI9teH9+PbjnK5sQsFtjS7eia/RYFigoe0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Qe13DhQ83WU/oEq1jihJ609d5PBFuvOoknhdccH9uO/GkLXpeZhq/kFUOJXXEzlcv+NNti+yA7T8M2UfV+bnssBNYVsC1mkTmj/rYx65zE7PXm9VEoqkdaERRs12lHG8rQ3wJpN/n1s0O60w/q/wY1hFUOlYkg39G+Co3Ym5Tfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=M47PdHeQ; arc=fail smtp.client-ip=40.107.6.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmP86vyB/Vrf0yJmnwxpVTpPms7NhEij7II/zuPFWXq/1ElKfaIyCPDuK/m2dBWtN5kdg/9tMC0k0S2hvOpKgy/medGjOufHKKDrb/8Q9otSgCd1XR2i68C+mbYw/xPVMAQ8ZNGTkDkIMs2n4xIyAZcF2HpoWFW7wX2lPsVo6JZEZ8GzMjQJMWfBe8TkCG8WJFdNYJdT8IWCVenYvPcVcWiteUUZyQ8kM6qZK6IUAbMI/YdyRvGC5qKIX54dBGH/rutnHcKoLVRraoI8P1PzIQMtuGBaBf+7Nc3On4YWyIV92Eu57QP/zZmf1wc0kpMzaYW8mpU74WJKjrHP/TQSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzK6KCnL75iIeu/0keC44iFjDBrEbb/opc6DTStlLd0=;
 b=OyFxnfEfiUdG/YzUXTuyWyvL9weTsWbAulWo6UVwvab5TGKHCn5eNdtXvmEKbCpyq8X6tY5xSUwRBX/oK1ka0upLMJoZE1jFX98/6JjAJNGCRW5tJAAuJ3uOMRMQvS/VxKM30n1cZpDQ4Zr/N4eW7GIXwMsrYnalJF3Bpti1KtjbG69gHfUUICOr1bSmnFPA7sx46ar/ATuX17pSUOmY+vNHdcjLg2DOQVqwMXUSqlKFAxHsuJalCwvyIGZ/+0cJaOGIyJPRVJmhbUWTyK9B6bN+QkJee7YHgfPrimGUNoAopuozHHEcYjTQEGUvD1Jxkhs4WAkIaXKZc7XaQGfEew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzK6KCnL75iIeu/0keC44iFjDBrEbb/opc6DTStlLd0=;
 b=M47PdHeQrgcSSfpObRoTxTYgsEyWZ9Coov+rWVOqAv4nH1Bry2Pac80mkHJOrC0TSbMLaVBBqpYzzokrh6o1Eu+Apm8In7Qt8ON/i7MrIS6IXoyOeNH5zAgQrxHvluz2mxQwoTiRDLs4WqTOdGz67Un+two18GZn5LlCnAcub/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by PAXPR04MB8813.eurprd04.prod.outlook.com (2603:10a6:102:20c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 07:37:30 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::557f:6fcf:a5a7:981c]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::557f:6fcf:a5a7:981c%6]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 07:37:30 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	eperezma@redhat.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH] vhost: use pr_err for vq_err
Date: Thu, 16 May 2024 15:46:29 +0800
Message-Id: <20240516074629.1785921-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::22)
 To DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|PAXPR04MB8813:EE_
X-MS-Office365-Filtering-Correlation-Id: 18584296-1a3f-4e0d-dbf6-08dc757b0aaf
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v6zCA4rj6yahO8JXGmcdfw7AnzGvxfvcFWxkbOg3WjtRwf1RlswjKO/5cSPi?=
 =?us-ascii?Q?xvj2lN0w8aM3cbraz8H5pJwARvmFirJPz0llzzih/Lm4dHGq93y7QHm8pzMr?=
 =?us-ascii?Q?JQUUDavLjKzE8dd58GzxeT4oNQn5w26clHBXQTTQkA71KBglU0jvP+nV0/50?=
 =?us-ascii?Q?NAQ+MZ7Cbm3bQ6InJASYQ1UK7dvGLrv2Z1AqfDM1on7gMVlBcp3YIDf3c11b?=
 =?us-ascii?Q?ZzYnv6gpBrcx9FEfK+JbZjRnzE48bHQY/Le9jv4lrYU19GdZ43AXKXC20P6W?=
 =?us-ascii?Q?vUX51Ds4AqSbwB2YlmsvRKRbGfKNXKEoiW7VQD1qCZ8NiY20afvFb8qaie+i?=
 =?us-ascii?Q?v63tHKuwv6I92o+BUp52J32SLYDh6qymtfwamIcZEwqP/i6nYgi8Wr5DXCjB?=
 =?us-ascii?Q?bgNqYu/xAyEPDkG/p35coNibgj1HYn3YRBk9yb2op/JSZF+pGPwpfl8z3hVu?=
 =?us-ascii?Q?lSnUCIhTgDrKfni2fVXn8w+t5lEXOYIW5wyU/KZwplbca/BcIPi5GwJCUdCV?=
 =?us-ascii?Q?FwwGyiPtXzdyG3Av3sIlFpNyIaWegrMN4gs9fNG22/BfS0va4YTVlfgazg+6?=
 =?us-ascii?Q?5Sky3B8+KXNkBp5JAI8pcZYaN4x6bUnGPTa7RbgntIke/vIN8xcTrp+8qPYF?=
 =?us-ascii?Q?9cVR+QRJx0MwOcuI/sVaNnz9kWFbnTvaRMRcEeRbqFJ32cujNfs2P76+slYF?=
 =?us-ascii?Q?q7syU308J16gmRIXPKl8j94X8prhFGlcOh+30wVF7mk+mk174FPECxogktHV?=
 =?us-ascii?Q?UUDgCzB1tzGAo8TdAmStqF8HGsiZce3vnjKKhtafXWukV3hADzAxdFIZ6h+5?=
 =?us-ascii?Q?2PC4vvab054mDJ0flzc+/H1bb7ZAzQxT6mUd9miwXaaP/LV4qZZ1Nc4b/HAt?=
 =?us-ascii?Q?aU3lScZd2yarWZiYYzLVdW4KWy6mgmqOo08BCFvhjzERC7GaGs1FyI8Efcu8?=
 =?us-ascii?Q?1aAvGEEMymnvQlHUS4z1YQzkaHjrg8EXhHBYoXPLrGoq1lvMBKxuFiBggS+J?=
 =?us-ascii?Q?hDIhpK0PgSFaoietXqVVSaTDv+994TLa847uxAXREwRW669n8wAkvUwbkcnX?=
 =?us-ascii?Q?aQrcsoJbu6lAk7U2LfW7J2isFovdMFHFZtRjLfHhnQYQKP2ae+7IPV//Kbi9?=
 =?us-ascii?Q?Fud3OvC4gGx7w1gObgT3mGZuOXLWbmUFeXCJHo6C4gSqkulx21TwZpk2E3yd?=
 =?us-ascii?Q?KooUB7Wleg5cQhR6PvxTCA5vRRbV8yqCkBaLMd0BgXMqrqeTDMpy73LAUZ4+?=
 =?us-ascii?Q?zOrVZ+c7EHlKY8NjmT7/W252oieknwlytLH5UcZ3Sp4yW6Draqcv/2TwgZFM?=
 =?us-ascii?Q?OIx+ty61zTng3QbZ2JCR/s+aLTBcy25quJ9Jiloe6DZODw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tJqt41nC2OHqTwT9xJEWpfBVt8rLRlEPIkhydc2lxTGDqeyLsLVL6bMx541u?=
 =?us-ascii?Q?h/4KQgLyCp7h8Eke/lGai3oxSwfaw5MfzuDQBlmdG9NDIbLnIfEug3XVNViN?=
 =?us-ascii?Q?A9Wi0du7FQaRLiZNL1jSZ/FQYf3t1a4Z0wS84vrueTSOLkSReOWapwcNRyHB?=
 =?us-ascii?Q?Pncx9FzjzY8u1GVZdp1RJQ1wPnYaKaUkz/aMIfpkq9Nv1e+EhixkQczWHVLT?=
 =?us-ascii?Q?RKJ/ZOVqcAZWnX46G/l5ZQErUn5AfJCGw0F9rWGP2WBWeKeoNXQ2URLv/Haq?=
 =?us-ascii?Q?QOgDGLwGgK3PRsTcn/vpj1/eOJFt9Qgs1KZqVNzXu2KeYCurAe0Ljn4Nesuo?=
 =?us-ascii?Q?uoJWHz68VNIrGPhhVWuZtcjx1Ou7p2v+UEBk1CqfyvPIkXnGRfeD++4+nxNm?=
 =?us-ascii?Q?PBcWtGg5wXngw+xZFayNyvbxKlbMhuyl6bWi2K/LU2VSF0ol8qtqa8Jbqk2g?=
 =?us-ascii?Q?OaCf2/I4Bf8qHAlwqDiNCARyBdzxueX1WfffNORFVudAs2XhXiqV/8Crkumm?=
 =?us-ascii?Q?1na/XvUJxNr9OHas5iWyfivvFHrkHQ9wR6yS3zRmFyAhkaOoxxi7Rd6DYTN6?=
 =?us-ascii?Q?fZ38mVRVIZAnO0GWqvVIwQegx/Zc0aizDMHlsHgXYBqjy0/7Gq5Vd6PiD2wh?=
 =?us-ascii?Q?qyzXQLMt8FT/LkH+gxGQ2dK1/hq3bbfK41KxM/kyBPEMqMD8Qg1J7ay6+lI3?=
 =?us-ascii?Q?zMZe0yQUSJLroEmKKgfMfHZeHnKdt4lfXm/cd+iz9+LcXKpl84IAcQu170lH?=
 =?us-ascii?Q?Clk1icZ4YEPXwibUIpmGBBzlA3Hn7oFV7df4CKdasC49YTitPS+c4+sB520I?=
 =?us-ascii?Q?m9Pa5QUJPWl6OMVKxh6ypc7yvCSdQPhpt/A1j2X2qV5NrTUbySz4GDHrzNXa?=
 =?us-ascii?Q?r36rQRic3hiQTS6ZoN3ypXhCAv8j911/EWS4zBKkgDTnM3nZd2ymsvi+jhun?=
 =?us-ascii?Q?zAbmg4LvSfHOBYpR5IYHrbt9PKM4AQTsG8GnkOkzxUfuGtHOjwBe/KJXQOhj?=
 =?us-ascii?Q?sEsr5HlMN8Lz2WvgoazvEHiMEKjcCB6y7ymX6lrHGvTsPvvWqb+uKeuKrdxi?=
 =?us-ascii?Q?DYiMwbnYBDefjOz3WaP/3KktLyclUfR6n80MQGIgfAerx8pzcyHMWJzLflA3?=
 =?us-ascii?Q?hJAipCVl9a1UfYdvEelhOvuv9eV6U42VH6gpg5MR309C9/R6NPy74+B5A5QI?=
 =?us-ascii?Q?idDrOmhwxAMi5LiAhfitzM9c16/YciqvVsIy9mHQ0Cd3b2qB5+wg0thaEs/X?=
 =?us-ascii?Q?PfSslcrJnZMrxVyXTksF1Z7Az/9mYikX8MdaMYnYb7deQDEbniUaCEMmpQUX?=
 =?us-ascii?Q?B7fFubYIaY5WL7iYABoRlU1mtiWNG3yIcS13Qvbzx3o7+qedqGQgPMEhp9hp?=
 =?us-ascii?Q?0zWD4vu1IQkEqBJwOxpJcqd5o/HSaFXcw9n9dFo2WIgKYEtiIY0JcY3fsmEa?=
 =?us-ascii?Q?uSJH7P9E8mIfcAl0hjDfcKTQB8OJNVgLiTY6RSf9FZyC6Gm2tZ1BMP/M43xW?=
 =?us-ascii?Q?gWCOG183tvmguoXnkE9SI92e0UKS9I/bS918Zpn2aSJtgGtnW702wgUbKV1F?=
 =?us-ascii?Q?WV24apsxFNAC6XYfPEtLvi2t5m4dICYqQ23dwrCH?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18584296-1a3f-4e0d-dbf6-08dc757b0aaf
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 07:37:30.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cu0m9vC+1gMxccMSkDMYITlC+Zk1fpnvFYuNkfPG1U4DuC553au9GCqIi9s3TK5Np4mLTN29Hob8yAjZ53+n/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8813

From: Peng Fan <peng.fan@nxp.com>

Use pr_err to print out error message without enabling DEBUG. This could
make people catch error easier.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/vhost/vhost.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index bb75a292d50c..0bff436d1ce9 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -248,7 +248,7 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 			  struct vhost_iotlb_map *map);
 
 #define vq_err(vq, fmt, ...) do {                                  \
-		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
+		pr_err(pr_fmt(fmt), ##__VA_ARGS__);       \
 		if ((vq)->error_ctx)                               \
 				eventfd_signal((vq)->error_ctx);\
 	} while (0)
-- 
2.37.1


