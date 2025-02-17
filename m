Return-Path: <kvm+bounces-38382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5945CA38C30
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 20:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 157137A3066
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34D3235BFF;
	Mon, 17 Feb 2025 19:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hti8mo33"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2053.outbound.protection.outlook.com [40.107.212.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AFA70814
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739819908; cv=fail; b=gsgqolwbW93aGBCBftv3SYum6YOdKCrUCkiV4y1yK3rB+96cIpxOqmmrCnBJ/ctBCiMf8yCdEhLxbeEoAgIb8mpb2+RAGK8nUAMG21l1do+gLlnV7KhW9W97o0SWoKsOZvuzqk5ly0WPyUWwyb07mql1LocmedGI6psyZGiZy+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739819908; c=relaxed/simple;
	bh=u18GB/UU0VJFy8f/BwcMSU1s1Ez1GJ3L2P6I0C2xXfI=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=PSXhaFcRH05xUx3V+0SQC+l8edtqqDQEIWXwy5GTDiID8coKtf8G5wWDc6Hd8K5Kx+X+hJjXps4U7ndQGUkijvBr1x+q7oCqthzfbEOu12hzEHQBa6YjUT9FZ44KUxefQCFzzYMac9x9ByT38Q47+qQyqtjoQGU1v8SoONL+WZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hti8mo33; arc=fail smtp.client-ip=40.107.212.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aR8SUyeIUCPv6puaKbqDz4LFGIjz0bes79IayWXqpUNhSp94hwgJbGI7rwMbVUk4xTP3fk0+PpEspT6g5o2IA3Gb6zg/k5kSRDadivAhflp+00QJTl7f1j4uqmENTNrXvesHYci7cVN8b1HfAg8QzsH4213qLguAyHlweF+QA+OB5AeSKIzoNHh7bolsDgNzO2sPKXijQDo9kcIpxeId2Ft/t1OpCi66OgG3IwtnQPFmIbPWTU8+8CLXdS45MWNlFcQz5kYs0VAovzAcTs0tIDy3fYAu8EvnjM22IwIZOk9VPXxW+VdADObFrhEHGmuTPkEX0TD7eAiK9R5PZPGhVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UMBLdf0FJObeus6ILqYQMYNmr0RO9rH84wCdS5LCjo=;
 b=sv7WLeJHZUno5OqY9/ZwGaENEIpCXUoVvec0G+tyoIHhJY4Nncj67080EkQ3zKxUcn6BRGyHqkCRFuW7AyELIafWHj/KW10Cj37mnEDwstz6C7VyTyMoeF8qOqHxzgs1mxU5FP/3Q8mUAZWMTNO/dJhkE+VWRa6B6NJ1aIRcYsJPzieeb4VlLHqwXdUFpufuZlZsptubh9YPHiyd4ouRSeFPZjwm5jgiD8u5Fc5T+y/LWA3yC/cCFq+nROStva37ichK2XhVQ3Bye+pB8dsmFW6toSKB4mF4zOQL8GIH6gGoetZrEKa3KgLaSMzA887xN+XXCfaOQMBU9HkvMEP+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UMBLdf0FJObeus6ILqYQMYNmr0RO9rH84wCdS5LCjo=;
 b=Hti8mo33t9DLEaGaGpq+ZbPI7xsSsj6PVHK55NPH88TK2xltJ3089M81U9Xhs9tG+98zz0z7Nb7OxgxGTaScgaTtLizoSYLjSlzctB3EPC9l7Vpt0O6w2AuSZJm4W0ZipAjUXDGatrbcdUlsmKTFMJCmY4kA9UA+OQ955RDE31I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Mon, 17 Feb
 2025 19:18:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8445.017; Mon, 17 Feb 2025
 19:18:23 +0000
Message-ID: <886f7424-9f33-7a0f-73d5-886ae4609ae9@amd.com>
Date: Mon, 17 Feb 2025 13:18:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-3-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 2/5] crypto: ccp: Add missing member in
 SNP_LAUNCH_START command structure
In-Reply-To: <20250217102237.16434-3-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0013.namprd12.prod.outlook.com
 (2603:10b6:806:6f::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: 733eebe8-7d99-42b6-1d5b-08dd4f87d8e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RU1QL2NVQWt6c01yMURhL2ZpdkZGMGtGdmExdUZHajZybWt6Z2dNMDNINVpk?=
 =?utf-8?B?MjNabDEySkNOYTZVQ3ZkSmNaUld6cGkyTFVDQ1Z6Q1ljTWpUZk0zY2VYOGcr?=
 =?utf-8?B?cHR2REVJcXh1cDYvSDhMZG9QSGtxeGpCL1AzRVBaWUZuaVRmazVKL3JJbEhJ?=
 =?utf-8?B?L0tORUY1VlRJQTFFVFNrLzR2d0xJeU90UzVWajdYQTZIVEJFRW0wUEY3TnFt?=
 =?utf-8?B?eTI0Q2s0b2xHMWdNZytNTkxBYzNhdkpVQWFyTmsvWnh5RitMYWRtWGF5aGRy?=
 =?utf-8?B?RmZFT0M4U25SWklQMzcwUG9JNXNuNWhndE9ydkdoTFcxb2t1ZnFHQ3JhWHNU?=
 =?utf-8?B?V1pwMGFxd0s4RTZ4cU9rZ2xuN1Z4ekpUK0hHdnZLN2pnQzMxQTlyRDJWb0oz?=
 =?utf-8?B?VzNQbm5QSzN3aGxKOE9TdThWZk9WUU1QZytUSEhpa09Cay9TVlViVUQ0NGw1?=
 =?utf-8?B?TDR0S2Jad3AyaFpYN3I2Ujh1Qzc4dHBxNnR2VWFYbkk4dXZ1Rnd2M0RtcVVX?=
 =?utf-8?B?Ny93VTB2ZENnN0ZNUlI0SEJ6OEM4OE84MGIzelg3U0lMSFZYSzZJVjZhdFBh?=
 =?utf-8?B?VHNhNVZMZjhib1lVNmFJZ05TK1g0aUUrUGtQVkh6RktXWnhBeldJbk5Nc3Ba?=
 =?utf-8?B?OG1WZkIzZjVFVkszc1hxOHlXN3k0Tit0WnNnS3lSaWFnUEwwY3BnMjRTdnc2?=
 =?utf-8?B?dXozK2UvS01NMVE1UXhkaWgzZjJPMFl5KzNIUWJENHdTcU03WXk0d0JONXhT?=
 =?utf-8?B?emxYRmE2V1N5RllvZ0JMRGVYd3NFODBFdnJqclo2Skc0ZmdjRjRkNmZad0FV?=
 =?utf-8?B?VWhYYTZuYnJvc3laYjlFVzJVOGFFajRjNVNiY3AxakNDUUlwMVRMRktBS2J6?=
 =?utf-8?B?ai9LY1dua2NzZEVONVRQTWJSOW9LZ1FTK1VGU0JudHpzQ24rWE1na0FZUk9s?=
 =?utf-8?B?WXhBeTBhcmtla0EvRmgxRjFiNXVVVDkydnRUSDNaUE8xc3JtOVJMZFRKcWtn?=
 =?utf-8?B?bG5jMER2dWFHZ0dVZG9iNVZOYlIxZWdWNVlOcmVBbS8rK2pLS1Fhb3d2Q3lm?=
 =?utf-8?B?VThpSG1HeHFiTitmL2prUHpMYTNUUVNSL0FIdCtuRTRzTVNJSlZZdEVaUDRC?=
 =?utf-8?B?Ym5pdks5VE9IeUJzc3ZUSjF2MDNiUTRsMjNzVDViT1ExMmZWNTBMczhUVnJI?=
 =?utf-8?B?YzYwM0U3N20xQmxDdnVPb2EvVUtvUmhSenRvVklLbHZ2SFhabWpFNmN4emEw?=
 =?utf-8?B?NUZXdG41aXJUTkgxbGFGQnhLSnRtQjBZbTExa0dML3pqeVNLUElJTTROZXNY?=
 =?utf-8?B?dmpHQ2orazB0eDZFSXRBemx3RmQrZUYzTUgwbWgrVFJXeUwwM0taWXk5cnd0?=
 =?utf-8?B?YmNZSTY5MkdlZW5NMWYyeXhiTmV5Wm1IK0tMQ3phU0liWEZudDl2bnlWR3Ay?=
 =?utf-8?B?Tk9GVFdEbTJlZVRWcVVUcWNsYVZSNWx2OVNKMHZpWHdGTHRHMnRkY3M5c3BI?=
 =?utf-8?B?bXVPc0szV0ZCWitvZ092ZGl3N3JneUY5Nm1HSjU5R21aUlh4M1lvY21BRTdu?=
 =?utf-8?B?ZThzL2Q2dzFhSGc5V0VJMGs3QnE2T2dVbGdPbGt6aUFKQmRDQ1pUS2NNS1g2?=
 =?utf-8?B?b1d3VDZmS3NpdnFlTlREN1VvTHlkMllZMzI3QUYxM3hvcFc0ZkV0dy90dzZP?=
 =?utf-8?B?RXNZNitkVUQvY2lzVVpQMW91MHNteVRTYk4veG9vTXFnV3BmdmNIZHljU2hm?=
 =?utf-8?B?S1BXVkgrOFltdlFobWU5L2xVcjExaUxodnN5UTcvV1pOcEt3U3AvYkhGaGNH?=
 =?utf-8?B?V2dwbEhlZEdPaDVrTWMzVWQvN3ZpMXcvOXJMSEJhclBWYTBGNWdGOHJncDdm?=
 =?utf-8?Q?QC6ztMrGLIq7N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGlFMzNZenN6Qm9lTGcvMmNVaFYzQVZLRzk4RzIwMmlOUU9KTlFQb09ZSHdq?=
 =?utf-8?B?NFVBRFdjZkV0NHJzYjAveDQvRUJRMmxkS3ZjVW1MY1BlcDhsUnFLNzlsa2lv?=
 =?utf-8?B?Y3ZCdDhBRkt5TitXOG80MXh6SlBTRExQay9IVWRTQjBxTGxiNitMSDk3b1Jr?=
 =?utf-8?B?T0laWFJubEFmbmg5TGNScTZaeW9tR3hDd2tBcFY3aHVseUlyMzZSa1FON1kz?=
 =?utf-8?B?ODFrUDFrNHdJcVN5T290SG45QlJ0NHNKeVVuMWlpZGo3cldPTzE5KytJcFRJ?=
 =?utf-8?B?Rk5tK2FVRXVZZjV4cU9SYUJrWUJXQXNRd01QV1lmTkc5WS8xV1JHZW51N1d5?=
 =?utf-8?B?dE9sYVRZRnlQVUZSb1NOSTZnN3ozWTFLc2V0NVVjZFlRVUhaTHVWM2g0K0dX?=
 =?utf-8?B?WWpJS0dwbWM3dU1KV240WFM3cUdkVjk0ajZJNTlNZkJ2bW0yYlB5Nm5CQi9X?=
 =?utf-8?B?NDN6Y2NPWHo0dnF1OWh4ejlVYlZpUmc3Qld0OUZQTFprUmZ4ZzFYemdndlZJ?=
 =?utf-8?B?WjRzck5xc0lFaWpKSjUwOWE0ekRoWVgwek9ZekFjK2QyaDVMenVVY2ZEVnM5?=
 =?utf-8?B?Slh1Y1RybitnSkszOG9rTmx3NWRqM2Vtb3hsbEdDUFMxMUxYdmVNSEROc0Z2?=
 =?utf-8?B?OXg2TUNKMjBGZkFaemZ5SHR1dk1hRGpmc3JxR0M1WVpZNXRYeU5Ed1hoaDVt?=
 =?utf-8?B?Y2ZiNXRNNEN3aExPWDRFejNOSmRhakU1NWkxdFMrdFB0VHdUNFJYT0d2YUtz?=
 =?utf-8?B?MExtS3g3MERhLzg0dE42OGR0SU5KWUt4L3B2M2EwU1YzWVQ3aSthOHZkWUdG?=
 =?utf-8?B?R0J6L2NJbnZBOSt6RG9VUTd0MkY4ZmtaL2JJS0wxQ3VGWC9ESVlvS2RDc09o?=
 =?utf-8?B?WVpNU1YyREdRZ2l5MjdsSHZlRWZzTzhnajhiT2ZnZkxpUHBNclVzYzNRTzhn?=
 =?utf-8?B?bDJHMEFCSnhaVFFvRjgxeDB2YU9Nb3NjbnRYWk9qTCthbXBRZ2RuWVpGVS9Q?=
 =?utf-8?B?WmNGa2pQcTEwWitUVk1hN3JhWnAwaFdFVzRVeGtmUEVZL1VBeDNDWkVJMWtu?=
 =?utf-8?B?dlZrNTRtUVlFRm90QjY5eDRiVnVhVnJNQ0ZKZXdodzE2RDJ2RkgvQmR1elVN?=
 =?utf-8?B?RG0ySkN6a1FKNHQxdVllQ05uNHorMnRXSENZQlJLVzk3dVFoczJ3empUQmlO?=
 =?utf-8?B?QXlZREp5T0hUL2dlOXlFVDhMWFlhdVBvcE5QOERTQUhsZEhaZlByYnhmUU42?=
 =?utf-8?B?Mmpma0tXMFJTK2VBNThodml0MGlOMGpnUWZXdE05KzN2aXBXR3ByUmdERWNH?=
 =?utf-8?B?bGxOeTNBS3VyVlB4aFM5cjZkbzlXbUgxaGdlUS9rWGdzMHl0eklpN2RkalEv?=
 =?utf-8?B?YmFFcVRydW5JelBCY1BTT1lvSmU2UXVHaWZuQ2pmZW9xOE1tTmhtNk1qRFZv?=
 =?utf-8?B?VGR1VWxBeVRJNW5vTlVHNVVOWkZ6Z1NPKzZUam81TmJKNUk3Y3loTFV4Ujhu?=
 =?utf-8?B?YUpySHdsa0poT1lJaUpsVE9kK1oyTzdUTG1NVSt2YlEzZmVUN0JBbHZ6KzRB?=
 =?utf-8?B?TC96SUlOZ0hLd1JhcUNEWnNINEVRQ3pPOHRXTWlxMzJmTnJFMVkrMVExdEZ6?=
 =?utf-8?B?ZlA0cDJmT0UyZmtQSWVVOGlwZlJEdC9JanNqRlhGMndDeTBPb1lCbk52Y0JH?=
 =?utf-8?B?M2JFK0cxa0xESW5qanpXKysxNXN5WkQ0bUt5SFVUanJQWDhSK1d0amk5djV1?=
 =?utf-8?B?RnVnTGY5dkRMMnM5TE1pZGZTZFhCdWxnUnVmdVBXZlVaUlFVSitqNHNTL2hE?=
 =?utf-8?B?SG5GZW1yekNPalQ5aklrZHBaYU1hWHcvS01IRCsydVprdUtsOUlFWUo1Sytw?=
 =?utf-8?B?cFVHamlqdzVHNDJiZXZqL2xmZ2tQNUIwRjlrN09seG8rU2M2QnNsOEY0V0hY?=
 =?utf-8?B?Q0RTbStwMjJzb2JwZGlmbi9Tak45SjZ3Zy9XdDcraGh4UG1BSUYzc3JFT1c3?=
 =?utf-8?B?c0x2dURNY2txQjVjckgyY2V5NGVDdS83K1BUR1MzYTBZRytOVzNYVTJQMWxQ?=
 =?utf-8?B?d1lXbC9kUVhzOXVEbkwyZUlFSmNaL1FWODVsblBKTmFjWVFGa2tjQnAvOURE?=
 =?utf-8?Q?5SC1mFbBYmccg8vX699qXmFjN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 733eebe8-7d99-42b6-1d5b-08dd4f87d8e0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 19:18:23.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oapRp2gv0hW1tye/TKmGKcUAIMZs5/lcLKk96xkPhvFSx8LLxa8FAOLzhTk7nkl04Au1rnbRh6LIayWp0d3sog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7199

On 2/17/25 04:22, Nikunj A Dadhania wrote:
> The sev_data_snp_launch_start structure should include a 4-byte
> desired_tsc_khz field before the gosvw field, which was missed in the
> initial implementation. As a result, the structure is 4 bytes shorter than
> expected by the firmware, causing the gosvw field to start 4 bytes early.
> Fix this by adding the missing 4-byte member for the desired TSC frequency.
> 
> Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
> Cc: stable@vger.kernel.org
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Even though you're using the "crypto: ccp:" tag (which should actually
be "crypto: ccp -"), this can probably go through the KVM tree. Not sure
if it makes sense to tag it as "KVM: SVM:" instead.

Thanks,
Tom

> ---
>  include/linux/psp-sev.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index f3cad182d4ef..1f3620aaa4e7 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -594,6 +594,7 @@ struct sev_data_snp_addr {
>   * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
>   *          purpose of guest-assisted migration.
>   * @rsvd: reserved
> + * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
>   * @gosvw: guest OS-visible workarounds, as defined by hypervisor
>   */
>  struct sev_data_snp_launch_start {
> @@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
>  	u32 ma_en:1;				/* In */
>  	u32 imi_en:1;				/* In */
>  	u32 rsvd:30;
> +	u32 desired_tsc_khz;			/* In */
>  	u8 gosvw[16];				/* In */
>  } __packed;
>  

