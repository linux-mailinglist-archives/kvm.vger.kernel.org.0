Return-Path: <kvm+bounces-29618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F989AE250
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1FC21C21305
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD2C1C07EB;
	Thu, 24 Oct 2024 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Orn7+/k5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3BB1B0F2B;
	Thu, 24 Oct 2024 10:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729765029; cv=fail; b=LsYTPGZd5dsJblAXtKXdo/YRY9uguNz1XKt/YpLoRXQ8M3JkokN5FDZjnYUwEKnGZEvbpbP/I46f9YKWI8ZOg6M4AbkQO3DUE4NQHTyfZ8slNMUt9zXvXR2DhBUAtK6Vv8PP5geIfc298cHUYP0jfbcsw7nDdODPmvGx5/2FwCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729765029; c=relaxed/simple;
	bh=IBmBPVOIKW+9FjJPFcFq8giBVpEQQlSjGqjIk79mPY4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K3/VNDuh8bV+Dk7K7z9+mLOjR4OCj9W9hbZO1t0NL1cZkJ2Uw35X4eyq8rVo4nwQgwB0TFTgvZ/QOCEiceczDh8vtBzi+w/BnE1p/QGPNRtAHeywanDFEWBFiOsxEQIN1ro+560GGMf/vKk2Qr4UwHb4y6qi3IrUxJRhq84ithk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Orn7+/k5; arc=fail smtp.client-ip=40.107.236.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADqGpEP0ZR0E0J9iGEKdM6F25IjRNbqPvmf789Y5EgE0f11xeYrTyu5Nb+E32xF4vfkr7qyYxDjTjLT0joc3kuXr13dlDhDkTHCkRymp6Ek9+YaxKwxgmCrMVdboJUYZO5YTm+r3VUlok3rVKarPJgMDas0mE4gJ4MZ1jRgG/xcCoOlogzd1DjiYXdao8boBcIs/OT6fZgzODvwGjBj1XKzg6hzKCzfyalF/7pg3MfLb1dMJmMTELSZZboTdVQFwqiHOjwkGttyIGYJrIEp9lJPLLt0ND/sPGi+E8bnyMgoN7YRH/mbbwwHeYM1rK5nrKG1WaerO4M7NuBk+gpWEdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aubFx/1OKh+uvmyFApiTQOw9HLKk3Bajl7QFr3OUWIw=;
 b=k+ZlkdUH2oFKMAgv43l38MK7SNz9EVDx9DZfavZt+MwFnI5vdHVfwSWy+VzTBlt40A6/r4H5y//s1es/PVDtj6n6t4JCKaI8tve2b3LZMu7GETCixbCS8KzYJdCBWBjfiT+1rLJTI9NWrw8HPH6C8Jj20aXHRp/4XLSSYqTSieUVaUONG6c49DVvX/Wr528nlexOJBh3Grtvoaja8li2V9zwAKUe7uRh4aupWYODt/WgomhrmlR5FKGkoTe8dRKQj2scVpxqZderdDtqzYEEQl7nV9LihNMWUZUl2vnMu3doLGTRaqzAXIH5CHa6+wkebv1kIda4GDW1mTUsAR1jpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aubFx/1OKh+uvmyFApiTQOw9HLKk3Bajl7QFr3OUWIw=;
 b=Orn7+/k5iPXLRFYTZd02uVSreQypeVU8h2yeFJ6dY41ffgGgyAuX88ezx1w1X62yLCQv9gv1Wb3XJX9hKTg6606WmVSxnNsDAKbtHRYmOfecXW9zfS98echIEKQ5Z+nfK+/8yZm5CqduPBkPNz+LD7wGHrbHR/o7fcKzzf5Gt3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB4070.namprd12.prod.outlook.com (2603:10b6:610:ae::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.20; Thu, 24 Oct 2024 10:17:05 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 10:17:04 +0000
Message-ID: <937f745b-4e16-6ba6-6249-2f63aec308c2@amd.com>
Date: Thu, 24 Oct 2024 15:46:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-5-nikunj@amd.com>
 <c0596432-a20c-4cb7-8eb4-f8f23a1ec24b@intel.com>
 <33300e68-dde5-0456-2a6d-4fb585d188a6@amd.com>
 <3a13ad57-8006-4218-b9fb-36f235a5d5cc@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <3a13ad57-8006-4218-b9fb-36f235a5d5cc@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0103.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::15) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB4070:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b1bc7f-7029-49b1-6fcf-08dcf41501ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1BwNzBwbEdlbDA5am5qYlFhbElubTlTRHRHSTlBeG9uY2J1K2dKQStzU09D?=
 =?utf-8?B?NWtaa2o2TUVxUDA1amZxd3hjNlF5MlpkZ1RxT3ZuZSt4Q1lkL0J4dzZidUR2?=
 =?utf-8?B?eFBWbkVNOG8xTGhNVysvaE9qdjVaRmppUUM3RUU5S3d5UkVxdllXZVYyZWVO?=
 =?utf-8?B?ZVYyNWZaVUg0WjNXM2NNS09RbVZCNitPR2FtREFiSkxxS0RKb3hmck1tZ1JP?=
 =?utf-8?B?VW42eUlQMGswZmdUY1Nxc0VpOTFjN3hOTDdubFBiNzBRNjVaTUZrQ0sxMlBj?=
 =?utf-8?B?VS83UXJ4eTVVQ3R3REVLMDIvVTVDYk10SlBlZC82MWNHbUNycUYrOTJDVnM5?=
 =?utf-8?B?ZUt6RFUza3ArUDBaeEVKVS9VK3JhMFRabU5obzNXRlc5QkwrbjdDRythekMz?=
 =?utf-8?B?VVMyZ29DYkpzN0RvR3I4di90eTAzQlFmQWdTcm9COG1SSmxQWmNPWHFSQ2tz?=
 =?utf-8?B?NElaTDlJSTdIOGkzU010SUZQdDNka0l6WlQxRVVQcUpHcWYydmFOZ3NFellX?=
 =?utf-8?B?cFd6SGNRUU9sK2pmMUZFY0tSVkhwb3BGSmRyYVc3aWZFYVhPSk1sWjFNbFJK?=
 =?utf-8?B?MEpoczIrblIvTDFhS0pMdXk3cHNjdkl0em1mRktzcVJ6dzdxRndzS2ZkLzh2?=
 =?utf-8?B?Z1g4cm5RVmxRTG5xRTcwVElQblBIczZOVFhpTy82bmZtcDQ4WnByUHlsc1dl?=
 =?utf-8?B?TDFyWWpUaThlTGllckZRWDlieFg0YUlaajRFVW9KajJVeWRiYUJsY013THQy?=
 =?utf-8?B?UTJkQVA3UWlFRVNTN1lybkJUYzJtbzg3eXFzSkVQdWNpczlxWjNLNEZKTitD?=
 =?utf-8?B?U3ZROHFqTzEyM0pGZnNnZXJzUXh5bXhxd0VUTkovZ0Z1eVJJaVpyRHN5RlBU?=
 =?utf-8?B?RUlidWdxOElVYW84a1Y0ei82Q3JZTXduN2xOT2taS283VWxvcHVaeHpwK3cr?=
 =?utf-8?B?SnpCdHdRb2UwN3lhSFlHU0hIYU5JbFBMS0ZxWTdxR2E3R3BjcFA5djRia1Na?=
 =?utf-8?B?T3lpRFNXSEVyTXZMdmJMRjh3OW51SzBHL0lIZmVab1pCcGR4RGJDY1N1OEl6?=
 =?utf-8?B?SWhTS3dDYlpFU21lK0FINEhaNXVBcTR2WVRDdkw1b2FmbjVGUSt6OWpZeTVw?=
 =?utf-8?B?cERFUkNXQVQ3SW1vYVlsYzBXWlVlMTdJSi9yV2pBYzU1eTlTUW1UQ2hZVVg4?=
 =?utf-8?B?QUxwR2UwaHp3b1lwd2Q0d09LbUV4amlIT1FoS3RiQll5WFdvd2YwZnhScnA4?=
 =?utf-8?B?b2RsTndXUC9ncVZhQkI2QVZYb1JPc1ZrdlZsQjZkRzd5UVJSQncxUUpENzVZ?=
 =?utf-8?B?NmkwUlZaVGZtdlpUbHpGZkRxSHBYN09NRVdrYXozMTBIcEdmTGZMVjduYm8r?=
 =?utf-8?B?VkZMcGxOYWdHWS95V2tveWxoMWNSbjVEVjdnQUcvS1IwS0VJK211UzMyQUVj?=
 =?utf-8?B?TnF0OWQrMEVHYjJ3dk1VUG9LamVhanY1NmRSdWFEL2s4bkxhN25yeDNSZU1u?=
 =?utf-8?B?SHNkOURpV0twN2lrWTF5aVladzZqSFdkS1A0S3MyelZDUlBTSU5XdDV3cjgz?=
 =?utf-8?B?QU1YbXhoOUphUUVuUGJZQnphKzdlYktldWk4WGJ6VWNYRG41U2tkdytGeVhy?=
 =?utf-8?B?bXY1T2Zvd3JKYXl0Z0Y3WVhSMGdIUWRVa3A5M0lYYXRuY1g1VkF2czM1UUIx?=
 =?utf-8?B?KzNZNnZhSmc2WEFkY01TWUNvaHFBNEJ4ZkV4cENQY0t1dXBrcDllOTdmN0hh?=
 =?utf-8?Q?t7vPHC+rnhLOVGTLkZxifyH8uuaKcap/0pzlFMZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akxUWHhOQVVIUGhjV1RrTGxGYkxTd2hBaXFYR0llSmNMUlVyYzFzcTFiMWpX?=
 =?utf-8?B?YkowZUlqNGRBMDdrRFdrQ0kwaGJpdDNkbWlFWklIYisxejJjeVBJY2VIc3Zo?=
 =?utf-8?B?VWV6dldiY0pRRG5MVU1IZGNyeDZybnJKdGFZa21hVUlUM3NGOG5vSW1PY2pU?=
 =?utf-8?B?VFFyT01zL3lXeWRtTElMcGZ2YUYyQW45NEhYOExQOVJnNjhGOGpGblhLbE9k?=
 =?utf-8?B?YllJZDVCWUdhd0JZSGpLOW5HVWhkR2tVNWl6a0NpNG1sRlF1Q25PdEdIUVUy?=
 =?utf-8?B?Zi9CSFdBSEo0aTExSmpKd1R2OU5uelZJVHJPOXh4cG4zSFk4QVZJRGJET0RJ?=
 =?utf-8?B?UzFOV3Y1Sjd2VHNJR1NWS0YrU0pacWxnWU5rRWNXcUNDUk5yWExsbUR2UzJm?=
 =?utf-8?B?ajU5Z0NUaTNnMHhsQmtGaTd3aXpBQTMyY0xsM3ZlUzBCT0hkUUxvTHZiZEJM?=
 =?utf-8?B?empuN2NHcm5RNTZ1ZGZuTjY4ZEtHQm1va21uK0dKUTJwMm93YWdWZ2d2YjBJ?=
 =?utf-8?B?aGJDM3NWYU1Ca3F4NG9nbThZM0E0ZDdROFFSUXc4V1VSTC9jVkRXUG5KejlB?=
 =?utf-8?B?dUVlUFhzUFYwdCtVUWZDR1RMU1Zqc2ZWYTJkc3U4WDJJVEo2cENnalJyZHR6?=
 =?utf-8?B?eDBiTkFhczcybEJLWXpuU3BLSkk0THNaQVBUMGpTU3FlUyt6bTFUZmY0a2hu?=
 =?utf-8?B?WVdKRUprM3lCYTZTOEwrd1BBQ3lZQ2JuSW1MM1hTU0pvWHcxTEJTWnNLbkVp?=
 =?utf-8?B?VHNLZjhnWHBVUnhrWlRJN0UzM3ExcldMMC90WkJZMDlOaEJGaDhLVFNxV0lZ?=
 =?utf-8?B?L0xoenhBSUhnR2xaZTMyYkpINU5xY2pNa2Z6RGJVdHBSNUN6aGIxY1hLU3E4?=
 =?utf-8?B?NkdISW1mU1F0dTY1akwyN3FNUFVpbGg5WGlZU2wwVUdUbmRqU1VLdEg0N1g1?=
 =?utf-8?B?eDI3MjVQcU5vbnlvWXJ4U0xkcGFueVlVZFFuOWFBeVpGa1Y5MjFITzJ2Z3h4?=
 =?utf-8?B?NmZqZHE4eGtiaU05dnU2VnVSQ2NzbmJIbnJrU29qOGN0di9reEFkeFplWit0?=
 =?utf-8?B?Rk9zTzd5TVlhVk1iT1A1Z0hqZFNNeWFxMHRkRkpHbkpqVDhQdytpVWdKQnp4?=
 =?utf-8?B?Mm9EbjJGdXlCQU5Jd3g2SWdxWlJBTGd1WHh1Z2xFaStvRUloSmhKK1dHZUUz?=
 =?utf-8?B?UVBvYkZnV1FqbDZzWEZxTnpmRjlZYllnUFN4ZFN2QlNzcEN1djE3bzdNYjNp?=
 =?utf-8?B?M2pZOGJtNEYzSjhrajFmaWVyYXBXRzhjOEt2SXFLeUhMbnBGWGMydnQzaTdP?=
 =?utf-8?B?eXNBV1lRd3BCaHl2TTZiaUttd3NGTWN5clcxUXFDKzV2SnZLdGFyWHBOTmV5?=
 =?utf-8?B?L2FmNTIwT21OYlc4Yk5pQXhnaWQzZVhDM29lODhTQ3pWMG5ib0JYQnRiS0Jt?=
 =?utf-8?B?T2ZMV2w4TlRnREVwVHBmbkdvQWxwUGd4RUh6K1FTd0JWNWJyczgrTmpwMEZX?=
 =?utf-8?B?WmQ1eG5od2t0alhPcE5rM1p6NFFEQXBZOTMxSUIzYVJhNFQ1aytyUjVSOVBI?=
 =?utf-8?B?czRMZzlET0ZVcytzRFBVakx1NmhRZmlIaksrQlpmYVo3aTRjRUUwSHpKRytB?=
 =?utf-8?B?dnVCdE9uSzl1U285NFpkc1V5RnBHZERiQVQ1QTUvSWMwMml5YjkxVGlYaGhS?=
 =?utf-8?B?MUVxRER6RzNMelRNWElVaE9nVk02T0pNa0puZkQyWE9CY04xN2ovTFg5VytZ?=
 =?utf-8?B?WitWZUpFcFVoUVR2RDJ3U2x5SVBNZEYxRlpiWldOSFRsaHF2UTEwWGJyOTUv?=
 =?utf-8?B?cFdiVkJzazgxdHkvSUJGUFdZMndUMjF6cjhxRWdaM3BqdXVSUnZQZi94a0cr?=
 =?utf-8?B?YUdQbXJXbmpnNFVWVDVFSGFydi9jTGhVSEpNVkc4MUc5Y2F5bXlmTGVRZXRZ?=
 =?utf-8?B?K0FQUUFnMXB2ZXVWNmMvdzBWUS9Bc1ZwUUo3MmJucXAyME9RbmdJM0MzWkl4?=
 =?utf-8?B?NnlmVFZaeG5JWmV1UUxRS3FXYjJFSURHay9BZUFITXhpbkY4aCtpUk4yTkFk?=
 =?utf-8?B?OWdCaWpDaEFBVmdkTk1kclc5MXFjT3JyR0pSOEhUTFRaRE1TL0VnbGdlWi9t?=
 =?utf-8?Q?xa0w+azDiWxNcnRiSfGuZIXKo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b1bc7f-7029-49b1-6fcf-08dcf41501ec
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 10:17:04.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sijh44V+qiWNr1usMHdPScv8auym6/CVvHWYEod3fFHBIU3oaocd6wm4zOgMU9CdN0vU+OQ7c8S/ewQre/B4YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4070



On 10/24/2024 1:01 PM, Xiaoyao Li wrote:
> On 10/24/2024 2:24 PM, Nikunj A. Dadhania wrote:
>>
>>
>> On 10/23/2024 8:55 AM, Xiaoyao Li wrote:
>>> On 10/21/2024 1:51 PM, Nikunj A Dadhania wrote:
>>>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>>>> index 965209067f03..2ad7773458c0 100644
>>>> --- a/arch/x86/coco/sev/core.c
>>>> +++ b/arch/x86/coco/sev/core.c
>>>> @@ -1308,6 +1308,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>>>            return ES_OK;
>>>>        }
>>>>    +    /*
>>>> +     * TSC related accesses should not exit to the hypervisor when a
>>>> +     * guest is executing with SecureTSC enabled, so special handling
>>>> +     * is required for accesses of MSR_IA32_TSC:
>>>> +     *
>>>> +     * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
>>>> +     *         of the TSC to return undefined values, so ignore all
>>>> +     *         writes.
>>>> +     * Reads:  Reads of MSR_IA32_TSC should return the current TSC
>>>> +     *         value, use the value returned by RDTSC.
>>>> +     */
>>>
>>>
>>> Why doesn't handle it by returning ES_VMM_ERROR when hypervisor
>>> intercepts RD/WR of MSR_IA32_TSC? With SECURE_TSC enabled, it seems
>>> not need to be intercepted.
>> 
>> ES_VMM_ERROR will terminate the guest, which is not the expected
>> behaviour. As documented, writes to the MSR is ignored and reads are
>> done using RDTSC.
>> 
>>> I think the reason is that SNP guest relies on interception to do
>>> the ignore behavior for WRMSR in #VC handler because the writing
>>> leads to undefined result.
>> 
>> For legacy and secure guests MSR_IA32_TSC is always intercepted(for
>> both RD/WR).
>
> We cannot make such assumption unless it's enforced by AMD HW.
>
>> Moreover, this is a legacy MSR, RDTSC and RDTSCP is the what modern
>> OSes should use.
>
> Again, this is your assumption and expectation only.

Not my assumption, I could not find any reference to MSR_IA32_TSC 
read/write in the kernel code. 

>
>> The idea is the catch any writes to TSC MSR and handle them
>> gracefully.
>
> If SNP guest requires MSR_IA32_TSC being intercepted by hypervisor. It
> should come with a solution that guest kernel can check it certainly,
> just like the patch 5 and patch 6, that they can check the behavior of
> hypervisor.
>
> If there is no clean way for guest to ensure MSR_IA32_TSC is
> intercepted by hypervisor, 

Yes, that is my understanding as well.

> we at least need add some comment to call
> out that these code replies on the assumption that hypervisor
> intercepts MSR_IA32_TSC.

Sure, I will add a comment.

>>> Then the question is what if the hypervisor doesn't intercept write
>>> to MSR_IA32_TSC in the first place?
>> 
>> I have tried to disable interception of MSR_IA32_TSC, and writes are
>> ignored by the HW as well. I would like to continue the current
>> documented HW as per the APM.
>
> I only means the writes are ignored in your testing HW. We don't know
> the result on other SNP-capable HW or future HW, unless it's
> documented in APM.
>
> Current documented behavior is that write leads to a undefined value
> of subsequent read. So we need to avoid write. One solution is to
> intercept write and ignore it, but it depends on hypervisor to
> intercept it. 
> Anther solution would be we fix all the place of writing
> MSR_IA32_TSC for SNP guest in linux.

There is no MSR_IA32_TSC write in the kernel code, IMHO, so second
solution is taken care.

Regards,
Nikunj

