Return-Path: <kvm+bounces-28281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E02997178
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA5528653E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8991E25F8;
	Wed,  9 Oct 2024 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h5ht0td6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52011E22FE;
	Wed,  9 Oct 2024 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491016; cv=fail; b=sNzH6Nk1BLNdcmpx8p4vDUt4x/4GhPvHh5KikYhVGw603XChEkMF2L2h9GlTByqFigVsVwUNfLT8D1SNtEa/dJGSd79BCW/nMbWdk6RBQkSCOm76FZWrHM683UDgIiF8Nrilc+THfizItNdMNRZJuYx733N7+RKgIu5JTWvq3B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491016; c=relaxed/simple;
	bh=pdzsj8eeFQ7CCxjSAY5f8fb4UEa+pYHl7dLdVqsi2is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XZfJ/xTRedyELDR8SxQXhWboil9iuSVf/ZK70oFFO3mZki61atey9gf1uFh+qG7A97X5biTHvCPYPGhtoTm2+6VYRe/F1Y9NxjvuleX7EKVDBhx8GIKhXW4Zey36rXWt1kuzjUUEdjRvdOSOpYsIMEYLgQ9/C4Yvvqoka2e8ki0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h5ht0td6; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajSfjQrJV3//r9R9KIDVZHyr/nI7+mEE08lpzg5GXWceSZZNgzgo6ydwkAgDW4o2Sewsy8GDATMIPRg8N82uIdV3cGZ6ejX6tMaWueI/gEj4xQVniHn5N5gewcV3987Nin9I6uNsFoNr2DUbxiROu4B6hFk3swzgyzL+2ZQ9tPyUio2lVvNx4Y4sAzQ8pNDakH6RoXmik3gKnCtVmEnVsDqMTVhUF93YUE0zQ1oYJPmPNO8ORI8zUajRDUnCN6Kg5JegK6ZoqbpUcGCfZ4m6ouYzOfE5JT7dJCMg8nB6CfyKNtEwqqzNc9vpN1UzSN60baYLLlw7t8oafzHlsYjrfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PkoTZUjhuR/nKmtRTOKzRg40EpQKs10xY4n4MrkeFM=;
 b=B2xwBDmPgab8vmGL2upbaC67SHJ8zaSD1u+x6YDaBewnSGuPZYBrydy21QLZZ0CFJlsFow3KwOCDXDfyKs0L32A+7QY348t5UovToQ0TDv3LxnTaCcITGsjGbrKh+yi6xpJcG6SA6h2rUYxb7c7igWIYMyoAEHgN528vlckT6UcHBcqCybz1xWfNMaHYfasfjKlgLrxcRze4koO/V05E4fi63N8plHMDk5wIcs0pY0zDmNUOMYJ2rgyVslv0JeMumIlzIMfY9tUMQJggzQxzALTwX+6GkhsU2kWm8/GkWv0lbxQ95EVFSLK8L/GfIjcLbKXV99tjNXMpsZt0NdjXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PkoTZUjhuR/nKmtRTOKzRg40EpQKs10xY4n4MrkeFM=;
 b=h5ht0td6G/QaJzn6gidg/C5OKT0qB/6qb6SbyoM12mLjCsuYD2r0ow/obZ0Pd4XzQdF/Ta6XSZ20HHU6TZ5B2umpXWWSC/36MGZvh/1cxX9nmZXrqZEFgvBXTo7fq+VmakWLUU4ko33lQQmhxXnwFVyoc1vZoqUtesbVY1RaGZIYW/tQlFKrIUlGrdQLz6KLxIgeeoddmGiAn3NdaPt+C76deR05A16MQVjDB+YklD11eT216Q5p6QW6SFEFMsEY96+QN06Jd8LYH/e1dJxt7ThQFYRiUmP5L41GHS6f0fX0sej2DW1xlegGheQ2+b8Sg7mA7OFwUUg/iGp9/z4l4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
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
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 2/9] ACPICA: IORT: Update for revision E.f
Date: Wed,  9 Oct 2024 13:23:08 -0300
Message-ID: <2-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:256::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: f6b0f993-8715-4676-fa6e-08dce87eaed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9amE+EP+CFP/AU5Vr+Z8VXM2wHgtSaRyNziKs/fulNFITqr4DTuIAHeQ9ng3?=
 =?us-ascii?Q?IsD8oz9SB340R50co5mLEb8KrezhrDrPls5tuEfje+LpB8QzxXevXXst1Ckp?=
 =?us-ascii?Q?GxOfZIhQrWwDkg8OoxJ+HkG8++5WG3O9UPvQWxyyrc/bvIj3zy9ECQyFGu33?=
 =?us-ascii?Q?LUsR7Hyc0uwc8kUyzpvOMOvgFng4CWZgvuiS/wm651b/G1RWinKpIU7l5Vpr?=
 =?us-ascii?Q?LbsIYNIpDylftuAnSfgdwD6e8VIACuhDg5RzwNAHoK+D+esnCIbmX89+02mj?=
 =?us-ascii?Q?Ubk6tQ5Q7wyCtN8JGkKGy89qVTIwayxelMAOZNdssaULfXGDqE4ECRP/HUl/?=
 =?us-ascii?Q?j4RjeRHaq5eTHDPh7Jq+FBkaseAChPRvMZ5+pKwHkMskrLz5bgYat3v/ZMZC?=
 =?us-ascii?Q?rHEC0lK9LhAjgtYfwzLjUFck3epKx53vfmUhmsxk+gPaOtyfAYF7gcQzqFZj?=
 =?us-ascii?Q?BliGnb0wzN9VUi/uHaXbCXPyCOvQKQbjKUn9A8ZIwt/BxjebCYPv3C2r+s7W?=
 =?us-ascii?Q?7nogY3VjoMHOQ2zyzjyiXBDCroJVfGT5WTMIrN2sXWbS0cRQDZx/hwD2WAoP?=
 =?us-ascii?Q?2IM87WkA7l/5zm6756dru/wKxoZ8UaYbQoAxyzkodx7itaYCFAmhsTqbxrk5?=
 =?us-ascii?Q?LN7InBRmYyJ4SeofARvabLYLVjWRfZr9CLW40f4HJGV+gg6ThUlCf9Tdnud2?=
 =?us-ascii?Q?HVEerylJAhiR3C3KBBC5hE3mR4B6N4CJzY0vm3J6Sc/5AY4TGFUcL8x5A6Bh?=
 =?us-ascii?Q?hECdqKbATW8Y8/jH4sW2H5890uY1cNyqjw7MOJ6Hx7YdlSnMVxIcTx9/Bhw7?=
 =?us-ascii?Q?6XA7XlDSA6xkVtLOFE57ijWbq5318qC/jW+o6pLISzx81CdfHQIN1nw7y962?=
 =?us-ascii?Q?Ga59VU8RrOlGkXjgr/odLyBvqt2pKSwbSAPtURmVwzVZst3TrZMZMr6FIx6d?=
 =?us-ascii?Q?NwA+ris0YppKd1+OKnDcFXiyQTVMi2cSC5mAsmTaMEUvhAfDPPepxKcXr7ng?=
 =?us-ascii?Q?hPjISufrroaiMM7vBlGZ9G4rvvcl+WLS73nSyTqgE2Q2TNBZ28l65+fS1stn?=
 =?us-ascii?Q?tJEupD5HkZI3Ftnlq2TFnpGlff/1TvQuHkgndHjAJ/+p23L7w2Xi8ArPqgWc?=
 =?us-ascii?Q?nQwjvSX8cHb+Zk/eKK+PD/mF3lNxln9SMrku4cGbtA4rYWDWKojIBlvErg5r?=
 =?us-ascii?Q?E9ck8mBSOM0HZE3PrV29RDAUxJEWDRW3xgIPG713OnIVZRYO7OjV/SD7gulJ?=
 =?us-ascii?Q?DRcYoKxZIf7w7G0JeJK1C8ZDO8oF6NEY6WiYykT4Q90OtbMcEqePYJrF+J4G?=
 =?us-ascii?Q?rIF3x+QIRTvx/XqEktprQIP+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R2hCg1whHGXEevV8GCpZxsVO5M/MO4cHpp7lLk4/W6HMX6TWp0tw14Rv3ZBU?=
 =?us-ascii?Q?U4vvpIR0SrKAFVkHH/oP30v2ePSyKbxn292xDYdzdhILX9e9Z9VfRByrNgXp?=
 =?us-ascii?Q?J4sNvYo9aRcr1T1HI9AeT/8ofiC0Qm9drTAKsdjGm0DvbzKA26CfO6BQYG1N?=
 =?us-ascii?Q?CuWpQOAQvP2fqX0vtDVcpJg28zudu8TPp0TCJziB2iSfCm+lvs+DePEBB/da?=
 =?us-ascii?Q?hnPAdkmIHOI5WH5bS1NZgwBi6l4Y00vKB/84Sw8sUIvhGx0LUnDmEo1T6FWq?=
 =?us-ascii?Q?fsx2YIra4DvYOVwaxFt8Hjtp5GmVpxwSoB/qo7zXZabxEu8Drutnjb6odRJu?=
 =?us-ascii?Q?vfU1niuHy6QdUWl3E2NGKQjm7o7VvWmY/43ncbURTudO7O2ltl3fMNreFufh?=
 =?us-ascii?Q?aFHuqJ3M9Qr9anaUc+buW6mmv08qSqpRi1jgavA9ZN+otE2hcb2dHE2Y8UI9?=
 =?us-ascii?Q?3cnDhKI65sXCJ78PXlz02aGsvabT3IXlRaVrEPW/pNen6TqNVKlu+iPnHBN3?=
 =?us-ascii?Q?dsTI8zzP4sdR4jtf61sD2AlQj5qfIA7uonU2Xx7k2l5jr1OtKoQsCXa+EXK2?=
 =?us-ascii?Q?5OmC96ZyeEJ17GM+SIvSqIw3joEOSvBwjRs71AgGvS/DHhemvFok54QAMH/L?=
 =?us-ascii?Q?68GdKOf7zh8PWJLbbcmNuE3ixh+/IWxnkggLfFQDsi9UNejy6BylUVZ3wVud?=
 =?us-ascii?Q?CbIwxBoAd+WC6P2BeRT+3ekiuT3cE/cXTgJO6uXy5CDc8puKQRE1XwGlQ9Gz?=
 =?us-ascii?Q?zaKG7PF8tPHd68rJ64DjPqqyYS+LnaYi+yyBkmzl4WHftMIeHcEf+DKUAs7b?=
 =?us-ascii?Q?UYyxbZhK2GMwQJA+bsPjgSqOAxw6cy3L+d133hfS1nLV5Aof+pbIKhfNEnRk?=
 =?us-ascii?Q?UhXeuSV6jODCm1+qu0s6qK5Nw10ZKtgtpqSVeDgPzd5snkCcE63C3YbMWs4L?=
 =?us-ascii?Q?+tglrUe7xmqQP8o57khNWjYtHLJY4vdAs7Ajymz9iYX+3jUxt3VrUHSsCBlw?=
 =?us-ascii?Q?qIGP4pHjPHVYHpSyuDJWyUfUpcaHTjKYh+loaF9omFimUxe/SxnqUl+Th4nd?=
 =?us-ascii?Q?j6oPKr1WzzSJ21v7ohutge/xubnmiISfofJVPbDbgVC/XXWvFUNTYwybB3ec?=
 =?us-ascii?Q?3o88cV1SH6jmKmw1uLnxxOHcT92I8uQOStLla2A2r//06Ep6hB/lqUyM12CH?=
 =?us-ascii?Q?a6KPbZshUwPCmMIfxBPucIeXUyoOwj4oGn2HKdLQD+lXYkc4AnbQvb6bK26I?=
 =?us-ascii?Q?uX8KBUEIC3fSlvHZygqVZnGPJnmBrVAizRMkH2KSWKWdrRa4IWPlGZnZxf6n?=
 =?us-ascii?Q?CQJrIcY4XUj51d62oHWPs1m4VE6pjlIw6zWwXL15newaVMUdvbCnepLFFNem?=
 =?us-ascii?Q?2ld1gHDajej92aN9edZjhkJpTN2l02wSMKl66fXXpRhPxXcLfwnrmoWuvcWM?=
 =?us-ascii?Q?ybQsRi8AMB6YI6ygHTIJ9v1q8c0GpaTteXah+2Ys+QMMB3VmgJuK4XLm2b+2?=
 =?us-ascii?Q?4TGom3TnlgeP5ancCfUY6jkLreqORVYs39mVwCe4k6IHswin6a3dFwb9o730?=
 =?us-ascii?Q?TShUBJFtQEHNnhKyaao=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b0f993-8715-4676-fa6e-08dce87eaed7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:17.8249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBqh1YN4c3T/3DisoVWoGfnMefu7KsrtI4+NpbNZTITf4lWFCCnLVtTqKlJR9Dpq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

From: Nicolin Chen <nicolinc@nvidia.com>

ACPICA commit c4f5c083d24df9ddd71d5782c0988408cf0fc1ab

The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memory
Access Flag field in the Memory Access Properties table, mainly for a PCI
Root Complex.

This CANWBS defines the coherency of memory accesses to be not marked IOWB
cacheable/shareable. Its value further implies the coherency impact from a
pair of mismatched memory attributes (e.g. in a nested translation case):
  0x0: Use of mismatched memory attributes for accesses made by this
       device may lead to a loss of coherency.
  0x1: Coherency of accesses made by this device to locations in
       Conventional memory are ensured as follows, even if the memory
       attributes for the accesses presented by the device or provided by
       the SMMU are different from Inner and Outer Write-back cacheable,
       Shareable.

Link: https://github.com/acpica/acpica/commit/c4f5c083
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/acpi/actbl2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index d3858eebc2553b..2e917a8f8bca82 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -453,7 +453,7 @@ struct acpi_table_ccel {
  * IORT - IO Remapping Table
  *
  * Conforms to "IO Remapping Table System Software on ARM Platforms",
- * Document number: ARM DEN 0049E.e, Sep 2022
+ * Document number: ARM DEN 0049E.f, Apr 2024
  *
  ******************************************************************************/
 
@@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
 
 #define ACPI_IORT_MF_COHERENCY          (1)
 #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
+#define ACPI_IORT_MF_CANWBS             (1<<2)
 
 /*
  * IORT node specific subtables
-- 
2.46.2


