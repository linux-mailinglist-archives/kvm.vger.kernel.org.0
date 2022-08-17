Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A3B5973B1
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240873AbiHQQHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240807AbiHQQHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1983760C7
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eK3Q7j0+GcvqNssBJSH04arsoawEZ7Bqz3oyBC9n2THY49tB340pqS8t8/BotIjle/F9+RzqFk5gQdEkV3mrdLY4+DJ7qui7MPbvSDybsMZwjXZbpvWEdYzJE7Dvqh9BttsKZLcohf/8X61M5cqimIYeJyHad7caXxAicvU2YzAl6Q+ax/alnp4ILonIkeQBWvt/e5BlXFC3QXqZhDu6YrbTRRKCo8o37PRL9HMJhKzoQZCwC7F9yNUOmeRxtSEsdlCmPFOGxB8GGcASaQcs6gZWgszTrfa82UpRZdZrTfRL4/tps9wb6BR5kVNaO2IrkV4fE7Eo3xE7/dLIkQsLoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCdpw68nbPkTpQ+ij/Mqjno48+8atd18Y3oCi5+pBHQ=;
 b=PN5Iy66XOrREj4Vag8OUNBvxYchYsPPRJFKk2KA/na8s9xaS1Kf1F7g1MrzB2sRBk4j0zOJbbZ3swTxgq34XtApMNgIaWtiZibLCDNO00vc1jARgpDoY0Hs3xVmRN2FvX8HX2XgUeKs/wcBkrYQWbpH4cyR3USwXC5heq88CJ1NvyDfUPFMIb6zs3DM2Z3QHQUGcg4e1ox2PMAR+GKNu6wlf++LIpyNKMBIiFeI3XiICWTvA17ESXRJDne7B4rwQJu7/WhbbnIgwDuSrlx/ZDpJr1Us9FdrjGmn3AHkKCHVrYO1T0+noXfkPBkM4sdj27F3cW1HHYFnKIdfadoe0og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCdpw68nbPkTpQ+ij/Mqjno48+8atd18Y3oCi5+pBHQ=;
 b=l/blVsTwTJq5vPVoVa6Mv8N04RghCdS2Fl36kbdO4aNAcHAYRoLPh/htnzEUkMmVIi3nzzhfslelkYz2lkP80S0bgRAKzPY+vnaP8xv20vJNoreqAcCGsHkkpDaopeGWP/+hyLXaegn26l0YuM9T+eYKZfu2lnUFFj9bFDgmFFbiTiQNsZhD42jeXMYiq2WQ0KbXfkv1+Ah13mRGQK4Hdg+iDZgi82LzTtY8Kkk+BnDOumdERAOPlivwv+vjPVYGMqvkxYmFADI6qoahPTw3KnkWrVdVbkLRhO9LW/QvUBk7gqVWWR90ugHNrkviO0cvNpykbCyu1diLKtqnRbT8ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:30 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 4/8] vfio-pci: Replace 'void __user *' with proper types in the ioctl functions
Date:   Wed, 17 Aug 2022 13:07:21 -0300
Message-Id: <4-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:208:236::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac7cedd0-c7f8-487b-af8b-08da806a9476
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZDylyOz24X5lZxhLwOYO04HhgUVFfNvgweEjlLrQ7GFtcSV1S8oubvmfhcrkrvYHk5K5AjFuT103bUGfpDGcqrXCoCfh4lhas2i+jUllF3wCXf3leWauXe5VA2sLiiX+bxjr1BNPcjKN60txvffMsenNVA+58CbRuriqMmOC0iCYBoDIbss44EFSDY/xfdcDx/s1gDa3rQ3GfKU7XTefTmHTiTic7N/lA//KFC2aJhV/7084igirHYieqIqsmwNZB6YuoEloU1abmFS2WKeRZtclG6GGLShzYtCYcOr79hVj22/x6vPZBkmuiJTuc+view9CaHj99r9SNrtf63FHbCLWv0TlLXGFh3ylEWOSj7lQamqX7adn0Lo0uRmkVeehAyBajvEjuaZg9rSCXdwbxOBoi7SHSdpDOgXzWB1aP4tS881JIFM+tEK/GFffnglZmtwDkHBLLfhw62ysMHSqXLtL63t6wflt0xrWS2YtTec7jU04Tv5WOl1JrB10APJQ+OBW94Dt1PvUlNdnH6xThlMnPlp8SCZpSaHwv+5YvU0l5KZsPQc86/5g5m7jyoJACC500/ibVb6JZF6s+Y8+oPa3Cuq2IfJBKSZstwyAH2gnsBAGZeSgCh6MM7U6MQgwLWZuHXUOVr5cQ5blV9UdjqeAfMi9iRGh24DEEQ0PKwhVQ7h3rodgVtDSXbD7MRfUt/KcjaUN03mD9Q/TqLoTjcg66lL0PZjA+QzAVDslOvPfQvCcwqfa2J2SgxN3Pzl1aVfBVmPso9XrEspmwm8/GoMSS3MDcvOgeWiQt5cWsc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6666004)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cVVDvcQSuQLyoS5227ABIccYYoxaRmJrtbXCUdLUz2T0Hi9m+BaEYkrkFbMD?=
 =?us-ascii?Q?Rvw5hEEKtp15a59nsiSa3+SaiO8SetdsYdjUpP1z7qM/H7RvfiDDYnhZhVZV?=
 =?us-ascii?Q?RJlwYstNvlUG3THJResWLY94F+FPmGOBqVjWMjDtZv8fbJrHvMgjtreqfGgv?=
 =?us-ascii?Q?+dWmgRPsybq1MFLSiJsdaktoEfmxpRhg07XXh0swmSa0H3dT2RL8EMsZXnia?=
 =?us-ascii?Q?rKGLo79Plt2C4uN2lDYalu6jwXmzGiFX8VqO5AHTHY+Ts4EszF8LdxPbT5yz?=
 =?us-ascii?Q?3Vb3Ir1yeyfVszMTqVTuCgPJa/ElUCb39RyCC5Yx9acG8FBSoEVCFLUtJd6q?=
 =?us-ascii?Q?hsqHDMLAldN/GvxOlr1FCj6djKRU/SZQPLnLR5qGGYsUkkTIpweJ7vgJOj26?=
 =?us-ascii?Q?WdWKP90mrmaHajxlXg/7ckzKtymjnPU0janE+Q9GxO16vcFfpCkHxrdC7VPh?=
 =?us-ascii?Q?7EOvzB+0Kl3pj7YyPv+9Kzn/wd09eyvwjlRGrSKxVuj4ZSiqvVu13bkrqYNc?=
 =?us-ascii?Q?56+pPrseMsL/UYvWa3Ag+RvREp5WZ0cMXZMNzYUljVIQkNzysWzDLHHqYtrN?=
 =?us-ascii?Q?9shMJhqfsCRgZR2uufHFSlvJtW7gAws81JXbyu4wSoklQRTEvdI5jiyxWziv?=
 =?us-ascii?Q?iI4RdJb0sY1UH4Gju42e4zyZCxlai0Z413BRLCEHLFqmqWi0szwK596shmBY?=
 =?us-ascii?Q?MTfNrUM8iLDDu0KoNavzw195qlYdogLgEh1xoVh9WEjF+bKuI764KqwFWu8n?=
 =?us-ascii?Q?4xK04zbApm3ZVj/fIRkPAytajGzySAIZsQzMYIBN+wLM1xsg4PGauLpo8bZ9?=
 =?us-ascii?Q?7fc4vI+NFm4BvwVw8Zo01Cy2pLNoAWPZaBPlCrQH8+zjLQ9h9YBX6u9lc9C1?=
 =?us-ascii?Q?45QlilAm+hFOAijrx4TaeaK38ntm4H9pjpOKilyWF2S4Y4vB8X4qYVUJ2SGO?=
 =?us-ascii?Q?d0T+n6VpjoLQnnzSkYci/MPKXySwu37vh7AaH/4WLLsWXvoSCGAq5g4VEa6b?=
 =?us-ascii?Q?uleRMMQWkEQCGXJaBB+1ycSqGyb0pMsq8b7wOcMi+LpLpup3/fZESgZDYdhd?=
 =?us-ascii?Q?KDB5caulJ3ELZDyd7pyVV0cy64/AygZsv7yldfs9075TRvHOeqa18cQQRrf5?=
 =?us-ascii?Q?Ne4D/QZ+k9Hl2uZw4JMFr3/OZ+t4YTzaR3M5y2+R6Ra6XfZlacV67TMKgyhW?=
 =?us-ascii?Q?wqCa/yPc7JWgAFZ/xG+tXBPZrFWIWXiFBbeKV/dWaWKXLINvrGAjEQJ42k4p?=
 =?us-ascii?Q?+vy6/Ms/tarkhDI8Ngg6pxlgS31i5KZzqjh7wT/hm+4BaotPOso4tqcKBGqp?=
 =?us-ascii?Q?GhS3X3DSow5ssBL3PgdhpxXvC49NXBtVTBlaVh3CkZfdG0ODGJ9GVW9hNOQN?=
 =?us-ascii?Q?YM8n8SZXwxCCHTCOovWFMrsSF4X5UjqRrE2CKhVN7PGmeGiGjrppBpV7JC7v?=
 =?us-ascii?Q?ZIyebq83TKbQTmEocm42odqp5Qi81z9Hb7rbPZmWEseAfKXOhnCQzCKPfg+d?=
 =?us-ascii?Q?3jOeJkl7eznxlkLioCuZwmBFR8hSM3AkqM7nlqYP+zW6IE0/QHk1EkyZUMjR?=
 =?us-ascii?Q?Z8OcYmkJaC15FYH6GyDVZ0X+jrdSBKfPYhw06cXg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7cedd0-c7f8-487b-af8b-08da806a9476
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:27.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BsghjnNWF5k+ANrB6k178CrB2r+YJhFCrGNw3/6XQ4y1TaWEMfmxYmmxVC4A3lC3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0216
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the code clearer and replaces a few places trying to access a
flex array with an actual flex array.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 58 +++++++++++++++-----------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a0a855a52bbf1d..050b9d4b8c290c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -690,7 +690,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
-				   void __user *arg)
+				   struct vfio_device_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
 	struct vfio_device_info info;
@@ -701,7 +701,7 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 	/* For backward compatibility, cannot require this */
 	capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
 
-	if (copy_from_user(&info, (void __user *)arg, minsz))
+	if (copy_from_user(&info, arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz)
@@ -733,22 +733,21 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 			info.argsz = sizeof(info) + caps.size;
 		} else {
 			vfio_info_cap_shift(&caps, sizeof(info));
-			if (copy_to_user((void __user *)arg + sizeof(info),
-					 caps.buf, caps.size)) {
+			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
 				kfree(caps.buf);
 				return -EFAULT;
 			}
-			info.cap_offset = sizeof(info);
+			info.cap_offset = sizeof(*arg);
 		}
 
 		kfree(caps.buf);
 	}
 
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
-					  void __user *arg)
+					  struct vfio_region_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
 	struct pci_dev *pdev = vdev->pdev;
@@ -756,7 +755,7 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
 	int i, ret;
 
-	if (copy_from_user(&info, (void __user *)arg, minsz))
+	if (copy_from_user(&info, arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz)
@@ -875,27 +874,26 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 			info.cap_offset = 0;
 		} else {
 			vfio_info_cap_shift(&caps, sizeof(info));
-			if (copy_to_user((void __user *)arg + sizeof(info),
-					 caps.buf, caps.size)) {
+			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
 				kfree(caps.buf);
 				return -EFAULT;
 			}
-			info.cap_offset = sizeof(info);
+			info.cap_offset = sizeof(*arg);
 		}
 
 		kfree(caps.buf);
 	}
 
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
-				       void __user *arg)
+				       struct vfio_irq_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
 	struct vfio_irq_info info;
 
-	if (copy_from_user(&info, (void __user *)arg, minsz))
+	if (copy_from_user(&info, arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
@@ -923,11 +921,11 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	else
 		info.flags |= VFIO_IRQ_INFO_NORESIZE;
 
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
-				   void __user *arg)
+				   struct vfio_irq_set __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
 	struct vfio_irq_set hdr;
@@ -935,7 +933,7 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 	int max, ret = 0;
 	size_t data_size = 0;
 
-	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
 
 	max = vfio_pci_get_irq_count(vdev, hdr.index);
@@ -946,7 +944,7 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 		return ret;
 
 	if (data_size) {
-		data = memdup_user((void __user *)(arg + minsz), data_size);
+		data = memdup_user(&arg->data, data_size);
 		if (IS_ERR(data))
 			return PTR_ERR(data);
 	}
@@ -989,9 +987,9 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static int
-vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
-				      void __user *arg)
+static int vfio_pci_ioctl_get_pci_hot_reset_info(
+	struct vfio_pci_core_device *vdev,
+	struct vfio_pci_hot_reset_info __user *arg)
 {
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
@@ -1001,7 +999,7 @@ vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
 	bool slot = false;
 	int ret = 0;
 
-	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
 
 	if (hdr.argsz < minsz)
@@ -1051,11 +1049,11 @@ vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
 		hdr.count = fill.cur;
 
 reset_info_exit:
-	if (copy_to_user((void __user *)arg, &hdr, minsz))
+	if (copy_to_user(arg, &hdr, minsz))
 		ret = -EFAULT;
 
 	if (!ret) {
-		if (copy_to_user((void __user *)(arg + minsz), devices,
+		if (copy_to_user(&arg->devices, devices,
 				 hdr.count * sizeof(*devices)))
 			ret = -EFAULT;
 	}
@@ -1065,7 +1063,7 @@ vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
-					void __user *arg)
+					struct vfio_pci_hot_reset __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
 	struct vfio_pci_hot_reset hdr;
@@ -1075,7 +1073,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	bool slot = false;
 	int file_idx, count = 0, ret = 0;
 
-	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
 
 	if (hdr.argsz < minsz || hdr.flags)
@@ -1109,7 +1107,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		return -ENOMEM;
 	}
 
-	if (copy_from_user(group_fds, (void __user *)(arg + minsz),
+	if (copy_from_user(group_fds, arg->group_fds,
 			   hdr.count * sizeof(*group_fds))) {
 		kfree(group_fds);
 		kfree(files);
@@ -1159,13 +1157,13 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
-				    void __user *arg)
+				    struct vfio_device_ioeventfd __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_device_ioeventfd, fd);
 	struct vfio_device_ioeventfd ioeventfd;
 	int count;
 
-	if (copy_from_user(&ioeventfd, (void __user *)arg, minsz))
+	if (copy_from_user(&ioeventfd, arg, minsz))
 		return -EFAULT;
 
 	if (ioeventfd.argsz < minsz)
@@ -1214,7 +1212,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
-				       void __user *arg, size_t argsz)
+				       uuid_t __user *arg, size_t argsz)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(device, struct vfio_pci_core_device, vdev);
-- 
2.37.2

