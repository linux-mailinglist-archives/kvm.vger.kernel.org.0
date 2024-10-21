Return-Path: <kvm+bounces-29294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4B69A6C2A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 16:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EE35B2335A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760151F9A8C;
	Mon, 21 Oct 2024 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kZzF6FtM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D041E8851;
	Mon, 21 Oct 2024 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729521189; cv=fail; b=swncGhNZmfEc4zXoTFTSjffvry09vbrwvQxWKCwZE4fAatV2G8zjf54hBDFDns6WNmytuUw3VOBYBr15HhfCuJZgOSvndihye8YkZL52Pbmkk2mTi3Y7pF+oIbRElaZQZ4LvFej4wJRZcJTUepPs4zTwPJiN2dwPBU3kS0IGBdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729521189; c=relaxed/simple;
	bh=lOH58l9bEzxZAAJzuKIqFbMDGEvK9I9N0MD9LGvtfdY=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=V+qcsCm+ssZG5sOrzpA1OiurProhwxl8IYN5pi4WEjfVirGRwzH6+duCE4rs8yApekZt/pAjvyBCXvce7njYaWxRFnQm4f5W++Vbei67Ynga5ML9XQ7Ix1BwUWSJ8VvRHRh2LwjFuLqiz0OpivJAS4fb+CAavCbKVZr4TKW2xmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kZzF6FtM; arc=fail smtp.client-ip=40.107.96.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRlGvRZys0DEWNe5vhwaaJPDb0W0C3P3Ci0sWZvK96CU3MOqvmexZLUD4xcxuIVoUn/9Mst3tlubbQb3jl2JDVh/AcVnVekFapOdef/cNndrLXvVnZ4l4ahVH7rqXoRnRuIvxZR+J5QcAStro36T6lc9pEbjJo/MW7H2Ru3a8m90pdmzIVuCmPf5a2UaC6rPcE6p6EOUUodLDSvSR1JKZ8EGCKVY51vra7b5RbDkZXIXr4LgXWy42nnvVpbMboLjsetAtrcfpok6LHKYhY7hc+5VqU3aITHnw397kBnU9BUvLCRNY0bJ9gVa0HhzaQ04oyey9qis1Bo/Zp1d0ZyZvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9pPa5ijMRT5lphkxXKIzNwaMOmlkLXEm/XhG4plAAc=;
 b=TDyhXfJuc1NG1XhA8uU0K6PV5DXSlD/3tWkCzKo3GjqN2wqGKJR/5qGoS+/GY7DYgkYR3xJCYrrnLVu8pElq7RgiuuUcDvd68vNuImchVzWqGP06rQXdVPvpOTKwH8JLVUoBFbpngjiBFpjGnJG/bB0fcfCpTF2ROkI3NpRiZBgdlahTJgIKarSqvezcYHT7vtE8lCWX9TZJfgZjd2Yms35MycaDdVrlFFLxQnUs4aqY9XGvzjsLwubrWv8ghD83gRkc1PlwJgiEollZWc0ki1j2VLH8OV+2373pKzFREJD8bcYziFgu0/BTDt+2JQP4IofCRVLcZLpF8mS0RSFUCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9pPa5ijMRT5lphkxXKIzNwaMOmlkLXEm/XhG4plAAc=;
 b=kZzF6FtMU+BSwrQ9iya51tBkFJwS0FpAhJElL6/KA1T327Ay9O9RdRRMu8X+A4pZ2QcmD6H8/OmgV3ekUqdXRyMnZ+rIp/o5p7a7wXSumclmKwZdTIM/fVE16dVPvXhhcxlUv3ujTr1/LwvLUqStGgyDRtZpnlaOD+cTVybTr5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7315.namprd12.prod.outlook.com (2603:10b6:930:51::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 14:33:04 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 14:33:04 +0000
Message-ID: <4c58d1f7-1493-ea32-c598-29edaa62f5c0@amd.com>
Date: Mon, 21 Oct 2024 09:33:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-10-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v13 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
In-Reply-To: <20241021055156.2342564-10-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:806:d3::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: 5579cb45-6e04-44c4-3b88-08dcf1dd45f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ckNEWXBqbE53ODZMa1JpaGlNclZBaEI4QVJIV0xkSFFQWUxHUzN4eGx4ZVNs?=
 =?utf-8?B?eUJJOTJzQllTemIwMlg1d3NTOTdsR3RDcFV2a1QzOXhxWm9EZ1A1cUNmbDl5?=
 =?utf-8?B?emVZRTBvNUt3SEduSDgvY0hSN1JHMVRwbjlCTlpFUWNRQndIMzFqNUlRWkdN?=
 =?utf-8?B?RTlhbG9vdTZ0MjZRSVIrUkpUY1daL2tQTXlFNXJYRlRSRkw2a0NMNUhIVzhq?=
 =?utf-8?B?RWZkU2R3V2UrVk9NaXhPQ3V0V3IybTgwR1RQU2E2NFJ4V1N4ZDhiRWdCTVl0?=
 =?utf-8?B?dlVhRFRJSkpKSTJCZ1NwU1BDQ3g2TFhnNWV0OXppaUdPSDRIUHdnL0hiZ1Uv?=
 =?utf-8?B?OTNyT20ySjBjNlFQOHlqdzUyeElPMzZPNHZKNloyWlVodFFuQWhaU3AzaVJK?=
 =?utf-8?B?QzE2SW43N3UrVTJSZHdHTnJGRkx1NTF0ckdhQUNlSktvaHhjM1o0cDhvWHM0?=
 =?utf-8?B?OFc4TkNqeVBRWDZRNEpGdUVhR2tLa0ViQWQ4aWRuMERoQktmOURDTVZZRDcz?=
 =?utf-8?B?ZUhkQzAwOTM4dWFDdnRUc1VZL01yMHhZQmlVN0I3cnF0TkVOSkRWUVdmSEgx?=
 =?utf-8?B?WDB1QnN1ZmJRSGNYRSt5MzdFajdzTk82RUt6cEVrRjJqOG9IVDBnbklqL2dl?=
 =?utf-8?B?dEw4ekE0OXdtZUtPVVgxWXA4Q0FWa1M0VXAvTlpvZzh0NVNOampaSHkzYUp6?=
 =?utf-8?B?Qm9VTW1yUmRpRiswUXpwazJYRUErOXorL2pEOEwvV2xpWmhuZ0lGT0drS2dW?=
 =?utf-8?B?OC9PUUN1TVhTblpEcWgyVFVSdWJ4WVk4dElraHA4VEI1blNiYlpxSTdMVjlC?=
 =?utf-8?B?NFhRUzBPbnBkYmZpWGl5WEYreDNSeFVXZFBvcXdlUWVTY1dCUWVEWUk0YWd0?=
 =?utf-8?B?R0FleXRXbEhqVkE4RkxoOFM0bVYzdEZockdnbVR5TVJya2FodDRHZmw0QkdM?=
 =?utf-8?B?WDB0SHU1VGJqS0Uzd0FuczlzWFN5R0tFQUFFR0c5aE44L3RPRW44S0ZIZmx2?=
 =?utf-8?B?S0FXM2dFNU1idXM4Zk9hL1BON1ZLN3lmUDZQaFZtbHlHd0l1aUtXamtZZlBr?=
 =?utf-8?B?N1BhUVlEOTcrUjgzbG56TWtQMWZ5M2JiR1ZJTnBOTHNQZVVvSjZkbWZSSjhp?=
 =?utf-8?B?R3p4eU1ZSnZRYURxMXdYZkR1SGhwejRKd0E4QW43cFdaUzZCeURrU3NpajN0?=
 =?utf-8?B?M0dGbThVYmYwSVZZOWtlaEtucTRNNzRjTTRyL1lscFFscUpzSHBSUWZPTzc4?=
 =?utf-8?B?czdCK0haM1JPTjVVblhMQTlGc2hHZHRYbUoyS3FOZ3M5QjYrcmNsOGtPZ1py?=
 =?utf-8?B?aHNRSGR1b1NRS21SSmhyZzdxeDl6QTZFWUJQZS9CaG5wOGhRT1FJZkpQSUI0?=
 =?utf-8?B?V0IwOVVKUVNHWmd1RXJNUEF0V2pIQlUwVy96amVNYlhpM1FEMmZBNEN1WStL?=
 =?utf-8?B?emEwSmNiZlMrQ09kc0hvWUgrSEdlTCtyL21GMERSZFNlNi9mWWEyV1pVMmtU?=
 =?utf-8?B?MjZ3UmwrQXQzL0FzS0xFckQxckRjdUI4Q3d0NU5RSEFScVZuL0VheEZEOHdO?=
 =?utf-8?B?MHRRRVprd2pzeVc3K3VqeGhWelFVNnFvLzJtUjdEdjYybWhBZUJCWnlick5X?=
 =?utf-8?B?M2hkbDlMRTZkT1EvejBoRGhkc2dDRmh1dy9MQXM2RlJjTWdTUHpPZXNHeldx?=
 =?utf-8?B?Q1dtS0xIcHNCTGVVb1o5SjlTV3kyT1EvWEFoZ2VHTUJsOXJIWllTZEVVdXVs?=
 =?utf-8?Q?k15zBZo2P91H2sUtlz6PqUXIzMv2npfe60VZgsT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFhreUZuVnMrTzk0OUdGMllFKzZWZC81ZE8xZkwwOEtoTjRFZW9TRjkxa3c0?=
 =?utf-8?B?Z1diRFpFcjhuWUpNMGFqZmdobnRhU2EzazNJRHlkSkpPdE00YW9HSDJHRFRK?=
 =?utf-8?B?ZStWU1lOT0ppNW1GdzlhenRNbkNDODBGRXp2YzBFSG96eVVqQ2ZVNHhxdkg2?=
 =?utf-8?B?L3JLVDN6ZjJxY1JKYS9IR0hRempxWmRmQm53V3pYeGU0NDFSb25rQ3FCUnNl?=
 =?utf-8?B?clAvOVpPWEtDcEVDN3JVVUtRTXlCMFBYWHJ5NUhhc3YvcStYZmt0c0NmRTE1?=
 =?utf-8?B?SnFpdk80ZjVJL3lFNmZCN2dvYWJYdlhzZi9GdGNKY2pOZmtJYnRvRlZZYXBk?=
 =?utf-8?B?OFNMZzRwN2ZyRDBoYStxMlh1L3JLNlVSMCtxM1BxNFZOdG5CQVg1eFRHb0o1?=
 =?utf-8?B?WU0raGRBRG11M3VnckZvVGFIMFFpcDkwaUs2clRTcUpWdXU0LzAvVS9IUldx?=
 =?utf-8?B?aXliUURjOXJhOWpGZlR3ZmExQUFTZlFzelI0Vjg4QUt2bFJuRWNONkFPWkRG?=
 =?utf-8?B?Vmk5eHhzZExGSHlXZmZGQnVzVkdPdnZzZ1FkZEVUVHBJZXhoMXloRWxNQUpF?=
 =?utf-8?B?TU9aR1pGYlhIVjZCYVJ3Qlh1T3Q0Y0F6SlpZSHl4cnRPaHFwa3Aya0hhWFlF?=
 =?utf-8?B?TFl6NStqbGNSNUlsU0hncFRxbUgvT2cwbXhWTkV1c3Jzci96UTViQTFtREhB?=
 =?utf-8?B?TksrMUhzQUhVM3hKRjF5RGp5c3VWUExaRlBMby9TT3NSZG1FSzRtQ2haOGt0?=
 =?utf-8?B?TURmdzJnYWJVQlB6Q1FBUzBFMzVxV3ZsbnpmdnA4bG9TZlI5MGpON0pBOFBq?=
 =?utf-8?B?aWZSekxmUG9vUDVxZFIwdTV1UDJVdnd3QVB5Wm1iSDZsMzBXQmExZS9LVDQ4?=
 =?utf-8?B?NjcrYmIyTjhhZUVGS0VPa2h6aGttbVhQTHFzVWoxeTlWZjcrU1RCVHAxY2tB?=
 =?utf-8?B?d0cyWlRITDdjSTBhSkdkOS9TZmI1S1VCNGVFbWx0eG9kbUhLS1ROK0FqZ0oz?=
 =?utf-8?B?R1psNm8wcEVPQm1qUkMxZXo3RzF5aTJBSzBFcDUwNUJjbzRZMStETWp0K1Rs?=
 =?utf-8?B?b08xYytncmw0bG94dER0T1hRUEZXRnNnQk5ZUkJwVFJncVdxY0ZJQjg4dmda?=
 =?utf-8?B?L3ZUbXVQTmdrTWNHeEg3V0d1TmN3MzNmTStwS004WW1KMzhuL1pBRmpjN21K?=
 =?utf-8?B?ZTBES2dCMGFueGpJVTcrVzdJdHorMEdBMzFVUlBNQmNOTWUwZEFWdnBhNXJZ?=
 =?utf-8?B?alE4YXBGOUI1bFpCdVNvajVRaEFEWkQrWENZdUVzdGNMOEZ1ZWExZE9qUHZO?=
 =?utf-8?B?T1NqVFdOZE9zUjBSZlNIK2Frd2pBYjYzNFBnTzZLY0Rpd1BxeVZNSWRITXFG?=
 =?utf-8?B?bVNDTE1iNDRzV3NnMGx4OUtFbHFqUkJSZWIvYi9aSkl5WFFpN1EvRmM0VjhZ?=
 =?utf-8?B?R2RXVGJzbmcxbnNpNWVsRmNTM1B0VTA2dEtJZ0paOUVUM1g1Z3E2UnBXaEk3?=
 =?utf-8?B?bzdwS3RpS1FaSVJBRExuejJuOGh0NzFUcjZ4YU1rM242by9rdm0rbDJBMmly?=
 =?utf-8?B?SGVCaEJDbk1kT28ySVA3OGdiOFNaOU02NjBGNDhNNHcyN3R5V29jOXpCK0VJ?=
 =?utf-8?B?VWJOdXdDZUcrQ01RbVdaY2R6S29hOFZZZmFaeGdyczFxLzhjV3MydWlCQU95?=
 =?utf-8?B?VHQ2b09rRkpIdCtTOGN2NTJRM0sveUdjaVhGeEl0RFVUSXRqbzd2REIxU2Jl?=
 =?utf-8?B?NGx2MEMrZENuMUVJa3J2MTU0anhJV3o2WTJ6Q1pEbFduYUZjN1pvNWordWdO?=
 =?utf-8?B?OHY2T0tYMHB0YnQ4aFpjODZtMkdxa2ZkdXlERmxWM0R5MG1JaitMS1lrc0hI?=
 =?utf-8?B?N0pEQ3V1Y1JROGJqbE0xcnhRZTZiUWhjS0tJNTVsTFBiUEZhQjBNSjRqcXh0?=
 =?utf-8?B?K05wUVRmM3lNYzVkNkpMZUtRVWd0Z1l2c0d3NEZoRjgrNjV4VTBkalRmaS9J?=
 =?utf-8?B?dzEvVXB0NkVLdWlhdlIyRHlYQnZROU16d0FFL2JCZmdSUUVLLzJkbjBjckR4?=
 =?utf-8?B?Z2NUM1NvYVVEMzB1TVk5R2xzYVJOUExsU3V4dDE1Ynd1ZU90eTVlVTNSTm1V?=
 =?utf-8?Q?rG2DHFmnhRtHiu5/edTOY8Pxt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5579cb45-6e04-44c4-3b88-08dcf1dd45f4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 14:33:04.5584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqLDPBl3HrWAq2swVAO6USdgFijoM4AudbymeAluXt27Mr1G86iAyU3dZ7hk8yca3N0jd8YA+Kn4PGOp0leByQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7315

On 10/21/24 00:51, Nikunj A Dadhania wrote:
> Calibrating the TSC frequency using the kvmclock is not correct for
> SecureTSC enabled guests. Use the platform provided TSC frequency via the
> GUEST_TSC_FREQ MSR (C001_0134h).
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>  arch/x86/kernel/tsc.c      |  5 +++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 9169b18eeb78..34f7b9fc363b 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>  }
>  
>  void __init snp_secure_tsc_prepare(void);
> +void __init securetsc_init(void);
>  
>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>  
> @@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>  				       u32 resp_sz) { return -ENODEV; }
>  
>  static inline void __init snp_secure_tsc_prepare(void) { }
> +static inline void __init securetsc_init(void) { }

This should probably be named snp_securetsc_init() or
snp_secure_tsc_init() (to be consistent with the function above it) so
that it is in the snp namespace.

>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 4e9b1cc1f26b..154d568c59cf 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3065,3 +3065,19 @@ void __init snp_secure_tsc_prepare(void)
>  
>  	pr_debug("SecureTSC enabled");
>  }
> +
> +static unsigned long securetsc_get_tsc_khz(void)
> +{
> +	unsigned long long tsc_freq_mhz;
> +
> +	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
> +
> +	return (unsigned long)(tsc_freq_mhz * 1000);
> +}
> +
> +void __init securetsc_init(void)
> +{
> +	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
> +	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
> +}
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index dfe6847fd99e..c83f1091bb4f 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -30,6 +30,7 @@
>  #include <asm/i8259.h>
>  #include <asm/topology.h>
>  #include <asm/uv/uv.h>
> +#include <asm/sev.h>
>  
>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>  EXPORT_SYMBOL(cpu_khz);
> @@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
>  	/* Don't change UV TSC multi-chassis synchronization */
>  	if (is_early_uv_system())
>  		return;
> +
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		securetsc_init();

Would this call be better in kvm_init_platform() or kvmclock_init()? Any
reason it has to be here?

Thanks,
Tom

> +
>  	if (!determine_cpu_tsc_frequencies(true))
>  		return;
>  	tsc_enable_sched_clock();

