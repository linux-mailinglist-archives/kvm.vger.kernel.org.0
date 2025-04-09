Return-Path: <kvm+bounces-43018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB31FA82BA4
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 18:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6F91445185
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 15:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDCD269CF8;
	Wed,  9 Apr 2025 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="quyMsuRK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AAC264633
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 15:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744213845; cv=fail; b=kExCuxcm7IUAazwGzXCVqEGeXtMSfftTBJCX68WwMMeSzUbLOBOcz7tSCR+dvPfy5v14C39GUznykR/jqunjiunMXaF9NzCZ2u60Gp4lwndLGiif74Xi8hJdsumempzuFDIdlLsR8ekXQdbTQ+PZffwffsTq9dfNWKpygTz8EP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744213845; c=relaxed/simple;
	bh=Tig75+6AxyqJWYI/AZ3LsiWUIMlHKnka0XT1YWOA30c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YzgfEddjmDShjFT7rdxdVXrzvaKHkwC62V1uPLESpmIQvzTSonwsrQ29sMK81eiYzOywE47hiibxqSKNNFvqHXZJ9xAEM1XwsSyL9gJBbh98IYMMm5Z/IGJxNdyCii4GqNud07sU8B3mWrcf/igmvUpV6v0Bszy5jIVznMriaiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=quyMsuRK; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7g8Vv5i+e98MbkIfXGwoKFmoV3ZJdl0pkkPGCbvZ+C1/L6o+QvKDdp7tJ5b1ma3ISK56yYrslKGgyVoji3F2aWNe/CygQyTCSp9xJ8zdZmUdqV/Q3k6K+6ww+5qBF1n5cx0mm1z3ctuU5qZhQBiM28S81jA90+MBWsn39lCBi/XvVdUC/m61TMC4aFcVM5NsHQQgiKxVl143bDw9+hetVWgJl35I6sbKyF150vp+YhWupguTtvBC6x+HTAe8CvB5kirDPqcMz8GAxXodxYfSx5hw3BgnsTdtNSbqcLw0QO4dQ6ExX4KuQMlR5w0udRRYv2f73OdhbQ+acC5RSzu0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txv8PHLqEVr9szOFwtNyYX/2L2ErHF4Wi1K1AyAflVU=;
 b=UnPd9ICQB7BVgZ/BK6XpVYjUNRSj8Xq4AMzhZGyWuNeHZBtOpcQFpjW5CRBy2fbrq1apmDh+BOz3vsyPf2q28bv0irmTvmDKvrp7gcXpJGAjHv6cE3HIh9To5S55OhLp94w5AmftEl4oBs/OIc8AfCI2zG8dYGN/zeDdxwK6dHAL2VQYOIaAsBPgaXnfbrQ5JTyk3zQw5ZdOzVp/oPVZd5e3LTp4NluWveSPH/tAowZvnisjlzeBwbxiTOZi1ftSvGXjxFk0YQGMmvzXN+tXsDPY8UvYUTC6jywIRJnMJ6XOqhqM2kieViZicCpnmfFFgjPo4o57PJzNB9i/8iby3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txv8PHLqEVr9szOFwtNyYX/2L2ErHF4Wi1K1AyAflVU=;
 b=quyMsuRK0kKNUNnPnZBbqDGdF16wXC5XPfWawY7r8eO2szTHzVzdgqpXIjtLFZEaXdZTndcJNY32trfBu0JySDGicbpJ1K2JQE/lk4c6Flk4Ts4s5Tl+PM7aWGophnOasJJZL82VcGelgwWXYQD8ee8Sl3MOKfwQffa5B/MWcPeeQzockjmP1pYngDP5jNnaHU8d3oWsrt4T2wplLJujZFJE5Qud/eQi3EJw6bMqZUWYawSTGNSEMzrVLepcxko9Mm//2fq2vJPzmq+x+e+uDqChhlGeuwzFFGyK9DR40mV4lhENVf79gcn6swX6Xw4mIVfwQuOIS82m8dyqPl8GZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 15:50:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Wed, 9 Apr 2025
 15:50:40 +0000
Date: Wed, 9 Apr 2025 12:50:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] vfio/type1: Remove Fine Grained Superpages detection
Message-ID: <20250409155039.GL1778492@nvidia.com>
References: <0-v1-0eed68063e59+93d-vfio_fgsp_jgg@nvidia.com>
 <20250408132333.382ab143.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408132333.382ab143.alex.williamson@redhat.com>
X-ClientProxiedBy: BN9PR03CA0394.namprd03.prod.outlook.com
 (2603:10b6:408:111::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: 774dc5ca-19fc-453f-057f-08dd777e478a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?67Ui7mvfIjCj/8yY4p6mKmgkg5nnOsy9k7BZDua7T14oSyiX9yYKLGkXsJja?=
 =?us-ascii?Q?FHHyWehPyCwy/S+Q/iSvZF+KzNVmFWM2inZJRm4kII1gPyRUWxj4vMpD1XXB?=
 =?us-ascii?Q?2Qo6IVzzK9QVCOPblPLl4aFWUShUToXtoTK5XEd+pRk7r6aMMeVz8VEJtEDr?=
 =?us-ascii?Q?Vq04V36coqNY6i7HTuCaqgP6Nnmn5dtbw+WEMYbSaZ1CUwoHwT5Hx84hSw2R?=
 =?us-ascii?Q?wHEhQ4dyUO10WXyEHywqf3f1GfZl/wr9OWx15Rj5owRautqfkxw95Zmc0FgW?=
 =?us-ascii?Q?sMyruSpHwB2bXzSlZrMfa3QFNX8hY7cpVfSZTmEIUvpwIq/2ZEUfdKbd2DC6?=
 =?us-ascii?Q?g7yngQVhmjP9noIZICP/o5b8u/qRe11r4xHwIOmELsFU8WEHdZbKn2a/uzCY?=
 =?us-ascii?Q?34np7vVMmdSVAmhDvb+ijRjK7/lOI1H/kJ3t4Ta0MhgUyMhr2OePq6C2kp1B?=
 =?us-ascii?Q?GcOB2Ki5OzocF1/eopC7beaDe6BbwsX7xcsWkA+ALWUMPGkpTnFXxAmBQrUO?=
 =?us-ascii?Q?5V7d9blKv1Tbk1ah4/L88RQd62WalwcVWJWMQh+5xZ4mhjm4UFfGm007XX4k?=
 =?us-ascii?Q?APkNXc/Hj+f8xU/CdS9fo5+PXZTSmCd3DQBXOiGerpj7cORtg/BsAmQNUtKw?=
 =?us-ascii?Q?ZGPG5ummCGAg4SfmDifMk8Z+sqPiICGm14PudUAhH4pwjCOLgZWOzyfM1XMw?=
 =?us-ascii?Q?F53j+2cmwoJCE0Pqzvxnugoq21zESY/YjzwpGqZnI3q599h0shx98kavCXPf?=
 =?us-ascii?Q?L5T30Iu8QYUqUr6flGs24BHTL99odhX39t5qVpLCMHisYuhtHGJh8ebkReE4?=
 =?us-ascii?Q?WNYOTaOXRddHvlVaA5WLY4LUAQw65wPKvyn3WwDl503AwszDORFOCcfUxQNw?=
 =?us-ascii?Q?BvmpzbULzATG+cJCBYUUCyy7lxwBP5JN5eyR9UUdpNm4oJE85ElDIn5CwNz5?=
 =?us-ascii?Q?ZqQb5zai7SF5DrnPgoh56MlTukBYyAgXoBptja2sYl4WSd6qGfR9v0JAl/fE?=
 =?us-ascii?Q?BzkK+uIh4ycvdK3ycHWT8URHaY5m99K4IhRxE21FCqsVjriU5bdo5m/l4B0C?=
 =?us-ascii?Q?9heTbQo3J0YEAOjXn1P7qV46iyCftvfLDQl5VcV2hwdxpxpIYmgT4qo073sO?=
 =?us-ascii?Q?9XOyx9AAhlTTw+LOEOZGOo0gFU4qTCy/weutFYOHrVjY0xO+NNQC8BP+P+3p?=
 =?us-ascii?Q?yT+zPItEf2kxOQp7xZhHxfPy2rbQ8ZMwLLjs9VDMx3e8O04akiCPeRC2XAEE?=
 =?us-ascii?Q?ljGs+MlAwNjI3W3LucuPEHJdmEpFy3lJvAl0a1N5U6o9IUI4FNFZNNkvL77B?=
 =?us-ascii?Q?dKcY+njcoOBZEb54I7G3o5/loaHyq6iwsXpk8WgMVONZOxVdo8dpleWfkUiv?=
 =?us-ascii?Q?z/LLY67iWFp7FBFETS8VXmf6FPxq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tzBPm0sVSPDr+dqEj2Q0a7N4wfvyqpxb8MYYOeHaN6YSvANHC4KX2xqRoJJJ?=
 =?us-ascii?Q?jdUzvowc95KAN59ohRJAnm81VxyiKr3Outwf5tHWfyntwBMXpVbQ/yQ8gfdC?=
 =?us-ascii?Q?HFErykKcdNjlVic8ALvFckZ18sLw/GR3d+HCwZVAXTxcj2YxUinF2vwVU/bP?=
 =?us-ascii?Q?XCCO5g5wI7qhZiC4NDs9m39nYc3jEgAwd+qThyjWS0oLihUgTa0LnURhSwTG?=
 =?us-ascii?Q?DRR6obafVXDi5BbGnyyjjNnT3sPthyzpuu64WJRwWfIuq7dZ5vnm8gV9qWqR?=
 =?us-ascii?Q?Vs/yQfB0mgSvsTDGJgJ7kq252HBTMAQjcmTH3Ydscqse4A99mZL2wJS/7Rwc?=
 =?us-ascii?Q?9OKQpPk6St6D7OxfAgWyvEeNyZOrmfaCnqO0/2KLF2wJT0cPR/djM97JhVZH?=
 =?us-ascii?Q?MfuRYlDGngQYNzsANcKAG7YNIwRYlj5hySX0wbMJDJLo2sQBENj6enNhXSxH?=
 =?us-ascii?Q?JhulnyPE0JtC7CsOhVRgFtFca+JlAnQYAYEcMRisUbE4zXfZR8xXGo5ETXFE?=
 =?us-ascii?Q?EszgPtsML4cK5xMORfax2HIrjsXf74/2tIPfSmO+Cerqo6sEcim2Dy/ONKLT?=
 =?us-ascii?Q?+YJGnLiwTQZcbvjdAlgY3GbLfcW+08Jhc9msRLXFVPNMSM3M+ct7G/Dl4s1T?=
 =?us-ascii?Q?uVTn8Rdb55ooHMaUKU/ybR+4sgBCc1toMk4ODrKCQVb4VoQRPwQ4xdvjJKOS?=
 =?us-ascii?Q?Cj3QJ3m5cchUWA8Cip/qJh2LUNU50erFIZPKIRffgB0FBQQDhJtNmjhleQ9i?=
 =?us-ascii?Q?eqSZrZfFnhM0dp4ycuh2/euHMOMY39pU3DB/8q1nAbYsjnVgEGpFU3V+hhSB?=
 =?us-ascii?Q?V2bbEZhfNvyg0ja5uqegJkBXlI2h6o0DQhIVGBo/X3mMfiexPr2TUfkTTcvZ?=
 =?us-ascii?Q?rPCv7TNPkqZEOc72eoIUBch9cbEJfc1nTeIKFeyMDwqBeN9dpdVaeW49VOwG?=
 =?us-ascii?Q?Ukrg8jL51OIKrne44uycRyIFYk4e3ZOPe5X1Y70sHDfgq8uUErnnqHPDhIGz?=
 =?us-ascii?Q?ESa9X/XlYb7+/xKh6C+nSnaujo2Mx1q30WopW7qpGigsjuuhOMZjYG+rwlW8?=
 =?us-ascii?Q?XaB+1Z82jLntRMwv1dykKD8h/DF6eV/MN1F55bvxX8/gI1Kw9m6zMqk+BzVy?=
 =?us-ascii?Q?qInUi+esJWBOwgfIi5rxPU5gVoy9KGveiPe8su+FtpMXjMJrIazI5hWN+MGu?=
 =?us-ascii?Q?nVvyxX4CfN4eTDrqBqEZ4euiPTuTiQe8Lp8M/jsFfvI0w60dpvM5K5PxjuHr?=
 =?us-ascii?Q?NPJT8qXLoH8I/BPL16aUl+ONV3qVhe9K/kqYZjKrlcNIxpQwb3DUeUyNO3ca?=
 =?us-ascii?Q?nUagoONPRUiX+hbwli+qk+cBnl5dBz81LU+HsMQZNLb67e64QyWHH1ElO5pN?=
 =?us-ascii?Q?jKsX3HbX2lBs++UGRNfmgrdaqETDXvvXMSXxlFu2jo/x2s+QTqO+YAvQbxVJ?=
 =?us-ascii?Q?5q+a2JhiXNpfgDZyZE9lW/HLwe15ioNolf0IndrB3214vS1EpadwUqFPV91i?=
 =?us-ascii?Q?vogsJ+jLTrL3jWnY201RBeWpZKuiTlgs5zm7h+mG/y0/NIUDBBRdJGHtyeBo?=
 =?us-ascii?Q?EgBAAAOxYCi5D5cSYS21+NwGeMG60oNjq99jtYE7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 774dc5ca-19fc-453f-057f-08dd777e478a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 15:50:40.8552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHhXXvu8RquoQNQDjson/SX4FEGqI+ScsmExbao9224R4D5PAqke2DRvE7KBe7Pq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

On Tue, Apr 08, 2025 at 01:23:33PM -0600, Alex Williamson wrote:
> > Remove vfio_test_domain_fgsp() and just rely on a direct 2*PAGE_SIZE check
> > instead so there is no behavior change.
> > 
> > Maybe it should always activate the iommu_iova_to_phys(), it shouldn't
> > have a performance downside since split is gone.
> 
> We were never looking for splitting here, in fact an IOMMU driver that
> supports splitting would break the fgsp test. 

Yes, I thought that was the point as expensive splitting in the driver
would be the main reason not to use the unmap path.

> Nor was the intent ever to look for 2*PAGE_SIZE support.

Maybe, but that is what it ended up doing :)

> I don't recall the optimization being overwhelming in the first place,
> so if it's relegated to AMD v1 maybe we should just remove it
> altogether rather than introducing this confusing notion that
> 2*PAGE_SIZE has some particular importance.  

Okay, lets do that instead. We have more and more cases where we can
get smaller orders than 2M now and the iova loop is probably going to
be faster than unmapping a small order page 4k at a time. Only AMDv1
has the ability to store the arbitary orders..

Jason

