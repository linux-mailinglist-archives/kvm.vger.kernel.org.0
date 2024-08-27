Return-Path: <kvm+bounces-25183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 758C8961358
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AC9D1C22E6E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104611CFEBA;
	Tue, 27 Aug 2024 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dGy3tQDc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEF71C9446;
	Tue, 27 Aug 2024 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773920; cv=fail; b=Rj5gIgFePmnrrkNOohxTsFs7W/ftKSR3cM0eLZ9t8N4++2IGroOrcWfDBVrMLmT1At6AM7dzFscuxNrWi76oaE1MQc/ZNJKYyUvLVtpXzPMWjXlNd477rzTi7LdlKlF5OZl6RzIOJEsE9Zxir41Yt7bWyqRxb3r9x1Z/WMWIBZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773920; c=relaxed/simple;
	bh=MF/khwL0nYiPRs9CasA+VdkJRC8nWlv1Y3lZTBslSCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G8Ql2TA5zAXjTtibj7myGCdXapdrTh/1b73Up1s68Z0N0lahFBhOXsmp5/x6KCMgLnr1dezURsV88W2557pBjzuV+YIPIrvG3j+nBkw54k2DnBjFt1Ad2ZeizHsQ4bF6vhhKe2Z32YSGSlP1G28IBlUevrUtkFnLmwYArLn1dgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dGy3tQDc; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWgbnSEfqf2ZlsTsoYQx4B129x5SGcXqbmZEAmKZZ/hwo0RCwwUDLBgovc3nAkyNWecpfT4FB4Kyw69QgswW6YahdcGKuaPqmtXefRKPFdlMPIv5SIKtqha0IMJUU6G0ajEaUoaarVdhYJeHexH40ycb/fPQydhGBld4RAn/mBU3IG8MfeMjTOxf/TGX5T4o1Pu7RgBxFZ3tV2FwpXbT2HJwJ9LSeGarQgQLwMOrI4AIhyUz4ki/9bAnGpPvvvPAaGQ3kI4ZefpAxm3eFgmwhjEUUGD5tMY3PoIhZ6l5tR0YiQ94U1fwE3LCIwX+qgZEyOgYrzayzL3zzSsnX8+YrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRUyuzV0hhDxGQJiQHZpwajgRGE/E6DK8zboc2gejXc=;
 b=gbeeVFh1a6sqCRi8tcQPFD94vJVpJI+Wb4/62xveVzz1EGVGLK/4zg8LFGLHTSoDdeFbE2CiYC3G5My5TD6uMNf3YP3Z7Imf2TsX7QnG25rIpuI70jYArZ1tcantTusOHaFLyr9O8tIl3U+c2KcobPmzs5B87e+mNgFZUdkfY+TqcuyHg+aamE5wWzsB31gXYB0lOA+ZmDIxG8vebcX/Bid5ICWbtQVBVConW6d552DEOxpx85fYw1XHi8jHiSggtPrHpgmInuw3vPU4IB84UgZTFkuBZxFj/cOWYqMlEQmuedWMjY4HGgIXmKGgKKi0dNubJJrg7mU/ijagM6Zd/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRUyuzV0hhDxGQJiQHZpwajgRGE/E6DK8zboc2gejXc=;
 b=dGy3tQDcB1dskk3RkVxNeCIg87qbELzSCHn0x6R2FUoCxDXuGOc3Fa+PpeUfr/ER0F/J5uPSNu36YuV9d387l53wI893UeVBkx11hV7u7CA5cEE5VnLhKaHNEt2Dgniv1JxZ5OJb5K4AC3Pyg6IMeAl1fUOpSPdHtDnyFETGPkoCLwN4lntPhxBWPrLkLNmmcnwptqMXjWL+f6mu9W6DLLkQyc5tVP7XLxTnBUKOPt69L9tX3BV+HyiG0Niuv8NzWEMxeqJ4ELwwjx1pJDBp5sWnX88PcN4eArIIaWXsU4/x+7WruqEaMf9eOCVPXFCicAVR/VvtsiDctIhMLE+ZBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:45 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:45 +0000
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
Subject: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Date: Tue, 27 Aug 2024 12:51:32 -0300
Message-ID: <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::34) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: ff8b5b8f-d858-480e-e780-08dcc6b023fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QUAwtOXYLjV0c1Uy525qzDqNwsshyPmPJDfxVoWRmhnbk6qeUoH24u9F4RCo?=
 =?us-ascii?Q?8he/miUw78DNgQjB9c+ZLy3WbUi4t+xtIpSz2TJ3pK2QPITnmrjyliQ5ToXh?=
 =?us-ascii?Q?ANyGTSrHWkOmGgl6MUXZxUEJkn75qLLXYMVHx8PjNbsllysKnluHEMjxcumq?=
 =?us-ascii?Q?vaNN9J6cgkusxlEoNXsD8H20DPzGHxTO4nYGjpUkKmxiEVqOxqXttdDnls9n?=
 =?us-ascii?Q?R95ZsGpEc8jNUvy2lqrDjgkQyqOwq1S6agJe61XXalMON4/ZOd92HBRGKk8U?=
 =?us-ascii?Q?Hj7AmvP7olIcQiBTPazdz2BT9K/+Gkoy3GoBg57aQrTJWUjDgU5buYV+blmC?=
 =?us-ascii?Q?HY6oLrFxH3GX80RO4r4d8X52GzgAgnBQzNYDfCs4qH/SL9lNRrPI7G/c24Up?=
 =?us-ascii?Q?Xgq3txXlgVf+Z/vDOFfYwgHZQ3ClhNplkKjvanpBtkAYo6c0Y7YVt00xuk50?=
 =?us-ascii?Q?cwu5fMt3OxNq/5ajyPmta2ZY7yK0vdNpof4+0IjDcw4QZa3Yi48uqaIrWtEC?=
 =?us-ascii?Q?Lm4zYXR7GV/l9ujrGKPA81Uus9w094AXQgtgo6GqXTH4w0u/A62ZAKIo5jN9?=
 =?us-ascii?Q?E9g8OVF+T/49S5fR3QskxkESK71BD6ebJORUvb1hnVZCr0BTdcQgOzne814y?=
 =?us-ascii?Q?QbuFaZXYHX0FqtAIxEP5lS05xY7D7cNYm/6kMDOVArWjVSddDSNefHD6zNAx?=
 =?us-ascii?Q?j7ppsXIRg/5axWI34bEAKMmVvP8wt9tel8qGfykB5tM02K6PkCwjOW9sGKiw?=
 =?us-ascii?Q?0MAMCPETQSstBUxj2rLszuJK9OuCWw+2wPl2AMTXdn5QcqQ14z/0DBliENUv?=
 =?us-ascii?Q?b4k1uDdE6VEf+7yl1uK6Rs2QxtYuzh2Mz9sNYu8YDVXhuinJLb1c58xornSg?=
 =?us-ascii?Q?NpaZpgndeWiAQbNkrZv6c9C4AR1yMZqd7y5kszu+5OLgCIfSZN8BlTe9Tn6z?=
 =?us-ascii?Q?VNakC7pFmMliRTw79gEDrkmPQtOwGrvUYcUF4FHbKv3uLhzdjQrEnDyJ3iQm?=
 =?us-ascii?Q?GH8m93b8rlZMvbHLbxT2JKbNyK4f7MQu20AITb84t8eqMp+1lkP8fPMDDC19?=
 =?us-ascii?Q?SEd9bWE/yfV93gOGxQISrK3p+7dECVHGlrmvSsbRPQbpJdk6Ahs9rp+CfjrX?=
 =?us-ascii?Q?yE+R6/qvWYjcbMscZXClm9u2tNscrp+PmofCcm+IfHo6DqjiVHB2oVjGez3e?=
 =?us-ascii?Q?wnU5lzkRZ7KglRI+KZE71WXku/pjzH6CLfBQ7Pye9QzrpnShhohj40YIbsgv?=
 =?us-ascii?Q?jta/bmWI564ijvxZZwWlHmGJKyQQYq56EqK/mPatAn1pfGPi2H1BrHsYTHs2?=
 =?us-ascii?Q?RT1vJJ6iMHbOE8f0USSUMuxwrJHsV920OQRUvsTwbv5B17i1y5syZrZQFeKM?=
 =?us-ascii?Q?ufGTyBKUEbroXj3IYYrfQxQnM1yj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lN2bytnekIgEu3q8wDbRVBZQyUH5pfrfHn23qkOejmrUKe6ZlSCGPxgWI+0A?=
 =?us-ascii?Q?cbClP8spkpDCoE5HDA1xgSU2QG0xij4/SDefPKMeHZzrtsva1uEsuGQeRkNL?=
 =?us-ascii?Q?tiMExpGSej1E4mrqQ583XC3w2ABzS9rxcYHvInc11jvrdMK+q1pFeSaOor4J?=
 =?us-ascii?Q?xyEi5Mfnb7eAsucXxekvEWVIQGxRczW+DUdKFtRS91evY3+TdTnpEHUeMQVA?=
 =?us-ascii?Q?Q2SADUVrqHOvX2WrpjsY+CVpV/mWeCqv/WNAIoVDBg+vyXRhCDgkhTQTsOXb?=
 =?us-ascii?Q?xaBNfSig3Wym197FNIfzbzx0TEfWYNB08X2DP/2zaBYIFXBNWEAMnJQQZhIP?=
 =?us-ascii?Q?35lw+nSZeQJ3dqDE7uvNec/xRjOLCaU3DhcrJZnqdNuk1kHFSUi4I7mTziCb?=
 =?us-ascii?Q?4SUzlwyn8EQ97hwJR7vonOnHtHh4pjGs51KQJBBwYoaCex047tGOBUCsF18q?=
 =?us-ascii?Q?H+xPv8x5RjehnyUWCWsw7gxI4lEwEYth0aV7rnPMBa97EV5Becq8kxc/i8lJ?=
 =?us-ascii?Q?aU6TpzJDAl+WCCe4WtUxMrg7BiatZ5TRmbu0VUUiolBExmE5OcYNvGF4zzti?=
 =?us-ascii?Q?TXv/R47xsaQOB00o3aX4JEWOaOci/M4x3XGLDhCgRYHwuCBEB29EXRor2Z8n?=
 =?us-ascii?Q?os7lxdn0SEL8XvyqfDQSM6toG5kJNxi0r6gBxO/PC0TxfmZlgx9R1WsoxKDr?=
 =?us-ascii?Q?NhuKGLd6X37FE5WOrIL0NMmFyc+axOyHrxWaSMp2/y+4K+s1ywOiVrpiQ8oG?=
 =?us-ascii?Q?eNqimvZYb7KH5z7YMth3ZijngQn8l+9+hKbTz/+OTNhZN5uaSErtbdPCaSNh?=
 =?us-ascii?Q?cRxdyKRO9UNwQQcOgfxpoDVPh6yQaqLfYVc9DBF6yWoPGgTL9BK5D1u3SqV8?=
 =?us-ascii?Q?YC7zGsHq4ETtlzrORRbmSNPzz5KBWCc8K9vtI+olU7CWIin1AtQeB/IOhJ2m?=
 =?us-ascii?Q?i7lQ5PdbAGsdVue24PyNZoV07GL5I673hQS/yYUY0yY10yWTEtpA8D0OZznx?=
 =?us-ascii?Q?rpR8o7KN5Gumu5+phgMdehxp9pkVD7mNMy4psU+LPgip0n8QmBLm34lkZU1a?=
 =?us-ascii?Q?Sm0pSKcgQq2oVdE4cxh+sIdRr5hLSLrm0d3xXd1sTo8eXrHO/iSLdFhZUPSl?=
 =?us-ascii?Q?/F1aUI+ccQvuTPp1NdFrEsNjEWie6JuWgdDeSCWk/Tw1q2GEWoA0kf6q6r+r?=
 =?us-ascii?Q?Eg1MVaRRvjkWockrMv1HdTrpyDLsNYjzudagdpcD1AXvHRjZYnVjVgFzUeBI?=
 =?us-ascii?Q?xyJgGbHIw7cwoWwj4+mwRkEAULwcKCwJRkdSJ/o2/PnfwDtke6cnJRGTHDE0?=
 =?us-ascii?Q?vGW4p3K/ZpoqRod5wuNnzbgawAHZCZZFh0OwO4/RMNQ0Zx4OcRI1Qf18p8Cj?=
 =?us-ascii?Q?+vuf19+H69pKxubYKaOzpkkEbBi+AxcRBJysTBokwEDfVWIoIg2ZEIUbyGHe?=
 =?us-ascii?Q?FkdJ9vZBaCr5w4iO1R6c3qlJQlPB2SWrLr/967RY5fnbBJV//FDTWurSjgEd?=
 =?us-ascii?Q?bYUKR+pQqWOfEHIIvIgOe82l2bUJRoR6wcs4OcewntK+5XEwuYyeOKWlV8go?=
 =?us-ascii?Q?Uik3XdJP+AJURvolqmSGqMut4sA31aUciOwlTwOD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff8b5b8f-d858-480e-e780-08dcc6b023fd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:40.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y4fWn0Si0w994NAoYaDZ/S/IfMQfqmfY0+AHtSo12aTzl5Ft3dHDbFvK07ltpOVJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
works. When S2FWB is supported and enabled the IOPTE will force cachable
access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
access otherwise.

When using a single stage of translation, a simple S2 domain, it doesn't
change anything as it is just a different encoding for the exsting mapping
of the IOMMU protection flags to cachability attributes.

However, when used with a nested S1, FWB has the effect of preventing the
guest from choosing a MemAttr in it's S1 that would cause ordinary DMA to
bypass the cache. Consistent with KVM we wish to deny the guest the
ability to become incoherent with cached memory the hypervisor believes is
cachable so we don't have to flush it.

Turn on S2FWB whenever the SMMU supports it and use it for all S2
mappings.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 +++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
 drivers/iommu/io-pgtable-arm.c              | 27 +++++++++++++++++----
 include/linux/io-pgtable.h                  |  2 ++
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 531125f231b662..e2b97ad6d74b03 100644
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
@@ -4189,6 +4193,13 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	/* IDR3 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	/*
+	 * If for some reason the HW does not support DMA coherency then using
+	 * S2FWB won't work. This will also disable nesting support.
+	 */
+	if (FIELD_GET(IDR3_FWB, reg) &&
+	    (smmu->features & ARM_SMMU_FEAT_COHERENCY))
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
index f5d9fd1f45bf49..9b3658aae21005 100644
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
@@ -932,7 +948,8 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
 			    IO_PGTABLE_QUIRK_ARM_TTBR1 |
 			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA |
-			    IO_PGTABLE_QUIRK_ARM_HD))
+			    IO_PGTABLE_QUIRK_ARM_HD |
+			    IO_PGTABLE_QUIRK_ARM_S2FWB))
 		return NULL;
 
 	data = arm_lpae_alloc_pgtable(cfg);
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


