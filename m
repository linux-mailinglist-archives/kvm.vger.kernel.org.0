Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B8265F4A3
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbjAETg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbjAETf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:35:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D97917E15;
        Thu,  5 Jan 2023 11:34:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1oc5+DGyqh55BY62wIiRCnoll5nvAbV0BT3sk26gk1qAR5MwHv/L/24JpYf9qOxfQVxT4OfOwAubuPeXmt7pAZMnrAdKxufeI3XfTpA8PInfvL95n5BRPY4Lppdo+NNSj7lSqkQOyhu/iBf+e+VSGYTL6685iubWYH9Jq+tcExZa+43AqiaeZnOk6uRm4T3jdXarIFUNf2hwJfHJeJg0L1s1rxN4428jWhqTm3m6AUjcQ2kWeR4O6N92EDyPtIaa0OvPyWeZQ0lsBANREj19co1XR+syMQESQN1CppuDBWfIGNfNnwHuEBn8cq9BwKUgXhKR/if0vaiBNV1Q/A/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sosBjdYNTrjBhynMWFRWg8lUNZPX9K16eP56km3TEM4=;
 b=BuA2Bb68AXXz7N6JIfsVPGSX/R/NaUcMGhxlA6sQ8oag9r7hhjshGfH1Et8lnUNIJ5Pe0oO2xq/+wC5kW1pTUW7hoKuUao7Ot9ixhMGKfKb9cYrtit1PPFSopnlYZJw6lwlR9cmEixxmCSt3+PSSFSPvmbQp2YFd1zz/kbL6ocZq9Z0ZQVXoboSZEzKIUhmhJ5Ylb6GvLKHciUhaieqX/otVN6J6jjumLaLhlpQoCM4DIAe6hYZmRLzBPkmkOETtCbvYZiA6OxXEKLHfrAaEygWy/L5DgmXFyIZqIGXhpS40lOI01NPzpTBxWT7kNz929gGDcfI/7v0+1OfEDftQsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sosBjdYNTrjBhynMWFRWg8lUNZPX9K16eP56km3TEM4=;
 b=b2Zb6H85AdsF0/RBk5q964DDMWmAnclnjdB9+rbIWkiVnpjY45PYNOcCHeAQUfEFdKnsN7u0cKVtRgu6NX/x0vue0NpHu2/EkBR7zeeYK/jBPJPF//hENXY33RF57jpvb3ms5pCPdQ+j9Xyx5xOdTDPcRJ3wOHA3M8nTnXQsho+8SoiiBiNpS8UQqPOXIsz6RpHE3ekWTaOzXFtPELoB9RLxT3sthCuEDFx5+wzuWR5/nspjBzKM1XZ1YRKHyxuJTPHmdnTAvEQiBO/U7z22YOWaqYMKm2dSty41vOVBlL18lNIP6WK3vTuV9qvPe+x9tp94xTjjzwjTA6Odqj7mcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:34:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:34:02 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v3 1/9] irq: Add msi_device_has_isolated_msi()
Date:   Thu,  5 Jan 2023 15:33:49 -0400
Message-Id: <1-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:208:fc::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f796dec-9ea9-4cf9-857f-08daef53cb35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3DFHfClBJyIa1wUHRZIfCoGvwn8UkRt7RJo3ybWNB+qoHqldDNoYp3UkL9VjMG1dDOfzWjH7mgpDu7GTaFB0SLiN5MqmhJvP9zx4N1AdPYEWYG6cIf+afwRoK7sTiuJg+IRATIZ9QGIve9HjvDnkh4JexDwTNypkjmG0WyCuQOredybUVRg3VbqoPM85LuxP9EaHYBSJcqNSZxJFfRSsjE3INfclcXhQbpX3J8aozUWCG8hx0CayQb7cVd7zrsOGS1HhAm6A4pYR1y7s5I3bdgOJZxNTTkgx2ZJ6gvBgavQQp0Wxi/oCpWeuUrUFUbYClyyNrM6QWl2/4sQOFGnFRgo67YQJTtP4sYdgRjGw47CCxvBEWA8131gdNfDlU137FxJzN1JkK6ek1rnKte9TlREf04WyIGT7jpoJOaaRBFZlfw+vqHH4NYICMgDKsjCS/g/KUp0E+CZQglCcuW/mmiks0gCPeZ+sXJXrnzBaxbbVibkcix1TYQPNHBSweWDqsjWutLjvmK4mrSkiHIS18UAD0/nr5JC0mJTsuofxzqg9Cow8SWwm06Pa9DB/FjBJOLkqnBAE9MzFxpiL/9S5xG4ppL8tslA9mcSu7WdEt+A/oqGhAiwqgxyXld/KBftOXVaQYRKCJmX7vf0mpht56WLmljb/2IrcUkRqiqxrq4XGs2lZARN0PucRYspVb7zQhLPJ2uYyZ0H8J2VVtIVmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199015)(66556008)(7416002)(41300700001)(4326008)(66946007)(5660300002)(66476007)(8936002)(8676002)(110136005)(54906003)(2906002)(316002)(6506007)(478600001)(6512007)(6666004)(26005)(186003)(6486002)(86362001)(2616005)(83380400001)(38100700002)(921005)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YEDquqSFBRbOBA7GEisZZfAXarWgx3eaKmAuOlTOaF0C85Np3HvRcheWRZGF?=
 =?us-ascii?Q?ss0cDHnHKDW9LhI4KVbW0sOWWc7LNe/QUOmHxGxRx6eqaqSqVvk8edm4MSIS?=
 =?us-ascii?Q?wYp0gPLWZFwQ4p2TZ9hRlRpsWwmjK2nXfWq0mbKmpulRXg6nTRbaqFQKL6Cm?=
 =?us-ascii?Q?JU01RsJ7fVvYehHwrVAXPhNfSYq3jhweEbBfOkatH0xQCAoPfzT324Pq5/RJ?=
 =?us-ascii?Q?2Pf40pWBvCjLlb5wKZ/0CvgRAWZ4tUdIj9Uutvg5+1n+fLclsT5DGDwiI5RF?=
 =?us-ascii?Q?/YKp0awuYY3D6uCRYqZykLrHl9DK58562UyHcY3hoEIJ38bocuRHQdmEn9Pd?=
 =?us-ascii?Q?WfWE0+ow5KXAu2ct5vZPXAWBuPK3i3DgXO4vcQv/QkfjZKXayhVIe2WaHhpa?=
 =?us-ascii?Q?iQr5mTE5sVt1tWBL+VH6aSBd/bVX/22u36iGJSx4/UAqofDJoBSDpBqLLWmm?=
 =?us-ascii?Q?BK6R7nyz3NuFz3p/udTbvmZI7klVE6/XO4M8ChJmTDUI8aU12GK5c8Ipx4Lr?=
 =?us-ascii?Q?uOmRCv7BqEQTLHioqAslWOywA67/7BfIGCfXBB8swdkfmPqvEmdxtA/9Yc8N?=
 =?us-ascii?Q?CKlGlFBJPv1owTsL+kJEAvJCnQVSwnx5MycZaMCMsSt0nRCk2b1PeW1Yd1ds?=
 =?us-ascii?Q?acz1ldFJJ6qFbQlVYQG5+ICyPra0ZNDdBgln4YZdMSnlvLdDEEW0t1ynofLf?=
 =?us-ascii?Q?jX1L8UGESQ8aW5Ov/rQXQG32QSlt8kqjM+OyqtURK3H/0yanWUL4c0REvrm6?=
 =?us-ascii?Q?CYu6/iDlk6ZDRAPCQZrGvqVFGhVTRIES1nEZed45xJOWfWsu/vwhVCureO9r?=
 =?us-ascii?Q?kWlhPLE4HNkZVbZ4ZjtdKjn5fA0E78j4zhcqrngwGiDlAg6Rrv07wca4ryxn?=
 =?us-ascii?Q?2/GhT0EvCfuEvfhfea9Nn4BScyltbYBoSCgTC9WfOxXIeQf2XH80s4usnrQw?=
 =?us-ascii?Q?fJR/MtE6N7MJW/gZ8SJJOotlUdJuUW+CgXk6M7QrhgYdXQ8KmbEOahItYKco?=
 =?us-ascii?Q?xSHggTw0fu7bXJkl2YQ7cvfTS4Nl6VQCc79rRzKPTnL8lb9CYI3ejZHBJPQT?=
 =?us-ascii?Q?l9aizBkdVFJtmXbqcgZYC1McKBUn8O1Ei6pR6K4Z22ax5pd9W9j2bV6zNobw?=
 =?us-ascii?Q?wBl+tJKe9qhUGLqawKK9uPWOuy5Gl8cmv64wrZMdbZ9+k724XWOPpQUzWKEU?=
 =?us-ascii?Q?y7Z21NOYFuhoc0A/Fd2gRXz/QDhi+G8NG4z6dzM8cmD5yU3VKBgLzqZ1GgJ3?=
 =?us-ascii?Q?HMPVSjv0SbFA1O/a2j8n/MYUHDN6xSfOYWGeIc82uZf0bcIrN/KftdYkgEa/?=
 =?us-ascii?Q?XLHGEO4KowH7IDQ9zdCOrq7x+mR6L+elxJo0W+7eMrX1jTP6bw34Ac4OXd+i?=
 =?us-ascii?Q?VJRGva4bpWnyCvmMq0HDz/L02d+uafcRoNJjLMxT4M/6uawtqjL4+gGltgQ9?=
 =?us-ascii?Q?bQSaFi+kdupAJhMomo60Cc74dP8TaqDB3v4JUglyBQsEL+s5D3Aeap6qdfkF?=
 =?us-ascii?Q?8Y7xbWVeNGcB6M3KghgqkGubu6N8Yqt1kJD6RYMjxqMz06keTNm9Lu7c9zXg?=
 =?us-ascii?Q?JtCIR0wteMUXmTECdztR+TeYequ7y5O1GEnTxRcp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f796dec-9ea9-4cf9-857f-08daef53cb35
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:59.8670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fb69ybEkF1h/SUwY43NSSFow6oqyuHCAKvBhKuvwbUE+gEoczxMSmv81jN3kA5SZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will replace irq_domain_check_msi_remap() in following patches.

The new API makes it more clear what "msi_remap" actually means from a
functional perspective instead of identifying an implementation specific
HW feature.

Isolated MSI means that HW modeled by an irq_domain on the path from the
initiating device to the CPU will validate that the MSI message specifies
an interrupt number that the device is authorized to trigger. This must
block devices from triggering interrupts they are not authorized to
trigger.  Currently authorization means the MSI vector is one assigned to
the device.

This is interesting for securing VFIO use cases where a rouge MSI (eg
created by abusing a normal PCI MemWr DMA) must not allow the VFIO
userspace to impact outside its security domain, eg userspace triggering
interrupts on kernel drivers, a VM triggering interrupts on the
hypervisor, or a VM triggering interrupts on another VM.

As this is actually modeled as a per-irq_domain property, not a global
platform property, correct the interface to accept the device parameter
and scan through only the part of the irq_domains hierarchy originating
from the source device.

Locate the new code in msi.c as it naturally only works with
CONFIG_GENERIC_MSI_IRQ, which also requires CONFIG_IRQ_DOMAIN and
IRQ_DOMAIN_HIERARCHY.

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>
Cc: Bharat Bhushan <bharat.bhushan@nxp.com>
Cc: Will Deacon <will.deacon@arm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/msi.h | 13 +++++++++++++
 kernel/irq/msi.c    | 27 +++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index a112b913fff949..e8a3f3a8a7f427 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -649,6 +649,19 @@ int platform_msi_device_domain_alloc(struct irq_domain *domain, unsigned int vir
 void platform_msi_device_domain_free(struct irq_domain *domain, unsigned int virq,
 				     unsigned int nvec);
 void *platform_msi_get_host_data(struct irq_domain *domain);
+
+bool msi_device_has_isolated_msi(struct device *dev);
+#else /* CONFIG_GENERIC_MSI_IRQ */
+static inline bool msi_device_has_isolated_msi(struct device *dev)
+{
+	/*
+	 * Arguably if the platform does not enable MSI support then it has
+	 * "isolated MSI", as an interrupt controller that cannot receive MSIs
+	 * is inherently isolated by our definition. As nobody seems to needs
+	 * this be conservative and return false anyhow.
+	 */
+	return false;
+}
 #endif /* CONFIG_GENERIC_MSI_IRQ */
 
 /* PCI specific interfaces */
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 955267bbc2be63..dfb5d40abac9e8 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1623,3 +1623,30 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
 {
 	return (struct msi_domain_info *)domain->host_data;
 }
+
+/**
+ * msi_device_has_isolated_msi - True if the device has isolated MSI
+ * @dev: The device to check
+ *
+ * Isolated MSI means that HW modeled by an irq_domain on the path from the
+ * initiating device to the CPU will validate that the MSI message specifies an
+ * interrupt number that the device is authorized to trigger. This must block
+ * devices from triggering interrupts they are not authorized to trigger.
+ * Currently authorization means the MSI vector is one assigned to the device.
+ *
+ * This is interesting for securing VFIO use cases where a rouge MSI (eg created
+ * by abusing a normal PCI MemWr DMA) must not allow the VFIO userspace to
+ * impact outside its security domain, eg userspace triggering interrupts on
+ * kernel drivers, a VM triggering interrupts on the hypervisor, or a VM
+ * triggering interrupts on another VM.
+ */
+bool msi_device_has_isolated_msi(struct device *dev)
+{
+	struct irq_domain *domain = dev_get_msi_domain(dev);
+
+	for (; domain; domain = domain->parent)
+		if (domain->flags & IRQ_DOMAIN_FLAG_MSI_REMAP)
+			return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(msi_device_has_isolated_msi);
-- 
2.39.0

