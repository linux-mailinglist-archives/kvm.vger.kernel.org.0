Return-Path: <kvm+bounces-41286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96039A65AF1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AD0E188971D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457DD1ACECB;
	Mon, 17 Mar 2025 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xxuY0iAw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BC71A9B48;
	Mon, 17 Mar 2025 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742233009; cv=fail; b=eWd73LkrEIJyABtXRuswg35B2BijAScxjPdIZ43VFa16QTMUcpttcgTqU1txvsS8YAEnSUv3Ijcsig0raHUblFh1Y2Z8bVA1OPSyP60PMmEIsN9Apw/diPlYTf8jJuAh05uckTQuwkreQes1Dfo+YF6kcSiJQ0NdkOWU4F1/uQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742233009; c=relaxed/simple;
	bh=+yIpYEHeTUEp2UZB9eSjs5ln1arqrY37ZHwmZjkLOiQ=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=Xz0OWf7NSQ6MXaNjF5lVlnhbmOVsGJl3zt8yjWb4jp+1y13Kuds0Zn4BBGjH94gG8L88V7zD5jC1udck/kaUmgqIdfpC078VC715uAofLw+EfCl48HK2bJYHQusSHtVSVqxNp/cgMgdDmO6745g1uBw62kLgPlD+kn7LVukdAZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xxuY0iAw; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0FJb63gKIrLwgqwvisWPtfGc6Z3AZmNqMq9uHCGsSNIG45vhGWmFWMnC+XjAXlAadCq2147mOjYKl6xGQpflPa8s5DG+gMjxmMIcUqAApvrFo5oTlPPNUa3UD82QvJsD35sxqEhYZeHDzn8Bj9NqSc/R6fd2IFzdWV63FXqwxzVUNtpZ0Kisg3TOZCBqFhflMDvaP13aaAAt1bIJKdrnbrUDH7+5t4eqUx7JlnGu5BJoN67DGyRvXI4UQ/5hxN7f5zjtCdRDPI89fGRJdfBw8CoAzLPNUhKjx/nehHtqlERctyEZHXqzhRnq76Ux3ohLBe8nDNRKvkRRvk3ogYjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y91cHPTkOCoeU1shmxWwwCivBxiU94svZidFvE44udw=;
 b=UD+0gb05NZEVqOU1zKOX+LPqhLkAM1VnFjkK/EnZROh/Rl51ItKcvfGSZEQHXgtocICFX3bt41QWeXpfk8zZZTcw8D+i/ADEPw5u7aZJaw1jsZd2ojLrnh2xG+kuFvV24PdvGiK6ANC0m102501RtmsqrVQ22zJC3dOZskYNipKZhwfICFqRhOFcQAfyLqiR5jAE19MDMtSQPUgSD/seVqVO7KAJ9dPyg+t2+kVdRJvQvmvt2IzqTx9KsCjrL5h3jHd2VmQ/b+0K0UHM/sEAs1+wABsk8hACyJw+gA4+1lmuH0qQcZqsbzqMdvfYcEYfNBPNC7iFYdU8gR57hIWacQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y91cHPTkOCoeU1shmxWwwCivBxiU94svZidFvE44udw=;
 b=xxuY0iAwoFGe7Q54qt9p2I5ZrrVJCygNN8GVthambPEbz7PFnSs4o2xJTevHrNuV+ZTXtsEeTTbZUgQ8KALYgSjlyvuGRuWpCeu09GGZjHLUzg1n1wtscap1Yg6KpoALfJOk2vax/gIdUbabPoilgPxDXQOvawMn6s1bD0GXX/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BN7PPF521FFE181.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 17:36:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 17:36:44 +0000
Message-ID: <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com>
Date: Mon, 17 Mar 2025 12:36:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com> <Z9hbwkqwDKlyPsqv@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
In-Reply-To: <Z9hbwkqwDKlyPsqv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:806:d3::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BN7PPF521FFE181:EE_
X-MS-Office365-Filtering-Correlation-Id: e9392b6e-50fa-4503-b875-08dd657a493e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blVETGtIVGhNdmRZaXFpRm9na2NzbGZleXdYQ1RrbENOY3dYc0xoZzN2Q3JB?=
 =?utf-8?B?Ym9hNTFRNTRtSDlpVmk3eHIvS1V1UlBPKzVTR2FhVENsK2szUWhnV25hN25C?=
 =?utf-8?B?TEZMbzRjdEJGUndnZklzZ0NucFQxcWYzOGhoS1lPaXhoWmFMVktQa3hnN3h5?=
 =?utf-8?B?OVlLS0NuTnc5VS9NK3o2RVM4Rm4wUTVDZUt0SmRrRU12NFdkaVozQU9zaE1S?=
 =?utf-8?B?dFAySC92UDRHYjZvSllMSnc2U1VnejZueWsvamx1REdZVGNkb0RNZnNUT3U4?=
 =?utf-8?B?TjhoTnNVZmRobW45T3ppdjZ2ZkkrODVVaDdXZUJIL1o4SGFEVnFWMVJzdHA5?=
 =?utf-8?B?emJEalo5SU1XL25INk9IdSsrdysrNUpONVlVankxeXRBQ3BYSktJTmhtb1NG?=
 =?utf-8?B?TTloSTJQMWJIcWZuQWxFY0E0bXVxZEZEOVZRR3kyNlgxNjdvcVlWRDhPVlFD?=
 =?utf-8?B?emMxSkMxYTJzdGxQUERTNDhHMzdYd0piV2hQMW1YRGxxNi9WQW9YUGJuampz?=
 =?utf-8?B?ejhiR3FPTGkwdlJSbldFWVVjUU5BdFVJdGFQSTBQTkhtM0p5UWpZUnBvTndm?=
 =?utf-8?B?MVQ5SEp3WldoN0EwWkUrZ3U1YkJ4cDdWYkVZQTBQdFJnRXJCNnV1dXc2d3ZK?=
 =?utf-8?B?VWViT014bXRQZUF3aHE5SGloYnRBdi9CRXloUHEzN1Rob1lUazM0cHF2Yk1D?=
 =?utf-8?B?bTNhSEs5cjNaQ0t3ODMyNGU1cjV6Y2w4MVk5ZGhWTnhRRTVQeWliYjIzS0pi?=
 =?utf-8?B?VytCK2k4c2NyQjc3aG56Q0Z4RTZPRUpkYmFLV0hFdktxS1RSaHRyM2xZd2pR?=
 =?utf-8?B?OEp0UVFUcGx5L3RsSWp2TnRaVVNjN2VlVVNvQTVFN3NiSEdGMlgreHcyc29u?=
 =?utf-8?B?bGM3MEltMEl5SzNyMVNQMVNPTU4wSzJIMmM1YVE3VW5vOHBjOWRBZXk2OERp?=
 =?utf-8?B?clNZSXo1b2M5T3NIWVFZV2pKdVF0bGdGWFYzVGZqR3ZsaG42RDYxS3dGczRl?=
 =?utf-8?B?ZUY4bG1GOHoyanRCYWcvRFp6anhSVDEyRkNMeWRWZjQvUllTeDVEQnlVTjJx?=
 =?utf-8?B?MkphRFMzLzc0UjFJSXpWTEh5R1UxaHVCWWc5RWZGRTdkSzk0RmprQllCOGJM?=
 =?utf-8?B?WGNNdmtkWnI1N0hYeWR4SmpUWmZ5WTB5bmRwaEhQL0VKMVF4SnBHOXNUR3dE?=
 =?utf-8?B?cFRJKzc0QmJ3QThyWmhKVDBGTmtCaS9OTlFpaVpUVlNlMTgwZEZKT1MxazRX?=
 =?utf-8?B?dVkwU2gzRHFxeWVVUHdQZVMxRlg2b1lraFppVVpKSjJzWUQ4SWRPTng1QU5E?=
 =?utf-8?B?cmJ2NWp3RlpNclFVTlgxRkxXTnM3MEs4MG9TVS90bWYxeWxrQUV4MDhWOU5s?=
 =?utf-8?B?WHdoZS9Sd3dwYUNMNVpuMURuZ1pDMFd2YnNzNkN1NGJ2WG9qdkN2bVJ0Q3FL?=
 =?utf-8?B?QW9rbnljN0x1TDZ4ekV0VWdRTy9LZzdVcjcwQkxnbS9lOVVxQmpXZmFLUm5i?=
 =?utf-8?B?Mjh5MDljclY3eDZmV1RFQVhkbVdLNmZrL0duRnNod1AvdlZuaWozeFpUNkl3?=
 =?utf-8?B?ditMOE96WklsVkFpQ1p3RC91dDhKTWROZDJVRnNXZTRmOUJvYzlVU3J2Ty8x?=
 =?utf-8?B?cElOY2ZRNmZmR0o1bGpHb0NtLzF6QmZucUR5K2N2aTNYaEVOTEZkRGdWZE04?=
 =?utf-8?B?b1JZTm5vRVp3dXM0RmlnUmJoc0JWeW9TMVlpblU3SlllQkN1VEhmZW90YWFw?=
 =?utf-8?B?RmxvMUVOMC9UeUE3ajNBUGlTdDFPaGNxOUhhcTUxMzg4T0s4amVLYmc1b0dE?=
 =?utf-8?B?ZG5UWXVhejVoRGJYYU1Wc3ZabzkrdkhtMmcyOFlEM0RQSHNXUmJScTZvekVr?=
 =?utf-8?Q?jSz7xBS5V8+7c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVRJWFhqQVdSSjN3U1hQZ2psYU9YbVRKSkhIc3lKQkg3bkRzT0YraGhDeStv?=
 =?utf-8?B?ampPTzNlamVtN0x0U09icXFTZUQrUFh6NDk4ZGZOTHhrUWNhSUtKUTlsYWxS?=
 =?utf-8?B?UTFQeTFHNzR1bW9CUUU2dHpkd3cwbVkvUGlaVFRwamM2VUdYVndRTDdVdGll?=
 =?utf-8?B?ZUgxZlZVR0pGcVRsQXBQOVZORmlabUxsN1VEMjIwek0zRU1INE42MXBLQ0RI?=
 =?utf-8?B?VktwN09oM0FBOG1JMENiU1pWSy9vWjNlOG1XT21uNHFBekVpWEtJWHVjUU1w?=
 =?utf-8?B?Q2l2ZzZKWERzY3Y3T09JdUdKZ3NLWll0SE1qa3VsNTdybTZ1QkhldDAyMGdT?=
 =?utf-8?B?UzFVU2U1c1ZhZ0FJaDN0bjlPbE8vZmt5SUNPTnFuR0VUN0t6UnZSK2IvckE2?=
 =?utf-8?B?WWJseDJyMlg4TlpDa2krTmlrT1JkTEhkNDNZL1dDMG03azArV2Uxb0FBdVVQ?=
 =?utf-8?B?am1EenJzSXZ1dDlVdS9WY1A0Q1pyYXEzTm1KVXh0L3JlUDJTUkV2TXBIM000?=
 =?utf-8?B?Y2VmaWtUZEF0cC9QUlQxYnFFOE1ieFlmVWZzZzhMSTJzWGlubzdNakVyWWxN?=
 =?utf-8?B?akdRcHJiL2kzS1JqS21WbU5xTU51ZElQUFRJUkxaRExic1laNzVHWnRjRGtC?=
 =?utf-8?B?QSs0Wm1YSW11R09XVzZWVnRJUHVYcS93WCtkT0FuTGI4dnV3MTIxZnd0NXFj?=
 =?utf-8?B?Vlc0U0tOWjJmU3RHbjQvZ1NQTGVQOURLVDVYb1pGUVEyRVJ1QmdlM0Vqb2pa?=
 =?utf-8?B?SVEyYXFzMlZ6ZC9LOGtrei9FdjAySGJIRTdDbTlweWtsSEhmaXVUeWViM0RM?=
 =?utf-8?B?OEpFNzdGbFYwSTd2RnJ1cjFvdmt1aTkrNnN6OFRoZFJmNzdpSHdNa0VFang1?=
 =?utf-8?B?SlpZV3lkL3BxTzFMczlTL2NLalpoZ3FmOTN0MTl6dnlPb0daa0h1OGgvaXkr?=
 =?utf-8?B?NWlvQVNsV2dKSnVnV3FYblEzdEh5cWpSR01CR3MvajZCTmpYMHNReDhsbmND?=
 =?utf-8?B?VUFROTVrUE5oOGk2K2tkS2c1UW44ZXhpcHVaVEFKdHRranhZUkpxOUZoRlJS?=
 =?utf-8?B?RDBERmpGbzgxeXBxcEROS0ZHdnBlRFlQQlp1VXJQYThscGlTV2RTRVVHOUNS?=
 =?utf-8?B?T1JCR1FFMk4vdFNydFVPY0xGdGFUSGlpYWtnMUg0NWg4Lys2dkt1UFBkVG9O?=
 =?utf-8?B?c28wRGp5aFpORHFMeSs1UnQ4ZUhTbXN2cmJLNkxkeENjWHI0bC9oNjZhOHVt?=
 =?utf-8?B?LzJWaHBFZ0ZsQWdIMmM5M3k4eDI1MkJXUk5LSWlrZ0ZHTGprbFlIYkd0eGxk?=
 =?utf-8?B?dkM3UndDOUdBN0VGQlgrRG9VVDZQUUNiUmE0cGgyZGhiNThkLzFkeDM3M2xO?=
 =?utf-8?B?VEFyM1FyYTFlRlZJanVNSjg1bjlXc3BwaW50MlVyaVcvSlloajhtVnpET0Vi?=
 =?utf-8?B?dWt4SWF3VGZkUGR0Uzk3ZG1samJLUWtDVlp1OWN0aHVhM2RMQXpCUHR4aU45?=
 =?utf-8?B?czRKb2l3SWJDdW1jWWFxT25wNmZjSVVGKy81dWxmTXFieTdkNW55OGI1Y0w2?=
 =?utf-8?B?TVlhSHhBeEVWMVlETFF1dXIvNGRhbTRKWUN0aUpkYlM5S2hMeTN5b0prTFNB?=
 =?utf-8?B?MFIrTG1uUXpBdUpZK29sZVVHSWRaRjEwZzFmVnFiRGpiemJFdVFoREVOZ1ll?=
 =?utf-8?B?QlArbTVleXFKMEl5K0hCYlp3V3FVbFp1Mm56VDR3UUpDTjE4bWVpNkJyV2xp?=
 =?utf-8?B?V2oxRHVEbGZEbkF2cEMzcmFlSlpPRUoxY0Mzcms1aUVXK1QxUVNtUkI5NjRT?=
 =?utf-8?B?d0d1MHlwTmdxV0hzZjVRenV4TmVGa3RUM0lwNkhWdE1TVlhNTUlhSEI0bmlS?=
 =?utf-8?B?Z3NLQ0FXV2ZiQ2lJUzA1Q0JUOXd1RHJUWlZvYWZCUTk1SVl5Y1BCMGxuQm9t?=
 =?utf-8?B?RjdJK3lhN3k5SmZyZWwvczRQMVdnR2lJZll5VWgwQXJuL25zaUQxQ2FrY2Ny?=
 =?utf-8?B?ZHp0RlR1VTJlb1kxc200bjhkMkhQdkhxeld4eXRVVTJNZkVTeVVBc2EwMFlQ?=
 =?utf-8?B?a0xaalk2UURnQzZVTlgxZmZWS2pVT0tiQ1c3clhsa3dZaDVvMGpzbUpiaGJ6?=
 =?utf-8?Q?G4CIGyjLMwW+XUW0Ua3W8wQ70?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9392b6e-50fa-4503-b875-08dd657a493e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 17:36:44.7149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FpBwOisqKxJijs8G0k5plgjCXhLQfgl74hfK9hi8+gE3UV0BE4/wPLPaw514/fVEAsbwjzf2N+PWcztFq3zdsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF521FFE181

On 3/17/25 12:28, Sean Christopherson wrote:
> On Mon, Mar 17, 2025, Tom Lendacky wrote:
>> On 3/17/25 12:20, Tom Lendacky wrote:
>>> An AP destroy request for a target vCPU is typically followed by an
>>> RMPADJUST to remove the VMSA attribute from the page currently being
>>> used as the VMSA for the target vCPU. This can result in a vCPU that
>>> is about to VMRUN to exit with #VMEXIT_INVALID.
>>>
>>> This usually does not happen as APs are typically sitting in HLT when
>>> being destroyed and therefore the vCPU thread is not running at the time.
>>> However, if HLT is allowed inside the VM, then the vCPU could be about to
>>> VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
>>> a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
>>> guest to crash. An RMPADJUST against an in-use (already running) VMSA
>>> results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
>>> attribute cannot be changed until the VMRUN for target vCPU exits. The
>>> Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
>>> HLT inside the guest.
>>>
>>> Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
>>> request before returning to the initiating vCPU.
>>>
>>> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Sean,
>>
>> If you're ok with this approach for the fix, this patch may need to be
>> adjusted given your series around AP creation fixes, unless you want to
>> put this as an early patch in your series. Let me know what you'd like
>> to do.
> 
> This is unsafe as it requires userspace to do KVM_RUN _and_ for the vCPU to get
> far enough along to consume the request.
> 
> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
> to be annotated with KVM_REQUEST_WAIT.

Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
This is much simpler. Let me test it out and resend if everything goes ok.

Thanks,
Tom

> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 04e6c5604bc3..67abfe97c600 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -124,7 +124,8 @@
>         KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_HV_TLB_FLUSH \
>         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
> +#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
> +       KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
>  
>  #define CR0_RESERVED_BITS                                               \
>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> 
> 

