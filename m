Return-Path: <kvm+bounces-54876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5D4B29CC3
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 10:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C6EC7A547E
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C9730498E;
	Mon, 18 Aug 2025 08:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="eVfm2EwZ"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012027.outbound.protection.outlook.com [40.107.75.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1FC3009C8;
	Mon, 18 Aug 2025 08:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755507141; cv=fail; b=EG9Pz/zPI/h08DX6tpgxJroysn8W51bu2GyS3WWhtORjwtGkaM0XF/W8V07UzyfJEssVKDsjAJ0s4gt1GC0JegvbVWh2wJ5iGpm9EnyBzyhQwvs3KhmqT3UEDVwvC+s4FhYOlTMr19B+Ufd6ELCU0Ja925noGO7WMoD6ZziTjHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755507141; c=relaxed/simple;
	bh=qiBfJaO8qpOjLIXC/x5i2ud4oF45x2l+4IBCd8ZiVAE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=hedbdZCeM4R/sPTAlA916bE17w6ZRROS8ukW7Et+YfgSeCCtvzK4wvJEgneUuAajW3ifT45KwSjS059DdiSRqmOd1Juq4Fq79Uho/UBCtocFZ7fJnn0sNV4mBpsFgWaiHG3x4NFUHsbhiyvazQl5aN4aHLO9EIZ6/tN/uzIVQyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=eVfm2EwZ; arc=fail smtp.client-ip=40.107.75.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOILb20cy1RPd64wdGpXi0izllSgNX2xJgA4Eo9rZxppXZjACNNVlBZ0pCNjfhIz3CaipAam3B6GW2Z0L0L7fmllPv/pFoEHgf2cfe8Rxg9W/ZkdezXUtzJtbiF15q34JRFXXcThibvtXzu7t/+0o+OtKFfnHvhxNkXpgN+lww/hQA4D1GMkU7JXexosRlJQTHpExdZE8ccftBLKxckZdh2lalFKl6TCakNLqQnokQEraNWpufN8xgbYQhopG8CQBJQpsfRcVXy4INClpDPmNsu4gFdxY6rId3jyAYeGDVU5QkuPiZqNpIuiYfRla3jKuitCQG40KV4aeAyYo8QbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTe1zGyypR/1SPusRH/GqweRMajQVAv3AHpZhtwMFgw=;
 b=TADb2d899vL6ZjzvgZ7W9piuvJuKKOQmPeMxfjCFqYnDUQtdkl6b/BOWXQWPBiaQjB9YxAMZoQhIcDoZyFmbQ4lB8qZatsfVyX+pZL1zZzEg+qS9stYkDO5cEXMc9sI+2ZXJI3luqWa17fesv2l5qwYIsqhnWd+Z6xMrS3ItSQjixSDTwf8yc8tkJAEJK58Wu8S6ASFMkUgR71i+tnJcrMsc1GDs5iLGOxriBK5B9al/K9MLT+r25KTayezgLLwEBWm4oFSKyW0/JsQfmB+Q5q5OQGy2b/wXqaosDH1/ItlOr/Ee0u22JUaFQRlk210UWVN2YIc/qDg06cWuow/RIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTe1zGyypR/1SPusRH/GqweRMajQVAv3AHpZhtwMFgw=;
 b=eVfm2EwZB1iwy+Txwl90O85ypBb2SCUJnAm4sHLqDryblLx5a1/c4EWhSvnPLJxlLhEbSB00EOtDZ6ciLMMyUve+QwSTrp3PYzQiPdfptl/9poosM044fHq6X9WJV2dmqZ/hZ2+3ED26lrmvaSSyauo/ytbtWFBwGDLvBZkUqA45mjAZw54TnKZgt5n238P8r4vVkP4YmXWcnouQeMsv+l1LWXiBFcJ4hOBvjwNm4ov50dlilMx/QzKAqneFuB/wcZ/09NxLchE6IL45j1Cd5Bt83nDd6N2SSLog/zWYoP9p8fFewOco2eRMv3TIJrB4wUJo7lumSO71dcGsXuM1+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by SEZPR06MB5200.apcprd06.prod.outlook.com (2603:1096:101:74::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Mon, 18 Aug
 2025 08:52:11 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 08:52:11 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] vfio/pci: drop redundant conversion to bool
Date: Mon, 18 Aug 2025 16:52:01 +0800
Message-Id: <20250818085201.510206-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0175.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::19) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|SEZPR06MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: ae664926-f4ca-4e2c-7c66-08ddde34852e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8cr3tFgXNQnCVvOc8TL7+YyA+GLFKxifbPnjDyAaDQkzNk+HbUHC07uQ69Ct?=
 =?us-ascii?Q?Ux3yITZGCOcrJG9bCRNrbmVXU+rnm6Kegg9icoPEJZnbL/Hi425buCuk3NZJ?=
 =?us-ascii?Q?fXRrPScHjT/+dzLYMd9kHhUW4xY+GGaNFwPzT66gFphTpa9KatcXyGBgXMYM?=
 =?us-ascii?Q?whfKm9DoKYLWPev260EnJ4LDjOE9O7Oz7CG7z9ZkDVWgYPXrf39zklLbkDO2?=
 =?us-ascii?Q?SMDRKq++RgHUt2g6d8XUQQPLxqC77Ejw+o/Hvbl9R7+AW4LYn0wcGKiA+TUj?=
 =?us-ascii?Q?0N/sSIc6Mo0UwqiNsW5KL7Op3G2HJYx/ncIl5lRCU4lfpLTkrDzskogAiDq/?=
 =?us-ascii?Q?lEDd2mer9nxSubTPGKJxUl6Ecx927MsF9QZAg9ubR1eZSipwCBMPJrsV/5di?=
 =?us-ascii?Q?4op0gJRcDKOyytEWBvuWbctBdahoUNuIHUkfztkmSayJfACJ9J0G/aICJ8nK?=
 =?us-ascii?Q?XIXDgAv5BJ3aSA62lR1qrLRfXKdPToD3pieCleBQ8wrWh4aimIJJTUqLgZig?=
 =?us-ascii?Q?DgiuyUMPSbDrwuljfp6f5UN/ctHfhjdbgIIn1RN57xGs1KhSAMHnOzNE1Eeh?=
 =?us-ascii?Q?Fv1rEmr6bJhPcG+rf8efIbLVLOVesdV6/4gmG2AG+JRD1NDofG+eJYlWAjyj?=
 =?us-ascii?Q?GisA77P50vqpnK/zgFlHFsG7EUP/bOJR7RvtdKc6cbcTh57bK16UzQGYB0KZ?=
 =?us-ascii?Q?J86znGrO+i+n+lmEy6RYr/RRH5XxvQfjbj/hHIjJAE6eg89C7eyelPJ3HqL9?=
 =?us-ascii?Q?OwD4r9JHdIqPSGL7ICc71l5O78DgHLgqx/ykyBQWB+aSPS69nQ+dMZcWw5MU?=
 =?us-ascii?Q?E1xR+lgQo7lahX0qqadVjn0umgcF4N/AvZCnTnIcGAoMZfALZWXBueMkQtfK?=
 =?us-ascii?Q?a5ErP5FysIQ4bXB0Oxb60T2qiOvmCxF60N1Ciuw799Byb7UfN1QSCDvzgNpW?=
 =?us-ascii?Q?D5mFBolcSyoOp2rvR36CowVdrYiLq8mhd3fy7PQRjPYRa7KHWkzr24kG5xBY?=
 =?us-ascii?Q?ZG9uLc4aTNG44tL6dJeFdmcD7dERL1QDSAwBAvS5OT+uoJLVz5XY6KLforyq?=
 =?us-ascii?Q?BG+ble9eL1On0HAulnFeljEY/Xljtma55cRslgxYU/YRKtfdTReuCHanL63+?=
 =?us-ascii?Q?kmuTVNlo/vtIR84HsjbbJ771fJB5H6yAZrYqq4ZWLlbmxTAGrrtP6AhItmlI?=
 =?us-ascii?Q?riYQSXhnxNLKjNesw2svrGLLy04xb4nOa58ffWud6BdzU8c1+rz1m8yC8Kbc?=
 =?us-ascii?Q?hIQzV8LmX7v92njra8uG0zFTf33dP+E9IsJ6RkrxqXWMX3B5s49CcwCQ6Sed?=
 =?us-ascii?Q?Llv/LZOuPt/AJjeJGK1dGclrOUtjCVlIoflubDZYMT3IE94yBXqXsOCYhbXU?=
 =?us-ascii?Q?0UsyVe2y4JM7utq1reqn8qDSlDOfHsFx2ictwC6YVe/lyopm/zMOG9gj1EEV?=
 =?us-ascii?Q?T5icrZbBfA7busnBFk8RofhmuMtIoRw0MisFaBX8jdPwokSmVwqwDQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x+LhuswELzY5S7IxChj4/zFsjIdM8i2dQ59Y9cvGaHAODmwimfnZ5AvybAgR?=
 =?us-ascii?Q?VSrJVYOC7dJYPl2t0zzWs0lWE7mEH0ctWpwcByzVSXILnMoYEVwcWskGgV44?=
 =?us-ascii?Q?fAIlxJr/Vp6TtCCtzsSJapWbj+bqBIR3CYW1xT09KJg4UCAzU0R8o8cn5gQC?=
 =?us-ascii?Q?ZDBjkSguMq82b8tNQUt0rePCu0pZ5XOJ+r8YRnWf2uv2P1f2XZ2kP1927s5B?=
 =?us-ascii?Q?Ac/bAwaQjW1EKy7nM0z1coeroZXyqEzNYFQGxMOd15b3NbJFF6HsbOUpynlU?=
 =?us-ascii?Q?AKuNV7Zreq1ozvkIUGLAorUp1MgjZxv7NyUU9+j4+I0wkk/8vIMzkFKjSKPo?=
 =?us-ascii?Q?/yoClmRRQxdXHSN8xq9UycW8/JdbMSX7ZJWc88K35K2B9jDblm2oW/H9mq2U?=
 =?us-ascii?Q?SnjM7oMTFMaFYlx2XQbRsaLApPtn8Su4z0bVjIbLSTZ3tFH4kpBra1xet7Kr?=
 =?us-ascii?Q?os8E6MZxTVdkSeDCbbxq9wFq9vK+0joeZRnY43N2btS0b0h9N64NVAqO9pMK?=
 =?us-ascii?Q?8IQzH/Hbp1ZKVR0M2rCyE1ASiy/3HtJfeR+EC+5imGX6W/mxZsZ56BfOHuBB?=
 =?us-ascii?Q?SRJKxcENIM0maQB8p8MFhd43ZHMKXGGPO6oCaM8h2JV9fD6OHvTYEyrMbtOs?=
 =?us-ascii?Q?lQw8h5u5J+9OGapc9S4dzVQQxYdiFBEvu8NC/JgfD+JK1Rfvk311qJeo+vuj?=
 =?us-ascii?Q?kDLLmYSzXG52C6RbYDYVNj3sa3b6QBevhZF1DvNy0MN3Oagrd3Gkr1FfsPk2?=
 =?us-ascii?Q?oDR8nM+UVj9SJfMMsKzU+h7vEDgYwSzGtZEkeXBtOoJF9iugOJLDvvR6Vr5t?=
 =?us-ascii?Q?4LUJ995D9xwIHZVXv82M08LDbk7hOYGQwcuNcv0pCZug9MIwW+JdD/RqOiKX?=
 =?us-ascii?Q?j+5BiwPyKQBHGJJ/TXxijS2goAfFqEqF6IV/oErGbQJo0ashwbk1k5gZZBme?=
 =?us-ascii?Q?Yw/PcB5aT4KWj50ThJwBXoEMpTNB/egcj7Km8inRZPLe9b+F+D/qTM24gyVT?=
 =?us-ascii?Q?NUaZiFKASv1LTVj8yuRLUubFgX1rioSwPaHuGisJ2sElkYrBlWCCVMMrW8rd?=
 =?us-ascii?Q?pbcq/b9NIL1bHJwpKiMSKV4JF/JEA2mJHTykoOBUO3lYu/KVHQ30WwsVou/O?=
 =?us-ascii?Q?tx1OVXgpMS80ky1L1Zv1NiPh0+pz/KWcgrE4oS/rwivYqQADUde3Mb+zjaBI?=
 =?us-ascii?Q?HE17JrVSLMPC/MqView8gEzRkIZPF+cZyGJjK6Ch1uUr+hyt1npmn/T0yVQH?=
 =?us-ascii?Q?FVjVoBUe5lhleYfdVyXvX7GUB98MMVuoWR5sV/+9gA6y3tFdxppIikjCWIZ0?=
 =?us-ascii?Q?g7d+9J0dRpccjpRmFkC/4+cv5izJo6Pm06qTWr3HCcZaX3jd8g0Nr5Jlz/cs?=
 =?us-ascii?Q?BdEM61FMVH7lhAkDUtP6+vQZ14SVO5CpTlVANzyByi4NeONiA7kDXrn7Nhvp?=
 =?us-ascii?Q?LsJUK2FVDTWurRwm/9BvLncEZV8zUZgmDLct/N5gDuDdSZaL/P4z91GSXcuN?=
 =?us-ascii?Q?PO1I/yUz+Ps3B3rI64lTr25q03PlVLZsC8fDqvLnd79HmaRzFiFL4wCJDFG1?=
 =?us-ascii?Q?lV3nWKvpTlOWZ3Rkpu+gmVm5csrzlq4z4dFgH92s?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae664926-f4ca-4e2c-7c66-08ddde34852e
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 08:52:11.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ID+idXdiQWDu5xuYzDprwqnyfcAv9Bh33jZ1pBkI4Mrpq6+z/mar0nSSk0/e2Rvvsa9VH3LaMFWVZIHb89h+5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5200

The result of integer comparison already evaluates to bool. No need for
explicit conversion.

No functional impact.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f..00583909b380 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -677,7 +677,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
-	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
+	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX);
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_msi_disable(vdev, msix);
-- 
2.34.1


