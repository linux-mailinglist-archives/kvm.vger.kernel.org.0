Return-Path: <kvm+bounces-52923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F886B0A9FA
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 20:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D59C11C80727
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 18:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476582E7F22;
	Fri, 18 Jul 2025 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n62eZz8F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48E680C1C;
	Fri, 18 Jul 2025 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752862193; cv=fail; b=HN+xcCTrhBcFocGE5h7Fr7JjRfo7vfJf394Bw04yC0T3E5fVqOviibiR0w+8qyL9CER864lpOM6wtrlUIJdblZFVokCGd8+jZeb6lKDVj/oRPIPN2ss2HTlk2ii37KmZWWk5x2ZrpeARjjuiJZ070sGsUz4PHJQILBi9kZuaWvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752862193; c=relaxed/simple;
	bh=V5lNPhHuH7aM03Tce+qi6XOvRSNpUrBTw/QjJGEYWbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qvxBx2kOnN6QsGRjJYLnODnLCM/MxN8jZMJwY2hTO7xXBVhVuqsIpnOnNhKTW70cbTQCBoBlMStZkWKwQJSpPLTnl7vtjJXDNpvq835AvwZd1TYDU0krfsarkc0creR8/1rChs9o0KC41SaENXQtkEoKpZ84A5jGsznYcrooju0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n62eZz8F; arc=fail smtp.client-ip=40.107.102.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sl/QbJVRetroALWI71Zl6GwyTpzZTAj8msC47Pb1plfYSCuHQT/QBVCmXak1Py10HRRC/sJSc13u4pQ8Fel4F+g5cDLDvB2DDkSlLikkna6Ks4KLbmJShsJjT0Ad+MnMDk9F3WkvLoz9FUrH9BytXE58uhVFr5avdMNq9PqpZ86XdcMVy18FlX0HziJS1495O5NUc7ODdr4EgMZRVp5noTH/SFcjM8t8jtgrDAYIywxRSgc/6+bCX/3ismHWyHoH8PI9X+zoS8H+H5/9n7AArk72T7qIkvYY9x50igEP43qhkb52M87bDIf90F9vH+Dkeqe++13+FwlG5ZXifTfp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhUdXjsFdtqpK4Il/9f6d28JDHIHm4168xoE0ANfuE4=;
 b=qpwc4v6urWAqh4SWWNyB3gflzu4BVICtO9+FN5mwS2Y0u4kYKrAWxh0gFzcYC228ceBy6LyspvOxqFlli4xQGV7l950WxfCXjsaQ1EhVekr2XmEztvg3eAeanXelVlIyH+QQ6sP/qFFHue/nZ9V1n0laJsIaaZSUVDcW0ZFOyh9kaQ5OBtUZAetusOZgc8Jr//jIKvmuCbZsRRNck6xTNTca6MvnI1y4yIuFmu0a4PlqBmLKRojVwjvC8LuSsouLqNJzN2hrPq05DHHDDpE0vSe83mDmthutLs4uNb5EJ8V3Kg0DAIuUO4MC8IaBHBlV4lhZRnb1wr7EBPvrOE608A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhUdXjsFdtqpK4Il/9f6d28JDHIHm4168xoE0ANfuE4=;
 b=n62eZz8F3A2h2KiSfXEx+S83COm9qfUxM84uvpHDlcqTMho6UIEdzllA1GPcaxBY4LEdzIu5fI4CMRuLCG6RRs3DN5unAchGLT58RMA8GJlW9GC3nlkdVsKQvpC3N4hBSnVjEqeIJ8MiHzsYPM4VBXQrmA4gX1//efePE+XAaw+bj0IfDdVQiYFg8P77UbyC+yZBp8XlsFn9bOy+khOkBrpL3FUVIl67pu2d4or9dJ8iLYQLa0o0qBAFvuUOt+6M9saON+NgTzlYB7TSzdqz1v+9/rc0rO56zVQAGzxidM2vgfBmQ4sE2fPHWWFcd7yQ0YJIqZx5Ya+bDJIL2cKaHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH8PR12MB9766.namprd12.prod.outlook.com (2603:10b6:610:2b6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.27; Fri, 18 Jul
 2025 18:09:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Fri, 18 Jul 2025
 18:09:49 +0000
Date: Fri, 18 Jul 2025 15:09:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 03/16] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250718180947.GB2394663@nvidia.com>
References: <3-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <5b1f12e0-9113-41c4-accb-d8ab755cc7d7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b1f12e0-9113-41c4-accb-d8ab755cc7d7@redhat.com>
X-ClientProxiedBy: BL1PR13CA0387.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH8PR12MB9766:EE_
X-MS-Office365-Filtering-Correlation-Id: 6095689f-f120-4b90-efac-08ddc62648cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ac+/HHEyKp0IcZj0TPCbGzr53mecs9FS4b4QRL0kWqGjhpSeAlgNlsHxfg6+?=
 =?us-ascii?Q?zO9YS5t+52X3Rh2r+FdnbbhxHyMo+gVsnMnK+dMD02TBNcwb9jdM6lESXXeT?=
 =?us-ascii?Q?ti44llQ4WpPu5QqiXGjaEQvdUDA0S8CcmpEXvUO4bE8DZd/KpA4pfpLfknVo?=
 =?us-ascii?Q?2K8BYQAklprZtnjWBPWUvmDwWWTN5eH80/SAAtQ24d9Czz73nmb19vFhRUfv?=
 =?us-ascii?Q?fVuXVyNMEVDr4Je9v2lVMiAripXbrltohp9Kk7wSaEla3VpCEYhuV5jOZXNl?=
 =?us-ascii?Q?dSfNAfRNU+swLwbDeEa9UgIHwe4SuyYWG9bsLCZR9jqybw7bEb0DVNdWjQcT?=
 =?us-ascii?Q?7r+uaF/vDVuurdGZMEKHBftsojMDutBe5jZPTz6Z5L1MAk9hbG5Y9bcPXG0d?=
 =?us-ascii?Q?owrvujlr4DaA//4LR58i3xmc/uzTF57CaJw/5jxIOdDmJS9I4at927mOhwTY?=
 =?us-ascii?Q?YLO0v2xEA+8u4iqGvxKQJlEbTu0lgmmOkbOnG0v0Yq/2zSEs48/F6INTqg8v?=
 =?us-ascii?Q?JqKXYE2t6WH5bUltD86mv+/uCVfl7NUe7/nTA/cHZIsXgm/+BYh4wV2mNwwc?=
 =?us-ascii?Q?tPXKNLkI1ey+fLUCGOtqLSdmCQsDI7Rs3wJ6XzZ+O/RUrOkmLjgYG6xuoATS?=
 =?us-ascii?Q?RSfkOROc9Q9njpqaimahFYZLEiy+feVa4LGoNOnHIfXWelO8cyZtg6QXVsc2?=
 =?us-ascii?Q?OsJIlqGle+KPyKx0iKcRv56h3ccyTr6MgmjZRPevrJogaPA2XFgU4nUXnCk5?=
 =?us-ascii?Q?8dZkH6zAKV8dG682opFARBKV1Do8NUkaxOxglg2SyFVSQqFnDFwSpUlww05Y?=
 =?us-ascii?Q?skCwgKsf4kOs6W+BVVeAeb+McU7ggRDcOdiul57L3CW/rHl9hkZflenjdPyv?=
 =?us-ascii?Q?+bZfG5Gv80dzAn57pW0MNkd719CKKcX1tlIV1d++ZDLzPpNUs9EjByg17IwB?=
 =?us-ascii?Q?DZJjR6GHHxiY5gwb9xY36AGvOs6xzzC3a5xyCj2tT6/yBCsZ7YpHBLbNHoKn?=
 =?us-ascii?Q?jyFrPJWm/kYG/29eZ/EXUjoOI85p/1BnkmCP722RgFcnxqrlBf0XIdLy2j0f?=
 =?us-ascii?Q?uKeFQ/FvtJVe9qErHjC2PSmTO4gXHvA9Uw7YjdNiFbPhm+IV7jW07aUfsAev?=
 =?us-ascii?Q?J4ZZz62+OYtymtLXKNRXbh8WTk3AlS4neZdbLTF2evhTxtMuDbjgM+ArVN0Y?=
 =?us-ascii?Q?Yr7exEDDjVkGsNErSbeSFl17TFkR1ftqZCgbe5bwSNoQDXWj84J9swLSVQli?=
 =?us-ascii?Q?GbxONufMNTr5sz29hA7HD33ZwNAlbjBiNfMrepDN1ROx1voLLJTftyjX6nGr?=
 =?us-ascii?Q?BBBB29PAbKCSKiolNYv2GTwHPJF/R6CUdNtlQr5Y8O3hW5yGUyaBDuIumssr?=
 =?us-ascii?Q?XW9rdH+IRXIqBjpDy6FoAiYrLCoDuqu7cb5xRW5+9+bqIGX5h4DXl9yo79D4?=
 =?us-ascii?Q?CjjfFvJiHmA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zqy0zbcq3Hgv+Nf6uQV99dtZ4k8brGwoRQHdAl6N0pgNTrRpmYBm2DlLRpPS?=
 =?us-ascii?Q?B7pTbZVZoXvbAUj68HjRXWnRqjSsO4geLs5CerBLJ8fOwJcdn2MWVZgsvJpr?=
 =?us-ascii?Q?fTQyC/ScfpAIful1Xwt80IZB0SIHSxLARSuqz1Yjrv5zIE75iKlNH52S6LO/?=
 =?us-ascii?Q?HWl/vWgJ19Y3WslhAy429rjJT1jhMpohj6I6BFiclUOkW2j30SKUIhxOo8MK?=
 =?us-ascii?Q?e9iHQrCAcJ8eMsBk25jgyYWVtUeEJM5A7GLzTwX7CmCLvy0Ysc1hjaQmCc4s?=
 =?us-ascii?Q?uXBsbEGMuirGtHQtgkPBDNRsVjriF/wUrAgSW+w5EznScwQAsUgyTNbaItCS?=
 =?us-ascii?Q?WG9AJObKo9cRKt1DF5pz/oS6NoDIY0ZgfqgmILHjbyIi0d8guKAB07AZLmAY?=
 =?us-ascii?Q?upXSsxpbQDFsP2l97cI/3UNCV8k/MniQxKZ3aOvImIre7pEMCO73fVf91otX?=
 =?us-ascii?Q?1sVJGhzT78cGnEr5+Hr7CzpU9VZ70TGQzbC7eBU0dXYpU+XdDTWUcxbk/YaZ?=
 =?us-ascii?Q?zIGBMGdTCelXD0A0Yt5mO1SKczUbcDSNYtG05GIqpAZawljb17lULRUwGgC2?=
 =?us-ascii?Q?yXmj+ROyWilCtf/W7lFlaqYBq8wG5LmsSlHjoNHqAeDaSQYCjw7rm4ujz93R?=
 =?us-ascii?Q?vZNLZKWGJ5RG2TnacVYFxQHS8DUHp5YPmU06IVs3ir+u2B5JPoVJNvPwjfvB?=
 =?us-ascii?Q?cktv13HYcd9zeyKQ6vKDs5emZv/zAtKz8BlXhMq2dYXRLJcjwSD748+yDrDh?=
 =?us-ascii?Q?RugIxISxzSW6o4IS6Q4f6TjJIT9T+pBwPGtqHMKkAmMXnXbFHjG26jCitDVt?=
 =?us-ascii?Q?i1CDtVMQ6RbSA/xBWjZeGKqpnRfBMA3QN0oncee/CYojEp0wt9AE2gDbiBBR?=
 =?us-ascii?Q?Axc2uwvYMh/TiDUpGmH7/EoAK3/o9MDDCxDUDJXmG5MShAPNXrCPczVcZEfY?=
 =?us-ascii?Q?UdSRP1ZonJcrEse3XhKmCdGO9ZxPheJCuMcrjg6Y3OXO6orMR/AuFzjBxq7o?=
 =?us-ascii?Q?nOqAE7z6ycE1r2zm9Ihr404jeNYakXXAMnh6LKLpNmnLy/vGKU4voy1O5iuS?=
 =?us-ascii?Q?LeMH9Vanzp9JhFXJomAHEm8RAmKJpfTRucdF9EYrRtuNW68MAwynnLcQZyIo?=
 =?us-ascii?Q?JlCWpmKgetmEphVr7vbqo4bbbpQU7qh+y0+yQINVCgqYyNz8WxOu6OVKlBUg?=
 =?us-ascii?Q?ePIKm2FUPQ6NE1nncx/FDur5aYEAztT3DaVnzZdd7j9+xFygZEgNNlL8HMOr?=
 =?us-ascii?Q?NTx+54cmJcveyiMcXJMx1hKMeDXQOn5LHSgpgAWw9wFRc1gc0z7OG7l4EPe0?=
 =?us-ascii?Q?52t9kUMLpNE/ZTxmNOyq9gm6zvtu5JqeAr6mMQl5JNMPKs/aLyy0jNl2IVNn?=
 =?us-ascii?Q?4z9XfFx+jeAaNrAjMImV70QfMCOF4PvnPmHSUueQCR0la6/7nyxFEN/N8ynK?=
 =?us-ascii?Q?Ma7KzzPhJWS5ZPD5nQccrMFdSLN/8O/uYfEA8BvjcdyUqnViLVtVivpipOcc?=
 =?us-ascii?Q?NuVeqlWOK99gDGgEhw6cyqtRrpuLzH6zT8Yd2j0yxePfhsePEGhbhC+Vfx85?=
 =?us-ascii?Q?5SzHW2V+YbDugdx1/nmm0ZIBvbOm8LKDAerzZ4Kb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6095689f-f120-4b90-efac-08ddc62648cb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 18:09:49.0771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZVrXl3qbomrJWR0pXoRvDcsi+ospjo7lY2TIGTNBlHlgBNSow/SL7Tr5V8fb9eJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9766

On Thu, Jul 17, 2025 at 06:03:42PM -0400, Donald Dutile wrote:
> > +static struct iommu_group *pci_get_alias_group(struct pci_dev *pdev)
> So, the former pci_device_group() is completely re-written below,
> and what it use to do is renamed pci_get_alias_group(), which shouldn't be
> (easily) confused with ...
> 
> > +{
> > +	struct iommu_group *group;
> > +	DECLARE_BITMAP(devfns, 256) = {};
> >   	/*
> >   	 * Look for existing groups on device aliases.  If we alias another
> >   	 * device or another device aliases us, use the same group.
> >   	 */
> > -	group = get_pci_alias_group(pdev, (unsigned long *)devfns);
> > +	group = get_pci_alias_group(pdev, devfns);
> ... get_pci_alias_group() ?
> 
> ... and it's only used for PCIe case below (in pci_device_group), so
> should it be named 'pcie_get_alias_group()' ?

Well, the naming is alot better after this is reworked with the
reachable set patch and these two functions are removed.

But even then I guess it is not a great name.

How about:

/*
 * Return a group if the function has isolation restrictions related to
 * aliases or MFD ACS.
 */
static struct iommu_group *pci_get_function_group(struct pci_dev *pdev)
{

> > +static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
> although static, could you provide a function description for its purpose ?

/* Return a group if the upstream hierarchy has isolation restrictions. */

> > +	/*
> > +	 * !self is only for SRIOV virtual busses which should have been
> > +	 * excluded above.
> by pci_is_root_bus() ?? -- that checks if bus->parent exists...
> not sure how that excludes the case of !bus->self ...

Should be this:

	/*
	 * !self is only for SRIOV virtual busses which should have been
	 * excluded by pci_physfn()
	 */
	if (WARN_ON(!bus->self))

> > +	 */
> > +	if (WARN_ON(!bus->self))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	group = iommu_group_get(&bus->self->dev);
> > +	if (!group) {
> > +		/*
> > +		 * If the upstream bridge needs the same group as pdev then
> > +		 * there is no way for it's pci_device_group() to discover it.
> > +		 */
> > +		dev_err(&pdev->dev,
> > +			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
> > +			pci_name(bus->self));
> > +		return ERR_PTR(-EPROBE_DEFER);
> > +	}
> > +	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
> > +		return group;
> > +	iommu_group_put(group);
> > +	return NULL;
> ... and w/o the function description, I don't follow:
> -- rtn an iommu-group if it has NON_ISOLATED property ... but rtn null if all devices below it are isolated?

Yes. For all these internal functions non null means we found a group
to join, NULL means to keep checking isolation rules.

Thanks,
Jason

