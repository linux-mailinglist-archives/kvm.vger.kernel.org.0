Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6124A56324B
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbiGALJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbiGALI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:08:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA51113DEA;
        Fri,  1 Jul 2022 04:08:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAtGpwmC/G7QIl5j7aXfPQ6pzasRm4iNHMqTXkTJc2cg4biz9l5GsLJpoOx9Iv+j8L6oP9VMQMKV4NtpFh6Uazvn/jiktJs30cHnLKy+GRAfg0fpQeo8ztlEvbriMcW0Sc5jIyVfyiv1wUOIKDPhVQw/bv9FVpq7K3x+Nau1ELa7o17qC77L5rhWkaRXE9/PeftYsXUyz/SV/kqh7AnW8f6DW6eWBd3UTFBJFAzhgkTeVM4SRaIwdOh+EjSzmNRYr747D8nMyThS4VjnLxnagcLNycRhfvHbDFCgSB+wL6IFRUDEOqsTnJPI6mEK5ZCbdw4D8Sq0eM6OL4y+LoPNPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baRtbmqdjYf/awCA1mQfNe8yaCXjOVVeAntEji/Ka/0=;
 b=MTYkkki2tHr84IueB2cMdf0Y5mSaO8w4tYN+QYOXB0ML182HG5S4UjPbk1o8ui1aq01hJjH8O/atX8c/qUZjhtDqtrI9RI1hdj4JsocC8FiU5BTVUTyvi3lfqMloC26SVXtEvZhtxfAMnlzMzVze/eqQNLYs/UQqrlxtMGrqYFId9+Ad8E3tf0aPHuVMGEanWcyLnmyoL2/8peU+UieIPpwKVTW2ZnChCnBOgZR9/bB1ez1r9D4cyBshOqwzRjmExDfX5vtNbVbnV5soPM42FkZCNA8beNzCyhbng8DxqveQVlcq5RgeYwvQcDYu9oF/IipsAQVuKkLpOLhkfICE3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baRtbmqdjYf/awCA1mQfNe8yaCXjOVVeAntEji/Ka/0=;
 b=AiBM3rgdCcSulQ7cVK4N9UggaWKqx3nEwboZ6SoPQZboQYAnvKqDeqcdlT5/ic+gJKQRhaSBJWC6BO+7fC1u/bq2yHh0wWfrTR+1s3FVM0jtHz4ijUHaKMQk62231XRjXtXZ9TQmfJ2rF+Y7I8GtKmgVO5nZJc8uLFLoUj1X4fDyjv3+IejoAJGb9TkudfZBoPRE32RKwMaP6wuisymwxdUIJTMB/l5TZ5LEmK20rbT/TY793N0Fz3tDS8eUBWNNL5UqJxk5L12donSQNvemFgUZHZ/tAOd45mUtmjZiqD7rdamoVeAHvvoSMIHXZk9CJKuqBrw037EP/jSVwOZYpw==
Received: from CO2PR04CA0200.namprd04.prod.outlook.com (2603:10b6:104:5::30)
 by BYAPR12MB2632.namprd12.prod.outlook.com (2603:10b6:a03:6c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Fri, 1 Jul
 2022 11:08:49 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::9c) by CO2PR04CA0200.outlook.office365.com
 (2603:10b6:104:5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Fri, 1 Jul 2022 11:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Fri, 1 Jul 2022 11:08:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 11:08:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 04:08:33 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 04:08:28 -0700
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
Subject: [PATCH v4 2/6] vfio: Add a new device feature for the power management
Date:   Fri, 1 Jul 2022 16:38:10 +0530
Message-ID: <20220701110814.7310-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701110814.7310-1-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef5353e0-0330-4d04-87b1-08da5b5212d8
X-MS-TrafficTypeDiagnostic: BYAPR12MB2632:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05+ghnD6cpU5ybByA7kxBnDsiD9RYaPUzhFPmmEiiwtyyRSsPF3X6cwfU316AObSdvblUV6JMYUG3x1FyxyyleGCodlfGD16Uhu71yqbTUf2+dgpLycNnniuifTNgN1BThxo6S33i1/wMpRzUKZvxevWbrY6o3zPhSXVRnPK57SlQsQn4SGo3Smj0bRjO1kD/7mJP30NjFDSDdbkGJ8oMGgZpFVv21B9DvKSQGnNAiv6Z7XUptR1hOQUPNSEpjeIfdFwZM0k0OMBJJVjm0W9F1bX7ORO6Li8Ie/bjWW9VGiSC+dF7EgSwALn9MJC1leFEr7YR1MiR7F9Z94Idap32MDoUBa1R7xx53UGTrvcnjmy2NGGl/IpqnNbmBu4y4GKhEUrf8VYzo6KhHudFvqNmzln2zROTlpmjzXsHM+mxeAaxPXK0d4AqzfRDmu6PmvaVAPpPFaVjAnndrLY9G+CPzM3019Gf/QpgxtknfE/5p+yDzb+cK7ww+mHai1VrqtwxA7dXRKT7D+875LGjxlLvtFW/u640b3biQigqOm+ad/3ADbZjTh3eXVrVADONpW6NtzVrBC55t1eD4go/kdvjUII8IzmvZYBUouU3ZctHv4cD1Dc8gIPgzCeOCttiPM80eRvewt8pwVr+y9fcKKY6C/sOTYJWNrIjaZ5lqENEGAm1HgGBMgzcu4Eo/Z1faxri8ooj5XzCxZyiKLpfUo2wPhI8QQKNUdmYh5mbCo2LRd4TmOG9FbNCWqK45ky94OkmirFK2OgPMwBf9yoMQitK7OjJro1aroJEdMKEpfUzH+jAHlsuALtNkxCtTOeJ6/s/Q1h7u/ppcnwbqORA9ZdWwBVt6Hqkc+Tdfa0ql3EKSU=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(346002)(136003)(40470700004)(36840700001)(46966006)(70206006)(426003)(83380400001)(41300700001)(36860700001)(54906003)(81166007)(186003)(110136005)(107886003)(2616005)(82310400005)(336012)(356005)(1076003)(82740400003)(40460700003)(70586007)(86362001)(7696005)(8936002)(478600001)(4326008)(47076005)(7416002)(316002)(8676002)(2906002)(36756003)(26005)(5660300002)(40480700001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 11:08:48.6722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5353e0-0330-4d04-87b1-08da5b5212d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2632
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the new feature VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
for the power management in the header file. The implementation for the
same will be added in the subsequent patches.

With the standard registers, all power states cannot be achieved. The
platform-based power management needs to be involved to go into the
lowest power state. For all the platform-based power management, this
device feature can be used.

This device feature uses flags to specify the different operations. In
the future, if any more power management functionality is needed then
a new flag can be added to it. It supports both GET and SET operations.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..7e00de5c21ea 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,61 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Perform power management-related operations for the VFIO device.
+ *
+ * The low power feature uses platform-based power management to move the
+ * device into the low power state.  This low power state is device-specific.
+ *
+ * This device feature uses flags to specify the different operations.
+ * It supports both the GET and SET operations.
+ *
+ * - VFIO_PM_LOW_POWER_ENTER flag moves the VFIO device into the low power
+ *   state with platform-based power management.  This low power state will be
+ *   internal to the VFIO driver and the user will not come to know which power
+ *   state is chosen.  Once the user has moved the VFIO device into the low
+ *   power state, then the user should not do any device access without moving
+ *   the device out of the low power state.
+ *
+ * - VFIO_PM_LOW_POWER_EXIT flag moves the VFIO device out of the low power
+ *    state.  This flag should only be set if the user has previously put the
+ *    device into low power state with the VFIO_PM_LOW_POWER_ENTER flag.
+ *
+ * - VFIO_PM_LOW_POWER_ENTER and VFIO_PM_LOW_POWER_EXIT are mutually exclusive.
+ *
+ * - VFIO_PM_LOW_POWER_REENTERY_DISABLE flag is only valid with
+ *   VFIO_PM_LOW_POWER_ENTER.  If there is any access for the VFIO device on
+ *   the host side, then the device will be moved out of the low power state
+ *   without the user's guest driver involvement.  Some devices require the
+ *   user's guest driver involvement for each low-power entry.  If this flag is
+ *   set, then the re-entry to the low power state will be disabled, and the
+ *   host kernel will not move the device again into the low power state.
+ *   The VFIO driver internally maintains a list of devices for which low
+ *   power re-entry is disabled by default and for those devices, the
+ *   re-entry will be disabled even if the user has not set this flag
+ *   explicitly.
+ *
+ * For the IOCTL call with VFIO_DEVICE_FEATURE_GET:
+ *
+ * - VFIO_PM_LOW_POWER_ENTER will be set if the user has put the device into
+ *   the low power state, otherwise, VFIO_PM_LOW_POWER_EXIT will be set.
+ *
+ * - If the device is in a normal power state currently, then
+ *   VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set for the devices where low
+ *   power re-entry is disabled by default.  If the device is in the low power
+ *   state currently, then VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set
+ *   according to the current transition.
+ */
+struct vfio_device_feature_power_management {
+	__u32	flags;
+#define VFIO_PM_LOW_POWER_ENTER			(1 << 0)
+#define VFIO_PM_LOW_POWER_EXIT			(1 << 1)
+#define VFIO_PM_LOW_POWER_REENTERY_DISABLE	(1 << 2)
+	__u32	reserved;
+};
+
+#define VFIO_DEVICE_FEATURE_POWER_MANAGEMENT	3
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.17.1

