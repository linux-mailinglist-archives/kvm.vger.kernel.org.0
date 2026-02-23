Return-Path: <kvm+bounces-71467-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0IKbAodVnGkAEQQAu9opvQ
	(envelope-from <kvm+bounces-71467-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 14:26:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 937AA176CF8
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 14:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 92F4730BC1C3
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 13:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0131C5D57;
	Mon, 23 Feb 2026 13:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lFvBEA9J"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012038.outbound.protection.outlook.com [40.107.209.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837D81E376C;
	Mon, 23 Feb 2026 13:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852900; cv=fail; b=k0y9jlZJyl9+SkTi6WEZ6cj5hOkLn9ha+JrgDwR+01u1LIiSShFeYhb9vbKnKZQdaMF47BJQtuaUK3niLGU1ui4+eoMFoIQb++h8Kl9uUvEa++36pZp1qNVhD5xp0G/MJjHuUsWKhodKCmt1WJ5hTRe91+mxgP8fca96dqfn/IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852900; c=relaxed/simple;
	bh=9RwgVBy3w3CViyDM3VRb1UB1HGdKgPbqlTnS5q9STkw=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cds0f+yw+gHW0ayALZBi25gSHIgB+L3RHsNdjplX40Wx78UiryUdHvcNutQOQKu1e7yfxlxN2rUC3sFb14CB+ppeJQR8onlISc/+JUfMJSc/5lPp0pXX6fxBh4sB/6z7JAhYhgLS7CtKswwgRaS0tdv/aMohdghFec3pzfWtH68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lFvBEA9J; arc=fail smtp.client-ip=40.107.209.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ti3EFj9JWJ69VfVJijoxG9tX2cWNSPZskMMqHIFn7gwf4ZH+/9KU8giJ5Ro3qWO+66Ir+YQvilZ0ytmLM63wmSzqOCTnoN+z9/Vy8gXH4SqNMpO6XOQ76yIhetEFb57oHM0ewJAoK3SOHOtJcibYvXTEd3WZupyUcCm6PqWXxMQ5PYAfg2yvkAlrRG1S/aSLUkOQshswUcjgGcy1K0H6ldAdTQjUt3Sw+reMsQznhmEQvqeQv7Ogu1F+pJ1Vu2SoXr56/0biaY7re/5vGHPLgQlx7mpFDTs0qBtdkWUVybftMGOeg2buNzqsMyz4jAEy6UvrZYI597rUzHFRJc8igQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53NXDp1K+1pjINh28+tR+02cSeDFN8z48vTh6wyEvYk=;
 b=lkBCWROll92IEhxIpMaFGIuUXfphuGh3D4skVQ2khXcMVc8O3aJ5kWg9zgtyxTK6G5/DXWg7JESPLKb002UpM3CZVKEV5vDQo+7ggJDZenW1y8ofNeT79cmhttvWFLjuQuvwWGac7hSmNcWT98y+xbWR0X/DzilJJOi0K7MfgEfcLwuk39MRdpuqdbh3hb9x7c+fymB6pNS8CmJgI3bnIOjH88oLimY08iGSxyDzXBs+/X7QcfXW6R9PkInlWejHyyxtq8SxEL1hA3/g8/mzLF1uvnJRiUbHWiovm/7zsCQAIld7j18mrAn32NZKtvm2xY0gpbYWxKxxr/LqNeELaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53NXDp1K+1pjINh28+tR+02cSeDFN8z48vTh6wyEvYk=;
 b=lFvBEA9JqoPwxyAmgzCEcS/42SejPBx+pjrcQoaaMPHuqeapV4oZDuW1ddCHbk/hin3WKfQNTnrDMnOEpIkfTOOIbr0uzjJHD39DQTVfrFlMS4MO0QeT0I9aChtN81zxAF0/2B9/Jl1+2j/GEsU27NAAoJaLPahGNVzNr9Wce5Bw60QEPDLKI7IIfvcifEQdB9bhUURsCmBUmEDdEgL1vjXZH4OY/0ORGj7WtxC3IgQtg2MSetV1BOln4d3+aj0vRKt7TGkoxHj0WXGpZzQn2ePJ8k6Ei5jdl6UG0BP2PCkz4l21odpEnN9fimP0wfThGT4bzVxuep7Ni+IWZwNhNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 BL1PR12MB5707.namprd12.prod.outlook.com (2603:10b6:208:386::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 13:21:35 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 13:21:35 +0000
Message-ID: <d66f5229-f2fd-4fb1-945a-264b3b7d32e9@nvidia.com>
Date: Mon, 23 Feb 2026 05:21:32 -0800
User-Agent: Mozilla Thunderbird
To: reinette.chatre@intel.com
Cc: Dave.Martin@arm.com, akpm@linux-foundation.org, arnd@arndb.de,
 babu.moger@amd.com, bhelgaas@google.com, bmoger@amd.com, bp@alien8.de,
 bsegall@google.com, chang.seok.bae@intel.com, corbet@lwn.net,
 dapeng1.mi@linux.intel.com, dave.hansen@linux.intel.com,
 dietmar.eggemann@arm.com, elena.reshetova@intel.com, eranian@google.com,
 feng.tang@linux.alibaba.com, fvdl@google.com, gautham.shenoy@amd.com,
 hpa@zytor.com, james.morse@arm.com, juri.lelli@redhat.com, kees@kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, lirongqing@baidu.com, manali.shukla@amd.com,
 mario.limonciello@amd.com, mgorman@suse.de, mingo@redhat.com,
 naveen@kernel.org, pawan.kumar.gupta@linux.intel.com,
 peternewman@google.com, peterz@infradead.org, pmladek@suse.com,
 rostedt@goodmis.org, seanjc@google.com, tglx@kernel.org,
 thomas.lendacky@amd.com, tony.luck@intel.com, vincent.guittot@linaro.org,
 vschneid@redhat.com, x86@kernel.org, xin@zytor.com
References: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::18) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|BL1PR12MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d1ed04-ea51-4511-3953-08de72de77c9
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3BJS2tRd1JEdjlkK0JOOW1KSHpsTEpqUWZHQW1NZnhUZTNtQkZIRDhkYlJ6?=
 =?utf-8?B?aUpUcnFFZnM0WFVpUjRySjJoQ2hleWNOZlozTHlsN0FQRWZUVzJxOVVVYXdB?=
 =?utf-8?B?VW1DaFllOXpNVmNabFBNQksyWlJDemMvV0hyOUYzRUp4a1lQalluaEdoeFFs?=
 =?utf-8?B?Y0VvYzJqc1lhU2hUVUdUMUFjRUR2OUhxaCtXUUE3VzZlWENkcjNXTlVKUFJr?=
 =?utf-8?B?di9wMlgwM29MUjBjOWlMUFJXSUtlOVdPdWU5eFdrNHVQVkx0SW1RRDRjS29X?=
 =?utf-8?B?WXVpS1l1Nmptbm5NRjgvYjZWZHBqNCtPdndKdk9NY0I4dlhwTWl5VXlDdWwy?=
 =?utf-8?B?ajBCYjB1WVNOcHoxSTBmcE1aUlV1TTRQaFp6MVNGYlVqdmk2Mm4rSlNXM0N3?=
 =?utf-8?B?bkM5Y2NYMHhZSXVVdVJwNjhocGpTdmlaVFVkdGE0d2xzZUNxUGVWTHdrdlhs?=
 =?utf-8?B?Z0hvWTlCdWFHVXVzaUF5WVpnN3BZUHdVdHZ1STFxVEV0WUtLZ3YwWGc4U0kv?=
 =?utf-8?B?WXI3dEZ3OW9lQnBadnBERW1JR1RWdnYrRzJiSWtscXRDbEVXZEJWdmo3UVYv?=
 =?utf-8?B?RCtUUmREbFV3YkdJYldLbW5vYzBWSERKbWhCazIrUENYY0l0bXU4dU9QTXc0?=
 =?utf-8?B?eXBySEJWb0dhKzcvUStGY3cyQXlJU3Z1WGxzWnd3OVRjZGpZUXF0SUtRbTdo?=
 =?utf-8?B?K2JLdktmWGx5QzJ0d2NoYUxjNlozRG5JV0xjNGlrM3Jrd0xCTGZ1ZXpQM0h5?=
 =?utf-8?B?TnMvSHBjakhNb2x2R2k4bkxEVWN5UkNvNCs5SjNXLzlSSHBydmc0V3hmbmR5?=
 =?utf-8?B?bEsrUXEva0dieUZhc0U5UTBrVWVOaGpNN0JibUdtZ082TUxwaDVmMStva1VE?=
 =?utf-8?B?WVVtSnV3aVpQOEtwRTBmVEN6aSt2SkFzUjl1ZjFIbjUxQnNYWGx1SjNzQXBz?=
 =?utf-8?B?dVBvemduaW1NdnVObEpNU2gzd0krNTdFR2QzelRXSXNVQ0dESXp1MXF3aDUy?=
 =?utf-8?B?ZVlnaUdJYm4yb2o5SnUvejFPeFo4WmJJbDY5Q2RyZnF1ZnlnNFJYYmFyaTU1?=
 =?utf-8?B?RWp6eTMwUWFKQmtseStVT1l2ODBTY3lQdUZ1QmVNd0QwKzhJN1BJeHNIK2RZ?=
 =?utf-8?B?WU5sR2U2b2NHLzJiSUFiVElmVVE1ellmbnBGdUtYcUFVWDlmbnUzcjFTdXVU?=
 =?utf-8?B?bThUb25MYmhOYkpHTWxYRlp0UDhGbFdoOWhUei9kNDF1SE9FNFRDRllWempU?=
 =?utf-8?B?RFBiZDVwOGFQaTM5Q2t0bDVEYjRkQ1YyUldIVWN3S2JKbnVqMU5mb0gxL2hJ?=
 =?utf-8?B?ZVM5NklONVgvS0dQeVp2WTVSYUpEOHJOSFJSdXNQeXE4YmRuUm9rV25VMm90?=
 =?utf-8?B?K1B4ZVE0QWEzbDJaTTNjdytGbUg3ZEt4dU1iWHFJdUNvUExKYXFnRjB6bHF5?=
 =?utf-8?B?VDNuMUMrcExtVnNmc3c0QXNCY01pc3YwQWZBb1pKM0FMcHpoTGtyRnpvQ0hE?=
 =?utf-8?B?d3ZPZ05ma3BuV21JY2dCWnA3elVNTnlMdGN4bWVwRmlqN0hFZ2kyaGF5NUo2?=
 =?utf-8?B?NUs4dzIvQzhzcmt5MDk5MVMzbTdZRzVVYlAwOWhtK1ZhcU9qR1JmYTVscHQy?=
 =?utf-8?B?eEdYMHA2L3BoaVJUcnFCNzlVdld4V3RVa3VIOG1FZndPM0N5Y1p5L25tMjZl?=
 =?utf-8?B?MVYveDVucDhGOU9tMkRWbGxwUDMvUGlpWUpkMlRnZE42bXBOb0FQOEoxZk5Z?=
 =?utf-8?B?V3VJdTVSckRMVWU2UU5ENmdKemUrWmZwY2paeVNtMUsvVWt4ZSs5c2Yva3R0?=
 =?utf-8?B?WVJ0cEtHSlZrRHBOTHMvdHJSVDFZS014M2c2c2dudWNKaHZKQWtOM2xNaVRC?=
 =?utf-8?B?UXJPM1dkOW5oOUlrUzFUOG5TOEpsVHhsNXdhU1Nhb1RpQ3V0djBDbnd3ckJM?=
 =?utf-8?B?K1hDNjdQQ0tienIxdUNnc0ZXRjdTV1ZreE1RZytKL2dxdGpmVVB5cDQ1bEVk?=
 =?utf-8?B?QWtyRy9NZm9QS1psVWpIMmQ2OGlqVCtJTzVBZG5ZM2V4YkdoREV4aDgvR0pF?=
 =?utf-8?B?ZHp2Ry9wVXBtR2sxUGVIeGNkVkRpS1RsSTRnSFQvdnFQdVUwbFJuQVBuREoy?=
 =?utf-8?Q?Mz/E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tk4vVmh6TWNaN0M0NkhxK3pTaDQzWHg3alVJQ1RFYi91UWk4S0ZMZHNvSC85?=
 =?utf-8?B?OHZWN3QveFZ4cXUvdzc5TWdHbDd0b2RTTUw5OFhyampNOUh6SWI2RFl1dnRR?=
 =?utf-8?B?K2hHcUhrdUZyQkNIYXUwNTdIL1BRZ0ZaeHRDeUUzbGlEd0NUUmp0Y2VDSThv?=
 =?utf-8?B?am96ZkpyWitSV3NkVGFXQmc5Rzg2Yk12Qy9yZ3BOZUx4UHBkVlJBTFo2aWVD?=
 =?utf-8?B?SERDOXk1dDlYMXRUN3QrRHB5VlBjMmIweFpLa1dLL2IwWWtVTDVEZmJhdUdz?=
 =?utf-8?B?ZFZCNDIydjdjSWRTYzFqTmhoQ2ZkZDZoWXNlOFNBSzVkN2piZDE5Vzc1Qld5?=
 =?utf-8?B?U0ZKNHZPN2Y5Vm51M2NvODN3bS9NaTVYNS9SQ2p5eEV0WXpyQk1jRHFvekw4?=
 =?utf-8?B?K1YxSDMvZXF4UWtwZFpKbURweDlIcVNJa2lHcXJSdmFETm9JK3Z4ZlBaVmhy?=
 =?utf-8?B?ZTRkNDFMaUxjVkVXaGhoa21PVTkyRXM0d2gvbVZjYXEvWnpsQkpzNFZpdlor?=
 =?utf-8?B?NmVpOGlwNGY5RmlwRnozZnVib2tQcFRIRTg3TFpVeGdZZ0MzTXMzdk9ENWps?=
 =?utf-8?B?ck0zK05YbzhlQnhrN1ROK0xyaGt2T0Z2dnJ1SHlWTUtNOURZOFpzZXZ2NzBa?=
 =?utf-8?B?V1FZSDJHa3RveTVIc1ZET0VoMnJJNU5HUFMyQ05OdWl4S1luMXJnOGRPclhB?=
 =?utf-8?B?bmhIQjQwZEhVbnREVEErVlNIeHRVZllYVzdLNHgya0NEWnJQK1BWSzhqQ0ov?=
 =?utf-8?B?NmZZYlpZT28rQ01Xc2RHM2tFbC91ekFPK0o5NUs3Q0lxSEJldGF3ZHplVVdl?=
 =?utf-8?B?aGNWaHphQXE5R2NiU1RvaFdQS3k1OXh0R3M5WGR6WnhxcnRBTml5SnpFazR5?=
 =?utf-8?B?eHVlWlRkSXlqWTNMUGN1NDBSb09BNG8vUFR0OU9BMmxydkF1QkxMNy9uVmoz?=
 =?utf-8?B?SE1WcDhJU0VrcFlPRzVPeFhBVzJZdXJIZVVDeVNPTTRzYzZTWlVyTlFKd3lo?=
 =?utf-8?B?bi9FOVFUTDB5TzIxZzM3SDlDaElrZ3VubGtVLzFkdVh2Z2pab1ZZQjVEaVNR?=
 =?utf-8?B?VUhaZVBUbEszcHBmR2tBZnA5bnViZnZyNHV1VUkwb3JMOWpDSjhFdURyMDBm?=
 =?utf-8?B?TGlBK0pxVlpXZDhPUmU3eG5QM1NQRzlteVFVQ2JsNzdPZ0hzak9TdjFvWjJm?=
 =?utf-8?B?VU56V1ZNbWJrdlZxNWZqcGxOWHhFMThYRDZYYTlPb3hGYlNDMS9DcmpWcU81?=
 =?utf-8?B?SityMGEwdjhnV1ZFVEtPSWFZd0paaDRJRlU1dDBkNXFyTzgrWm5Icnp4UDJz?=
 =?utf-8?B?YUg2ZXZybVArekRMblpqRTBOQWgvVG5PaVQzVG5haENvMTZrMmVTSzlmZWx2?=
 =?utf-8?B?aURwbmR0TDV3WlEzYlorSFBDa3I1M2M3K0x2bDRWWFQ4anNWUTNkRVhEY21Z?=
 =?utf-8?B?MzdnQTdYc3ZMc0twNGdlaEk5K2w0Wm85dmFZa2tJRUl5RkFIMVdYbVh6cWs4?=
 =?utf-8?B?VDYyL2dqUVpSV3VGd2hiOUF0QWhPZEJid3NtV0xqSm53OXVhcFlGZEFEcWV5?=
 =?utf-8?B?M0FXZGw0V0FEbzdXbDVwY2duTDhaK1BXanYzdXZqTmxJczBWKzFCSVI5d2Rx?=
 =?utf-8?B?NkJ5Y1FkZjdzSmtzMXlqdWl6aCtjOXJmcDVndURZUVRnNkRKaGFDeUtxS1pZ?=
 =?utf-8?B?dGNQbU5TanA1WjNQWmtkQ3k4WFgwaGlNQmR1RFhSOGZDcUIwd1ROSWYyTzI5?=
 =?utf-8?B?V3BRU09vd1FISTg1QVUwTUdMMkE3eDZDalRvRFFyQzM3SnJTRGZ4VXZoVEtx?=
 =?utf-8?B?ZVdwSzkvSisyTlNQS1ZXNlVLUS9TTEM4ZlpwSXBCSzNSY3g4WTBlSTU0WWxt?=
 =?utf-8?B?bXRpQmkyTlo5dG1XUGorc05YcXBjaWFUWkh3bkJvU2pjQWxlYmhIeVYreXpn?=
 =?utf-8?B?ZTJEV2ZBcTEzOE9lSlVSWUVSaXU5ekRzd0hnTFYvYU9PNFNBYndVSEsxYzJo?=
 =?utf-8?B?U3lrWXNGWStkenkxU0dTSERLaTFCTVRHVjBNMnpMM0RPMnRtUWMwa2l2c25Y?=
 =?utf-8?B?N0xoM3FkMG1FSGUyMzRGQjNvd216amJDMGg2Y0xlTDY4ZFozdHNnbmtTZ0tR?=
 =?utf-8?B?bTFmZHJVcUZSMnpxZGZjRzhBUWRsUTYraTZ6bndlNVB0emFUNjB1ZkhJT0VJ?=
 =?utf-8?B?bEhid0NCVmMzc2NnM1VTRklMQXl2eHdub2VISkFMS2NIeHN1RWg1Zk9EYUh5?=
 =?utf-8?B?OUlwQUpHWnRIWVdEU204aXdVdjhNU3dIbnkrcnZFNWc2eEN4azlxRUI0alRE?=
 =?utf-8?B?RU1YQXAyWUJmV2V1Y0dIQ20rZTBtd1VQVFE1UFJycFdxMlhUcXF3dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d1ed04-ea51-4511-3953-08de72de77c9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 13:21:35.5097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuSeYUK3Lt92C6cw9dFWdz2Vor4QPYmyqyPK07aPeJtTAcR9goiNUhGhKKsWNYy29t65BcqoVy6W1rdScLT4Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5707
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71467-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fenghuay@nvidia.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 937AA176CF8
X-Rspamd-Action: no action

Hi, Reinette,

 > What if, instead, it looks something like:
 >
 >info/
 >└── MB/
 >    └── resource_schemata/
 >        ├── GMB/
 >        │   ├── max:4096
 >        │   ├── min:1
 >        │   ├── resolution:1
 >        │   ├── scale:1
 >        │   ├── tolerance:0
 >        │   ├── type:scalar linear
 >        │   └── unit:GBps
 >        └── MB/
 >            ├── max:8192
 >            ├── min:1
 >            ├── resolution:8
 >            ├── scale:1
 >            ├── tolerance:0
 >            ├── type:scalar linear
 >            └── unit:GBps

May I have 2 comments?

1. This directory is for both info and control, right?

"info" is a read-only directory:
dr-xr-xr-x 8 root root 0 Feb 23 12:50 info

And its name suggests it's for info only as well.

Instead of mixing legal info and control together, is it better to add a 
new "control" or "config" directory in /sys/fs/resctrl for this control 
and info purpose?

2. This control method seems only handles global control for resources. 
But what if a control is per domain and per closid/partid?
For example, MPAM has a hardlimit control per mem bandwidth allocation 
domain per partid. When hardlimit is enabled, MPAM hardware enforces 
hard limit of MBW max. This can not be controlled globally.

For this kind of per partid per domain control, propose 
config_schemata/control_schemata file:

partition X/
	control_schemata (or config_schemata):
		MB_hardlimit: 0=0/1;1=0/1;...

Is this reasonable?

Thanks.

-Fenghua

