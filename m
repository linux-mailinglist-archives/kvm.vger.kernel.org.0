Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F16D50DC93
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiDYJag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbiDYJaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:30:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E3713F75;
        Mon, 25 Apr 2022 02:26:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgHJCO9mvzZg3lt1PNZVG2xAVyR6T3m+VMESaQcEvgu6SF2KoorgJLdXpUVeoXHVqDYWm4JyBLqQN5ccfLa+yXsrFt0wqLZ71H/KVesSKBXhJokb/RKN4eNoR4ZR9ytPE/YrQtqzG3fyBX1ebO7VGzp5gK2QXKQXCsK9kaqYNdjbmoiE+Xd3MpmtC8V2Z9F+xpezv8MK6/izuU5o4DKJgEHiIretrqRT87GWEl8Iyf2CpcQBFsrFJlsbZ714zYAFonvn8MQMZIAZWvswcYoz6i0UebuXNlw0d2ihorq5c6EbtmFUPx+Vg1k6oi5yO01mCcjktgiZRVNSa80u7OdKNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgZFhebwxLIINx9DwHJah7HYPOPuycDCyeEL58Ba2to=;
 b=CaxSf2aLM/ChXps2tj08DTnIsVYth2ug0sge93k9KZ4797ffa1XGBBSFAWuKw/9YENFvVkTAnWm+l/F83CmwcAyGgNIhFNSUoBzfjZxPKU7ieWvzBBHlUgQTzO++tQDTsJoovK/5loWh+04SUfRNh6OvhstJY7318Ni6/mtOWJ00y9SWGGvMPlK3+clN8hArOyb72G3adMYJP1ewIw0wlbApy5F6bY2geIvqNo2ptO5+cwQkxRoHhrOVQ+MQmzGVwKw5gHbOdkLYG+6W4deH5DJF2cYzc7Ess3z5oaEtDtS5i1mAnRRSDMhX++7shQeDB+g0dAVcJcJIwotlUrvqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgZFhebwxLIINx9DwHJah7HYPOPuycDCyeEL58Ba2to=;
 b=n7jZ74JXHfAKdOMhsXpasYk5zwGTcB0piykVwt1UC9abrt7/QZ3ig5JC88/sCyJqk/BUv2ET/2Gqu1jQ0bxCJax94KHpmMzEKkbbB6CenucTbrV3gqOnYB8kiXaaKOxLZXmdmHQlsDN3vGSBN+jBVb1VfSnnGpN2M8yzIEl5Fq2oZc70Rc0hZkyVndOHdrYY95Bdo/782o5x0Pa6NCynd5w/DgxSqeFVtcep3wjAp7nTfaG7Om6S1hYYm/68oRX1nPL67A7ztHC+O7qstfn9cL3qv7RVIOgCjG2lWNgM8PJ63kRyKSAPfKXFjNvu6opUPMbImMnmkvVetchaMpntRg==
Received: from MW4PR03CA0013.namprd03.prod.outlook.com (2603:10b6:303:8f::18)
 by CH2PR12MB4088.namprd12.prod.outlook.com (2603:10b6:610:a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 09:26:51 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::a4) by MW4PR03CA0013.outlook.office365.com
 (2603:10b6:303:8f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 25 Apr 2022 09:26:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:26:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:26:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:26:49 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:26:44 -0700
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
Subject: [PATCH v3 4/8] vfio/pci: Add support for setting driver data inside core layer
Date:   Mon, 25 Apr 2022 14:56:11 +0530
Message-ID: <20220425092615.10133-5-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220425092615.10133-1-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5bfe851-0c87-447d-646a-08da269dbabf
X-MS-TrafficTypeDiagnostic: CH2PR12MB4088:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB408869A82CCB96DAFE6C54F5CCF89@CH2PR12MB4088.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHGAbtC97xCSpPGOOBnZ8eBB98bfyQxfXyHOANvor/mPqiN5uB5sOTYmB25+7eYgWl+xBbAL5YscHN6PENBFT8GHtDqIwc8CrvF492GAjMqoSZNDYx7kMXH1rJefb5yAF5NqwYNBfzgjCu4+OBXCc2FlbBwcmQNG5nY0/WK0jl5Inxr+XmsS9n6838qAuVy2xPFZDP6I+PosBP+TkCjvT0qlfwxNMOn1toz2tUa2izSfsKi6bksh+B2Y/xrLtR/3K4xcA7CdqPe+uvm5ZcOJCgff46TXArcwAjDKazKL2wvHCgp0U2JJdksyT4nevs35KSX/RYIMcUSjcS8+M0egeXEERd6txAv5rcvIO965AeWYhS5dPFsPEbZcNz7KXDMI18NRNvsOHRicddoM7bfymPqVd0r4xNAXzkF/joXvUGw8Qdf8Rw0rUZUuhWyqkmw14Pk06GxagRitAe5nySo6+58rpl1rbnGiSH8CZ3gEXY4R9w9OdbhekSXc8OwPWaiVSJC3C/BdcD1lewVc4Z2u3TXT7Mbp0jZCQzsEQSmR/F10nPMyzjyxWpRKlbzjlmz7O2sNa99qH0dgpb/WHFwtpOdLMaonMvS2f2OWRXnomi5X+/imWWfm6tSEAROTHkwCNJuplptpfqDjWgx0kIi98HjGcBpAuJNbmsAuQ2k3EjUC9lF2HK42nPXlUnA84eePC2PrfKFOBAzoSJw4PdqFLA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(4326008)(508600001)(2906002)(5660300002)(8676002)(7416002)(7696005)(2616005)(426003)(186003)(336012)(83380400001)(47076005)(1076003)(86362001)(107886003)(8936002)(82310400005)(6666004)(26005)(36860700001)(70206006)(70586007)(81166007)(40460700003)(36756003)(110136005)(356005)(316002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:26:51.0235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bfe851-0c87-447d-646a-08da269dbabf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4088
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio driver is divided into two layers: core layer (implemented in
vfio_pci_core.c) and parent driver (For example, vfio_pci, mlx5_vfio_pci,
hisi_acc_vfio_pci, etc.). All the parent driver calls dev_set_drvdata()
and assigns its own structure as driver data. Some of the callback
functions are implemented in the core layer and these callback functions
provide the reference of 'struct pci_dev' or 'struct device'. Currently,
we use vfio_device_get_from_dev() which provides reference to the
vfio_device for a device. But this function follows long path to extract
the same. There are few cases, where we don't need to go through this
long path if we get this through drvdata.

This patch moves the setting of drvdata inside the core layer. If we see
the current implementation of parent driver structure implementation,
then 'struct vfio_pci_core_device' is a first member so the pointer of
the parent structure and 'struct vfio_pci_core_device' should be the same.

struct hisi_acc_vf_core_device {
    struct vfio_pci_core_device core_device;
    ...
};

struct mlx5vf_pci_core_device {
    struct vfio_pci_core_device core_device;
    ...
};

The vfio_pci.c uses 'struct vfio_pci_core_device' itself.

To support getting the drvdata in both the layers, we can put the
restriction to make 'struct vfio_pci_core_device' as a first member.
Also, vfio_pci_core_register_device() has this validation which makes sure
that this prerequisite is always satisfied.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  4 ++--
 drivers/vfio/pci/mlx5/main.c                  |  3 +--
 drivers/vfio/pci/vfio_pci.c                   |  4 ++--
 drivers/vfio/pci/vfio_pci_core.c              | 24 ++++++++++++++++---
 include/linux/vfio_pci_core.h                 |  7 +++++-
 5 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 767b5d47631a..c76c09302a8f 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1274,11 +1274,11 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 					  &hisi_acc_vfio_pci_ops);
 	}
 
-	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
+	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device,
+					    hisi_acc_vdev);
 	if (ret)
 		goto out_free;
 
-	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
 	return 0;
 
 out_free:
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee..8689248f66f3 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -614,11 +614,10 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 		}
 	}
 
-	ret = vfio_pci_core_register_device(&mvdev->core_device);
+	ret = vfio_pci_core_register_device(&mvdev->core_device, mvdev);
 	if (ret)
 		goto out_free;
 
-	dev_set_drvdata(&pdev->dev, mvdev);
 	return 0;
 
 out_free:
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2b047469e02f..e0f8027c5cd8 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -151,10 +151,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
 
-	ret = vfio_pci_core_register_device(vdev);
+	ret = vfio_pci_core_register_device(vdev, vdev);
 	if (ret)
 		goto out_free;
-	dev_set_drvdata(&pdev->dev, vdev);
+
 	return 0;
 
 out_free:
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1271728a09db..953ac33b2f5f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1822,9 +1822,11 @@ void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 
-int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
+				  void *driver_data)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct device *dev = &pdev->dev;
 	int ret;
 
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
@@ -1843,6 +1845,17 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
+	/*
+	 * The 'struct vfio_pci_core_device' should be the first member of the
+	 * of the structure referenced by 'driver_data' so that it can be
+	 * retrieved with dev_get_drvdata() inside vfio-pci core layer.
+	 */
+	if ((struct vfio_pci_core_device *)driver_data != vdev) {
+		pci_warn(pdev, "Invalid driver data\n");
+		return -EINVAL;
+	}
+	dev_set_drvdata(dev, driver_data);
+
 	if (pci_is_root_bus(pdev->bus)) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
@@ -1856,10 +1869,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	}
 
 	if (ret)
-		return ret;
+		goto out_drvdata;
 	ret = vfio_pci_vf_init(vdev);
 	if (ret)
-		return ret;
+		goto out_drvdata;
 	ret = vfio_pci_vga_init(vdev);
 	if (ret)
 		goto out_vf;
@@ -1890,6 +1903,8 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
+out_drvdata:
+	dev_set_drvdata(dev, NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
@@ -1897,6 +1912,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct device *dev = &pdev->dev;
 
 	vfio_pci_core_sriov_configure(pdev, 0);
 
@@ -1907,6 +1923,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
+
+	dev_set_drvdata(dev, NULL);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 505b2a74a479..3c7d65e68340 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -225,7 +225,12 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev);
 void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 			       struct pci_dev *pdev,
 			       const struct vfio_device_ops *vfio_pci_ops);
-int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
+/*
+ * The 'struct vfio_pci_core_device' should be the first member
+ * of the structure referenced by 'driver_data'.
+ */
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
+				  void *driver_data);
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
-- 
2.17.1

