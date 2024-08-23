Return-Path: <kvm+bounces-24908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA38095CDDC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 681F92878CE
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90A5188010;
	Fri, 23 Aug 2024 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5fstYTf2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9B318661A;
	Fri, 23 Aug 2024 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419824; cv=fail; b=ZxegYBC5POpx40WB8io/BxYnCojQCIIuvWu7SjXWxNHKS1KJo4EwIexiL7G2UXNgkwrpxlRxpMo3FhC++GBoeUOC/8N7yUAFBxbYkCklM6hwvw40F2J2nmZCVeBEFIUGQa4nVYpQ4vJkjWHtqRLUgjyEtwl1Vbm+5e6t1/4gM+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419824; c=relaxed/simple;
	bh=GLa4TFQSHAD0dZCNVkZl8XmNtgtkwsISfeth/JQ6hF4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FW5M1CwyXf7hWkT1dgDEeM7GmJkF+311ud86HHx+YLkVZRwfdTjc9pJT3Qr/UtivzRujjZmTH/bDTu56WI+cRPZMcA1Ra2BEr0jYvKqpIqi3X/4g9EYvz9SNFvHKax3/F3aLNxWPHaIlrIy+g1c3PW1fgSOPNTujbzAbgluv7qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5fstYTf2; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAwsB8eAqHvoY6vVU6NuBroVmrivmT+jElc8mmAOa8cggTf8UjOxf4K2lQe+WrXNeFPeTfMZZwDwYjikJTyxkNahZtbSd35LNYaMglLKVJLFb5DlDIf+h3XiOFe/8xwnDuzJiJG4LJvjpSyiiNttbow/h3813kFB4EMptNW41y4TE/y/ykKpBZXr4y/y8sTwsdUi8pHkM43Qa1ymbuy2c+kbjtX9s8UfEc6n2Ke9A0IuoOMYuUvgZlpYEpEMLRqu12aKpqzKpvseWUxgYXThCw0jhYvjLQepov7KfAbyyI3Cc+a7D741fHx86QHpzLCxTG9agV+yTcC8qE7/2wcavw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFJA1027OWp/wJaSI238LSJRcJGP/frH5jlMKXz/P9k=;
 b=QoZXX2pvKPuEPK4ZSrT2W5ko1+NeBfpwAnHMONjxnAfKnjl8kgy/awDvTckG+ov0Ey5+YWtTqqlLmRfEQsLcPpkt08zLKGx3ZY3iANJtEOrxhjPRNJL3Y4IJ/WQxpxWj+Z10RD4EbWywLG9DMyB1V417Atwft4SRMWGbVCuJQdEcZ/8mJ/n6jOY7MFd+KL5v3ps8hO5O9Ci7qVx0YZd2GKKIr04lQDzBcya6UXtOx0hhCtn+AwvnaH8UuTT0N+bPpl8u7++CYLrQcy16Lu3n5fYbsdDdoIrb9vIpqXkWqICjaX77rR4dztgFgv4w5G7M+ftubcHf4DRSze0Je5QzCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFJA1027OWp/wJaSI238LSJRcJGP/frH5jlMKXz/P9k=;
 b=5fstYTf2H/uNfy85LFSO/pBcWZNIPmOOugflRJPL53uN8gvntoKYRoTlktKMFZYHSa/wFskECa9DVO7nuRVvFuzEAMidPc0sYX1OHxWGsGIrqt4biWe/Ol/puZhIxm9HZBPn69Nl06+Al7lgXUeGM+ca/ZMStH8iS2RMp2t9d/0=
Received: from DM6PR13CA0009.namprd13.prod.outlook.com (2603:10b6:5:bc::22) by
 IA0PR12MB7530.namprd12.prod.outlook.com (2603:10b6:208:440::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.19; Fri, 23 Aug 2024 13:30:16 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::98) by DM6PR13CA0009.outlook.office365.com
 (2603:10b6:5:bc::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Fri, 23 Aug 2024 13:30:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:30:16 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:30:11 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 10/21] vfio: Export helper to get vfio_device from fd
Date: Fri, 23 Aug 2024 23:21:24 +1000
Message-ID: <20240823132137.336874-11-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|IA0PR12MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 513908b2-9096-4a94-1c59-08dcc377b9e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y2piiAtQOTrAvIZ1KWznvvMo3EOAuqfZKTmX68gH3872HJUXYwb/4FpeeyWP?=
 =?us-ascii?Q?pAvYBVEO+8tdNmpqUYADPeAmfIKD1IfUAmCV79lDtjnrrtQUBohggtdZ+y9S?=
 =?us-ascii?Q?m/8IJTEoo2u7Sy1VeFbkkGGki/DQHZQbFhpw6kwCrzCVtvE5wXekH2Wz4flU?=
 =?us-ascii?Q?bgvHWLpLa8jhYi+sDPerq72H45hjgu50KPPpRsnH5usHQVmTnB+ii70YxlTn?=
 =?us-ascii?Q?yySr3NKeorfKG3Y0sXPqUcn10nk45EaphxSfCpVFVSESa71cjDVEqe4eWDay?=
 =?us-ascii?Q?gXPmghYldv5lROZaDK05LebQFrNf4NY9AKBI3XK8PLKYoCGO30MdhV/Vvr5/?=
 =?us-ascii?Q?YkKVRfhxDehwGSPvNmM/tC1Xa/3QSzfOaJfbgFVs4r8PYSo6oUtv/z75vJsF?=
 =?us-ascii?Q?NZIAopKcIPo3tKdEQZrRl7sqW82odepLQ3nEgB5ACh7AVRD/239mR5yTWz3o?=
 =?us-ascii?Q?mTTrLi8eZF+sJUKaMBZBHwngtdYgw1dOs6Bc1hOMs8YXfrdCClp7AzIs/ZC7?=
 =?us-ascii?Q?nUtpU+0bTF6qpZkKLTaX8ta4p/qW8wUX3403Lg8yMSI/4cuTw2QvPMW/EQPG?=
 =?us-ascii?Q?NSj/CXh87YfbBbqEDJSG8eWadByj4v/DU1JemxMdxIYBSl2G6M3AmmGUpnYf?=
 =?us-ascii?Q?QMCPraJZNEMqbK5w4zePZBEsCEigRoZ+Cm+jium0IN38dbzQvxasGGBLius5?=
 =?us-ascii?Q?I5bumDwilnmElps+1NDud+Eubx82iFuRGI71fSP3w2YLn33p49pymd9f2yfx?=
 =?us-ascii?Q?jdS0N20JHLPO7+8cvFvN4Y4XC21KoRXfJlKYPzAk1L3Gaz4l0cdmoiIyXemR?=
 =?us-ascii?Q?Uks2Hs1drfBLUND+K24HX7pruqgecjyfiRxdfKc93y1f/TtomUixCqkW9u1Q?=
 =?us-ascii?Q?VfOnH1qe6WjCyVULBlkMAW/uwxs5sDanjFofgBo6qgG8LdF5ESb2jrx8XFDb?=
 =?us-ascii?Q?cZYbYlgyEGsQg5aVyqcnhOj+HN9JAHpocuK+pdXK2k/10zmHHcRiDQzZKc92?=
 =?us-ascii?Q?YsssH5nWg8O0WIW24fiHRQe3uGuz8cI+L+c4lWDjqUtyrHzpQ6ay5wYVkZT+?=
 =?us-ascii?Q?8I7ZWjCLmzom8sMItp2pKc+eoqE6ReS4C5wyOZeh9hLbhicvyh+FP22NJQBn?=
 =?us-ascii?Q?inftBbIKYuHS1uZvQO/gf37VZ54H4e/+F3RdgNuLFdfFV+ub/iFxA9nPX9aG?=
 =?us-ascii?Q?bAZ791tn5Ntm7XTlKwIw2wQwrcI5VYm7y69Hx7Dvbq53ae0013dG8i4m2ftq?=
 =?us-ascii?Q?lMIJNjfz71W5jchWG0R3AfxvThaicRnNfGhMk457pDHORbB9ccl3tOXgErgL?=
 =?us-ascii?Q?uFzc3CPb9l9DOeNNgIwAvWc6II2Sw7LuQupxSlWrQsUb5oGi411c+qAJpeGD?=
 =?us-ascii?Q?6WowWFbpdU9ZdBxx447KsvviujfuKYPDMLW0N39TqaXbsXODODbKiX6dGeBw?=
 =?us-ascii?Q?ymYF1cIGCxHVE0vk8De8XZGLxYgzEUDv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:30:16.6089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 513908b2-9096-4a94-1c59-08dcc377b9e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7530

The SEV TIO Bind operation is going to be handled in the KVM
and requires the BDFn of the device being bound, and the only
supplied information is VFIO device fd.

Add helper to convert vfio devfd to a device.

Note that vfio_put_device() is already public (it is "static
inline" wrapper for put_device()).

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/vfio.h     |  1 +
 drivers/vfio/vfio_main.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 000a6cab2d31..91fd376ad13e 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -293,6 +293,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 
 void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 			      u32 req_nodes);
+struct vfio_device *vfio_file_device(struct file *file);
 
 /*
  * External user API
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a5a62d9d963f..5aa804ff918b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1447,6 +1447,19 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
+struct vfio_device *vfio_file_device(struct file *filep)
+{
+	struct vfio_device_file *df = filep->private_data;
+
+	if (filep->f_op != &vfio_device_fops)
+		return NULL;
+
+	get_device(&df->device->device);
+
+	return df->device;
+}
+EXPORT_SYMBOL_GPL(vfio_file_device);
+
 /*
  * Sub-module support
  */
-- 
2.45.2


