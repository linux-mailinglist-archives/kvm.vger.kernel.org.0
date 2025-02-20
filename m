Return-Path: <kvm+bounces-38778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0879AA3E4C3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B2293BA5EE
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDCE26388B;
	Thu, 20 Feb 2025 19:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="flhZpfyN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E921C1ADC6F;
	Thu, 20 Feb 2025 19:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740078532; cv=fail; b=qZ1hWNmxf3nXsCKE9X3CoqlPw8YWUFngUbrlL+PSpcR08XpL3P+XuZRwVU5IvPC7HEYEuaWwP5Cbmnzmqx/ZtGZK5OOf7TybcFatq2VBSI5njnEBy33t13pUdFwtDRn3UAoLFLxc/HynkSMKKdefqs+2M1OOHsKe0lcPTxHijd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740078532; c=relaxed/simple;
	bh=uD10kVoUti6+Vy7PgNXTgB62TXa889W1s1P/Z5SoAnE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=IoZmtZ3yz5vTyoY6UrFgBKoV1fMQ34dGkoVve4qK7VzJ4tSeddmrlkay9vLGxD2Uvo3MRYJdSjybJHkzKmp52C0dWZaKFimerCl5hrbM1ryw+8sUN07bDVyTDG/juKBZk0EncPwBTLTEu5RDGVnFgBXpzzNXhjbkCd1IF4/eAA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=flhZpfyN; arc=fail smtp.client-ip=40.107.244.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TraNJV8A9kS6q/j6T+X3ou26vVIbAXXIX702ao8IPax2i3LcgbZdG9vRcHnd7bBYacxHl2ynHXt/UNovs9wNnHpiJDSA3FeswHl2A06GIhvDT5ij798PEZ3Fc3Tm0I/PckH7YImtpNarVSCT2nB6/vIDyYjPuXPTJrA8uO5jnYTx2hc6FEp5jf6Mon0bv0VTtKOaRe3KmAjok1kr0bPsBQQRPyNSJEZAr8MuFTtF0K51FwX11cQCxssrL1IPCA5pD0WaReMU4uMfHT19SdUzyMjXotAlLmiTMvg1nPgA4QvAATMNYz9KR/9kB/oPCh0pfRKSHWEUzyHHd9wCgtDdlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjz9W02JS76GSLVwltf6wqLcXr7Q48310S60QZHdLS8=;
 b=HyrygGqMQdviFXAXhdETc6hW2390vFyp3o2W8Vy/pajcgOtCbAKEE0O0T6jgCYac2D1buJb2clCTNsJBorlSfo5n4E7OtdzuM125r0pUx+oAIzTDhuaZiJSQoBAcgCAAMXD97emsAMDcXfTPAG0uYtVOfEGTP2mGLl5e3K5sPkg1ZvEcuscNpkYfocGOwmZIPiFaiJFepjO4l8sfeXUhp3yFdEb45paRpxEUOdJpoAFDPR01zEJm0Btb4RNvjGyBvQeNrlByyzt6XGl6eG8w+73OuRYSdL+BpOdU8e4WBHOJeTXe1LzbOOa+rX+cR9eKlu8pMItDyTO+bgd/Ip2nPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjz9W02JS76GSLVwltf6wqLcXr7Q48310S60QZHdLS8=;
 b=flhZpfyNAew+YxqEWQyI9fEIb5EevuQ9tVteco/VxnT113NpNge6lvjPwA70/XOm4bcElpCCWf1Gzj0it6UtRYiTqZ0DUaAMYWtR5bA33MyOe18KTZwb5KeFvTddz9pnrH+r3W5GM2meq0eXdXHcjQ+hS5C9QvMmviBdSleBY4s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB8051.namprd12.prod.outlook.com (2603:10b6:510:26d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Thu, 20 Feb
 2025 19:08:48 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 19:08:48 +0000
Message-ID: <021ccdb9-ffe2-901d-0e6f-3e20ce679d96@amd.com>
Date: Thu, 20 Feb 2025 13:08:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <de3a9cc7808dcf3636e2bd2e48c2db06d3eab502.1739997129.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 4/7] crypto: ccp: Register SNP panic notifier only if
 SNP is enabled
In-Reply-To: <de3a9cc7808dcf3636e2bd2e48c2db06d3eab502.1739997129.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB8051:EE_
X-MS-Office365-Filtering-Correlation-Id: bc03be7b-c9b3-4f83-a744-08dd51e20107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2EzMjdLSTZTQWtKdVlWQ1ZCanZGcWgvN3hlWXFYbURIUy8zeGtNbHhsSTIr?=
 =?utf-8?B?cldWdDBqdzlxdURtUFg3S3lSc2g3STZyS2lYVUl1eFowK1FzYkRSTWEvZ3Fr?=
 =?utf-8?B?UlFVdElGc3ZKYUFwV09OVlo2L1JKYlR3UDNnMDEwZG94YWxrQkNLZXFIRTNE?=
 =?utf-8?B?U3BBSm5JZFdJZTZvOEg5V0xydk5RcmdmekczZ2NRUzVGdCtVZ3ZLNmkxbnp6?=
 =?utf-8?B?S2QvNU1ZVTFTdlQzTktaMUNKUGFic21nbEw5ZENPQ1JZU09tUzF4OFordUVT?=
 =?utf-8?B?NERXL3Y1R3FHcG1SaWVUNzZBcVM2b29HVEtpSHYzR1JOdXlqVVpOQkNRcXhC?=
 =?utf-8?B?ZTd3Smt0eHAxTWpzbVdsY2NyMkNrRHoxRlphcTJRMi9nNXoxR083Ykp0cWxB?=
 =?utf-8?B?blJQeUFaRTJ5SmZIVFJSMElpSWJWTkJOODJoelFKQzJrWUJobzFUdklvV04y?=
 =?utf-8?B?TUNENjFtbkVCRVJsZzBZZEJKTFR0SEdkeHhpalZDM2cvdlJseW5EczhVSHhq?=
 =?utf-8?B?Y0F1czhQOHdNRkh3RzlXWFBzZFc0SWU0N1VqQlp3VnB0bnJudklVMWhrQXFr?=
 =?utf-8?B?cjd2SkpkOFg5K1dXSXZVeWI5WnltTXBZYjk4dlJoOVNwcnJKV1dkWFN1OFM2?=
 =?utf-8?B?OC9MSm9xazBSNFlhTVhlbFQ0R3VZK0ZSbzhtUkhaUm91WHFrTzFwNlA0RVhT?=
 =?utf-8?B?ZzlhL2dkL09rM1AwSFdydFVSU1VoMEZmOE5zTFF5NUh1aWgrRnZkMW9JMTc5?=
 =?utf-8?B?TGxrK1VvWnBsZ3gxd3lUN0xUNjRseFowcXMrM1huMm9kRUozZ094RE53SW85?=
 =?utf-8?B?dm03Z3I4bW4zUEYwVDU5V1dUQTNTb3RwN3BLc2hWTHRGWUo2ektFWjJDVlpM?=
 =?utf-8?B?Snh1UTdneW9ZckRYOHhFeGJkcTloblBHRnpvWjVFYUhuL1lZQTBCZGx4RG9k?=
 =?utf-8?B?em9LNWRRR2YzUVZtUkovUXhicm1UNWo2OHZYWkhrSG1HQnBXWUhDbk9PaWJu?=
 =?utf-8?B?aVBBci83M2pHcU9NQXV3Uk84SWt1eTlwSDFuTWs4elViWXBmaVpZc2xocGMr?=
 =?utf-8?B?NHBrU0hISnFYaUpucGpPN0o1ZnlGclZuc1p3VmthWUQyRHZBdXlKYnJNZXU0?=
 =?utf-8?B?N0d5cGJQcm55dVlJVzk1MFAwT1AydjZ2QTJ3YU5SOWtlUUhPWW9ZYmNFOWkx?=
 =?utf-8?B?Z0pzQjhUbzFFRVNXbHQ4L2pyT1lWOHY0dkNMcFFFZDVmLzM1bGdJc0FiN2lR?=
 =?utf-8?B?UHdUZzhGMWRhalEwZFgxNUMvc3hIRjkzYlEvakVkWlZ5RGZxOElvWlhlcElM?=
 =?utf-8?B?RDNUUS9tRkh4ZEFwMk5hdnVmTUJvbjdVOEhzRW1aY3NuaHZXWmNBRlk1MFhh?=
 =?utf-8?B?cTJuWDRQditqOCt3dkhvNWt0UytjNThYRURDS1RpY0xLc21UazBWa3lVNDda?=
 =?utf-8?B?d0NRUTZ2MUJiSlFMQ0ZPY29Jc1dQdUN1dzQ1UkFSajc3TnAvZWNINWRJYm1y?=
 =?utf-8?B?Sk1IdVRYTDBRbmNScHNSK2ZlOTZ2THBCWk11TUJmUUhldktWVEs2czZaVW1a?=
 =?utf-8?B?eTgvT1RuV3FMaUVodER3OEVzdUFqZTg3aUN6SEdMU1pUcFBkcjhtZzJKcUxB?=
 =?utf-8?B?dFhDN0RzbWJUdTRxYjFscHNzOExBbFcwRE5SclI4bXBmTnBqSkE0MXZPTHdQ?=
 =?utf-8?B?WUtiWnN2Y21FZCtFVENmTUl0L2hwN1RSQWxYUWEyR3RGNDluWHFLd0RBamYr?=
 =?utf-8?B?d2hrdXpEK001aVMxTHFjVlVkYi82QTVrMFhJSUFsNFNuZzAyOEI1d1hNYWlF?=
 =?utf-8?B?Mk1zOCtSUUpBWmMzWTBPTG5IMDdWWFR6bTY0R00vZXNYNlordlhyVGEzV1BR?=
 =?utf-8?B?M0Zwc0hmNmFRbnFFUDdDdDc1UXNvQTVIeW9XQmhPb2svN2VIYWJrS0diNEd5?=
 =?utf-8?Q?gJFYfcYOXJo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejRGOTlJNkVLQjJEeW5TV0NJenpKY2g4YmI3VWkxcXdaaFlkdlVSZlRyVnhY?=
 =?utf-8?B?bU9UQ2NJVHU1TnpFSWpsL2lRVG8vK1RSWm1nc2Z1dDhDN2FpTlZBc3NSdDBD?=
 =?utf-8?B?aitKZi9YeUdUd2EwTkdYcXcvVTNodGJzMFJPd05JdllQWVo0ZDZTbmYyVS9P?=
 =?utf-8?B?YTNWdDNWQXEzaWVZMEFMY1BGQXBXaWg0MTBOT0lnWWpFZ2VscVQyNUZSY3Bj?=
 =?utf-8?B?RDd5czdaVnQ4OFVsQUZPR0hpQUZOSFJpcHhCN25kSWJyMGZkczJTcjlaakNQ?=
 =?utf-8?B?VTNYeFY5eGVLZW5aVWd1Ky8zMlZZaEZtV0hRS05SNzhRQUVCWmIrb21iYzZj?=
 =?utf-8?B?MytYVWUyc2RiMnBHd0I1MjZpcW10RHZQRHhOZmc1Y2lmSGYwRndkUTRqRG5R?=
 =?utf-8?B?SThZaFc1UmVBZWk4U2crazVUKzNMZHNpUzZmT2kybzcvN3ZVWURENFJ5VHli?=
 =?utf-8?B?SWlLVmE3K0Q1Qk1Uc1ZRZVRBS1Q0eWVNRlM1Ukl3T1BYZzlYOGdPMVFHUW4z?=
 =?utf-8?B?UGg2S0VMOXIvY2hudmx4TmtUT1JoZTJ0RC83UWltdGNicERqU252My9SRzBH?=
 =?utf-8?B?OVdySmd4U0V3SW9aSFd5cjlMUjRjMGxDVUEyeXNrZWJwVWJiSXN2T0VDOWMz?=
 =?utf-8?B?cmVtdWJobXVwSXA4SHRINUV5ejA2NzhBcVBBTSt6eDZvZDg5TkpmN2xwbG50?=
 =?utf-8?B?YkdYRFovb05DWmkzNHlOMGF3Q1M5VmsvQ2tVSWE1WFRJK0hXTUdaMGQrdVVn?=
 =?utf-8?B?N2tOTUFmSWtiN3RRbEg1WGMzY3FKTzJDb2FKUkVGSVc3Y1pKNDRySnVySklO?=
 =?utf-8?B?K2FBS3pSNk95YXczTWN0L01URzNRNWIrWnBPY2R6bEIxVTdxQlhNeUxqL2d4?=
 =?utf-8?B?S05VbC9NWkp5Y3g5azBaYy82YTY1cVcwcFA2MllFTDBmaDkxY29tSUJQcTZN?=
 =?utf-8?B?RGVNeUNOT0V4VmM3ZGxwY0lTbS9XdEkvcyszWXJTSXdhcDJtVndpN1lFa3ps?=
 =?utf-8?B?djE5Nm5waWlsM3cxWDFYL3pKV0ppdDFGdWVxNXlpaGExTUFUS3pXYXFOb0RG?=
 =?utf-8?B?SDVDV3hjVGh2Snd2QXFUb2ZwNm5WUkt0KzFCZ1JIUW5JS3IxeWY4dXZMb0FJ?=
 =?utf-8?B?SmUwMDFTYUdITWJjWUhBMnNjRU9sbHR2ZHQ4NVNBWm43RkJJZENHN0d6VUxk?=
 =?utf-8?B?T25hZkV0d25yUyt1UXh2U05YODNCT2VxWHNqNm93WDA5dFJKNm1HWVd1QlZH?=
 =?utf-8?B?c0VkYXdMN1lUeFMrQ3FMY0lqNkFybG1xR2ZtZHpRNVhKdm9BbmUzQWFEUktm?=
 =?utf-8?B?aHN5SmZ5WHBlYk1mYUg1NlduL0ZiNmFXYi9pdHoxUDdBVzMydHN2cUZ5dzV1?=
 =?utf-8?B?NUw1dXNZajBGeWR2VWtiVW1Xd3ZDSTBHWnoxYlA5NXlkNytHSENPRGd6NDFq?=
 =?utf-8?B?WjE4VGhScVpNTUhmbkgvWDNsZHJBSEtlVGZOblZzSlQ4ckQ1dHd6Q1lMdmVG?=
 =?utf-8?B?V2FKNEd3YzBnTmdGTDdWc1FuejNDY3FMTDVYRkcwZkhvbCtSTVExeWxTYzVk?=
 =?utf-8?B?UnZINHltNlI1b1Z0VTROdWZRNEpENkdaSmxTdlJ3Q05sc2pMM0VtczRpNmdD?=
 =?utf-8?B?TUtBNzBFMnlKMWdFWlZ0Rm42cmdETUVSMThIV0RxYVk5V1pUS0gwN2pIVkZu?=
 =?utf-8?B?SmwzUXF4L2dBUXkxVExLZ2FWUFdlak5vQjNsZlE0Vmt2Z1hGeW5MUkdiNU5W?=
 =?utf-8?B?OUFhK3E0bUp5YXV2Szg3VVFOSlAzQ0FZNXFtR245WTZFREd6M2dCaUpKaDN5?=
 =?utf-8?B?cHMrY2xWeFd0OEVjNEJJODZKSjBsRFYrZG5YRmNPRFdaZFp0SEQ3b0VkYmtR?=
 =?utf-8?B?RG9EdzYzU095WXp2eE51K3RPc1lNbXdQaEFrSXZvZW1ncUdZcVkwU2dmSjJi?=
 =?utf-8?B?RDk4UXJnamx0QUdiR2hiVDVCbGl6SFY1REVvMFhuWGYvdmlvR0ViYTVKYzNY?=
 =?utf-8?B?czBjNzFVQ2x6NUxYVjUwNUY0Q09uL004RWgybTVTN3NmR2NGdGVPcXpWZWFI?=
 =?utf-8?B?RVcxSHR3U25NcENNS3FtdVdLOHJiWWdBVHBGMkRTZXo0V0YyQnJ3QnZjMUE1?=
 =?utf-8?Q?yclcxTZBcx0qLlPbtyVWya02h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc03be7b-c9b3-4f83-a744-08dd51e20107
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 19:08:48.0267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NyETvl6FWCWSwN07OvBOGW+ICZmAQny4mTK29Q8ofqQiexRvqgNZrYac0Cor00teI5ulie8CBAkb9FvWj1HDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8051

On 2/19/25 14:53, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Register the SNP panic notifier if and only if SNP is actually
> initialized and deregistering the notifier when shutting down

/deregistering/unregister/

> SNP in PSP driver when KVM module is unloaded.

s/SNP.*/SNP./

The PSP driver and KVM reference isn't needed.

> 
> Currently the SNP panic notifier is being registered

s/being//

> irrespective of SNP being enabled/initialized and with this

s/intialized.*/intialized./

> change the SNP panic notifier is registered only if SNP
> support is enabled and initialized.

This paragraph should actually be the first paragraph of the commit
message, followed by the other paragraph. So something like...

Currently, the SNP panic notifier is registered on module
initialization, regardless of whether SNP is enabled or initialized.

Instead, register the SNP panic notifier only when SNP is actually
initialized and unregister the notifier when SNP is shutdown.

Thanks,
Tom

> 
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index be8a84ce24c7..582304638319 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>  
> +static int snp_shutdown_on_panic(struct notifier_block *nb,
> +				 unsigned long reason, void *arg);
> +
> +static struct notifier_block snp_panic_notifier = {
> +	.notifier_call = snp_shutdown_on_panic,
> +};
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1197,6 +1204,9 @@ static int __sev_snp_init_locked(int *error)
>  	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>  		 sev->api_minor, sev->build);
>  
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +				       &snp_panic_notifier);
> +
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
>  	return 0;
> @@ -1751,6 +1761,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> +					 &snp_panic_notifier);
> +
>  	/* Reset TMR size back to default */
>  	sev_es_tmr_size = SEV_TMR_SIZE;
>  
> @@ -2466,10 +2479,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block snp_panic_notifier = {
> -	.notifier_call = snp_shutdown_on_panic,
> -};
> -
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>  				void *data, int *error)
>  {
> @@ -2518,8 +2527,6 @@ void sev_pci_init(void)
>  	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>  		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>  
> -	atomic_notifier_chain_register(&panic_notifier_list,
> -				       &snp_panic_notifier);
>  	return;
>  
>  err:
> @@ -2536,7 +2543,4 @@ void sev_pci_exit(void)
>  		return;
>  
>  	sev_firmware_shutdown(sev);
> -
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &snp_panic_notifier);
>  }

