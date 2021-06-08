Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817AE39EB1E
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhFHA5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:54 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:45339
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231295AbhFHA5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljuUipffp4LeVbQGCJ7sq6yptLpboKdO72Hi82ggs2Q4pg5SDFE09ykigRYswAK8t2Ur53BWfuUk4H6sgsFnirgQMuHXqXVmVxzrSBASg/jg6j8XVuNXAYASuU+wrH6YngHF9hZX4Fngu9EDb0ovo3nQipNNb46Ex7FpYp6W7jryjaC9lA7DSWFZcVM+y3r1tZzcLPqGTaeCApXoux0VhAsg2N0rw2+IeWUh9uonXWUMEkeIRw/YGtfhNZTLIdXJY5ljppWKfYhX2vPFAy3ncPpw92TIpBLyqRBU1azthzdoUZ2SOqqKkITggcu68lh61g9ji372KLYb1BO8NmOuXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJ8tRREbXzciCpeaClAgBQMttdC4ihdILwMxB1U0lM8=;
 b=edfucHWQFMjWcXhJpOWR5VJnUzea1IxvDAXe/UmwDXyIBOan7UeT+lZ1NMY5UJ0QBpI9dQtv5erRmc21t+91RfWbkd+kp4kXix9FM8msafJsD+ZfsiCKIYzIdoT7rqQ47sh2lDC2Igb2cLu6WMMeASVWcaQxqEpQGtZMqJPOpiNeOCdw3ME334Sq3ZHruikpk5aXZRMmTWxk6Hld0bjNhm02drRfX0qz0+0vBgq/IRvcf0jK/Vu/pxiw5MpCDjYA7PrIXTL+X7ysElJ3LG0B4QgNWl5SodE6m98Kci2h/Tw207xzekFAgw9jtGvNLww4Sq8OkMb5sbgo5Mi7I9aiIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJ8tRREbXzciCpeaClAgBQMttdC4ihdILwMxB1U0lM8=;
 b=XLvdfGIL7F1D/zYUeSPlNGlYnb8s76q+CBw5rw4bErs5FhX2Kz41/jfqe445cVsT+p6VaJJP9ZkTXoJCCfjstsO7OXPeSgt7pDlOV8cpugyUzmi7ggsWHZXZF2rvmbkTYTWGa3OiPId1UoymWc0yGNlc2E9bhcI7dv+Fw+qiIVVzfLWdsH1+9eAJps0Ro5W36C/ic7cAzMkkzV1EAudcj2QyPqer8bPZwRiUo3lCKgkK+c6RGpSab/Z0xY8OHlqTIXjtziobeuR60nDsXwC3j7kWtNA0dWrGxpJ/z3rfT2zz9jx/NAxAqbMx9NzIrYlKLi+clLGgaPPqHqDKOlXEqg==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 00:55:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:55 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 04/10] driver core: Don't return EPROBE_DEFER to userspace during sysfs bind
Date:   Mon,  7 Jun 2021 21:55:46 -0300
Message-Id: <4-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0252.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0252.namprd13.prod.outlook.com (2603:10b6:208:2ba::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12 via Frontend Transport; Tue, 8 Jun 2021 00:55:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKW-H5; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d3d86a3-815d-4f0e-e3a9-08d92a182b21
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-Microsoft-Antispam-PRVS: <BL0PR12MB553904797C3B856247034A92C2379@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TzH+9m6RLUz+cd5Vbvqj3/iwnsm9o/U4gCmbxC/XORCiC8SGyHfbv5WV6ryeBwtyC0VVH67ucOivj/2igYQjjc7j7He5TzonBD5n1TOISZlHwkWo1IHO7VYM0oI29eZhChk/iquVFDtAZYQLN8Hq8Uy8PywKLbZqd1i/zrxQzKsgM7aHbOvfCvZ6D2AxPq5Pi1E+JsskQM4cWuKPbOOs8A0Ob5wGlfP4wErhUoneamsY8CYE4MucKSjkAqk+jvyJyrG1OEdapotUAytOyGOTB1NkkGSKTue3QgerZzxPVbjkshxxwDtvR+3XbH90X35kn3G7kHBfrNx+XAylYYPHTNAua+213vNPGCDfE9TvriaIMu+OZn0wy/3punVlHqN31iIIXYud1AdbZJRKKtgfj3V7nGpA3PsUvIYv3BnydrXKbCLlaYj7C3nKonNNVHG0wN/HYQTvfYEoOKYfajUH1beIP5QpGIcbcoxnJS11E7AYa4qRmOxN6m/4SEDyixG/f1sd0hazs2ZlGaFav+JtA5IKp8okzmOPWCT0y7v2XDGgHANvlZKx0GtWpP3b79wj6xSH7TlwOe3BDHBJe+R7+R/gDvScP1uJX73u1JKyrG83R4dI8fX+L0LboDiN/0SuiptIAqtNinMoAY03mmDnGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(9786002)(186003)(26005)(36756003)(316002)(110136005)(8936002)(478600001)(9746002)(2906002)(6666004)(86362001)(83380400001)(66946007)(426003)(38100700002)(2616005)(5660300002)(8676002)(66476007)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p7ybQ9PyDWdaFK525m0ZmP7cJiuFp0q1hY5M4DTY4JxSg8Z86wv1mLMxzK0d?=
 =?us-ascii?Q?0rftVcFFhsgahedzTGFW/r6gv6tSdzAhEKL1oHHPuFCcOMllqRbc2jYslcD5?=
 =?us-ascii?Q?t3eK+MiYZEZdlwxzQyEp2kEwbz7JfhifKznpSASEr0nCGCEJTTHiDe2uM6w/?=
 =?us-ascii?Q?Sdm0YPmT0aHhRXKJ94ImGg9dIFylzcMID0w/zgbAXAFCpoXtM9gKFSvB1bqc?=
 =?us-ascii?Q?9xY6iJWh7aufLYaIvFSrRgiOp1M+1PJt4V/DCXYiz54ydLkR1clsNrCokpns?=
 =?us-ascii?Q?UXAk4ra2bXpvbKH8Xh7ZH8eaAdP++WPbtI/PYbJCgZOWC/0XWK68uuW0Gp9I?=
 =?us-ascii?Q?7jOiD/DKMkeNN3hJ3kaJDvJHIh+7JpIILN9PQ9sj1tgK0sDbPGCfFeCPkvqD?=
 =?us-ascii?Q?07DtJJGIfDMBTyaUi6jAviQ3pGHrpgSVuCz2qLnj7zOqo77hwj/7hDZ2CNiC?=
 =?us-ascii?Q?y6BVHZHCpH6BGB4oYVPr/l49B7Eo8bcoI/jKaWeaWOmsnDOcw6TkKYRuMPE9?=
 =?us-ascii?Q?JkSPmRIZ9/YjjJiyRZ2DdxieqZiZ8PSHMtw+xfwbZGFHzqV3N7t+5n5PtBgW?=
 =?us-ascii?Q?w+aWhbkjB+yIm37tTk2gQ/VJJ0Yv5zQasorltYGVNtQeBiJPaoyMYjrCnJIl?=
 =?us-ascii?Q?Bsu3bQmg3YVy6XVwWM8MrMGYHsrSG9u0JAxUMwlPnNBV5W4BxbvwL1wgVzEL?=
 =?us-ascii?Q?E+wP369897t9U99JVW17Zqkd7ZsasH6y4vupaP7FnT2JaDWyERwjz71fI3ig?=
 =?us-ascii?Q?+z8sW35huxW+i1LaP/M53r1G2p2iFVzjXu8q1QBIyvrlGdCuIZQIxy5l4Ssg?=
 =?us-ascii?Q?Gur5xI1UMlTzjHRM/cmgXVWgMKDS4/B6DNpUpuEhGiODNhkY8kIaaM843Hql?=
 =?us-ascii?Q?V1VeEnqVxCqEtADBd/daNmdcZT/RCTJL3D6Zkfhtwwv+LGAM8ZkQ/dsUwuur?=
 =?us-ascii?Q?RiNmh16McPEi9XX9VYoUNN36kz1U9vQq7FHjHnoQ3SBdxmqLamq1f0f1yfBg?=
 =?us-ascii?Q?Bj8atuJjiAVYS+WxdnKicKy/EwdEN+MT2iBZhKcFjc0SvtPv5pspSY/43Zwq?=
 =?us-ascii?Q?P6d+EkOnLkbR4tmjWlFES4OnOhKhBWaPoBE1j5ta544yhl7mTudnjVR3oMre?=
 =?us-ascii?Q?6xD7hnDBZ/EqJWmEagf6ivKJ0wZlwhA5g5s/qkg9jd27+yBwaf71ljFh2Iav?=
 =?us-ascii?Q?3+jUtyV+BJyJVROGflZg9kOIr2MiJi57E0JEVKCaVUDVVbT+E6hI9jcBVTwk?=
 =?us-ascii?Q?cpje5mkCMFszr/DguAZ8pnENkZiOQlOFy59hWCZfE+xDDWRylvtAPzuz1m+q?=
 =?us-ascii?Q?2O9N+zsz2LSzPV2kpnlLj0F/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3d86a3-815d-4f0e-e3a9-08d92a182b21
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:54.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /By7hb9n+YM7byv1iXwLXmmJYXzFKlIlHzN/U2Yueo1MX9WO1oGSzYtbIHw+CwJ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPROBE_DEFER is an internal kernel error code and it should not be leaked
to userspace via the bind_store() sysfs. Userspace doesn't have this
constant and cannot understand it.

Further, it doesn't really make sense to have userspace trigger a deferred
probe via bind_store(), which could eventually succeed, while
simultaneously returning an error back.

Resolve this by preventing EPROBE_DEFER from triggering a deferred probe
and simply relay the whole situation back to userspace as a normal -EAGAIN
code.

Put this in the device_driver_attach() so the EPROBE_DEFER remains
contained to dd.c and the probe() implementations.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/base/dd.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 7fb58e6219b255..edda7aad43a3f7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -516,12 +516,17 @@ static DEVICE_ATTR_RO(state_synced);
 enum {
 	/* Set on output if the -ERR has come from a probe() function */
 	PROBEF_DRV_FAILED = 1 << 0,
+	/*
+	 * Set on input to call driver_deferred_probe_add() if -EPROBE_DEFER
+	 * is returned
+	 */
+	PROBEF_SCHEDULE_DEFER = 1 << 1,
 };
 
 static int really_probe(struct device *dev, struct device_driver *drv,
 			unsigned int *flags)
 {
-	int ret = -EPROBE_DEFER;
+	int ret;
 	int local_trigger_count = atomic_read(&deferred_trigger_count);
 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
 			   !drv->suppress_bind_attrs;
@@ -533,15 +538,18 @@ static int really_probe(struct device *dev, struct device_driver *drv,
 		 * wait_for_device_probe() right after that to avoid any races.
 		 */
 		dev_dbg(dev, "Driver %s force probe deferral\n", drv->name);
-		driver_deferred_probe_add(dev);
-		return ret;
+		if (*flags & PROBEF_SCHEDULE_DEFER)
+			driver_deferred_probe_add(dev);
+		return -EPROBE_DEFER;
 	}
 
 	ret = device_links_check_suppliers(dev);
-	if (ret == -EPROBE_DEFER)
-		driver_deferred_probe_add_trigger(dev, local_trigger_count);
-	if (ret)
+	if (ret) {
+		if (ret == -EPROBE_DEFER && *flags & PROBEF_SCHEDULE_DEFER)
+			driver_deferred_probe_add_trigger(dev,
+							  local_trigger_count);
 		return ret;
+	}
 
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
@@ -664,7 +672,9 @@ static int really_probe(struct device *dev, struct device_driver *drv,
 	case -EPROBE_DEFER:
 		/* Driver requested deferred probing */
 		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
-		driver_deferred_probe_add_trigger(dev, local_trigger_count);
+		if (*flags & PROBEF_SCHEDULE_DEFER)
+			driver_deferred_probe_add_trigger(dev,
+							  local_trigger_count);
 		break;
 	case -ENODEV:
 	case -ENXIO:
@@ -853,7 +863,7 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	struct device_attach_data *data = _data;
 	struct device *dev = data->dev;
 	bool async_allowed;
-	int flags = 0;
+	int flags = PROBEF_SCHEDULE_DEFER;
 	int ret;
 
 	ret = driver_match_device(drv, dev);
@@ -1043,7 +1053,9 @@ static void __device_driver_unlock(struct device *dev, struct device *parent)
  * @dev: Device to attach it to
  *
  * Manually attach driver to a device. Will acquire both @dev lock and
- * @dev->parent lock if needed. Returns 0 on success, -ERR on failure.
+ * @dev->parent lock if needed. Returns 0 on success, -ERR on failure. If
+ * EPROBE_DEFER is returned from probe() then no background probe is scheduled
+ * and -EAGAIN will be returned.
  */
 int device_driver_attach(struct device_driver *drv, struct device *dev)
 {
@@ -1061,6 +1073,8 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 
 	__device_driver_unlock(dev, dev->parent);
 
+	if (ret == -EPROBE_DEFER)
+		return -EAGAIN;
 	return ret;
 }
 
@@ -1068,7 +1082,7 @@ static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
 	struct device *dev = _dev;
 	struct device_driver *drv;
-	unsigned int flags = 0;
+	unsigned int flags = PROBEF_SCHEDULE_DEFER;
 	int ret;
 
 	__device_driver_lock(dev, dev->parent);
@@ -1083,6 +1097,7 @@ static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 static int __driver_attach(struct device *dev, void *data)
 {
+	unsigned int flags = PROBEF_SCHEDULE_DEFER;
 	struct device_driver *drv = data;
 	int ret;
 
@@ -1128,7 +1143,9 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	}
 
-	device_driver_attach(drv, dev);
+	__device_driver_lock(dev, dev->parent);
+	driver_probe_device(drv, dev, &flags);
+	__device_driver_unlock(dev, dev->parent);
 
 	return 0;
 }
-- 
2.31.1

