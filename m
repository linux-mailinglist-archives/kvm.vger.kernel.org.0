Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46017596886
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 07:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiHQFNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 01:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiHQFNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 01:13:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F0A48C84;
        Tue, 16 Aug 2022 22:13:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcWDMc7ArrPWrrWNV9HWPWx5QK2ubzWG1PwPfO1VzIKV0iSmce3smT5OFvEd8jxjRfCn+0RxnNwwQUf5EYzJjHqUVRxIwhhXrQfrxgZ5/ufARbRv2IiSz8QOL2DbxNU+kAV/fFT4AAsVieKDvdL8XShk2SdNdhb7J+Vhwtza4RvHdnzGZ4jNJjSCIHeHHenbLkRaeGiGByTwGziCcziQRnL3NDvR7PLIDoryGQ8ZM/Ya35BvmmEtBYJtmxFaRSxq/FBMSA905FjGYUSRneBIWJYdMVUsUx0UPLrrDKxUdgr3xSAyZeF2+7N7Vpcz/2KUaNNf6honVbueEzaDXbb/7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GS+0AX+1mjY+BsvJVY/oyr/YmF59D85FHAMSBSUwoQA=;
 b=DBj6zQyydfqzl2WqT0uHPMVRlQQmfg0qgqCqzJOwSW8p69tjLrIcbwaH2W6DexMYWhDTaZ5c9WeCy3QHdFgcLcIvVADlEW0mUXMnaIcJm2mtGY/EIxGu6MTcirckbdeesvq6cx1A/wnoMnno2X7RPVFygnNUad7ssxkgNFHV9y9N/fQKBbp6R21bsXmTD9afW269dgzmZq2oO5rqRUUdNm6qc4FzgJWAvU1vmlZHkW9IM1G1tsCjWRZCqBkQykVmgkC9fNcOeyWdIV/zvCN80rfaEFqjAZf1bckljk+9Rt4rRbLuvH+sBTptCUuLtSaqH/Ere/tGGBv7+0ejsRSndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GS+0AX+1mjY+BsvJVY/oyr/YmF59D85FHAMSBSUwoQA=;
 b=e5sPQaloTjkhnZTNdy+TRzbZyksu8gFLHVkO8pLaPleJ+2jmm6dx/aQRu38HLV92toRwvqyHi+oDjT5zZ8boU47+e/yTKnprfOy2VS9BSkl38j9dVnVLZyT7UK/FS05LxSyHYF0UyKCLLkD9isiMpDlZ9NjcwnGHTaWL7J+4fePYwItVrVraZxJVd0RnzRjCsOnn75X4god2sE3BIfmoojcm34UB3tFsV6/b9peDI9vo0wZw0kqzfgUZuQbsI6bzNLgmyU9aCzEOLG3jSaRW7xaiIOrX0GHpJ+xfi3+Iv0PnUbhwxsBhLG9/v17jEaaPMwjgH1aeO2m054BgLNMOdA==
Received: from MW4PR04CA0226.namprd04.prod.outlook.com (2603:10b6:303:87::21)
 by BN8PR12MB3489.namprd12.prod.outlook.com (2603:10b6:408:44::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 17 Aug
 2022 05:13:41 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::be) by MW4PR04CA0226.outlook.office365.com
 (2603:10b6:303:87::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18 via Frontend
 Transport; Wed, 17 Aug 2022 05:13:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 05:13:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 05:13:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 22:13:38 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Tue, 16 Aug 2022 22:13:33 -0700
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
Subject: [PATCH v6 1/5] vfio: Add the device features for the low power entry and exit
Date:   Wed, 17 Aug 2022 10:43:19 +0530
Message-ID: <20220817051323.20091-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817051323.20091-1-abhsahu@nvidia.com>
References: <20220817051323.20091-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67af347e-e51a-4a11-44e1-08da800f3f36
X-MS-TrafficTypeDiagnostic: BN8PR12MB3489:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ExIDsbLLb5VPXHhX0AUrLf3bIv3XDE179j6qZY+/Ju5OYiiOLT/cA2Ot/lziOKDGdhNnXxLH8NnNlIcws6m+j8KLQBViosE8UWp6A1lLoXszpSrAKWJjX0U9Sgh5EkqxWEMxdSPPOA6D1w/5OXVkpwd0s0prrQMRlHe5fzgpk0CuHTb8BAJRkdvEwJGOpBlk5wdcKBeoI15Q6oyQwZcXFh65IcMRqyWUGfTzMzNDyYxVSPKj0QcW8hwtrzn+/fTUXypecGxMrqjn8hdxN5oIHJzl1m1CdfKmb7C7KnxeiwzoJwzYAGFcq0969G79kP21yNnlu9Lx+cOq9Fu5Ozi6/QRZEdXvAvFXZ/defLZgDqPNpBpD6z5A5ilmFY1AUZXg6g2qWmZL4L401TBmm+Uy8e7TB+hvp5gttlN6gBQwOQlvrd8gb2Vxy5rieMxW5GsdAiunOAT4HIzDPd7JvdIjQDEZ73JWCBqySeSqxguzat7BNIGOCXSQEXUj73MQ5TDBumFTodHKpi5OC95+m6sCm6YkFKLCSs8+b0XxbUbxudLarNuJpTo96UEcH8Y+bnmT5woGga+dQLWQlbYux8UPw9vk8WFTini2eeomnLbC97+kyPtvet6V0TW3efY/xR9ejWrao5b7oDdspYJdSilTV3A8Dts0NQFrrr0G4zlcVejgh5K6ob3bwpsVtQvIUjeHJQTZmEVMjMPrjz5BtEQFXnlz1vYJNnZ8RfikVzuU9AkSTzrhwdQKUJ5+QmJs8EqTWRWiVFab9jVNaHaXPHjDJSRssNVbJ9iX7HvYTl0M8X3iXKU9Cnb+88Tt/qMjWK6WjdYlHkftAwHeqcrlEecnNg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(46966006)(36840700001)(40470700004)(8676002)(81166007)(356005)(7416002)(36756003)(70586007)(4326008)(70206006)(82740400003)(5660300002)(82310400005)(36860700001)(6666004)(8936002)(2616005)(54906003)(316002)(2906002)(186003)(83380400001)(426003)(40480700001)(110136005)(26005)(478600001)(7696005)(86362001)(1076003)(107886003)(40460700003)(41300700001)(336012)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 05:13:39.8795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67af347e-e51a-4a11-44e1-08da800f3f36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3489
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

This patch adds the following new device features for the low
power entry and exit in the header file. The implementation for the
same will be added in the subsequent patches.

- VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
- VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
- VFIO_DEVICE_FEATURE_LOW_POWER_EXIT

For vfio-pci based devices, with the standard PCI PM registers,
all power states cannot be achieved. The platform-based power management
needs to be involved to go into the lowest power state. For doing low
power entry and exit with platform-based power management,
these device features can be used.

The entry device feature has two variants. These two variants are mainly
to support the different behaviour for the low power entry.
If there is any access for the VFIO device on the host side, then the
device will be moved out of the low power state without the user's
guest driver involvement. Some devices (for example NVIDIA VGA or
3D controller) require the user's guest driver involvement for
each low-power entry. In the first variant, the host can return the
device to low power automatically. The device will continue to
attempt to reach low power until the low power exit feature is called.
In the second variant, if the device exits low power due to an access,
the host kernel will signal the user via the provided eventfd and will
not return the device to low power without a subsequent call to one of
the low power entry features. A call to the low power exit feature is
optional if the user provided eventfd is signaled.

These device features only support VFIO_DEVICE_FEATURE_SET and
VFIO_DEVICE_FEATURE_PROBE operations.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 include/uapi/linux/vfio.h | 56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..76a173f973de 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,62 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
+ * state with the platform-based power management.  Device use of lower power
+ * states depends on factors managed by the runtime power management core,
+ * including system level support and coordinating support among dependent
+ * devices.  Enabling device low power entry does not guarantee lower power
+ * usage by the device, nor is a mechanism provided through this feature to
+ * know the current power state of the device.  If any device access happens
+ * (either from the host or through the vfio uAPI) when the device is in the
+ * low power state, then the host will move the device out of the low power
+ * state as necessary prior to the access.  Once the access is completed, the
+ * device may re-enter the low power state.  For single shot low power support
+ * with wake-up notification, see
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
+ * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
+ * calling LOW_POWER_EXIT.
+ */
+#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
+
+/*
+ * This device feature has the same behavior as
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
+ * provides an eventfd for wake-up notification.  When the device moves out of
+ * the low power state for the wake-up, the host will not allow the device to
+ * re-enter a low power state without a subsequent user call to one of the low
+ * power entry device feature IOCTLs.  Access to mmap'd device regions is
+ * disabled on LOW_POWER_ENTRY_WITH_WAKEUP and may only be resumed after the
+ * low power exit.  The low power exit can happen either through LOW_POWER_EXIT
+ * or through any other access (where the wake-up notification has been
+ * generated).  The access to mmap'd device regions will not trigger low power
+ * exit.
+ *
+ * The notification through the provided eventfd will be generated only when
+ * the device has entered and is resumed from a low power state after
+ * calling this device feature IOCTL.  A device that has not entered low power
+ * state, as managed through the runtime power management core, will not
+ * generate a notification through the provided eventfd on access.  Calling the
+ * LOW_POWER_EXIT feature is optional in the case where notification has been
+ * signaled on the provided eventfd that a resume from low power has occurred.
+ */
+struct vfio_device_low_power_entry_with_wakeup {
+	__s32 wakeup_eventfd;
+	__u32 reserved;
+};
+
+#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states as
+ * previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
+ * This device feature IOCTL may itself generate a wakeup eventfd notification
+ * in the latter case if the device had previously entered a low power state.
+ */
+#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.17.1

