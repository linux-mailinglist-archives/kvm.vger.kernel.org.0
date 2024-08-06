Return-Path: <kvm+bounces-23451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E067949C67
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61B491C214BA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4977176FAB;
	Tue,  6 Aug 2024 23:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gpvq+JGY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB08176AAF;
	Tue,  6 Aug 2024 23:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987692; cv=fail; b=F4RQchzGgoGi+j4nZ0ASs/mFrwJic6YQXVxaZ+ArrlhePviUZlui9oq+FxRDv5QmzgXiiUUxB0DvMu7v3Pbb+lyC9ElctIczUSTYp2TJGrEJ5+yKv1gu8/IOuPbQWpFsIn/Xx0BC9AJGKwdRQSGoOZY1G2pOtkyL42o8CrRXrpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987692; c=relaxed/simple;
	bh=+u3q3v/zEl8OJuJgzddQLnfPOiBh7eRAB+eCdp1U5ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=thHJeim57AOE+k8qblX2h88wsDHVaJRhr/jPbCK3ED3I3lBHa0Xw1mJirHL11+eAgPmRaWRQsM2LIfvOU+H0ywV/n+W7Jqhtx4Std9RXKfQ/1BA8mcA30CuGdRMtbbdBaPGDYquFoi0+Be8SSK+XL2zZU0Bjw8mBNpaw+obNBRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gpvq+JGY; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3Fe8hAfGftnx+YuaFJF331ATUZCTM8d67oKl9HB2g+HxH5Lh+rKuqa63JktDXmfAq2PmvbpZVynXqKJAPq0vo+aZxXkF7NGp57+Zwyhsi6lWOV3RQGymb9Q8lAQ7+xokeSJQ7ec89yDamwIjtsMglDzUhusTHeQgM21vJzWZrlfjFFZLptXT0zsbIRJ4Xgq6DvpXOzFVq/Qo+GlYfaUW51ud5nBDyEmlkY0MNTuC98tREwgjPyFibNIx9VX1J0f0ucflwea9ZMqVA7PuwvQ8lUH0iqVCv+LkW3sOeyQRqia/OrI0YAyRrBLN0AbSv1zHr93ZKJyXjn1q4p82xzNuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VYPdcBQbLlrAWUS5pJUa5cwh/NlHTssas6dwFh2rlc=;
 b=xLbDfp4UHuyHvvFYtTu1LECyHP6N52vCQi0wx37PtwLzbw4Le1jO/SE8n++k5xp35D8ARWSsuReXKUTWKuP/6HX5MO7E9JH3hsivesa0SL/w2DJQyYrBY7Zeqa6p/IaeVnQzyt/Jvtl+Kvd/wm3FcvtZPv0zh90nmpdNA3m1j6nsCaCAN4apuHmqvKPV2n+aT9xRl+VcP1KrZTJLwMjRDpTJcDxElDXG5gJThSTeQiYDMvcotKVUPK+hC8uFl4YjzhWMTj0nrJMLHm5JMdMC7OyRCFLIFJH3xDhM+9iXnJAyOek9omF8C3aD2XeOH4rYwcOtTGsxA05hao0HsvOGcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VYPdcBQbLlrAWUS5pJUa5cwh/NlHTssas6dwFh2rlc=;
 b=Gpvq+JGYtdzbWud57bntAObNldGQuCt+5WSI4be7HIV+8NUXdqjOxyU91rPAIZOKoazJQiSF88pgnpW1xkZ8bM7c7JI+1hZ+RjZf5lshncmGNw+D69w28jaYhseduha7Ewm6T9oKDbEE6NncjP6oa7XITUUloMfQoC3xpBxLIr+TNNlk8tRQ3R5/Xhw7lzB7uK2zwHvOCZ7o2PtiipITaIHTLYxbUUiUuHasasCISQp0YjDbEiwTP1yYRMivc/QTaLhfE/FHErnWOrytBaIBzsBplMYnl9lD6pHJCIe57Xdm1uYtAwl6SFKlTvydMSn129ndNHttR0dSVAGZuwL4mA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:24 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:23 +0000
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
Subject: [PATCH 4/8] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Date: Tue,  6 Aug 2024 20:41:17 -0300
Message-ID: <4-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:408:fb::9) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: d3589e7c-1afa-4335-873a-08dcb67147e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q64wxfJYvmJ1Zxk+8KoH0m6x/+xx6apGTIlLDDTwk3L/EOj2vPGjOdM9Zqun?=
 =?us-ascii?Q?MeZ+Q/nUjNbs8IJoWchODA8/WauDq4Q3O4DjFNdcRqzanKvpm6ak4FJ8Wd0u?=
 =?us-ascii?Q?QZamweQFV4zpgwOGAR/YjwLPPk1fidjXn2rKG+WMNpVpH5dwiHUBZIt4GQQ3?=
 =?us-ascii?Q?KyQZVypBtyaBUzJtOXhsqcQSS2O8dQdwld3Uj/M7v+4d87EeVr2x1eFy/rl9?=
 =?us-ascii?Q?hFJalqATIFQCRjhDe4G+3AcIA7Bka15/fWw5K/ND90pV0CQYqf+nfI9CuQKr?=
 =?us-ascii?Q?vBSixPOejgSMhPoxR+FtgzK8m0CetggwSXdaa0UDC88MGT6QxPowQrk2nwpw?=
 =?us-ascii?Q?MyHp8toSvblJcHOhdeBgSvV+xKSB9XGvY63iwSnvbhPc7sGUQI4F/gKGls7y?=
 =?us-ascii?Q?VDggalXy5ziHlhoaorPEFAz+14JDqvFLIWtR7XhsSkHCqautHM5PO/H/+a/R?=
 =?us-ascii?Q?Dtqoz2bOt+aJxU9Rh0wPoM9Twvisi90lhaKTuLvn0653ZmX46L55URnHvyPW?=
 =?us-ascii?Q?VN/8rXJmrZmX6u6AJmgFnxelo6kuzt0/iDjvSgKRboj3Aottzx/gNCk8/akw?=
 =?us-ascii?Q?k8TyXQsKxRC2f4CO5JQlP8TVw4ZVbctIWKWNn7kDDRZqE8YpxZphpEGPpXEX?=
 =?us-ascii?Q?ywnwsqipsr5Rldtkir9SqidmdYmY0NMv6U6J1e6xzlioCVsIaY6Wbew95fWF?=
 =?us-ascii?Q?Eij/6oefA+uSZ4sEHwaW706ERmHfa8rqgNZCIo6XUHbLNAuv4KTsuwInyrvK?=
 =?us-ascii?Q?pLZy+76QqB7QsbO/9MoPehUYhJz3j42Mmc6av3ubImDF1t/eQMusqWLZqMig?=
 =?us-ascii?Q?mV/Wl+2TyyQalOfDjqd9c75OqtPJ+JfvlVSr/whnB786I07DKIhxV+Blhnj0?=
 =?us-ascii?Q?Hw+zVBZr0RrMQmOkcA6EenddG7r5jSabW6tw2qK28TtmyfNmtTZH9T74mnwh?=
 =?us-ascii?Q?fKpMA+mNp93IfVaWj2vDuY4+vch1UHgJwslwwxiv095XvGMeJthcfthK75bw?=
 =?us-ascii?Q?d0gaJWQh2mdf/QlkerEf7bN3CsM823FlOJUhKVkAi7lhttVAaR6MtPrrPKSF?=
 =?us-ascii?Q?8riEn5Es4lcGGfOrBuW7zLGdY5hUh60lt0SCriG2fl0sulD8q3Ol6jIYIulB?=
 =?us-ascii?Q?h8ppu0Pt14Gki9WwZ5NzXqFbotQctsa2dnkKXkUE0yMG6HMa3yTOvymtPMdd?=
 =?us-ascii?Q?9flArWeQF2jwwKFzQlIW9/1LMrbsHRSgh5xX7owmm82WcnfJKc6NpPIYGQS5?=
 =?us-ascii?Q?cFp7cEBKVLX97GV5HbwFQSXjk8AMJ3qz1189W80iUZZnW7/51+c1l1HBrvNZ?=
 =?us-ascii?Q?+7oUJCejx27nswbMeRRDuU5KkYXqNfkj/Pdphy1mgTeGqv6+BpiDd1+1X9ch?=
 =?us-ascii?Q?7b6Ip5bFTm//j3U02zOlMjwTBVZ2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vxDb3sIV7OLDznY/22D3IqobQQ7Y9dOTSlaKQrm+C8O22pM1Zlf0m5ZbkPiV?=
 =?us-ascii?Q?uaKlpO/QLRHTSvMI9rxXyeED8OmQCrHrMKKUEu+vgFcLe3TDpalgTL8OHA9r?=
 =?us-ascii?Q?ss1xXEl8KGtok5dpzWlEcPNmx4vNLZa4Xe3InRTOlL8UtC4/kU2nY5nJSzU3?=
 =?us-ascii?Q?kd/ZMTMitI0zz8CzixbqbbL9Znb3a77bwt0/zNRevqOo1yi5p94KI5HnSv/5?=
 =?us-ascii?Q?ffejW4LIyGhtriiIrRVgRNX39vZ33gFbWr4h/et+j8W51rsd4r989C8EIRPl?=
 =?us-ascii?Q?QEZ/Opra5zyj7EjZm7EUSMQKw9g3KpbemSxtlBW6DkGhhsbxrSx7WCWDydLH?=
 =?us-ascii?Q?3W/60pmqSgVzwzDmZt1Wm1Kzvv1jJM+Pef1LGHKTwpPzwnAk8orlTSMdSrx5?=
 =?us-ascii?Q?NWVgmawj3JXhGa7mfTaYRyyRZ04rmg7qeI60sPTO1YNBuMKX60nYdtFDu7NF?=
 =?us-ascii?Q?OwroQK4xz8264fpdWqvGC0vcxy1Eobgcc2aIHG35YgMwqqSCnO5P01RSCD11?=
 =?us-ascii?Q?TLtyENLbuNUnjzfMPMp+/c6srnufFMlCEpm7tHFpMN5uctgg7/oAR1q4Uc8a?=
 =?us-ascii?Q?7IlN4yYQkNtJem9KYsFF/WUhuQD/KjOckioKrvZl4c1O4+wSkMYJpcDKXDSo?=
 =?us-ascii?Q?dZP9HUhCqe1y42czIGWsnxuxqIajVVzUpd0i9oJlMz/AmjspCUV+/388j8kB?=
 =?us-ascii?Q?a4G8QzZe5m/LhmTBog25lzpayF2FyHVo4UkjaZbr6GPK+CcJB77Rl8NDMYaB?=
 =?us-ascii?Q?CWp9EZzJap1IZfWun1DFMVY+avozDIDKwPBMKSWVx1KogaxGT4qiHKXnLA+U?=
 =?us-ascii?Q?N0RXPu0jxEjrAkF40X5i2kK45+9J410TUSEoEJzRrQtSqcksUsROz3tokhon?=
 =?us-ascii?Q?aXlvAfkAWYcsHFeJCEhpKbb8koZ862qa95+9qxkq+dlZWtGEydghIHEKYi2Z?=
 =?us-ascii?Q?zYoGwbzOXkN8KPhAECYYclXPB0Q+aLl9Rs6Lof4O2tV172VJtCr61s7dgBHM?=
 =?us-ascii?Q?L0gwmIZcleBOLqdOUOEMIktE7J7Vvtcx9eLwSrwbB8xrq+UDtGtSWOvy314X?=
 =?us-ascii?Q?hCsTD1tNQThjoSirwJ2Iy3BgL4QBdYUxCCZZ23gMp2rdQurFmyohk6JQve2h?=
 =?us-ascii?Q?lsiopg7/bNcxqZiytv3lzHzz1pEUltjraGhyAMx+TY/+k3mWQYNoLMX+hdmC?=
 =?us-ascii?Q?ah2CqijE17guBGMBFrYc8S0R2wn8lyzq/zFiu0cfVBvOt0e43Z6iNVXsqLLB?=
 =?us-ascii?Q?p88UpWaHGof2VRfafYAYnw7U2vO1tiMKJcsUA9j6xcZLqSuh/4QFPK7hG6q0?=
 =?us-ascii?Q?/0pvuaDvRnXkHX6N/E0Jy5SsUoeCvVg+HiE7+Nt9TpS4m0v6jQr1KiBe7kxA?=
 =?us-ascii?Q?vEmgQCorjiaX/5j3u2F+9faechhs4XpPlaByM5EHD++auyx+tff8K6it/VmK?=
 =?us-ascii?Q?gFclUFuuogS/r+5kBiup1X79AcqkmmVU3KznWQ0fOqcu2X29DGCLFRkjqmgu?=
 =?us-ascii?Q?hIBMtU7hKi5/ZTiqrRXVVcwirgfR57fYqDT3K6FwkilqkgbrVDlTVxkTNeI5?=
 =?us-ascii?Q?AazivkB6ps2abNnj83s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3589e7c-1afa-4335-873a-08dcb67147e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:23.4831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdeDDktDWrvWPnHt26bMyIeyZouJX57Npozku0AL1kJ7ZUR7OKKtZ+iQs/HRBJZF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

HW with CANWBS is always cache coherent and ignores PCI No Snoop requests
as well. This meets the requirement for IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
so let's return it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 35 +++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
 2 files changed, 36 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7fe1e27d11586c..998c01f4b3d2ee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2253,6 +2253,9 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	case IOMMU_CAP_CACHE_COHERENCY:
 		/* Assume that a coherent TCU implies coherent TBUs */
 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
+		return dev_iommu_fwspec_get(dev)->flags &
+		       IOMMU_FWSPEC_PCI_RC_CANWBS;
 	case IOMMU_CAP_NOEXEC:
 	case IOMMU_CAP_DEFERRED_FLUSH:
 		return true;
@@ -2263,6 +2266,28 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
+static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
+	unsigned long flags;
+	bool ret = false;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (!(dev_iommu_fwspec_get(master_domain->master->dev)->flags &
+		      IOMMU_FWSPEC_PCI_RC_CANWBS))
+			goto out;
+	}
+
+	smmu_domain->enforce_cache_coherency = true;
+	ret = true;
+out:
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	return ret;
+}
+
 struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2693,6 +2718,15 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * one of them.
 		 */
 		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (smmu_domain->enforce_cache_coherency &&
+		    !(dev_iommu_fwspec_get(master->dev)->flags &
+		      IOMMU_FWSPEC_PCI_RC_CANWBS)) {
+			kfree(master_domain);
+			spin_unlock_irqrestore(&smmu_domain->devices_lock,
+					       flags);
+			return -EINVAL;
+		}
+
 		if (state->ats_enabled)
 			atomic_inc(&smmu_domain->nr_ats_masters);
 		list_add(&master_domain->devices_elm, &smmu_domain->devices);
@@ -3450,6 +3484,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.enforce_cache_coherency = arm_smmu_enforce_cache_coherency,
 		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7e8d2f36faebf3..79e1c7a9a218f9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -787,6 +787,7 @@ struct arm_smmu_domain {
 	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
+	u8				enforce_cache_coherency;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.46.0


