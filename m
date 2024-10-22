Return-Path: <kvm+bounces-29330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3F69A97C7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF6951C230EE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 04:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D522584DF5;
	Tue, 22 Oct 2024 04:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xofGLxwo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF8E38B;
	Tue, 22 Oct 2024 04:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729571084; cv=fail; b=tdFSVepNhEe+W4dlBiO4REQZKW4hBwAtEN08UKOpLQU6/THVjbW31MKCy36RmxFQZNYTmUbAjFq9oSj361tPVvPKpvUnqbfOQ+T5I7kG1rDS+9X5qbeqR8ApQK15k/XmJZaF8WdYpJ8fDxk6nDpVZ+zXMqxsukdLzXY3pHc9eYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729571084; c=relaxed/simple;
	bh=VlzzhRWl9oY9J1yJWS2QymKOjRI3mHEBi4ornuPQfR8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rhCeAdo13VUjjvM6XIJ4DTQb0I5tgvq7IG5rwVX2XEVBA6bz8qGXuPPsdNEuH88G6XOtFvJgQ1L+afL10t8TZaNdPSdrKShatrGaSHlKM/FtnOz4pMipH5Jy5Dha4iKFD1BIwzrGZb/kqs1d8NA5BnVM0DPlYKpyC7OrbK9a4Qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xofGLxwo; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WFN0xQaZ72UFw/UnyWuSo189L6x7umml6IwQhz8JnFQKuhiA+B3otGu8KgH9XChgLLwOdupLTcpeydYzT2dYCuNBLhAZFEIZ1sf25IRsTQ899kf8bmTmdQDW3j0ZB41ZANvhH9BG0EtJHx7p8YKT5A2zwTwsVFbEWwnceK6voz2a6SU55dpVymfu6pwE2fcMGz8v0KHdeiXRJ0Sla1m26N99kQX0S7Lo4nQRXOiOxh3HgizS9OoIlQxJwVfMk8d92I9CvwfwGPT24C0e55u5zDr6dMcpzi23tygBJ3A3We/S+SgHVGwL2cRIBZRpdivpiUd3cB4H7q0Z6K+e4XK6Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGnGNoyoRPBmk3CPh1LW8W8yEUMka3KOJgd6BFOv4X4=;
 b=Gqz/xWZ1UySnUzJP3IHRcOoDEIbu8N4AUOIF/5mk3qDVnrAuOBgSMl/t1+t4DHKgL3+Hb58Kw/JRXlPPAQ1V91B0jWmGYor2elmBTzssEbYn7HCa4pznMPy0yfrN+fsgJ7Ij7RBn+tszK2zUYdGcRt5+dnMHpJitbJEdJRj4OQXgGXRWFt4XmQp5DiPsN88nSRQB3oocffg1XrMvRnla5yZ+i+u5yNHB+vhE/pL5Mc4KRKIne7/XX38Pys9pNyYItk+08YbAz0/Zg8JXhIavGkiRQe2LI+QbJUIyPbcAXaqvQpDeO3F73qDy4/0hrvzibtZ6E8JPUHKs2t4Z9vkHaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGnGNoyoRPBmk3CPh1LW8W8yEUMka3KOJgd6BFOv4X4=;
 b=xofGLxwouikEUVgpRcC1qi4tRdG6i9RC+49mpz7LtHp2/2d64FRMlGTWwFYz0m7n5cD7LArpI9B2G5vBLlnimQO5/VUo5ZK4nlBkvN6mzmtOd6chK1aHCedBrUufOkR82cl4VfGD+G5Bqc/hcRBg71I7l8Zyc4xIoG5CfFJPA6Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4320.namprd12.prod.outlook.com (2603:10b6:208:15f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.16; Tue, 22 Oct 2024 04:24:37 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 04:24:37 +0000
Message-ID: <25c87e59-970b-8058-6959-ddcf8ce09bbc@amd.com>
Date: Tue, 22 Oct 2024 09:54:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-10-nikunj@amd.com>
 <4c58d1f7-1493-ea32-c598-29edaa62f5c0@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <4c58d1f7-1493-ea32-c598-29edaa62f5c0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4320:EE_
X-MS-Office365-Filtering-Correlation-Id: d03d4e52-5d68-43bf-bf04-08dcf2517061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1JJeXNkTjF1NDZJS2hidENNOHNHN25ZZGlPNDZ0QkNRb202YTNwVE5aM0F3?=
 =?utf-8?B?czRQcTJvLzJ6NnVscVR3WFhMS1I4TDlseU9MSU5sNUZsaFJ2Y3B4QlFDeW9y?=
 =?utf-8?B?cm03UlVneEQzdFhHeUVIQXZLT0x2bDF5aFNYRTRRZUY2Qm5VMW5xeGRhRGdz?=
 =?utf-8?B?dWdpZ2plblRxWlhVOXdPNUwxNUROYm1CSEdpMUxlWVFpczRadTdvV1djS05j?=
 =?utf-8?B?LzVLS0RQSE5NR1FsdTNXTitYcFFaVFlOQmxjNTZCV2F5SDlNaUhsYjB2aE1w?=
 =?utf-8?B?TWk3NmJYOVZZYWI1ZXlOVVBOWFU2OWtVcU5aTW0vdCt1cEpQOERzNUhTYUZB?=
 =?utf-8?B?YXJWRUNqQmlJUVF0RmRIZHEwYnpWclIxVExkTEpqT0dDR3VzUy9oRExCQVI3?=
 =?utf-8?B?RzRFaEtiTHpUNXFLZUVjUnZIa0ttVTdJU3VtWHlHZGhwYTdHQWpmanFFUm9S?=
 =?utf-8?B?S015aDZEc0N1VE1xREtaOWU0Tk14a0wzQmE0N2hzMDB1VjM1eWJDQ1BhSnpL?=
 =?utf-8?B?NG5JTjh4UUpnQjRETmdhZEV2MVd5b0N0bnJqYlRLc1p6WHFwVVgwa2U0T3kx?=
 =?utf-8?B?QjlUd0d1WU43c1ZzaEVNTm9OcGJYOVZqaTZEY2FoWWtGVVdFSjI2TVQ5cWs1?=
 =?utf-8?B?alE4U1hXR2tXdEs2T0pSSTFFVDJGSW56aFhWYkFha2V3QmhOUUJORkVmT3pY?=
 =?utf-8?B?aHdJcHNEV2xQVWF1cVVtUjZvcmdnNEY0WFBTcHY2M0lpZjRYc2xEZHZKRGpF?=
 =?utf-8?B?ZTFVQWxxcFcxV3JvTmgwTkVwanoyY2JhOE1qWlhOc3o4U3E0RWZGVmEzNUxw?=
 =?utf-8?B?ajZiRGdmMVkwTzlWbnBpOEIyUlVMcVo0NWdRSnlMZWszWnk1QjN0OSs2ZVRM?=
 =?utf-8?B?TnpvTmlPK3BoOU5CaHA1YmhOMjlqUEVzaVJMazI2RlNqOGVXcGttcXhucll5?=
 =?utf-8?B?d1EwNkIwclF5YnlDWjYwNGdXcXlnWjZMMjZMdW1vbnZNYnZTOE5CV050b0JI?=
 =?utf-8?B?cXRRUVFHdDd1WHNoaldpVGoxOHlVMU9hREZRMWs0cllTSDNXdEx1NzQzTi95?=
 =?utf-8?B?L1FKaFhydnd4bk4vYnh5Z1BrVnAzUVN1ZzhxRTc4SzBPcHdlNjRtTXJZS0l3?=
 =?utf-8?B?aXhER01SM3dDT1loVmhRbkNualVzbkJHNis0R0RhY0xOZ3hSOHA0VVUyamxD?=
 =?utf-8?B?QzAwaGNad3IxdFVvY0lEUTRZdUJVT1Z1WEgxOWRvUlIwQk5rTmxPbTY3eGNM?=
 =?utf-8?B?cEdzZzFTM2ZYbzcza2RkenhscUVKQlpwNWpsNkFxOVY4cWh1dE1VME5CNTFa?=
 =?utf-8?B?cmVDZ2Q3T2hrZXlqMkJDOEh5RTlneG5sMVBmV3J6dHQwNkNMdk81SEhVVWpZ?=
 =?utf-8?B?TzFzd2ZWcjlVM1Y0dVQ2d0R4eWZsaytLdWg0VmhqOUxHdW85M0lrSDg3Z1NI?=
 =?utf-8?B?VFlMZ1gvRWRDcDhJM1hyN2NrQVhpSUpsU3dZTTBJSTZwVnlSKzdtdmFNRXVX?=
 =?utf-8?B?SEdJS1pjOUJMUGRNTWpFbm43d29uaEtBKzc2RnMvZUtCUFNjWDdPcjBrL21l?=
 =?utf-8?B?MUc1VjV5N1RFUlZneEExSE11VDd4VUozandlRlNZQ2ZrNHJhRkpqV1RZdElK?=
 =?utf-8?B?ZWJYdzVUeGFmMzlIYURNUVFFc2x4Q1Ywang3a1A3L2UwZ3EwdkZYZndBY2dH?=
 =?utf-8?B?ek9CMzRuQjdzWkh1TENhZnJpaDB2Y1IxMlFCQ0tnVkUrT0p2dmlKMms4bXA4?=
 =?utf-8?Q?CMUUJd0U8TS8HSPtZLNXyf4VTKB8Ky/5VUHBZvj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTU3Yncrc1lTRjJyTlFBMGhtNHhLVjI3UlRYMm9FckIxV0ZTUG5DYnIvazdB?=
 =?utf-8?B?aCtyOVlvNFFLY1pBM2tZZVpQcUg2VnFvYkJxWVBkYlBrYmxtRkZpWWh4KzNi?=
 =?utf-8?B?d2hOS1lsbzQ5WGJOOXE1bW0wMmVadm1rMWlMdHN4TVZ5cis2dnFIamYvZ3pU?=
 =?utf-8?B?TFljRi9PWnA5Q010ZkV4VWJqOTIxL3NLVVNlTDVJVHpub1VXMFdHZkt1TVV4?=
 =?utf-8?B?Z2hTaDVKQ1B0SFlQTjZpSWY0RmJUcTJNRjFXV3hEbkhWekFsWTFmUnJRMjBC?=
 =?utf-8?B?cVZDSndBR2dPd2tnMk1kblpFT0wzWHlObkdnVnVpWjFpaUJwMld3TndtUmNy?=
 =?utf-8?B?emNrS0xWQzJMdko4VXNFcXA1R3pqazA3ai9wL2FId0ZDdnZoNWR2NHZsTzBO?=
 =?utf-8?B?T2VMNSs1T1J5c3FNM0pCb3dWYnBkN1ltOTdFYjJrMElHMjYvSzNtSVJ6bi8z?=
 =?utf-8?B?RHQrSUluNWlCQUYvbktRVWVJLzcrNXNUK3VnNVlWckhiNS9idFFVSDlGallC?=
 =?utf-8?B?N3BGSmViNUJ3QnQrY2xrbW9EMlhyV1JrYlFHbENwL2hqcW00MVVkbkErK2ht?=
 =?utf-8?B?d25ra1JYeWVOQURiRGVvK3IwZU93ZzV4LzRueGg5UjBkakhoU1VWSXE3ak5M?=
 =?utf-8?B?S2h5R0VDK2w1bnJEdThDdzR5OHd3YVZmZGp4TW1EMlNUWjhFT3p1a3I0RnpH?=
 =?utf-8?B?T1d2UVBwRTR6M3FodXE0QmVpeUhLeW5OSEpBTUEzVERFT1pOZ09GdGxsOHFE?=
 =?utf-8?B?Q3haWklVUDdZY3NxV0ZtUFlwSTk5RGRYQXhkb1A1bnVXRUo5bEdHdzZDQzEy?=
 =?utf-8?B?ZGQ5TndTcGtUNEdJU3M1aVJ5VmNZWlFzSmp2VDVvbE1NNlNTQlFJRlh3UjBN?=
 =?utf-8?B?Nlhna1Vkb3JXWlRVZGpMV3hOZDcxM1RmUEE5bTFURmxvR3h2UDMrcVErTHRP?=
 =?utf-8?B?MS9QaFJzSm9Dd2J6eC9rVGRFZ01Vb1NvYUNoeU5YTG9SclA0UW9DSkFmNHk3?=
 =?utf-8?B?UWI2bXZDUzVqcWlhZEhIRFR0VnVrN3daWlR0N3ZZRktCRVpwd2VNdkFSV2NB?=
 =?utf-8?B?STBaY1F3SE05eFJvNzNqZXBjVVdWWmpKL1o4R3B2WGg2enJmSFkrUlpUT09D?=
 =?utf-8?B?V1ZIalR5WDQ2alJsRkdzNTNGSVVHMWc5a0FtSFJRRjNSSUR3anJMRTJJVHJP?=
 =?utf-8?B?bnVZNElVT2IwZ1orbGJQZEdnUTJxTkt3N1VZcVQ3amh1cjhoSWY5T1VvYnl2?=
 =?utf-8?B?THBKaEkzanp3TWJRZWZLRDJ4UTBqNmVkODh6K2doUUQxRmR0c3JWczY2T3Rm?=
 =?utf-8?B?VWNiTEF1c2hCWGVLMGtyZ3hkdmtQSUJpanRNbCtudGxJZHlZUzZOYUtlRWdH?=
 =?utf-8?B?V2VUWG5uWUZUTGVucVl6L0hDR3lDN2QxUGxCcENzcG42a3FoUVRDRFQzVVFl?=
 =?utf-8?B?OEdiMm54aTN3NFdHTXNHbitYV1dYUHdEZis2cjVKN1c5M2F1NzZMNXlqTjNt?=
 =?utf-8?B?cmE4bGlxdTE5REg5TnVjYUpwK2FSRGxFbnZwMTlNNFJRUkYyK2JudU9STU9Q?=
 =?utf-8?B?c3JsRG1nM3JwSU51b3FHRzQ5NW43aEZFZWo2TERuTGl3bEZ0YjhVT21yTUZY?=
 =?utf-8?B?YlBNUUlqZEhVWmZsNHprM1dlaUp0M1VEQ0YxZmlSMzVJUnBWTm5lcVh4d2lw?=
 =?utf-8?B?b3pDbzlmWmZPMG01R0RodHNIMXZNYW0renRmNDRLUGpPaEVnNndjeDJQTHk5?=
 =?utf-8?B?bDFmK0MzM2lZNkZNRGxESTJ4SlFuWWROWmFzVE1qb1cxKzBydVhqMSt0dEpp?=
 =?utf-8?B?NWlBcFRVLys5cmRES2tON0hVeUFBYXF6a1k1alJoS1NKTmgxYk00RDhvN2xL?=
 =?utf-8?B?NmJ4a2pJUElaMXZoN3BTSERYbkh3eUtFUm5wNDdscE81SXZkcERlWjhkemxx?=
 =?utf-8?B?REpEZmppemRENHJKWmJxVW5WdERXbVZ4dkh1T1Q2dHI0VjVxODRYejd1dmtJ?=
 =?utf-8?B?VWp4ekJxQVREZ3RxOGRIOFdEVElTVzhlVzlWa01BWTdhSi9RRG5xNXBZbWh1?=
 =?utf-8?B?QkpwMm1yemNmeG5QcHNJRDh6L3hhZFd6UXlFT25PMFR6VCs1QWhLQU51aFYr?=
 =?utf-8?Q?C7sBfrLhP24YumutcX7AH8rqK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d03d4e52-5d68-43bf-bf04-08dcf2517061
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 04:24:37.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vse7fBagUQIfj/PnsE98Zf2cuPy/tvJ0+U/xo+YsXJg1sUMolXFjHancpng01txxd7+kWz2JR/2Fvu8ZJ7sCZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4320

On 10/21/2024 8:03 PM, Tom Lendacky wrote:
> On 10/21/24 00:51, Nikunj A Dadhania wrote:
>> Calibrating the TSC frequency using the kvmclock is not correct for
>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>> GUEST_TSC_FREQ MSR (C001_0134h).
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/asm/sev.h |  2 ++
>>  arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>>  arch/x86/kernel/tsc.c      |  5 +++++
>>  3 files changed, 23 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 9169b18eeb78..34f7b9fc363b 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>  }
>>  
>>  void __init snp_secure_tsc_prepare(void);
>> +void __init securetsc_init(void);
>>  
>>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>>  
>> @@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>  				       u32 resp_sz) { return -ENODEV; }
>>  
>>  static inline void __init snp_secure_tsc_prepare(void) { }
>> +static inline void __init securetsc_init(void) { }
> 
> This should probably be named snp_securetsc_init() or
> snp_secure_tsc_init() (to be consistent with the function above it) so
> that it is in the snp namespace.

Ack.

>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>> index dfe6847fd99e..c83f1091bb4f 100644
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -30,6 +30,7 @@
>>  #include <asm/i8259.h>
>>  #include <asm/topology.h>
>>  #include <asm/uv/uv.h>
>> +#include <asm/sev.h>
>>  
>>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>>  EXPORT_SYMBOL(cpu_khz);
>> @@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
>>  	/* Don't change UV TSC multi-chassis synchronization */
>>  	if (is_early_uv_system())
>>  		return;
>> +
>> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>> +		securetsc_init();
> 
> Would this call be better in kvm_init_platform() or kvmclock_init()? Any
> reason it has to be here?

Added here to make sure that initialization happens on all the hypervisor,
not just for KVM. Moreover, kvmclock can be disabled from the command line.

Regards,
Nikunj

