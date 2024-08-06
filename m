Return-Path: <kvm+bounces-23453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FE7949C6C
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFF21282525
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D3317839A;
	Tue,  6 Aug 2024 23:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LvL3VrSV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD3176FCF;
	Tue,  6 Aug 2024 23:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987695; cv=fail; b=dxgQSCcOAklQZsOJrvsfIZWD31d7zMG7YepvvfgUYRyXEirOjT+EiZYQiag+Lo5AKcSHl9QD1SrTNVgHHJq4KBs1/xjkrRwO8bVPNNz/bkmhMR1fnnDUanse9wHy1WYupYVouDx/clLXgRsbA+TH2b5YDGtj5ahfEo/xd6TFVgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987695; c=relaxed/simple;
	bh=oQaY+EPLzslVInjkbOh+giJdSCdyPkYjSsJu8ItK4dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YGUTff1Vm0MFuZGmwU0S08qs2KKBxa3ulzHcrAEdvm65JAEpZhpnQ999OifDPEsS0gizyEFoLUbh9H29WdnKE6W66S0rANPHhgPvRU6RdTlCcsHgkM8JsQyVxLZKdmPH11+HXBFtjTkTT3892lT/J/xyvRrrtFMSRC2exrXckEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LvL3VrSV; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACte1z2oFb9Xm0ikvUAEOpa70fGCBzs0okGB93kIRUzVmvgSK2UEJUufdc9/KodxOHNXWM70AkX4Qz72dPki+EEv66cbu66JfQ9emb5/vUzdKUvlD+obW2gbNhXctLMVJrF4UFL2ytyuNquiWbFfPQ+P0LmBij85ZXjPvEBSzhwmQx/jDirxnAZCJRECWbfCCYvVm5IHjGyE7ZzZsL5/T0OLP2Ta9LMdczNUSK73xNYJptqnMuZg27bQGOZnuFZ61kQoMGC+XVFD76429U26MgPwj+gsO12UxAMzD7MnchIfwEPHCkJiy+sGh/uX+vcdeq/7eDja/FtaVIIMPI4S2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPiWfsDFtArTBCmfh/ouk56R0Z9znkLPRHaGoddn0Co=;
 b=m1SgV+JdZLwwaKt97gxyKraIj9lWnl5WuCxVyvSTTMjmxryCTVuvrEP4VPQTTG3k3SJyZT3eeb7RrTSOOK+kuQd52s0RUZe9oFR4F05CwUVqyXY6QOEm+1jPiBku9kDqDkM0XCvR/9McHKbCIdtf6kp7dh5GGhl4pRqK9ty+wmkK5R+/yDQp53IMPO7DomT6zhFE1mgvWSgOu5CiLBU7nwoJ8F3yv8bCalNx/qwmQh42JrsnGNk8HM58CSxhFJ5BG6YJxhSbfDkbJMZLs57sCnNLinm/B0bLofxBsQQGH42a0olDaFOlFxlhSgBGMVnwmFNsVFuZRX+9Ja4ZV2gZFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPiWfsDFtArTBCmfh/ouk56R0Z9znkLPRHaGoddn0Co=;
 b=LvL3VrSVubPUnTmqHMh6fkvDAFQ3CCwL+3W2B86ZeqA/1qtrhM3YCNyv8dGYyfNvjIttqt8V2ftj6bsBUKW14p8BsaWU/yByPbcbA/kRkLaEMPCL3pJsWXo7gM/ueKHYtqy7z+7rTTDj21SJPG4rW/AclnJhwBKE+rkhLUNCvySs3OT6y0QG5QhIzjlc470yOPCWPwyXYDZzrvDQ18P6V7G5pXPX1hPdCbnniALPgyK0trV+SR4ctJLpWXjd0YvqMtklz0ilw0DgVGRhcwaHoHaGwhzdCUrv8JbLciaHtkWCY62SdRj92tOloFtikqVZ6bjAK7Hf+gwdnuZhu+6HOA==
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
Subject: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Date: Tue,  6 Aug 2024 20:41:15 -0300
Message-ID: <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0963.namprd03.prod.outlook.com
 (2603:10b6:408:109::8) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: c7f87cf6-49ce-4112-c9d1-08dcb6714805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K2VtNQxin51f4CNT7yfYmq3iKd/EWXIH11hgE8pSMQAEZHO8C7q031yZjLDB?=
 =?us-ascii?Q?TRvzU01P22rleSS/+Q/V6kr8GkxtEsfOTK/7JKzEzwrfi4QNkRVOLHXvlh2/?=
 =?us-ascii?Q?S8zsUCTQotufSEv6gF3Huthkv4Xs49nq0cvi6nfSRYeUNnC7CtHBfOhoeGnq?=
 =?us-ascii?Q?5wxuYj5g5YAyJRhhPII1h2qoWIOWuqy1KdpN7D72PN/faeEh5rGRXPCLaZzE?=
 =?us-ascii?Q?9sV8K0tv+9NPx0ydyLmYF6tEPdv38TU86mKr91N+V0eWhoCVeu31R0iPX7ES?=
 =?us-ascii?Q?VlrWaJS8CS2vsLMXe1UH2wEwE4QdaoNMjOtp7YeNJ9lsHkiEtJjjumoYJi61?=
 =?us-ascii?Q?4EJzDJYs5pcOOJKDjp3ekdfXHVPw5/A+6jSfvZ0ZVvadJ2nKGZQfNsSK1urP?=
 =?us-ascii?Q?ydRLDhJ8WbxKDR1KMMoeC3F9FwpDX5c2KFkkvuI8Oy38VlXVAslqm5iCUuN8?=
 =?us-ascii?Q?BI9u3H3M9FfyTMW4medai28w8l/zpT6LFBKIeRgK8R+5uptR43RTKHFQgVMu?=
 =?us-ascii?Q?qpujW3zAmhbKCuN87iXJ5L4A1tAx9YtZUGGu67XfzUBfKd752z4BrmhkZAyN?=
 =?us-ascii?Q?oj0jO6pS0r6J8G4gz4v61RcAOS8lDW2BqUmG1Aax4Y6tgi50lm4dJGC/PKe+?=
 =?us-ascii?Q?DL0mjc0wcW8WqytT2SezydPfUtYkomBvTMrhGC54j7WvYn9wrGTGc3uAQtC0?=
 =?us-ascii?Q?4sxxnCzJUPVvdqm8v4J/fcTk5RymdWgooAIjkdjXWsOedAqyCT9vQbbg1JcR?=
 =?us-ascii?Q?9kDU1O6FHzprZ6c4zOyV8gjqOIEcwxEz0qNymcVDRVIxUcGSltbWRq0pBHZX?=
 =?us-ascii?Q?daS4IVRTmzkoXQae+NTo5oGNzykD5Bt7MWGBMfl7V/gtOV5ZY0pJIdS+wu9R?=
 =?us-ascii?Q?fBYsq3Bfmi1quZ5sWD0HqwvDmjR517zpQxSQs0v+dU/ZZts9fDO/I2f3MS4B?=
 =?us-ascii?Q?c7PsxaMuIoCAoWVnHmZ2TxHjgypr7Vus6mlSEGpyM9F3rVwW9HuGXfkxGFE2?=
 =?us-ascii?Q?3mYQMaf0XHOtgDGn/J8RaM1MHj+INOOshGhdwxJgNeh3TItgLzNUPeSHnak8?=
 =?us-ascii?Q?iujkyWLl7aVrOc/Bxu0g0txkGRDi0UT0i3gW3NOHsj0Aa6+KE9XM5d31sEuT?=
 =?us-ascii?Q?UphU97fMUJgPWElHVmbWszBQPlWOSfezfqYfk5IwwKMpI2NlwPHh6wi8jZ1t?=
 =?us-ascii?Q?+G4BcolGVuOTLvU5NwpvDxxOxrW63bAx9WPW1gkiq8Z0pdc61OlCjxNBPjwo?=
 =?us-ascii?Q?/JRxeq0iQ7GzGu+y1HjUEHTcAFtTuy8j9n3N87t9XFsrad/IfU+A58KcUp+J?=
 =?us-ascii?Q?xm2q7m/gm7VtRczhC2q2L6QXjaPDujVbeGvxfx6FkVqfFgCkuwvjwv56W3NG?=
 =?us-ascii?Q?cleAr9ygTPFtS0cS7yDsdzp0T7ZV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OHd4GTyzuRu9NSj6V9nLT6JIEvNmDIx6iCZOHsUm3M2Oqy4JdBjIDix6asMr?=
 =?us-ascii?Q?BstRk/eLiVkfgp63obblQdCts+M07EujlPcOsyycgBaO9Ia2mxnpB8kkMaDm?=
 =?us-ascii?Q?bJPSx8yV+W3fqAPyWJfAxPgpGPNDeA0z0jtnecXUqfVuyohoPZKtv25oea+v?=
 =?us-ascii?Q?G/3ch3WFDMDBCpYx7qJecAloIluwuAxur4KkDHx6x6O6LJTT7xT/nm8NMFLs?=
 =?us-ascii?Q?xX/ArZWMA1vaaK6LkRfsFB/wb5aDyTO9i1QCcZGAGHZPjq8SqcZ4KOx40znv?=
 =?us-ascii?Q?1OSsa/0sYkzPOksgPXlJmJCC4WtTCAW6OdQHUjqZZfOKOd4eH8LmuIS7Ih99?=
 =?us-ascii?Q?7mTUBQSnZOVN6wi5pV1k+kokCnFKqJlz2n+CAbKfC18zgOYkKEt9HBmoFHjO?=
 =?us-ascii?Q?VX083WHEiRVZ2ZiVlvFAW4AiMArnnJAJ0scBptCHa2nARgfeS73qRGlcwSCi?=
 =?us-ascii?Q?FiQqxrVbGupbl6FWNFp2jfzLOCbc8gbT26lUxBIPGKgxZhESO0Uk3tWNHjWL?=
 =?us-ascii?Q?wICI5epRhuGj00bOz3PFXSZvgbDz2dsqkiz7e/Kj2VxDDrc31yzL5kbOdE2e?=
 =?us-ascii?Q?4SmgVuiSPtyy7XOIK3o+ABLGhTYzloqbAlyQnzERWKW++j9si0Yj6arUEnRT?=
 =?us-ascii?Q?oEv3sBEe/iSkqC5t5/JhkCjaQJ/Ac3n82cJjZdGmxA0O0Yh/zgTqNSPeWFT3?=
 =?us-ascii?Q?I7O/T7fTMWRZ9q6S5SemHgzK9EdXyDMRhWtTZmWIHg2fPYhSaOC3tiYYONCW?=
 =?us-ascii?Q?GJphgiuhCcRjXrDWhiSomuE1Y7nA2ASR7NKJl4b53hICHSVB5xjgsdQWE+3r?=
 =?us-ascii?Q?EEI14P2eQZbvveZ+ZKmk9UdyLpebWB5XtwMEWCdOFEVMQVCZ3jkRddSgPR7c?=
 =?us-ascii?Q?dqRCPkGWTQ/J84cJYkYnBhpIDDc3OdmY6EZqj8la7lf9RNlrCaMUT5uR5P4Y?=
 =?us-ascii?Q?IMIyqcq2x7OGZOsS6nGbAxhrdeN/7f+l7ZECPiXdhrrM1DtpdAkMvpLfIeDL?=
 =?us-ascii?Q?ocJpUuWWR9FtNBYxc3N4bQKtAPjiUuSKgnFZ+9lsokNQ8w6i89qp3jrdc3/l?=
 =?us-ascii?Q?7HdAVxdrf73Vpy6fICThqYWldu895o1xOPEAB2LvZiDWbnv0EPmKMvPCiJOG?=
 =?us-ascii?Q?bl+CS04il+2NBxOFbbmbwAOZszGTW8jmpqVXqUEa4XBClaqf/wdLVhm3l1LE?=
 =?us-ascii?Q?8r6zHwIqxmsozHOt7VUBNgS89sQs45Qkw741YctFrWMUuwz0aL1fTbEr43jN?=
 =?us-ascii?Q?ofTUD9qBNnGcFhh7dhY0Y2PoK03Ofg1GJXGhL4s6tawvrwqOgSZpkgttAlHT?=
 =?us-ascii?Q?9e87QWrigHbUs5kQlQofkdyRJSeCOrmkZ3kcGYBu90Bjo3xq9WRYQKVAjxNU?=
 =?us-ascii?Q?RiidH0DiKfW9Qavj4OZtmcRKVZszwN5BCVCqPN6EWa5bcqLadcD3Na9GlfK1?=
 =?us-ascii?Q?MtuUufbA93elG62iJGdodk+4dRDw9hP9ZkB9/P6udXntjZEPFuo4XTRxDOpO?=
 =?us-ascii?Q?+AhmAlCTXnYDxWW0TB0eY1YzVBj5jQTSjezalvuvJDiCpZyOMZxxl7V1syO0?=
 =?us-ascii?Q?fZ10jwJFH9p+iYunkYs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f87cf6-49ce-4112-c9d1-08dcb6714805
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:23.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTyxZXN8JaUNLL4z5d4KB2ciglny4F/AaXveDZARfZc9U7M0ozzKTT+kI9eONqdK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
works. When S2FWB is supported and enabled the IOPTE will force cachable
access to IOMMU_CACHE memory and deny cachable access otherwise.

This is not especially meaningful for simple S2 domains, it apparently
doesn't even force PCI no-snoop access to be coherent.

However, when used with a nested S1, FWB has the effect of preventing the
guest from choosing a MemAttr that would cause ordinary DMA to bypass the
cache. Consistent with KVM we wish to deny the guest the ability to become
incoherent with cached memory the hypervisor believes is cachable so we
don't have to flush it.

Turn on S2FWB whenever the SMMU supports it and use it for all S2
mappings.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 ++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
 drivers/iommu/io-pgtable-arm.c              | 24 +++++++++++++++++----
 include/linux/io-pgtable.h                  |  2 ++
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 531125f231b662..7fe1e27d11586c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1612,6 +1612,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if (smmu->features & ARM_SMMU_FEAT_S2FWB)
+		target->data[1] |= cpu_to_le64(STRTAB_STE_1_S2FWB);
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 							  STRTAB_STE_1_SHCFG_INCOMING));
@@ -2400,6 +2402,8 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		pgtbl_cfg.oas = smmu->oas;
 		fmt = ARM_64_LPAE_S2;
 		finalise_stage_fn = arm_smmu_domain_finalise_s2;
+		if (smmu->features & ARM_SMMU_FEAT_S2FWB)
+			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
 		break;
 	default:
 		return -EINVAL;
@@ -4189,6 +4193,8 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	/* IDR3 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	if (FIELD_GET(IDR3_FWB, reg))
+		smmu->features |= ARM_SMMU_FEAT_S2FWB;
 	if (FIELD_GET(IDR3_RIL, reg))
 		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8851a7abb5f0f3..7e8d2f36faebf3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -55,6 +55,7 @@
 #define IDR1_SIDSIZE			GENMASK(5, 0)
 
 #define ARM_SMMU_IDR3			0xc
+#define IDR3_FWB			(1 << 8)
 #define IDR3_RIL			(1 << 10)
 
 #define ARM_SMMU_IDR5			0x14
@@ -258,6 +259,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
 
 #define STRTAB_STE_1_S1STALLD		(1UL << 27)
+#define STRTAB_STE_1_S2FWB		(1UL << 25)
 
 #define STRTAB_STE_1_EATS		GENMASK_ULL(29, 28)
 #define STRTAB_STE_1_EATS_ABT		0UL
@@ -700,6 +702,7 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_ATTR_TYPES_OVR	(1 << 20)
 #define ARM_SMMU_FEAT_HA		(1 << 21)
 #define ARM_SMMU_FEAT_HD		(1 << 22)
+#define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index f5d9fd1f45bf49..62bbb6037e1686 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -106,6 +106,18 @@
 #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
 #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
 #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
+/*
+ * For !FWB these code to:
+ *  1111 = Normal outer write back cachable / Inner Write Back Cachable
+ *         Permit S1 to override
+ *  0101 = Normal Non-cachable / Inner Non-cachable
+ *  0001 = Device / Device-nGnRE
+ * For S2FWB these code:
+ *  0110 Force Normal Write Back
+ *  0101 Normal* is forced Normal-NC, Device unchanged
+ *  0001 Force Device-nGnRE
+ */
+#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
 #define ARM_LPAE_PTE_MEMATTR_OIWB	(((arm_lpae_iopte)0xf) << 2)
 #define ARM_LPAE_PTE_MEMATTR_NC		(((arm_lpae_iopte)0x5) << 2)
 #define ARM_LPAE_PTE_MEMATTR_DEV	(((arm_lpae_iopte)0x1) << 2)
@@ -458,12 +470,16 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
 	 */
 	if (data->iop.fmt == ARM_64_LPAE_S2 ||
 	    data->iop.fmt == ARM_32_LPAE_S2) {
-		if (prot & IOMMU_MMIO)
+		if (prot & IOMMU_MMIO) {
 			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
-		else if (prot & IOMMU_CACHE)
-			pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
-		else
+		} else if (prot & IOMMU_CACHE) {
+			if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+				pte |= ARM_LPAE_PTE_MEMATTR_FWB_WB;
+			else
+				pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
+		} else {
 			pte |= ARM_LPAE_PTE_MEMATTR_NC;
+		}
 	} else {
 		if (prot & IOMMU_MMIO)
 			pte |= (ARM_LPAE_MAIR_ATTR_IDX_DEV
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index f9a81761bfceda..aff9b020b6dcc7 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -87,6 +87,7 @@ struct io_pgtable_cfg {
 	 *	attributes set in the TCR for a non-coherent page-table walker.
 	 *
 	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking in stage 1 pagetable.
+	 * IO_PGTABLE_QUIRK_ARM_S2FWB: Use the FWB format for the MemAttrs bits
 	 */
 	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
 	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
@@ -95,6 +96,7 @@ struct io_pgtable_cfg {
 	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
 	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
 	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
+	#define IO_PGTABLE_QUIRK_ARM_S2FWB		BIT(8)
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
-- 
2.46.0


