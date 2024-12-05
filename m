Return-Path: <kvm+bounces-33108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0749E4D97
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 07:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3E57285D90
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 06:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4066719995A;
	Thu,  5 Dec 2024 06:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a/nXcbJH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BBE18C33C;
	Thu,  5 Dec 2024 06:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733379934; cv=fail; b=IXN59ic82+V05DD0FLvPcKlmSo/fcwA84EmhYhFpCQJ5uvzvyf7Vw2i6ee4y34m4mz0fDvIjwLVaJvsItLiK5nDNMk5FAE00dfxEwOaEix5I5iy1M9MCjIV8grgctv3n7WqWNtgRs0MXc+fL6my4pUQIv2PWsP9olNvxklDN8wI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733379934; c=relaxed/simple;
	bh=QeQwL9NjTLTViN6JVffNb0yNF2z36PhcIqtMLn9GSA4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F57o6ri9nzrMFAXDVEj90mLZMUDz8l9pEH+xJliWDl/MTXaYGAgCwnJIV5fs6XZ54t6akfrB9X1arbN3WB3JmZMPUhQewiXeOIOabEuH/HkLt7TAMbU+ZkXz+b2/6QEGTwbeSGAO42g4ou/qlL6kv3cBtbFOhki7HNIAgjhj81I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a/nXcbJH; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQmtLKeOzJ48D0mlkG/6Tax/uARHPMIlbMutcFNqcR71q6HCeiS5vVnf5a/tiHE46UKycaGyrtD5xHQ3L/VbPczIP07ax7dLMGRwVzQUuQu/lebU8tJDpoP3RXfs087Pu1CqzrBInAcjzjHG8zlFdMzvJ2z1V+epjV9/BtZkB2Ms/9j3wm39J0V0bxA73VwfBjgIr9+DsTBM+fq7BVcQjN4VTlTjTA/J1rwgFU44o1KWwuuDCUO+FnDrEmcIMaMWyxpB8fd21h+eHFRR7EHNIy1PZAsVzZAZOHukXB66tGfxiZD6bWKns7sZJXQJ9qn3qZ6EP8syk2Ym/ScE+4dxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKOj0Xpiy95PqiDqt3lRkiR5QHM8pWyqIIUFqWGEbIs=;
 b=nKExi/7vZvO3EhMSOJpDfmgG7vOPCOqjCvg6v6M7DaIlfxCJ27AIlG6vNu8/jiyl8EP7zzN2BL4JtI2iAUGrXcl+qer8pEm6ORy1pt+kqeaJgD7gmtJHMOECE9G8XvNa8h7OVchx/tDV4IT50uDndDsaml6YuQBGojrP9UZ4AN2uJzGtAK2ErBPhFFlUqUZxh3QOXVb20cp337lP908d/5Q5zoF3JCHOMymj8ia0+jPQiyV5xCxC24N1HUB6okqUx5BfLgBQdr+OFLhKxxRjXr+uSBCwGXwBPbkWelzXYQxyGVYIEeZ383/JGiWDzaEYeVlQnh/aIuL+ILeox0wHEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKOj0Xpiy95PqiDqt3lRkiR5QHM8pWyqIIUFqWGEbIs=;
 b=a/nXcbJHtNxkgRw0N8HwIaMSXCN9r2M7s8MdoyI4TYQQNEvah5G9SOBo3vI5lFVKUEdhBljQ0hhS17NT98vg20Lnszkl/pHqhBur7R4hIq2MT5P1fJAu7dmk/ZpKLzz5Keymk6CDUHj02rzaZ7H4AWj7NZ3Tr2R1NpnW94xIArc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by SN7PR12MB7953.namprd12.prod.outlook.com (2603:10b6:806:345::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Thu, 5 Dec
 2024 06:25:29 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 06:25:29 +0000
Message-ID: <209a7cf7-9e16-4617-bd7f-3564bc66426e@amd.com>
Date: Thu, 5 Dec 2024 11:55:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 02/13] x86/sev: Relocate SNP guest messaging routines
 to common code
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-3-nikunj@amd.com>
 <20241204202010.GBZ1C5ehNbXTyCdtpr@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241204202010.GBZ1C5ehNbXTyCdtpr@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23d::21) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|SN7PR12MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: 012f39a2-2887-4731-e03e-08dd14f59d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a25LWGlvNTc5d1JPMENteHRwdHlpSnM5a0N0dVZ4WWZma0NOLzJta2trZmp4?=
 =?utf-8?B?S0hPNlhTcVRudGptOVBXOXQrOTZMV2xuSXZIRlZ5NDRxaGsxVHJIbG9jWXVp?=
 =?utf-8?B?VTFaR3Frd1pDd0VtcWcwNFFsNE1NZFBaeHlUVWdNcG0zR3VCSXB0R3RGVkF4?=
 =?utf-8?B?bTNKZXFjdWZCTWFoeVlKc2hMeFg0VUhvQTMxYmtlcEV6cmR4VFdmL1VMSlFl?=
 =?utf-8?B?VUlUQ2hkNWgxZnFoRVg5aVpnUXg4ZksrWi8rOTdoZEJpTFQ1dXRIMVJ2V2la?=
 =?utf-8?B?TjFERHVwN2hPeHBJTFpYUzBlQitwcC92ZEpxNkpPaXFScnN2NU15NUlXSndj?=
 =?utf-8?B?NWhjZTMvV0krOUxoR3hBZjk4dlpSOU5ySWJ0dFZqa0s5ZmQ2Z3Z5emM0WXpv?=
 =?utf-8?B?R0JCVDNnN0FpYWYwYndVZ3hYY1JWQU9lTnd4TGRzdFM5RUZzbS9ycjhGVFBr?=
 =?utf-8?B?aFpHRVlDNFkxU1JuNmxSSzNzaHpWZDZmU3NZTUNIekJCc05zYk9PekFFRHJH?=
 =?utf-8?B?VGNUeURVclQ4WnN1WHJoOFlXUkZTT0g3YXdxWERNbndYVm5kWTdPR2Z2ZCth?=
 =?utf-8?B?ZEFSditWalhjVkVBdDJOLytYTVJaOW1BaTJ0Mm92Z0JySm5CZTNMMHE2VnV1?=
 =?utf-8?B?Q1gzUlJLM3RjZ0NkT2xzZUxjaW1SY01hSTlCd3ZHeUFqaXNya0dpM2d2MmRT?=
 =?utf-8?B?RXRXWWJDS1ZVdVRVYUF2ZDk1NTBLRS8rRkFSd3lIQ3FJbCtUbXlWWCtqa1lK?=
 =?utf-8?B?MTd6SEx3NDlPMmZONE11VTR2dDAwQzlJcFhDZGJudE9UWE1PZDRiUjJsT01T?=
 =?utf-8?B?M3VlNWllN1ZiVlMrUzdVNVY4aDNzWnZLcUFqQS92SHYzVFVadzZmaEpzWVNR?=
 =?utf-8?B?QXJyaHR6VUU4ZFZQb3hXazMwVHV0dVpQdG9XVnk2TVhweGFqUHRIbkdjZ1V5?=
 =?utf-8?B?Qkl0ZVM3WDJNMkp3WVBUNFU5VklEMXFsNlhqVTlCN3Z0QlpTejV6SHRGcUtM?=
 =?utf-8?B?SmJORGdsZEZ0R0N4dW9JRXBIcm9BRzhMVnFsclNCVkxuK0JTYlhWeDU2SUlQ?=
 =?utf-8?B?cVByMjZOVHdJb1BPakhGbitjRmNxQVVNcEc1UzdNazhGeEozOW12N1A0R3ZU?=
 =?utf-8?B?eDZyNy80NVlTQmJIdmF1OWd6RnZKdmM4WkxTRlorRTdNWG5uOS8rcHlUZFdX?=
 =?utf-8?B?d09zOUY5UkpoNGhWOVpwb0E4cjdrMi9IMFVrZEVwNU9PMUR2V3hwa3NsYUZl?=
 =?utf-8?B?Y2JmUDlQR2hGdndJUVI0c2xZSDdqaVN4SUcweTdxWnJ6YVhrZGYzQVVaTzlI?=
 =?utf-8?B?aHJSMmkyclpvTkRNRFNOb1U3S1BGaE5mR1pwTG9SL0tPZUVhbG80RUFWWXkz?=
 =?utf-8?B?SDZFYjdrc1BlVEJ6SkpQWUg2VSt3Ri9HQ2QwWm9jOGxLMWNOL1JOSVErOGcz?=
 =?utf-8?B?VEIxSEVtWDd2Mkp6YWJwSHEwaU1YOXE4TDRtODk1MUpYcW9oQTFkNTh4OU1o?=
 =?utf-8?B?b1hUSkd0c3V0TXFrQTVudGFDaEpqVFpJWjZjZFo2Ui9KdjlVbGZZejZYL1Nh?=
 =?utf-8?B?SU1mSmlsSzA5MU8xVDhqcGZMRXNBSnlmTEU2YWNDRXdMbllMakxjS0UrcVQ1?=
 =?utf-8?B?dnU4OEJyYk0vT0NDWmNRTEF5empSajJtdE5hWFg3RERhMzNyYmlUUXZLamNi?=
 =?utf-8?B?Y0hEQ2xVb3JrZ0ZQQjY2WGV4Uk1kT2tCcW9oYUdBSWZjNlBGcWNLWWo4Yzk3?=
 =?utf-8?B?L1lQaU91cGN4WE1QRSt1UFJsWGMrN2piQmhZQ1E1YnJ3UEppeGJNaGxqSUdI?=
 =?utf-8?B?SzBUNHFVV1ZEMFlxdGhXZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGJxc0tzdmNBYzk0RDBCL3hha0E3QmRtME5TWGJtYzdQeFdFQWRvU3N1cEdn?=
 =?utf-8?B?Q1NRdm9TckFQbU10WUI5bmJRTUNBdFR1TFpSM1h0TGRXaWI1UWZYczJwaXgy?=
 =?utf-8?B?ZytDUkZoN3NRb3l0TS9xbXhLNnc5UTMrQ1dwYnBpcWVpWmQ1Tzc1dTZBMmRD?=
 =?utf-8?B?RXp6UU40c2ZIVDNGSmpmWG95LzJzZkI4cEUxWWo5bk94YlpVdTRUYzJaMHNw?=
 =?utf-8?B?ZDQxSXdmMDN0S0U4NlBKLzU5WGVtelNaeHJ1eVJ3TnlzV1BoUGlGWndUMldZ?=
 =?utf-8?B?Q2pXb1daYm1Yc3RPbEdobW5PVCtjNUZraEVEM0ZKRXRvU0FLK3ZZcUN2L2cz?=
 =?utf-8?B?dG0xcHRlaDVOcWVkcmdsNE1rdzVmRlJETzZMZmlNMnNYYzZGN0VNZXpnb2Zy?=
 =?utf-8?B?N3RRRkMyZ3g3aGtCZmlvTElHZVo4WUNVM2MzZXl1Wk1hQkJhOVZZS1RrVnNy?=
 =?utf-8?B?SFBFRUdNWWFOdUR3NGEzS2JDYnNmUXh4RHMvZ21EbHRBTWxXN3JLN291Qmkw?=
 =?utf-8?B?RDMvQmQyVmFpcTF6Z1dDZTJtVzBpOTdrRlVscDR1cko0ejhrcHRnM2dXTisw?=
 =?utf-8?B?Q0VzODYxNW1sK21oT002VmZjUTRDOHhoa0QwZE53bUt0VjFXcCtHY3IzaXV1?=
 =?utf-8?B?bFpBVUEyNnZIVEhndUo0MFNTTGVVZHB0cGo5TGt1b1FmMVVHNit3SmZ0Q0xJ?=
 =?utf-8?B?QXFrRG10SVB5WnFhdlQwYTRlZ1dEQzRUTUFVMTBCNzJFME9LeE1LRy85OS9V?=
 =?utf-8?B?NlRTam12dUVVWk93TGhDZXFYSGNGL0lNb09zM0phZXpnb1JSQUZzbDJsMC9U?=
 =?utf-8?B?SUJIWjNrTmI2UjZmV2o3ME1EZW5tNXlpYTFqR09CSVVVV3Fsdm1TTlZVMlc5?=
 =?utf-8?B?Vy9hYjUwTzQrQ1hTVlFDTHNtRUU4YjU2a1ZQVlg0YVNhaWRnbWRITFBKUHJZ?=
 =?utf-8?B?bE1wVjlkTnhxSld4YTBoZ096NUYzYytYcXNJWk02clJwQXYvVHRUaXNPbU8w?=
 =?utf-8?B?dnp3b0krb3BwWXVLVndrOU9DN1FLcWxnSDN6L2g3ZUVBYTA1VzZXR2ord2NO?=
 =?utf-8?B?bXpSRGhRM3RRNzBwSjFYYVRXaUVHMXhJL0dGdW9ycVZUZ09EN1lZTVVGM0xH?=
 =?utf-8?B?alpsclc4eEd3WUhrSk9mTFJGK3ZjSUFWbWRqdVhxaHdCRmkzcHk3dmtNbWFE?=
 =?utf-8?B?TFc3Y0FoeVc5ZlA2b3B4U2h5b1BpVVZqeEtKVFg4ZTl5eTlxQkVwdXVPb3ZS?=
 =?utf-8?B?M2lNK29UMjRQOTBjYUwzM0FEam9TUndFaG1lU3JNejdxRElmOEs2a3JzMmhC?=
 =?utf-8?B?UU1FbFJsWXltbGtUakVCYXdLeUNTU1FvTDlsTWtKMHZJZ2p0VldtQ2hhcHZU?=
 =?utf-8?B?TEpVNkdla1lBTUM0RWRlbW5qVFZUdzJKNjlEWWZrWjBDMVpHNFVHeUdCVjNr?=
 =?utf-8?B?SldheHZVT3UzQlVETDVWZGVVN0NRdVJvZituclpLSEZUR09UZVNjRWZXd2NY?=
 =?utf-8?B?NHBhSzBvTEpRaGRvZ0QwWWVkWkFJNFFseHlWRmJqWWZuZ2VBUlUzdUk0aUlC?=
 =?utf-8?B?VWRnZFJMdHhPQU55ZTJtOFNPQlN1TzJpaWVodUIyYXRWdC9aMjUwVmJUbmlQ?=
 =?utf-8?B?azNhTW5RZ3pDbHNycmszc3JrMk8vL290N0dpWnFlcWxScGNqT3U4UU1VOG9E?=
 =?utf-8?B?cGlDMzJrUG1YNE52YjlJWVBwbkQweFJYTElPZllBb1lFWFJMZHc0Zld1OGRF?=
 =?utf-8?B?L3EvSnZZczB3UHFxM2JCaW1Iby9Mekd2RTVrYm5JZ0pwNWdjbGNRT2QvZXVy?=
 =?utf-8?B?R3JBbk1nOHVGWCszSWFLODRURXV3ZXkwZW5Nb2dyUEN2Nm9mWjYzRHJQWEYx?=
 =?utf-8?B?SmZDc0ZITFJVTGJaSmlBZ1UwK0dKemRsOHV6eGhmN3FRK1dPYzVOZkhZdGJi?=
 =?utf-8?B?Zlpvdm1tR3R0V2o0VVdEcm44azZuQ0dWR0YzeUkvNFJXSzNkSVhQZjcrRkFu?=
 =?utf-8?B?dm5NSDNFL1dzNWtmUkIzSFFuLzZJdmU5WVp5SmR4U3lyc2VSVm9Ha1BCem8w?=
 =?utf-8?B?NVpiUTZ4cGRNWXdmczF4NzFGZG9vN2h3K1R1Y3FGcVdVZFRiL0FzUnBhRUJz?=
 =?utf-8?Q?gLtBbDXQMkVJ1FZPplzrhFKEN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012f39a2-2887-4731-e03e-08dd14f59d0e
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 06:25:29.3865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2quh6ArkljY1u8fQlpMJF+Tl3HXOfKH2qFboAutrehRzeGHUBPE7qNEdN78YJzMjNxujpAOLA1D+YF0+Oio5Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7953

On 12/5/2024 1:50 AM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:34PM +0530, Nikunj A Dadhania wrote:
>> +	rc = verify_and_dec_payload(mdesc, req);
>> +	if (rc) {
>> +		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
>> +		snp_disable_vmpck(mdesc);
>> +		return rc;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(snp_send_guest_request);
>> +
> 
> Applying: x86/sev: Relocate SNP guest messaging routines to common code
> .git/rebase-apply/patch:376: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
>

Sure will fix it.

Regards
Nikunj
 


