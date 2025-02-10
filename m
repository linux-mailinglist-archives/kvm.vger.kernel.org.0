Return-Path: <kvm+bounces-37750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E2BA2FC70
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B00071886FA4
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBEC2505D3;
	Mon, 10 Feb 2025 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dlK4EWVH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF2724BCFD;
	Mon, 10 Feb 2025 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223445; cv=fail; b=TU0oaYyNYq/rnnr/eOQ2N6jUGXplY/Fjks5dmzqDME5jI07MJhUu3Kx77Ki/TfKp2IpKvBeRCUEchRe9cHAx0jcG1wnLS25R34+5Ys0Nlv1jTrtHzphMC/sGYH3irGkpbtg1xHiL1LKxviaXW445+kkpSsNf5bTuATXngWOLa4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223445; c=relaxed/simple;
	bh=F6a3tICUMOvbmnUl/Bdwk/expQ5eTEEIi3WOtvyshL4=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=rA36YjfBVHDiCB5JoL/F0no7iWmpYlIY2c9thXoE7qy+bJjsIoOwwRhKUguhVpVa2JzTgc+nS2U9rXY3VLMPaNIKaZ1A8lDXy4zzwfg79PCuH46GizrMj9oyQz8/Jc2FmXHTsPUm8ARNwdoz/03o/tr+B1QdjgOEnOFzFICe7kY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dlK4EWVH; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h42UIRRcHp0TWWG8dxwuWF+NooBylyR3AqngD8ctnZoL13KOA3i5XivbUBjL7NXtUvP6bV7Wf6bQJTdNZv7htetIZOtvt2z+IlSsvVJ/wvOW3ecyRPFvwxADlWEX7mKLqm20fsAC6acJ+1DmTJ6QmW5NKnBhfz/xpr/vsgwUUubKQWBblbh6hCb6TgkONEeAKoiwauOtDB+fgwH4SRQiU7argATsbm3dlZKERYOHEbejYAGcNvhPCmqX0/rHR6aiiTj+9cdty+Ry2SORtfZB1hRIA4l+jZcml5LRD4GY31Lu4OgX1jgo7Sdq/nzOWgCn3Sf1LlLL78QqFVys38YtXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+e+pXKAGpb0LD8hVpN3dLDHbKdCRDuv/KSXG2tWrxY=;
 b=vaFqXIXFcWdsL358UlvUdZ669kobzWxoH3FqiAobmhDtGffF5E3+V9jIbOekWoFyk5RNzaVpIh4K1T3q/nnhh7BIHZ20OeSo34xPC0qPsWB+4D/xcEH+z8EcgIVhSw+SZ6KIHFlGxAPC9E/G9AcnBghYuG6uV2oP8pcD/v0wT1rRFK4nV4nfpUB5kHQtvGyTDerOPvNTN5eVkky4lQJnycjjXep0Keqt4Kivv8g+U/yHKmpcLRZ7w6KOHJ5v0VjjWgf2PRXgHLpeWqjcRRpuqc2MNXnYWkf92G+sDPujkgnTpy8Q3tp4LmtiyhmwUDrOC+G1YxG7ep/Hw03tY/iWcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+e+pXKAGpb0LD8hVpN3dLDHbKdCRDuv/KSXG2tWrxY=;
 b=dlK4EWVH2Fv7cd8MvpOXJ6MCcvW7CpmMb2YBEpAV2nKxHuompCRpWkEk/V20ygdXf2iEdvZKZkezjRbzPggyKOEnx2S7DhTOiAWMjFbAEvPqJWzOS8WYLdF3k5LyOLQLZ18oJcn/78Neun+a00lIp0OzNgh/0hhF+MfGiV1dY5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB6988.namprd12.prod.outlook.com (2603:10b6:510:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 21:37:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 21:37:15 +0000
Message-ID: <2e9a8f42-11c1-bc7f-78d1-4d0c50058c87@amd.com>
Date: Mon, 10 Feb 2025 15:37:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: yangge1116@126.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
 21cnbao@gmail.com, david@redhat.com, baolin.wang@linux.alibaba.com,
 liuzixing@hygon.cn
References: <1736576122-9818-1-git-send-email-yangge1116@126.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH V3] KVM: SEV: fix wrong pinning of pages
In-Reply-To: <1736576122-9818-1-git-send-email-yangge1116@126.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0128.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: 535addbf-c4c3-445f-96af-08dd4a1b1651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFM0SnptcnRsWEdadDNZcVE0RUpsRmxOY2JyQ0NxSTVWVktiU3ZGdW92TGtW?=
 =?utf-8?B?NUk0bHYxY0dpblJPVTBMTTVZQUZNUU5CU2Y0NjlQeXh6eitiRHVJTlVrSjR5?=
 =?utf-8?B?RW0za1JvQWJiYWVhcnE3RkJYUjFUNXZwK2RmYWNYdTZ2T3FxLzB4b0Fnc2lw?=
 =?utf-8?B?SHZEbkZNbWtObCtKWUYzbkEyTjdXUGFLZ1dZU1pKQk1GWUt1L1c4NENXWTJC?=
 =?utf-8?B?alYzbG1mTVNSYXYyMHJDUnRQdjFOdlJ0eWdjN3Y4TEVJc3hUOHVOQU1oT2Fo?=
 =?utf-8?B?SXpxZ3FNYjJsbnhicEhxdi9adEkxVS9nMlpmMjZhWE5VM2pvdkNrSG5yVStE?=
 =?utf-8?B?RmVZUXQvYWFqbnlsL2dxUURPR3B2dVJUNXFwTE9HVWFIdzUwMkJLTEg2bVg0?=
 =?utf-8?B?U3FnL3MyVkZhSVJBQ0tnYmsrVGM1NEwzM1pBMXRYdUZIbE5hWDFRZUJHRDVU?=
 =?utf-8?B?MXZVd0pmclFrZXl3Z0oya2lxQzlhMjExSnREejNsbWMwM0JhSk9Edks2bk5F?=
 =?utf-8?B?UnYwVGZ3YWJWVGlPc25CK09lWmpMK2ozVEF1RFJEWEtrRTMyNk8vQUdTbzdN?=
 =?utf-8?B?SXBtS1I5Qmt3cXByRTN6Y1dscnJ6VGRESzhJZlYyS3EwcWZsQUVDR2JPYyts?=
 =?utf-8?B?bENneTljcEJkN0dCS0xRenIrR0Yydy9lUS9EQ1Zta1pPM29IRjd1UTJvUVI0?=
 =?utf-8?B?TmFUUWxFTXlidTQxZWplaHExK1RRcnl4Y2ViOC8rODlBRjhYTjF0ZnVkdnoy?=
 =?utf-8?B?ZStRdlo0N3AxcUoxa25ZWnBTNzNoaU82VE1McW5KdmRsMUFMVXoxK2RDS0Y3?=
 =?utf-8?B?WEZ2VGxMTjBlVk5WMnk2eUtYYVgwa2tJc0VmMEFjVC9ISjVvVmJuQWQ5Mmsv?=
 =?utf-8?B?dG53aVNKWmpTUWRjaStWa3dZc2pPaUl1aWRUcmUxd0lwQ3UxOUZWaFNYTSti?=
 =?utf-8?B?MEdRd29ScENVd2d2aS9zdy9kUWZoWXZuM3ZSdzJhdytKRkxOMFRqMUtwOExV?=
 =?utf-8?B?Q1RaaENFQjE0Mm9XRkVwRjFhb3VUeUlrWDI0WmlHUzY5eFcvZ2Zucm1SMEh0?=
 =?utf-8?B?U1gxemJ4OWRlRkFkaXJrRjhKNWpuMk9sd2R3bW9MNXluR0NXdjFSRURiUG42?=
 =?utf-8?B?dVl1N0w5NWJSRE1KTXU4eXhtay9QWVkxYWpRV2N5UVovVS82YWxyNjZDME4w?=
 =?utf-8?B?Nk9aTENGanFLQkpjNUpabFNLcVpSM2FlbHF5ckwyVVBxNGo0QVE0K0JsdkEx?=
 =?utf-8?B?ekIwK0h6QXlpdlkyYS9MQUZWQldTNzVIUFJTSHdTcUt6YTJvcVlxQ21rcnpJ?=
 =?utf-8?B?dTRZZE5Pc3RrM3ZiaFdLRW9URkNwdllsVkFsSjZWZVdUblZlcE5UVmd0ZDZ5?=
 =?utf-8?B?T2tlQzQ5V0FnNG1oU1dZM2NoK3VwWnVweFdaTUtTbGtiUi9jM0NXVSt4dFdn?=
 =?utf-8?B?bHhWRTQvUmlmVWU3WjhGanBtWEZlRHBDdHRKNnJRc2VUZWVDZ0Z1bnZZdHIx?=
 =?utf-8?B?R3h2dDBMejd0aU1HcHZjNFBhVXZKVmdZTkZiTHpmOWFuTVJNeEdiL1ExZTFl?=
 =?utf-8?B?OSs1MjFmVHAzejZ4R0ZrOWdYWnFKK20vdnExTzZHRHJFUFRxSG9tdW0ybnFN?=
 =?utf-8?B?M3Uxbms1S0tKSHpzNEVRdnE5OVR5eTJGNEFJd0Nhdi9iazdEbk9XUVlNbGxN?=
 =?utf-8?B?S1ZsWnFHQzJhSFUrU0JzeE9iU2VlazBVVEVRMFNGeERTNlZXV2NrVkNWTHE0?=
 =?utf-8?B?RHZMY2luN0FBTURjZWdSYVpNQVowTWdveXpMMU9STUdqYy9MVzUzemovQnBS?=
 =?utf-8?B?K3dUSTU4ZGN2VjByaEYyV1hWUnZHdDRjYm9xWHJHeE9hMUQ1K2VjekdaaUxi?=
 =?utf-8?Q?NrgH+qdvdHJFp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1BpQmlVYW53NE9wU1FPYk51c2dKb0ppdGFWUjViQ1VqalpmKzkxSDlVTVhv?=
 =?utf-8?B?YmRtTjg5RFZwVmJ0SVFHYTYzc3k3R0FNOTJMSzhSL0phM0w3UDllZGNtcGpI?=
 =?utf-8?B?QVVpQ21mUThUUTUxbzdLVHByTVNTMHB6QXI5cFhSMUhyTTJhTnpyZElreFVp?=
 =?utf-8?B?bXc5T0U1S0N5V2VMNVFVbXBaKzA1eGwwSmoyaEhHb1QyUVFCSitvaHdBRWpN?=
 =?utf-8?B?ekJBTHFTRGxXcGxVOVRGdXc5OXJvTlB0cE8rQTZEWHFGNmQ3eHAzWWRjenpG?=
 =?utf-8?B?QXBPYk5ETnFyV0JWbFVJUHdBTGlCQnRRRUxYczlxbFp5OWhWcjN4NmgwbjhV?=
 =?utf-8?B?ajdYU1p3M2ZPWXBudGhPejg5UEJoaW1XVmRzd1RQWEpVVXZFUnNhRkV1UVpH?=
 =?utf-8?B?WERMSXBNeFVSUE9XOXo1bUFzLzlWVUdYcFRwRXFLVDN3REVjemswYjhmNEpN?=
 =?utf-8?B?TU1oVDJwYTN6TzJPc1g1Tlo2WlBKb1oya1ZPTHg5bVpUemgxK1A2WkFSNFN4?=
 =?utf-8?B?ajJNUXJNUDZIdDBJejJ0Mk5tNXZhNmZ6ZG1rTlp0SGMyQ2NVd01iRTNVdEhl?=
 =?utf-8?B?bytIUWMwdHNVM0NMbG53WmJjcFpEcklmOHdQT3NtRjlpUnVvU2NmSzNPNXJB?=
 =?utf-8?B?ckRUckVrRXQwenlSdyttS3VIbHEvYXZhb1ZjcDd0K25yZTRQYjMwbUdTWTVX?=
 =?utf-8?B?SGlzTUczYVNuVDJvb2tQOGc3RkRjMlZMK3FkZCtEdTNTUnhXWVI3ODlvU1g4?=
 =?utf-8?B?d3h2Vm9BWE1SYVZSeGR1Mkpqbmx1em5wNHZSMzU1ZzVoSzdENVlBLzRyWXZs?=
 =?utf-8?B?S3Q5bWhLUFpFS3ZrR1daMjBzaUdHZEZNeUx0QXdBKzNrMm41UjkvNWx3dDlx?=
 =?utf-8?B?ZGkrVU1xcWswYThZWm1JWXl3OVQ5aldLdmllOUNYWEh4Q0dtOXpXMXpuZWwz?=
 =?utf-8?B?b3RVdk1kVHphRnhSUTNyQUJDWTY3d250WmcrK2FzTUpKYXZyT09IU0t2YWRq?=
 =?utf-8?B?RytLTlFWZGtaSU91SkN0UVI3Z2lXZmdwYmJpTitSejNtaTFxS0dwVEsvV094?=
 =?utf-8?B?S0ptMVBIckFQY0c5T3BsamMxS05vczNZdG9iMVZFZzlVeXBtQk5aemJOYjFr?=
 =?utf-8?B?Q1BibnlxN0luMXY2SnV1bWdDNVQrMnFCa214YWNvRmhYQlY0UEJCUFJ2YVcw?=
 =?utf-8?B?Wjl0T2U0R3g2dFM4TW5WRXFvYUFZNVpvK1dCWCtXRS9RMk5mVmUrWGhHY3Jz?=
 =?utf-8?B?eVFpL3ZWSzNhNWx2MUdxaW5Ga20wY0RmTExXNGI3TDhKV1I4REg5SFlIbEZp?=
 =?utf-8?B?M1ZQcDFEUFpnbERtQTZ6QkV1aEFodk5IaFc2V2xtM1VGWElSWXViZ3hhK090?=
 =?utf-8?B?R3FWbUhFZzIyeHE3eEtCMFFlZlRiSWY4TEp1b213WXppWGsyM0ZzbkFjMThS?=
 =?utf-8?B?MzJBbUprT2o2b2ZyUU1jL2d0RkVVQURVM2xROVJXd3ZVVGZ5bDJTRGtTTWY5?=
 =?utf-8?B?cTFXckROMFBJM2JDRnNZZElnL1hQbzBHd002RkRocWkwbjd5eHA2aFRhS1ds?=
 =?utf-8?B?OTJmTWUxOGE2QmVsQTYyWTBTcmpPZTZZVnVBUWtjai9Oc1NMZkFHL3ZNS2th?=
 =?utf-8?B?cklWVnBOdlpaRUxRNkhHczlRMEZhbUpSNXhYN2MwUjczQUdCV0x1U2hZVUVw?=
 =?utf-8?B?ZDNINENnMHdVZC9hT1E0ZFBzUE43aHJtMTFIVkxJRlppZWhFZnFsVGZoVHFS?=
 =?utf-8?B?TDVQMHArU3E4N2VrV1NwbFY3Mk40USt0TUxZYzcxSU9icWVzNjZmU2NTMGNn?=
 =?utf-8?B?NFgwTE1ISjBoSjBaZVhlNzZXQWVJTTZsUlU0ODNOMi9pZkJpTmxUa2h5QTlQ?=
 =?utf-8?B?TEpMVlVwRnpvTmFPaHVFdmJVNFBnR0huWUNxT3o3aklOcnJuRTNqOWZSU285?=
 =?utf-8?B?dCtkeTJLY094aENveURTQTNXbWhZOTl4N0tVRnI0QzNLbUtDYWp4Rmc5MjFo?=
 =?utf-8?B?b1VYVDVxMTlrM2hvenZINHFJcFhuU25EWXBjb2YybmFvbTVRRFA4RlptRUJm?=
 =?utf-8?B?dDY3MTdVck0vNHpjekFSRC8vTVZrazR0dFBsRVdsUXZqUVdtRVVoM2swdXpB?=
 =?utf-8?Q?dCVVfERnD90SWGE/uGXKl9jXl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535addbf-c4c3-445f-96af-08dd4a1b1651
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 21:37:15.7298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLQMw+qTDUXBSGo7BK5yP4MfIHe5XJ++TsJJnRE4NXm9extStMgLAC22ZtdBJZOeBW5OeUMeDt2bCwflFu8cdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6988

On 1/11/25 00:15, yangge1116@126.com wrote:
> From: yangge <yangge1116@126.com>
> 
> In the sev_mem_enc_register_region() function, we need to call
> sev_pin_memory() to pin memory for the long term. However, when
> calling sev_pin_memory(), the FOLL_LONGTERM flag is not passed, causing
> the allocated pages not to be migrated out of MIGRATE_CMA/ZONE_MOVABLE,
> violating these mechanisms to avoid fragmentation with unmovable pages,
> for example making CMA allocations fail.
> 
> To address the aforementioned problem, we should add the FOLL_LONGTERM
> flag when calling sev_pin_memory() within the sev_mem_enc_register_region()
> function.

Seems reasonable, some minor comments below, otherwise:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Signed-off-by: yangge <yangge1116@126.com>
> ---
> 
> V3:
> - the fix only needed for sev_mem_enc_register_region()
> 
> V2:
> - update code and commit message suggested by David
> 
>  arch/x86/kvm/svm/sev.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd07..04a125c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -622,7 +622,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  				    unsigned long ulen, unsigned long *n,
> -				    int write)
> +				    int flags)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	unsigned long npages, size;
> @@ -663,7 +663,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  		return ERR_PTR(-ENOMEM);
>  
>  	/* Pin the user virtual address. */
> -	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
> +	npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
>  	if (npinned != npages) {
>  		pr_err("SEV: Failure locking %lu pages.\n", npages);
>  		ret = -ENOMEM;
> @@ -751,7 +751,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	vaddr_end = vaddr + size;
>  
>  	/* Lock the user memory. */
> -	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
> +	inpages = sev_pin_memory(kvm, vaddr, size, &npages, FOLL_WRITE);
>  	if (IS_ERR(inpages))
>  		return PTR_ERR(inpages);
>  
> @@ -1250,7 +1250,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
>  		if (IS_ERR(src_p))
>  			return PTR_ERR(src_p);
>  
> -		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
> +		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n,
> +					FOLL_WRITE);

You can keep this as one line.

>  		if (IS_ERR(dst_p)) {
>  			sev_unpin_memory(kvm, src_p, n);
>  			return PTR_ERR(dst_p);
> @@ -1316,7 +1317,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
>  		return -EFAULT;
>  
> -	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
> +	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, FOLL_WRITE);
>  	if (IS_ERR(pages))
>  		return PTR_ERR(pages);
>  
> @@ -1798,7 +1799,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	/* Pin guest memory */
>  	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> -				    PAGE_SIZE, &n, 1);
> +				    PAGE_SIZE, &n, FOLL_WRITE);
>  	if (IS_ERR(guest_page)) {
>  		ret = PTR_ERR(guest_page);
>  		goto e_free_trans;
> @@ -2696,7 +2697,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
>  		return -ENOMEM;
>  
>  	mutex_lock(&kvm->lock);
> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
> +	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
> +				FOLL_WRITE | FOLL_LONGTERM);

Need proper alignment of these parameters.

Thanks,
Tom

>  	if (IS_ERR(region->pages)) {
>  		ret = PTR_ERR(region->pages);
>  		mutex_unlock(&kvm->lock);

