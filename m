Return-Path: <kvm+bounces-34577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2ABA01E8B
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 05:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55F261884193
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 04:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6650B196C7C;
	Mon,  6 Jan 2025 04:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dvxHzjFr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124E67080D;
	Mon,  6 Jan 2025 04:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736138097; cv=fail; b=kbnJQbyW0mYyH8m/92TovLqY9tevrjgghxuMzRfntTVuz2vLu0ii30WvuwSdUZNSorM3JJZG+fabSpcLSoNUQ/fHaTH0b/tRkijg8j0PoeJ6bDTzAEjHpOG/8tTkv7oHxvAfcwOGnXQpiFjoA3xi7GjxOhpY8QsWxrav77+Vzu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736138097; c=relaxed/simple;
	bh=YsS6F1ICt5L5BCynylg6JGq2UdtSJneLQIyXYL9Zgvs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rHufb1oEbHgsMBJd/hbOX8mWjJY+1LEEWM5Zd5f7ot44t6gSiQcDnDM23v1GNvqQ5sHUHPOlN3LyLf0AkvUTRJDfirRdWgcF7xKOWGWDvLcUNeDQxntTok9ZvZDsmVH7sDPKAiM8A/lCl9HlwHFPyU1KyHGYP4zY80uB8jrPGRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dvxHzjFr; arc=fail smtp.client-ip=40.107.96.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d24fsZN/Y02OUncZC53zSfKfwQzsCLhMbccYGtW6TMy9ZBJRO5h8W10HM1MVvDHICbyu7tE9Fp6VQ7f1McBuZlbqBAgNmBP27ELjxEZr5okxLNwdwWRVT4nU8hdcHGAqv9151ZSonXcaOJld/8m/tPxG5KByvJrfVC7VZFWnTiroLApHLQ0+eHQceKGyuGO1VbJQs2ObP0Igcty3dCB6kS5ustDFFspIvsnIHKjGCowCAYhIr+XMu8FvGX/CVp21Lgg3EA5BtsG++VWZApk3WVGNd2IK58m6Dj8irIQV0uhqw1CPA/fAmZ/uBPMioeJycKn2Dd1LeTrvbvf7okZLcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbK6MphxE1OXNNMeM1RD7otogmy3mMQZ0EZHl+/6OLw=;
 b=J4erxYHNSBzPd4/QnfbOFMtNrGs/VslEMH2/u/wzWeyX829ukqF3P+ATdd8LTC6/x+l77on+Rz8pMAWNChLI9swa1nLBEdlwfi7LvLrsZUrky/7W2z+NR55zRSZUPuBB4T2tMTsLz9hglzt6nwkUskDgt424XE8wFZww3SphWQhokD2UgDa6gb0n1Eib2r+CTkliE93EFhh3YX9AUEVrI6vVUlmZZX65iJzwCDCxr2ka0tpncbQMfsZgHjlpcE+IdGy9ddF3MM9MzIIS17D495LMmJMcYz4c08vObUlCDQ2Q6G7SUIRy83uJUj4zljDR3nm1f3hySyOM2t8aTsNn6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbK6MphxE1OXNNMeM1RD7otogmy3mMQZ0EZHl+/6OLw=;
 b=dvxHzjFrP5VFVqFkKdkLDkpn/4xk6y2d88Mji9fqIy36BVilTORvHaOy0PST+SlXjMjB0w0zq+J4UMDm4MEXDHaoFkWeSZ3oAQi4IkUhhJMTLimc58irsIIeMSzGxg6XEvEVbTYcnFd/PRh59m8mzY0C8Ncr3qvO+LAUuKC4X6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB7347.namprd12.prod.outlook.com (2603:10b6:806:29a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 04:34:48 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 04:34:48 +0000
Message-ID: <453d5f6e-49ed-4840-944d-f6accb690b81@amd.com>
Date: Mon, 6 Jan 2025 10:04:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 pgonda@google.com, seanjc@google.com, tglx@linutronix.de,
 thomas.lendacky@amd.com, x86@kernel.org
References: <af92fc80484a6b1f74d8b2535f54833702b7e1f8.camel@gmail.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <af92fc80484a6b1f74d8b2535f54833702b7e1f8.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: b1d82261-a6e8-4062-7fe8-08dd2e0b73f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0hMMDZmY2pMay8xNENDTGlOZmFmeVpJNyszd2txRzNtYTFHRDdNZXJNeE1l?=
 =?utf-8?B?aUlmTWZTWGNUM2F5RGlxK3ROVWZLRjhraDAvS0tuOVN1T285QSs4R3dxd3dz?=
 =?utf-8?B?WXFXYnZtWDdqcXNpcTMwZ2RYRU5heHlsRHBRNEJWOUoxVWtkYlVYSzdqQjZk?=
 =?utf-8?B?c1BjUDJYN1NSS3cwdklaV1grNEFjM3VlTFhwcDZZeXNoS2pBSlBENStrRHlZ?=
 =?utf-8?B?U3dJc25OWWN6TVNZTlFmYURjMEg2cGZ1ZWhLYUVBZ2RyUnA1K25UdDljWkM0?=
 =?utf-8?B?SjBCd01KVThPWGF2TVZiUE45cENaUnZudnNIS2pWVnNtLzZQaTMwSVNIVjhV?=
 =?utf-8?B?aWNmMEpINGc0M3ZKTXY0Q3JncE52M2wxekFWS2hSb0xxRDI1YmVPbmpqN1hx?=
 =?utf-8?B?ZHVZSTNWaWVPZHc0cXhGb2lwTzM0Rit5NTJvdU0wcG1qaUM1UXd6OUxleWEw?=
 =?utf-8?B?ODFNdmFYOFc1aFlIb1dTQ1ZjNnphSlpIa0hGRGM1NnVyR0pVVmJ3bEFVYmho?=
 =?utf-8?B?WGFnNWcyU1hRT21VRzVRZXlQREN4ZlhyajVyc0ZvV2VSNFE3elp3ZmtDV3dX?=
 =?utf-8?B?TzdzMC9NVUNrWDAydG5CTHdtdVM3RllYUm5tSzRJRmlFdmVLVEU3cDFCc1hF?=
 =?utf-8?B?Q0VhRzNzZGQ1NHZNUVJYcjFnNDU0Z3g2NGYxNjlXKzZpUEkzcjRSUDhVbC83?=
 =?utf-8?B?bkpRU2ZnZlYyRXcyTDZJRkFCODgzRDBlSHd1dkd0TVJmNTZ0b0VTeWlKTmpM?=
 =?utf-8?B?UVdRb0wrZHFsQ1FUSlJtcndmYUNtUlBhb3dLc0haVWhIdVdoeHNMT0Y4Q3ds?=
 =?utf-8?B?TThzQ1JaSHVwMm9mWjhXaFA0MWw1ekxaOHh3ZTg2YmFNY05YMWNMQmV5WS9S?=
 =?utf-8?B?VTRMQ3ozalpJWm94S0oySWVSUjR4T0YwMTBVMmVVVTkreUM5VzBMbHhmS3NX?=
 =?utf-8?B?Z2FaUXNjUysvY3IyMDVWZzRUNkNtSlhkVitJa3c0a1NrZTRPaFF4aXNpQjl0?=
 =?utf-8?B?V2RpTkVxcWhrZWRTaThLR215OXRGa2RuNUk5ZnIxc1UrRXN4VlRDMUpmV3Bn?=
 =?utf-8?B?T2tLbE52aXpLc2JxdEEvYllCNDBrcFdxYmF2bkl4cjB5elczRXNIaXFORjNX?=
 =?utf-8?B?S3c1dkF6akRxT280eHpwaEdaZDhCVisyZmhQOS95b1ppL0Z1YW43d29lL1NP?=
 =?utf-8?B?TEhjejUwRzlWd2VaN3Y2TmFublppd1dHOUcwM3MxejErdWRyZi9BREhVZ3lO?=
 =?utf-8?B?N3czY3JtOG11VVFKaGE2SlhISk1MTC9wSW00NjFueXlQNlBUdkplcjNEUlh5?=
 =?utf-8?B?aEd1TVdIL3lNcndiSU44ZXg2d3kzejN2MFFVNzBPc0pTckl5dTY0LzNYSDhm?=
 =?utf-8?B?SFlORWNGMkpkeHNCRTk5L1ZoRFBZc3lDazZKZjg1OXphUzBSZlAxRnQ5UVIx?=
 =?utf-8?B?YmRjYW14LzVadzRoWVNDbjU0VUEwd1FVUVJsSkUrS2k2c3VCancwakkwb3hi?=
 =?utf-8?B?YlZYOHJLQThvQXdaU3hoRjFoV0U2R1dzYWZlZkZKcjFUOEpRdzFvY2xsOTZk?=
 =?utf-8?B?Q3ZUdEk5Z3JTK1FiQVhSVUZYd0VuTnB2TU91VFE3c1hhcWh5cG5vRzRFRDBV?=
 =?utf-8?B?UlhybnUyaGJyRitjNFBXM1JjQWdZRWw5bDJ4K2JOTSswNVhqRUo1b1hEQ2VM?=
 =?utf-8?B?VGdKeUlTMDM0STRaL2VUOWh5Nm1xcDZ3QUVDaW5HMUJxd1I3eXNhbGNVMUpw?=
 =?utf-8?B?NzArRUN3d0tGZnNpa3FiZTVVTUhadlRnL2lkOHUzNFJkaFNZbGJsQzR3c05W?=
 =?utf-8?B?NVJEZDhtSUdoWUJYLzFIZHBwSnVjNFV0ODFlVVJOT09CUk1HMUtWVzRQTlI2?=
 =?utf-8?Q?zjXKqB7gFkI2v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEpYRHoxR24yTHFYT0Z1Zng2cHp1S3dvZ25WbXlUbWtJc0xkanB5UHljbHR3?=
 =?utf-8?B?Qi9uNVF4N3BZc20wTVFVbjdKeDB1Qnh1Q0RWQjI0UWJpeEtLTmdNYzkzNHhQ?=
 =?utf-8?B?WG9JSVQ4MkNqTmtnZmlZeXJ4cGxzZFB0Rml5L0ltVjlHVEpqTmxOZWhlQTBu?=
 =?utf-8?B?VW1Ea25zOUZXdURMK0t3UEFEVlljSDlaejBsL2FoU2ZiYXExNXFsQUR5K1d0?=
 =?utf-8?B?bDFRNndxUllCOU8xS0NRKzRrWW1BTEZNTE80OW5SYlFvT05BOThOTUxndGg4?=
 =?utf-8?B?VnJCSFJROXJZMEtFZDZGT3ltTGdIU1AvclEwNm5NU3RlSm5CRzBoZElFNW1z?=
 =?utf-8?B?MEtMR0tNcHZWcExBK3FxYmFxeEc5Yk1BQ01pNzhOdHY3QllITW5kc2E4cTlu?=
 =?utf-8?B?NXFDbXIxL2ZuMmxYSk12Njd3cDZCWVJZQllHWDVnL3VtM05MaGlOUVcwTGFZ?=
 =?utf-8?B?U0ZLZmFTMGpEL3ZSWkVKV2Iyb3JzOSs2Z0t2Tks0M1VEOEFwbjZaUENmWUw1?=
 =?utf-8?B?RmIyV3QwRGh2dGVSbkExR3BLKzZTQmV3SzJvVUh0WTJEK09CMjRxMngwWWR0?=
 =?utf-8?B?WXAvTFFzM2x5Q0NSMlFXcDV5K1BQT0V5YUhTQnZBYVpWMDdoRTh2cjA1Uncv?=
 =?utf-8?B?K0haT0xjUVpETUtaLzd2K0xUR0Z0K2dqNjIwdmc4d0FyNXcyQWF0d0MrS1BC?=
 =?utf-8?B?M0NnNWxuTzFqeUhuOWxRYlpxUXU2dzYwQ1BjRWVmeGYxRXdLZHhyaHN1UkNG?=
 =?utf-8?B?NjVxTjgrTVJmTS9kY0l3M292b0hRQ3RzcVI1bk1LWmxTUnhYQmVvTVVsR3Fl?=
 =?utf-8?B?dURjdEhjUFhJNmdtOVpuUFU1UGVsakpNbmhla3pYSHp2VXJNTnN0MW94K1VD?=
 =?utf-8?B?eUlpVDhlMFVJMzAxYVVOZnFUdkV0a0pyQ1dmQ2Y4RXY0VzVSQnN2OW0xeEJ0?=
 =?utf-8?B?VHROa2YxL2c4OSsrVzBSTzlyQkxYdTFna0JzUFBsSkxYTGxqUXJ0NDgwam1o?=
 =?utf-8?B?VHQ5VzNuRWhNYVhOWXcwbks5N005cWR2SXp0UkVGMUFxdnRZUmJOY1VtUlNo?=
 =?utf-8?B?QndzRVZacUV4TmttQ0dyNDhtQTBHSkJKczZVQTAvUXRZb2ZLVTMweldjdUk1?=
 =?utf-8?B?b1JEeDlHb2txQXU4bmdGU2RTaWYzc3hOSkxWa0xUd0M2NjgwSTkyMDJXYlM5?=
 =?utf-8?B?aFNkZ0g0NHN2cnphMnVLMHk4bnZTVkVaQXZmTzJuK1VUYU5mZnB0MG9QYzNN?=
 =?utf-8?B?UVRVd0p5emRodUhVbERZYlRibEhESUVGQWZMK241UUdOSTFKNUNrR1htbS9k?=
 =?utf-8?B?WDhPeUgxa1JVUlV1d3RRM1FwRURoVjNCbkNiZTdNZnIyd3ZTaFJvWFlhMkdv?=
 =?utf-8?B?S05GMWFuQ2NwVWVLd00wNGxsL2pqTXJuK0VMUXpZSFBVcE9nMy83VWF3NW5l?=
 =?utf-8?B?dU9iTzBIYkRHejhiNjE0eWdEc0tuVU1NRmRVV0k2QU9jaXpKQlJpZ0I0ZXlq?=
 =?utf-8?B?c3hJVjJsYnhyWHdPTUpUR2V5VEtTaHB5UDNjQ2UvZDdBOElGeDkrZENjalB5?=
 =?utf-8?B?S21yV2hSUmExOGRUaDE0c01oZkxRV3pubmJienNWbkxZYXZ5ZzdyQzRPcklW?=
 =?utf-8?B?OURaRytuUjBiK2FhN3F6S1BUYSszUndNMldhVHp0Y0FNRVd4bThsZ0VKdUx5?=
 =?utf-8?B?RkwrbG5jMVBKY2syeXoxRjQ5S2ZxVGhtY0tTd1pUck1kZzJKdzIrY1FTMmov?=
 =?utf-8?B?MWZCbmcvS0FyMUxSQ0ExRld5MHhoNmJVc0VmY1YxMTRRbFJCbmZBZTh5Ty9k?=
 =?utf-8?B?emVJUXk5QVUzK2ljRGQ1RFBSY1daWFJ3SW9SdWxnMUt3Y3dzQkdYUUo1S2Rv?=
 =?utf-8?B?T0JlWGltbjZjOHFtb2hhYjV5Wm1GNHRLU3lIUFdDamJvQVZGcjNoU201enJa?=
 =?utf-8?B?QmQxS2QxTzBrWWhNTi9lRW1jemZiaE8reGFoS29sR3cxU0YwdVBoaDdaWi9W?=
 =?utf-8?B?cEprSUtZZDc3Q1Rwd3pQaWJFTG5nS0JZUUhKMldtSzdWU0R0blZBdHBVT0dN?=
 =?utf-8?B?RWxPdlpkeGdFdXNLWlhjWXhsemFGOWc1c1drUTBsc0pUN21IRFNYSHBvVlhF?=
 =?utf-8?Q?X+GtO+jvtYBI3sC1XSvNzSWm1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d82261-a6e8-4062-7fe8-08dd2e0b73f2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 04:34:48.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fC1tCZqn71JXnIq/e5ABhmnjSTl21Y9GThSPEn4zBF+idhPY30kA5R0wjeEX6GrStKdzqloA/Eyp6S1ew+iGgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7347



On 1/5/2025 1:56 AM, Francesco Lavra wrote:
> On 2024-12-03 at 9:00, Nikunj A Dadhania wrote:

>> +
>> +e_request:
>> +	/* The response buffer contains sensitive data, explicitly
>> clear it. */
>> +	memzero_explicit(buf, sizeof(buf));
>> +	memzero_explicit(tsc_resp, sizeof(*tsc_resp));
> 
> buf is an unsigned char *, so by using sizeof(buf) you are not zeroing
> the entire buffer.
> Also, I see no point in having a separate tsc_resp buffer just to copy
> the response from buf to tsc_resp, if you just use a single buffer with
> size (SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN) and parse the response from
> that buffer you will avoid the double buffer allocation, the memory
> copying, and the double zeroing.

Makes sense, will update.

Regards
Nikunj


