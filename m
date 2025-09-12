Return-Path: <kvm+bounces-57434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 454A3B55719
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 21:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECA497C4549
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 19:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6FF28468E;
	Fri, 12 Sep 2025 19:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q579fRPq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2053.outbound.protection.outlook.com [40.107.100.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3977426CE3C;
	Fri, 12 Sep 2025 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757706755; cv=fail; b=RMIVJcTj9Mx4Zv7MuYbhfuIV7VDdDLMQ0wdZChGHDVvyCyaC0zl6TBzfHh3AC6P6s+EhRXQnrDUNN0rkK9KMrveKakyQgT7oJuTAbuBBeIezwlDfW5edbLMx8ERCjwMLEcBhE7ByiYy1i+lZ1GvGmlDbBPXr63r15j1peqp41Rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757706755; c=relaxed/simple;
	bh=aGd4X5svIQ8GZbKqV2Tq1SDbh/O7KH2CificHXTj8Zk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CvOUC18xikbL3CCombbFbiiDtar8MKg8FvDOlYTJf7FoR8Eo/h9C19sNMhahmFHyCtsYnvUGVfUM3Jhzik5rd5LSkAln0wlRxbL9I3mfzgejVGo1C6ueUZQDr8Z1m26DfpKdNFKas37sh9O83DrPrXtx2S+rvir6siCsanyOos0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q579fRPq; arc=fail smtp.client-ip=40.107.100.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ix8DR1Fz7gYbA8+1zBGTQhTTqTiG2kXAL4/WYW822owyZ17Po9zI3g8XY5E3Jf9IHOWRY7316a/l8svAGZyv4HMXo5lVcikgu6Hl23Ixg6QdxqK40nu5hlfQ/AJLLfi6mBIiogeWJYX83nsfctyEmCp0HvD8IwmRkLNDZ2cqmGhex9j4HjKPGKg1e/lCk2we10O6SP/Wb46NgSq32pXvHVQvSoxsIfnSjseNPUyrRbJ+XmLAX4Rceh6EzMfK1PENWV9rsBgVHeWbdFtGrIP2PtPSw8hD1eisajrQMSbqxXds8YlcDqrEyJ2pXiJO97xBHtRf0ZsWd/8slmNr94lxkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ku0AshWnRDtuh8hW0PtVe5lO2Je71zv0qIluthO/KME=;
 b=BAS+54QheTc4fnadr1hbwqZ8E1K75WqNeGoah0/RBrozkOXNILl2ZET1XPlnNkRfy4LhrOjYAonfe0SWXLQjYR6m+PiqK++bx83LY4zHVv3efnICRd1jqawfsywTfnVsLt3OK8bZQv3GdPB2l7TiF+Bz73nmjvTBF4CMf1wL0H/yAf0fAAdp1oFuxUWBi4slx95PSgHdzGCPWyWX8kSUrL6pJhQ6rL6N+1UnZhFPJAxCp/kE3wt2pbzLgk93yL0WI5fIWCTreKVi47AHwKzlBEUP36kECz/NrI6tmI3do1AqkqvNPj5WaBQDa56oYXvuRCH/XV0E9Pjr4p77fUI22Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ku0AshWnRDtuh8hW0PtVe5lO2Je71zv0qIluthO/KME=;
 b=q579fRPq3Sz/YTyCf4X4m1aLSWdhmz1jwff1+E75bf6r+juOj9OJsTUZdXAqwowVk4Oel0sgyIi7Vl+4m6RTAkGL02H4KzKLx1M9NPRRMjWnuUj7vVE1O3QcOhhb8gR9oNGjmH+1THALsH89CMziUCD/hwAphnwznu8c/yu/jYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DS5PPF5E0E7945E.namprd12.prod.outlook.com (2603:10b6:f:fc00::650) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 19:52:30 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 19:52:30 +0000
Message-ID: <f550303f-3150-4e5a-ba8d-110170735615@amd.com>
Date: Fri, 12 Sep 2025 14:52:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, pbonzini@redhat.com, herbert@gondor.apana.org.au,
 nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
 <aMRnnNVYBrasJnZF@google.com> <df357d87-3b4b-41a4-acdf-31289590b233@amd.com>
 <aMR3bRYEoR0eI6x7@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <aMR3bRYEoR0eI6x7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0161.namprd04.prod.outlook.com
 (2603:10b6:806:125::16) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DS5PPF5E0E7945E:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d619f8e-cfa2-49ec-e6d5-08ddf235e818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUQ5MFZtK21reGNqc3VNUm1iSTVrRlJhd21KMnV2Qy93eWpvZHBKRi94ZytF?=
 =?utf-8?B?Y1Q4d0p3TmdYeVIzWnRSckJTRlZyL1VRUFNBYkRjMWpJRVlrMjVWa3BkLzht?=
 =?utf-8?B?YTRLV1hhaitiQjJDd3RzSTdWR2wxNCtmOEtudGNFQzNBTEkzckFHaGU4K3gv?=
 =?utf-8?B?V3BqV3BiV3RFY1NyZTlVbXNyUFJpVHg0R2pmZzdKYUZJVVF6c0IreVJFbmdR?=
 =?utf-8?B?TzBIcFlyblNFRTdyUE1rdWhpektmdDMwdkF4enJ6WnFRTlVrMFVHYnlRbHBP?=
 =?utf-8?B?ZUYvaHlua1NFOGpkVXkvVUJDUXZjTUNwWlFLaUxybXVqRGxFRWcxQjFaa0p4?=
 =?utf-8?B?bHlPZU1Id2ZHNXZKaUs4eTQ5SG4zQ3BPV1FzdmtKUmxGdkNETmFoQWdiN2RQ?=
 =?utf-8?B?TlFENXVLN3lrZWRaN1laUXFOL3AyNU1PQm1qeWdZMHdXbmRPbUI0Ujd3enUv?=
 =?utf-8?B?aUxwWVVYSGhzbEg1SDBGOUc2ZFVJbmlPRTRDNjJQNUxuaHRlYlkvQ1lpbXRW?=
 =?utf-8?B?YXZnVlVjQk1KbXo3YkhPd2djTkVwUStDaTFyMStoS1ZSUlpieTdUVnJleXNi?=
 =?utf-8?B?T2xCYUE1bUVCTTh3TE1JUisyN2diTVhkNHNXbFZLZ3lkQjBNOUZXS3Fob0dN?=
 =?utf-8?B?dlVscEpZSXY1dGJOb0IvSERiT0doQ0FiR3FaOFNBeGgxcGxQT2lEMlA1a2o3?=
 =?utf-8?B?WDVUZ0JaY2NLT0pZTEI4UW5TNWk2d2lpdlAzNzNsdnJDNStuTTZZNHJaQlRm?=
 =?utf-8?B?RXQzWUMrS2t2aXpVUFZKVCtHb3J6NTlyWFRwVTBqeXZkS3BhTEpNUTFkWDBy?=
 =?utf-8?B?SW1hdnhrODlkNnRCNmxBcEVUSGh0WEdla3hKdDd5QjRhd2l6dHZPRGxaekNr?=
 =?utf-8?B?Nk10NVJIa2lSaVI5UE1pQjBlV2hXY2xRL3hNSUxhYUdNSVdiWlBPTzJIbC9J?=
 =?utf-8?B?WnhOVlpBUllKUVlNSS96bVJWRnBGdUVuTEZ0SDdqS2lubkZTV3pRZHFVeWJ4?=
 =?utf-8?B?ZnNDdXBGN0pGOUNRQ3A4Y1VybnlQRUhzUzZ0ZDQxcFF6Si95ait5UzJiMEp2?=
 =?utf-8?B?ckRLR2lpblI0RGdjRDh1WTdTcUxMaVZUNUI4MjRWZ2RMelA4VExRZWF4UkFn?=
 =?utf-8?B?eW54cG9XZjRLQjV0WGI0azkxZ1BpZ3NBbHhpeHJTV3JXZm1FSHg4SEkyMW9F?=
 =?utf-8?B?aGtyN2ZncGJwWG4xREw0NFJnRzdOMkVQZERZSlIwM2EwajFOcGZkSnRoK1dB?=
 =?utf-8?B?OUF2dWhzRjFVTVBuUmtzNEZaSHNhdEpySXFldDJ3MWd3ZUtyaDVtNGozZjYw?=
 =?utf-8?B?am4vcUNweWFTVWswZW9UTENiMjJYcEx6bDFORVpsV2FRdW1JTXVPQmhNem95?=
 =?utf-8?B?Si93Z0dISFpXTFEyd0pPVmRpQjBCb04vRkRkU29yQzhNVlU5d00rd0ZxbjQ5?=
 =?utf-8?B?V0NpdGpqMkwrbEJzTHR4ajJ2UjVBaDhxSXQvSlBpcVRIWC9pbU5nWXRHREsy?=
 =?utf-8?B?Wi9uNkhyekREcjBQcUpNdHl1U3F5YUhDdGR2Vm5xU1dJOTd6dVg3RFZTQllp?=
 =?utf-8?B?eHpSZXJFVXZ2bUpLWHUxUTRZNHZVSWRCQnlTTHBLbmg3NE1HRDJPVWtpRFdG?=
 =?utf-8?B?NGs2bXZFbGRPZ2hpeHQrSCtwdUZsTCtpSjJmM2JGZDRxNE5VMzhRTjdlTisy?=
 =?utf-8?B?cHVtZmcwUGVnWFo2cGJSQWNlU3pHZnFmejFiUWxxRlNudUpVMDJMbHVJQkg4?=
 =?utf-8?B?dDh6bm9jNSt0NzJKQ1ZaMEtGdnArRlMvcWxxWTBLZmczYmR3RndwZ2ZUaW9C?=
 =?utf-8?B?NHNJVSs5U2R3NlN3UXBqNTF6Yy9HSHBiRTdmS3hTa3g2ZURZZDlMUFcvdElC?=
 =?utf-8?B?NXRQck53VUxkUmpuZjQyZG1ZYzJoSWpuejFNeHJVUG1lbTg3NldDQ0w3blhK?=
 =?utf-8?Q?5VNpfpZJeno=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnExQ3pKcU1DYjRmL29ZRkVPUVBxTE9aNlQ0Z1haQ2ZOME1MTHJ3MmlTQ1dz?=
 =?utf-8?B?UnlXUVp2OEVCRWFxUHBtSm00NWw5bU5CTzJUODNqUm0yMFN1YmNMRjNRN3pK?=
 =?utf-8?B?Mzh4d0hkaDJwU0ZtRDhaaWY4K0pLcG13TVRzelJsUXVaRkt5K0lJa0xUd1Uw?=
 =?utf-8?B?Nm4zeUU5bngyWmpENDg3cHBac29DS3ZPRW5qU2l5N1pkR1IzcHhTdWJnOFN1?=
 =?utf-8?B?d3V5OFdGVk5RUDltck81Y3pETFhvQjEzamlXNTJjTXlYd2x6Zk9mMHFDRHRC?=
 =?utf-8?B?Rkp4bFNFSlhUZmE5eXhOdWkwc0YwdUt2ZTF4UTN1WVJHVzB3QlIxbjNrb1Vk?=
 =?utf-8?B?bHNlMXlrWXE2TjdtYlllU3o0b3dBZ083MmpxL1pJdEJKZHpJbUtqbWRsS3lL?=
 =?utf-8?B?YVdvK2ZHS1orY3A2Sm54clZPQlViS3UzVW5IUVdRQS9UNktSRWN0SnNZbGxt?=
 =?utf-8?B?ZzFVNWViYXAycko2NDR6YWYxSDhZMW9CSmdFVTg5SnF3N3hiOEhGOGdwM1Mr?=
 =?utf-8?B?OERvdmhOeWYzb0U3MERpVW5ZWG9RZlBuYzBKbTd4R0xKRGNBV1lxazh4Sk1l?=
 =?utf-8?B?WlJCQm5UblZ3ZkUyUCtLaFYvSzhocFM5UEFKNjNqTWhlcDNaUWpXdjB4czZ5?=
 =?utf-8?B?OE9FeW84R3VtblZ4ckNVSzdsSUhlSGZHM3dHNk45ZEVRdCtvV3hWTE9ublYr?=
 =?utf-8?B?ZGk3ckhQMWdpSXRNcDFyUHpJaGxoRS9XVXlLS0hXOTltSllZMllCc1ZrWUNo?=
 =?utf-8?B?R0RQTytRNDhncnFnaHN1bk93UGdUSW9HQXFVY1ZzaTY2US90Q0pST0pjVjZv?=
 =?utf-8?B?cHprblVWUkp5VkhBQXZTZHBsUzB2RkhWNlhHbkx4U1NFVUsxbmR5OHk1RzZj?=
 =?utf-8?B?VDRZTkM2cWo4bTMraDZIemtGbmN6TytMbk94U1lFZ0QrZGZOcUtPT0N4Mnc0?=
 =?utf-8?B?TW1lQjRsR1Bha0IyeGxIUHZidFJlMk9uUHk2VEd2WDQ1QnY3bzAzK0EwZWxG?=
 =?utf-8?B?WTVxWUUzQm5OSHk1SFowLzNrWjhFYWx0bFBMcUc4N0ZiRndHb2xVUE9mazBl?=
 =?utf-8?B?UVZSdVhPMHhEc25zQjJ4VE1UdW1PcmU5b2FXN2RvWTgvdUR1dWMzQmVaZkNw?=
 =?utf-8?B?TGJIMXl6UHQ5eHoyaWhOOXJQV2ZlTDErZHRNQmxwYStGd3BXaWhJWU4zNlVk?=
 =?utf-8?B?bjBzSzN4c3JzRVZEU00vRmM5L0RCWSs0Ni9Wc3gxVEZWaURycHhxWm9QeU1Y?=
 =?utf-8?B?WEk2SGZMZVhkbk1YdzRyeElGaktZZkVkTXpOUU5kNk1qUlBEWHpjMmo4MThJ?=
 =?utf-8?B?b1loK21KMXh0VlVGSU1UcmRPQ3lmTUFGS1FSSGhRcTNNNG0wTXdIc3UzaE90?=
 =?utf-8?B?c2x4dWdka3lUN2tsYkh0eVl2Tm13Q0dCMytEaFRWQkxRclJxUzV4RkpxelNs?=
 =?utf-8?B?ZFVtelcxMGRxbjBqQXRXS1RxdjdXQWFWQ2VyV081dDRnQXhZSWJaQi9OS2Nk?=
 =?utf-8?B?d1l0VlhjMmJmODMydWdQRXl1emNLZ2dxby9yWVRYVEFJMGp4QzVGcS9Ub3lL?=
 =?utf-8?B?bThZK2tWQXFvQVVzaUpyRmNYOG5Sc0VzUjNKTUFRWXJmaTZWNFBpSUg1bi9J?=
 =?utf-8?B?aWIzYjdvdW5HQjQ0bzhnZDJ2QlB0Ny9DYjRxQWc1VGVlTVcvdFBSTyt4NUJJ?=
 =?utf-8?B?OEJwL0E3d0lBSGcyM3Z0b1hQNVBvRUlZWHNGWFRveEJ1dnFESUpmWTNBcnNj?=
 =?utf-8?B?d2V3d2J2eThtenMyMTd5QVZsZlR6YnNFSTBMQWFmWVpFSjFDVFJUL01vRGZ1?=
 =?utf-8?B?RmNRZytZVGFTeWVxY3BmRjUwTXZqVDZXc0pmbUxuUjJrSW5BRWtjdXowejBn?=
 =?utf-8?B?dzJISnlLRjRzRGZ2RkJ0M1hXeGNudzlHWElrbk9aTGpSaEZ3c25hK3E5WHNS?=
 =?utf-8?B?L0srR2xob05tOHVQQTBxY1lydWFaMmZxZFhSdDhCeUlZZ0FVOVJhUnFxSm9U?=
 =?utf-8?B?aUMrak1ZdER6dzQvNXpKd1laOFRvZzgxWnVXUEVPVnVNaDVWUmNoL091djVk?=
 =?utf-8?B?dlRtblc2QjFxTnFFMjRsd0VVcTZrSGtzQzR3VW9iY0NCeTZiMUU5cmU4Tmtk?=
 =?utf-8?Q?47P8q7vY6K7S52gm9oGB34LYn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d619f8e-cfa2-49ec-e6d5-08ddf235e818
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 19:52:29.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmBYoTLzbeSMdciAhqy3pwTWn+9ZNILbD2WZ5vDEIReNL+DK5dg5u8Ud4JepIeMZxNvQNE/g0zW7Mz7/A2Tz1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5E0E7945E

On 9/12/25 14:41, Sean Christopherson wrote:
> On Fri, Sep 12, 2025, Tom Lendacky wrote:
>> On 9/12/25 13:34, Sean Christopherson wrote:
>>> But the below build failures show that they aren't dead code, which means that
>>> kernels with CONFIG_KVM_AMD_SEV=n will silently (until something explodes) do the
>>> wrong thing, because the stubs are hiding the missing dependencies.
>>>
>>> arch/x86/boot/startup/sev-shared.c: In function ‘pvalidate_4k_page’:
>>> arch/x86/boot/startup/sev-shared.c:820:17: error: implicit declaration of function ‘sev_evict_cache’ [-Wimplicit-function-declaration]
>>>   820 |                 sev_evict_cache((void *)vaddr, 1);
>>
>> Yeah, this one is on me. sev_evict_cache() is guest code and should be
>> under the CONFIG_AMD_MEM_ENCRYPT #ifdef.
>>
>>>       |                 ^~~~~~~~~~~~~~~
>>>   AR      arch/x86/realmode/built-in.a
>>> arch/x86/coco/sev/core.c: In function ‘pvalidate_pages’:
>>> arch/x86/coco/sev/core.c:386:25: error: implicit declaration of function ‘sev_evict_cache’ [-Wimplicit-function-declaration]
>>>   386 |                         sev_evict_cache(pfn_to_kaddr(e->gfn), e->pagesize ? 512 : 1);
>>>       |                         ^~~~~~~~~~~~~~~
>>> arch/x86/mm/mem_encrypt.c: In function ‘mem_encrypt_setup_arch’:
>>> arch/x86/mm/mem_encrypt.c:112:17: error: implicit declaration of function ‘snp_fixup_e820_tables’ [-Wimplicit-function-declaration]
>>>   112 |                 snp_fixup_e820_tables();
>>
>> This function is only meant to be used if we're going to run SEV guests,
>> so being guarded by CONFIG_KVM_AMD_SEV was on purpose. I'm just not sure
>> why the stub didn't get used...  or did you remove them?
> 
> I removed all the stubs to see what would break (I was expecting nothing since
> all of KVM's accesses are gated by CONFIG_KVM_AMD_SEV).

Ah, ok. During the SNP host/hypervisor enablement there was feedback about
doing all the RMP type stuff based on whether the kernel could run SNP
guests. So that's why we see things outside of the KVM tree using
CONFIG_KVM_AMD_SEV.

Thanks,
Tom




