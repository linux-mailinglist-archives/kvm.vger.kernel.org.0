Return-Path: <kvm+bounces-52311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28253B03DB5
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74DA27A9907
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F554246BBA;
	Mon, 14 Jul 2025 11:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mdH30PJH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E97A927;
	Mon, 14 Jul 2025 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752493913; cv=fail; b=H4Bk6N6RFUvfYai5mnvCqef0jyicvTTROIZSDf53uirTvrbnFveNMuiUizozfsE7vDfJ37iuQFpFGVrdgeyHCCtW6HRDQQz4K7xrBEGqJ7jt5nZ1xbHqsG6wRhWB1f5RKEvtU7pOEA2ch/hb9aAhGINkr+WyKeWAiSJR/z6VK38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752493913; c=relaxed/simple;
	bh=V1zl/LzQvyL5+1PzKffFDHMW6byuWyDa1RLHyqpXok0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pabEIm4nT3fwGUe3rDphA+xq/i44qGck0bw4b6NMg9aeROnrVGeMwmD7cFUfXbWjs9yRE3tdcQwGhJJeEqw897XHyrKoWfGoIp8TUYP4mPv2WCdYdu40aaYL+5pS76wA7F+/59+kaMc1Zzyc78fGbF1zDQ83/JWw5OiBWf7Bj4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mdH30PJH; arc=fail smtp.client-ip=40.107.236.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tfiak7pk8nZY7IBZqj6nhrtrccgJYv6PlEQ63uNCzwFqACKMBGxwbbN+pTd6+mTqkYXWCgSbKBo2Q36ZXmEMYXpzb7cvVIESWI589b1d6091wseEAV/JKALniVcAa0tDfGXr0cRbbtltqlbe7m5Nv7gcX6KA5PDlC2w3xVEMhKdntPikYGA8ndJhWl2Ftp8MaZzQnjIJyqTwm2AXpPibHHfYYFFFeIt826sy1HSK/qUPpwdf+um8fLx3DnoWTy4x0MC6aROMxs+lW3nAXGkpsEvOFQQ99bXldlX52zlmfisxYmPwl38YBaNbMPHtffk5bRN6Rot3TcCnvFLrmukvig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBZFfycvWT5d+X7Zf4pDoSgNWdFlWMhnG0GA6Cz6lnQ=;
 b=uU1umEAU/f+/y+XKpv6xwPW6V5MrJIf7KqFGndMSRFo0mMiVavBnydT7SKBJ6fVlAzWs5dJn7Plc+j8vMpG9Iw3j9gwTSXAen+l2gke9xgxj4MIfxuvfO1H8zyiBahnk/NB4Yk5yNKmwn/hNyOYrx/1a9o3wnxNqDtQG2T4RGq/9CdhRssI7At5XyLmZXvB9fFzJbLDnVPRr/gK9NWcevEi3JsmW9QSn3M4FH4f6bYizACcwt3a0eD2jonGs3lwoSbNXPUiz4wDYLViwiY1e4xKrojM92nSMgrYOTWS3gjlgljbpieKS4FFGUhws0Z/i8jh0E8L4vsFqouxfe4bkeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBZFfycvWT5d+X7Zf4pDoSgNWdFlWMhnG0GA6Cz6lnQ=;
 b=mdH30PJHZze4pN2pGiy+esauaiCGWmD61+bVXQd/2il1kadRw/YYk4wtI0fwqyCQGHtSobGfWraNamD82JzGtKYFhFeLdVF3mByBZmQ6B+1ltCHnQvn05CqzkX1WZw9EB9g9iHNBRHwvdEdYGMWsVN8a8/adgf2euRp/5UJaRaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 DS0PR12MB7969.namprd12.prod.outlook.com (2603:10b6:8:146::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.29; Mon, 14 Jul 2025 11:51:49 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%6]) with mapi id 15.20.8901.028; Mon, 14 Jul 2025
 11:51:48 +0000
Message-ID: <01174799-e7be-4985-879a-b3c10b810c98@amd.com>
Date: Mon, 14 Jul 2025 17:21:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] Implement support for IBS virtualization
To: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, mizhang@google.com,
 thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
References: <20250627162550.14197-1-manali.shukla@amd.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::10) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|DS0PR12MB7969:EE_
X-MS-Office365-Filtering-Correlation-Id: 483212b7-a775-4d67-665c-08ddc2ccd064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlRBYlRBWlJtaXdSd01Hazdvb1JscHhITnBLSmdyL09lMWtsemdIQ0hiTDFw?=
 =?utf-8?B?QVZQbVA1enZIVi9pbm43ZC9RbmVOcVNucWFWYVQ0aE5vZm5aQmt1azNoaEho?=
 =?utf-8?B?eHlHS09tN2tFajAvSFl4NVFoUnBzdDgxTjFkQlQ0aDY4Rk5mb3pTYk45UW9U?=
 =?utf-8?B?MURaWU5EUG1KR3FzaTU5NDVTM3lSNUtHN1lIRiswS1lLbGxXbkJUMjNBeUM2?=
 =?utf-8?B?WnNsUXpVcS8rNFJoeW9YekVPZElJRnRIVlFlTG9XU1F5ZFRmaHYrT2gvMzQ2?=
 =?utf-8?B?cFdhbERCc3dMdkpFK2tWQXBpNmVTejhVS1RZWGg3TXZMUENRNUd0TW5BR1lH?=
 =?utf-8?B?SnJEY3F4VDBWSkZjc1hWTGJvM1pYS3Z3UTVwZExWZFh4Ym5kbWdhWTBzbDlH?=
 =?utf-8?B?QjBZSFZmaHhNSmtzZ0x0WGdJOGhNNm1vSmtpMFNYU3FNaHJwMjN1RWZSOWZx?=
 =?utf-8?B?MEo4TGNHUzNLNS9LMForZTFUS3AvWDdNRCtpMU11bFE4d1V3NjNBNHQxYWJo?=
 =?utf-8?B?YXZRaHNNU1FoSStBRFN2NlhQK2NOb0VwV3hTRDRMaUY3V1VRR05TMWY5S2Vt?=
 =?utf-8?B?Nyt0RFBIeWo2MmxEUi8xTkp2R3ExV0N2TWg1TEhPRUtabGhKUS83Ui9PdVpv?=
 =?utf-8?B?czBNNVoyVHVBUnFMU1FNekJNbDRQdG5IU04ySmhFOUx1R2hFdXdSd2JkSUxL?=
 =?utf-8?B?b0ZIaUliNDR1N282RStwbWwvWlp4YStYRVZuOS81azJ6S3lFTWZKeTZSalEz?=
 =?utf-8?B?QmpqN0FvRDZrWEp0SGJNZFJkS1lqOHZMV09OMlovWmlhSm0wZ1ZUSWJ4eU9H?=
 =?utf-8?B?NVhxL041YTN4aVZrSE5QbGdYcHRUVk9RZDBMd1ZpbHhReTQyUThEOU1uUGVS?=
 =?utf-8?B?N2pDc2pFTjZnQktWcWRSaTNDTFZ3R0M2QkcxUjlpcVgvdjYrQ3FCMEo1Y0tH?=
 =?utf-8?B?RVZuV2NBT2pwZDRRbEc2QVNTeXc4UnF4UUxyYkxHRkYvMGd3ZE5lY0hOWHdn?=
 =?utf-8?B?M1BpU1hVUVBUOEVqcnExNTlVUGhtVjg1djZ3bUw3ajJodXM3S0xXclovVlAx?=
 =?utf-8?B?UWtNcG9mOUZlblk3QUhMT3NTNnM1MS9zV3dYOWJVRDBTMjQxUWlqaHlEck5Z?=
 =?utf-8?B?NXdRMVBpN21XWk1PSWZ3RFR2VExlTUlyTnE0ZkdJS29mbWlZc0M0WHVBRkY5?=
 =?utf-8?B?TWZucmZ0UFNIYnZrWWdLQ3gybnAyNFE3cmpqUFdNYitaN3IrcE50Q0NCcllH?=
 =?utf-8?B?UzlOUTZlZDJtUGo4N3MxKzFibzVtL2gwTmc1UUg3L1l3R3J1Z1NUZEMvZCtB?=
 =?utf-8?B?UzRYaFhEN1RQNU9lRXkxa0ZHOG5wQlJMVkdOMHgvWkFtbFFUSzltc1V1MUpn?=
 =?utf-8?B?KzlTWUhjbmx0QkdTeHNMS0l3M3ZPc0hvRmlNT0dPRCtsQ1NSUXk4K2ZHWVE2?=
 =?utf-8?B?T25odWQ2MXFYTklteGFYODFZUHNJVVFSaUo5b1hNeFpqQytBd3pvM1pveGtK?=
 =?utf-8?B?M01ha1NsQ0Z2MGttUFQ4cVdiYTFMQ1lmeCt1ZW5mcVVLbk5nNk5zU3QzUHd4?=
 =?utf-8?B?amp2aVZoUkJRVWdpa0V6TUJPTFVmK1dJVWNvdWZxQkd6WXR6Skd4M29SQ2Vh?=
 =?utf-8?B?WjRIRGNKVm1vejhTdTVXNXhkb0VlSFlqTVpNZ0NKWlJXOE5UaDUweXdhcXR2?=
 =?utf-8?B?N1NHR2RFaTBBRS9ISGZNRmVSNWZ0TnZxd1hLVGxubHdFNVFGSlhiRFBQOFVF?=
 =?utf-8?B?TVdpLy9sTXVROGxzdWxIOG1SSTJGZmVjQ3JkbFFaUG1FdW56MWp0OUpNUWRt?=
 =?utf-8?B?MWZ0TE1yNWZESDZtRmJZaStvREtjRXhsUHYvR2FEelYyemZxQm5ibUhwTHJU?=
 =?utf-8?B?dGQrdFc5NnJCWlNFdk9pR3JsSUt6TlZTOWRXYnZEUlZOeU14U2k5MHE3MEgr?=
 =?utf-8?Q?W6efDpsaPpU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djNkbklZT0JaMEc2OTM5NTJ5WFpadWczOEpsYStUTFlRQ1hWNGhDV2RkVFVF?=
 =?utf-8?B?blhhTWFlUGdzbHJ4bm5UY0piWlRoSEhBbndacTlmY3ZsenJGQXJGV1JZZndU?=
 =?utf-8?B?Z1Q5MTlzTzY5NTcxeEU5eFBkcFVFQ0d3d1RXbUV3VC96UERRcmNURld4Ui9n?=
 =?utf-8?B?eEhXelRUY3ZEUExhSVJuUmR2bjlaL3YvUkFKRmRjb202MXBZZk5USStnS3JM?=
 =?utf-8?B?anl6ZXErUkQ2RWFCUTA2TlMvZHI4RERYU0JnUXUyMU9sVmd5a0piS0pkZUJy?=
 =?utf-8?B?Z2RQTmZ4SkZ3ZVUzTUNaTlhrQkFvOSsrcjVpMWpiTDVxd3cybURVNm9XdU5M?=
 =?utf-8?B?U3c2eTFnakovU0pJdUo0VWxjUHVPQ3RiWHRqSVJOVXk5L243UDA0YkxhS1BH?=
 =?utf-8?B?d21yNWNZY3oxTTV6cGRRMHlJYnZySlJhU1BoblVGclk4SjNhc2ExUnBqVldN?=
 =?utf-8?B?bjhjVEd1eTFqTW5JSzU3bW0wWDFVN2NkWTNPUG1BTmVrNm1iT1VyZ0VSb2tu?=
 =?utf-8?B?aUdtMXB0bW5yaWxnM2hkTFdIS21BWEdaSVZzLzY2S0tBSENoQVJ6ajlSY0ox?=
 =?utf-8?B?a1lMQUF2dnc1NGhuMGtuSmFsSUY1V1lUdWdBQWlsMVh4SXVpWGlaM0JIM0Jt?=
 =?utf-8?B?Z2JZYlJRZDdyd2NFRVdkaHNvM0Z5OFpUQ1ZCREJRTzJRNjI1eTJwTVRLOCtS?=
 =?utf-8?B?NVpOWXJROFAwWUJrdGIraUZBVzlJQVZ2VVNRVWhhZnhwdklIZ2MwNkFPeUVY?=
 =?utf-8?B?VUsvRmlCK0xOTmQzZG9uTVJFSEttSUdwelI3SWcvQzQ3VUdsR2xYa0Zya2VV?=
 =?utf-8?B?OUU2V2lPN3B2aGQvTGJRQ1dZbk8vYjBCMFp3cjhtSlk4SzlRNi9ka0wwN09F?=
 =?utf-8?B?ZVpERzk3c0t6aGk5Q2ZSaGMxMzRFLzc5dG90QUdCaVZXbFl4Sm9ucDFpWDZs?=
 =?utf-8?B?ME9MQmI0Y2pnbW9VVXZ3NFNKeWJwbGNSYjBxZnF0dFBNa2xXSTdVdmk3SFlv?=
 =?utf-8?B?WTc5RHJuQ3JvYWZEMWk4U090ZHcybzJoUnl6dElldFBKMFVCVHFSMjQ0MkFK?=
 =?utf-8?B?cGRJeG9aU2ltUE9mM1dCdjJDRkl5YnhIUkpFVGFPczNDMEt4elNSMEhVQWpZ?=
 =?utf-8?B?b2FqaDh5MGpyTlpzRjNVSWZXMHJDYVVVUC9rT2FpcFZiLzZCYU5ET3k0QS9z?=
 =?utf-8?B?RGE1MlF3WmEvMmN1TXhIUTJTQVlXbThrRU5uVGhjSXZNSzd0bW1mMTRMMFVB?=
 =?utf-8?B?bmt0clp1dTRpNnFFY3djc1cvMmZnVlMwSGhUbXYxMkxId0h0aG1sTnNRUWRt?=
 =?utf-8?B?aFIybEU1bHNVd0NFUDYxRWJmeDRCNEEvcnBTaExWSE90TTExZmpQRWZFN1hD?=
 =?utf-8?B?R3ZpaFV0ZGx2YXF2NDVlRFFxOG53MzdtUGtrRUR2aktTOXJxSHhVMGdxeFJL?=
 =?utf-8?B?RTQ5OTZoSHRMNzNCUmYrd2N4MS9VSnpMbmRpU2p3ZWJCT0ppcjZiUE5uckYr?=
 =?utf-8?B?TGtxbzBacjFXT2hSU21RckVxb1psWUYyRjQ2NDNDU2YrUWZTc1lnVy93NTU1?=
 =?utf-8?B?dysvaG5NTWpIMWlUbVo4RVRvT050bHlYV1J0aUtaemg0M1MzQXoyRjQ3MFJY?=
 =?utf-8?B?alhzdUFBOGNkTGJleG04ZDhraS9BaFZ6MG9HQ251U1pvdXQ5Z1ZYQUI0ZGVo?=
 =?utf-8?B?Sjl4TmZLTFJQNjlCSzUxYWcvT3hDd0V4eU1EbjEvS09yNnhOamNpc3Y3T0dH?=
 =?utf-8?B?b3FSakZkeDlBamFmZzduSEcxd0Z2MWlyY0xlMTYrWTBITko3WFg5QkhyL3Y3?=
 =?utf-8?B?SS9zdThVaFVMS0ZzUE9zWFdsQ0hubEtCVXVJUTNmRUdZRnJvTGV3QVhvZURZ?=
 =?utf-8?B?MCswS3hCRkhwRCtMTElDOFVWZ3VZMmYraU4zaGlDS3VkMGM2MzEzMmZlR0FY?=
 =?utf-8?B?N1crTDB5ZDY2ZlhqNDNuMWI5Ti9LNWpqVU4yOHNLdzBmT2pkMnpLemRTZ1Zt?=
 =?utf-8?B?TlMxcWhZbVBRdWdIMmYvUkVvU25uR0V4MlNTdC9NeWJQTjcyYmVNTG1Dajhv?=
 =?utf-8?B?b0JCQjEyUUNBY3RReDFUd2RSNnJmbGxlZEdteDNKSlZXaFR1SWthcE0xL3BN?=
 =?utf-8?Q?hDt1Hg+IOw089GJDhmpAUmtnI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483212b7-a775-4d67-665c-08ddc2ccd064
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 11:51:48.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKrvUC1rb473x+SSnQzMXA9lZT3p/4vWBa0JWriwbd60LAaL0lXeHJ7eToYYfNMwjc68k2iNil5uROouQ9kurg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7969

On 6/27/2025 9:55 PM, Manali Shukla wrote:
> Add support for IBS virtualization (VIBS). VIBS feature allows the
> guest to collect IBS samples without exiting the guest.  There are
> 2 parts to it [1].
>  - Virtualizing the IBS register state.
>  - Ensuring the IBS interrupt is handled in the guest without exiting
>   the hypervisor.
> 
> To deliver virtualized IBS interrupts to the guest, VIBS requires either
> AVIC or Virtual NMI (VNMI) support [1]. During IBS sampling, the
> hardware signals a VNMI. The source of this VNMI depends on the AVIC
> configuration:
> 
>  - With AVIC disabled, the virtual NMI is hardware-accelerated.
>  - With AVIC enabled, the virtual NMI is delivered via AVIC using Extended LVT.
> 
> The local interrupts are extended to include more LVT registers, to
> allow additional interrupt sources, like instruction based sampling
> etc. [3].
> 
> Although IBS virtualization requires either AVIC or VNMI to be enabled
> in order to successfully deliver IBS NMIs to the guest, VNMI must be
> enabled to ensure reliable delivery. This requirement stems from the
> dynamic behavior of AVIC. While a guest is launched with AVIC enabled,
> AVIC can be inhibited at runtime. When AVIC is inhibited and VNMI is
> disabled, there is no mechanism to deliver IBS NMIs to the guest.
> Therefore, enabling VNMI is necessary to support IBS virtualization
> reliably.
> 
> Note that, since IBS registers are swap type C [2], the hypervisor is
> responsible for saving and restoring of IBS host state. Hypervisor needs
> to disable host IBS before saving the state and enter the guest. After a
> guest exit, the hypervisor needs to restore host IBS state and re-enable
> IBS.
> 
> The mediated PMU has the capability to save the host context when
> entering the guest by scheduling out all exclude_guest events, and to
> restore the host context when exiting the guest by scheduling in the
> previously scheduled-out events. This behavior aligns with the
> requirement for IBS registers being of swap type C. Therefore, the
> mediated PMU design can be leveraged to implement IBS virtualization.
> As a result, enabling the mediated PMU is a necessary requirement for
> IBS virtualization.
> 
> The initial version of this series has been posted here:
> https://lore.kernel.org/kvm/f98687e0-1fee-8208-261f-d93152871f00@amd.com/
> 
> Since then, the mediated PMU patches [5] have matured significantly.
> This series is a resurrection of previous VIBS series and leverages the
> mediated PMU infrastructure to enable IBS virtualization.
> 
> How to enable VIBS?
> ----------------------------------------------
> sudo echo 0 | sudo tee /proc/sys/kernel/nmi_watchdog
> sudo modprobe -r kvm_amd
> sudo modprobe kvm_amd enable_mediated_pmu=1 vnmi=1
> 
> Qemu changes can be found at below location:
> ----------------------------------------------
> https://github.com/AMDESE/qemu/tree/vibs_v1
> 
> Qemu commandline to enable IBS virtualization:
> ------------------------------------------------
> qemu-system-x86_64 -enable-kvm -cpu EPYC-Genoa,+ibs,+extlvt,+extapic,+svm,+pmu \ ..
> 
> Testing done:
> ------------------------------------------------
> - Following tests were executed on guest
>   sudo perf record -e ibs_op// -c 100000 -a
>   sudo perf record -e ibs_op// -c 100000 -C 10
>   sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -a
>   sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -a --raw-samples
>   sudo perf record -e ibs_op/cnt_ctl=1,l3missonly=1/ -c 100000 -a
>   sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -p 1234
>   sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -- ls
>   sudo ./tools/perf/perf record -e ibs_op// -e ibs_fetch// -a --raw-samples -c 100000
>   sudo perf report
>   sudo perf script
>   sudo perf report -D | grep -P "LdOp 1.*StOp 0" | wc -l
>   sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1" | wc -l
>   sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | wc -l
>   sudo perf report -D | grep -B1 -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | grep -P "DataSrc ([02-9]|1[0-2])=" | wc -l
> - perf_fuzzer was run for 3hrs, no softlockups or unknown NMIs were
>   seen.
> 
> TO-DO: 
> -----------------------------------
> Enable IBS virtualization on SEV-ES and SEV-SNP guests.
> 
> base-commit (61374cc145f4) + [4] (Clean up KVM's MSR interception code)
> + [5] (Mediated vPMU 4.0 for x86). 
> 
> [1]: https://bugzilla.kernel.org/attachment.cgi?id=306250
>      AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
>      Instruction-Based Sampling Virtualization.
> 
> [2]: https://bugzilla.kernel.org/attachment.cgi?id=306250
>      AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
>      of VMCB, Table B-3 Swap Types.
> 
> [3]: https://bugzilla.kernel.org/attachment.cgi?id=306250
>      AMD64 Architecture Programmer’s Manual, Vol 2, Section 16.4.5
>      Extended Interrupts.
> 
> [4]: https://lore.kernel.org/kvm/20250610225737.156318-1-seanjc@google.com/
> 
> [5]: https://lore.kernel.org/kvm/20250324173121.1275209-1-mizhang@google.com/
> 
> Manali Shukla (6):
>   perf/amd/ibs: Fix race condition in IBS
>   KVM: Add KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC for
>     extapic
>   KVM: x86/cpuid: Add a KVM-only leaf for IBS capabilities
>   KVM: x86: Extend CPUID range to include new leaf
>   perf/x86/amd: Enable VPMU passthrough capability for IBS PMU
>   perf/x86/amd: Remove exclude_guest check from perf_ibs_init()
> 
> Santosh Shukla (5):
>   x86/cpufeatures: Add CPUID feature bit for Extended LVT
>   KVM: x86: Add emulation support for Extented LVT registers
>   x86/cpufeatures: Add CPUID feature bit for VIBS in SVM/SEV guests
>   KVM: SVM: Extend VMCB area for virtualized IBS registers
>   KVM: SVM: Add support for IBS Virtualization
> 
>  Documentation/virt/kvm/api.rst     | 23 +++++++
>  arch/x86/events/amd/ibs.c          |  8 ++-
>  arch/x86/include/asm/apicdef.h     | 17 ++++++
>  arch/x86/include/asm/cpufeatures.h |  2 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/include/asm/svm.h         | 16 ++++-
>  arch/x86/include/uapi/asm/kvm.h    |  5 ++
>  arch/x86/kvm/cpuid.c               | 13 ++++
>  arch/x86/kvm/lapic.c               | 81 ++++++++++++++++++++++---
>  arch/x86/kvm/lapic.h               |  7 ++-
>  arch/x86/kvm/reverse_cpuid.h       | 16 +++++
>  arch/x86/kvm/svm/avic.c            |  4 ++
>  arch/x86/kvm/svm/svm.c             | 96 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c                 | 37 ++++++++----
>  include/uapi/linux/kvm.h           | 10 ++++
>  15 files changed, 313 insertions(+), 23 deletions(-)
> 
> 
> base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041


A gentle reminder for the review.

-Manali

