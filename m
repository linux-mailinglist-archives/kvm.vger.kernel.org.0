Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1388B39EB12
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhFHA5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:48 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:45339
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230382AbhFHA5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejZBAud7PTObkNgCU9gqlDNQpk8VlB/FMsnExclLV7t28x2yQdmKtAL5xZKVjoBlYVwAZ+pzm3deHiitHd3tF4+RDUDItxM6WKOFpiWhH3iB5s5aSI7y1+e0PiGAAkIX3BEiGpCLEFtT5lrzRnebX6mCgvmJJPpzTsz1pE0owLWQU+PVA0HqjsyexYKiuihmD84EoH189hjc8KI/hwXog2aX1oBvlUGHd9uUtM/QAOZiF0FBlwqY/wmgfpgiHZEFgQxZHbAxvDoZqh0vG8tood4cRiNUUcUgPobrk77V/u6u5V4rCO+WOIUwKUrnsoXddCZJH32Ast554JKj1p9c3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zNscrwBy7BNIkufnTIHhgPEyqlaxu8hhfxhrGbQUbI=;
 b=HjwPT9AuQAjy3V8+TZl1D/Xz3Bqo+bvMLNBbexMm36HLhgZwkY7QZgo1EZwgAgV8ayNOwFhqIL+OLQ85DTMu2Pd1SkWL+xDgjwD0xdZuEXTynhrT9UqWHJlaGSSDDhgL22htNDCJI6AV50FXafeBaf/hPM01JAo+fX3PNEin678OmyJRu3Id4+82XjRczgzL9DsOnNP19AtTucGpzxfzTibLGjP8Kew+61Bkn8qHfSzZMI+WNKUyb8W9wy8ZoPCsulnioQRw7mhiBHoU8fKjoL5AMRQY6IKDg0VVbDMWx3JaxqTCmOBP1Yl+Ll4TuHIFORh7fLI8VEWjqHcpHXEAvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zNscrwBy7BNIkufnTIHhgPEyqlaxu8hhfxhrGbQUbI=;
 b=gdclbAT7HjQyj58adlAt6Fn+j4Qygz2hskXvDDRMwGwnCTOKsotAdqiqgDfzcm5g/HZKYT97yoCN1sQOvpJbJg3hNi+8ffjGvOtBcOJ602g/wsZ7v4zI1PPA/kmCwGhW1riRhGVsLDx5AcULu9JNUQiJem4mUy23MTEzKP6hGJrZjRJoFty349QaZ/cHWlaONrQQax81dFXRZQAzhtoHECIHhZLqEiRojNSXt19YE/q6xwbiwcwyujK6rWLtDKTWbP/267Z7oWSDs/fz6W1SlHvEs0AXxvALJRLTOCK7lrnqPKUV6WbXa3jpZbr6M9SFFSWqFsylFw0rlid3CI3TbA==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 00:55:54 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:54 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 03/10] driver core: Flow the return code from ->probe() through to sysfs bind
Date:   Mon,  7 Jun 2021 21:55:45 -0300
Message-Id: <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0390.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0390.namprd13.prod.outlook.com (2603:10b6:208:2c0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Tue, 8 Jun 2021 00:55:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKS-G7; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8eb56a3e-8ba6-4017-364c-08d92a182aa1
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5539B58AC52E391F68A181EBC2379@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGiR1ViV2OPj9I/oHXlFe9ny2w2BXZw5NdWodO0FflOB8Cja3bVgXZQCTIaqqd8LXhhNgsCKUhJfFApS35raAacb/115ReqZD+hyItZpaLWEKcq7CPutVtLA6NK7gfOZpi1a7Z51Uui57V7PbHIZYHQhflxGZxEU7qsVaUBKRd6DDpq+V4poeO18PcRFFGiC+W6cHxHH1ljr2LsyQRse2j0JBvH3NK8t+/u4ZGBslUvwq6tsbOGmg9MF5diQtfhMuBTj4+qktUmpEonHv5IeMDfd4t8WFAjHvxHnL76KTebScwyVkpi28ywT6eOntgPD9/S2rdMFlGbtXpC1g/Q3tilt6bLrVYw2dGP0m0iZ2ABfbsuSzAhbHKAUm3yYNpaigT/vFvWc8wJ07gfmSd2ahrwvm1yL33GwDi0hFNna6OUA5Z3zSrxdT7sHfeQGDlb+u30N9JEQ8jsqmqPD5bXbJ+cZepTb76T4Jgp+WkGDkgPcnVzgPvJh4uySuA/LwIkrcPxPf0NpQfqZbfUODhvtrtTtLyhGSUVqA8u/9V3Asw+Aa1aIsMa++vRbdqETFQNGH5ppJN7DFf1BBX5JpnCSmBcqkyL1tjysoxbP9su5v+sQ0vU0vasvxcWHg43uy/HNGUWS6snA4hpHV8Jp9ainFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(9786002)(186003)(26005)(36756003)(316002)(110136005)(8936002)(478600001)(9746002)(2906002)(6666004)(86362001)(83380400001)(66946007)(426003)(38100700002)(2616005)(5660300002)(8676002)(66476007)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkikBmtc12/NPrFiDL5q1Pi4TYTS03SbesPC5cfVw5/MrhlZL9Q1O+52ItTi?=
 =?us-ascii?Q?rmMc0NkYwfsGZQPbd2P/sQqXEVd/u2GEdZwWMwFUK2/yipkbp+H2hsSe1sL8?=
 =?us-ascii?Q?CqrXOhZmaiqbTIKZ9vXjLgudQTghVl1I32OtUQ50DqLuyU20l786lbaE/2Zc?=
 =?us-ascii?Q?7kp+K77LoFUlLco5/EyaXXtmc41bykX0MWdu3K+APIEl0k9WF2e7qkQUe74m?=
 =?us-ascii?Q?wSEZy56PGIAFipB1VJLBRVtlKFIfZZTfzWLoFco+C7gEowmzv10aB7mpFJNF?=
 =?us-ascii?Q?bf905VgnXsiWJBiaA+zen/qtZVgfX+AMbswP8hHgIl73r3Ao6f35SXwKHtPa?=
 =?us-ascii?Q?zeQToWbhT06V+YyPO3TsF3s/ZYhj77kxrY7BVAEDgLg3rNZaRD+wRbcs6PRY?=
 =?us-ascii?Q?CAMR7rcYvlnFqB/jy/P5QAZrsQsfJ4CqtRwjOxowV/SzUjITJ8kNnHj6f0Km?=
 =?us-ascii?Q?MNjgUA878Y1e0IWpike64FPOsJSnrz9fbkvdB0VviEEq9ezQ1bjMD9q9OTqn?=
 =?us-ascii?Q?vz0tK6bu9+Ufbo0VQqmiRJlEq6UyXO64SGK720HNsY0HtJwchTqJ7Uw08HQL?=
 =?us-ascii?Q?mXke2RI/ZxyFFb3yLw5KoQLQfUun8chwOenJca+ITvyteTTz1D2D4S/UZhhU?=
 =?us-ascii?Q?TBQ5p60wV3X6BBpzHtWZoiYgL6cQVlf66OeBOwLHFrtjgjRTSTWcyHjngnaI?=
 =?us-ascii?Q?gXiwMW+Ka1wPestvLHz7IUhTs3zck4wkPa0h/GJta81D2Bj5Cj8oNsEG/SBe?=
 =?us-ascii?Q?S0421ML/caJEohkht+KPlvFwdqW02aqxcxMy77aEPnvw6ezhuLlF4tGUyInK?=
 =?us-ascii?Q?U0JYn4Z6X3i9KoMaBi8Ta1/7sed1T//BaFwjinqX122ViUYN61c7GK83CWsv?=
 =?us-ascii?Q?Xz0/5/1pGB4QX629Ghtft4GzPZDPNov81ECLI37muevmCd0ss84g0udrxreK?=
 =?us-ascii?Q?ooFBEC0PXGltGc+QIzLAAsNEyemb4SaI4o00cEi7tJ9EtSRi8/TnRBVpcSDM?=
 =?us-ascii?Q?hpgH56ld36F1Ht+CUjNXbsXvM49aah/7jljtXlhLRBROugJHFNLJFYJuYz8J?=
 =?us-ascii?Q?PRZDtxTlLLCUywDzGw9ZhSb+uGD7beJ5dAaOcaX+N+eyO1aJJCa16njvrmGY?=
 =?us-ascii?Q?bzH6bNazbrhNXT2l22UAXN4rwUKien/RWusQBkDzGtP5Cu7uhaO6lcxAwDa/?=
 =?us-ascii?Q?CMdomO4JqTpAQ2SnAQ4pb4n+H6M0UpzwmrVt7hjIHGwytxMOXXeg8fY0w/Ik?=
 =?us-ascii?Q?53xrhidYI9QDrE2z8SHxCs28FJL6834aDoA4otSZfqe+1iT1d/yRzudYyfUH?=
 =?us-ascii?Q?LA7upJb48yxta/MX++ndkn+K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb56a3e-8ba6-4017-364c-08d92a182aa1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:53.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64AE8JFHOtLBCX21Zo+itqY64Ipxs/b44MNAekbVdK5xSxwZTlVQ/MQuPf6J3fGr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently really_probe() returns 1 on success and 0 if the probe() call
fails. This return code arrangement is designed to be useful for
__device_attach_driver() which is walking the device list and trying every
driver. 0 means to keep trying.

However, it is not useful for the other places that call through to
really_probe() that do actually want to see the probe() return code.

For instance bind_store() would be better to return the actual error code
from the driver's probe method, not discarding it and returning -ENODEV.

Reorganize things so that really_probe() always returns an error code on
failure and 0 on success. Move the special code for device list walking
into the walker callback __device_attach_driver() and trigger it based on
an output flag from really_probe(). Update the rest of the API surface to
return a normal -ERR or 0 on success.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/base/bus.c |  6 +----
 drivers/base/dd.c  | 61 ++++++++++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 36d0c654ea6124..03591f82251302 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -212,13 +212,9 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
 	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
 		err = device_driver_attach(drv, dev);
-
-		if (err > 0) {
+		if (!err) {
 			/* success */
 			err = count;
-		} else if (err == 0) {
-			/* driver didn't accept device */
-			err = -ENODEV;
 		}
 	}
 	put_device(dev);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index c1a92cff159873..7fb58e6219b255 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -513,7 +513,13 @@ static ssize_t state_synced_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(state_synced);
 
-static int really_probe(struct device *dev, struct device_driver *drv)
+enum {
+	/* Set on output if the -ERR has come from a probe() function */
+	PROBEF_DRV_FAILED = 1 << 0,
+};
+
+static int really_probe(struct device *dev, struct device_driver *drv,
+			unsigned int *flags)
 {
 	int ret = -EPROBE_DEFER;
 	int local_trigger_count = atomic_read(&deferred_trigger_count);
@@ -574,12 +580,16 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	if (dev->bus->probe) {
 		ret = dev->bus->probe(dev);
-		if (ret)
+		if (ret) {
+			*flags |= PROBEF_DRV_FAILED;
 			goto probe_failed;
+		}
 	} else if (drv->probe) {
 		ret = drv->probe(dev);
-		if (ret)
+		if (ret) {
+			*flags |= PROBEF_DRV_FAILED;
 			goto probe_failed;
+		}
 	}
 
 	if (device_add_groups(dev, drv->dev_groups)) {
@@ -621,7 +631,6 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		dev->pm_domain->sync(dev);
 
 	driver_bound(dev);
-	ret = 1;
 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 	goto done;
@@ -656,7 +665,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		/* Driver requested deferred probing */
 		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
 		driver_deferred_probe_add_trigger(dev, local_trigger_count);
-		goto done;
+		break;
 	case -ENODEV:
 	case -ENXIO:
 		pr_debug("%s: probe of %s rejects match %d\n",
@@ -667,11 +676,6 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		pr_warn("%s: probe of %s failed with error %d\n",
 			drv->name, dev_name(dev), ret);
 	}
-	/*
-	 * Ignore errors returned by ->probe so that the next driver can try
-	 * its luck.
-	 */
-	ret = 0;
 done:
 	atomic_dec(&probe_count);
 	wake_up_all(&probe_waitqueue);
@@ -681,13 +685,14 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 /*
  * For initcall_debug, show the driver probe time.
  */
-static int really_probe_debug(struct device *dev, struct device_driver *drv)
+static int really_probe_debug(struct device *dev, struct device_driver *drv,
+			      unsigned int *flags)
 {
 	ktime_t calltime, rettime;
 	int ret;
 
 	calltime = ktime_get();
-	ret = really_probe(dev, drv);
+	ret = really_probe(dev, drv, flags);
 	rettime = ktime_get();
 	pr_debug("probe of %s returned %d after %lld usecs\n",
 		 dev_name(dev), ret, ktime_us_delta(rettime, calltime));
@@ -732,17 +737,18 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * driver_probe_device - attempt to bind device & driver together
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
+ * @flags: PROBEF flags input/output
  *
  * This function returns -ENODEV if the device is not registered, -EBUSY if it
- * already has a driver, and 1 if the device is bound successfully and 0
- * otherwise.
+ * already has a driver,  and 0 if the device is bound successfully.
  *
  * This function must be called with @dev lock held.  When called for a
  * USB interface, @dev->parent lock must be held as well.
  *
  * If the device has a parent, runtime-resume the parent before driver probing.
  */
-static int driver_probe_device(struct device_driver *drv, struct device *dev)
+static int driver_probe_device(struct device_driver *drv, struct device *dev,
+			       unsigned int *flags)
 {
 	int ret = 0;
 
@@ -761,9 +767,9 @@ static int driver_probe_device(struct device_driver *drv, struct device *dev)
 
 	pm_runtime_barrier(dev);
 	if (initcall_debug)
-		ret = really_probe_debug(dev, drv);
+		ret = really_probe_debug(dev, drv, flags);
 	else
-		ret = really_probe(dev, drv);
+		ret = really_probe(dev, drv, flags);
 	pm_request_idle(dev);
 
 	if (dev->parent)
@@ -847,6 +853,7 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	struct device_attach_data *data = _data;
 	struct device *dev = data->dev;
 	bool async_allowed;
+	int flags = 0;
 	int ret;
 
 	ret = driver_match_device(drv, dev);
@@ -870,7 +877,17 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	if (data->check_async && async_allowed != data->want_async)
 		return 0;
 
-	return driver_probe_device(drv, dev);
+	ret = driver_probe_device(drv, dev, &flags);
+	if (ret) {
+		/*
+		 * Ignore errors returned by ->probe so that the next driver can
+		 * try its luck.
+		 */
+		if (flags & PROBEF_DRV_FAILED)
+			return 0;
+		return ret;
+	}
+	return 1;
 }
 
 static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
@@ -1026,10 +1043,11 @@ static void __device_driver_unlock(struct device *dev, struct device *parent)
  * @dev: Device to attach it to
  *
  * Manually attach driver to a device. Will acquire both @dev lock and
- * @dev->parent lock if needed.
+ * @dev->parent lock if needed. Returns 0 on success, -ERR on failure.
  */
 int device_driver_attach(struct device_driver *drv, struct device *dev)
 {
+	unsigned int flags = 0;
 	int ret = 0;
 
 	__device_driver_lock(dev, dev->parent);
@@ -1039,7 +1057,7 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 	 * just skip the driver probe call.
 	 */
 	if (!dev->driver)
-		ret = driver_probe_device(drv, dev);
+		ret = driver_probe_device(drv, dev, &flags);
 
 	__device_driver_unlock(dev, dev->parent);
 
@@ -1050,11 +1068,12 @@ static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
 	struct device *dev = _dev;
 	struct device_driver *drv;
+	unsigned int flags = 0;
 	int ret;
 
 	__device_driver_lock(dev, dev->parent);
 	drv = dev->p->async_driver;
-	ret = driver_probe_device(drv, dev);
+	ret = driver_probe_device(drv, dev, &flags);
 	__device_driver_unlock(dev, dev->parent);
 
 	dev_dbg(dev, "driver %s async attach completed: %d\n", drv->name, ret);
-- 
2.31.1

