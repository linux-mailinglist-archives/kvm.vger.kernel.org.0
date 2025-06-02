Return-Path: <kvm+bounces-48212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C61DBACBC56
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 22:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8088D16427E
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 20:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E9322A4DB;
	Mon,  2 Jun 2025 20:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PvxPjov1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20528227EA4;
	Mon,  2 Jun 2025 20:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748896358; cv=fail; b=IyB4yKuRqYhtAWB2N7l36VhMMRioEnlz/zUDE4CExX+IhqFVQHi7JsbSuZe8lg/IbBbkzBwfDi6w+SPnArf9PU0kYXQZuS0d8uQbb2UZufcSTwg2Fg5oVW873XDIQA+5fG1O1nEu0vG8+4VrmiACTHkFIkRAP94qIaN5iJ46gZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748896358; c=relaxed/simple;
	bh=nM90/0q7j2DedUthyWkDmszvtrwi9XCKu9OVLtsGpZc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MmBxQp+zCY6blPT3xO9kLbH/FC75KaCIjp5pyIkCL1La1wD4WALUf7yM2nkZy3CNTGtYJBDt3fjbB3xatLRIn1t/b+/XryFrhvCpK2Z69rgYQBROev2ij7mRR1vf4NX0iEeLl4ZgyysDnqnj7zpq4eLgAo41xditMZMyiY/sPNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PvxPjov1; arc=fail smtp.client-ip=40.107.95.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OZOe5RE8G7zgEjkZTAQTQf/ItN4pDE85uOOeD5SFNsFZZ+VYtVlngMxYT4lciLSmsz1sNeaN9fsn6wUHnxoJc4S9/7CyJPJafQ2aQ/A3pZEW1R+fwGxrjnpv+I2+RYqxe+x7EpxxWJwlEfMPlPIMbd48WpmFjrCfLZN3GPBtvoa2+XzfsqaGMT7OY+gx3bmGwEAH6dvNtH/s6iShF5d6xOHI/JOigbYPEDj9/61KivMjnVfgZsdBTJdjQhqRwRNNBIakIsOipqbsOZoDhVSlcMY+MERhExnOyTZz5ZLyTA+djKlBhSxgJvW3cRaOUnunCtrg7FLQblBaz9xq5Pbeyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Xu3FwXUtD/eKOclE2aUJTZagtV6rwmIegAIAvdErJg=;
 b=hlnPd6hwz/dFAHRcLcpoGSxMXZmDFGMDjpFupQVcmfXRBfAwuxPKMluf1DJZblot216F+dqks37zGs5o/jERHoU5FgPGxIqQHV79pxe5UznSFnAz6evHAmf7mWtN3V68gGdUgzgmpsxSRHw0vv+bG3zjhVX+qlLL3w2SATtNRxqXefKUB2mQI1VTe5IA7ybq2TQ8+tuEcSs/NmVuii4t4S03lIq5dj/pYAH48Fc2f7Rxc23lTUDlqVMnNkt7jNiCVDuo/D6NUlRWhpVUksTUenCD6hH6sjedlC4QYxg7m2JJKhVNZB047xKzLVzD9Wg/xPHM7RT+E7Fo7O5OVbNGXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Xu3FwXUtD/eKOclE2aUJTZagtV6rwmIegAIAvdErJg=;
 b=PvxPjov1WTdn5pjfkb6Yr8X6jA39VV0i1+rG6l46t8HPo/sVB4zCdoqOSu/KdWBvlvCoOam0jwyWS/ICaSeg6FE1QKee0EqTPXKxvch98aJnfarBex0AvdnKyGEsdZAF1aBbsT5H6m40auWq74lBxysi+63sjeOtWH+4mxhQszc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB9070.namprd12.prod.outlook.com (2603:10b6:8:bc::12) by
 CYYPR12MB9014.namprd12.prod.outlook.com (2603:10b6:930:bf::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.36; Mon, 2 Jun 2025 20:32:34 +0000
Received: from DM4PR12MB9070.namprd12.prod.outlook.com
 ([fe80::44d1:2c2f:297a:591b]) by DM4PR12MB9070.namprd12.prod.outlook.com
 ([fe80::44d1:2c2f:297a:591b%4]) with mapi id 15.20.8769.037; Mon, 2 Jun 2025
 20:32:34 +0000
Message-ID: <6532fa2e-53e7-454f-80a6-c88b70182a6e@amd.com>
Date: Mon, 2 Jun 2025 15:32:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Dave Hansen <dave.hansen@intel.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 akpm@linux-foundation.org, paulmck@kernel.org, rostedt@goodmis.org
Cc: x86@kernel.org, thuth@redhat.com, ardb@kernel.org,
 gregkh@linuxfoundation.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
 <f76327dd-b505-4a24-938c-5b917da9aff2@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <f76327dd-b505-4a24-938c-5b917da9aff2@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:610:74::7) To DM4PR12MB9070.namprd12.prod.outlook.com
 (2603:10b6:8:bc::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9070:EE_|CYYPR12MB9014:EE_
X-MS-Office365-Filtering-Correlation-Id: a9056735-dacb-4a86-3633-08dda2149b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVNWNFBYc2R6RGFpY0RPTmo0SFQ0K0NqYlVmaTB1Nnd4OVdjNDgzdW00am41?=
 =?utf-8?B?MEl6SnhZUXpCdHUycGI2aHNIT3JEdGVnclQyUSt0dWxCb0hBcDFUNU0xNG1w?=
 =?utf-8?B?bHBQNUZJSUMzcG54dGtDb2FsaFZZK1JpQ3lMc0l6UU01T2diT2xvMVlZR3ZQ?=
 =?utf-8?B?dUtFeUFhbSs3d05YdjFML3J0S2ltb1lXd2h3R2NjUXRxSk12Y1dCKzhxa2ZZ?=
 =?utf-8?B?eVhqdWJvci9YN25IUTh5OUpDbmlpVUV4SnJOc3VTY3JKdHlNc2xJby9UY3Fq?=
 =?utf-8?B?Ym1qVkgwZzNKempVQ0N1K2RzTnhQcGhDYjBZeXMybTlkZGF6Sk1jR0VGSy9H?=
 =?utf-8?B?UXNBWlp5cVpWUG9tbXpvTldzZ3Q2anNyRXBHSi81KzVlUGpPZzR2TlY0NEhs?=
 =?utf-8?B?ajhwb05Kby9qTlBUUTRVWVAwbHFZSjA4Z0RxN3FPUHBGeCtZVVUxdnlPZk5o?=
 =?utf-8?B?YVNsYXZJTHptQk85M1lpdmRPUThhVmt0S2VBSlhDVitPdTlsMithZVhjYUhw?=
 =?utf-8?B?VEFxZ2RnWWNrMW5FaTluemFQdUlOUXhkS05LMitVWWdRM3JHZUQ4dm1JUnQ2?=
 =?utf-8?B?bnFoZ2MrSEZERDg5NnZqSHZ3VjBycFdZMXN3WjdlUmVDRTVmN2EwMXNCR3dT?=
 =?utf-8?B?bzN0RTN0eldzMTNlVnZPT3kzQTF5WWtENFVrT3J0alNua25reGRUODJ2aWhL?=
 =?utf-8?B?ZXg4YjREYUErbGNOYmFhd2ZWa2hUNW5BSHNTSGZGa1FTSnArVGpYVWNTNlUz?=
 =?utf-8?B?RjlnbWJqRW1IakdRRkQzbXBMWEF6TWZaNnNac0dKcVIxbTlJUmtYNEdUVVoz?=
 =?utf-8?B?anppc0xoZ1dZL1JMS2lZRW8vd0UwSnhMZXdhbUVjTHZKakF6SmhReUF1anBZ?=
 =?utf-8?B?ZTJJS0h5ZGxwL2FiVXpNd2EvZ1Z4R2JXYjdFTk9aY09uME9WQ0hJaWZ5QWNJ?=
 =?utf-8?B?Ukw0MVJJcVNPUHExNXNTQ3dTS3J6QW1PUmRTa3g4RUZjd1FsK2hDdjFmNWRU?=
 =?utf-8?B?VmlndEZ6Q01mT0xOVVRoRGM0VUNlRFNMQk1ITzJkZGRVeG9GeXFKQXQ4T2JN?=
 =?utf-8?B?SjI2SjlHeVBlM2pvRW83OUNnZDRkamdwWThqa01DUGJnSGxqWFJpcEYwWGJJ?=
 =?utf-8?B?ZURqTG5vUkRiTzRzK1RYcWttczFoRlJqM0tsTnpkUmVtZm5wWlVydHNreEVP?=
 =?utf-8?B?WEQ5dE9tM0hSS2dXZE9NOENZV0xGZ3lMYlFzbXRsNmloYVo3WGtPN1UxWHdp?=
 =?utf-8?B?TE5oV3Z4aHpsK1Y1ZEZWQW8xWjZicVkweFJVRlFqOTFwUkxzQ1lsNFl2a0pC?=
 =?utf-8?B?S1F4U0tKUlF1dzBqMTk4aEdtTzQwYVRKRU94M0I2MlhLNXE2eU1CeE5BRkxx?=
 =?utf-8?B?WUZOTCt6NWQzYWVPaFcxRm5VcnRVL0xSK2w0SHlvMHV2clVDeElqakJuOEp4?=
 =?utf-8?B?clYrOUFLR0pJS3FNVGpQbHlxQjA5MXNWS3NRWDQ4K2dXR1RtU200K0JXQUI2?=
 =?utf-8?B?Vi9kdGppaHAvZDdjMjFlZXZ6OGFpbmdXRjVaY1E1RWdiYXFoajZESnordExW?=
 =?utf-8?B?UEppd0lSZnYxU0VxUG9GNnFpcGpNTElTOTBlcno4T0tEVW9UOUt2VzVjSlVZ?=
 =?utf-8?B?OVk5OE0yZXVUbmtyNTFsOVdQM2taNEZzRCtINHJzMFYzK2piL2lNd05PcUlP?=
 =?utf-8?B?U1BkbnBDdFBHTGcrdzZHK3FYKzgrTnJzK240VDI5cXdDUUFQTE04Qm5KQnZB?=
 =?utf-8?B?ejdGTUQ4bWdGS3RlWlNEcXpHaXdKblpGc3RidGkyakRiZTJ4U1hGOXJsbFcw?=
 =?utf-8?B?MUtrWU5FVzZxVWh0S2Qrc2dnNXhlVmpHS3cvU0ZqaUhKUXEyWmRsMzNrRmlu?=
 =?utf-8?B?Ym1QL2JYT0FwanozeUZGNHlwbXZyZHJGWGtENnJOUGljaVNSNW96ckQwN3J5?=
 =?utf-8?B?MnlMTE5OZ3EyWkNibFZCUFdRVnVPK2hyeTI5QzlGS3k5ckxZOWRrS3RHZVly?=
 =?utf-8?B?TWxSTzZnblNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFovSFhNaitGSFpEN0psV1BuYnJNT0VWZHJlRThWd2lFaG9lUUVPL1JIY1BQ?=
 =?utf-8?B?b0Q2VnNEaENmdjFudDc4cDIxdXhIeU9JQkFJaWV4bzkvQlJmelA4bFBWaG53?=
 =?utf-8?B?TVEyb0NHQ2lsZWl4dmJrV1FIYnU2NDdWenFXUkFmL2N3R2lJOFk1em43cVNM?=
 =?utf-8?B?aUQ3akNVSFQ5T2JVT2wwL29UZHpERzkyWEt5Qm1kZ3ZSZUJucktmRHRhbDBL?=
 =?utf-8?B?V1k2TEE4c05iSXB4TlptMVgvMHZYM3hNOWFlV0RKTGRZdlM2bjBsOTdvWVlG?=
 =?utf-8?B?RDNkNDQ0eUFFTmE0azN0K08wMG1RL2pWbHcwWHJBODVsRmIyWXZUcE4rbzZE?=
 =?utf-8?B?MHZobFVNeWE4cXBEdFZQWXk3dEgwVG5EZ2YvMHZjL0lsNURhSXZsQWhjQ1hB?=
 =?utf-8?B?a1FrT1dzK1VGeHBkOWJ6aER2WU9aZDFUYTBwZ2c5eEdGQ1VxRnc2UnJaY29k?=
 =?utf-8?B?RExMUHp1MGVZMEFRaEx6bDFnNnlabDIwb2h4OW5zQjAyVGYxMy9hQnpmNTl4?=
 =?utf-8?B?RE1ZTzhRQzEwdTJ4emRvWi9Vb0dvMzBreGVRb3g0Q2pibThwdm1tS1hyL2cx?=
 =?utf-8?B?ZDI4NTIxV3cwR3dxMlcxcW54dXh4UlJKYVlUQjN2UFFJS3hZWDMvRWczMzFi?=
 =?utf-8?B?RlMyKzFEaGdRT3pxOWxFdmVuTFdXUWIwQkt2N1pCbUhsTVVjUnJBU1Urc2wy?=
 =?utf-8?B?TjNIQnovSlhzbjZkOXZoekV3Wk5MaWJOY1ZwMEYxT1ZOYU1WQjhBZi9kNXlU?=
 =?utf-8?B?ai9Pem05dm53a3FIUHo2cGdTMCtIK0VhSnVYYW50Szh5M2hYVE5yWHBHb0VU?=
 =?utf-8?B?QzJBVXdjN0g2TmxQbGIzQ0ZWa3JZYVBRelpZZ0xIMmtqY3M1dm9UN1F3dnRx?=
 =?utf-8?B?SWN4Q1FXOWRIdFVhOE90UVNMSTFFZ3lPc3dpVkJxUG9jblZtMkhxSjVua2RX?=
 =?utf-8?B?MnoyY3BLdUpGZlpWUnJsUGxrTnVrcEowaGtOZWtTdEpFQ0h1QVhDQk1yV3Uy?=
 =?utf-8?B?QStYN25kdUNESmsvcUwxVVBGdEVUU3EyWnE1OXVFMmF2T0hMRjRTb1M2SWVJ?=
 =?utf-8?B?NTNmVlNBMjBUTHM4ZmwvbXJ2c25yQi8xd1JnNnFHUW5sUGtVOVdUeW9MME4r?=
 =?utf-8?B?WGVhc3RIazRBTDlZMzNBYmdzQXljZUx1REpvK1FpUnBIakM5bFN4SDRWWHhh?=
 =?utf-8?B?OEIycVJzOEhpVnZKSnpibjE5Wi81clFIR281SnNTRWlxd3hHeHlBZElBVW14?=
 =?utf-8?B?TnUxakVYbVdhQ0NIWlJmQi9kcHFwL0k3WUQ5M0wwR0t4a25tTCtXZ2hrSjgv?=
 =?utf-8?B?OXpSNjhHK3NVZitMM2hENUNSVi9jRmp3Wk5XQTdTR3FvWFpkUTl0eThJUFhl?=
 =?utf-8?B?K3IraVhkdngwL3dNSHhLSTdudjRxUVg0c3hCczRBZzlOT1cwTzA2RTlsbnpS?=
 =?utf-8?B?blB2UnlHby9xNUpHTnU0aEgxMUhzT2g5SU14VEhFcis2b1p1ZmdEVllYRkQx?=
 =?utf-8?B?cGhqZC81N3Z6U1ViWmdMaUFlTGMyMDFxcHpGL29URFNFekVuTUxuSlkxU3lX?=
 =?utf-8?B?NDk1OTdSTzhMUlUwM1VzUTl1VTd2N0YxQk5FYzQ1eGFaT1ZiTjVTcDd5MXpI?=
 =?utf-8?B?NXcxZ0dGZ1NPOXBlNk4yK1B0ZEdoWWk4T1JpcGVHOFE0RGxrYlI0aEZKRTh2?=
 =?utf-8?B?UUZxNXc5a2FxcTBQZGl0OFM5OVlwbHlTT0VzMUFTRjZhZVMvaFhuTHh4dXV3?=
 =?utf-8?B?M2lDU3k5NVkydnp2dkM5UnVBanpuQ003RlhQQ0NtVEJaa3NpN09kc2Y0ZnRv?=
 =?utf-8?B?cGg4dGdCQXQ4VkhoL3pMWnhISlpHaTRNSDFWdXJsekVYYXZuZHVNNkh6KzFL?=
 =?utf-8?B?b3M2VjJnZXBzNm1pdjdjREpPY3lFbXRSV0Vkb1VzcEo3QW9BRFdPVTlxbWZP?=
 =?utf-8?B?YmJ1anFwVW44SCtaZkFkcEI5ZkljM1lockpyQ1VQM3lMTmE2VDVCY2g5aEhE?=
 =?utf-8?B?Tm80S3pZeVE3ZlVTV2V4QUJkdzlvaFhVaGJsNEpML3cvWTJyVVRrVElCV3Ur?=
 =?utf-8?B?K3NIMGU1UjBqL0E5QVc0dTBMK2R3em9IOVJHRTdSMEJjbFJzK203VkVMQlRy?=
 =?utf-8?Q?+rSsbQybAe44YZYeFbSjkfBcW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9056735-dacb-4a86-3633-08dda2149b21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:32:34.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wv5Ns00veorSsmYHkgNuWEqK9DbmFkjX/FwiHaZKVfZ8td50X6gGhT3NdYwzxkpDZa0mrmvRpj7xMbm3VIJfeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9014


On 5/23/2025 12:29 PM, Dave Hansen wrote:
> On 5/19/25 17:02, Ashish Kalra wrote:
>> +	kvm-amd.ciphertext_hiding_nr_asids=
>> +			[KVM,AMD] Enables SEV-SNP CipherTextHiding feature and
>> +			controls show many ASIDs are available for SEV-SNP guests.
>> +			The ASID space is basically split into legacy SEV and
>> +			SEV-ES+. CipherTextHiding feature further splits the
>> +			SEV-ES+ ASID space into SEV-ES and SEV-SNP.
>> +			If the value is -1, then it is used as an auto flag
>> +			and splits the ASID space equally between SEV-ES and
>> +			SEV-SNP ASIDs.
> 
> This help text isn't great.
> 
> It doesn't come out and say what the connection between CipherTextHiding
> and SEV-ES+. It's also impossible to choose a good number without
> knowing how large the ASID space is in the first place.
> 
> Why use "-1"? Why not just take "auto" as a parameter?
> 
> It also needs to say what CipherTextHiding is in the first place and be
> more clear about what the tradeoffs are from enabling this.
> 
> 

Sure, i will work on improving the documentation.

Sean, looking forward to your review and feedback on these patch-series, especially the KVM side of patches.

Thanks,
Ashish

