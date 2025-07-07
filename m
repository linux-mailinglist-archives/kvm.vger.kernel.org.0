Return-Path: <kvm+bounces-51684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7494FAFB952
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 18:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5ECB3BCCE7
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 16:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40E3289807;
	Mon,  7 Jul 2025 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EFNtIQhT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A36E2951D2;
	Mon,  7 Jul 2025 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907454; cv=fail; b=oaJA/HFnhW3jtDsdHwRCvorYeBFCSbz4MWY5+mvc7NMlFhQxrI/FqewPEYwPoJR1nB2WcvXG6vCaifj21zR8hWT9NtlUr75wZ8YixxjnGuMtAb5eAtN2iDkGZ3CcLjPGQnns34wnADXn3VYlZ6QTr/kfRY1szIVKOm+kPRSfR/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907454; c=relaxed/simple;
	bh=aaK99ssmkWfWjCKkQcPYAwEuDonI9IUBN4lzpF+l/qA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CPtp+olttiCwtIXwtdwY8V8Ta00hNGJ81HSKGMLBXM4rC79ScG9PfUdksmvujZZ2GcUPCsCS8RHc6LOGc5b58PLh94WG88OBB1ipdenQG5ysy5y6kHuTK95jAVTgt2f+ho13PaOv6gvxXVDztxxosPe4Pd0dh6vY0tWFLoSpQhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EFNtIQhT; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xtkq6HtaPxcuj1/jUpVrTfOwu+JSDg0FMJuj06k/qjeiU2oX0Sb8Vu82AZTEIXytm/Riuu14cmvCvpEg1VbbLCkJQcot5o9Syr7sL91KThZRkV9dh0RXJc8ozdqR26psZaYbIVx6jj2msJGmTxc4tRKo/ygrpvHOlzhONiZfsKwPASDbFg/ylxSPz5PuEPNhP2sB9qDfR0hschyn21zTMPM7qzcsZTh6IeG/It3gJlKNDi9FMOs+iGRxoByYyC4Oz7RGJZuzYHrMFrjTzaEACN+HeiKBmpal31cPWyOSljVlU4foHiGj5Tap7MQxNmh5MwpA1CHm2+64kLPaRo9+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB/52zcmXj/okMQP4ln5UtWi2WwFH4h1PsKB+ofkTow=;
 b=PSuXerizKRpyMsDnBQzH3iWTKcBMCRxLPH0egS3zS/hebMLBJc8k9iaqz3mB3eve1kZYokSrqHKq9EsBzUT7xJgoDN4FMKp5Sk+SiWoe6+oTThsn9VvvOLAHhaMAQ/pctcZKSHhZcZLJj8O4xOodrV+XLqEH8pq56EMTVeCEJo3FM7SpFhXAfUFH8Psj/4bs5DIZSJ5e2BZUmouemZii30mDGW8DkWdzDxI/GuxRopz50Sf2qB/FC4LaWa9cnGFy2ZbSnsJpAzgcMQawijz4ol22qNp/zkEEd0jgVWsJPjQkE4vqwXQqZsx39Ehoafw6yQUnb+xeW2ONWCsrbIelkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB/52zcmXj/okMQP4ln5UtWi2WwFH4h1PsKB+ofkTow=;
 b=EFNtIQhTzZvtW4iwy00fRLU3LP/O3MJsKszAWshzUY1Jk6J2IjRYfr/MpdHnQ/2YuOfkR+zK4eGLr6LSL04tVlFZXmQfXXH7IqrCn5nOtryjrHEXOvm8rxOX67BcGv0r8jm7eV2hg4RP8/ri/QXZ8DpVUnrNW98NvKVkn1UvKhQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7330.namprd12.prod.outlook.com (2603:10b6:510:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Mon, 7 Jul
 2025 16:57:27 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 16:57:27 +0000
Message-ID: <04146e76-5411-a9c7-ef29-cb71e71ac71b@amd.com>
Date: Mon, 7 Jul 2025 11:57:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 6/7] KVM: SEV: Introduce new min,max sev_es and sev_snp
 asid variables
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <d950b7bf35c3b5492f5f2d9c4c50a70efeac856b.1751397223.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <d950b7bf35c3b5492f5f2d9c4c50a70efeac856b.1751397223.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:806:121::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: a530065c-466e-4cd3-0633-08ddbd775a3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTZrbXRUOVVEQzVlRnJWVFBXTXNkTjVCSVRuVWdGOTBWZ1FwNnY1U01PRFhH?=
 =?utf-8?B?WnVKVjBqWTRIZkNrTzg1YWlUcytFc2ZrcCtUczhiQitSQ1FGcXpaaVJrZlY1?=
 =?utf-8?B?TVlyVkhTK0hEK3F1aEpTbXh2SHVVMk9laWlGdXZuSTR0RGxFdHZtQlkvcjBq?=
 =?utf-8?B?TlNXZ2YyZXpEQkVKSzlta3Vid09rR0pmQ0NicGZpWXhIK2hEQmFsdlJHbWd1?=
 =?utf-8?B?TUdra2NYM25UVGVyZ3BwOFRZbmRKd0ZQN05GYlRMdi85NlBUMTJVRDBZdmJY?=
 =?utf-8?B?ajdmRUdpOFR2SHVMNzdsRllpSkx3SFBLdXlhWTRmQTNFQTVuNEdXU1c2ZmNE?=
 =?utf-8?B?NVVieVQyd3cybHUxdmtZcGhNZDVBUHVKemkzWEhFTU0rUjFEaU9MbjdYSm04?=
 =?utf-8?B?cVhRbUh2TDhQTzU5SCtRRE1RQktMRzRzVU5YN1hES3BHaEdDdmUrb0w1Wmdi?=
 =?utf-8?B?Y1JlK0JNeTJiY1JRMkdRaXNMTE13dXkyeGk3OENvZTBjVzVXQ1QwQ0ovc0Fm?=
 =?utf-8?B?Z0w5c280QmxudC9tMXFXMHJvbHRiQUo0L1B4am15R2llSENWWHNxVDZYMGZq?=
 =?utf-8?B?TVkyUyt1VEF4ckxPUGJUVktXTldiY3hZRFlBbW1sWnhaL0hkMlZLSjRCbk1t?=
 =?utf-8?B?VjlwWmZtTXFDV0RDalExejMrK1A2ZmM5L1V5RUptdkNCQk8raG9SdnBFYllH?=
 =?utf-8?B?cW1nWmxJOXNNVXk5bmNoamFDcXJaejBKenUzWmxMR3hwckJLTmgyNEliTWJD?=
 =?utf-8?B?QUt3MkRjOUo1c0x2OHgxMnI5VDc2Mmc1WnNmaGxZZnBsRUVFVjlacjVqZmM3?=
 =?utf-8?B?ajd1R1RpN25pajByOS9Xdm1URDVvSlRjOFZwRWRodnJyZ3RucHZIbjAxUnJv?=
 =?utf-8?B?MXlOL1JybWhkbnk2REp6blhMZGdKc3QyZTg4eWpHMjI0WnRXZU1xeUJMaVJN?=
 =?utf-8?B?RXlRVEpKSjdDL1R2NldGVGFrOWxLemNUVDBJeWlJYjg5WW5adDV5NWFhd202?=
 =?utf-8?B?RzZxYXV4T2JzSE1GUGRlbFdRMTlyaFNtdXhaUjRTem5WZzQ3M2FmRmMySEsx?=
 =?utf-8?B?K2lUbzQzb0l0L3k3WjBlVlIyRDlYL0hnMzNZZTdwZkRyWXFlTStqbEl2NDlo?=
 =?utf-8?B?TFRaQmwvY2ViL0ZUTHVJWG5QZGdZOUhkanF0KzlFQStJOVUxbzFFOHNNNTBZ?=
 =?utf-8?B?NWJXY05FQmd1WGQrQ2VUejhXQUJXbVRodHI5eTlqb3IzaHc3NnF1WFBSMFlG?=
 =?utf-8?B?TURldENMRHhTQTFraWw1VkR2NWNKZE5JZVJROUNPTmpJam9YajgvdTVlVlV4?=
 =?utf-8?B?TENQQ0pnWXlhSVJjNTM5THptdXJ3SXJWQ0d4YjlYVHJtQk5nQTVuZDUyWDJU?=
 =?utf-8?B?NFdnZDN4eGVCVEx1cThnUDFJT3IxakFiQkcyUStrTithcHdLRnI0ZUNzYVpq?=
 =?utf-8?B?dSs2aEk4bEEwNUFuS0IwZHczU2FTQVNLNHNBc1hOTFpGNy9jQmxHYjB5RWk5?=
 =?utf-8?B?c1Q5S3hvMGZNR3VJanZ0eHl1dTkxcytFUFA0NTBaZ0hKeFFPZkh6d2RaK2xm?=
 =?utf-8?B?eG9tUG9CcG5aeGd0NkgvMHhtQjZ3TU5xL242WmNrbkYvZk14azNGREZmbW04?=
 =?utf-8?B?NWFrd2I0UU9Pa1B3cWZIcHM5SGxneHMybFRIdWtVZm9VS2RUQ1p0VUFRRnNZ?=
 =?utf-8?B?RFMzZkcxWU1aNitoWVdBQkpiOUFyVXBTVDlQSjRGT1dkeE55aG9lMU43VXJZ?=
 =?utf-8?B?Rk41aWUzTkxYdmJQQjhqWERyZ3FVRkJWS1NxeWQ4UmE5eGl3Q3U5MkxiNmpn?=
 =?utf-8?B?QlVsTWRTdnJaeEVyaDhIdXhySmFaMmZUTFB4V3ZPNVMzTXBjVXI5TGVvaFhM?=
 =?utf-8?B?ZHNQSEpPT2NwaUJxRmp2MGk4NUpVUW80Qzg5QkU5MnJjcnJSVUdxaVdpZ2lp?=
 =?utf-8?B?dkdQOFk3YUc1N1ltcituQ2VxQ1pnd2lGaUhRY3Q5SDRxVzZRdW9sbnV4RmFY?=
 =?utf-8?B?anM5U1VzNjFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0pWU2JCTGk2QWJEZlZrZXV5SWZSSmd1RHVpdWgxMisvMjh0aDFiSG5XNys1?=
 =?utf-8?B?cHRjdjU1M28vNXh1UU9IZk9FNFlTd1ZEdkZuZXJBQjVMODZtTmtGV0Vpc2wy?=
 =?utf-8?B?Titwa28zR3VGMWlDZ3kvTGp6ZHNNeDU3Yys2R29HT2FCUmZOcVd1ZWVIWm81?=
 =?utf-8?B?K1Fmb1dsd0hzWmlQSjV0QnNNR1JXckkyZVlMR3dFUU5JOTNHRk14SXQxd0Vm?=
 =?utf-8?B?bkRhL2JuRlAzd2trZ2Rrd2FTYlZxU0F2d2xaaGc1R29xUTRpdUJtSWNKT0Jl?=
 =?utf-8?B?cU5RNndiUjQrWWJwc0FOSGhXQXE2TmZlMzg4d0hMcUZQVFhIRnNUNU55Ulls?=
 =?utf-8?B?WVFzN0UzNHZKRVhTSGJpMklCVWRiYWNudGV5dzlJWHJ1RUxBOXlmb3JYdE91?=
 =?utf-8?B?WnpNLy8xVVVCTkdlRmF1Z2pXUmJQSU1LcGZna3JwTjZDUFJ1bWZmTmd6VkZu?=
 =?utf-8?B?ak9kTUJ1blEvR3U3UU1RMktWc3Z5WnFKS2ptRDl6QW9wbklCSjJrQUhHUEJx?=
 =?utf-8?B?K2o3WjBPUWlqNU02WXJMOGdMKzkzak80UUFpNmlacUhoQlpOQ2RIVWhHamxJ?=
 =?utf-8?B?dGZIeFNiUElRV0JYbHRQcEljRW1ScEhuUWpDbE1NMU1JNTF0M3g1TWJudlNV?=
 =?utf-8?B?cHFmOEJOSVg2RUpwdFRMVHRDSGRoMUpDRTY2bHRwOWFYMDU0SVVTbUZkYk0y?=
 =?utf-8?B?NVMyd1ErZ0ZOd2lCYW9NZlJHek5ubzU2ZzJlUFdqOEZtVU43OU4vQUFuVkZE?=
 =?utf-8?B?ZUtKdVdwZlc5bkhBNnJETk5ibENSOGx5djkyMklFSmpJdkF6cFFIZlc3Yndz?=
 =?utf-8?B?cHlpeFFmaHAxbHZvc3RSNDJMRWJ5dEJxSmkzekhQRmJEVzFjdG5sMFlKZ0M3?=
 =?utf-8?B?WkpkcXhwMkE3T09Bcmd4czZBSjZVUEZOemdsWWdnOWg5UlFsYmxLWjFuZkRm?=
 =?utf-8?B?aFNicTdZVmQzZXdHQitDellNcDdTSHFQTTcrVUhibTF4QVNhb1VieWNnTElx?=
 =?utf-8?B?eENWU1pWOGdwMXJCYlQ1aFMrZi9ORnJ1Tm1KUm1xa1oxd0dXbTRqRHFHOU1D?=
 =?utf-8?B?Vm13VThiZklSckpWZGc2a2EvTE1VdUE5blJUMmxVVmFmN2p3R0pDbWppM2Fa?=
 =?utf-8?B?Rk9JSmVsbk9GbUlqVURqYUw0TDFsSkJNdzA4U3FHVk9sT3NvdjZEVDNvamNi?=
 =?utf-8?B?by94UlpIS0FoQngwSTd6VWs2SVcveU5aMUNkZnN0a05pMVNRSDQ3MHpRUDlH?=
 =?utf-8?B?cHUzdmFLeHBEaFFSYjN6ak4rZFA2K1haUFRyVDZWOTVJUzNzY3oxY3VWbHVh?=
 =?utf-8?B?UXVWTi9sNStkREZtdU9HTjViNjhGOCs3dE13Y2RQckFBVXNycHhNbTVJKzhw?=
 =?utf-8?B?OGppTVR2KzZ1U1Q4WXlYWGo5Vkg2Y0EwQ2t6M0YwWmhuN1doMHE2NnVHRkJJ?=
 =?utf-8?B?VnFyVVFPWjBUamxUNW82TFdHVHA5V1A2c3ZpZnBmNDlLajlZRVE2WHNZNjRy?=
 =?utf-8?B?anBGamZTWDRtZkh4dXVyVmQ4cmZnZ0hHd1owVGZlRGdLQmphZjd1dzJsUjkx?=
 =?utf-8?B?S3IvT3Rqb2M0cDk0Y2NUN2c2Q3pNVEpTTTlBdm9pMnozUmJ0L25YbWlzUGtD?=
 =?utf-8?B?QTZnaHlTYllYNTFSQmMzSzBWK2JvMXpGdE1Wd0VuSHhnQVRnUmJoc0M4d0xT?=
 =?utf-8?B?RjBVbGFPOGJqNWplVVpWeGlUbFFseXY4bzNXck5FUFRYWGprdzFmOXZZTjdH?=
 =?utf-8?B?VTNuMXFxb01OMzFFaXBuQW55UUNNTW5QK1J5VTVGUGxUNGRGR3VhVFJBdEts?=
 =?utf-8?B?WGd2M292cGVpbUlIdFdUOTE0WVVaUHJKcEpMNnFPSWlsS3lrR0J2QjZOT2d6?=
 =?utf-8?B?MGJrRzRHdGt3cnpLR3RsR2M4WEFya2NhSXpwdktWUG04aDNhTE9CZ1ROZSs3?=
 =?utf-8?B?bnRFTGVabEROQ2lqTXc1Zm9kSUtBSlM1QmplT3hWc1V3RldmT2FBcnJIZ1ZR?=
 =?utf-8?B?MXpNYVkyaUp3T05DTnBZUnp4cnVJKzdWdzJwOXE3VmMxSENYN093bW85NFd0?=
 =?utf-8?B?eXRESWVOQWx1UnlQWDJBdURpcUFiUU1iSDFoMnl2bEYrMFgremQva3hqT2dL?=
 =?utf-8?Q?c5Zguke0RbLnwcIey1EnUKWkb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a530065c-466e-4cd3-0633-08ddbd775a3f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 16:57:27.1093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T25GS9ZVu17aokGV1p7GioLZF3jAfdQsXxEGlJrUdutLYTTnVkjH1bu0bdhluAGgOXvS2hNcWGWy58SEMRpPHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7330

On 7/1/25 15:16, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Introduce new min, max sev_es_asid and sev_snp_asid variables.
> 
> The new {min,max}_{sev_es,snp}_asid variables along with existing
> {min,max}_sev_asid variable simplifies partitioning of the
> SEV and SEV-ES+ ASID space.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 9 deletions(-)
> 

