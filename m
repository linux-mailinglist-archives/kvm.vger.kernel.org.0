Return-Path: <kvm+bounces-27410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 638C79855DE
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 10:53:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E8A7284FE7
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 08:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7B515AAC6;
	Wed, 25 Sep 2024 08:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GOTuWRqI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EEB2AE6C;
	Wed, 25 Sep 2024 08:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727254409; cv=fail; b=UPfthr3smfTR6BmBHZbC2Dcg6CP+Aw/OcPdvLj88O+VZ63q/femf6U0dOYqxNfL4RsedKzjLDSyEifs6Lq0QUFI/h/53DeB21Qs/A3Y4UYJQmm7wrlX5kBF3BJkJvOlOLW8Qr3Bm3rxV+c/Rnl/XEFUsySrURTaB5xm4ofmMl/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727254409; c=relaxed/simple;
	bh=ASdhJFsfEMq9HHZ7lkpVf8f5fh94tFkbhbZuKI7k0go=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tTd3AUwSm3LrgiujMTo4BSDBYgjhDhJIIMJAcVOQLym/0qnSBA00c7Q0Hz1hKYz4t2XrfTAGySVjPlXac26MUFBewg1wE1F9aAc7uvh4dKOs/BFe3chxAoThk/qTQ1an0jkC8pfSK1/GGs789LhRw5CDCc2mIrRmvh4hEwmDDX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GOTuWRqI; arc=fail smtp.client-ip=40.107.243.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JZHRM1aWZqdqpqth0RCTX0BXvV222NaEF/TvvCMCynmhXkztbullzj8UpkjeQF3iVx9CTVFXEO7yYHr84ymItDM/gP/418/H2ICIb955mCjN+pczW1bOyys1T7peTRts7AH8/sxVTqlVbv/EH0HGzKqHDVG9+uefGPvY4l93yDUzB8loJ6gtH8dgV77rSd7XaasTothRvM5+dgbvdsYRMHw+0wxC6V30PS7/cvM12Q4n2NpwXWW10s+Au2pYdp+W/280B8q8U4VGdf6Cwd/9jUcYJqEi1IU38uA2Z3U1uOZ1UE/m4U6cJOat+CzRiMgcbPmWTD3s3Qrt9oUkzqRNqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aSKzCjIkKczE4t1exx1OsaCGACsFMcCN2HB2phcYA24=;
 b=EfjeW+3FOq5zDxEvlZcpJQfD5krdi2GCFwiJ1cTrdC6cGjcFEHO18R1+F8Cp8e0bO8IYZhAy7VIItcRnbmLacgevmB41NGAtfd9rNck0rAqEl3ZrY1gvfodVhg1PoTmYYkGzh2zbrY8A84epb4j19yK+Mi4SDNd5Geyn0NoZdS6INCc6kzc0O3D0xAdEFYEydLc5yLjJC5ptd3sfwZ9EVgj4/XitoBbvEJijcx+m0U9LP+Nst8pSNQ/syhmbSOQhSK8p9khMdG5qeDqEmeSkNEhrAgfdR7Md+P1+N2gYW3huLDaii3qxMiT6MUrHM1m/45y2JzctAonvRrLrMQarow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSKzCjIkKczE4t1exx1OsaCGACsFMcCN2HB2phcYA24=;
 b=GOTuWRqI7L0dFO5YjwcfBgKsZqbOb9xEAMLTr9q6VSqxuW4fBNt3+efgr9qed4eMA0fRRpjvhXDcEM0Nt9tgu311dUUlcFjqBPvXKqGlURX3fJrs9HSDbBnKoJLuSqV4/5Ax93ZW7IJDCpeuyWRrIvBx0FaX2dJLWnW9ZbtN2C8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 LV3PR12MB9235.namprd12.prod.outlook.com (2603:10b6:408:1a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.26; Wed, 25 Sep
 2024 08:53:24 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 08:53:24 +0000
Message-ID: <ef194c25-22d8-204e-ffb6-8f9f0a0621fb@amd.com>
Date: Wed, 25 Sep 2024 14:23:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com,
 peterz@infradead.org, gautham.shenoy@amd.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
 <9a218564-b011-4222-187d-cba9e9268e93@amd.com> <ZurCbP7MesWXQbqZ@google.com>
 <2870c470-06c8-aa9c-0257-3f9652a4ccd8@amd.com> <Zu0iiMoLJprb4nUP@google.com>
 <4cc88621-d548-d3a1-d667-13586b7bfea8@amd.com>
In-Reply-To: <4cc88621-d548-d3a1-d667-13586b7bfea8@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|LV3PR12MB9235:EE_
X-MS-Office365-Filtering-Correlation-Id: 769fe76f-7e2e-474e-c073-08dcdd3f8392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHdzaVk5VmtCbi9pcHlnV0kwdlB0K01PSmoxZnlBbThObEg2Q2ZkR1BDMjFt?=
 =?utf-8?B?NjErWVhBOTFDRmtKMkdaMzBwQWpoNStCbjhLTjBJQ1plaFZLSlRLUk1RV3hv?=
 =?utf-8?B?VDFXbkhzQlQ2Rk9RSFk1clovVzdrd3JQN21HemZ3RXNnRVJKNjBNZVJYbThO?=
 =?utf-8?B?R2QyU2xZZVZJVEZwK3pMVmhzMHZuZWMySFlYMXFtNk53ZjBqa3o0VFgyUEFy?=
 =?utf-8?B?dVBhaGJBTENQVVdEMTZNTGxXL084aEN2cmtBUXYxSjRRZ2NCUkF2RUJZRlhM?=
 =?utf-8?B?S2lUUXJyd2hab2F5ZVRha1V3QkR1MzA3bWo2NUQ1eENrdU85TFRzaEhoaWZG?=
 =?utf-8?B?OGtuVkkrcEw1M0VvTjgzclRERjdDVTlscVI4bHpJOEpLemVhdFdldFJKRkRl?=
 =?utf-8?B?KzEyNmNXT1NFdVFGWmtCOUE0YUFRS091Z1d5MzNubzVsSW4vbEpQcldNcGNm?=
 =?utf-8?B?YWt3LzRsdG15UStsb3hUTElvTFJFb1ZvakNpT0lzUEFvNzA2TXFWcElZdTcz?=
 =?utf-8?B?MFR2ekt3T0xHWnN1S0g5ZEh5dk83R1o0a3BMNW40anZPS3U2cHhpd1pNNGZm?=
 =?utf-8?B?ZzRIRzBpVmlSemFvL0NjY0o1VFJjTXBlYzVZY1JGSS9YbXFzNXgyTU5HejZX?=
 =?utf-8?B?N25ETDR6VFo1T2EzNHRQTUV0SkVRcUsrdkFSaTdtMHFVR0FOMmxOazdkdDFW?=
 =?utf-8?B?WTVRNGMzSVNWWEtJVFVvNUduOGgxY3JaRksyVE1vdVVVSnByakJmb3lma3NI?=
 =?utf-8?B?WlJkd2I4V1NDVm9NbGE1czhLTEZKYkhUaHdCWWl0OTZiUEo3OGE5L3o3N0lO?=
 =?utf-8?B?RUJRRFNvbXJyRUxZOFc2TW0yNnFLMGFIVzB3SGtFU2MrUGM5SFNjb0VqM21o?=
 =?utf-8?B?TFNBK0Y3UzRscjlRMFc3UWRzMmtGbWVvOE9yTTFRUnRPa25lVGZ0WUcwb1kv?=
 =?utf-8?B?d2RkYkVtbGhrRXdubXpuUnN0TjFnWllNOUpYdW9YNmE5S3oyak1WQkFaeVlW?=
 =?utf-8?B?MWZLR2lBRW5NTlVPWTFrN0VHQ2FBVGUzMkxyTTJHQTRHMlgrTk0yMEFEOUY4?=
 =?utf-8?B?bW5tbllzUkZZT2hvWkRoRGNveXhSd3VmQkUrOEhVQUVmWjUwdHRLOFI3ZmpS?=
 =?utf-8?B?Wjc5U0RGUmh3Mk5VcFIvZloxVWlTTEJQNnZYZmdmMFFpc3V2U1JNd0NZWnM0?=
 =?utf-8?B?U3R1NlhxeUtxTCtQTVd2NEQrSWE3NXdsS1VzWkp1MG9GaFBMblBMUlI3UUpP?=
 =?utf-8?B?Nk9GbndqNmZ3cWpMQ3lGd0pTcGVHTXBOSGl6TFl2M0o1T1BLRUZBNVVLZnFZ?=
 =?utf-8?B?aVE3aE9JeTQ0dkJ5Sk1MRCtHNndwcWNab2pZZ3lZV09qUTJWT2J0em50cEVY?=
 =?utf-8?B?cTVQM09Mdzhra2o1OFplcjFPcE5WK3ZXSTNGN0ZGWG4zZjNvY3FpcFBMaHRS?=
 =?utf-8?B?blRRaWJVcWFNV0tmaFhSbUI5bm90bStKa2pNdjBDOEFtcjVUZ2lGNGJZRzFG?=
 =?utf-8?B?OW9ZZ2wxZVZpRUpyclF1bHZkanVvRGxQVlZyeS84SXE1Njl6Y0QxL0VMVXFs?=
 =?utf-8?B?cityWmFDdmJYeVdsTHZIQ2FjSDByd2luMnIwZEhTMjQ1TVh0SjBUOTMxZmkz?=
 =?utf-8?B?SEZTdy95dGNQYTZycjFZM2pjUFY3UUdEME1SVHR0R0RXTkhrVlljcnpJRVdT?=
 =?utf-8?B?anFWQWdBeWZNNVppSDdlTk5WbFQ3dXdmdUlienh2UVNxRGlxL01IWEpBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFpoaytpK1dRY3drZ2l4U1dlVXE2bDVwNDVjUGxiZGJsUWplTitIdWs3ejdi?=
 =?utf-8?B?RmllSTBlNzlFdG9Cb2laVkhBdDhkRUZaZ0ZJd1YvckV3YUpLTW93eVVldm53?=
 =?utf-8?B?YVFCUDNBWUQ1VUo1VUR0OVN1RGRuTnJDTWlVMVUyaDBNMGxnbUZwd2lRZGR6?=
 =?utf-8?B?RWp5M2dwT2pwa2I0RGFtamNwdC83bTlkNytFYXFNeTIwZHN5Yk1DRXc1YmZM?=
 =?utf-8?B?NXVkcjJuT3lkV1FnblpVVVdRbU0vdjM1Z292S2JmeS9xMjhWcmdMV0dZQjA4?=
 =?utf-8?B?TFJxMjV0YklXTnlzcWIrUWl6VmxQeWdCZUc0WFZkUDhMQjVLV29LcENRL29B?=
 =?utf-8?B?WklNTDhxWkJMQkN0YzlXK3NjYzFjeHRNeExKbkJMQkhCc09zL2tPcHJhRjFD?=
 =?utf-8?B?bjQ1dURqZFZScnlEZ1Z4SlZmRUpMNnZ0K21vZWJMclFQTUZsaTFzRUptcDhJ?=
 =?utf-8?B?Z0ZVbThvYW1WSVZDcnMzbzJPSWtld0RnbTVkR1NXbFRKSm16bE8rSC9xNTEy?=
 =?utf-8?B?Wk4wL3Y5L3pzRXRTMHZFMWo4RHorYTZ3ZFRuNi9lSDhiY00wcStBWFZ2L1ZC?=
 =?utf-8?B?VnVlVFIzUm1ya0EvZk1ncSs0anE1b29nWW5sclVkTTVacDlCNWJrRkp2d3BO?=
 =?utf-8?B?bmVSRU9PQkxocG82V2xkNUN4TXcyeFhoNTlCY2UvTmhvK1hIMkJGRmVuWm5Y?=
 =?utf-8?B?Q3BmWm8ySlRXOGs4U0JwRkZZVTlEZFZEREFiMTF4Qkh5UDFUa2tKa3RvTXV3?=
 =?utf-8?B?UU54S1NtYXp4QU5XNVNEWWdaZTdBN3FBMmpqdnlWOXVzNHNlcVFCK01IbHRS?=
 =?utf-8?B?ckJmVnhXS0RjTktLWTE1WGhJN1RaYW1yVE53bUpmT0dSczRxYWZtM1hJSkc1?=
 =?utf-8?B?QlF2b3NhalJLSWFPejI2VlRMZkhLVVF5Z1pkK2xvenJlMkdnU053WW04NmFl?=
 =?utf-8?B?MWR2b01kbk8xVkIxaGdyMzRlRTdTUFErTXc5WkR1OXdleFoxbTlKMWhsaWVS?=
 =?utf-8?B?aHBTQUdiYTVMSVZTQlVMOHlGS04wSGJ1SnhNR3YwaFkyVkVTVUFwd2M3VUhm?=
 =?utf-8?B?SEpRSjM1NE41dnZMSUVRbzFwdjdKZDdxVzZnWkRaVmZNNkpMbFFOUk1yUERx?=
 =?utf-8?B?WUVubk96NEtGd3hteHBPNm9jWVhiZ091aEZQZWdmUEtqUWFXN0JwTG40VG95?=
 =?utf-8?B?TTNDcGp3OFY0R29nVXJjSERvODg2MzhVU2lxb0FINEJKYzAvMDJON3Rsdjgv?=
 =?utf-8?B?MVFVL2pLQjE0UnVONHB6YVNzU3ROWkJpTG1BTHcveFZuVW9rYmlMeC9XSFdn?=
 =?utf-8?B?U0RqUVU0blU2N3VDL0MwMmY0cXRDQ2lzc0VSWHhNbFErbFYrOUMrZFVPVHRt?=
 =?utf-8?B?Qk54dzVqd01yUFBNTGo3Rk9IdVZvUW5kUmZYd25PdDZ1Qk9XcmFBQ1daTm82?=
 =?utf-8?B?OHJJSktFS0FpRkRvTExFSldRODFRamxBM0t1bHkvWkx0RTZibk9nVWZ4emZU?=
 =?utf-8?B?SmVjUThhdkozRzFYV3J3T2JmaktiTVUzZFp5Rm96aC8yT0lhZU1hbS9TdWt3?=
 =?utf-8?B?L2tQaE9HR2xweDBZZ245Wnl3RUZrai9TdU9wSlFhS0ozMm5oVzdNQ1BBK1l1?=
 =?utf-8?B?OWZINURIdUhPUitEU1J3M1dIV0NjZ1gyNlZyZ3BlM3JEY1RPT3RxS2JRK0hk?=
 =?utf-8?B?anJmdDd0K0JUMGhXTVJNQWpGSzFpT3BoTXFoNnBVS2dkV2JoS0xrOWRITDFu?=
 =?utf-8?B?T1c4UENwYktSNG5vVE9jc0cwWEIwdkpOcSt0THR6M2pBWXowM0gzMXY3L1N4?=
 =?utf-8?B?R0VYYllLdjlDVzN6cENiS1h0d3kxeWVHdW9lRjUxWEZSOEJUTXh0VCtwbmUz?=
 =?utf-8?B?NTdrQjdCSDZjWXNVZ3lPUDF1YTFRZ21VaFlmWG5BWGgvMzhnWFpUcEJwRGJR?=
 =?utf-8?B?RTFMS20xSVlnNllwUjhTYnV6aUZ6NkYweUplVy9adktZaEkxay9OOXVxZlBR?=
 =?utf-8?B?a1IycVp2MmNWMUpPYUhNNVVGdXFJeEFGRG9sYnIrWXdkWmdSWUpsbzhRa2VG?=
 =?utf-8?B?V3ZuQUpUUzl3UHNrOXltRzZHS2hEUGhTZjQvV3A5OXVQRWozaTRPNktBY0xp?=
 =?utf-8?Q?8tSIMttIPcmFwac2I8sqiAvB6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769fe76f-7e2e-474e-c073-08dcdd3f8392
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 08:53:24.3111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AaVJ/Vv/VkSelNMQ77lie7yhIW5DaM/QkWH8B//eiW50z74LV47pNGh0PTYtUjiMOBsnyeEUdbr+dqO3q1uvRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9235



On 9/20/2024 2:24 PM, Nikunj A. Dadhania wrote:
> On 9/20/2024 12:51 PM, Sean Christopherson wrote:
>> On Fri, Sep 20, 2024, Nikunj A. Dadhania wrote:
>>> On 9/18/2024 5:37 PM, Sean Christopherson wrote:
>>>> On Mon, Sep 16, 2024, Nikunj A. Dadhania wrote:
>>>>> On 9/13/2024 11:00 PM, Sean Christopherson wrote:
>>>>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>>>>> Tested-by: Peter Gonda <pgonda@google.com>
>>>>>>> ---
>>>>>>>  arch/x86/kernel/kvmclock.c | 2 +-
>>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>>>>>>> index 5b2c15214a6b..3d03b4c937b9 100644
>>>>>>> --- a/arch/x86/kernel/kvmclock.c
>>>>>>> +++ b/arch/x86/kernel/kvmclock.c
>>>>>>> @@ -289,7 +289,7 @@ void __init kvmclock_init(void)
>>>>>>>  {
>>>>>>>  	u8 flags;
>>>>>>>  
>>>>>>> -	if (!kvm_para_available() || !kvmclock)
>>>>>>> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>>>>>
>>>>>> I would much prefer we solve the kvmclock vs. TSC fight in a generic way.  Unless
>>>>>> I've missed something, the fact that the TSC is more trusted in the SNP/TDX world
>>>>>> is simply what's forcing the issue, but it's not actually the reason why Linux
>>>>>> should prefer the TSC over kvmclock.  The underlying reason is that platforms that
>>>>>> support SNP/TDX are guaranteed to have a stable, always running TSC, i.e. that the
>>>>>> TSC is a superior timesource purely from a functionality perspective.  That it's
>>>>>> more secure is icing on the cake.
>>>>>
>>>>> Are you suggesting that whenever the guest is either SNP or TDX, kvmclock
>>>>> should be disabled assuming that timesource is stable and always running?
>>>>
>>>> No, I'm saying that the guest should prefer the raw TSC over kvmclock if the TSC
>>>> is stable, irrespective of SNP or TDX.  This is effectively already done for the
>>>> timekeeping base (see commit 7539b174aef4 ("x86: kvmguest: use TSC clocksource if
>>>> invariant TSC is exposed")), but the scheduler still uses kvmclock thanks to the
>>>> kvm_sched_clock_init() code.
>>>
>>> The kvm-clock and tsc-early both are having the rating of 299. As they are of
>>> same rating, kvm-clock is being picked up first.
>>>
>>> Is it fine to drop the clock rating of kvmclock to 298 ? With this tsc-early will
>>> be picked up instead.
>>
>> IMO, it's ugly, but that's a problem with the rating system inasmuch as anything.
>>
>> But the kernel will still be using kvmclock for the scheduler clock, which is
>> undesirable.
> 
> Agree, kvm_sched_clock_init() is still being called. The above hunk was to use
> tsc-early/tsc as the clocksource and not kvm-clock.

How about the below patch:

From: Nikunj A Dadhania <nikunj@amd.com>
Date: Tue, 28 Nov 2023 18:29:56 +0530
Subject: [RFC PATCH] x86/kvmclock: Prefer invariant TSC as the clocksource and
 scheduler clock

For platforms that support stable and always running TSC, although the
kvm-clock rating is dropped to 299 to prefer TSC, the guest scheduler clock
still keeps on using the kvm-clock which is undesirable. Moreover, as the
kvm-clock and early-tsc clocksource are both registered with 299 rating,
kvm-clock is being picked up momentarily instead of selecting more stable
tsc-early clocksource.

  kvm-clock: Using msrs 4b564d01 and 4b564d00
  kvm-clock: using sched offset of 1799357702246960 cycles
  clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
  tsc: Detected 1996.249 MHz processor
  clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
  clocksource: Switched to clocksource kvm-clock
  clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
  clocksource: Switched to clocksource tsc

Drop the kvm-clock rating to 298, so that tsc-early is picked up before
kvm-clock and use TSC for scheduler clock as well when the TSC is invariant
and stable.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

The issue we see here is that on bare-metal if the TSC is marked unstable,
then the sched-clock will fall back to jiffies. In the virtualization case,
do we want to fall back to kvm-clock when TSC is marked unstable?

---
 arch/x86/kernel/kvmclock.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..c997b2628c4b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -317,9 +317,6 @@ void __init kvmclock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
 		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
-
 	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
 	x86_platform.calibrate_cpu = kvm_get_tsc_khz;
 	x86_platform.get_wallclock = kvm_get_wallclock;
@@ -341,8 +338,12 @@ void __init kvmclock_init(void)
 	 */
 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
-	    !check_tsc_unstable())
-		kvm_clock.rating = 299;
+	    !check_tsc_unstable()) {
+		kvm_clock.rating = 298;
+	} else {
+		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+		kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+	}
 
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.name = "KVM";
-- 
2.34.1


