Return-Path: <kvm+bounces-56826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99EEDB43B52
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 14:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54C84566FCB
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 12:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2204980B;
	Thu,  4 Sep 2025 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iwIcKcde"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32AD43ABC
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756988150; cv=fail; b=pTFIbQveNj8VwePgil6v1yMhaaOh0s5dY4uG4atAl1tPfRJf/ZfqHH5bmSJ26SuNYjja5JbSrg8I8osUO85dkHfUBRZjjzPpirSL1YL7bipIW6Mqe/8pmkmfDew9FXmIeyfYG92Tkaw5rZEym13Iba12YRFTRexVemdzRGeGHx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756988150; c=relaxed/simple;
	bh=JouLBPmStHEHn8tztXOQwEkdL5vKcfuxgC/Its08iec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dRrlndKs0jgsW2DVvUcydePlYiGSTRmd5kHelwu26/2Mn7ebbkbs1V/1KJr8xfK6iR7wcshXddx7PFbIuw2qd2fyB7FTOzfMvoCeOcrrVAPy9y42k8bXW7OkA69seJwSsfixz8HvfqgWNn7pHBa78uSu8l7M98VDepDISa1dOEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iwIcKcde; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yjjy90d1SYsTkJ3PdTpf/NspZ+9Z/TKuThJlpDn0Ic6y2QfJ2erGHpDvxMRrU/v3Kv3qsJF9Gsxj5zYAPFeNraFmhVDdl+AWvAFVMl6Z954mv4u8YoX2JW8p5FX0Twz7IrCmcz73TGVx0SdPAVpI71gN8TYcTmNr8mVE2qh4zvKL57ELJn/bHs2Ldt+r7guB0sR5bQoe4L+dgF0uK7K+cYHR3QtkeCMAz43vkbv3mSn/k0FmFet08F3fAw5xd+2IBqaqYeEj37V+SVa4Temv+6Y3rr4TCXip3R38OzWZQl+QdIGKZyEz4y9s81V+4yFEArULFo+O9RAYmUHZ6ZbC+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JouLBPmStHEHn8tztXOQwEkdL5vKcfuxgC/Its08iec=;
 b=k5Db99Gihuwkqq8YWmEHYlaBVR7YySaz7msU91XDoKBu/+qYNiptalXIDjMdBYlPmS8FknIQvEojvdBqcZRV7R3vQl0tmIwWipBFnjmK1Qa+dKgUyamO+9UVn3FQgKBnQjUs4bH6fSBQ6zxBZPm+dkZbUWjHAJSsFNmVkv81fwj41qh7TMTt+hzywgXt/laLlBoQtP8CpB9jaod+8Q1nZGRO7vfgtsPTpM+sPDecDMVPuGCBVK9z4unY/Eyog+DwWpLdu9a26NdsI+MtoZxjtLz9fgHtQi9bfVfarCHteQ0dCbceY2lwQkoGa8VW2LxXeiz4KVO1u8Uf1dDazkpfHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JouLBPmStHEHn8tztXOQwEkdL5vKcfuxgC/Its08iec=;
 b=iwIcKcdeTdDGdmAQGLoQcbmy5IY3ZI1PN/P/4zcrIzvM3gr5iWsYmFZEqAJvHXjWAaJkT79cySKu6/6SB/iwYz08LAaeSHzG/lSZV3hVyzuXXGVSUcLWpeR2jykJvC4wjJ1Rh8VCU/jKcCCbEgxfUzeSjl4dm/lI8jTMLg14qGp97eemulfDM09VzMs6IdFjCqpM5fG2dqMWk9eCzKQYfcsBHpZdI7z/IAVs0dFi4R3luI2ttg4HUiSlJWHbClc6yCu1HCIS2gzNq9dS2DpSazbkPK/lMIQbyJV0UbxkTaJu+txCh0KMDJhyKdGNt4M1bx/GRuOWGNj7o7vn+MvHxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH3PR12MB8851.namprd12.prod.outlook.com (2603:10b6:610:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 12:15:46 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 12:15:46 +0000
Date: Thu, 4 Sep 2025 09:15:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org,
	acourbot@nvidia.com, joelagnelf@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, nouveau@lists.freedesktop.org
Subject: Re: [RFC v2 03/14] vfio/nvidia-vgpu: introduce vGPU type uploading
Message-ID: <20250904121544.GL470103@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
 <20250903221111.3866249-4-zhiw@nvidia.com>
 <DCJWXVLI2GWB.3UBHWIZCZXKD2@kernel.org>
 <DCJX0ZBB1ATN.1WPXONLVV8RYD@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DCJX0ZBB1ATN.1WPXONLVV8RYD@kernel.org>
X-ClientProxiedBy: YT4P288CA0091.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::28) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH3PR12MB8851:EE_
X-MS-Office365-Filtering-Correlation-Id: d11b092c-97b6-46b8-cfba-08ddebacc6cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C7vBbVQcqgrMm2zq+2z8A4EjSs4QP5k4pCR3xQ/suMWbqFKXL7/lnSdWSShS?=
 =?us-ascii?Q?5M8/p/BfJ9l8LLlMnFvUxvSHj82RTfKFx6ft2otHxn9zqt8GG2QMAULPccVJ?=
 =?us-ascii?Q?aAgkbMiTH1NjCsipmCs+W1mbehO2vgYfuoCsHXoGe4Gx3bUK6aHXOQc1D80Z?=
 =?us-ascii?Q?I//T43NQ7r7pyFjHx7GanX90HYlnxPcjdGdGthbpwPa+rraRtGAXgAIk8Cfm?=
 =?us-ascii?Q?t4cxSoy7IT6ewRwzLQmDn+GeV/13N6djBVW+2bZ6E2oV40XbTAMKD+ELlBKP?=
 =?us-ascii?Q?7WECq92hVMj2+XjRDRKjOyD7xnJq5sbftJEFEQYHpLUcBB8wU/GUTRqyMMvH?=
 =?us-ascii?Q?65zmvpeP57Gs3LKxefPaaeZaW9ZCkCktUtLmW1fPYw4DHvjVfzu+z9wH4GBq?=
 =?us-ascii?Q?WfPjoFN5ub826LLkjm94JJU8atgiqF7/EtqZ2j5l2FJQm5JbsZediW9jGXAT?=
 =?us-ascii?Q?tOZ3uw9iN82UhtFSIFuAmGE8qjv8PfgVFkHME/3DAcov3PNQk4+UnDpsOOou?=
 =?us-ascii?Q?6mLFE26FfyYlSbW2pk0R0vmJS0yBc8atzi855CHTh4kgL9owLy3/H8Tj5VIm?=
 =?us-ascii?Q?7+eoFQ98X+PJn0Xdf/0/yQHYT0FB7B6KcN45UMX54RRE+3nqXMI2j7iADCCI?=
 =?us-ascii?Q?UM/yTuxGCFEDGJaQKgUsuRQZPVzxbk6NPp1nnLE1j6HPqUEfE4milf2ldzEZ?=
 =?us-ascii?Q?4n/29uxjnUgb/gtb3FM6VeM6WrFoOzOYD86I+1eQ7CQKBwB/8xb8FnYZ1RZb?=
 =?us-ascii?Q?1OqurFCrlAIaQVfVJx9GQn8XeFriY+pUT+orqjDGO19Y+IzZ9BlhORzCif4R?=
 =?us-ascii?Q?bYyB4B32h8JZVUu3V8EVw9H9JLxrdSIEU/BFpGwa8zWwqyx7mmA2ERtO5Qt3?=
 =?us-ascii?Q?lCVrVIAzas42EKUKaUAL10aHO8Fv/4UkxvudGNTOO86UdFQgenz6C8btvF2x?=
 =?us-ascii?Q?qp9bPbSnpS4OQKZ7Z3c2ZjOosZhS55p6XQGCAHS7OOvT+J9pZ6NnhTxjnphQ?=
 =?us-ascii?Q?6tG/hAfP9Zu02aG8rK8OuXpGK6OgN18tQJgZQTmUe0j0y/eZKzFBsy60X+gI?=
 =?us-ascii?Q?r2f7kYp06zfkuhOpEefX4hvmA6VXKjow8YVyp2s3DnMblm/1P7neLCL6/CW+?=
 =?us-ascii?Q?hccR2FF0fOagz0TFCrqKGKBzGVNJsFRIrtVj6WVU6Ud2rEP5cS1YrlwgYuNO?=
 =?us-ascii?Q?Q2Y17QGcpTW1kGXq1aypGlhJyvEEUQKP9B+/fSH195ZnJmxcSoHnpnVFkBA0?=
 =?us-ascii?Q?Sx9OwopFneltQUzPRvWWCZk4H2sjpRAqXUXQovjXdD2Xd8Kab2jvvi8zqwhI?=
 =?us-ascii?Q?kGcImP57ydiJrQdEVFRlm2hyAb1N69+r1D5SwIzxcFWAEGeEsmGETI0RKqyH?=
 =?us-ascii?Q?L3sJR1qEUjLK2UTtKqVzdGoICwi+r+HCA9ZiAsVctiLniJOWHr+vo9qXFefJ?=
 =?us-ascii?Q?g+K7pU5cEJc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rIeJG5UtDGuBUWNfQ2OoRuuhilNx4xHV+mW4nosbu7nvYPQnbM8A6GrVDdYQ?=
 =?us-ascii?Q?hZwBnHq0etTaDkun7UDBvKgzHWmc6UYhJLeTSHuwfWP3vCI1UFi/ivuPA858?=
 =?us-ascii?Q?sCbZ4trKIAmpqWYiT2wYYVuZFvMaY373QhkL+Xbv4oD9zY26qk9wKCht6IKD?=
 =?us-ascii?Q?o0UEL1z84zuffHs9juMGuiT2/9mpTKkextfxJiSQ7VLhzD3xJg0zYIUFTY9+?=
 =?us-ascii?Q?rE5dy7OjjVxiWQBycOXq1apWvPnVuPlbcSyr61zkvo0G9xQSSITvCjCtHdlj?=
 =?us-ascii?Q?j9oO08YDhUauvOP19xPcBpFL00d43WcQGkdP/RJtBmq1wdSC5BXh9EfRhqzb?=
 =?us-ascii?Q?szpBisirO2piT+upECbcR0fomUPcyzr/EfZ/AnFJCK5cGzjak4OLGr8LlKYS?=
 =?us-ascii?Q?4sprdphzHOHsGjyzdleYAXBVn/XbzcNGKt3tE4kgV7s42EUucjOkp+JAXF8J?=
 =?us-ascii?Q?844sqnnHucXGsPCcKhelXJrPZv6MVtmg9iE0z/cLDV8OGH/nd8OySolQtsMw?=
 =?us-ascii?Q?wD5x5m9FOgwrkH1ZIjXIb+tj/4rr9G9Mg8UyqSQ2A6xf/UlbSGvD0dZzoaku?=
 =?us-ascii?Q?FUFWjglw1wQWa0mrmyRAthq8P38ctM7/8H0tZZLwGeh1ARshc/n9sTNhwSSw?=
 =?us-ascii?Q?+QLql27iEe5EwyxS+qduTdEaYKimRFO1KO+wh1/lK/UBDDTYU0jyQrjydU6v?=
 =?us-ascii?Q?s5Px5Ny7rd9CjJB3wCAkaJt22j4Ri2xYU7IxYgafbldVAXsqDVu+UzJO+oJt?=
 =?us-ascii?Q?ty6JL4VRgQHm7QyvtyZsS6FYSAMJv+sFGzw3pp5A9LDyWq+ziDEdD65rWIzN?=
 =?us-ascii?Q?98YQwDB2uTggoNpGJQ7sEFd6iI+fx9iTHm04AjFBkgLdmC7ZiF9PAEiv+qme?=
 =?us-ascii?Q?towW8Z0Im62rH86lUsDq6iLFp9yaZIGUSyMmVm3+6dtUz75i9D/zVPlHBUMl?=
 =?us-ascii?Q?eBpyg8PkrgwVWgvKQk04ySzOeQRVTGWwMMPiXTIiyGZLx/tShfKjm/AU1Ec/?=
 =?us-ascii?Q?SizBtfL02Fj1IKDZXgmFhHL0mfYdEv1gP3bIl6gL5QM5LQM0WWpLRgkYV0fZ?=
 =?us-ascii?Q?97BfNd7nFxymiW160DeOsAdi9mxDm+2K/D4MehnCeoIWckqW4Z3lkNgHzLvn?=
 =?us-ascii?Q?Rxc+eExgAT64jhbIo9+ZUeBpabbdc/2mTAPDemP8WCw4363dbrn3nm2QYRNI?=
 =?us-ascii?Q?X6T/sEP1yPpp73d7KBq2mMXfO4cj7RSvjgYj/pn6c8DZ+673vzoKlPUiCB3r?=
 =?us-ascii?Q?VpHyvZIbvS27xVKGrRfG6+KKYHhQCyIvsta/SPdDbEcFffWQMyNjodeAqtqO?=
 =?us-ascii?Q?HgGkYXfkmhAdTkw0ZrOKhcLetvikkAaXlPjsJwe48RYn6ZyolUkKa6J5+FsU?=
 =?us-ascii?Q?YMwnNK+sYCTDShfHNdVDwIU1bjg7nFCOpH1TMeKT5E2axGhtC5WdfTNip2YV?=
 =?us-ascii?Q?7yOxPGJvZvMjGcR3zP6gWThAKmH2rdpKn67pFbSMSCLk/al1jIPfgl5yOjEm?=
 =?us-ascii?Q?+xatCXjiGbwpwUmALog9cIN0rFjE4sSx+Tkev9+yDwNkWK8dRLMAQhMMZgma?=
 =?us-ascii?Q?QNzL3r4lrZngDmIS3Io=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d11b092c-97b6-46b8-cfba-08ddebacc6cd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 12:15:46.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIYsbgNkajrizyzwVEziPI8FzqdwCHXmJ9rIqO+2ESy5W5zjuckjQZqdMpG0wMmK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8851

On Thu, Sep 04, 2025 at 11:41:03AM +0200, Danilo Krummrich wrote:

> > Another note: I don't see any use of the auxiliary bus in vGPU, any clients
> > should attach via the auxiliary bus API, it provides proper matching where
> > there's more than on compatible GPU in the system. nova-core already registers
> > an auxiliary device for each bound PCI device.

The driver here attaches to the SRIOV VF pci_device, it should obtain the
nova-core handle of the PF device through pci_iov_get_pf_drvdata().

This is the expected design of VFIO drivers because the driver core
does not support a single driver binding to two devices (aux and VF)
today.

Jason

