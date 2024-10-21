Return-Path: <kvm+bounces-29295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE75E9A6C55
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 16:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C58361C21A84
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D23C1F9AB0;
	Mon, 21 Oct 2024 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ntSAVlsg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B3F1F5830;
	Mon, 21 Oct 2024 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729521470; cv=fail; b=e4KZjbzn+2LuCSlmuCHrSeRccBklZPHMQ17btZg9j0mj2yAQiStQNyEBJPAHF6cz7cXKyDPqNfa++36wXNaTdLIR67rY3FrOwd+oWnqMHPwymsuSdsdug3pzRrogcqlJkLR+u6+/Ql6Da+3Em6y43AO5i2CU6JJmuYgSBEhWqb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729521470; c=relaxed/simple;
	bh=6iLENsUB1w1mzXu9owUsfUVSfuFp4LnOrds8MuMM+Pc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BR9jtsGDyBARF1J95Kb+/rGzsBIX+fvl/iebQD1jBob88YrZpn6T5c12WQIakObEWFGSslCfeWyehodeed0HbpuLHO9Q5ikkD7jDSsnUoOHdOWDB6EZgX1TBNVoXp8f4j2sKyjAtCRP2A+BHQCDDD3KpnZDGIIKRu5RTIPoNbjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ntSAVlsg; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SIyRGDAUO7mkG3T3PmQ64tfKa/WsG0CLoY0vXc4haoYO7NGtn03+/maHhgG9aP3IpYCbwUixwqWUP96ThBjF33n756I2rkJv3XKik92BP9KJgI0gp37hX4eWToV3bwj6pzn8UShJnPPtqigHUqCW+3mWP9RDMxpTIfgT3VJmEVz/CG/O01m8nQacbJbyiyihgals0y/aCgmz83A7/aRNs9afthH3ucvr2xxgXEj6+aEN/lekxaabCOO5uztORRiWcAh0feVwsfkkF3r6jwMLnMv9s4j+W1uf/rxC0IBrNzJgoCvAyEGl3hRvEMVyU9zbQHley2FuOzeoOPJawJQlKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4UCPcb6FpTr+3BzjMiFbjtfoIqRRw5wwDDDeJpfnJQ=;
 b=XU7WAF7e6yCYMNPeJgXsKSt/TeoGCjC+9sK3ALh/cxF6Az4/iWzBDuvmhA2QPHiiey/rWDjd9Bt0H6ccXJfmRsU6OFUXVJa6iDioGPMn7pUfuruFWX629mhkusmR3VVwKumnoMJ86y5Q4jWO0vQmSKwdZwYoDYmbZGHjhZVoNfoSRdBpgS8JVgUVEEjVZLu0538qmof4ywMAWbidT4QJeKvUNrus561fKYI3MzTzX157f2+q8Y4dJhovn0fzRNP/+ppHhRNcyiFLEaZ36eNNfwWEZwDq9MYaoBUfC0I0USv0ob77jRCRTOmgofkLZPqH64UJC49/i380UWWPSoWP/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4UCPcb6FpTr+3BzjMiFbjtfoIqRRw5wwDDDeJpfnJQ=;
 b=ntSAVlsgEzsGGJtBQrKNUj4jr/sMGD4ge1Iig51Vvp3Y6Ozlnwayjj0g2PyWRuB/XqU5CP/HfGsG1QSTarAixBNeyqKs5tV3yqLBYtBKP5LuIwa9wEDAxQIyRuBEz8qnKOLiw8sCh5lfNs0yD2HCP97C4xK/2haZhG7DYmbZhQE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB9053.namprd12.prod.outlook.com (2603:10b6:930:37::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 14:37:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 14:37:45 +0000
Message-ID: <04684b8a-c8a7-5d4d-de8d-16b389d0c64f@amd.com>
Date: Mon, 21 Oct 2024 09:37:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v13 11/13] tsc: Switch to native sched clock
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-12-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241021055156.2342564-12-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:806:27::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB9053:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c249e84-e994-4d05-d9b9-08dcf1dded8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2V1d2pnc0Z4UXFtY0R6R2lEMUZ1dHdkd0tKem01QnJEKzkweDJIbFVib25v?=
 =?utf-8?B?VVROM05IT0NXOVFSZ3pSeUhMbjVVQWk0dFMxdHpxa1hHY2hSSlF3VEZ2QUZK?=
 =?utf-8?B?TE81Yi9HclRuY3ZEWG5GR294akkxVEh3ZGJGc0dMMGNVTEx3VFBuais4R2x1?=
 =?utf-8?B?eHB2QnovR2dHYlN1L3NLOUgwVjE4dkIveWkvQzRJZ0dQcFRMMzhJMm1xWGx5?=
 =?utf-8?B?UjJpczI4cS9vVkhEM2NGSGY2MmkvaUdjUmRhUHdDQTRkcnJMbWc0WndqUWZJ?=
 =?utf-8?B?Wmp1OS9QTXBjNjloc1ZDVWZ6UnVpamcwN1ZhdzByUGsyNHdwYkcvNXJaVFdk?=
 =?utf-8?B?SGh3aENDcndlVC85cjhKRVpsUlhUbWZBc2gwbXdYWHplRyt6U3NUV2NzS2Nv?=
 =?utf-8?B?ck90WDZMTGc0bThOSDdoZ0pTbTRkdDZlVHNYNnlIVWd4RHoxTUtadTZTRkRk?=
 =?utf-8?B?em90bC9RTU5EUUdtZzVyaHVZSERUTlZMSG1WcnFYWFJyQVloWWMvOHZsRTRW?=
 =?utf-8?B?eHBKYTZOOHoycVlaR085OENVV2FUd1NqWWhMNHBPVHQvL3d4RVFrMTVsVjlo?=
 =?utf-8?B?Zkd0SHBOYmVYazRxSSszd2R6QmJtZC90S0lmL3o1MTJOLzNPRzg0U2RyVzRm?=
 =?utf-8?B?bUxhY3ZISlRSNG9RdE5GSFkzS1BEVkZkd1ErTGlvUTB5UnE2N0dHQnlBMEFs?=
 =?utf-8?B?RTVrY08zQldGaHRQZS9qMTdlN3ljTnpPa1FJUHNqaE5vK29lNXBXWUlWbDU3?=
 =?utf-8?B?MjFHcGd3MzBjQUR4TCtuWS9TR3BqRnZMbTRIckVFNE14c3NNMkYybExNbmFw?=
 =?utf-8?B?Q1pUTzlJZFR1Yy92WElqcnFzTnQxMFp3MTdkL1NIUUNCWHM4ODN6aDlFT2ky?=
 =?utf-8?B?L0hNaHpxZmFVYXVwbDZORlhPRW44d0V2cStkMG9uLzVVQUY4dGpLZFg1WVIr?=
 =?utf-8?B?cDkxbkZSbHEyaGRHRVZvdXBQVzA0c0pSMFJaZmxsVWRhaE10Y1hDYUhLV2hE?=
 =?utf-8?B?WHcveGk1MjR4ODYyWVVGbEdYUHc1aFI3WHIvKzV4RmNXenJCR1B1T1pNaGd6?=
 =?utf-8?B?NUcxWGxzSmo1dmVCNDc5cEM4b3RRTEVwL1o0R29XRHZpU293bHVTcjJsSHBD?=
 =?utf-8?B?bEZVTmhlenpUR0s1V2JSaExUY2hPYzBLbjlKVFlMWXFER3pxZHZ2Tkp1OFpv?=
 =?utf-8?B?NU84MEhhVzMvSWl6OTJBc0N4aEF1ajFjcTcxRm44VVliOXdmc0wzUGc4bkI4?=
 =?utf-8?B?RUFOMEY5SjNwYjljQlBpWkVDZng0VzNYb1ppeFNpTmhOU05vSVpjZFRBeHFZ?=
 =?utf-8?B?MGxDYklYL1JhSFAwMXFqa2d3eFJoNGlRdDZhbGlRUVpqN3d1bWhmcUxzZnVP?=
 =?utf-8?B?NDZoODBFUzRwMnlCb0lWV2xKKzAxSEJHeWZNQUhYZUJwcWZqdUxXQmUzMVA5?=
 =?utf-8?B?ZEpCZXJnOHZwNmtzdUtadGJEclUwTDBCcmQ5REtkcFVlY0dZdTBxS3Z2a1BY?=
 =?utf-8?B?enVOcHQvbmFwYlBPSmtWcGJyenZGQnY3a0NkdWJlc2lOK09PQjA0eUkxRHRT?=
 =?utf-8?B?SnlKYkNiZVpETks2U3RlbWYrcDg3d0xjMzlUdUlXOEdFdVNMWmQveGUxcG14?=
 =?utf-8?B?UWhsZ0VWK3NhejFoZnJJblRaMGtSTWpGaGZabmM1MGJKb3NPcUxVdFJCMTlE?=
 =?utf-8?B?YkFXc2tESjNIdW9GR0NFNjFLVHBpUW9KdlJlek8wdmxzc0dnTXBjN3ZpV001?=
 =?utf-8?Q?45cbTCci61ZnNeKD9XInK1MkGA+b5+qmDkUjxPb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnJKOUk1dVBtZ0lrVEdDbXRhNndZcW51Ymc0SlBCN3I0b1hzVDhLZkVLdUYz?=
 =?utf-8?B?QTExNlpoTnVHNHZzVGREVENTWDI1VGdsOFExK1dQbWxQalFtWFVHM3phYW1h?=
 =?utf-8?B?aWFaRmY0NUhDSkRkZHZYdis4UVhqeDRFU1lYYndlRCtDL254UzAwT0V4cVJu?=
 =?utf-8?B?cGFDTW5yc1ZNcU43UUlsQU4yWjB4b1ZQUGZ5aHV2dDhHenlLdmNscWttZVdO?=
 =?utf-8?B?Q0tTWWN1bTBFSC81UUhGbzhHRldnZjFsZFdXWlE3LzRuMklHNk1FTG9iOEVy?=
 =?utf-8?B?cCsrMGNmNW1qa0NHL0lrSzU5b3pIUFFwOGM1ekdWU1JGc3RiVEVNd3JIUGVE?=
 =?utf-8?B?SkRPU1lCNGJUeE5zUHlYdVNhRXFwSEkyaDZXTVMrcitPTWovTk00K3lMOGR6?=
 =?utf-8?B?MHRMU0kyNFhqL0NQNWNxaktlY2JmaWFyaXhUYm5XZmNRUGlxTlNWQVo4Qyt1?=
 =?utf-8?B?S1M5WXg1dXAwZ3QzV0lyUnhHdVJFczZtQm40V1A5TEEvQVpOclRIeTZvYmRL?=
 =?utf-8?B?bVFlN0o5MEFBY1JTdGdDY0dLa2o1bC80TnY5VGc4UGRSbk9iZ2ZPdDZ1N2xV?=
 =?utf-8?B?WDhKSEh5NWJUUkFTK0lUNm5hanNSdjFSb3NzYTNZSWdxT0JiWXZFSUQvSHFy?=
 =?utf-8?B?U0JzaTZhMWQvRlJiYXVMeWVxcXdlU04xK1gzSmFXMEZ1bDZlMjZ2VWFXdnhu?=
 =?utf-8?B?blh3dVRvcFd5N3l2WE9WUzNuSHZXb3RNM3h0ZW5FbmRlVjUzanRqTUp3Q1Jz?=
 =?utf-8?B?SFFwbWxPTDdRQ1pKVXcvajRmVVdxVE5mTEt4cll4Mm1NUXZxV3Q3emlsd3lN?=
 =?utf-8?B?eDVNNlJ2Zm5BK29rcjNXU0VwSGpnNmduamFkZ240LzE5UklRQ2xqM2RDQnl0?=
 =?utf-8?B?akp1WFRkSk9BT3hVcWEwMStZd2prZFY1T29zNUw4K1FqZzB6L3RQYlhLSEo3?=
 =?utf-8?B?OTRPSVVoanprcGhiMWxFSTJqMGNXNXRWTVo0Q01iV240cHNMMlBMU2NYaVNk?=
 =?utf-8?B?ZUM5ekdRS3BKM3BmdGxxU3ppYVFWaHNtaWltdG8vMEtjT2NTYWk2bVN6UHh5?=
 =?utf-8?B?eFJxdmZTWGRjOERDSk9WQzVTTmNQUXJLYzhjRTdmMFdjUGt0ZkhkMEUvYXAr?=
 =?utf-8?B?cDkraDE0N1o5NWs5cjZ1VEo1RDZ4VFhGZ0I4cW9ESlRZUVd0SjJibWF6M3pK?=
 =?utf-8?B?aDZFWVVlbFlQS1h6d0xqbDloQVo3R1luSzdJY0VkZTc0bmJKM1hzR0t1U1lL?=
 =?utf-8?B?YmRTSGJoSVl6a0tGYTc4UVcwcGYvMXk0VTBOK0YzamI1T0JkYkxoZENFZXE4?=
 =?utf-8?B?K1dYcnZ5S0UzYS9EY1NwNHNEQXNOK0Z5MlFROTh4dHB0ZGZ1U2ZnRnorekYw?=
 =?utf-8?B?cGI1ZDNTUmpqcXVwWWhKN0lsbzNiUVUyUFBXTTFnRnRHWTgva3pXbFN4ZkVp?=
 =?utf-8?B?Y2RJQ0NveWVYSno4VDg3bUFPdGZ4U3BNL1ZqNmFYY2FhV3FuRVN2WHhrM1hy?=
 =?utf-8?B?NlBYVGdweklqQnMzS2ZSWVRhVTZMbGJZaTdpUStldkJHMHNJbXhRTDJmeWdK?=
 =?utf-8?B?VlFRbjE2VG5VWmZCeVE1N2NRQSsyQzNqMW5LanVZTVJTUDdVektPQW8wai9V?=
 =?utf-8?B?Nk91Y1FNWnNpdXEzZlFpMUNtaFNUWUhVSGNpWXZxSXZ3ZklQVmVSM1hWWnFZ?=
 =?utf-8?B?MHo2UnhsV3RtVld0Zi9VQTVMM2lKdzB6Mmg5ZmxnKzM0U0llNlJnM3VlNFJB?=
 =?utf-8?B?MDByWldlYVo2ZEFPam1mQklNMUZsekFIRDRWbWltY2k4YkoyVDRMcVVud0h3?=
 =?utf-8?B?ZFVubUw1cWhoRWkyc1Bva2szdXU3aGtPUURva1ZjM2lkVm5tTjErSlllazlI?=
 =?utf-8?B?MldVMS84UFNkbTJXb24rTy90bkNOekdWUlhsZkg5REZTdkpCbEpHcktOVngz?=
 =?utf-8?B?R1JBRUh3ZFNBTmRBcE5tNWhia0tmSEJQcWE0VzJCR1ExSm1VSmVBNFd4aFRS?=
 =?utf-8?B?WTZiSExWRURJLzJIZ1ZLRUNLUlcyMGxLejVidFRQUEMwSmNCT2U1NjJlUW1r?=
 =?utf-8?B?MnRSdUFaTk9KU0pzMVZseldOWlB1bEVQaktTSVg2eGdGRWJ2UWxDVzdtM0Vw?=
 =?utf-8?Q?hoap1jok2ZZnMlzbF7pV3lVX7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c249e84-e994-4d05-d9b9-08dcf1dded8e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 14:37:45.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9MhLex9vpZ/Vjd0JTdPD5AjN8dIuGpGUvlM9LzdM3ucaT66sT6Lz0OwdFhpA8Gf1o+xDESRFyeR9RTz3YM6fOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9053

On 10/21/24 00:51, Nikunj A Dadhania wrote:
> Although the kernel switches over to stable TSC clocksource instead of PV
> clocksource, the scheduler still keeps on using PV clocks as the sched
> clock source. This is because the following KVM, Xen and VMWare, switches

s/the following//
s/switches/switch/

> the paravirt sched clock handler in their init routines. The HyperV is the

s/The HyperV/HyperV/

> only PV clock source that checks if the platform provides invariant TSC and

s/provides invariant/provides an invariant/

Thanks,
Tom

> does not switch to PV sched clock.
> 
> When switching back to stable TSC, restore the scheduler clock to
> native_sched_clock().
> 
> As the clock selection happens in the stop machine context, schedule
> delayed work to update the static_call()
> 
> Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kernel/tsc.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 27faf121fb78..38e35cac6c42 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -272,10 +272,25 @@ bool using_native_sched_clock(void)
>  {
>  	return static_call_query(pv_sched_clock) == native_sched_clock;
>  }
> +
> +static void enable_native_sc_work(struct work_struct *work)
> +{
> +	pr_info("using native sched clock\n");
> +	paravirt_set_sched_clock(native_sched_clock);
> +}
> +static DECLARE_DELAYED_WORK(enable_native_sc, enable_native_sc_work);
> +
> +static void enable_native_sched_clock(void)
> +{
> +	if (!using_native_sched_clock())
> +		schedule_delayed_work(&enable_native_sc, 0);
> +}
>  #else
>  u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
>  
>  bool using_native_sched_clock(void) { return true; }
> +
> +void enable_native_sched_clock(void) { }
>  #endif
>  
>  notrace u64 sched_clock(void)
> @@ -1157,6 +1172,10 @@ static void tsc_cs_tick_stable(struct clocksource *cs)
>  static int tsc_cs_enable(struct clocksource *cs)
>  {
>  	vclocks_set_used(VDSO_CLOCKMODE_TSC);
> +
> +	/* Restore native_sched_clock() when switching to TSC */
> +	enable_native_sched_clock();
> +
>  	return 0;
>  }
>  

