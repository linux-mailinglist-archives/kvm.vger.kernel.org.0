Return-Path: <kvm+bounces-56908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C9BB461CA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D8A9A65B07
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423D231C578;
	Fri,  5 Sep 2025 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X+dJfcC9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B7B31C57D;
	Fri,  5 Sep 2025 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095610; cv=fail; b=jX0Q+Xa+Y4iyEXSLIKhU7mfhSpOOMs22A5j1Pte1n64AKtrCp9UDwA8t8fG6zVct6k+l3KtYSVNwmTxlKpLXBfXrqHrXFKn1uynM1JF1pIxPQt/HQ6LXij51QXAGjozCJ+YwOHQnG+j88T6mwfuJiErGHeCA3NCqZVDp/HUGHJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095610; c=relaxed/simple;
	bh=B+UHQ5pNNQ8BN4Q7/7nZ1g9slQFXxbuVoitCSDpJorQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uHlt8qXLFj2OuzIpUS+oMkEhU/RjYLINA51E/wvEYou7f0D9HS1iMLHtKRCjTEVK/tgq0U1c2mJGMS0FWIbMdedovYqNfx58Hb7hR+1PPXbo0aBksYk3ejS2Kn1HfyzfAHYJBPKq/GT4BTKQOEBbvz73IFxX5lP0shBYziq13qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X+dJfcC9; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOaTQu3AKX3W1uk40Ior0k1bFt6OwYP+jiotDUkaT+Azsaoj7AjZlaJZVMDwq+oTajhSi0Ji63ZWwqOpWucbeCDoYPtbolyuczROAHMicKu1pERD4vUdzFaVb738xU+sYJzUdRtPefNdQCoYKVtLLeYIvGbaCaW9Y8Xp1p6DOHkgSgTPyzPBlYBR+NfEw4VzmFyei9yalTsMY0Dx8FNbl7oWmV+jKue6Sm/XO54AekpcpMIkq0C/BbHQti1EqgMOjVBg2iqxB875cMwQyhh0KgPahA9AIaMy22ge+bAeXKJN5jQYAwpIYl+98+YqlOS9q89wm3YY9ZJGHhpLcOpl1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6uI+fIZu8P7TOWHi+n9nZ2GeCGN+ohvRRKuJu2HmeI=;
 b=Yk3zEo4mCd+i1MD8DyrO8G7sOVG+iMYxIFZS5hp68BCw9IOx7KI2xRlnfrdfxerTxO8lFklPDP9v0mpsa0RmcseBgtbJ12ZN9+yLvYs/uEwfGmDfdVU0fdnsogI5wH66YsBDBJkwxE2TCj4rzDd5tXoiwzYq1+j3fEkp3TYMwMJXY13HiHBnajeTEzwqhiXojFSWHvw0p6KRh0xUmwGKUk6GPjg+81NVwqioO1wbYauOTXxroOQM9HTShUyMlX8Wm3dsegzM3OgMAiEny/87D7V9j2Gnc2jPZ3wbzOujIGo/PbYN0jDR37k7FvNNDAasgfIHEtSac8jvD3U5GQZBOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6uI+fIZu8P7TOWHi+n9nZ2GeCGN+ohvRRKuJu2HmeI=;
 b=X+dJfcC9C2Mg2COCwYBEfn1uRthjBnvglYk13C0O+LCgCZ/QsENd5q/H5HYMdKNd2a8A0ZS0fxAvUY0U0p+lq7MOO6Ix6pLyLUxVhfqOQ9JVYxpL144yrqMdF2PrMbKpow90AwnA4iJVf3kSyyns/UTYb597h0uWz2NhVFgTb1klNp/hyC814rcDLngJzu+gsGi+Fm+PjjAq8E2AZzreoS3KMWX9XYJbGxfzqZy457fQOzKhQm4l/y+z/Yk97NAK1fOASwez8kHK3lv9W7wyJ66TW0PGuTqwPIA2myS26ZRnmMRDE7WDX6ynG3PPqt/SNO00UptR4YpNiy4L1GHB5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:32 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v3 07/11] iommu: Validate that pci_for_each_dma_alias() matches the groups
Date: Fri,  5 Sep 2025 15:06:22 -0300
Message-ID: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0036.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::27) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: f42471a1-7547-49db-77d7-08ddeca6f0e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IuEron69S8k5Qr8GgGP22+ALut1d1xwgGxAJgKvm9Dg8vdPsVJXOGE+SDRCu?=
 =?us-ascii?Q?G3HCZcKJDfedX30EB5eCjskLcPiXPnsz/7488I9kram4IG9iJqX4ZR/MQd8a?=
 =?us-ascii?Q?SBR7nVQQo485/i4Mtzd0VK2Jwk8bgdRH34MHZ/O94wY/gTNJydPkX7H8ET9f?=
 =?us-ascii?Q?IzEZc7IMAhE2+6vEnEriw9N4faHzTtUlsJ79tBTKcApbjUtFN2eDCMgRdbV4?=
 =?us-ascii?Q?vzpk6oN0oP4/IQkUKa+n0Tm32JoyLAG1sugS5rQ0ga/YtiTD7FtbSzMgHRBr?=
 =?us-ascii?Q?LM02FYqVa93NIJ0N9cSuod19UXT4ZMKYxexUR2HJ+ZtuLEg37YzfmUMlAd+F?=
 =?us-ascii?Q?vXGR6xo2XSnaPc2LPCDviEmxi9QxrfYUT0trEwKQarU9wY2EPcdwTZySfR6f?=
 =?us-ascii?Q?NKUSpqE4Hhc1qqKjp2YlsncX64FnNreeHrDv9iczQxR5+3JmY5XQFuTpwIyt?=
 =?us-ascii?Q?b/REZ9el4kQbCTorr5ABN76rgdDsQ/V+NLfgBighjNb4l5127iCkPwGNEvMH?=
 =?us-ascii?Q?a77+ZhXwxq3aOKakFXUKTqz9Jgouruzou+iVYC5LYP1jIkPlEZBo/IXUXbs9?=
 =?us-ascii?Q?84UWFlVcGyKX+tWgdgncOOsjMIfIOui7dK7zbOT3DeoxwJjqOqK9+Hg3FuXJ?=
 =?us-ascii?Q?+VPUB3iIiHDXxvrwS3rHHaiWcrO09Uy+PNTEw4TLa8i2v6wcrSfUWVUbYRcK?=
 =?us-ascii?Q?JU5dEjmp+H/BMjT0IoDvThgre82AFUsAesn8JOCbU8btTSr99McIijb/+wvm?=
 =?us-ascii?Q?WjKAVRQLjyrI5lQXdR0gyH6C049J3e+pQCZilOViu4E9BZ7VhokUL8xxLbD7?=
 =?us-ascii?Q?7gPP58/16K+QY0KwUmkD3b5o0cCkoIiZ93NsNGryj32k+flNZCyqifLUSeoQ?=
 =?us-ascii?Q?LsA6e7fCiSq2iR6vrojunsEnj6vWTnYATu8h6KW9lySoiPpVFZVEWw3QQlWO?=
 =?us-ascii?Q?Jk7NWSgJKTL2yXSddNWLm8U3wvIgulcMtdIkfw4g0ORZcce5LHZkvV3XoBqe?=
 =?us-ascii?Q?9BXEOdaPnZ6u9yeGzmqJaC+EYXZw8by7oMiCttgGQI2FjSRtttvgJgv2jtxe?=
 =?us-ascii?Q?D+VtpcKU4rrxEwt22aFuwTRzQSfK25KUjhZZ5HfQ3mlon84EIUl/k62CarqZ?=
 =?us-ascii?Q?uwjZ2sakpCZc/V1J1rRwtXqzEs/V8pSSHRdAjUuEwqllMBjjY5+9UkamsqNQ?=
 =?us-ascii?Q?yFcl5rNAtkpd1xT3pT57zk1Fa/abfNhixRNbr2hUd619gCbQFQGKHycZXobV?=
 =?us-ascii?Q?tXm4MWlBtcwc0vbYoOANiiB5J1VCb2ANR8yOqNiEpLeVgok82DdkxFm78q4t?=
 =?us-ascii?Q?SRWY7Uk83NnXWLa8jfACeJ3mFjgLTj7wf4EsayX+dRgKrWLtIKcTQQkWpwLY?=
 =?us-ascii?Q?j5WgIhdQHVtnznb4uh0o28O3tUXGZhV1mVWp9oRyq6VlVhKGiRrXbn2qPdGS?=
 =?us-ascii?Q?krkHh/V6hNU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GErgLlAHVMK5FZ39faXr0Sw8KA1n+MTcCXK1PqCKaLYZDSa9vXKOMnniVjTt?=
 =?us-ascii?Q?94xBPRGiia+JWGk7DkoeFpIaZ5Q4SsdsdNWCNLdFSAVH+JWJBfMgs0h71UQk?=
 =?us-ascii?Q?5Sl/oeoZh6RXTAhjFzhTsEsc/huikJajUXaZVuQUvAo+U5fZLZs8mWMgW3UY?=
 =?us-ascii?Q?qb20cKcr0c2fZ2dNUxnH3fu/Ru9K0ss5IWSdHLvFt7ro13CTdBns1cjQ7q2b?=
 =?us-ascii?Q?IQGHVfGHwk4KvGQu/uxMOdz1ICYe2Ygiur6QpBor3tHrXosBa5Qdji5tInuU?=
 =?us-ascii?Q?92zJAxlahd7hSpQi/QbT6VVIEQ6MPnxzQ+FZuX0EWQ+zdXqmYbqa/vqm4JuM?=
 =?us-ascii?Q?531tkDEnU8qZNcIswCEmP7b56MC//uYPXUM6J+GG5agt5a7XHRE+1AMXV7/+?=
 =?us-ascii?Q?A/NZ/8IgpqSABsNeMBNtrp9PwHRQkdqm4xqp6NDinV5o/+6pdPOBVPsw9cyS?=
 =?us-ascii?Q?IjJ0hQuvXA7fJseLUNJ9acbfarls6GoETa/c7V+PYlutVXQIadDVXc9WMVjJ?=
 =?us-ascii?Q?81RF4e01WCktSrNd+1MMVAVODZifTOhKF0uaJz82kyrG1pvJp4M7C6CwbwPL?=
 =?us-ascii?Q?LmsljmMTUfldeHi+natnZ8Op+JkRlA86Odb43eS7YBe0h9CTRCNo+SNjvMHQ?=
 =?us-ascii?Q?lqegiCw05ZO19U96e8/qwNehq6CESrvj+5AU2ipzwOhdSJkXp65dkpBjb1A3?=
 =?us-ascii?Q?3Vyf8+VWVQrQsoFvaHlu6LYlditq1xOsuMePrq6IKz8huEwyRQPqGAUfWe5c?=
 =?us-ascii?Q?59FfKP1QpeNL18rHHFytf/VOvMcGH5/Wnm0eZvH3g7Ohl0DBw6q6QN1sMl09?=
 =?us-ascii?Q?xQpzahnHv+u0dZxqbNkh37x/PvOnxJiU7+E0spgnJOWmpdwXML0bbvLRd1lv?=
 =?us-ascii?Q?JombK9gVRcFCF+eRNkOBSKYM8PDENPI7kMAmMv+8+ecQPSKes6dNEVp2igp/?=
 =?us-ascii?Q?p81E+gUNWb7ZmfQ7OcTGF0dCyv+1aZMhA0m1TNGZfJdLya8iFKEgFHJmz28I?=
 =?us-ascii?Q?hUuRHvuuLSyMJW3EiZbprAuhbdECiS9uFpET3yREDGROKJiHFGW/49h/j8Ci?=
 =?us-ascii?Q?2AdZJEf7H5H5dDUx6/nibuK3fdcd54FYRobFgIdJjLuBvqkY6w/XjK3tLcOh?=
 =?us-ascii?Q?g/hUcZJmjJp+A8PJ4aBixx2SD1ZbSz0z0lfbVd0AST6lfUEivCCgIp/h/k7z?=
 =?us-ascii?Q?jxuafZLjxKIjyLN56xwvsgmEgBGvfNtEQSubsX8jxThPSOWAL9FvAFdkLAFA?=
 =?us-ascii?Q?+e+1r4eZ5M4brpAsVdULoAzy8V3Rk5NAlxHAwJ8kQcc3m59x/0KTBz5A+OZI?=
 =?us-ascii?Q?qRI/2+4/GUraxT5rstxjw7B5Z8I2H2FtBkOygs00Tgj4nJkBpI4xrVuYfoAA?=
 =?us-ascii?Q?b04/+nMk1a4HwL1a7aUEBKT/wWSRUyN0NmFdWUG1vGqk63hrtP4w/YmqJjSl?=
 =?us-ascii?Q?WUIvw0/vDIP03ClOdXncCLoL71XRCm7cXwUHX0bXC9i1QLT2UBZzK4j6XWrx?=
 =?us-ascii?Q?ZrKJYtjGtsT0unpCI0qN8SyyPhBCz1tSFBBvQxutigLLYBJni7tb89pBo9DL?=
 =?us-ascii?Q?304KdmP9Ni4H58iqc2c=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42471a1-7547-49db-77d7-08ddeca6f0e2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:30.7874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSqeqHIE0EjH9Xhei4tuXjtnN1Ag97GhCu9uhZ7ynB4/qewFjyKBGTG0CEVTYxPS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

Directly check that the devices touched by pci_for_each_dma_alias() match
the groups that were built by pci_device_group(). This helps validate that
pci_for_each_dma_alias() and pci_bus_isolated() are consistent.

This should eventually be hidden behind a debug kconfig, but for now it is
good to get feedback from more diverse systems if there are any problems.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 76 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fc3c71b243a850..2bd43a5a9ad8d8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1627,7 +1627,7 @@ static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
  *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
  *     that bus becomes a single group.
  */
-struct iommu_group *pci_device_group(struct device *dev)
+static struct iommu_group *__pci_device_group(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct iommu_group *group;
@@ -1734,6 +1734,80 @@ struct iommu_group *pci_device_group(struct device *dev)
 	WARN_ON(true);
 	return ERR_PTR(-EINVAL);
 }
+
+struct check_group_aliases_data {
+	struct pci_dev *pdev;
+	struct iommu_group *group;
+};
+
+static void pci_check_group(const struct check_group_aliases_data *data,
+			    u16 alias, struct pci_dev *pdev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get(&pdev->dev);
+	if (!group)
+		return;
+
+	if (group != data->group)
+		dev_err(&data->pdev->dev,
+			"During group construction alias processing needed dev %s alias %x to have the same group but %u != %u\n",
+			pci_name(pdev), alias, data->group->id, group->id);
+	iommu_group_put(group);
+}
+
+static int pci_check_group_aliases(struct pci_dev *pdev, u16 alias,
+				   void *opaque)
+{
+	const struct check_group_aliases_data *data = opaque;
+
+	/*
+	 * Sometimes when a PCIe-PCI bridge is performing transactions on behalf
+	 * of its subordinate bus it uses devfn=0 on the subordinate bus as the
+	 * alias. This means that 0 will alias with all devfns on the
+	 * subordinate bus and so we expect to see those in the same group. pdev
+	 * in this case is the bridge itself and pdev->bus is the primary bus of
+	 * the bridge.
+	 */
+	if (pdev->bus->number != PCI_BUS_NUM(alias)) {
+		struct pci_dev *piter = NULL;
+
+		for_each_pci_dev(piter) {
+			if (pci_domain_nr(pdev->bus) ==
+				    pci_domain_nr(piter->bus) &&
+			    PCI_BUS_NUM(alias) == pdev->bus->number)
+				pci_check_group(data, alias, piter);
+		}
+	} else {
+		pci_check_group(data, alias, pdev);
+	}
+
+	return 0;
+}
+
+struct iommu_group *pci_device_group(struct device *dev)
+{
+	struct check_group_aliases_data data = {
+		.pdev = to_pci_dev(dev),
+	};
+	struct iommu_group *group;
+
+	if (!IS_ENABLED(CONFIG_PCI))
+		return ERR_PTR(-EINVAL);
+
+	group = __pci_device_group(dev);
+	if (IS_ERR(group))
+		return group;
+
+	/*
+	 * The IOMMU driver should use pci_for_each_dma_alias() to figure out
+	 * what RIDs to program and the core requires all the RIDs to fall
+	 * within the same group. Validate that everything worked properly.
+	 */
+	data.group = group;
+	pci_for_each_dma_alias(data.pdev, pci_check_group_aliases, &data);
+	return group;
+}
 EXPORT_SYMBOL_GPL(pci_device_group);
 
 /* Get the IOMMU group for device on fsl-mc bus */
-- 
2.43.0


