Return-Path: <kvm+bounces-25181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C07961354
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 126F41F23209
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80DA1CDA1B;
	Tue, 27 Aug 2024 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YUkgElfo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665D01CE6F8;
	Tue, 27 Aug 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773918; cv=fail; b=unapzUmQHdsD60dyEdqW1i/HSiIQaNxgmOF6wBq7n4bz+7vsvDwDJa8hckLWYeNKCSwNOxESsfaMMIkii0FHImR6BjwwnDUoQHJdTiMq8kaIbWwJjUfkg0Zc6S84THOYsIqKRGc4XRyD2A4FEPlSZChIK7vaigb+sbinHHs9vpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773918; c=relaxed/simple;
	bh=Dl6N0LsdB9vt5Oot1lD9c+Ms3CszglyIKxnMHpzHVnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SL3hxVcQOoDhdJR6YTHNfwJIfzZ+atfX7ViIDP9CZqJz6kRqHEONkZDwiaJMlNbc0dTtJ9EOdrdQGjVthHdmx2zTYdP7J6ZomhS68SeV0YCxNmpXyKR38bFyAx6BEeEEXR3H7oiJp6nVwC4SutBMvp65SXFf21IlRl2VtBfLOMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YUkgElfo; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugZJnP1eGTC0WmjkeK61v6FPp9tsuXDcVrrjxibc9n4h/OVb2qWftdO3LMFJxjS7xN69ZaSWFN/PsHTALD0nHR1assKP7NAiWHyba8FxtxBJarqyw8t2vtzqFkPeTCmIteoAA4kRaBfUBcLwU8Meu/HOO3JCQKaDz668e1ujf7qnYWmZ6VOqnXXxQLTGQR66AeW6i+2RbjUjluk6ktFyURL65OxTYeimQE3xj7ugk0JE0SDhsl/frMFo39GOiUSCeqs4hU4lIA5XN3NucrVEkM+YKsNtHvBYO2TpeUbzEggbQ4DAREHr3xGAIxb40vt1JuB2koaJMioKP2yI5iUtcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mA/O8BSGCnaIIm0bE6X4wZPUqWemQxMeIBu95O0VoPk=;
 b=izPyuViizdES4d8SNwC81HTWSRgmMVMKJ/P3SONiYz4LfDrgAFbyItWqB9UCNeJIeS7zuANDIkZ4bIpqwAZUDwFEgmVL6p2dbrJvXUIQ+U8kUYn+y7vu7BJm3wU3HSC2nJd9yByi0crtHm0j7OkBrnTDPsW3Zc+Nvp/f5qfWANoOyEf5wz8RovFh+85W1GTQh1Q+VF+nzbMG5R9L718MVuUqtIs1SE31YZUdk2Y4IRJyD9E/38lcwrWilKVk9xSXyRa9kubXLC+IIGHQOFcLojvUSsYcyZXXwE/E7JAM9QpCkF+NA7Ns3YUrDB02CCyaOzlSWF0LM9PRGiGMK+Vtuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA/O8BSGCnaIIm0bE6X4wZPUqWemQxMeIBu95O0VoPk=;
 b=YUkgElfoAfI7FU7c8223Nz1YwiwzlaFGdil4V+X0h99j1Hrjvt/X6Q9HEAP8fT2PvRJ50Zjk3SNiIgSk60M0AcvHpSNjTNGnfyMIbKVuZz9+wbbknU1z0pkXmjS5KZpmlvFExU3IRvUplssTNQi4xfuQRMtbo4DY/lmUw4CyGWBgK1uRxSsmYBvPT1x+vCO/seh2Wp06Yw0kzy/6J+jUdgWf+N8py5pCQ8fPqMthg+iEP9nU4VuEwwpNk8dbot3knbC0Nu3d+oS/N1KuWsVL4IHozcSERR/36YBC4NwBahDhqeCt7mwkcuLZ9LSRKBSox7FQOy5LF51wU5+7CV0/1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:43 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:43 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 3/8] ACPICA: IORT: Update for revision E.f
Date: Tue, 27 Aug 2024 12:51:33 -0300
Message-ID: <3-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::11) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: abe3a666-52c0-4a73-0d41-08dcc6b02420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kxs6L4uYfF5q5dR8z/ilM6KmlyyT2UpN1a+465XPN99b8TeTwg5REdUI5gOk?=
 =?us-ascii?Q?tvWtB6xl2YmvP/EkIUkLc7aWRVMGocOqb2/ziik1rs0YY29nqQCQNaM4f307?=
 =?us-ascii?Q?cwjeaVucpn5WX42jFuDi4yGcKzB1F52Qwex/cp0feuFiHl3KLV7obJ/WkbKl?=
 =?us-ascii?Q?+uHyfBC5lyBH1J+scKLxFJhe2yM5f6dTAGTc5hquzsLLllf0HHq6FvQhtUzO?=
 =?us-ascii?Q?49+s7vP42dlZLFYMJpEyhRY+xOcRoWNOhutwj8zFe2CRtafAUDmgGjmeRKln?=
 =?us-ascii?Q?TWZx2vabXCtd34zuoZZAvcj9QcCvkengb1/2j7ezt0qj0i5F2YWMntqGGjwL?=
 =?us-ascii?Q?6S3YEB9BW50ObIpA7cCgtbUaW/Fu4VSYJJBbaKmdbsKTv/WOGYrzD5dR7uJn?=
 =?us-ascii?Q?2cursgLvYqdUgFujWsEB7lZ+0aVMZIMor1300bABmsvnY2nV9boj19nhZdTD?=
 =?us-ascii?Q?x1/imV3LGRaap/V4ntncT/IysXBUeeYkL1JQadFlKyCL1MyJxcU75iTT63Oz?=
 =?us-ascii?Q?TiZPt8igtvE0BNQc+PRJ89aUIoClXygWxPaSAHcv9wohVgqkS+/cVgHaTJQd?=
 =?us-ascii?Q?YKPnL2B1K7O+OF4Qg14IvFGm1AYXHgGSOJnNjnTx3Uek4snlJtQLn2xXKDf4?=
 =?us-ascii?Q?+wwOCYCQGkvp9O1lZ5xkNvRGVJASMrAjBDfo2I1BYd0JrNZn5RbiYSc5GFrR?=
 =?us-ascii?Q?uQZxbQzEiIpw1Vdlk7HN6l15VOkE3xP659+fDZv1H1kFABa5dY+h3i2My9nU?=
 =?us-ascii?Q?tnt43T6d7FEo6TYp04wImPtIL37qCCCT/FrA/Qi92OpYvFEav10bfH7x10qV?=
 =?us-ascii?Q?rsts54jXZtNIollu+0oLDKdZ2lyNS6n48509f6vXHie6XA8gy8tGeuVMlLlz?=
 =?us-ascii?Q?NtiJ51JQqanP1fYsXUty6hdykKkkrAE7I2TlvuMM2U0X6i0jTXaozZbu3UGs?=
 =?us-ascii?Q?54dDzj/Uu5IzqQJnX7Zwpa8U3k1qw98ShwYyaPAGgUs8J2FDTnlFl0BkTNQp?=
 =?us-ascii?Q?sDZki7sEaFoXlhn1Kig916S65Rm2zAV8KRhDe/Kj6DNxjScf+Bg2sA+qZZMw?=
 =?us-ascii?Q?FbjqFsf/gTO8IkCJ9D7sVFD/hhPJBnihPtCk/XgKqH9OLk/fJxcrHisbq3AR?=
 =?us-ascii?Q?FTgx4U4djb5hGgsVNq2guo3/7qSKsnVebaHR5bsIQ0AxV41O1wxk4kWz+ijM?=
 =?us-ascii?Q?5gtUZXTTr3U/sYgMQ5rbv71jObctYfeL36yVrCokx0zJ2dPHW0JAI9sCes0T?=
 =?us-ascii?Q?vvdvf3V9/WwgviKecWuo0u3/y6FVnSe+iqStBw+tJIrMGK1Px3O8paC1v7at?=
 =?us-ascii?Q?M1kqPtYz1RWEQmqG4c36DBE+Ox5P/v8Ct4zdq8NA7coGb3kzrzP1tbVqwuz1?=
 =?us-ascii?Q?fqHL6XE6hXktuIEHgckK9tIXDzzQ9GhBxzYyZs/FXCaHIY+IMQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PlXVandMAsl4ecgAchIyFkK9ymPdb8Ty+KWhC9xhmtCHEri5dThfs0lmsFxQ?=
 =?us-ascii?Q?qFwPcMyKhuk/Bhv7yj4Nl658YFppCkheLTBqf9p/uuDPq6028MbhtP4yHi8N?=
 =?us-ascii?Q?lvJH5nHKmBForaVGwhZQWADoEOZtFC8MEDCtbQ4IqDm3U6N8RlRE0nrBPnny?=
 =?us-ascii?Q?4SAuVW6Um0StQrOmaHWL07tQcqDzYLzl6SFu0PmEO7xDMJRScq69r3N28fMM?=
 =?us-ascii?Q?uCxXQs74Wrd7TVOCQLF85XTQgmAvTHXmXX5Rape4N0tKfXwIgm5lL1V95aUz?=
 =?us-ascii?Q?23ikXTRP2yWd/5cahs8QlxUJeOtR5OnhDbEUTvkwZTuwCGwDljtqJnJafvnK?=
 =?us-ascii?Q?jHMPNrndVqXP1LNukFQgES37KKYyfmrfGNc1SSmAgUH+qynnjuufbtwAZnj7?=
 =?us-ascii?Q?vY/swojh/eFnPOnf8UIUc0I+yNVqgWiTMq8ATBPzkISiI9nRnEHmnO2e4JqV?=
 =?us-ascii?Q?0wx5XEyvE6lKQriiNUvN/HsL/P2/LfeQNLC6jjkH3kgZ0bMoHHYCuDrFAioR?=
 =?us-ascii?Q?82IrP80zrQ0RhKEQEJuJRCWi6JnbDA9yEPSUpRse267J08wZg2NZQDIQvS9e?=
 =?us-ascii?Q?vCF0mskB4d6jJPpopOr1K6fSKPfYO7CLOPX1tUWADUpSkqVpSYCKMWAERobV?=
 =?us-ascii?Q?qsT9qEAkgoPvoYxQjT9Ar9SxfR0bkykU7x+V0cYFDzwUSoVbWZG3n4pMEjGl?=
 =?us-ascii?Q?fD9F049bpXPhRMp6psG9IfPYDsiR3iBj4dhZmuhKEzXjUjT4YraF5mFTx7NN?=
 =?us-ascii?Q?IvXaohKm1hUdyjl7tSyn+AzDsN9htG9CaijHFOiPS7C0MkyXcLxw3lZC1h4Y?=
 =?us-ascii?Q?GvWX6KnaQ2oQm78FQiUgUqiA6FFCs15D/TGskxp8w5ukFHupRPfgzVmTIh6z?=
 =?us-ascii?Q?ALU2w02cjPglRN71VFE0YmniLKSvVj7BapCcytrqdycdcbkdvPIpqAkQI3PC?=
 =?us-ascii?Q?ZFJtCZOFrJAZJ1lYLgVq/R2yn7sQouRayjP7kNRl7XwRZ5dOJy5Pj1P1uBhc?=
 =?us-ascii?Q?rjeUf/ByFzjbvzK0PkESZPtebOPG255v7n+5s7EMcqRiHWiqx7p719mn3NHP?=
 =?us-ascii?Q?caQ2iGBsCHy0ToSTRkvyuooPZ/x56dRjJbnp10VJxrvCnuiU19iAz0AtP0vT?=
 =?us-ascii?Q?4yTmY0ZXI5cjJ9Ie/GlqoKXWnjSwWI5DggtGfugDNfAlNb+0FuvBOoUPPn8S?=
 =?us-ascii?Q?swj1G/x2bntSRoabOT/YynhfkB8y6wvoFHz9VVnd4Ng8Ib5zzdGUO/OuA4WM?=
 =?us-ascii?Q?gf8bucyr6BQkjqyG6dHpCw4Gvs3q5feNDyInGCpJ1LTTlXAGbo1gbBQJiDya?=
 =?us-ascii?Q?F6fJMMriOZUvQoWGABgGr1KNvLB2HFRPnKHKTq8K5xEVeSRPs9QDeCSbjlfU?=
 =?us-ascii?Q?WTLe/jUsmeHPKKizkE94BMpqawNSKT3zLmS/AHhxWUgr57uHUe6c7K1hPgcD?=
 =?us-ascii?Q?6sy7yk6Ei+b2JuwMREkfTgrgwEvBDfiaXnEPDCZYJFmcECSTQUTPeKFMlqaf?=
 =?us-ascii?Q?zFPQ/OLWwBHC4lk+2dtttkDKttTWLFFQTBcKXklQBAQDVF0uKM9Nr1aZaSxz?=
 =?us-ascii?Q?FTY/cemzBE42oexAuhwIo/EPhTVFPK3i4TGmpqb0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe3a666-52c0-4a73-0d41-08dcc6b02420
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:40.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTA7OrkP0f0XSgBgXNjVmpeQ2pNT410L4SDoXu6AbfPe3x2uEeB/dI1GCrilgbpl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

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
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/acpi/actbl2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index e27958ef82642f..9a7acf403ed3c8 100644
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
2.46.0


