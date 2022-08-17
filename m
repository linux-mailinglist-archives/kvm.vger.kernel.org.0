Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07845972EC
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbiHQPaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbiHQP36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:29:58 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4522C22BD6;
        Wed, 17 Aug 2022 08:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpYr3FDjlZYH4f3B65ibzzf+sQhQDeuucCgpXfNcISRCl26p6w6MEbNedmddkA8GMz/7HMMHWHzQc7TPc7IdGsJ+XADpg+SDvo2MW+57bp6kYMvwe1FRrm9hYpNXDEtheMvdjZQ8U8PGC21kQKJ2C4xyjI6ljJGOeyo4qgPRH9Gs2eQT2aChtRskK8WF7TfvVggBN1gb14qHGni+Zk6gPSKP02ZKvmGaMnPVNWhb7XaUmnHvgnh5Zr/5gUe2RlqqB/JTk/DWmLcGucqsO7QAS54f96LMLJZu1W1k6x1zTyzHy4vl+vhXVz1byBT3ZPOV1KngH8N7Zy/yZM9sl8LGyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ab6nMZqNK5h9F3NYRK/HcZEYPwyGJsEH7CF0v47OyE=;
 b=PkvqCGfJSA8gm/71GUwBDmPJOm+NJeKF5FJukb2VHrHikUzpFs89FpXOSKpjweNIhuIjKpTby7CXLI9ss84S4LCvjmwX62xsLupr2isfDWFylCZojZP1Qw9WoE1Rx1qGDrSryhSmR9gXbN0sRrIConVn8mdQYde8WCmRCELxjdOolS3pD/gl2rUwW/61EPVFsvXxLQqlKHKjqj4mZn86vSUeffacOxDI87zG07950sj1Ula8ExsMQD0hUnypULgdQwSYHee2UtxUWdKCH/ska5a2FRMjXtFBY/lHm83b8ys05dnIUM0FhDVV9S/K3BYjaqATF4tu8DnQsbMwGofq7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ab6nMZqNK5h9F3NYRK/HcZEYPwyGJsEH7CF0v47OyE=;
 b=CU3rxxQ7jU43Y/8RaVW0/4ivjey4EC7fWz1EU55+hfwlX5DFYq3oyXU3kR1hS9ZKR6HBiw68A7LSaiB84gcrUoJeYWViH4CcJ8TjFT4QRVGI3eNNZ4zOQ6Tskasg9n1XNxisBdadjmIWjrNrrLk358BwwWSpu61BOm7a+8eEOEwdGlkr3zyrg28xn6VnRFVkkk0d8i5e/vWCDAuZ49g6z3ZINFdhPsgYe3lNY2/HfBwzR40R4NnFIWSNSsO2EnUkw+wsUIUWnuRvqMNX+zmdxUZJQWAENIms/WE6ZeGVH/jj3hlOaEZUWfPdu58qZePmlbkpLSAqETbfBJ5QuuBJNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3689.namprd12.prod.outlook.com (2603:10b6:5:1c7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 17 Aug
 2022 15:29:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 15:29:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 1/2] vfio/pci: Split linux/vfio_pci_core.h
Date:   Wed, 17 Aug 2022 12:29:50 -0300
Message-Id: <1-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c36d572-bc42-41ec-9d29-08da8065547c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3689:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D79S+meut1EqZkQqvWXD03IYEIYYpAtX/WPIrMUuYfjxXoDXuzXl5YSHAYJAzSr5OGIywZa9vI1naq5B7y20+G7gHQ/F7+v/xICjXI6CUtc4gFn3GJAOuzXUBkp6lnJJKU4G4jYJtJFCTxOl0H2132/eYm255y1Ro1PW8sn9ZtGHrOAxf5JOAa2IGXe5EuhcnuI0+/7X+YFd1SSbO7xqMFDQ10y7YU9pFnuM1chN7RZxHCXMUcv2H66auem2bsRD9PO60lJEMup8lL0PfPPMSp5UwTJp+wnvXwVy14cZtJXgYPT/5Qu4EmQ426u6VhEWGCldNSYZGc2ggFhIKoFiLl5JDMt7NrAbgkrMLg0aYsG8ETmIZL6HexdiN9hdvOmR5k2bG0zDmqdWFueUxiVTGD6hDwLXyNcfAGFz8l7NdR78s1ndN+pyLONzY+jsaUO9jh8rCn5mvuRbZCkm7xCS4+2hDgBll/tvjS5Ryxok48hzOZPvTiMCJfdZNwBGTnR8nO0Ov129waU4KSzvLNMWlaUXwdLzWywti+RUjzuIgEaVnHaBNwgu8W6IkBblB/D2/2WxiQ1eGyoVnqmwUSKGe8jejsZp0zaYmcHYLUSOcG6pttrBj2POgpnhVgTAWvPJYD+jk+9JV0GOnZZzxAc/CML8AbUtHQDZmthOG33aV6t3HgPdz93qL5WlMHHpa/CsHlBYK6lmTDM0Wo+iYVjxb7dE3VTyYj0+BWstM4u1PeGBUSeBrxJam3ZT9HhJNzl/xjlpNn0Mru2uuGNc4D+i9j11D3inIR0iSgCnFBzA1LU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(2616005)(66556008)(26005)(8676002)(66476007)(316002)(83380400001)(36756003)(186003)(6512007)(66946007)(86362001)(5660300002)(2906002)(8936002)(478600001)(110136005)(6486002)(6506007)(41300700001)(30864003)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qNEGzCh8w/xpMSJ6L3mfagqMBsdsFTigpscBQYco+asImpcCjimPj4Y6HeO5?=
 =?us-ascii?Q?EyhS5zMiP44+hrJX63HhwtgqgNyxCf0apY0nt1gSzgkPUIoF5MSVxgeVcDOY?=
 =?us-ascii?Q?gdAFQReI/qXC167isG4h2Tj5wya8GcqsYS/7yS+B0Du41pXfTwsStxr4U5E4?=
 =?us-ascii?Q?FU5HQwTCWxeLCtHMkcEMpJAuN6WmykYCUsKfpNLb5tHKyM3CXNbETeKLq9k6?=
 =?us-ascii?Q?jGg4cqH8+OOoB6I0+O/dhbn78OkhKXxesVPtoo10Z9WhJTFJsxfYHSCcs9sZ?=
 =?us-ascii?Q?wTKqX2WMCvoiT9i3pAqnZHGGZQhfJtAXSJ70jKNwXrk3oyCgPnR3Grk7OLqU?=
 =?us-ascii?Q?r7sB4KDlbhgP8QJVZLs/0TVhgX4HUyZjodqzOfAvnB6p+ILF+qAJhHNdX/P4?=
 =?us-ascii?Q?hOvJ0FQE9P2RbZhF8Niwo8QL5bDMqp+jTaU8zjEDtxdBltBClIdgSnNPAAXU?=
 =?us-ascii?Q?qxUJi6mex25m46qBQT2WOTHat4NfR2drx/rwOSEf4nnAajcdj6z/jn2Pt1P+?=
 =?us-ascii?Q?u7Hnv2TfqJ4gM+M700Qkt9+edsw65SurzzsHwJEHCU8h8iLMncpzR/Ri6Gpn?=
 =?us-ascii?Q?E4v9VpG8mBC2ow3KKf0TCvceFGXLvF6VZqSDmgXve9Oq664WtYGRmakmft+2?=
 =?us-ascii?Q?/bE3W74u10/GC8W+n6PkBKURG/buPGLLKgBsIcP930MG1l/q/y+PgbMi9QsQ?=
 =?us-ascii?Q?tV7c3Lt+WVzSSmrkg3Dap2X+bSGTs4mNcWr6lLYelyILUj0TqOGKm8c8xg3N?=
 =?us-ascii?Q?WmvAtq7qPxNUzVe2A6k8eejhFQS4vs0OxXfraZNjDDUU7J1ms8uGTCffl9RW?=
 =?us-ascii?Q?JQ+66IpGzc1tt7zBB9TDa4X20b9exYuKHbl60Int77CIg3DeNExblxtFsXiM?=
 =?us-ascii?Q?YVnGp0laTg1/7u+qX0ZtAIdvCUw+78jcr4ocPUJ5xdv43xkY/OYrcVqMj1wR?=
 =?us-ascii?Q?xHBbyrUrE/f/IoAG/B+BR5HANIPJcIIo2+WW1Cjvvcyrie1zwuEkcQ9JJ7l2?=
 =?us-ascii?Q?7h0RMi/d9dPFD11OzrfEZS8jQJSYGiX6gOMYkhyFeU1M7UWfjXpzDpqyELhn?=
 =?us-ascii?Q?hf06W2SlPNWtLLAm0F1wh5fzh2HZM9+Ki56cFAys/Mhbp4yU6ZgqC3sZGv69?=
 =?us-ascii?Q?0NHtkAvJvFzxXEgc5zA1gIPv+BEikKP7JobES7H/nqTNUt4cCJZuBSoVHs0V?=
 =?us-ascii?Q?G2moy7Ayhkcfi2UoZ3UHTOrct7/AuV8Eiff4Edl0Ks2Ta/iTjXe+qXBg+Y2y?=
 =?us-ascii?Q?AiWIzovkUUDSh6rAV00wTA4Fj4OMyLwg8mFtJjs2eI/ksaI8aslWh9wz062B?=
 =?us-ascii?Q?TE4LJcLbxVv0ivbi1Gn/PLASdw+Z73XU/WkMvyva3tePo9/8h0TWN4Yka7gR?=
 =?us-ascii?Q?BpFlm1Zh8ksL8nkZE62l59tu99KOWrMSQqU/dFu/8XqDLkn6IHwX2AGD4McY?=
 =?us-ascii?Q?QX7V/QsdTHWJhXVIjOEP65aPzR3iRaFePnZVKazLAikxScQCQxN1nA1j9uoH?=
 =?us-ascii?Q?H8Mi5uAMjLSluTF/7Gvk2vF86fWS50tRboamPjBOrtRhHT01h67JIYrs97gb?=
 =?us-ascii?Q?cZbDtoeV0V0JVZlCYTSnNRcEQUFvafv0B8uJ2+6r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c36d572-bc42-41ec-9d29-08da8065547c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:29:52.8069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1peLTSwgw5IcevHIkEf57/zc5+5RIfW8Zl+gL24qycgi3nq09Mr7kmRxrrKdanM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3689
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The header in include/linux should have only the exported interface for
other vfio_pci module's to use.  Internal definitions for vfio_pci.ko
should be in a "priv" header along side the .c files.

Move the internal declarations out of vfio_pci_core.h. They either move to
vfio_pci_priv.h or to the C file that is the only user.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c        |   2 +-
 drivers/vfio/pci/vfio_pci_config.c |   2 +-
 drivers/vfio/pci/vfio_pci_core.c   |  19 +++-
 drivers/vfio/pci/vfio_pci_igd.c    |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c  |  16 +++-
 drivers/vfio/pci/vfio_pci_priv.h   | 106 +++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c   |   2 +-
 drivers/vfio/pci/vfio_pci_zdev.c   |   2 +-
 include/linux/vfio_pci_core.h      | 134 +----------------------------
 9 files changed, 145 insertions(+), 140 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_priv.h

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 4d1a97415a27bf..d9b5c03f8d5b23 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -25,7 +25,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 442d3ba4122b22..5f43b28075eecd 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -26,7 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/slab.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 /* Fake capability ID for standard config space */
 #define PCI_CAP_ID_BASIC	0
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c8d3b0450fb35b..04180a0836cc90 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,7 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC "core driver for VFIO based PCI devices"
@@ -41,6 +41,23 @@ static bool disable_idle_d3;
 static DEFINE_MUTEX(vfio_pci_sriov_pfs_mutex);
 static LIST_HEAD(vfio_pci_sriov_pfs);
 
+struct vfio_pci_dummy_resource {
+	struct resource		resource;
+	int			index;
+	struct list_head	res_next;
+};
+
+struct vfio_pci_vf_token {
+	struct mutex		lock;
+	uuid_t			uuid;
+	int			users;
+};
+
+struct vfio_pci_mmap_vma {
+	struct vm_area_struct	*vma;
+	struct list_head	vma_next;
+};
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 352c725ccf1812..8177e9a1da3bfd 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -15,7 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6069a11fb51acf..32d014421c1f61 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -20,7 +20,21 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
+
+#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
+#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
+#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
+#define irq_is(vdev, type) (vdev->irq_type == type)
+
+struct vfio_pci_irq_ctx {
+	struct eventfd_ctx	*trigger;
+	struct virqfd		*unmask;
+	struct virqfd		*mask;
+	char			*name;
+	bool			masked;
+	struct irq_bypass_producer	producer;
+};
 
 /*
  * INTx
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
new file mode 100644
index 00000000000000..ac701f05bef022
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VFIO_PCI_PRIV_H
+#define VFIO_PCI_PRIV_H
+
+#include <linux/vfio_pci_core.h>
+
+/* Special capability IDs predefined access */
+#define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
+#define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
+
+/* Cap maximum number of ioeventfds per device (arbitrary) */
+#define VFIO_PCI_IOEVENTFD_MAX		1000
+
+struct vfio_pci_ioeventfd {
+	struct list_head	next;
+	struct vfio_pci_core_device	*vdev;
+	struct virqfd		*virqfd;
+	void __iomem		*addr;
+	uint64_t		data;
+	loff_t			pos;
+	int			bar;
+	int			count;
+	bool			test_mem;
+};
+
+#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
+
+void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
+
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
+			    unsigned index, unsigned start, unsigned count,
+			    void *data);
+
+ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			   size_t count, loff_t *ppos, bool iswrite);
+
+ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite);
+
+#ifdef CONFIG_VFIO_PCI_VGA
+ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite);
+#else
+static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite)
+{
+	return -EINVAL;
+}
+#endif
+
+long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
+			uint64_t data, int count, int fd);
+
+int vfio_pci_init_perm_bits(void);
+void vfio_pci_uninit_perm_bits(void);
+
+int vfio_config_init(struct vfio_pci_core_device *vdev);
+void vfio_config_free(struct vfio_pci_core_device *vdev);
+
+int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
+			     pci_power_t state);
+
+bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
+void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
+u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
+void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
+					u16 cmd);
+
+#ifdef CONFIG_VFIO_PCI_IGD
+int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
+#else
+static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
+{
+	return -ENODEV;
+}
+#endif
+
+#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
+int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
+				struct vfio_info_cap *caps);
+int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
+void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
+#else
+static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
+					      struct vfio_info_cap *caps)
+{
+	return -ENODEV;
+}
+
+static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
+{
+	return 0;
+}
+
+static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
+{}
+#endif
+
+static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
+{
+	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
+}
+
+#endif
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 82ac1569deb052..d5e9883c1eee10 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,7 +17,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #ifdef __LITTLE_ENDIAN
 #define vfio_ioread64	ioread64
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index e163aa9f61444f..0bff24f0d4d717 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -15,7 +15,7 @@
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 /*
  * Add the Base PCI Function information to the device info region.
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5579ece4347bdc..9d18b832e61a0d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -20,39 +20,10 @@
 #define VFIO_PCI_CORE_H
 
 #define VFIO_PCI_OFFSET_SHIFT   40
-
 #define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
 #define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
 #define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
 
-/* Special capability IDs predefined access */
-#define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
-#define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
-
-/* Cap maximum number of ioeventfds per device (arbitrary) */
-#define VFIO_PCI_IOEVENTFD_MAX		1000
-
-struct vfio_pci_ioeventfd {
-	struct list_head	next;
-	struct vfio_pci_core_device	*vdev;
-	struct virqfd		*virqfd;
-	void __iomem		*addr;
-	uint64_t		data;
-	loff_t			pos;
-	int			bar;
-	int			count;
-	bool			test_mem;
-};
-
-struct vfio_pci_irq_ctx {
-	struct eventfd_ctx	*trigger;
-	struct virqfd		*unmask;
-	struct virqfd		*mask;
-	char			*name;
-	bool			masked;
-	struct irq_bypass_producer	producer;
-};
-
 struct vfio_pci_core_device;
 struct vfio_pci_region;
 
@@ -78,23 +49,6 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
-struct vfio_pci_dummy_resource {
-	struct resource		resource;
-	int			index;
-	struct list_head	res_next;
-};
-
-struct vfio_pci_vf_token {
-	struct mutex		lock;
-	uuid_t			uuid;
-	int			users;
-};
-
-struct vfio_pci_mmap_vma {
-	struct vm_area_struct	*vma;
-	struct list_head	vma_next;
-};
-
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -141,92 +95,11 @@ struct vfio_pci_core_device {
 	struct rw_semaphore	memory_lock;
 };
 
-#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
-#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
-#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
-#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
-#define irq_is(vdev, type) (vdev->irq_type == type)
-
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
-void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
-
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
-			    uint32_t flags, unsigned index,
-			    unsigned start, unsigned count, void *data);
-
-ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
-			   char __user *buf, size_t count,
-			   loff_t *ppos, bool iswrite);
-
-ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			size_t count, loff_t *ppos, bool iswrite);
-
-#ifdef CONFIG_VFIO_PCI_VGA
-ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			size_t count, loff_t *ppos, bool iswrite);
-#else
-static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
-				      char __user *buf, size_t count,
-				      loff_t *ppos, bool iswrite)
-{
-	return -EINVAL;
-}
-#endif
-
-long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
-			uint64_t data, int count, int fd);
-
-int vfio_pci_init_perm_bits(void);
-void vfio_pci_uninit_perm_bits(void);
-
-int vfio_config_init(struct vfio_pci_core_device *vdev);
-void vfio_config_free(struct vfio_pci_core_device *vdev);
-
+/* Will be exported for vfio pci drivers usage */
 int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 				 unsigned int type, unsigned int subtype,
 				 const struct vfio_pci_regops *ops,
 				 size_t size, u32 flags, void *data);
-
-int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
-			     pci_power_t state);
-
-bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
-void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
-u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
-void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
-					u16 cmd);
-
-#ifdef CONFIG_VFIO_PCI_IGD
-int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
-#else
-static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
-{
-	return -ENODEV;
-}
-#endif
-
-#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
-int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
-				struct vfio_info_cap *caps);
-int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
-void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
-#else
-static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
-					      struct vfio_info_cap *caps)
-{
-	return -ENODEV;
-}
-
-static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
-{
-	return 0;
-}
-
-static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
-{}
-#endif
-
-/* Will be exported for vfio pci drivers usage */
 void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
@@ -256,9 +129,4 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
-{
-	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-}
-
 #endif /* VFIO_PCI_CORE_H */
-- 
2.37.2

