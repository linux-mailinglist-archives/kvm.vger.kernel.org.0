Return-Path: <kvm+bounces-23454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 024D1949C6D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53FB1B22FC5
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB9F178CCD;
	Tue,  6 Aug 2024 23:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t+Q9VHe1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A79B176FDB;
	Tue,  6 Aug 2024 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987695; cv=fail; b=EVW/YthW5+40EGgsWW4oSOYOfU7vGJGHVHj5ykF9xSRoFtnGS8m7uwu07ekLL+/lJzIpSH4wU5gyAMrDTk4kBfT362aVuVYfy0la24YicGWUzc4rdZs3e4mnltLd2YqxMIJkk3Zh/UwGrK9+xAxMhpp+j5pQ53QbrTfm4cJw2M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987695; c=relaxed/simple;
	bh=26qwsxWB5OYlNcsTkvyqGvjljo0iWzq01q1LuhIsZ9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BdYdG4mmcYHCs7XWQjYyznc50LdyUyibNthV3+PLa3gBnQq5Y3aUcWI1jKeQaJq6iASrAL85Teu6U/A5CbLjNtBJ3+KeAuUbRB/JwCncRLE0xhZqc2F5zIv4f4wV/JvgU1Ygp3sYsD7H2eQlvXX2ObIn2K1Ag5uM03T2rA6M1ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t+Q9VHe1; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZIXMJneVbg038vmtatxcM+jcrJEsG9TH64UBS2IcEGAlgE+Zr+cyszYw87fN9d69rUtlCJ5mzK8hv+8yYjuE3LkP65dx35FIYKFsZCNfgMv3c4qqvWwUJjK7SOzzBhCs+zj3NhtjetTsSng3h09H/lp1vCIdzGCdHPryVISwAYSaWjyMcXI3KkwverObBdlvBvaApksBRfBHx9JyN1YHFq0LVd/eTezr7itHlltCbvEqCKId3Yr8mOqWjHSwFhcLE4yb4ORiyMRQNHMza2gLtA8gQejBRNZe7DCQwSZN1X0SG3XqxCsUjCA4tpQzYsM2xgRowjl+sHf4YkLV0gPGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8uELISHKDo8aopEsoXqsfcXZwuzDOSWDjKX+9+WdCY=;
 b=U3kTjate4F+8piwD7U3XA9H8jYZO/VuFNkeS+cBKVoOvJq6XH3IHf8j9HLpQECAzbQbYqrN4l2TgC/2k5VGPUYua2fZNMogarPqKMHifIe5lhSYrsYBBZT06geGkOYsS3U4zIqCehj7tWmaYEtW81mu/RzyDRr9naC8cWTfW1jsSQmfqrDCDHUGGm751ACTp8uGfg+TSGU/9ktBo+Ch9X89wsGmH14Ps9vYSNkUaPLIC4uPWsA0LonsBj1Au+ADp1F8dKkJUVlkTkQmw1YkHcoBdfPDq+7WqhMKDAD6WEJH+deo9k1HLj8s+plWRjeSVXkYuaSdqALxEz+l1YV6HFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8uELISHKDo8aopEsoXqsfcXZwuzDOSWDjKX+9+WdCY=;
 b=t+Q9VHe1t5/ujrs0gEsOC0VovOk9ThfFuyCJgslmY/+P7jcPebvdHAicOFgw1FeJV3MByv8bZilDAqc1I/wej168W4SD/UDDLMLtCRXEGeFT0Q73UWjhsJzXHEplQXS2JtPumz8q7hZEP06P+rM8UGM2NRLzlEI7fvm3L1B7437xABmAqcdek3yZaVfqU6O4R+BlRsuvqmEnVoUIp+nK2/qGqBbSxi2WE3IUXedExDV/Sslqr+PmBSCpYv0sgDHG6CbhR8iwhhO0i22jCxo/mIiowMRZFYmFT1NwAzvHTjLPBvKG5303c1wSDyrYppUzIZVIdou+oo1T4CO/famSlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:24 +0000
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
Subject: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Date: Tue,  6 Aug 2024 20:41:16 -0300
Message-ID: <3-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0362.namprd03.prod.outlook.com
 (2603:10b6:408:f7::7) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 598044bf-73f0-428f-adf3-08dcb6714809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6TTGCOTZKdwheB17rSPAtTHQapfdDbHh4PBINzchFkEGhv0RtteDzS8TjAzz?=
 =?us-ascii?Q?HqolwqJf7lON+N0ZZaZM0yLA2tdNv9GiLqucSzxb+pUYOkoIY1chlXssDgLc?=
 =?us-ascii?Q?iT1akPh7aMb5vlBy/uwiZ0ooUWtWkoNEcgtqkZgzBy9oIHD4RmO3JOBVd7DH?=
 =?us-ascii?Q?sJJ5rY+ct/nQx/XPJJrNlPUoy7eMYlOud0zCWJCQi+YTG4jpNVRo/UKXZZwk?=
 =?us-ascii?Q?Dy4OMBN8eA0Yc58ua5A7MgcPJX4ddCtdrzMVKeqlxld0zWX1zS+4/zyuyEl8?=
 =?us-ascii?Q?MkOLcCKibKk0aXPRAwvFUrl13uw9xv/BhwQcF0gCf9zCBZ9gc9Jggt1NjUA4?=
 =?us-ascii?Q?SvxW7Ld6xDmoSiQVWVXeeadxXrRWJDi7/X0Q1c88X9GLOCEcN/HTbUhqhAXe?=
 =?us-ascii?Q?ozoiT2eugn+dcnRLWy+USWT8lWUUJZWAzEX2nF5ji+LFGKmGL/0nUI6GhSle?=
 =?us-ascii?Q?ccfSq9rZ4ru45aDPBsFZtwxwxA4pFTskJiZoAT3HytWxg7R9fbJApsNejeN4?=
 =?us-ascii?Q?61DF/UwejzSbAD9YHZlbmlwl5hC1Dgbr6j/ZfQakvPuR+t/A/KD04t6hULsC?=
 =?us-ascii?Q?goHgUIzIrLTMmxuaq3oxMVVfsTgz5/QJXsh/zryjTN23T4o6T9vk/+/VhUKi?=
 =?us-ascii?Q?GIljM9ElkpNHJbQb75ObMnn9q/fEe7i4Ewi1DQIsWXucLViYV5c5qI8Xv9mt?=
 =?us-ascii?Q?icgCjWYqvBgvfRIoB1jEfijOgkqU7g5P86cwsX9s7NbURW9MAfHaZjBmawVO?=
 =?us-ascii?Q?4ujiUiH5/wDzggO/oiuoURSd7eca5Xf21FSEi5BtU8lxiC1hnCBz+FYQKijT?=
 =?us-ascii?Q?sQOAbpT5I/qJ58O5KCXbgYjjhs8MTbm1nlSAn19qmkkMUuzO49KXmvkW1OZc?=
 =?us-ascii?Q?1ZDmC8GD+/F51wVxbAkx3cV2oTqzGyDJ6l1CUkUW59SmDPvMtr0kKmDAkVRI?=
 =?us-ascii?Q?QJH0uVEw2iB/K0P5ZNtzs3jqco88iT1kdmScCUI0gUdBv3Zf6JWOHbcsEwJv?=
 =?us-ascii?Q?BMEVGYlv+rSfyuqaO6oyIvawcBi1R/jE5NrXMtyZbGRuDo8NGtqF1yNIb0s4?=
 =?us-ascii?Q?DpKt0ynR4WuyGEFfT9iQ4bb9cT2rqtUZcY84S+1Z181jkZtHmqjSUwU2jJ91?=
 =?us-ascii?Q?SMqwZVENSyCPZKdbltxijCQSxuRbEsWaEYi5x0NRgnnR9row4a14GqpvtVDF?=
 =?us-ascii?Q?1HAQSc0AZYmXSyp40SYT67Pi0eOCYlVTZk7mfnOj++SmUaNml60teYhfhMp0?=
 =?us-ascii?Q?kkBsA031SFXy/+AfaS1gtKPo25yy5Z6YfmOkyxfbkW8TFp6xSMdgHUI7VAhT?=
 =?us-ascii?Q?1T5Awo7SiEri8JQiqpZJdmuM1EsUKMRcq/fC5Amt2k9R/5IJgvaLjvMQflEL?=
 =?us-ascii?Q?gV/5lqT9Dnpriyqh9veQ6yKxoYhZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YOGJyPuKmC10oRUbGYBxjReeiHXJEw/5ZLFykLjQTjiWwwHUCckjsgHCVpY5?=
 =?us-ascii?Q?spAo1KzQMvA1muboAokG/SeqDlhc5n6xGgXgRlQ6hIOEQoKPfmTfi+uJwVlH?=
 =?us-ascii?Q?Fcmp45ny02dwK1QUrKk9HfZr0jrRD1L7r9gcRvfrfI1NMbrTmeeqAuX+gg2X?=
 =?us-ascii?Q?lKiMRbbcPZ7sUStlHFya4mDZrQUoidky1gvqK6ns78oeQSZ7UtXIqRroodAu?=
 =?us-ascii?Q?7iDuN0OqE+vtYoOM6NOZT3cnJsGai/oW0lt/MlJuHb4ufuMi9nr+ywYp21S4?=
 =?us-ascii?Q?eaJGzfF3G22DkqF3nQ8xs/XI2BOi8fJ02fkCubuI5wdNk5mOZ+1hYj/GC+Ji?=
 =?us-ascii?Q?4rLysveyujCqehggD1JAGqy6KI1vz4L3nQJIRFG8ky3cwlAlSJfwAsEvlde2?=
 =?us-ascii?Q?6Zg29QVV/Meh1YWMQ8FDCHKEnXXoEY5VI/m+HEayFoZK/AKxNGdXcrohKdYC?=
 =?us-ascii?Q?o/ElUlkJb3rqNTbQ7tHAdDu9GZ3cEfCN7oSEfmJoP//UF11JAYabPBnmge6W?=
 =?us-ascii?Q?tL2TPhU7bSwsR4d4pEb79D+ANN32zQPpyQUPcrKm3m1m3hn5KOGm9IfadjuT?=
 =?us-ascii?Q?iZiECtjJ6X3N3ttLHDHHTfUv8JcOgZorXHhMG3mA8Depc+FMMFYHse7Sq1zw?=
 =?us-ascii?Q?BDV3Z9VB2BP1Lg9NT+BwSbvMBLEqSRJCOdVHEDveFXSMKw6rek2gwknLjcxw?=
 =?us-ascii?Q?JhScRHhf5YKYr/x/AITGiA2q44th+mevV6pRvxSCbwqxHFx+xGKqOz4g/TLi?=
 =?us-ascii?Q?tJ1Uf2EDfSh+0zsAjQaDOPdKcI13JkxyGXaNRakiT67Lyz9JpTWaT+92RIrF?=
 =?us-ascii?Q?VIgjx6aip7UvWfOX/5WXAV8AaGbKuCBbEt/NQCgVzOlrETcwSxXCUFA5k55A?=
 =?us-ascii?Q?KqJEECSy3JiTO2AuKUOx3DwPkCQzD40WQ5SUPe1UqR2RG/bHo7ksbVSvZws3?=
 =?us-ascii?Q?xsBnL70jTmz+0o/zFfeT7Ld6vWfKsBC4EbFmOjf8/t6xHMowIKgLw1p735w1?=
 =?us-ascii?Q?qIhacPdy3ZguiyR0P8fPDqPGV0yN7OBD/sy2KDe8PY/YY1LaeQGMkAzR0QX+?=
 =?us-ascii?Q?xVtVyAS5Mf2d8vwQyuHFF13ztabw1i9pOSHFWSzEiyvsmxvsniUZLPgypf4m?=
 =?us-ascii?Q?dYiL0mHRqVOuyMqn0okVfuwzzsAx/yVFE+uV3XfZqtTXGpBQqTQ1XMyVG5Fs?=
 =?us-ascii?Q?GV42A5cRQQr1bCCcjJISuswrhhrVmOn4TAnps0IvONeV0vqa+2eu6xDSC70m?=
 =?us-ascii?Q?Ax2el6ygXjKGEzcC33tzMnCac5x37lqmtBD9zUuwK7YnQWMuiCQpu0CP8X6o?=
 =?us-ascii?Q?0tw8M9ObiQ+ZaxXc8Fl0pZikCkW9NummZxI8Wo4MfYy9F+rK6o9Dpy629uHS?=
 =?us-ascii?Q?SpoxKyAwy/Scg36nxbkJIscwvwwbhO5EPesWgrFiatTSDoqhG8xuxWbZYmGp?=
 =?us-ascii?Q?TYWvb/i6IY9J/8JvUPgpijCdrHi0GqH8hg5NqNk/aDIfmWgVOkk59YhaunVN?=
 =?us-ascii?Q?3pagoNGw9vRCCvWjMavalFMgCfWLosWoHqqRUDRXCC9FSUtBlb5/BfGDrwxo?=
 =?us-ascii?Q?k9eyjjf1GNeTi0O/CCs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598044bf-73f0-428f-adf3-08dcb6714809
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:23.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HsDZqRW5Yr9ist6qP5NAfL4lTJpXVtdNehjcQhDXRkXtBLLDbTeKTiyfNPNfwXJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

From: Nicolin Chen <nicolinc@nvidia.com>

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

Note that the loss of coherency on a CANWBS-unsupported HW typically could
occur to an SMMU that doesn't implement the S2FWB feature where additional
cache flush operations would be required to prevent that from happening.

Add a new ACPI_IORT_MF_CANWBS flag and set IOMMU_FWSPEC_PCI_RC_CANWBS upon
the presence of this new flag.

CANWBS and S2FWB are similar features, in that they both guarantee the VM
can not violate coherency, however S2FWB can be bypassed by PCI No Snoop
TLPs, while CANWBS cannot. Thus CANWBS meets the requirements to set
IOMMU_CAP_ENFORCE_CACHE_COHERENCY.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/acpi/arm64/iort.c | 13 +++++++++++++
 include/acpi/actbl2.h     |  1 +
 include/linux/iommu.h     |  2 ++
 3 files changed, 16 insertions(+)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 1b39e9ae7ac178..52f5836fa888db 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1218,6 +1218,17 @@ static bool iort_pci_rc_supports_ats(struct acpi_iort_node *node)
 	return pci_rc->ats_attribute & ACPI_IORT_ATS_SUPPORTED;
 }
 
+static bool iort_pci_rc_supports_canwbs(struct acpi_iort_node *node)
+{
+	struct acpi_iort_memory_access *memory_access;
+	struct acpi_iort_root_complex *pci_rc;
+
+	pci_rc = (struct acpi_iort_root_complex *)node->node_data;
+	memory_access =
+		(struct acpi_iort_memory_access *)&pci_rc->memory_properties;
+	return memory_access->memory_flags & ACPI_IORT_MF_CANWBS;
+}
+
 static int iort_iommu_xlate(struct device *dev, struct acpi_iort_node *node,
 			    u32 streamid)
 {
@@ -1335,6 +1346,8 @@ int iort_iommu_configure_id(struct device *dev, const u32 *id_in)
 		fwspec = dev_iommu_fwspec_get(dev);
 		if (fwspec && iort_pci_rc_supports_ats(node))
 			fwspec->flags |= IOMMU_FWSPEC_PCI_RC_ATS;
+		if (fwspec && iort_pci_rc_supports_canwbs(node))
+			fwspec->flags |= IOMMU_FWSPEC_PCI_RC_CANWBS;
 	} else {
 		node = iort_scan_node(ACPI_IORT_NODE_NAMED_COMPONENT,
 				      iort_match_node_callback, dev);
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index e27958ef82642f..56ce7fc35312c8 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
 
 #define ACPI_IORT_MF_COHERENCY          (1)
 #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
+#define ACPI_IORT_MF_CANWBS             (1<<2)
 
 /*
  * IORT node specific subtables
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 15d7657509f662..d1660ec23f263b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -993,6 +993,8 @@ struct iommu_fwspec {
 
 /* ATS is supported */
 #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
+/* CANWBS is supported */
+#define IOMMU_FWSPEC_PCI_RC_CANWBS		(1 << 1)
 
 /*
  * An iommu attach handle represents a relationship between an iommu domain
-- 
2.46.0


