Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B956324C
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbiGALJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiGALI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:08:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5099B13E3D;
        Fri,  1 Jul 2022 04:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KD09HPjys7g23cY9e3ppUGN5hfRE6RIBRSo13byP/IFqSN+HTK/JgZNXlopcoJhqCplap4MOHShP75xyJdUUdmm0xxaio7o1uEDkwRnnRc6E541qYr0voU0TDbcIOwJ+w49B3xD/Bobls0lXbZ6sfH7MdLlXbYp9VGaJEY6dxTo34bRKngMef+TnX5hFp01ZCgQ/4Z3ohcej7aakSGNhNpqzQ+4KSrGK2H19/TPgwgw8O8KK9vj9w+hFfwnYUUSsCv1e8LVKOu13S9BHNj8g/rFEw4auaYYn9ekcZa0RNXt8peKaiE09x309IsCpZ2ycVdRc0JrExGdn9y2mMVmRpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuEBACjnHYDVEjBgT8z6HSA0SSdtjlTt0DdeJK7DyPY=;
 b=jBsMiW2JSqrc8OUammkUGhQohVHREXr3jKZ+350PiKjklROkRh8FBUcmwN9zhplkWeKn318mAvt+gVikt1xvWMDe3FMY9zsKtTX6kr8nQMWvJOkDjmWr1nWRweTbLKC9b8BSlQqxWGImgfnfuiPk48prubwzUYcspiBFsjXNJcVeVoHF2cvGPmRCQzQM/4QIWa3EbbZVDgwLUS5Psw0u/3CPKZWnRJQ9jp9Gsi/1D8be3wHxwQ09fvIJctNeJdbJf44z3HXV5oWCgShP06KIY0ltt0jwixhpbqAxkqz+ZStBpTq5DjpFrnrGbQAus6M0JyjIJFZTuJUquzaehSWQDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuEBACjnHYDVEjBgT8z6HSA0SSdtjlTt0DdeJK7DyPY=;
 b=gxOUDA0u03WZjbTsLz2UmpZQCRihs0OxeUhplcK3fQc6j/N1G5hF8rfBMRdUGWV7A9Jp+K8f3G4jChSEAnvCaI6ErOPA2MMUfrBxBmoBGZ/zs56ktesFlmx1X5CuDwdDpZx6ncEDHwKkmaNCPH0iS5GOlO5oJVB+R4sDM7JYP5wulrL/iaZ4qBL2+Q3I5ha3QxKdL8g3M8ZR0O3yMeqCI7pksWIWaqrgE0Z/Hk8FPEbGS0CMYjkrYpzV19sSnAv3NPhH/HsveYaIIk/NYo5mBNQLHv4Qr0KBp83aQA9fKSzpNey30LUFqA2SvSCgozJqqkcTJKpP+EYwQz6nSae09w==
Received: from DM6PR07CA0041.namprd07.prod.outlook.com (2603:10b6:5:74::18) by
 BN8PR12MB2995.namprd12.prod.outlook.com (2603:10b6:408:41::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.17; Fri, 1 Jul 2022 11:08:52 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::95) by DM6PR07CA0041.outlook.office365.com
 (2603:10b6:5:74::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Fri, 1 Jul 2022 11:08:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Fri, 1 Jul 2022 11:08:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 11:08:51 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 04:08:50 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 04:08:45 -0700
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v4 5/6] vfio/pci: Prevent low power re-entry without guest driver
Date:   Fri, 1 Jul 2022 16:38:13 +0530
Message-ID: <20220701110814.7310-6-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701110814.7310-1-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44422f5e-9e02-4a46-eae1-08da5b5214e5
X-MS-TrafficTypeDiagnostic: BN8PR12MB2995:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QhoApFnRVOiMUOY8QW9C4NupsH+48q5rcgk0X+q1gGDCYK0L4P/u2/C3hJwfPxizQ+jvix/x95lYDKKbIPSzEylcz1eiEdRhi0BjGmaLreJciypKx8ZEhQHlgCOX7O9lXBYQluqjACvQ985hhAlePcxK1xK6W3GioG8Sw+6CTWSX1S0N2WmnqZfS0fb2MheswGiOUYeWQ5CBeMqzrNpfIGeN525Dc+R3blAkUQg7BBhwmrHh/1vxaFFMlKY1jmwdW8suOUZY38mGOSH6arMXu2Gb2WVsnmqhbdPVQhrLM+7+rgm8HezflnPIdiF+fWLeYiV39pmtMBlAomIyK0qoftwapU7HrV6yM0ZW1eD23sEb3wiXxJd5VYegD7eWw2b1p5pj5MqXe8ybV3b3hdm5oB5h3JSz4IcAhUI7W+meGOAhl6MnrmYbiIJ0UL9/FpFzvUnKzPwYOKd3B2T0A0Ba4kRKym43qjhx/upojKPPcj8d+LfUUweacE/7ncP84AoFE6WPeT2VsIKDz06DoAmfpee9/npAs/s8q4KmO3hA01fHXabXn+hi7EB7hl0qiUzbObMM0x1v+auxEyIMWwZH7dBl1o4xDnzSqO7tJs4mQZYCzqrK+AfXz2P29d0NR6KSoE/XyPW5AxV3St8NGzgwKLC/6tbfGBVCb6+GhJla9CcP458G5CLQIa76Aptmxyjp3Y3QK43F/FqYQlaZERUBtZ04PwkFcjBWkBDeQHHqRBJqC6v6489wkZEK9uuYhPe/dDx6gYGsYazsCrCXuEDwFliHBmdAjkLDxUKnt6ZUHO/aCOUXUvVqx92JRpdRIJ3T3r7K9KtyoapM1dqBoDivyYmZJHfQ15ni7foyy936A7Q=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(396003)(376002)(36840700001)(40470700004)(46966006)(47076005)(70206006)(7416002)(40480700001)(316002)(336012)(86362001)(426003)(1076003)(110136005)(186003)(2616005)(2906002)(5660300002)(36860700001)(54906003)(7696005)(41300700001)(6666004)(83380400001)(356005)(8676002)(107886003)(81166007)(36756003)(26005)(478600001)(8936002)(40460700003)(82740400003)(70586007)(82310400005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 11:08:52.0842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44422f5e-9e02-4a46-eae1-08da5b5214e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2995
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some devices (Like NVIDIA VGA or 3D controller) require driver
involvement each time before going into D3cold. In the regular flow,
the guest driver do all the required steps inside the guest OS and
then the IOCTL will be called for D3cold entry by the hypervisor. Now,
if there is any activity on the host side (For example user has run
lspci, dump the config space through sysfs, etc.), then the runtime PM
framework will resume the device first, perform the operation and then
suspend the device again. This second time suspend will be without
guest driver involvement. This patch adds the support to prevent
second-time runtime suspend if there is any wake-up. This prevention
is either based on the predefined vendor/class id list or the user can
specify the flag (VFIO_PM_LOW_POWER_REENTERY_DISABLE) during entry for
the same.

'pm_runtime_reentry_allowed' flag tracks if this re-entry is allowed.
It will be set during the entry time.

'pm_runtime_resumed' flag tracks if there is any wake-up before the
guest performs the wake-up. If re-entry is not allowed, then during
runtime resume, the runtime PM count will be incremented, and this
flag will be set. This flag will be checked during guest D3cold exit
and then skip the runtime PM-related handling if this flag is set.

During guest low power exit time, all vdev power-related flags are
accessed under 'memory_lock' and usage count will be incremented. The
resume will be triggered after releasing the lock since the runtime
resume callback again requires the lock. pm_runtime_get_noresume()/
pm_runtime_resume() have been used instead of
pm_runtime_resume_and_get() to handle the following scenario during
the race condition.

 a. The guest triggered the low power exit.
 b. The guest thread got the lock and cleared the vdev related
    flags and released the locks.
 c. Before pm_runtime_resume_and_get(), the host lspci thread got
    scheduled and triggered the runtime resume.
 d. Now, all the vdev related flags are cleared so there won't be
    any extra handling inside the runtime resume.
 e. The runtime PM put the device again into the suspended state.
 f. The guest triggered pm_runtime_resume_and_get() got called.

So, at step (e), the suspend is happening without the guest driver
involvement. Now, by using pm_runtime_get_noresume() before releasing
'memory_lock', the runtime PM framework can't suspend the device due
to incremented usage count.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 87 ++++++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |  2 +
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 8c17ca41d156..1ddaaa6ccef5 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -191,6 +191,20 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 	return false;
 }
 
+static bool vfio_pci_low_power_reentry_allowed(struct pci_dev *pdev)
+{
+	/*
+	 * The NVIDIA display class requires driver involvement for every
+	 * D3cold entry. The audio and other classes can go into D3cold
+	 * without driver involvement.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
+	    ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY))
+		return false;
+
+	return true;
+}
+
 static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -295,6 +309,27 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
 	if (vdev->pm_intx_masked)
 		vfio_pci_intx_unmask(vdev);
 
+	down_write(&vdev->memory_lock);
+
+	/*
+	 * The runtime resume callback will be called for one of the following
+	 * two cases:
+	 *
+	 * - If the user has called IOCTL explicitly to move the device out of
+	 *   the low power state or closed the device.
+	 * - If there is device access on the host side.
+	 *
+	 * For the second case, check if re-entry to the low power state is
+	 * allowed. If not, then increment the usage count so that runtime PM
+	 * framework won't suspend the device and set the 'pm_runtime_resumed'
+	 * flag.
+	 */
+	if (vdev->pm_runtime_engaged && !vdev->pm_runtime_reentry_allowed) {
+		pm_runtime_get_noresume(dev);
+		vdev->pm_runtime_resumed = true;
+	}
+	up_write(&vdev->memory_lock);
+
 	return 0;
 }
 #endif /* CONFIG_PM */
@@ -415,9 +450,12 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 */
 	down_write(&vdev->memory_lock);
 	if (vdev->pm_runtime_engaged) {
+		if (!vdev->pm_runtime_resumed) {
+			pm_runtime_get_noresume(&pdev->dev);
+			do_resume = true;
+		}
+		vdev->pm_runtime_resumed = false;
 		vdev->pm_runtime_engaged = false;
-		pm_runtime_get_noresume(&pdev->dev);
-		do_resume = true;
 	}
 	up_write(&vdev->memory_lock);
 
@@ -1227,12 +1265,17 @@ static int vfio_pci_pm_validate_flags(u32 flags)
 	if (!flags)
 		return -EINVAL;
 	/* Only valid flags should be set */
-	if (flags & ~(VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
+	if (flags & ~(VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT |
+		      VFIO_PM_LOW_POWER_REENTERY_DISABLE))
 		return -EINVAL;
 	/* Both enter and exit should not be set */
 	if ((flags & (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT)) ==
 	    (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
 		return -EINVAL;
+	/* re-entry disable can only be set with enter */
+	if ((flags & VFIO_PM_LOW_POWER_REENTERY_DISABLE) &&
+	    !(flags & VFIO_PM_LOW_POWER_ENTER))
+		return -EINVAL;
 
 	return 0;
 }
@@ -1255,10 +1298,17 @@ static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
 
 	if (flags & VFIO_DEVICE_FEATURE_GET) {
 		down_read(&vdev->memory_lock);
-		if (vdev->pm_runtime_engaged)
+		if (vdev->pm_runtime_engaged) {
 			vfio_pm.flags = VFIO_PM_LOW_POWER_ENTER;
-		else
+			if (!vdev->pm_runtime_reentry_allowed)
+				vfio_pm.flags |=
+					VFIO_PM_LOW_POWER_REENTERY_DISABLE;
+		} else {
 			vfio_pm.flags = VFIO_PM_LOW_POWER_EXIT;
+			if (!vfio_pci_low_power_reentry_allowed(pdev))
+				vfio_pm.flags |=
+					VFIO_PM_LOW_POWER_REENTERY_DISABLE;
+		}
 		up_read(&vdev->memory_lock);
 
 		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
@@ -1286,6 +1336,19 @@ static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
 		}
 
 		vdev->pm_runtime_engaged = true;
+		vdev->pm_runtime_resumed = false;
+
+		/*
+		 * If there is any access when the device is in the runtime
+		 * suspended state, then the device will be resumed first
+		 * before access and then the device will be suspended again.
+		 * Check if this second time suspend is allowed and track the
+		 * same in 'pm_runtime_reentry_allowed' flag.
+		 */
+		vdev->pm_runtime_reentry_allowed =
+			vfio_pci_low_power_reentry_allowed(pdev) &&
+			!(vfio_pm.flags & VFIO_PM_LOW_POWER_REENTERY_DISABLE);
+
 		up_write(&vdev->memory_lock);
 		pm_runtime_put(&pdev->dev);
 	} else if (vfio_pm.flags & VFIO_PM_LOW_POWER_EXIT) {
@@ -1296,6 +1359,20 @@ static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
 		}
 
 		vdev->pm_runtime_engaged = false;
+		if (vdev->pm_runtime_resumed) {
+			vdev->pm_runtime_resumed = false;
+			up_write(&vdev->memory_lock);
+			return 0;
+		}
+
+		/*
+		 * The 'memory_lock' will be acquired again inside the runtime
+		 * resume callback. So, increment the usage count inside the
+		 * lock and call pm_runtime_resume() after releasing the lock.
+		 * If there is any race condition between the wake-up generated
+		 * at the host and the current path. Then the incremented usage
+		 * count will prevent the device to go into the suspended state.
+		 */
 		pm_runtime_get_noresume(&pdev->dev);
 		up_write(&vdev->memory_lock);
 		ret = pm_runtime_resume(&pdev->dev);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index bf4823b008f9..18cc83b767b8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -126,6 +126,8 @@ struct vfio_pci_core_device {
 	bool			needs_pm_restore;
 	bool			pm_intx_masked;
 	bool			pm_runtime_engaged;
+	bool			pm_runtime_resumed;
+	bool			pm_runtime_reentry_allowed;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-- 
2.17.1

