Return-Path: <kvm+bounces-28567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 114699992E3
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 21:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38BF4B26E96
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 19:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B3B1DFDBD;
	Thu, 10 Oct 2024 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JDYgXHza"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A8B1CDFC2;
	Thu, 10 Oct 2024 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589202; cv=fail; b=h6p8ebHCSukyPp4BBIRKKnXr2oYcnuo16ZL0ftD31gzxuzCIMUybs09ZxfmKfikFqqIp3eltpGxZpjsq1c5u06tbySUmhKjkfkFevJe56zxFn8wMNDCSdilJmJqGHC2coO/uW1eYKB0jgo4MMJO+lk/YBwrqUQpzmWa32n/Rbns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589202; c=relaxed/simple;
	bh=ZnNXPcIzf2GefdO2D7R0q//JsFn6umCznQoKypLgXog=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cd60wuqFLjnw5MWb6V9ZwfPnya0fsFVGteThE/a+h1P6icisvhSAz1g8m/Kjd/hXSklllDuM+pTBBujwVDZ8iXS7bRFb7QPMeT8UrBUcAtH4SXdMegNHlapIvMJ5V4tWMTK4IVQb7K7GL192XadpbaYtb2LGXMS37HEqH+s//ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JDYgXHza; arc=fail smtp.client-ip=40.107.236.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ui3vIlbCOrKi1Hw/hwnTVGx3mfDpeRN3M3LhTIuDNyVGFelhatBhPxuauZehYEo/s2lnrynGSE+/j4huEf3P3h8q4AoYj+0bB+XtfjDuHYkvCLO0DVHKgW5kTyIdaOiuKz5lSZ3DOfiN5oS0z1QwqrlEjJM2zmhyxXOZ5aDQGuF47zjdjTxjkC0nRz9v7h1twhgXvaQoTA0S/EYvh9U1bBYF43Lfx7GlZbLHtmBvlb+0td4snlvlvOdqEabdXEgZdD3Kv02dYQEA83/0h3bCZhM8Tc6Z5cMK8FVVRhi06nsr9mxsYWU12m9gvexAM5Cu4Ouab0lvGOQlcH4i3SgLKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ar7XAd3b2t/Pcnja0rqNfGA5JM2Qhm7smZmUs4a/RAE=;
 b=Suz4c0Ck8iIzaBcSUL4TBGn/u0xQD89mC+Jgz+EmCjveagvZp+cFyhrzQjFmzKS7A4IWqDy5A2ghGmLdyr1ostN+0wSvGuBET+n0lLBuJjFz8+UYiwJEEJ1ykWI+PHLt4YfEw+Djp8wRRImPUxNzcd+EUM7lXfCZjnC35qv8L4ikakeaD9tz0FDQl0/R++2OsSmaSl0hU656KO05JUyfx1q2aaBYrzeyxAqfndneUpG6oef8RyOxeAkN1rVkns6vPwJMeFCfxseWm6gNsWj30YIxj59G000I5BJPL4968xV2974zYE1n2C9pGZde2j40yaJC1pSeaBzFC0xKxw1t6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ar7XAd3b2t/Pcnja0rqNfGA5JM2Qhm7smZmUs4a/RAE=;
 b=JDYgXHzaIIjNkwN73KZkSRSH+QaQ5QUTG/nb2XQHvPfy/g/05U/JxKCxtlfJg4cXn9+WTeXF5itYelIyKAzAV1jWFklifhsg/0+xhKY5OZjOVSeq5pJSQAKc9nXXPedLbxbnP7x3kRD3tl4JZnsRTJviJ9JEHgB+eyQSX2DhkcY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8494.namprd12.prod.outlook.com (2603:10b6:208:44c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 10 Oct
 2024 19:39:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 19:39:55 +0000
Message-ID: <72407a44-fb70-52cd-a231-c80fd81e0fa3@amd.com>
Date: Thu, 10 Oct 2024 14:39:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v12 14/19] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-15-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241009092850.197575-15-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0037.namprd04.prod.outlook.com
 (2603:10b6:806:120::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bde2771-215a-46b8-6a94-08dce963515d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlZWc1M0eHdpUzh3M3ZQWEJuWkh3TGNTMzJnRmYvdFFEVlZiMTlRSzFLR1Ny?=
 =?utf-8?B?ZDFZNUxLVGh4YUFOdmo4dm53WktJRzhURlBZUUFxZWVJL1RUYW1sZ2tWTGla?=
 =?utf-8?B?MFM5VXo2QjVheWgxbnhYMHFwazZoWE1zOHJ6L3IyaXZpbUJwZzExNnRmaXVo?=
 =?utf-8?B?cGYxaTRvd0UwbTNZL2ZRRnIvckU4MWozd0k4bU9pdmorMGgwMlNiZno0enBy?=
 =?utf-8?B?MHFiaFBSMzJlKzdiOFVGZklCSy9kWEpJUk14ZGlkajVLN2FObEhjTGZzTnpr?=
 =?utf-8?B?ZE5BcDZZWlVQNTNKMjhUQkN4ZmNTWFNid3h2VnFkTzc0NExpUlp4cU0zcWZU?=
 =?utf-8?B?eHZ0K09TUkJzNWxVcTA5S0JkV0toNlY4VnBIcDN3RlcvbTI1cEZXWFFud0Rl?=
 =?utf-8?B?cU5PTXhMNldOUzR4S2NlWFBxTjdyQzFtMDhacHpBUUdud0JGb3JQZVNKL1N0?=
 =?utf-8?B?cjYzaWhLazkySlVSVFZHM0krWU9qRlh6cE1FbklLSWpEY2tiMHJKbmZQUHBS?=
 =?utf-8?B?aHFjMElreC9wVUJCMmQrUmxXNjQ5RmVCcUpPcTk3cWdnQkRYMFBRVGJheFFE?=
 =?utf-8?B?QlArRkJMdGwwYlIyb1VmNEs5ODJLUW0vSVFpRkZwSGJEa2t3TW1XMll3dFBO?=
 =?utf-8?B?VEttei93bU5oUUZFS3g4ZXoyNDBJNjZkaVAzdFptYjQrODZwOWlwa0V4T3Iy?=
 =?utf-8?B?VXRCNm9aK2ljbU44N290elF6UVVnYTdkUkVzaDN4NHJFSmRLRVBkZ2pXZ001?=
 =?utf-8?B?NnJ5WTg4bVFRTCt0Yk1mYk9ZaHVoK01seUp2b1g5MCtRelZrK2liZDkrRFV2?=
 =?utf-8?B?dElHaXRJb1VpYnhVU0dUdGtLUXA3S0RETmFEbXZEd1U1bkgzQWQxeEJELzdF?=
 =?utf-8?B?WFNrRk45c1BNZmxubGVDMVhHTkttdHh2aFlJbHJ3cWFFOTlGdE1aaElSeEFX?=
 =?utf-8?B?K2N1Z2FmeDVlMlVCWW9jYkV5S0VFZm9ReXRFem5wZ25yOGlBalVMcnhiRFBs?=
 =?utf-8?B?TG1GNnNpQ1NaaEY2RkdMRkpvREFWMmtzV09lWklQTHJteVl1ZG1KNHVVR3FT?=
 =?utf-8?B?T3Ara3grMjFPMnFMeFl6STNzSE85QkdiRWV6NkxwL0ZOVkhGdE1Nb1dCZGlZ?=
 =?utf-8?B?aThxV043Q2orOVNKcWdjZGlsTDFKNkhMMHZGYTloQkV1NTdEYzMzV3Y1VC9E?=
 =?utf-8?B?SGFsYkcrRmZaaklNcjZTOU1KK0MzUnFsenVld0JwQ1JySTZ5eVZHKzVkUEF2?=
 =?utf-8?B?aHh3Y0s4KzhSUlUwd2hMYUxYYnhwVEFyR3ZOVXZTNTk4MlJMYnFNdERwR2Jm?=
 =?utf-8?B?RndIeERLQ1ZxVzNIa3dDTTNXWDFucS9nWmJSY3VTVGZMc1RWNXB4Qjl1UzZm?=
 =?utf-8?B?cENXMlV4VHg1YlhDb28ydnB0TklFRVQ2YzFoWENBcUxmcTkxQ0pkSzY3Ymp3?=
 =?utf-8?B?RndoMGlSM0diT2M2dFpvNUswcjcya3ZuYU5Dd2w4VHU0cFRaaVpjS0VVbjFi?=
 =?utf-8?B?Rm5WYlhqMTZSSDdQMnRjNkRHWTZhdjUzRG1kYU43UysySDBXYStvenBhU0tJ?=
 =?utf-8?B?V2ZpQlhhaC9HY3ZKbjNkcjJyOTMvZTNRbjNqYkpiUTJLMlVXeHRsc1ZJNVpP?=
 =?utf-8?B?OFBodUdVakVMalR5YTMwNTJ1N0VnL3l4Mno2aVdDcW82MXcvY1FHZlA5MlBG?=
 =?utf-8?B?V0tLN1JhZ0NaTTM2Mks3c1puQkxESFdLaGc5NWh6TmVaUU1EK0NqdnR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M29zTmluUDVwVUFQNlNEWkhPa1g3R0V4STh2Qk12QURja05HQ3RTNmlMdDB0?=
 =?utf-8?B?NGZ1MXQwcHBnWituQ09Id05nM3N4M0doQW9qTFUvclFzdFlnejNBam5yR0RZ?=
 =?utf-8?B?ajdjQ2V6TkhRUG4va2p0RmwzNUhqeTliVDhGQ1FOY1hFcm42N0lydVN3Y2Rn?=
 =?utf-8?B?cHBJUGRTMVZzRHN1OGIvSUhvSUllNWxNOFZmanJoTUt5YmZUTGx0UWtVUHMy?=
 =?utf-8?B?cU43MHFJQ2NMVElCYTR3OFEvTCs2OUJ3c1gzb0ZwRDdQTmpoay84Ni9LY2Vz?=
 =?utf-8?B?WnJuaEZoQXREN1N2cEQxYzZnSTNHUFN4Rk92NWswWklLVHdUS08rbVVkVHFU?=
 =?utf-8?B?eHc4VThuTUIwdXc4VjFhWlZNNUJyd21FaW5hOVhEUmcrMkJnbVdLVFZJc1c5?=
 =?utf-8?B?OEFSV0JCQm9zRGpTd0tzVUlnYkl2VStRdFNocytFRzFwQmU0V0NuaWFiNEN0?=
 =?utf-8?B?TWJ1VXdXVkFnZmxnREViWEd2ZXhENnZRb0hRbTg1NmJCazhRNnlJNkMyT3pl?=
 =?utf-8?B?VFpGVnpDVzh1SnZMaXUvWFZLSVp0ZVV6NkNCNC9wNDBTcGlxVjBDbnZYZ0Y5?=
 =?utf-8?B?ZG5JMTNVdWdYYXdRRFROL3lyLzhBUElOeHVrU25ONU93YnF4dkM3QjBFV3l5?=
 =?utf-8?B?TGJhS1dvL1hNT2hiVzJTQnRIdDhXVGxGM1g2eGtYczhxN2FhM2xlUVVidER2?=
 =?utf-8?B?SzA3cXRHZXdnNG1TWndlQnVwdFdJN04xeExZaDBCd05jdENFell4MUhUTVVv?=
 =?utf-8?B?ZmpIZEhud1QxU3R4d3l1SW5mZm9qQXRjV29VRllkMEQ1bEdkYURxUU5SNVho?=
 =?utf-8?B?a3BRd1JsUlJ3V3NQbE42bEVFN25pbnRVZHA3RnJqalJEeFN0NC8xckl5T3NU?=
 =?utf-8?B?UXlkZWVzUnVTWnkvalZrMjJuVm1oQ3QzT3hxVzVEQkZwL20rTFhONXlJMDlN?=
 =?utf-8?B?Yi91c0J1M3NvYm5lckRiYnozd1hJSlpIMVNXZElqYU9JTHgwRmI3TU9QbDB1?=
 =?utf-8?B?NEJ5ODlLMmdmZzNkRWtPeWpHWkVLb0VmTFZtck5XM2crRUZhUWdacS83QTM1?=
 =?utf-8?B?SXJLdHE5QXQyOVFWVXJuN2ZwQkQ2RnpkTC9DKytkejNja1oxZ1kxRzZoUkhw?=
 =?utf-8?B?MFh5aFpLRGZUUkZ0UVNCRWdyQnpGbW0vUWpKT3BteWRPQWhwenZRRUYxSlgy?=
 =?utf-8?B?MDdHUTJPYnY3bFp1UUdXNGMrNUl3cms0eVNUZFo2ZXBQa1NGSXArU2kvYkY4?=
 =?utf-8?B?M0Mxb0h6Qk5HWW5XLzBBUy9wdnNQVUt5NVhuNitWbzRrRzlaRkNsUGh2amh0?=
 =?utf-8?B?eWpWUEtlOEpnNWZqNkhmWDJYeDRMRUZiZXpYbFlOdERHeWE0eHNFK1F6Z08z?=
 =?utf-8?B?NGFqb1dicldPK3ZUdkVEMWNuTHRQYlBBNmNPVEx4SWgxSUFMRFprdU01RlRx?=
 =?utf-8?B?WEYyOFZxMVNzelkrcllyUkh4SndIYUVyakxCUW9kb0E2NWNXS01kNExHVGpU?=
 =?utf-8?B?VnFBVGNVMEw2eXdyR2FobyttbEp2UisyZVM3aXRKVXRmcDZCOEVWWjljZ0ZO?=
 =?utf-8?B?UVNNZklyeVJLWTF1Q0JZdlNTN0lLSExIQ2t3cHdienh0VTJDaXg2NDNqbUVM?=
 =?utf-8?B?VnowWkYzWSt0WTJZNzcvWGY2UXBMVjVpK3lHbW9sSS95aDFiS3c4L3FjeGdt?=
 =?utf-8?B?dTRjS1Q0Zlh1VUROemYyYmg5SzNhUXIxUDVMaEdDNXlxenVycTdzNGJuRHhr?=
 =?utf-8?B?eHRnL3RaRTlISXlPeVdCb0dNSnVwc1EzT0JPZ3VKbm5WNUN3dWtwd2o3ZjBD?=
 =?utf-8?B?YndNSUlDUmc3ZktxQmJ1M3dicTBLSFhQQUk5RlZwV3FQNVBSY2dyVmlyTkwy?=
 =?utf-8?B?QVgyTzd4QUxManNyTnRZcElmWVlpaTFacGRPZkNrQkpCU0QwOTFKSkRodEc0?=
 =?utf-8?B?UThzVWs3ZFZuQlRYRCtkUFBJbUFjUnFJZDVhR2hvbWNoWXRzaE0zdmpXampS?=
 =?utf-8?B?eVhEN0QzY3h6VmF0NEtzL2RRak9IN2N0S2IzMHVIZnN3eEF1b3JWRUZsaUk5?=
 =?utf-8?B?Z2RtWFhNdlpMZ3pDOE0reGlCbG1iUS9iRFJJN2JydjF3UnpnNTc3WmMrcVl1?=
 =?utf-8?Q?qJtuwOKJ0IQcvZP1zB5gZdEWZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bde2771-215a-46b8-6a94-08dce963515d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 19:39:55.7322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJRs8PsQx4gPMCQ1KSXupCeOdtNA0CdG8qa1M4R53xL6NgTbyrG2QXYXg8igp0yDdLHPSo/xZk3G56L88wISVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8494

On 10/9/24 04:28, Nikunj A Dadhania wrote:
> Calibrating the TSC frequency using the kvmclock is not correct for
> SecureTSC enabled guests. Use the platform provided TSC frequency via the
> GUEST_TSC_FREQ MSR (C001_0134h).
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/include/asm/sev.h       |  2 ++
>  arch/x86/coco/sev/core.c         | 16 ++++++++++++++++
>  arch/x86/kernel/tsc.c            |  5 +++++
>  4 files changed, 24 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 3ae84c3b8e6d..233be13cc21f 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -608,6 +608,7 @@
>  #define MSR_AMD_PERF_CTL		0xc0010062
>  #define MSR_AMD_PERF_STATUS		0xc0010063
>  #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
> +#define MSR_AMD64_GUEST_TSC_FREQ	0xc0010134
>  #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
>  #define MSR_AMD64_OSVW_STATUS		0xc0010141
>  #define MSR_AMD_PPIN_CTL		0xc00102f0
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
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 5f555f905fad..ef0def203b3f 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3100,3 +3100,19 @@ void __init snp_secure_tsc_prepare(void)
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

So this MSR can be intercepted by the hypervisor. You'll need to add
code in the #VC handler that checks if an MSR access is for
MSR_AMD64_GUEST_TSC_FREQ and Secure TSC is active, then the hypervisor
is not cooperating and you should terminate the guest.

Thanks,
Tom

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
> +
>  	if (!determine_cpu_tsc_frequencies(true))
>  		return;
>  	tsc_enable_sched_clock();

