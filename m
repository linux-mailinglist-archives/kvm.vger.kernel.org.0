Return-Path: <kvm+bounces-53789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E26E5B16EA4
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 11:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB5BF188BC61
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 09:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3C12BDC21;
	Thu, 31 Jul 2025 09:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b="DtxP5UG8"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023086.outbound.protection.outlook.com [40.107.44.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E927C21CC6D;
	Thu, 31 Jul 2025 09:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753954145; cv=fail; b=YX9BL7FJ/po9BmvJIaLK/qG5p8D8pczBpunL2kavW/uBq05hDIC+xAcpyzww5abH21bBw+ZuOxqzuePBjKNV+LuGP6hwWvP27IGGbEErJgGGH573Iru7k094+uC6F1suPq1iirw0kiY/tEJaZPhOqSeFRdMhXgiPvjKgbqNbGZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753954145; c=relaxed/simple;
	bh=1/X9dUZNitEk/DujAsvdZhu88K1fK3oTNhrr6NqC2VU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=vAh2KOItHefl/DpEoBE78sJjHGtsd7t1Vrf2KqX5dBoedkLWqmIoX0ZlRF88AnvGowEVu8t/6x/KgNg4OaaEu8LSFrxSjhMNzsNjDz/x461Q9mbuBEtkYZdRuGc35gnVOZym0+Hks8gJXLaBzyHy1GCjIHqeJF7tb2xuXhol1OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com; spf=pass smtp.mailfrom=jaguarmicro.com; dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b=DtxP5UG8; arc=fail smtp.client-ip=40.107.44.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaguarmicro.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i57gb8rzWiLv0I6LO4zV6V2iBeAZuzuDA9hBF7SdDBbSLsAwk36bRASG+idgnwp1Q9g58qtnw8/EaU4ST+OAALMMC3ORzAtkubfQZNOHDZTZKYA5MPfpxg7fyq77aCNn00VS3MLo9I4Ni1c6Sz4JvlWNxIPj0tLwosp+jKzHMOp9ro83xoD2NJtaX10RMveR1e/QNkqnHUO4AA/8+JRM24eD1H3lTn4xr788QcG92d6fn+oKPTYJheUHlXaslJiIEw3GZMKTwqMLIQ4USjaPuU1AdLFI56s2pwIFhUKpMbjBQNGag0SRQFyF7zFaW5TcjkUbpkIR2gNGM/4SAWAfhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DH53owwCm8eC+HFbT5VoMcck3pkjkFpzD5Uh5bNpKyQ=;
 b=AIe1S6ct63yrZOyHMzcZ4zMpy0cAOIw0TidpzxIFBo0G1vpovOqlqGcAdq5CFHOAz3PuhFeP5XnqgIabIYA5wN4k3McnbxO/c1CZBhKws3J2JQZeS6aKyS1/TfgcdZoJg7nRmAyQW0dI/bVbBL1w1NUiV5tJLPJ2m9V7CvE3HeNkc05gojvNDXtr7gMh8j084CO6r0XPWdbp5y+8o5Ea97DPXMnT52fKTmr+9rOzDVhdYosPue3O8MNvmRRNXaBAD5F2P4d9L4jk7MzUhhXX8Cq2mnBWHwVYNB8BJzft+oa9NgQaJUJfXhRZAXrFZLfzu1sHritzooRyhVUZ3wvaMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DH53owwCm8eC+HFbT5VoMcck3pkjkFpzD5Uh5bNpKyQ=;
 b=DtxP5UG8H1fP/yCNlOJK04fFHDxBLosGOFgCSsxO6Xi8MMGCYiRdkCu6zxEKz/ZAnXVITx0QGck703TVs/AulVLcIkWLW4Z08RCdb+ZXEaumdzNkpGoNpHnVX/vkIzqaLmtAhfpEDfgcCMhj6l7mDYykcrUaCdDjVgELOBHZi3gMRZDPqJZoAgcTtHh9bOWc237JxslYKNYWTF70SkSnCCeV6TaJeH9Pg5NkgsRXHb81Pg7WYXqgbb5E/UtnZFhyOqm3OOvyfpiWymBckweQnpFtjh0IPLDhchUdUa4YrP15UxynrIP9HOZEaVa+aCIl26TiwlnFih40JGtrSC8JHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by KL1PR06MB6943.apcprd06.prod.outlook.com (2603:1096:820:127::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Thu, 31 Jul
 2025 09:28:54 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881%4]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 09:28:54 +0000
From: liming.wu@jaguarmicro.com
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	angus.chen@jaguarmicro.com,
	Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH] virtio_pci: Fix misleading comment for queue vector
Date: Thu, 31 Jul 2025 17:27:57 +0800
Message-ID: <20250731092757.1000-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.49.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KUZPR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:d10:33::12) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|KL1PR06MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: 7837af8e-eb50-4166-1fc1-08ddd014ab17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Bdr9bL8XsL6EpwsCre9x+qjsfJQYpw9nrGhCKGK4d19BBf2B4sg2jgKILp9R?=
 =?us-ascii?Q?wyYyaOy+2Qs9Eyx2r9wdkReZ0ye936S/DvWmK7mcQuPyXgxAiic2sExUad0A?=
 =?us-ascii?Q?9t/nKhL3D/aeCm215T1tgbWFXxCK/ncdsZJAkRR4lBCYrLFSqwSO6bqn548v?=
 =?us-ascii?Q?kbK6A5jUUqPORQHt6wy8TRrF7p10VWxzngddZPny9xlBjlnM9d9NoEhjMfnY?=
 =?us-ascii?Q?Gy1TEFuPQwmrZ4zL/+YEccgmWnxzVEc20j8UllgoqBJqi8NrOyuaxUqfLXAe?=
 =?us-ascii?Q?aNvm/SPdkXjaFOoeJr+NLaMwlP5xm7tpEVAyRkxYfRjPbZyPeY1CFpmOWRht?=
 =?us-ascii?Q?254AUxuDh49rTecYTi69mfOs6aZq/JQNZ4Wj54B+BodglMYNyd/QAtZfU1nO?=
 =?us-ascii?Q?BVq5sc3281XAWZfghC4/JzkRbmAOWXcbLTN8HyoU/8xEIdoZ/FHEt2S885Xe?=
 =?us-ascii?Q?XZLTPXLCjMl71thVSWHcC+qTueztlCM/Z63Fax9INv6drTz7fgIE6OeQeoHc?=
 =?us-ascii?Q?FkWKzWsuyw2j9AzkWRcMoXKBW6yWLvw/kiDRm1Tbikifbfya2mY2DXLo7fpJ?=
 =?us-ascii?Q?v+P/5A9f1HWXtKMWurCV7nwb7Qjn4dVczTnRtdMQ79gbtiGXFAA+y1zpLuRd?=
 =?us-ascii?Q?wWr3g9iVQI0Jn40DUVXS3NYkfYj/v3Nu0xHVw1pqqK39fdam45BL8UEckpoF?=
 =?us-ascii?Q?fm64VLCHzUxqOFP1+hAfoLiC/I4XYp1bzeLWL90rleb2pN103TO87wiqhdm+?=
 =?us-ascii?Q?M5UtMv5FK3GJMoNkNNzq/DqbgH/G+mlSYq5UPIF4TMq+ldIp/IE6eW0RO8uc?=
 =?us-ascii?Q?uzItOiT3VHcuWGJtCmMkdHnpIPMgxub07URiC8dXzhqP3J3m8FC78tAbF7KQ?=
 =?us-ascii?Q?/ct7a4VAmYge3U3Vp6SMJsFQQjWe54Ay345p2VC9LRfrIwba5xIHYROuCfUm?=
 =?us-ascii?Q?8bbAc/YHrSAssuUVHbQcdrpQhQxPkhxXmUu5OQ83U02cX411ARxlNXPfgVRT?=
 =?us-ascii?Q?ykT+5MtD2bSbeoOZnyH0+s6saGiVEE3GOvhRSuXEi/6FJYrqojUBwAnTcnu0?=
 =?us-ascii?Q?40S6MVbtCr5x00EylilvYwBCatwuv7r0GMBNOPCk9yP7cbqljL6WhOSshI1E?=
 =?us-ascii?Q?hI2ia7tArd9ZU4ZIUEC2/mpKuDT77rLKyCDZSk7T73J5lzf17esfcjJQySe4?=
 =?us-ascii?Q?n6JiX/uFsjRxKpG80ZQqdBFpuNN7TPR/vxXYd2eRtN2oX/49sMqG7xyXTxs2?=
 =?us-ascii?Q?mBHIM/aYE5bpHooFRUP5a9mYY8BtzuzKgGuDG3HpWQ2oyfQVZoikHYd/YzrO?=
 =?us-ascii?Q?lQOTh666xNi2qnIFaAQpebp7z1gjDI8/JTFcm/t/jhfWCtZ8PE+svkzwDhkl?=
 =?us-ascii?Q?n/UqH1/QJI+COlHYQamQ/A/TuMhwTgVR0GTkAWRXVwglKFha/iJcTwBh3PmA?=
 =?us-ascii?Q?gK3cRbtZ/Xarl843SgwwYAYD8VFTKeHdXjJgB/PlREzN80pY2lz19A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b9MoICYHTIZCGS3GqIvz6eJScHReaDEuz18DWxKMyd44qSyVqnolP0JV0Yzn?=
 =?us-ascii?Q?wkKFQbDzrpGUHxQLI8a73wwapUiRZbHqAiMrPQ/dVYipJHLsf2RKf5pX8hMI?=
 =?us-ascii?Q?1jmr8eNck2ve5ENsm8aVhmQ8lH9iNt0gOv2ni3b8yjnn9w/U9pVdc5oLXSY5?=
 =?us-ascii?Q?ffF9pJFBM2L2ZUCe4/6PJuQpksZASYTxTE6M+JeYt8jqqcT1qFZRpFxweMLR?=
 =?us-ascii?Q?0GvZxXfqctmLSBE8lC8M2rZ7qYh7uu+Qp71736531fCANgephwsMNEPqAeHy?=
 =?us-ascii?Q?Wn/+Xo9bldVURaYNmRb4tYL3TWO4nsk/CTBEc1YDS+TI2T9FPpTm2le9pUgZ?=
 =?us-ascii?Q?lDOxHHrWiA3M4QTR7eAH9tzWjHbfWQdNpuNL1w5d9GgiJ6s2Fdjc2jLBVGuv?=
 =?us-ascii?Q?K3jyd0hmB7dQFfOuEX1EAvBx9pHRhf7N4rFkonGPLmUDMUj0YjRkyfvNY9oo?=
 =?us-ascii?Q?pWvKiv6tccSr495v/7piDa9t4rdtE6klHb9lXaVczUE/dQdUXqPQCGw1r2KB?=
 =?us-ascii?Q?XvznPaB96RChv58sBrsSITqfRjmEzmK07DwxPmzgD4oEOrGdEDUYgZCibjrS?=
 =?us-ascii?Q?qd4n+iHHdVL/OoatLUAw61TJyb3awgxaC7AXT1IdQyThUx2CQXoUrIkk0K5p?=
 =?us-ascii?Q?tWyiuD9oZcgXqcYYkzpA1RNbgGYV8npGpo+Bh6j2N2l07qEl+qMd/ozkhPDr?=
 =?us-ascii?Q?8+bK/6g+/J2Nx9F8jjIjIaxcqmc7EOYoxLH6HU9ykofkOIRHIZSJCA1Wtgcu?=
 =?us-ascii?Q?cu79zHgK9zlVDXAKr7ewpassc6uzNuEIOv+L7yhZUzVWPz2g5Ao6NoVLvkeS?=
 =?us-ascii?Q?YRUtFz8XH2Kn1GIUKVfDHTvXeoJs7ZeMXxeHmgx4Uq6cPqGVlx0dZLcek82n?=
 =?us-ascii?Q?evH9IiFMblZqXaS9DtJWGzdC8f6ks9OvsOZRUVU+zTxGoT+Xmr0z6yVVFOV4?=
 =?us-ascii?Q?uHFn8qe3WFjDpHufpgKnqsI+sYk9Dexf2/B2j11g/kVhD5MxJJoeo5a9hzVf?=
 =?us-ascii?Q?gs7AMgrUbqnvybZiIeTqffLFYRaUK2RAo6VVmYu/WW0+2IWuDbk9YzqsjPJp?=
 =?us-ascii?Q?0uQwNloeTz9FDMlL1/3+DPxYJ+JTs5CUDrErsLgLbCVklsfxOXIQnOKkdjVQ?=
 =?us-ascii?Q?FjicI23t5ll5hemvN7fPUhFaKW5LPp8HqfVQXn1q8dYpod09GzL7Tm5Pnpef?=
 =?us-ascii?Q?2aIqh90bZeUbh7eUfrU0jZXVeJy1Mz6RaYwZi9LVnn56Nbj1uLJwDnQCHSQX?=
 =?us-ascii?Q?TF10lxbVfh0TneSEN0vzVO1jH/mHtJdNLYtkG/HfvSp3RhAhZCVKqkXAf9Q1?=
 =?us-ascii?Q?3mPpuuNHWC7k8TGtNc0YsKsYQjN0oa1w9oRnRMRDFOBUH2ANlFX9JYdzZ/FG?=
 =?us-ascii?Q?3KlJmMsAmLvaEkdazJQomoiJYMZfMDC1lvgAb22IJSm9EIbR/X7KFnLQ+gZq?=
 =?us-ascii?Q?25KJewLd2u99DRzy5Sx81ybHkDw0gA5LGx1Z979/6UYqcaoOpg5ov6sRRwFy?=
 =?us-ascii?Q?SIWHgpSQAVxBMoYOX8GuWm81oeORO4zNBXL4poUc/pXLj5XIhHUj940YDFQB?=
 =?us-ascii?Q?VV8IDCqn5TM+WJbQjIgJ77W2a6rK87bSscoEDJ4h3wm880w7QOEouDbxOMWp?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7837af8e-eb50-4166-1fc1-08ddd014ab17
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 09:28:54.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdNf38dogNAbD9U5bsP1sQgJV+DXJKENh9mIBj3zeY5uRSIurCdXTME4RMksZLuYiKpID5vyq1ZM/k3iz+CJmvQ4HSIsl1uVS2vSHMBF3no=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6943

From: Liming Wu <liming.wu@jaguarmicro.com>

This patch fixes misleading comments in both legacy and modern
virtio-pci device implementations. The comments previously referred to
the "config vector" for parameters and return values of the
`vp_legacy_queue_vector()` and `vp_modern_queue_vector()` functions,
which is incorrect.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 drivers/virtio/virtio_pci_legacy_dev.c | 4 ++--
 drivers/virtio/virtio_pci_modern_dev.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci_legacy_dev.c b/drivers/virtio/virtio_pci_legacy_dev.c
index 677d1f68bc9b..bbbf89c22880 100644
--- a/drivers/virtio/virtio_pci_legacy_dev.c
+++ b/drivers/virtio/virtio_pci_legacy_dev.c
@@ -140,9 +140,9 @@ EXPORT_SYMBOL_GPL(vp_legacy_set_status);
  * vp_legacy_queue_vector - set the MSIX vector for a specific virtqueue
  * @ldev: the legacy virtio-pci device
  * @index: queue index
- * @vector: the config vector
+ * @vector: the queue vector
  *
- * Returns the config vector read from the device
+ * Returns the queue vector read from the device
  */
 u16 vp_legacy_queue_vector(struct virtio_pci_legacy_device *ldev,
 			   u16 index, u16 vector)
diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index d665f8f73ea8..9e503b7a58d8 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -546,9 +546,9 @@ EXPORT_SYMBOL_GPL(vp_modern_set_queue_reset);
  * vp_modern_queue_vector - set the MSIX vector for a specific virtqueue
  * @mdev: the modern virtio-pci device
  * @index: queue index
- * @vector: the config vector
+ * @vector: the queue vector
  *
- * Returns the config vector read from the device
+ * Returns the queue vector read from the device
  */
 u16 vp_modern_queue_vector(struct virtio_pci_modern_device *mdev,
 			   u16 index, u16 vector)
-- 
2.34.1


