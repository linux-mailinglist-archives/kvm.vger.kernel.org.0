Return-Path: <kvm+bounces-57114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 785E9B501AD
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 17:42:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 855617BF461
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 15:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2123B35CEAD;
	Tue,  9 Sep 2025 15:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nTYR16jH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B471835AAD5;
	Tue,  9 Sep 2025 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757432118; cv=fail; b=OhZOU4Z1TgAyoABNxd+7hyeqE2bT6ecGN547wYWB0o2sorKZ4eHq8/tFqc7gAmh/68hKzJfTBZsidBWJBJwELiqoAuq16/TGtO0J61Du8ujRYB3ByN3AoyoHyk0CArIWylykgWrss/CmdQ58UKRvrk8C+gRDxVBk8b5QAebjPDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757432118; c=relaxed/simple;
	bh=U2y2ZnPJH8nWdgujalUDAmyYp2/b6S2zJB/xRxEtvgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PZ580YmxbUd68WdT1PIWUt9Dbga1u2WvmpxfhAlf2ZJGDOfRM2KJ5kZVqA/Zbqk8s7h/bvJLn+Wfwn53cvNRvmeRKk/73CtIT1hwMW+SEcZLNNRHmHS5rQqUQt5mnwDceShhDnw/73RHIBGPIBIB0sskCxKAN+sGzcJ464Eum7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nTYR16jH; arc=fail smtp.client-ip=40.107.212.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YeAKwzGuia4nJ0S+IjvzqmpwOHssuFdaN2oBcOFHhpcbtkyYzYUTQcGkDkqpL1a5CfE2Pz4/3GYDqQ734l2dUFRGEIL8sxGD9JtQVHsVhsMAZ1AxVHPG1XbLI8Da56HImGDmP9p40X+VQQco/6gCDB6yWWWV8S58h5QuyFOO5uT6WnKrmegHlxSLQ0JSFQinpvC8e/gVRSOuvVXZuMIGt9XeZpE902dOuAKftEJu6Tg0Ei3E7cwnQbl7yU3tyEEHRv10iNjHV8O0+gqhKLhtRoaU7qzIybGTgGMkjoPmQdVoHUh1a4YOdmtTTN93awvPInxofBbftRVWI20lQzgV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNamLsVjoRqT4wX74IwR/RNZFqR2LcOrdG+1+dG65Vc=;
 b=DFTlbaKJyC2SHlYtLvpved/jnS5qGVhbRFIHB67ocTI/pDT0FQq1hGo3P37bO+dBbAsBLwlIYPzsXuvd6kSd2bWPttnySzOecrywAq9lfCcVNbySXB1ybCZ2zzsWiDx2lKKbB78GfA1iduW/ltnomBvxeeEa8QkWhPrh901k+85pEcaiv2WZ2bbG4koUefssX4W7T9zeGhdUXGbyiH4Y+5dFYvf2knDR+PWN8eeelPHkpvNEtQzCFDRlgm9DryMcsJstOrSASW5MSFYuUdxnI4WtrQH8vxDm1SP0mMLf0svcF+SN/aFsM4fjcpCg2D3GDPOe4nYjtXrzb/JVH8JYRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNamLsVjoRqT4wX74IwR/RNZFqR2LcOrdG+1+dG65Vc=;
 b=nTYR16jHwi7p0nafiAFKlDMKaIm6UY6HPIA746K3tWdQQdhJhA/YZlEBSVCIGCbcNo+A3itLA0MjegFnqf2XgM9p17GEw40hp1wWlCsvanFmBj80E8ZGkUAHEeh3CIWxaQAsCXnMSCmnycaRamEw319SdaRH3CeYE6CO8HbfBKDdMCcIgWUA8i4v1lST0u0pWoJHa53XPupayMFuNoIp0FapxuqOQRbVUTt/6ewiZAoibUR4JERDLD5x+G/e7gz06i+5PpylGOUywZcilprQJfTe4ciojCNwW32Xtqna/J5/V8xEBjsTFYlo56a7tXxfEnzp4usl2BjWUudrn76I0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MW3PR12MB4457.namprd12.prod.outlook.com (2603:10b6:303:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 15:35:13 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 15:35:13 +0000
Date: Tue, 9 Sep 2025 12:35:11 -0300
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
Subject: Re: [PATCH v3 07/11] iommu: Validate that pci_for_each_dma_alias()
 matches the groups
Message-ID: <20250909153511.GM789684@nvidia.com>
References: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <9487fde9-ec40-4383-aafe-7ae0811830f5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9487fde9-ec40-4383-aafe-7ae0811830f5@redhat.com>
X-ClientProxiedBy: YT4PR01CA0503.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::21) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MW3PR12MB4457:EE_
X-MS-Office365-Filtering-Correlation-Id: e47e7572-4668-4547-209e-08ddefb677fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3fksuWysewttfL299N8gxtfeBMCP6zjv7EFRcOY5LybQQxGxOupXRVkMhUvf?=
 =?us-ascii?Q?Te2j6i8QOYCgZWbTi8yx6h3ntT5lWKU7CXgWc0x0y7RKcPXk1ebWOdLijCCD?=
 =?us-ascii?Q?M87W4OU0Rs6hNZJ5OhrRfrwIH6RIh2+EX99ZPA4D8wgjNzLsuRdYWbEdhECS?=
 =?us-ascii?Q?UYVrYM/Y2qYkKS5K1Vt8p0d2in5RjlGxJETRyH2JmCPo3fv5EMOS2c+mj8yj?=
 =?us-ascii?Q?6X6qYDKy69xbQsTGdZaRly60W66F59DftMWGbDHXziMVwwYis5SRGGAOn/Qu?=
 =?us-ascii?Q?hz+4s2R9yy6+gBNsIK0hY9wBcvZDcQCd+SxnV+gS9fJM1QxZIXyXew0SOFnM?=
 =?us-ascii?Q?EzW2E47s4VyzVSsSOu0dQUzjQobkxJCvGXQimCDxIiGzjIDClAiccUsWAZng?=
 =?us-ascii?Q?r8gIs8XuPr0Fia2OFx1GJZUUl83FHB5Ltxqje9YXkQqJhyTru1LSSTAIgMFo?=
 =?us-ascii?Q?neNmMMkualTEbQuAv+qB2OgYIYzwg7QmhcX2X1YE8AcsRIrFtrRyNoOeVvVy?=
 =?us-ascii?Q?TJX5N1Mnjpyzj9kE6fFh6dicLKTnKqdJkzH4YB7lHyaIXGMgZakesMjT0LqP?=
 =?us-ascii?Q?s3frFm0F6YTRa3lOobo10ptJTE6dToR2xD3/Ar85fYfbDc8IH/fGmccfX2WK?=
 =?us-ascii?Q?Bs89oD2zoBPKEzjGhRuQgsk53xHk0oq/N58xp0gExeRHjNYY0PnHgrK7Wq1R?=
 =?us-ascii?Q?LGLjbC2WdZwDbmq2X2azJlrLVSdlX3YRRY7kIb/lztyO/cosuYBcfeiXMtMb?=
 =?us-ascii?Q?g0NqnPH2txPctxH5B74QoaIufC6MtT46VkbLTnmMOmJ1+h/gBYLrpMNbGtLt?=
 =?us-ascii?Q?O6GMvgQoo8NipjJAejWH+ACKOSu/rkKXr12tLulwsYc4Vppbs6UZwI3vj+4w?=
 =?us-ascii?Q?2qO/XzJgLP372B2ZJI6kejUffi6jhttO1bLw9Jn+opMDd62DVYuYGj7pK7N8?=
 =?us-ascii?Q?JhEr2oFpIf/eOHnCb4hUGCFwgk3lTJB1Y+DdJ3YqwciBBWsek6966lOz/4jn?=
 =?us-ascii?Q?o8kzQjKMMi6U6ZJ0A+UmJH6VDdbc4wuePPST28gkfH9ltcnNMcrByJa9oA4X?=
 =?us-ascii?Q?8eQGGBAAukXrpXq5pM/9MBp7DVJhZgEEvI9GopeD0xceGBiVXC+q9izEb60G?=
 =?us-ascii?Q?5STlHDi6QzjPcz4UUIxLhDAGKzonwEa1QEWKfbAgVMzAscHl4yJDUZw5jiEz?=
 =?us-ascii?Q?Asyyij8Eq/nEtC12bUTp/iJvq5oTZ+NRAMXELsNSB3D3XMbMLWjn5ebJQdBH?=
 =?us-ascii?Q?FOc02XbpwNqWJQVVlWCyT9Fx6UyeI04uQImS8qqiZcZSEfjpufcnD8/VTKeY?=
 =?us-ascii?Q?grDdecLGB8QWoRvL64UxWIjXhSlm9HkrPnEh3pdwOv5WUXa/9434lO27u8GT?=
 =?us-ascii?Q?6OLE1dAlIy6HzVGN8Jge08ppsSkFvYN1rlwOrSC854wJ9tgt406P4bDNO2MI?=
 =?us-ascii?Q?XXVBpzqmHP8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u8i4FDIlKLwiEgROgVe632hSU6JQFcOVTjWPzGU0KreYRHYALRQ9juyCaJw9?=
 =?us-ascii?Q?sitV9Na8QoetaAX7EdUekWRYfKyp4Qu/Zt4NWJ8fWpFCsgM+Jza/AStUZvTb?=
 =?us-ascii?Q?qkPQMXFHkwv/gB9ehSBFb+C8ljnKinTk/qyNEXOKkUpaOjfAVdYWkQjX+G0+?=
 =?us-ascii?Q?C2ETtPU0+CppzMZLE6SuSEqhj1jUUYExI5wunuhvrXWMylTW5nw481FheIuD?=
 =?us-ascii?Q?wzbMk86W2R9GJMpRRmNN68Gf1U6t41tAs4A1BqBFPP9Tv3gwU8jlUQV0AjMB?=
 =?us-ascii?Q?Nm4sIX4dqJWEfRN6ChiM47YspfWs3FBkL1KGOZkwYCdLZRYAatZ3NVWtVt0t?=
 =?us-ascii?Q?vxPhQ8ca721BP+e+R37yM9yWz2w3UzlmTCN160a8h04mCv+dukr/Ao+eejXd?=
 =?us-ascii?Q?lAi7AmST8LXalOfsKDe/k5x25Xlt//CrirqsUAGif/ypLGeyhN+f20/wZPfm?=
 =?us-ascii?Q?nn6E+xlhjuWHnHy9cNWkeX9N3Pb4i2XjRONdMxN9Xa5wBamDSwz3pW8FsPja?=
 =?us-ascii?Q?liWjYEapjttqqXwU1C1kAImZ9GNE/H5PfzQf2dGqTDwdxjihLgNxfkdbCth0?=
 =?us-ascii?Q?x7lvDVZwq9E3Qi5urPcaDVgP94TE5KVOqhUFYP24EZdhrTW0XwtSQB1PVTdi?=
 =?us-ascii?Q?9J6VuBeaHaOWPHjfeYsdJvpTdqXImLM8vkB9js6+8YcGGOia78TEibgAKftm?=
 =?us-ascii?Q?aq/8SwG0ujdr+6pcB1hCn9rMKxVb7bhe+gIIC10S04XfIbmjFhosq1+oBV2I?=
 =?us-ascii?Q?YOpuTMXkuQLksEg6Bqt0Cgm8iEC7mg5FxMmL9mo9IZ8NSU23X3WJMqKsTKdQ?=
 =?us-ascii?Q?ot00on1Zuq8WHrb8MeWXapaT7C4JQTk7FLNzOOlSAMd+jJofOR2n5GQaw8S3?=
 =?us-ascii?Q?/KyJ+vFm+zWSm1pcsjen/Vi+im01Xpi+EXsK+HScOQs7dNad28soaKCOfOA6?=
 =?us-ascii?Q?RVblpXnz7b51NuqNrCErzKDRpmuJUKvgOK51BSW5An4omTuLgP/zYXe/s5rc?=
 =?us-ascii?Q?TcGIaFYiGts+5zs2wKK9i1d5th8+aHz+sFHgMR8D7o/fULRwcyfCKfPFfeoB?=
 =?us-ascii?Q?zMIHQ07H7xAew126rpoHOny1sUhkvUaF9oQdc7lC2ijYDqNH9xjLgK8qraQ9?=
 =?us-ascii?Q?omhIAi8XvJA4eM5QNYrc8F3tsT29yGtnfosv7QbWkEiCuSqKUkfIv+xyKad8?=
 =?us-ascii?Q?GBwlMyhBW2I0t+/i7sEOnvknH0caJtNptUtXv309VHEDKHaf/hZyMYuuCB10?=
 =?us-ascii?Q?WlveNf6TjwVHhg7KOJp19C/ScBwB5d9+PYcJUX3Qu4S9b3GRFCNwbbyuZyrD?=
 =?us-ascii?Q?qtTKZtFIAMuc1FfMJHiv6zkMIHzxzY96eHtvAz+mdNEOCMildawVlD6PdzLD?=
 =?us-ascii?Q?AX5AYI0e1ifU1vc1IZB+qHGWW8udfNn4Re6al8avXn5RdwVDuaePHothtVGX?=
 =?us-ascii?Q?99uoeqd2ef40B3rQuQwTq23/4+Q2R4pVkSmWaZa8O+rmePdPHxCcDiTigkou?=
 =?us-ascii?Q?3R2eyiCvnrs1CBMOaEYiImv9z1z3qR1T3Wb0T2Qq9/XO/FIgpAyxSMw8VqFO?=
 =?us-ascii?Q?hgCB02Z7PsxIDG5ttts=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e47e7572-4668-4547-209e-08ddefb677fd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 15:35:13.4237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HeH3E5he9AgZzug3TwpHMpBHO0i7neAuVlE1IDBAUm+80cG7DYwL+SEjxY+7FR/8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4457

On Tue, Sep 09, 2025 at 01:00:08AM -0400, Donald Dutile wrote:
> 
> 
> On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> > Directly check that the devices touched by pci_for_each_dma_alias() match
> > the groups that were built by pci_device_group(). This helps validate that
> Do they have to match, as in equal, or be included ?

All aliases have to be in the same group, or have no group discovered yet.

Jason

