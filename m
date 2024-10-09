Return-Path: <kvm+bounces-28283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0954599717D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50D5DB2270E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE0F1E2013;
	Wed,  9 Oct 2024 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iMigaRbG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662231E1C28;
	Wed,  9 Oct 2024 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491018; cv=fail; b=loK1aI8n9097eP6b3LVo1U8XzH/3/d7b6JkaDdqDctIpEPHf3ntxE9MLFcU73uE1mialmiYofsNxTmAYBxSkTsnS3YH/R/BxV4liuPfj6khvGIFjmuYkmxxYh5VtrZsf/FzGeuENJ1VhJlTAxTf13ICnZ8EEG2DoKY8lpLg4WiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491018; c=relaxed/simple;
	bh=aO4bbQ0a8b9xl+qDwfqWXHEHMH+lGK3NUhAJ4TCyPNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n2Fw7NcRyB+xG16fLrBwAABUo9kZHK7ANfEv/f76iu+sOyh0feDbDA7XDTMA3jSoyBMNThux5o0Nvo0l+05GMPytigjrUYMpXkkYMExM8KFQMwMMKj0Qmvva2GYoDV/WVErb991dUeu06LWd2mwpUd6bJOC6wmf2FeWsDL4xAV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iMigaRbG; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xM2/+PyHCF/aDP5xcUjr17W6Ul2zex0TtCIZNU6bI7gQ27pXREy8MaNiODl7qGB9LyQp72evhJP409OX0y+OIz4BHLnBTTPzr0h/wEe8FhCOLIJ1fjqYUGlAHM+0jgAuUPqB9fwFw5QC8DlVYBncIUo3qWvYm/5RkIQPHHor0xHHERe3NtU3u/gPQoSF6Q/aU6cspLO4x+9Syn5u+NhQK1HOZ2KTUvKpqsI6df9wi6FB9q7w2VciuWWAcpDZRZYGdEAWhUpQijT9ktExC6jdHm/WClIWRsntHozFhiA+vCuG26onbRYNBxDHCFLdc24nQfYr0cENrUW2h+4OOYrbHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jT6Y5LUXQWoArwiC5FxjhovM1kp7zOqJgFz7SRJmliM=;
 b=qhMmZG3J5RvxqyazREXyYklDTU+eMvRIcO4urdNXQ7xhk06AFn0Ht+CR3BECEJNDPU1Zv/BrZFJaAtm/i8d2YuACFAN9QDp1zJ4ib9Dz30BPDgR38fId1ZxhAUg7KfS29oN9s5Y7K+nihKlEERT7ec/L9qNvCbdqgJv5H+JYLDO8np5UlL5942FBNxOmhKxcNg8chT2kTMzAF//UDfhtEFvCS2exbQW0i1fwHgA6Q52kvtL2xBKBMFZjTPG0JV/weB9DYGVxAWKCUsqJU+XTc7YBRwf7ldompWL6tCzikK8it1RfyYf5qIMrJwf6TXQRCNYe7DXxDFDZVfyrqN0uEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jT6Y5LUXQWoArwiC5FxjhovM1kp7zOqJgFz7SRJmliM=;
 b=iMigaRbGwZDtnaRrUu5viu/hrnTyNxmvrE2+8Q74ibmPLv8ZNd8qsxsuLWezEtbtLwLbBX+qX36zDUmzFpE/dhmLuKrKNEqLscQqwdvHdfR2wVWPq1VGHmexdEPpEVFO/Sher5MEUgDRbmqo7Ok1iyNUdOMylBXLjG5UV6RpJwT8KKOdiOhq5AhNgB3WtVXlpsaXHBHfPh8n1DTTg56uPo14EacAdOHPBfYSQK/xJrxEnOMbAlwkwJItUadhni5qbfhrKk3smjXbz+yOjMdYNQgGRv6iH/Y3aDMK2etHA+9Qr4YfRJcZzgDoEkGybNFeuLM/dIpnUZSJbK2145iwsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8768.namprd12.prod.outlook.com (2603:10b6:8:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:24 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:24 +0000
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
Subject: [PATCH v3 7/9] iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
Date: Wed,  9 Oct 2024 13:23:13 -0300
Message-ID: <7-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:208:256::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d113752-b73c-4cd4-f9a2-08dce87eaf4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eXe1KiZLtsvSdPU5XJqEAUaDb3KcDQIAQxsGyCOh+gZjCPkeG3QCWq1dp2SH?=
 =?us-ascii?Q?eM8eo4sZCuNaqb6/oaiyX0DztdVMyixjJh5YdwzwEHXupCz5v+40w3rXg0a0?=
 =?us-ascii?Q?Tzj1GbCAhd/IPqk1vvGXtCt0C7FGX4Jc2rnzID9ddnGAnPUKXzFfeEtZIRJo?=
 =?us-ascii?Q?mS8T2UlV+miFlnL487VKamXImjBUEt9xRVcvomB7oczLB+ffpAhXw0KcyQXV?=
 =?us-ascii?Q?jnknxxVJHr/rn4+KpRx/rraZxXO0XojN1m7fEveg4cyOuPNXKQAW8oYxIsrj?=
 =?us-ascii?Q?/7LB3uXrdxssW50BlnQHlKgUlEsTifMbMkDz+bBLHtaKT5yMGnbrceZEWpRa?=
 =?us-ascii?Q?0PGSUA4HuewmBu4NIKHhdstLdQDFFk/LwOR0sCXUrUMoYVi5NYSXUwg7G8VK?=
 =?us-ascii?Q?vdUOVb+/qoGn7GfpZUWMhssCVnpx+6dGZMxW9DS4dJGjE/IFyNLK1shPA3fw?=
 =?us-ascii?Q?HgPGUQpH+HUUT2rM+RPA6L1PL74kw0njnaznsjfO6Pqo4XJ4sVxNW4BSJ0tf?=
 =?us-ascii?Q?fD4SIG82JaRX2QWqF+3AFClUYt/Coj0yLyEqiUkXGgZya6h9sFrzrrjKjztI?=
 =?us-ascii?Q?+CitKPFeUNZ93z0hSQE4B/GKzCbXobkcp1QvQYn5xFkh6itV8Mb3B/RFhPNd?=
 =?us-ascii?Q?SxrHHq/jpM9SQr7YHaJQAsMlXK245S2LzXOPcnn5957FM3mHxghpdhfgYkO+?=
 =?us-ascii?Q?pUN9OpaVhs237L4ZbVE4rSoeG3kun/wbxDgCvm6temIXrrRoc/1S8iMnZTJB?=
 =?us-ascii?Q?9qzZnar3jjmlcS/4asNR6GhV2YLU00Dxsd9VtQ65k2GNhB20rNaclGWhFC+q?=
 =?us-ascii?Q?fzdLaHlFDzo+dv3+vbYi7ql7RqY6Ia9apqL5Aj/AuHyLAj3dJfh7H1lFXVO4?=
 =?us-ascii?Q?Fqsll2TauQ/WW/GZ2ZHHniPgWENxzeSiwDu0SCE/izbD4zWCFuLxSWUZebyM?=
 =?us-ascii?Q?QI32f0Gk2OXoLbc9rC9WjjK3JEe/JNUeLqc1xPgz/Pk9ZA7wiV7zOjt68zKh?=
 =?us-ascii?Q?1BiWvzdH5pmbBJCEQgyN+ReethmwQzRPsr8IkaJ+gpoapoNyCMwRe1ogj1pK?=
 =?us-ascii?Q?gbnbtkW05xIrYtEqcuBwQRoPkUHcQn3C0tnnmFDhE9LIQ+jot4BZh7pHFnQb?=
 =?us-ascii?Q?ft7FRM9nRcjG5o/c42DSn0A9tOcutzvz9WNDjr8KvKsDkWMlEvtTcpyZjYHJ?=
 =?us-ascii?Q?Hjax675EjvasfOBneZdaMoFKi2nze2pinnekPou/Hf+gMkhH7KfUiVNSPLyE?=
 =?us-ascii?Q?aL3xZy1bRK9JZpb65V800+jHYjXIsUdIbXFH9YHjoXbGHkMr5pxgtMMs33a8?=
 =?us-ascii?Q?0GQokAciobWKOUDRNM7XYgKs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jPBCbswzEzb71qftBregg+k9uYHloAu5HeACD8DUzVn8DZsVyZ3hpKdDxZtT?=
 =?us-ascii?Q?/nVO2XrQmi/VBlbmR6IsD2mmnCK7Z56A9LQcGtJ0U7IULVwJAu6L1hhbhHz5?=
 =?us-ascii?Q?rr/7rref8MJnrSm1NNfQSAmlJ4+U4U8DiTALjGG9NBiOwaQWwrUll0+1/0Tv?=
 =?us-ascii?Q?3BQ3QOb/qQ+EQimZ9riO/SCrHMWT/lPR5Ijom11nNoyfv0gYDa2i7VdeYDJZ?=
 =?us-ascii?Q?OiK9ZJCSSVQHlw/DpIJJIH+gmAluuJZS+qiY5wvcsGXs08tuoP8ZnL6onV1v?=
 =?us-ascii?Q?LLE4B0h3XZJqA47bVALe5duo6TBxZuKdwbBsdvSxT3fw5NgU7QqT2i7GZOnO?=
 =?us-ascii?Q?T1+N+2q/8A7BVe0N7x3LSIzg+jrZkYGmvq1Wn5eO7pLb+5MT7hszUtVRs7FR?=
 =?us-ascii?Q?y79mJLZZ5s1dK8TDEkHfSNag6AhNSMEbgf0BtXDt6mrztZTZSTCZM84Pe+Eo?=
 =?us-ascii?Q?XHPtBH4lqwDldSRdRWi10AHlNFO5ikqh+NwrYYzW9bqhEsyGlFmpEhqrlnBD?=
 =?us-ascii?Q?Xnb3DK34ahOV7UY81gvI+kQWAdsFF7MLrdznMA5VCC8FtG475cRBdGAKaEzj?=
 =?us-ascii?Q?+k0RTzMnZYBEZjCZXCpSoV5SzOvi6oVYXHCV1tn5jsLdDim2II1jHAerIcAk?=
 =?us-ascii?Q?mLH6TMCLwOdXvQqJLdHi2rHUoEO6egudmHDOVLG0DGSPNEEklPrZN6/4XU3d?=
 =?us-ascii?Q?KY12GNBjCRYXFVlO7VUJbCk3nEXcRhbPTASk76HSgcCqFkwikKmgv14PKoO6?=
 =?us-ascii?Q?NXQJeu2kMv1eDuwlKbb6J/UHVAAriYnz3SKqisEdUWxNFQS+8tTdJuWtgQY+?=
 =?us-ascii?Q?Gsd+fIXcxoEwySJPP0vQX4vAdbcTkNsRG57iAVJzXo3PcMYbBqnIxPRC2R5G?=
 =?us-ascii?Q?j/26iSM7rIafpgi/QpjIov8w5DPTE3PxvLiQrHe6pK5kqPmm8T4IeltEksY2?=
 =?us-ascii?Q?sRYoDv1Fz0/8nj4r2YAg4SwMG6iclJ3fLCGvQXVT10OVgtvKOfSZvSSkqQ3+?=
 =?us-ascii?Q?li6HSbPcpBMQTNYRvP65Py+NEr0g6VhLYnwshfEPu5LVhLJLVw7j7GY9IH+C?=
 =?us-ascii?Q?KFCNXs4mdujX4ikZGjAuZ2qEusmxFRTVeFFpEQut9MvPtWSSOGannauCLtcl?=
 =?us-ascii?Q?IJXTebxAoWBcmTwRTrz1pQZ7OPsSEgaxfJTp4c9BGWm4/6511NvuDWYwkHcG?=
 =?us-ascii?Q?aEGzEiI2vIZIHTRFocuzL6EB4WSOgkwIa35wDLcp2ZCz57WThvyyEqa2x8yt?=
 =?us-ascii?Q?cmlumvEkA7Vd/BxoLYFV4cwI1qDAIhYFOSnah1fRtivykxl7/7BbNDYiFCvS?=
 =?us-ascii?Q?ibVZhNfGjxGYqPYBfcljnEgwoD3i5RJhPrAkW4cv87zgsBpsQEiQUd6lbvwd?=
 =?us-ascii?Q?dr3LhXAEAALC5QtmdEuyeYqKjiNnMr+b5u0FpaZl7F+0hagAxPlsoUqn9LJJ?=
 =?us-ascii?Q?PtAJDBBjh82OARh0jXMlblTsmkxrEiZo1algJ/BfhvSYP+cyIf+326cwlaiZ?=
 =?us-ascii?Q?XaCsGBIGpazXTPuDLfsmHQZ0wC36N8N+1oUBTX26+jN1vd10U3vDYn6o+NXM?=
 =?us-ascii?Q?0ei5p6/r3AWBXFwteX4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d113752-b73c-4cd4-f9a2-08dce87eaf4d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:18.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RV3QZpXL9qUp5ARwKdZnmDLG33bkwAT55o14qCpseXs0MgMBrjgMcqFgQ6tQ/EJf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8768

The arm-smmuv3-iommufd.c file will need to call these functions too.
Remove statics and put them in the header file. Remove the kunit
visibility protections from arm_smmu_make_abort_ste() and
arm_smmu_make_s2_domain_ste().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 27 +++++++++++++++++----
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 80847fa386fcd2..b4b03206afbf48 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1549,7 +1549,6 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	}
 }
 
-VISIBLE_IF_KUNIT
 void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 {
 	memset(target, 0, sizeof(*target));
@@ -1632,7 +1631,6 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 
-VISIBLE_IF_KUNIT
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
@@ -2505,8 +2503,8 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	}
 }
 
-static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
-					 const struct arm_smmu_ste *target)
+void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+				  const struct arm_smmu_ste *target)
 {
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2671,16 +2669,6 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
-struct arm_smmu_attach_state {
-	/* Inputs */
-	struct iommu_domain *old_domain;
-	struct arm_smmu_master *master;
-	bool cd_needs_ats;
-	ioasid_t ssid;
-	/* Resulting state */
-	bool ats_enabled;
-};
-
 /*
  * Start the sequence to attach a domain to a master. The sequence contains three
  * steps:
@@ -2701,8 +2689,8 @@ struct arm_smmu_attach_state {
  * new_domain can be a non-paging domain. In this case ATS will not be enabled,
  * and invalidations won't be tracked.
  */
-static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
-				   struct iommu_domain *new_domain)
+int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
+			    struct iommu_domain *new_domain)
 {
 	struct arm_smmu_master *master = state->master;
 	struct arm_smmu_master_domain *master_domain;
@@ -2784,7 +2772,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
  * completes synchronizing the PCI device's ATC and finishes manipulating the
  * smmu_domain->devices list.
  */
-static void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
+void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
 {
 	struct arm_smmu_master *master = state->master;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 66261fd5bfb2d2..c9e5290e995a64 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -830,21 +830,22 @@ struct arm_smmu_entry_writer_ops {
 	void (*sync)(struct arm_smmu_entry_writer *writer);
 };
 
+void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
+void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
+				 struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled);
+
 #if IS_ENABLED(CONFIG_KUNIT)
 void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
 void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
 			  const __le64 *target);
 void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
-void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			       struct arm_smmu_master *master, bool ats_enabled,
 			       unsigned int s1dss);
-void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
-				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain,
-				 bool ats_enabled);
 void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  struct arm_smmu_master *master, struct mm_struct *mm,
 			  u16 asid);
@@ -902,6 +903,22 @@ static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
 	       IOMMU_FWSPEC_PCI_RC_CANWBS;
 }
 
+struct arm_smmu_attach_state {
+	/* Inputs */
+	struct iommu_domain *old_domain;
+	struct arm_smmu_master *master;
+	bool cd_needs_ats;
+	ioasid_t ssid;
+	/* Resulting state */
+	bool ats_enabled;
+};
+
+int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
+			    struct iommu_domain *new_domain);
+void arm_smmu_attach_commit(struct arm_smmu_attach_state *state);
+void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+				  const struct arm_smmu_ste *target);
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 bool arm_smmu_master_sva_supported(struct arm_smmu_master *master);
-- 
2.46.2


