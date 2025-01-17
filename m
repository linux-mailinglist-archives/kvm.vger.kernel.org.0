Return-Path: <kvm+bounces-35837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43ADEA15574
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECEAC3A3385
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050D21A08B5;
	Fri, 17 Jan 2025 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UENdEi8u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE8B19E7D1;
	Fri, 17 Jan 2025 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133850; cv=fail; b=Vl7NKYPzLEAuEpTzF2cZcV/kOTxHkmvgwKfldYWHpQfCEVukiCyxTL1Ox8dIiXZfsS3lgA2I2q0VbXuAj3BWLFxnzgQ/RTwvdAGbuVSqmVI5QkRlZiccD9bOiKVaed2JtwzDmHZlrLTy6DZCgZpt12/E2E8jFrhRGxMG4Dqz/Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133850; c=relaxed/simple;
	bh=edGXggiGS7DyGlXk7HGbK0N5hrq59gszX4Z99pKrrUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ALTVZ0qA3I3mKjaA6RrLgeDsnEBWEQXGIhhg4rE3SZQwRsm2grYVmF24m3HIRrhpNW0AzvMeooOic8A9m1jaFh/Iy/KTmqEfasuuF3et3kjtDV+29GSISGkTHrVIJHmqrufRnbhNn/HEQvEpwk8aJGwmhhrGN/818/N+JJK8Uas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UENdEi8u; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OwrFBC/hVS/MyIHp5DMVENXrn6t9W7GnpI9q/KE6ZfsjpWftqrWVwoSTs0/i8kqsTOfpQ9KthmwIRcLn2Mk6XOi+aRGBuNkrNISQPV5htTjvxqIofPvxl8IUtS4MQPV5r7TIBPPcU9faOaoxu8fyPHSfH/FncREWMA6yn3FoOs4DCnwqlW57wSMzWFUCx4xkQlcOa4/H2u7qMw6X+dywj5al7F6Pkzi5qXK5fx6RRrzPXB/tz7pBvDcBbEH/0KE6rstqUyeKsBzT4Bn7e3/Gw/V3qsoqkTtb4cNEc30Oyp5Pq2/GFcSiuKVifEMo53piU2xWQ0vpWuTir6uuo5k6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edGXggiGS7DyGlXk7HGbK0N5hrq59gszX4Z99pKrrUs=;
 b=GSNs3l6nGTQbKK706xADXOJmD4VSLcH7OeqdtVcDzafMdaMhOK8lsSpCvJOifXS5nx4CItZJ3OGjxngOZ8Lp8qpT98YOrpAPpOSIE2WAW8x+qa3gEdoVzyLOJG6xwweqCoQM6yYlFonuC8VMBZA/s+BN08lNACC5Y4H52lc3hMO7hZIOtWMc82RW7nDK4BTutLFtMD/OUYhfJDcMGv2LIeAawtShntf/+w5cATDWLKFFRlt0r3r1TopqrK6y4hoEqr9hOIElX0E4Wm7dGnVgihllFauDh2DiHCldEeS3qiJAZg0gqVBxM2cZIvwWM4M3Q/M/G7htzJgSb9zmGYoT5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edGXggiGS7DyGlXk7HGbK0N5hrq59gszX4Z99pKrrUs=;
 b=UENdEi8uz2RJe+ukB9g7QpJsBWAnZ7rrxT/d4bIJe5tHS6mozUSJxFYBeitHseWAPMyjRKDhD/uwtH63+IozBGP83qFNfUCRMbS6pwQLBPa38cztbftgCIiPuKxpYNArF6NeM56nT3Tt1+p53QVKXcqbm2WxKGbcw+8CfDfSazSzRjdPSRrnRciZFD0HeZ/a8sNtzCFXecr0/xfmCJLjeCRgLNLBGELE+TPkUDU3UQBKPn7kK1KeRVE0pDUCtBHcyNQpKpBeEkDeO4oCU+Od9a6gEa8wz+aQo05auwqqg3AScVryeDz6HIPDB6W7KKroEBb/Hn0oClxI+RK1V7UL3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6384.namprd12.prod.outlook.com (2603:10b6:930:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Fri, 17 Jan
 2025 17:10:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 17:10:45 +0000
Date: Fri, 17 Jan 2025 13:10:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250117171043.GE5556@nvidia.com>
References: <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
 <20250114133145.GA5556@nvidia.com>
 <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250115143213.GQ5556@nvidia.com>
 <Z4mIIA5UuFcHNUwL@arm.com>
 <20250117140050.GC5556@nvidia.com>
 <23fa05f8-ea30-4261-91d8-b34fc678c4de@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23fa05f8-ea30-4261-91d8-b34fc678c4de@redhat.com>
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6384:EE_
X-MS-Office365-Filtering-Correlation-Id: 43d2d3e2-7fe9-4492-1020-08dd3719e132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bvA6bdBEyyrq0s2d5eOVN149kzDyv/F9rHAFPwfx9OqpYZcyqMoqHjsNZ9YJ?=
 =?us-ascii?Q?Tc36PXM1b+HV4RKqDHVYMorIeKcqUDsGhcDlXwMmQ/K8sNyuTdy7GS2BU8iw?=
 =?us-ascii?Q?o0OoYjHIBF8z/pQz7vrz0jjHdb4MhA/nJXZU+kJknHxEsOiRuh4G9YV3dVY0?=
 =?us-ascii?Q?FJuOmK8C+7noQCeO5Tvz4uSikU+Ay4yUTAC8fl5rxP6t6JAY/eAgW5uJd0ZI?=
 =?us-ascii?Q?aSHouvtCd0V3jKJX1ZccL/xi7KZyUMtcdPdxlL86yx47ns7G7E3KHQAANbvQ?=
 =?us-ascii?Q?CliWbRxDJ1nz7CHB/2ce6GM+1ZXqmYykzzkR49/S/svuhzXbLdiZvOt/NmKV?=
 =?us-ascii?Q?hoHWSj9HG/651YyHRyTuVvNO9gEnbSTabK5cJxJJegQyDPfEw0sy8NCaf8vQ?=
 =?us-ascii?Q?7POvHd7CQ1GTh34LhSfvUBce8oVav3CcqgbN/c0bgP1P8YTAEnAr2/Vgm6VI?=
 =?us-ascii?Q?uUblR4gHa4INTsXTs9QT8tj3x2qBSpYzoFdi/veh4IhFdK2qksoGJ9YWyzf3?=
 =?us-ascii?Q?V4i38SVz++V69bl1wmYIUXA37waTo8Dst0E2vr9QKtJnyLQh3qxThdgdh8o0?=
 =?us-ascii?Q?UlZNhaUUl0OCshQioSBA6rSc1E7Dy473ntT4eZAL6xPUkkexHzRwxv3hy8Vq?=
 =?us-ascii?Q?7kYLQCOddahnTJRqtbEQdWbDFJ5Djsavjf3CiFGJc6NdBgHFhhFOdkB+QXdf?=
 =?us-ascii?Q?/TdgoaRczz0EjbPItGImPVJjI3GC38v+2iqK++sk2452XWLjdjEWqH207eOt?=
 =?us-ascii?Q?xBAqArw5/pkXUZRVfk1ddDHNppBbfmuQP1BdIbJgXYdNtBrOhEdPMlOZShTZ?=
 =?us-ascii?Q?KBUb7QhF3aFIdJGg2Bxc6eiyPpPBaxLIhCh+Kkf9xnh8e8pkyDXtoysTSs6U?=
 =?us-ascii?Q?olSn720423J0l/+AbtaNc1lUXB5JiXqiTRgtvexSgfOEdk5NNylF/shfoib5?=
 =?us-ascii?Q?ux0brkcotk7ev/tKabnOZWDHrsbjKlcKxV5T09/sVzcQ85iNLL6Ja6tIIREl?=
 =?us-ascii?Q?+VoraoWgdkX8kt0GGsNcuiKoX5FVsPzfsBypi8RyrmYOkpiP1Kj55sJbZgcx?=
 =?us-ascii?Q?LstJmg8pVSyahrQLI6ETAoB0iVGz3wLKJZj0QDZVW31oUmm5yETljbH4PxR9?=
 =?us-ascii?Q?+AF4+mXxH8vDStFuta3jzs0MYVvDKHcXFp6z00M7LmakhnnNLwaDFBX76FZH?=
 =?us-ascii?Q?GpHUKde4gPD9BTumR8KfHM6AH0jCKCZCNvZxpR/EGghxQL2ql+3jC/bKpGqk?=
 =?us-ascii?Q?lvAQcuP7CcFVwyOzl+bbOWLnCSGfkCE16S9IrRShvUm6bpTsPVeCW3DK2V4n?=
 =?us-ascii?Q?ytgPQn71V+6yzpFuN64VS46+0u+E+GA8IWB/APwB0cC/qspqC2A7eOfGyDdL?=
 =?us-ascii?Q?fhR00t1kcAK6dY/xd0adtV6QJpTE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UrW+5mbw3Da5PuWfDik7P53Cysk9mRp592wVJOF3AQ928J5iztXs33jPJPP4?=
 =?us-ascii?Q?7SIY77ilNw3XHmWqc2G5RUMW6kJSpureac+w6R79ZMn2Z7o5I6t6+jUINoNc?=
 =?us-ascii?Q?AHElFgfcdVNWEmznH/jDrGtiWppXN4qI1V3BbvP/97PhVlQwDg1LqAJw0rAP?=
 =?us-ascii?Q?djRWIuPyl+RALP0kTYao8p83vaORqu6r9/f4DqkgACTp0wakxlhAHNwMtzhn?=
 =?us-ascii?Q?4DaWQ36/aGnJfhKEQws8wGSlmKGJayOzJ3UHWh1LCpWrcGPKCVfcjh3xWC2W?=
 =?us-ascii?Q?TMWEGYvT2DAcw/8HnHo3l75WrpYF6sTRQqaCvr5VHII6YqGuKRUWGWodW44B?=
 =?us-ascii?Q?HD/hKBS4BVyyJzKjidlKUwPfY2j9gY4wTnOJXpu/mZDQZQeCnHg0FdkjwMSH?=
 =?us-ascii?Q?PimFcpYszZ6r02mTicrcVN4xH6hzUIYOsIydlTB7LaM8pQpB8HzLGCqJ6PHN?=
 =?us-ascii?Q?KRk1yvEi9f8P+mZBgqEgV9rOZYH1qQmXD+5K4sonwt7G7t16Rna3QVwzWi2i?=
 =?us-ascii?Q?8L4TDCYtARUu/cVOThf3bjHKF/FG1uEVzpUm94zyT8rpAisE4tAhafWoIFxf?=
 =?us-ascii?Q?1YizRCncfiuq68vh0NWnw6lMq5e0yKjve/jITAmuUf84xwugaF8Yv/frPmup?=
 =?us-ascii?Q?DHhih6SicqorCPYMBC7O7PCCo/oWPskV8WG6ZRgykuESkIIEurXjy66VLe4Z?=
 =?us-ascii?Q?be5v9RlEgPerda0EsrxsbM9IytWfB7t0BN99CHaHKedHF+7OqpFulxLykiCN?=
 =?us-ascii?Q?kR1MuguFIQlwwPqHN1nIKOMYckC3vIzANEQKmQGnHOT5drAVwn1w1Kd9hIIM?=
 =?us-ascii?Q?2SmCtbmR7NU2JYiVWnlErw+eb0sIkk+gREbQKUhIXBP87km8ZK79MAmQTwMz?=
 =?us-ascii?Q?kCr4a3YgEu6iswLq77769SbKZi1aPpNEy3uX6OMvzMDGdttiT9dK+um6SuaL?=
 =?us-ascii?Q?OY5xNr8Wix1T+XIn1qlLOS/MuP6oj/V+U4B3SwFZJqh7juJv++alpIX+c5O9?=
 =?us-ascii?Q?Qi76TP8OY9Log5GvuCBl1LAjOqUvg1X7BZd4U+J4PFsoRO9UhNM8w2G1jcaN?=
 =?us-ascii?Q?IBrupHSlqab/1vMZih+EStR4p/v/4gGNiLNU3+6FH6L0NFA0v+pYugEHFTIE?=
 =?us-ascii?Q?MREGWrBYbS1PDakqV/hXEhr5SUT5Sba8T2ZyTUdq+C3ejXUlhhGe2nuLAM+s?=
 =?us-ascii?Q?p1jSfxfcA+G82KCzeFnsZWyVI+dhMgT60wHmWoEanQOQxngyboVFHSvFqaQi?=
 =?us-ascii?Q?zqssJT4T+VVic364lcHb0mfwcZzPHDYWgekC5EdaBtS3bX3kNxdPjRpYBc9E?=
 =?us-ascii?Q?CWpztC631XzStsfgFXUKgh9pxjXMekE4t+b54sQJgqDLhKgWE5W7ZmFDgO2m?=
 =?us-ascii?Q?RGcM7OTaborz1iCeKvMu5Ay0kQvekHxg9iQ3YSS+NqIlKf78ZISPINoqSxtW?=
 =?us-ascii?Q?BLXo6Jk/0VsZa8JOZMfDQMHY/CIE6UJ2ncD4EEz+AuYnL5M2TOhZzkkqEaQ+?=
 =?us-ascii?Q?Co+xRGOIELSI+xPPlRF4fsXAtBXpAHrY38/XtGRBV7AG1lPXBTPKqDOqGcEi?=
 =?us-ascii?Q?9Dxjgl8oSKidxbj0XW+cITL2KD2vLhU5ZSVrEjcI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d2d3e2-7fe9-4492-1020-08dd3719e132
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 17:10:45.1318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZMBMz49AefzGi8nYDwqYTIkgnbmMC+++yj+tRTqOdGIuda8buw3BLupG6Fvl5lG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6384

On Fri, Jan 17, 2025 at 05:58:29PM +0100, David Hildenbrand wrote:

> VM_IO without VM_PFNMAP might be interesting; not sure if we even want to
> support that here.

The VMA is filled with struct pages of MEMORY_DEVICE_PCI_P2PDMA and is
non-cachable?

I don't have a use case for that with KVM at least.

Jason

