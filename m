Return-Path: <kvm+bounces-30130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 189B29B710E
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D07B1F21B80
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6ADA927;
	Thu, 31 Oct 2024 00:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kJm7pgk2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6908A46447;
	Thu, 31 Oct 2024 00:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334079; cv=fail; b=Mg+m7AR26dxXkVGl4BxEopzWkvGgiwLM3bfyMAZzCBdbgQyJfUtgUwtsrxGszUmlIPWW8gHAExVtlaGbMd/FTSt5Hndo+tauVB7TfAAFtSPMpOqkBXZ91LSIuRz2C/MyG5mQf2rGLSghXjF7IA0wAGZQZ7Iit9fMFoq0kMwrkZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334079; c=relaxed/simple;
	bh=b45dqg2zOqYmyA46ZI5C9fsNB04f49SoXT1iQJhBdLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T0/PzL/sAgX+uBwvPWKbSBU5+Bx6ktflgCIFXAMdQcPzVXR3h61bp+VS5RNtYoAOQiZANJkDzRX/Z+rLXQp9ttBiaNvjzmyKK9HEE6ILntm28K5Ah0Lgt7s352t5BjHpDrBmKVDBPxsnIZe2FI4PmX3/XITzxPIdgEhXAN0Dl6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kJm7pgk2; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRQo4d/qFhmEi+2SAPqcHV+bk44LHS2nnNVGaaOeYCSeVEk+d29rXZUkIDB+VWrlbMrV5IDWfub4I982CQ3+jFEQ3VqZl+Ql6bPRClBdxaIebgK9h5HjRjYmWtpEV668S1xu23QfTJdL28ByItqFs68N7FI/XYNImOkAKCWM2AyKulNwNLKytgJahKTRmatwu2yVAXjK0u8mZRT5r4yTr9HNBmbK4eqZ5XRcLkzezwLT/LOdWVArAPdGD/MtZKJEwt6SqUChQqJLolKK2tpF/BdObMU3Su6j9yrYQMY/SekocwbiEkRiELArkAKjF8HdqKrZsyF907qEywlHYOUrkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFBHc35420GEetXyhz/HM/yXoL6p9esLeDRZqs4HPGs=;
 b=IYE73KnuA4oUp5i4RE+ksbkTuHshxXTHZdIkKIQp/OH0X9q1X7VqXJaQYDTA7AYXqRhIJtmei3cwykEOhX3LmYKUjZJjUTxZW5gkJRU7/xCajFy/ulFBODVI6IWaP6IxMkxCJhjD8IqoOffV9TpzYcVNP18SMvgyMqCNdhD5FdLuAaF3MkkUuYDLa0LNBqYEEicxMgPMMN3h00DDKsDfoUS7TL4aFixAGTzah1EZNp2uuC+AqVJCgXADCXqM4opVIw45iGfY1ubOc9p2YnNl46Nqpo4sABLmBNZoxBterh7e3wjXvcKzCJGFx0P6aDU33ylymarYGOYVYxYu+cp9dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFBHc35420GEetXyhz/HM/yXoL6p9esLeDRZqs4HPGs=;
 b=kJm7pgk2dU+8cvtG9x9rfZrC+Km9Qq/jbT0nVvtWdJNP95Akvrmc96aa2iRqoR+4UeOsrh6qdpequl6oinAb4S1all17LoJ4FGBkGQQ9Bm5w93IRs2uc0V/k2BJ7tYNvpVfhHFHRfooLsQVxgpwvAhr400wBcRuTLFhwm5dv8gEWYuGCqG+e8aaWcrBFanaTizEMkS3lcJerRosSY5RvsRB31Ssz4Tkh3lGor+DEnUJ1b0ARfbrTCd8HqBEHQO1vh5PCaxFmzPE8AC0ygLQCDAHjMg6SoI0b1l22m5Fo7IxPAv62vw30xV73dbEisdlenKDxAB927bPMGUZk6HMcxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:21:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:21:00 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
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
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 03/12] ACPI/IORT: Support CANWBS memory access flag
Date: Wed, 30 Oct 2024 21:20:47 -0300
Message-ID: <3-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:208:23a::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 278c9aac-bf48-4243-0e66-08dcf941e47b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lhU2olADq6NJJoMf2jeIHn+vheTA4RAtPIcp3EnOR3+tCPtNduyjHT5E/eTx?=
 =?us-ascii?Q?rTbEPUG3Sa3azrNvj7+d9CKbG6MPodmC5ZhX2WvnSZFPMZefOtcLi08dOu2Q?=
 =?us-ascii?Q?If+Ww7Ov4JeRkcpq+sixkaUheOOaW1LZPXLC5oclVLD1d7GpSs+k6KSc1KA+?=
 =?us-ascii?Q?r8ImOLEvgr6Wi2JK/eInFiHuvwjzHE1p9M7stJ6cXXJQQUYlfIoeML1yjHKz?=
 =?us-ascii?Q?dM6xDLRRtK20hvXK+NzyCztVFwpmaK9kmfkKDn6A7yjKR8pcBKx03MOuz/xM?=
 =?us-ascii?Q?0DXJBx9BtIUYXo2d5KXufz8Hg16V1GMEuvaWCuSysTEIEi/nBTv0PnMfik/d?=
 =?us-ascii?Q?lSJrynJiST7o4JdzjmuVuhyBvfxVi2FiveAebl8BQwyWTVpOn1cRoZNk8vNW?=
 =?us-ascii?Q?OVVxnNKGSH7icbpzfBo47EvuWf9ND9P7RAT+/q1wvjwdHZ5b40hl5iUrr9iR?=
 =?us-ascii?Q?8axyQqTOUuc3OjtoaG3Oj9ExLuxdlhsUUfdqclf5bsCY1H2pj0pt47SGjnaq?=
 =?us-ascii?Q?lBDMXDml5Z0OM4xO52Qo1UodhOl/cNFOTy1QkoUgEGb4cKi3EgBevocBJOMx?=
 =?us-ascii?Q?O+9/8I9Gft6L0E4cJU3RLt3qdNvX0QrnMozhuwR2ZlkaRsddLNnWdl0zLLUM?=
 =?us-ascii?Q?TndLxeJfJJycGI4F1PJeclX2LFMhKODKyaAxMlXB3+C59YxmSFROmiMOQTT4?=
 =?us-ascii?Q?HLguKYBByqUiumBEWkTlz79CUIxHXgXfoWSQuDRJL9lVoGnh2MZdigOyVicV?=
 =?us-ascii?Q?Li2vhvr9OWTffSYLEcdjVVZWann5DQgeZ6ss5m8u3H2OwQCjHNb+sUEXfpDp?=
 =?us-ascii?Q?A4MTI7J1/nnXdAavquFjQBxDigIyCA2Jq/x51sW4b2SzoMVOC9yoBcjLhREA?=
 =?us-ascii?Q?Py3YFqYq90bf5QAfW5iuI4RsXu/fOqfWKkrLq3qCGFaNUE9O23eLc0YvoDWp?=
 =?us-ascii?Q?oLmsxG1AkMKlWE0yveqD80B1lrBhYO191LuGM2ndtOTKgy7EwlFz9sqU6M/Z?=
 =?us-ascii?Q?VqcyqsUnpagH8Egtjxabm08XsCDS+7gXrOtTgxsGqwUUkEz/niNgCXaQ0caC?=
 =?us-ascii?Q?Devq58twk0dnjDJhr6UDHuY2KEnXfShO0sFTYJOOTR5mu8zKjKTZwk5/+r4V?=
 =?us-ascii?Q?nL1I9ut3lYI4C8K95t83o9o42U3yDJtzABTPC+3fuuO6BlHIv02jT1g3oiDp?=
 =?us-ascii?Q?W/1XuBnegc4qsuMDiqAaC4fWP0XO6l3DVosrScSRUe1qXc7lAuHKb/lzntde?=
 =?us-ascii?Q?ZYSHAeoAwF6kb3ryTIAds5HXoFjh06sX2zCCsuDOcjWyGSyRgizQAhp1A1cr?=
 =?us-ascii?Q?/ruSSglEHSzdGXMNulGBgqzUbNsZCQ4q4d0Rwt4ia0HbdmsjHgeH3xrDAcHN?=
 =?us-ascii?Q?HuLIIlA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wyDWCrYBRAEqfkjOx6ba+a8GZjVxnqV6By0Rrqf9L0L+lwxtQONo8WwCZ7MZ?=
 =?us-ascii?Q?ppQJfhQEuanp/1hmWQqddn9xxo6hEHRYUg0ZX6DHiA7Y1kUFuduSU1C+eZq6?=
 =?us-ascii?Q?rFx2IRzU586eqRe5i7JjoJBS3S17mzA//Zr02xNMcnSQvZ6vRdNgy/NIQc60?=
 =?us-ascii?Q?h2Z7xrRpqCoknVRMbSUYPK9RtuKleGdG8PbzDGx3XgG6Qm5R2UJ/40y6h0/Y?=
 =?us-ascii?Q?pkTosWuqon5vT9Y/rExK9/EUvFa/ZZClXu/3I2TOlAvCCzRnbBeBvN50CK3O?=
 =?us-ascii?Q?SfhaHI+ZBMxzVTo2NsNbVk8A03AQWRWkn60VpcWpqeZfbNgdwrLnO03bVZvd?=
 =?us-ascii?Q?1Sq5rk4wja9LgWNWxX/5Q9Oak7ryUTH/Eiz+oE854ZSBJTRKEzQJsGxBiHpQ?=
 =?us-ascii?Q?4fZeX4vEzOo2bq2GwmitvGwRjyLa9ZXPQIr628cO6BiPnBnK+Y0t1cC/9jih?=
 =?us-ascii?Q?MazrYy8aHsk9jYypUpy/Wj4muy13FjRVY/VZnUwE8W/NiSYSPTzPHvHag2fW?=
 =?us-ascii?Q?FsukcPrWrWfFusaMrWanHFtW0T9slTsTAo4ekaV+eiq55b7WQnQjHmp2y6u+?=
 =?us-ascii?Q?VV+FsuUaekmvdG4fYt52Wj5EiouQW0H7/l4Trnam8wXfA/a4TtE6P10fuV3V?=
 =?us-ascii?Q?verRO9kDw+NCpHxep0T3rhufpylU3GwLYX10ecvHvYAQbVUfrowuFYcUQCRp?=
 =?us-ascii?Q?pmyt4VrIBijBVxb8ydHpL1uLFFAwm7UtiVwvHMSsLeUMSuHSYleOxSaEMTuS?=
 =?us-ascii?Q?Z+DTJy8wb7QPrEECZzPdeZ+ZXKxf3zTuTGZDWpB7z68J/LmDAkbgotlGcNtG?=
 =?us-ascii?Q?/VseUsqxbadZEcXeRj97ch1IEFYWr+Hk4i10w3MLfC4QuZaNPCYDlt83FXsV?=
 =?us-ascii?Q?KJiHFX/48TfW9SvJvUkIAW554UbGqh+oLOW6CEX5iK4kF5alV/C35I5NTRXs?=
 =?us-ascii?Q?2HYAyvpXD54z7n19gefLLWghbb9VYHkx0CWKssn8dvfCXLdgYQyP5kqV/i0i?=
 =?us-ascii?Q?r3QJpffpKY5jNeNR0XZaeDoSmNHcMf8THP7skQElUMEekPHxKrPII3uW55mL?=
 =?us-ascii?Q?HQ/aY8Ymn3m4lmq43hqhzJHTMr60lqczuYIFOlCh+7ydl0E88iu0t4EANdJj?=
 =?us-ascii?Q?g2m7zBYuS5h94lubG4gSDtJ7OcSISDDgDJ1nhqm9eB526CGTZXQSmolfLp/c?=
 =?us-ascii?Q?6UpJzV4RBo4b5gQi5wSxP4kEnSS+hGKJPYPgkBy3sXNIAyXYQuf2CWkLapHk?=
 =?us-ascii?Q?WGn0sZ0VdzuBvOHuafifyaLF6M3wH+Po6vmSYbzI2iNnHwb11s44sRwSHygu?=
 =?us-ascii?Q?38Bq3V8JlOJObEy2ZBwghVUFteSrKpZ+dPlPc05HFtS/FzvEO/AbN6tQrN+b?=
 =?us-ascii?Q?gPEzlyB6zDS8DejG/ftilaERdkj+YI4Y8zsJF5Wm4KaOGU5kjvXuruW8lh6f?=
 =?us-ascii?Q?U3Z6Pe3FSo4+FgKglBq0lsVp6y8b9cfMogPcLIpPIx48bV5XlfK06X0/l73v?=
 =?us-ascii?Q?v50FuNEawHdXEQoDFpAcYi8yzIToM5nZGKkvJb3tNIhdq7asZLqracwLumxB?=
 =?us-ascii?Q?Q5j9R8bav+fGKttSJa4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 278c9aac-bf48-4243-0e66-08dcf941e47b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:58.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUfCSLMcdbXTVA7Jkpr/GqxE7Dv1+/uqO3tezf0AtWkMlkGOEojhyENVjosHFWiq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

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

Architecturally ARM has expected that VFIO would disable No Snoop through
PCI Config space, if this is done then the two would have the same
protections.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/acpi/arm64/iort.c | 13 +++++++++++++
 include/linux/iommu.h     |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 4c745a26226b27..1f7e4c691d9ee3 100644
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
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 099d8aa292c25d..8b02adbd14f74c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1051,6 +1051,8 @@ struct iommu_fwspec {
 
 /* ATS is supported */
 #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
+/* CANWBS is supported */
+#define IOMMU_FWSPEC_PCI_RC_CANWBS		(1 << 1)
 
 /*
  * An iommu attach handle represents a relationship between an iommu domain
-- 
2.43.0


