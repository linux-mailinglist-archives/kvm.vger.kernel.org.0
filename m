Return-Path: <kvm+bounces-55115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E354EB2D976
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 12:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BF5517FD94
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422CA2DC346;
	Wed, 20 Aug 2025 09:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eVI9Zn6F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D911E52F66;
	Wed, 20 Aug 2025 09:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755683963; cv=fail; b=UNJkcHhmfIw2Jd8n4JaYYZ6kIYljMYtT5rMdinV5zaEeTJHZLrbxFbmeCDzMY6+YPgp+768rmA3aD3si5hPm4R/Tqhyi4PNswnpjfGHf42GtCTC2J2kSqulkzH2CfdQa4y1lI2Lknr483j+i6v1acW6RWuBemJiMeNG5uOjzN6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755683963; c=relaxed/simple;
	bh=x4l6wBfCgImCUkM2rd4PTPyv96mv8su6Ad7ij9lgO8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hLvI7buUPRa7H/OFFTqSJPf/Gei25/w+pcv3pe4Vq9tbDdcUSeRiAhLfBLsSp5BgMIMwPpyPp08xQOJS26W1ZSuoC75vH8w+11Zmj0leRom3bX2vmuiG4obR9QDzQChgPZJOrZy4JVm82yoAqORI3XFO/zdgQNU2lyD6Ut4RGHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eVI9Zn6F; arc=fail smtp.client-ip=40.107.243.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SEiU2uF2ofACXYHuPZh5Lk7HJgKSvJjcHERW7pmANetw5Q9ZtPJFZxcGqXUimcYUjHuvd3lMfJXgsiKAMNa0MO9HNooUmfWS8NoqRKiGJXDSykfbWG7S0G8pqJVMTy48+QLXQb7gTtAlBZoYS2eqe3eFIMPZDQNeyLsiYClwPUNetrRKjw1n+snXveCQIQgj30vFQmZyLYIkw5a9ub+ZRCEMfw+boPXt3bW3z/RipovVqy85fgaUwM94CZvEOdjehIDEM4Q2K432+RoATih2IUu8agwPPySbGYvi0ev5BEX86pln6CYnVBAQO7bVn3H8WBYebJWcqQwZwiWPJPWveA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgP9701SrVZ+3X8+muGTy0qhj3wueX+c8o/VD4LqMoo=;
 b=n9phMf9ExlRZlPEv9mCBgeO1xsK9otLIABh5WRCw8/somNPwHKUB1G9fXrbTFpvrK1ubhDr3GbtN1k97JzDoVjGFH4PdZAV+oMGKDLrGkGoXBeKYx9ewiTtZFn9bGIgQlT3uNFzpwKsyvcovO00ez+1ym1AeKoHX4afLk10/fc8SuGadRYaxs8qHZrRg9IdzUTYniU8qsfVgBDsCfsohDLnYHz1ZsDOfVN5ol9VyeBcGfURVn1BvqaTgWPWOC7pWjUKH2uSWFKFQOH1J22B/Yir/LdSZOvYA47UrnTHoiB4C48g+ZSnEIVkiMZSOxNtfwW0ry3bGhcE+liMmoptDZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgP9701SrVZ+3X8+muGTy0qhj3wueX+c8o/VD4LqMoo=;
 b=eVI9Zn6FIxtGUMi3Ak8UogsNX1gCrJj0UfGZBA0RGNUhhCXwvl32Qt72QrH7kVOa2r0M6/o5TmG/z7hWg+wLIqz7rtvmhXi+DaNAusOPvOqFU574vYbbXx7hUEl9tMFfqiy6Gg2OMlr09zqimqq3wQKfiC09EkYH5900KdSmvN4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB8252.namprd12.prod.outlook.com (2603:10b6:8:ee::7) by
 PH7PR12MB8106.namprd12.prod.outlook.com (2603:10b6:510:2ba::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.13; Wed, 20 Aug 2025 09:59:17 +0000
Received: from DS7PR12MB8252.namprd12.prod.outlook.com
 ([fe80::2d0c:4206:cb3c:96b7]) by DS7PR12MB8252.namprd12.prod.outlook.com
 ([fe80::2d0c:4206:cb3c:96b7%6]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 09:59:17 +0000
Date: Wed, 20 Aug 2025 15:29:04 +0530
From: "Gautham R. Shenoy" <gautham.shenoy@amd.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Naveen N Rao <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
	Sairaj Kodilkar <sarunkod@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v3 0/4] x86/cpu/topology: Work around the nuances of
 virtualization on AMD/Hygon
Message-ID: <aKWcaPyal4mDfy3J@BLRRASHENOY1.amd.com>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
 <mcclyouhgeqzkhljovu7euzvowyqrtf5q4madh3f32yeb7ubnk@xdtbsvi2m7en>
 <20250820085935.GBaKWOd5Wk3plH0h1l@fat_crate.local>
 <97aace4c-921f-4037-b8f2-c4112b4a26a9@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97aace4c-921f-4037-b8f2-c4112b4a26a9@amd.com>
X-ClientProxiedBy: PN4PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:266::7) To CY8PR12MB8243.namprd12.prod.outlook.com
 (2603:10b6:930:78::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8252:EE_|PH7PR12MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: 93a43bc9-c437-4a6a-0383-08dddfd0395e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?we5fDDw3bL7uvTXiXrAzis4lGvwArm9wlpsvqk+MeNmIxF/3yAk+cH1EQj8z?=
 =?us-ascii?Q?OJ03X9oZPm5qfffWQEpMjVeeNmjjqL0kJSpI7+kwfc7Co5oq2oFTJ/APQuFP?=
 =?us-ascii?Q?VIjsZkTuDyKaMU2hLRTsbl3EhR/urPHSSGnt3eNi494Ba4Y8y/RxkX3EsUvg?=
 =?us-ascii?Q?Ph9VrYJ7pKQsKOPPGQIrcmVLuggkQuAR9lorToZsbYJwBwL3YNC05RtWPVJy?=
 =?us-ascii?Q?KAbJTX1QPmeELLzQ5a82QI4rw3y/JpRjjnCzaOm02kIKeKoOslo5KYIM0x9S?=
 =?us-ascii?Q?6DsbCXq/Sc/IrhVS9IDmNe6r7n2O/EAoYrN3Tdp6vcYoQFj+vLL5uNzK1772?=
 =?us-ascii?Q?t5/BHFKF+s18yL50NGmfQgvDuqiMOST7vUwVD5cmQ7L40NzXvjB1gecGABY4?=
 =?us-ascii?Q?83akvxsfrjdlb9s/dGZqF5OWPUgTgbD+nNSLGya7jTz3hijmuLKWBzvqWL4u?=
 =?us-ascii?Q?MjAjmal0yQqKypP2iVVaUvsPXJbcQDml5RRhLnJhbQTHdrSqmjrKQgPHEacS?=
 =?us-ascii?Q?q0DIGpX42J8RI5mwC0m9a86H+JT1DoLKdAFsyOxFe9DOwYX5zg/plZgDp0/v?=
 =?us-ascii?Q?6zhWgAeHmLu3DiaT9xTd5BtJb8pSlv5Hzh7+fIKEvJeR9Duv8ducQdZW/27n?=
 =?us-ascii?Q?tF+75M2O/HjGCWIl+syL4HpmPsHp95+Qd8hHJmRk/sdHbMhIrU7rBIqNoBZd?=
 =?us-ascii?Q?MJUSh+wJZgygLzGTX29rBKr2ALTYH37k3c1C128TyEW0QARCvvjo3D+urgrp?=
 =?us-ascii?Q?FVBWBtLkgvKX+xJ1TNyLpBBADzsB1LMmpZBKoLsmSy1594AeSG4kxH6i3zGJ?=
 =?us-ascii?Q?ZL4NaTJQU2BzMn6CvlKi1bUOp233MJYkjmton+th2XOD7qGvs7rSGxGb9qv8?=
 =?us-ascii?Q?0TrIayDJQ7HTAJTx380JZPEqqwDbm7HkvCVsBNgY7AdKkwnvcuSsmKBQahdB?=
 =?us-ascii?Q?98DrEl73j7St22Dt3c4dYCm8KMEXp0y2/S7axvDRhWwIikBwN2VUn5FMMwje?=
 =?us-ascii?Q?elO8YgDmXIZqlM+kWmpJTFMtbwWns2papqwRGcWf/o0Z/bq1Pb8j8v1Q0RcO?=
 =?us-ascii?Q?B3b4RXO0A9gqo9LEBeIMN5YlS+sm0wQWIMt3bpKZUB2JcWr3VQZqylle143b?=
 =?us-ascii?Q?9JmZxwth9X7VALF3fevRwylq0i8SXSL4iLkKWOEmw925DkWLPkGGr4LUGs5c?=
 =?us-ascii?Q?LwC0sWH5g8YzpJAVIIX8sE7Jfx/O9PJQo6yqgTI0sMPwTvW6F68zHq3JKaYw?=
 =?us-ascii?Q?tYdxajMFIEgZDgxp40coS851ikDCRNoqODiLO1XmkcsqFlGhDhHuPGsq+Vtr?=
 =?us-ascii?Q?yCvCRX+bktkXnvly3WpfOHa0TJF71rC+563ybJp64D1WqonEWk9IOVpq0ekO?=
 =?us-ascii?Q?OeFrx1qvzo4YF8s+POio6uUDaZ/+pUMqhou/zwwTjxXIs7D7xsp8gR/oYpBN?=
 =?us-ascii?Q?QiUHgILCCrA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8252.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YaAr5+9CeWZVVT5+wNGLwV35peI53nFSy9C0w0jMhLo04xLanFkgaM5cea0+?=
 =?us-ascii?Q?nenHaqUou5dkSqHoMVwsvcnDB3dEg2hfjzo8AoYoJ31ftOv6k5RFO7QDQ+kD?=
 =?us-ascii?Q?rgxITOdBgWN8ek0PShVeJxgCGJfgS67uY47D0m0YUF8eaoM2gxrVMkMKBqRB?=
 =?us-ascii?Q?VziGcuBobEUd/vvfy0p7tgtL+nOJB8q9C6T7OM09Y63Fn2vUFPgfe0kk3iNp?=
 =?us-ascii?Q?+pLSttMOqIyhYTwvD4yl1u8+iEyEbfcYct5UKcgkMnXV2Af1MjU4qVuEu0mS?=
 =?us-ascii?Q?f6OkJaEmGuvO6Oe9mHK/wco72xAcyOmL7EkhjX8Iym76obknXJdYP4Jf+hio?=
 =?us-ascii?Q?9VT02doQDy3rUMHRzPpO5VLgkuDdmIfsY7EsFDh83LhJBdxYA89U2sgzZpI5?=
 =?us-ascii?Q?k5u0cUIButA6xWkUnmwiYUZdNJRcEF92Zmc+DYEN5rzsnaIu+Ye/QD5bmQHU?=
 =?us-ascii?Q?IeLltuKPITmQurF/NjwbAYgKeoRvNYOpKzs65opI3mWc8gjwBKL4EAVdvTsB?=
 =?us-ascii?Q?ZGYcNrvsH47xp24HhLPSwbu64ajHeyeKOPMqCF0FH88qAH+lWAgNvkaInsB8?=
 =?us-ascii?Q?5S1DcRObE25bI3ZvV8WYtGHjQ/l3Rzceo82hB4jVVjr1dxsLre2rD6WYUfUM?=
 =?us-ascii?Q?3RlL+I7PFR/o3q9V7g8r6g6ADqHvvK3D5sjzLpAPv7Bigt+m8w9yvJ3n0AIS?=
 =?us-ascii?Q?2bDvwEFmtT3HTtE5pJZoc1qV+OtUCIsf2GZwNf29lI0b1LAkBT4YeKfeS6r5?=
 =?us-ascii?Q?mxdrGkxAIP2Wisnu0FbXlvAzIYXZzsnEx6NFvc5LlQE2tlVrkiCGUmzhUXS1?=
 =?us-ascii?Q?t+lUqHUeaHP0UWCV+ASz88MMCeo2A4VR1mtNzZkfgDi1gXCA2iBsg3U61NsZ?=
 =?us-ascii?Q?VV+iLoAUpz6nPjaAgb0XqRtNwYVCGeQNOHGZRjI4BI6tsTHA1U1bjPF+CGg2?=
 =?us-ascii?Q?0a+iChHqwrLa+kZO+0r1GE4gMjon+1njeYxy39XliA54pUxz3USHtQLX9EuQ?=
 =?us-ascii?Q?6W+Xb4WxC2xqK+63s0gsgPH+dfXqw6Fo8joRMv9X55wLgUDQ+lK/v9cpi1Kv?=
 =?us-ascii?Q?YSf1V8jCaetlJS2ss3RncX8xTPtj7DvpZWrNJUj6o5QKQn9Y/vcQfs0Iy2dE?=
 =?us-ascii?Q?a6UnNrQEGTfyJAYuRCqIFYpeRWSMc3NlQUw41O2oVMdaeo+HP/29ugQ2CkpE?=
 =?us-ascii?Q?gKtvXiW1PFgpYK5+pKKadBKrTM7g6znUI81GYzxXZe8yzVJdMwkGZsnIEr8Y?=
 =?us-ascii?Q?sOm4PE9H7J0eul51HAN8Yy/ZKbxDGyWOZappdkrHNLmLr94O/KfddKWSWx0g?=
 =?us-ascii?Q?gh2LRFgimKcSDDqZhvRQCmg95iqN02Syti255Uq+YriFn2Q2NFEeXgV4R16N?=
 =?us-ascii?Q?75VxyoLjmY655LzvbKDLANy87LTjKyJOc3COYn42q2hb9vNXYq2rN/qlwp83?=
 =?us-ascii?Q?f3F4ydewcZP1jU2Asf+s9pC2tbN6xC/eMrBtqUHgmwow73+RjkAEiIDTLqdx?=
 =?us-ascii?Q?nvsYWICwyyDSOzYgMxwBw0+4xtqewJbtENQUU2i7qdVbI+/sTreVqkzGSYf9?=
 =?us-ascii?Q?cb2mKQFmhj3d+UL7erXyYAiX+WeyPhC+K1XMBsqV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a43bc9-c437-4a6a-0383-08dddfd0395e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8243.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:59:17.2238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qX7Y7W/rwSdIo48z7eIsF2xDbpUBASqD0p9axm6t8Qj/t40CgyOoIQNdyHNk4jwCVU34mh4pB/4Z8IJI7n4yqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8106

On Wed, Aug 20, 2025 at 02:42:26PM +0530, K Prateek Nayak wrote:
> Hello Boris,
> 
> On 8/20/2025 2:29 PM, Borislav Petkov wrote:
> > On Wed, Aug 20, 2025 at 01:41:28PM +0530, Naveen N Rao wrote:
> >> That suggests use of leaf 0xb for the initial x2APIC ID especially 
> >> during early init.  I'm not sure why leaf 0x8000001e was preferred over 
> >> leaf 0xb in commit c749ce393b8f ("x86/cpu: Use common topology code for 
> >> AMD") though.
> > 
> > Well, I see parse_topology_amd() calling cpu_parse_topology_ext() if you have
> > TOPOEXT - which all AMD hw does - which then does cpu_parse_topology_ext() and
> > that one tries 0x80000026 and then falls back to 0xb and *only* *then* to
> > 0x8000001e.
> > 
> > So, it looks like it DTRT to me...
> 
> But parse_8000_001e() then unconditionally overwrites the
> "initial_apicid" with the value in 0x8000001E EAX despite it being
> populated from cpu_parse_topology_ext().
> 
> The flow is as follows:
> 
>   parse_topology_amd()
>     if (X86_FEATURE_TOPOEXT) /* True */
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>	cpu_parse_topology_ext();

Patch 2 from this patchset, which removes this "if" condition above
seems to be the right thing to do.

X86_FEATURE_TOPOEXT refers to CPUID 0x80000001.ECX[22] which advertises the support for 0x8000001D.EAX
and 0x8000001E.EAX.

OTOH, the function cpu_parse_topology_ext() parses the topology via the following CPUIDs in that order

* CPUID 0x1f (Intel Only)
* CPUID 0x80000026 (AMD only)
* CPUID 0xB (Both Intel and AMD)

None of these have anything to do with X86_FEATURE_TOPOEXT.

So the call to cpu_parse_topology_ext() in parse_topology_amd()
doesn't have to be gated by the presence or absence of
X86_FEATURE_TOPOEXT.

I agree that QEMU needs to sort out what needs to do something better
than clearing all the regs of CPUID 0x8000001E on encountering a
topology with more than 256 cores.

Or at the very least not clear the CPUID 0x8000001E.EAX which has the
provision to advertise a valid Extended APIC ID.

-- 
Thanks and Regards
gautham.

