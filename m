Return-Path: <kvm+bounces-55721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A9AB3527C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 06:07:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A5861B2713D
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 04:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694CF2D23B6;
	Tue, 26 Aug 2025 04:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VEC5Lrse"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1233D984;
	Tue, 26 Aug 2025 04:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756181230; cv=fail; b=LNN2sem14oTaz05cqawpRSdreWbtScyNKwZ7TXMe8N8T8rtoyZulGF+b4an2qnCQZhDq33Qdi5vC+pad7PIO1mCFFvMiMqwGmIQyKTMv5dSI2vAYPXz4vxWVgd7oKuFZADACpmmi5kb4VmoRkeMh6aMpxlbX9nP9N3U2g9yXW0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756181230; c=relaxed/simple;
	bh=VJyN+oqEUWEB+mgDDLIkEjHNcdcGiq4DNz8c7XVi55k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XczQPKf4XWEMsglG7YEWZy4Xv50Z95c3B3lEplVk1+us+bP2fPS+/koOKHupitexHMoF/fBTyhMcfJwqiSPXF85vCn/P+4L4OGEbJnhm4bCtmQzLwmzgT37iR7RKbfeQOFxellX81kN1nZC+k27q46LZAluEEiEkChVs/rJOFI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VEC5Lrse; arc=fail smtp.client-ip=40.107.220.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HEuB4YX6cPUG6JtSSSm6zLRl8fsaJN1sRThbjUpMGPQ1TuhJjHxnwg4IIS0GxNxSXvj+AOg2yaSaAHRie1hXArd+DrpTEKxtKkMDHUecDY8P+EcfSSWX72Bn9c1S37o8C4TjheGzdCcQxpil4Q/3JG3Q3wroRJAT1Z0wSI/9q8Z02Jxb/EuFnpwxcXnqLtzI7Uct2Gqm28WTzLE7ZAS0FpNS0WxFoh0gAGWkxf3OGT7lkVCZ57+VSqY8iaGFFVM8VpoR75skY/asM3Nd0tN50GXR8MLNgcU7kl+h7zsQTNDNS2VSrWC6x7gbL+gzQqd9Y5GhGWgf4/ftT89G/bGsNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25qAwpdzMjm81CZXnfv2deTAn31HBJy7HXGbjJ8L5j0=;
 b=kpYiPlZ2xDR/zWZ3NGEcymEzAUq1ra/QqA2r+8h4/Z3Z5S3cooZcjEtvYAkZQ7nqhIxOGa6WtnEWpTksMN4SfEyE10ITOjsNu1yXcwxVUp3xz1viGgMepvN5obvfBzGFYKN8LGVa3Dhu4XNwqtgzwJIwlGGBHOmwt8sVIwdLfw4iqHNx+hBEJWHgc78AcUe7NzleG5hHPykXx0Ct6txJyL2gXgNr2xrLjZ2KyBBc4o8bcp4AVllFYSPyoZs5mNrYa/ByAFptJtgPQ/RB4Gyprxaf1QWxoZagU/50Pn9s6Ko+NhdBVJKUbsvu0DjXUBOgF1y9yHOq37bnreuAx3c3Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25qAwpdzMjm81CZXnfv2deTAn31HBJy7HXGbjJ8L5j0=;
 b=VEC5LrseMiY/O5d28DdOtZUTdNu3kOTgoEF6kAFbekdKxgGNIm7oe+jvjzf7VvGOOOyQaQCZVncZahLFzAo/mgX7lPugkdbTiyKmHN/g+QsYb2tKS/RL5EdgPkQuMJoy4gpzjRff1zTGj8j92170ZD9Gcec3NMkBTV+GnjJ64ko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH0PR12MB8462.namprd12.prod.outlook.com (2603:10b6:610:190::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 04:07:07 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 04:07:07 +0000
Message-ID: <74234b63-d9c3-4429-848d-0953fa684d5c@amd.com>
Date: Tue, 26 Aug 2025 09:36:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/18] x86/apic: Add update_vector() callback for apic
 drivers
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-6-Neeraj.Upadhyay@amd.com>
 <20250819215906.GNaKTzqvk5u0x7O3jw@fat_crate.local>
 <c079f927-483c-46c4-a98e-6ad393cb23ef@amd.com>
 <20250825144926.GVaKx39npwZZ18htgX@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250825144926.GVaKx39npwZZ18htgX@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::12) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH0PR12MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: fde390d1-3772-4817-18d9-08dde456058a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VllhdWZsRmpIZmhZV25ROFdSRXJtRDFXTjZlbVhaTTZHMytQL2JNYm5mNjRY?=
 =?utf-8?B?Tk5JZXFOUlA4Z0JNejljY2pCSE9pbmhhSG56VnZlZVBESmRqUDBuYnVSSmhP?=
 =?utf-8?B?TXB5azlyUW92RWFxcXR4QzJoSFc4bGxKd3hxcG9qcUt6c2s3OG9mZmZVbVdU?=
 =?utf-8?B?UXhPQm5WU3ZZSXU5NStaTEhuZlpPc2dnOHNtOC90K2N2bnhTMHdTdWFHZER1?=
 =?utf-8?B?VDlHSWRlaGRvK29CMUpiTGZWSDM2TGFuTGZ6VFFsd0Z5ajNHdWJmRnc4enI1?=
 =?utf-8?B?ZWVXQUEzV3ZEdWFXNkZPaTI2bzA1OGt2WkhUYW04dnpBYURGQVhrQkt1RjB1?=
 =?utf-8?B?cU1aVE8ySFdDVXpCK3A4ZTd2QjJ2UHE5ZTlaYjlQbU9FUGM0dWNETUk2ZkNm?=
 =?utf-8?B?bzFKNU8vOW1CZENET0EyNFoxTmgwU2ZjdlBuQjNYTlUxaDlob0dBcjFkZDBS?=
 =?utf-8?B?S1h0bzlheXdSZWNSRUs2Q1I2U3pFMjZNUkhNSmU3b2tDd0UyNmxHQ3hNV2NY?=
 =?utf-8?B?NVl0cHdRT0hOQk52V2tMVU5rRHMwbUkySncxOEM3cUFobCtXVHZZK055c0M4?=
 =?utf-8?B?NHVFaDErbjZ3blozS2JweVRyZURlTlJxaDFBY2Nzem5XUVU4WTk0REduYjlv?=
 =?utf-8?B?STljcDJ1VitEREVJY0loNW9HYURyTmpLa0ZPQVUrK1ZwVzd0WEtoK3pOV2Y4?=
 =?utf-8?B?RG9sY2MxeWZWR1dyTmcwTGhHK04wWXFSaXROMFNkZzQvYXI2SEpSOU5FQm1Z?=
 =?utf-8?B?V0hBbmNzTlpiNHJUbFlFQ2hNTzd6Ui9nbVlqbDZtTTZZcmQ0cE10c3hXK2dM?=
 =?utf-8?B?TzhjMlEvMURyV3hDbitGcy9LdU5BLzdYaW4vUjcvVksydUt3anVCcjZDZm9H?=
 =?utf-8?B?THV3WCtMTGxFa2tUQzl0ZVMwcmtHZ2JKNGdzWXU5ekV5aFAva1F6RGV5elNk?=
 =?utf-8?B?VG82QlZEYUw2dFFWNHJhYnB3dk5aSTltK2tyaFlNdVRIZStGRkh1ZmE5VEVO?=
 =?utf-8?B?dDRveU5LUG1hK2t2UlNPbXJ1dU9hdnlOQyswNzJTSTZFd2p6ZWpVcERWaHV5?=
 =?utf-8?B?aTVTdnFXazRrTXVQbDlPZi92N2VNVThFdUh6K1FLQ2hWTnFEdE5UYUJ1RmRz?=
 =?utf-8?B?VGp3TlFhTEJKUGxKd1ZhSmNmZjNMVGd5NXF1UlZZcVhwSzROMGtkRllNSU5u?=
 =?utf-8?B?U1ZvaCt0dk01UEMzbkdIalIvU0Y0TElVTWhaZE9pekFobEdmYnhUVjQ2ZkFO?=
 =?utf-8?B?VU0vMU5ETWNXLzhoM1Ezby9ocnhtWURzZDdmeC8yQnlQYmhXdTZhMlo0bTFF?=
 =?utf-8?B?dUZiTDdlRUFaSXBJT09nMmRhRFEwbU1rWVo5QmhNdklvZGp0QWZYV2FKKzk5?=
 =?utf-8?B?QnZvVlJJRnhVWmdLamJiVStqUjRTWEtsSDlaQnFFNzN4OW1kVW8xVHFKY0Ux?=
 =?utf-8?B?Si9yQnZBWEVYek56c0Q2YnlzVzIrcUtpd1cvNEhucmxRUjIyS2NQSkkxbG8w?=
 =?utf-8?B?TDc4Nk91L1FPQzVCT3A0MS91dUhuUHo1TVIvYTZaalJRVUUvSmVneXdtY3lD?=
 =?utf-8?B?UkY4VXEzYkRQbm04UStrK0duRkxwNFlCOEpESzRkSXErVStMdlhGeTErbTdF?=
 =?utf-8?B?enR1TjF5MEx4U0hBL2JKeVJMbDFQSFZESXNUWUYzaC9LU2N5NmxXZlFlbGw5?=
 =?utf-8?B?dW5TQWxaTUsxRE5XV3NlandyREhWWDJaQUNZMjVWWldmd3pLQUg4RUovWkxy?=
 =?utf-8?B?aEhndkRid0xlSnVrUVUyWWhRU1NMZkxzclBzS2kybXdXN2hIbW5oMFJNVVdy?=
 =?utf-8?B?cnBjN1ZtT2VQSnRMUW84dWdsZ0VibUFPbmtid01hYkZYQzlYNVhMVUFJSFNV?=
 =?utf-8?B?Mklucy9ZN0hnUU1kTEVwTHpKaHRrUTFVQkJ6YmNrQi9NQncyOTdsTWp2L2hq?=
 =?utf-8?Q?KitpaizO9fg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3Erem56U1VLdGVsRlA0V3J5ZzlURkFVa25wUkh6Y3ptWkF0NGJROTRwbDJD?=
 =?utf-8?B?T1dKR1NidE5zYm1SUVdXOXJvSjQyNXJpSWhKM1Y4R3UxWm8zOTFwazBGL1h6?=
 =?utf-8?B?dExLaGhINjNQcUJQVjFkTm54Ui9HbHhsQndxSUlUNU41cG9tMzIvMU9zMkpv?=
 =?utf-8?B?aTFJa2lLdnVyK0dEL2lBVmRNUjlINDhLaWM5RUhMZlJ4a0ltSXVzcVJ3QXpD?=
 =?utf-8?B?cENvK2RJK3V2OTlBTFpINlI2bXcxVGpuQWwrYUd2ZDZidDY0aDBlOHF3cHd4?=
 =?utf-8?B?SEpaYVVZQkIvRTZhd1FEaXhoR051VjVPcDByNU9haHI2WHBGcVNlZzV4RzhL?=
 =?utf-8?B?Z29LWndLMVJZMUpzV3IzTkg3M2tmcGxEK3BQYTlYelFRZk9Ja3UzV0VLNWkw?=
 =?utf-8?B?a01SeUJJRXpmNjNqTmsvRUtFWG44bEQ4UDNWUnlteUlXMUZBTm1uc1hSUFdL?=
 =?utf-8?B?eE1xQXhrKy9LeHJnQ0pEQUU3a3J6YlErVkRsMldZQjRxV1U4blFFa09xVHBE?=
 =?utf-8?B?SFdCY2l1UmJ3bWxsRUZ5RU9PYWYrTU5sTzFGUUg1ZklMS2ttSW1WUmNiZTFS?=
 =?utf-8?B?OEFScHZLdXpUNkhqY1FjS29nVi9iOElvamVZa25Cd1oyTTZiZHJDWjRrc3E5?=
 =?utf-8?B?KzdSRmhEN3o1V0lHcU5tSHk0MlhHaHk5aTFaMkRwVnZBRjdVUmdtWWpmUHQz?=
 =?utf-8?B?YUtadTM0Q3ZYdHJrdUNiV3NJZytucEdCTDdkQmxHL3FhTnRHd1U1bGhjdTRL?=
 =?utf-8?B?NXFGZmlOWW1aVWEzaWFQbzdWeVJ6V2R0M2dHWUNVV3FwVlUrZHhXdGpzSEpv?=
 =?utf-8?B?KytyMWlSWUVleEk5QThGcHJNUzA2QUdUTEQ0K1VjRWxHZXJqaFd6OVN0MWQ1?=
 =?utf-8?B?U0ZwcXdHWnRwK1J5bFUxM0llZGtWYWJXZk5KNDM0RTNLL2ZXeVRTRzZ3emxj?=
 =?utf-8?B?SjZzMkd3NU1hdlN1VGtVUU1HRW5seSs5YklOUjN4bnJvMzF4QUVKWjk5WWhi?=
 =?utf-8?B?a0pVSW0rRHJnSnNreVVMQVlhSVhocWdrOUt0U2lwY1BlcVRTaXBxaVJyeXk1?=
 =?utf-8?B?UXlSQTNJL0JiVFNacFo3TVltWlM1aWNwTzNnUHN0OStKcXdTYVc0aEo0M0h6?=
 =?utf-8?B?Qk43QjRiTWtKRis3TjRwakREeFdaY3B4NitxNnhxdG1jUFUrWUR0dXNoY0Jl?=
 =?utf-8?B?RjE3NGlNVVMvY1paMmZxQmRlcG44WkcyRWI3ZCtWaHdaSUNhcVVaaUdrb0NZ?=
 =?utf-8?B?d0tIUEtsSkFwcVJkV1dwR2xWNTZORE1CVTh2NmloTEdqQ1ZNd3lTTTZ1TDNl?=
 =?utf-8?B?VUpWOEN5M2dXRHErb0crWWVNVXdCc3dGS2cwTHJFclIxQUVCa1YzdlpXK2xZ?=
 =?utf-8?B?ZjlRd2llRWYzVk9ZV2p6UmEwY1o2N0NTK0JHcVQ3akFpNjBEbTBZeGNPekZZ?=
 =?utf-8?B?YzIzcUFBbzU5Y1hHUXcxOHdER2s3SVVhS3JwR0NJTjhKNWVqekNrN3EzUmc0?=
 =?utf-8?B?allZaEFOSW8zMjMzaEpLQmVhUmppNm91SmVsM3VPQlpFdmR6azZmdkduSWpj?=
 =?utf-8?B?YUpqT0lScDJVak9oMUU0dzBQQ3R5T01TMjRwQ24vaXhUODkrdjZGQVpaUEtF?=
 =?utf-8?B?cDA5K0JmTGdtT2RqUnJtUGRpSjJqN0VuN21STTZOL09PWTlhR1cvcGxkWEp4?=
 =?utf-8?B?UDh4V1Z2WnhGc2s3bTU5dngrS1FSSzhVeEJCZ3p0MU5KUy80SGdFYzlwckIy?=
 =?utf-8?B?Q0FqVG9KS2ZWL0htS1grTVRnWWtlZTVlaXVXSVF6T2x0TjRrNWpkLzJ2ZGkw?=
 =?utf-8?B?TXVheHZmRVlZRDNFd2tUL3pITlFwYUpOMHROL0N2bE5GbWE2VXhOenB2c0xR?=
 =?utf-8?B?eTlCam01WVowcFFZUUZOdllqYjhqRHFtWG82NW5Sa2ZleWNXVXB3RytLL0w0?=
 =?utf-8?B?cms5L3RuNTlVa1dwZDlIU0RoWHU2TXFlQ2F5YzJTWjBsR2xPL0gvenpwckFj?=
 =?utf-8?B?MWRheGlYdG8vU0dvVkFodGNRcFR1SHQrdldSVnZEcmFMWUNHV3lvemVPRGhl?=
 =?utf-8?B?L2p5amo4WkI4a3FCbEFiZkY4bjFkZ0xpNWpaTTVjMkVBYnlQd3BGZDVsZFJl?=
 =?utf-8?Q?wYDv1lgMzfu1XHgE78wKiWaSF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde390d1-3772-4817-18d9-08dde456058a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 04:07:06.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/VY7KYtiNcvCYlc+vCi/nGJ4YjhVAKitY2sEJXkqM1kH6xMLaJmqY+PqvLQyU+ZRXbtvwo2eab6SFkaWZuY+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8462



On 8/25/2025 8:19 PM, Borislav Petkov wrote:
> On Wed, Aug 20, 2025 at 09:06:52AM +0530, Upadhyay, Neeraj wrote:
>>>> +static void apic_chipd_update_vector(struct irq_data *irqd, unsigned int newvec,
>>>
>>> What is "chipd" supposed to denote?
>>
>> chip data (struct apic_chip_data)
> 
> So this function should be called chip_data_update() or so?
> 

or chip_data_update_vector() as the updates are specific for a new 
vector assignment?

> It is static so it doesn't need the "apic_" prefix and "chipd" doesn't make
> a whole lotta of sense so let's call it as what it does.
> 

Got it. However, I see other static functions in this file using "apic_" 
prefix (in some cases, maybe to differentiate "apic_chip_data" from a 
generic "chip_data" in common kernel/irq/ subys?).


- Neeraj



