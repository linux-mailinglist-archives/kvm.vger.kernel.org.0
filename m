Return-Path: <kvm+bounces-27308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F145097ED8B
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 17:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 035271C21136
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 15:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5739199E84;
	Mon, 23 Sep 2024 15:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A5TydgaZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D351CA84
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727103754; cv=fail; b=LGfog5r4LHypWXYvZP6hdDTqtVu1Yjzb9IpZjLtZvIh02W9lUTY4498O6JTrMOQ/W57emE2DZ+HDRjeWo0uGthooiS3ZOYXRGvXt8M+AuL+wBLfbC7bbGr5nhowjcC686cHD6YKRbB1YU9LFtVdc/NflTZeAnYb4Q2DAE9p+U/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727103754; c=relaxed/simple;
	bh=G9pP8PHs9oPD7ff7ZOhfLv4eH2pgzrPqmKETxGGEvkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WxZvo9Kogw826x8YoQH0jrXbyIPIqG4gnAae6zqP21N8iONcUinIhsmT3/fyRn96htO/vyuUJhLeOSZCT8DZ0P0jPIEQLlDK6fOAoMTpEVxdUrl6qkNfBjHi3hs5QxWTURamgUZjy+7bW+bYd5PwxoDk0ZNhAq78w8ptsjA/GSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A5TydgaZ; arc=fail smtp.client-ip=40.107.236.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahYCa5aR+b9xr5s0brVYImXfhlZu5E+c8SGPe5XyySE4cPbn9y2a4qZyt2GM+SBM0vF5sm4XLai0FUDeWvyYCl8EeaWu5TkKzaOFYz7vLeYCDfjWA0uH+JZGnz9Gq/9WtHNLJVig7g10fVsKkKV92mFYlxIjJ7kn8gbO2GqO3ED/II7E85ZHM15FptyKAemKeSwYpMcTT3evNXOZFHlR0F6m7s5vI30CL9cNe7Kzo3+ukUHw41tgjRf9comeUCIa3l3z81sXncTn+wlA2koTlnOXeTAsxsFQ7MT9l2QG7dsT1RHBLivtpgXqCK7QEdtaMTlONyEscgtaY804M3KqDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VXvfRRZOgYs29fdvkjd9+cl0zaByTQRa17HBDrahm4=;
 b=rD6flBtNAI4Rl8nyOHtw8zykLhjDYN+JsfEkgz10pA18ImdSRWpT8/7PNqAlPdPc4OKm9GzLFUHXaZf9jc/p5OtEEM9cwUiW76ZLnvmi0AfTqhnd5ph7LNF0PJFLmE9u4WYGjdfvwK4XqpBbm+NST9uH9lkGo8dPfeh2Tj1544LlSl/0ycWTrjH4dELm1emXrt2Kl+Ly7IReG3oh730LuXDs6Mo+0Z2bIEPJ0mL8AXmak8kcQtSacAZ8Ux7RPSQ6cNWI5oZ5SprLXn2Zv/Dd3MRQvfEeNvWgaBXwYrm9UuZhxtwPMSBQOQnn/za7qYmQ5UYk5QZjS55aMlZrZiXv8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VXvfRRZOgYs29fdvkjd9+cl0zaByTQRa17HBDrahm4=;
 b=A5TydgaZHb0DmDydba0GvmbeH741tweaulRcn/4ygNTac1haG2W3hUqAvRsHn0XNjt/5pmlClKHpI/pyrAtBkFkaBDeyAezvX4KF3p/dr5Y+r74zYxIHLlwjhlsDKL0QnNmmNZ5F2TsAYlqTwaSm58xVyEOgo2fK8ufNucNDyS/RkBtkqfbVM6NtrZbTfLNCiLVxHTBJkwY8f9VJd1Twgs0KJSEKEkw+pPlVWAEYtIt21vI9HOxVjFDiCgqkqtj8o3EX8xbgkZA5N80ORr3rbbFSYs7W3Kb0uzU3Cv4ki9TKQIE47050DcoFVwP7JxYWLY6XW+YiQ3cHR6+efNQMcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8720.namprd12.prod.outlook.com (2603:10b6:a03:539::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 15:02:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 15:02:27 +0000
Date: Mon, 23 Sep 2024 12:02:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	"Currid, Andy" <acurrid@nvidia.com>,
	"cjia@nvidia.com" <cjia@nvidia.com>,
	"smitra@nvidia.com" <smitra@nvidia.com>,
	"ankita@nvidia.com" <ankita@nvidia.com>,
	"aniketa@nvidia.com" <aniketa@nvidia.com>,
	"kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240923150225.GC9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <BN9PR11MB5276CAEC8170719F5BF4EE228C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CAEC8170719F5BF4EE228C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:36e::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8720:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a707fe7-86a5-4eb9-57a7-08dcdbe0bced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L4X8AK1LTLcIW7l/gnku3ydlrETl1kVyuQFEvUKncrKws6BT0Zu709zSzO1f?=
 =?us-ascii?Q?enPWiU4drSXzOmyVpf/yoHrsgiyBsi+rD8h87TlhlinaZ6ZouUOxhodngx/S?=
 =?us-ascii?Q?+hP3zEff4QCJLnfKC6jaWxQNXIdFEPCY9Ema5hy2xzd4uQCEO18ZWjWXn1uV?=
 =?us-ascii?Q?NaDtV1UXxNie5AU6ep1JX1o9J4WWBnh3r1v9cPsZad7YeoN+OwvznmbnQFX8?=
 =?us-ascii?Q?UID2tTdVAK7gpfUcyKu1dmx2bXqaAgaov3Q7o+p1bBdsnz97yz3KEpE34A9B?=
 =?us-ascii?Q?VSO6iDNMO9JPsH2YBmhodE1qz8rukcZiqTeyG0HjNyNHUyt9nFH0+e75bTb/?=
 =?us-ascii?Q?Y0rO69vxgVyerUSoJIp1vhsGcS3XcHvk1QfJEsdma8H6BNoeyKqUnbgRrY5i?=
 =?us-ascii?Q?1fv/Z1wKc5pzlgq3/zv11jg2KdTXoz6IM3yRjp8e2CwIQ0hpDDDkmWLeB73W?=
 =?us-ascii?Q?U/r2GRp2ZgT7qeL07qnc5fjR6mjS2jP1j3jmTIwBi8kCogKi3tm+uspu6ywO?=
 =?us-ascii?Q?tLiWkgDgnCPCnC87OXn+csM+WPpMp32KMIhoiLewjUVWqNiNOECGwVJcmfWQ?=
 =?us-ascii?Q?S8yxd369m0hlFD/cPpV3fQXdjtJx2SZGAICjwjY6CDdL49K0A/dOdPMCgSUH?=
 =?us-ascii?Q?x1r58nNvLh6kBlQwzoOIinFzdgzSoX0zhx6bTp3P/DOfPpGJBTvwPx1rzBDc?=
 =?us-ascii?Q?TZx5Sve/gJxwcCnS5b+O5rpR9HtFoQQNEkDA/+Ju6jIbv7+hbFn+NWaKWNiK?=
 =?us-ascii?Q?q/PIrAjPacjOmw+mlQyueZgd3dipGzdh3HtuVvzcEPTlw35EDCuHAESxSiOb?=
 =?us-ascii?Q?OI24DnV0x8qPTiM5bGlFaUrFNx2ePevaWVZphzjMQjWQ3bYuEqx9pmhBbaOc?=
 =?us-ascii?Q?nxDo5VQVoW6f32KAinWmnpm1bubI1UzmwRLr9bNsEhA9tEGJX/nXB3LTS7Fq?=
 =?us-ascii?Q?0Liyf6WhNGX+ESCsyvlIL633XYatD8YKCJiJrWlR0guVwq41YjgC19gpEx/e?=
 =?us-ascii?Q?g0zQJmr2rHexUNYywUB6ReB34ceXT23at2Srp2m4tpexufi+xOmG0GpHVaVk?=
 =?us-ascii?Q?751VfZH8oVTJJbOgK+u1ZU3he/G/7tnuYw932XrOH9VCPZMROQaUQG9O58g7?=
 =?us-ascii?Q?5Mjpg/XDIU6GAlE5tEnFotCb0GhwlRK5MgEgZWwAFLxuhE75/03uZn4YQ8BA?=
 =?us-ascii?Q?QKZvBxXsUgsKuzkQ6NzLk9bHCRa6LZYzmEaoH/QlB4v0R4uN4yun9y125DO5?=
 =?us-ascii?Q?occ1vuRqeuR2dow+LoXi05kYTRUnHHV+qhNVrD5deRMx+d0IFPFRlwi8FhV+?=
 =?us-ascii?Q?S7JY6QQC27+ghyLF+//hF0IiLe5GT5zDXypfrvxh6uX9DQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JkJ26obdYY8p1/Cm2SnRzF2Zqb+AsBZ5chzqv2GJVRwK2vrWIA/EH/f5ah6m?=
 =?us-ascii?Q?oshMfnnB5LzLT/UOY40LtWB1LLZiyRpBPliDLTbcHT3mqzXBNekTGxzlHzo2?=
 =?us-ascii?Q?B0oRbLdKN0eicOiXiiy5XuuSOIX9JhYOhsXDxKmjMoHEXaP5E9Hz/WFDAB6C?=
 =?us-ascii?Q?76uL2NpMEFLHw6nOrTNxNnB2tgg0HVi9SleVUlMwpu7OrGVVRkEHsCtsu4D/?=
 =?us-ascii?Q?ZlOtloceHymFYnnjvH7erQSdNRYBwrWNXWM8Cq3yyqkfJsjKLSvEgEcSLSCI?=
 =?us-ascii?Q?9RiY6tUcZsPPxwTGhMrQgGX5QaB9oRY33VUb6L2MTZvCOHCCqZX6ao09mp0e?=
 =?us-ascii?Q?zxFLtHg5rkk4tzY9ySuAWR9IZkVaJe1a/X3lMsllpwQS9VzgR3HvVpKuJJxm?=
 =?us-ascii?Q?pLnab66PyS8ve0Be//sIiQe8EKD+icdEaxIHLUbbZudkgYGOELT7JDl35Hng?=
 =?us-ascii?Q?QvBMZ92EBRLqMKJpc2jytIxdAlurTAhKHXUzfboBgR1vk63xUWDHyLkt6Pw3?=
 =?us-ascii?Q?RGrhNfjTX5DhFyvL95+ubMm19vPlla2AVm7fPUfqa6HOliYNMCz22UAm5BdY?=
 =?us-ascii?Q?5mBGTEOyNtjw41FiUKLRXub7RqJRoGFlWfySTCU55msEWeYAsz/YJ8orutcS?=
 =?us-ascii?Q?+4qL6wR8CtaKkKhiOfTnSu3jskY8zMYGoh3+XMWYsuiron86HwXn+H8kAS+F?=
 =?us-ascii?Q?FBtYi86TTiIl/d8vng4dGuRf8zSxjEmQrHCegCf8QSdFQ7m5G2XIB//M86hk?=
 =?us-ascii?Q?lgRRggCOh8itZvTtqVuGI/Wamce0e28qFcI657L5+MhQvEPNPsWK75F84n05?=
 =?us-ascii?Q?HAngKhcIXA7MXCSmTidu2qF4nBDKeY9Y/DBqVOq60s/Ny1FjSq0HPv7vo6+O?=
 =?us-ascii?Q?Qt2rcRmXOG/ns6PC8xOTCVe2tS4Ui87X0Qp8lUmPXXrEjFl3kcoVPzLl+CJq?=
 =?us-ascii?Q?gvt9vxCxf6s5vnV7Z+nk1LcXFOoAbnw3WtEthQBCOiF3ctwY+Gq0x0VCCiT8?=
 =?us-ascii?Q?Juqw0RM8o83fZW8tWNwSfum7gTrPmf5+cHx2y4HEQHT5f2vZCQmDonkP29+x?=
 =?us-ascii?Q?AT5yaXSNxMIcDrBIuZPAX+ImCRlbDYB/lF5gG2ALOdJ0spJaZx1qE/c6stnT?=
 =?us-ascii?Q?z/fFc8g6Nxqqt8zN4J7sT5KC2dhcw+I0kwB6fLs8zvfhqA45NfbWgWKlFC21?=
 =?us-ascii?Q?rhD8n2HTYV54LL/sDsRnrhHsn8kOsanBn1GC+S5hm1pwfMnUgDRXZIyNNEVf?=
 =?us-ascii?Q?RZV9qlpegkW+5SXCeYXU+TJQkkzJDuZIVYWqUt65qX5BOc90WWIbjgMKVc7j?=
 =?us-ascii?Q?JLb/B8+Z+Nfnv/npcipntte9aE96H7rOZAdcD87rtCmyZAJA7aLjgfjGmM4K?=
 =?us-ascii?Q?z9hdHehN+I47m4lF+Y7Gf1qYS6ga677FESc2YlacszpnkiYyn+d7FOQem/Ls?=
 =?us-ascii?Q?Q6jBQtsj6qYIK4L6VtEVkYo4lJQ+ESGnTD/tuDORswBAi5FfD5u3y+vic/3S?=
 =?us-ascii?Q?BvlVKDkb7ccgF8YWgGnw1WlXmeaBoJeukO+Bu6PLAs9irR0GpOzRQA4ipocI?=
 =?us-ascii?Q?qy6B8Jep362ZJKuDUfk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a707fe7-86a5-4eb9-57a7-08dcdbe0bced
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 15:02:27.0488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYo3VlTykcgbShvxEmnbr9os/COgNaZlXrKtcCjQp+87vqF7069xvnsvM6Tk2MEW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8720

On Mon, Sep 23, 2024 at 06:22:33AM +0000, Tian, Kevin wrote:
> > From: Zhi Wang <zhiw@nvidia.com>
> > Sent: Sunday, September 22, 2024 8:49 PM
> > 
> [...]
> > 
> > The NVIDIA vGPU VFIO module together with VFIO sits on VFs, provides
> > extended management and features, e.g. selecting the vGPU types, support
> > live migration and driver warm update.
> > 
> > Like other devices that VFIO supports, VFIO provides the standard
> > userspace APIs for device lifecycle management and advance feature
> > support.
> > 
> > The NVIDIA vGPU manager provides necessary support to the NVIDIA vGPU VFIO
> > variant driver to create/destroy vGPUs, query available vGPU types, select
> > the vGPU type, etc.
> > 
> > On the other side, NVIDIA vGPU manager talks to the NVIDIA GPU core driver,
> > which provide necessary support to reach the HW functions.
> > 
> 
> I'm not sure VFIO is the right place to host the NVIDIA vGPU manager. 
> It's very NVIDIA specific and naturally fit in the PF driver.

drm isn't a particularly logical place for that either :|

Jason

