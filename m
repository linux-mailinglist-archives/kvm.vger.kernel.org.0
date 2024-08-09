Return-Path: <kvm+bounces-23698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF11C94D2CF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6809282262
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700BB197A8F;
	Fri,  9 Aug 2024 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dJ3OyXx7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8F3198E61;
	Fri,  9 Aug 2024 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215573; cv=fail; b=DLFZtf3ez8U+J/A9GFYRrKojZ5AeTXFIx0Wz34/XXcxX+0RG62q306T72Z3r89qBD7HhMr1s6+y3UWEn1SNwga7Oy3z3L6dA2pck1XVkMr9DDvapbmG2o0ddF9CtIp9+/4FsUKWleC3ATObjIEgk6QIz3e2vXntbbfKHB+5JFiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215573; c=relaxed/simple;
	bh=1ig4hb0BhiyZ7tlYaNcCT6qmEWVDCkz8k/OlIfUrNEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QbVlor95Aj6NTRfq1fTQ2BYwsIUTcRE+QNVtm6Uqi96EcBEC8t+tYVOWgrAMBjL1y8BRVkrmelgvhC+szwWgqjmvvEfhlteQqappQToTsOjZDqkeXpWJlDfl+5wD8POa9GNPd/NDfhkNXn84gy/dl5CLOug1RCO0EN1TCQqOh0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dJ3OyXx7; arc=fail smtp.client-ip=40.107.237.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQmHyE0xSP0chWLeuxZRFxHZgxS9b9/nROELLHGfMQM76wE49Is1gEWmHSKv16xktPktY49zUKxUvfobXzlco+Qf9TSZd8aNvnE5iHjaNwiZKYOndtI4OpyeiJhUJtzQD+gSEhs5QaEzR8A9eoudeI0T2SRL0UgmUdAamXPC4Heo/TjyCmpY5dD1Lh0oe1lx/2uyle4+Cp0y36ZX1IzmDwD5YkBfXJpl5g3R4yQMTE1pgsaCn3KcbPjMT3I4gR3JaQrKIi9MGzGAYi3xl3Db/8u/wfONlM1GS++g0h0hAelzwLU6lR5NLQquImU4NjQW3/vfkh+itF8syKHxkPHCVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMC8kUMLlcaLotTpZxyWyIz4NNOWYMTen/7gzugRLd8=;
 b=R377Wmc9jbkrt37CRCUjh4AYOnZ8U3J7VFuF8gGMfrWQksX41Y3n4AmQoVcJZ2aRNvqsjS2T9jiMy+4qTi1hzQLo2HWXqv492zwBoRvu7bh19yYnN1xmuwFP/raUI5J/5nSmhO0dv4B05j+GcOABCzz7VYKRkzH594hexQbYNM9z2rAdkrO85oMwHwtfmjdg7vNRj12ltW87YXQ2apZWY1OJN3DcYZOX+c6adUjW4eEmlWKzeKAFkmZd8qvTlrzkW8HNKz0bjqdTV5SL3ohDXDkO7DcMMWIWW8PVyWT5XSrKainoOCuTIqT2PpNnvwJo25hTieS0yPllHzej64WTfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMC8kUMLlcaLotTpZxyWyIz4NNOWYMTen/7gzugRLd8=;
 b=dJ3OyXx7XV3vp6U/jJJx9SxDXrKIATYpYW4QpcR1By8Wm+tMJzZ72rQaSNtpXX3ZwbT6+CiuKrBdEj7bW79FqlcHy4Qu6xjYy863JhrZC3oD+fCVKCVuaJLJEZ22P6EHcW9qcAW6Kt4J4M676haIjxaAZU92Jdw/piwx8XJ6Ps7zKZ2oKZ0b3kDXVR/T37D6xz7Jn5a72SeTO6Ex36MNWEEpMMHfcShcDSKLJ16oinwjtGQdqivsWGIf6764M4BCtpxCoaznO2pZbsr06K3xBOQnWvjOXLkrTx73M2GBbGnnwpJH59LiBH5l8gaLDFWe8Ok9t1EpYkb4/tH+N/3I/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.17; Fri, 9 Aug
 2024 14:59:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 14:59:25 +0000
Date: Fri, 9 Aug 2024 11:59:22 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Message-ID: <20240809145922.GH8378@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <3-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <c2dc5966ab794825a69e2ae2b2905632@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2dc5966ab794825a69e2ae2b2905632@huawei.com>
X-ClientProxiedBy: BL1P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::28) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: 96b56d77-3150-4f65-cc8e-08dcb883dbc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lJuVEHmFfm6h8MLXK0sfIYahSX/z7OzB4zlm0/hKqdW2JsIjDq9VAZvEj/Xf?=
 =?us-ascii?Q?Dj8qtT3eT8r+rqGDIuT6Qoij6v6rtGxGonTu3wVzr4ObhEDjJUdo1zKM1WkW?=
 =?us-ascii?Q?ZbuWPzqpPNLgq27nj6Wgevfc35qx7XJGl7r2zxZNNIku9dDT0fcU69iwFVCp?=
 =?us-ascii?Q?chP/YspJFa+huVjWDzbq9eA4V7bnYpA0LarRwRiL6+CyU6iQWrYF6v4ngTBc?=
 =?us-ascii?Q?DqrsWqv+E9TYhmVZTcNkK5jfIFdSpqpV7ZY/JTwtOZ27GSQipJWXg7pueJpb?=
 =?us-ascii?Q?91C4Dhe9cEd/cM1mAOzFNe48vWY7loSN2wslo/HPFYiODGu9CGTw+nqc6mhV?=
 =?us-ascii?Q?Vr+DR9FgWsY3FOQT8ZGVjfwlE9KYUCzigXTptWuXR6BOmMXiCUtYGTot/8Q3?=
 =?us-ascii?Q?hmenqxc6rVLdhYftE6tklpMS4sLDQmjrl7pzdPuVxzFy7SlDO4b4McZSPiA+?=
 =?us-ascii?Q?NkNBaByW8eP2oalbgdgo5U+JY4EO0oO5Meqk0Xk+K5Btqt8X7Jqoiv/Kijiy?=
 =?us-ascii?Q?gx/dLoXvhXBcRkckCPq5zV7HlcTrvh3Be/geMwIpEJ7jRs/+YO6MfmfYO8F2?=
 =?us-ascii?Q?daxLW4OajSoIeBWjQbxitPdA/pRM0Jx6AXu4tS5NZyg0rEVdMWO8O9cYqLrw?=
 =?us-ascii?Q?/ghtPxp45WPIPyP7P7sTvmbm847AfIZZeJoh21uDTb2RyNFk7FbuszvWrpfL?=
 =?us-ascii?Q?ztl3IxQ+XrCoiAB0ji5IRnGbqdN7kmghuisdFMIV9i9/1vFMlag6JfUiTJVA?=
 =?us-ascii?Q?2QopK4rqbpKMgjl9l0WP6WxuIVfi+6/3OzQyur1AUu2tNF6Rdla3LcJpv33K?=
 =?us-ascii?Q?HQemuJ5OFe3Xcx9LyujHmX9MfG8gJ7zaOFCIHnPtDtylWOQGmjTkYIrHYh1V?=
 =?us-ascii?Q?8beZmOTSJGU7MKdU+2PU+dYV99bTiF5zLBsukVD9XDGw+LGzNJakMFZcuy5o?=
 =?us-ascii?Q?2BTG3LIIdrQ4d0f2a766uVPlrNna5D+PZk+CCX2aLUhwt84m1bv7Z56c8kpV?=
 =?us-ascii?Q?UtnA44kBydDwMWCc0Qq48nIWjwZrlvx9/7WNsbIw1PFsI9ycsHCClJ1LiqRL?=
 =?us-ascii?Q?DVfFb6ZWXCqtn2I9S0vjgIEkFaWU9lfHnyJ6leI79aIHO3j4/OAVtCVFqKkE?=
 =?us-ascii?Q?8FhRaZ2N0il5k3r7sHN8t8/kQGFeG3sb3xmU9cgvmPUcR3bgd+PwbWc/5hdn?=
 =?us-ascii?Q?8MLcGoWX17gQydQXcbDFC6OoEa3wMoZ6x4oPM/Nlpd+yuKvpJVjhqCplfULV?=
 =?us-ascii?Q?vEUcBBps9pqZ2bN/zY9959hDTFvXotyNpTa4EqOwl21lWA2i0efpmya3gdP4?=
 =?us-ascii?Q?UiMqeOo1eQL+bbVZsQAKi1Sauy7XQH6A3ihdgsduGY167A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gEz0zYluBWwkdQ7qrQdCSU6zeNGbZMFVknG+v95IQZsyC6wd30qsQ6gFbz7U?=
 =?us-ascii?Q?gvmqa9jUDwomCZPywYM2ZZRMZu3aJxYyTp7liQYEZFrFUvoXkbweqq0o+KRq?=
 =?us-ascii?Q?ovn0xef4wqb4tyX2CZiZTKT/ug1J5Rn5GAY2V2evU9b4GYeM2FOKviXcZzJA?=
 =?us-ascii?Q?v1FagJvBiZmH8KO4aPZdV21uQPjv7VnM7zMeW5K4cjrpMTKpFjRKENnGq8+d?=
 =?us-ascii?Q?4a+8vUR9bfI67D3yH1m32dzQ2Jmav12m6KfENtU51SPsl+25Z2MGiOE3QStR?=
 =?us-ascii?Q?CGBve//Mn+t+AluP9be7sogQiea+ReNMz7ZTWmi5XyOWbIzKxp8BQrU2oemR?=
 =?us-ascii?Q?6iA43oGJHU+7VDYyI49QBcOJdtPFbWCjWuU2cTdPiY2X1SsV67hTN7h4H7JR?=
 =?us-ascii?Q?69tOggSxdCoZZahGst++i0BxDDVlFUldNSifxaP88XUfh+DTaiK076qVPAn4?=
 =?us-ascii?Q?90d7slfiM5k9yHle/ngIVJ6YwAiPr5a2SFhOGU6WR+Gs+4bZ0513UHCfxyu7?=
 =?us-ascii?Q?9kaEcJipTpxQ1PIASyJ5nITEBTVlbwkzToY2ucLzZH1zjGNc1eEeqW+st7EU?=
 =?us-ascii?Q?LQe0GdTUxA0ujeerZRt15KxvVykdOyierrKFD2zl0g/YeDACfFHSQ/ucD+Kk?=
 =?us-ascii?Q?SyZ2ZQN2hr2WSNMagZhcC0bouxarASvyCNEs55Jt+XxsKDHgrevic4VHev6V?=
 =?us-ascii?Q?mwEyVNXfq+5L0z8CLFFS2cNgg2IZy9wDLtPoGX0RxUoS951C/uQ6N6KJP1Nl?=
 =?us-ascii?Q?A16sImCFGixoAOaz60quRWh0Nk+pO+L+4JkPEuyESgyQB5S7JeFON4NfwSpz?=
 =?us-ascii?Q?NKdpxa/3FPGQqkXwBWqN8p34DGY4NRd2r94SYx4yh52YhFUFEVqvZ4bMNpkH?=
 =?us-ascii?Q?T5MzjttnmJA6o/X1JldHAVRi0I4Rux5y6AdPaDJackiNy7PE6i5S5pBjJLVx?=
 =?us-ascii?Q?w1++g+vvYuyWD3XQli1uJ5jsoCfixQrba0IbRJJrLvVe2f8E87mxH/CUd4MD?=
 =?us-ascii?Q?v6DgZUA4PsrKQkEptCYrYqVn2euZZavKzTsF856aA1+oGsidl2lq0W5dUKCg?=
 =?us-ascii?Q?XxrMmWJolxwI5HOvlaawvT8hpZEKqm4+EY1jKJ3lrPC4+6L+4rFxmhj/VWwH?=
 =?us-ascii?Q?r4z8vQa4e5mHyANzE8vqqTpye+51OO2qUynrwcn8zQnzCoknrBm04yHdRis/?=
 =?us-ascii?Q?TKZ3OpMJ1yOzMSXdbqDMFIHo1Nc8fRhtfRoUzje76pIBQ445G6boQs66acNf?=
 =?us-ascii?Q?M7X6mNfPBOFBA6QmJf5dMiHZvsF91R3ex9NtmuzmB32g/joiFLNIsxRQiPi0?=
 =?us-ascii?Q?H4EkcU12Pq4cc6lT3dlTfqitFe7zcf0cGWdwNkzo5cfyC2K4rJmmn+koNRDp?=
 =?us-ascii?Q?d8bRDa88kPnOIsJjAU3jXUzXMjo2rVRtWFP7mq0/6/FrKhEGMH6sZ7+sQ6ax?=
 =?us-ascii?Q?KjGhvBzFAKCJn5hUV91+BYLDY1ljMtI18LJ5nFqo4nUntam1Pz+kOxo5ub0S?=
 =?us-ascii?Q?pIx4e1VyargqwDZ3jZkIiJk0itc8I7fk8qr15I9+39+HX3zT3kIY0ypMcPn7?=
 =?us-ascii?Q?qa7vLdp0o0YpzXEocLg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b56d77-3150-4f65-cc8e-08dcb883dbc5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 14:59:24.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaqagxgvxCdAeQF6RGUNyMyp/9tGF1Eo67eDWy91mOqkJYsn0sA4WkpJvJL3EYN/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353

On Fri, Aug 09, 2024 at 02:36:31PM +0000, Shameerali Kolothum Thodi wrote:
> > @@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
> > 
> >  #define ACPI_IORT_MF_COHERENCY          (1)
> >  #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
> > +#define ACPI_IORT_MF_CANWBS             (1<<2)
> 
> I think we need to update Document number to E.f in IORT section in 
> this file. Also isn't it this file normally gets updated through ACPICA pull ?

I don't know anything about the ACPI process..

Can someone say for sure what to do here?

Jason

