Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43E839EB1C
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhFHA5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:52 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:45339
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231283AbhFHA5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CE/4gVUC8HXSzhwNOc0k1ASMLaUpPBxdX//IeF1/oc2ImOBfwBdCW6QL0s/HMWKcNe5LS3dAue/aCmHjMKwHg2J+7cs8ozS1CBnYny2RcVMkUJYCVdK5BK4UHjJYPLYu6NKWloLjrBUDGSt6m9J6u5JzTQXpOx++HGL4aJsbbD6Fum8/WwIGqIjxSt5EcgpmKQmPTV3OJSEzkaauuByxb/+JI+297Bb10epJMkwAAIzKrmSAxJIuxjho1lfl+D7lQAH0EgU0Q3IT7zgOSaRRWF+D2Dmbgg/qUH5FClB1nxk+iN6NH0GdZBFayroo6uge1IKd11MwiKbfr2cmnDY3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Ix+R4jEwhvzrwBmdWPBSZUKcnvnwI9m1C6x8Q1R8Xk=;
 b=BCW6QdSkFgDRmhG5NGq6QBLfHGmGr+/xUxFH+JlY97E7kzXLRNLV3wI9DYpIHdNH3bG4Y6WTNqHiFB/7RnFTlrl2Rcb8ojhknafLka5wjvwlSnp9ae5/j6B/A2V+6MmPSm+qybXbW/AZeZlTLcr9xzE8ylucfMH+bjoOaGj1e0Z8q99pyNOw7el5z0nSktz61MI46IFcxzCcHcg5TBwb6GbyNM+4cuy9P0fJteECxH+ZY0ooJhJx+xumBoY55PU/9XWiHmk19ViQQVqeLWPGO+m0zJpKfxCBv7XBOQoQsVvCWSMQQFVoUdJdHiKK59b4l2Spv6W+y99XVvEz9Th8BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Ix+R4jEwhvzrwBmdWPBSZUKcnvnwI9m1C6x8Q1R8Xk=;
 b=RCn2+n9Dmc6OxEoAHeLYXP/Kkc312KbuWICVuE72hUa2gVRA/+pD+Yvz7csf5b6ZIyS8QbqC8JelR0bNbyNwu1VF07F6e/2eupGTku7q8yw1Ltqj4WD+6868XBGUhf6VDdb05ETvp5sXUpYCP36YkdfRslv4wg3DQrkVGLBKGHG4CG7JiB3KeTEskQzSfp286mGFgMKNzfsLiW9CuUJxJII9EAShjj5Zsa7BU60Kjc9i6cGtrdV832Y1jwyfMT9NnXTmw19J8pgAbaKgPw8w6P3X3gkggLWTVwHji6um/1ueQCSUz8gUYRBgrgtYBFI++xGkmpMa2v1T/fEe5tr/Ig==
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
Subject: [PATCH 05/10] driver core: Export device_driver_attach()
Date:   Mon,  7 Jun 2021 21:55:47 -0300
Message-Id: <5-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0259.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0259.namprd13.prod.outlook.com (2603:10b6:208:2ba::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.11 via Frontend Transport; Tue, 8 Jun 2021 00:55:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKa-IM; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d62b007d-91ea-4c67-00bd-08d92a182b1f
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-Microsoft-Antispam-PRVS: <BL0PR12MB553991799B729BACC72A1C7FC2379@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RzdSBAmRk88MUGHREpp1vZy3Th05Z1vMAULe2500BAbTJnlzFb2D3SdAoGIWZoQuPIUVchimNa0idOEwkOexuajYVp8mfQmVkxBAIRGfKWtlFio1mmVzapq/idofwVIwZaTY3XtZyJs7JFUWI1WgbITYwmkNqDfyYABm7pdRW/1P4MqQSFrjfNclhZWJ4dBBj6wW6gLbPcLT3caH+PNSbcgDMZ6SYpjmO/6Lx4zJditZZumsqHbctk6VPmk5zu59MNO8Rls6Nk2/dfk5lk5THeWPoY4qqUR+Tn5LHkz7nwhjmR+Iqr1dwWg+rk2/cAu7wf6b9oODZNQm2fPzobTZqrt9RjbKCX3YgQT44rHVWiqOWC62VUzQa31t7Jx0sZEQN4HOpwgR25Yl8/O0zT6N1D3nuglN16/u+WD6o/0agweB0ltibe3akCNKofUj2gozTRkzLIHviitftqOwtKFQbfJDAwE7I5uXxjmVpinAn/u1Ub14wQI+6U8Bj4RgzFfrXwPfN1xJwt2R2072xQDiceBliiWrTO/3EDkr0h1AnYF+xnh8ajwDMpvtnGz58tJacrg1gskP1yiJ1WWWcZ2N3n/Ch6cDdj6WnEQjOvZQW/mqHBZ33rGNil14duBTDwZtuIDGTMlogopZkykvoKHrWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(9786002)(186003)(26005)(36756003)(316002)(110136005)(8936002)(478600001)(9746002)(2906002)(6666004)(86362001)(83380400001)(66946007)(426003)(38100700002)(2616005)(5660300002)(8676002)(66476007)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?srDRx+WmPss1c55RBAO/xotQMOfBYeB5DeBcFgME2rbW/dduuFosDQTqTcwc?=
 =?us-ascii?Q?HoHUqiB+YZ5RYO3FKTWy2Sq4tHVxbu4Vi1AQV8lL9GbwaZX8VnSDngYr38s/?=
 =?us-ascii?Q?EiIcXpY96WyPUcrgE2R2uyx908czokHXlaVLzmGS4NfdXVFMieH0WopMZ+MH?=
 =?us-ascii?Q?Z4HkvuIzDTonjCxXMz12ADHZjVgQrXtw6Cu7VKSKIXlzzWrp0Bc/2GmEVn7X?=
 =?us-ascii?Q?zaS3D27utH7cajcnG5uXXYGJfboXbXIBJqFpSOxsmcP6X1+u/rIY2Jfmxb2i?=
 =?us-ascii?Q?D1TgjTfUHjTQhfJSCVj+vYydpUnXrW5RJF2+FbiK43T06lKFEcJWpLiw2DiK?=
 =?us-ascii?Q?387kyYwXhrx5WAkKYrYz5f6TB/foB5ZrqNJ6YuIgkxoO4RLZwrTdjXFE4nXM?=
 =?us-ascii?Q?eviu+fGt/wK0Qp/nQ2LEAOBTwQVS+YXiqjwWDFYSueIU/cH8s7+IAo1nASIx?=
 =?us-ascii?Q?t93INmQu90o4EyWIfYmBVSGCeffMJTrPrOGG8PY9y9rHHcU+JwIgokEHFgc/?=
 =?us-ascii?Q?ltNwhs14rvOw67Fs6gvnBWboYW+5kowF7sRm3BfN8f0laMH/EH+KXvk/cVoM?=
 =?us-ascii?Q?JjDT2rwab0hzbr6jE/BspFA8WDK5+wDLawOo3iKnb81xmOgRFkpPh1OTallo?=
 =?us-ascii?Q?IZIOW62lbyHezDKFzhaXRiYNpMu0Eepx1kLVzKVptQw6Dz81oEBTyEZ16Kr4?=
 =?us-ascii?Q?PvFPzNWy0yvzyzmdEbmwI0okpkQzfFNBO+BC7/Aoxx4f1Gn2QCcvIEemahzh?=
 =?us-ascii?Q?X0xuAf+BZ6qyFCKA9EEFYXYGdV76jDdKibvd+NH25PE8wFVm5PV8W/T2Iari?=
 =?us-ascii?Q?2+wgYDx9rvUni1U5ks8ejsH8rN9ZOvv8UL0ZckRY8QTJWyEQ+fCMv9Mtw0Ov?=
 =?us-ascii?Q?hR0unjRBfOCuAn9RyOojCd5NPkWWEcyw5IBqAQ9EbCXMgPXggkh2qbHkXdIs?=
 =?us-ascii?Q?vN/HCwn2Yeg2tkMkSyU7YYAeEcUqHCIyXnqn7VEw6p01r3+bpPS1HPL+PmgO?=
 =?us-ascii?Q?ea/z/MAH9Z6kR+jsax88q5nZeA6LcyVRjhVIMO5YF8a6n/ouOPBXooRY6Ldo?=
 =?us-ascii?Q?MnbO1Wjr7pfq3VTRZ4FFAXYeLYEzqJD71m/CgRZrfLLFrsAXcMPFo0ynJuv1?=
 =?us-ascii?Q?H0XCobF+9CQkKTEskJAB167cWujLjol8NPOTesH9DMq/wvezN5YWEW5II4w6?=
 =?us-ascii?Q?gFF5ft/jBKJE4LEGtwNQoRyfZzKXXvwyupKnmrBMMJ0qI5YhTdO5GYoNxAHJ?=
 =?us-ascii?Q?0wpTHSPRyqvd5e3iGbQ9r//ehw5w/jQCEovm0rxQ0NNxmGuAq7CKtQC6xKlL?=
 =?us-ascii?Q?sCkJdsV60RDEBVxqKGd5dtwD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d62b007d-91ea-4c67-00bd-08d92a182b1f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:54.2182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrUR60jv2/cEZa1ZYBkhlamV5eMrR1VZZGtVzDO5cwVCA1o8cInrmSqy9F6P06Rd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is intended as a replacement API for device_bind_driver(). It has at
least the following benefits:

- Internal locking. Few of the users of device_bind_driver() follow the
  locking rules

- Calls device driver probe() internally. Notably this means that devm
  support for probe works correctly as probe() error will call
  devres_release_all()

- struct device_driver -> dev_groups is supported

- Simplified calling convention, no need to manually call probe().

The general usage is for situations that already know what driver to bind
and need to ensure the bind is synchronized with other logic. Call
device_driver_attach() after device_add().

If probe() returns a failure then this will be preserved up through to the
error return of device_driver_attach().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/base/base.h    | 1 -
 drivers/base/dd.c      | 3 +++
 include/linux/device.h | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index e5f9b7e656c34b..404db83ee5ecb5 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -152,7 +152,6 @@ extern int driver_add_groups(struct device_driver *drv,
 			     const struct attribute_group **groups);
 extern void driver_remove_groups(struct device_driver *drv,
 				 const struct attribute_group **groups);
-int device_driver_attach(struct device_driver *drv, struct device *dev);
 void device_driver_detach(struct device *dev);
 
 extern char *make_class_name(const char *name, struct kobject *kobj);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index edda7aad43a3f7..9a5792527326b7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -471,6 +471,8 @@ static void driver_sysfs_remove(struct device *dev)
  * (It is ok to call with no other effort from a driver's probe() method.)
  *
  * This function must be called with the device lock held.
+ *
+ * Callers should prefer to use device_driver_attach() instead.
  */
 int device_bind_driver(struct device *dev)
 {
@@ -1077,6 +1079,7 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 		return -EAGAIN;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(device_driver_attach);
 
 static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 38a2071cf77685..d03544f04aa9ee 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -847,6 +847,8 @@ static inline void *dev_get_platdata(const struct device *dev)
  * Manual binding of a device to driver. See drivers/base/bus.c
  * for information on use.
  */
+int __must_check device_driver_attach(struct device_driver *drv,
+				      struct device *dev);
 int __must_check device_bind_driver(struct device *dev);
 void device_release_driver(struct device *dev);
 int  __must_check device_attach(struct device *dev);
-- 
2.31.1

