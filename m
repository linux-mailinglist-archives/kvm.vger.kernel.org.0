Return-Path: <kvm+bounces-15600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 325068ADCC7
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 06:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 561CE1C2185D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B351CFA8;
	Tue, 23 Apr 2024 04:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cmMOyS3n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83D3208CB;
	Tue, 23 Apr 2024 04:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713846176; cv=fail; b=CIVzdwM7BTX+ENHcV3TauxhIe4uEcHXq1iv9A961qMKIsI7DAiXVD4NcmbBQWYkOOs8UBfeDLPjZ45aRRblghoK/7UPaQjhvlgv52OWMOin2BVZdr0xLqHbprPj0EgGypgISZvP2EWGpiXHneUDKQL7SbbnhOCsKUVCjAP9tM6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713846176; c=relaxed/simple;
	bh=fx8DZOfd05GU/BIf+sOfLx+QLRR+BHL5NkB+SFrPzEE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IZkMWmgX5TPpCB16R4bTpwTxSC1dXgHZw00u7195TVgtkmpELuZZuiOOq3G8MRKb/0uo2u0m1ao6KIaPjOmoXCwi+Q5OHe0KChsm0VOHL6ozhgRFZPEuzymo7l852zgoYMYxHyQLpUgk01iCoeoEtrd28dgBLso9Ehlva8M8G1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cmMOyS3n; arc=fail smtp.client-ip=40.107.237.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qel6dRb+tuxyrQoVwD1lacrVnIPBy6LE5gTI3gVdeQRouWr8F/1hMK5Fa/VOQOX1c7MZAzYNd2RYM9nDbDLenDGzoX0/+o+d2Xl/2RXTswGRdYgVQayO0W+4LcRzcVvm5IB0N59BJDOLwvjVQ3SIpSR4XfC8ab2bfF/GqYkbxTHkA85EpeUwAdqny4U2KxVj8YxHBKb/kSubTDDitCzNr3z1Qt4HynQEOR+5+z9bL98jGrKtup3LaDYHIQA6tBM+ZkOQ8rMcZRzujKD64IWJ9PZKjIbQ6RpLQoN5ZDQ12v/TiEio141DONNsF7Har7PR+bIqQG7BQRHYfU/zay+HwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+N3x/H4IyIDfmFY8YBT2TdrNvENfKGnRAck4h8lVOaQ=;
 b=c5NtxgBH/OaPQxeDjTobRsjAfbhOocpceKYc0Y0+BSFScs7v31auhk6nF3qarDgIwgwvB0WZ+n45OMLIpHkGqgkjrHtrsBNbDqL3jsUWK6Hb/HYVsn6+m+jMOcj+cHQC3pICjcAxKQcB4fo/hb+W/qkE0feky7AvAs+14qr4/pQl7Mlclx6mkD7Xk9rePcppuXheMbpObRgg7fmZLozhRft0ztprlkgJT7WuJn49cOXEAdN8foi8FODwl4uM2ldS9/+pm0DvXOyjm16jVHdLjHKDSzLOTGKAVg0BQNzoqagi4gIpVocejMdJf6vrw/dahQA5jFQSN8VcaTavvO7mqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+N3x/H4IyIDfmFY8YBT2TdrNvENfKGnRAck4h8lVOaQ=;
 b=cmMOyS3nwF/n3UdbkxI20N0cbYXuAR8YwHMFvvqNBlH0Jgj7Sa1TRGn76g1iz+FDFEYAAQ8jx04sG9VuQdKkumOpLdh56nu1H56EWTaqznXJpEbmGv2iPQWkhN0tmA4fRjgqUcIHcjGutEdHOTPmDVorxAAUS+iyfKKZAAR4L4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB8766.namprd12.prod.outlook.com (2603:10b6:8:14e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.44; Tue, 23 Apr 2024 04:22:52 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 04:22:52 +0000
Message-ID: <6a7a8892-bb8d-4f03-a802-d7eee48045b5@amd.com>
Date: Tue, 23 Apr 2024 09:52:41 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 06/16] virt: sev-guest: Move SNP Guest command mutex
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-7-nikunj@amd.com>
 <20240422130012.GAZiZfXM5Z2yRvw7Cx@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240422130012.GAZiZfXM5Z2yRvw7Cx@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0171.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB8766:EE_
X-MS-Office365-Filtering-Correlation-Id: c03c2982-f3db-4210-d100-08dc634d0a74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTN0S2xoNCtSSnNrTXBiYTBJR1BoK1A4a1FRUmFsQzNvZDJmcU5kakR1OWZC?=
 =?utf-8?B?cENDdEw2c2poTWNsMy9zSm55UkV6QUpoekNobXJFU0lpKytER05GTzc4VzlB?=
 =?utf-8?B?WGJTaFNuNVA2V3FtUnBxcXFGVzdBVEE2NWdjNUJ2LzM5Vml4NldBTE56alBJ?=
 =?utf-8?B?Q1BmcnpoNllHTy9xd04yVWxCRnJHQ1JCVEFGSEJCSWxrY2p3M1JMSXZNZGZh?=
 =?utf-8?B?K01CM0tiV0Y3SG42cnd4NEgzVnVvZ0pKZGFlWWZJakh0M3lJK0I0OW0xQ2JT?=
 =?utf-8?B?OFFmNzJWMTQrWkFiVCtKa3NhRjRZUU9FNFNiV1F6VG01NHBtYno2UkJMSk01?=
 =?utf-8?B?SGJhSzU2eFlySGtjeFNHQXIySTdYOHl1QWxyQnBtcmQ4SnF2d1c1TWNaWXJV?=
 =?utf-8?B?N3lVUzQ3Y0Y3cytQUkdaN1F0dVlKRTQwUHFPR1JpaDBxNUNGYTFlMmNzb0hT?=
 =?utf-8?B?TW1LSlh3R3dkOVFKSUZTWHZoOUxZZ0JPL2VzZ2RQUDlpQ2dxVEVZOVhuZXVT?=
 =?utf-8?B?bXJic0krRzlRZDZOT2NKMjcyTnhNZnFMTmh6bm9vNUZZd0NITEtMTTNxU25K?=
 =?utf-8?B?b2VpNld1K2NpZkMrOE5hQmlBZGE2QndTbGM5TzdMbnY5anFZSWhveG1naFZ2?=
 =?utf-8?B?dU1SVkFLeEpncWV1TTNjTi9BTnl4ckV4cWl6MlhzNzdJUC9zS1VtSGxvRHZB?=
 =?utf-8?B?MlZOakE4aEpPSlBvakFQTkJIZDFMV0tNb3JGdHQvanpRNUxCbVZSL2FuQ3lH?=
 =?utf-8?B?S1UxUGM1bkFHUit2UlA0M0tORHQ3QXhRWjRoUml0cVNqQzc3azFEc1lscm1j?=
 =?utf-8?B?U09MQXM2Qnh2b3lsaEhobWU1OWlyRXhablhsNU5YVWFweXF5YzRVcW9YTzJQ?=
 =?utf-8?B?eWNjQ2s4K3Z2N1JVRWNoRmtlbVAvNEtFWE5FWXk4dFp2ajNzRFpLNkt6TlBW?=
 =?utf-8?B?aThWbzBjemZjYmRrTFpRdm8rRDBlQ0dEKzlPU0k0U1licEdjamRiQVk0T3Va?=
 =?utf-8?B?S0Q2cHhqZE9HdGFLdmtjems2c3pYV21vVTU4R2FXK3hhNmV4TFEzR0hIeXNP?=
 =?utf-8?B?VDlFNXRNZ0RPVFBBYitJVVRBdTNNclM4aGdzeWxJcWJ1VEJ0L1U2STRrS0hI?=
 =?utf-8?B?UEYwNThJVHdqYXh6NHB6ZEZIR3dXczBDenhWM2RrUHJwWHRGTStmcWQzMzNW?=
 =?utf-8?B?ZW0zN3p6S2NDQXN5dEY3OHFwNTNOZDBYcGtPTWp3RWdRMmw4NmkvSGVhU3V3?=
 =?utf-8?B?QXJINlkvejA0Ull6SEdGQy9XRkNYRjBocUp1WWhuQzRJTDF4SElzSzZCVUVS?=
 =?utf-8?B?bVVlUjU4V3VKWURnUko2eGNiOWlRWkcvS3Q4WlVuOGVBcFp6K3ZEa1h1a3cy?=
 =?utf-8?B?Si94ZlJEYkRGMFVycVlWY01LTkU3SW9jOWVuQ25MWHVjZkttMTdTWVl4Nldu?=
 =?utf-8?B?a3NFMXdacjNLRzd6UGxUNUE0NXRrUDZjeHp6em1aeEJEYU5lUnVQTDR1V0ZN?=
 =?utf-8?B?SFFLSU1raTdrSEJXOCs4UUVPR1hRalRLRTJSMGQvam9KTDVlNlpzNGM5TGdY?=
 =?utf-8?B?ejQ4S3YwVTJVcVFUNFFwcW4vKzRBR0RmMzhySDBwa1RXVUtVMXU4NkY5T2k0?=
 =?utf-8?B?TlBVcUV0R1pMZFdNcVlGc2R3REZhbTdReG4vVGxMNUhXTjVwMjlXdnNkMW9N?=
 =?utf-8?B?RjQzSS9VMHFDY1lYWnovak9MbXM5bUNOWnB2MW44OVg2ME1oUE5vcERnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QURVRExZNkRpNmlGK1JjOERIUyt6NjdCUkk1b1JydmZTN3cyZkhFbWhNNWdP?=
 =?utf-8?B?VEdLbWZkdkE5QnFuNUFoUzh5NXNpN2ZGMnVLR3pQZmlWdkJNT1FXM0h3Qm94?=
 =?utf-8?B?SVJ3VjB6VXlIV1NYNnBzSnlCbGN2VmJlSlEwUml6aGFTVXRZNmNMWFNMRUps?=
 =?utf-8?B?U2diMHRDeklWWm1HZHIrVjRONTA0V2VIaVVldnBpK29XNkxNbDJ1NnZYYUcr?=
 =?utf-8?B?SnRNclQ1Y3E3N2p0alhGUHhkRmlGN2QySHpnV09HdTVBbTRsZFl0NDROaUdW?=
 =?utf-8?B?M2QwYjk5Vm9oeERZbGo2ajNkdThCdVUzdEluRFczUmhDQkFpWDBROVRiUG0r?=
 =?utf-8?B?eHNVQmx2TzNFSWRmei9RODdWd1pTQ2d1UUozbE9YMFMveWpUWUtTcndacG9E?=
 =?utf-8?B?VzZuSFd0cFAyVjhoL1dETjhtUHdPazZyV1lNRTlFZlo5V2YvWW8rUFRENzho?=
 =?utf-8?B?T3J4ZkwxZnVHZlJDTFVNVmtNcE5PRzBTandLRWI0dU1BaDIyc3BTcmhQdjli?=
 =?utf-8?B?dGJKVlVmWWFSZC9zUFBpMFNZRjAzVFNRSVZMRFNKVU9PWmNkdThBYWcwU25v?=
 =?utf-8?B?SkR4Qm13M2FvOFl3a0FHK0lNWUFnMENxZTdYTVFvRWlqSGN4ODlaTENSazB0?=
 =?utf-8?B?YmxMb3Vad0wxbnJSMXJXY3Qrc3pKZHdTVE1qQ1ZjaVVsSkpXc2Z6UFVnZmls?=
 =?utf-8?B?YUxabll3dXNhZ1lqa0pOQi91Zy8xenpOQXprcHFIaTVMWHV1RWZyQXZ6NDZi?=
 =?utf-8?B?RUpPSTFOdWVDVWRjWHpPY3grYnRmbUZKZk9IanN6N1FVMnBmVjJwYTBHbWN0?=
 =?utf-8?B?YkVmWERUN1V1Z2wxWHVIam8zOVlEeC9qaUtob0pQMjFmQjNEclJaeVU4cVBL?=
 =?utf-8?B?Rm9qRTJBcUZnRGhWd1Bxd2gxTi8xb0Y4Uy8wNkhka3Vmc0VvbHFxZWxLNnVQ?=
 =?utf-8?B?NFVOOXdvNGR6MmtwbXpoRTU5ZW4wcFRkc0QrYjRJdTFPMUIrVUwrbzQ4VGR6?=
 =?utf-8?B?eWMvclRLNzlmeHVuZTAwdEx1MXV6TEJXOHhrTWl4b3plcTdsbzh4T0thYSs4?=
 =?utf-8?B?NkdaYytkUER3Y2h4VkVDL21aUWFFZmhIdDhDWDBPejRwZXVRQ1NHd3V4VnJZ?=
 =?utf-8?B?a09ZWEFrSTBnZlVmVXpEMWF5ZTRzWlV3M2tpaWpwMVFtZ1AzSnB2ODdIbnlT?=
 =?utf-8?B?R2J2WGxmeVo5WGhxcW44OGNaekdKYlN5YkRQbWk5QlVIby9nQ1R0eUZoM3Nk?=
 =?utf-8?B?V0xMVnJnbUg1MFpHWXdoYzFBaTZWNzJlWlBDSURBbzJwSkFjYzlsR095S01v?=
 =?utf-8?B?SXVoS0prTGU3YVZBSlBaME9FQ3ZDNFo4SXZDQUFoN24zMGw3bTRtL1VVQ1Ur?=
 =?utf-8?B?L0NPbDNFZFJIcWdUWmtnN2VPYmJEZ3NhcGtMSllLdGlIM1c1UVI4eDFwNUNI?=
 =?utf-8?B?cDZpc3k5Wkh1cFdjMUZJb1BZUUxVZHQ4cCt1QXRQeFJHcFFOL3RUVy8zTzRl?=
 =?utf-8?B?c2kvOU02Z1hzekRvcmpuWGdPR2kybFJHQlF2LzRDcUxLNzZpV0xUcFJoOUxy?=
 =?utf-8?B?Q0F6dUdFOXc1c2JpMHpSWkVaQ3lOZFlTdkpvSVVJYjAyTmg5a0tvWW5tVjJG?=
 =?utf-8?B?UFJoSzZoYUQvL1VkZ2RKYzJXS0E0T245RnJpSTFXOXBCYzRmc3N4bGg1OW0x?=
 =?utf-8?B?U1ZrQzVVSk1iakluRUN0SnI3QkJQdU1jOEtOdGdEbXhtWkI2TFdYMWIvRERS?=
 =?utf-8?B?VFVzRXN1M0ZoRis5VXY0VytTU1dQZjJWbVM4THBpdXZ6cUluYmxNYTZOSlZr?=
 =?utf-8?B?aEVhTWRUUDhxMW5WTWJiSXpkeUZXMVhTLzZHbThack4yb2NFQnJueEM1TERC?=
 =?utf-8?B?WjdlaURrYzkvTHFRNEtGSUEzazk3a0l2L2FRQzJVU0xHWVgrMUkwak5mYXlk?=
 =?utf-8?B?L3piTFZKOWJhZDN2aHhJM2c5T0NtMDdiWWd5Sm5yN0tIWElFcGUvQytCNGxo?=
 =?utf-8?B?SGxiVGJONmtYQjVtK1Q5eFN3Rm5vV3RacVFBZGJHdUR2b040bzcyQ0xJWTR0?=
 =?utf-8?B?M0dHbjNBVXJHTS9zQnZwZ01wQUpSaWNpL3k0RTBmMy9kQW4yVlJXOTMxdm1r?=
 =?utf-8?Q?o1pUohlJIbMXjM/SigaKFCdOp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c03c2982-f3db-4210-d100-08dc634d0a74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 04:22:52.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5VLk8TJzo0KtS0m1Bs6Oa5iC/PguNz6uOxH2AEFELlaIkIn6imwCjZhEZGmJEeT9kl9CM8CMDQE6NIMpOEblg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8766

On 4/22/2024 6:30 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:18PM +0530, Nikunj A Dadhania wrote:
>> SNP command mutex is used to serialize the shared buffer access, command
>> handling and message sequence number races. Move the SNP guest command
>> mutex out of the sev guest driver and provide accessors to sev-guest
> 
> And why in the hell are we doing this?

SNP guest messaging will be moving as part of sev.c, and Secure TSC code
will use this mutex.
 
> Always, *ALWAYS* make sure a patch's commit message answers *why*
> a change is done. This doesn't explain why so I'm reading "just because"
> and "just because" doesn't fly.

Sure, will change.

> 
>> driver. Remove multiple lockdep check in sev-guest driver, next patch adds
>> a single lockdep check in snp_send_guest_request().
> 
> The concept of "next patch" is meaningless once the patch is in git.

Sure. As direct access to the mutex was not available now, I had removed lockdep
check here and documented that lockdep gets added at later point.

Regards
Nikunj
 


