Return-Path: <kvm+bounces-71490-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AleBbd4nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71490-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:56:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AF19F1792C7
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 227123014FCA
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97883161A4;
	Mon, 23 Feb 2026 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iRpMEQMT"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011069.outbound.protection.outlook.com [52.101.62.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372FB1A9F8C;
	Mon, 23 Feb 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862151; cv=fail; b=lGPFy+v1cWF/9V8Dn/h231A9VkV/eZx5c8VMS/IjAP0YejGe4giMuXNyfK94u7qaGvwXrpdnhD4nqa2VH4iS1yIUdse0n48PQuhhPk7wsL5a60c9TMtYn7GzVULkAZzcWRE/yc2zTomo+RfbYF+7Ak1ZOlXsz1zyEYK+yceOcbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862151; c=relaxed/simple;
	bh=PCSsEOL2JrZcrfCO86empU2fimhWIY3v6GVVycm2Yac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YfBeHsFoRZj/uiVoojXOAMhId849cluHfhypnYt4d8Eu5Y3qi6z3+gJL/BEJElIW41EV2r5hPSnJmj2DT8x0WDk+nio12vAP3tDSbWzTdEM9KiudEz940+tjTn4pNxxywtDWgZz2Z0deR/sVy3ZrQgJfBrfvi91GciLfalB0TQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iRpMEQMT; arc=fail smtp.client-ip=52.101.62.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rHOQfklqq8WUi5OPFyQrV7HoI4x5yU/i8VMT5prYW0jMrey15hyToKvUattQQhvvVV/XWWrzWl2muoSoPe0WFy+QaBJWZo3q/Mvt0Xb/jNwICO3bCcPz1YIE0fr9QdInUAr27Acog0shzSJOP55L9jgykjhEMOl5mDkEpV1y9foYGwltNIC8zz+goPU0NwA0ZHcuoKaU4liSOC4mPp+NqTmxt+uwWobXHdoX/m8VIxRD/vfmCnAgIN28iErXsedn2QEzrMJXwtSqDBDyZBwrqjclqYzJE9tWtgw9/ZPtQ1R8nAz6kSvyhwTDlvnDo9/4RWPNktX+yJLz+p8/5WFkGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B75mlKomfm/qn+4qf6nwTAKA98LwNab5j81V56MOMdg=;
 b=DK1fhhnUtY7P1IkiWntIeNLa1CKPKB8D889nIQe7KidxMfltz3KzUOgSngjToMxIq1uW8r3G5Dhycq0l4zked38q3LRxr8z1AK6+rr5QRiSJ5Sm5FL08EzLztw28/MN+5rJIEGYtSkeMGMInjeq4GRlAJulWl1WS3hauKAEoKR+hHSTI4YAmpQDHmh+EuSHBWatLoGikAPozRlJRmNGX/Kdk6Q10S3yRZUat9MDlxOeDmfdY0jamho2eoJ4DDz06Df3ITyDdul7xYYJuxTqMCSwJKAlOP6yBSZ4W8d7+HVq6XVaouS9R+HNDbgN1hDjdmM+8cX87UVugKZMPT6jFFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B75mlKomfm/qn+4qf6nwTAKA98LwNab5j81V56MOMdg=;
 b=iRpMEQMTP/5yAe6OqvvhZQ3bA89RRxim7hDHbPM5FX894FYhawcAidAQohPSV3RpDFflBMDY/qwnd79oru6lkXtgVbhvKyJCi8HG3Me+Nn1NHtVg7NcDPRwCIRmZ+ji6VaSznzzTVtiOR87erlP7eV0+Y7rD1O3fKWso7JgsLs5N68vUAufo6swpXDfcnC/jbtgcFurDEgnAfa4SMZMrBoxV1mVZ+8x5+30akGQocq3uD/vZEeiTWLzxavEFIcNefpJl37fPk7PFwHI8z5DlXjppqUrIJPxRAect4/nkC41n7w+csImm5NG7+77rz32/qbQnaDo+0G4Zf2pTOvMw+A==
Received: from CH0PR04CA0048.namprd04.prod.outlook.com (2603:10b6:610:77::23)
 by CYYPR12MB8924.namprd12.prod.outlook.com (2603:10b6:930:bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:39 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:77:cafe::21) by CH0PR04CA0048.outlook.office365.com
 (2603:10b6:610:77::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:20 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:20 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:20 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 13/15] vfio/nvgrace-egm: expose the egm size through sysfs
Date: Mon, 23 Feb 2026 15:55:12 +0000
Message-ID: <20260223155514.152435-14-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|CYYPR12MB8924:EE_
X-MS-Office365-Filtering-Correlation-Id: 41bfb6be-0c08-4721-3b33-08de72f3fda7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?it/xNP0+P6wnL08Ha/FigY/FQVuinfgL3JjRddXpXfL5hlJv/4j1StYO5Qs5?=
 =?us-ascii?Q?SI4XFO5CzZoJQ71fnK9beERH5v9HbyzcVjHe9J3fwwDAvrCeZ7t4L9Y2zm1+?=
 =?us-ascii?Q?dRniTtvlObUT24y3HsiBBYgkTgtQ6fRTYjdGjHxx6E2Z0MX7UiaMOEPLQ2aX?=
 =?us-ascii?Q?mIWhcnhwGqsRGBDvFOHcX3zKqitE6Tqa41Ud2t5rkaCmUQNZdGTNAwkxocvy?=
 =?us-ascii?Q?hr+xVFAYHY4XROUKzHcPyt54wASS/eeyjYFsYvwzctDfjXqZiwhcbRdYoPHM?=
 =?us-ascii?Q?6i5c2GA9JUlWXRlAzQs7nPS+6A/h/lvRFRMjqV5LBUqJ0lBw6fQ6IthZx679?=
 =?us-ascii?Q?wvJC/3tTpAfB4l0YgkFKUFiIJxvVa0vC6UzdqWd7UF8S2qsQKjcgb+btqqRY?=
 =?us-ascii?Q?btlqIpjVKNZc6Cq20nbWDGAELqlsvkxxgxiV48ZU4p9LWsBJVyvOkaPTHJnb?=
 =?us-ascii?Q?mVgVzEL4XKusKpU5DCWZNXneIKjLUS/Dl4T8d4f5r3Tari5IbJd7mc76hwpb?=
 =?us-ascii?Q?okL77eaLjdVHZ3Vt5w4t7pR4ZoCNsLld2WDQC3dm24Lr/1d8Z9Yk6t9fjmXA?=
 =?us-ascii?Q?wcuIQZpV1yHOkND1+1LoxmIS1Qk91SODMfJ2tNc/hEXs9LwlSxIg/zKqDthj?=
 =?us-ascii?Q?Zq7KCwn+9R2BmJJvatp8nx5iHp9Aumla05P9rTD4RyZkHJ8G/5c02sYvJ/7K?=
 =?us-ascii?Q?kflX6MXBPyw6dl0AYeddd1jvU+CRH0uf5YmH9Lbq9yZmnOdDuZEdxnkygAT0?=
 =?us-ascii?Q?+DXUA+J8X5SY/z+UezFr04aXuTkru+e4teB9D0Dy3OdYM6wbJthHYd9cRQ+n?=
 =?us-ascii?Q?LvyaRkrXLqrJxNQVec0HaRs68c7N7Fo3nvuzkYo9fpKtZ4uNqZwsJW4SuDLX?=
 =?us-ascii?Q?OIvVzS24XAnN9MQiuI1uJib4OVl9vWKAXcUE7nZzffMEIeKWP5D+p9qwRJck?=
 =?us-ascii?Q?cj9R/UVccbQt3tR1M2etFhpdA3BOlql1cYOMjeUq2N7C1AlUVJvWbc0rTiyx?=
 =?us-ascii?Q?hSv5swF71KSBIYcY2xRrd7w7P6ei9Jff9h5faQFTBBqgYr0r0tqAqPoHLNSZ?=
 =?us-ascii?Q?XJcH/5BntytDBvsoW1kO1ny7dDvvnm8l+JilRW+hY5Zto/Co12mUZptXD8OT?=
 =?us-ascii?Q?1hnmo1UInU7wIquqFM3lmWCEAouNw548VWPID2Gae+qoyjL59o4NLxubNvWS?=
 =?us-ascii?Q?tCP4uh0iFaF90xKehx4ai1yaIS9mC7Sat/oPhK+dS83Iry+0hEtD5TxBu9lM?=
 =?us-ascii?Q?f69vKFjWqFuVaLsh+AT6M7AjsNH1A3KCvc3WvrpBmGw8cd5ytwGthtwO1Alf?=
 =?us-ascii?Q?md7XsZlumUgxUALMfWsX6dfV1Tf9vj7YAkewoAY3HrAYTOx7V5YWYef9n9v2?=
 =?us-ascii?Q?sfmeYPccrIUBiFhAnVuEAm26y1RyBWyllIhsCNq8H5puG/wEmYhV7ItZwV/t?=
 =?us-ascii?Q?YTZQ2kHk51Mjkxk5pXSxhROPcXVCIq4/2/vjjWTn6WdyQ5Bc5rYLpRIaK1RM?=
 =?us-ascii?Q?CK57r18OEJnyr2iAU4uM3uUUoj+vQsnkRRr5mwtgaYQ3UCH0H5yMztO6dkC1?=
 =?us-ascii?Q?1+34Kyq5d8yPjeNOmycNkmi1DmP6z0hEvWmsjvPTlSouptCBjU2iEkucCDjU?=
 =?us-ascii?Q?1F4STAykii8EQVOF+YYTuqKvy8e0WvK/y5YX3IADrc5bs0hCAVCSutzL+TrX?=
 =?us-ascii?Q?dA2OAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Pg4xyuWuY0Q86lYkxSvRhCtyPEuN5OSAyHreTRG9oSIhIPE18gLUPDB3ngDYAoymvHQVqtX/1L3NXVDUvHbx/ZH6y5NUhg6vAm0k6HuLR52UjBTMhIKfDybBV/5b2878RUiHBwjyaSUQ/6R3aYGUDTHZLDHSQyOE+UCwABCC196p3dLW8nuSxPW7vZmGRIXE0HpTDgMf0PNa7EPIrd6QJ8+HUgjvyHmi2zI7Q+lNeno32Ob7GfTwXQtZeXnD2GmBIyUZJgQQ3+aLTjQme4TGYfz4dW51EUlS9ntjLBmitkVO5u65QYsWnZpPO5RbBPB5VICPHeSU5SLEkyF9G7+OfgoWujimLe4yBoksUVKqrMBrbobN7jcFEg9OJBbAZLzoal3EXb+sxNOup6BNC/7sHEYp4m0v7/Wvrw7IQ3SbTqYERZMk6SBp5bWZSOQRwOCB
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:38.9958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bfb6be-0c08-4721-3b33-08de72f3fda7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8924
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71490-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: AF19F1792C7
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

To allocate the EGM, the userspace need to know its size. Currently,
there is no easy way for the userspace to determine that.

Make nvgrace-egm expose the size through sysfs that can be queried
by the userspace from <char_dev_path>/egm_size.
E.g. on a 2-socket system, it is present at
/sys/class/egm/egm4
/sys/class/egm/egm5

It also shows up at <aux_device path>/egm_size.
/sys/devices/pci0008:00/0008:00:00.0/0008:01:00.0/nvgrace_gpu_vfio_pci.egm.4/egm/egm4/egm_size
/sys/devices/pci0018:00/0018:00:00.0/0018:01:00.0/nvgrace_gpu_vfio_pci.egm.5/egm/egm5/egm_size

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 918979d8fcd4..2e4024c25e8a 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -365,6 +365,32 @@ static char *egm_devnode(const struct device *device, umode_t *mode)
 	return NULL;
 }
 
+static ssize_t egm_size_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct chardev *egm_chardev = container_of(dev, struct chardev, device);
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+
+	return sysfs_emit(buf, "0x%lx\n", egm_dev->egmlength);
+}
+
+static DEVICE_ATTR_RO(egm_size);
+
+static struct attribute *attrs[] = {
+	&dev_attr_egm_size.attr,
+	NULL,
+};
+
+static struct attribute_group attr_group = {
+	.attrs = attrs,
+};
+
+static const struct attribute_group *attr_groups[2] = {
+	&attr_group,
+	NULL
+};
+
 static int __init nvgrace_egm_init(void)
 {
 	int ret;
@@ -386,6 +412,7 @@ static int __init nvgrace_egm_init(void)
 	}
 
 	class->devnode = egm_devnode;
+	class->dev_groups = attr_groups;
 
 	ret = auxiliary_driver_register(&egm_driver);
 	if (!ret)
-- 
2.34.1


