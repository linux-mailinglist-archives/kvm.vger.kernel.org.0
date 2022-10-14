Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C080D5FE82B
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJNEnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJNEn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:43:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034B3DCE91;
        Thu, 13 Oct 2022 21:43:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvCc1JAZmqD1ePX8zBYPIKCmNyZ1wgFJghmO7z6v95o+W2rbNZxCvsrT3aMBeGtZ77BDjOS+B3/hbwQdZ5SLfeuE6xK2B9oZ0VEqAsSrqhrZrxa3ecujZAIsxCp3dMq8EHthDu3fCjC7QmV+OASBO9kRzERI3CfqYsV58tVNS6y6iu9qVu+/LAcrh+loM/9JMEHYL0hyLmRcCeafAnH8Uc025P3+w9Hk4WM9bDHCQaCyW7+8pTPBp15LZmZdiOnm8kRrZPEDZmlJFYPNIytgJs8kzJvdblBAPrHXsMelaAoIhomf8Q/4s2sLWu7ZJdeJloRk6TfeN6mC0HEZZGTMGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hi27uM8BaAseFY8oA0i7VLY82I3uPU56L32S7yUaocQ=;
 b=RmLshjtn8rTOw6MIiKi+eUoovA2Gy0B7FifiltRR0jx8pi16ZQUrMwGBGfyUlmoQh+H7prrP1JDEMEs7CedAKzSGRJQQYgha7t2AnNGZ0HE4QvKIgBfLJOmSpUFkU8tXx240+AeSS2fQnEJr9QLXLISbXRFrNDVt7N+ny+YyWRsRJZXULJUY+h4aXpbTpYVnT5h7PzfnHYxmWaPA+YhHQdYoPpt+oBjkugU54zSHemkxB76ARPwH+xthGXW+5Iy2srjwSOxH73cVwcI6wR6omCSsKj/mVoj9R3EtMynSxpzLBecsYUbiu8UEjB6tBUHKIcD/vdb0pQREiGRCzpsO+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi27uM8BaAseFY8oA0i7VLY82I3uPU56L32S7yUaocQ=;
 b=APrF0jGyn/8Lv4KURRIyWjmJ6ydslT/7PJaonsBeF/R0XG06zbJ/v5qOACgE8D92CH9VT56XK59GjbSkq0Be0GmLFgaRzn+iExmjyWo+z7vqkNrdViW0dzLfrc5ko7ppKuoW2USTC8KO2FM3p2bYDqJ7PQicTGHZAsPlIvJSNls=
Received: from MW4PR04CA0295.namprd04.prod.outlook.com (2603:10b6:303:89::30)
 by CH0PR12MB5251.namprd12.prod.outlook.com (2603:10b6:610:d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Fri, 14 Oct
 2022 04:43:20 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::e3) by MW4PR04CA0295.outlook.office365.com
 (2603:10b6:303:89::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26 via Frontend
 Transport; Fri, 14 Oct 2022 04:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:43:18 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:42:42 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 21:42:08 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:42:00 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <jgg@nvidia.com>, <robin.murphy@arm.com>,
        <will@kernel.org>, <joro@8bytes.org>, <masahiroy@kernel.org>,
        <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>,
        <aleksandar.radovanovic@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v4 6/8] irq/msi: use implicit msi domain for alloc and free
Date:   Fri, 14 Oct 2022 10:10:47 +0530
Message-ID: <20221014044049.2557085-7-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|CH0PR12MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c68f82-7917-45dc-3a4b-08daad9e9dcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmv1040eWsmfK8wBA1TiSCEkosouHe8xQIhiNRnZK21xjhLnQjyIjLV0bqewUTXKRyWa2qSs9cXLp/q4ScH/0Db9Dp60egeJevDrwmzPfKms7wMzJYdmr8p34EpvPCPQU1FwSwnOdJtPRb1GVAJxXLFBCTeuSBVy9zCVOEgZquhOK/H4mCvD6LJPqhoiV0p7D8LwhKykpy11tvwCMJyLBKqmSczyJk9kxVUKGBdrKkyyAOeF2PrSHUnCnxB0feob3/fQtgSkvfPE7MJDAUt5QEMLoERHoNBIbScTqs9WqaL3IY3nQ1xsnZw/4d0NHVlzTIJO0YrauL26/GuX79spJsme8gOO9ChAeTV5vat7CmkmbAfQTpdoytWoABIOdIjg23GaT+m3dYciQIpi5GFjwoqVFUwzPLXnQE3SxFPQXgjaKJ2zMQVqb+QZSamrlFl33s1GhIcjQ7ik1U2IFyuDG2wgfCY72cUurUDlaDaFFqW259Ig559FnLFdOEcSe/svzbuv8fXRTjRgy/RN7wS3nRkPTVXImAqi1XCjgtrxRs/S6/BOnUoUjbXttEcbm0VTEPkl3/FQmQKqgEsBBJj6PeASCwVTInEdQ1HBhN57LsmtCJxL1jq6q+kAsmmfVd+rpdD7WZtsVm9fgwCMtqRTJJJSl3Gxw4elf2UWth54qLudHfGwdI3rMkjftrJpO1zsInVGpo7GMCh5HL5nhkJOxEYRr/qtiGOXbot9/EwF+VBsy2z6ZIRWVyodeHSKMT9DtYVJadXrfPe4lFCFWTk8tcdtPcW5/sen5OsycftasWxhyYqPUALA/4eMSPFiYF3gujapp7odJHHI1cIrRavuW0CYeh5+OF1M6tMvuCGequvNtBBENLWRfO6ArHDKMLI0
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(2906002)(7416002)(44832011)(316002)(110136005)(54906003)(4326008)(8676002)(36860700001)(5660300002)(6666004)(8936002)(70206006)(70586007)(41300700001)(478600001)(36756003)(47076005)(426003)(83380400001)(26005)(82740400003)(40480700001)(356005)(81166007)(40460700003)(186003)(1076003)(336012)(82310400005)(921005)(2616005)(86362001)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:43:18.8628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c68f82-7917-45dc-3a4b-08daad9e9dcc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The domain can be extracted out of the device rather than
passing it explicitly in the msi domain alloc and free APIs.
So this change removes taking irq domain input parameter for
these APIs

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 drivers/base/platform-msi.c      |  4 ++--
 drivers/bus/fsl-mc/fsl-mc-msi.c  |  4 ++--
 drivers/pci/msi/irqdomain.c      |  4 ++--
 drivers/soc/ti/ti_sci_inta_msi.c |  2 +-
 include/linux/msi.h              | 10 ++++------
 kernel/irq/msi.c                 | 21 +++++++++------------
 6 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 296ea673d661..62664a207230 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -212,7 +212,7 @@ int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
 	if (err)
 		return err;
 
-	err = msi_domain_alloc_irqs(dev->msi.domain, dev, nvec);
+	err = msi_domain_alloc_irqs(dev, nvec);
 	if (err)
 		platform_msi_free_priv_data(dev);
 
@@ -226,7 +226,7 @@ EXPORT_SYMBOL_GPL(platform_msi_domain_alloc_irqs);
  */
 void platform_msi_domain_free_irqs(struct device *dev)
 {
-	msi_domain_free_irqs(dev->msi.domain, dev);
+	msi_domain_free_irqs(dev);
 	platform_msi_free_priv_data(dev);
 }
 EXPORT_SYMBOL_GPL(platform_msi_domain_free_irqs);
diff --git a/drivers/bus/fsl-mc/fsl-mc-msi.c b/drivers/bus/fsl-mc/fsl-mc-msi.c
index 0cfe859a4ac4..0522e80a34ac 100644
--- a/drivers/bus/fsl-mc/fsl-mc-msi.c
+++ b/drivers/bus/fsl-mc/fsl-mc-msi.c
@@ -235,7 +235,7 @@ int fsl_mc_msi_domain_alloc_irqs(struct device *dev,  unsigned int irq_count)
 	 * NOTE: Calling this function will trigger the invocation of the
 	 * its_fsl_mc_msi_prepare() callback
 	 */
-	error = msi_domain_alloc_irqs(msi_domain, dev, irq_count);
+	error = msi_domain_alloc_irqs(dev, irq_count);
 
 	if (error)
 		dev_err(dev, "Failed to allocate IRQs\n");
@@ -250,5 +250,5 @@ void fsl_mc_msi_domain_free_irqs(struct device *dev)
 	if (!msi_domain)
 		return;
 
-	msi_domain_free_irqs(msi_domain, dev);
+	msi_domain_free_irqs(dev);
 }
diff --git a/drivers/pci/msi/irqdomain.c b/drivers/pci/msi/irqdomain.c
index e9cf318e6670..00ac782afd1d 100644
--- a/drivers/pci/msi/irqdomain.c
+++ b/drivers/pci/msi/irqdomain.c
@@ -14,7 +14,7 @@ int pci_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	domain = dev_get_msi_domain(&dev->dev);
 	if (domain && irq_domain_is_hierarchy(domain))
-		return msi_domain_alloc_irqs_descs_locked(domain, &dev->dev, nvec);
+		return msi_domain_alloc_irqs_descs_locked(&dev->dev, nvec);
 
 	return pci_msi_legacy_setup_msi_irqs(dev, nvec, type);
 }
@@ -25,7 +25,7 @@ void pci_msi_teardown_msi_irqs(struct pci_dev *dev)
 
 	domain = dev_get_msi_domain(&dev->dev);
 	if (domain && irq_domain_is_hierarchy(domain))
-		msi_domain_free_irqs_descs_locked(domain, &dev->dev);
+		msi_domain_free_irqs_descs_locked(&dev->dev);
 	else
 		pci_msi_legacy_teardown_msi_irqs(dev);
 	msi_free_msi_descs(&dev->dev);
diff --git a/drivers/soc/ti/ti_sci_inta_msi.c b/drivers/soc/ti/ti_sci_inta_msi.c
index 991c78b34745..ae10b88d1ff0 100644
--- a/drivers/soc/ti/ti_sci_inta_msi.c
+++ b/drivers/soc/ti/ti_sci_inta_msi.c
@@ -114,7 +114,7 @@ int ti_sci_inta_msi_domain_alloc_irqs(struct device *dev,
 		goto unlock;
 	}
 
-	ret = msi_domain_alloc_irqs_descs_locked(msi_domain, dev, nvec);
+	ret = msi_domain_alloc_irqs_descs_locked(dev, nvec);
 	if (ret)
 		dev_err(dev, "Failed to allocate IRQs %d\n", ret);
 unlock:
diff --git a/include/linux/msi.h b/include/linux/msi.h
index fc918a658d48..76f997bdcb52 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -428,13 +428,11 @@ struct irq_domain *msi_create_irq_domain(struct fwnode_handle *fwnode,
 					 struct irq_domain *parent);
 int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 			    int nvec);
-int msi_domain_alloc_irqs_descs_locked(struct irq_domain *domain, struct device *dev,
-				       int nvec);
-int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
-			  int nvec);
+int msi_domain_alloc_irqs_descs_locked(struct device *dev, int nvec);
+int msi_domain_alloc_irqs(struct device *dev, int nvec);
 void __msi_domain_free_irqs(struct irq_domain *domain, struct device *dev);
-void msi_domain_free_irqs_descs_locked(struct irq_domain *domain, struct device *dev);
-void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev);
+void msi_domain_free_irqs_descs_locked(struct device *dev);
+void msi_domain_free_irqs(struct device *dev);
 struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
 
 struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index a9ee535293eb..14983c82a9e3 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -925,7 +925,6 @@ static int msi_domain_add_simple_msi_descs(struct msi_domain_info *info,
 
 /**
  * msi_domain_alloc_irqs_descs_locked - Allocate interrupts from a MSI interrupt domain
- * @domain:	The domain to allocate from
  * @dev:	Pointer to device struct of the device for which the interrupts
  *		are allocated
  * @nvec:	The number of interrupts to allocate
@@ -936,9 +935,9 @@ static int msi_domain_add_simple_msi_descs(struct msi_domain_info *info,
  *
  * Return: %0 on success or an error code.
  */
-int msi_domain_alloc_irqs_descs_locked(struct irq_domain *domain, struct device *dev,
-				       int nvec)
+int msi_domain_alloc_irqs_descs_locked(struct device *dev, int nvec)
 {
+	struct irq_domain *domain = dev_get_msi_domain(dev);
 	struct msi_domain_info *info = domain->host_data;
 	struct msi_domain_ops *ops = info->ops;
 	int ret;
@@ -951,25 +950,24 @@ int msi_domain_alloc_irqs_descs_locked(struct irq_domain *domain, struct device
 
 	ret = ops->domain_alloc_irqs(domain, dev, nvec);
 	if (ret)
-		msi_domain_free_irqs_descs_locked(domain, dev);
+		msi_domain_free_irqs_descs_locked(dev);
 	return ret;
 }
 
 /**
  * msi_domain_alloc_irqs - Allocate interrupts from a MSI interrupt domain
- * @domain:	The domain to allocate from
  * @dev:	Pointer to device struct of the device for which the interrupts
  *		are allocated
  * @nvec:	The number of interrupts to allocate
  *
  * Return: %0 on success or an error code.
  */
-int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev, int nvec)
+int msi_domain_alloc_irqs(struct device *dev, int nvec)
 {
 	int ret;
 
 	msi_lock_descs(dev);
-	ret = msi_domain_alloc_irqs_descs_locked(domain, dev, nvec);
+	ret = msi_domain_alloc_irqs_descs_locked(dev, nvec);
 	msi_unlock_descs(dev);
 	return ret;
 }
@@ -1006,7 +1004,6 @@ static void msi_domain_free_msi_descs(struct msi_domain_info *info,
 
 /**
  * msi_domain_free_irqs_descs_locked - Free interrupts from a MSI interrupt @domain associated to @dev
- * @domain:	The domain to managing the interrupts
  * @dev:	Pointer to device struct of the device for which the interrupts
  *		are free
  *
@@ -1014,8 +1011,9 @@ static void msi_domain_free_msi_descs(struct msi_domain_info *info,
  * pair. Use this for MSI irqdomains which implement their own vector
  * allocation.
  */
-void msi_domain_free_irqs_descs_locked(struct irq_domain *domain, struct device *dev)
+void msi_domain_free_irqs_descs_locked(struct device *dev)
 {
+	struct irq_domain *domain = dev_get_msi_domain(dev);
 	struct msi_domain_info *info = domain->host_data;
 	struct msi_domain_ops *ops = info->ops;
 
@@ -1027,14 +1025,13 @@ void msi_domain_free_irqs_descs_locked(struct irq_domain *domain, struct device
 
 /**
  * msi_domain_free_irqs - Free interrupts from a MSI interrupt @domain associated to @dev
- * @domain:	The domain to managing the interrupts
  * @dev:	Pointer to device struct of the device for which the interrupts
  *		are free
  */
-void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
+void msi_domain_free_irqs(struct device *dev)
 {
 	msi_lock_descs(dev);
-	msi_domain_free_irqs_descs_locked(domain, dev);
+	msi_domain_free_irqs_descs_locked(dev);
 	msi_unlock_descs(dev);
 }
 
-- 
2.25.1

