Return-Path: <kvm+bounces-51530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E239AF840C
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 01:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBA5D1C858BA
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 23:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8862DA774;
	Thu,  3 Jul 2025 23:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jt6Df+l9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F02D46C3;
	Thu,  3 Jul 2025 23:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584895; cv=fail; b=EtUBAtMW5e8b6W3XzQAeH4QXkJp/tto3gWHDgPEjtUfCKx3hkhG/pe6WNkohlr8bFh3dGg6O/Xk5UDBVgfivzRM4BoGeea9cdIYRK0JwpJ4/DosutXXBaVOgrjcji5mwmfyW3VcNolmeX94VFKp9Got8FP29R9s7Z5WyQWjLkbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584895; c=relaxed/simple;
	bh=f60C9v1rLUM9CJ5am40yMkMVI6XV2mBeGx7A0UEU2rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kaFCyAVini3tZ1FmzNg/jd4ul2ZDoPpAqJsZz0xf0yX+TNuZgPnvUL1tD0I85hkrVuEeV91nnIPdEpIvtVHdpxa5gGcZq4T0PE+5c0/txMTZpS+ZDhnb1l/GzGaFNlRllyOfioIHwU1E6iZPtSCRPMENqxym2ZzX0Xev7xfcrEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jt6Df+l9; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q92JSs19tRL65hZItPgGExQAo9GoQm9EHls2xS/p7kEyiWaVVKuVBngPSYFXXOK7wH+UywpUptOBucpZCKZiuIMaOvsNLCmbuBOw0DBVLYeGBfJectJcsh0A1yQJsvynUfbIvL/WaDS6P7E/EtvAqyGzVjEY+I7CxDUMbaVgih9XuC91aSJgVJ9J9Eq1hyAjtI+wzANvYLN6vvGwlG3CS5eyw+Wn6oMoPk1n1QvmlAEsEfz7lyw98uB/PE2oVITlxY2h/i0Wx0R2Cly8eT4FIMJJb70ohgBUJ81vHojCPAA5OlIqc1gQCPRPKNawJHeH4HCSLF3gV/3j8LWPvwLBUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cype1H2Ht/IMKnCQLhDGh1zz0OROd7itlYr4MSjnFHg=;
 b=SjJtz+vOEfj2dLx/0el9RBsD9TVC2x2Ua+bZLSHkTFQxbIvabAV1NMHT5u8Iqw+jFeUdRgc+F2WKd71DnkvoyHGOMD/VLtH6SbN60EYVMQLl+kyMKjgRnilOgDjdKJlL+8Lv9SOXFmS6uiBuqR6HFqnV5FgcwM9mWJFN7XFXontHvRL+cEkEpqFAPEHvwGVSmTrQjSbr6O5+lAdg/6/uGoJjIrfSUB2eAFzvb2gwhkdC6f2gigeY4dc5qpE75ptUvdiyjQkmSBZsxc24Y9YGvTCdgOlerZfIkGDVIER3Mb+6Js6TQfUZCM/qBjltkTbe7osR6WhN0A6g83p0id+DXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cype1H2Ht/IMKnCQLhDGh1zz0OROd7itlYr4MSjnFHg=;
 b=Jt6Df+l9B/JgD/lzrf1TGO8iLE7Tm7leRteMVVWYcIRZwhqEAWW4CUFkSd6NPbEWqdiFqWA+Yjq6025+M946kGqmG+EC66z+ICkEJykN8y2lxTh0tJZMF9YiFw9vIZ1U2Ork7p8RZ/+4PF0TsETJd7QxcClR7jJjJ8pV5Hx7F22ZM8vGq20FhMXMGQ2W2yU7CfMxQpzbjuM+hgOcFe8Ckn5aosLBPoISIZWUzuve7ER+qTm2LwBwT/acvrhCiVincT2xqdRAEtzpIUR7OnezNpKNtSw4Tm9cHopVqn1WZihcVlq2mh8MkFBwEDy2C7/ShQUPrY52f9fCi9qkc9C+Kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB6837.namprd12.prod.outlook.com (2603:10b6:806:267::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Thu, 3 Jul
 2025 23:21:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Thu, 3 Jul 2025
 23:21:28 +0000
Date: Thu, 3 Jul 2025 20:21:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 02/11] PCI: Add pci_bus_isolation()
Message-ID: <20250703232126.GH1209783@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132859.2a6661a7.alex.williamson@redhat.com>
 <20250703153030.GA1322329@nvidia.com>
 <20250703161727.09316904.alex.williamson@redhat.com>
 <20250703170846.2aa614d1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703170846.2aa614d1.alex.williamson@redhat.com>
X-ClientProxiedBy: SN7P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: 57f7105f-fe8d-4779-2956-08ddba885646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ctEbD0UzAuSOdTJBJe7qCQ1DG1HXFUIYpH/73MbsMKyNpJ4C361l+0GxRXm4?=
 =?us-ascii?Q?RK2LjRg8IWMm37BHrEPh4qoGZb+rv82EhyEP6U0JgaVm/9LLGB9yh2K5Oyss?=
 =?us-ascii?Q?eEiFVe0MBk81qONaAxCT3/fJK2oJYoD+HgsMK5O7Z3RvG/fBmsSWqE6C9awk?=
 =?us-ascii?Q?v5QqPfwPu/YZ297aguTBECwSholw58wsGJe3lV9doMghWqzDWhX4Kk5PVf1B?=
 =?us-ascii?Q?0WUMKVW5f9sLO3jDuVmlDZURoSlIQreemUtd68XiLjK0Q9hi7uEcgArIWvAW?=
 =?us-ascii?Q?KdHk9TbHa8dtQEmDwr1F6DQPHsnb/GOSGbYICWEuJGqqxMPN+ir+iPbub3ar?=
 =?us-ascii?Q?1w7on/PHpPFxRxMC6aX1H5Q0Rus6KN5AcOtIEgcONzjCRoi771fswrP8a9Pn?=
 =?us-ascii?Q?UHPGmwaZ1HC20UyfiWcpCTN2QRDw3Tev5N5T29X6c0x5Hm58L/ZHV3lF2p+T?=
 =?us-ascii?Q?+AyTpSTg/eQF8x1KzpRbuizXJtux7PWQ6HefqaEfw9hPrmUOnEOkwg3Og1gZ?=
 =?us-ascii?Q?eq1xMnjxi05r9zrQ3wnskqSK89wtOsidndD2d4zocBPBotN6V7tUt9r4nGf+?=
 =?us-ascii?Q?/qCMMaJHvnZSzWnpHo7fijk+32WvHEqJm8UQWCNKcFQ0Ve+5POM0TzoVdc/e?=
 =?us-ascii?Q?RnRgotYIoYGmcJKNTFtAUUtk9X9A/Tt9Cb+3MrbYYDHZ9cbsURCoeJNxX9wP?=
 =?us-ascii?Q?PCMb110GKTQzLmL7dTGxwY7zgSe3oosleVjf8N3wN0ZhkqnB0eFvs4ri7JmC?=
 =?us-ascii?Q?FlhUZQPg827mi3/vymZHumWDcgFoubTuD4LE5CfCPahlO9Kcgr5xTb7+V1xT?=
 =?us-ascii?Q?HZTlbjszOX58w0is3h348r8cIpeXSkPOeY9+C7KDmGpQXpqnmxpOu29Htmr9?=
 =?us-ascii?Q?HwWwxS+hJfm1ZeGkCH37aPK553xIti2xNymvai9vMhnFBkVtLIUpvmqGdEjU?=
 =?us-ascii?Q?QtNfTsqnwwZmtqeqrtdCnCWk00Y9L2drvRc7DcNWtXyxfm5kdZcOJ8AXPNel?=
 =?us-ascii?Q?+HcdAUGoGI5wyl2lLog/sk4gcIIdMOcEpHuxI4VdnZGWG8kxqI5py1NeFqgQ?=
 =?us-ascii?Q?N12SMazTAr7jhNGycurzQGY6ybbXYsPr3G4JmRQKnXdp83Ti/GY8/wFgd9JU?=
 =?us-ascii?Q?/kAAYmxBCWHkSjAWhBA8g4pOqjDX19UCNDoL3jXqHXwYDgPuwybH6R5DCyhy?=
 =?us-ascii?Q?UmBzMlwJPKxudc59TU1DJP7HlEaNQtf5DCIiRQuZSNk3ekjwDQniaedMgTxG?=
 =?us-ascii?Q?QrpYDk5xNCTwO4yXwGM1MkihUklErbhkq1MvmRcw5f9R/UHVXFFx/aGBYYsc?=
 =?us-ascii?Q?VzcLMoTSyGNBo4AcI7ZgV/f5+nzwkQwtcFbwDFaoUcahA53UK/8vNrBwd6o9?=
 =?us-ascii?Q?Rg4+alURl/j+xkf1C7V2oBnqsKI2ddGJUMFnnNLBfX0zMZP/V8HJrkHqD0dI?=
 =?us-ascii?Q?q4hMuPC+CSg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wer1eo43jrHs+6v3nebyDJqW9TesC+l0Vnz1C8z0q83GhmXFJyVLJlevpv/K?=
 =?us-ascii?Q?Fw6Gw484XcO+6QF229DlYDvkOODATe9mk4o4W4QuFuNGb82/9ygp5+cVVImB?=
 =?us-ascii?Q?4Vb1kHpB6N9s5zHexMsrjwRI6kMFNZq/zfSNL4m42xb5Utnx2XX24zSLGNha?=
 =?us-ascii?Q?WwG4NFgNNZT6jQE9jW9tDS8z4vqgZSi/QgTxmXXjCsdbsUFZyT7SmOi6NwFF?=
 =?us-ascii?Q?P15psnSRtuRNq4lcqe045n1T7q7sLgVJjZ2mTchJTUoj6M+ZVtkBOCKVbwnW?=
 =?us-ascii?Q?Ne51jc1EI7hWdQCdwvxhytHCb4fZhabgYwBpYJy7DMKYF6Pg1+a3K/jc3nqv?=
 =?us-ascii?Q?BrPRv07GTC5VW/B4agabmWIpIhlOi0MM5EpJa8HDRR+gA3yziDx6ZmB3miKY?=
 =?us-ascii?Q?eh1srDoRh862HF3FaIJY0IA8mTT5ZBhQhdzM2MzsD9W6JxuhgnRd5SUJDUg2?=
 =?us-ascii?Q?1iJJ3d7/bsXVKG7HKBP9MysAYSN7PhLhLjiwPDFzBL1I3wIJ3aWRvL9mM5PR?=
 =?us-ascii?Q?pdEYSITyysgj9CO1qBHNUcTADwOCHtSE2RU6wIYSAqP8BjR/FXj3aoirKSl7?=
 =?us-ascii?Q?0nRgI4JFkiuIp+SJKjBV5zqX2cyripCjfhosAqMgTHihb8D/2hVoTxmpbxFe?=
 =?us-ascii?Q?CQdDQmVZml50Zo/woNBFg1+t13SfjQIIrX8QQpclCgDJr9s6VovSX/86qcW0?=
 =?us-ascii?Q?hRmpT7LMyoSLDJUrCBagQexUWe6pX98PYAvXA9PyyAt5vbSzRNt7hX0guBWG?=
 =?us-ascii?Q?cvpJHv9m+KcnU9JXvt3901/PWjnYsge4GKSWiescsVEYs0dJ4M5KfqeJuXjF?=
 =?us-ascii?Q?y2XVGA0y73C6NYGakpc8AAUUHSKTbjqI4YKseqyK9axsczX5LGKzYfaB7P2n?=
 =?us-ascii?Q?HK8AMFttPJrj1VCmeq0H+xoApY3tBzpn8Le8S7SasTFgrc3q/d0W2VJgzeb9?=
 =?us-ascii?Q?C3cXquUAMJQy0tgQlATO3bI1RoSecoLuKyXAghgEbZ5cQZXBotdPB7JnDhLq?=
 =?us-ascii?Q?3Fo1eS/rmfeS6xLeSoIukq30m/RjqnkjryLblRyJNKGSCXp+MCF08KeBdVfn?=
 =?us-ascii?Q?+JS+PuPyCKeqIFTBIWEFXQdP64zZA/Q0SAeMb6+WdWc8JqqHYSFJU89bV6Mt?=
 =?us-ascii?Q?9wTnT62bl3UpUbJd6MohPVUlg3rlikzeIlhdLkoUULxzRl8ieA6VH5pe0rcN?=
 =?us-ascii?Q?mYvCqeXst23HgorW2jhGhXulAfMVbgInFSZACIh987bM0cVW3l1r7MLZps2m?=
 =?us-ascii?Q?BWcKdbcCZ5hk4o02lD0ME/KGQs6zEAFGyzr21acIWs7Csa9WfsH4U5CwV5u1?=
 =?us-ascii?Q?DmLIMpC9A2i/VkwVJLom6ccXODU6d7uTmHD93TwPfCXGERwFlm+18LGeK7F1?=
 =?us-ascii?Q?QgiMFYPjj/zeZuwN+LE7Vehk58840TqOk2moGqseSb4lQLogkrOZ4rE8fX33?=
 =?us-ascii?Q?bJWzGfkW/3x7pywiE9JqjO3EpsxXLUArKoZDVCOYwhhS4kiIeyN0l6gwW6+4?=
 =?us-ascii?Q?pHzqG+iWHkyjrXxoIsz35Un435QDlpiGVxD5HnKTXnFQ9qV0wYQj+Nayu92i?=
 =?us-ascii?Q?0CIuimz5WF6N/bHCM68xSX1eVpHPL5FsnuTbY74c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f7105f-fe8d-4779-2956-08ddba885646
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 23:21:28.5096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyrKKarDLMcf4HoTh6L10EZU8XT4JgAsI83EKdcPkMMmhWhmtCNOqyDzSLv+kawx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6837

On Thu, Jul 03, 2025 at 05:08:46PM -0600, Alex Williamson wrote:
> BTW, spec 6.0.1, section 6.12:
> 
>   For ACS requirements, single-Function devices that are SR-IOV capable
>   must be handled as if they were Multi-Function Devices, since they
>   essentially behave as Multi-Function Devices after their Virtual
>   Functions (VFs) are enabled.
> 
> Also, section 7.7.11:
> 
>   If an SR-IOV Capable Device other than one in a Root Complex
>   implements internal peer-to-peer transactions, ACS is required, and
>   ACS P2P Egress Control must be supported.

Oh, I haven't seen that one yet..

> The latter says to me that a non root complex SR-IOV device that does
> not implement ACS does not implement internal p2p routing.  

Great

> OTOH, the former seems to suggest that we need to consider VFs as
> peers of the PF

Yes, I think both are saying that. 7.7.11 talks about "internal
peer-to-peer transactions" which is exactly what ACS for a MFD is
about.

So it seems VF to VF is possible through internal transactions.

> maybe even governed by ACS on the PF, relative to
> MF routing.  

But here I think it is not clear - does the ACS of the PF globally
control all the VFs or should each VF have its own ACS in addition to
the PF?

The latter is certainly more useful, especially if the egress control
feature is used.

Let me ask some expert people what they know.

Thanks,
Jason

