Return-Path: <kvm+bounces-53987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B03CB1B3DC
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BB0B7AB113
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC19271A9A;
	Tue,  5 Aug 2025 12:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mGMwyyrn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761172264DB;
	Tue,  5 Aug 2025 12:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754398608; cv=fail; b=khGnLUX+9kFYj8VxGhzI139H0L6hFBia5pP8vgu4tA6/VkYgzaCE8YOsvSGbLmtvgzTM6AwpWD7fCAd+Uk/wOj4eTD7hpifG6fTIGZ3j359KUkG1lvmLRQJPK0Mlze2kqnFiMGKL0KB6b+0rN9n5aSXvNbnRhETGXcOv1W8SWKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754398608; c=relaxed/simple;
	bh=o4Gk0VIkI+GjVLBdfXRrI2iWoYBv0vqItNRuIvw2MB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tUJxzpAlhOJ+pbYW+P3TwaA+90kNeO0pxl7GKjngDrLKMoCkb3+Iy3rHhvtig6VkRIwQs4gl+nXk1WwYOMbJpO9CDz4Me7edCJKQ8ZTvcL1mP938JBcM/piwt8uOTnbdXPrIXRTMd+M+m+0fPOlnwGPvCpP+DVMWclIytb8AnDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mGMwyyrn; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WWYkAK8gJDTN9hCwYq0/O1x7D81KTZQ6hBl8h4QcGPq4ub8DMdemRCTumf96e8qUk6mkM2KXGnHZjqf7n4pctqGK5UnjFhWyr73PbFwOMV+C3kNL3dBHICCGymIMLSgfRa6l0yIKTU9ZWIvOoL6+RTwwn0AgvPQbxx9G3yg8zPA0gLXsTZTAp+y7DS/msnM8POHWbo+p0xVnNJwdz4vSB+xITluAIK5K52dkkAPLgT/TEve/ElyPMQcVu5R3v8O56SlfABTeOn7v+ppTnXbQHzL91wFJv1lxcacin6dez4nwmiXqumKQkreqX5Z84meOuPPhmCr9yQjHtIvQQmbweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2uaVV+TTu5pFGSwsNlD82BKS97YA4icw22fCfszKQI=;
 b=JFNyZK9SymuKsVYGgmTuWALEd+PjKaK13mb+RFE32NykLFnhzS69iY8uJ8zYfSazWwRXFDeeAF77S/zohfX8BL0PF/xkID8oCKOy689cgBvLE/BKfZQHeK1LotvvkNo2cXqi6KQ9M/edaGv3oJOrjGg0H/gypiDLQI4VG+K6cMR7oREanhPMa3Nip8RW+Voryq3DyqHITGxst0B4tA+RyZtC3CjQDXU1LqoUJcmyjnpybvbWApjpeGxdfU16YcHb4MAihsmmP/DKtyO+VUOoFCYAm++EhdUv18TRW8zao8meEgaVZ5vlGQF4n3JNPCNmSIa37/Q2p+DvlYgjovT32g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2uaVV+TTu5pFGSwsNlD82BKS97YA4icw22fCfszKQI=;
 b=mGMwyyrnO36Ed+dbMCpEWhVu3SRR/Uldm0cv3vYfozZbGajIu+RblAY9TMzfjmHEpdeWR9b3tf//F/LMZxH7l5FqVSxKYgi20w/jxsaVFJVmx3dU8gisvZi4pfAdFc4xFeXYaaC0xdgCq6zxmz1jG9wITXNzAIWti0zHr8z4B5EUfU6VwqXtkLdqo9pc+3wylzuM8XsPqcHE9JCmPgJlCm7kbwSzlhkijKMi+HPOPFXvEBNDULM3qQIyzhiolGK1ft8n2X/OnD/iltl8KtgZGy2yY6WkJAf87/oxzK3yG+Qllt7T8Da0jNo5XzdakCUhdUuieU8O3v1jv8w3EgcYGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS2PR12MB9591.namprd12.prod.outlook.com (2603:10b6:8:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.22; Tue, 5 Aug
 2025 12:56:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 12:56:44 +0000
Date: Tue, 5 Aug 2025 09:56:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250805125643.GK184255@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <20250805114908.GE184255@nvidia.com>
 <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
 <20250805123858.GJ184255@nvidia.com>
 <db30f547-ba98-490c-aaf7-6b141bb1b52a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db30f547-ba98-490c-aaf7-6b141bb1b52a@redhat.com>
X-ClientProxiedBy: YT1PR01CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS2PR12MB9591:EE_
X-MS-Office365-Filtering-Correlation-Id: c95fddb1-d656-48db-655a-08ddd41f87e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sSOk6KmqOi0xZ/TXgRKLGBjqOwhVPkLFwFKemCDo5Or6ZSE+FmZxd0RoDrXu?=
 =?us-ascii?Q?L+d5i4usoM3Apia3q7NiKS6u3rUu65WUojOAL0b4pqoP9Q1ZzWEwUGtBxzEi?=
 =?us-ascii?Q?ZTclJJT+RyasEar7kbJHPEB82w8g7OxIPPhqFIAQ5MWsESN21sw++SaClS1m?=
 =?us-ascii?Q?9oMH3E/Dig9Gs3aFJznIwhXb20oAWAAsL7r7J/c5eeGChfn8gocZW2LLb/ad?=
 =?us-ascii?Q?uGDbMcCF8rCPa58V4GGkdjV9YkhcSQs+euT539NLrs8JJ+9BMuuJZaPyYMnX?=
 =?us-ascii?Q?5QvI6EUf4ym27yKLpEHxkdCzKa2NYqQOFCj8Q1AD7saVMQ5BGqiTh+sxglxw?=
 =?us-ascii?Q?x3RmGfBbE8uxt3U+0oymnGZLbUCs9wJUApw0cXuwR+ZhkptwqsSNE8S+envG?=
 =?us-ascii?Q?7NQbZ+3jQLF9pZycjmLz0SorZ0MuwQSWmdGdLrE/uTlyDHto6VTIyCNkFgyf?=
 =?us-ascii?Q?xkJmB1VRQqZA5MReybkqZEXuhK089svSni4bc4faRnFoizaVbNlt1myIVWZL?=
 =?us-ascii?Q?E/JOoJmzBpNR2SHOSCVUbcglJJ3P8Bqdvax/hPU9J0uaeNXE4bZ4N1qvNr7L?=
 =?us-ascii?Q?fHChtxXozBQj8Fbmb7lcBr3P0pcvlVf/5R9liNHpOECONNmeFiuOsPMx4J74?=
 =?us-ascii?Q?lV9uphHdQ8GE0pDL7bUEtZQdFJpLgnkTBIxv2K/aJwwrbYQwPdn/4U29Rl6B?=
 =?us-ascii?Q?9Pe8OuQ/Fi/H3hUnanYBINb0KsSbeTEUw3uSTG5qRW2le0P1j4bBZsE+FLPB?=
 =?us-ascii?Q?fS4Jx7NnRi3shDsMmS2qN0ii33zkjBk+eNPcn0w6SkgLm8qfK3tiDPwbtqr2?=
 =?us-ascii?Q?iidpthq8j6vFADYEXF/hZ5mH5eCLf2oZs0Nqp2jgjmbKHZqazQpIPefPONQx?=
 =?us-ascii?Q?nDgn+R8ssjmu2mw+3gAZn4HNv1DPT9hEnXsBRItyFMKwPnkm/Ughyr3+Hxw5?=
 =?us-ascii?Q?zSsSZrqeHKayb1I5Scgs6MVIx0NImjAiMFSmIxgA6a5NImaWE4JbQUDaKkmF?=
 =?us-ascii?Q?r5z3l1ILYl015TZDee1rNxLo0S109FZm94oA5Tr9TtFEv30ja+5LUR/wfBaj?=
 =?us-ascii?Q?epdUYYONx0gguDzehgL0HLMMLftV1GFWfj0xO4RCGIrxjVUQi9ziJAittIYk?=
 =?us-ascii?Q?xsld1ipAlQ2A3vDAzp+JO8iWO6zhQ2zDJwIdrPli/ZbVFxWfQiMOnvW9Z6TG?=
 =?us-ascii?Q?hf86B3qMFuQWO7gLy8KRdMsGF0mt5hLLMbqnOemuSxs+5NZQMsDggvXSIubn?=
 =?us-ascii?Q?qnvw/AZjqR7cYMWtfpNUcSgaWQSoFXS3zH7ts77oez+loYaK5M3g8DBKJLSN?=
 =?us-ascii?Q?/bvQn0FEjciVGSQW+I3de47dKhq6Ezbb8fz+kJtwnucWJaADbVoq/k1IySwE?=
 =?us-ascii?Q?4Yr/z19yFgaiTb02Mu4Vb7vzQhhtNfMlBNk2Kic3hLB6XVvYSA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HZ8KIdGFrihR1N0K+zy83fT84e9Af2f4MT2G4Hk6Y0EK2Y3FLVGPBANY13wR?=
 =?us-ascii?Q?5W0fORrHLK1IWmUamWMcYWeUEl+/wKLWFXxIImgmUDfdKNZYFPffGVrWsBEb?=
 =?us-ascii?Q?a7PcH7Z5bLcS4YZQFCQXK7iUSbYXZln6OqTkiLSz2ZCOBwrRTSUX4R8nONR4?=
 =?us-ascii?Q?OUP8/QpIGY1t1KrxnbfDHB/acScQ4NKD+AOxIj0AQN7ewyYl7FXHZzlir6Jg?=
 =?us-ascii?Q?6YEcxlfLtr9/BD58fr6Pumh2hrxCERzOwAhKwurUUCwqRrHjf/++DgV4VE/9?=
 =?us-ascii?Q?oEjSUie/8S6B10fz4GHqu+CYvu4tn7Vl1XhZGPaJ95t2LTBKj5UBVkdTXvn1?=
 =?us-ascii?Q?uSODrNniR1R9E7iihWAusYIvuCg2QtZYwebc8To4jdASHnF6N+E/EPqQL/gb?=
 =?us-ascii?Q?ZJ/WUfZobuZ+VxPEDTj3P3ICporUPNAE1RDeOzBz/X43qFcq/QWp6yj9737/?=
 =?us-ascii?Q?mp4KRXqHaYh+AiUp7fq2XuiXnYRkGEwHqif4EXeWGARBtgsIXtWthjmLbcMT?=
 =?us-ascii?Q?UaBKZKYWFtGImxLcjY1/qhktSV8ulvorJt9DEMujOWoIg2VIVgaYpBiJpsmR?=
 =?us-ascii?Q?IfKbTTLOKR4WWKk4lcz+FkFoWhdC86pppf5iZBZntvFhOAibTtQIZ1ose9iz?=
 =?us-ascii?Q?ZaDb304PT+ItxrUTqKhHpKmGAteSUI2b3Zb/CLyDxNQlnlXcvc/mk2FYSwoq?=
 =?us-ascii?Q?nq/3jD6io5AUPc6qCksKbe5VWXL1c8VseTBzTSfY7LCIA676mW5W5f20pM9+?=
 =?us-ascii?Q?24APOrnQDxtAmk3LuNGd4smDPhKnprsQTZ+wluHLf4Q4XPQ37FFCvwMAjjMP?=
 =?us-ascii?Q?N9/qxg0w4Xsb4JNrpTM3VeDpzwBtZIgBC0ciKi05XhYQDGjvnIcHVXdzFB79?=
 =?us-ascii?Q?vFmpgq/2IgeVk+E81I6h8FeDBvziN/2GJLVIABtty4+dGiewCoveI0jMTv3P?=
 =?us-ascii?Q?YslcATl+j0zGmc5L6TlgSoOGdFxF6qOGErVoS54XucWaGUp5cqOO81/EgZgB?=
 =?us-ascii?Q?4LB1VNxeDWgzcBa7qVxXqX1zuXpZSuSGYZGPRl059yyFyuOn1Xj7U+kW+hFj?=
 =?us-ascii?Q?w5WoDyPL61Kq3/Kgfje1OpQQlOKQFMpbEa7TrxAiNccnenAaxuzPJJ8bplGB?=
 =?us-ascii?Q?7EMuLndprg0mzjRLpdc2Wpx7FblJNtWTQpS6Qgpon8wXZXzxojKyi6MBK9JT?=
 =?us-ascii?Q?LRYHS7R7HHwcVGDgbico9cAjBYoIPPbH5K2FcVmi0kI+jOYzrDvg7zIyYE7r?=
 =?us-ascii?Q?vJCCG7m3hQ7tZZQ4jYl2YtNN4uD87I6nDl81z86+vTEQALyRfjtiDgRif0dB?=
 =?us-ascii?Q?AXVpHOMxp8MFdgsmMj8kPI7F8hb/XYVVENFO4S4YdF1N0p6g+bTC/LI7Zq0n?=
 =?us-ascii?Q?oHZNAg0x7y/HV82TQ/GcticPbhryChgqvxLGvdXm/DelsYd+3tSrVQpPBA/Y?=
 =?us-ascii?Q?Qw1/fcHGMjlWsT2JPDpA1z8Yysl/2BKVxBooRdT4e/pst2917/B6VESmn86R?=
 =?us-ascii?Q?E7oYfaWSbssOoLt1A8nr1KvECejgafyiZ1sheRQT7F+C/NrZay3TUi8gpjY3?=
 =?us-ascii?Q?xbFF2YSME6UrOTq/HKQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95fddb1-d656-48db-655a-08ddd41f87e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 12:56:44.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zJsd227fFkNRUT4KGhlHNwAZMBDsrZZ97g1a/Jz6IvcDgXE/jpw7sj1GrjH/5j2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9591

On Tue, Aug 05, 2025 at 02:41:38PM +0200, David Hildenbrand wrote:
> On 05.08.25 14:38, Jason Gunthorpe wrote:
> > On Tue, Aug 05, 2025 at 02:07:49PM +0200, David Hildenbrand wrote:
> > > I don't see an easy way to guarantee that. E.g., populate_section_memmap
> > > really just does a kvmalloc_node() and
> > > __populate_section_memmap()->memmap_alloc() a memblock_alloc().
> > 
> > Well, it is really easy, if you do the kvmalloc_node and you get the
> > single unwanted struct page value, then call it again and free the
> > first one. The second call is guarenteed to not return the unwanted
> > value because the first call has it allocated.
> 
> So you want to walk all existing sections to check that? :)

We don't need to walk, compute the page-1 and carefully run that
through page_to_pfn algorithm.

> That's the kind of approach I would describe with the words Linus used.

Its some small boot time nastyness, we do this all the time messing up
the slow path so the fast paths can be simple

Jason
 

