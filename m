Return-Path: <kvm+bounces-38409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AF7A396D2
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66520188B922
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA4422F3BC;
	Tue, 18 Feb 2025 09:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f62yh7XU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ED722DF91
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870383; cv=fail; b=eLiTNsPw7Fm7oV7WOMXRBvx2WEnuQtQwFCMPuZXuDq3bDUfh+nxPRsoLYNYbeOSUmdY/CimWTfGK6bV7oDczDvhyW2kCTqjZR+jJVS4JOYFwjROBSVDv9FLv8qMMIm25AgrDndfLW0g2knWP4nrTnacTI2bwv/CRg0Zl+iwojjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870383; c=relaxed/simple;
	bh=sHNYjvxgwXnbEqXzWdNAYMr2qBMVpD4u7hJf+iqNCTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CZOLYbbHlOlK7Ib81yZ/nUvtqa1MPnMwQXissvnI1mJW0xsshnh8gJNQEvj2YHjh9tafoCp8m8UpAmEzKWbq3AsWsJ53T01EF/abynIgTmjI/sGJMs3a3Lbc9O0M6CRcq/CekGKCz6tI0toSlBNi3BdMySWg0F2F7X7884GMNFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f62yh7XU; arc=fail smtp.client-ip=40.107.212.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WYoRR5uIFNBkJ4P6wIiEMlIDmmClLWHro/H/w2uoweHKeBANexBmSk1T19Fk9rp8N+5NjNNvPOAw7O67VT05Ki4Xdxzn0zaGDSgnOTwAYy1B44TLF5RS84zd+JT8ymPQne9WDfpgALqSjdMUZnYJiSTiWD5ROOaW9W6ejrOYGJ1chw+jOb/MBzufR3Aqv7uKf1no6wJwkDWbOWH6Eo4zkvWfjizm1K5BC7J2Bqc/w9XOikVHTeJPIFwX7K2EybekGsOFA5yDfvNcY2KAqCN4V1IfeLeIOO8aE5iagSxLkY7nZenV9LXVJB0dkLtbqMmkm7jipBZt4JXL/NpbLyH4RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHdC77PmzLyXW6tgGFYb7st9W0d4fCGBCYYgQAcY3Zs=;
 b=Gukj55lx85/T+nBHFkXI/JX6OviKHsz/97hT2VKxwBFUSwBpbh6ar09WnkJv1sn8setwH9m7fqA9kueCyqx78901HtpLYIDI6zyUmB+op7Y27AHNmVkjWoDFQ2pwemfmdV+/8VN51TSfdF6vEfn0ywXlE0mbsF914XvR++Sn1hdVsE40KKAfWZlszVEZibVr6YbrpKQhtHmDSPIZocMhYYaoDA9ENdMpoAmEcCHnbS/gAcPHsgTL4c2D4+a8mNVXX60XDnFSh2+XEJfwYgALIQVytsWHMxFeCuFLxxp0vJdXOmepY1gr+7PZL/OpmfkkMUhlI4BiQlbA3MLaXrz8nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHdC77PmzLyXW6tgGFYb7st9W0d4fCGBCYYgQAcY3Zs=;
 b=f62yh7XUGDgkT4xi9HmTEXiIhBQeuAlbZz+oY1hHaOA+1wDRFo0EEBh+eAnYC5cq9wfLc7cSrko6iNLCm0VRXaKiY40OgmP7vTZ8XXO3NObtQk5Cj/GuIt+mCR/K/FpVHB+apt+G5Y/WswcJxqIgKXqhTDZvtwk5z4IZfzwHaQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB7115.namprd12.prod.outlook.com (2603:10b6:510:1ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Tue, 18 Feb
 2025 09:19:39 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8445.016; Tue, 18 Feb 2025
 09:19:39 +0000
Message-ID: <212ba199-3339-4ecc-94d2-3d1c32ad77be@amd.com>
Date: Tue, 18 Feb 2025 20:19:35 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 5/6] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-6-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250217081833.21568-6-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P300CA0034.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20b::24) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 75f32be2-6105-423d-aede-08dd4ffd5e8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V09oQ2Yrd0N1elYxa09lZ2RBOW1ONlU5cjRxR2txelp5RXY5K2cwaTZNZFQ1?=
 =?utf-8?B?bGtTSHNvcVZoTTVpR2V3ZnNXYks1cHFreXAzZjk2cGgzTW5IYjVrTlhPYnhq?=
 =?utf-8?B?ZU9WYmVFU3lMdExsTitKVnJHaXN6QjNFcFZrbGROWGZCVmEwalJIZzhtMlYy?=
 =?utf-8?B?dlp6MmVNZ09oOWZNZ0tBcW5RNzhWMmFOdGIrS0pPUDF0VjVQczB2YU1JUmRS?=
 =?utf-8?B?M1JDMWxrVkF1bExaOEF5OFlMKzBJOFJJaElZMVBNUGRyL04wQ2g2WTluTjNa?=
 =?utf-8?B?RVkvdS8ydlNtTUZSa0VFcHUyN2E2SnN2Vm9yNjVFRkdjcDNXZWY5OFJoYjRE?=
 =?utf-8?B?VU02MzBNR1hsbC8rYk1YYTR2aXRjNUZpNDNKeWxkVmEvU1ZKS09DZ3F6NDZT?=
 =?utf-8?B?R0hIODYzKzVGMFROWTQwd0VyQ0RRZ2pPZUxJaEsrWXRlR0NXVXpOTUFBL3U2?=
 =?utf-8?B?WXlIODVOZmJJdDVpcDIwSEZhc3VCT0RyWkNaOWVEclNHUGRpcGlWU0M2aHg0?=
 =?utf-8?B?Wm5uY1ZUZzBqSkpSZDlJWW9kUWZqTEV4MFVFSGE5MldNVENUZlhjU0gyYUNq?=
 =?utf-8?B?S2w1ZTVRdmNJbVZGZFgwMXN6SWQ5WUVUWXRoZ3FJUGRyYlNqQXYzL3RWT0lr?=
 =?utf-8?B?K2hLc0FoelYxS3BLd2hwbGFkMm9aVTZqZXArVWN3d05HL1hjZ1hpVFNPRE5N?=
 =?utf-8?B?TUg3WlVxSDBsWmcxY1dJU1BYMER1cGJ2WDdVbC9kK3ExS2RMZi9OSWtMajN4?=
 =?utf-8?B?MzJtR0M4K05OZjlqbWpRaDZiSzZubnJiWFYvQW9ScktiVEFqWDVMaVJFVE5t?=
 =?utf-8?B?Slp3Rkx2bCt5SzlGcTJXMnpJR1VoTlhLbnpWc1Z0U29zckpnN1JBQ3M0V2t3?=
 =?utf-8?B?STNtTmMwYXBlenlhYWtVMS81NFFTU2p1ZXZHMTVZYWdXZktlZG5VZDFmSjNT?=
 =?utf-8?B?U1dFSTRlWFBJa2x6RmppSnI3dTFPRUJNM1dGSjFsc0s0WkZpZVNuSmJCZkd6?=
 =?utf-8?B?b1FyQTg3bnQ4bEZMQXRvMzA0a29NcTNBekRlUWJaYUhTbWNMZE5SQkZIcUIx?=
 =?utf-8?B?ZkFXb2NDK2JSbmZmWXBqcWRzNVlZYm9hWVJDTTdVYnNPYjFQNDVVemdXUjlK?=
 =?utf-8?B?d3JTZVduS0o3aDMzbzNYdmxscUMxVnh3RjdwMnBpdkxxMUk0a3hlQ3V6Qjdh?=
 =?utf-8?B?NFUrQ1ZUbFZYa1ptdXQyUHRiMmRUNHZZV0o2TkVmQlN3U1R3MlQ4Y1hhS1B4?=
 =?utf-8?B?S3d4YjZjTTV1ZFA1bFU5NHVNS1RkNXNqWGtmZUJGaUdZN2ZpT1hYYUlubmxo?=
 =?utf-8?B?MWlaNnFQYkR0UThiUG8vZzJrTzU5YXVSbkN4a0JuT2pGak5FRTA1Um5xMEFv?=
 =?utf-8?B?eHNDcjFUMDJKTlFvZE1sL0I2emFtSTE0TWlhL3JVYjhPa1VaTE5rVFhxcjcr?=
 =?utf-8?B?dHlqelAyakRLcW4reUQrZDY5VFlodUFPMXAwZHhEZW9pQVdpVUhWR21DNExC?=
 =?utf-8?B?WDNqOTBrbFZ2bzRxZTdtd0MyQ0lJclpjMTB0K0tVcGlpL3dWRitFN042MlFj?=
 =?utf-8?B?aGNRTEdmanRndTh0VkZ6eUkzcmlMWWJkQzEzMjhPckpWOG5VOCtOMGRKelJi?=
 =?utf-8?B?OUE4ajBTNXJIdWJiUU5KS2R4Y3EwcVQrU0YxUklickIwUlN1UHFwMG0xSzZN?=
 =?utf-8?B?RlRyY0RWd2ZSazdSUHRjZjg2OU83Zzh3V2JvRVM0ZVd1Nkk3TkxNaVNkRUZw?=
 =?utf-8?B?TGxoQWFQb0VMSjM5NndiV1haUXRNaDBHSmEyNnBRcXBLalZIUUZyQW5QTEM5?=
 =?utf-8?B?Yzc3UFNuKzJTdzcyZGo5QnNJZzRkMWFEWjVsUDYvYmFEa3dRMWxadmlZbU9m?=
 =?utf-8?Q?Dn084Dv4ovAuQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVNkcFU2elZRL2plcUp2WGk5anVnMzV6d2pRVnZHckNNOURWZWkxV2NNdjBY?=
 =?utf-8?B?dGRTVy9sc3dtV2dIRmZqUjZIMGh6eGVQTE9yWWJLcnJIODkxZWRsQUJObEVZ?=
 =?utf-8?B?Sks2NzhsNE1ZamFsaUNSemtCWXNKZzc3djNyZXA0eWZwTXJreUhxYU8xR0Vy?=
 =?utf-8?B?WWRvc3h2UndHL2xLQ1dKa0h1dGRsSUluZmZhNlN2T3FNQ3FUb3p3eHZSeGpw?=
 =?utf-8?B?V0o4ZWd3RWRHdHhaOGpFdC8wbzZFMHRJL0tiUytUbjV3RG11Y2haY2U1MmF4?=
 =?utf-8?B?eUFtam54d3hpeERHb1d5STBaaitQQzhEU2UvazVRdzF2MVExbTlIMXFzZHpo?=
 =?utf-8?B?bHR4Mjg3UU9sLzZaLzYvckM4U3dSYkZyMGwvclY5L3BUZzV6YzFYQ0k0NGg3?=
 =?utf-8?B?Mm5LSlIwTU1xeUpCR212TFBoeEp3aE1JQkkrWnVobWtRNkNsYWlQWHUrci82?=
 =?utf-8?B?alFqRWdVVlVCRDFMMHMrNzN2L09ZYThsMmc1UXJNUWliRUpldzdhUHZ0YVVp?=
 =?utf-8?B?dVZod24rQ1FlV1JSbHZ5S2xGMXJETVk3NWxIdWx2WE0rdE1tMEcrb1loMWVR?=
 =?utf-8?B?ankvTktjL2NTd0E1TFN0WUluaStoMllLTWRKTEJudEdzb0d0NkZGdDRLbVpW?=
 =?utf-8?B?Z2dHYVAxRXVtc0VkQ2wzUFczeGgyZDQ4M0RGNDE4SkY0ZG1PU0dMUWVYSTAy?=
 =?utf-8?B?VFlDN2J3cEJYeEhtdGVQUEtjTkdncldlZjV4TUdEN1lBQytPalZvNStGWTlz?=
 =?utf-8?B?djR1eTlUc01UMHM5QUthN1FXMXZrRXVBYW5KU2pkeDNLYlAxWDg1N2lkZzZH?=
 =?utf-8?B?OFlqTXJnNDJua1BCZHhRSU9CTjIvem1CSE92bFVJY1JOWlA5bG9ENC9JTHRN?=
 =?utf-8?B?UlRtc3FTY2JJUFdNYlRxMVJwWDZCaW5GZ2J5ZzRMc1U1SURXaWdUTHJHa0M1?=
 =?utf-8?B?eXF2dXNPOFFNVWIxTGtKT2h3TXVWTjZ4RVowZFhWbk9yNTk0WmNjdGVUYXRk?=
 =?utf-8?B?MjdDdzBFUGNYdzI5a1o2MWVjRXZxZW94RzZuVnJIaXVCOUgvMG1ZWDZVb2g5?=
 =?utf-8?B?VlkwUHIxT2w3bGozNVR0dzBDLytjSml4VzdqSTdLcnN5a0wvODhGeTl1MlRx?=
 =?utf-8?B?UzlXaWNmbG12RlZIUTQ3eVRyZUxNRXltSklTS3k3NzVkR1lYMEswK0ZWaXQv?=
 =?utf-8?B?SVhqaUd5V0RrdFdyazRYbUYvN0g2NWRQV3VDdW45VmpLeWx1OEd1Ti8vdmVq?=
 =?utf-8?B?dG1hVE5Fa2lXMUNOdm9ELzh4dG9LaDdNZnpPVmFsMEVMUElyTVZFaGdjY0g2?=
 =?utf-8?B?c2hzZlNUZTA3UGNGOVlCK3NiU1hLUlJmY0tTdVN0aHV4dmp6cWhibnVNR0Rs?=
 =?utf-8?B?TC9uSTFQYzVuUVlSSVd4Q1BqSThRdWRiMXhXSTloM0lGcWxoYVFRaUcvWGxt?=
 =?utf-8?B?UEVMTUsyRDY3Q2pFUTFzRFV0allUU09menN2ZXFONU9JZ0tyaHQxM1AzUEpn?=
 =?utf-8?B?dnVMMExmK1FLdVgwMCtzaDBNNEpjVFhSeDAyRFcrRXJEQ0dPeFVJeVNDbXJO?=
 =?utf-8?B?NkZyYlVUc2MzaEQ3VzEyNVhETUxUdkkrTGdtNEg0U3huRytJZnovbXZnNjNL?=
 =?utf-8?B?dlZ4V3EvVmttaGtlT1prYVJaQmlsWnpUZU9sUE1DRXNWTjFNYktPWDJqd3NZ?=
 =?utf-8?B?QitibkdQVVZ3OGxCcnpYM1M1cUczRlNWbFA1eDdBek1TdVVQbWNWVisvUG1N?=
 =?utf-8?B?Zk1NWHNPZGlxTkMrQkg1U3Nsalk1bUIvL1RxemN1VE1od3lwWlowZmdhNDBv?=
 =?utf-8?B?V05WbmhhbU8zbUN1ZktMTXg3WUtBemNDM2pwK1BURXBaem03K2Q1VjErZnZv?=
 =?utf-8?B?TkRjQlVBb1BxSTFERVpyNTBac3FXMGZ0QW9vZFVxM3U4TmtlN3RxWUF0ZEVr?=
 =?utf-8?B?ZnhraHRRZWNrRVRDWkZxNUs5Q3l1cGpsWFRTZ3lpSVdtOFFjU3pDYmRDYXo5?=
 =?utf-8?B?ZFI2Q0FMRzY4dEhKdFN6Z1dHL0dmUVRObzNxU29CVnVVNkh6OE1paktwVm5X?=
 =?utf-8?B?WVFmemhiUGZmMFhvKy9EczB0UkZsdS9TVGJFaEZKajVuL1pMSVJkd2Q1Wm9Y?=
 =?utf-8?Q?At7/0UWMpvkn82KMKNHauz1Vs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f32be2-6105-423d-aede-08dd4ffd5e8c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 09:19:38.9764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yo/7HwMXEXcsOwraRdidSrlsvZYdPkPKmyhga4EhkIOAWEjhoCYWIQqPmmQeXSRfIL4TIsi+tR8XMX9TF9M3JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7115



On 17/2/25 19:18, Chenyi Qiang wrote:
> Introduce a new field, memory_attribute_manager, in RAMBlock to link to
> an MemoryAttributeManager object. This change centralizes all
> guest_memfd state information (like fd and shared_bitmap) within a
> RAMBlock, making it easier to manage.
> 
> Use the realize()/unrealize() helpers to initialize/uninitialize the
> MemoryAttributeManager object. Register/unregister the object in the
> target RAMBlock's MemoryRegion when creating guest_memfd. Upon memory
> state changes in kvm_convert_memory(), invoke the
> memory_attribute_manager_state_change() helper to notify the registered
> RamDiscardListener.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>


Reviewed-by: Alexey Kardashevskiy <aik@amd.com>

> ---
> Changes in v2:
>      - Introduce a new field memory_attribute_manager in RAMBlock.
>      - Move the state_change() handling during page conversion in this patch.
>      - Undo what we did if it fails to set.
>      - Change the order of close(guest_memfd) and memory_attribute_manager cleanup.
> ---
>   accel/kvm/kvm-all.c     |  9 +++++++++
>   include/exec/ramblock.h |  2 ++
>   system/physmem.c        | 13 +++++++++++++
>   3 files changed, 24 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index c1fea69d58..c0d15c48ad 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -48,6 +48,7 @@
>   #include "kvm-cpus.h"
>   #include "system/dirtylimit.h"
>   #include "qemu/range.h"
> +#include "system/memory-attribute-manager.h"
>   
>   #include "hw/boards.h"
>   #include "system/stats.h"
> @@ -3088,6 +3089,14 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>       addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>       rb = qemu_ram_block_from_host(addr, false, &offset);
>   
> +    ret = memory_attribute_manager_state_change(MEMORY_ATTRIBUTE_MANAGER(mr->rdm),
> +                                                offset, size, to_private);
> +    if (ret) {
> +        warn_report("Failed to notify the listener the state change of "
> +                    "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
> +                    start, size, to_private ? "private" : "shared");
> +    }
> +
>       if (to_private) {
>           if (rb->page_size != qemu_real_host_page_size()) {
>               /*
> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> index 0babd105c0..06fd365326 100644
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -23,6 +23,7 @@
>   #include "cpu-common.h"
>   #include "qemu/rcu.h"
>   #include "exec/ramlist.h"
> +#include "system/memory-attribute-manager.h"
>   
>   struct RAMBlock {
>       struct rcu_head rcu;
> @@ -42,6 +43,7 @@ struct RAMBlock {
>       int fd;
>       uint64_t fd_offset;
>       int guest_memfd;
> +    MemoryAttributeManager *memory_attribute_manager;
>       size_t page_size;
>       /* dirty bitmap used during migration */
>       unsigned long *bmap;
> diff --git a/system/physmem.c b/system/physmem.c
> index c76503aea8..0ed394c5d2 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -54,6 +54,7 @@
>   #include "system/hostmem.h"
>   #include "system/hw_accel.h"
>   #include "system/xen-mapcache.h"
> +#include "system/memory-attribute-manager.h"
>   #include "trace.h"
>   
>   #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
> @@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>               qemu_mutex_unlock_ramlist();
>               goto out_free;
>           }
> +
> +        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
> +        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
> +            error_setg(errp, "Failed to realize memory attribute manager");
> +            object_unref(OBJECT(new_block->memory_attribute_manager));
> +            close(new_block->guest_memfd);
> +            ram_block_discard_require(false);
> +            qemu_mutex_unlock_ramlist();
> +            goto out_free;
> +        } >       }
>   
>       ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
> @@ -2138,6 +2149,8 @@ static void reclaim_ramblock(RAMBlock *block)
>       }
>   
>       if (block->guest_memfd >= 0) {
> +        memory_attribute_manager_unrealize(block->memory_attribute_manager);
> +        object_unref(OBJECT(block->memory_attribute_manager));
>           close(block->guest_memfd);
>           ram_block_discard_require(false);
>       }

-- 
Alexey


