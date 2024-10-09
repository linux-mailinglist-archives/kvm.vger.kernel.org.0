Return-Path: <kvm+bounces-28165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A8C995F55
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48197B22B88
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE508168488;
	Wed,  9 Oct 2024 06:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P1MhSpaT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDE64A3F;
	Wed,  9 Oct 2024 06:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728453682; cv=fail; b=ReS01uWBuB3LVAl+p7hXiY+/dMtflFqT3Raj/a1yQcBf855CCfxIcBcjc/SJgVU4naRxUZGV8dJkYsnlZWr1ZPt4V64yF2JV6xmY4PzBifiqkrw4lds6s9HYCPP+yWzhCmXe2CtBedhbJsOzvfiLg6xMRRQhZ3Kj5BT0lM6YOHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728453682; c=relaxed/simple;
	bh=Q2nIfMzJz7Kw+n6YedMbMiZvq4ANirFvPt8+WYqqgUI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IqiWIAIwdZKW0PJtaw3ZRXL+rLXHuFRVlUoeBuqSjazz8SLU9iuxBqUbvnIrSz8D5v9bSe63tBKJ+dn1TqcCLgENjZq+nKQGYuWk+ukIAr56ZUVdOP4ruCt34bnck+JbWG784+2DH8yXWPlhBjcDig/UATnXA/8NeXr4/aUX2xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P1MhSpaT; arc=fail smtp.client-ip=40.107.236.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CQlBc2km8hXjdCZqFPPeMnpF1UpGdmhyZr9w5Rnf40a7yetmNqz4iLyzlpRXkpeiWHlZzv555AmYGhIegIN5uX/Bhn1aTCCGG2nHgL+C4KB01E/7NSJClQqkbIqi5iTOcsP9RGCIOnyrqySJzB+Jt1+XxppFJBiRp7lh07xdKwyxz83hsFJDw/JXGk+0mNWeJkHzmfmA7JGHaz0djn9hvUKXwjASsSvWUvuoFlvEfXDxhXatMX8PCJjvN6pLfX/ZrHYtYy5mtVdw80txid1IVjrDEqe6d+QEAVVk2Cnlvy+GMec73DePNq7KGGvWNgXBCuubnjV5ZHxLOCbJvWX5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rA7i4oBREuvRUSnspPrN5BgxkcuUJSg7UyPoL9Mg8TU=;
 b=I1bdtw7+EMn2DjPJ+1KYynh3l93UcJE9GcgmnWDWNEhzjieZgi2XJY09OszLO01PjpXA+xokJxY2bP23SZFEGLYPXSA0HzSeoccrbeVUNvt2Mh9xVOyFpdDGKjSbVgZOJ2XjDdErAf76IN9nL/Exb6T8Hyunxn0SjA/K2rcnivhgjSb8MenOvuWYc+Wj7j4QhcJJkbm4kdcknjhivssfBTDoGHYUKZJpG5hTS8+/13vi0wxvFdTEE8kMXisctNIwjh2K9QkDDx+qe6Rb3Gcg6SjtKZOgZC5Xk+jLU/OJuV+bo+P1C+s3FAgICtn5Cd2ke89u7VoDuVsd7KPrdU7nOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rA7i4oBREuvRUSnspPrN5BgxkcuUJSg7UyPoL9Mg8TU=;
 b=P1MhSpaTBQNFUzcfAG7U1r/Hi+ztL9RfH+YrvqYGnFXG2Q7uiKfnahMp1CS8mkfhFV9GvapeEEAPRlES7Qam6E9Ek3jX/OXNa2sD8G73nuY5zgMrAK/fPLYbVr6EMX3qcJvdwCtSWzB/odjxeAPrslN6K+ayXbZ1LqAHb0vq73Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11)
 by MW4PR12MB7165.namprd12.prod.outlook.com (2603:10b6:303:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 06:01:17 +0000
Received: from CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0]) by CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0%5]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 06:01:17 +0000
Message-ID: <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
Date: Wed, 9 Oct 2024 11:31:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
 <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0232.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::10) To CY5PR12MB6599.namprd12.prod.outlook.com
 (2603:10b6:930:41::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6599:EE_|MW4PR12MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: 88455d33-2570-41dd-e14c-08dce827ca24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nk9ySjhHYmR4dUVvelNSbkhHOStTcWpoYUl1ZEJhbTVYQnB5RHBHTkFGTGNz?=
 =?utf-8?B?RjkvUHB4UHZwWHNldUY3MDVMM3NzNEhnb3pDcEMva2lINFFOc2FSdmpmQ2tF?=
 =?utf-8?B?WXpLR3RxUEFjY2VNQk9QWUdlUm93VExKdUlYL1pvMitsb2RuSzBUenlSR2xw?=
 =?utf-8?B?YjhKYkw5SHRTK3VBaVRUYjNSMXYvZ1p4QTc0SGpubUZMOUtqajFMdjFrSTlG?=
 =?utf-8?B?MnUzU1VUNTZRSVUzU1crUERhQU9YT0xpc3E4aDBoaHhYOWU2VmVBeTQ4cmF2?=
 =?utf-8?B?ek4yWXZ2akQ4QXBPYnI3d2t6dGFoZkNlSXUyYjZ5V0RpNWdSNVlzK3ZxRFpK?=
 =?utf-8?B?d2ttdVluZW5uczBUS3FrSlRCb0d4Umd0d0VqdDdSQUVFS3M2TUpYa3ArVUxj?=
 =?utf-8?B?YmttNkQzajNieUwzUkVoWXVPYktMM1IrcWpickZxK2l0clV1Z0E3eE5FVVdW?=
 =?utf-8?B?eU5nbEZHY0lDMGhkNVBFRjd0SGd2RzcxR21uSERhU08vMGJZYktXQjJUNlhR?=
 =?utf-8?B?ZlRLY0lMVjduMjhOWWN2Z0g5bGhjVGFVR3ByQjZ2OVFWWk15NnRlTE5xeWM2?=
 =?utf-8?B?Z2VOd3M2ckllV2JtRktlOGlGbjZqRWhpaVR0QUtnek5waUJjUE13by9zcTdm?=
 =?utf-8?B?SGdsTzJqR1BVczFjbTRPVkxiSmFUNHMxNlZxQ1oreFMyVmlLQlpVNGtZQ0Zi?=
 =?utf-8?B?SHhycTZSMnZ2SnpIVmxDejBqZGVySzFCY0xSSk1KOCtrRWc1TVZCQmZaRGRE?=
 =?utf-8?B?UlhCNExGTDZqRFd2OVZ4V21vWnFVaHBEL2ovZm9CcFVMd01Cc3M5YmJDV2Nv?=
 =?utf-8?B?akVSdGM3dkNYWnVZR2poTWlUVXhBS1BIeG1pckRTVjEwMExUNWRRNzRKTytY?=
 =?utf-8?B?b2U5UDJoUWY4UHByeHhjNzRKWGtrV3BhRTNFdzBnc0RJeUxVb1pSejBLeHdY?=
 =?utf-8?B?WFlIZzIwWXpWVjFvL1RGNnBIcUlnZUh0L0ZqWEo1Tm13QjZMVkdWbVRRdXZ6?=
 =?utf-8?B?RURYRThVT3I5NWxQNm01Tm1LZ2pjZWRHdXNKZGpLRUhpb09wVzVIcW1WRTdW?=
 =?utf-8?B?Wlp6ZDc3T3BXdnFJanV4dnF0SzdLR0NqVEVrREFQbUxLbm5OZkhxakZoS3Jl?=
 =?utf-8?B?S1lQaDNWcXFLV1Y0RGFSMVRzVC9JTWNBczIyaCtKT3JBbmNZY1BPS3VVMFJR?=
 =?utf-8?B?U0g1eHF3bkVvRzlXVHdnK3dkaXcwYXBPZmFKTVdzVzlrNXJRTHk0Z3A3NVll?=
 =?utf-8?B?dFdWTVNpckNqd00rVDVlN1l5dUdsNGJFK1lGMzlTU0xSTGZ2Mm55aDBWZktF?=
 =?utf-8?B?RXJjYktJaHZjeEJvQXYvMlJIOHFXdzdlZjlGQmpEalVZR1k4NzlCQjRNSExr?=
 =?utf-8?B?VmdQQWFpK2MrVzlXeTl1ejlRNmdIZys4MWJhV0ZIQ2JFT2NJaVhDaVUyT2E4?=
 =?utf-8?B?QkRjWXY0em1TN09yWTM1dlJBeDFTMGU2TXp4ck1HOG14dkcyeCtBTGFYOWdH?=
 =?utf-8?B?YnJUZ0NlOGVKY2s5U1hkMk9zcmNHUXd2Q2w2ekV5WW1rdlRPVjNGeTdSZlhm?=
 =?utf-8?B?dWEvOEs4MDA5TGZVNHpMUEIveWFwSHRVQ0gyWndFNko5NlBJZW1Cc21qZnM2?=
 =?utf-8?B?Q3NCNXlXSEEvR2N5TWRqZlRUZ2htT0owTEdQVW02Q1daMG96bStmajhQSTF6?=
 =?utf-8?B?Wk9JaHVmcEtiZ3VuZ2Q3VEt2cnJBa05lL0ZVV1Rtc0ViMFE1dEpUanRRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDAxS0RFUU1kRkEzd1Z4enNkdHFoYnhvZ01HcUlwM2xvNjFJeW5YZWFPOVM5?=
 =?utf-8?B?QXAzVndFVG1NOWxLTjE4djlZTElEVG1lTEl2cnFXaEM5RVZFYVlteXI3UjZm?=
 =?utf-8?B?amRvazRaaUhoODRHVTRmR0krVjhxUkpJdDlrTmZYNE11Ukp2UFhBaFFTR25Q?=
 =?utf-8?B?VE43WDd3N3g5bTlEL2hFaHJKWG1HQnlJTk1VWmgxTEFHcTFmeUNaS29mTUd3?=
 =?utf-8?B?YXNyUkYwRlI0UCtGNWVkVWwxcGM4aGxlTysrV28zSUNyc1N6VVBDOTVoUmNZ?=
 =?utf-8?B?aFA1RU9NTWsvdUdjTVJTU0RmS1hsQ2EwbitFNHRmZUNlbnFYdC8xSUU5N3Zq?=
 =?utf-8?B?NnY3QU9OUVdlVXFrL2llaTYzNVRZSkpwQzVKK1U5c3k4eXNpS2hONmpDVFJS?=
 =?utf-8?B?RWhIVlBtYkU4cldObEgzd054Zkx1S0tzNWJJYy9oTmJSWnp3dldZWG81WlZN?=
 =?utf-8?B?RmdCYVN3ZEhKZlhXNXRGYnl2SmlEL1AzY2QxYmx6SkQzeXBqM05lekd4K0FW?=
 =?utf-8?B?NDF4SmhsWjc2Q1hONUFJeXQ1cjhHNXFLZG1jYjBTcE9ZejFtM1RYc3ovcTlp?=
 =?utf-8?B?ODdvVzVHajdvaVFlbXRQT1BjYmRvTlcwbzhBQ3hKM2ZWYzFZbWRpZmJsdTFs?=
 =?utf-8?B?aUxRVS9rR2RVc0FKdjV5dnFNVmlrWmI1a3NuV2dWYTR3YVRveTh0Mi9QcC9T?=
 =?utf-8?B?cnRsRG5oRXduN0FUU1ExZGZ6ZmgyUzlieDBUaVozdmt2Z3VzajFCbVRzd1pp?=
 =?utf-8?B?cUJHY2Y5elUxbDRRSG1MaVNqaHJUbWlxL3pFK2Q2N1FYRDRjeXhqQmVXSlNx?=
 =?utf-8?B?SWlJTXo1cjNNdUxUSW5rU2tsa1VycysrYm9mUHlaZi84SDNHaGt3WVp3QVYv?=
 =?utf-8?B?d3ZjZTFxNVRnNG5nRE80VzIzdzJNT05JeExWUFVWZklhVk5BaGFuaUI0c0hP?=
 =?utf-8?B?aXp6VDE1Z2plRC9xMHRhbzUxY01TZVdybTR3dVlQK2YyTnR1bTgyTG4wdjlR?=
 =?utf-8?B?b1kvT0x5ejZNR2tCYXNJL0ZrQ3ErcVNnZ1FhbFlHbjZacmVVZWVELzhrcmFD?=
 =?utf-8?B?bnNvejFmK3VHYUY1K0ZoSEVrb1lHVjdKUEVTOCtIMGRoWVZVRXVPcng4ajZt?=
 =?utf-8?B?SnRUYitYaVo4Y1VBRnI1aVMzOWxFSno4Ri9ha01TK0hhSWRpMDRJcTJMSnpM?=
 =?utf-8?B?L0w4dkkvTG1YVHgyTFNOTytVemNGOU5DQzRMbFo2L21TYVNweXNYVWpuRy8r?=
 =?utf-8?B?S1dwMS9ndDZVMXFTb0wwdFBkTktxSzdrekdIQjNqTlZFYnV5cXhRSzFWYnVJ?=
 =?utf-8?B?eDJvZGp2bTBPbzNzQ01hdTh4eTlEZjBXSURFV1RwNGtuRG03Q3R0OUd3enNT?=
 =?utf-8?B?QVJqNnc2RXVKY1Rrck4rZjJ2clZ3VVgwbHM4QUk2Ni9kTHdQRWlDVEkybEUw?=
 =?utf-8?B?NDd1dG5sTjM3aGRTNXVrU0x3a2xDSXUvUVBoR0gwVTVLTFVEMUxoQTdXZXNV?=
 =?utf-8?B?NmtUZitvL2hZWDcxQzhNajZOVlY3N0RHakdrVUZxcnZETnFRTGlPcVNEYkQ0?=
 =?utf-8?B?cWVKT2U2aHRzR3poSjYwbFBNWmdBWC9aRDhtYzQwZW5EL01GSE5wM2djU2Vs?=
 =?utf-8?B?b3FYb1NwbEpDRHNielJrSFVGU0lVUW5aMmpmR21SaE44R2FSWGdsZ2FKeXdG?=
 =?utf-8?B?Nk4raGMzSDJ6dk9xZVNYaDZ0UGlPWWpNVCs3NWZtTDdBTkZPMmRLbVFveUR4?=
 =?utf-8?B?WnZEaW5oTDlsSm1oVE9PTnQ1enlWZ0o5NnV3Um40VnErTXFWY3ozSTlJdFdP?=
 =?utf-8?B?NXNyb3p1YlF0M3JNY3ZSSGFTR056RzVPNVN5c0NtWXhpRVZlY1ZMNTFNQjNz?=
 =?utf-8?B?MFpPZUZhUTgrL2lRdE5YUi9pT1oxOHl3UEQraDNYeGg4OGNlRUplQk1mWjg0?=
 =?utf-8?B?VU90cXBDbjk2R3hYcldTQnJXR2owMkgrYkpNaHFxeE9CUUM2MTU3VnVaaFVO?=
 =?utf-8?B?ZEZ4YnZBRDVod3UyVytNTjBNeS9Xd0FlMlR1RjV4L2x6ZkN4S24yaDhWcGxh?=
 =?utf-8?B?dllTN3BCMTNPRW9aM3BCa0hqQUw4RVdoOHhQRERNVjFvZXZTeXVnYlhYWjFi?=
 =?utf-8?Q?6PZ8kjdbPb4xZ14R+wXZFMJg0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88455d33-2570-41dd-e14c-08dce827ca24
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6599.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 06:01:17.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CITRtfMxrGzZIW1xI0D0zop+EH+APG+/TGkt7f+3ZhZLfThlVY8V9ApHQWRgX7NhRjel+O+Rt3DILHgbmX2iSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7165



On 10/9/2024 10:53 AM, Borislav Petkov wrote:
> On Wed, Oct 09, 2024 at 07:26:55AM +0530, Neeraj Upadhyay wrote:
>> As SECURE_AVIC feature is not supported (as reported by snp_get_unsupported_features())
>> by guest at this patch in the series, it is added to SNP_FEATURES_IMPL_REQ here. The bit
>> value within SNP_FEATURES_IMPL_REQ hasn't changed with this change as the same bit pos
>> was part of MSR_AMD64_SNP_RESERVED_MASK before this patch. In patch 14 SECURE_AVIC guest
>> support is indicated by guest.
> 
> So what's the point of adding it to SNP_FEATURES_IMPL_REQ here? What does that
> do at all in this patch alone? Why is this change needed in here?
> 

Before this patch, if hypervisor enables Secure AVIC  (reported in sev_status), guest would
terminate in snp_check_features(). The reason for this is, SNP_FEATURES_IMPL_REQ had the Secure
AVIC bit set before this patch, as that bit was part of MSR_AMD64_SNP_RESERVED_MASK 
GENMASK_ULL(63, 18).

#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
				 ...
				 MSR_AMD64_SNP_RESERVED_MASK)



Adding MSR_AMD64_SNP_SECURE_AVIC_BIT (bit 18) to SNP_FEATURES_IMPL_REQ in this patch
keeps that behavior intact as now with this change MSR_AMD64_SNP_RESERVED_MASK becomes
GENMASK_ULL(63, 19).


> IOW, why don't you do all the feature bit handling in the last patch, where it
> all belongs logically?
> 

If we do that, then hypervisor could have enabled Secure AVIC support and the guest
code at this patch won't catch the missing guest-support early and it can result in some
unknown failures at later point during guest boot.


- Neeraj

> In the last patch you can start *testing* for
> MSR_AMD64_SNP_SECURE_AVIC_ENABLED *and* enforce it with SNP_FEATURES_PRESENT.
> 

