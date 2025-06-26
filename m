Return-Path: <kvm+bounces-50908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF9FAEA87E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E83944E2580
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350A924503B;
	Thu, 26 Jun 2025 20:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q3eaE0a8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0320202996
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 20:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750971374; cv=fail; b=m2H/uKeCdCsh3xwqLkRIsYF28UNfFzQuN1n1zpjnLu5PFxXwdwBxFg70Z4IxbBWvIGZb62VH8SzXTh2jxRUp54UKGrw4FPwUjQ/4Dk/wIrZ+sz2JsSO5nfuKLW9KjsQEMq5rvoc3AX5DbsJAogO+0aG+lPGURcJ6jquz5ZHqMBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750971374; c=relaxed/simple;
	bh=TSbJ/tQ0uYihAzp+UwLwCktcV9i7eo/3dvK1XL+kBFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XWvEAJxAM3CqT9znkndO06Z7JlsYIqgCneKQjkFVinW06AWeGwQhpHR7h3OsLFeawGeF8FPFq+H8VF4ONJphXyshqCVu2M9GPfyfOCX7UNqwVUFJXI/XAsRcJKCTBUIY39fqwFfjanfmum3IEl5XzS6TEEBlny8UnJD/MRdVwk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q3eaE0a8; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ji4+VlGEcpXeb388CHqNOCCtuz6z5DD7haZTgKdMUnalDaaRZzH41cPdSGcVs5c9J9ap1E5rlXEKAzpz0FMjepGaBZ3WQYuL45OJYzEoOBwKynDS+xGN0yY2QR1HTX6GDIzMag5X3uQ3LzALItNGi26uYyxlylQfJsmkAmQ+259fQMh7W38iS5X2qN/9LrQy+3Eda6GVHKWA7CfdHVIB3RAaGMmIknuQLAQTZBWAYso19fDxkgNZF2hLUpixJwAdwvXDjNV4YclZlSsbwsrXy3DOAScXZu1E5DwbVNkyXxI2Xxfa6SRwINmEQxwP9hP87/S4kE0GxqP6McmUkpRLeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iTJ9F28ENTztWc7Tud4+bb4jK1laOARtmKvR0TmTZ4=;
 b=RyBXglHsYwwY5GocwFaBs3MAw9jiOgqu1q6gqzNaSdqCQvt5AdbWFck7TcTYWR0DgN+wt2GyJiRVflyDgOfOK9Ig7g07LDYAVd9ejm8Yxy5wFH7PcuwLDkqPNRVEsALNHd6pB9FsNexTffzczkU4eXHy46K5317sTDMsyg738OGJhLvWwDXw8sskgezDaHGZzHLV/2gyjTjUPFNdLcQ6CdVxvHJWR/cJ2tZusxVG8uGSleL7P6A9C5TifQlZg8kKR9NcQwRO9p5WBv24B8Ja3od269PRvNbxWdx/L+7Eu21BHJMhx+YgmHOhoMZYXEDhn82T8anPd39fM87Jdq8kXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iTJ9F28ENTztWc7Tud4+bb4jK1laOARtmKvR0TmTZ4=;
 b=q3eaE0a8XtJ9ASukQ2bawBnybZix+dfBKNj+7z56563/j342xJSKr3wL74v9vpgs3RYDgChX8Yvy5mZbHUm+CWdqcAyzs0EOYPFKUWubmhlCz29/KEZvIjDfOr6ew3S6C+a+Kmc3bFdR+RvyQ9aX/RuUDpHilcK7cpont/ynpVtEYXAMjb+hoFFz+Nrt00Q2ISnCH0jt8F7y3BykOlCg3FPiWOuROW7wFaQ2x2v3y0NydT3ouGyFsJOTOOw9JOBfnxXm3zB4K4mMuSV5mKYimuIzkNgLk4LTEo15217POe1K+umbnHWzEOuESusbTg0ak8duXDJzbK6zQOv0rlU6lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6083.namprd12.prod.outlook.com (2603:10b6:930:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 26 Jun
 2025 20:56:10 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Thu, 26 Jun 2025
 20:56:10 +0000
Date: Thu, 26 Jun 2025 17:56:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, bhelgaas@google.com,
	dmatlack@google.com, vipinsh@google.com, kvm@vger.kernel.org,
	seanjc@google.com, jrhilke@google.com
Subject: Re: [RFC PATCH 0/3] vfio: selftests: Add VFIO selftest to demontrate
 a latency issue
Message-ID: <20250626205608.GO167785@nvidia.com>
References: <20250626180424.632628-1-aaronlewis@google.com>
 <20250626132659.62178b7d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626132659.62178b7d.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:208:256::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6083:EE_
X-MS-Office365-Filtering-Correlation-Id: fe9f3697-ac8a-4f13-cf47-08ddb4f3e0ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3WV2dX7KWfUrLc5vkXDHkOd5YpCCc569jCAEDC9O9ujrQWW/QqnK4BvtCVq5?=
 =?us-ascii?Q?hzWmXgcf+g6Gal2tHbOTbDa4i0Ip0iRJ+/oIS1v+PxZ4hr6zAwJK2/WoxxOv?=
 =?us-ascii?Q?/0Zns9EbDr47hz8xetUBPu5nazFwayYWGe9YYndmjKm2+b+Jq8VJPGYFHvRu?=
 =?us-ascii?Q?IYkIMAZgP2xOVJsUluTvEntsbXUPhuFreqnYmkbUDO8c1cll4gcVlbcS+UeY?=
 =?us-ascii?Q?ieSz2ZmIqLKijIj/nmIlRfCZArcM6VM+E1/09FSmdPXxM3PPt+DvDjplzO5v?=
 =?us-ascii?Q?ZdZ/M/Kh5Zpjt6TlQteRYUMaCSzopOFBKvB/ymafZrESpiI8+tlwoWL/3G0S?=
 =?us-ascii?Q?14bNbT88AdrlKvhreaJNpXzFtHo02fYhRAlOuldcNJw7kXVCyPbjGyNVooYU?=
 =?us-ascii?Q?svtWZMQLvi3mW1G6I0O8Rk+NGRnx9uFDyxKQDIde5j3Nb7EHUkpQ3dYNUBjM?=
 =?us-ascii?Q?vyIEwheqfrnHSd7z54cL8GMlUM7bFUnuztQkbuXXEye5RPZmwLHq2MwqZfRg?=
 =?us-ascii?Q?UYhvNuSK+PvgcHmy1lUGzjEPeaFwVGg+Q40otcvokSRg7bRqz617HYO+e4rg?=
 =?us-ascii?Q?duLbcZ29PLhK1F5C/72cNViZ6yEULq5Wi458CMSt9lXNpPGNA9nntkg798FW?=
 =?us-ascii?Q?RJE7Bhj7+2QlhNKxWxeg/iOAVZOGqje8pyjALR8HmPpwBDmkMBIx6XHH9uHU?=
 =?us-ascii?Q?KQIAOO8IYn4pSNGprldwTROA47K/0IluCXpfSo2rBX/6Nas0N6EaOUVCgjZO?=
 =?us-ascii?Q?firZKExr2A/ochQTlv+q1Lz5tEVw7EajTsIY0WYTBEfZTMHaifdm8Toj0dIO?=
 =?us-ascii?Q?/Rj4kB9KSrNuu/c4BFeX8PpcQsE90OLdWfeCchRBLME/2fc+tu5698xbo+au?=
 =?us-ascii?Q?Gb9wpEnaOaJ7dkhFIA8CPXJTaTb14IrRGN8BGe/JNrB84UfFAwui7//5Ghzl?=
 =?us-ascii?Q?jyCsYghCRbsEAJBbNT124sjE6d7OIyaTbvjdqZPqf6atTrHJuE2MlhK+IQIx?=
 =?us-ascii?Q?GKGyqcX8jZgXhImvAtnZON0Y4Xjmp+z/795yE8dwzlC0UD8LQnnO5MLSFTGG?=
 =?us-ascii?Q?8nGgWScUUTf6FpmCt8h5zTCDOPE/eXqtI33Qh9hL5LSctgS/T3tRrZ0XCDHH?=
 =?us-ascii?Q?O0VKILdH9mAn6X9niLKVuso4fCnW4oJzfNdin6ZhRE4MAJb+RXY1Ntr6i9rs?=
 =?us-ascii?Q?sVqDOTd8Tht9xzIZgpoBLjz1eNIokY7Zu/9JJ0uVNcvnpRMJiCCRMISBPOj5?=
 =?us-ascii?Q?4ge021fXXLE506+3ifuWoCnwmZK9sL/QgbmskzQH0XVqw5k0Mhh45+IFo3n4?=
 =?us-ascii?Q?S8JD2oK2MsGOsncCsAjDscYwX32yIWltzAyeN/4wboAs4g6Hst8CQKf57vbD?=
 =?us-ascii?Q?s9OGDCAp5eXLtD8G8UfAulscYQK7rGKgBGjXaQ2bScJ1qtkMzmP6aaTuLF9V?=
 =?us-ascii?Q?d7/j+A/hK/w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nTswAtVj1EuA+20PuD7D9pHwczg7ZhlFPbMmS1hHcl7oHplSAwfB3/wbhUwH?=
 =?us-ascii?Q?znnyfJhJem0ei+VmkR4d38hKoiFKRiWO/g6ZEspDOV22GMmgaVoe9bYCTGre?=
 =?us-ascii?Q?OMMEFTBYarArWb6KqRxh4upbVNpGW32HNxBBBX0hh55XkSEdK5iV02R2N9BW?=
 =?us-ascii?Q?01J6B+sJS13cXKVgryhGvffOF1etswLLVZ/J20zIBJiLUR5iqIMp4XMiUsZ/?=
 =?us-ascii?Q?JsSzVoKhyYMzFvGJPL8Z105N04s5Aj6ERr62VeLa6saZkpXAE7Un6UVKl+zI?=
 =?us-ascii?Q?OolfFiFzc+9igTFcn2tXEpXW5XR/rN2HFCNAYT7J70yjUSJE+VufcEZ1n6HQ?=
 =?us-ascii?Q?UPwNTQJlEbR8InJfewPDHCJ6nEd8CXzrQNIAo+uK+1rJGEfFKZ0Rh7tgidK4?=
 =?us-ascii?Q?WSiY0lvHFuUulQdnoUbMs5JMJdStssngeU7xWtCsjDr9MP57DSzCHGw+Sdyh?=
 =?us-ascii?Q?ydiN1CpJBk68FmdYOukm3f3ane02HsYH3bPmVYQBV5dKgjpPuMUdnC4lwKma?=
 =?us-ascii?Q?6zVqOSqIfv8KkSCahzLlGdb3vdIhVds2ApCmxulEud57IsRYxRdechZWXl8s?=
 =?us-ascii?Q?4EPn/3RhvbSmiyd8i3Z+a8z947PoT3cYuAZOmHo7uuQu/js8dDqiQOxWgW7W?=
 =?us-ascii?Q?Af7nSUt+b1qqnQO7us8ihd/5PSg8Su4I2g+uNZGGKk547kxOQ7MGUOewxFwI?=
 =?us-ascii?Q?SAHEAXGkyYy1L9iSBsbvdXZrXhSgXXMhz7iKEgzle87Ce7Ly+cY0NtUwAeP0?=
 =?us-ascii?Q?th2wvioYcRlTfllegMX05Y9znUH8LHqkfVD7+vXNgMNNjH7lyjnwYjyoUqMY?=
 =?us-ascii?Q?etlbJBtPOsGq8yAylZ9my+ua/ggD0Fqmes+WOa78iXhUF+2SRQtW0qDrnVpk?=
 =?us-ascii?Q?0AH/iJrryZZyIy6x+hISUZuLe/CACgohYIRCr9Z7WkIgCnIY+2EyKV95hyNy?=
 =?us-ascii?Q?HgAn+ArGbukBMofKTgfRdOGJubSJ7l6isFsfjOusMK08JyhktxSLnUBepBcH?=
 =?us-ascii?Q?jYP6ZJHQuqLnHyFXHRnXNoUEu+eD2QGxYG/YQxRi3yg+aecq19ne/i7gQx/y?=
 =?us-ascii?Q?3+jjWahIJkWsILEiEcuHKR/vO5UjqpYkho28XfZlQEwIMDt3p1NxbmGxde0R?=
 =?us-ascii?Q?AzvoGGnBADsM62tGuT8JmFjTuRmRXovGkYAldPR2Ig9nCIxmZ/NgyXmBeO8b?=
 =?us-ascii?Q?EL94ndQEyLspUfLMKJgkzurdfwnRO8slldHWAih/v/0sjLe3AGI3zsjoMR+h?=
 =?us-ascii?Q?zEMbsESqa4MU0n7XC3UwfrjeHj6NknD92zygltyyuNDm4Mc5R13M9biEul3H?=
 =?us-ascii?Q?sOIO8k5WuFjSFocktRJOtswTw0uTIG2n4zPWxE0BLZbBH76lQmPP2/4JRt+3?=
 =?us-ascii?Q?XV+0qDmVgYSN6OmofYS496SnHz9zu0vHU8xby76ropJwXGiP0iLvK8lQideN?=
 =?us-ascii?Q?X31edr028e3WUcVlgy/be7bTfAqJj8CrYXLxA8Rhplcw251+9LcFPbGXxjRP?=
 =?us-ascii?Q?euBDcKRDiIsCwUZn/cOqzLcHKqDY08Fs5YNpJSOPNnkxSw5fokRGKrTEqkNH?=
 =?us-ascii?Q?fHs6Sd7movOxR6XrttgvALLgWvy7MggDYehokvmv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9f3697-ac8a-4f13-cf47-08ddb4f3e0ad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 20:56:10.1371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcae2iAPrUwuODNztVwZ1In9tNDQUC9mIF+5eJANs91YM88M2l8nWFsl+HzFAtrA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6083

On Thu, Jun 26, 2025 at 01:26:59PM -0600, Alex Williamson wrote:
> On Thu, 26 Jun 2025 18:04:21 +0000
> Aaron Lewis <aaronlewis@google.com> wrote:
> 
> > This series is being sent as an RFC to help brainstorm the best way to
> > fix a latency issue it uncovers.
> > 
> > The crux of the issue is that when initializing multiple VFs from the
> > same PF the devices are reset serially rather than in parallel
> > regardless if they are initialized from different threads.  That happens
> > because a shared lock is acquired when vfio_df_ioctl_bind_iommufd() is
> > called, then a FLR (function level reset) is done which takes 100ms to
> > complete.  That in combination with trying to initialize many devices at
> > the same time results in a lot of wasted time.
> > 
> > While the PCI spec does specify that a FLR requires 100ms to ensure it
> > has time to complete, I don't see anything indicating that other VFs
> > can't be reset at the same time.
> > 
> > A couple of ideas on how to approach a fix are:
> > 
> >   1. See if the lock preventing the second thread from making forward
> >   progress can be sharded to only include the VF it protects.
> 
> I think we're talking about the dev_set mutex here, right?  I think this
> is just an oversight.  The original lock that dev_set replaced was
> devised to manage the set of devices affected by the same bus or slot
> reset.  I believe we've held the same semantics though and VFs just
> happen to fall through to the default of a bus-based dev_set.
> Obviously we cannot do a bus or slot reset of a VF, we only have FLR,
> and it especially doesn't make sense that VFs on the same "bus" from
> different PFs share this mutex.

It certainly could be.. But I am feeling a bit wary and would want to
check this carefully. We ended up using the devset for more things -
need to check where everything ended up.

Off hand I don't recall any reason why the VF should be part of the
dev set..

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 6328c3a05bcd..261a6dc5a5fc 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  		return -EBUSY;
>  	}
>  
> -	if (pci_is_root_bus(pdev->bus)) {
> +	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
>  		ret = vfio_assign_device_set(&vdev->vdev, vdev);
>  	} else if (!pci_probe_reset_slot(pdev->slot)) {
>  		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);
> 
> Does that allow fully parallelized resets?

I forget all the details but if we are sure the reset of a VF is only
the VF then that does seem like the right direction

Jason

