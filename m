Return-Path: <kvm+bounces-37978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 537D7A32C68
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 17:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D3CF3AA49B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9266253F03;
	Wed, 12 Feb 2025 16:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TIjhE/qA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7199C20B1E5;
	Wed, 12 Feb 2025 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739378999; cv=fail; b=sWyRizdLZBpAB1IEx+OFRdpMdqKSXnf495R1u3b6KCbUYVG0oGIVFTMqz0/N9ljjmA5MktXeFQi6TCtsK6CZkkLFIC7+iZbzRqteLnO9AeqYFeK/7Ug8V+YYJwKNjkHrQHN5FQZhPc+nG03NGlELL4JbQxPTs/o2p9yU0vmyKzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739378999; c=relaxed/simple;
	bh=/d+eDOgqhTmZDvD+yCJiUZXdKSJ8v6k7T+U3+EUb6U8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qUPtZoZQUzFArn9CDvPUTETontXMRil4vjsH0Wzx5RtbClhgc4nKkr7ZneQEh80AlZ5h0E92LEv7AVbvuKAcfH+dO3NC8K1noEJ6aMRv0fAzvCy6NPCfif06qO5pmdxxJ5gPjd9AD0aYeJMWo0Y3K7fDQmSwM7NrnLvBgtrTReA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TIjhE/qA; arc=fail smtp.client-ip=40.107.95.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3c0l23xfZiQFZ788oheJaiCr6Uv/cMRSIZaYkIc3JhkuTolC3loQ+rYAlsh6whlZrlJtUsPD6fodeu84PMOIamlna4KAocYgiVZgBqHDCHR+jzsqrdL2iAfH5szCRBBnVbCmTrK6qvtgeflV3Ndv60pA63oEuzcvAS/fyvY6/OWVpztpe1R9Depc+AlR91D0Cg9ocStplrvPUfqAACLXIhGMNR9tHr1v7GlyObsJNhpXddPldpInU1xryQ13jbaU2NOk1Z/arPBkMV7yWbr/UPZbToc1i7V/pg+g95jmhxyDAfT17hlV5NbgyzG9jQjPUnWchHKYQXYYdIRHGKYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxXSYxMHQQEL/UkEHf2xJX5B7OrgUFtjDNKz+QOQq6M=;
 b=Z7275/dBv7VfRHpboJ1fmHoBdazcXw4CsXuKWhu8yFlMGKOHsXTg6evSoxe0u/BnGn/c5vD7qke2ICx3WB4xENWZnze4CFKOcSyPnGe6jyV9IucHpdoJquSUTy8EsKA93nulDNKntIG9clH3HyNpgrXQ1ea7GAM0ndOgysM6rb/7s/c8EJ3x+JHTCGsd9pAYAICiH7hYF2zt8Li2arjZLzLiXauh8iC2RwJBiryw/yonTQ4yKtOH13eO5B5lpY0s0dVd2ZBLZ9IbVNWYy2TQoO6S0EBbxszv3CmF00oen8uZ33tRYebvrPvwNOXiI1lZqrWFvPVO1WUxhd3tTeoeQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxXSYxMHQQEL/UkEHf2xJX5B7OrgUFtjDNKz+QOQq6M=;
 b=TIjhE/qApbtMveXAI3Zo0uRp5L6NX6sI2qC8rNEhvxYAbPS1vJAN2CVvX8YpzQc9n0A8FJa4qJ5HcTre6s1MH4pIm5rJ5chTfOPCJTPw5mz+mUZOt6jsikixns2L9RfB1UhaSejYKhdI9iTfGpQ3K2BC6XGV0nmy82lS7PQyJEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB8346.namprd12.prod.outlook.com (2603:10b6:8:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Wed, 12 Feb
 2025 16:49:54 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8445.008; Wed, 12 Feb 2025
 16:49:54 +0000
Message-ID: <e17d5f83-9610-19de-c9a1-8615c1894e77@amd.com>
Date: Wed, 12 Feb 2025 10:49:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 03/16] x86/tsc: Add helper to register CPU and TSC freq
 calibration routines
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Juergen Gross <jgross@suse.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 Nikunj A Dadhania <nikunj@amd.com>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-4-seanjc@google.com>
 <20250211173238.GDZ6uJtkVBi8_X7kia@fat_crate.local>
 <Z6uMOyHD3C6-qCXz@google.com>
 <20250211203250.GHZ6uz8qs-bzcbi0_b@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250211203250.GHZ6uz8qs-bzcbi0_b@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0008.namprd10.prod.outlook.com
 (2603:10b6:806:a7::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB8346:EE_
X-MS-Office365-Filtering-Correlation-Id: 58a9e2f9-fddd-4939-1484-08dd4b8546c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHYwaVZhbG1ERVIxY0QrREFtOHdtdDRUYXRrMFV6eWRVbDViUVRMTFp6VGJR?=
 =?utf-8?B?ajhBOG9oSUhrckpGNk5FMHZnV3B1Y0EwQjBGTHFJTEY4T3ZBaTFNS2EyWGdq?=
 =?utf-8?B?UXVmYzQ0d1I4aXVmUHpsYko0bE1ndTBXb2cvUjF1R3E3cnBHcXVlaEIxTmtw?=
 =?utf-8?B?d3N3MlNhbGVhbmN3R2lGT05VRlVreWs4UnR6aWJySHVvN2lXZ010MGU5Ri9W?=
 =?utf-8?B?dU5YZkVRcnJDeHYvTi90aS9MaS9xcmtmejFHYTdaSlhWT1hwb21WM3VnVEJQ?=
 =?utf-8?B?Wk01UUNTRXB6ZFBsYzcvWFI0SGVGT0hjUVpPSU4vdEdyUXk2TzZBNHp2a1dN?=
 =?utf-8?B?dENKaXd1QzBTQUpEM2dvaEpJa3N2YWh6MXJ6NGl1ZGhCZThyUG1XOWZrYVdH?=
 =?utf-8?B?RFhPVm5iVXIzbFZxV29VQVpScGRTemdqR1JRQTVpaWNkSWFCNkVhK1VYK2NE?=
 =?utf-8?B?d3hjREhXUDgzTTV3bjVieHlaY0pHQ3o0c2lQNDl2ZStaWnUyNXM1c0d1OHli?=
 =?utf-8?B?THY4U3NUOVhyYm9wcWRUbklWWmh3YjJ6d0RXdm9Na21ybVRTcWZNbk9DT2Fr?=
 =?utf-8?B?ZVM4bE10bmhBOWJkVzAyNStDbVRQNkpjY3oxcHc0a2cyazV1alArMVZwRXNr?=
 =?utf-8?B?TW4yWFRnTkdkZGkzcDVKSG9kb2NHa2o5K3hFOHlrY2xoTS91T0djeVJ3WGg2?=
 =?utf-8?B?QmtlQTJZaS84eG5CM1FzVmthbHEvV05KTzdmeTMzS0E0STlxTEduVlZNT2Zn?=
 =?utf-8?B?SVpqckJGazBDVU5ocVZQcTl4dGtQMVhHV0VweDNBS0xodEFhTHMycm1KQitP?=
 =?utf-8?B?bTJNY2tIVlVLOTFkTDVTdFVieDdDMVJiUXdZT0ExamhVRjJDOEF4TzE5M2JX?=
 =?utf-8?B?bEtxZ05yUHFrTk5pWjlxMnV2bW93dGVqci8wUTBzN0I4bmdzMGsrMVY3Skta?=
 =?utf-8?B?L0k3WmVkdmRMZzhiTVVWZkdCUmxldmxWTUZKM1VjQjA0SzZWSHhEZnFZWTlx?=
 =?utf-8?B?UElXNFNuR2gwVUhUVUd6KzVsVkNBWHkvQXN0MHFqS2wzcTNaVDBRQmdnVFI1?=
 =?utf-8?B?TkdGM2k0MlVkWjY0aVpGQ3o5V0l3bUZyVWQwdkpJODVuakw4dlIzU3FUUjFy?=
 =?utf-8?B?YzlRcVFSeGhKZ1haUVFYeW9YYWtLQWdiaHE1R3B5a250bStsWXVUaXRSZzN2?=
 =?utf-8?B?YzlpOXVXVnpLMm50L3kvTm5nTzdpZUU2SXk2MUd5UWtIcUEyZlJjQithWGRk?=
 =?utf-8?B?VGdMd2w2WDNWZGJsUXVoa1hzdStjQUV4clpYMnJvK3E4WFVwTHRWRXdZSDJ6?=
 =?utf-8?B?YXdDLytCcHFTcExEQXJIeXFqR3oyK1dhbGtycHBEa2l5TWRLM1dabk1JWnNR?=
 =?utf-8?B?b1grenBuVjMzZjBORzhmZWxEVDBscUhiU1d4REtyVjNJZG0zZkJPS1M3YndT?=
 =?utf-8?B?ZER4N3M4U0orb1A5NHNKU09lcklDeGF4R2pvR1R6dHpQSTRGU0xtcVQ3V2VT?=
 =?utf-8?B?QkJwbzlLL0FCaTBiSzZaM2tHTFJCTlRYQ1dZRFdIbzFDVHdtc3ZITHVRQTRi?=
 =?utf-8?B?UnA4cmhFUXRFWVdQdFJCbTF4WlVnNjJwQm81VG5vOGs4dlFNano0VW5uMWpM?=
 =?utf-8?B?QXVkeEFnbnJoaDhTeFdCK0dIam5PSmRyQ2RMVloxK2FKQVFmOGJIdEUxV0ly?=
 =?utf-8?B?Zi9tR3JqSWZQSEFPeWNxOXc3aitUcmhUczBIT3BrVVZkbDFWWkhVZEZMN2JI?=
 =?utf-8?B?OTEyUlIwOExPakNQTjZrVGd1RlEwWmYyeElQQVNVaDRRWU9jZ21RTWJ6d21W?=
 =?utf-8?B?dU1zM0d6TU8vRVNjSlBGK3ZWNCtKa3JqbHIyb1V4MW0xcnZpZzdsdUFjV1N4?=
 =?utf-8?Q?1jPgmEKBjoc9X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFFsRHpGS1YwbW1DSnQ0YjdLYXFqQ3ovK1FnQ1o4Q09jZHpjQ1h6MEhsK0hH?=
 =?utf-8?B?Z2RETGVKMmt5dDNSeDlBRVUvbFhNd0lGSnowQXdQQzdqL3h4ejNFY20wUy9V?=
 =?utf-8?B?dll5RDhSazRuclUreTNNRmErUkFNRC9teTFWTmh0NUtmM05KQWpmY0phR0pW?=
 =?utf-8?B?dkJlTWhvWGVjQVRGYzNDYU80UVBpbmNzNWNSTzNjYUxFVVdJWGJySnRwNDI4?=
 =?utf-8?B?dEdrV2c5WXJmYzZJUFpNOGJrVUphQmlmVHFNVjhrSm9ZVnNLZGdjamhKRy90?=
 =?utf-8?B?UHg0SUVyazBDUGx2d3d1eCtvUktGUTVSNWdlTjBZSldpaldPdFk4SlVna3Zp?=
 =?utf-8?B?TDc2QUxPVEt2U3pacEdDSDcza24vNnJpZWx1U1NuQ1lWckJIaHJhR3FOSGxu?=
 =?utf-8?B?aEJTRThMVWxIOWhMakxFQzlxeTZ4d3F1OUxDWThLYmk4NmNuUGFDaEZoZGxx?=
 =?utf-8?B?QkFhdHNEM0JXQVJCOFlPQlF2MEJXQlZ1UUhCblU2c1RIR2pobW9vQkhwckVH?=
 =?utf-8?B?OU9MZFp6OXJVQ0FadCtSdWhHY25DS2NzQjYyOVh2ekVHYkNSTEppTzQyK2VJ?=
 =?utf-8?B?Zld4KzVkN21SMVU4RGR5OW82YnBZbG8xWnVoSGhza0lNQ3MzN0VubW1VWFk3?=
 =?utf-8?B?V3BVMkJZUUJFK0xjVDV1b0NRaFJnVC9mWm5nL0lqQ2wwMVNvMk51cG1GcnB1?=
 =?utf-8?B?bWNDZEhqbmtOQUZEWWJMNUZtVnMxTkNTaGJCMzJCUXdtVGkrbWhHWndRWVNi?=
 =?utf-8?B?LyttT24ycmZZNG1KMjBibDdVek5LZCtNaUwrdDNCZ1FZcTA3bzZIelJid3V2?=
 =?utf-8?B?RWFnVXRmRWZMTVJxUjNyRnhobjlKMkJ5UzdOVlZwNDNHRGsrTFZRNE9WYjRt?=
 =?utf-8?B?ZUZOUUpFT0JBVmQ3bjVBcjYyZFpKT1VvSXJsaTZnYnNiZy9LNW10VS80Szha?=
 =?utf-8?B?bHRtaXd2czExQ1M0b3hic2ZDOVZQYy9tUko4aTUzSS9zS2xoa0gzSzZlOEtK?=
 =?utf-8?B?em1nZHNVV3lkVjhJbVJiTEhQekZIbytUbGJ5VTRlQmtla0kwSU14TGRvdGd2?=
 =?utf-8?B?Vk00d0kxREhxZkJpYTJGd0hscmNRRmtUUUQwN3Fqbng4TlVIbUFzSTRGaUtj?=
 =?utf-8?B?TEFhOXVvQkxGai8zUm9ZcDcvUGZ0dFF4blc4Mk1lVUZNYTlhL0srVnk2SnVC?=
 =?utf-8?B?MkljQjB6VU5JdGJyTU45bWJsSkhmbkZqVDQzY1FRemxpRXZQellkQVEwU0sv?=
 =?utf-8?B?cnlmT1hwTnpjbmZjOUoyNnVYWmlmQksxZC9lb3U5aldQVUlPc2F0b2NmYldF?=
 =?utf-8?B?S1R1T29PQjZZbWJkaFNzN0toRXExaytaVkVWdm1tdVFkY1ZWbWFUVUdtSW1i?=
 =?utf-8?B?KzBMN0RkTlQ4SUtqd2VqV3Nuek9vK1RkY2phTmV3cDF2Sk5FelVDOGxTTHZt?=
 =?utf-8?B?a1k0K3htNnZtR0s5Zndxa1gzMkFINU1JOVVvcXFzeVpYWG1mRThHbU16dVYv?=
 =?utf-8?B?Y2hGTDZrWGVaRWNvN0Fuem05Rkwya3NITll5QU41OHdLWGgvNXhWajg4NVJV?=
 =?utf-8?B?M3REc0VqOW5KZElCRFJTaFNPNGUwakNZUHpGMFMxUXhPUzB0SndKdzJtRm8x?=
 =?utf-8?B?OTAwWE02eHg1STJUV3QyMmFJemMxV0xzMUUvSjh3Um5ybU95TnVocEdWd25o?=
 =?utf-8?B?VXFHVTI1bG1yZUFlbk5HaGJlR1RFaHlXN0d5a0FPQm5SSmlLQklXSEtXN3gx?=
 =?utf-8?B?TEFXVURLNHZuSUtEMlI4S1hwSFVjYWQySTVlOGVuMmxpOGZ5azlXWnlCUWVK?=
 =?utf-8?B?aFlIWXBxL092dHh0M3ZCck5ER0hTaXF2RDZOUzJrTkxVSVFkMkt1YVJTTkwy?=
 =?utf-8?B?WVhyT3o2UGtOZHAzWTMwNDEzM0dLelNteEIvcXE3eW42MEFrZEF4eHNpZm1W?=
 =?utf-8?B?RC9ndks1Q0Fvb2wrOTZJano3ZlZyb0RMN2liRmVhVVhvTzRtRmVJcHcxbUJk?=
 =?utf-8?B?UllyYVZLQzlFckpFT3JHODFLd0F2SDM5UlREWGJHNGpIZkdLT3J5VWNFMnYx?=
 =?utf-8?B?aDFQTThDRHdOc0lhandIbDVWdkxwd0UxQ0FQeWpPTjNYeU1YWWxvMWNZUWZE?=
 =?utf-8?Q?bcfpdTiSGoLUnqEOEC0RUDKm1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a9e2f9-fddd-4939-1484-08dd4b8546c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 16:49:54.7826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QsOW/s5cyf3TBLz/tEeC2N0j3jW4ebS0O2pJzeQkI2qyFRrFFvbFbkrtg9Z0LuC4FmGQtlaEnGo4VPoLEziGVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8346

On 2/11/25 14:32, Borislav Petkov wrote:
> On Tue, Feb 11, 2025 at 09:43:23AM -0800, Sean Christopherson wrote:
>> It conflates two very different things: host/bare metal support for memory
>> encryption, and SEV guest support.  For kernels that will never run in a VM,
>> pulling in all the SEV guest code just to enable host-side support for SME (and
>> SEV) is very undesirable.
> 
> Well, that might've grown in the meantime... when we started it, it was all
> small so it didn't really matter and we kept it simple. That's why I never
> thought about it. And actually, we've been thinking of even ripping out SME
> in favor of TSME which is transparent and doesn't need any SME glue. But there
> was some reason why we didn't want to do it yet, Tom would know.

I think it was because TSME is a BIOS setting and you don't trust BIOS
to always expose the setting :)

I do have a patch series to remove SME. I haven't updated it in a couple
of releases, so would just need to dust it off and rebase it.

Thanks,
Tom

> 
> As to carving it out now, meh, dunno how much savings that would be. Got
> a student to put on that task? :-P
> 
>> And in this case, because AMD_MEM_ENCRYPT gates both host and guest code, it
>> can't depend on HYPERVISOR_GUEST like it should, because taking a dependency on
>> HYPERVISOR_GUEST to enable SME is obviously wrong.
> 
> Right.
> 

