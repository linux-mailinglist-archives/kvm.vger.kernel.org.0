Return-Path: <kvm+bounces-33436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 717F69EB6D1
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 17:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8AF11885987
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F12A233D70;
	Tue, 10 Dec 2024 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lWmwHja9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0202153DC;
	Tue, 10 Dec 2024 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733849112; cv=fail; b=FsnVF0HWXfmM7zDVjCj2vFhjo0Ln5Q/WxngsoYNrLByv/lBolQhihCusUlkC1SYfopz3nqp2vPgKs6lQWx0GeenvrCSCLIeID4udLaewEpyQUD/bViS9EgoEg8UcDEDDaqXWXW5vxD1AzNTDl9glFOz1UPWruo0T8Z7H0E0Q/Qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733849112; c=relaxed/simple;
	bh=FHeOfx0n4VQawQcfFE6wCavkUqLgZUNBi3k4Wj0GVlk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rk5KBu7WuHlLznKyD051kVutG+8Cfioixf+FjwMx4zuqdfa1eOIllp0BTT9Xm4w1P0y6iLeF/qbAFCcpnew8MRQV1BR0aCncFPZVSZh+siyhJ7+pj0CIF9YzPMUd2+/1aQpa4SfeLefgwWa8MNHBY5xCupgNs4zQt7J+j5jvbV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lWmwHja9; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KJX7zv01ky0oj9NBJg/l5Kz3QAY7Mna0MQIK0px5Yaxi/LK+R0DTdqyBEWnr7B0eaPwxz+8f+3ait/SnJvpJg9e0mwQZzhQS/1cT/XYQx/C6gseAeDH25EQOP71zndIx3lO66u1B0GcMgVdN2hCo9m4jmB5q4bHuA8xhu7B2PU3FnF6N62JemwYuqMl5aH552lgcaVlY5hHSmoeQIn3O7PBGTFHTPxYdVwAZusgd+VDE3XqUG5CIyLs2L4D7PBNYBjq4gQcjyywr/7rGgA5Z+sihFCkfZT4GHi5PIbe3Yxf36VFTeBXzyzzwdTTy+okhj9bYatX4+f/Z5/tuEmOdAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIWPXI/cZvcMHJiR0+kOP4mv59LRbGQLJZ6HExG8BMI=;
 b=Kk9UNLMWVANY5bshlwrek7rYL+C6mY2GBjRvus/4UWk4dpyNe5Sl1WZU9FJ/XO6II3U3xJezpkd4QC7TLLRrN/VrFZ18unPvk+U99yQy8ODb2CnSlb1gXyBsx8zE0SS9qzqZ0pX5KuPDX8vV4XEMGU7qTKPvlyJwPGBhFSK5fTJcekDjLJPieXa/yvn5QAdUwvAx0s1OsLVcl9sNWqfUTwvjm+Qzc5y5hCwSVeg4wq8yhWyfWsvRY/IzgQs1rZO2pYUXKvluQ3YNj3NzE6USJdeteFs37WlduLV93VsxOKCCVk4FcuCo+Jl+uDViubpS6AVkGq3VmM7/IbbRsyvSMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIWPXI/cZvcMHJiR0+kOP4mv59LRbGQLJZ6HExG8BMI=;
 b=lWmwHja9Lt4GRzzKRKrpwdcjCnTqASvA7+Lu/MvMyyIsWMRNxQu0u7xlUJqh2gz54XleJf5uB2DZOnlRMjundwGd+TTwi8Ig2nGnodDf1X5qu1V8jmgK61mPVT6965vUn1r7xumbc6ZAHw3R03TrdIvtTT/ic7MUZkb/4Q6Cj+s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BN5PR12MB9510.namprd12.prod.outlook.com (2603:10b6:408:2ac::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.18; Tue, 10 Dec 2024 16:45:06 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 16:45:06 +0000
Message-ID: <311a718c-916e-44c9-8093-51903f20ff0a@amd.com>
Date: Tue, 10 Dec 2024 22:14:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
 <20241210114357.GGZ1gpfWVLixGKXc0s@fat_crate.local>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <20241210114357.GGZ1gpfWVLixGKXc0s@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0192.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BN5PR12MB9510:EE_
X-MS-Office365-Filtering-Correlation-Id: f3415e01-32bc-42f2-a345-08dd193a0031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFdUY05iVzRlMENrRlRjNnA1TmtPUnU0c2VjWkI5ZmZmMlB0cC80WEg5WmQx?=
 =?utf-8?B?a0R6Qm9KMEVRSEMyRnlBak1aS2FpdTlIWDM1YUprTVBGV0NEVTU3R0FvNE1n?=
 =?utf-8?B?RjJYaFVIM1VCNWdtbU1tclNLUFhFSy8xUnJaV2hZUlpqZE1nakZtcGt0R1ow?=
 =?utf-8?B?Rm1vSGZ1WE9meXo3aG5FeERHNGxORDh3WTkvR0w1REVURlFjS25FSXRXZ3Ew?=
 =?utf-8?B?WlQwT2ZVK3A4VU55TkJDaW1XN0MxbmQzOXNhMU5tNEd6VWlzbXhLc3BjSFY2?=
 =?utf-8?B?SUh5YlVLSVJheExNMjlJQUlrZXpKeTd1NHNMTEVjV2lodWJCVDJsbEw0cnJI?=
 =?utf-8?B?NTJkaUdCSW83Y3dJdXVOK2RpcU5SZCtFVmVaQ0JHMTdNK1VFWFFXbE96M1BJ?=
 =?utf-8?B?YVpwZDhFK2RRUUU0NVlEMWZBYTdwcTZKR1BkeDgyUEJuOG5hM2ZiWnhMci93?=
 =?utf-8?B?eWExZGY2NVQxSTloQjNzalBZTUlaVGRUU2pldFlvOXZSWFRhMjAvRWJvd2tw?=
 =?utf-8?B?YS9uTnM3NGswWDAzL0Q1WTFJdCs1Mm1YeVlsRXljeEN0cUpoN0NNN2U5SGVR?=
 =?utf-8?B?NE9yemE4RUx4QUJuSW1CUUFlVjJsOVlrL0RrSHlkZEZJS0k2dVpIdTdYand2?=
 =?utf-8?B?S1l0ZFVVV0VBUWJWV3ZFWHpBWjBUN0RDQnVud0N5TTUzdDE1S3d6MzBYdTRr?=
 =?utf-8?B?SHUyY0lUdFQ3ZXlQSFRFbnZ2dFNDT2kzZFRwVVJ0eTNoQVdqdEVmNk4wWS9m?=
 =?utf-8?B?bkpLbkw2c2RIZGpwWlVLbXZHeFFDNlExUURTY1VFRG9NNzA3dTliZUJReXBw?=
 =?utf-8?B?Qk5YRXprczAxcmxNaHlQMXFNaGZOZEx4c1lOTHVLNE9ML2dNWU9vRHVHRisx?=
 =?utf-8?B?TytLaFB3M2E4YjJ5aVI0eVNrZExVa0FtVk5Fa3VrUEtyTlFXWGFhQjVncTdO?=
 =?utf-8?B?L0V2Z05TS1BlYlhtMnVTQjhuYnNuQjNFaUJoZzBXeHpLUXZaL202YjJxb3hy?=
 =?utf-8?B?WkMvT2dlREY4VUVvdnpwQXVwVHZlL2RNS1JCcTFEL1ZIWllrVU53ZTRyYXdM?=
 =?utf-8?B?cnl5c3dUNVBRL1JrUTFWUExEbEVnd1g1NERTbEh4M3ludnpnRXZwTkwxeTBp?=
 =?utf-8?B?WWNYT3F5UDV4NU1JSkJrVlRMTDB5S2VYNXBjbkswT1NnSkdhRUdrM0hLZ2gz?=
 =?utf-8?B?c0VBWHJ1bHUrajJ0em1OZVlhVHVVOU1UOVhxajdFVjVzek9HanlPR1l1WHpi?=
 =?utf-8?B?T1Y4Rm8rVmw5N1R4WnRoSmRjdmRMVWl0RFZNbXVuTVJLaFlISjhWbEl0N2pt?=
 =?utf-8?B?cFExVEhBZnlnRUpNbWNwTEpVY0J2eDRUS3JWTmx4by9SREtqWmtOTmhqdVAz?=
 =?utf-8?B?Z0ZkWm1JM2VGTkxYOVNEN0R5aTZ0QU5iQ1FvREZNTTNuTmx6dUdQYWw3UXcx?=
 =?utf-8?B?WUJ1NkJqQmRMRGZxSkNtaHZITHZjQTZSTlJZMzNWbHpvQTVPeTl3bUNWQ2Z5?=
 =?utf-8?B?Y0x3MWdhNGFHbTVyMEN1Und1andTOHBidEhpTWJmbnl3Ym0yR2tvcHovOE44?=
 =?utf-8?B?Kzd1aHVmWnh1Y2tjMHJkWkl5dzEweXgrME1BY0ZKMmpIcFUvOXlqSHBvL1VL?=
 =?utf-8?B?Y3JzUk9jK05LVTIwWXRhUWx4MzBSM1hlZFd6VWFOeXZiUURrMUtEcXZzd2E1?=
 =?utf-8?B?YVg3dUJkaXo0b29zZXJoamlwd01Wa21Ta1ovKzNydVlaK3ZYUnZ5VTlMWTZh?=
 =?utf-8?B?R2plRnlzNkEvNiszU1FzTDdFODRPMHliTXBUZG50RXRmNG93aGNjVmRZWER5?=
 =?utf-8?B?VWxwM09id3E1NHRqVGYzUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHh6RFRKeXE3MVo4L3NPQnN2WjZxLzk0bWNoUE9LQmZWZkVpbWtWV3lraCtr?=
 =?utf-8?B?REVIQ1ptV0hNU1V5L3EzZDBlVTh0UFQ3MkgxR3JodHl5VWRIWGxZajZ2VkFX?=
 =?utf-8?B?ZHE1WWV1aldVWVBnMFRWVms2S210VHlEQ2VmbDNYQUd4WFBGY0ExQmV4M2VO?=
 =?utf-8?B?b1pTKzMyajB6b1FWd1U0U2o1YW5rODZwdWt4em5ycHZIVG1UclFqQ05NSHRj?=
 =?utf-8?B?bHJCa1p6V3V1SEswMkVnVXUySkFEeHpUdGdkZzVJSkZiWEpjbzA4K2xOQWoy?=
 =?utf-8?B?MktQQ3ZBWis4eVlLTjNmUXhNSktiMmhCaTg4c0hucXFKdmhTbTN3eTZDL2wz?=
 =?utf-8?B?ZkFWd0YvU2xncFgwNFYzSm8yUkZsRnpRbE9kY1ZvcHQwTVBPbi9TSUFiWm9Q?=
 =?utf-8?B?a2E1ZFlEWFJmTWthWDR2UGs3R0hnNGNkQWJSalFJdk1vZll6dmdqSGNNNGFz?=
 =?utf-8?B?TnZ2UEw0eXp2dW9HOVcrMytKU2JWeThnbGQxcndyU1BMWjQvQTdSTnRMQy9m?=
 =?utf-8?B?ZkJNSE9jVnpuL3p0ajdMYi9OTGp0Y3paV1U1SkhJczkvdVl5NGtmak1HN0lw?=
 =?utf-8?B?Mzg3T09YWmpudWtab3p2MDJ5Mmx1YS9ITzl4THFOM0kwNjJ5U01FV1hxNWhw?=
 =?utf-8?B?RmxGMmNhbDNPNCs0Z2NaWDBZNXBHM3c5M2gwcGJ2eUdzMjBJTk43QVR0bFR2?=
 =?utf-8?B?VFFqd1ByWGhPN1lrSFVsYkd2aFU0NEM5MFdid3BjUHczNU13VTM3am16NXRG?=
 =?utf-8?B?VjVYdVFwdkt4MWRyL3NwT29NcTVkR2tGN1B3MXNhNUMwcUJQNjNLSkVmU3Qy?=
 =?utf-8?B?c0d0SkFwNjNBWjJOYjIvVVlYTG1VbENYbEdZQXdtUm5nMENDbnZ1T1FPV3V0?=
 =?utf-8?B?dkxhTlpKcTg2RXIwSW92dE1xelVhMzlPdHhnOWFqaUEyNmtHblJ3aGtTbE9k?=
 =?utf-8?B?YWt5ZUd2T0lPeTZ5UVNyNDU5UjdqUUloWjdHejB1NXBjLzFWbUw4Z0s4a0wy?=
 =?utf-8?B?YmwxR3dMMjViQlVEUmVJVTFlL290b21FTWd4RWY0WXNlbzFwYU5xdDFnRlNp?=
 =?utf-8?B?UkxDeUdWVFBoM2Z5RzhzRUF5M1lVVUFiYnZQN0dRUWFhYzI2N09teVZxc0tO?=
 =?utf-8?B?UDY4NGpEcjlJMDBLb1E4R0pWWmN5Z1F4Sllwd1BYQ1JTWDRuVzhoRDQ1R1BK?=
 =?utf-8?B?V21NaHphczI5Q2wwOHVKL2pBRGpocjZPSWtDVkdHTTdlZ0t3eXA2cnB1d2JN?=
 =?utf-8?B?OWgwdnRSSjVTZGRYdVRNRjF3eUMxU2FEWmEremZRSkhyYkttZUIvMG1QMHJT?=
 =?utf-8?B?SmhkNGdPc1hFOVdXQTdYTERNQnJ6aFpIblBOUWdUQUJkdHlnZU5QR1JIVHlX?=
 =?utf-8?B?eGh4a1pUWjNkMHg0Z01VZGFlcE1GenRBUjZJVG5Gd0Znb1FyYll6djFwTHI1?=
 =?utf-8?B?NDJjYS9WZ2RZdVdVSGNNb2x0SXlHa1BrWEJuS3ZhV2VUc05PT1hQNGRnY0F0?=
 =?utf-8?B?SURmZ1RKN2RlT0FZUEJHYk1SdzdVS0l0ZnZhSjRxTTFjN3hGWUhvK0ttMW5L?=
 =?utf-8?B?aytIb2Z6R0ZYZlQxUGQ4bWFubjNSMVVyb1cvZWgvQ1gyaU12dVplVFpzemJP?=
 =?utf-8?B?NFUrTlBtNGVUNUJMRllnQndiOTlyOXpnM2FrQy9kUzZvanJWUWRZQnB4ZkZm?=
 =?utf-8?B?VjJVbEl1eWlma2M2Z2ZTVlp6ZW14V1MvbkJOSUtVeGR2OGZFVGFZdUZmY016?=
 =?utf-8?B?V3pTS3prTlBwR3dMZzdmWnA0cVh5V2F5Y0FIMEJHNDVjMUdWUEhsV1oxV01i?=
 =?utf-8?B?bXVGRHdPY1AyZGtXN0JMaHh0QXZydTFjME14OGxNQUJRMmxKdEJsSFFXSGVk?=
 =?utf-8?B?a2xBcjlNMThPa05NTUl6NWc3MDNQbDY3MXc3bVNPeFIwRENLRzFIbEFQdmlI?=
 =?utf-8?B?Y2VqNlNWVmNrbTVWT2tpZHhrYjF6aXlDUllBNHBWWDQ4RDVxay9XZ2hBMWhy?=
 =?utf-8?B?dmQ1bTBDbDNaYjZlNTRTYk9IV21vY2YvQmV1bWNPVDcxc01HQ2g5YTVpU3ow?=
 =?utf-8?B?MVZDVFVFeThLQnUwdU5kYUllQUE3NnJHUU12OE9ORUtURFB5b29vd0R2VWQ0?=
 =?utf-8?Q?yi4xcp93ayRtwT9dRltqkGHWo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3415e01-32bc-42f2-a345-08dd193a0031
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 16:45:06.3018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKpa7Nv93RnMB2ZJDOlmbdAD8WUMoAIuWlQq7ppaEUbNCLlbmFb0uxgp0S1ukwqdDabs31SPdRn9DmTAO1qLmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9510

On 12/10/2024 5:13 PM, Borislav Petkov wrote:
> On Tue, Dec 10, 2024 at 10:32:23AM +0530, Nikunj A. Dadhania wrote:
>> Do you also want to terminate the offending guest?
>>
>> ES_UNSUPPORTED return will do that.
> 
> I guess that would be too harsh. I guess a warn and a ES_OK should be fine for
> now.

Yes, that will be better.

>> This is changing the behavior for SEV-ES and SNP guests(non SECURE_TSC), TSC
>> MSR reads are converted to RDTSC. This is a good optimization. But just
>> wanted to bring up the subtle impact.
> 
> That RDTSC happens still in the guest, right? But in its #VC handler. Versus it
> being a HV GHCB protocol call. 

Yes, and the change is working fine, I have verified it.

> I guess this conversion should be a separate
> patch in case there's some issues like the HV intercepting RDTSC... i.e.,
> VMEXIT_RDTSC.

I tried instrumenting code to intercept RDTSC and RDTSCP, KVM does not handle
EXIT_RDTSC and the guest (including non-secure guests) crashes pretty early with
the following in the host kernel log:

kvm_amd: kvm [2153024]: vcpu0, guest rIP: 0xbbea5fc2 svm: unexpected exit reason
0x6e

> We should probably handle that case too and then fallback to the GHCB call. Or
> is there a catch 22 I'm missing here...

Regards,
Nikunj



