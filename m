Return-Path: <kvm+bounces-39885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D945A4C387
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D8716DBA3
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 14:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF8A213E6E;
	Mon,  3 Mar 2025 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xBNV4l+5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D9CA5A;
	Mon,  3 Mar 2025 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741012736; cv=fail; b=s7U/AiSmo+oPn89tHdoMOLbzCGL5lmpcO0Jycq/Momv/8wjWTirvrOby1Dog+mQn3H6t7TpJL1V3Mq2/SEPo6LVGguPYeeEjQ4xkBAJVWAR830iyQQ62vih5r0gZ69K/YRylqrTPAHS9/qf4pTpynXSqqkJwXJUnTlRxsrXNS9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741012736; c=relaxed/simple;
	bh=8+eCZjok4M9qs5zy5Mku0rXVy9TojchPdezV9NU5HrE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jRPUw4sWZfg3LXQAl99Y7Ec3Gf6q8F/cslBNxnjV4s+KdyXD9dFgNIOVBPuRsgNVXNaBQcUGs9/RGVtkttJuamQjwe0D+lKuszhct+MYcxeG3wlKFIXn7V23bSuOElbPghRRESv0wB3JQquC7xoZvfS++1zE+GDPnh9aVBdJYiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xBNV4l+5; arc=fail smtp.client-ip=40.107.101.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QPlLGahGTODJKx4suS06thy9nnNk5WbHMci8YKPbWX2FnXBSDc4EqXloZHNiF0VUca1RpgbmOQ4oifm99MJKD5zAtM1QZcB8+Q0tKj8bZXoA+dvidRH76c5ASpqdOcCsPZhfIVh0HT6W5Z14V2rq02EpkH51wwXsT9mSwyKY8/KSOJe58S7VYRLJaFF1nbY8KT4Y9qHxqgCtMz3XHGK529yxy5w5z7jjbuPblryGTQVIdak9kwNbjTB+Am/JZZkLGH1SvnP5KWtu/rAmgN7MMX6W4WdP35P9Hqp5tUxqiJN+bDkrHqAooNxfW0iqBgOKxp1eKm1yr7imcrv1Ryk1Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pu5H9Q/lcoVoyt28hdLpuccgEDngqw9Rxe06+eh+Cn4=;
 b=SuNwYGX3XxZ9A6Tx3+RI055vcWkiKpOjOPaByuge5FtFwzJQQj+raLqZ2tg3BB6ItL16m1Tg4XNPtuKy6m8kHxr8zME9ObUZoynrRaNozfY3znbqVg3vSKuugSMZ5Mt2MHbfm5mzqGUFP7A/tIzwaz4xH38v9pFXJAfLJDnA4GnNrryKijcD2AO1SxkLdK9O6fbZgZ1kvMIi+1KHjaG7cQS+rMH7SQwH1ogEEWtmKcXdrJpD/5qMLEaLzK3WYtVULGgkBs/Hwepd89fUjX/Q9/3WxmPGafEMYLQssbQo5CdYMz8WAvXMp5aAS3XvRy+ZHITmVv+3ZwDf4BTBSaehmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pu5H9Q/lcoVoyt28hdLpuccgEDngqw9Rxe06+eh+Cn4=;
 b=xBNV4l+515xADU+m5ZP2j7+lftqB5exP2h6ARm/vErKfyuLwCK9yRoWSgUCtGz5DaDc4mpb7+QcjQaYEg8F6cr7SSHDApmCB5fjzINjjhUUa8Jt5gzFpUJng4rs5OAnxRP2PiBkCa/hm9jZZBS07DTE51tgjz0UCZByc/oCZ1HA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 14:38:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 14:38:51 +0000
Message-ID: <1ff85a39-8c5a-9fba-45ff-f5fef54ea630@amd.com>
Date: Mon, 3 Mar 2025 08:38:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 1/7] crypto: ccp: Move dev_info/err messages for
 SEV/SNP init and shutdown
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <52a878930a84fa0d5905a26d230baeb0ce554fc1.1740512583.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <52a878930a84fa0d5905a26d230baeb0ce554fc1.1740512583.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0123.namprd05.prod.outlook.com
 (2603:10b6:803:42::40) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB5744:EE_
X-MS-Office365-Filtering-Correlation-Id: b7261d61-6be2-4422-36dd-08dd5a611d9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWx3L1VJZXFzQjZuTzZxSnRDWkxObTBGTGp1RGI2V21NWi80OWdYUERCQUpm?=
 =?utf-8?B?OGdLR29GekE2UWJIczhRaUE5M0VFL1NEeUFUWnFUelYzTERyUTNSeE54Z01s?=
 =?utf-8?B?bUduK2pOMnFFemRBbFZGUStpRFZ6czdPVDA1ZGdWWGU0ZVMzUkN5WmhRZXl5?=
 =?utf-8?B?ak84L080QjNnRDBVVUhSbFNETlJzYWk5ZW1BRnAvOXBzLzFEV1ZCK3lzNGZ5?=
 =?utf-8?B?RGpaMVIzY2R1bWdmcVJtcTd3NnVTZ0t1VUJXNGs0Z0poR2dud1llR20zOWpI?=
 =?utf-8?B?S0IzZnNGbVB5UWZnRWM5SVZWNFFTbWhHa3dHb1IzMUk3Wkl6RnlFbUU4ZTI0?=
 =?utf-8?B?KzhZellnc29PUmtCalBZQmdha1JMazFuRVRKbDBIclZEUEFSUTBOaXlvN3hB?=
 =?utf-8?B?eUMwSzR0M09YUHErM3YySW95c3lvaXphOXNJZTZCRmt5UVBHMXNDaHBYZ2Zw?=
 =?utf-8?B?dmloa1ZhRWsvcEg4bko0MmVYcEI4SHdiZmF5Y0hqVHFlODBYa2VEN253ZmZR?=
 =?utf-8?B?RVhCQzFPWktpdDI0SHpvRXV4QkJSWGVNYXZkZ1pxbjZ3QytkTDJ2UXF1S05B?=
 =?utf-8?B?MkM1cUdMSjM4NHQvZ2R6VnNpeksxSVpzSmptcEl4T3BsMy9RNHlKSXN3U1M0?=
 =?utf-8?B?ekMxeVpTOFowT3lwYjdHOUdHVmltYzU0MEpwejI3SkI5K3NpTElBZ2VLWGNP?=
 =?utf-8?B?cjRFTDUvbUp4ZDBTMzNncXlQOGdUOVQzeENxUVBxUDNSZi9zakJUb2FzTmVJ?=
 =?utf-8?B?NnFvZGJVQ2FPVU92RE53TVloeDByamU4aFNDTWJobXZERE16T2RXQ3pzYjhL?=
 =?utf-8?B?cDFYSGhaOC81a0xnc0Yvb2gwdlBocnY3b2I4UWR0bkJVVUJoVWhmOEpNeEVB?=
 =?utf-8?B?NzNjU3BFbHF1SUVWcU9PTXkzaFdVTGpaVFVMSEJMcDRtNFExakdRYmRZb1U3?=
 =?utf-8?B?ZUV4dTdXNEFXMGZEYzc4NmdHK280N0FxWnZSbHNSY1VweTl3ZmVZSjFnM3F6?=
 =?utf-8?B?TkhSSjIrMEVyR1gzQWljRTFJR294c2wvMHJMbUVldEFKdHBXYVlWMjNwdW8y?=
 =?utf-8?B?T25heDFUZTBjeUFuM2NhNG0xRFpmRFFvOGFZMkQ1YjlhU2czL1c5SkVrOHFT?=
 =?utf-8?B?dDlZVnd6VEw4elpUb1prOUNxM01iYU83WU1yZzBHNDRPam12UkxOVkJTSmRw?=
 =?utf-8?B?QjVaRm9tN2RBSmFQck5wQm9WcGJZcUhGYnNmQ2ZSL0U4YWkzYkFNU1d3aW5a?=
 =?utf-8?B?QnVMd2pBWXBPL1JXQXY5SW9uOW5vVUNZaWwvdEErdTRUWCtRTFVjR09jeTRK?=
 =?utf-8?B?UjVETmpsdFViTEplRkpNZEdvUm1sNDBoME44RHJHSTh2QlE0ZlZvWW4rb2Vh?=
 =?utf-8?B?U2VPdFNXakVTd2pHZkNnN05zWHhjYk9CNzE1Wkg5NUVXMnBCY01KbzV1d0NB?=
 =?utf-8?B?ai9BRUE2Q25rSmRwTVFxMVRMTnZTOVFPNXdZUW84Q2duL3QzOU9XVVN5VVVB?=
 =?utf-8?B?b1VxWkt4RWZ0YVpDMzBVOEZEZ0tCalhoZVVWajBEU3VLYk1KZkdzU1dYd2J2?=
 =?utf-8?B?eE1yd1J0R09LWXRkakY2Rm9HYlg3dEtKby9vMUhHTjJUKzM1RlU2VkpobjRS?=
 =?utf-8?B?eVJhdzRUTyt4aXpvQ2NmaENLUVh6MkVzU3A4S2lyQ1lBejVaSFlnS0V4MkZ6?=
 =?utf-8?B?ZkZheVJocE12Z1NYdDRIVzl0dmljcVpiNEhJWnB6MWJKVFhlTk82bzNsc25B?=
 =?utf-8?B?cS9HekI3U1FadmZmOWpPY3BaY056ZCtxR0JIeFE3MGNBNVBXZnFOcGVhL3Vq?=
 =?utf-8?B?QUNxWUZ6a1BIN0x4NFRFaHdCVjBkbG96Yk1FaFBaZlNVOWZnV1JaK3NiN1F5?=
 =?utf-8?B?VUxjMHZENC9GV2RtOHIySkFMQ2hqd2szZ0tYdHVBWWN1N1M3RE1sZGs4UXl5?=
 =?utf-8?Q?yS1oTZOdDz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2Z2aHZ3V0ppMlA1YmszZWtmOHBlWTdWOWw4K1dqZUpERG1xa1duZGxGSnhP?=
 =?utf-8?B?bE81U3lvRjhOanYxbTI0eXhjazZJWUZhcDRwOUZlWDQ5eG1kZzFpR29Cb0Mx?=
 =?utf-8?B?VEYzQ3ZxekprUkFDUm9VbWdhT1lrelpuUGpWQ2tycmZHTFkyYVpXWFZQRXN5?=
 =?utf-8?B?YzgwbjZ0ZzRFakNGZ250TTNhbFc2N3FoTCsxOERZM3ZpL0RTdk5IcTBMc1A3?=
 =?utf-8?B?alR6eisrbW5YUEZMcG1HaGdRME1sbk00QTFBL3dabFk4ZFpoa0x6V0MrbVc2?=
 =?utf-8?B?ZnBNRXQ5VGJvUlRJV2o1Y25jS0dHYWJCUmc2NHJEZThiZVM2M0xTcVpEaU5C?=
 =?utf-8?B?UXFCK1VKdTdyNkJzY25wUE9kaER1K3FpcFh5MVpqUUczUi9MU3ZZZHpJRzI1?=
 =?utf-8?B?ayt4ZGF3SldKUkpSVzBBeURvdTFsWTFBRXVTa2hSVFlpSmdVdVQ3QUlXc20y?=
 =?utf-8?B?WHAycUFCWXRMT2QwR1JYSjR2dGpYVkVrMXNuWGtFV1djTHg3c1ozZGo4ekZi?=
 =?utf-8?B?TTRGQndWL0pySlJUejlwRDlKUFppRWhFbnNaVnN0eVVXa0VwWnYwbmFQd3l6?=
 =?utf-8?B?czRhV0ovdldXZXNHaGQ0V01WdUlISEVaci9FOFBaNVlIN1NRam1qS0syQnV1?=
 =?utf-8?B?MkU3dFFOMVNTc1hseWVMQk0zMkh4WWtLTkdFTkpOQmQ0THp6T0liSVNBVVB2?=
 =?utf-8?B?ZWttZjdJTld2UitoQ2dmV0NNQStKMzc0dHJKY1FPMFVxZjllYTlLNGtnK010?=
 =?utf-8?B?K0ZRRlBldlJFc3RXNG16a0laT2dxaEFxU3pHdHFDVnN3cERvMm45UXFQRXJ0?=
 =?utf-8?B?YW5HWGlHZ2orNGJaWkZxbVY2RmQ4S28rRk15MGltUlZHY1d1Ukw5UVJvc3hu?=
 =?utf-8?B?Yk1kaHZTcHZkeW56NE1wTmRtTFBWQUVXcXdVU3B0RnZVd2FKNFU4eEFXa0Y5?=
 =?utf-8?B?ek0ySTZ5VlNWai9WTUNqL3liVjBFZ3hnTnFzWEcrY0ZCWXMzUFIyZnNVdUdB?=
 =?utf-8?B?cElFeVRpYS9yVEo4RzY0MVJuYWV3RXpBaGkvbW9hbXB4Z3JORlYvY2x3Rldi?=
 =?utf-8?B?dTdFaE9KNmh3bWJ4MGc3NnBNRFFxcXBFajVuR0drb0MxaWN0NVVTclI3NUVz?=
 =?utf-8?B?WndZU2ZkQ1dCdHBvUE41UFpyT2dYRi9xQWVxZTFaNmg1aXVRMGdCMVFtZ1Ur?=
 =?utf-8?B?UkU4MkRMSm9YV3IxTGsxSWxKY3lhTGFaZXVBTWI1M0VBSXRYRHJkQ01hL2lE?=
 =?utf-8?B?NVJXSVd4RkxzRDdRQzNlbGp5R0NSUm84ajczZVJrTTk3bXdSd1djcmJCWk4r?=
 =?utf-8?B?Mm5qbThXWnZ4SFptaVQ4UTJEWDFsdXRCbEt5d0dKYjBnUmd3Z3VTT0doK1Ri?=
 =?utf-8?B?elFCWjhvZXduV3BnTDRYNWFnUkg1bkRGMUtGZXdNVE5IaGZ4NnFDeG94b1pF?=
 =?utf-8?B?TmE4MVZ2UFdxTFp2NmVBck5IM3VMbHJGalNMVGRkaGhUK0VZZEpabHJIV1pi?=
 =?utf-8?B?MzhmL09wdWc1VTVKdXF5Y0ZUOUZUcjRBQzhLYWRHcG1Ra0tHSGI3OFRtazFR?=
 =?utf-8?B?QlFHSyt6ZGVxNC9wOFVmcEdUekc5MUR2VVpGM01yZDIyWVZnWDQyaTlKMVYw?=
 =?utf-8?B?SFpNN1FJaE1kUVVCb2VNS29WN1VNdjJFdUw3S3NpaThydklkeXA4YlptbE1Y?=
 =?utf-8?B?aHBNRi9pdjdxVzVRRldIMmI0dWpSVE9BK29vUjY2N3g1NURSRmp2VGM0NDZO?=
 =?utf-8?B?QTZQU1YyY1ZBVFBhTjhWNU1aazB0VmtxNkd5dnpLeFE1TDJWKzlFS1dTanQv?=
 =?utf-8?B?NUNBWFNJcWJBWTRyNlNsREtkeUJsb0dJcGY5bVlFNi9PM3FTcS8rRkJzbG51?=
 =?utf-8?B?STdWT0U0TDNDdUQ0N1ZsS09YcHhXMVVOcjBpdE96ZHBRQ2w1S0QzTEpRUm1E?=
 =?utf-8?B?eUF0Y1JpaE15YUFSbSt2UVFLU2VMYUlHbDVIalozb1ovRy9KUUVHMGM2U0ZV?=
 =?utf-8?B?NmtuS1JNc0FTaHhHWXlqT1VlTXEwZGo2WjczYmVWL3l1WUNYZnlFWVlpTmps?=
 =?utf-8?B?UU5PUUFNS3JkY2J5VXJOWjAwTDdUU2lqcSsyWXBBWHM3bzZYaFdZdEdXb0Mr?=
 =?utf-8?Q?2PQuMZPv6YpgqCviOfoYrLHtb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7261d61-6be2-4422-36dd-08dd5a611d9b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 14:38:51.3425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U91FqqfLpJDXNabJiA91AMYQ26xcJC76F/UaBQhTG6fs4iR5elmOsgkXC2WqN8X/TDaRm965tGoUYtcY7OfSGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5744

On 2/25/25 14:59, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Move dev_info and dev_err messages related to SEV/SNP initialization
> and shutdown into __sev_platform_init_locked(), __sev_snp_init_locked()
> and __sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() so
> that they don't need to be issued from callers.
> 
> This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
> to call __sev_platform_init_locked(), __sev_snp_init_locked() and
> __sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() for
> implicit SEV/SNP initialization and shutdown without additionally
> printing any errors/success messages.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 44 ++++++++++++++++++++++++++----------
>  1 file changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2e87ca0e292a..8962a0dbc66f 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1176,21 +1176,31 @@ static int __sev_snp_init_locked(int *error)
>  	wbinvd_on_all_cpus();
>  
>  	rc = __sev_do_cmd_locked(cmd, arg, error);
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV-SNP: %s failed rc %d, error %#x\n",
> +			cmd == SEV_CMD_SNP_INIT_EX ? "SNP_INIT_EX" : "SNP_INIT",
> +			rc, *error);
>  		return rc;
> +	}
>  
>  	/* Prepare for first SNP guest launch after INIT. */
>  	wbinvd_on_all_cpus();
>  	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV-SNP: SNP_DF_FLUSH failed rc %d, error %#x\n",
> +			rc, *error);
>  		return rc;
> +	}
>  
>  	sev->snp_initialized = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>  
> +	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
> +		 sev->api_minor, sev->build);
> +
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
> -	return rc;
> +	return 0;
>  }
>  
>  static void __sev_platform_init_handle_tmr(struct sev_device *sev)
> @@ -1287,16 +1297,22 @@ static int __sev_platform_init_locked(int *error)
>  	if (error)
>  		*error = psp_ret;
>  
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: %s failed %#x, rc %d\n",
> +			sev_init_ex_buffer ? "INIT_EX" : "INIT", psp_ret, rc);
>  		return rc;
> +	}
>  
>  	sev->state = SEV_STATE_INIT;
>  
>  	/* Prepare for first SEV guest launch after INIT */
>  	wbinvd_on_all_cpus();
>  	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
> +			*error, rc);
>  		return rc;
> +	}
>  
>  	dev_dbg(sev->dev, "SEV firmware initialized\n");
>  
> @@ -1329,8 +1345,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  		 * Don't abort the probe if SNP INIT failed,
>  		 * continue to initialize the legacy SEV firmware.
>  		 */
> -		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> -			rc, args->error);
> +		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
>  	}
>  
>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
> @@ -1367,8 +1382,11 @@ static int __sev_platform_shutdown_locked(int *error)
>  		return 0;
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
> -	if (ret)
> +	if (ret) {
> +		dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +			*error, ret);
>  		return ret;
> +	}
>  
>  	sev->state = SEV_STATE_UNINIT;
>  	dev_dbg(sev->dev, "SEV firmware shutdown\n");
> @@ -1654,7 +1672,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	struct psp_device *psp = psp_master;
>  	struct sev_device *sev;
>  	struct sev_data_snp_shutdown_ex data;
> -	int ret;
> +	int ret, psp_error;

Move the psp_error variable into the if statement where it is used and
name it dfflush_error.

With that,

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

>  
>  	if (!psp || !psp->sev_data)
>  		return 0;
> @@ -1682,9 +1700,10 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
>  	/* SHUTDOWN may require DF_FLUSH */
>  	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
> -		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &psp_error);
>  		if (ret) {
> -			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
> +			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed, ret = %d, error = %#x\n",
> +				ret, psp_error);
>  			return ret;
>  		}
>  		/* reissue the shutdown command */
> @@ -1692,7 +1711,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  					  error);
>  	}
>  	if (ret) {
> -		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
> +		dev_err(sev->dev, "SEV-SNP firmware shutdown failed, rc %d, error %#x\n",
> +			ret, *error);
>  		return ret;
>  	}
>  

