Return-Path: <kvm+bounces-28884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 866E299E9DC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 14:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA4FD1C212CE
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6443A207A3F;
	Tue, 15 Oct 2024 12:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iZko76SU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8821FB3EA
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 12:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728995285; cv=fail; b=HUbbzzpFLHjrJQCs3Ezz1/taII79JrRI558eSNUgWbUEKv5S88p8xdVhwJF7mxPs15q6akahe8Ueyf6hcvQMWv5x8SDpJdgitp3Sb2A5Y5FwoJ+36awh4/uSD2cEdjL+iLvHXz1Qe3K97bgv4Enys37xHw+DOTWz2gfaPGhtPaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728995285; c=relaxed/simple;
	bh=yQXcvmesd2l+d/58YaXRKzXhbMbpWQi+gXWY7K8E860=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YVZXQu2F+dW28a0TYHmSpdtGYhKG+Ctm/iasEJQcPg1FyYDytC7AwzcuG8sCGNpx6NQwlXOZBdf8i3eT5TstHUrMy+i237z66rFGhm3AgWkrEl0RkJj1AjIxtclwUuY1K5dOwwGn77ZwFeoCREIefv4b14ZRUdyj3UR88YwfbJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iZko76SU; arc=fail smtp.client-ip=40.107.244.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s5neW1noBWqrYt6Wp1GN3/N4+ZZsdZSXBYpv5TcubnanGwPzgryxrTZTKlo17V/NQ4VtEsddkbaMaWWYg+lWEj1smnS61B/hlv1E0nSQWUtXhIkHrjkvPsc3KwQLrj7DIXufSn9RW3WmCy0v9aPTJ967SDOjRaRpMaMUzJJFG7UEBIg6lgqDNV/pCCoaqlzj51zXjKSdS7JO3yiois1f2vbJWerl8kLlxW30s/eCcWKrqYeq6Yfk0M1FG1Vr0Vv5wAeW1VjXLqHXyHAWpUmmgdjS/Uitsb9FVc46Vxl4ffELn0jm4ELO0jsz8xDOCb6T+YiRqw9C6oh2VsCSYSzCSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvoK8sA4BBztWsSGphP4EAgc2QZoviWBePbcci9XkUg=;
 b=GoM5UJUlNl5+Jk103nno6cDQLrJCN1bYN/FJY0LCdcXDfYFGIhxcsqndclc3uC34XGiDcwotVlEO0EgPDegXtTsEEdFO5Wfbp5FlFcSr06FAdEBLehiD5pRXg6JNA5TgqcLdVkebm1F/H6wizJ8QiSZEWiYbd0IjPUuhYbf0gM7tsFMaQ7PhjOFSvfF/hrey7pzKiEer+BKmncqhtRV4ORksV6+PmFibg2CQ22OEVe/TTG4HY15kwljaGTPPRtNO+mM3CVE7blJBfB4YPo1cBg9kQPlbEgCIMiEKTdmOhhdWGCXgrkCnGbekB3lTvDhVjoJBzSFJ0kOXWlrsRp7vJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvoK8sA4BBztWsSGphP4EAgc2QZoviWBePbcci9XkUg=;
 b=iZko76SU79oyOdxYemBw9R1XiC77eK07Hv4l4hFzwEPtVex5s9hhCf4pc1/PlWn/uosPxvts+xbQeuzbx1W3gCy1L+V2M0RH5mQi6wShjs6V2Jq4zhdb2vru3QCqY9YraoIiSaF24cTP6pcfiafiEhtlCpoOBlCEd+uinrrkV/BaXEZWwjxILhpVW81cQioyUjWSxLkIJ8+n46DhfMz7YEQ5tKpqlbFyQ5FZDYpUL7fkRvRs6t0EQvfxYLb1LjT7UWz8bQSQHs5LRf1DElDAh/kGF5ena72LTieJjvV8TUHCwLbJ/nxU5dofEWnnMX2fyFuEfExBACkYp51ooSiRQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7285.namprd12.prod.outlook.com (2603:10b6:303:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 12:27:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 12:27:59 +0000
Date: Tue, 15 Oct 2024 09:27:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Message-ID: <20241015122758.GJ3394334@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-19-zhiw@nvidia.com>
 <20240926225610.GW9417@nvidia.com>
 <d46ff67d-92f2-4e84-b1a7-1576b422b6a6@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d46ff67d-92f2-4e84-b1a7-1576b422b6a6@nvidia.com>
X-ClientProxiedBy: BL0PR1501CA0007.namprd15.prod.outlook.com
 (2603:10b6:207:17::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 874cba6b-3aae-4661-251a-08dced14ce36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t2+WNO7DSKGcIGdTCey9uir6D/PE7MPYyVa2xRAHcaShQJPU3n2OeNfEgOfp?=
 =?us-ascii?Q?13yPphvdVBb7LitIPEaloKKHEwagw2eJd//tkA0gSdkm4Zl1NMwiVeR48YzY?=
 =?us-ascii?Q?5vny5E0XxkIEhuxNyv/Udy088g/p2Vfsd9n9vlZXp4ivDsJFsf4adkhVkCig?=
 =?us-ascii?Q?Fv3yJKIVTqOftf/5SSZkNM0CaC5T6khl4p04K3g441obNTX5mRflbqiOkpgf?=
 =?us-ascii?Q?Cmy59c/lcZVZI6HEgS6GVHiYqbdJQ94wlKMSHWkuENEHLOADadtSPqZhVTpY?=
 =?us-ascii?Q?0Iivh2JygPllkrdzQ+j0ig/DpZJCZHzEuHKBQ/09BX/3G2DJrhirqZOAo5e+?=
 =?us-ascii?Q?f2o0dzjCdvsREXE/H6zRs3CI3an2spAwov8VHFbhSEF/937BYgbHOH2s0eQd?=
 =?us-ascii?Q?m6bwKNMIASMIJOwsulQnOj731nvIEmVfiVhoWxEW6KB6w5plpI7dkqcnfxPG?=
 =?us-ascii?Q?GWRx5BMuInpdj97BkJouifSGCzjOiwt4jZVA4ozUndIgAiJCI22sEn+ntPmG?=
 =?us-ascii?Q?re3TL4foH5ubZFagokTl5ifsgEeRKA3lRPWx/LJgwi5XStTa0aJa6kHcsk9O?=
 =?us-ascii?Q?msZA/2UpDypCQvoBsS2YlAzZZn/A+aXQ+N1bAXkXDdLdnujzDg2QS0ZSmaQW?=
 =?us-ascii?Q?xFXq9rKpamdn3BYDceffrhKoOtT0mgPKXyKuN5pKAoL9Yc/C3nXkvAIXO2iK?=
 =?us-ascii?Q?OBcUYb6MFRoh9vcSfuZACVU+UflF2mAwDa6lHtItzPckF+Dqn6iyeT9dV5Ec?=
 =?us-ascii?Q?pntFSzpBDrmLDfpKnVTc+VbwCduXD/I5Jz/OC6meRHToOb1yOkSU6+jhJIa+?=
 =?us-ascii?Q?YZEkPvqZ3tSWaUtCI8Ui6Py/3PsR9W8SgXxI0/7/Ckq+tAKo033Hlav9gUsj?=
 =?us-ascii?Q?VQ6Xq9Bckp/54gXHlGabgWSv6u22iE9teGhHiQydiqveRzTP1MmNQI8K1f0c?=
 =?us-ascii?Q?qWOq1XXE01Jmnkr36SjzKcKuzZ4880L+/Cf2F3lkT6t5ACp+240O9ME2IcXI?=
 =?us-ascii?Q?PQluHvUb1O7OkuaS45rbKc8NW/ia7jGTkCRK7eFo8YCaV34xC+9qA4mKZMIv?=
 =?us-ascii?Q?WplVD0//y5tjQ7vpO0YrmACWoQblEfiouK+zbIcmnCnly8+DR1MY3yZh7+SO?=
 =?us-ascii?Q?iwrqjOZ77NRIjKQjjEpdaZSCVVbA2i1T4Zs09AqKjRvuWBnDCkptguC8oL05?=
 =?us-ascii?Q?UC2aee9GTqMI06KlZIyBWyixj4z4cnVKbclKIiDtm6O5MWFYabrCSMeHDdcc?=
 =?us-ascii?Q?xi3D3RjiiOIt4cqj5WOyE3GKE/7vZPHpMC+keCMZMw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ScUFVzKMBlm2jOHcnP07KIjsG80WAVyCLHdGebA4jEkKeBpThLuOf06LiZpt?=
 =?us-ascii?Q?n6nkwoLuQ23niws5EJeRGRu5ECJCICn/Dy46Ho/Tg8Lc086Qxbr8bCj/pek8?=
 =?us-ascii?Q?etXJ+HgZr4wVnZiBTfTr/dP/kAupAG/sgGqqe6RvKzPT78xULDFHCGMZM+qd?=
 =?us-ascii?Q?KtcMpFZr45Euio64lwHSGTCSpHv+kZxMR23f/xlGHa7/bh9XBqzAbuqbOL+A?=
 =?us-ascii?Q?9H73e1EVeT13T7zV4MyqZnkA7tM7Nc2k87U/d5bLW7QYVP51Y2iKUk+LDe40?=
 =?us-ascii?Q?xKMJ1n0jGy0nTYW82qBUi1kdR7j0Ar1V/nXSSIvEK3LB/Anvyck89jnn1b4e?=
 =?us-ascii?Q?NiGdw3Jp7Sk6Fcw/Dkx9JryehVBYJVCaY3ocgc6pk0y9WVmksfpvEVDGGdXq?=
 =?us-ascii?Q?aPx1vkaek9+hiNMGZEhIM5jVuVF1WqqTfgSfMuYJfg6gRzIMualeMsutGLaX?=
 =?us-ascii?Q?KU2cUFy0srZYuJ2LUTEBoVW30p4e+mfEax1jcV/AQ96c8R0x5A10vaFpr10X?=
 =?us-ascii?Q?xTNIGfAq8ulfuqGK9GgGUypk/UF8oC9YAvY0iNwqDYFUUCaZ35XnaKIzYiwe?=
 =?us-ascii?Q?jJSEopqUQ/GGcWpA3XTEm3yyiqvVN2rZnTGGeBRR2MHoHgd2atPbQ4BcRJSW?=
 =?us-ascii?Q?RK5b/nohtpSOsukF7inV+Kwk89jOrJbV/4HP9llxKWQf2sd/m8O9woKXc7vK?=
 =?us-ascii?Q?mNyQN+abbN8g7zkAfmFOHG14j2E8JeZFpUbzgdABiH/vx7lqQ8qoZNXh/Cjz?=
 =?us-ascii?Q?xEx3NmXlQ++OMT5YhvXG0KkcvgsP6Ndrmbw/gH9LYkuLXMaxzCkvDPuWBtK9?=
 =?us-ascii?Q?rvx6RFPV8dF9X28PtiVA047tr3xoxztuUhtVY1OMwkrIm5HirBji68SO6NJb?=
 =?us-ascii?Q?5CiVDDWgbqa1+LbtxlcRxJV9HPGYdjeFYt+tGM3nbXLdDMNYJ01cGIXveXuQ?=
 =?us-ascii?Q?13lmdSCm+Ndi3wHkiandsUnvYM2vpnVXaTsaJoo/w3fjFgRX5lRXklyanKxl?=
 =?us-ascii?Q?lk18ERvfU9k6fgtS3A0GEP8iH8GKdc0YQ5L9tUsrjBqx+L6HhIhW+hM1WMPg?=
 =?us-ascii?Q?EAVWwMiCslBdtWynpNX0z+ncWp7X+uMoiOkdt2+PgW6+Ki/GRjS6W83f27J8?=
 =?us-ascii?Q?M3a7pOm3/Oohw0U8NLU74+K9ZTR6TY2LKt8BK1YHcNk1tg7oLV84aZnUD55y?=
 =?us-ascii?Q?5SHmZpExtXJ6V+qMaCpKBX3LOuLSVvgOa+PtxiN40t68zlibwHVXim8EIPfs?=
 =?us-ascii?Q?lmJbOzih70g/xrpwy3O1QzHOnf8rrrEF/GofYPEmb+H29S4PDiqOfWaHm4UC?=
 =?us-ascii?Q?cANgOhiYvuyclrCrTqZ64SOAkS79xQLP/fjuuMNWKdNkSmvXVaphjlKnQ7JW?=
 =?us-ascii?Q?FgyGYPvQJ+o+2t3sseAxMGzyd1SUCG2r6g4/8ySX9WJAkNv2py/32K4U4TQU?=
 =?us-ascii?Q?dWfB1IyIHZoQdWaEcwAJtS7rXSZm2/+xlbG/w02s3CGiQnIECuWnE0aAv85i?=
 =?us-ascii?Q?Md6Gtx87LU3qkhuKLRetM3pfxmTK6JUS/fLXLsFH2V6INDe0JjOVmIinXUfe?=
 =?us-ascii?Q?C6KxWq6p75xYyw7/2tQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874cba6b-3aae-4661-251a-08dced14ce36
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 12:27:59.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czJR+efDJvcnooqJTxIdWsIhZaxh6epfuA8VLF6XO+9U70mozQqX739ANYgP/aaq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7285

On Mon, Oct 14, 2024 at 08:32:03AM +0000, Zhi Wang wrote:

> Turning on the SRIOV feature is just a part of the process enabling a 
> vGPU. The VF is not instantly usable before a vGPU type is chosen via 
> another userspace interface (e.g. fwctl).

That's OK, that has become pretty normal now that VFs are just empty
handles when they are created until they are properly profiled.

> Besides, admin has to enable the vGPU support by some means (e.g. a 
> kernel parameter is just one candidate) and GSP firmware needs to be 
> configured accordingly when being loaded.

Definitely not a kernel parameter..

> As this is related to user space interface, I am leaning towards putting 
> some restriction/checks for the pre-condition in the 
> driver.sriov_configure(), so admin would know there is something wrong 
> in his configuration as early as possible, instead of he failed to 
> creating vGPUs again and again, then he found he forgot to enable the 
> vGPU support.

Well, as I've said, this is poor, you shouldn't have a FW SRIOV enable
bit at all, or at least it shouldn't be user configurable.

If the PCI function supports SRIOV then it should work to turn it on.

Jason

