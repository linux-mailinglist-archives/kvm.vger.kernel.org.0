Return-Path: <kvm+bounces-35613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 597AAA1323D
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 06:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74BEF3A5F93
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 05:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153341547F2;
	Thu, 16 Jan 2025 05:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z9zQD55x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2049.outbound.protection.outlook.com [40.107.100.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B5F142E7C;
	Thu, 16 Jan 2025 05:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737004477; cv=fail; b=p8QXhR1vLbtZjUgt3cRLxbIRETrGrFh+5D5vYCRX8PQ1qKAak7YSOydLYO5YyFL+suXgevXC7bqhwaCUdTPJgybnQH5fhqqXBBV16q18afgVRuWQdD5DhR6C7I2DMpWon8AQNgt356S5nn41rJryL7ObScWzcN/UlgDCfhwHEnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737004477; c=relaxed/simple;
	bh=Q2m2+4tdu6RXGEvWS4IZrAnsavQ+n0XBgscq62cJTu4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oNk64cQYL7iue80oc3AoKjiS310XFtIkJw3P9qi54keAROcOeZh59/N9qXUAgeoWKkp9j6AYHg7u+81GClOCgmnR99p5QP7CZfqLuTuX6/UIxNGcwe09ogh0YFhSVdPIee7u0fCWDU9zYgkjGL2CMKBngx9t0ZMZqmXdlX0QjqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z9zQD55x; arc=fail smtp.client-ip=40.107.100.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LjZ98UknIUQ002KLRPkYcojXGrguXdurcE3xn0zAxpkL7gc192PLa9pwfsYvQ7/CIMqPZ14/buTQkMcTNzNhpYIOhyUVX5mRlRpqA+iQPEBho9/O2yijsYLBdq/YIADysL/XHFG+3U9PlxsI+92JP2oEj6N2to0dV7dm2xy/YlkqXAHolOqTlZwcAhPoHxkyUsQ7zgto1i4c95FpzsuevgRZMX/8/7KyOxM2FNuDcZHAheK0Q1l9cVQOadmNrhacZBdNybcyJbMJBHgAJD2gX8cSLAy0ntcaafpjoqkaNzdTbvsb/H6cwdZnlg9TXY66ts8KT20sTmB0dpeY/Ggpdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvnnRfgmJRCl8LKiuPTml/D1QiaX/r5oMNb2TY0TZlc=;
 b=XeHuIKjCwgJQurDBopY3nH4oaR6d7ESIMMujmfDy69k20dKQ06SjwG8oFLoxi0P0VxDNzON0dAXHDuDHoTX2JOk3NCx2i3y/xV46jRcrm66DlYIv0JZ84ufZx+0VXTplwYuDEkY1ts1H4I7cq0q/dl8R8CHmRO+4npaneSnDeYvv8u7/eBKiNU0L23l5FjjxhL9vSfOqMBk3J0IlRfPzmHpESARR93/iDGlSiurbQc1xS+vFTR/hWM4G1RZb53qeRTz7kTQEgvaJb3xN0E0ysA2NI9Pta4Ue5Z3hVKLHO/nSLOBK4gDt3bnL2wPGTlgl1hZKl7yNkUAoU5tdV5l73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvnnRfgmJRCl8LKiuPTml/D1QiaX/r5oMNb2TY0TZlc=;
 b=z9zQD55xNQ1yYEtQ82ZXRHEK7aPhGlUl7rsjJXvPVByf7BfS82gBOTg9L2Hm3Zq0nS6AB7/0X7Iv6hsEbOudwXURGjun1cDFoJ73Jd8mrOzRR/i/ltajiWJmcEHpT1NuDpbIyl6iO2/ryB6UWwSFQ2LqKeITDCCCohoYHU7U0l4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Thu, 16 Jan
 2025 05:14:32 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 05:14:31 +0000
Message-ID: <ee027335-f1b9-4637-bc79-27a610c1ab08@amd.com>
Date: Thu, 16 Jan 2025 10:44:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] KVM: selftests: Add infrastructure for getting
 vCPU binary stats
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250111005049.1247555-1-seanjc@google.com>
 <20250111005049.1247555-9-seanjc@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20250111005049.1247555-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::29) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|SJ1PR12MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f3beb2-644f-4e8e-10a7-08dd35eca86c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVh3bDBQTEN5aUt6RE1QRWtEdUtvMTIrcDBoQU96T3VjUGM3LzcvcE5jVERu?=
 =?utf-8?B?VlpOZWZ2UFBmR3FWVG1EVjV0QjdDWTFwU1hvNDI0bFhMOE5QNE53ay9JclJR?=
 =?utf-8?B?VVZET2VYWlY5NWQzV3doazFkeEFjUEhHWHFQODlTekMrZ3RHd2g4U01RTHI4?=
 =?utf-8?B?dTl2SlU3RmxaQWovQ0pBWlVMSDN3RmZveGI2Qi9EU1VIUjZCU2J1Z2pXc3Ft?=
 =?utf-8?B?TEFITHRLQXZvMGduTFNUMDcybFdJRXd6TWErT3lxcWgxQjBWd3VSblQ4RVJS?=
 =?utf-8?B?N3d5ZDkxbVZ6Y29TTTFYWklSWEtZeXdHYkJWUjFDNEtWajIrL2dkS28zYXhp?=
 =?utf-8?B?S3hyUnc1MUltN2licVg2OUozRjJjb1o5NlVSTUJla2RqOFFCdHhsUEUwRU5o?=
 =?utf-8?B?U2RUNnEvVjJuRStXUmdrMUNZQVNUMGFOZFRWZWQwLzNxdTRFYWdEakRGT3Ba?=
 =?utf-8?B?VVBHNE1mYVpPVDlYM0k4dFlQejVEZEtKNG5vM21FUGtxZW9xb3k3a2Zmc2w2?=
 =?utf-8?B?OG1MTzVVSEMyaFY5SmY1ZXNCdUJwUEV4bG1LYkdZQ25Xc2hMWlVTNUZESFkx?=
 =?utf-8?B?TkVXVktZUkRBZk04dXlUYmVJUVppVWpLRU1KOE1jTlVRQk96c1NtMlZBS0Rn?=
 =?utf-8?B?OFNYcGFpMGxkMXdBdnBlcUFPZ2crTGs1NU1qMVRoZzZaWVpUWGtwSmRPbUVH?=
 =?utf-8?B?ZEhSU0FNRi9HZWdIUFcvK0E1U3RKclFLc2NUY0M1aUdoWVZDR2ZlVWRkYXM2?=
 =?utf-8?B?d2lJNzliREpJbHlFcHlOeEhqNWgvVTJvV1doTmJZOVpEY1Rpd1QrNm9IWnJT?=
 =?utf-8?B?UlZNZGxVOEFBTHlhTUFQNW9XZkk0S0hNaTVla1FwYUhLZEFFZ2Z6NUMyYWJJ?=
 =?utf-8?B?M3FvZXlpWjhjRWVLanZpN2o1M2crS0d3NCt2REYxckE1UWxya2YvSExTOTFv?=
 =?utf-8?B?cUxPcUl3YmdNNWFEK0Izek9oZGt3akRaSDdOTWdkUVF6N1poUDFMbU9pOTQy?=
 =?utf-8?B?MzVBUS9VcWUvRFhtTkh0b1hHZGxFUnJDbHgvN0dSUVcwNDNCTHdyR3Mwenpi?=
 =?utf-8?B?L0FaTFFtcHpwZzBFTTlHYVJoUHFKeVU5anZqZUd0U1ZpVFdNTVN5Z015YXlL?=
 =?utf-8?B?QjFFeWRMdVFBNmFJM1B4K0d1eWVLUEQreTZONEJaTjhnUHBKYlMxL2hDWDU1?=
 =?utf-8?B?QUsrNTQvVUtLdGhnWVVBQXlIY1B4dXEzVzRjV1gzZ2VhVy9YSk8wcVl3b00r?=
 =?utf-8?B?bFVNdnF1YXpDbkpzcnlrK1o1NzZDMnZmeldNYmxMN0VNQjNmVmFkVGZGamFF?=
 =?utf-8?B?OVlsR21xQnZacWU5WmFWelE5YmtXVmorK2E0Mi9nTXQzVUxieDZ0NFhqak9q?=
 =?utf-8?B?N1RoVEJOcmRKcEo3U1JEUzBtTzNSQ1lGSVp6WjJ5OWxjTWhsQXNEOUN2Q3lK?=
 =?utf-8?B?NmVwZit6dTNkcVdHWGlNa2ZJc1RuL0VDVHB0WmtoZ3V5ZXBxY2VaRExGS1R2?=
 =?utf-8?B?YlFvQkFNWGhyZW9MZDZ3UmhONFNoemxZWnp6Q2JHSjlQTFNIaG9zK28xTlE0?=
 =?utf-8?B?dWNUaGcwL1lQNU5sT2NiUTJKRzdBY3hiZjRTdXlyN1hqM2pqRUZEZkZjTE5z?=
 =?utf-8?B?ZWQwS05jcW1qci9HRUdOTklMT3hPMlF6YkNtK3NvWG0vQzNEQkV1RXM3N091?=
 =?utf-8?B?Y0JZQ3NuZFI1YW40NldabTZoNkxMYkdXcExES2pNR1FQamN3UEVoTTU5M1Q1?=
 =?utf-8?B?bXpocUxncmJIeFFaWUNKNm51cWlya2lqNDRlalBHeFpnc2pFY2ErNng2SkFz?=
 =?utf-8?B?SkpXa1k1STNKRnVUZWR6dkw4eGtaVXNFTDlQRG5nM3dwVTdOdDN6MGE0ditJ?=
 =?utf-8?B?bXI3TCs0RTZMMEFSRW8yaEs3UGlHWFQ0YXgrd010VmxxUGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmREZ0FzTWJod2lpU2JiWWFWK3N3aGF2L2t1Q1U3aVJUSVpqaXhIRHFQS2tB?=
 =?utf-8?B?a09XME4zRXpIMm1qM0xMeHM1MG5keFVRMncwV2JZcnVHZlo5elZUaFltNHJX?=
 =?utf-8?B?TTRxMGJzL2x6VXhZRzg0Nlh3eXhqc0Zhemo1SUdoZVBVTzlvaFhEYUF1NlZU?=
 =?utf-8?B?dE42aTVxS3YvYnhBVmNVdzN3MSt4d1IrR0xIMXVjcUNMR2ZoNGtQU1JuOUkv?=
 =?utf-8?B?OE1uQXRuV1h6VkVwSTlSaWMySVFGM2xvYTdwRjBKTldubHIyYWs1WDdER1dX?=
 =?utf-8?B?NzNLYks3ck1panZCUXNxUDhkOTBBUVRZUDRlenZ6K3Q2V1hyaEh4dUZWdjRk?=
 =?utf-8?B?SDVndzlxcm0wemRzQ3JWY1VBWHgxR0xVYTZRdE1zK0ljaXV6MWNOU2dWZnd1?=
 =?utf-8?B?YmplZFZiYzBiSWVyR3BEN3dTSnBRZnJTUlg3WmsvNERzd1I5ZTVUOHdvNFJk?=
 =?utf-8?B?MjJFbk5OMDBiK1pZVUpySWg5cnF5dGdOdDFYdlBRTnBpWDZacjVscks5bGx0?=
 =?utf-8?B?ZUlHcS95eDdjaDlOQk41YXVPTVV5VEdYbGZVS2FFcS9mWURRcWpRV21pbVVw?=
 =?utf-8?B?eGRlaHgrOFlnWkJrQ2xWSDhFK2ZlOThocjJuQThrdEhXSTR2UG90eG5QWk41?=
 =?utf-8?B?aXZDK3FhU1pMV2tjVUhnbys0K285b0h3TGF0RFJleDBidS81TThjU3VTalFG?=
 =?utf-8?B?ZVhkSnpOb0hyNkMxb1ZlaER2L2V0WFNSK3p3NzV2bXdmL3RkTWxJYlVYVGhL?=
 =?utf-8?B?ZkpIUkVmNEF0amZ6aVNRazdRMWJTV3JMK3hDT1BVQjZXME1zZ2RINk9VVWxa?=
 =?utf-8?B?VmZnbXpMeTFFT0lqa2F5eEEzQnZmLzVBdTMvKy95NEk2dlhlYzNtcWFqTFJ5?=
 =?utf-8?B?alU3REUwVFJYbmdSYU5wVUxQWXQvbTdyOFl2c2l1R0JsRVJoNGsxeEZzbDBw?=
 =?utf-8?B?aFRiK0ZJQnM1YXU3Y3lSNzIrM1JWVXhDa0pOUEdmeFIwZ25BVTBudkVUKzFR?=
 =?utf-8?B?Y0NYM1kralJXZTQ4SWg4d2ROQXBRMWtYQ2hZRkxPSjVuOFRwMDBEdGJoM2Iv?=
 =?utf-8?B?ZDN0UHhGcFFNRGJ4cU9zQnowMUVCaG5Pc2FSQjZFZXlGTU5zZ0k2VkE1bGU3?=
 =?utf-8?B?b0tmQ1p6bWpBQzVEcXA2TzU0YUpYRzkxU3ZDdi9SVHF2YzdZRWtuTjYyNWx4?=
 =?utf-8?B?cEZvV0dOODdyRWtzUFk3MmpKTCtoYXdIZmplMUlnTmhpb21sbWliY3JLNXNQ?=
 =?utf-8?B?dEF2UnFMMjNYbllwVkVQNHRkbUg1MlU5RUZ1dGhMWlNPbnBWdzhmemVWeWJY?=
 =?utf-8?B?TlU3c2thZ3NlTmtuQjB5UGNIdjdMcWN4S0E5OWRsVHpJSFYwdTJGazBVTHJr?=
 =?utf-8?B?ZW9hQ2o2cDNUSHJHOTVvbE5JblFOYytnOE5GYTBuU0RwVElOYy9iUTFGWkZw?=
 =?utf-8?B?azlOY2xXcE1VVDBNUTdzdm9jQ2xBTEZhd3BtMXM1L3U3M1J3clpHU2dBRXNO?=
 =?utf-8?B?YkF4ZHpuL1RWNDBKbWFqM1RsSVgxQmh3S2I0TytPdEMyY25LTldrZjU4Myth?=
 =?utf-8?B?c2R4NTIyUHNkeDRpajNTUW8wb0NzeThwSUE4WHlxK1RpaTBHcDd4emlKcTBT?=
 =?utf-8?B?WStZaWgwRVAwakh6V3dGQTQ0azI3VGZUSysvcnJZL0ZHTEwzdE1XSS9ENmw4?=
 =?utf-8?B?K0JoemltbU13cm1OVUFTYkFNYkxETHN6K0xsYW5HQWs5TCtqTklrekJscHlk?=
 =?utf-8?B?aWpuYUdXdG9XWFBuUFdQTHZvdEhVZm5JYXRHdHYycmRoVDd5K0FXMFh1WDcr?=
 =?utf-8?B?NG1uL0FaTHhVT0xvK2pOcnh6aHBnZ2xmdkQ2MFhxVzdBMDczUHNjVjh3RkM0?=
 =?utf-8?B?aEp2bld2TXZHTTdMSnlkRnI5bmp6TkpRRlo0TFFnM1RWQzRGMEJDVWZUcjRC?=
 =?utf-8?B?N1BBa1M4VUlMVFBTSFJVb1Jwbk0zd0NrZ3d6OU5RbkJOL3JlMG1nTU1ERjVy?=
 =?utf-8?B?MlBTY1picHFjRlIyVFlSRlFJWjc5V1RVOFV6dFQ5TFJhYm5LUmhWdkJKbld5?=
 =?utf-8?B?WExoMGt1c0c5NTVONGxXRzk2dzZRRG9tTGFoZ2NQeXA0K1cyTUwyaXJkREgv?=
 =?utf-8?Q?YeL/7OiBR22Di/p56HikXiWgm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f3beb2-644f-4e8e-10a7-08dd35eca86c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 05:14:31.4306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jYYtBrxMiecqF33iEj8FV7krlQ5+vjcQqIWV+qIyv7yLq4n8rmmTnJk1SYKFoIr8JD2MySJloyGpuAg8xYfqzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316

On 1/11/2025 6:20 AM, Sean Christopherson wrote:
> Now that the binary stats cache infrastructure is largely scope agnostic,
> add support for vCPU-scoped stats.  Like VM stats, open and cache the
> stats FD when the vCPU is created so that it's guaranteed to be valid when
> vcpu_get_stats() is invoked.
> 
> Account for the extra per-vCPU file descriptor in kvm_set_files_rlimit(),
> so that tests that create large VMs don't run afoul of resource limits.
> 
> To sanity check that the infrastructure actually works, and to get a bit
> of bonus coverage, add an assert in x86's xapic_ipi_test to verify that
> the number of HLTs executed by the test matches the number of HLT exits
> observed by KVM.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 20 +++++++-----
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 32 ++++++++-----------
>  .../selftests/kvm/x86/xapic_ipi_test.c        |  2 ++
>  3 files changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index d4670b5962ab..373912464fb4 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -61,6 +61,7 @@ struct kvm_vcpu {
>  #ifdef __x86_64__
>  	struct kvm_cpuid2 *cpuid;
>  #endif
> +	struct kvm_binary_stats stats;
>  	struct kvm_dirty_gfn *dirty_gfns;
>  	uint32_t fetch_index;
>  	uint32_t dirty_gfns_count;
> @@ -534,17 +535,20 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
>  		    struct kvm_stats_desc *desc, uint64_t *data,
>  		    size_t max_elements);
>  
> -void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
> -		   size_t max_elements);
> +void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
> +		  uint64_t *data, size_t max_elements);
>  
> -#define vm_get_stat(vm, stat)				\
> -({							\
> -	uint64_t data;					\
> -							\
> -	__vm_get_stat(vm, #stat, &data, 1);		\
> -	data;						\
> +#define __get_stat(stats, stat)							\
> +({										\
> +	uint64_t data;								\
> +										\
> +	kvm_get_stat(stats, #stat, &data, 1);					\
> +	data;									\
>  })
>  
> +#define vm_get_stat(vm, stat) __get_stat(&(vm)->stats, stat)
> +#define vcpu_get_stat(vcpu, stat) __get_stat(&(vcpu)->stats, stat)
> +
>  void vm_create_irqchip(struct kvm_vm *vm);
>  
>  static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f49bb504fa72..b1c3c7260902 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -415,10 +415,11 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
>  void kvm_set_files_rlimit(uint32_t nr_vcpus)
>  {
>  	/*
> -	 * Number of file descriptors required, nr_vpucs vCPU fds + an arbitrary
> -	 * number for everything else.
> +	 * Each vCPU will open two file descriptors: the vCPU itself and the
> +	 * vCPU's binary stats file descriptor.  Add an arbitrary amount of
> +	 * buffer for all other files a test may open.
>  	 */
> -	int nr_fds_wanted = nr_vcpus + 100;
> +	int nr_fds_wanted = nr_vcpus * 2 + 100;
>  	struct rlimit rl;
>  
>  	/*
> @@ -746,6 +747,8 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	ret = close(vcpu->fd);
>  	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
>  
> +	kvm_stats_release(&vcpu->stats);
> +
>  	list_del(&vcpu->list);
>  
>  	vcpu_arch_free(vcpu);
> @@ -1339,6 +1342,11 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
>  	TEST_ASSERT(vcpu->run != MAP_FAILED,
>  		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
>  
> +	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
> +		vcpu->stats.fd = vcpu_get_stats_fd(vcpu);
> +	else
> +		vcpu->stats.fd = -1;
> +
>  	/* Add to linked-list of VCPUs. */
>  	list_add(&vcpu->list, &vm->vcpus);
>  
> @@ -2251,23 +2259,9 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
>  		    desc->name, size, ret);
>  }
>  
> -/*
> - * Read the data of the named stat
> - *
> - * Input Args:
> - *   vm - the VM for which the stat should be read
> - *   stat_name - the name of the stat to read
> - *   max_elements - the maximum number of 8-byte values to read into data
> - *
> - * Output Args:
> - *   data - the buffer into which stat data should be read
> - *
> - * Read the data values of a specified stat from the binary stats interface.
> - */
> -void __vm_get_stat(struct kvm_vm *vm, const char *name, uint64_t *data,
> -		   size_t max_elements)
> +void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
> +		  uint64_t *data, size_t max_elements)
>  {
> -	struct kvm_binary_stats *stats = &vm->stats;
>  	struct kvm_stats_desc *desc;
>  	size_t size_desc;
>  	int i;
> diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> index a76078a08ff8..574a944763b7 100644
> --- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> +++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> @@ -465,6 +465,8 @@ int main(int argc, char *argv[])
>  	cancel_join_vcpu_thread(threads[0], params[0].vcpu);
>  	cancel_join_vcpu_thread(threads[1], params[1].vcpu);
>  
> +	TEST_ASSERT_EQ(data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
> +
>  	fprintf(stderr,
>  		"Test successful after running for %d seconds.\n"
>  		"Sending vCPU sent %lu IPIs to halting vCPU\n"

I have tested this infrastructure with xapic_ipi_test and ipi hlt test [1] on AMD system.

Tested-by: Manali Shukla <Manali.Shukla@amd.com>

[1]: https://lore.kernel.org/kvm/20250103081828.7060-1-manali.shukla@amd.com/T/#mda361fc0892e6949d98de2a4a79f68fc362a2893


-Manali

