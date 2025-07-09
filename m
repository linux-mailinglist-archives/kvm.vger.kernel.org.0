Return-Path: <kvm+bounces-51962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB693AFECAB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED5763A42CA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC872E88AC;
	Wed,  9 Jul 2025 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BW0v34d/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0787D2E7F1E;
	Wed,  9 Jul 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072749; cv=fail; b=FJewMSDyCm2sgvCZgiRCCXZmKK+vzHW9BFtDNVhNTDGC/wT5HmUufbeo2sqhURcVlBW2IBaXSasT5omnRGIDjc0jtWfgg7hXJwrtBIret/e1MZfb+j/KFfsJJgkor3P9nVz82T4Ha+wH0egxheVajP+mGZAyEeKYM48y3aaLWhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072749; c=relaxed/simple;
	bh=O3aa86fb5l4Xk2Px4AuFdvu1sVSdqnGMleS6u2izTYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rZNsp2djKJzZAYuOoUSRX3JTAsoIdFuYNenZgnqy89qHgDRTU+iYTFff9pB+AUSxKqpSbaAuIguBQpLNuOGzmMc6wvXxfzzVDOembV3SG63MdQKhoH0yntJJ78ixfKVYt8/xvZFD8PRHLHJYkPCTE4fKwFCKEK1R0whuJ878PCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BW0v34d/; arc=fail smtp.client-ip=40.107.102.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o469qBcdiBzH6Z/PSgWwmZ1zo8N82BYHvhXGy10FpUMtfxnpXbAEGhMAp7sbwlhtdGw7/IXFewrahjj7HtZwTX6IPqrG2/nkwWUjjKcrxQEAxtBS4EqwQJ0oUW6dkbmIiNAGmZncIJA4l4H7Eg/MR7ataumtZI435/CwXBTCNqBEvt3JTY/WTI5/Y1FTs7kF4a1KPNI1noMcOni9iYnPZ6QOBWFnIEVEkwYlLwJ6r1GQ0H0e81eKeAhuJrMBgZ8gBIwprhuHHAFh+2D9R+tBpK/cr4+jD2DsXodAgu0oed2nysXZoaQm3ixDL+qG5ZTI/L+JtOGkjzam39hlqpvICg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JivbMSbberz4blU3/i0UyOH9zdzPncHP4PAM/cq03Zg=;
 b=hhVNDAmhUYttJZwLScrgElvx0KpyIQEdIAQYygNeUMNNXoaa2/YegEdu2Iqdby5y4o3fiqoqFup5026imCk5PPrZEfS+D5Exd1D0ccwgukLKPR1XNHEcFEPqBS1XXRyAxzP2+t7Du9M/hqZNepl0GTDp0WSg2FzoYz++durSybAZKuWwZd1mu69tYbUdTBlaGg5+kvnO50dK32axtNDgYOtZmO5PgLFTv/3WeY6YchJK9zjbHmHeArQ8LAqGub46pELhQM5UthiPexQ6zj8tsW3blgq2Mi6LHPvdruMB7mlfE2HTDpjaSiwRvgrFhyQwLUdgkr9GfzLMPp470EopHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JivbMSbberz4blU3/i0UyOH9zdzPncHP4PAM/cq03Zg=;
 b=BW0v34d/lpzsmb/UweQQlKSTYBCfX0E/UNuQRX1daXb3SR7Hh/r6UoIVo/bdJxfOwjsAkZ6jncNQH+s9LfYKUCNXTHz7NIuDmHnr4Rcqsp9xcbLyzvclToTxKv7BfTEmC3XkPEn2m7ybwbek3oQ/zNxEQpsgDLG98rDOuz7LxJzMPrHSAuqVrkYeS4+x7BczxkFVvIuA3kv69by6LuTSR+bjlS47Uiz99LWPVpCjEUZfhwqAD2yhQrZ5qRYZwUu5+K0VH/x835CTWvzsEqp7jXP+u23cLk58tDXgXihAhUhM1LyMHhSTN6rwn7taHX+jiYynwfQZXquXQIh++dyTeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:25 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v2 08/16] PCI: Use pci_acs_ctrl_isolated() for pci_quirk_al_acs()
Date: Wed,  9 Jul 2025 11:52:11 -0300
Message-ID: <8-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0168.namprd13.prod.outlook.com
 (2603:10b6:806:28::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8aeb87-98f0-456e-8913-08ddbef836db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OBmdTBh5juannXhO4MPMEF+AQeUlzu6p3/IsQEUp/SBgKmROv9srMGurB5iG?=
 =?us-ascii?Q?1pjdJK1LMGXEREr1F0dv6m7wkswQa8wTK1Zr66oS3njOHxizTRxvFqdm4B43?=
 =?us-ascii?Q?G4BoPMqzBOGEWk3xG9cu4EX+ZruWp+U7X3e8K4OLlErhPJKXWtt1DA1XbyAr?=
 =?us-ascii?Q?AXc7nSKtucIX7Q5FdB0Z97NJQaGiIPOtoHoa+bSLFTSaNE9hiyd6ignMxV+Z?=
 =?us-ascii?Q?ftyjoL2PltfEi+r3RFzRG5mxd+M/ZTZ8p+NVVLGbqD0BOXCR0+q3CCZLd8m/?=
 =?us-ascii?Q?nQ3mXADz2I79/2Y1+9X4sRN+w45WtMbCWBHvDO17TyGG+N91X4qfOYgA8JMY?=
 =?us-ascii?Q?I2rVnSvDwNybmmt1elpgWL4ev4dV6ah9QzNKrsTqF/DW2zGIJ5+HYseXwtJJ?=
 =?us-ascii?Q?43xqy7Ec6U3Pf6hnB4nn0G0mmM1gjlJOOSSeiZTKBxo4655bclomGuV36b7N?=
 =?us-ascii?Q?8Pm85KPPZtd9nSO8NcLGv50vV9g2lS9HJpzn033KfaYMNZ4hyjpcZq8G73Fw?=
 =?us-ascii?Q?ovDgeaC59aItNW57DKPYmHhqSQau9hBTaqy32QiwHVBYfjFjEqSzEMMfuBtO?=
 =?us-ascii?Q?svFvAE/fMeh9KnoStcUluHcGMzMZZb5JN3bExG3YrxDYWGfLA1g6lQX2q8Zf?=
 =?us-ascii?Q?vC3Ob8mOCB1HhzdASczvNcReHWYuAh4Pn3SXcCfmPkv1bl/zoT9TCjnotzMW?=
 =?us-ascii?Q?MZ3ms3K7BqmSaF/sm3jy8MvUnnv3SA3UPjN70tBa6Ctn+h+aMQ+dOOPZPfpk?=
 =?us-ascii?Q?miU9UunpbpP/iWTYmtezqejfCobwrF1dIXhuWoFVQdHA2Zn+tPwQhVZWZ0b6?=
 =?us-ascii?Q?8W+kiPCQdhYkgaMp5amrqXrXfVGv/3nGlVm74ZAWwRSlvoy0HeUMyFN8ibzm?=
 =?us-ascii?Q?uHOmKfoNbaj8bFFzrK/AkKknYzgFE1fIGEt6wZxIq7sWcdaQ9aBzzjeTB67R?=
 =?us-ascii?Q?jdez341JIF5YqmM4Q5lWBlCmPq/BWHQ++vvAjrcuxlLIoUUcByeGxGuPfTpr?=
 =?us-ascii?Q?qZTg5TH8C9kipvShVTwgNy2qytL6rXAllxCICGNUM6GfvUAFskKJzv6vUhdk?=
 =?us-ascii?Q?CNc6Qg5IrbMTjhpZAcRuZjf9BW97yegr5M5iLGBD+igpyrK6TC30ljHU67B4?=
 =?us-ascii?Q?5frGYY2F6+H0U9CNj3SX5To0YR5d/TVTjh60z8UKVV16dLOrwSUM0UaHujZU?=
 =?us-ascii?Q?c3GRkaY+n4JKXb1tHR872+U/aeQtoYSBPAjQ7r3mWVvDXLpzzdtxfewGS4G1?=
 =?us-ascii?Q?fr3k7Hb3fl4lLfDtucVyxNEolBYIitlwD3RTC8BtYORHdDB12nkDqen1AmOE?=
 =?us-ascii?Q?hBUVV2QMwI7bn6zFxrZ6Ml6ZSKpGh/xxFqy0Fv5Fx2jax/mOymMi0TQzXwd+?=
 =?us-ascii?Q?ZUEDOgywW6zG4LA739sykuFA02Xr8CLDqWWDYsQfHuWqfaJS+HgXlDJxGoAo?=
 =?us-ascii?Q?r6OJTpKsRAU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s4VX4bl7K8OQOlSGRCD8/Kvb1AtYCQi6KpiC+kVjKTNMGU7n2xWh8fCkrf8d?=
 =?us-ascii?Q?xkpYefbDdHQrT2DG2HoVrSoOyFP5hTrQqjcq3r4pzME3XlOz3P7VLmSkNbnY?=
 =?us-ascii?Q?YbykV2vKE5Qvfu3rWi/Id5HXjbvb63/9n715nR+PRTY3Z1UANJKJBvcQxURh?=
 =?us-ascii?Q?4foA/+yDuUm9zgUmZREijpVtcw2Tu/gyhlB7Mrg12tSe31DB57BJgWGXSlMO?=
 =?us-ascii?Q?/4Q+neZcqNEfSkL/VDwVe3Ojo0ZRscLnQD3eO6WKeGnSB5kKtSipIeyRGgAr?=
 =?us-ascii?Q?8dwk3Z9Y2U2yW3QQvI79xTbnkjsZ2Gl6A2nQbzAztQQonhssOLRJ8+r4dEi0?=
 =?us-ascii?Q?OP6vJp+ULyfjDIEKNCeU0wL2lYIBHSuCJJEQbtgvVjwRDAZTLF7gZ2VeYIuj?=
 =?us-ascii?Q?1LjskmIdGZZJtFMLp/1fh3qKV3AGHYB58KUOwM88Xgutxvdo0T2u2Cw9DnmS?=
 =?us-ascii?Q?/ynyxXhqdOAgsr6n14C6T5NCIIrjn4P6FX+myPod0eCCmnEUmqPzrt9pzDCs?=
 =?us-ascii?Q?DEJRu017rFnjDlaNvukLeV+Pdz6nj42a7NdBALWRFCqCy3abmhKe3BWJOrVa?=
 =?us-ascii?Q?XGrZLe9z0aMNgLykrBxnzsbT5tAqWnRT8h7YlAsL5XhcYRhksruD0gwjFqNc?=
 =?us-ascii?Q?Ad86Cqo/rDG1LDQy8oNahQmNuaQtX9/k6TAlvfJizI66yTN8SkjAAJqSGUiS?=
 =?us-ascii?Q?YcLaKC4ufwg2a+pK049oDnYw5pv6c7ss0KaUet+AmUvzA88EPPuwZaAsFWfx?=
 =?us-ascii?Q?XHl4Gc/jRdNDIJUgCK2DFKq+xMFXKgwqRxqNN4HnaCUKX4MfbYOH1vO1ssRB?=
 =?us-ascii?Q?lrupyisDHlLgEWYX/FtG224ukUXcIUfc6Icvyuyo8ySnydicMB5+w9cDYEcu?=
 =?us-ascii?Q?q1vZr2bDi0iXn3qEDmHwJBJ9W1ZOCgXaybPvVVVrF023R7uwtLi/ykQNW/A6?=
 =?us-ascii?Q?XWmuhdvqSIrdM7XfGX9c7dRmxh9GiHDYedrq1M4oCsUHarv1C8X8lbwW9G3J?=
 =?us-ascii?Q?u4VQz6Ihasbj0pKgcJO5/7497ePnuwVycGALoECbz256RXjCIbQOE/RKamOn?=
 =?us-ascii?Q?z9KXhOk2sHRXneMerG1LE8y9r6KCgvWApNoWG7DrT5LPSd9iWrqCFj+6RQg9?=
 =?us-ascii?Q?dek27IznRMTtbPqrkwLatnSOizj+E4hP9NTh2TvCmKu/aLlFh0Bovg1Rrsbs?=
 =?us-ascii?Q?6ogogSFc1TQ3JgElLUX2n07l+U4Ja3S8WAXOmJMTKsylvCXV//VwUQSN5Mqv?=
 =?us-ascii?Q?/H/RL07S82MozAA5HpBYWPLKD9c4ETNE18X2EJKdGbJQ009Y/LfCcT0i4O4M?=
 =?us-ascii?Q?5FCPazEEORrWZ6o1l5RbaPOXfWjp+cUsl4gNpksOwTSmZ+644M+n5rcvvqSx?=
 =?us-ascii?Q?xvDqdxfBNe3FW8dXoAhqAB6d/+m5+wFjinqiNl+CkwDbycfXbWdSSVsQ1uyW?=
 =?us-ascii?Q?ERLoTdDsgup03ZQDDw9A7pfXwY7p7INsUq04XU5vtWRFUlBKQGDIq+8plWt7?=
 =?us-ascii?Q?9JKA9JaYuVX3eCQ4bI+robrk/oG0mgwb8WxLNYZnNOXcnWM707SJda4taitM?=
 =?us-ascii?Q?bszXu918PyBnjtubyCLdH2ZXFE7UlL7vR66oAlSZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8aeb87-98f0-456e-8913-08ddbef836db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:24.0497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0e4/qt9BPPe1UeVDzMtyPN1grWAQaSCgiLYSlFoESUirt8mE7GCKxp2AD/aAac9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

This is the same logic.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/quirks.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 963074286cc2a9..d78876b4a2b106 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4860,9 +4860,7 @@ static int pci_quirk_al_acs(struct pci_dev *dev, u16 acs_flags)
 	 *
 	 * Additionally, the root ports cannot send traffic to each other.
 	 */
-	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
-
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 /*
-- 
2.43.0


