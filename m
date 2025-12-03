Return-Path: <kvm+bounces-65252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7A1CA1FCC
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 00:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C0543010FC3
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 23:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53292C029C;
	Wed,  3 Dec 2025 23:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rRlx7xPY"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010022.outbound.protection.outlook.com [40.93.198.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40177296BCB;
	Wed,  3 Dec 2025 23:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764805736; cv=fail; b=tCfNgXLcO5Br/szNsQNHCAV543iucEU6iGfdWTWkQxQRMUKF0B04jggKOZAj3FcTDIAVyELr2KKe0EsfZZNmgh+jlV75w1XE6655OdFIvybPH4+C5iLqphDV7mEGDhp2fxmrW3ROzexkMSpp2IbRKagNtV3IZuanWbGcpk0RxnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764805736; c=relaxed/simple;
	bh=imySu7+6TmljWxST9heLuFi66+oS9b830NR0j3yhmQI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R85a0qtBClbSR82ntWnmZv17uPtah4xSsmwDxIITtMZ2Q2ljukzMrxQgAX3yFbl33GRqs8DGL/6urtPzXIF00WtEDEdAsmmbeSo88lnKMU7IKOlPT1JZSzRPfS6teKKZvvnb6CASb+pbdB373euJc4k307F9xhVHABG9QdAz9uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rRlx7xPY; arc=fail smtp.client-ip=40.93.198.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZdE19deJWBdEv5YYlPtGKURjGzBggyaw0HtJelBD3OWTbk1qiW0r6BaZU6u+3upKIZiloc9JCCiHbnf3v1jVnohzi7odRYJPHPVDiQmXUSb9Ak8G7/eJOS1M00H1zDlc3eMH+3psEZUn7j4FkilMVq2seZIkSEUT+T5tofhYpphbqo0s0+sgmcW2v4vSOZReFZMZeYQMR877R23TYDt6PgTTTEwwEHVYAhRDSoPdchqag9MVKoDDj7wP4xSTICLlO0Gro3EhapoZRdZ5WAWvmP5rfknmEOkYt6IWuV+7QhaA1XjfJzfQ9Nfy3zpY1iVNsrS4Oe9KHJOiV8NilAXv/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar43r4y+MzRQwYTx9xB9dTnCj9DNuoVarzpPyTxnQdo=;
 b=rmmmCJAIgWLnJJiozDKQyWv2TNY0dXYdIBUH5dNhymIRQRhb23E0fiM+6bVEqEa+SlnNUjA1g2AfYoNOQooGnNn5YM3vkj2ftWoKCF2uP7CN78TJ8asq7EWehi/JGNeK74zI4xmpgj8hHuHLXdZF+elFEej/HKok5Q+8Cb4Z1N8owkEscE6QKgnQwxAtYNSrn4GXoiGwJZIpUUvQGWO+QSe2EYUiSKqbKxscC8A/vS9Xc2f6hdzLmHzz4JYz0qPXV562Q0uhw6IXVFTwrY7obs319EwvA6UhuF+mCtYEM8kNaC/3dJwQIUezgoE3Ud84TaJDBpz5edmftoPfftmByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar43r4y+MzRQwYTx9xB9dTnCj9DNuoVarzpPyTxnQdo=;
 b=rRlx7xPYgVlPdWPBSFk+VLxRlO2WqMu4MihqbqgUJSqHX4zaVlIgsTKJ3GZ/zdqF11nG0xXj6B+H++0h5ySFTVJCaF7UoVSi0qtn2KnNHEHtRYy7zfRwkQs+3Foq3wqtvAuQGG3JVdcyiVC1CDUdz9m+zuvdASZrQiJ7IV+qMxo=
Received: from CH5PR03CA0019.namprd03.prod.outlook.com (2603:10b6:610:1f1::27)
 by MW3PR12MB4396.namprd12.prod.outlook.com (2603:10b6:303:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 23:48:51 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::83) by CH5PR03CA0019.outlook.office365.com
 (2603:10b6:610:1f1::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Wed, 3
 Dec 2025 23:48:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Wed, 3 Dec 2025 23:48:50 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 3 Dec
 2025 17:48:50 -0600
Date: Wed, 3 Dec 2025 17:48:20 -0600
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251203234820.jzzmrqxjeyt5w6gf@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <CAGtprH8gznGJ6VObk8aShBn_XnhwDoUzyzTkaDAe+MyiNsJ-NA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8gznGJ6VObk8aShBn_XnhwDoUzyzTkaDAe+MyiNsJ-NA@mail.gmail.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|MW3PR12MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: cd8c533a-c0a3-4bdb-95a1-08de32c682a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHJjc1JGVVhwZXpJWkI4SkRRKzhJZ2YyM3pNSGJkYjNkbVh2ZnpuMVYxUDBN?=
 =?utf-8?B?c3RDeEswUUlBM2ZyYVBUTnNSMTN4R2FOSzc1aFRyOE5nQUhKTzFIUzY2NzJO?=
 =?utf-8?B?RnBZYjJHZitsbkVPSmpQN29PV0RqRTBkbGtGVDQ0THZBMDloeVNqUm5uZHox?=
 =?utf-8?B?V0JnVzlUMVRuUHdnOC93UW9sdjF2NUdsQ2RieVpncENyK1pXck5DVis3OFBa?=
 =?utf-8?B?ZHhQeGVyZ3QwdUFTYlE2ZExyS3A0eVlMNlVuQlhNSGFEck84SDF3bEtoQVAv?=
 =?utf-8?B?L0lFYWVLNkIyNnhuUDFCM2JSalBuanByV2JWcGxYdDQ3QzdsZURJWnNMSTUw?=
 =?utf-8?B?NHdHT0xud3R0Q2NjSWN2M3BKbWFHOEgwQk8zdXlEcTVabVV6cnNHZFZSSFZ4?=
 =?utf-8?B?Sk4zZllJSHZxN2l2NThpaEY3L3NST3lsUWtxekdXWmlWaytOSWRZWXZTVWlL?=
 =?utf-8?B?b1JKeTY0Z3IwYlhpY3g1ZHI4TEk5VlJLYi9BTW9UUGJDOXBseDZMVFBnNHdT?=
 =?utf-8?B?WVV6RWJLbEtYT2F1dVk3aWlWWDFCWlQ0ZEhjbEhXd1dyalhKMUlUM0dSTlMz?=
 =?utf-8?B?MDJ2U3A5Mk5WeDQ3K1lTVTU2RklhcFdEbUFXMnE4L25RVFZoclBTSjAvTmJS?=
 =?utf-8?B?NTZlVC96UjBHYkdSWnVNY0FYNW5Uemx6Y2tYK0lzaFlIMVV3MTBybFBDQ2xN?=
 =?utf-8?B?YTBJM2Y1cUxRNGg1ckpGQVZ6d1E1UEVMaGluYnlvaTVJaXdBaTJVZUd0SE9P?=
 =?utf-8?B?Tm00aUJ6c0VPN1E4d1FZa3plWVcySHcvcmhHSjBjYTYzNXIzMFA3dDdLTWRL?=
 =?utf-8?B?ZmpMSlJrV2gyakpMUlRlL1ZVRW1uWWtacGNMOHR0dUJNcXR0SlVQbytYR3lo?=
 =?utf-8?B?endaUFhzMFRvZCtSbmZnMXFHczhSOE1RNW1Rb0d4NVpDYU1LL09BUWI5Yzl2?=
 =?utf-8?B?RTVXVmlwOGl3STJ0cyttTkJtUTNsWVV5QWpxaThHNW4rcTV6TVpxWllGWGJR?=
 =?utf-8?B?SU5yRGJqSkFSaVE1cjFSY25yT3B5aWRkalZCUURHZEkzZ3NiR1pNb1B4RnQ2?=
 =?utf-8?B?TTJISUhZWDUwZG45S1d0UmQxNXVkeS9iajZuek5CcmIwSW93aHJGVlpiOTZi?=
 =?utf-8?B?ekl4bGJsdS9BeEJUOUY0Qk81L3hrbHRQSVJGRmIwUC9MY0djMEpTNEZZWHN5?=
 =?utf-8?B?SUtidUMxbGtxa0JESm9MQkozQkFWYUllS1llbFlSbjV0NVE2SjQ2YldSUlRw?=
 =?utf-8?B?Y2tPWkF4b21JcVMvQWVWSTdjdXdzZklqSEE5QUhqL1VIQURnWS9Va2tHNXJi?=
 =?utf-8?B?elVvakQyaEd5MzRRUW9OOWc2ekE3OWlYRzVDNXgvUVdxcEJ0OEE1dUZvSCtP?=
 =?utf-8?B?aUNXRmFPeHdjUm80ZkJBdU01MXFSbS9sZjFmR3ErMDZaY2llMW5RaXlnZENF?=
 =?utf-8?B?UnlhbTU5aTB0OWlJY05hSWFjRlpLNmNUZU52enBocU5hQWZwWVQ0dU0yZDhz?=
 =?utf-8?B?Ty9NeXRRNjdGdHhrVDFVSjBnVjYwTG1TZHVUamYvSFd2Z2tNWlhhdmlzTHBC?=
 =?utf-8?B?eFJ2eGxMeXVML1RFMVlYakQvRzlzV25jVXNha3o1VkdNYnpORlk2MHNFQUZG?=
 =?utf-8?B?dUlQQnBoOUxhWXVFWXFUd1NYNkpDR2ZYa2xtaC82b3VTczZBQ3FlaTk3aEJ5?=
 =?utf-8?B?bFltQlV3b0hFK2V6NnJDR3grZ0p3SzROMmtFeDBOa2R5NG9HZGtWRUQ5Yjcv?=
 =?utf-8?B?Yjh1UVE4ejZCcjU1OFZhek9SQTdGZnRBY0hUMGpkUUdQVW1Sbkc0alg4RGIz?=
 =?utf-8?B?UllLNUY3OE1ybWNxYlpxL1JRaUdacFZ4ZzFURDh3dTN4RmVwc3RuUjgzcjY3?=
 =?utf-8?B?dTByQk5IcE1TeFRxVXhSN3U0akRRVGQxVDVaNVZtQ09QY0FCUFl0VVdNWnNq?=
 =?utf-8?B?dk9jNFQwODF1NHFOZWRVcHdsQ0pRcHYvbVhrK0FkcDJwS2VJUmMrcnA0SW44?=
 =?utf-8?B?cGxTRDZZc3g4WEh2NzFrOGFQakFHWnBERUc4TVNYQ29UclhJZXhRZkJldWIz?=
 =?utf-8?B?YWlZbDNWR2NEV3dXMmVUY3NrM1AwZ256Vm9LWnlIV1B4WFAwOHJoaTFpSDl2?=
 =?utf-8?Q?trksuKdTYW8A40+a9WN+3rkjN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 23:48:50.9358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8c533a-c0a3-4bdb-95a1-08de32c682a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4396

On Sun, Nov 30, 2025 at 05:44:31PM -0800, Vishal Annapurve wrote:
> On Fri, Nov 21, 2025 at 5:02 AM Michael Roth <michael.roth@amd.com> wrote:
> >
> > >
> > > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > >
> > > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > > per 4KB while removing the max_order from post_populate() parameters, as done
> > > in Sean's sketch patch [1]?
> >
> > That's an option too, but SNP can make use of 2MB pages in the
> > post-populate callback so I don't want to shut the door on that option
> > just yet if it's not too much of a pain to work in. Given the guest BIOS
> > lives primarily in 1 or 2 of these 2MB regions the benefits might be
> > worthwhile, and SNP doesn't have a post-post-populate promotion path
> > like TDX (at least, not one that would help much for guest boot times)
> 
> Given the small initial payload size, do you really think optimizing
> for setting up huge page-aligned RMP entries is worthwhile?

Missed this reply earlier.

It could be, but would probably be worthwhile to do some performance
analysis before considering that so we can simplify in the meantime.

> The code becomes somewhat complex when trying to get this scenario
> working and IIUC it depends on userspace-passed initial payload
> regions aligning to the huge page size. What happens if userspace
> tries to trigger snp_launch_update() for two unaligned regions within
> the same huge page?

We'd need to gate the order that we pass to post-populate callback
according to each individual call. For 2MB pages we'd end up with
4K behavior. For 1GB pages, there's some potential of using 2MB
order for each region if gpa/dst/len are aligned, but without the
buddy-style 1G->2M-4K splitting stuff, we'd likely need to split
to 4K at some point and then the 2MB RMP entry would get PSMASH'd
to 4K anyway. But maybe the 1GB could remain intact for long enough
to get through a decent portion of OVMF boot before we end up
creating a mixed range... not sure.

But yes, this also seems like functionality that's premature to
prep for, so just locking it in at 4K is probably best for now.

-Mike

> 
> What Sean suggested earlier[1] seems relatively simpler to maintain.
> 
> [1] https://lore.kernel.org/kvm/aHEwT4X0RcfZzHlt@google.com/
> 
> >
> > Thanks,
> >
> > Mike

