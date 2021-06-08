Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5539EB11
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhFHA5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:47 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:45339
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230266AbhFHA5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpRHwTKFQwNAonIVpXscHQ0Pxdl6N0EPGDU+48pJOr4t6GsoCgik3ORJGjDXSTnhwDX5hQoQZJv4na9wT3S4ps4O+f+UyGphrmPc93a9wMHana3p+D5vkIqzTT0orkvyZhPxINHO44Wb/uQ6j09J7gvF6mfR49HY39WTudRtpPVD0SMsHLeIWEx3DCXe9u2SLq7VYGMseBfmV5IYHrUNpbZ9Qg5YklgyZSihyYTi4ozWDs591VehfU3c69ibiUQy9wSfh57K1rCY5pukEi2yo+ABd4j504h+d6antxR800GnXO/cqQVpNRJLOEyke4iRxfUoUplZNdzZDwGX/Lk9Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XNqK5gMVn9TXVQ/donIWzsg/nEgmHcimerldaIVuko=;
 b=W/hWs7hWm4yiVNc08cYBIm//nakMq4ysuPooUmxpS98tfvWZXx2fsayHWWTFOozGdIMYkcESLvNET/SoOQq6glNKQ5R+adC4V6x5AMwCCfkUGrgXluVK4DSrPkJ/wcg9aFYXY+3EnO1A5OcrZBXr6HcoRZTxigo0K1DhDTFnqDik1ZKUQv4DwiFfEF+vxKyu0Jci2eq1W2kx23eKFjfHwALJpwRUn3JF7PCZn6I/Bxh9C3SOwMdIfBSlBUANKV5EG016XHiQzXeCcO8EDVo0Oga9veVCq1lQfqxA+oHPWlKruWa6AFT8olo4Dz4DFw18Ii78sjO9axvBkfQPIYgOMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XNqK5gMVn9TXVQ/donIWzsg/nEgmHcimerldaIVuko=;
 b=MxluVSnU9nJxSGhU+VoM/70EyPoyCFH3jfiMuctpgpRtHjgTGuMqn/OkxKvMr/VKJvxMFeOgAMxO6zjcf00GDeOfnrxia6kH37oirHrAX1YEeKx4I1reK4B8MmJ/yOk/8kxlh/JVsV9F1Uyvc8cv6DMaSMCFdy1km7GdAw7GdUjrq5yZ/S02VnEcTkRG8LC7qemgxCF1NMdJ7TLzczO683goU/QGW4gyrUxWYwsmpKoNW9jjq8jvs4rljinM5jTXT4170Iw5CQ/QuDB20A8r4J8BXc0UGf040jBP6GP+eFvI/4R3KfLg4ErINuT57vNZNFsP9gBxnCB1Un3tv/iKMA==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 00:55:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 02/10] driver core: Pull required checks into driver_probe_device()
Date:   Mon,  7 Jun 2021 21:55:44 -0300
Message-Id: <2-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:208:a8::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR12CA0019.namprd12.prod.outlook.com (2603:10b6:208:a8::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Tue, 8 Jun 2021 00:55:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKO-FI; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4561265d-7898-4826-a48c-08d92a182aa3
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55395760416DEA8E82BBFCD1C2379@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qZ7Tz+LI4BZxJTRy1chLpKDu61VEUcr0wsi1XVP26xp6sjO++bZKDzRbFtJYJkMI83zNfqg70LSMw7qnG1T/zwVaK1m0A7Mb8LIIIl2gjG0qwQ3+/mNAhVj2fa++Wy/6ZdL7NKZZYmk2LslRoVtEevFPW4fBF7JPqLz24B+rVrk/Z1VQ+C0zk3mtRQaQj4mdMWCgwOipOG+syg6mTpgeVJ7ey/WgeRAZJcPmPeRt8W4xs7BbCZLtj2zLX4kOmhkG8ldx2dN60wlRr+InHp5cfDpgaLMHuaRYNzM/EWLsArWlLwIiVgvMO/F5+ndcRKoN4pR+zEscnvvaS0sGPq2frwJypU7CNeN0CIdOuJcIAHm4syJSSQGORP4pE4R2QpmvVvkxEmEj7k2Myw7+GGVv84u9j75uV1OoBHmsRuWOxDT5C/ndzpRKoSLZBtcv85pq+TUNDOyWiC4RAzw9JdNFund676rQOkEP/NeUa4wUK1sNM+jwHeemB5MInkKrKDGz98vPkH/bdLmwM96PSxbs3I95h91rHPqz/YQnCs0I+HTw79p5eLoHyO7y/7BeZ6Zc2AsLWZi9VfkZdM+4FHeLerF33ayJNis5ELxsiXac9ekqFmraLMomgdXqWbCItMDrGhyApnfYy7aFisSYj/jIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(9786002)(186003)(26005)(36756003)(316002)(110136005)(8936002)(478600001)(9746002)(2906002)(6666004)(86362001)(83380400001)(66946007)(426003)(38100700002)(2616005)(5660300002)(8676002)(66476007)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mbAdlOKuFhiwV6v+CqQfBnik4xRlv+76zodXBzglIIXS44wBr+tGDG1nn19t?=
 =?us-ascii?Q?o6jtDih45QxoceAkO2KTBRsFa2WQB/w+LR/KCajcOxN99aewrYZpcP1ngJjS?=
 =?us-ascii?Q?WnKV/z+NbBMhrW+/VQ85xmiBagWZuTTmiv3L/k2I57xjT7Jlrp41vt97RRZi?=
 =?us-ascii?Q?IN/vf16qJxuikmaKlyifPc3p7o+lsJJV+ic/KEWhzEa8yFqv2t/AVqvWPWAF?=
 =?us-ascii?Q?cjecyBRwePd4QCpe3Kg5gU/v2WQYTR0Yy622FrogYi81iKASrOpGqbHO2Vfl?=
 =?us-ascii?Q?uXexO9OGeiyF5+vAeZN3nb5/roFSq1R43GzaIy7DGHfjKl0f51fUEuGjCALe?=
 =?us-ascii?Q?BbKfpqBgTkmXEHHvoJetxPv07QuMntoBzPB1Vctv7hH7uR6SVoHVXx8zl8LL?=
 =?us-ascii?Q?LsKUZqm3O3dxZjajHfWFVfDTJuWzdQjIKof0UBekVCOiGSMCj3TJ8zsC0hcv?=
 =?us-ascii?Q?vDS9xyaQg3SK7oS91ICxip/Chb6r28UxVRiHvbciCVK59+x31x8kMg/8QuzV?=
 =?us-ascii?Q?oYNFEDPgOTpM0Z5rE4t/syGCvETLrDZ39JYJMe/r8IadvktcAN6cD3aLy5ec?=
 =?us-ascii?Q?7+rO5Nekjx62WmTJlKwZzQykENMmv/Z8F4RQ+nJ6tb9VJJtAvEpDYmpOF26r?=
 =?us-ascii?Q?oTs91xtS7umpkTWLH/fRAY6GMTaCM65myOpjIKfxIXPLYiF1WBMbHuh21Rxa?=
 =?us-ascii?Q?E5Q2n0eVCdjHGLr8taE64OAN0AyuVB1uiIN7M7FDsH+2lihhBFbgsxsYBErI?=
 =?us-ascii?Q?OSv171kBtGiII6eL5dF0a9e3xwuS+ixUmK7Xq26fRl8l4GXS3kBLHwWrO+7d?=
 =?us-ascii?Q?4Q0j4hXWzSSB5n27wicyBwa/vDdCDExtM48mRXn95eLRjuM9Mlpx+lC+jecc?=
 =?us-ascii?Q?CRZenXQe5uL7JkdawBRJkFFnlapegpeVR9pXCTH1n+rkNCEKIt4FGY66SjLK?=
 =?us-ascii?Q?FkgJgsHazSzJiFU/K0IRZNG0d3BcMZ+bUj+PjipCMLn9gVelhtrZxNxUB3Fm?=
 =?us-ascii?Q?bnFDuGcJkSBcK1h8b+xUYEKW8+eGx7b+adnYsE2M5wDTl1r8lSeOJHsG8xPj?=
 =?us-ascii?Q?nMmvZB2DdSNnIV3aYZ5QYBnwsv6Yyin83WkmsW01cHFRkjYYNoreurKbynIA?=
 =?us-ascii?Q?LuQ131m5u8GLIC7UBLTBJQ+DBKuSmQkMbWjluw7eZW/otFezUzv6LMUbqsS/?=
 =?us-ascii?Q?paQtW1A+IoYjrrVJsCPSTDs6vybS1FZRqcwv0yw1mwH/KQlykqYUmskHpI4Y?=
 =?us-ascii?Q?9ir47oI/jZcpyP4TZnCnqHOPFqFdZ+zjkNW+dZp6ZP53Mq4t4/Hiswq06lqz?=
 =?us-ascii?Q?HahEeRhiacTd3ZSGqksYWyi6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4561265d-7898-4826-a48c-08d92a182aa3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:53.4735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PA7vnBQmsLJujZuHeGBWy43OxTFnKpXd/8tTYA0KBoyY8LUJk7gc46pxYPlCHWp2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking if the dev is dead or if the dev is already bound is a required
precondition to invoking driver_probe_device(). All the call chains
leading here duplicate these checks.

Add it directly to driver_probe_device() so the precondition is clear and
remove the checks from device_driver_attach() and
__driver_attach_async_helper().

The other call chain going through __device_attach_driver() does have
these same checks but they are inlined into logic higher up the call stack
and can't be removed.

Preserve the sysfs uAPI behavior for store of succeeding if any driver is
already bound, but consistently fail if the device is unregistered or
dead.

Done in preparation for the next patches which will add additional
callers to driver_probe_device().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/base/dd.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9d79a139290271..c1a92cff159873 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -733,8 +733,9 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
  *
- * This function returns -ENODEV if the device is not registered,
- * 1 if the device is bound successfully and 0 otherwise.
+ * This function returns -ENODEV if the device is not registered, -EBUSY if it
+ * already has a driver, and 1 if the device is bound successfully and 0
+ * otherwise.
  *
  * This function must be called with @dev lock held.  When called for a
  * USB interface, @dev->parent lock must be held as well.
@@ -745,8 +746,10 @@ static int driver_probe_device(struct device_driver *drv, struct device *dev)
 {
 	int ret = 0;
 
-	if (!device_is_registered(dev))
+	if (dev->p->dead || !device_is_registered(dev))
 		return -ENODEV;
+	if (dev->driver)
+		return -EBUSY;
 
 	dev->can_match = true;
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
@@ -1032,10 +1035,10 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 	__device_driver_lock(dev, dev->parent);
 
 	/*
-	 * If device has been removed or someone has already successfully
-	 * bound a driver before us just skip the driver probe call.
+	 * If device someone has already successfully bound a driver before us
+	 * just skip the driver probe call.
 	 */
-	if (!dev->p->dead && !dev->driver)
+	if (!dev->driver)
 		ret = driver_probe_device(drv, dev);
 
 	__device_driver_unlock(dev, dev->parent);
@@ -1047,19 +1050,11 @@ static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
 	struct device *dev = _dev;
 	struct device_driver *drv;
-	int ret = 0;
+	int ret;
 
 	__device_driver_lock(dev, dev->parent);
-
 	drv = dev->p->async_driver;
-
-	/*
-	 * If device has been removed or someone has already successfully
-	 * bound a driver before us just skip the driver probe call.
-	 */
-	if (!dev->p->dead && !dev->driver)
-		ret = driver_probe_device(drv, dev);
-
+	ret = driver_probe_device(drv, dev);
 	__device_driver_unlock(dev, dev->parent);
 
 	dev_dbg(dev, "driver %s async attach completed: %d\n", drv->name, ret);
-- 
2.31.1

