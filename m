Return-Path: <kvm+bounces-52935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CA1B0AC5B
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 00:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 987C27BBB44
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 22:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812D8226173;
	Fri, 18 Jul 2025 22:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LIvCHGUr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E8918D643;
	Fri, 18 Jul 2025 22:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752879176; cv=fail; b=onu5jJngJbbRyKWLa50IUIilLwxGy77L9ViPvEw+2U+f32HW3qfxfXe+5Y9UBLR798FNW2ZipiBObC1b3q812FeoktO5uFnj8SnBkZqTroW/oSinJouiuFRU+v3yYY3ND7NhcI0VfF3d9NT0deYa/iwJSMweoclMdJvk6EUGb5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752879176; c=relaxed/simple;
	bh=mkgl5SUQy+bOaTQgItUFs168gZsD83TVbbg4vV7S01k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hh5Xd0EKZaRdoyF+iL0Bet10pjL5pcVteZBr4vndJe9PC00kafOYDkGGlN1INcoexeCurGYlE1Zn2UnTns/5Pxhv9Lz9mWtZhDF2/0Jw6XCJMPQJ5S7mpLV2ivLjWKSuVRvhQliX8F9kWtHAM1aLAiBKgWzBE5mQ/J2r4dvre5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LIvCHGUr; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=erq131FobmSjek3TktFPLcMKn+qBWCVMnpjUgFbGcvxb0ZwIFRnwfQwS8algys848BoOVyt/vMTJU+Eby5UnUK3X6OSrhgyUmKDxBw1/3soU7rzvG/GJRscAKPqHMKfncNYnH8yhw/wGIINHl/2T5QfV9yCnBc6SlM6K4CJkjblCxvO5EwmRQh2iakmjW1mIH+9PDsg6kBTElvIfIIrBp/koZD5bMESSaT2FOr+2RWW14cqnu7c2hpYh7l8pCRWkarROY9FDZBWJMpLjpySq9oJWdEKd2pTxHf9MUfJeXw3OhKg65TlQAivQBesV9dM1IU0FsYQQN8teqHp/q10Lwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXjk5Pe0pFU5rfdOhMSiwPVybQX/XCl230Ir3XNVpjo=;
 b=wT5HqyYQkfYcEXqVHiC+Rgr2kWnXtauDIcgNZZc3bbYEgPp9yPyT6c8xNEBz8tuQ87HmNmi8C/YTN0BoWnTLXR7K/ofQq+Mdrj24uhb8vIICI8iATPTde4Cf1Je6fTxfUyziJ4gZQtJkBPjudLdpolJ8bPfiBETNPNp611xNtsWvB6ajwcgB474VVv3plVeVXtKapVMH4d1WVPwGPv2G+uTl3DxlRN858DVyd4b6Upv8LM4nnvJAD1/RtptyMYBA0Zt5+AuCzkUGd2OOv5OE5Sg1v8lCetxQHnfqW7t/dyWsE+BS8Ids2ns++28F4jq5e7cGfFZochxtIymSyh5Wmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXjk5Pe0pFU5rfdOhMSiwPVybQX/XCl230Ir3XNVpjo=;
 b=LIvCHGUr8vuqilabHoEL160Wvp4oxU3OH+l/wKsx2kjdeWSYnCj8qxrFf//GJl+q8b/6UPYdrEg8ufc+kr2CYgdxMOZniNwC2mmu5LeDEIq1jzNBCCDSd7W+rBlxs2o8/6B+Lj9cRlOmIRfa9oF8Q8A4jTWqKZCtq36REoUaqBL+Wo4jFIz4/18HfJYv4PYD7tjNsm3TiIB3EmX7vZi2DtFb4rcl0ZzmgKOCcUeprnce3LxWW2X2Q83rt4LzFcYswq6frZzcjOLKLg5w5zO2FOd+zv57uyy3Wbev0sCR2mAhcjL6C09SroznlQESxEdGWEFUh4otdalovJemwPluMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CYYPR12MB8890.namprd12.prod.outlook.com (2603:10b6:930:c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 18 Jul
 2025 22:52:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Fri, 18 Jul 2025
 22:52:50 +0000
Date: Fri, 18 Jul 2025 19:52:48 -0300
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
Message-ID: <20250718225248.GK2250220@nvidia.com>
References: <3-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <5b1f12e0-9113-41c4-accb-d8ab755cc7d7@redhat.com>
 <20250718180947.GB2394663@nvidia.com>
 <1b47ede0-bd64-46b4-a24f-4b01bbdd9710@redhat.com>
 <20250718201953.GI2250220@nvidia.com>
 <1cda6f16-fb56-450e-8d33-b775f57ae949@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cda6f16-fb56-450e-8d33-b775f57ae949@redhat.com>
X-ClientProxiedBy: BLAPR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:335::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CYYPR12MB8890:EE_
X-MS-Office365-Filtering-Correlation-Id: b71d88c0-97ec-420d-d06e-08ddc64dd23b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Sh8uvoTndKxidtmr3nzy/FrzV1+WYNxsgH+UjbG91iDVmU+FRvf+11YDyC67?=
 =?us-ascii?Q?C6CKUQQSI0hDC95MaESh1iaY5iYHiOBayiaPYsJxf3KRB/4/eBkD6nCKSMfs?=
 =?us-ascii?Q?Jt+pGInCvKmkLhvIGdmtTIkKmENvlu16vBhKDArUQh236QewqLDG9bg8n5P+?=
 =?us-ascii?Q?yMixVbnORv41qncRfTV65GtQZibmnNqUK5fVnork2+gdjJQChhihcUmBP3Pi?=
 =?us-ascii?Q?lrGYkDeRKA+BRRczhMoMoZuPnY6YDnGSkxXVk9xaMlq4iJw2l4qkgX3owQgh?=
 =?us-ascii?Q?mHfJV8PbCoY9kkHbnAvupYrgiTIFSFt+59uTTSasxfOCWdEus/3Zva32hc13?=
 =?us-ascii?Q?WSu6F/DkHv1JNAk8joGGKwjE29uGmLdtzUohmoizT6lSOOlNQjAOYlrKNVpQ?=
 =?us-ascii?Q?1Oa9OkqrP9bWjTL4YBsxb3wW6iCjRj6DtzafEVJ+HH32ZQ9r8QXJ7POmOkji?=
 =?us-ascii?Q?RnW9RSdQ9VRgW/46lyPe8uagtzL9YzrQ0pfkjT/aYufzVN2emY//hOqSvPR+?=
 =?us-ascii?Q?Mm8nzggrxQ/XsNYvQ3T5vqxXghdYIWnR40Xhu3IGgtj+1nRJ+We+dY5r7KLc?=
 =?us-ascii?Q?lrTGuFbt7+VbCzS7G8g0pQgeQdoxfo0fdRWwrdlt9CiWA/puDk2S3ydYfUhi?=
 =?us-ascii?Q?JoXZLLcN9SyxxWMdGeDIvE5zINSE4sGQcmPQQZVQ9ro9DkHoA4fVX6foJeXK?=
 =?us-ascii?Q?G25mmFVXZgqiJMal6TTTy63A9EWlK1cqKPOkDNefYEB09+ncDcLJK7l3JW3l?=
 =?us-ascii?Q?+go/1LFfOdLyf+ZFjKoucRm8j623UgI3d31LcduKIX85ezKMOlBxiiva75cP?=
 =?us-ascii?Q?Zc7QMnW0qrPa9l5mh41Mjfbf9smbMZi2uKTKKV7MX24fBfxk+KShUh7jjxaW?=
 =?us-ascii?Q?QS5HrI/lHr01nfJnHc1IGRC+7LO85dM/v0Agu5YRt+q6NsqALQoCMTT2dVUS?=
 =?us-ascii?Q?Vg1Nj757XOIwcgEUvpQoVYvBpGpR1zYLgjVgmg2zXCAL2l3GU+Xa14NJPZQS?=
 =?us-ascii?Q?HsHPU5TOaaS/sTupU3nInNs9r1fOwS/9PNzAt3tNIVda26B5gN6Z6fn8e4G0?=
 =?us-ascii?Q?FxTWMLn+GZI5MM3dUM3B2hpmdL0FiZDiy+ngyCbczTJwNpucXe02ssqBKCQr?=
 =?us-ascii?Q?xIBfQObLqj30jMEINzzwJ/Yriadc/xfAN3Go/joKUQ4ZFvH9PymNkg2fpdoK?=
 =?us-ascii?Q?RsZyPyqFKWe+yFKuGhXPJI1QmU+onQUncPJQ65iz/o65Y3OR/UU3U6f79jIa?=
 =?us-ascii?Q?o4+bBoAWOGOrlVnHfqQJBZ7I67fg/a9QrVjElxPv3MNnqsa94lqFx7WxG4ty?=
 =?us-ascii?Q?418tZv15v+uiGArUP0afDEUTjb4cIttEDBIom4kse7VhAGeWLJjgKorfdub1?=
 =?us-ascii?Q?bcGSBnEP/+9RFLQOB37YLytfKsHwpZTvGFmDWEHoeBzUWjhwAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XfYBKIgv8Gs94UA0RQWRyyUN15F1lEjqqe41pDu/qrjsfNgs3ZVLBqvdq1Fu?=
 =?us-ascii?Q?go8SaOOJgXbJkZCcMnwa2UbzqwS8yldMTrFyCXlGmSZnw/WEfAQ/R1LRENLg?=
 =?us-ascii?Q?aCZu91uf3qf5iOYhKiD0/2vHZwdUc1RKMNEJlNRKvG05a8IXbLQuaZpVMaAC?=
 =?us-ascii?Q?DCkVJ5nFyU6qOzCm7jiRmEdUJJe9locOCkC/UZsa0rKuWMsCvom9cIiqkTYr?=
 =?us-ascii?Q?w1AbC0EHjHjM2lQUlAB88SJA4xWiepQlZhPkSTyrXW2HH1u7TvmkM9VrHRLd?=
 =?us-ascii?Q?CSFojBVzUgzuK1xpwduv9fv0AugF42/krXJ0pQErf0Gol2OCG/frU5hCj4V9?=
 =?us-ascii?Q?n9wQBdEd1dRy/6+UczoxduMKIxzDyOCFTTJWWrFPqH+4bXVff8/BDuBNaMYs?=
 =?us-ascii?Q?QEZSXVXYdjX0geY+Hsf6Dt6P5mjNfJe+E9tftP/ZEXRyek027lqhNLLQLxaN?=
 =?us-ascii?Q?Tgy4qV5f/aJbuGLwd5inORanDp3oKswupusv6E5mL/cUK3EietLJykvHbrya?=
 =?us-ascii?Q?pgDHulm4LxgWZSX7hbQvNoWPUbjdk3TEu4bsCg8rPofpy+0/mIx6JKP5oPBX?=
 =?us-ascii?Q?jAhZFRGlUFbOryml4bvUKqeOMeNAhTTaIbkT46ioqfGBR3Dz0bAsE2K429pR?=
 =?us-ascii?Q?DgrSAqu/Ov1ZA0KZfWJhKfijUbeq1R8ZuqAVvf5xtuJ7IBZRk/rj3j0V8toQ?=
 =?us-ascii?Q?MAgeJmzJE0gegXHVyXpkM++4tuMkUmbyS2AwTXIGAw1oGuI4tgmB9JWMRJ+E?=
 =?us-ascii?Q?3VY27ymfxjW755QPY9vDS18zgcIdP+jDa97dyYu0uoNZfCaRkqyDX2XsUbU7?=
 =?us-ascii?Q?eMw6tHnrw533+KCbPfWYglR2UcKUm5cw30Xj9Y5stYWOidDAl/fo+FBNgAHN?=
 =?us-ascii?Q?2IKNdHuVM69EZAYoEdQ8qhZyLhcsGAi3ZPsrKfCd8jK8tUXBq/ZzLl1yT9Lv?=
 =?us-ascii?Q?wTdQubeSLl1Wu7+fwQ7yordFTxyFyNBrnDJV2cshkI7tmkJpXGL7YwNAqKvA?=
 =?us-ascii?Q?XtVBzRG8l8ig0z9lb2izyslTa/nWnI3qadVwGpg0zVP3R6LResxiUmIvJmns?=
 =?us-ascii?Q?mBiXbNk13yMYEvGruzZFXO7FV4DP2E4Tow1T5EBGKo3vUkIcz+r7gSxpzgNW?=
 =?us-ascii?Q?x42ZA7gNx6FODrM9cL/J+GITLjA7KcnWypWPBndh6uy1nv1PXLVvljms0Srp?=
 =?us-ascii?Q?5gH5Z4g69VPvWSo3l9nX4319f+3mUSWjoV8xUaERZXA0CCxjbV0eDWdBlzHE?=
 =?us-ascii?Q?zZk8FoJhr3UFQgWKuHf/Cri6MRmanRyzRk6lg5ELeeZ6jiA/5vQJ95P13jbd?=
 =?us-ascii?Q?i1MNElEaX/3mkNWFPZOeYcMMm1NNDW7TuHpXmvfFcVIxtgRohmdlc5fkBZ2D?=
 =?us-ascii?Q?g3HUc2Urejo8GInFjpD2bg58Z4+U46tXdjzwFLQ4DpTDDkVN2GftQaLowIDh?=
 =?us-ascii?Q?O+YFTeP5tq3GW+jjQzn5Sm9sWdXgdPwsTEcTpxs0bLCYCCU7JxOlNr60Q/p/?=
 =?us-ascii?Q?hRjCfMBlYOvo9TguXDv2Jo0qh990Z4/sRiysSFQzRvvjFkeCAjRUd1bTK5YL?=
 =?us-ascii?Q?CDAmR9BtjEtvoWLbzkQF5WBm7Nyj7p0ma39uOo5M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71d88c0-97ec-420d-d06e-08ddc64dd23b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 22:52:50.0522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fFHlThSezG0VIp/RQw6zTu4rK1Qu3iTFsLr0M+EOEY+Iq2la3T27aHR19yJqClIZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8890

On Fri, Jul 18, 2025 at 05:41:47PM -0400, Donald Dutile wrote:
> > Not that, at the start of the function there is a pci_physfn(), the
> > entire function never works on a VF, so bus is never a VF's bus.
> > 
> Well, i guess it depends on what you call 'a VF's bus' -- it returns the VF's->PF(pdev)->bus if virt-fn,
> which I would call the VF's bus.

There is "VF bus" that the PCI core creates if the VF's RID reaches
outside the PF's bus. This bus - the "SRIOV virtual bus" has a NULL self.

Jason

