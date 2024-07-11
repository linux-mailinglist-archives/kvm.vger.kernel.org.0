Return-Path: <kvm+bounces-21435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 409D692EF00
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 20:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAAB42831D6
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 18:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B338216E876;
	Thu, 11 Jul 2024 18:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YhW3u9A5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C7B26AEC
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 18:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720723055; cv=fail; b=R4+4CL8+bywuHQtCeSEx7bpTVQQv7ONAp/ICAeiPRzzFI9nhrPlo0166usSr823jYz3m8St7GH8GftJ7KXJob7d62vqQ+sZt9sHrPWriROUpSOs04aqwmZhGoXrfUcQxvncWLPCzYv7/ORJZULt+h//WtUqygQn6WVMCDh2m1kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720723055; c=relaxed/simple;
	bh=rhDAef64G0MT+TX4cTWR7Umn6+KkAF33uch7h1OSOMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H8H5Lp5UiLorwrloFHwGpUM8IheO1P5Lbo+NIBkRSDq0PtNzv5sf0IXqet3BTW33vT9TB/1XGqysElRiidcnBg2T3TAIsNvGDahddW5kBCisdMC+L0LUOqOSCMqWdrmpJjK98E77MgHiUUkxQUxlcjQvG5XST83P3hEdDJILaos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YhW3u9A5; arc=fail smtp.client-ip=40.107.243.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5uCrIO002Vjq+5dtvbOOXGd/zCxK9SAiFIV8KE9YWlSv03PH6hrbf9gbdAGdrtsuTFsuh18HG+7R/UuoEs3p+LN4OW4q984KuEv5XYwMnaD3rZXaPhNVpiPk4wvXbUIGfqa6yDjwUfdNNkuLlL6k2JQpOG2XVdu+jdNs/ZKEEMiTNgEQbs9LT8P2KH+AUQQSs5VdxhaOfaHL7FOI4HsRm/q4Epj8HuxXROcFtozcGWUJ3YiLhONQLtZLuQ/1K/uR0RHyr0/syGlfHjIK1JoR6rkmV3vBEZd0VP05puR4i2uYFoCvqJnBLQNqsaynPpdLDenk9JKwSGN7/uXeOX81w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRmcxd2AJoBHiigV4hH4zOBzhzh7j+l4ex8zxXVvLuk=;
 b=YgEmHUIoY3t77FnrgDpU1czk5oMZ3SKK5jwmwGWlbu/XinSTmqPTYi7B+mgI5BEMlwQV33icTjQndn596VNEAdUSd/FMTc8bw/byzZYi7c57jirv5mGymPsPbAJBMHYLT4f4oKaoNXXfcoYWb9/CTP6I118+DXFyOwKqnhpqY2nZ6ecYcT1EZi2/sCGJfnYNxu3sh9jr9gY1nXbhfKgOg8bK8gQHQbU6Gk8j+HLHai2I3PI7hPJIMRSSsR6YNN39NHdZT9J6u3pF0eiW6lHETMMPVyH5vTewlGEmKKIfTKbXK2y4F8CldhrhzRh1DxICQ/dvjOJ8XChOK0Pz+zG3Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRmcxd2AJoBHiigV4hH4zOBzhzh7j+l4ex8zxXVvLuk=;
 b=YhW3u9A5bRZbnvi9VViWBlQr//PLnb7KbFX6Fr/rAMx3c0Fv8BNnJj5W6VY6u7R4KVxskl5GQamnj8LRtDBi+cjYDu5Sw8HZjg8QlB/bQ1kfbtrW9Xn4U3o4THMEDQQZ++4AF0PfQS9Vy5a1r8lcfcpCYVo7v2jIfJBQb4iGt4qG1EcRyDCCwdayzEXtri75jU+qiGG1prekPY95GBR2ZqKGED35Oq+42M/SHRexbQL68Ot6AVW+wAA97Njcp6BGZ4bw6yCQNaPnvIn3ne3QZZD7UYLd6QYm+2W+DywUxGGUkDnRZfFKsrO0vDwguicN6yMYivljIP/1SKBtDMmDQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH0PR12MB7957.namprd12.prod.outlook.com (2603:10b6:510:281::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Thu, 11 Jul
 2024 18:37:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 18:37:29 +0000
Date: Thu, 11 Jul 2024 15:37:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Message-ID: <20240711183727.GK1482543@nvidia.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240628085538.47049-1-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR22CA0023.namprd22.prod.outlook.com
 (2603:10b6:208:238::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH0PR12MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: 4688d703-0ff8-49c0-40a1-08dca1d884c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4Hq0XeAElquIltJmVV6njSlPBeTvv4dLSz8q1ua8VpuM3uU/D96Ty3tZSr0P?=
 =?us-ascii?Q?yOAJhfBEgERExEMUpFUzkcfU8gER1CxvxI0MdlgBuV8zLoYWm4mqQtCW+ykS?=
 =?us-ascii?Q?4HfKqaHiywwvb+L1fagp+/5Mj6GA8haJ4TZtZx8hgY652rg5brXGMBgJIMGs?=
 =?us-ascii?Q?uxxHvWgY7r1O0+7x3HbQp82VCVuG6bwUO0vHzVdWa7yS8BFzztmU6z2Qc+Bh?=
 =?us-ascii?Q?ecu2rSTDjhn80tSaDaSNFwjZ7ajagvmGqK7Ojr05Jww6hWwxcg2OOXbr50ZF?=
 =?us-ascii?Q?qAahiXXTd+VgfA81MLLIUPNvCtscw1fzj4dgbJAzIEdY96EDusubVqrKMSxi?=
 =?us-ascii?Q?wprIP5pwLvRjYujz++iA7dX8P+MsJILmejSBLWktRjMEmJVwelwbDC1stTc3?=
 =?us-ascii?Q?/qIo2TIkxAq265fkuzXxc2vctNoOTplK+aVT6N042M/Tdgn+E81YKiCLEK6Y?=
 =?us-ascii?Q?J0Dl98YYqgPjNUtYmnNB5cLsBHdeJznND6AiicdIuZIlQaOnv+GcJzXtPuql?=
 =?us-ascii?Q?EZmhH1ntfut058uglaeARNOZrPX8Vd4h5UmlNqR0/iOgdWqExaAxd4SG0+dF?=
 =?us-ascii?Q?ilaLfXqC0UNQ+PGjojNS9EpU2ZNIZ9PDNMWyfoEC/IdLejJO79Cqfb3VxkoA?=
 =?us-ascii?Q?Y5+oSE168c0tTzLuUCG7B3G27MLpWE8C9ddZy65qAwRCZOapMznzRN/YlUOz?=
 =?us-ascii?Q?6Wn0NVtqr1+GFp4V35g+C3uLu6WX/8k8k3thLnu3zLUSRdEytMZtfPERekFP?=
 =?us-ascii?Q?2CnwnYB9qBQhLIvr6qv+XaF3hslKQx7CWHRvaYWpQxjIV7BN4d2bRBkDYTqj?=
 =?us-ascii?Q?ahWlWZ9PiyHmFp0X+AsnNgi62arMNdYwFeavPxMOVvjBqrhaafi/ZMIojbn2?=
 =?us-ascii?Q?slWH1Yvmg+E//PmzgplIz1EJhYNN5ifue+edHxq2JkbhPSQDbXSSaYLiQdji?=
 =?us-ascii?Q?Ca2wXDsN/Oscre2x8GKk+dj+9Sre+IZP9FxX3RGOzNhJbVuU/l8LIkuI5CVz?=
 =?us-ascii?Q?cdflHJ+QtOBx9+lJsH/cshZSjNpCJVMqjXtpF9IOC0p8j8FArOPNQx0UsKia?=
 =?us-ascii?Q?avMzVqV4qEaZPwJdJ0O58SpuiVbyMVkbGJmzakNGBM4W6agx8Ab/Cx3rNYXe?=
 =?us-ascii?Q?wyX149Q01ZYd20hIEmy4/TjUiIgQ8m9c3mUhuUuA2ueZBXfssNC7s7akbA+e?=
 =?us-ascii?Q?1VFj73SRGiUuwO6DmtoR9zZlHoh+FELN6MWQAmQLOqW0V8mqvo9lfX3LmyhV?=
 =?us-ascii?Q?42xi+/PgE0gCU0YFdK5bv5E/6N9uHxEE8PpeLM2GowpezjM0ZM9yfVfz/WTN?=
 =?us-ascii?Q?v05WYmjwc/iA9h8PAsLnomf68NR989h4aon4EYJhR5nfBQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0hveSrGKdrUfUu4M5JGcq6neSqmc9uOw9uHQJyDamByvzTuEaCEeYMxPxp5M?=
 =?us-ascii?Q?lxuH9jyZpb4FC3uCxKciSn3MlnoYnBstbqzxeqpoZvcawsIx522TAqeq1T6d?=
 =?us-ascii?Q?0WaOHi6pjnQEmm4ayqHZanpz12wLJSma3a6+gspcbNSnUNgnwEtKBINjao/u?=
 =?us-ascii?Q?gHf2ONxNUA7XuwZwz0FK37tlp0UTngIINrtW+xkaEBwU0Tx8npegVnpXGdZi?=
 =?us-ascii?Q?zmsnN1FBrpQxotoHMYKWMOwC8aZ1JRncGo/kRIRsxLIOAJ6NDfq6hxnnfplq?=
 =?us-ascii?Q?BLkxjDPjCiQ+u73D8hs3h8yHx/Pa8g7mk9apn/1pX8RfYeQJ1e1sTK+YvdDF?=
 =?us-ascii?Q?tOD46cv4YN4BSEotZ/St0soQgYetsWHvWJMmQ2p1/vxruhDkcy04HBN4J+0Q?=
 =?us-ascii?Q?VQWm2Jj4HEGOaqUcG5mQY9xF8e9mETID06cDs8w7c7HplejFOzb3xtmqJ9EY?=
 =?us-ascii?Q?49gIoICKY+4sQ+0sKF+y5AXtPpF9KQ92R25PTESO/1eonQa5tlFHEFXmFWFk?=
 =?us-ascii?Q?5tOEBpRy4CK8Kl8cWKKrHip9mTf84YU09QbzaDXWBW5dvdCeBGprbdJDDEWI?=
 =?us-ascii?Q?rqwX+pXrLNys87QluzIXwUwokVETU1yQ9naF6/JNGjN2UjS+LP8nYE+PHWKs?=
 =?us-ascii?Q?MDvSVkniOtGeJrjYwPFUJYkB/HpuR3k0TUNdp49/RiKUJ5B6wK7SMULfREKc?=
 =?us-ascii?Q?20DwnIxCL+N7x3jQunT1HWOPumuMUrobTidrZ8Dy58bYllkS1UjKpYHfnFty?=
 =?us-ascii?Q?FSM82D6Mtbt3wLRm4/t/5JFe19O5y5sbpsR5FWhL3iFk6zGDSiE5/Qyy2ihW?=
 =?us-ascii?Q?3UwE3fL/A4miVMre4bB5Gv2Q8kzJJpuADT1K8HLZtHxCQbeVuxmxPKT4p90C?=
 =?us-ascii?Q?8V+FGrfXywjlcgSYmfhv0cSuNgS8J6sTRTCbIlQ1OP0ntBWVlyz4cJ/zN2xp?=
 =?us-ascii?Q?HX2B8k3R1UGZy9IWST3O75b8VM6vaz5ebp5SSzFZW6HSwp2gYEFjDIEG6OQ6?=
 =?us-ascii?Q?GZre+tgawZ9ygiodSgoAsPOsyxwRvDyx4cpSWz6dBYUBwX6sGysBa4KXlVNi?=
 =?us-ascii?Q?iKa0zLZNMbodLiZwJG9peg4y60q7f2exYomNOCk7tc68QXdYqMdgDVy5LAEC?=
 =?us-ascii?Q?I1Re25rZtXjdyxgeULTx7AmTAPybiwAQiq+xY0iuyIkK1e8r/CzQ0d07u66o?=
 =?us-ascii?Q?dGICANGnfOY8g8cLwbmbQlHNx1doOvbBSaAMO/ZeK5+9FEvzkjntO0/AU6O1?=
 =?us-ascii?Q?ZzQfXWYcSEL+0nIhigwAxzyJAPK9l/MTAB8JkUbdEKzGYXK4abV1EDaGplPo?=
 =?us-ascii?Q?9Vociu4stRK24rt/neLshlW4BDwAUi9it2Qxl/ZXAkuCOUcgS7t0XUhCUsCZ?=
 =?us-ascii?Q?sci3gR2ksm6TTKX+4/g4jBNvkFMAHQOgfOKExm4OPMkQdPjP5vRjMieNj9Ol?=
 =?us-ascii?Q?+4g+CPoqH0GDaeZXTA333BDq2J+GAEbhNyy61CtZ0P6/Lhw0suACTZr8ld5s?=
 =?us-ascii?Q?PWXNLQ9PrzkPURs/NnBBwBjyvQ5oM0QR36LOXQ7Xu69evImCMfORNWun7R9B?=
 =?us-ascii?Q?TlgsmoxJRN4zgNAd6Tc4XSJunryehJ+YYq7vJT0R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4688d703-0ff8-49c0-40a1-08dca1d884c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 18:37:29.3330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYdUtr7i6MP9FH3oLdnlph1tCAuOwa91/7/etEGVwespEktKToYPn8xxkzjPA54O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7957

On Fri, Jun 28, 2024 at 01:55:32AM -0700, Yi Liu wrote:
> This splits the preparation works of the iommu and the Intel iommu driver
> out from the iommufd pasid attach/replace series. [1]
> 
> To support domain replacement, the definition of the set_dev_pasid op
> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
> should be extended as well to suit the new definition.
> 
> pasid attach/replace is mandatory on Intel VT-d given the PASID table
> locates in the physical address space hence must be managed by the kernel,
> both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
> which allow configuring the PASID/CD table either in host physical address
> space or nested on top of an GPA address space. This series only extends
> the Intel iommu driver as the minimal requirement.

Sicne this will be pushed to the next cyle that will have my ARM code
the smmuv3 will need to be updated too. It is already prepped to
support replace, just add this please:


diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index ead83d67421f10..44434978a218ae 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -350,7 +351,8 @@ void arm_smmu_sva_notifier_synchronize(void)
 }
 
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
-				      struct device *dev, ioasid_t id)
+				      struct device *dev, ioasid_t id,
+				      struct iommu_domain *old_domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
@@ -367,7 +369,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	 */
 	arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->asid,
 			     smmu_domain->btm_invalidation);
-	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target);
+	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target, old_domain);
 
 	mmput(domain->mm);
 	return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 238968b1709936..140aac5cd4ef57 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2943,7 +2943,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 }
 
 static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
-				      struct device *dev, ioasid_t id)
+				      struct device *dev, ioasid_t id,
+				      struct iommu_domain *old_domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
@@ -2969,7 +2970,7 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	 */
 	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
-				  &target_cd);
+				  &target_cd, old_domain);
 }
 
 static void arm_smmu_update_ste(struct arm_smmu_master *master,
@@ -2999,7 +3000,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd, struct iommu_domain *old_domain)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_attach_state state = {
@@ -3009,6 +3010,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		 * already attached, no need to set old_domain.
 		 */
 		.ssid = pasid,
+		.old_domain = old_domain,
 	};
 	struct arm_smmu_cd *cdptr;
 	int ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bcf9ea9d929f5f..447a3cdf1c4e1c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -828,7 +828,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd, struct iommu_domain *old_domain);
 
 int arm_smmu_domain_alloc_id(struct arm_smmu_device *smmu,
 			     struct arm_smmu_domain *smmu_domain);

