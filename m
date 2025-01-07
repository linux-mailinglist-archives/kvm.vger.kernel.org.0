Return-Path: <kvm+bounces-34699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC31EA04945
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5848618870AC
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C0B1F37B4;
	Tue,  7 Jan 2025 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D4AV5/wf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786E17C21C;
	Tue,  7 Jan 2025 18:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736274852; cv=fail; b=UzDCP3ZOhRatdLfgz8RYut4JzQTmKoa4YoGh/73XmSKqNFevT6EkmcBJG6U6KQRXLpwSnWVDRgC6BMm9QpxatLQh+yFMG7FTpjWqxlNYwJIyjdQ3Gzr8C5GQRXI6XYoF+aCS7sB3I4XAbSJHb5drexSWjq8L61E2rFsZ8yiS2bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736274852; c=relaxed/simple;
	bh=9PsCY7x38HUmv6awLCHF1KKhPE+WfXS9zyy0PMvpGeo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JwLa+DxbOgQAiTURWI0qr/MRpX41ujZZ5LSOHFvu95mvz4LQFt+bJIghq6IWoa5wZjWHr+Yb3uX2+wkgBo6xsIiV8X10CCHvzqD3vkf1UONwxqIvmS7RiKBFgUAmZfI06+GyafUOHQ8NhWLBa1rcA9oPoALBjaxw2G9Bkl6vxh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D4AV5/wf; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2IhwpGf7DZ54XFI1wriQlGbtZXlskfs8h+fZ5540NhiY7cWUhNtfAWgtkNVWAQuMACTKLpNvcqrgk4kPrax52rmKqBCtlOPxW3E0F7wynv3nVwPNjBfaxqOmm04mDZM/kAmiTEYtCyML3E6iE5Z8yGYSLrE4pxRY56/IaIA633RNSIfdEEGuqD/Jx7uW9cPhRgL1mUwSaGVBjX3OMPAEht1K66Jevh1YY6It+hDZrgaCsEd+F8DD6v+8z9wB9bDmBy4+GsWBYX0WPG+N+iLobfTEdNB73uHK5TWTkOdN3vpc4h+gP+62FClGaGbprF2qdTPbukmYBGt0WcnIrZVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUu6Cf21lJdhg4cA008a+dH5zZKeDeBrQrzjBHmEb+I=;
 b=jRmBiEBFOM6EmmocbuCoL3nxAjvbIZ2kqbdSh2PEnahyNH9NTte0FNzU/E1gm94Y8LvUrbn8M4LDZDGOvxX3ojP4+Lj9U1rotiPbN+xs14DVux6cyCfvdmdB+zshGd9y/rtvG23R1jFf7kIZdpXwLozDKujwOARiXd6xYsfDLW7T8hlfrUOUAM8WVfSYGfw7XnEb0OHezFHAwv4I65luS4gxX50TkWTf2QWOVvKZi90WeiOXglG4d+pZOHLRDYpv8WTmEQTBtuWhsJwbthLMA9K8SGpfxkOxwnYu4uNqQuCOiJbtGeJwlyz9vD7FjFZfWuAdtjevB27uVduSxKC7sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUu6Cf21lJdhg4cA008a+dH5zZKeDeBrQrzjBHmEb+I=;
 b=D4AV5/wfWqysdMZdSJyX/gwJeM1whbMyfGolnTFkBW2yPNbi4ITs0j756x00YQBJmPYdpzcaxCWa5SWOVHy0XjK+EsJ36Zox5xET9NqHPqHCjfrhXFCLOcdAT5ueySRXCIi6wnS1nPYknDSkOL1fdtQ5cA4EUyJsiSJfr5FKjHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DS0PR12MB7972.namprd12.prod.outlook.com (2603:10b6:8:14f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 18:34:06 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 18:34:06 +0000
Message-ID: <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
Date: Tue, 7 Jan 2025 12:34:01 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0228.namprd04.prod.outlook.com
 (2603:10b6:806:127::23) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DS0PR12MB7972:EE_
X-MS-Office365-Filtering-Correlation-Id: 12520ffa-69e6-4bf5-e11a-08dd2f49de17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTZVZW9FTXZPeURFS0ZGWVdsNThDOW81MDhyME5kU25rRFZwOFJveEVjYk9W?=
 =?utf-8?B?N2orMVpXOElNU3p5WFBSV0U5a2pWTHByZHQwdTlpaFY0TG8xZlJwK2FzQXg2?=
 =?utf-8?B?bEZITXBmbE82SkdzZG5EU1lvNk1maEhVUlBNcHcrUjFVbHdLZC9sR0Nna0hL?=
 =?utf-8?B?YzhjclA4RTBjMXdaU1NTb0YxbWpoMXdQcGJ3Um9SWWxCOWNRMzZzK1MzYk5w?=
 =?utf-8?B?Um1hWGhTWVdXZ01LQ0crUUsweTRWb0FHL0t3SzVrc0lrK3FXY05TQkc4Y05M?=
 =?utf-8?B?b09EYWtpWlJLQXc5UzcvVkQ5YnJRUXpBZGdjbG9zOFlTeUJKOFdNMlV6NHEy?=
 =?utf-8?B?NDQvNWRrWDlFZHUzelhoVkZYZFpWY1RmU01mMnNNQ2h6L1IwMFB2cHdDOVc0?=
 =?utf-8?B?RFFyVGdIaWlvOGZnMW81TkREQ3lUQmozc2Ztbi9lbVJiS1l6YUxmNUlGR2xq?=
 =?utf-8?B?NjZmUU1NNmFjaTc2Rnp5VzlzbWx4dnRoSHFWdTd6VytEdkVEZkJML1hkOHhn?=
 =?utf-8?B?UEg1NnlEVzdPdnd5aTg3RkdrdGovRjJNclM0NEpYMkJwakVib21XUlVNQlYx?=
 =?utf-8?B?aFhMU2ZsS1l5bkdyNUFGRWl1ZHgvTmdlOEM4TVI2N2JqTVpjLzNweEp1WHhu?=
 =?utf-8?B?ZFdCQW92T2pqdjZpR2V3Qk9YdzB4NjZna1dURjdEbVkyOEdpNVJmTytSTU51?=
 =?utf-8?B?bksyZllQTGYwODQvUjdYcjd4NUhkQzhhelZsK3BMT3h0MmhReG4yVHZpSG9C?=
 =?utf-8?B?SGhtT3RuTTZMQkFBcDExOUo5U3JzZWRoR1VodkVqWjZyNUNCY3FzL3BRT1h0?=
 =?utf-8?B?NjRra2pubDhnaXVRMnljL0lDcy8zR2JHck55aUpEeVJsSW5DdXl1UG5IeGxx?=
 =?utf-8?B?MEd3cTJTbnpMSTJ4ZXJWdUVDTExiVFFwbzEwWFdobHN6WVJkaXFxQmxwenlT?=
 =?utf-8?B?bCt2YWVGNXJuRU5qUTl4Y2JTY3Y5dC9CMWprMCtWUWxLZHNTSGRVUFh4cDdR?=
 =?utf-8?B?WUd0R2V0WEw5QzJiWm1kais2ektDN1UyMTcwZWxQcHgwaWNxNk0rME83MWpq?=
 =?utf-8?B?NUdCU0FDamZxbFNQYjhpSWJUb3laOTZqZUJsWUU2b0M3bFhNUC8yQW1HZGN3?=
 =?utf-8?B?VWRlc1JPOHdGNlZtTit6REFJZ3lVQm92dTZIQ1hrU0h5OUtmV0o2Q0gzNmJV?=
 =?utf-8?B?cUdKMkFTaWdMenhnYnE2YkpFMjBuMk92RkZhSlViWFk1dUUzVldCSlNFeXZr?=
 =?utf-8?B?ZEtFRHhuRm40U2U3c0czc0VDTUE5WFo2Slc5MHBRMHFlZVdYNUdERXY2YVZN?=
 =?utf-8?B?WFBCNnBJMHVOazNQTm5uZzhnVmN1RXVWZTBGcHVUMXFjT010QlNVckpIQXhT?=
 =?utf-8?B?Q0dxU3hBK2tnaUUzSHo4VTBPYVNZSWFFeWxpZFdwdDBIZnR2VDZwTUFvWlJW?=
 =?utf-8?B?OU1UT1pSU1BwemlZU1VvN0JqaVUyYlVab1hrZVdENzlML2lmOXB2OEtFZmRM?=
 =?utf-8?B?anlaU2dvZnJnVkR4VEk1eUJKSnVvTjNmQ3lYZTZ1QXZvbGJ3YXFQQldlK05N?=
 =?utf-8?B?c0E1QWRhZW1BTGlLb0pTNUgwSkdzS2JPTzRYSFdtZTBhTnY3R0hENU5laEFx?=
 =?utf-8?B?TDVub0kwSHcvbDVvWmE3c1JNM2YybXlvWHVqWXNQTnFsUTVmT3hrSEU0eFJv?=
 =?utf-8?B?Vzhid1Q1aEt2NGF6Nkt5Vkh6OHFEOXJlV2FiY1pKNkdkRzk4WHdwNys2cC9T?=
 =?utf-8?B?ZXA5R2FTL0lsd3h3c2xNK2dFOXY0MzhxWWxMbXltbHZrbm93UThwMVd6MWMv?=
 =?utf-8?B?MTgzb0g3MkpNWFNCcEpUNWNDTUNRYi80UVBNbVhScmR4bFZvMHQ5c0ZzcnQz?=
 =?utf-8?B?b0JWZW1DM0g2Y3A0dGtoL2hWdkoveHpjVUFDWlNkWnl3eFR3YzE1WUxFWG9N?=
 =?utf-8?Q?RXh/U//t5QM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTBhNnBCOG9lT2V3SDlMYnZ2QkE3QUJVaUdpbEo0b25jZmZUZWgvZGY0RXho?=
 =?utf-8?B?Nmh1WUIvVG9IRlpPMzNESWQ5ZXR6QzBrOEFuOXhkOWx5UzdHOTdEUkN3QVJ6?=
 =?utf-8?B?Zk94bnkzb09wSExkRm5sVEJwNm1UMzdUVjBNTlZqTGVoL0dmY21zVkJjM29Z?=
 =?utf-8?B?QUxuVGFYVERreEtvaGhtd0JSNXNldWQ0M21SS0ZndGhQSnk2OHpxbnhrd2hV?=
 =?utf-8?B?TGRDWGlkUE53N2RZT00yR294WlpRdWs1blhacHFBQVY3SVkzaVBRUmtiekxN?=
 =?utf-8?B?dGk5U3ZpT3RiWjZXcUZiR0dIQXU0QzZyK1JFZVQ1N25BUVplbVJjOFA1aFNG?=
 =?utf-8?B?b2hrdE5QM1BLNTZvQk8wQ0lJaGx3R2ZybFl0Tm1sdVoxQ24yRVVIekZFYTBU?=
 =?utf-8?B?dHAreFBLOUFhd2dsUWw4VE1ZSHpkKzFmUVRHWWxRWkxSMWJLdjBsQ2hKcXFn?=
 =?utf-8?B?ZkNkc0kzMTA2R1orYXdZSlZ3bFFEUitVVk1qK2VaY3NZM2xoSXIwcUJnQWFv?=
 =?utf-8?B?K216SGt3eDQycUVSNFlUNzN2cmtiVDB6Q1JwaDB6WHVoNVJML2Q0NXRQTnRE?=
 =?utf-8?B?R1BCa0w0Tkl6SHpoUUJxdGlPaFlTQUpSRlc2WmRyREc1Tjg3UFhXY2ZyTXhW?=
 =?utf-8?B?SElwTEVnRXo0ekN2REhpR3FjNEw2eXNRdUhCSTVCdXpSTXRjYUp3K1Fyd0dt?=
 =?utf-8?B?UUJ6eVVud0pvU2ZkSU9DdktWZnhYbUZrZGFQV24zUGt0WUdaZ3c3VkpHaFhX?=
 =?utf-8?B?c0pJOVZJdnZRaHltZTd5ZHR2Y1JCRXBqYytDVjNsT3V1QU5mZU0rbHZuaklQ?=
 =?utf-8?B?RnZaUDhLaVZJeStxaStnVkpRWXd5c3ZDVE9WM3lRbmc1QjAzVHEweHNQbGda?=
 =?utf-8?B?M0lmdkF5SkVmMzVSYlZ4VSsyT2JaaGlpTXBFRHVpWmd3TnJqaXg1cHBFb3Ra?=
 =?utf-8?B?bmlHQ3hLTVJXTU5ZZ1ZMUXAzenZrZ1BLdStpenVOc0pSMTRYTWRsKytUQmV1?=
 =?utf-8?B?cDNhWEtWd3BoRE5SNDhMSStDOWY0Y1JYTWhWOUZ2eHFNMHpuYmZXYi80YVMv?=
 =?utf-8?B?MWIxOFRmR0dyNHh2WXEzcmdjdjQ5Z1BhVVRJMnpaeTdOamwwSnBsUnZPcGgx?=
 =?utf-8?B?T0U5NXY4eHdqK2gvdlFUSnNUQ3RlMVJVd05WNSs5TmtubDQxYmRsVXZmeXh3?=
 =?utf-8?B?ZGp5MlN3VldBU0NOODNkMTZsOFVtWW8zTTNGTDhiZVRPSE55TytWMitrUDVP?=
 =?utf-8?B?cGJYT3BrWnFRd2J0enpJVGtrVjRQMmxMZkxIUC9wVnhYNnFhaTVaV1dBSkM5?=
 =?utf-8?B?bXA2STJBUUs1Nk00eGY1dEltZUFyaUFobWJaUTdCaUZJMllBaWd6UVNBUmpp?=
 =?utf-8?B?TDVHZG9xdmFIRVVGamhkbVJlSTRFNjYyYWFJRWU0dit5c01uYWl0cVhldzdv?=
 =?utf-8?B?dGtFZlFkZU1kWldvQ3VQZWtRem5yTDA1eDErVzB0cGpxOWVBTEk1T09qMGRn?=
 =?utf-8?B?Tnozd2JVYWlTcWtsV0lXMmp6UFJXNzlUVmE3VERnUDF3Zzh2aDNtNnAxUjNh?=
 =?utf-8?B?WEppM0hnck04TGtpUHlwOVRIczlQR3E3R1Ezb1BtaFducytHMlFKRFRtSmdU?=
 =?utf-8?B?VHdJbW41ZFhDejV6V2FMOU5yUXRzaW9lUDBWdFA1MEdKUXNkMnRTWk1tUmVp?=
 =?utf-8?B?REx5dUs4V2NhRFhuM2ZUbzdBZnB3WkVMYTFtOS9mU2N5U2R4d2JVS1E4dW93?=
 =?utf-8?B?UHNUUnh4V0JaeE00Yk1UVnZBTTVrVldhelVySDRlNWtROXJFOExUTTdIeG1Z?=
 =?utf-8?B?a0VtZXRxOTJxYXJPdFk3dWJzSGxncGFlYWQ2NzNlVmkxOVlxUms1N0paY2tL?=
 =?utf-8?B?ZjZQSEpmMm5BbkxzK3MzMGhsNXJ5SjAwWm5pdDBoTkVxck5UU2d3cE5HYUhP?=
 =?utf-8?B?a3NPeGc2aWhHWjdlZkx1RTlHQ3RsN1A5cktnQ0s0RGlvcjhTZEJBVE5uR1hv?=
 =?utf-8?B?UFJ2WGVOQkIzSkdJUjZJTzA5bnI1aDFyZjBlV0YvdkQzNlVKdFRPQjJMeExp?=
 =?utf-8?B?ek5BRHdGUWJRQVR5OG01YXAwN3lmVlNUUVVBbzFtMDhvRlVBZ3UyK3Zndlg3?=
 =?utf-8?Q?Rqi6QriqdhrAXBGYtfZuJOnXH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12520ffa-69e6-4bf5-e11a-08dd2f49de17
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 18:34:06.4767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndVqb5S+2iTvoA5BK7fAITMP1WPFkEMlwWa4THRwYaPPF/IwICITQkATS3wG8tmDfNkyukQy3Vp4AR0nzTqD0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7972



On 1/7/2025 10:42 AM, Tom Lendacky wrote:
> On 1/3/25 14:01, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Remove platform initialization of SEV/SNP from PSP driver probe time and
> 
> Actually, you're not removing it, yet...
> 
>> move it to KVM module load time so that KVM can do SEV/SNP platform
>> initialization explicitly if it actually wants to use SEV/SNP
>> functionality.
>>
>> With this patch, KVM will explicitly call into the PSP driver at load time
>> to initialize SEV/SNP by default but this behavior can be altered with KVM
>> module parameters to not do SEV/SNP platform initialization at module load
>> time if required. Additionally SEV/SNP platform shutdown is invoked during
>> KVM module unload time.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 943bd074a5d3..0dc8294582c6 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -444,7 +444,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>  	if (ret)
>>  		goto e_no_asid;
>>  
>> -	init_args.probe = false;
>>  	ret = sev_platform_init(&init_args);
>>  	if (ret)
>>  		goto e_free;
>> @@ -2953,6 +2952,7 @@ void __init sev_set_cpu_caps(void)
>>  void __init sev_hardware_setup(void)
>>  {
>>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>> +	struct sev_platform_init_args init_args = {0};
> 
> Will this cause issues if KVM is built-in and INIT_EX is being used
> (init_ex_path ccp parameter)? The probe parameter is used for
> initialization done before the filesystem is available.
> 

Yes, this will cause issues if KVM is builtin and INIT_EX is being used,
but my question is how will INIT_EX be used when we move SEV INIT
to KVM ?

If we continue to use the probe field here and also continue to support
psp_init_on_probe module parameter for CCP, how will SEV INIT_EX be
invoked ? 

How is SEV INIT_EX invoked in PSP driver currently if psp_init_on_probe
parameter is set to false ?

The KVM path to invoke sev_platform_init() when a SEV VM is being launched 
cannot be used because QEMU checks for SEV to be initialized before
invoking this code path to launch the guest.

Thanks,
Ashish

> Thanks,
> Tom
> 
>>  	bool sev_snp_supported = false;
>>  	bool sev_es_supported = false;
>>  	bool sev_supported = false;
>> @@ -3069,6 +3069,16 @@ void __init sev_hardware_setup(void)
>>  	sev_supported_vmsa_features = 0;
>>  	if (sev_es_debug_swap_enabled)
>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>> +
>> +	if (!sev_enabled)
>> +		return;
>> +
>> +	/*
>> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
>> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
>> +	 * VMs in case SNP is enabled system-wide.
>> +	 */
>> +	sev_platform_init(&init_args);
>>  }
>>  
>>  void sev_hardware_unsetup(void)
>> @@ -3084,6 +3094,9 @@ void sev_hardware_unsetup(void)
>>  
>>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>> +
>> +	/* Do SEV and SNP Shutdown */
>> +	sev_platform_shutdown();
>>  }
>>  
>>  int sev_cpu_init(struct svm_cpu_data *sd)


