Return-Path: <kvm+bounces-38788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22219A3E58D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B548421C34
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C292641FE;
	Thu, 20 Feb 2025 20:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jhxQxgz7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F5B1E5B6C;
	Thu, 20 Feb 2025 20:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740081833; cv=fail; b=LqfY8RKQnZwmPer2SWq8lMNjsWtRKenna4ceABkqjrq1unPUO7calpyeqkV3Ehj9A1JI95NOS9S6osfGdkhxnC9CMW8ed9HIvo3QVC90VWUIauGv8qwtiWVCPjVYvfIwgJTVr94T0I+q3gn8kQ49WWyu2LXfGKcl1ibLfQbMpf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740081833; c=relaxed/simple;
	bh=UZkOcbSedUhCzuCLFKKKB8fs4dI2MVHQCIZeN8YH8U4=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=XzD/9SGB1Y2txVMGHDWQOhFyUEWwmkHNhSgMbC26JlqcS0sxU4rZtBKO/xqLqTuXYoQ2WTs6ZA2xACjGcj7SwhWiDshqu+aQHAqfscLsFpaFuUGCYszeSn5+y/qkYbUAelVm5EIXYjl/YJNv6aaB90/3p5gU3Rft4NDoYIo+MOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jhxQxgz7; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bwkJPO6UK5hvFGTwvHNL3eSkkCN3YnxLH/N05PCqdleZlEOPKJYI7vpAPZW9MdKBY32cgYZkOBKI6E/mqNPD8cLF5sR8c9faHS+eOkO/u5f6YbN4l/d4JGib9SeCaZKTITq2OF75VOjlTmOvYnnYEWIQKOXwieDuFbNraOlkYI48DFC2Z3+04+3qeays6lxsNFQjiNXmmhKKBwXLaMSBVZPPcaEF7G+QhEaS1KsJTcarB896+x9BNHmvy+tfUyBeHNbLVGZRwUoy76WSkRo1z7AwwXc1WzRh25kY4egmR4D9UAByLikV+BxJWx4W/JpiYegjGCoTvylAcxayPMrBdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79rkYA+S3ibg/psuVLKlZQeuPqpzzjMw89wdQNvzdpk=;
 b=tdbG6MSIVcyQD+c5a+1Z6P8VAUFvUcPTNIBgsSewJI0Jh3078vd04beWpaZPFzrm1iWs0IKkVWZsoRtfwiWNQfxmMQE5HzOFPQDed+p0c6mnE/LPrblvzfNbBWDcA105VAqsVwDy5ChImu+00O5N2ga20+MREZKvIoJkYalGqNxmwV+C/MUQb1ut0nJ/upoXIm58PCNQGgl9Ry623mxMeGOEu4xs6E1W7Y9LaVA5gO3wMxfaOqH9QiFp9hcQwitXl7cvcamZTuMTRobhVaOJBc46uheoXkp+W5IVqH+GEDUvuSkMBADV7ShB0vnxm1F9s354LfVI401ORtAwyNMCpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79rkYA+S3ibg/psuVLKlZQeuPqpzzjMw89wdQNvzdpk=;
 b=jhxQxgz7FkzFrd/FKp/HrWxekl/TFMWScc1DhZEqXx1POgdRI7khTAyZkxdMyORYqSr6nHGswUwOdmvlA1ZW92wq9kVZ3XeXzQ0Q/YmwKx32HS/93cTo/lYChByrE0SGQ40z/Yitlls2FoCndodDHZ3eF9ryzJBItyEkcEqLKaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN0PR12MB6104.namprd12.prod.outlook.com (2603:10b6:208:3c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Thu, 20 Feb
 2025 20:03:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 20:03:46 +0000
Message-ID: <68daec1d-63b3-ecc5-f8c3-9df8a905ec88@amd.com>
Date: Thu, 20 Feb 2025 14:03:44 -0600
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
 <8ddb15b23f5c7c9a250109a402b6541e5bc72d0f.1739997129.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 7/7] crypto: ccp: Move SEV/SNP Platform initialization
 to KVM
In-Reply-To: <8ddb15b23f5c7c9a250109a402b6541e5bc72d0f.1739997129.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0040.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN0PR12MB6104:EE_
X-MS-Office365-Filtering-Correlation-Id: a52582a8-9910-4b96-f0dc-08dd51e9af45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OStNM3B6TDVGRlBjL3B4VmN2ZG1tS3ViSXhnMVd3WHpCdGdtQ0lQOTd6TVRT?=
 =?utf-8?B?VUxJTGxOZWFnSkx4QmtDVEZoeFR0b3RISGo2cmZMZHRtbDljTWdQY21paWZy?=
 =?utf-8?B?bDQvMzZVN0hLTmt5M1czdlZ4emU3aFhMQlI1SGhWQmFKQWU0ejQweWVZZi91?=
 =?utf-8?B?S3d3VEV4RmE5TkN3Wm9MelhyZkF5WTdvNkQ1VnMxRTNaeXJJcTA5a0ZBdEJX?=
 =?utf-8?B?T3FOK00vRG5wdEJmcS9vTXNTSU9zZVRMeURVb0dqbXFSWFpva0d4QzZyUTdL?=
 =?utf-8?B?Wkk1UGR0MU9icUt2YWUxdXRrVm5IbFZvN0NNMVhoRVErUFZEWnVzOTVGbmNU?=
 =?utf-8?B?QVlsaFVGczh4VTRlZEpXSGsyZi9udEMySS9BTFcwYUw2eURyMG9xRGJWNmN5?=
 =?utf-8?B?bTMreVFNUWtJWmg1OXFLdXU5Y3NTNFNuKzJpY1k1MXdVYlZIWUZQQlpyLzRl?=
 =?utf-8?B?Z2cxb05yVEk0SWp0OXY1dXhQR001bFFrQ3pyUnY1MEYyM0RzWVBycU10bmJv?=
 =?utf-8?B?OFc1NUFBWXVxQnFkMjNaTUlXdUpxRHFBWDlkKzcvTUxHOXdMZDkrTzdGRHFh?=
 =?utf-8?B?ekI3RHA5dWN3TE9QaE9UeHZJQ2RvSGYvMjhvN0JKNTBLL1lzWktSRmIrL1pI?=
 =?utf-8?B?RUJuUGExd0x6RCtqM25aK0FMSURibVh5b3hzaktEanBrVWxTaVFSWDlrY0NZ?=
 =?utf-8?B?czBwNmgwc3ovZlc0Kytzd00vTzhVeGN0d3VXRVQrZnBadjIzaWN0SklNSzgz?=
 =?utf-8?B?VXNzSVp2Y0RDQVNnY0hQNmNoNWNSTGNvMkJ1R2dtTFI5N0owOXJ1YkgxYUd5?=
 =?utf-8?B?bm1zaTBGYmd6ekZEeng5c1lyYklnVGJ3SDJEdDY0UXNXNnp0cWFkSWVZcTVz?=
 =?utf-8?B?UzZHTnRTeGdvdmloNjMrdSt4K3FGMUlTNmk2T1M4Z3IrcnRXeDZOT1B0V09O?=
 =?utf-8?B?cnB6ODVUTWJ3eWVyZDhRelBRdU1NdmFNbFlNbWN4NE1ycnZ1eGNCNjdtdmVs?=
 =?utf-8?B?TTBaWGxQQ3kwR0tDSWNnQ25XLzY2b2ZwRFBXLzE2M1ppKzJJQTJadkVpejlT?=
 =?utf-8?B?TmU2amVwOVRTdHZMc05mMDQwMUpTd1Z4Sm5Oc2JoS2NKR3FUODZrS2xOUHdr?=
 =?utf-8?B?R0lRbGR4d0JNbXZGRmNYT1pPend3SXovV2xBU0xpR294RzFtZDlSWTVqRmVy?=
 =?utf-8?B?QzhzRGdHR09NbHZVamdMSC9lMEJlelVLV1h4citaZ1JpMjlFV0w3bXZ4ZWlk?=
 =?utf-8?B?YUtvTHVERENhcXVvdXBTRzFwM21rakpNSkhlWTZFWG85Y2ZiVENCY1dhU0Ez?=
 =?utf-8?B?MWYyNnhONnRoNU1nU0c4M0cxSUdhUGNQY3pvNFFjcEtMb0pHN1E2SFBBR05S?=
 =?utf-8?B?aHgvcU5Xd0dpNUdzSW5taVVha3YvTUFZNStuZUhBbU1QZjFNMnFxdmx4eEYz?=
 =?utf-8?B?c3hzRGlxc3ppdGtTL2c1b0ZSVXY4WVZ1ZVkzRHZYMHJmaE1vV04yNXpPdnNS?=
 =?utf-8?B?dUlWMzZ5V3JWL3Y1Y2NINHZ4SFBRTjB1MXFxSEdRSjM3VjRwcERVTmRmekZH?=
 =?utf-8?B?SUJXc2tTNSsvNVNDR2pObG5VSHBDVHZNRHV2NWt4enpOMTQ2S3VDTER0Yi90?=
 =?utf-8?B?UENHQzF5T3JiajZjTGV6aE1rdWtid0FINVc5Si9GMmR3WUZJR0ZKNks3ZnNR?=
 =?utf-8?B?YkR1ajRnZDRveW5uVEl2UnFkbnBuV2MyNlczV3hBaThUUlQzZ0tLQVRuU0Nu?=
 =?utf-8?B?MUlabk0vSHFuSHhTeWpWeHpwMkFWUG5zMVpOR0ZvN0NYRERlU0J3ZHpDSWxp?=
 =?utf-8?B?bnBKQ3A1Zkc3ZUFIcjdKMDY2NjNLTWRnUndoaW1DZGRrOWxGSnhQaFhrSEJi?=
 =?utf-8?B?OUF0N3R6SSswUWhhYTVjYU1Jc3BhRnB2MjFhbzhvaHQyL0dUUVFVRys0eGY3?=
 =?utf-8?Q?/sCzBA6MphI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2JrNmRCZGJOUHpzWWE5SDNJQ2ViRE9TZGhyMzNBSndPbVNBaXRweVpHRFVJ?=
 =?utf-8?B?REdways5Nk5pTDE0ZVRzYjlFdFJKNlo3dm9jQ3V3blVKd3k2V3grUng5OWx0?=
 =?utf-8?B?TGV0S01GRzd4cDRrN2hsYk5NVXZqQ2lPTFlLbnVXajdielF1Z29WOGhaZ1Q3?=
 =?utf-8?B?cmpXNVB6ZjNHRUl6bzE5NjFVMU9GN212L1J4amtjcC9jZmRCQW9vMTIzRFNz?=
 =?utf-8?B?bmdNMmlyUmxybG1BV04wQTFGbVRJSE1XakUrRDNwU1oxcHN5WExmUW1RMGNa?=
 =?utf-8?B?dUlrM0NsWEM4SkFxdzk0ZlpMN3poY3BnQWJNWHEyVm5aMi9mMzdaY2grcCta?=
 =?utf-8?B?eTJCQnRRWnpRcXlWQW4zLzgrUGxCamlBVXFzVWpObXhJTk5GeUg2aEs1YzJX?=
 =?utf-8?B?TStyNUdQa2EvS2FFQTNrNGhtUmNNb0ZNVTFRR1RrWStIMTMxeDlaSjhrZHJR?=
 =?utf-8?B?ZGdCa3crbUJSc2kyUWtCenREbWhjbWVrUUFTNUFFQ0o2LzAydUxXTGZKOTJ2?=
 =?utf-8?B?TkNrNVhMUXQxeFNzQm1qN1lkY2NGbkttRHVOWEhScTR2a0NkS0ZWOHU4dzNT?=
 =?utf-8?B?cnZOQ1h6bHNxS3l2RElBbnFkRlUxNHpXN2lwempOS1Z1WFMxMHhyaHJOYXA1?=
 =?utf-8?B?NGpvVnM0SGFLM0tjTHlySy82Uk9pZkl2c2QvTzZUQnJwTjZUUStRMGIvQXFC?=
 =?utf-8?B?Zk9BdWNQMzcySHBmQ3B2TmNRK3p1WXdHWUdtUEx0T2puT0MzNXY2T2VrajdV?=
 =?utf-8?B?TGZTZE1leDVxei91cTdWdjIyOFluMnFzRGJPZ2t2VjZMa2xMZkQvQjZxRlM0?=
 =?utf-8?B?RXNhTDcwTmE2ZXpzbFg5aDVEVzNnV1pVUmJPVk5WL0E2SStpWllaYjBaWVJU?=
 =?utf-8?B?U1l6eVNoeE5KaCtLeHRBd3JraXJzMlJiY29RK1FrYXJwMzFxV2FSQitOV2Iv?=
 =?utf-8?B?eHhOS2ZwelZZbUtWT2lTMUljYjVYOHdTYlRQL25NUDBkV3U1NFl3eU9WbGNI?=
 =?utf-8?B?RElhdkJFejdJd0lsMWRYZTZDNkx0R1M5Q2tab1hKZDJlK21EdStWWDk2dWJr?=
 =?utf-8?B?REJ3ZnU1VllqeWtCSzF0a25PbGRVY0tEdVlBNEY4RjRiNzgvdi9laEU4MFIr?=
 =?utf-8?B?NVlhWm1IZkloTmhtQ3hSRXQrV055UXpmWU1YVDhyb085cGV5UjhObHlDN3ZQ?=
 =?utf-8?B?NlN2Skd6M3FzUG1vZkd1ejBtMVpsL1J5SzNKVUtPM2N4bW5oajhpL3BhZ2FY?=
 =?utf-8?B?RzFvbmRMVkM0cUcwRzRXK2d5bzRuWmtGUUEvY0dtSzNXdUpkblpuZG95Uklk?=
 =?utf-8?B?WUJLMm03dmxjUERJUDZ5cUhmYlRvdEF1UEtTN3o1L28wSzFCM3JwQTJIdlB2?=
 =?utf-8?B?cFZ5ZjdLdUxWVHNlWE91V1ZpaE04TEhTNnBidC9EUVlsZkNKMVVGblFpSjNj?=
 =?utf-8?B?V2NGSm02Q3JUOXVEay9zUWJhTGVDUDQ5aFp5UmVkU0QwT0d5QzAyM21XMWpL?=
 =?utf-8?B?dTZQc2ZPSEsxWXkvWWgwN2FZc2dSN1FCYSs4Z0lrSm9wTnVSRnBqVkFPVFp2?=
 =?utf-8?B?UWRpbGRjOWx6VTVsdzlCb01XSUp5SlZqY2Fqc1dnUGUzVGgyM3Exb2NiQS81?=
 =?utf-8?B?L2dzbmNSYlFnMSs5Ymk5WmlSU0Z4OEN4VFlEZnZVbXM2NncvU2xNaklOYS9l?=
 =?utf-8?B?WW1FcDZ3RmZMTDdRWkJ3Zkh2UnpsQ2svRnppb2VpenJJM1RYZG1UK2d4QkVT?=
 =?utf-8?B?SnZES3ZJQzcrTDhuNG44aVN6emtoaGFqakZjcUpXQzZ5S1NlV1BrSmN5cnFD?=
 =?utf-8?B?MVk2bHFYamJ4T2FTUms0SFZzOWNHa01kQXNqN3RJbnZTNGRDK2tZWGJXMjBy?=
 =?utf-8?B?RjlOamdxQnYwbEIybEpOcU56aTdra1laTnFYVldOV0JyQUN6dS9uNFlYUzQr?=
 =?utf-8?B?WVJnVGx2QkgwSnVEOWp4OGNub09mZG93emRNVUdUZ3NNM0NoMExMSlljY1RP?=
 =?utf-8?B?S1k1ZmRDMEU1d01xQlFyQnpTaUlITEs3R0pRbWw5ekZ5dkZYYWFqanAvMTBG?=
 =?utf-8?B?d0RPS1MrK0dQVjJVS0JXYkFIZ09xdUVjSWdFd1VKaytkdE9CSWJWV055VnJo?=
 =?utf-8?Q?IVXqXuj3vz3CvErsAEneGB9+K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a52582a8-9910-4b96-f0dc-08dd51e9af45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 20:03:46.7762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bzvetrlU4t0ECkypyKC2kI7m5yP6K7rGi1aEYc/os5sHvNNLfMBuoI47jAYjsGP95H2OiekFBtRY5Hbyn0wwrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6104

On 2/19/25 14:55, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> SNP initialization is forced during PSP driver probe purely because SNP
> can't be initialized if VMs are running.  But the only in-tree user of
> SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
> Forcing SEV/SNP initialization because a hypervisor could be running
> legacy non-confidential VMs make no sense.
> 
> This patch removes SEV/SNP initialization from the PSP driver probe
> time and moves the requirement to initialize SEV/SNP functionality
> to KVM if it wants to use SEV/SNP.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 25 +------------------------
>  1 file changed, 1 insertion(+), 24 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f0f3e6d29200..99a663dbc2b6 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1346,18 +1346,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> -	/*
> -	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> -	 * so perform SEV-SNP initialization at probe time.
> -	 */
>  	rc = __sev_snp_init_locked(&args->error);
>  	if (rc && rc != -ENODEV) {
>  		/*
>  		 * Don't abort the probe if SNP INIT failed,
>  		 * continue to initialize the legacy SEV firmware.
>  		 */
> -		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> -			rc, args->error);
> +		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");

Please don't remove the error information.

>  	}
>  
>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
> @@ -2505,9 +2500,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>  void sev_pci_init(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> -	struct sev_platform_init_args args = {0};
>  	u8 api_major, api_minor, build;
> -	int rc;
>  
>  	if (!sev)
>  		return;
> @@ -2530,16 +2523,6 @@ void sev_pci_init(void)
>  			 api_major, api_minor, build,
>  			 sev->api_major, sev->api_minor, sev->build);
>  
> -	/* Initialize the platform */
> -	args.probe = true;
> -	rc = sev_platform_init(&args);
> -	if (rc)
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> -			args.error, rc);
> -
> -	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
> -		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
> -
>  	return;
>  
>  err:
> @@ -2550,10 +2533,4 @@ void sev_pci_init(void)
>  
>  void sev_pci_exit(void)
>  {
> -	struct sev_device *sev = psp_master->sev_data;
> -
> -	if (!sev)
> -		return;
> -
> -	sev_firmware_shutdown(sev);

Should this remain? If there's a bug in KVM that somehow skips the
shutdown call, then SEV will remain initialized. I think the path is
safe to call a second time.

Thanks,
Tom


>  }

