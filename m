Return-Path: <kvm+bounces-24134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D81951B08
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4F62B21702
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF3C1B0128;
	Wed, 14 Aug 2024 12:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="odQl+Ky1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871E19FA86;
	Wed, 14 Aug 2024 12:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639273; cv=fail; b=fUlJ+r8oah/L+a9Rjboo5pjOQcHl2VDeaLEjTPzdYkDEXo0BjrAy3iSIJQfITfuTiZr/psMYXzqLXoc127tXIZEXr0WShcuQ9qZ0vR2ipbwHQFg5fBXpQlBtapnX31rDS7//hAAK8BUp4xRLTQYHM4tN0fcmVuHHi/373k1/63c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639273; c=relaxed/simple;
	bh=8Jr+m8DX9+QkarcQvzPs4TZWaY76ZMiBYVbVxcwom1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qlIzxF06EL1uJRzFO9hu88P7Vs/u6v6CIllFaPc6L22XUrJQoclNJRcAZdx9nSTNyjG8CXzBT121DPJ0O9w4gp4hhVcTafU3RgpnFWX8dL1S2zTD1rLRfQG/5dY8dagak//XGOaD9otYKShFz0ceSTQPoxMiLWWvEk1zReAdAcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=odQl+Ky1; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AXfyxJJKhh9a+v4Ue7rJKE3/gFgy7bJmfZAiZSXZECQ92kCcDUYk2tyTJWiuTkh/4q7FgcE7u9BhGAwR6lFvqRkr/FwApnXImWWW2fjYsQGKobb1+gL/jY5o0Bt861ne+m4RgVCCFWH5f4RJmoZvHJncqBshNPftpO6lvsO76mrRqArRx8EXMi4naTrkMDhuWxaOAyvg3kK/naMMWE/kGMYfg2W1xHk73GygvKYXiN63HUNvmw5KL5EXf4VHarpae8To9LRifSCWFXAT1MayFSyYMpkS1u14o6diTKo8UnK52G193pg7GcuiRX9nWuWwRgtXspqAcYu8Ko75OJG7VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JLUpVB8oWyuD3hQ3M5lhytQDNTxH+qwjEBXxBIa3Rs=;
 b=TWYaaM2Z7QPeORZ6Ix/19HxNOLQOhXlclTufa6GrLuiRtIrNRw9+M3D762vbUwxRbZrr5EtMCeNOMiTQj1ljJ8kNfNsf1P+i57GFHOSNuG+mxKgQM2uBbIQP/CJq9WfQQXTHu7hOQTBWLHx9znwxIHXA3vkpbUY1BQSS6VQRZPqoJmIx/LNjJckpU1FsmJyTvxff1UifjeDYpY/bSl5x/R6Dg/3jWD/a6dB6+u1o0P5NofK5B4l2V9vDfGcJ/x/B69jGnJGA0OBnCyODcQ1m8AQd915hwSh2xoQIjdvmhprOsKpJxuNvIQWfUfdmBnYIh9vlbLPWFuEDS9yywwj1xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JLUpVB8oWyuD3hQ3M5lhytQDNTxH+qwjEBXxBIa3Rs=;
 b=odQl+Ky1S3ynQoIlsYCOGB4ONDq1+73356yLqZIU30EROzzPcMwtTLQgV7b8UdKmmB4zLY0q/ndfH1mR8WgYHheC5rrOiCL/gaaGVyjZiA8SYn6/wf9rwhrFJz6od03tO273waW+vVzAleLmqInWKIcB/pb2mpgrdsykLtGDwt/FR/fQxAnWbclwiOpxV33G4zkvSjN7h4r8mA2uLprs/vbfpnfVp7nEHav5z1AewOVWP/yemrYe8U6UKXZc/kX2gMZHdw6HaLlzRTqsgdvADL+B19eZbhcKn91cAluEi7ZeciwDVAqvx+SoPZvRXoi0wxl+kSGQ90tByvuH82B5+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by PH7PR12MB7332.namprd12.prod.outlook.com (2603:10b6:510:20f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 12:41:08 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 12:41:08 +0000
Date: Wed, 14 Aug 2024 09:41:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 05/19] mm/gup: Detect huge pfnmap entries in gup-fast
Message-ID: <20240814124106.GF2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-6-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-6-peterx@redhat.com>
X-ClientProxiedBy: BN9PR03CA0915.namprd03.prod.outlook.com
 (2603:10b6:408:107::20) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|PH7PR12MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d8a53e8-3cfa-4be8-066c-08dcbc5e5e8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kvMABoCGjXN3FWtB0TZz7J+8eujMd3AZK1BPRGF1gI0tsKd5QktdpWD5lwSt?=
 =?us-ascii?Q?1vgdkCskAnl0JvipphXV9CjwBiMMlOSIQiG8Cx4fJU/vIGRix2YZrv0hvyoW?=
 =?us-ascii?Q?7sUQOE+euSZIAL+EFjFPRUEp+aTe+Pi0jvBAqvw22wPIrj6vYniOG/HC2lKR?=
 =?us-ascii?Q?VmxGRRnxBaTbO/WgI1ek8LK1RjDxvaIimDvXmpJmpNQgJRG6A2yuTon8bnNF?=
 =?us-ascii?Q?sEinC5N/GTncHSGl8ch9+/Y+80HEsP2lIxy1goQEl/SKs1yJWdsUjyqRD87p?=
 =?us-ascii?Q?/3uaUcZ8Y/mUeb8AgWFfxgzIEZFCHi1WzANrTJmFhLbc5q+jIkA7Z4e70DHU?=
 =?us-ascii?Q?f6v3aXNySg/g/V0RjbhgprR/nu1FH8ufBPyngmzMF9CfaclTeD2zxWavLLCA?=
 =?us-ascii?Q?wb15F1l+m76BbKgkarOS0Uas0XaJ92DkeVIHFiTOqHY/IqyWlNQn41K/SAOJ?=
 =?us-ascii?Q?V3asjIovWuV7v4ffqKvWViMX6c7NU5QEmel+4NcCvw8WPnMq7aMp5T+0nIe9?=
 =?us-ascii?Q?j9TbWWiaTSilvKw/Wk56P9yNHLiZWbI6ua2KrvqORrj4/w0FhHTGKy7+cSxo?=
 =?us-ascii?Q?FKTs4zMfA5naVKBd54Rj8qdIghNISXXByA8tFu4KN2QniF4fInhZZD+XRw8w?=
 =?us-ascii?Q?Gd9AYF9TMY7Gkrr6/bQv+Eq+F+kc8NFPYjyiYEBKrl0oPHlm3fYxdkxFikI2?=
 =?us-ascii?Q?LkmvmZfb2i7edSGo8UpwEEk1uBa8eui4uhzeYAtd+L386fw1kMufE5lLsXbx?=
 =?us-ascii?Q?XQId75bQe8H2GBkF9ZDIYsJasJ2BkA3Qn3AGS3Fc3csFTEoK0C3edVUixKlt?=
 =?us-ascii?Q?kqvemvSNxa3LfNgi4YF+CUEuX+W50/HCr90H81tRciHhWLwZCG8Il6xXJG0V?=
 =?us-ascii?Q?hqUly3Mx9InEreZbn6oldEV9uKeKrKjgh39JtmD8P8MRIhktH7LCYPxsh8qa?=
 =?us-ascii?Q?oxHOfTcvJgh+X801kGzkRaEx++d5/4LAmC+UU2gywLx4K42gDknYQcMezgvR?=
 =?us-ascii?Q?Had0LjjceW8Y0YRd5vxxwOGKHRENCOQpXuf5I1y5Z1iPdsguTgS+PVwn5fKL?=
 =?us-ascii?Q?HM2fZnsmoKqPYnyUh83rp+us/xQjwDYKE3OS2He0WC6gbkyxtlW0Fgo/jZJ4?=
 =?us-ascii?Q?C60Ds3xa3aFVPJ/Z3ejoJ0txSsZt6VfwixIIBY0olLxazc6AByJAEZIDTaZm?=
 =?us-ascii?Q?kMbWnyt2ycHXzlHGl+V1dZQbOjbWfIzYxpoMYkWsZW9bXfWntBYKV4qhwCLw?=
 =?us-ascii?Q?/QROakIFaz0Uh84DwJcmQ8C5WOV0yTgXj/9ObPAvF98LI59z8pVhzYh6MwzO?=
 =?us-ascii?Q?2MeEtHpqO1Ei4xlIb0KAf+zlALFwG0Btz4d6TRDxRNqaNw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vimFX+VDRBhQEJqNDnHDWj8porlW+PN+k3mPabVDOy8oKMr2opH3oJzEV0te?=
 =?us-ascii?Q?ewgwmaumCMk3KqvDOhqUGVf0qQLIjyzxbF4BrhHF6NHKyC4P1N9AZ8ORnq4W?=
 =?us-ascii?Q?Di6CVj5tV2H3k1cTX1s2nRScLHKgy+Fb+5mqiN11zkG5PEIQlqx1UvI51SjD?=
 =?us-ascii?Q?PbaBnsjG3mI3+vokYdYRgv96+TbAA45SoUYJl/0nvACTwGLtLgkBUJrnBxKj?=
 =?us-ascii?Q?2I3CFwaMMR90nT52TXopX6wms+dQVeI63WW6uT7J4yZE9fqvXJOtL0GtbZRy?=
 =?us-ascii?Q?eXlF3CrLNnK8Lyy5zVR4GVRozCil3LZRFIQNDwlR3L1lpLZjTqQBVVPWsxxj?=
 =?us-ascii?Q?VRCCC06bccOoz0f9/BPqPKQJ2ffxscRsmk0VMD0O+DwVk+81Lwfv373G+qQ7?=
 =?us-ascii?Q?Nr2GuDf7MFu7zCtTqs8qTTQExMb3EFUbGOWQrIHK1D1X1a9b0/zvv2cR9Zky?=
 =?us-ascii?Q?HsexskVSgIdTLQ2QyYu8XE753lTGMNRw+nRNPyRhf6hKdTljbEzmL4D0wXSC?=
 =?us-ascii?Q?qXwK+Igsg56D/FkSKUnPZObKvfrkZli0e+2X8gEfZgfkLE4a2ADCo9BNgq98?=
 =?us-ascii?Q?wZCu/nXRf11ewv2yP6FiFoPKC+MelT7wHyI3HfEvAOsmfloW7/HhOvZSHcDy?=
 =?us-ascii?Q?YsVvEUjE9+9IkxtowHuzzbcSjilxRaDjvlJcrB+vZtbI7z1nnQw0VPkM8nom?=
 =?us-ascii?Q?KXwDYxR/mZTAtN9VU8iQ7/ZrWocvUMS3LH6cOcCHh8iWGoOVBKcqo+yiAGBS?=
 =?us-ascii?Q?RR6ZkWzobDK2AjzZP5QhC0wX89M4k3p54UD1CQZBzTR7cnzsleyqHgNutK4S?=
 =?us-ascii?Q?STEqc3TsyMa1tw8YoI+KJRljwU0EnQcdLb62K3gMwuhVnTa/fkFfHPu8K/7f?=
 =?us-ascii?Q?0oaaLnBBnIqawkRotVUDlcTdjvDWQpXzvcnm9fA97Gj5ra01AB9wtMiD7FXo?=
 =?us-ascii?Q?j7V73mzg8fA8Mfh9Fes9eKRhqf0twqRv30lElEOhZAA/3cFruF6L9vD4Unsh?=
 =?us-ascii?Q?8WxXrPECklCsA/KqijKIWGV536bqDP6+hQ7cZsZTjwgK5tZKdEzosse7w2EH?=
 =?us-ascii?Q?6d4R1yxwGxpetHGtl/X+xgCdrQgNYYbf03e/5VpEe2wjd4fP7XxkmVALXxPT?=
 =?us-ascii?Q?Za+m1ewLdO8cON5o0fwFCFTbpV2Fua/xJAwh2UGKg1FCuVyjXZsZPWaLzDx7?=
 =?us-ascii?Q?+CY59pNBcjvUxym0oYx1Ed8m011uL2Qq77ZONSK5Rd8EHPn0aDaN90kMpC7f?=
 =?us-ascii?Q?fgUKd59uflJ2JfBlZmaMo5cWRvOhw8YkzDjpAWWAyijBe4RkZ5XGt66ZJTRP?=
 =?us-ascii?Q?54K8vh1AH0A6SZvXmdwDf9C7W41NQsL7jM1dFokz7yEUlFXyuy6aAjuVlXi0?=
 =?us-ascii?Q?niLzqDb0c+6QO2VCSmwbo369MQbh/r6bbPcgUq+X4i+LtK4qK8WyvD7UPAaA?=
 =?us-ascii?Q?uR6Ad9MdLoLJ1l06uuMLJK9tIAHyVyF1M2GN7FyRfG8+n0xoSHwujmK4paP9?=
 =?us-ascii?Q?e2G4kNRWKPB0CxPfSxYYEQr+HKbNoOj5GlEAyUTP1GPDXygRYRNSKPL82HjR?=
 =?us-ascii?Q?oS3mZvUYU2+zD/7kqF+tThZFrtAKf0wv8ODc+cT8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8a53e8-3cfa-4be8-066c-08dcbc5e5e8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:41:08.0909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7dOjEw9RtINnv19dgHKprJWgQxXhXjY5+b3CJCRHdivY2QK2ftphD0vpMYlN4aW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7332

On Fri, Aug 09, 2024 at 12:08:55PM -0400, Peter Xu wrote:
> Since gup-fast doesn't have the vma reference, teach it to detect such huge
> pfnmaps by checking the special bit for pmd/pud too, just like ptes.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/gup.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

