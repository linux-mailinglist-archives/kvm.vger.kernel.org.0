Return-Path: <kvm+bounces-48107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E11AC92F8
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 18:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E9957B2A22
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 16:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08712236424;
	Fri, 30 May 2025 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VEC7U5Q+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B57230BD0;
	Fri, 30 May 2025 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748621160; cv=fail; b=S1/ldz4honvTtk5+5rr7vgQwpPDZMtXu2t2uD+6LfgaVACuufQlWVqLeFSNnwv9gEV2XYu9JnbAgtRyp46ogLvxNghgCIZ6Oli3maGAcweBJ78lFdu+d8Em9KyFtk90s/rgGoEaJo12qSWHoEKpgqOR3nh5P2qUt8eQylT9v6rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748621160; c=relaxed/simple;
	bh=KiTntR8i14a9L6vp+KFogoHNZMMoByHKpb0FBXspdOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oG37eQfImYTSndRt3wEREdFSYi7JvJSjd5wBJr677oRyosJolBbYUgJ9it/WaOvzeN1WKHVof/MryrhPJCpXjk58kT2xz+TusNqhCLp2ritq1uLU0bsJ3W2cxe7tzkl9bV7rR12C7f3dsmbpk06m+N+zQcg+sY6YsNSSPZLXKgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VEC7U5Q+; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K/FwSnbgtv1qgW1xEs0Tdiy4kr4boQ4xWelVx7Goqqi4bC3jw1zu2B0Cou6wqZVRfN5GW57iYGExcHkC8yv73NE7n6FQmNwZe9PiawkXnoIrPDw4fPpQWSEf4yKlt24j/vXthRsDtKK/gYJ4ABP2/wVBPyb1NDv8Xdpq0Kbm1B+d2q9AD/le9U+Y5d2F9lt0Wqb7mZFIwKk5B+MMKyG/+7TUoviAcOnpnif7SS2vxx3+q+cn5hKeeVWmXBpzpVd5hCDoch1iFQR+wY2ljmXw/KLZuKQGMYTmrfO2wuidYiJyyIn+/vWqjI1Hp5bKiUZlc8XMJ14mNBuNfAyNNzHh2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0s3Px3fsQulM5PPCE4GNDb2Rg7SbLnYAtEzWIJ4+yQ=;
 b=UXzCzYSobjjIC66p6y6B1CcKi09auDZTk3PbAThAf3F7TLkVze2qvGXAyXmBVfVowc7P+hwVVAJBKaBPnn2IIgRf6+Iiww5RUU0LCVCScW4VKdxr6+7Zt0Y0Crpu97BmeBM5XaHtVqK44kxEis6bZbIQNm2udILvL72Tphh6633mp0u439fUXr26KwPmdX92ydijUuOnRHzDTMKogNEUbluLjIz8m2jzG68JozVBedmi95EJS0xOnD2uPUFf+9C2Wz01msskzMktxrrJat7zidHsfZeEdT6VV1hfeHBv4U0WERmIINln+z+YM37YAW0Cpu9zEBvKQPnn94QINL4IpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0s3Px3fsQulM5PPCE4GNDb2Rg7SbLnYAtEzWIJ4+yQ=;
 b=VEC7U5Q+iGFQUiRumVDTfzAi9ZoW/R3q/siYEWYg/Leaz8sAUdx/UscSS18+GB5Vrxs3zY9w/hEiNPrfu1VIdG/t6DG6tEvYJV5hMSTrmK3+2pOJg006OZF6gm01OcUgpTeBg0nteUyE6p17z05TgGuIfUTNJKhmh+Ybvvu8dZw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by CH2PR12MB9541.namprd12.prod.outlook.com (2603:10b6:610:27e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Fri, 30 May
 2025 16:05:56 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8769.029; Fri, 30 May 2025
 16:05:56 +0000
Date: Fri, 30 May 2025 11:05:50 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, dave.hansen@intel.com, seanjc@google.com,
	pbonzini@redhat.com, peterz@infradead.org,
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, bp@alien8.de,
	chang.seok.bae@intel.com, xin3.li@intel.com,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v8 6/6] x86/fpu/xstate: Add CET supervisor xfeature
 support as a guest-only feature
Message-ID: <aDnXXpm9Ioj0cZlX@AUSJOHALLEN.amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <20250522151031.426788-7-chao.gao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522151031.426788-7-chao.gao@intel.com>
X-ClientProxiedBy: SJ0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::8) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|CH2PR12MB9541:EE_
X-MS-Office365-Filtering-Correlation-Id: a9aac3ef-b1be-4a0f-ef6d-08dd9f93dc3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D0cDzu2jdfGxFPzonk8mSRzrCZWMVuj9DROsuZkH22j2oCqD/PW28wWTh3Df?=
 =?us-ascii?Q?YMa1yCUQz+hmUe6Ua2NyrNdKTbSZossCd6OmX8euWnPv2KnasvYz4ndcJBd2?=
 =?us-ascii?Q?4ubFFIASkNttgT/J/zIgV5o463aU1C8UmW+QdgS1Z4W8OIaX12fdFcRgx0iW?=
 =?us-ascii?Q?K3U7KSCFwY2/HWZJDFPSz/0//aPoZwkOlklEVDz4/vDw49prK6p1ywjhzTS5?=
 =?us-ascii?Q?e0Z6F9Ukx5sBjVfWUptz5w7aFZCyfFg/ypAXtDk837d+cZgj87Tzq158ughB?=
 =?us-ascii?Q?xmdQnKK0DtDb7Kpl/BqO7RUegKKj/7wHcgOaWqhgbDe3eEJ/WUURsDnqopv/?=
 =?us-ascii?Q?ZzXiid/+9uBkF/NyayDT+/vavSKv01dKPqWrjEFqt4LQ/4gvGqPi1cKqH6ar?=
 =?us-ascii?Q?lMyS+SH57whPgq5+56vdYYXltlTSutcJWJcheV2FgawMR80CfSIw89Td98Oe?=
 =?us-ascii?Q?zHeDPvUQSmmUG1jMMCg8x+kxTk37HgL6TYm3Afuxf/EsNpHy/j73AtuTqvwe?=
 =?us-ascii?Q?XkhTJxuw1GoOwfCP3PgYljZY8QIhX9VNefbEBrCBfOaK+PkQRCX7PpAh38+C?=
 =?us-ascii?Q?Mwk7QC0XXL9ZXfHIdT62jOGJhmXb3mSc49VQaMGegY/0MsBSP4JTX1EKWrtX?=
 =?us-ascii?Q?kCDSM0MT77ydxh76qS+Y/WgdlA70Fv5Yub9UlIpSXal2C77M8kQjc4nXueZb?=
 =?us-ascii?Q?ydZfAObdOuCE+VF0BXrT7q0rI0ebxFTvilrMnVibaFjyvYZsiHYZE5K/7Xy6?=
 =?us-ascii?Q?8z4kBk97PIPURIZBLHh2dOunctjAyTqCoHVgNvZjAWetR6CrjqERkq9wjBgJ?=
 =?us-ascii?Q?tGXIrcX+yKTRcKMUJoSGfIq3HyZYzC+lX2nusSe3lHneNnRBbvIuKRgINEnH?=
 =?us-ascii?Q?Af9aIU8pkn6Iufm30fpyNQYf3sfzEavkZmvcGVBsrkI0h4eVqfZ5Gy2cLKdD?=
 =?us-ascii?Q?GaoCj34INj0ou6MK7SDHFXupAA8LamDchNjf6jP6quRjCgJDBVY616KTXXwo?=
 =?us-ascii?Q?jAop0smDjUZRJ+vCgVJySeYAttCZYvcON13EBmsm29NHqnnZJF2bcj43EP1J?=
 =?us-ascii?Q?2iBerip9eyddk4IdySdFkBn80XAzaxqvMmT8xBoN4dEW2fX3wXJv4Y6p4AhB?=
 =?us-ascii?Q?P///ppCqZez5TvdeYOqXA6SmNG4Dg1tYFI/8ct2j+MuA/YnjfHM6u8JHjk10?=
 =?us-ascii?Q?5Z+jSqS+7FFkssQpPZQTyBw1jf9gXZPQxIqM31PAQGnAubOmNZ0IKmMEJipF?=
 =?us-ascii?Q?RlqWBuqTjX3zkooHL0ktsNonMsfShMH/ZPgqaKTCNZjA/9/9qMK/OLwHVNI6?=
 =?us-ascii?Q?y1XZbCZV1xPupNalxKqvZMuXkZ72/j52i1XTRJU4mBOy/g3FZ9aMIwTON4zu?=
 =?us-ascii?Q?v1KRgkaU+cqcrs/nnVNpyPter9fYE7/nVVaoHV4Gu+hd99V/0qqho/ebPr24?=
 =?us-ascii?Q?7bsH+QJwXXE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TijvdUS/eQnzfAI7yu8JmWclgpwZA8bBtEO8zpq5ZnaUfCN+fEYu5mPu8+dC?=
 =?us-ascii?Q?+9w67uNy59JYAytYmz9VD6MR5liS/gBk8PjpPQEa/glJvjg2f30DLFFniY0U?=
 =?us-ascii?Q?Jk1IOlkKdBpusyk+JuyQxP4ptY2iH2kqJY2WogcHNyZ9W2UyOcoZnBn9NKtF?=
 =?us-ascii?Q?pYk9T1jT2GSMoBUE9EUXS5f2od2Duyj8dVf6QdCZae6FLKLjhuy67NQvNugb?=
 =?us-ascii?Q?HfjT3XSC4ijaQpK07mUJjqii6dNp+MmH3rP0ipC320Gt/6oEHOUBoYIw54JJ?=
 =?us-ascii?Q?N4i2RyJDT/iX+V8qiUj+Qe+UOq8DU1bm/x8jEX2jgaCzI8sONBO3WxCyftwX?=
 =?us-ascii?Q?BlmUVNnyechf5EZgav7ZTIpQedF8gsDVvKw0B7gZMwzgw6YikGsR+4Pll6J+?=
 =?us-ascii?Q?Ul34krwuu9e4wMJfkCNzYuLVbNez7oxaZM0JYuJp9iSO43FfQbXxiscVCOzO?=
 =?us-ascii?Q?EnHGJr4omekYNm105uOLoWLemFspHLxps6Cl43CB0uo/tmqefu46JGoQBsBO?=
 =?us-ascii?Q?Zqv3b8sNS2lW/RrvUKv6bHX+jomd5r/cH8b0ROphYzzhzySgDEt1kuhSz0Q1?=
 =?us-ascii?Q?oVw5MqhVyDa8wOXQd+fdRM7orcAfFSbRJjPxLX3unARb+oOmTl1ismMGC018?=
 =?us-ascii?Q?mIT5dXq5ZUdCwGHcIpUe9f1lK3SjyZwx3ZGo/qbWx1JisT8Km28xpv8q1DGr?=
 =?us-ascii?Q?kC2pceDiWzCqGBtyoiKfRsQAU7GbAY6gz8u7LRUsLOTSCGeioyUTJUyLS51F?=
 =?us-ascii?Q?48zjccK560idgkoD6rjrXulqcDxHR1iJfwMKNjF5lo9MwF7oLY8ZFlHs2SuP?=
 =?us-ascii?Q?m+pGvDXJvG18G2VPGjRz1SAEUaiIvHnsTwB8mYQR9U1Sb4J37vmQ7lpN+Pu3?=
 =?us-ascii?Q?WzQjfRu8UalO3eZeYJDSagQzW+WRQcieEo01gWh0N2tCpSg8z0NS1xhalSnA?=
 =?us-ascii?Q?+C26IoMO3g4/EfQMrqpF1GKEDhF9MZakYPQ/VD2pUpAKO4axC/x19C6n2jFN?=
 =?us-ascii?Q?6N9WIc08pgzloD3unWGXJ+7fhu+5NRr/20v4iczNZMGIiRJSLc42XaBmmPK7?=
 =?us-ascii?Q?RSvK6wuEH6B3ubPz5PL77EHEKUWl62bKsDNI3TjXcNXkDcwRT7Xg4mDpuHR9?=
 =?us-ascii?Q?r2M39VX0e0+ayEwY+ACfMfhKPLJfUt9SX5+Wkn2TBrHyZnWQH82v1llGhzlX?=
 =?us-ascii?Q?FvIgR4NZip7JtT1uhw/piZzx5SRM0Ga3vWumWBkM/az+saWDXpamR6kcxChD?=
 =?us-ascii?Q?wP+VpuRAYMWc4VJOnK/jtz1VwJuE9neC5bSCQEkZJ/AMvVPMWEn6/+aqzDg/?=
 =?us-ascii?Q?A3yWHx03aNgPR84IjRQ92gSn8T19DTOXqQR3JrZ35FFQ3GQvuEsKKPV4Nnlo?=
 =?us-ascii?Q?O9HzvWW6zDLBMwtv4lrlAGkZmAuMJ0Jsz+ZfBFJ1w8tKlOywKMEbzqnmsyP6?=
 =?us-ascii?Q?fAG0g44HB8EcRvMv5RAskGlhxDXSoOcs3yzMNjzroJnRAL1DhyTA2vj60Vbi?=
 =?us-ascii?Q?G1Roeg9wmJ32l96Qk/WEK+rysHtiw7a2jJt4F56rFGaa4nOm4BMZZAFt7p5b?=
 =?us-ascii?Q?d+4aDUREfquD1P7DmgryzSjGnns0rZpUz3Ctnn4H?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9aac3ef-b1be-4a0f-ef6d-08dd9f93dc3f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 16:05:56.3198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fe0c1MiCoNM10afkthf5VpDR4tWZuMte9JxssHQdxApJvx0kO8eUAT/L8l6ckhulMudLcekTv3KMg/mlKENSOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9541

On Thu, May 22, 2025 at 08:10:09AM -0700, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> == Background ==
> 
> CET defines two register states: CET user, which includes user-mode control
> registers, and CET supervisor, which consists of shadow-stack pointers for
> privilege levels 0-2.
> 
> Current kernels disable shadow stacks in kernel mode, making the CET
> supervisor state unused and eliminating the need for context switching.
> 
> == Problem ==
> 
> To virtualize CET for guests, KVM must accurately emulate hardware
> behavior. A key challenge arises because there is no CPUID flag to indicate
> that shadow stack is supported only in user mode. Therefore, KVM cannot
> assume guests will not enable shadow stacks in kernel mode and must
> preserve the CET supervisor state of vCPUs.
> 
> == Solution ==
> 
> An initial proposal to manually save and restore CET supervisor states
> using raw RDMSR/WRMSR in KVM was rejected due to performance concerns and
> its impact on KVM's ABI. Instead, leveraging the kernel's FPU
> infrastructure for context switching was favored [1].
> 
> The main question then became whether to enable the CET supervisor state
> globally for all processes or restrict it to vCPU processes. This decision
> involves a trade-off between a 24-byte XSTATE buffer waste for all non-vCPU
> processes and approximately 100 lines of code complexity in the kernel [2].
> The agreed approach is to first try this optimal solution [3], i.e.,
> restricting the CET supervisor state to guest FPUs only and eliminating
> unnecessary space waste.
> 
> The guest-only xfeature infrastructure has already been added. Now,
> introduce CET supervisor xstate support as the first guest-only feature
> to prepare for the upcoming CET virtualization in KVM.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: John Allen <john.allen@amd.com>

