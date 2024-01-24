Return-Path: <kvm+bounces-6862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0254383B270
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6870D1F25539
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 19:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A0A1339A2;
	Wed, 24 Jan 2024 19:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tBk+ko3J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAE8133987;
	Wed, 24 Jan 2024 19:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706125354; cv=fail; b=KEV1I4gEm4lo2c0Bn3p8a+9z8ICOGCvXCJ8OJyaErRPSSVgXrwWHrIXk/G1Gka0X6SiaprerdRUDu462U4Zl3Q5Wo4mgFFOnPfQDZN+La9sQyQ/mJ81LAWuMgShMJPq6kY+sOOUeEGxf1Q3kLqjVBavex0x1I1U9VITus6TB1rI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706125354; c=relaxed/simple;
	bh=g3vf8S7oOBi7U3MWKlTY98ksUPO/RfCCoGlI1SVjD2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MrJhPjNyZua51Sh7555bUYuhcBHsTSpZE7ItV8uOsDjbSue86h15VIiXJrJhScyY6/+WzzXNWcNeEk52TofoKWyx2fBKn0pOjWeeLMxsGgUpBtndc6t8MDfAfnXMC7pMEaBttghfyk9TgM1YK4nz/+8OOh4tSucFYd373Z+mWtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tBk+ko3J; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvQNPSV64NcBFR2rgsKOq4saMI36u7vhMCNBZhfl0S4fMOOA27hlm4jnnlyqmXyTISeIM6Hw//uqcRCT6SPf/5LQ5KWKC2nURYHPxoPwCZtqIzyx1MXFhsMMtLyF/fLa5NggcZl9/LUmovUXvcItX9/WaMpXKmMCTFCXiluA72nKHGFqq3D/zZ4PS8w2fZA4LfQ5DUiC1U7iIEJ57O2rXdr4aCrijDLRcw5DRWdm/Q6AwQKFl7C+OzsdqlN4goUQffHZL6NSNhT1iO3FrV0FFdg5s4dnSU1NGWevXw/OguPKxVjmQFyeEa5abgrCX9GDy8aV8oDgUoQQu+/t9wbyvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjo6KhKjNTPm9BnXkCKLj5yznWa/F87athREYKbfE+I=;
 b=IBpk8lNI3gcJOhK0wW6gewIXkLsQAjh35PR6gYopay/IW5QOBWv1FcgIp2bgSz6fURPjmHJ2NIBBtRpXEkINHH8Yz6CsCZyPrTZrOfQu1HUaL6Ds3SGvQW9bU6QfgxzP1hyGzdY1iE0Yxqb4T2x2I0rtbfSPkyruufVJ3KrH0PIxy9N8k028VrO3MQnZwIJ4IuRbfw/+pgoEO0ocMlDBO1DXH0oSoGASJPPi+HZzkzb+W0A2VnBX4tbUuZGIrMnLYIRa69vZOYBf2ri1rz6+y9cqwfOIuGfuTTTUJiG8N95Vw9K2eOcCNkUlQN01pETd6CTdeOWf0ohrb3tBqK5MFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjo6KhKjNTPm9BnXkCKLj5yznWa/F87athREYKbfE+I=;
 b=tBk+ko3J1cowEEOjQzXYmmCPJ/f/tilQ1ZDxsr/zTidB1tOuA0r2Q+pfYfRJ+icbWrKE6lF1tE6qeXlSHASk0/E+Qg4FUuDfusu2BeVtBUFI/tkU14BDIht0mG5tcMKRV8X3Cmm8wWqouYgc951A90EIvA/iT+XFS9U6ky1PmMZwlCmWEIhv/liQj0CbGRJAab9UxbnVhr2f4BGqWzX6fF38hACVOBO2SmGaIaSZbeOW9Qh2OYZrS+/dhT4zVNq4fkBrNZEqBdJ9w+An2O55Z1Xou8eua5PnXHuIqHnUvE/Ukm4TiK4LblaW/KYmcvrFG08ZzFjewBWZDWvmB1h9Iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5388.namprd12.prod.outlook.com (2603:10b6:610:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Wed, 24 Jan
 2024 19:42:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Wed, 24 Jan 2024
 19:42:29 +0000
Date: Wed, 24 Jan 2024 15:42:27 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>, Kevin Tian <kevin.tian@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.01.24 - Memtypes for non-coherent
 DMA
Message-ID: <20240124194227.GK1455070@nvidia.com>
References: <20240124182444.2598714-1-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124182444.2598714-1-seanjc@google.com>
X-ClientProxiedBy: SN7PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:806:f2::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5388:EE_
X-MS-Office365-Filtering-Correlation-Id: c248c0ef-09d5-417a-7a8c-08dc1d1499ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hBwLWvBD8ae3CUJaDHtYcHizvVIpef/bx3UbIQhHNjzoYx4BoXoQ9fCZYOa5a+EtV1xrCoRXhbpGFKDkq67PQiBIKfRbRyq3oY2zNJDKVcoj71j91nxOBqOharfwXYQyHkWlNsgAxupi1t6BWI1bGBcjNQb2RqbswzvQDvfdjfzRI1ud4nQnT8rsK7fEBfIt4xvfnMVcDhhM1UrT1lcpwOsGYtpNSieiffbPxryHtUoz0W+gjX03nCDZR627iee6iX0GzQj+rZb+2m5vhZtWNiM50kMhuzTtOHwATJ/Vf4JQ20pQsvVNi3k6vXA4h+isqabhemcSDArj0vpxVGnwJMkfSj574B8KTHgcr6rVwPQgLoahyewzF5BZDjTsWL0UhsTKeT2JfH6gPukTzJaoZ85srPkN83sho/9ghrLJL+oCMxhfk2q2dc1uELU9kvIRrAHuUd5UQZq8HzvqXrelco+ON2Sd4uCgn3zz+Do3N3BANU8liteywMUo0329X37yU6jMykQYTFTpx8Lh+AD1yuNfP6P8YT/mplZ5hIBjMQlx/Old/ucUkQJUscbw7m8V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(136003)(396003)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(83380400001)(86362001)(36756003)(33656002)(38100700002)(1076003)(478600001)(26005)(2616005)(6512007)(66556008)(66476007)(6506007)(2906002)(54906003)(66946007)(316002)(6916009)(4326008)(8936002)(8676002)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rSvRDxqwTo8NgMLe4BOOcmNKoIyMsqY6hOHzm+wXAvzQ82APPy5Kd/pccmIW?=
 =?us-ascii?Q?o5ws9mtG70p0RyDUHQDkXXrAmZEHAF0xCSNOaBB7wqVGE/DgeCUtpcepaPYq?=
 =?us-ascii?Q?DsmfRZJW6WWq1ULpVp7E4Xu6jvYhwzYyW+Eayy4SURvp+nJz4ZoGnUo7X2e1?=
 =?us-ascii?Q?ueSIc9K6ReYhNHaBGwo1xCJdGvjGtfZCmZkY/tEwBktpqBY80IuSbsuNS78E?=
 =?us-ascii?Q?VUdAoFuU/zE3PSrfRM5FKblBDFBkNwBGd6sDzX0XUtpk5skYoAY8BzoScMem?=
 =?us-ascii?Q?NLR3oULYa44vlOOYF4n8RESggTvEIwX8N7fBnfbIyo0qEUaOnJbPdWGToB7x?=
 =?us-ascii?Q?vnNnAiY5P68rKkbJbeLCjXEbPzADDp9QD/dcYv0MyPrMEJd4XXlFolHt0BI8?=
 =?us-ascii?Q?fGocEaVjrFAY8pezoGnzJtOXdgM1g2638pa131WXkfqoqL0WzbeiSrr4ERuc?=
 =?us-ascii?Q?CysBebDC6X7v8TDO2D47g0B1ZMBmfPaEnHCHKq0TCwNoDHz3SpAhGj2tagVX?=
 =?us-ascii?Q?a2tAUV3HRjBJmvm+y7ZZxEUNUuS8z/CnmWMU0TeanQxK8DXhFmvyzST0xh9L?=
 =?us-ascii?Q?5Dl1d5mcpR9AgGHwTJyKoCHShQ+clcgXWYNb2ljOMZHn7/Oz9ojOFXA7XxGb?=
 =?us-ascii?Q?BwUb7iXOI2R8u7UVLoRJuoTghhk3MHVmxYpCJoqDHSHNx0QMQVzshPu3K5IT?=
 =?us-ascii?Q?g/dp+lHvCU6xhOckM7lMFdS95zxB9TAmZE1T+o3gvDhfmIN4sdQ4acHGPS6T?=
 =?us-ascii?Q?QEOngGvoKeeCbstaJdtXro+6gvUrRXX2R4zETr5HgvvA+GStcKCJfuPqrBFi?=
 =?us-ascii?Q?kQK4BBxfoyIdOfsYGhFb9bCejhxsS0NC/y1GbCHEwUDC/Yf+5kkM3mxwPBda?=
 =?us-ascii?Q?8bEEcL+bzWUFYlmkytMQ2KVNM5P2+EmC6WLRYtlPyl85C78flczRB3Bseugb?=
 =?us-ascii?Q?ttc3s2xSW0+Tafw+lWGc0c60NfoUbIZSPNNNJ6qu1VPRNtSpkmX6HovPiDmg?=
 =?us-ascii?Q?+Kb41PYV5rBdbJ4RMqN57wyNOhd6iB5wr0RZsdunfuWbOBDtobR1Bqlvy+RU?=
 =?us-ascii?Q?AKXSQ2qWOKYBRl4cSV3B+mZFCBIPfknMB+CgvFVuINgFwut7u7rdcP2Y62dR?=
 =?us-ascii?Q?pd+j6R6sW7z5f8uy+7GDRalJSSTeAHd6yvVZYyBPBfdryGVdNU3sUYg93E9i?=
 =?us-ascii?Q?n0alyWg+pdf7LuWe0V+3MRS9g/dk4wfzwy6kFXJncC1opyHC+YuFmPrcpQfS?=
 =?us-ascii?Q?IBZgcw4eE0lsWt6axS1cWWpxPw3F+y6Js3K2FQflxtNs6gVzLKqdBhwZf648?=
 =?us-ascii?Q?lXeyw+FA9kQpyU69VXfOKfxGo2x14mGxzGLRTpU0PIOyxsLDeSOLjRBS0mbW?=
 =?us-ascii?Q?t/BU+xQX5UqV65V2cFXOjKqrUGcoHpyBdY5Deauf0OlTlu09Mgz849TLkoQo?=
 =?us-ascii?Q?TIjcq16S65qs9IIrUaVQo8ObOxSZYvEMPkMkzI6FYZi8DdTWfmf84OJuOxP2?=
 =?us-ascii?Q?lqHFiVPzi2RKO9ILRU3bP3U0JQBsDjnMVwyfroMNNRSr7ybGjODbry77Rf1M?=
 =?us-ascii?Q?3eJ/cgozfnFHDBMS3FCqRzSQvOZkswDl6GxC+bIJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c248c0ef-09d5-417a-7a8c-08dc1d1499ac
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2024 19:42:29.5615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnqtflLlQqVHpVW3qgLYGhgJCJL+bIQiyrctoUXIVsWs6ab2wIOl+pd7WCCYtlJw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5388

On Wed, Jan 24, 2024 at 10:24:44AM -0800, Sean Christopherson wrote:

>  - ARM's architecture doesn't guarantee coherency for mismatched memtypes, so
>    KVM still needs to figure out a solution for ARM, and possibly RISC-V as
>    well.  But for CPU<->CPU access, KVM guarantees host safety, just not
>    functional correctness for the guest, i.e. finding a solution can likely be
>    deferred until a use case comes along.

Regarding the side discussion on ARM DMA coherency enforcement..

Reading the docs more fully, SMMU has no analog to the Intel/AMD
per-page "ignore no snoop" functionality. The driver does the correct
things at the IOMMU API level to indicate this.

Various things say SMMU should map PCIe No Snoop to Normal-iNC-oNC-OSH
on the output transaction.

ARM docs recommend that the VMM clear the "No Snoop Enable" in the PCI
endpoint config space if they want to block No Snoop. I guess this
works for everything and is something we should think about
generically in VFIO to better support iommu drivers that lack
IOMMU_CAP_ENFORCE_CACHE_COHERENCY.

ARM KVM probably needs to do something with
kvm_arch_register_noncoherent_dma() to understand that the VM can
still make the cache incoherent even if FWB is set.

Relatedly the SMMU nested translation design is similar to KVM where
the S1 can contribute memory attributes. The STE.S2FWB behaves
similarly to the KVM where it prevents the S1 from overriding
cachable in the S2.

The nested patches are still to be posted but the current draft does
not set S2FWB, I will get that fixed.

We may have another vfio/iommufd/smmu issue where non-RAM pages are
mapped into the SMMU with IOMMU_CACHABLE, unclear when this would be
practically important but it seems wrong.

Jason

