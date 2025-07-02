Return-Path: <kvm+bounces-51321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17927AF6081
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 19:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88C497AF02C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 17:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ACC0309A7C;
	Wed,  2 Jul 2025 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AePUgmeI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4535130112C
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751478964; cv=fail; b=qflFKvAuuC20BMJA4xtFs6cba8jhL5aMhrqsFq2POoL/ctmmUuKpGRoeeSWtY093ThZZJ+s+5MnQ436Q0Klr2BzDpSDWvZwWBlYniRs8hiZzwMghmxrUbHgyz+dNlM1HCSY3ZLYB4oeb1ghZ78+0MMp1HHEx0vPK/4gH+itlYTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751478964; c=relaxed/simple;
	bh=3WTGKra60h1wxGvnp+ne1KiKqWxe3NuMYUFYhzOco28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hDYg5hZnHbWGYx9W++C49Tnu4ZwPzvEbwG0JXVUis+/91qM9E4okZFNcTPY6qYKDGfFgtSO7JxowIzxH/VH1pagRjI7IdXyPozCR6WO8/qZUMtMiIp8D/hjcgPpoYPi9xL2bAL/0tsjrXXY6/1DidJPDAbSWEF8ynhijF4vkR1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AePUgmeI; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWOeDIjg9yjr5ucKWirj3A0muyQVpfXNrZHM8aXUWNTSyo9AUENYSs7Tvl288/fBv/x/5NVvgOHLDaY3erT1qil0JESHHVnk1OVjumu8dD8RogZ+GI9bNHyXEv/8N8VbMqvKafBJujqS76SpOl4R6LHeUcoeJ588iBvhJwJu7D8uD1mjPK3ZjbX5c3FhqYbS/dEiJHMpl+37fh+LQ277+N4sc4aDKy0dA0/AXOyxHa0s27hjRwWCKy6KxRRyYG1aIeGwO53fDI25++1k+4PQ2lnM8b8OtoYI+yHqk+/znQIropQYL2APpKnGdzzH6gac/V5yF04wOUY1jovKRG78Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2MmgcIAe3QSVQDfeNTjZtOcbauLz4h2End+O67BwcY=;
 b=UkM1nBRvrPQpD2NvwZTVAn6Tr1AzTC8rYXHVvl8WihfOvAh4hqhmIZD9ZQ+p+0W/ebEfIG6TQDKRPVtvp7aU80naV/A4xc8gYAJJGNzuKbthJC/Vq8FD1Zd4qN+3oZsQ8JrJEsViMdPEbfm0O/7hNaX3zPRuxbzKIt4W5mFmhBaWl9FyULVgSWA1m7iheMcXmnGB2n7C/0UUIGhRvdMBMkVWk9SZRLenXqZ+hxuNZjHq3TjW+9HJf3FBbFm4Wb05V/ZoceiASLnNQkXnRsHUQAE/pmPcUxkTlI2hgQP8L4BCyFR1FfMyIJvsKgcNQ2eNC4e5BQaj6YNvt/MH0IGjCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2MmgcIAe3QSVQDfeNTjZtOcbauLz4h2End+O67BwcY=;
 b=AePUgmeIq5DrCbJmMYpspQiDMJrmS3baOKHicdfChyibTsx96rikQ4PkUyEkNUVL54w2tNmMoDpwRmkaGZnd7OJvYhF0NSm779nDSr1sHfyMss6w9XE3D5r8eUenbXgd2cmQqcPBAJi4qKmIz62Pwuj3LTf/YFsEFaQPlSk4MYUuyVen/NiLdGu3ztmQL1Q7APHHoiF4omewhPwYkZNe8QeUz4XgMq7bDi8nHo00zTKl4IKOk5qy+0imgQBb+sp507lkSRaxWm8rV116ouWsRopCiaSAM+Yb5+xWkUc5RApikWqBvotQVAo2g6wKELUsfJE9jSQX/jJV9K4y66s1eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB8250.namprd12.prod.outlook.com (2603:10b6:8:db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 2 Jul
 2025 17:55:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 17:55:58 +0000
Date: Wed, 2 Jul 2025 14:55:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, aaronlewis@google.com, bhelgaas@google.com,
	dmatlack@google.com, vipinsh@google.com, seanjc@google.com,
	jrhilke@google.com, kevin.tian@intel.com
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250702175556.GC1139770@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
 <20250702160031.GB1139770@nvidia.com>
 <20250702115032.243d194a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702115032.243d194a.alex.williamson@redhat.com>
X-ClientProxiedBy: SA1PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB8250:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a65b0ec-60aa-4342-0b67-08ddb991b2c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VXD7Zi3dS1hWSWCMjox93PK5EXJCsiY5QRBtm6HTOJODZ3R3Hq1GT1UZEGHE?=
 =?us-ascii?Q?rtTl5djGrMa0fJ102mvC7wL2AkLOi7wpd8K+AxbPcVOCqRqYY1yy2bJo09Cw?=
 =?us-ascii?Q?uFRITdqN/VyrmiTTj0sGI4caVX5zl/jMY7/kP6Nh83mNqgPLeMDqLRZ1rZ+p?=
 =?us-ascii?Q?hG81PzeQUpoU/xchoirP64m3Ao3u5yR763/yA6Ra7LMAGMhdVaX+rTV8ob1Y?=
 =?us-ascii?Q?rL4Cu2JoYFjJlrs8mWQacVF5XPMfRPRbnMc/tAXh5P55FFRSFgPELzNlHmGs?=
 =?us-ascii?Q?mlECVC72Bv8xn0ZnN8LuzIVGLR/OorwH84oTg+Rn3E2+ml/0edGoDWppJ1hg?=
 =?us-ascii?Q?kMui1ZvMh82Egp4lHVZJqkoyeD1bJGoKsVSezfdPbKekDngYJWp9e3I2JAva?=
 =?us-ascii?Q?8FvVL1vgbco2QHeDHwL10yI5pzydxPanphddTYzH3SJRrnUcvwWd1Y+QF38V?=
 =?us-ascii?Q?U2/4S95lv7O72dTPLcK+70t6D5zfnVT2qBXeZn1lGYd3GvkHpKqUTTXgTGP+?=
 =?us-ascii?Q?omYvECC9CrDVWFhWa5GBnt1AZ1FIRJalqhzKsSFLEbz/8Xn+IePN8jWPrWPM?=
 =?us-ascii?Q?7rS+Z2XjPWMPmWCp8Tu3Mt0kJgmeWBA/xQwTY4YbAgZHknq/gPfZe22qLqgX?=
 =?us-ascii?Q?CDQ22vqV+Sy244TeI2Q3NbTz5aHUi3smddBoa4gYb3cBZvkC8xe0awHZ9YoC?=
 =?us-ascii?Q?nt+jXxqTezQ8BJ3HmQlyXgEXRX6QLj9g9vYNb8Zs7nuedYra98+E07YE0ZEo?=
 =?us-ascii?Q?dkAMpOAC4aE2DtzfdzWeLTDDdPt9LhoKY9ij3ImiRYlbU8pAUD3Am1TkmZmu?=
 =?us-ascii?Q?/b7Xav2L7s8gfb6t2/KoZhjoq0cYj2yf7F9gf7/CSq9FtKOixKsv/I0swB8y?=
 =?us-ascii?Q?lYBgsNixnwUmRmvz4TY1sh10sEDhw5J7/vJSauJibVZVzZxTtYqJKbHtlxmS?=
 =?us-ascii?Q?d8QuINRnYjVNc4/puXuEgilRK65zR7hup/XN1mMh5NrFDVF0umr8NTYrWeCP?=
 =?us-ascii?Q?akC8RFHCc1d5VKThfjg4ux5UzFeURmo7fbxAytXdf6KhJjG8X83aZKjTv24o?=
 =?us-ascii?Q?gr9Klw0mq/e/0kTV4Pd+U/tFvnF/KRAKlfCRSRoEP49yUPe3Sycu9lzx/pga?=
 =?us-ascii?Q?TInd02jvYLlKa5MPArFmr5VagmHWriJbtrQp+NF0ZSzCq1yPYu/S7nVxjt0q?=
 =?us-ascii?Q?2kGR1Uca3SM8YSVOVlRuk7hZ5PcJQS37WTHBiLtePHVN1DsPSwIe3wzA1alL?=
 =?us-ascii?Q?CuxGoJo9ehIcYJcPvIpTcREPGnZMwb6m2JB+aOGe+N96caW3zrPWkBxXObHC?=
 =?us-ascii?Q?73XeZbKRZnKoazRVVVK69i7YBo4BCkYuO0Zp6WxJe/k59E7u9IfujxFQVnYv?=
 =?us-ascii?Q?At0KFHIOLM/dvxjBGUITSGdDFvMszfCNJ1OLgRLrLQMBsTZ+msGkoob90QpR?=
 =?us-ascii?Q?iM5HgE3JXVk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2IIbcEivyA1iNdVMCdLC1sTOlEFUA2toMHbswb+KP7CwlB/ZMpP5UOJUzKLL?=
 =?us-ascii?Q?Mjw7vei/oSYoJty2IB4JPU2WC8y5QGznwHDxzILzZWhfGtPe1+GWL7Pb7mXy?=
 =?us-ascii?Q?k7pEtx1QUGuxECvUfmJOz60oQGCfK7rc69y1E9aQh3FuIEheVG3O+4XR+irK?=
 =?us-ascii?Q?9URfTlZbqwSkaSmX4vJVzK6RhEb6IzBRmdd+ehG/61AUrYLWafDnnqOYBfCX?=
 =?us-ascii?Q?AVFF3cy4utV43BOUH20g4/2n8ASPBpmpYpw1UfnW7zjQwk3vXwfyil4QMWIJ?=
 =?us-ascii?Q?oiD3RDzFK8ci6qbjzJJbveo7BW5INTRooAs7uB0MVaCWAPWtGb0wWRIyTQD9?=
 =?us-ascii?Q?yLIAdZch0uhNuQXOZl0S5xpZM/868LGM9AE7EGnLi1o0oLm70MWgihMHbTto?=
 =?us-ascii?Q?NICZZGZ6YXyuSsaLqw7uOjDdEqSSW+M9uDFYDlDjLbvaCskSrYhfb3sSAKZ2?=
 =?us-ascii?Q?51xhE8Qq08n4f5MEfQQathhlXW9mmc2IzmAXqASYIl6zrrm609KpjNpdbTAe?=
 =?us-ascii?Q?UOunhPKi7cBWZl2WLNS34piTjuiyBNrYkb52tTuu5iILoqMDzc7CASybTvw6?=
 =?us-ascii?Q?lyac3kkCFXoAfON+YUdrA9dQAmR9euVIFVEujqbBXVT26aV6NXvImma9W87Q?=
 =?us-ascii?Q?sm9dOwZUQjq/0zDfUaXQ6XBFLvVgsJsbF6PsDRrqG32tSoyuiIF4nSP4cYgQ?=
 =?us-ascii?Q?S6J9tfgQW8P6WOwNB7ejUC2eE8PH5d1kYdYIM59i4DUxwHNlruBKqo5mgC62?=
 =?us-ascii?Q?0X6tJRCLshAzUOE2XAH92jqOcUDix1UDDZqdc/xV3KJctMS2qP8hHauJJjqy?=
 =?us-ascii?Q?IMu7u5ylu1qKf6erEDfxeiplLEcoNZXz/CU3dteszW8DKIGxuUboHpMW/uAa?=
 =?us-ascii?Q?TJ4/7a8lOaC7OmR5ou+QeZhsCUbjIS5WvwxAETVynUEFj8jXL06AqwFbX4b6?=
 =?us-ascii?Q?mLFAU8loCW0tvsfvp8pnpNw91UVYCCw245xqz12IcLDd5xQIGJnPuiYXGOva?=
 =?us-ascii?Q?o68ZP3q1wJStU3U9k/JtvVC872BABmBVBPTslAL21DobLvD24qZ6SK5A9o1n?=
 =?us-ascii?Q?Bw4CUhH/3K71Xaq+Rp5ZZMW+K2Y9a3kENu70EUGS18Bu0p4b+7ALTV01Yydd?=
 =?us-ascii?Q?XcqTt+tIMOAkuBi2TWSvkM1q3iao4FHr035Y/nUkLpECD+RW4dWZd+U1weP3?=
 =?us-ascii?Q?9DI05ClGLjUw0gS3gF78iutEyf8e5oXwXeXIKiqURP6iezEpyrcB8/cU23Jv?=
 =?us-ascii?Q?2BhbQgHLbhAS5phxp/H0RgJvsEAGDru2Ok979DTN9L+PJND42dqtaJ4UM1iR?=
 =?us-ascii?Q?MI+j1ShJOXp9oaM2oayHvTdVvCvBW65jzTvtNJT0BiFi+8D1yUTRRn8z5UE8?=
 =?us-ascii?Q?xMm5nH3ixFKOg/BF/4gqjAKf17eq+WSO8OufBB9xbkd2FqYcZ1gM+CWHzaC/?=
 =?us-ascii?Q?R1tgKIu1PkfbFvpaSYYBdMJhzlez2oVOxMenUZyikrP73ghyA6Q7hiho1nSA?=
 =?us-ascii?Q?PwAf2Ug1mjgPJseXi86zBPbLG5gzMHbeneNYvwiZePDnajOdimfSuWnC+GeG?=
 =?us-ascii?Q?lLdEYLVDtDX2UsfSyzDstSpDhHjp7qReQH7VUJPH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a65b0ec-60aa-4342-0b67-08ddb991b2c7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 17:55:58.0452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2KEWaDOQCAoHHzjfKRDAoDQE0O0gGHgDOhDl6NBu3HBbq+aimdWByAW2yZicBDQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8250

On Wed, Jul 02, 2025 at 11:50:32AM -0600, Alex Williamson wrote:
> On Wed, 2 Jul 2025 13:00:31 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Jun 26, 2025 at 04:56:18PM -0600, Alex Williamson wrote:
> > > @@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> > >  		return -EBUSY;
> > >  	}
> > >  
> > > -	if (pci_is_root_bus(pdev->bus)) {
> > > +	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
> > >  		ret = vfio_assign_device_set(&vdev->vdev, vdev);
> > >  	} else if (!pci_probe_reset_slot(pdev->slot)) {
> > >  		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);  
> > 
> > What about the logic in vfio_pci_dev_set_resettable()?
> 
> IIRC, VFs are going to fail the pci_probe_reset_slot() and
> pci_probe_reset_bus() tests because they don't have a pdev->slot or
> pdev->bus->self respectively.
> 
> > I guess in most cases vfio_pci_dev_set_resettable() == NULL already
> > for VFs since it would be rare that the PFs and VFs are all under
> > VFIO.
> 
> Regardless, the VF will return NULL.

The PF could have returned non-NULL?

> > But it could happen and this would permanently block hot reset? Maybe
> > just mention it in the commit?
> 
> There is no bridge from which to initiate an SBR for a VF, there would
> only be the bridge above the PF.  We require SR-IOV is disabled when
> the PF is opened, so the dev_set of the PF would never have included the
> VFs.

I thought we can turn on SRIOV within VFIO and then attach VFIO to the
VFs which would have included the whole lot in the same dev sset?

> I haven't tried it, but it may be possible to trigger a hot reset
> on a user owned PF while there are open VFs.  If that is possible, I
> wonder if it isn't just a userspace problem though, it doesn't seem
> there's anything fundamentally wrong with it from a vfio perspective.
> The vf-token already indicates at the kernel level that there is
> collaboration between PF and VF userspace drivers.

I think it will disable SRIOV and that will leave something of a
mess. Arguably we should be blocking resets that disable SRIOV inside
vfio?

> I'm not positive on the latter, but AFAIK it's always been the case
> that only FLR is available on VFs and this doesn't change that.  Am I
> still overlooking something that concerns you?  Thanks,

No, it makes sense, it is just not entirely obvious on some of these
details.

I also did not find any locking concerns, so

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

