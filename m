Return-Path: <kvm+bounces-24647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA55958B23
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 17:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5A25B22010
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB63194C93;
	Tue, 20 Aug 2024 15:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nlxq7flw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02256194AEB;
	Tue, 20 Aug 2024 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724167490; cv=fail; b=J96OXdIFCxRYVicfOpDrTk+TkFm1jFq6Lj+IqXMVF831Ycwkvtl4u4CXjiz+dMBYStM2CqdmvDZEforU/u2TEdDbaHQ5FtQnIdXOLqoPhBu9BE+Bb0w69VYVFE7V26ujVziFfvUSh32fOnD1s5ZrGQH0ahZE0LXS5d9exaZYYpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724167490; c=relaxed/simple;
	bh=CHApj+NsBDBGlhR+rA2Fen91D0NPeqkhvzBg2tUP+VM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taNwcllvyJo37Twxfjqb6fXFWSe3ywKj7ar+OndqrxNM2KXHT29EZKm3/IHmR3JJObLCo5mTDljJtabPm0LKw4RX3HBOxKPTe5s4OOTZVig+UtWJ4Fg/c4ICI0ve8/IpB4vvfKwmI71ZgSkJ1s53VKwWJH4B0CLtgmDKkJwyCk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nlxq7flw; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VmUUs5A0LsyhLmiBjNKidwfKarZYy5hzcGCD4rQ6Upwsb8/BG3MbMhryu7Aw8M/uDZlF8MM6MZT6mB58HZJFRdpgXfgPrgXMXmCkrNXFk8GrEPK/uWQD551UTPI889OsSjXg+lPDCZBm1fLAXP45hBxzqOZgOtDdoz67rXB/bFuwtuNEZ3yBpZLcF+UK3eakSZCjB55JZeW1T1Q9Ho0NMCWWWP/bm0tT1DUgHxIhQkeHBLPP8ZFwrWIucTwOMwSJr+zQa/OjdVhFP2QOKUJzY0H9dow/OD1QfCIFfBZ49H1iWFNVxvONfFAesVYybfBHG4MaeRsKe/CrVjgRX/oF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkYHJ+mPRtYm3B59wrDzysbRo9Q3GZfAi30cd56mtGg=;
 b=Tv9ZpBuIsqjlKH8PZSX6F+VbtyN8JMYyJob9mbO2f8R/wZwYOzzH66R6j7zdnZEc+L9yaUtszY8NEaNmz3/H+G0pRDz9YdouX+Z5hMCFdScZiDH07dzCcqP6gHX7xDcRHXsjKr6En/ltZfMd3UqYZv8SyWUq02hcxyLreNjOWJsNhFf+5geYF4gb3AlTkEOPvCoG90TZvSXLYdWTeiONvnnV+gkOg6G/jVD6NkLf6NMxD2mgZqBQMtzHwXdGKph/HgyJJU8IQmXQojv38dOzRWfZoD1TXJM3GuzoKUyizelbsTuEIkaZeKakYqxi6kj7SIWBdO9/ZA2F6iI7bokYlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkYHJ+mPRtYm3B59wrDzysbRo9Q3GZfAi30cd56mtGg=;
 b=Nlxq7flw4hpTYFUu3b9ggwaBy25czMVD16sf4xKWYfzUooPA4e9z81342nDNteb2F1XHDS0rKLcszTL5cEtbZUqD0SnFdHk2L+iShVbtal+NPtl2VXMdwvw17VIOl9uUR5ez9b18JdTkev751JyvTtL13cpsoiFUYRe8+C98ujEr9FPlwtSHbVxdfaj+m452XAxg0VaSpTNw1hkyil5awZRJsee12ejEN59iNi7a8cQY7GV6WP3dA0ss7GvvutNRFB4DLZruNVoi8sxN81fduiLueoN4lx/Jls0/u8cYlDbE+pA/hAxgcqFY5/6YoYN8AGbX396kmE2MblAknThhzQ==
Received: from DS7PR05CA0009.namprd05.prod.outlook.com (2603:10b6:5:3b9::14)
 by CY8PR12MB7435.namprd12.prod.outlook.com (2603:10b6:930:51::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Tue, 20 Aug
 2024 15:24:43 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::14) by DS7PR05CA0009.outlook.office365.com
 (2603:10b6:5:3b9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.13 via Frontend
 Transport; Tue, 20 Aug 2024 15:24:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.11 via Frontend Transport; Tue, 20 Aug 2024 15:24:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 20 Aug
 2024 08:24:33 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 20 Aug 2024 08:24:32 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 20 Aug 2024 08:24:31 -0700
Date: Tue, 20 Aug 2024 08:24:30 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <acpica-devel@lists.linux.dev>, "Alex
 Williamson" <alex.williamson@redhat.com>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Eric Auger" <eric.auger@redhat.com>, Jean-Philippe
 Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 0/8] Initial support for SMMUv3 nested translation
Message-ID: <ZsS1Lsd5ORJOlRJQ@Asurada-Nvidia>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <ZsRR0MUHPz23zxu3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZsRR0MUHPz23zxu3@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|CY8PR12MB7435:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ce7730-607d-4695-b882-08dcc12c3789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ysgs677FBIKJ3kF2J6Wcd+XnIPCbURPbVPVb4hb0jhyli3eMh0kdIrCIGdLm?=
 =?us-ascii?Q?6/CMT9BFLn38jHh1dOhxkf4TmpKOB3dWL7BdyqKzqmt5Pn/1Bxyy/GGTft9e?=
 =?us-ascii?Q?mfM7KbHqZGrUiqDr5gHtJByKso/OEEgWdlBW04FaL2WwUKG9KPwEigR4eWuS?=
 =?us-ascii?Q?gdy5Hm/Ropnu9B4T3UIx9rfq26JrNGRbukqmTPD3TmhGpFJhPQEqeK4nJk+E?=
 =?us-ascii?Q?dnveeRHeI4F7g2kq6zSib7S9nM6R293qQl2iGw4PMpLzyYblLiigbA9jS3mB?=
 =?us-ascii?Q?7CzZZUUv2CzBhI3SZqgziE0+aDYV5acAh4BnJOXMoiZ8wnWbtTz2Q3pLbkd2?=
 =?us-ascii?Q?t0rfXF7NDqy9MClvKj/zzNAt1TdI/ksvVaRakwQJDAA6rqNSMRl/Z5loViij?=
 =?us-ascii?Q?ecDqeVYU/uEapeYCOVetDFsCG6s8fHhLiOoLr1yroP+60eXrkGh1UknbZRdC?=
 =?us-ascii?Q?0a2j2GUr3gwhpKrTYqTm50lUDP0cn8nkYWoGKKkfID15XgJ6CacepMGD9Z8M?=
 =?us-ascii?Q?YJ3eUmLbZinoYq482B0jpu0a2ip6eJcscW8O3nZzUJfEe7G7ul5TK+KSRitf?=
 =?us-ascii?Q?QNlhmF1KhtKw7OKrHO23eys0kjXMZRl83iCsei8KpG2iJsyKha0ZFtyxn2RR?=
 =?us-ascii?Q?O5D+gOJA0BABZ1dQqtLv/hhmQIGQAySpR1ek2wm0+dFsKYQHunoPsYMuNVGG?=
 =?us-ascii?Q?lRkWEsjo678jSdLboCAmQGk95CntOmbejooCO5bGheai0BELpj6D4LIbkGLp?=
 =?us-ascii?Q?UgWP8zb5ZSuMFpPcWhkJjLvZ+zTQn7S2uAeosk1PU1YkBKFjD8k5HhnLW07N?=
 =?us-ascii?Q?ZwJiMr7F+Z/QdXMmTBrjEF7Q7YQ7EXMaUJ8Qy7ASLxUui9J6udt7xgu5kGoc?=
 =?us-ascii?Q?OqlPCS80+vRBUvh4D6Rqc9+Uxg7nWG0M4kfyqLgLrYkmIzxFQ0Ycd9OZyi9M?=
 =?us-ascii?Q?+OR3f7QnRJCIBwDqWx4b7h8WvLWfaKBl/66r1QqDhN0dV87ZomTJZ4fK3unH?=
 =?us-ascii?Q?u2DtHeVwdJ+5e1DxOc79j+iguRVeUCKtQxjsyLgmKrDyxhzn+AwOnNZSuQvH?=
 =?us-ascii?Q?WTAe9YO2ZYHUqDGT+q/RjQt9U2MzUpA9yWx+lFgIttZC++Q73kWJFmdKlgXx?=
 =?us-ascii?Q?ubTinpod29avs/E/T7dcrnhbE+324RwiIQo/v6xv40Kr+BaZflJpgWRPnWH8?=
 =?us-ascii?Q?cVObn2/n+uQr5mw6bv16wKt2yRqqcNZ7xEqnea/IgixjTkQERE7flp8YaRwx?=
 =?us-ascii?Q?YOlR6uaJTggmTNaJWbHdZzrYxRux7ahKXSE2tpkelLsSh/3JbZ2QVPvYyR81?=
 =?us-ascii?Q?9zoWV9/rbJijBnFxLNnT4eGCjmYxh9daPUmCCwnJzAf1ZNIFJKVo/3a1P1zR?=
 =?us-ascii?Q?cE1xsBSdQT6cCqEItMi1Kml4UtmFP9Y0uS7cqhn+jKX/w+qseEtdPpfYR1ba?=
 =?us-ascii?Q?0V4kZ8rzgzsVnIy/+tLUWvTEWIfuM9mm?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 15:24:43.2855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ce7730-607d-4695-b882-08dcc12c3789
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7435

On Tue, Aug 20, 2024 at 08:20:32AM +0000, Mostafa Saleh wrote:
> > This is the first series in what will be several to complete nesting
> > support. At least:
> >  - IOMMU_RESV_SW_MSI related fixups
> >  - VIOMMU object support to allow ATS invalidations
> >  - vCMDQ hypervisor support for direct invalidation queue assignment
> >  - KVM pinned VMID using VIOMMU for vBTM
> >  - Cross instance S2 sharing
> >  - Virtual Machine Structure using VIOMMU (for vMPAM?)
> >  - Fault forwarding support through IOMMUFD's fault fd for vSVA
> >
> > It is enough to allow significant amounts of qemu work to progress.
> >

> Are there any qemu patches to tests this?
> As I am confused with some of the user space bits and that would help.

I have the qemu patches, but am running some backlogs to keep it
updated, and don't have one exactly fitting to test this series.

I collected a few remarks from Jason regarding the VIOMMU series.
And I am reworking on it. I plan to post a testable QEMU branch
with the next VIOMMU version. Will CC you and more folks.

Thanks
Nicolin

