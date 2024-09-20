Return-Path: <kvm+bounces-27225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 217FB97DA96
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBE50282959
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074C218C92E;
	Fri, 20 Sep 2024 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OV867Uxy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C57F18DF66;
	Fri, 20 Sep 2024 22:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871719; cv=fail; b=o7tryRIi6HF/j9vylWr2kAkho0f9Jzuya5H2x1uHOK0C8ccUDUU/1Z55wEpeYCq3nBMAbUhp2Pt0Ox5qhjrz8UqfaNkF4n8DLP2MFJrhdHwPzO/BFae/XtcfKyIQXeyBo1wT02vyjDqfN3PgNOklLs0r//ycvV3obY1GopmSjfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871719; c=relaxed/simple;
	bh=3s6iDmvat1DTIh52UuYQFP6Eh5RHgyLznQTbt3wPVfQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TO0uXNrmWGOQbK5kGPadFaT9IY1rtvEOLU7GS5dt+8UUfNYR4FnlYgaoOQuTwUOCS1SjUn1Af0E/gwaPVXbLzZun+HDAE5vVo4AZ6CeM+Nnh2IoXNmzzOQIE5Z/12oCbM5NTYG0Sz39eirs3n+2gaMttbX6wM9j/+iqapeqp+oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OV867Uxy; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j26JsOtsuPtjvQUxs03O9bF/cEFUaCOd8IEFhUXx2AwYwFDlnQqkM8Eb9fR43M46z0mJlvWzSKVzGaAz3n4pCAtE+3w7fFckALS6MdSlwBZMYEkR4v0usG1TqIu1iSb4vkATpRWZU8mgIR3DG5R4M0yjNyESBWVHn6nrtqb2chsD7w+VHurhikCdVhi+5au1ciVCFk/qFeOASpfM0TilMvmVN+lkvW1YMi9kwq6XTdfBqhhhsKVs3gM01T1+ZXXsIJtrHjnNgNCU1fauV7YnKjXs0oGalVZBlb5a/LTSUXx9v616zggR2ApS2f/31tXYjIpYVyV0XTQXJnxWb0vScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JV+Y4GHVgBeatSHjmQi3GCXcGD0XiYZoTobGPWMYW0w=;
 b=F0+/LR2XqoHRzvjh1dZdg0Lh6oSv4ToOc1o/2Lg7f7tIXIkMtf0NIUrWBA+8BEIPXNpwXJs+Mkj+mMjO9+MFk7h3GJ7C6DM65eXw5dsR1oeILc0d0OZRoOiqSUzSO2fJ02QS7KFpFM6lx5z0dZKTmGURvWvqygoM8eDeJ+za5Fhpd2LN1hONhMv+kReRmC8kt3nFB5uuSd807mKJwpWnxBP357Xv7WvXTUrmQDKJM/02V7Tmnjp7gJKEFT1ymeb6xInYy4PfniqXgx/KkDWsSD/XKtPDpx2FRscUrd1d8g6CXPCBhcsN3QtqS2MROKyINsnL5IN+Uw2RiltIAZ97fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JV+Y4GHVgBeatSHjmQi3GCXcGD0XiYZoTobGPWMYW0w=;
 b=OV867UxyjSs0LBKr/or30aqlRXtCGayaoc9si0+buFYA1iKHpjPtguIxuPxGHMCN3aVcRVS/HL0IYB/BQp5os4HLNOywkQOHlqM4A3JjlNXp1gYWkmnIYDff07r0DcgxLxz5Z6oarle/TtJ0Jjt/lfLPxJ9XstgOdTZU6TzMzhiqDJZQUXLAsMZNgTnKoPkMJGw3Hk+6XGmV2GPiERlRCBBw6/xssJ4L8rjKP9rO1BpuyObwDlQYzu+pnbIP2U7kVU4J5wsw8Q3ccw+MVUZGFzc3/2ymESdHm0Y9E9HGKBlROTEDHf9vWkKyZRD9vHJMqNqO8cza4yD/4FDZ8nrlRg==
Received: from MN2PR18CA0019.namprd18.prod.outlook.com (2603:10b6:208:23c::24)
 by DS0PR12MB7654.namprd12.prod.outlook.com (2603:10b6:8:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23; Fri, 20 Sep
 2024 22:35:12 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::6) by MN2PR18CA0019.outlook.office365.com
 (2603:10b6:208:23c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:59 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:58 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:57 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 06/13] vfio/pci: expose vfio_pci_rw()
Date: Fri, 20 Sep 2024 15:34:39 -0700
Message-ID: <20240920223446.1908673-7-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|DS0PR12MB7654:EE_
X-MS-Office365-Filtering-Correlation-Id: de1e1571-85bf-4dd7-a5d9-08dcd9c47d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OkkQAh4gOGSmRqhFTHXY/j/D5eZH8D2X0HKtfRj4LTUqomP7qNbVIl4BMs13?=
 =?us-ascii?Q?pKGhhLfNxMCWpwQVCsa3czf1il5YYJ06ev63fF9/YfumeJJlc/HYYmNNnVFK?=
 =?us-ascii?Q?v7aapT86GgayxqpO0mzjY3yKYFGh89VK+h8Aeb3VD8tfPFrcH+lzj+Y+HKfO?=
 =?us-ascii?Q?BGgM4o9GOJPG1uQVP4hhI5TusATG1BRlKoHs2OC+DymN+7EUHsIKHisUwhb8?=
 =?us-ascii?Q?ynVj/Rnr4uRjuvhrKihc8tE3yHQHrXqvRldqODkc5xIeTXv9FBEaOs0LGQbr?=
 =?us-ascii?Q?2PBd4l7dcv/FdCal8PvReupa3mAjG2DFp7D+k/4jci9+gCz0+kuh4aMcKf3p?=
 =?us-ascii?Q?+ZKiol876A2f0UVnJF+DWTt6k/5MbCE3Sbx9qWBC8v+Ae5b3/gpQ9dv5raME?=
 =?us-ascii?Q?2RrgpgBAGgAS9jk3YeQ2J2VHqJ6GcojQPdv7m7IkEaIfyUIBl5xfLDg5fHqs?=
 =?us-ascii?Q?77KV7WR/gleGzMqCObyTrjpjTuXThLa0P4bl/i3uR5ZjE0ecNrh4/1G7EYyX?=
 =?us-ascii?Q?VOom96q2c7E+AV9kBejkLi8Eokgt3M/BdNKbqikjw5YDZmtS8zEU2qgUgxrO?=
 =?us-ascii?Q?zvlr9aIPZtpcHqyI2/ycZyZoL54s9pfnXw13eW4itYdy/Dbz4DxhK7yA2l+H?=
 =?us-ascii?Q?MKq0gOCAmoUqyBmeUnL/NpRJl+uEfdqL6yGGgO4gyyFBjIEZAmimG2qHAkmX?=
 =?us-ascii?Q?8R+1RYKL8RHu8QNRtSRU5sVlv5zLlTyfehc7ZiaSx8NFQFuQer79UUiL26GR?=
 =?us-ascii?Q?gO/QYrteRUpMGowmeJ/+rAGC8Hu+oVPAWZL8EiykWLWnt/hulstaqcw5BHnn?=
 =?us-ascii?Q?P5na8gOvh9uHwX3oqIymouV6nKxdjUE+YeA/fLGPGPe8ulRsPviDRZRon6DO?=
 =?us-ascii?Q?z1SdgO+qUx3nXSUH3ZXeQcH/IPscmQ7i0ySDuhWD6VcVIlvaH9VFwKQJ4fId?=
 =?us-ascii?Q?SKy6RO669FXiiRtY4T5hY2AEuSuWsAFkPx4wSmjU+vDymYNazWDOSUfZ2eOK?=
 =?us-ascii?Q?AWdRi0FZXUKbJ+nbY4n999c0r+l6C/Y3/OHi1+1zOB+TrHIZ40On8XtTe4UW?=
 =?us-ascii?Q?xipNFqlTGmYd4/EGS2i0NjG3cB760R8znevmvacIYXcMUDqCRXFJ7hLAl/uT?=
 =?us-ascii?Q?wUKXgJavbibtWVxfnFxvl9NLeNDj/b2vVAHbCqg2bSQdzddGzrzurOi7+X+c?=
 =?us-ascii?Q?L7JH5RsK60fmJADaWd6RPKDXnAry+gW0wGLN/OD81b4+ZA0WSZw8Ksg9DFS3?=
 =?us-ascii?Q?W0iBZQXkxMfjces3nVjHwhLXQfXFBty2lF+iXWQHJojmeda5UNb3MNeFCzin?=
 =?us-ascii?Q?I80KASu05MZ0JNKGxEro6XRAx9WbvmVFJfLbbw4VpErPNQq2K5N7hvalV4Wq?=
 =?us-ascii?Q?kcbaKcRqELbUT/9tEClsuQwny1iIeR1pmvVPYVqimnhzvNpyXBHmW2oOQody?=
 =?us-ascii?Q?ePly+N+tYAtBynW2u1OwdHf4QUuM5nq4?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:11.7737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de1e1571-85bf-4dd7-a5d9-08dcd9c47d59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7654

vfio_pci_rw() is the common function for handling PCI device read and
write. A CXL device programming interface is built on top PCI
interfaces.

Expose vfio_pci_rw() for vfio-cxl-core to handle the access not
interesting for it.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 +++--
 include/linux/vfio_pci_core.h    | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ba0ce0075b2f..9373942f1acb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1537,8 +1537,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl_feature);
 
-static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			   size_t count, loff_t *ppos, bool iswrite)
+ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+		    size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	int ret;
@@ -1583,6 +1583,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	pm_runtime_put(&vdev->pdev->dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_rw);
 
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 6523d9d1bffe..62fa0f54a567 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -144,6 +144,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
+ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+		    size_t count, loff_t *ppos, bool iswrite);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
-- 
2.34.1


