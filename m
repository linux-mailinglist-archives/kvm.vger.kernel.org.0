Return-Path: <kvm+bounces-31237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F25609C1898
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78B3DB2399E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 08:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79081E0B6D;
	Fri,  8 Nov 2024 08:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ydm9lo9Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD3E47F69;
	Fri,  8 Nov 2024 08:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056362; cv=fail; b=pJaN22SyYcUD/RgYEsSkQSdASRj3DZUmNSMFnxhiqvIdRoXFHCnOv/857qmfYOLT4V4G0+Htz+rEB09eC9txBgeNM8ndBNhR4nViWYAvsNH74XcFf3uJUtEjeafn5l5WDK+YTCRFyOTPXA9sglrkTdx0rpefUrIaUnuH3Q6T8Ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056362; c=relaxed/simple;
	bh=s8Eqv2iZNAvrnElgZAJZpAmSbn4xqegrjfE3dj5Hq4M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Bm0BgvE1fOu1Dfqk4qictje0Wl51SFlFhtWu5h96ex8KUn/lHZYBEFJ5x8U9TLDGKukMQTejUltKOd9uFXNK4VpUMTCrjW1jQIhn+lBkdnDkmM7eGFwSNMf88KcgYFQDvp21mWcZoZ7MIqAd6eR2y3hJ9UqoWZVaRbp73FtDHMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ydm9lo9Y; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ty3H5PTZR+D9W7ilXulagavI3PSuiykE22kgXrgVn9L59SvnXUpL80UNlaDpl0Spwa/HUPv1EvWDZnxhpxhtVmKkrBh7OF64EK3ft3++iu/d7uL82JCtdfLObdHW0fsCtSVGRUmFSxPO+88+jPcSACB3HJHSTlWyujvWoqW9BgT03qaCwvcGaemXckmtx4LLDtIiWEATd6Rpidlx6kxB5ZcdRfZvNABJ5qVQTBctA30bSlO5I4v/K6OTGKCB3cGJuqdD/BV0+O2XXvZaHbTAk403N+P813rNTaKAyFVHDuVBzhBUGmIHvXYx+AThXvvyK7fVjqI60F3ujB/UlUBcJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UjSA/JUEhAGwnZPZTJKC/QYGyWn0Srye+1BWDb7md0=;
 b=ykkW0Hqw6oLe2avu9M5cfCDsMIJQWpNJz4dAfUCdAR894OP7t+GomMzbHwYcQAvf/OXWrZg48S4L2p0ntmvofkAJKbJlunJG08fr7W2YtpLeqhZTVmKfCkO0k2OxDxUEdYk5ipAkZzZv1j+GXDK5ZU4eH5hT6dpT6pQXrAeqbE+3FTE95hzI/qCrxSgtLUx4pU0EeAPNyJbfEdwO5hnVIm/w2tlVtdJ9T2+A5EGIcfV0usuWO3O6nELTTxJ7sWMwNImdmiE2rIJN/me3G97tOOIEQXry9rfpltN4bBoiFw5SrsKvOa2QwkhgxaCn6TXcbk8VV9FjcYS2uKl3xNcsqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UjSA/JUEhAGwnZPZTJKC/QYGyWn0Srye+1BWDb7md0=;
 b=ydm9lo9YRbIPHwg0IdraKDXZ+ppUOaAeltEHron1xxb98k5/zX8oXuyP9xVH3B545/btn9LZRXCGZnj3tgBRXY8HW0LMxBxeU5qlAOT4/0yiM+lShndI6vW+pfeDdXhcNEcogSLVM4La02si+K9dOWZyL37XSzjwyt9CN6tbcN4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM4PR12MB6253.namprd12.prod.outlook.com (2603:10b6:8:a6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.20; Fri, 8 Nov 2024 08:59:17 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8114.028; Fri, 8 Nov 2024
 08:59:17 +0000
Message-ID: <2f10fdf6-a0c7-4fa4-9180-56a3b35cc147@amd.com>
Date: Fri, 8 Nov 2024 14:29:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
 <20241106181655.GYZyuyl0zDTTmlMKzz@fat_crate.local>
 <72878fd9-6b04-4336-a409-8118c4306171@amd.com>
 <20241107142856.GBZyzOqHvusxcskYR1@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241107142856.GBZyzOqHvusxcskYR1@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0152.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::7) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM4PR12MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae4f3b6-3297-4123-0261-08dcffd3a048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEVTamdCUW5Gd2V1YUo0SnE5Q1Jxc3MwOG5RZDVzUjZ1bUd3VzFrMzVjK0N3?=
 =?utf-8?B?RWZTd2JWcE8zSE9Nd2xxRXBCeWpaS2ZvamZzNyt4aGxsbUFPT1ZDSzZkRjM5?=
 =?utf-8?B?bHMwZWgrT25WV1VlaGN6T0IzWDFDbk5xOTRxU2Q2UWpMUWlrdE54SE90Z0Rs?=
 =?utf-8?B?NkUxck8zQ1NFL0wxZ1hJcTBxNVMwVkd3b1J6aXdIRzN2ZEdZcUFxSEVQK2lx?=
 =?utf-8?B?NEk1K1VuVHBLM2F5MzlSek1MZHFoMEEzQUI2QTdXbUVRTkI4V2xyelVZSE8r?=
 =?utf-8?B?QXhKYVc3K1NsVFRPbktzbUtNUFE5dGd3bDltWCt3YzU4dytzbzV0RnVlTkt4?=
 =?utf-8?B?aTMvSk5BV1BKenpZQ0dYYlYzQXkvakZIakgydi81MVY0RGlKblNGdGxKVUVJ?=
 =?utf-8?B?T3dWcVAwNUpYNGZKajRYd1luYVFsc3BjbHh6ajNrdUFWaFVlcHhYRU84bXZR?=
 =?utf-8?B?bDFUenBKNWNEcTEvVkpZcG9jSmExZ0JFbnpuU28xZisveGV0Rm1yWGFFY2FV?=
 =?utf-8?B?YzZHMmJEYlZHSWc0bVRUekx5OFZ2cEVqQnkvOGxzNkVpKzRnWVJJSmZ2eHh1?=
 =?utf-8?B?RE9vRXA5UnRQZ3BCbjhHdWpRalYvM3FDMHVUWDZsR1hscXRpRXhXVFozcXRq?=
 =?utf-8?B?VTdXWlFJbUVYL0J6Rm5XdGZzUlFxMjI3Vm85aWwwNFdZMmNlNm9zUmd2NEdE?=
 =?utf-8?B?cFlzMTZiN29DTU5id1dESDc3cFNXNDdRYlFSYXBCWEdRdkoxeVFBUXBhWVRW?=
 =?utf-8?B?UjVyd3Z2Q0dnaktxc0twNW02TnVwMDRpRkdCZTBXbGFzSUsvV1R0Z3lPS3li?=
 =?utf-8?B?UjM0WU1xdGxEVG85MjFYdHAxcVd0RmQyOUJpeVNKTzdEQnpxNTNuQk1Tbjds?=
 =?utf-8?B?ZW9QeEVRUmJMY3ZJS3haQVgzNjNlSUsvYTF1WFpQNGdUOWVRQ25Wd1BkeWdp?=
 =?utf-8?B?L2JnNVU4NTRENUNSMCtwcDB5U0ZPVW5qa2psd1BTWFlOMEdsQVdyUWc1Ni9F?=
 =?utf-8?B?Sm45V1NsQzdsMTdOMFdVbzJaM3FhVVp6bGV5OFVKSzB1TUJhWXdoNjFvbHNH?=
 =?utf-8?B?bFEzS2V4WlMvSC9tclB5RkJnekhyOGVsOUFqUzVNL3ZSNHJyL2hoUElHRFdF?=
 =?utf-8?B?cmZqTGRpZ0F6cHNBWENNOUNCaTIwYUVnalVJWTc1dHJlUHplUUVpQmw5WHdO?=
 =?utf-8?B?Tm4vbngrVjNHSDIxQ3dNdTF6cVB6V3dvUk5tZUlINzhBSnNUNk9IZ1VENXB0?=
 =?utf-8?B?MGFOVEJLTHRjV2pnV3lwRzFmYnVMK2M3SWIxd294RUNNaktHZXZXR21yMG1z?=
 =?utf-8?B?aFN0Sk9lTzJWdVZZKzU1dWhGTVBGR2hWd3RpbWJNTlE1c3o1TTE2eGoxaDlQ?=
 =?utf-8?B?OUtrdVQ3b2J2SFJ2amhVZ2tCVGdOOHRVZG9IUmJUUVRINWQzQVpud01GMGli?=
 =?utf-8?B?ZE5VNG9ZOU40Q0JJbUhRRFArVmFFS2pNcnVJVUxsbXZZLzNkZ0VKcHJEdTYy?=
 =?utf-8?B?RGhMYjc1K1drdUV4MlJBakI4OXRoUEhMYW1mTUNhTUVieGNBbTJRbkVTb2pY?=
 =?utf-8?B?NFJtb0pwcm91dURYM0N3bnA5U00vVWM1UUh6bWNpY1pub2NRR0hQYk5TcjZ3?=
 =?utf-8?B?a0FOTW9QKzdJZ0FIa0tNcW00R2lMUUEvaE1EVXB6NjNvcXZIcGJaVURTQnYw?=
 =?utf-8?B?N0JucmVvL2wyWlpYNUtwR2phU0RtUC9aOXhpaTJHcExDRDNFUVZzQVd4MS9I?=
 =?utf-8?Q?887v4WQzxMmUkkVuwbrI5ui+xiW65Ih8h4KGb4H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGRqb0hTWmg3anFwSXJVNWwvTE40d1BOQzhmWE9MZk1CejBnaXFraFBwV1VM?=
 =?utf-8?B?Vll6RWFUMmdiV3JFMXlzTG10amZUMlV2RUptaEptT3JhZjZoQjBkUXZxanNM?=
 =?utf-8?B?Y0FUSzhaZGJscVN6ZmRYMTRST29FelRHWWlIb1B5L21wOVhZZ3dMQm5KUzc0?=
 =?utf-8?B?OXRBOEFnUzFtUGxpMzQvMkJYdVo2UVZ5b0c2TFJuUXVDNklKU3hRRnJXUFRP?=
 =?utf-8?B?M0hGV1Y2aHk4KzZQZFlwUllqdkdpdWkvWFpMcVBRdGFBRkVtcmsvNkMwbHZ5?=
 =?utf-8?B?VllBcFhHNEtJT1kvQlhvYXYrK0tJUEhPdnFPWW16aFRsZDRPMG9nSytZY096?=
 =?utf-8?B?UXVqWlFhcy9tb1lnbkVRSzd4ZlpNZHJIUGdvczMrY3hndGZOSVZrOWswZG9G?=
 =?utf-8?B?UW11czdYUWpwQkkwd09xRUR1MkhKK056ZDBscUR4dVlYeTZCS0pidDBPUFF0?=
 =?utf-8?B?UlduRmlVcHNSNU04R0ZvL3N0Q0JuNXA3Q2paZG5zUXpJUngxcDlwc1M2cEYz?=
 =?utf-8?B?cmRCWFBNSkNHY3dhRlk1Zll2VXZiQzk3ZXZZSis1SzJ1N2VEVjJGWVhMcG50?=
 =?utf-8?B?ZWZheGJRT1cxR2s2bVdqOExValg2bXBpa0swUGEyUXhqbDUwQkkxbXB0b1dr?=
 =?utf-8?B?MThacGtGS2RCZjdHUFhRMWtjbzYza3o4UUZERkRrd1hCdThZdEs4OEcwekdj?=
 =?utf-8?B?MFJlTGtpdCs0emlDN0RiT2YxVWtQdURCckx0N0pWK1RiVDFTR1NDd2dBTzZ0?=
 =?utf-8?B?bndyRzFRWXFlMy9aYy9YbFFPd040dm9DOWJHeDRtV3d6TW56TThRZXlMRHVD?=
 =?utf-8?B?L25JS0E0VlBFbzRTVUwzWStFK0Z2TzdVcmEraEV2SG1Ic1BzQU5UMXRrWFR2?=
 =?utf-8?B?YlUwb2tNSkQ5aStwd1JvNGtTaGFWL1JBaHY5VnorbU1EN2lvNlMzWTFBVWZk?=
 =?utf-8?B?OEpsUS8wMW5Td2xqYnNIaGQ4QlB0WEJOQ1N3Q1FFRFR0Q0ZRS1huRmFwb2gv?=
 =?utf-8?B?cGpDMG10OWl0OEhEank2TmxFUHpEMndtWk53bXZkNlpLWVBUaW80MTRJMkla?=
 =?utf-8?B?eG02bng0cHlndmp4WEQ0bDhSVWtpYzJobmRtbzJ0cmFzdXJGaWpXWkVxNGxw?=
 =?utf-8?B?WmpPcHRLb0hTS0hMV0RIMUpLc0t3K0g1U3VWcGx5Y0pXNGx1Z1pwZ2R5cTIr?=
 =?utf-8?B?NlY2Y2loS2NUcExWbXR2cTFFV0tYZU4rbkRKeFdsbUUzRitGMHVCc2tEUVZL?=
 =?utf-8?B?amlLaVlwZXhEUHpFTk81NGVmd0pKUldpa2dhWTIxQnArLzlrVmp2RGF3aGNT?=
 =?utf-8?B?aEYxVnRMRkVENGxkeWhEL2ZBaE53VzZjZE9aNWp1dUlsNnBxWU9oU093WWxT?=
 =?utf-8?B?N0RFLzdNdGdBZ0NFK2dPbUJZQVJ5VzNqRHN6T2pFRHJ2Q0RRUnpudldBajlT?=
 =?utf-8?B?UTZDdEZ0SWlEcHlMdTVUOFgvdlk4NXRic1liZUFzYlp2eDdnb1RINHVvZW5u?=
 =?utf-8?B?MUxYL1pXUlM2WEc0RU1Mdkh6MHFjL3NmNFE2VmVSMWxCTzhnS2ZaMWZxUEw1?=
 =?utf-8?B?SW02dUU2UE1zdm1FTHNnNklaaTVCcmtORHZEeGxMdVV3Qk9TNTdka1JSVUZZ?=
 =?utf-8?B?Z2kxTnpqRzFNSmhiWjJiSjBJOXozWEVlTkhBRUFZRlNnbnlTUWJ6cnA4eG1H?=
 =?utf-8?B?WkNqeHZsc0hhbzUrREVqVUlhaGtvd1AyRStHMjg3eGJLbXhOUzJmejJQOFda?=
 =?utf-8?B?TGZLL1Z5TEhmczVtcEV3ek1uRzVKWTMzUFJ6MUF3UjVJWC9saXoxdmFpMEM0?=
 =?utf-8?B?RkdKeUVtQ09hQmxmWkVpWjcwT1JsbDFVRnJWcTZGc3cvcm0wRVpqK0FlUW5D?=
 =?utf-8?B?UFpmNWN1Zy84NWxwMnB3UUg3RFRBUE1DR3IvVnoxUHVUZ1o3NEpTSnpEcFNx?=
 =?utf-8?B?c3IxMEFDU2RpRytndjdCMkpnc1EvNERwMjZhVlJ5UERhSE52ekNvV1NreEFS?=
 =?utf-8?B?VE00eDZFaUIvM2NHdlRPS2VYdkovMERPZUs3YVQxOVJ5amhRQ0VLZXFpMElZ?=
 =?utf-8?B?WVJBVDdDTVJ3enJqOG1mSmhHTWtMNEdhWEh6VUtNcEZ4SXA0S0JoakNzODV4?=
 =?utf-8?Q?S7vRJWRWHViCzdAB/c/Yqm5OB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae4f3b6-3297-4123-0261-08dcffd3a048
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 08:59:17.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tue2ZDhFebTIfA3+Ixha3MG5vB0nwW/53Kzp4s51uVjR48xGJim73MGFRye7qTKSDzthyHzyObXZBH0LxSXs3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6253



On 11/7/2024 7:58 PM, Borislav Petkov wrote:
> On Thu, Nov 07, 2024 at 09:02:16AM +0530, Neeraj Upadhyay wrote:
>> Intention of doing per reg is to be explicit about which registers
>> are accessed from backing page, which from hv and which are not allowed
>> access. As access (and their perms) are per-reg and not range-based, this
>> made sense to me. Also, if ranges are used, I think 16-byte aligned
>> checks are needed for the range. If using ranges looks more logical grouping
>> here, I can update it as per the above range groupings.
> 
> Is this list of registers going to remain or are we going to keep adding to
> it so that the ranges become contiguous?
> 

From the APIC architecture details in APM and SDM, I see these gaps are reserved
ranges which are present for xapic also. x2apic keeps the register layout consistent.
So, these gaps looks to have have remained reserved for long. I don't have information
on the uarch reasons (if any) for the reserved space layout.


> And yes, there is some merit to explicitly naming them but you can also put
> that in a comment once above those functions too.
> 

I understand your point but, for this specific case, to me, each register as a separate
"switch case" looks clearer and self-describing than keeping a range of different
registers and putting comment about which registers it covers.

In addition, while each APIC register is at 16-byte alignment, they are accessed
using dword size reads/writes. So, as mentioned in previous reply, using ranges
requires alignment checks.

One hypothetical example where using range checks could become klugy is when
the unused 12 bytes of 16 byte  of a register is repurposed for implementation-
specific features and the read/write permissions are different for the architecture
register and the implementation-defined one. Secure AVIC uses (IRRn + 4) address
for ALLOWED_IRRn. However, the r/w permissions are same for IRRn and ALLOWED_IRRn.
So, using ranges for IRR register space works fine. However, it may not work
if similar register-space-repurposing happens for other features in future. I
understand this could be considered as speculative and hand-wavy reasoning. So,
I would ask, does above reasoning convince you with the current switch-case layout
or you want it to be range-based?


- Neeraj

