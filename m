Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B19355C65
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244932AbhDFTlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:02 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:28513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235424AbhDFTk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:40:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kv7hkYvm4GsEhpAtD1JpeT5psO2eCBBdWUcWM1cfJ2IVY+aFC80hytcu2+16K9eaYKSny4KH847RIQspiwol75757KqmJUMGX0qYkhPhYG9EN9JOiY1CM1tqBeKRJu94RCOhkr5yvbCEX4Zoa1zHpr3KrE2Z0I+OTiq8Zddh1X+aIEbSS32wQgrbL37Hi9apAnhumH8LbXyHOtQvbzcwhNR2L4O/V17Eni1uLwQOwjMglX7S/SqmU3BiWbga8DQnzLIRBcHIuForZGtWdb5GA2jEENHj6ip63ZOpWloEI6HnGTTKExblTwWuQaZPHxwtBnS7rwxcBjlwnZOSZqITWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcIiMWSepG5xkNLmediyrsbbka1WWxMuSvIo2oTYikg=;
 b=fUdyy93nAE8CpZXGq/TYocrafNu2sdjzP9tWdsmCkhitLY7C1UyIn+Dub97e96ATKa2Z4kC7Plzwj/wB+oQdfMKcM6Ztr5EB2PowJlyEMog2dw67+RUZ0WPoJMwy/QVz/M3rjnZ5slwMY/DTIruK9tclyxHDsFfHMmV6jBg40dqWMyoP2fpdajxegN5CHLRDg05rQcIY2Ap1u607GxjaLuIb7AScJ0MVOMG+JGxq0/sFMlBg5B5UWRQNoS7en4Vzl2PpeLT+Dwbl3pMaB8merrPtTbkI6G7WM2YkgxCmvzQn8KUPRu/RjuRV/ps3JMc1GvCoC+qwwDaHZggn/jyT0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcIiMWSepG5xkNLmediyrsbbka1WWxMuSvIo2oTYikg=;
 b=SF+CpBf0UPvIlQL95N6krVVaen1oiPL3BS0ETTLGw0qsjepSBjCg1FUhg4XvLMWF6jaTB1U4H/rMwtlRqRGprn9Hnunl2dnukuoLdlpFpOdcyEzR2Fk4g7JRJFb+sY17z4Iy/RALg+U7N/sSQU8U4UmudrMok7CArXwfmzElUyQuosNDNujK4DzNcXZn02ngd4/uhtx4UZKMW6C8UhGE96CX/h0lkVcqNecKh6HUr3iVsEqXHBx6FqI1KLI2/BTvKk5+1udbOiVM7dWscnt7KWazoCiycKZssZOp5NdYDnvYNFMNOZEPjPtjS3vox1cvhUX4/8t6CFzG6am+2z9Ysg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 13/18] vfio/mdpy: Use mdev_get_type_group_id()
Date:   Tue,  6 Apr 2021 16:40:36 -0300
Message-Id: <13-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0137.namprd13.prod.outlook.com (2603:10b6:208:2bb::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 19:40:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXe-Ac; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c843c9d8-62bd-4594-c280-08d8f933df19
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB423541756C1EDBA7648CE39CC2769@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:446;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0C0ghdNeVvq5+k78pSKOK1X1N1q0ppnY2Fs0As45HIypvqRZ1B6aYDAtrW7rv96VkSgWt3vKNnSujTY0/cfyhoNv7pDlneW0EYXRfp7B9Njy9sktfRRwupD/Nw0tR04H80OPW46hiuLGZqGiCcde8RvR5NLLBsHpiH+DwzAf1NqKUEyjqeVY0rsUJkAYkE7gSk3MLJOnjc81hilumMWHozfKgiX2xL6y0osR6ph0IbGOLJHawNuVfrqDEBrCnuzX2U+ATb13KVxoSlWUMFNBxGhTGpQzSvYemKUbYyY+VLfGTgU5jawkD/ZRrBH+xohYodCLAWv15ipoYtM5Lakkz+ge9zTh2Zu+Oj9v9oDksAMNUu8aoYaDG/aI00Fj4YQbpRPxhFk8fZ30aIijrwxnFyifleKGzYPfNLtMXccSeWrK/h+UFEguicJLaJXsQ2VwWqUKSAJ1CNxPMv0xJaMsWRVavoQbv/tt5v8IrTklDvNEDZb7xVqg+GVMxfzl5WEyKfGjI2PrMcgssTdIn7Nh4nXUhfZae+IP0SSeg1Lu7WjSlgfIPMgryZ77W9CDHZlq076EVH8myFDVxuSicbQ9hwFmLnMx92NOc6sXu1BZQmf7bvVjk/rPCCpBn9tSceDAQKoEYDqJjVmpPUO1lp3qsXM55x0UZdwO+u8MiKLi8uU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(478600001)(54906003)(8676002)(2906002)(86362001)(66556008)(6636002)(83380400001)(6666004)(5660300002)(38100700001)(8936002)(2616005)(66476007)(316002)(426003)(107886003)(36756003)(26005)(9786002)(9746002)(186003)(66946007)(37006003)(4326008)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CHtgf/4qR0tH82fgFx023CkFI/s/wEQ26NvQpfphFiUgq7yubUJCWMbL+cb5?=
 =?us-ascii?Q?bh9cVV9OhXZnT6GpyLXDbWe74fbsYOHpl1YKIORQJWmSQmAGUlaPEpADm7hB?=
 =?us-ascii?Q?aOWqO560bbtUcADgKZKo1CVrFsX/2J6p3byQWrWNQHKFTC/XB5EnXafYSLtW?=
 =?us-ascii?Q?6Q49ufqGYdvYkmvt/PKTVopNoSE6lDJnGzucPH8MjfLwmxwhhC45CPr3Hiu/?=
 =?us-ascii?Q?yb3jwyk782/mKBZLWT40/HNA7C0buijh9g0ZK2yDgbo9UWbGzvHShkSIyqt+?=
 =?us-ascii?Q?wEkCttyWBBHcCNZCn9KJ4rCu2IPmlaZlt3Ltjts32ULXbAeVcOcwSvoKDgeJ?=
 =?us-ascii?Q?5Cn+xnmAEDGhwskrsRd2AE3/Tyy3qbpmNI8In7zBp+ifZdRH7WmWvf5IdPYc?=
 =?us-ascii?Q?v4smrjuoho4vq20YTgUQJ9kWajuOmBgjmx1TNVvfVdc4JEXsWjlpOoVBQF3P?=
 =?us-ascii?Q?PhOAiaPSH8eJ2mc/MHggjyhqEsPMs5iwxE4A82Z4D+Qjf/UKIxUKkopAvkRW?=
 =?us-ascii?Q?vAG40jlYnLaBhL5d2uHaUMOMAuSr18oq3QaqvHhkPeFYCOcXqLCROEd8y4eb?=
 =?us-ascii?Q?FGAKSRP+esXLgAnJFoK/bCSmg1294Dpvw0RPj8WhJyy7plUbYNuMhq76pFQx?=
 =?us-ascii?Q?A5JNLOqrwxnfECNb4LnKa/PHfqcT0KEcPVeRQtGCtKwAgj4NOo4ZTFTnENk+?=
 =?us-ascii?Q?85dSIcN7Rp5l6YSDtPon6ZXNqQiQnbHSYLl6EDzyoMPfFXHOh7laMyS+ekMq?=
 =?us-ascii?Q?NVGKlWlZ2dnRZzdTYp4vpQw+3vCwVs/RT4kbfFPaZ1/0xY3pfBDyEAeH+HyQ?=
 =?us-ascii?Q?SyWQybj8a6eXOhLZuxqpvP2W2yAEaRwbcLn6b2iI5sT6fIsC0vW/I09ZbPWW?=
 =?us-ascii?Q?yUXywvyKu0nDvIM6I8jDK4MXJmFpJS4dJUX1nHTrb4mHxszY0XrAzRw/30CD?=
 =?us-ascii?Q?tV20UvKG90qck4oVr7XHcR5BPs20x+/vAZoQ+PFLPsAtN8GHoNPM5wl6QPbU?=
 =?us-ascii?Q?wKMKxvwA202ljBsfgBwcbwM804Z3lAedElIa/ozv7zMOz0PuQOHNLNoIqOG8?=
 =?us-ascii?Q?cRpri0uJZXv0oOpZeBxAP29WE8QxqSS+tlr4OWvp/lZDzk0HIVFvLgOi70Bb?=
 =?us-ascii?Q?Cl95Bc3aaUWswvwg1owZaETNCDyW0E4dKmSn3ijbiaNZ3tD2xbXajmMup5SF?=
 =?us-ascii?Q?KaSsMZ8vDogvRtrKRttKfVFW4PQiZln5rE9Fw9hGGgKIJNUtjf+QDTPA9bAh?=
 =?us-ascii?Q?PUFecAxrAwW3U36S0H6nlflTJ5W1HIuCE2oV6Mksuh0Kv2HpANCegfffHfal?=
 =?us-ascii?Q?odXf8NBMRgq6e7b30d2lDsZWmQ0TMsKFN0JxnTPXlYiMIw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c843c9d8-62bd-4594-c280-08d8f933df19
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:45.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jq4JXiKW4OenKKJvIUgLzCUYWLFM3RUXOHbfilvbnnf04QQ74PoPuLyq7n17bt0/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mdpy_types array is parallel to the supported_type_groups array, so
the type_group_id indexes both. Instead of doing string searching just
directly index with type_group_id in all places.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mdpy.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index d4ec2b52ca49a1..08c15f9f06a880 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -99,16 +99,6 @@ struct mdev_state {
 	void *memblk;
 };
 
-static const struct mdpy_type *mdpy_find_type(struct kobject *kobj)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mdpy_types); i++)
-		if (strcmp(mdpy_types[i].name, kobj->name) == 0)
-			return mdpy_types + i;
-	return NULL;
-}
-
 static void mdpy_create_config_space(struct mdev_state *mdev_state)
 {
 	STORE_LE16((u16 *) &mdev_state->vconfig[PCI_VENDOR_ID],
@@ -228,7 +218,8 @@ static int mdpy_reset(struct mdev_device *mdev)
 
 static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 {
-	const struct mdpy_type *type = mdpy_find_type(kobj);
+	const struct mdpy_type *type =
+		&mdpy_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	u32 fbsize;
@@ -246,8 +237,6 @@ static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 		return -ENOMEM;
 	}
 
-	if (!type)
-		type = &mdpy_types[0];
 	fbsize = roundup_pow_of_two(type->width * type->height * type->bytepp);
 
 	mdev_state->memblk = vmalloc_user(fbsize);
@@ -256,8 +245,8 @@ static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 		kfree(mdev_state);
 		return -ENOMEM;
 	}
-	dev_info(dev, "%s: %s (%dx%d)\n",
-		 __func__, kobj->name, type->width, type->height);
+	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
+		 type->height);
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
@@ -673,7 +662,8 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t
 description_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	const struct mdpy_type *type = mdpy_find_type(kobj);
+	const struct mdpy_type *type =
+		&mdpy_types[mtype_get_type_group_id(kobj)];
 
 	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
 		       type ? type->width  : 0,
-- 
2.31.1

