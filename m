Return-Path: <kvm+bounces-8852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC848573E6
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 04:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 734191F24CB1
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 03:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06981DF6B;
	Fri, 16 Feb 2024 03:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s+bJGzmW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A9134B6;
	Fri, 16 Feb 2024 03:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708052527; cv=fail; b=gchxoLecE8qXCyXofv9ubtWZWco0GVq6YOLs9h5yFltx8SuYR38m+e/b3xGzBsxBto3FxQwt56YMNG1EqMttActYECSMPQKBhht41TsStiNejiVluwaYHZS7oJMO7uyut4a4kOtvPX7x0AlxX96Wc1SeuqcDFKb2/UXXz9gWARk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708052527; c=relaxed/simple;
	bh=ukUi+xABAv9WyeKr/OP0twmoraTWEKarfCIRqdwlJTI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=knmiA0smafd4Dcbwti7CFbL9YzJXE8oDHIPZMkpNAECV/ntN8t9EYAIqaZb2HOgOYrkMmuB28Ez3+pXqf5iWiUsJG4+u9s4r2QK5/7lmBVR0DIHo1k6kezqYm0bYJ/3EpJ0OKPzxoGM/xMDOAXS26cIJVUMCztjpgzAQ045qqP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s+bJGzmW; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx++n99L7G7D5jIjznQyWop9fCdb2UiQA0tOtqb0eyXh/qyI3x75bdFtU3WnynXIcw7FzYDryAPg4sYUIbV68SZ+frAyI6ouQbzCcg9HqvpVsQIaMiKlrCalyUttrctDCNQtUt/omRUE7Wrip0anum5qmQBOqCaZqTqtvyPNb+ZVElA3pN/mx83x1jwtKWWwmOFgGQxyDnA/qcseCGA5AzneS/IQFBJTJbLnek4WcNI/uBpTh2FoLpjLv4Y6JAKi1eBBXwdSmWI6bHzpS0KrD/YkZdkzhT1D8ojd+QoMxaSO9dzULZNyQH9w6YHFipRxaS8+frBcy1h4Jp69bphZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yyhlzK9zygalBLTF6yERt+KQfoFCLblTVO/Wvp5MwLE=;
 b=dQLOgyvms02xtfG5d2hi1Rf006NTYIk64IvKu1AEOxS/5AREacvUhadRilGmHVY/iUpSvrDnGpnsb7CBeI78ekJ64kZpjzaeUxrtSng59/7moLJDPexNB1GqBpapP5tuGHrShj55SxvKwsgviJw93i58JI0BDt6/tTjjB2e8zJj1evdw+wE4wKxFGiy6srvfr6ikzvgNu4zRusf/pqmJ4bp0AZQS0AK1Y6T5gvFMK+M52WMByXNkF7C++sgvHXFJ1/G8/uqDDuiNCeQIbUFWkY5s/zlTCsn16lM0zH7IG/CMZlaKNog5MeqAAqcPwFMOBuwRBQqJTZ9yAxBTJNtrkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyhlzK9zygalBLTF6yERt+KQfoFCLblTVO/Wvp5MwLE=;
 b=s+bJGzmWWIBM8LG14m/0yrCCJ6dFPrcqpqM9v17+fuoiwMQlmMLWVO5It8rMiwW9vQfF+THPT00josn/mgThwsKCaOpqx36PtX4x1Jpn4YPOVD65Am4o+pLNDA1JoPC5vIH6EnQZqwnvC0OIfryCUdo+WAWpvVIILsv1mW0JUjz6EjlFlkWEGppBGzvbT2JVQT6/ygoZY8Yt3ypY86NV9emuH1fsOG2PjcW8jltedI2XEk+UflWeU//fcIUnKrN7yUCNXyI3F6bD2lK1KBkjHwC9ojfrS8LtcNbL1FfzC9MN4rXKSdPn+FyMKksr2QalbtUs8Tfn+u72YOhS6Zo/sA==
Received: from CY5PR18CA0054.namprd18.prod.outlook.com (2603:10b6:930:13::30)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.24; Fri, 16 Feb
 2024 03:02:02 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:930:13:cafe::96) by CY5PR18CA0054.outlook.office365.com
 (2603:10b6:930:13::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Fri, 16 Feb 2024 03:02:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Fri, 16 Feb 2024 03:02:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 15 Feb
 2024 19:01:53 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Thu, 15 Feb 2024 19:01:52 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 15 Feb 2024 19:01:45 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mst@redhat.com>, <eric.auger@redhat.com>,
	<jgg@ziepe.ca>, <oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v18 2/3] vfio/pci: rename and export range_intersect_range
Date: Fri, 16 Feb 2024 08:31:27 +0530
Message-ID: <20240216030128.29154-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240216030128.29154-1-ankita@nvidia.com>
References: <20240216030128.29154-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: cb318344-f808-49ec-4149-08dc2e9ba60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TwyR88Bd87gP0pKbihXthzRKOqoEo8fi8Srx2UxMDi9lSpwPTAnGxj2JhNo7hWGM2WrYV7nPYvgO5pVgibQO1jpEs+1Q+dlOj/v3qNVy5/Zslwkix/JPNFHl/EfLeXyDC42olZak/dV4Gh2muYjhNBje3Yzv0V1pMtphSYIvC7STT898/WhN9MsApHsFW2CoCMhhIl8EEarAz97NlfPy4B96vrREy37kiLsWjHiw/+ZjZEAiCax4KCivrbj3i86TzwNM5MYJ/H/r9ie6wW4RD1Jcd5RlaD/OkZ/xwo0SHyIcsRPLBzt1RcNzMm6bfjMvhcQQY8Mek3mSoLuAzPgrotIbkJ5l5ttku664wepnhbsSuxjL18cQ59aDD6wyC3zQ2bUTPjmwX+EPYASUNcGqZ4u0ixhLK04v8j7CAEZHgrAOp475vSbQDKqPGOFLPdCzpmHfOGfuZ1tiAbWH33mu2/bD2S+9DRnOGS+06Zklcs8kd3BfV0rGsKyL+UWJ87DGqzU8gpLoW6O/1be1CYqOTR2fEAt6r9VB19rgSkYUo2I8ohC5vjjNKEnd3uLRAxufPsjaQZRlL92jd/TpYVWCMyeyU21pUDyl9hsdXCCHZzpWIkiEQnVohDz3XrCM3RiqZtj5gSUlaALySHqE01c2sbx3x7qsAVx+DhJYaBNd/2Y=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(396003)(136003)(230922051799003)(82310400011)(186009)(1800799012)(36860700004)(64100799003)(451199024)(46966006)(40470700004)(8936002)(8676002)(2876002)(5660300002)(7416002)(2906002)(4326008)(70586007)(426003)(336012)(86362001)(26005)(36756003)(356005)(2616005)(316002)(82740400003)(70206006)(54906003)(7636003)(1076003)(921011)(110136005)(6666004)(7696005)(83380400001)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 03:02:01.9434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb318344-f808-49ec-4149-08dc2e9ba60e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352

From: Ankit Agrawal <ankita@nvidia.com>

range_intersect_range determines an overlap between two ranges. If an
overlap, the helper function returns the overlapping offset and size.

The VFIO PCI variant driver emulates the PCI config space BAR offset
registers. These offset may be accessed for read/write with a variety
of lengths including sub-word sizes from sub-word offsets. The driver
makes use of this helper function to read/write the targeted part of
the emulated register.

Make this a vfio_pci_core function, rename and export as GPL. Also
update references in virtio driver.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 42 +++++++++++++++++
 drivers/vfio/pci/virtio/main.c     | 72 +++++++++++-------------------
 include/linux/vfio_pci_core.h      |  5 +++
 3 files changed, 73 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 672a1804af6a..e2e6173a3375 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1966,3 +1966,45 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	return done;
 }
+
+/**
+ * vfio_pci_core_range_intersect_range() - Determine overlap between a buffer
+ *					   and register offset ranges.
+ * @buf_start:		start offset of the buffer
+ * @buf_cnt:		number of buffer bytes.
+ * @reg_start:		start register offset
+ * @reg_cnt:		number of register bytes
+ * @buf_offset:	start offset of overlap in the buffer
+ * @intersect_count:	number of overlapping bytes
+ * @register_offset:	start offset of overlap in register
+ *
+ * Returns: true if there is overlap, false if not.
+ * The overlap start and size is returned through function args.
+ */
+bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
+					 loff_t reg_start, size_t reg_cnt,
+					 loff_t *buf_offset,
+					 size_t *intersect_count,
+					 size_t *register_offset)
+{
+	if (buf_start <= reg_start &&
+	    buf_start + buf_cnt > reg_start) {
+		*buf_offset = reg_start - buf_start;
+		*intersect_count = min_t(size_t, reg_cnt,
+					 buf_start + buf_cnt - reg_start);
+		*register_offset = 0;
+		return true;
+	}
+
+	if (buf_start > reg_start &&
+	    buf_start < reg_start + reg_cnt) {
+		*buf_offset = 0;
+		*intersect_count = min_t(size_t, buf_cnt,
+					 reg_start + reg_cnt - buf_start);
+		*register_offset = buf_start - reg_start;
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_range_intersect_range);
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index d5af683837d3..b5d3a8c5bbc9 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -132,33 +132,6 @@ virtiovf_pci_bar0_rw(struct virtiovf_pci_core_device *virtvdev,
 	return ret ? ret : count;
 }
 
-static bool range_intersect_range(loff_t range1_start, size_t count1,
-				  loff_t range2_start, size_t count2,
-				  loff_t *start_offset,
-				  size_t *intersect_count,
-				  size_t *register_offset)
-{
-	if (range1_start <= range2_start &&
-	    range1_start + count1 > range2_start) {
-		*start_offset = range2_start - range1_start;
-		*intersect_count = min_t(size_t, count2,
-					 range1_start + count1 - range2_start);
-		*register_offset = 0;
-		return true;
-	}
-
-	if (range1_start > range2_start &&
-	    range1_start < range2_start + count2) {
-		*start_offset = 0;
-		*intersect_count = min_t(size_t, count1,
-					 range2_start + count2 - range1_start);
-		*register_offset = range1_start - range2_start;
-		return true;
-	}
-
-	return false;
-}
-
 static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 					char __user *buf, size_t count,
 					loff_t *ppos)
@@ -178,16 +151,18 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 	if (ret < 0)
 		return ret;
 
-	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_DEVICE_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
 		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
 			return -EFAULT;
 	}
 
 	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
-	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	    vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
 				   copy_count))
 			return -EFAULT;
@@ -197,16 +172,18 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_REVISION_ID,
+						sizeof(val8), &copy_offset,
+						&copy_count, &register_offset)) {
 		/* Transional needs to have revision 0 */
 		val8 = 0;
 		if (copy_to_user(buf + copy_offset, &val8, copy_count))
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+						sizeof(val32), &copy_offset,
+						&copy_count, &register_offset)) {
 		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
 		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
 
@@ -215,8 +192,9 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		/*
 		 * Transitional devices use the PCI subsystem device id as
 		 * virtio device id, same as legacy driver always did.
@@ -227,8 +205,9 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
 		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
 				 copy_count))
@@ -270,19 +249,20 @@ static ssize_t virtiovf_pci_write_config(struct vfio_device *core_vdev,
 	loff_t copy_offset;
 	size_t copy_count;
 
-	if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
-				  &copy_offset, &copy_count,
-				  &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
+						sizeof(virtvdev->pci_cmd),
+						&copy_offset, &copy_count,
+						&register_offset)) {
 		if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
 				   buf + copy_offset,
 				   copy_count))
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
-				  sizeof(virtvdev->pci_base_addr_0),
-				  &copy_offset, &copy_count,
-				  &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+						sizeof(virtvdev->pci_base_addr_0),
+						&copy_offset, &copy_count,
+						&register_offset)) {
 		if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
 				   buf + copy_offset,
 				   copy_count))
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index cf9480a31f3e..a2c8b8bba711 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -134,6 +134,11 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
 			       size_t x_end, bool iswrite);
+bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
+					 loff_t reg_start, size_t reg_cnt,
+					 loff_t *buf_offset,
+					 size_t *intersect_count,
+					 size_t *register_offset);
 #define VFIO_IOWRITE_DECLATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io);
-- 
2.34.1


