Return-Path: <kvm+bounces-24000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 283809507D0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A96331F22EC6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B85D19D886;
	Tue, 13 Aug 2024 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UkCvQM4h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4F19EEA5;
	Tue, 13 Aug 2024 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559739; cv=fail; b=U5nCkgCS/mY3pAvLEA3uPighqKK3mVrkkRrSHO/IA41o23leksVwXG6tW+Qfld/q4DDWsrg+evrjFIp2E/BO4ekkmTLRRHeXAekEgIeumCXUj0EeaI+1uDlXJtNvRLRhRFsXEROmi/FMmcnGOl1WPVRG69Wpf0EgOiQIMSSME2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559739; c=relaxed/simple;
	bh=8tOjEClUiFmjLRbk872gACaD0TjcaOmOfIoWOYIML/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KDWepWDaQ4JQ1PxX7ynaf7B6anbYMW7T0wvgmHBu8l7oeivAf0dyNx+QtroR36IQhF/j3xe2PDL0T06+aOzEMSnRSNDKozlrPfe9ftaes/MSeJO7vvoGWc9rgaWXPrE43Y0WSpcvMkpBb8ZK3cLH3+stWePzZGO3Ft2i41hesQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UkCvQM4h; arc=fail smtp.client-ip=40.107.212.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twiH7XHXRQxL2qDHvBct829UoGIrjeeR5okTaM7QIskZIt/8MF2w+hCfbkCl42shTqD0jeon+4g3MKkJ0LpbITlaIC5uBnS0btrz99Hmk98I2qqm7D6Dd+lvsia6YgtYJxcrTW6K3E1/sRnYCZrd4IMflHz7JRZ70gELLpIIBM1ekoFHC2dnZZea2DP93vo/nC9rM9Tl2wgFBXEDSjvzaGs1Gdl3KI/VJrX2XftuSAYQKJLtQo+FrsQlaKP+7tbYuLPjSxt53gOPVTJ9gIgvHsLsdJbBOAc0h0EqJYSrEgybaVRRnn/KkxEUf6QnWP03FS5vygJC79MMOOCNXQjBJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FK308EMiap15ndAxPFYGOZfoTmOZIPm73X4sxG/r5G4=;
 b=L107AlJ0igWT9J16tA/2TOKUb1s0HeChz2qFJ23lbpMJJJyG4lx4zsO87tcyt5Lx7vf3/Zo5prsKaJZaDc7Ox6z6iUbGJY1NX8f+7BKrl8Nh+/y92k+G+FIs4WhaIrG6wXIwEzKgux0wWJyNWnnHcLJmUQ2x46oqQZZyBffAQ9tMriGMj45eDNWx+lb+7eOzpyH3aYDSmUCXRywT4ZX+AmWLiMp94BwCHDb9sK5f4o58CHED0R5UVFJp6uFU7IEvsE4Z5BiH/suo9RxvvvBugQF5TyGs6TeRsipS9NgGxv4lBXyF0p4Kfy0vW8Fo4etmNY6efQpCdx0u8lhb6ZI6yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FK308EMiap15ndAxPFYGOZfoTmOZIPm73X4sxG/r5G4=;
 b=UkCvQM4h9RWq5BnB+sRC67pW0mPElEtv+X6EunPoI5v/FOvvZw/YS+7eJZB+R0h2BoL6pZQKbdi5QE6NooSX3XVv3V2AUGVNwFFZPFWVi+QJQ8F5IaR6NAhfLC1wmXDjEAwI6AW1V2GXue7D6vPDBv7FuLCecXm7/hyVNV6njkAo2ScxFNd93SRmZflrY+IYI482LKVIMCGgLRV26bkX7tcAd9RFVvoOYWu9j2jJg4au2A/kFvS7PyKnZPasOhJyBpjGd+6fd62LeFS9ocQl5fcacTQp69qaEDhSJewz2lXLkGqdwXqpKoZjaXLckPC4E+Bbi190OFcg1MfSv1ASlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DM4PR12MB7504.namprd12.prod.outlook.com (2603:10b6:8:110::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 14:35:31 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.021; Tue, 13 Aug 2024
 14:35:31 +0000
Date: Tue, 13 Aug 2024 11:35:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 6/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <20240813143528.GV8378@nvidia.com>
References: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
 <20240809160959.GJ8378@nvidia.com>
 <e4116985-f8af-4a2b-af32-d9793e94ead7@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4116985-f8af-4a2b-af32-d9793e94ead7@arm.com>
X-ClientProxiedBy: MN2PR22CA0023.namprd22.prod.outlook.com
 (2603:10b6:208:238::28) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DM4PR12MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d43ee35-8bb0-47af-a230-08dcbba52ecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SQ8lXbTj1PBncvolkoP9ODCwrJUNJk0WSukRP5u1IQ9hxm4aPjeZP+au1bUm?=
 =?us-ascii?Q?64rrtE9KPzdCxDYR00iu5YHYSN54vFVu/tkkxN+t5rCYIdCisxiXn8BCnOdE?=
 =?us-ascii?Q?4mpTNWADfWtb0aRSRpdnWM5NOTd+KHOk8nza+ibZ9cCGjBHd67gBnMdN0yuC?=
 =?us-ascii?Q?qlJSq3DxugKeFfg9k5c74dMxyOLnS5+fiIygrrWC8FEsYnuokj1kGLdqKxei?=
 =?us-ascii?Q?8oTAmnDff/tenbKnhpV/hwW8BPCoUzrkZ5BEzVKyYEDoy4y5mM0jzNX0jPEn?=
 =?us-ascii?Q?gW6pypFdvERH0/yvlV6ZCYvEIGw4j1sRdHRWmxCmUFzauYH/bRTudZh9LeQK?=
 =?us-ascii?Q?jpnEQ634Wmt0wkuv1Qb5aV033Sqk2wWdrsO82yfN8vnPRBZBiuct/2MdODnz?=
 =?us-ascii?Q?E1sS6f+SGOVacra4aOEBoWa5CIoAU8wrUNvo4xDSV3E320wY8s906tczq3EE?=
 =?us-ascii?Q?tkypa/ILsUoy2QMYjXhZkPJo731m+wj3h58Ca2nnsr5HVOmC2IrwnqThqtuC?=
 =?us-ascii?Q?/E/UyhiUBet13HbYoscBDfjALsNelQ6b2JZTN+rPBK4SNzPyavZJ2GWluYQK?=
 =?us-ascii?Q?f0IHzwCxiIK+Ix4SAxWcYEs2Xbiy1hIy24nZYcbazd8G74uPzTMK1e17M165?=
 =?us-ascii?Q?gBXkQQ25iPGXdv/R3S/jpez9s7w/3KE909jaGfwhzd+ZFq44JShuUD/NaQO0?=
 =?us-ascii?Q?1iVkxDoP4J2RNv7vuQQXZ1RnoXIutsnwfYJL2YqX22lWwJr0LYuAl2m+895T?=
 =?us-ascii?Q?6fFLQYcSPLf/ABBrH7hhKpfJ/jsVTXUR2LLKpjx3MNGYsh/gqd5Dc/1wYqDj?=
 =?us-ascii?Q?6IGraRrD9BtJYB2UsdfBQfPTJFe9pBwHODkieTptGgAITFjWYWnaBUhcELnL?=
 =?us-ascii?Q?+UouQvsvmPWsiKm8p5Pt4mVlMqlDM2y2mBDuJpHzjTgRt4t6yw1Jp+zqO4LL?=
 =?us-ascii?Q?quKxiXAyGPlCF+hGTFB6ZZNiw2ZWE6jCwW97UStZ6FXjDmsmrPZ9+rE0644W?=
 =?us-ascii?Q?eNuLhAOpWUV/SwFhCcunrW+phH4FLlr9S7rO3RpWB3kBSChYusVXxMpXvcyu?=
 =?us-ascii?Q?heCG8pRmzcn161hLV0oKe1Js+37dWazvJHQQBJeZgZ8rK+Z8s81tXA33Q/QC?=
 =?us-ascii?Q?0vaY6qs4q4/UqgS7nACP+U2e6ePOpXFQtO/Xb31Bl5nBV/DJ2eFpn4h8GTno?=
 =?us-ascii?Q?Ru+aAdiUZnyp2vr2zjD1ruZVdqWoZwelDCHASWLlHEEF2g63qVh3+ET1a8Z7?=
 =?us-ascii?Q?ii0En+opL+IkGOVESnMy+BXFrOUmJVXBVxWfDeK6/lIgCrGIYisswgFcmJ3I?=
 =?us-ascii?Q?RCj9cknC1Y5VWm0qVLRHk/De/LMigoE6/vzTSS6XkxeMCQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lBQdC1Q5AoFlGYc5+yO50EzRCFbaICwnRKjYs4mVL7vFPV6Fag4v48+Truql?=
 =?us-ascii?Q?VW50Lf30i8lVWQa6OAbrdZAWo4rlPaOIFAFVVyh/XyhwhD0JqsAzgCusDBeG?=
 =?us-ascii?Q?ouYryZcBDJbGo3PpQ34ircUI73nCZAEnuXbwYsJPrZqyvjWzuOYTWBFWGPvf?=
 =?us-ascii?Q?XwsO0X4EN548/LtZy29Hu5DVZRXox3YtiTFh8yVpKQr3ZU40mtYdXSHib7Ka?=
 =?us-ascii?Q?cjoRVs3XojReAw+aJbXE8XFWzbGO3NNpEOoiE5jeRVli97K8nvqMUDwCAyiy?=
 =?us-ascii?Q?geR4OZ2nSKt42OAb5ayzMFZYcEHXxDajaX2CP4Iqj46DhnRItDn+7TQ6J0lB?=
 =?us-ascii?Q?Lbc3evNoI1yC0bU0HWBGERRW6Sc2Nx04Y7W5a9FFjrJavKjCS5zJGODbXgYR?=
 =?us-ascii?Q?L+Tg3YgpkU/hzLRV9QrXlbd9YR2fdT6Ch74zMUpjLGrMgHyZLS/abidKybxs?=
 =?us-ascii?Q?rgyNMiQ35XLODPkxdcpla5n0HiEqxTlj8kzPhe016zvQL1y51xGYyQWFjGYX?=
 =?us-ascii?Q?fJGSOyhMCL446hFWCLLk1fMbW4C0D6u7QL5kOAAk0aT3136/6hWSfmQhjsqp?=
 =?us-ascii?Q?0YTJ+GkgoQc0Ut9k7L/s7rlZQXs05KFbNKnrXrvLXyY6zAd9bm2Mg1n6VzVb?=
 =?us-ascii?Q?BuqOEKuH+sld2epwxDgryx6M/zr0eJRGVMx1Ww/FjQdjcXaJ94lQflqbFHwm?=
 =?us-ascii?Q?ePaTDXgADPhXeHARQz6a6qNG/ncyaq7MtWybCyjNhV12ZI7yLwLt5bjmieBE?=
 =?us-ascii?Q?WZ2FsohU3GhkEuvrQrHVcVMtYKh0SjqnAoEcPBkWTB4s/67n2TZ961pkAg4u?=
 =?us-ascii?Q?po990+LB+2DktYWlPxk3Ch9KuIP+VhfBW4i2W6HGcW0X1yvCkRPL6t+H/3Oe?=
 =?us-ascii?Q?WAq+ZoBenFbtX1XkeW+jqE2lCjiZ2dE8KAIyfvkIBhdxs5gPpVCw58mMK6GJ?=
 =?us-ascii?Q?/L2BuFrGNSmNIHfYHVnhxwiAZbGRgikKPNVjCXpXHiMIXcw+fO44GKqtDDOo?=
 =?us-ascii?Q?+BcfPP0LfcPlscYg0pogteBnEYWT9HWbPHapsYJxrdaTRsFJIbYDhDykP9nh?=
 =?us-ascii?Q?svKyiGn+x3TQxmHUmYbALZNaUCp9kgUh6I6LR9xtOjFL35UPrw3KZEai6pJn?=
 =?us-ascii?Q?k8a81/ba6WZLju9PSYRIQ3Sn5BkvNgqf4xmY20ZyHNP68Z2B+l2E+laSTyK3?=
 =?us-ascii?Q?321r+lXWRzI8gwACJuJCSeJ8kxGt3jmL7B3lfhu864BdyOKB2TJkmei0Zqqs?=
 =?us-ascii?Q?I/G84DD0Zu20cPiPbwOj2wW2LdOWwXfVLSmK1LHXeduFdUCr5EMkJMxtW5JX?=
 =?us-ascii?Q?c9Z7iBWWBqKd1KtnyArNZUGmqrEjTw5KU179uRN+0pSSx2+eQjo9fq/Cho7q?=
 =?us-ascii?Q?j3ZiPis83jtWECoSXbu5CKBZwkWKm06u1DWaSWDFLCbMg51QTagJlWTAI++/?=
 =?us-ascii?Q?4eRbHwdyWfT2HzD/gAxwL2Y/hWvv74VYpwAvg6v6os6X56lr0fJTT6nLp7Ee?=
 =?us-ascii?Q?lxzyhQKbPOoje9iI8I8Q1hyOCoTIS7M1dne+mRzEo1YqwGqR6bMJUu0auDyi?=
 =?us-ascii?Q?zfVLe5/mES+9Zetvd1A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d43ee35-8bb0-47af-a230-08dcbba52ecd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 14:35:31.0327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACxQDwUjAUoalwZe4XjFIgsvLNNwjXs2sZqGAvK+KwH9S3tQ9eQSUYrSgXo6i0ec
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7504

On Fri, Aug 09, 2024 at 07:34:20PM +0100, Robin Murphy wrote:

> > However, the above was matching how the driver already worked (ie the
> > old arm_smmu_enable_nesting()) where just asking for a normal S2 was
> > gated only by FEAT_S2.
> 
> Ohhhh, I see, so actually the same old subtlety is still there -
> ALLOC_NEST_PARENT isn't a definite "allocate the parent domain for my nested
> setup", it's "allocate a domain which will be capable of being upgraded to
> nesting later *if* I choose to do so". 

Yes. All PAGING type domains are expected to be able to be attached
nakedly without creating the DOMAIN_NESTED.

> Is the intent that someone could still use this if they had no
> intention of nesting but just wanted to ensure S2 format for their
> single stage of translation for some reason?

Sort of, yes..

When booting a VM with DMA default to bypass there are two flows for
the time before the vIOMMU is enabled.

The first flow is to allocate the S2 NESTING_PARENT and attach it
directly to the RID. This is a normal S2 paging domain. The VMM would
later switch to a DOMAIN_NESTED (maybe with bypass) when the vIOMMU is
enabled by the VM and the vSTEs are parsed.

The second flow, which is probably going to be the better way, is the
VMM will create a DOMAIN_NESTED with a bypass vSTE and attach that
instead of directly attaching the S2.

When we worked through VIOMMU it turned out we always want the
DOMAIN_NESTED to be the attached domain and the bypass/abort cases are
handled through vSTE settings instead of naked domains. This allows
the VIOMMU object to always be associated with the SID which is how we
will link the event queues, the VMID and so on.

> It remains somewhat confusing since S2 domains on S2-only SMMUs are
> still fundamentally incapable of ever becoming a nested parent, but
> admittedly I'm struggling to think of a name which would be more
> accurate while still generic, so maybe it's OK...

I think for now we can block it, as we know no use case to request
NESTING_PARENT without intending to go on and create a DOMAIN_NESTED.

Someday we may want to allow userspace to specify the page table
parameters more exactly and that might be a good API to also force a
S2 if someone has a (performance?) use case for S2 outside of nesting.

Jason

