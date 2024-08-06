Return-Path: <kvm+bounces-23455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9219B949C6F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5D231C2163C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D81178390;
	Tue,  6 Aug 2024 23:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XRkCrI2F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993A6178372;
	Tue,  6 Aug 2024 23:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987697; cv=fail; b=Op6hWmel9Ri/vsCEEWJtAppeck7p/Je+C/DUSvInEtQBvBlEVazP3sEnjL+KnO1YGxqVEc30wDFQMYJ4BLgN17WwY60lv6r7RHraiMfdNBwB91BerOVfQnDSF9vrnhSIzoBy52pV8MLqNNT7z/ziTuDMWSY+a5zQ2wfn/A1i3qY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987697; c=relaxed/simple;
	bh=MMDxUiPv+OTLYU+sWl2KxrB2SDpTNN1yVAfLJrKbbkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GDKSdF9rqkPhhXsNMZlSLs0jbxynTSPNR3TAXmAhwYje2bB7mmSo4fySUqdRAFIvMxGf6cTBg782XfLNl1BnaVRVU0ylvM4aXccpwSqY9jAeFPEIheItZfvEVctEg68HRYRWJeLNa+LtNaupu3S2BJkZdGva6+o4eUgcLWLkxFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XRkCrI2F; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lHUtxsW/TuLgHxFb9YnnBnBmxTeUDemNOOirnLBgz4rzv2f4/o74iPcyw5U4bDezE1Kmj5dkLN+9+Dscb+Q+jaaTAc7s6XeFpE7+GQX4H2oY9mwOmpxyPyJ46pc0ZaldKsVl3JM6vqnyK/TmU0SWPu0/wXGAqadqKqSVvV7nyRFvY5SpI/ZvOsSit/tacrKyYsZRFkVdZFw1VzOWZXIBgdFXiZQXObAnjWWnchSbnfCdjo5+y9T2OsKexAT1CDYBbHT+O84mV8ZvulUs7pkQPo/ivy7AlfwyRI2YucM/nk2kkIAVox8DGdfift9sMaE6SqNnexy0biNS2LM87v4Jvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATd2/dJfb5LCjxN+vqopITDXIqcNP6eKdl6pnEmq/zA=;
 b=qi6dLnhkE8WzuwzRkF2R1p/xddshAfK7JUSzuLQouZtL7VzWN8RgOmeLSdjC+XQrJfTcvYApahKlZKhV9BGeCDDtiKDDj0ugaBfb+Gc+AvKUYGguitqZsiLFWOAlJuCNCf45hZVGvjNrrrkTnyfdeQ3C4AXV4CTnLiQCOyjUDYhInRj6xAq+75y9vjqrutNP2BGdwOkFnI28ccJVREg97wMc6pVMI8hSGcU0Pds5TkiiY2Hher3sB+kmy6FYybdyiDKp4uF2Tk3/omPliNuL5VG4K0LuUzYemdOWiVxDyo57ZnpIWWw0+DKhNYUURPHh4xDKEl0t/uN3CwCPNqYBQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATd2/dJfb5LCjxN+vqopITDXIqcNP6eKdl6pnEmq/zA=;
 b=XRkCrI2FLWpIr/v/KiBmm8uUqai9D9kQmJ431Lku4LF0/MPhP7L3Aplvyd3iGBeTc1PwIChNmsyaDrT2nzon4JSIFkoz/U24+zCojYNyf2AZ2TXxlvzxdvFCFRwOfGh2tyXHL4ztq0IXW/98EIzai5UeTmFqqxFLhE0sWu6j93U34aQ/L5f8G17ILYK0HFCk4z99ygqaWJio3orln8AXI1jvuoMQmpZW64LO6p2bNKC6TmFYXA0aUHqBmvfGsSgCEGe8wLe1m4zFgH/TkPx0FQulZy6OqpdztNjEMQ5didaXAgMlrnusmgbvNlA26ToHZIQwPHImOsgih1tAy5qEeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:26 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH 8/8] iommu/arm-smmu-v3: Add arm_smmu_cache_invalidate_user
Date: Tue,  6 Aug 2024 20:41:21 -0300
Message-ID: <8-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN7PR06CA0045.namprd06.prod.outlook.com
 (2603:10b6:408:34::22) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aff12e2-947e-4b08-e972-08dcb671480f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9jKFeSudMMsVXqZk+GBRiIbXyKjZLakjdIaDudSrvx92ynIusOXB24jna+F/?=
 =?us-ascii?Q?cjaOyNXbtk7tHKJQCZ5TXHlG3Eu7MrNT2rTQA8BV77BEfi9cr5fJQ1Dg20XX?=
 =?us-ascii?Q?BwneniR6dt5yhg0mM9S1VDxLyhDWrywTObbTEfZ0QWverVpw/SYieCX9G5Qa?=
 =?us-ascii?Q?6WLEHaroZV9pTHvAPmzNKoYcZYOzdtj0ZEb9c0rutzm92vaG/frZsSApxe89?=
 =?us-ascii?Q?mRN/gN8/l96yAXQ3LOcOOYrn10PGjhUYL/69z9XV7ydrBD70QhS1YIV7LAri?=
 =?us-ascii?Q?rPDt/UrSf4nbE/ORDVfr7Y9KRCgUR+gLCQcfGB7p34CMKNsxmb67b28YVz6m?=
 =?us-ascii?Q?CG9iHhyFGPLB1otSwZj9AOys9BUjhimEaM/9swlB6Sw9TjEeDpPGUxfIE3lg?=
 =?us-ascii?Q?Rlz1woa1elGMKlLZFFm/JLWJeQqlYPVgpEfq+9GFhVlsu27pvmFv4s0wqc3Y?=
 =?us-ascii?Q?Dr4ADf0GgvUvuQAhTIwEff9pwS2fXC6kB0Gk5OQi/ZtH6/gwreeib42Hg6VA?=
 =?us-ascii?Q?ZBtoYwc9hxEbsvu9De3lNe5Tv5oBXJMBfiG85duD40kxsKz2Ryai40LOGJEF?=
 =?us-ascii?Q?UocQr5G9Xgw01EwSOzb+Eg6lRzQkEbLQxk8YHmJxNkEh6ixqcSZ8mXFYgSRk?=
 =?us-ascii?Q?4BOXPOtDCW7dLNB6FTcVwLvshDd1JyCk0gabIuw24WaAN5iqZO7Ez5G0zrcC?=
 =?us-ascii?Q?x/tb2A5LX+AMjXEY4x7zsUGU50kbzI9h7X3edkGicCJNGjCFg4ZB7W+TLZvv?=
 =?us-ascii?Q?+v/nXSqsDnSa4yziuYDm/v+MvxVZCh75y10B9bDbJmaiZ9a1TuGHup3oirXO?=
 =?us-ascii?Q?vBtqF/yo4Rz2diXX6p4/UB5lpqoYsVsLtBmB62OZHCDCEqT0usuknhxjjmjg?=
 =?us-ascii?Q?SJYAhAr30XnPqaGSGxdGsJtUtP0d+0bQudHtSbr76N1sNqwmqFkThTnW3Fpe?=
 =?us-ascii?Q?B8RbMWuUkSeviNt9bxISpTZL+9Ps2PS8Z2jk0e8EO9tvGMB3LA+YzYQFDa5u?=
 =?us-ascii?Q?dOiF+6pz7btZUa+lLD9vF+9woRIE228eZ9q9+rD2zqy38gFMD4Aya+o7Fo/V?=
 =?us-ascii?Q?h0V8U1/tonzrqoncImeU3HvxYUf6fjUYAFETuen6qo38xtnn9gF08NDax8S1?=
 =?us-ascii?Q?DYSWb69Wyx2Pfjnlt6aW4n3cuixmKx50f/b6WTcisHX1KOgQbsif16dNVscb?=
 =?us-ascii?Q?zXcBHzCz/NwWldoQ+/UmB8xqM1ZqL8TR/VJS/xwCCSU9/oNgZ6Jq6S6/Cisx?=
 =?us-ascii?Q?wb0K6q1HYZM3/HOqXc/dVJDIKe6rariOR//fwaGQu+Ls2gO758+P/sVwuksX?=
 =?us-ascii?Q?ox6BMyGNf3s5JlqbI+IHsl8syceRLqkgG0jmjI8ER2HwHUSZi8wcNnBXgf7N?=
 =?us-ascii?Q?kCo6dKqt4bvXhaiFcga6kI6XVdYV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GRzcTFent6MHQlRH6HsiI42j15rKQ251AXJ7PmQhEM1goCZBZZg/5/z/YFm5?=
 =?us-ascii?Q?Vt6XwclfAqXRLrZNxhnveqZCu4ibNYSxLWVNKyXI/pxPrk5w2OeZ6GPYnsfU?=
 =?us-ascii?Q?UxwRRjqPKxyfL7aET1/kW6Lp3hgzH6uGyG4jLUaMzPWw9q8C9ZmZXuumBDNn?=
 =?us-ascii?Q?Ciulf8Sd7xoNQja/zqRJbsX6Q4NsSKGI73gn+NpqO3Pgsoa3PaHjNEkI/cUg?=
 =?us-ascii?Q?ej59mekiCuy/1Mgzdd3xmqIXx+ytn7UXN3mH5upzxMYmC4K+h1H0Ou1Nb3di?=
 =?us-ascii?Q?pPIFn8liDvPkx8qIO24QiSiskSJ6TuEpAwIJcI51wmMHr4WTf6Zy0aMKNPxL?=
 =?us-ascii?Q?+Q5itcIyGIfUzafEG8I3pXCzDzcOGwzq0jNTvLxvWqYnuIZjOsRPblQxUq0r?=
 =?us-ascii?Q?12ya2QVeI5S0xnfr5vhdO8uWZ8tZEpK8UapL5ftXXyeyRg1jMt3r5zLG7J2k?=
 =?us-ascii?Q?cXEtVxo3sg4qrizqZbBgWoSSYVBQI+zXHbP8J93EN01fPd5vWqXammgoE+v0?=
 =?us-ascii?Q?NjFBIDyGylGJyyn65jHYQCM/NTU5X2XQkeXq4z88yCctZWCM41cpnNrlngqu?=
 =?us-ascii?Q?kwM+Z+3VBavJe0SgseHA11W7Ju/xXhhjxMZbMBTtAuzo1PQc5zYRW+pNN+G3?=
 =?us-ascii?Q?4ZAHFjyc3ITIgL0f4Al7mPDa680Za+3mriqeBc/Zt/Cls0FLWOaKVRDYKTGl?=
 =?us-ascii?Q?hHebSsHS8xRVLzTmr0HTSEBzOIRF7Q8u1691k/HQtsuINJ67vsnu+y4SXe0w?=
 =?us-ascii?Q?P6Rwsej1MJNSVDRKsn9lVE0YtkE9vTQgcohVzqGw0+7pP2xgo1SwLovdnPux?=
 =?us-ascii?Q?Y7u7PBywDksLSoDqdiwQ/xMZC0EIEAwkZESNRLFKh6/srmUiIGNbh/oAMHMQ?=
 =?us-ascii?Q?P7crTX0nQ6goAxBj8p6kb8+rIh5hSeFTnn/kZN4klezEBQH95Mh7POgaEMyn?=
 =?us-ascii?Q?qWdoo0LnRBGbJRC1+p0YOzHBTZQFGqPHCbr1sFTO2FoWwGgjvVuozhmKX3YI?=
 =?us-ascii?Q?m+ZLICCpHInldPbxOmhOj4jG1gmndxJqXGhF+MbB2E2F8xXPduQN+Nb9RdAM?=
 =?us-ascii?Q?0Mtaa5BMLPuCgP6+33rb2R859bh8SxLjAC+DQrI8TlkaTQWZ1f2UY9uvxBGs?=
 =?us-ascii?Q?y20tJMqMB151WZFXiyj2JqRS/ezSFJH2ULPMsqDFGAOxpjwiO0pBPssfhhCb?=
 =?us-ascii?Q?E7kX9JznGYcM8nVfUwRd8Gg3hXgRE+wss0GwIHKKlq/U+zAaxha60VsQLI+T?=
 =?us-ascii?Q?sUBvfkTlfjVPq+j9w/mnVFOYyXZtwuw5wp1p1ept8f6vzJ8kp3mBXweGEyB3?=
 =?us-ascii?Q?qzPE7Kg1igAn0hj9rgkS+f9d7E/ZFOjnI8BJO5TaY3X7/KCCNwbqT0h+lv5l?=
 =?us-ascii?Q?3E8hixs/Ns34TB+Ju4+4Fjw4Ztl3VdvskQm+LDQRPWSC+KCOhqptugj92jcJ?=
 =?us-ascii?Q?reuTmFrb39/TiwVTDmfHovzchueCgRyGoPi2U7yOzcAtQbDOnRwVuTKvo7Uf?=
 =?us-ascii?Q?ywjjd1CxLkhpZ/L+M2ySp90/PXJKhxFmwy+D5E7Iyak5HmAOfm7fg6Qvwqti?=
 =?us-ascii?Q?+8KxM2PLQ7jLAXRwJxA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aff12e2-947e-4b08-e972-08dcb671480f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:23.8126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKDVKFCkw4Exm/pIcXxfgDHo5MpnFsc54c0wcVzRsJvzJNtay3mRnPu85Ku1+YLa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

From: Nicolin Chen <nicolinc@nvidia.com>

Add arm_smmu_cache_invalidate_user() function for user space to invalidate
IOTLB entries that are still cached by the hardware.

Add struct iommu_hwpt_arm_smmuv3_invalidate defining an invalidation entry
that is simply the native format of a 128-bit TLBI command. Scan commands
against the permitted command list and fix their VMID fields.

Co-developed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 95 +++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
 include/linux/iommu.h                       | 49 ++++++++++-
 include/uapi/linux/iommufd.h                | 24 ++++++
 4 files changed, 168 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5dbaffd7937747..24836f3269b3f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3219,9 +3219,96 @@ static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
 	kfree(container_of(domain, struct arm_smmu_nested_domain, domain));
 }
 
+/*
+ * Convert, in place, the raw invalidation command into an internal format that
+ * can be passed to arm_smmu_cmdq_issue_cmdlist(). Internally commands are
+ * stored in CPU endian.
+ *
+ * Enforce the VMID on the command.
+ */
+static int
+arm_smmu_convert_user_cmd(struct arm_smmu_nested_domain *nested_domain,
+			  struct iommu_hwpt_arm_smmuv3_invalidate *cmd)
+{
+	u16 vmid = nested_domain->s2_parent->s2_cfg.vmid;
+
+	cmd->cmd[0] = le64_to_cpu(cmd->cmd[0]);
+	cmd->cmd[1] = le64_to_cpu(cmd->cmd[1]);
+
+	switch (cmd->cmd[0] & CMDQ_0_OP) {
+	case CMDQ_OP_TLBI_NSNH_ALL:
+		/* Convert to NH_ALL */
+		cmd->cmd[0] = CMDQ_OP_TLBI_NH_ALL |
+			      FIELD_PREP(CMDQ_TLBI_0_VMID, vmid);
+		cmd->cmd[1] = 0;
+		break;
+	case CMDQ_OP_TLBI_NH_VA:
+	case CMDQ_OP_TLBI_NH_VAA:
+	case CMDQ_OP_TLBI_NH_ALL:
+	case CMDQ_OP_TLBI_NH_ASID:
+		cmd->cmd[0] &= ~CMDQ_TLBI_0_VMID;
+		cmd->cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, vmid);
+		break;
+	default:
+		return -EIO;
+	}
+	return 0;
+}
+
+static int arm_smmu_cache_invalidate_user(struct iommu_domain *domain,
+					  struct iommu_user_data_array *array)
+{
+	struct arm_smmu_nested_domain *nested_domain =
+		container_of(domain, struct arm_smmu_nested_domain, domain);
+	struct arm_smmu_device *smmu = nested_domain->s2_parent->smmu;
+	struct iommu_hwpt_arm_smmuv3_invalidate *last_batch;
+	struct iommu_hwpt_arm_smmuv3_invalidate *cmds;
+	struct iommu_hwpt_arm_smmuv3_invalidate *cur;
+	struct iommu_hwpt_arm_smmuv3_invalidate *end;
+	int ret;
+
+	cmds = kcalloc(array->entry_num, sizeof(*cmds), GFP_KERNEL);
+	if (!cmds)
+		return -ENOMEM;
+	cur = cmds;
+	end = cmds + array->entry_num;
+
+	static_assert(sizeof(*cmds) == 2 * sizeof(u64));
+	ret = iommu_copy_struct_from_full_user_array(
+		cmds, sizeof(*cmds), array,
+		IOMMU_HWPT_INVALIDATE_DATA_ARM_SMMUV3);
+	if (ret)
+		goto out;
+
+	last_batch = cmds;
+	while (cur != end) {
+		ret = arm_smmu_convert_user_cmd(nested_domain, cur);
+		if (ret)
+			goto out;
+
+		/* FIXME work in blocks of CMDQ_BATCH_ENTRIES and copy each block? */
+		cur++;
+		if (cur != end && (cur - last_batch) != CMDQ_BATCH_ENTRIES - 1)
+			continue;
+
+		ret = arm_smmu_cmdq_issue_cmdlist(smmu, last_batch->cmd,
+						  cur - last_batch, true);
+		if (ret) {
+			cur--;
+			goto out;
+		}
+		last_batch = cur;
+	}
+out:
+	array->entry_num = cur - cmds;
+	kfree(cmds);
+	return ret;
+}
+
 static const struct iommu_domain_ops arm_smmu_nested_ops = {
 	.attach_dev = arm_smmu_attach_dev_nested,
 	.free = arm_smmu_domain_nested_free,
+	.cache_invalidate_user	= arm_smmu_cache_invalidate_user,
 };
 
 static struct iommu_domain *
@@ -3249,6 +3336,14 @@ arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
 	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	/*
+	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the exact HW
+	 * defect is needed to determine if arm_smmu_cache_invalidate_user()
+	 * needs any change to remove this.
+	 */
+	if (WARN_ON(master->smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	ret = iommu_copy_struct_from_user(&arg, user_data,
 					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
 	if (ret)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e149eddb568e7e..3f7442f0167efb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -521,6 +521,7 @@ struct arm_smmu_cmdq_ent {
 		#define CMDQ_OP_TLBI_NH_ALL     0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
+		#define CMDQ_OP_TLBI_NH_VAA	0x13
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
 		#define CMDQ_OP_TLBI_EL2_ASID	0x21
 		#define CMDQ_OP_TLBI_EL2_VA	0x22
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d1660ec23f263b..b0323290cb6c72 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -491,7 +491,9 @@ static inline int __iommu_copy_struct_from_user_array(
  * @index: Index to the location in the array to copy user data from
  * @min_last: The last member of the data structure @kdst points in the
  *            initial version.
- * Return 0 for success, otherwise -error.
+ *
+ * Copy a single entry from a user array. Return 0 for success, otherwise
+ * -error.
  */
 #define iommu_copy_struct_from_user_array(kdst, user_array, data_type, index, \
 					  min_last)                           \
@@ -499,6 +501,51 @@ static inline int __iommu_copy_struct_from_user_array(
 		kdst, user_array, data_type, index, sizeof(*(kdst)),          \
 		offsetofend(typeof(*(kdst)), min_last))
 
+
+/**
+ * iommu_copy_struct_from_full_user_array - Copy iommu driver specific user
+ *         space data from an iommu_user_data_array
+ * @kdst: Pointer to an iommu driver specific user data that is defined in
+ *        include/uapi/linux/iommufd.h
+ * @kdst_entry_size: sizeof(*kdst)
+ * @user_array: Pointer to a struct iommu_user_data_array for a user space
+ *              array
+ * @data_type: The data type of the @kdst. Must match with @user_array->type
+ *
+ * Copy the entire user array. kdst must have room for kdst_entry_size *
+ * user_array->entry_num bytes. Return 0 for success, otherwise -error.
+ */
+static inline int
+iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
+				       struct iommu_user_data_array *user_array,
+				       unsigned int data_type)
+{
+	unsigned int i;
+	int ret;
+
+	if (user_array->type != data_type)
+		return -EINVAL;
+	if (!user_array->entry_num)
+		return -EINVAL;
+	if (likely(user_array->entry_len == kdst_entry_size)) {
+		if (copy_from_user(kdst, user_array->uptr,
+				   user_array->entry_num *
+					   user_array->entry_len))
+			return -EFAULT;
+	}
+
+	/* Copy item by item */
+	for (i = 0; i != user_array->entry_num; i++) {
+		ret = copy_struct_from_user(
+			kdst + kdst_entry_size * i, kdst_entry_size,
+			user_array->uptr + user_array->entry_len * i,
+			user_array->entry_len);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /**
  * struct iommu_ops - iommu ops and capabilities
  * @capable: check capability
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 76e9ad6c9403af..f2d1677ddec445 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -682,9 +682,11 @@ struct iommu_hwpt_get_dirty_bitmap {
  * enum iommu_hwpt_invalidate_data_type - IOMMU HWPT Cache Invalidation
  *                                        Data Type
  * @IOMMU_HWPT_INVALIDATE_DATA_VTD_S1: Invalidation data for VTD_S1
+ * @IOMMU_HWPT_INVALIDATE_DATA_ARM_SMMUV3: Invalidation data for ARM SMMUv3
  */
 enum iommu_hwpt_invalidate_data_type {
 	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1 = 0,
+	IOMMU_HWPT_INVALIDATE_DATA_ARM_SMMUV3 = 1,
 };
 
 /**
@@ -723,6 +725,28 @@ struct iommu_hwpt_vtd_s1_invalidate {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_arm_smmuv3_invalidate - ARM SMMUv3 cahce invalidation
+ *         (IOMMU_HWPT_INVALIDATE_DATA_ARM_SMMUV3)
+ * @cmd: 128-bit cache invalidation command that runs in SMMU CMDQ.
+ *       Must be little-endian.
+ *
+ * Supported command list:
+ *     CMDQ_OP_TLBI_NSNH_ALL
+ *     CMDQ_OP_TLBI_NH_VA
+ *     CMDQ_OP_TLBI_NH_VAA
+ *     CMDQ_OP_TLBI_NH_ALL
+ *     CMDQ_OP_TLBI_NH_ASID
+ *
+ * This API does not support ATS invalidation. Userspace must not request EATS,
+ * or enable ATS in the IDR.
+ *
+ * -EIO will be returned if the command is not supported.
+ */
+struct iommu_hwpt_arm_smmuv3_invalidate {
+	__aligned_u64 cmd[2];
+};
+
 /**
  * struct iommu_hwpt_invalidate - ioctl(IOMMU_HWPT_INVALIDATE)
  * @size: sizeof(struct iommu_hwpt_invalidate)
-- 
2.46.0


