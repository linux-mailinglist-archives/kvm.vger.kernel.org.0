Return-Path: <kvm+bounces-28872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3508799E411
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B977B1F215A0
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74EB01E7666;
	Tue, 15 Oct 2024 10:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="URgIIPQ9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="URgIIPQ9"
X-Original-To: kvm@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2052.outbound.protection.outlook.com [40.107.247.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA261F892C;
	Tue, 15 Oct 2024 10:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728988251; cv=fail; b=hGb8JJvP6CsXUWn6sbHYs8pvFg5Z2kn3V+o91oVDjfYsnHZPqnkL/qpqXv1HtI6NM9Cmo5rOLJNJwYEU2ycK0kfVijsBxnVon+CUpoFAxCTk0dee817HJwzGBUBHv8+B38qTxQtjAMzgZkHV1SG+o0lGEwJxwhpGpxR4+QMZoOo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728988251; c=relaxed/simple;
	bh=ZzAxJDnOP/Wd8WD4AhRRn6u3TpbbyWBvWBP3uij3Plk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iKa9IuSz66XqJH0sIjcsXeXBcF/4Dbmkcb1liU/jF0N2mOJMTxuffcWUWbbqX8Aa6yiDNLsNHqna2qu9nvk7E+mPfMR7+yyJMtKQV9i2d64qvJP7N+sZY77ZuOdyFUCxLGV42cTxjyjJ52RwkHqjG7ZrLnSyj1lg33p2Aafn7r8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=URgIIPQ9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=URgIIPQ9; arc=fail smtp.client-ip=40.107.247.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=B3FyYzr2O7b/5nh1nZcyugCXhW0aORhsfDB0ChW1hVIpd/GmBEiSwr3EDM0NAXpwjJjabccsOG7RmOOczfoMB/hz9CS5yhDg8JgDA/x3RnDjjWhLxKVMO5THiJeYwidFTRJG2YMjc/zr9Eh8lw1qeAfp577azDQBulM7qRqVkZpWSVwWfrsfp/pD1x/1/A1Kcmld+Y9TIq/7ggpevZCRBqvQzwqo2igPDADJiW28JMJ5+qxxwJEwRmg/xI6gC0pDMYOjM7WjSxVMdGR/Ql8cpZDLj+5kYDjbPSB3q8ZtDPuDi1SJ673KwKfeAr7yrk1SX8DuFiwZBUrIrVas2ErrgQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLqJAH8ACWgR5DBNrvkaBntAeMKcb0lm/f0Ty2rpEis=;
 b=QPl4vab7px1wHRRJSEsRofSM+a71EisOF7bfSMmftVu83O6stUgK8rc8B241hd0NjGumlhy9ScFgJGjnB8myQRlFhI14G9gOWqCfJzNmRphUIp4PzfcSbpg6RumH+UJm693irrY6G7wMk98wb3x2SeMnp2jn4oKIV++B9EvTedgTT2Pt3mzzHYTg1/WNOe3MpfG5hxGSh+g6A7xvOB1JD5HYV1LNiSgs3/rqku+xoMR9FvV2l+yj18R1qqVWR/7/FvRxOAf+DnAFPbpjHqyI3uCa717rDZrHZZ5tDBEjoltX/8zNqoyekTBZOZgi8Jx5DXDQpAnWcG5/mHRKAvcAgw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLqJAH8ACWgR5DBNrvkaBntAeMKcb0lm/f0Ty2rpEis=;
 b=URgIIPQ9fyoEAkCc2remc4iIaz8xnAp/jrrZGESD+zqCmATt+U5kUr2JlyMDqYoc7bC924KDLnY0adB7cXSo9hMahkUfUUxsVCGQpCZYe2rjQXXF8s75wD6W+SgaLzUyZq86qlNwlqr7NZk82eN8FPpDzXLDEkAQY0LxdWcBMmw=
Received: from AS4P195CA0049.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::25)
 by AS8PR08MB9953.eurprd08.prod.outlook.com (2603:10a6:20b:635::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 15 Oct
 2024 10:30:41 +0000
Received: from AM3PEPF0000A792.eurprd04.prod.outlook.com
 (2603:10a6:20b:65a:cafe::f7) by AS4P195CA0049.outlook.office365.com
 (2603:10a6:20b:65a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Tue, 15 Oct 2024 10:30:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM3PEPF0000A792.mail.protection.outlook.com (10.167.16.121) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Tue, 15 Oct 2024 10:30:41 +0000
Received: ("Tessian outbound 0658930cd478:v473"); Tue, 15 Oct 2024 10:30:40 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 4aef298514ce2870
X-TessianGatewayMetadata: ZzbMqC4zt1U1xNIJKNd4w2miGZluDCigMjlHLFI+vrbEeMH2hD44AXlbAJAVZEo8DfdY8ETFn2OmaiEWKnTxqX3L1CLjDvDbwm+hFsQ7ZQ+73jtecZeVOOa+Z/04aLxaiEaETSTRIz/SnZMCIpTGwyn3AXNJ/CP1KN0RbBgErec=
X-CR-MTA-TID: 64aa7808
Received: from L8bbb5d8d9218.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1C6DD0E3-F2B9-4DC9-BB0F-D18B22228105.1;
	Tue, 15 Oct 2024 10:30:32 +0000
Received: from EUR02-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L8bbb5d8d9218.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 10:30:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KEfdb81owr/8TkyocoIq7T4tgbqPpDrcGuzo42B+qHFYR8C5zAcopVWwGDuJwuXnSK9rgFQK3UyB3kGTnDMwDKsyxPUnurqpvlyEDc5vfi6MeNrJIVsPcCmv3keNVbyT+sefZ/KwcdsfJPInVG1MBFMdeRGIaU3q5ov+mR1/YM0zJ1bVJLcPqyNAX4YQvApBKyOWF3JNmzFl/Upca6c9q6urCSiWcteXmqvKNq8gbKGVw4YUuFGqneODS1uauyiAFLfdFBUQpf1gDlcl96MI2ra7hMQDofcmmli6n3ajnIVKxQcGRGhfZRdD0FkRsMIsB5nhxfSxPzCRQD82c0yzqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLqJAH8ACWgR5DBNrvkaBntAeMKcb0lm/f0Ty2rpEis=;
 b=IY+D7a/h5bnEp7wRc38+RExCNc93AxN6wJ3ob1plY0z9BPgjO8MPq20KZ7f1BQt1Fa3a9U5vLo8yyVpoELtHsziIAB2r4Y3OL3glzpRABfk8lPsVZyB3p/L8q0JjrY2a/dlCXuXoXjVk6gydPk0ADbfnAtnAZ/wXobEn2JdAQ/Tr9djqf+PcMbC94ZGpcbkqCqxHVoHiIkKlxHeC2Xk7cX2SPgKgpdR7fe2XxywIRxIGY8goikgdZx91QHsdHLinSvXLu8vj3VcIpB2QpMlChqwTwk4tcNTnhyVPmm8KMit68IZOxvC0TBdu/QLB9X/8MBTU0wcJpy123qKhQLtN8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLqJAH8ACWgR5DBNrvkaBntAeMKcb0lm/f0Ty2rpEis=;
 b=URgIIPQ9fyoEAkCc2remc4iIaz8xnAp/jrrZGESD+zqCmATt+U5kUr2JlyMDqYoc7bC924KDLnY0adB7cXSo9hMahkUfUUxsVCGQpCZYe2rjQXXF8s75wD6W+SgaLzUyZq86qlNwlqr7NZk82eN8FPpDzXLDEkAQY0LxdWcBMmw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by AS1PR08MB7427.eurprd08.prod.outlook.com (2603:10a6:20b:4c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.24; Tue, 15 Oct
 2024 10:30:24 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 10:30:24 +0000
Message-ID: <d6762bf9-b1ef-44d5-b42f-3e5fd4f47b4b@arm.com>
Date: Tue, 15 Oct 2024 11:30:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] KVM: guest_memfd: Add KVM capability to check if
 guest_memfd is host mappable
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, steven.price@arm.com,
 quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com
References: <20241010085930.1546800-1-tabba@google.com>
 <20241010085930.1546800-7-tabba@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241010085930.1546800-7-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0597.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::14) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|AS1PR08MB7427:EE_|AM3PEPF0000A792:EE_|AS8PR08MB9953:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b401350-7371-4c4d-5620-08dced046b77
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?QmhSOXN3Y3dQUTFiN284NXlNZ0FDTlhaMDhxYWtvSWtIMk1KaUlUSzIrT0tH?=
 =?utf-8?B?SG1sN1Yybk1DQmdBQzc2RHJnaUg5TkMxL3RXV1IxY3dTRzhLOXlzSlIvazJy?=
 =?utf-8?B?VElLM0RveVRuUDVkODV2c3pQTGpiSkNoMkN4OG1pRWxpUTlFSCtRdmZHS3kx?=
 =?utf-8?B?ZFpPRDIrTFZYS094cGwrclRFMEJEY2VDTlAzTWUwNTJ2SzdZL01NcmR5Ym4z?=
 =?utf-8?B?UjZDdlJyc0h6MkVJdXU1L0QvWXorODJzNVNvWk5rdWx3ekZiQ1hPWENJOWxO?=
 =?utf-8?B?eXRNZFU5RENMTGpZV2tlRjZkNTd5cmJsSlFncEZzemNnZnlhMVNLbzlTZ0lL?=
 =?utf-8?B?UmZlQ3Q3akhtRnRrVXdjZEUyTFNySVdXWm1UVDhGMEdXLzRuSTVxSXpCTXQv?=
 =?utf-8?B?Qmtwcll5RXBvck5qYkgrWDYwZDJORWw0VE5UOEErRnJjOTkxS2NnT1pLNEJo?=
 =?utf-8?B?elFPb3BLSW05RUx5ejJrR0p4Zmt1T0s0WFk2NGw1ZHdLZGJCSE5ZVmt3M216?=
 =?utf-8?B?NEVvSEl5dVNWSU1VYVAyVTVMamM3OHJYUnZ3TVY1ZzJCYXcwcjlWa0tWY0dn?=
 =?utf-8?B?ODk0S0hDSXZlQTQyQVhwdnNDcjJadVNvd0RaREUrZDV6VW5JdlVrVnpQTTR0?=
 =?utf-8?B?M21QR0xOZ2g3cFV4c09EcmxZaytjVmVtdnpwK01KQUppT0JVK0o1SXpKQ0dR?=
 =?utf-8?B?TzRoS3o1WHRRZzBKVk1BcHEyZzZoU2h3MFRnNGVUbHZlNjZIY1NEODFGNWtW?=
 =?utf-8?B?b05hbzdnK2xSODVYSU9jVDFPRmhJVkVuZVV5a09mS3d5anphNEYvTG52alhh?=
 =?utf-8?B?dzVYNGJlUDhyVTM0MWFydmFLV29tSUZ2MlZGZUJ3dWVJV1hBd2RsWmdmSjUw?=
 =?utf-8?B?VzlTdUNRZUVoOUk4R1VPeTA3R1VGUXJibkwxUE9abnJvR01KQWxDRk9JR0Jj?=
 =?utf-8?B?OTBSWVlFdjBIb1dhU21xaWhTYy9JUWpVRkc4YzFSZlNrbnU3d1k5QlNoTWFn?=
 =?utf-8?B?ZEFKUEMraVpJY2ZveUZoYkE1L0MvZXVKNGhvK0V2VGxlRFkzVlAyVEtySWRN?=
 =?utf-8?B?VjhhVmtwZHFnU29kTEtKYkh3SExJNXh0MWZua3h4L1dGOFhEdCtlbWVvR01B?=
 =?utf-8?B?MDhKM211OTdnQWI1VVhTa2RDbGdpbi9pYzB4aTNUMFJWTUNNOVlNZExSNVFN?=
 =?utf-8?B?ZmJQWFpWcUJFZTBMSnh0M0RydDRmMGNyUHBaY08xRG1yc250OFRJTVlVYm9a?=
 =?utf-8?B?SEthUG1CS1N0cDdNS0U0bVV0bWFFbFB5UlNJRk93MVMxKzZlZ3c2dTFuWk9l?=
 =?utf-8?B?ekpJYnJDTmZ1ZXlGY2ZQazY0S2YrckdpTkxkVFNxU0NVN1lqWDVBNHdCdlVU?=
 =?utf-8?B?SUhVZ1kyWEtiUk05cFFzekgrTVN4Wmc4RTFWQ3lMTnIzMGhMTlBnSE9tY3k0?=
 =?utf-8?B?T2U2MGp2d3c2QWRRLy9oc1NPRW95bCtGQTlsbzhxVEppNmVmZWxHMTBweEJU?=
 =?utf-8?B?YkZ1STBmOFF2VVU1U2xtUG1tZFlnd0wwTjdOVFB5aStCbnJtS1EySzVCM0Qy?=
 =?utf-8?B?d3ZJTURKdWhlMTRMWmFpdENJdlN2aXc2djJrWTJLMm9jUm9DbGRsSXBnVTFo?=
 =?utf-8?B?WnhObE5iNXFKVTd6ZEI2SGkwbjFweDNKcE9SQk9SZTk0YVhiN0RQZGFjVEpw?=
 =?utf-8?B?aGZIMzhJNWVwQUltbHZxY2VHZFl1N2JZNERPTnkraGJDR3ZtOTQ4dnpnPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7427
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A792.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ac8140a1-a8da-4531-ba82-08dced0460c5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlBXKzh1Q3ZMSmNlS2tCRElnV3RYc042cVlRSW93M294WlM2bHlYdzRsaEJP?=
 =?utf-8?B?dHlYVktoNFZ0Z0VGZjgyd0s2ZmkwY1liY1NDR3Z4M3U0am1VbjhBenNvK0hD?=
 =?utf-8?B?blVCRFlzYllJMDJZbGM2TzlvOUdjUFp0aTVUbFFJZmJvNGN3R1VpNlg0RnRk?=
 =?utf-8?B?aDI2TWsrNW5XWmhSUC9aSXF3L09zbC9RMGF6ankvYzFDUGVYcXFvVGtsRnN3?=
 =?utf-8?B?MDV5TTBqSzlNSUNBcm5wL1RGc3FUWG0rV1FMYzl0OXZORmp3U3V1Lzl4V0Z3?=
 =?utf-8?B?TlU0eVI4bmo0S1l1NDFVOERBQnJiRUM3akVzUGkyWElER3dwZWtPRk5RQWVv?=
 =?utf-8?B?V1JpdVRnd25CL1BiTnJocXRUY1hXMnBudmUvVEFVSVJVNS9YQ2FReG9GbnY5?=
 =?utf-8?B?anpSRVI5TzFsNzJSNXozNGlBUjJ6c0hETS9YbVVCVFhlMUpOcEE5Wk5MRUZv?=
 =?utf-8?B?cVZDcGdIb0FSVkcwNDBPWitQa0VjREQyVnV2UG4zaGFZSDloVFRLSHRSTSs1?=
 =?utf-8?B?MTI2MUZkVzA0RFRKSkQzbVAwdi9BaVdsa3NoaXFMeE9FMlFPQWRZL2tUSVYr?=
 =?utf-8?B?ODB1Q09wYi8rRnloV094bjZWVFRiMVNwTFFueEl1VnhDS0pxc2FzeHVLeXV3?=
 =?utf-8?B?WGJHTGZNYnRrQUxmRXBvQzVuYlFJYTNYOWZnaUEzaEdLNnlxVk9DTzJmcFNU?=
 =?utf-8?B?enVxK2VVY1RKaDR2aGNabkk0eEtJMVh1YXAvWFpKUHZGdzNaQzBqaGg1eEVQ?=
 =?utf-8?B?SjVVV1pNYTlrMHBqVXhKVlJjMWJFWG5wNEZKVE1YVGFvN0NjQUsxR3VhT29D?=
 =?utf-8?B?L0dyNXhJVUVURGpHOGJMSFZSaEhXbFJXeWh2ejNlQStET0VNSFVFVlFYZ1ph?=
 =?utf-8?B?d2MwWnpaUjhSZWcyME95MDdnWkRyb3REMWpkVlMzNk0zZHFIWEtVRk85WG9O?=
 =?utf-8?B?dEVPNHpxU05KVnFtYmY4Q1Q1SmxhcXF4QVRKNTBLdThFelZxVWVjaFRtODBY?=
 =?utf-8?B?QlR3RWduT1NEcG84TEYweWZIRGFmblJkK0NZbHFJakRQaHFvNHhuVEIwMWdS?=
 =?utf-8?B?S0JIY0pjRnhvakJ3TU1ETE1qLzJWVWtHU2hyZnpkUkZEdHM5WFlDR1dEVHlH?=
 =?utf-8?B?RW14NDd1OC8rY3k4cit6R2pCb3I1R25pQzIzTnlrTjNoM2FQdTBKT1N6L1Rk?=
 =?utf-8?B?cXFZSlhQQzMycUdPT3lhekQrREVCS0Vpc015ZGlSSHY3aC9EZVl6WmpiRnI1?=
 =?utf-8?B?b0I3ekc4VFFDTk0yaVlrOHhiK1pPQmRaQ1FKQXNoWGYxRzAyRGtQaUlyM0VS?=
 =?utf-8?B?cDAvOFI4dXRmTW90dlkrOEhvWXNqSTBzWW00eVlFc1RHc2hxaFdPUDFvZmYr?=
 =?utf-8?B?K3NKTUZwYlF5Wkg3RW90MUhxMnNWdWFHN09ydGdjSFA2RENRV2t6UXZCRXNo?=
 =?utf-8?B?Y0FWTE1RcVlHT3BvZ2QzQ3lGWFhlbFRkekhTVVM2UlJ5SEtrNm95dnJqYmRQ?=
 =?utf-8?B?Ry9ZdEJ5bnVLeUFkWU1sanFQWlVDTG42UVQvSXEwYlNiMUJ6aTdYNzJFY0FQ?=
 =?utf-8?B?UmVaVUxUNTRUQlEyV1FoeFUxSjRhdjNiVFJsZWZ5c1FhWFpUcUplNXVvRVJ6?=
 =?utf-8?B?NC82UFJZY1JVZlZLanJQRHY1c3JlNmlPa2VKMWlIcmc0RldZVlMwbXNnQW1l?=
 =?utf-8?B?NndGREc5K3VjMXZkUzRqekFHdGxidzlROUYrY3RjYTA3aENzK3ZxclVsdzVK?=
 =?utf-8?B?eWxsaU9MaVZ3aklNSldsN25FYnpsSmswajBhWjZTUlI1bmFQSlNNem1yeitq?=
 =?utf-8?B?NG5IYUFHelU4VTBwV3hPVUY3enFhVS92WWI4MVdCblV1b0dMT0xSSjVlU2tp?=
 =?utf-8?Q?ppITS0olJSNGX?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 10:30:41.7621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b401350-7371-4c4d-5620-08dced046b77
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A792.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9953

Hi Fuad

On 10/10/2024 09:59, Fuad Tabba wrote:
> Add the KVM capability KVM_CAP_GUEST_MEMFD_MAPPABLE, which is
> true if mapping guest memory is supported by the host.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/uapi/linux/kvm.h | 1 +
>   virt/kvm/kvm_main.c      | 4 ++++
>   2 files changed, 5 insertions(+)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 637efc055145..2c6057bab71c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -933,6 +933,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_PRE_FAULT_MEMORY 236
>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>   #define KVM_CAP_X86_GUEST_MODE 238
> +#define KVM_CAP_GUEST_MEMFD_MAPPABLE 239
>
>   struct kvm_irq_routing_irqchip {
>       __u32 irqchip;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 77e6412034b9..c2ff09197795 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5176,6 +5176,10 @@ static int kvm_vm_ioctl_check_extension_generic(st=
ruct kvm *kvm, long arg)
>   #ifdef CONFIG_KVM_PRIVATE_MEM
>       case KVM_CAP_GUEST_MEMFD:
>               return !kvm || kvm_arch_has_private_mem(kvm);
> +#endif
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +     case KVM_CAP_GUEST_MEMFD_MAPPABLE:
> +             return !kvm || kvm_arch_has_private_mem(kvm);

minor nit: Keying this on whether the "kvm" instance has private mem
may not be flexible enough to support other types of CC guest that
may use guestmem, but not "mappable" memory.  e.g. CCA may not
support "mappable", unless we have a way to explicitly pass down
"you can map a shared page from the guest_memfd, but it is not
sharable in place".

We could solve it when we get there, but it might be worth
considering.

Suzuki




>   #endif
>       default:
>               break;

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

