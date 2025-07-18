Return-Path: <kvm+bounces-52892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 699E4B0A539
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F83F4E4B0A
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73AC5131E49;
	Fri, 18 Jul 2025 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HqxMPZYj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281722557A;
	Fri, 18 Jul 2025 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752845584; cv=fail; b=BHS2zMbGFk3kSZHM4fTagyA53t4WrSO7zukUg8IQzb9I/eX/frI+i9CmQEic4a+p/puviJP+xHyL+ZWCIFZOpm1xW9GhN2JzqK/MbbnP3hLKB9Ve6XkLmUew5V64C3x7BsVXsfo2ISoYLGiWTTIgBMN5s7A5eZ7uJyEfEA6/hMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752845584; c=relaxed/simple;
	bh=phXPoK6DrH/aXFQYCnQvps0+j6mhLOQIx2ig/CP9xTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GrVWAfLF9LyWbGqQxG5KGII+n6E5XIfhdFsmjeHHPxlpvlvT9XOCvR8TpFRZCgiYSCWRlzBo+leTzDKrB+tTz2iAgPnO3x/F9+iHB5/EbkS7bj+q4FVugP+BPfqfvdBWwTVW2uzxjc+lUjIe64qd0KoCfbqnvTrNjNaGq3+6vE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HqxMPZYj; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gsazm6j3juHe9s3+C2tnT8HR0o+8SmJP35SB4NpmJB+OntecsrVCZGvWVMHx7Nya0nXtLe8c7/JKcgQEZxcr86qMvorV9xTTGGr5DoJ4ybEXL69j+UHooF5OBRDIV/QW2NjpG0mHPTdhEoeeOv7dKaNTqpCdWfSFdEc//iGquqFgGnmPzydKesfObHL1Qzn/9GETMr55MZlS9C4bTYv3Nzy0tOrBCkhg/BxVOQceoNXNWEmX+WX5Eh4MG+RQQaEkpCI4cOyzgx2XxVpZsYVf2luYaqDJ5d9eq6LkXolzRMMxWBuqalcfryL0zh+RfMCugRSC+/Mc5SnI0iG0jspjxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwJV61VoUpHZD9iTxx+vnZyAjoXQ+oJcrwWtzdWYabw=;
 b=H8a6Ukd3I/ZaoMppL0cAFRm5ZzIbW0ev8cPTP8zhsHRzd52Pv8Yg2W6+kQeRzh4/or6NOvEbugdycLgBADeEIb88Dt1ZZFdDF2CZ4a/1tEGx55ynGLudVSHRPmN9aKEBo9ThkCrDfWmO7MNF6SA5cIotfvsUVQqcJxh2K5ta0/6VhLXk0q3Y1JMn5XkuZQsm9pjZJBmoXkPJ+VeYqAWpj5D217Qa+LzCJzpkP+Cl+cHtpPUQdy4OCAJyVGmYsjy0nHpWkcpooMpGBZuT3ILUnPZpM39Hl6cCLqgouQoXosTOzBJlG2xME0ua8OubcV9+4PXyKCx/yyom0ZAfOVqVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwJV61VoUpHZD9iTxx+vnZyAjoXQ+oJcrwWtzdWYabw=;
 b=HqxMPZYjd6TPp7TPfXyt5PP8eFaTWyKlQqDPAwX5tD+GV2OE8h7BLFXmlV9toZ8DyrFeSSsBZYmOjCCL4FWcWgX7ut83c52ozNarkgxXku9goV+dcHaUiFiiYYp5NERZ68Lkc2ni26tiLjFdfdPNWNczMGVmoLHdIlzKAsV8wGjf6ZNH0AQYgMhbNEs43NnHfpEAhc8eiNrSSiuEyuOMLYMyIJU98/OM7EhPo6gqZ5zfTTfDrHaGlymja0YMMfQLO2Ihrj94tEY+I9eI7glFf8HkUZ2/9MVTp5wgos+62VUDm1NRLcuTGXdILBvusuPIbEFs6Ya2dnoiHb30D2Qj+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV2PR12MB5751.namprd12.prod.outlook.com (2603:10b6:408:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 13:33:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Fri, 18 Jul 2025
 13:33:00 +0000
Date: Fri, 18 Jul 2025 10:32:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250718133259.GD2250220@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
X-ClientProxiedBy: MN2PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:208:23a::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV2PR12MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: d03fd789-d4c2-4cb1-8af3-08ddc5ff9d28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m/q+9X/Q+G0ajEmpb+CiLQgm9jLLN7x+3DZjZQBbBwx1uy80caKrzr+OZM3+?=
 =?us-ascii?Q?SiWp2u+XrBx1T9jaPUsGAGeWDkFiKJeeqyoKYlNza3fw3wq4UleXqXlaRbAd?=
 =?us-ascii?Q?EFHD6LYF9s1Qz6VjuCeZZBGridH8d+FEClZQN2Hzf0RpQUp5A+Es5J4haCBV?=
 =?us-ascii?Q?6ll8Zdb+TOLvSIzuLrulzhAKyf5HK6YzeZ0xdbXgA46RALYvoq4mwvWKDjaJ?=
 =?us-ascii?Q?AxUIt3Os0lkyquttOhOummlWHTsqTM9AqJ+qVukvX+BhfYZG47rGBPpZbAEQ?=
 =?us-ascii?Q?LLyHnFLaRDw91m5Jo5SRzKfzN2TLEleq7vR3SaD/x5mFl6cpIDkAoyN8uVCK?=
 =?us-ascii?Q?aIgVVYJnXfxKnBSKa1wEHp1+Y3ZhVtRHBKcFO7tTOeBPrV68Rf/Zz2JHVaUv?=
 =?us-ascii?Q?PfoX0sm3DmdC4mTXWsd/fFkbDA4aLa90vL1d41wi+Qw7YBz7+jvPxG33UcB7?=
 =?us-ascii?Q?epEt1OVzZeqhXf7Hw5qGUmMLfGDcnrRS4s++ki5R8VFv953EQs0sLb3FHmEo?=
 =?us-ascii?Q?QP6jh5vV1DCD5nbGy7mj+3fJMl4RndMOsJUNt8spRPbmPibRQEnbKf6sdLlB?=
 =?us-ascii?Q?k/OpS7J4iOrmUn7G/lUUMZtcc0IhO7E7wqGSOUM9kk8mzbnhSmLh3BSNeTyn?=
 =?us-ascii?Q?dck8lH9WmgxRS/J9hBrjLPtC9d4pS8ypLsE64AeWL6Rex1Nk0VFJ4YFR5TdC?=
 =?us-ascii?Q?lQtWgj1iSs1IhwgY9ChfZE1cvfzHm+4w5nmh3mzoTvXzWGGI+Ndm26+b6Zxw?=
 =?us-ascii?Q?d++VacJ/xEwHwnCYnvAlOSi/uy65LReIL+KDdsn6cjpcJNop5exhxSXthZ9P?=
 =?us-ascii?Q?3vDJK1cHKDxRT6S6hrsgKw5myZ5ZKaCoAqlFsf2X/1TBOzJC/vtskwOF3iZM?=
 =?us-ascii?Q?9X7nnJy4qgtLcm0LT1qngTR5jVqLSgOp4NJEmeeHVxVaP3gyysgbL29058dN?=
 =?us-ascii?Q?a2ZIZBnNfNgIlcKAXJ6G9nXFVBBJW5/mt0g5DUmJGEU9Z3lJCTddibkKciOT?=
 =?us-ascii?Q?6TemeNZ+oDb5KLZm0CxeD7mqVD/bYOtxwGh84jNWCFITzOqEKx9Cx5r9owDa?=
 =?us-ascii?Q?s/lzDUDRK3kVBtyv3562cJ2LUz9CnZXP1CbFvyGQHBtQuzooj40oalJdbfF8?=
 =?us-ascii?Q?P6tRuYXSKvKtI3jko6eJizXSQXpUkHG0c2Ljdh0duYVJIIwtrisziRbSJv3z?=
 =?us-ascii?Q?bsyYk0IuEORdrnEV5UjeW/L+GdwJWXs8kUuuAO6R8hZM+MlbDgEksEhwbX31?=
 =?us-ascii?Q?Oc47rZ65WglDS4ryT7oHE5Ob6F1bb4aKpLx5SaRjdo9kxIsW2EO5BXQEabrc?=
 =?us-ascii?Q?JD/yQuX+YU6XiNub3xL4+IZf3fcW7LlDbDE6hbfxOQrPOmrNdJMuJj9zh4xt?=
 =?us-ascii?Q?R0ExXghJ9jS/XU63m1bcolXUut9BgHgb5UkBELZcwn2BdM0Erf3FEWxgVSel?=
 =?us-ascii?Q?UMjREu3Qpuo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fg0XJOqbDU9NBZOU1lLnWIYRgu53i/qvVQb7/SutbwYnxbfXAghiBFxVn673?=
 =?us-ascii?Q?xTtLIn/XX2xKbF6iDzv57Gf5h4i4Skt4xjKo2gghsDzoyJmQNcKVfVWbvr2h?=
 =?us-ascii?Q?c/pa6/GzysE4oWSXrADaDL+64cCVarXJeZzvKiFj2SAeRTJ/RYlg8p1VaHj8?=
 =?us-ascii?Q?RJjXcm3+ldCy/4T4UcNq9s9tmJl9jNPeHVrj6PtIWUCKIMvQZkas1jBwr2E1?=
 =?us-ascii?Q?5mu7UTf5qdI8pQY1AT9lbrP68yZ2hS9bWiXQZijvJ7BeBHa7A7xCvP4Am44F?=
 =?us-ascii?Q?/CQ6uPURPnQw6lJw3qs38GwOrZYWDRmkoperAN3lInWtMB6pGJp34jk5Upaz?=
 =?us-ascii?Q?sbwSn5msk8aYBqLUnyU6dFOuaEj5yFLiZ1CTQ7G0N08FHoPsLqWUPwjujgm3?=
 =?us-ascii?Q?AcjFOot8zRuc99MKcqb2K3SAQNsxnWvVg1Ja6Vq7QpblMY2qna2smyUfEPPh?=
 =?us-ascii?Q?QYbnJ8qxGBzOQky1pGuVAMz1O1Nh8fGTXc4hWP7A0awyHkvV4I+qtplo8Y+a?=
 =?us-ascii?Q?04MgIjGeHOT8a77SwihBV2H4RshJuZhZmwF9pCJDQGEUxxKJxtXdzVj0qym5?=
 =?us-ascii?Q?35Wb+pkxPU+CPAUdREgd1KguME3fg0YJrS109isOTOJGHAm4BlYoG/GyYXzb?=
 =?us-ascii?Q?sdnzzzYN+C035Sh6KWOTrjLMyXotLyj6p+GanUYgP4ECBoFzywBz4hX2hMfe?=
 =?us-ascii?Q?p0HRIDuyUTCAZzwgpi3uSs70KLx8PqxaU2RDUGd4QQTThq+Wr8Sl8R/r9D6U?=
 =?us-ascii?Q?Fsvx3gf2FuwW/0ZLzKeiv80y9uGbcfxl4HiFRCf8UrBQ5eqTdbMfILvR8SY4?=
 =?us-ascii?Q?g+GF1xr7xMXwrqSeNEwAkr/DPNejtKa4I33/M+zgtT7/P0+HsdPaH0rTxuE3?=
 =?us-ascii?Q?Dt0uz84QPL7+vfKwRKQMmnsa2C7GfsyAkjTySbzByf9RZheFWuXoUzIAmPCb?=
 =?us-ascii?Q?B23jbXp2PUrmSvbcf/fLFlxnfyCaSFYJtHVW4CWz9W4NS/Vu3XzVEq/Sgy39?=
 =?us-ascii?Q?8pi3T8fapKdU/V076PUyGjLFG2Y2hJTXzzSLjXLlL2r+cvHlPaVBxpRul77F?=
 =?us-ascii?Q?Um72TKRpwh//fzwW+k+Xm+tQ9j7e2v1dv7jqIeeMjLVikuMzaaFB0PRbiaGl?=
 =?us-ascii?Q?CfYWRR5Ipga2lEq9x0I7g7+/inK6YZ6QN+XSPuBZ37ixpgIifz64ektxbyy9?=
 =?us-ascii?Q?6lcW/fww6nR+nuOZYZaRBkNxkjaNmmiIqyXp/eA9t6Z0RRyPOErazNYJz0RI?=
 =?us-ascii?Q?3dwaG3oo67fuhkfHIl81rPSOphZkLl6qZWi5ovYQKPZ9qNMiycZjnUM0LLUY?=
 =?us-ascii?Q?RQCOZTSnnPM8kZZ5qmIJTlB9sMULJ6jdBm1eN9IvjEorvPQlSUQg9SM5iBcV?=
 =?us-ascii?Q?CakPEQ6YSpKl5L9xsN4yDhNQhh74wSsFpSkmylVro+qToO9Wvh8Pq+thvrgT?=
 =?us-ascii?Q?U3O9aLZzXacJKHHdnwrqTXmy6ZEa2kp3qx25fwHfI5Keklvpk6zNGEid3lJg?=
 =?us-ascii?Q?jCR2dcZNGMo1CqKn99X84lakUgufDq347Ynuexgm+4Ak6fZqteXIK6rvcWq2?=
 =?us-ascii?Q?9JGMrn1jUCLI7JSo8NGka7A61/ByerZmVJu9CZf5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d03fd789-d4c2-4cb1-8af3-08ddc5ff9d28
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 13:33:00.2464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etoFYUy9Ll8XYHzNMtiRNt7EaIal5WQg2QyxOg3uUOJZS2l1ixGlkWPKjCAD0uZR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5751

On Thu, Jul 17, 2025 at 10:31:42PM -0400, Donald Dutile wrote:
 
> > > If no (optional) ACS P2P Egress control, and no other ACS control, then I read/decode
> > > the spec to mean no p2p btwn functions is possible, b/c if it is possible, by spec,
> > > it must have an ACS cap to control it; ergo, no ACS cap, no p2p capability/routing.
> > 
> > Where did you see this? Linux has never worked this way, we have
> > extensive ACS quirks specifically because we've assumed no ACS cap
> > means P2P is possible and not controllable.
> > 
> e.g., Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function Devices
>  ...
>  ACS P2P Request Redirect: must be implemented by Functions that support peer-to-peer traffic with other Functions.
>                            ^^^^
> 
> It's been noted/stated/admitted that MFDs have not followed the ACS
> rules, and thus the quirks may/are needed.
> 
> Linux default code should not be opposite of the spec, i.e., if no
> ACS, then P2P is possible, thus all fcns are part of an IOMMU group.
> The spec states that ACS support must be provided if p2p traffic
> with other functions is supported.

Linux is definately the opposite of this.

Alex would you agree to reverse this logic for MFDs? If the MFD does
not have ACS cap then the MFD does not do internal loopback P2P?

I think that solves all the MFD related problems.

Thanks,
Jason

