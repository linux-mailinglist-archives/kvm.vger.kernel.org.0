Return-Path: <kvm+bounces-54258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEF6B1DA65
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 16:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14BD8620A27
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 14:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C67E265623;
	Thu,  7 Aug 2025 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="iO/kwSzU"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012046.outbound.protection.outlook.com [40.107.75.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CACF1C860A;
	Thu,  7 Aug 2025 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754578199; cv=fail; b=JE78uXaGrhNMMloZ+qiWxTbnO+vo92/qDYA8cGQV5wZcHImjlkeU/g792RK2iIGa5B/aFQVGSsbzhG38D3/O3DTlY6fRE6obXlT4UdUBKgCI5NxAA+T8koBXc2/YRNIhDS13GLmzoPcFpr9WA9GFDFklu+dVH4V6FMxna9sDNeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754578199; c=relaxed/simple;
	bh=g8zdTMWXRkDJrgs6R/EdGnF371XIYiEKm9k03LmQn70=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=pcg6Dr2dXQ+QOKQ4Qmdbz3cHePLJCXm1SwF7B6XDx2iqdEHRF9Z+gnn/jQVgDV/2qZTYaBvez4P9xwKpdGL2u6tEinBqt83tHQXI9Q9cvvu/BiSFsfvLfYFAq+iju8Q944Zj00+/Fpp3QpEjzxeTTgG+qsc1oPAcfLt2JTFBTJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=iO/kwSzU; arc=fail smtp.client-ip=40.107.75.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDyV0F1q57NqocZfBDPmsC7pulKz9UR7PF7+IL1MYRO1vlNoUEor4Qm6kUy22F0U8YhblJjpk5A76joXRDrUP0ZnhMrQt3++f9jheZOmcCe7JrOKn4ojBNX/Uo9TR9XSJ0Hc/+9ckj7Acf3UwW6KF1cZQ5vQ4cSXuWOYWSHVIe2ouG5r6wtSb6MCSKTBJLa3yUpTF2V60OFzqOaHDzb5cJKCCXBdoVnnFBmioqjWFw/zQZ9oJ+uuUbVoyJV1V/pxh7a2JpEUmZEQ+YrELZqFr/AMwMR69+Tbj9ytKWtXgfUfD191PcrX+qu4StReJrI+eGXXs4QrnSJEWe6V//Zr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDqMEaYl5i1x+hIBhDVQZBfDX/FquV3o1NGuhYkmhlw=;
 b=k+80YO2GdPxPqUV3B+C1y7QbMRXmBP6zCV5fQKMdrZ6LbelYXmDoH5RuCPtEkzjgKeA0vJ19XPwZ2uvDyqn1a5SC8zLIgF+uPN3LZmbX8l5/U+Jq7Mwux985XHXWMEQX9lKFFJg/XJ14sbmlnCsFyMsktUwWK7kCSsOw6PAJdoly1x1MA7xw+cXwh8eK+G4Fqd8dGU2b+Owi5kz0LqmdIyULfsj6dm5dfGKS9aCLwYdsjAN6im1Ta88eH2MKIDh1Qd0dwPLsPrY2/RjCgWjHdhFLTiIP/oPSl8LupJ67AC4r2pTv1RIaAG2Tyep5BF7OeWkzqswlXnKh8TkS7OWZBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDqMEaYl5i1x+hIBhDVQZBfDX/FquV3o1NGuhYkmhlw=;
 b=iO/kwSzU3P3nhUBYNKzhF6K7jPzciSbhH02uZtJCppydeHQCeYpZhthoFf/Pge8aViNBjj2u0cq82q3GrmTZNnYP/h4/P5Ny+CaoY6B+gpyh5y4vSHaDFxm8soZDazt98BEeYMqPA9Pjbvv4Z1Cx/ALAZvuq6Gp6xShC+Wdnn5iiuOmYChXZCzL63XDgVIX5L0AiExalkwAA/ORHsHAMR0X/yeBP+SBdktPSRRNt7VBkH/ENaQUflLslYJhwD7Jcn+mHlyjofHxdRTDMWqS/9AVhTW4lkkqTotkDBLzHu20jjAc6OU6v+jDEQIUuFXcDPOwWRlP4VqHZJsG0otC9kA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SI2PR06MB5092.apcprd06.prod.outlook.com (2603:1096:4:1ab::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.15; Thu, 7 Aug 2025 14:49:54 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 14:49:54 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: willy@infradead.org,
	Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] KVM: remove redundant __GFP_NOWARN
Date: Thu,  7 Aug 2025 22:49:43 +0800
Message-Id: <20250807144943.581663-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0157.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::12) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SI2PR06MB5092:EE_
X-MS-Office365-Filtering-Correlation-Id: b91d7952-6820-4dcc-1f08-08ddd5c1ab90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kFdsaDijVbao1Q2LLGUOg8OucI2wSNJgJq8K/SYx/gRxZy7t02WqPSn9Fb7z?=
 =?us-ascii?Q?GIFW6SQmxXSF0jmaa15RTBGQg95XVbaBnf3RuoJaOvCzM94MzL9ypJz+nJFJ?=
 =?us-ascii?Q?J9W5fWL/4l+2LtuoUkYDLWMXRta0hNgZxZYsHvgqk9sqaJWSmDFgoOLKlMB4?=
 =?us-ascii?Q?A7QRjouInkHE9U6XOXYrfEMPWXg67tcgUALwvGTzVanGpaG4BF53HmDwlYTu?=
 =?us-ascii?Q?KG9VdZ/9hTbheQIqI6mzOmwREzFpm3h1GVZOXwgwkiS/Z8ZVZ2IBZsTI6yEy?=
 =?us-ascii?Q?EMzCBFLJZEUA/HXDgfW19EbstCyZXuf9wHcjYjpow3zXf9NgYAuTubJ7p8hd?=
 =?us-ascii?Q?eV16ouYH1//MWrx5MH72Z59vygMLSb3mSr+WA89ak08T3BBUKHS+1hsHS3oz?=
 =?us-ascii?Q?AILlqLE2iP5HpGO6iGMjDUcospz4KAkli1+mQ2GyTAENDgjCpXzAu06FM06D?=
 =?us-ascii?Q?gMPVU8IuSOhTfgKU4mUaG5EqvIv0/lk8UG9taN+p3QOVUjYTJo89ML/X/8Wp?=
 =?us-ascii?Q?yVXpJNDeAaypY6sA12X0UUjP5U1ZXvH+DFUYR850xgCHB0enqjPeb6NN0wnC?=
 =?us-ascii?Q?hQrNgOogqIWvcOmRR4ew43ZS4R2+Uh+yygdWNs1nCgfkmWX0aOxoILra5pfn?=
 =?us-ascii?Q?gWg1ky7tWiGdcceaoktc6AW1WmrdwiItrrqrS/7p9FJHNiKLkeqSnVV/hA4x?=
 =?us-ascii?Q?PMW0Eq7Gxg68zwDeKQz5ERcFEsutO1srULruQKqIFmhDrpIGl+l31/Hb9tj0?=
 =?us-ascii?Q?kXx7KaPFADeRnk2iVpVkVupNJli9rsrj4i9DGoVIb9q+Lbip+L79QmQvwPAL?=
 =?us-ascii?Q?dAmE0lGq4G/pnFLa+t0GIFI+T2z9bOOgOegykooxFPdfBBS08bm/zTrYQIWF?=
 =?us-ascii?Q?I2ake2fc5X6iXEOsCJsBae6PKFoiyp/Qlwjp+yjm3Cdqqp1Y+kRwSpPs55va?=
 =?us-ascii?Q?wTPY2MXfkikf6qhrNh1jk12PuFRXz1rEL6acxgT7dXz165A1w7sJ1fxTocln?=
 =?us-ascii?Q?FZxLuFy5c3vfJUh/LtkCbjq6eZmBpl6pp4XqQ124nkVLX4NuTGxW5qA17rqG?=
 =?us-ascii?Q?YR4kP40Zu5WFVjPiH6AnV4WVibPLtxZxN+Qz7aGFummCMz191nwMAyCdOa9A?=
 =?us-ascii?Q?+ptKBOSTKNCYxIVBVvnHD8f+kV9JyRT15NtT1dvL21jL/+SpFUPFVGXrqDLy?=
 =?us-ascii?Q?RNseJXfKsnEbxpZYHtSmWWNj5zDzYW7RlbCqAC29+m5zc0ODJdl3L47orFWd?=
 =?us-ascii?Q?CIAQQvP85LJbk9zpkGz9nb4SrotV1hlvCTII+zzPlZL0BYf4DD8PgVC+cNVA?=
 =?us-ascii?Q?NulRfoaE1wKwGPlenGca7iD2JB87Mt2Yw0L6T7EDTYPXNYU/HALjTG6/BlLa?=
 =?us-ascii?Q?hDZGYvJTCtNNlxM0nmxbY6aJQkdG0B1SJjxEqfAoOekhyD5ujcTYgWrGTfpX?=
 =?us-ascii?Q?hbmqL1nO8NyJJ7E/qq6r3QyLVh8ASMtNBtpnoha6x04yHTZGw0CHkw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+vJlj113iIhMtzHF1DEMMqVymeVN9lJTHJqC8zu1sz5NEEBC2fviOJCABBK4?=
 =?us-ascii?Q?H9+3Tagsk6CBeZdkF1KDyw5CIQU80yoVgNBvnLdDrQ5dgXCx//sUbEnNdGkE?=
 =?us-ascii?Q?/8U58aps29S6VNJ9ESQTwPRKYu2ys0Yw3uzFMKJTuuzQQbIXBs0mM19OVeWb?=
 =?us-ascii?Q?ZgKskoBlmrMS9snLGTUmRaLRNSJMX0cp2AcgQl8rmNMcjC5mHGwlkne/cQXD?=
 =?us-ascii?Q?GFlfOjNXNzf7uuaUPNaWXUmIY6kwoXDtVnjYxDco66NE2JHW+Sjoay8LetiE?=
 =?us-ascii?Q?9AziEMh7M14BUYqXyyc7TaCGUF5PeqQzBswNGBcvEsscvE5EWCunIleL9tfk?=
 =?us-ascii?Q?fg3GpR2kU6CfkNrPdxbiiGqX+qAtvPx52hBtgdvcbRpjAInJycs/qtE48AFw?=
 =?us-ascii?Q?xUXr9BXHSMxRfuBCxW/E4aJc1a989K/00yfh64qzfmt/1WGFdmKMnQ2AB5aH?=
 =?us-ascii?Q?SVzsfDB3EIyc2gdiLg2D47cvZUs8HHKkjzETNoxHLVbkG4huwQQwlTErgcV5?=
 =?us-ascii?Q?Q0AXu2K0hDX0QoMdL1RbeoHLkHgdwtr8lJ7rRlDITizPaAWqKQwbH5t8tatf?=
 =?us-ascii?Q?sPdhvsVb4rVmQtZwoquQYScLtjwOinTcKutn7bOxW1k56bqu7HegDXllGqZi?=
 =?us-ascii?Q?1GG1LJE0uJPs+LJqLMYelzX5pRjKIPgk+CK5D/N7r6NQHyFXF/LVAQHH45JR?=
 =?us-ascii?Q?FIoXa7ww0bupFmeBYiUNJ7jXExBXi5R9TQ2RCgcgz7CpFr6SJVmvOX9LlxCU?=
 =?us-ascii?Q?2GxxX9n5pEImaglzRdE5d/sgARcHPjFcSuKN7pQuk11nABhEL7sOm9SjjYl3?=
 =?us-ascii?Q?sNeZPcoITklkbJl6YWhbDExBDPt/o5rHtvd1z6Lk9PUQXx6iIPwy1RjLIEtg?=
 =?us-ascii?Q?RKAVXvyLfw3w6UnuEcaxHk0OTRcAHH6H6UdoFGTB5tXksWJJlADigFkid7S9?=
 =?us-ascii?Q?HxI11++BJo0wBzqML07dc4D4i5bB0T8gp5rgOS7bGI1FykeJTAOAgabzWzy7?=
 =?us-ascii?Q?Ys6BvNny/Z/5vuCFyyCEp3sqfvZb3xmb9G25eD+/cxOx0OSbdrHzJ24T9DGW?=
 =?us-ascii?Q?eWk+YPHKy1w9JG9UV1OTff611NAKLI4jxdLiG/sAhbSeNuAqO/43iOpU+W1D?=
 =?us-ascii?Q?yqFBLFfDoRHdYdcRFV2zTYaY8d3baeesXTqCGXfRywFUBxif9EZIITmaojMP?=
 =?us-ascii?Q?2VZRlXvSP+Ek92Mv1p7MIqpIGC7vtrLFyiDvH9gPNp5X2SeJ84wrLc+IMtbJ?=
 =?us-ascii?Q?ArVhX+GyAoyyW8EiXEABxoLZDpCBY6L854PNA66iKBI7LVTUQDi2TsDCA+ju?=
 =?us-ascii?Q?GS6hofNIA78YYhWjiMgAFPybn7by3q1IOkCZvRjF/jgjgkal5cFEuyzzsjSv?=
 =?us-ascii?Q?nX1Kjf/k2sUkpUWu9KfeeH0ATm6Jhvzk0XYOTSOKPcCtIpPOmYVXIO0ZeeDh?=
 =?us-ascii?Q?fgrB9ND3kk64aAGx8YqAtt6InrvV+NwZeMeP5e3HZ1sAOjC5uD5UWuTibe8Z?=
 =?us-ascii?Q?3ILg0tvtDMRtWUSodELeU+ITtFNNq0t841QqhtWjF8jBlqcQOsIDISze82tO?=
 =?us-ascii?Q?wAHfppKlOhFa/VpMEbCfYB0sKhl1mSUfYCV2AQXf?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b91d7952-6820-4dcc-1f08-08ddd5c1ab90
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 14:49:54.4796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3WfQXpI9vlH/RMAzSt3xwpcg7p5ILYjpSyTSEGE87kK3liibmlwjKQdy8kn+l9xbTI0X552lGTS3d9BU5ey9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5092

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 virt/kvm/async_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 0ee4816b079a..b8aaa96b799b 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -192,7 +192,7 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * do alloc nowait since if we are going to sleep anyway we
 	 * may as well sleep faulting in page
 	 */
-	work = kmem_cache_zalloc(async_pf_cache, GFP_NOWAIT | __GFP_NOWARN);
+	work = kmem_cache_zalloc(async_pf_cache, GFP_NOWAIT);
 	if (!work)
 		return false;
 
-- 
2.34.1


