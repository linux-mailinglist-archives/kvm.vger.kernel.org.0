Return-Path: <kvm+bounces-31398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A94929C371B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 04:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AAD81F21E16
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 03:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8637613BAF1;
	Mon, 11 Nov 2024 03:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jo99FO9s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1607184F;
	Mon, 11 Nov 2024 03:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731296734; cv=fail; b=L5knm1z4j9RBylDUfpM9ZO1Vl8SEnsYfeFXOOclOBTwj5qqtGh6fC3EkyB3Yo1VDgk7um+S7lpJXw5eBxuZttkdFfz69TSvFXRzXBlIPTRS6lhQZI+8bY4tvRJh8nSmdmOIv+GUB95GmHcYR+seJWoBosefvRQOSP+oIlZrxXXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731296734; c=relaxed/simple;
	bh=oeQf+bchtali3TmLuRdV12fzVbhTY8UltcvHZiutcVs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MK4EYJOakkQSND77jdz1gkhTpg3peM8VLVX/27CATe3ISwnO50XyyesZncXkcm5YBQeP+8GR+YcMZXxTcEU6SmXz2EvpKku60yZrhSAcXBjI8lJN5JYUbPnQr5liNH6phnAqu8bYoa8uTOJTlPsbNkLJTJC5T/0GzylN0CfMW9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jo99FO9s; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZDXHCKlASMfJ/j3ZBln/ngAtgbFTf5Pedr+5VKg+MHGz+S/z05psKfpP+N3EG4HLpb1OwnIQaPZ4087MNuNznIWuYsTG8Ciz9sHKJqwmsLO23VcF8mLCrGM+hYMfoTXrsH3F0c20WaqcosiDD1bB701DKBJj1BEGnSrGsMiY8oXlbxBUT52CGNolDthr9Vtve88vjRLaXbB5SIXnEDWEdmFnTcDf/h5kUpT8QmaaDEc+Zmif+ir/h7qz820yY3IQ5WUrxiagNcgWrsrFJo9T5AKcq2xFNAC1A1+Yeg75a10rMz74XTtT5mWrXNyGENWRoyzqRnX94lWUPrkJ+mlGRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpwdHbdpYgbfeGtJZmoKIjXV8+BBPcxSPrFBOZIbWlk=;
 b=dwjlV8mwHA48gRNFPqq9fdb+bYqbBZ+T7uvx/GLWIWg+Dh8UygcGmSWDJ6tLy3NWrq+QJ1LRfCqDbEAhfsUDv97EZRX73VFrTUUeyCOTTLxrvYwuG2FwuLWwT5RTuZLWRdp2kkbEUaYH6JqDiSyWLT8DzMG5Wy8XB7tff639KsP4yWclgGpvZzM9ndp+vTtJAcDLObZwJNpJn43p+2tRYMWzHcbKUjtdwu4NWuFrpfSfnWf6yeIShiJLeS8ilXFWN8U5rDVe+eE0IWh0aeUwmdGPKYzAVC7EJJ6yJfNrKpimhstS9yz6kHAdJH+3t9WrfD2c0m83WUXiWHZq18hRfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpwdHbdpYgbfeGtJZmoKIjXV8+BBPcxSPrFBOZIbWlk=;
 b=Jo99FO9sCDUEUxklw9YZCl0KxSF4ilSDAZaMd1QAuryxzcseTNNcGjMSzsQKhqYgJjRQIB1DLqrRcVVEL2bqOOIFFbWIothhIjFbdMrOOoZqlfMs8NBAqZNLLX2C+ZujM2aGH6XJtgPFF9/et9oU8wUnB8CZsKbHGfWAZW/o0yA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH0PR12MB8127.namprd12.prod.outlook.com (2603:10b6:510:292::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.28; Mon, 11 Nov 2024 03:45:30 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8137.019; Mon, 11 Nov 2024
 03:45:30 +0000
Message-ID: <3661c463-9067-4435-b1de-f5152762f6a3@amd.com>
Date: Mon, 11 Nov 2024 09:15:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 05/14] x86/apic: Initialize APIC ID for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
 <f4ce3668-28e7-4974-bfe9-2f81da41d19e@amd.com>
 <29d161f1-e4b1-473b-a1f5-20c5868a631a@amd.com>
 <20241110121221.GAZzCjJU1AUfV8vR3Q@fat_crate.local>
 <674ef1e9-e99e-45b4-a770-0a42015c20a4@amd.com>
 <20241110163453.GAZzDgrYY2oO7fKvxl@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241110163453.GAZzDgrYY2oO7fKvxl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0153.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::23) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH0PR12MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: 37782002-dcd4-482d-8f81-08dd02034967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjgrOGlnMFIveWtEK3ZQd3h4cUdGTVBBczJCREVNYzdMSTdLZGhwbXFhbXlU?=
 =?utf-8?B?aGV0SGhKQ0ZOT0gzdGdzQ3IvK3FMdlgwNERBcG8zSmdIUHhTNnZIUnorYnBV?=
 =?utf-8?B?R0hXQ2xnelRIYWNSRmNuMkxSU25NTFBKb0ZUNjFhclFIZFdlYUhzK1JiSnE3?=
 =?utf-8?B?dk1razIxRXJlTG9SNGFueDB2VzdCRnVCTVJ6UWxQWHJuS1doQXlyRUR4VUlh?=
 =?utf-8?B?b3ZUV2U5RVhIY1dPQlhXSFkvRG1iUlRsVys3WVVKT2gvdGhWZ0hiM3c2Mzdy?=
 =?utf-8?B?ZUw1YWZMQll0ejZHVCswU2cyRVlpNzN5MDFUeTlBakFRNkhIalcrblBIL1lP?=
 =?utf-8?B?aFNkV2p3cURuRHFXNjdiVVhkcmxIMFBkcW92bXZJQXdTdXByL3o2NTFTNHhH?=
 =?utf-8?B?YmZ4SHRUalpTMUVJRjUyNzIrVEpacUtiZXhOaE5SZE9nUFVoUWRFdmJnOEUr?=
 =?utf-8?B?cDM5N2NqdDhBeVp4ci9SdnhzbExUeXMvQkdlMnhCTlJ5UFVCUjIzeGRrNjNl?=
 =?utf-8?B?L1RtdXJVMWZydFdYR1ZaWFR6a0J3UkM2d2YxN1hoTGpqZm05TU9HQUoyRTBD?=
 =?utf-8?B?UzloM2ZqVHB5VnlxMWlBTDBWVHI5ZzlvRjZHWEQ1NWxPeks2Znord3ZORUw0?=
 =?utf-8?B?YkNuTDFuSVNSZUNYMzVDMXVjOFFMWTE4bW9UU25VbFF2NHdZcURiNWtIZERB?=
 =?utf-8?B?c2Q3NWllTERNdlJoa0JrWjVxZ0hQaVRoNXRCc0JDcmZLVStYcmtHMzBrdURs?=
 =?utf-8?B?NFB2cmxMOE1hbS9lR001MXg1SE8xWEpOTkVNTnpXZDBvRS9xa3ZTM2xIcWVF?=
 =?utf-8?B?c2t4VXJzQitMdGxmbnc3RExvUnVCbVJqcW1XWFFIelJtWHhobUVUSlZTelJX?=
 =?utf-8?B?alJWQlg3a1hsSXRPZks5eWk5TVFWQlk4V3lEMnRoRU44MGhKbTRpTW1ZNVdV?=
 =?utf-8?B?NWZBbDVXTmRQeEJjZXRoM1JWdVlzZEplZzRVNGNtYUFtRUtiUkV4M1Q2MEo5?=
 =?utf-8?B?VHg1YjhJZ1l1Ym5IVC9qaHVvblJiVHUwU3UvM3R4cFZuMzVnNTdULzRvTHgy?=
 =?utf-8?B?OFFQSWNMR1MyNEZMN1JqSDJmUVZNMlltZDhSLzV3NG1RZXMrVlR1dWphb1BJ?=
 =?utf-8?B?TUZKZlIzUWgvVWo5cmd5S2lhUnFrc0N5RFh3Yi8yMlNKVlFKRmszT3BGKzNn?=
 =?utf-8?B?b1Yrc1BNZWlPYjJmWFhjNkNvc1hITkV3T2E2OXJNZm92RHMrSGFQVXRhcWhQ?=
 =?utf-8?B?cklUS0NTanVFUUZLNTVJSDZONk9RR2RjVTNzWEdDTFNMRTdSSGJURUd3b1F6?=
 =?utf-8?B?VU9ycTFnRkJKVzdXT1MvNlUyQTNMZTUveTh4T2ZsK3VPVFl5Qi9BTjFLVHJD?=
 =?utf-8?B?ZHB4NmlsOTF6MjVCdlBLMU1YdWNkK2pwSmk1WmhzRXlGQ2ZobXprSmJYcEFE?=
 =?utf-8?B?bCtOSmQxSzRndWo3anJkKzRPZ21samppeEFtQ0JpUThkVmZJMWIxbC9pb2x0?=
 =?utf-8?B?SUJkZkpIZWJSZWU5SEdCMkJicE9Yb0RKMDJCTkFGRnlqOXVqYVJMN2RsRUJV?=
 =?utf-8?B?VUs4dmgwaDZaaDgrRXRGQU8xYTZxaU9IYURMdktZSFNwL2x2bFVlazFpejJU?=
 =?utf-8?B?amprVGk2akxZaW5DcS9JTzlFVDJnTkltOHFYSFY3Sit2Um1JMUt2MWJTQnl1?=
 =?utf-8?B?eVVROERRNm52RWR6eFA1TEJadGJRekhQN0Roa1RxWHFXWEtxb0t5QWc2VWZp?=
 =?utf-8?Q?ag5VVudkzldzD+JmqhGAqxxkfls4TTgSZa63DPD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?em9yY0VHSXVhS2cwcTM0Y1RRU0Z3ditjRk0vWmZ6Z0RVUE5EL2QxTnJEaUt6?=
 =?utf-8?B?bFp1MUd0bXQydzFlK0hrWUd2LzV5MHZGV2hQTUxSVWd6YzdLOStJZXNRbjlB?=
 =?utf-8?B?dWVyU1hvTnkya2JlUXVway9vV1dVVW1SYlExM0R3L0tkU2EzRHduditaaFlJ?=
 =?utf-8?B?NUlZbEk0aitiWklWdFhLeUlORVJxaWVhR1g2Rys5SDFSQ0VXbWg0TzBHYTJJ?=
 =?utf-8?B?aFdMYnZmUlBtOXZOK05Jb0Z3RkRIRjZUaXMzTUY4dkVtdllKM1dDN0s5emxU?=
 =?utf-8?B?WUFrZVRuL1NpSXNZSEpaZ2RwL2dybHBibEZBM0JLY2NsYTE0NTVGaGgyZXN1?=
 =?utf-8?B?akg4Tk9rc3Z4MGxLRTFZKzJTR1p2ZGd5UVNEcGhtd2gvTU0xKzVRekNNWmdr?=
 =?utf-8?B?cHBaaG94bnpJakhqMnIyRkpHeTFtUVBYTjVIYVdONVBMUjlSYjgzMHFLWVFz?=
 =?utf-8?B?RUNJcHVlVCtvWTBsKzlYM3ZDZGRqb05JRTgvcmJDc0JJdTZlNWMyTW13cEIv?=
 =?utf-8?B?blFMTllHVWJpOTRDdXFZeFRZNXQrdlhoaFovTEpGY3pMcFRPRVZiWVdhRWlk?=
 =?utf-8?B?NDBNL0k5NlgvYmVmTTQyaXIydjlNQlFUQ2tOLytEWEhWY0U1eTFkTmgwYVk1?=
 =?utf-8?B?Ymw1Ny9aL2Nrb2pWbEFiNDJMZGpTLzJOeW5HQ2ZoK2M4c0ZXeXJpOFJuZWZY?=
 =?utf-8?B?TkF0eDFTTkxBSFllKzhuRnVrSUUzVlcrUFdjSnFNVFZvRlJ0Y3dxSWxEYk4z?=
 =?utf-8?B?VWI5elIyaWcwZnhIQ2l1SDFIRVJqSlNkRGhhUyszbWlYT0N5RzhFa1VWMzVE?=
 =?utf-8?B?NXM4NUhUcG1NMHlyUGFISm5HSGhBNUR1bUdZdzdxRzhqc3IrMmNzSEh4VUVx?=
 =?utf-8?B?bVJxWk5EMFBLQklVUXM5ektNTkhQbEZwUS8yS3JIUUEvdmxPUVBUYjg2QXRY?=
 =?utf-8?B?UlljdkZSS2htM3ExZ2JBM2VDbzFweTV1M01DeW8rSWNQczlycmhwRUxtY3dE?=
 =?utf-8?B?K1o3T1NXS1htd3A4QWsxOFZaR1AwL3A5eEh1bFVEUTRwL1lhbFBFN0cxTXRp?=
 =?utf-8?B?dWVWOVJuRkNJMTBscE1jaktEek0xbGRib3BqN3U4bXdmVWZ1dThJSTBSZjdp?=
 =?utf-8?B?UWFpcmF2U1p1WERJdm00cC9tbnFtQVB0dzNaUkdNRkdpQXFHL1pab0FXSUJE?=
 =?utf-8?B?NUdOcysxclFxRVlVQVFoa3hvTS9mYTlZTDBPN1NhelhEdDRJZm1zYXV3REIw?=
 =?utf-8?B?WWEySkpWd1ZXQThQM29MQy9JekZPTlRKaVRDMy93enpHRFFyVjJueVBsV3lp?=
 =?utf-8?B?WUFkQjNJaU9oZTdsZ0FCRkdGamN3MVVBenNPZEFDVkNhTGdKR0VBVnpsNHlR?=
 =?utf-8?B?R2YvWWxxSitmcThycjV5alh4N2dhOUVBa3pQdU9rTEIrZkxxYmM0Rkg4SXRG?=
 =?utf-8?B?cUU4OU9lUGYwRnMxbm5EOVUvNStEK2U3S2hOSnJxa0puM2Z5SXBORzllQWll?=
 =?utf-8?B?UGFvYW5ZV1RIUHFDR3BhN2ZSU25aVTFKNG9vSk02cDkwNlFLdW9sM28wZldU?=
 =?utf-8?B?Smd2RDYyVjFLRkpST09NMWZjRkZ6QUhueXF2Vi94TW9ub2hncW9BSHREakxj?=
 =?utf-8?B?ZXpTQ2R4UFp5RW4wbEZ6VFBlbGtkVUlkbmRwR1NDbk5TSTJydE5tcXRqYysz?=
 =?utf-8?B?aThXMkxkNnVDSHEvS3BIL1FDSVdhbkc3MWdFa1hrbFZicFFZRzJoeXIwQWsx?=
 =?utf-8?B?blFBbitJK0Q1eFJNbzd5RUt1QXB4aGNBUi9qY3VrenhuVFp4bGw4emYxZEor?=
 =?utf-8?B?YS9HdGsyYWh5MkxFeVNxb0pMSWRlWkM0Ym1STHNFQ0lZYmhjYjBKc0JsK2VI?=
 =?utf-8?B?MzNiTHAybkg1bC9mZFREYUNDYlVwT0xqVnE2aWRSeCtnNGxRT1l5QUphdFM1?=
 =?utf-8?B?NXkrVFVjenczRHV6V3hhWXZHczdCcnRiK2dkTFB6dUs3WXZqUzFuYkp1VDlp?=
 =?utf-8?B?K0djUENKNm5CbUt2Y29udXBTUXM2ZGZKdzdpM2hnczJlRk5GRU94VXAya2pw?=
 =?utf-8?B?a0hQVVFINmJ3alRXaVRPNEFqeGV4b001Smo5Y0YrUWNGRGZRVXJSRmMrWG05?=
 =?utf-8?Q?m5yzJaccv4UYKHFRyPO/pmBxm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37782002-dcd4-482d-8f81-08dd02034967
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 03:45:29.9634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: laiackFvFBgFLDmC2fcIylwHPsRaGxIyrlymvbFqnMJxnb9H6umcRbPHakkchwHYmX0yAIrPUI7S/moWqVKgsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8127



On 11/10/2024 10:04 PM, Borislav Petkov wrote:
> On Sun, Nov 10, 2024 at 08:52:03PM +0530, Neeraj Upadhyay wrote:
>> If I get your point, unless a corrective action is possible without
>> hard reboot of the guest, doing a snp_abort() on detecting mismatch works better
>> here. That way, the issue can be caught early, and it does not disrupt the running
>> applications on a limping guest (which happens for the case where we only emit
>> a warning). So, thinking more, snp_abort() looks more apt here.
> 
> Well, sometimes you have no influence on the HV (public cloud, for example).
> 

I see. Ok.

> So WARN_ONCE was on the right track but the error message should be more
> user-friendly:
> 
> 	WARN_ONCE(hv_apic_id != apic_id, 
> 		  "APIC IDs mismatch: %d (HV: %d). IPI handling will suffer!",
> 		  apic_id, hv_apic_id);
> 

Ok sure, I will update it.


- Neeraj

